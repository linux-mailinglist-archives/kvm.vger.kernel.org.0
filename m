Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CA36C4EA3
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCVO4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 10:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCVOzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 10:55:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB94910F0;
        Wed, 22 Mar 2023 07:55:27 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MEs5ck003579;
        Wed, 22 Mar 2023 14:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=5fDLLt8J1e7OHIx2ghp13uXRKz4Fe8cG9y/Q0tF7TLc=;
 b=Dvi+JiY9J7pYkLCSQJIjHIf7UcOTV/pSkbDvxO+eiArX8dZUkRlzC90jd8evFFjOuANm
 Q/SQ5Yna5sRe0fIkIlH4CtU1RKeq2N0MJ3q0iODQYekZAbcujECvWg/Vz5XH76u1zyKK
 v1aSJH/5BktA/nlxk5U1RWI42fkJQCCWeFz+veGXni6j+Bl7K6aR7WHPCvR8vSWLEi9a
 tZ59ReudySLUXsluHNKRA4DsLBJ+6nmvrFUZ2D4QXdggY4kJ+YHSzRsjjU6awNfPDG2G
 bUOeMTHoGiW55cZ4rnI7SJW44dViXAAqGRjJkKqVeoVBTfy8CuFCIzkRZyB+0wvmAjBb Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg3uj81c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 14:55:26 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MEsE76003918;
        Wed, 22 Mar 2023 14:55:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg3uj81b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 14:55:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32M16TLw006837;
        Wed, 22 Mar 2023 14:55:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pd4x652t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 14:55:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MEtKVJ25690512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 14:55:20 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 920F62004B;
        Wed, 22 Mar 2023 14:55:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7781620043;
        Wed, 22 Mar 2023 14:55:20 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.93])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 14:55:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230301132638.3336040-1-nsg@linux.ibm.com>
References: <20230301132638.3336040-1-nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for misaligned load
Message-ID: <167949692024.87786.13003392018448803647@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 22 Mar 2023 15:55:20 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xo0wWEwgsdGlNE67Dz5HFCeub3mIoArH
X-Proofpoint-ORIG-GUID: My_7x0e-gthnm9KwlWKnHZ1zCxWPiMXJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_11,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220106
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-03-01 14:26:38)
> The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
> specification exception occurs. Test that this exception occurs.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
