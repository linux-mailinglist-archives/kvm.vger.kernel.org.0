Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92793587877
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiHBH4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiHBH4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:56:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD9E2F039
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:56:12 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2726JqrV017339
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=G5HbnzUMyyWfmSmuw1IUitPpb27UD7goA569dNx8+mU=;
 b=aY3VkkdIXauwyMhoMg2Ze1SyKagXt69eV4zsqNZuz3GbAUwDaAL1/mQIe9WsXB8XGn3M
 zs2VC61RFtuYSM9Q7kdM2bFsoa1uO1u73fscLwcwqjJJOldCPl03FUHZV0a+jjeDoFA7
 ht7y0lpuErTvHLpu6MMzKQSdMUzamWML9TFQtSEZFjohnPyD8Nmhy6hrrg04tNodFqA+
 hhF9bWKCl7Qrijky/tYoK/ctORhH6pO6ZEOhEjNPnXOJVpXXcaFbbi0E1R7FB1m3RhKo
 8+G2ffC4X6Lo2WoARDY/mzTAFJau92f4JfIDj4I2kAGc4rAHTvl4/S2U9M6Lb5S6DWTG 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpxjetkk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:56:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2726ZgEQ010590
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:56:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpxjetkj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:56:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2727pmfM001625;
        Tue, 2 Aug 2022 07:56:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98kda2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:56:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727u6Ib29688200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:56:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFEB2A4066;
        Tue,  2 Aug 2022 07:56:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7B20A4064;
        Tue,  2 Aug 2022 07:56:05 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 07:56:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-6-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-6-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/6] lib: s390x: Use a new asce for each PV guest
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942696565.253051.14140437182743201110@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 09:56:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ooq0o0T0ByUMUBk7QR8c_6BiTrrwAC1I
X-Proofpoint-GUID: NsYaBgl0MtKrpBqgWJIvZiZ_S3S7Hsw7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208020036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:32)
> Every PV guest needs its own ASCE so let's copy the topmost table
> designated by CR1 to create a new ASCE for the PV guest. Before and
> after SIE we now need to switch ASCEs to and from the PV guest / test
> ASCE. The SIE assembly function does that automatically.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

with two tiny things for you to consider.

[...]
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 3b4cafa9..99775929 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -76,7 +76,8 @@ void uv_init(void)
>         int cc;
> =20
>         /* Let's not do this twice */
> -       assert(!initialized);
> +       if (initialized)
> +               return;

Caught me a bit by surprise, maybe you want to point out this change in the=
 commit message.

[...]
> +/*
> + * Create a new ASCE for the UV config because they can't be shared
> + * for security reasons. We just simply copy the top most table into a
> + * fresh set of allocated pages and use those pages as the asce.
> + */
> +static uint64_t create_asce(void)
> +{
> +       void *pgd_new, *pgd_old;
> +       uint64_t asce =3D stctg(1);
> +
> +       pgd_new =3D memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);
> +       pgd_old =3D (void *)(asce & PAGE_MASK);
> +
> +       memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
> +
> +       asce =3D __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | =
ASCE_P;

I am wondering whether it might make sense to copy over the flags from cr1 =
so we don't have to worry about keeping them in sync?

But possibly it is sufficiently unlikely that these will ever change...
