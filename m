Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85060161819
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgBQQkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 11:40:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48877 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgBQQkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 11:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581957631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fm9Mu329tflOhzJ9YEndE4Fe2Pm3uRmsk0n5PQaTgWY=;
        b=dMtHCsnSW9Va1psj1CCnjPOpJFVAll1UD/afCF1lnAgJQwfLpS00wuxwEliIBONPXpsm5r
        +GIDSQabtM27z7+lKr3LuW4ErseeYdwSsDoSekHEYCNQqgLGhxfyKl9KjBpHPOMXJMGo2S
        X/BdxA+g0GYYd7QSU/VfWcu15XtYVtg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-62AA3akEP_6ZE6PgZng5qA-1; Mon, 17 Feb 2020 11:40:29 -0500
X-MC-Unique: 62AA3akEP_6ZE6PgZng5qA-1
Received: by mail-wr1-f72.google.com with SMTP id d8so9162404wrq.12
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 08:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fm9Mu329tflOhzJ9YEndE4Fe2Pm3uRmsk0n5PQaTgWY=;
        b=BJLS9sWm7j2zu03wD2BQIG0UKJqvE2CP5pyJAxWnjmaS+XyZhfvFdVocaHh7D4VnNc
         bwq6OIccbZociCPc4XJO3B0ucED2EzFm31hczJ1JXgOTS01z34ayhYP/ABtn9Io1BjHd
         hb5gPziiNywTkn476wzCqsMn9bIZjbvQlJWz+RGbi4217IFxDTtPBboEBSXpIdasaEF+
         xaLfAKLQnBeshJj5c7Q8cTOFfvwROuyD2PdQYl/3GTIxOEPkd6DuRoR2hzxep88Uoes2
         jpUUKbzPYEy2VF6VZuhutyx+JJwiG3iKyheODIa0diltO5Ff367Kk2zH/ct3DaiIBZCN
         DHqg==
X-Gm-Message-State: APjAAAVm/5QFEw3oE/Nur+SXJjQ37YKirmbw2DU5s405EoRj7kpQfx18
        wm9zfxLTtK203YRsEiaK+I4sPVxvJG/EhIz4/pLSjlTspZwMxrno3QHdGxaBMqb5K3HqTToxo+d
        378s5JD3L+fBF
X-Received: by 2002:a1c:740a:: with SMTP id p10mr23104935wmc.65.1581957627971;
        Mon, 17 Feb 2020 08:40:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCCTrFsnWEQy/Qavf0QH4TGCt6wA1yzkQAK3IxV3vfOTUJgIEepTQUFdbvUG6+zqWkVDBsGg==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr23104922wmc.65.1581957627771;
        Mon, 17 Feb 2020 08:40:27 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x17sm1732096wrt.74.2020.02.17.08.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 08:40:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: VMX: Add 'else' to split mutually exclusive case
In-Reply-To: <1581951750-17854-1-git-send-email-linmiaohe@huawei.com>
References: <1581951750-17854-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 17 Feb 2020 17:40:26 +0100
Message-ID: <87h7zp9ngl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Each if branch in handle_external_interrupt_irqoff() is mutually
> exclusive. Add 'else' to make it clear and also avoid some unnecessary
> check.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v1->v2:
> add braces to all if branches
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9a6664886f2e..a13368b2719c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6176,15 +6176,13 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  
>  	/* if exit due to PF check for async PF */
> -	if (is_page_fault(vmx->exit_intr_info))
> +	if (is_page_fault(vmx->exit_intr_info)) {
>  		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
> -
>  	/* Handle machine checks before interrupts are enabled */
> -	if (is_machine_check(vmx->exit_intr_info))
> +	} else if (is_machine_check(vmx->exit_intr_info)) {
>  		kvm_machine_check();
> -
>  	/* We need to handle NMIs before interrupts are enabled */
> -	if (is_nmi(vmx->exit_intr_info)) {
> +	} else if (is_nmi(vmx->exit_intr_info)) {
>  		kvm_before_interrupt(&vmx->vcpu);
>  		asm("int $2");
>  		kvm_after_interrupt(&vmx->vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

