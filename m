Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1F4C3362
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiBXRTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBXRTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:19:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53D9429F40C
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645723120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zS1exBQ8/i7GE0yNuNzJ4368SmU3x1bv1hKHvRyPw8=;
        b=IFdfjkeUB6pIsyWSuTXR7HMYDx3AhyXXAtoXulby8soAypXmE1HCfiAjVf/VLGzuEGTuOv
        /PJb1C85tvozaPRWjlzqQFci9LsWbDvFDg0tEzgTge/hXUchsVFqRVg7UFrz98QG25naOj
        vKsRHVKrEKKcxLhGKeuTQ0uHmaQyCDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-HjQKu-n9MBu3I-8CPxWnAQ-1; Thu, 24 Feb 2022 12:18:37 -0500
X-MC-Unique: HjQKu-n9MBu3I-8CPxWnAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E31E1006AA6;
        Thu, 24 Feb 2022 17:18:35 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2765F841D3;
        Thu, 24 Feb 2022 17:18:32 +0000 (UTC)
Message-ID: <9143d9d24d1b169668062a18a5f49bb8cf8e877b.camel@redhat.com>
Subject: Re: [RFC PATCH 05/13] KVM: SVM: Update max number of vCPUs
 supported for x2AVIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 19:18:31 +0200
In-Reply-To: <20220221021922.733373-6-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-6-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> xAVIC and x2AVIC modes can support diffferent number of vcpus.
> Update existing logics to support each mode accordingly.
> 
> Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
> the actual value supported by the architecture.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 12 +++++++++---
>  arch/x86/kvm/svm/avic.c    |  8 +++++---
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 7a7a2297165b..681a348a9365 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -250,10 +250,16 @@ enum avic_ipi_failure_cause {
>  
>  
>  /*
> - * 0xff is broadcast, so the max index allowed for physical APIC ID
> - * table is 0xfe.  APIC IDs above 0xff are reserved.
> + * For AVIC, the max index allowed for physical APIC ID
> + * table is 0xff (255).
>   */
> -#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
> +#define AVIC_MAX_PHYSICAL_ID		0XFFULL
> +
> +/*
> + * For x2AVIC, the max index allowed for physical APIC ID
> + * table is 0x1ff (511).
> + */
> +#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL

Yep, physid page can't hold more entries...

This brings the inventible question of what to do when a VM has more
that 512 vCPUs...

With AVIC, since it is xapic, it would be easy - xapic supports up to
254 CPUs.

But with x2apic, there is no such restriction on max 512 CPUs,
thus it is legal to create a VM with x2apic and more that 512 CPUs,
and x2AVIC won't work well in this case.

I guess AVIC_IPI_FAILURE_INVALID_TARGET, has to be extened to support those
cases, even with loss of performance, or we need to inhibit x2AVIC.

Best regards,
	Maxim Levitsky

>  
>  #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>  #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 0040824e4376..1999076966fd 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -195,7 +195,7 @@ void avic_init_vmcb(struct vcpu_svm *svm)
>  	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
> +	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
>  
>  	if (kvm_apicv_activated(svm->vcpu.kvm))
> @@ -210,7 +210,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  	u64 *avic_physical_id_table;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>  
> -	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
> +	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
>  		return NULL;
>  
>  	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> @@ -257,7 +258,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
> +	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
>  		return -EINVAL;
>  
>  	if (!vcpu->arch.apic->regs)


