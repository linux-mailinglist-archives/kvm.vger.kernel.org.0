Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3A4E61BA
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 11:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349503AbiCXKbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 06:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242686AbiCXKbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 06:31:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 441F25521D
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 03:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648117810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juZ6zFT70XMLDT3hqkTSkkxIYqEGcZZ3ok6VMb0BqDg=;
        b=K/+GtBdudkh+rZYI+YsJG3/3+DEWBPf5EksEdqlUOjCklH6zutlVWtLuCHpHIj90GPOxcw
        XoN6uqxeWjghppDAsql35/bA4bapCmGpYMqukwcSA8/A43YwAS1b9NNQvHcrne20Mcm2qI
        NuQMhEwDw2Od/KEmY1xo/e8P7ptXOq8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-ck4odP71M7awFTYn8hwHvw-1; Thu, 24 Mar 2022 06:30:07 -0400
X-MC-Unique: ck4odP71M7awFTYn8hwHvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2C073802ACE;
        Thu, 24 Mar 2022 10:30:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7F6AC07F4B;
        Thu, 24 Mar 2022 10:30:04 +0000 (UTC)
Message-ID: <0f12fa4d8aa43e6f346c1f2d73bb0b67e19bd494.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 02/12] KVM: x86: lapic: Rename
 [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 12:30:03 +0200
In-Reply-To: <20220308163926.563994-3-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-3-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> To signify that the macros only support 8-bit xAPIC destination ID.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/hyperv/hv_apic.c      | 2 +-
>  arch/x86/include/asm/apicdef.h | 4 ++--
>  arch/x86/kernel/apic/apic.c    | 2 +-
>  arch/x86/kernel/apic/ipi.c     | 2 +-
>  arch/x86/kvm/lapic.c           | 2 +-
>  arch/x86/kvm/svm/avic.c        | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index db2d92fb44da..fb8b2c088681 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
>  {
>  	u64 reg_val;
>  
> -	reg_val = SET_APIC_DEST_FIELD(id);
> +	reg_val = SET_XAPIC_DEST_FIELD(id);
>  	reg_val = reg_val << 32;
>  	reg_val |= low;
>  
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 5716f22f81ac..863c2cad5872 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -89,8 +89,8 @@
>  #define		APIC_DM_EXTINT		0x00700
>  #define		APIC_VECTOR_MASK	0x000FF
>  #define	APIC_ICR2	0x310
> -#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> -#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
> +#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> +#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
>  #define	APIC_LVTT	0x320
>  #define	APIC_LVTTHMR	0x330
>  #define	APIC_LVTPC	0x340
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b70344bf6600..e6b754e43ed7 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
>  	unsigned long flags;
>  
>  	local_irq_save(flags);
> -	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
> +	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
>  	apic_write(APIC_ICR, low);
>  	local_irq_restore(flags);
>  }
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index d1fb874fbe64..2a6509e8c840 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
>  
>  static inline int __prepare_ICR2(unsigned int mask)
>  {
> -	return SET_APIC_DEST_FIELD(mask);
> +	return SET_XAPIC_DEST_FIELD(mask);
>  }
>  
>  static inline void __xapic_wait_icr_idle(void)
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..03d1b6325eb8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1286,7 +1286,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  	if (apic_x2apic_mode(apic))
>  		irq.dest_id = icr_high;
>  	else
> -		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
> +		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
>  
>  	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f07956f15d3b..60cd346acd1c 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -299,7 +299,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					GET_APIC_DEST_FIELD(icrh),
> +					GET_XAPIC_DEST_FIELD(icrh),
>  					icrl & APIC_DEST_MASK)) {
>  			vcpu->arch.apic->irr_pending = true;
>  			svm_complete_interrupt_delivery(vcpu,


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

