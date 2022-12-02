Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFCC6404FC
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiLBKpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiLBKo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:44:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD882316F
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:44:57 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2A1fvu027487
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 10:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=aJ8dFizGkxzynD/7317aNn0LtoVTHirsm9hkzP/26wk=;
 b=WhxlS3fgArD20stkfkPq4h/7DYoLFSfG8eGiD0QsQXCBDq2T2JFgSpSZlWIQfbXxUgiF
 bN1/HgibUWR/CuZwl2TkVpYwOwkP23pRNY//RQlyDiBqtfjS6iamV5FFuadCQyqNWF01
 9OvmdGgjjl9zoN2aa8vUApp6WGDhXuIrFBwyVGKuZ6jBXgYkoZ9UjaPaxZGvx+NkF86u
 iRJtM+n765E/a+WFbh9W0JrUaFb+MpND0ZNUrW9G3IvsNns4DJG+ZSNUNvARl7erGmz6
 LZwJk3+GqtXKrZ1Vz6XBpLwMwv+wCYYIBWFJ4hs8JAwN1p4jLccVFqy16/kt0Rg7dK7d Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7f8gs0e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:44:56 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2AVEWb018643
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 10:44:56 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7f8gs0dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 10:44:56 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2AaDvH019205;
        Fri, 2 Dec 2022 10:44:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3m3ae8xhrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 10:44:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2AjZpY9962178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 10:45:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9446DA404D;
        Fri,  2 Dec 2022 10:44:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77206A4040;
        Fri,  2 Dec 2022 10:44:51 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.23.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 10:44:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com> <20221201084642.3747014-2-nrb@linux.ibm.com> <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com> <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
Cc:     imbrenda@linux.ibm.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related functions
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Message-ID: <166997789077.186408.11144216448246779334@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Fri, 02 Dec 2022 11:44:51 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aIXmd3UzZfFG6BzjX_GCvGkDq-Ehkfoq
X-Proofpoint-GUID: d4TEUJtsqLaLeo1-298ooZyTmNP9p4fD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-12-02 10:09:03)
> On 02/12/2022 10.03, Janosch Frank wrote:
> > On 12/1/22 09:46, Nico Boehr wrote:
> >> Upcoming changes will add a test which is very similar to the existing
> >> skey migration test. To reduce code duplication, move the common
> >> functions to a library which can be re-used by both tests.
> >>
> >=20
> > NACK
> >=20
> > We're not putting test specific code into the library.
>=20
> Do we need a new file (in the third patch) for the new test at all, or co=
uld=20
> the new test simply be added to s390x/migration-skey.c instead?

Mh, not quite. One test wants to change storage keys *before* migrating, th=
e other *while* migrating. Since we can only migrate once, it is not obviou=
s to me how we could do that in one run.

Speaking of one run, what we could do is add a command line argument which =
decides which test to run and then call the same test with different argume=
nts in unittests.cfg.

Other options I can think of (I don't like any of them):
- copy the code (probably the worst solution)
- header file in s390x which is included by both tests (better, but still b=
ad, means double compilation of the test functions)
