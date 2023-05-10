Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC25F6FDA02
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbjEJIwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbjEJIwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:52:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549FA44A7;
        Wed, 10 May 2023 01:52:00 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A8lvnx009562;
        Wed, 10 May 2023 08:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=1TZ3Wlt8MKcNfVfjPSiMXTrV57SRF9nR/yTXY7RFihE=;
 b=ANpYY2/bD5NBCOLYErICaXRw9PAxhsYGRHA6xgeJTsO9KMRgqHUWEgIx2nNp52bgFgif
 L6I70FYG6doY/NiH3yD5LvGtZOmZEiM8elQWpJcDHS+iGOi4Ff+xqIqmXWaCEwMMfgKY
 mfldrsbkAeIPl2a6CT7gk5e3OgdoQusYVefJoD1+sdPc1vPm+QuB9iiaviJpuh7IgBRP
 HN/dBEZAeNrj4uR6hW51l6bxwpiLI3jWLW8z8l5S1bp01bmKDuvfgq54gAooNGiim+qq
 A9aPXeJKp44kcEDNi9SzXW1bBiQlQy17LqwKNKva5vBR0AURb/xCNTnUyWI3/7KO7o0M QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg82v01ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:51:59 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A8pI2V017916;
        Wed, 10 May 2023 08:51:59 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg82v01vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:51:59 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7oNR1021796;
        Wed, 10 May 2023 08:51:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhgru7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:51:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A8priF28377754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 08:51:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 142C820043;
        Wed, 10 May 2023 08:51:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFDF420040;
        Wed, 10 May 2023 08:51:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.202])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 08:51:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502130732.147210-2-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com> <20230502130732.147210-2-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/9] s390x: uv-host: Fix UV init test memory allocation
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168370871258.331309.6187452257634029708@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 10:51:52 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rY5d2WemKCMXqOoPsjAbwBg8JVvuHPFf
X-Proofpoint-GUID: Qqjqcvikz9lOHwqB-DhXjFfc8IA3ABAH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 15:07:24)
> The init memory has to be above 2G and 1M aligned but we're currently
> aligning on 2G which means the allocations need a lot of unused
> memory.

I know I already gave my R-b here, but...

> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 33e6eec6..9dfaebd7 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -500,14 +500,17 @@ static void test_config_create(void)
>  static void test_init(void)
>  {
>         int rc;
> -       uint64_t mem;
> +       uint64_t tmp;
> =20
> -       /* Donated storage needs to be over 2GB */
> -       mem =3D (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_st=
or_len, AREA_NORMAL);

...maybe out of coffee, but can you point me to the place where we're align=
ing
to 2G here? I only see alignment to 1M and your change only seems to rename
mem to tmp:

> +       /*
> +        * Donated storage needs to be over 2GB, AREA_NORMAL does that
> +        * on s390x.
> +        */
> +       tmp =3D (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_st=
or_len, AREA_NORMAL);
