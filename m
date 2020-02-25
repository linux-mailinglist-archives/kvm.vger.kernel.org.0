Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361B516C478
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbgBYOzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:55:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730601AbgBYOzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582642519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gji83vHKV1k5g/ChPkhalite2KXqbop0gZZfM2DEBYg=;
        b=FJqTYZwHS4zMn92K9Y20eurDNQz4YEczt2exBxf5g3ryiKz1UyI5VlfmCCVF8AQCF0l7bY
        V9rmSH/p2V1lFsOmlToX6XaeeWzWYZuBBvMbFj+MJNivo/tMjzvm+WNSgoold4Z5hGKuWU
        OsUfF0XsGGCwmP/k05coM23r/7oVx74=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-yvwjDiyjOdiWxPgGOAgnLg-1; Tue, 25 Feb 2020 09:55:14 -0500
X-MC-Unique: yvwjDiyjOdiWxPgGOAgnLg-1
Received: by mail-wm1-f71.google.com with SMTP id y7so969237wmd.4
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:55:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Gji83vHKV1k5g/ChPkhalite2KXqbop0gZZfM2DEBYg=;
        b=FyJwNhm0stb6E/BNnCOHCLeZE5jLQOSHoG0V465fbA4Xp/W1lCtQ0r7565dlu1opPz
         16nOTWs71BClE8wMeZYZfZI2RyXzgV8rU1AIyNVZoZpylZqoiakV6pvnXq6tCaYO7Bm8
         oLVcACEXcStOdJVHgIM+4t3Da9UBdkL63mGae8zRkecuCZbtg7IW9VGOy3C7KC56uW0Y
         9Fqu/aXCk4QgMiOScRKUt4Vf+NWP3kmYDf55O0oKV6296RHiHKWbbRlSABtCHUmvje3+
         zts0BfLmM6hGZL+gU3Xp5fnUEoqlGxjFsrGauk9+iJG3PbVhziyxM5NHwXuMm65FNy5m
         o/tA==
X-Gm-Message-State: APjAAAWT4U3vyX1NTZm1g6YbhdOgRJLNcib63V87zkjKHqz83svb1wAA
        vF4xReo1I3Jg+QMX+NblTSkdmsyGLpqd9LgM9FPqYIBEsQKRC/0C4M4HjDjyLgd9K9hPmERkXBN
        /aaI6NhhTBemm
X-Received: by 2002:adf:fc12:: with SMTP id i18mr14772563wrr.354.1582642513259;
        Tue, 25 Feb 2020 06:55:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXr3wjuxnRC1UK23RsKWqBFdQZDHdHj223uHMid455IAOjAv00FvziRQO2xBJQYBw4ADY7dw==
X-Received: by 2002:adf:fc12:: with SMTP id i18mr14772547wrr.354.1582642513041;
        Tue, 25 Feb 2020 06:55:13 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t10sm3180316wru.59.2020.02.25.06.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:55:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 59/61] KVM: x86: Don't propagate MMU lpage support to memslot.disallow_lpage
In-Reply-To: <20200201185218.24473-60-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-60-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 15:55:11 +0100
Message-ID: <878skqlnsg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Stop propagating MMU large page support into a memslot's disallow_lpage
> now that the MMU's max_page_level handles the scenario where VMX's EPT is
> enabled and EPT doesn't support 2M pages.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 ---
>  arch/x86/kvm/x86.c     | 6 ++----
>  2 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ad24ca692a6..e349689ac0cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7633,9 +7633,6 @@ static __init int hardware_setup(void)
>  	if (!cpu_has_vmx_tpr_shadow())
>  		kvm_x86_ops->update_cr8_intercept = NULL;
>  
> -	if (enable_ept && !cpu_has_vmx_ept_2m_page())
> -		kvm_disable_largepages();
> -
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
>  	    && enable_ept) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 144143a57d0b..b40488fd2969 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9884,11 +9884,9 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		ugfn = slot->userspace_addr >> PAGE_SHIFT;
>  		/*
>  		 * If the gfn and userspace address are not aligned wrt each
> -		 * other, or if explicitly asked to, disable large page
> -		 * support for this slot
> +		 * other, disable large page support for this slot.
>  		 */
> -		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1) ||
> -		    !kvm_largepages_enabled()) {
> +		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
>  			unsigned long j;
>  
>  			for (j = 0; j < lpages; ++j)

MMU code always explodes my brain, this left me wondering why wasn't the
original vmx_get_lpage_level() adjusted before...

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

