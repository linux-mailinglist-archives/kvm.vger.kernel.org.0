Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8803A6D5C8C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjDDKAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbjDDKAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:00:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2634519AE;
        Tue,  4 Apr 2023 03:00:48 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3347uQAU030435;
        Tue, 4 Apr 2023 10:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=bRDfHeH6biUiqRSqB/8INxa1VLMfQf2+0ZpxzSEpOIg=;
 b=QiRKrMDncF417+KD4Hydt82zj2prhPndbWGYXF7623rf9S7XRDIVjCBea9hKWaTYmJED
 6Pw75fYfq+QcRQwPYYQXJpQ4kkqfYaOwHHbJiTv1vE433nQ4u4bIdBD+O9C0GCnfYQam
 oW7Cf4A1Sjr4GapeZwn8Joup6+QwtZRFTf/JnyNYc4ok11f4yd/hSNJPkxvipvdMFOwR
 m7acPasOPQie1hi+DWieeBzpvrg4WZ1AtgjZmu7Iy6QYDa6i4BrLmibKQlVmndL8RmoN
 Frkb4lYPqfQTuv3T+kDNxbBwSwYWTjrOKbw0+IX88XGqRRqeXZ8WbZTYwE1Sc+IBB7JH HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prfbyv40e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:00:47 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3348tGPq032242;
        Tue, 4 Apr 2023 10:00:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prfbyv3xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:00:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341wqNB005306;
        Tue, 4 Apr 2023 10:00:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872dpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:00:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334A0fEg23724616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 10:00:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27D8620043;
        Tue,  4 Apr 2023 10:00:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0969920040;
        Tue,  4 Apr 2023 10:00:41 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.55.238])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 10:00:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404085454.2709061-4-nsg@linux.ibm.com>
References: <20230404085454.2709061-1-nsg@linux.ibm.com> <20230404085454.2709061-4-nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 3/3] s390x/spec_ex: Add test of EXECUTE with odd target address
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Message-ID: <168060244077.9920.5308723452632105701@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 12:00:40 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4xXXOslLHKv8Rqa4iCtYuAEbjMRokPKF
X-Proofpoint-ORIG-GUID: WzgJepjyHYeUuzcJ41wmv_5H16dSe_dU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=899 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040088
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-04 10:54:53)
> The EXECUTE instruction executes the instruction at the given target
> address. This address must be halfword aligned, otherwise a
> specification exception occurs.
> Add a test for this.
>=20
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
