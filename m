Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBE7911D0
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 09:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352298AbjIDHKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjIDHKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 03:10:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9881E12D;
        Mon,  4 Sep 2023 00:10:18 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38477rQd018474;
        Mon, 4 Sep 2023 07:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=Ut2Koxy/lbycBlgqtEQMOJLEp39pDo0hH7dXFfAPhVU=;
 b=ZqKT80IIMESxGGVQwWtitadmv/jqpcbUgFyAbXUbTsxezuqAxsAl08GCf6Vv5kw0vqai
 2nSyt1hkDhkej1gbpfVkxvQ76YoNPTqWIJgOq+gC7zh0JS+0YxnW9vpDU5vu1vrqcO1P
 IsbLL0gWYldEZSEh9zMsVDfc4gTLR9e9P9kGTU+zKab/zhTCL0dg0eDFLqJqzSSksido
 F2fsebs1b7FlmX+EdOkgRyTRQbpNfEKOYx2f//L6f6GLFoPoiQIsragVj1ySwGNdkSZK
 REW7y5Bxg7tca7+PdXpLwJijFZ+H08gU7R+Ib1ldobD7IZ1ZxJcSosoDh2qOCjSLiA98 9A== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7qw3n9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 07:10:17 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3846m8DR001615;
        Mon, 4 Sep 2023 07:05:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svfcs8wbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 07:05:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38475Ail3539636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 07:05:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0476620043;
        Mon,  4 Sep 2023 07:05:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8FEC20040;
        Mon,  4 Sep 2023 07:05:09 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.12.249])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 07:05:09 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230901105823.3973928-1-mimu@linux.ibm.com>
References: <20230901105823.3973928-1-mimu@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v4] KVM: s390: fix gisa destroy operation might lead to cpu stalls
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169381110909.97137.16554568711338641072@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 04 Sep 2023 09:05:09 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oqOp2fyk9GpLLcprNhf55P8KNChfUJJO
X-Proofpoint-GUID: oqOp2fyk9GpLLcprNhf55P8KNChfUJJO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_04,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=470 adultscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Michael Mueller (2023-09-01 12:58:23)
[...]
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 9bd0a873f3b1..96450e5c4b6f 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
[...]
>  static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gis=
c)
>  {
>         set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
> @@ -3202,11 +3197,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
> =20
>         if (!gi->origin)
>                 return;
> -       if (gi->alert.mask)
> -               KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
> -                         kvm, gi->alert.mask);
> -       while (gisa_in_alert_list(gi->origin))
> -               cpu_relax();
> +       WARN(gi->alert.mask !=3D 0x00,
> +            "unexpected non zero alert.mask 0x%02x",
> +            gi->alert.mask);
> +       gi->alert.mask =3D 0x00;
> +       if (gisa_set_iam(gi->origin, gi->alert.mask))
> +               process_gib_alert_list();

I am not an expert for the GISA, so excuse my possibly stupid question:
process_gib_alert_list() starts the timer. So can gisa_vcpu_kicker()
already be running before we reach hrtimer_cancel() below? Is this fine?

>         hrtimer_cancel(&gi->timer);
>         gi->origin =3D NULL;
>         VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
