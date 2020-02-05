Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E551535B3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBEQ5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:57:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727079AbgBEQ5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 11:57:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580921825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxFkSdvrYLxIEAwQWaBaRc6nRKIPOYjssvLU1SdT+6A=;
        b=U093wRe37lr9NqEC+BhSd4vcVng3O56aQ2w9MBM5ZIXcBCK7WbjxkCrBjZ9k+5KsElccw/
        Qe6CIH4t7hxzvhU8hZlAnZ16ojZl5/c8mCLoSNmW3OlAcgbmB2tCZvvYPM//ZrCLFCcTMf
        xAQ0SxNKJNYStoduFBgqp9DXUlMZJVE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-rP9gVdHsNTesCCUWEvr_bQ-1; Wed, 05 Feb 2020 11:57:02 -0500
X-MC-Unique: rP9gVdHsNTesCCUWEvr_bQ-1
Received: by mail-wr1-f71.google.com with SMTP id u18so1459714wrn.11
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 08:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PxFkSdvrYLxIEAwQWaBaRc6nRKIPOYjssvLU1SdT+6A=;
        b=jVJHgNBWrFKMkeQSzN34fdzXx5sGamlJ3H4ck4wXDvjditqa450m8g+TdgqpfI9AeO
         EE9D7XGQtcif49Fd2Iuowf6VTUP+aVOa1W5TMbbN13PIDq1uvW3fB4Dl+RkZWI0v/VwU
         vCHg5FpEE8wDOiFbSugVRLiSvz11i5CqYuLAcnfRko8ECroyQwHT582ry9gPsCbdfpOH
         spipp1jncorC3wMA206JnSnAutDVe0+nc7urD/Gw3AoqBV2uznm9f+FBzVjxIBwrD+0V
         BA8ugYNbtXBZEa9RJ6o8bx5fYf8PlsSr3GJOolnL4vRHSfIjLVq+/XFHiql2Risr5PB7
         oR4Q==
X-Gm-Message-State: APjAAAUdupm4Rf1QW7BgWp1rvUYQsF0K2IcFQhwW/9z3sWgdfUCShy2i
        kzkt3I7oKjvrzZoITi/3y5TXK9da0ab9WfZM3KqoJABxCzP1M7PerUuJ+dgUnRDkBu0K8SXc2l3
        m/2BDLWUSyM2I
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr4617863wml.50.1580921821173;
        Wed, 05 Feb 2020 08:57:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6o+ESIGmO/3zFWtD1tm/ePiEllQhG+yeSmmbQ8rnxhegcVzud2hRMO5aLmfS0Rt3YXlUp7A==
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr4617845wml.50.1580921820988;
        Wed, 05 Feb 2020 08:57:00 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v14sm559308wrm.28.2020.02.05.08.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:57:00 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: vmx: delete meaningless vmx_decache_cr0_guest_bits() declaration
In-Reply-To: <1580916833-28905-1-git-send-email-linmiaohe@huawei.com>
References: <1580916833-28905-1-git-send-email-linmiaohe@huawei.com>
Date:   Wed, 05 Feb 2020 17:56:59 +0100
Message-ID: <87r1z9j7l0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The function vmx_decache_cr0_guest_bits() is only called below its
> implementation. So this is meaningless and should be removed.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 678edbd6e278..061fefc30ecc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1428,8 +1428,6 @@ static bool emulation_required(struct kvm_vcpu *vcpu)
>  	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
>  }
>  
> -static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
> -
>  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

