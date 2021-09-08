Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43283403763
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 11:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348449AbhIHJ5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 05:57:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244785AbhIHJ5N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 05:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631094964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vmB/xp1x9/sfeWgC15NH+4JC6OPYB0ruQ9Xmgxc57EE=;
        b=C82aFO289YBPJBPku4f3hVYHdB3dKPbgCRshpX7hSYWX8DxaQY/43EoUsJb7yA63Axox2o
        tvZ+LkteyEqWiZyNlZLf2Za3dmRBkpU2h/7a9ZNLyK3l6ckQRAh9k1fYcy/5xN/qefX6iV
        77zyTlxM3NOdE/WHTAMbVW/NwoJnzcs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-F96j3S37MjC0fcYWeiYIUA-1; Wed, 08 Sep 2021 05:56:03 -0400
X-MC-Unique: F96j3S37MjC0fcYWeiYIUA-1
Received: by mail-wm1-f72.google.com with SMTP id w25-20020a1cf6190000b0290252505ddd56so729913wmc.3
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 02:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vmB/xp1x9/sfeWgC15NH+4JC6OPYB0ruQ9Xmgxc57EE=;
        b=B2OUAQFjqLNYfAKNifXYvunhpFDorDhQ3LCFCWOYfN0pZiWMIplXLMUy4gS2huR3pz
         OSqMBe6covZwCPB/gf/5REa+EN0fnlBQaAdJEaDuz4iBO7Q1B9lIXzFz1atNSR1ME458
         NXBCRKkhCg+zmWk5aCuFqj7xbRg14tfcwv6IUqvkhGMGBRh9QUOOwSRjwVk8ofsJzFbg
         3X457pUefajH1hjkMndKj0A00vEFwsAHaFa9I0Feqn1aX4v5KzQkNVSqOVeQwJ6IOX3G
         duV05G6LrLVpOY3t64T5x1GFtZ/YQG7myIJni4/t/C+Fu2/M/IN+Wtr/RyGox6MbfeOc
         0zsQ==
X-Gm-Message-State: AOAM531m8OxxVagUs+eLGU/XhL6in3jNgRskjrb2LP0cPpzXwHoUqP2l
        NaxvTVZqhc2LqmsWKEWTWsbPV3c7bSQ2x1aocsbRZ4UiC1aGpcrkES0lXCNtK9cAbx7EGU4ZF8M
        e4bxOBfuxwUJO
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr2617418wmk.172.1631094961813;
        Wed, 08 Sep 2021 02:56:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfAQD8R1/Xqad+26X2yoemUkBoNqNssE2eq3Zh0ZmvkXO8rSMX/fkbbd5nlh7vGjMyNNMBzQ==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr2617402wmk.172.1631094961611;
        Wed, 08 Sep 2021 02:56:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v9sm1534759wml.46.2021.09.08.02.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 02:56:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: fix comments of handle_vmon()
In-Reply-To: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
References: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
Date:   Wed, 08 Sep 2021 11:55:59 +0200
Message-ID: <87lf474ci8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yu Zhang <yu.c.zhang@linux.intel.com> writes:

> "VMXON pointer" is saved in vmx->nested.vmxon_ptr since
> commit 3573e22cfeca ("KVM: nVMX: additional checks on
> vmxon region"). Also, handle_vmptrld() & handle_vmclear()
> now have logic to check the VMCS pointer against the VMXON
> pointer.
>
> So just remove the obsolete comments of handle_vmon().
>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..90f34f12f883 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4862,14 +4862,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
>  	return -ENOMEM;
>  }
>  
> -/*
> - * Emulate the VMXON instruction.
> - * Currently, we just remember that VMX is active, and do not save or even
> - * inspect the argument to VMXON (the so-called "VMXON pointer") because we
> - * do not currently need to store anything in that guest-allocated memory
> - * region. Consequently, VMCLEAR and VMPTRLD also do not verify that the their
> - * argument is different from the VMXON pointer (which the spec says they do).
> - */
> +/* Emulate the VMXON instruction. */
>  static int handle_vmon(struct kvm_vcpu *vcpu)
>  {
>  	int ret;

Indeed,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

On a slightly related note: we don't seem to reset
'vmx->nested.vmxon_ptr' upon VMXOFF emulation; this is not a problem per
se as we never access it when !vmx->nested.vmxon but I'd still suggest
we do something like

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..8beb41d02d21 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -290,6 +290,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 
        vmx->nested.vmxon = false;
        vmx->nested.smm.vmxon = false;
+       vmx->nested.vmxon_ptr = -1ull;
        free_vpid(vmx->nested.vpid02);
        vmx->nested.posted_intr_nv = -1;
        vmx->nested.current_vmptr = -1ull;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7c5257eb5c0..2214e6bd4713 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6884,6 +6884,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
        vcpu_setup_sgx_lepubkeyhash(vcpu);
 
+       vmx->nested.vmxon_ptr = -1ull;
        vmx->nested.posted_intr_nv = -1;
        vmx->nested.current_vmptr = -1ull;
        vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;

to avoid issues in the future.

-- 
Vitaly

