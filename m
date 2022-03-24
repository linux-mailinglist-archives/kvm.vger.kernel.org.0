Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4D4E6235
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 12:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349700AbiCXLPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 07:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348768AbiCXLPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 07:15:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D9C270071
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 04:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648120450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lkor8/fgDn8C4k+CI3MJ8f7UXm4ww7ZYHLZLrk4A3Mg=;
        b=c2W83K+BxLOQg6VkmpVdKyjoyWP8wwDaYgMEfQwaSFc9O3279CoXwHSeSWZkELtKQPoBQZ
        maCTHzGS4m5OVrxwtKWaTjDlaD39BqR1ZNdZyALXfuMf4Ei59m9o6cAGABaPNDDz/vLF1X
        gz9B+gCuFH/OalZzIGZuJ60Y2vBM8HA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-RR2YE1LdM72fscDxndmEmQ-1; Thu, 24 Mar 2022 07:14:07 -0400
X-MC-Unique: RR2YE1LdM72fscDxndmEmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87E482A2AD44;
        Thu, 24 Mar 2022 11:14:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9869D46;
        Thu, 24 Mar 2022 11:13:58 +0000 (UTC)
Message-ID: <bd33f54dce24c145470cc1dbcdc3074f0f53cc67.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 04/12] KVM: SVM: Update max number of vCPUs
 supported for x2AVIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 13:13:57 +0200
In-Reply-To: <20220308163926.563994-5-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-5-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
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
This should be 0xFE, since index 0xFF is reserved in AVIC mode.
It used to work because (see below) check used to be '>=',
but I do like that you switched to '>' check instead.


> +#define AVIC_MAX_PHYSICAL_ID		0XFFULL
> +
> +/*
> + * For x2AVIC, the max index allowed for physical APIC ID
> + * table is 0x1ff (511).
> + */
> +#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL


>  
>  #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>  #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 49b185f0d42e..f128b0189d4a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -183,7 +183,7 @@ void avic_init_vmcb(struct vcpu_svm *svm)
>  	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
> +	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
>  
>  	if (kvm_apicv_activated(svm->vcpu.kvm))
> @@ -198,7 +198,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  	u64 *avic_physical_id_table;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>  
> -	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
This is the check I am talking about

> +	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
>  		return NULL;

I would probably like to ask to move this check to a function,
but I see that avic_get_physical_id_entry is only used in avic_handle_apic_id_update
in addition to avic_init_backing_page which has this check,
and I will sooner or later remove the anywat broken avic_handle_apic_id_update and
inline the avic_get_physical_id_entry probably so no need to do this.

>  
>  	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> @@ -245,7 +246,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
> +	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
>  		return -EINVAL;


>  
>  	if (!vcpu->arch.apic->regs)


So except the off-by-one error in AVIC_MAX_PHYSICAL_ID_COUNT:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

