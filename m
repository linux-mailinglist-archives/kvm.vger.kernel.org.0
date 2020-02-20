Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD4166326
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 17:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgBTQdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 11:33:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728289AbgBTQdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 11:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582216402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fLonCBUOUjLc0CmEPRN1BygsqRkakx9D4QOI0lbDDos=;
        b=Yy0PiBsNWBmOfqmvm+3Z7fJQn3t56xOJVjqcZzVZzwevKXhUXKe0ULYmI2UzgSvMM5e+7C
        19YUoqj0gYZ++os5LUEIGFKlWcEFBhEwVE6wTBRiYOIzgbYscSJZZbHFe7fp243OMHVOPD
        MNl+BsWE4ZC8PJnV7VWGTJbZ+5RcyKk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-WX_k009uNlmfxZNgjNTZww-1; Thu, 20 Feb 2020 11:33:20 -0500
X-MC-Unique: WX_k009uNlmfxZNgjNTZww-1
Received: by mail-wr1-f69.google.com with SMTP id o6so1964617wrp.8
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fLonCBUOUjLc0CmEPRN1BygsqRkakx9D4QOI0lbDDos=;
        b=A9Q6ukFly+Vz8AvkTImErZM1aPYP9ELyD+PYvXTcvqRGMAxVBbqrXqwcUL8Gn7KtAg
         EnKqxmhHS1oZUhk7XihqnPR/P2yURBB6nIxNf2CRQS2OB8dj/QzJu1fdoQrJdGtNifz1
         1XHZWlw5h7dZUK29t+2ZqvkoUwWzwVUsW5X0ztAcczVavp3ERQ3pKiWDGk5J2aA8CgcI
         wfCHPM1HdYVVyLD+t++oWR/VNVgmHdUBla+KWGDvQ41/+rZq6px7mieAxvT1NHxmOKew
         w9AH9S59OUtPXRMTJcSjHquxfY8enoiAaL3kWUzGJ5kp6m8LVgPV0GkM9Fow3UfuNNs0
         5M9g==
X-Gm-Message-State: APjAAAVfhCKABoZAbcQeHj0y7M+4CwdYTSHd0slWKMhCyaD+sxO+Q2YJ
        8PTY4aBTaMK1Pq/qoC13VYK6zZpyHsaXmyQhdPC7N70iMOKgGaU1UotCYwlPP1NhUpt2YgLfX+3
        fRSRwcVkovO5O
X-Received: by 2002:a1c:e007:: with SMTP id x7mr5250307wmg.3.1582216399425;
        Thu, 20 Feb 2020 08:33:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRHj5vuBzGfQvaITDv9sfER6wfON7w4T7TTLU9Vtme/FwYOA1F5VpAtAdFuc4WikvP/UsG4w==
X-Received: by 2002:a1c:e007:: with SMTP id x7mr5250287wmg.3.1582216399222;
        Thu, 20 Feb 2020 08:33:19 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 133sm5765628wme.32.2020.02.20.08.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 08:33:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: avoid calculating pending eoi from an uninitialized val
In-Reply-To: <1582213006-488-1-git-send-email-linmiaohe@huawei.com>
References: <1582213006-488-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 20 Feb 2020 17:33:17 +0100
Message-ID: <8736b56wxe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When get user eoi value failed, var val would be uninitialized and result
> in calculating pending eoi from an uninitialized val. Initialize var val
> to 0 to fix this case.

Let me try to suggest an alternative wording,

"When pv_eoi_get_user() fails, 'val' may remain uninitialized and the
return value of pv_eoi_get_pending() becomes random. Fix the issue by
initializing the variable."

>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4f14ec7525f6..7e77e94f3176 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -626,7 +626,7 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
>  
>  static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>  {
> -	u8 val;
> +	u8 val = 0;
>  	if (pv_eoi_get_user(vcpu, &val) < 0)
>  		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

But why compilers don't complain?

-- 
Vitaly

