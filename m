Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170216D5F49
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbjDDLlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbjDDLlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:41:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6575510E3;
        Tue,  4 Apr 2023 04:41:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334BFN4I018350;
        Tue, 4 Apr 2023 11:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=uqiR0U/yr/oX4GvCRQmtQBRwtjWeFof0RyFAxO8YSeI=;
 b=JmITWyoSUGYQj/oVgt5eG5g6qrhH57nbpOZPPW2HszpcF9nF93sh9PxLyxfSe2cVh7vw
 ly/F+GeN5Z1BqWUynS2Br7yrK+8vRdid9V0JvGjr4e6u1TWV3qPsfDQL0z1y1N22Br9M
 NIGzxRwvD0mq3WqfZPUB8Px3SKUPWaK0KIfOl8oHXnnu17irkjC14wYfdNdiAj18aPK0
 URLJwUYqCN05koGyTKDOVnPt/rQy8vLnptJPYuNxHPneHGOuJ/ue+eCbCqs22TN/a3RA
 ZkuYelWmdvF1L4nSm/hOEPlCqpzOLl6eXFie9v1XnEPHq/KDkxkTkRmb83QzzbapPzLV 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc9mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BFrPM021848;
        Tue, 4 Apr 2023 11:40:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc9ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341n3tr024634;
        Tue, 4 Apr 2023 11:40:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2fud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BeqKM56164626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:40:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1D632004D;
        Tue,  4 Apr 2023 11:40:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFFEB2004B;
        Tue,  4 Apr 2023 11:40:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.55.238])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:40:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404101434.172721-1-thuth@redhat.com>
References: <20230404101434.172721-1-thuth@redhat.com>
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x/snippets: Fix compilation with Clang 15
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168060845248.37806.16611304473486227950@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 13:40:52 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -DWRFESA4_oOO0gFwWEpBIksFcKaBGUx
X-Proofpoint-ORIG-GUID: nIKbs-Eb3xFsOiawSkLSEm7bnog5h7v1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=703
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-04-04 12:14:34)
> Clang complains:
>=20
>  s390x/snippets/c/cstart.S:22:13: error: invalid operand for instruction
>   lghi %r15, stackptr
>              ^
> Let's load the address with "larl" instead, like we already do
> it in s390x/cstart64.S. For this we should also switch to 64-bit
> mode first, then we also don't have to clear r15 right in front
> of this anymore.
>=20
> Changing the code here triggered another problem: initial_cr0
> must be aligned on a double-word boundary, otherwise the lctlg
> instruction will fail with an specification exception. This was
> just working by accident so far - add an ".align 8" now to avoid
> the problem.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
