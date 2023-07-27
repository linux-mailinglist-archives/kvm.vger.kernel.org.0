Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCCC7656FC
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjG0PIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbjG0PIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:08:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E6AE75;
        Thu, 27 Jul 2023 08:07:43 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36REp1fS009227;
        Thu, 27 Jul 2023 15:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aSYQ12Oo80P5tDdm12/W0Mlezhefvka4So73eJcX1+4=;
 b=qeEx0pr1OtE+dOH2yPLAmfWLQ8Pq09rVQ9thU41fQGqzooFfM3vFd9L5gB9K8u9fhUJW
 vbPBmybDvz6z/mL/Fp9fbupaKISPC5bw1z+fT4MhDrFYbJHyel3ZssV6EHApkiaBL+/m
 MDIo927FPHiYjk6smCdqtOcYUtEQdsDs2WCRhXj7ESA9O92xfYA3GdSFsFZj4FPL3Y4t
 0WH5JqK20ZeT3vn/KTfGQWRDX1BHgAHOLe9dLdkJiNX8Jf7ZQ0GMG7oa6jWxZpJw5vr5
 OuvIkB0dVzLeXEx+I7DXGRhEt4Cq2MAybfqAS6O2w3gQvtSC0kV3u3MBFaIu2UMsevzn xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tk1rsy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:07:40 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36REhSLM014373;
        Thu, 27 Jul 2023 15:07:40 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tk1rsx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:07:40 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36REnBj9014403;
        Thu, 27 Jul 2023 15:07:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0styenxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:07:38 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RF7ZVk41288398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 15:07:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 300CA2004D;
        Thu, 27 Jul 2023 15:07:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E36062004B;
        Thu, 27 Jul 2023 15:07:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 15:07:34 +0000 (GMT)
Date:   Thu, 27 Jul 2023 17:07:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH 3/3] KVM: s390: pv:  Allow AP-instructions for pv guests
Message-ID: <20230727170724.7adb71fa@p-imbrenda>
In-Reply-To: <20230727122053.774473-4-seiden@linux.ibm.com>
References: <20230727122053.774473-1-seiden@linux.ibm.com>
        <20230727122053.774473-4-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ahMfcDCuictviPyL4jnUzi4OK03ojXcN
X-Proofpoint-GUID: vDFG3mWrVj0JMJ-l9rCfGaNlKAqO43yL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_07,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 14:20:53 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Introduces new feature bits and enablement flags for AP and AP IRQ
> support.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 12 +++++++++++-
>  arch/s390/kvm/pv.c         |  8 ++++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 338845402324..913ccfaa9d76 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -99,6 +99,8 @@ enum uv_cmds_inst {
>  enum uv_feat_ind {
>  	BIT_UV_FEAT_MISC = 0,
>  	BIT_UV_FEAT_AIV = 1,
> +	BIT_UV_FEAT_AP = 4,
> +	BIT_UV_FEAT_AP_INTR = 5,
>  };
>  
>  struct uv_cb_header {
> @@ -159,7 +161,15 @@ struct uv_cb_cgc {
>  	u64 guest_handle;
>  	u64 conf_base_stor_origin;
>  	u64 conf_virt_stor_origin;
> -	u64 reserved30;
> +	u8  reserved30[6];
> +	union {
> +		struct {
> +			u16 reserved : 14;
> +			u16 ap_instr_intr : 1;
> +			u16 ap_allow_instr : 1;
> +		};
> +		u16 raw;
> +	} flags;
>  	u64 guest_stor_origin;
>  	u64 guest_stor_len;
>  	u64 guest_sca;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 899f3b8ac011..103add1894c9 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -561,12 +561,16 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	uvcb.conf_base_stor_origin =
>  		virt_to_phys((void *)kvm->arch.pv.stor_base);
>  	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
> +	uvcb.flags.ap_allow_instr = uv_has_feature(BIT_UV_FEAT_AP) &&
> +				    kvm->arch.model.uv_feat_guest.ap;

how can it happen that uv_feat_guest.ap is set but
uv_has_feature(BIT_UV_FEAT_AP) is 0 ?

in the previous patch you check for the feature before allowing the bit
to be set.

> +	uvcb.flags.ap_instr_intr = uv_has_feature(BIT_UV_FEAT_AP_INTR) &&
> +				   kvm->arch.model.uv_feat_guest.ap_intr;

same here

>  
>  	cc = uv_call_sched(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
> -	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> -		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x flags %04x",
> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc, uvcb.flags.raw);
>  
>  	/* Outputs */
>  	kvm->arch.pv.handle = uvcb.guest_handle;

