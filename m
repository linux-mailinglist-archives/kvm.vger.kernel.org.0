Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1249152316F
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiEKLZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiEKLYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 406E82311C4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqklRis3NvLrtnkJ+fP/4KpY42A2+gH7n5/YJ5czfAc=;
        b=b551IdTevl8Rd4zUyVHVH5ACzpRlT71uveos4/jk6OkW7TrmPTiorqsC7s8tfskm+nGpO3
        tbwEOPeEOyXF+S2hskJW5/RAVh+hX4178GbkgqOByA8rFtm0uX/EyKd9vnLhnK4JGdhDzj
        wLn+K0EjfsGuJ9/nz4QP/0WsObr0XfY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-K5tUzUKpMUyQ2t3AM_VVxw-1; Wed, 11 May 2022 07:24:00 -0400
X-MC-Unique: K5tUzUKpMUyQ2t3AM_VVxw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB4EF1010361;
        Wed, 11 May 2022 11:23:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 791C4401E31;
        Wed, 11 May 2022 11:23:57 +0000 (UTC)
Message-ID: <874f6f1c1ae466a0d7f13610b5cbedbfa0869fd4.camel@redhat.com>
Subject: Re: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:23:56 +0300
In-Reply-To: <20220414132013.1588929-8-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-8-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> It may not come clear from where the magical '64' value used in
> __cpumask_to_vpset() come from. Moreover, '64' means both the maximum
> sparse bank number as well as the number of vCPUs per bank. Add defines
> to make things clear. These defines are also going to be used by KVM.
> 
> No functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  include/asm-generic/hyperv-tlfs.h |  5 +++++
>  include/asm-generic/mshyperv.h    | 11 ++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index fdce7a4cfc6f..020ca9bdbb79 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -399,6 +399,11 @@ struct hv_vpset {
>  	u64 bank_contents[];
>  } __packed;
>  
> +/* The maximum number of sparse vCPU banks which can be encoded by 'struct hv_vpset' */
> +#define HV_MAX_SPARSE_VCPU_BANKS (64)
> +/* The number of vCPUs in one sparse bank */
> +#define HV_VCPUS_PER_SPARSE_BANK (64)
> +
>  /* HvCallSendSyntheticClusterIpi hypercall */
>  struct hv_send_ipi {
>  	u32 vector;
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
> index c08758b6b364..0abe91df1ef6 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -214,9 +214,10 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>  {
>  	int cpu, vcpu, vcpu_bank, vcpu_offset, nr_bank = 1;
>  	int this_cpu = smp_processor_id();
> +	int max_vcpu_bank = hv_max_vp_index / HV_VCPUS_PER_SPARSE_BANK;
>  
> -	/* valid_bank_mask can represent up to 64 banks */
> -	if (hv_max_vp_index / 64 >= 64)
> +	/* vpset.valid_bank_mask can represent up to HV_MAX_SPARSE_VCPU_BANKS banks */
> +	if (max_vcpu_bank >= HV_MAX_SPARSE_VCPU_BANKS)
>  		return 0;
>  
>  	/*
> @@ -224,7 +225,7 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>  	 * structs are not cleared between calls, we risk flushing unneeded
>  	 * vCPUs otherwise.
>  	 */
> -	for (vcpu_bank = 0; vcpu_bank <= hv_max_vp_index / 64; vcpu_bank++)
> +	for (vcpu_bank = 0; vcpu_bank <= max_vcpu_bank; vcpu_bank++)
>  		vpset->bank_contents[vcpu_bank] = 0;
>  
>  	/*
> @@ -236,8 +237,8 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>  		vcpu = hv_cpu_number_to_vp_number(cpu);
>  		if (vcpu == VP_INVAL)
>  			return -1;
> -		vcpu_bank = vcpu / 64;
> -		vcpu_offset = vcpu % 64;
> +		vcpu_bank = vcpu / HV_VCPUS_PER_SPARSE_BANK;
> +		vcpu_offset = vcpu % HV_VCPUS_PER_SPARSE_BANK;
>  		__set_bit(vcpu_offset, (unsigned long *)
>  			  &vpset->bank_contents[vcpu_bank]);
>  		if (vcpu_bank >= nr_bank)
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

