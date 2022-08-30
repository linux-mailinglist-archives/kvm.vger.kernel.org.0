Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1235A6662
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiH3OfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiH3OfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 10:35:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAB22A40F;
        Tue, 30 Aug 2022 07:35:03 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UEO2kf021078;
        Tue, 30 Aug 2022 14:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=IxnAgDcalSTnCkZrv2Ik/WyALlvnHZVHoC6v1OGF8zg=;
 b=SDV18ZLF+z+RizNKpsP+4AVZ8UjEAgzI/NtvdN8VL3UtKRNeZH73U8nnSge06w9C1PMt
 CjDtymg3uGLCDmHOYZn2LWkq9sunnjK+FjUms7PHY2dbnnCKPc+OKw1PbPbMhFIucTU3
 XrgsCPYe2NgGwz4p5uO+jRUUULd/mywyhnu8IXvJ9+Y/0pewlXARZToMAQrXIQzaE4uO
 rqoPDRoOdnqaliXkJZ5lsKtJIzjveZ880WY7puF7Oqfs4rjG/6b0rW/4NeFdSRWkgxOx
 Vkkfwk9mUrRAcYpS7gB0xwTLD/mb51XgXP7W73ujPHwjrk/TYUuDW59zDPL88u1IkNZh Pw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9m9dgd24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 14:35:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UELifc008119;
        Tue, 30 Aug 2022 14:34:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw93uqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 14:34:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UEYoOs37421494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 14:34:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E79CA405B;
        Tue, 30 Aug 2022 14:34:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83E62A4054;
        Tue, 30 Aug 2022 14:34:50 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.66.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 14:34:50 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220826161112.3786131-2-scgl@linux.ibm.com>
References: <20220826161112.3786131-1-scgl@linux.ibm.com> <20220826161112.3786131-2-scgl@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: Add specification exception test
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166187009028.75997.13672950150134705250@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 30 Aug 2022 16:34:50 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fd2KSIG3zamYN5DqmLyRP3BMBAeV_9Q4
X-Proofpoint-ORIG-GUID: fd2KSIG3zamYN5DqmLyRP3BMBAeV_9Q4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_08,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janis Schoetterl-Glausch (2022-08-26 18:11:11)
> Generate specification exceptions and check that they occur.
>=20
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

with minor nits below you may want to consider

> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
[...]
> +static int bad_alignment(void)
> +{
> +       uint32_t words[5] __attribute__((aligned(16)));
> +       uint32_t (*bad_aligned)[4] =3D (uint32_t (*)[4])&words[1];

Why not simply:

uint32_t *bad_aligned =3D &words[1];

> +
> +       /* LOAD PAIR FROM QUADWORD (LPQ) requires quadword alignment */
> +       asm volatile ("lpq %%r6,%[bad]"
> +                     : : [bad] "T" (*bad_aligned)
> +                     : "%r6", "%r7"
> +       );
> +       return 0;
> +}
> +
> +static int not_even(void)
> +{
> +       uint64_t quad[2] __attribute__((aligned(16))) =3D {0};
> +
> +       asm volatile (".insn    rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %=
%r7,%[quad] */

Here you use .insn above you use lpq - why?
