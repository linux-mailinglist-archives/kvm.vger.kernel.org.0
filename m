Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045AA1649FF
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgBSQTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 11:19:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbgBSQTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 11:19:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582129188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQG6wOR7XEH6waSn1u4s8c6iKIaqZZz3sGjiy8AFd8A=;
        b=ON1U9gurDwl30R+16T/cL2o1LSaoU4Z1cTPS88i3JcBhvoc18PxI88veWoR2P1iC/t+72E
        X6bg8tQMNDwUMhxdbpmiFayvnjl4b927RktIrJi1txmQaEuqrjavzILEuy03gCUQT1IfR9
        0rFnjwsW9YmFuzRQDlOFinjUOyJbjT8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-BDc_OKZAO7mpBRAUYKT6PQ-1; Wed, 19 Feb 2020 11:19:45 -0500
X-MC-Unique: BDc_OKZAO7mpBRAUYKT6PQ-1
Received: by mail-wr1-f70.google.com with SMTP id 90so317147wrq.6
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 08:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eQG6wOR7XEH6waSn1u4s8c6iKIaqZZz3sGjiy8AFd8A=;
        b=ZB1ZNOkmquR0SZsW8/MJNPd96AsFTPmCCcrysHCS8PhUL8f3c2mRHsfe1Q/Cd9uic2
         Zo1838tGs+xrptfds9KmHGVwyD4l9SFV/Zo/rMzYayJRgGEKeo/xUUesPRkNDtMK5eSS
         fufyg5g9PvwzVLvdI3nRn837hLG+jAWRRB6ySDLkTv2wiPxF7QmUQe2JVefl5hAVDnTW
         M4UAAhF7at7PV2sdbSCOpIkn1eAlA/daLDJ6qLk9mrM1TgBOXqrrWSOg4YAWb2+H2Pt/
         5oJ+/2qF1lS/560ukUpS4gcjfw6AN5ulptZ1O0IL3uZTbUmnMEJI9wS+VGN45nQIB5HN
         tfJg==
X-Gm-Message-State: APjAAAXxlCLDoc60FMiyGXYkCLGSxkR/aK3U0t4sjQCo3yRsBHy9lgL9
        4IjdLBvGCeyaNkK10tVn9Z0s2dIKWhR+mlL7HlsmaC4z/EENP+YO7/NEyuyo1vQHVdaQKsHmge8
        001Huc4czsBhs
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr11142426wmg.144.1582129184442;
        Wed, 19 Feb 2020 08:19:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqxA0P0y9HeEt0jYJ8WWr+k4KMpNa61zp/pvvV7y6klztlfomtqNm/je1u9mUu7gPxdvz1k58g==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr11142396wmg.144.1582129184190;
        Wed, 19 Feb 2020 08:19:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ec41:5e57:ff4d:8e51? ([2001:b07:6468:f312:ec41:5e57:ff4d:8e51])
        by smtp.gmail.com with ESMTPSA id j5sm321626wrw.24.2020.02.19.08.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 08:19:43 -0800 (PST)
Subject: Re: [PATCH v2] KVM: VMX: Add 'else' to split mutually exclusive case
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581951750-17854-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <088c58ac-90f8-120c-af3a-d8e10ff7ed99@redhat.com>
Date:   Wed, 19 Feb 2020 17:19:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581951750-17854-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 16:02, linmiaohe wrote:
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
> 

Queued, thanks.

Paolo

