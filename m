Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF5D162619
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 13:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgBRM1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 07:27:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57143 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbgBRM1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 07:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582028836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJoYrV36o0Jp2itIALA0xT10zJEIaPxDyqdHnxgNlsI=;
        b=QBcKKR8hVfpdflP3lcDBOn9GH8ZQ474wmGKRaON15i2xcbsj6mik9xtVDLCnbbkPOCguBd
        XruLsK+aOqXYJiTBLppZsrG2yyclZh1mlMlGkjE6IlKCziQ9Wv5meWgEw4pWrwWM+3k6ws
        iFGHbLXe+Ua0kD8kIP1o7n5w9J9ajX8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-icsIzmfUMhW7M-3j9QYSCg-1; Tue, 18 Feb 2020 07:27:15 -0500
X-MC-Unique: icsIzmfUMhW7M-3j9QYSCg-1
Received: by mail-wm1-f70.google.com with SMTP id 7so958102wmf.9
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 04:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IJoYrV36o0Jp2itIALA0xT10zJEIaPxDyqdHnxgNlsI=;
        b=p3gjiO5qR9atzAqFd975F5gvuC31fXBP4ySoIX0Dtdv7S0rX4G8OnT6XBofwdhBwl0
         heBLOimJ6JO3LooeTl0Y+qpV2217kBoAlLnkkQ3Wn+L7iqOWHURAArQVlmKT0SJxjR0t
         38Wk3SF358XMGlk97A5Vmeq8i4RZcDS3w0bpRGcBsevWfhKOsEQ0c0GhukdAltr9Woln
         qEpR+O0Lvo1vYsOhSTELBf8ewhFPP8dBsoj+wgTlcDXvhUe2UsbSet+bjFrvUkVwe9Zu
         IU2NvYmC1qdLkgFyNXSZvGKChNKhGqEe/71nSJPFMv231ft8QYQaaoMxyc40mYFLaXoY
         O05Q==
X-Gm-Message-State: APjAAAVex+imcNqzj1t3l/ZdSzEWTDOIVKUW/W+QzDgXOO8sRchncEj2
        9l7ZwcVljtdO3VJ6sJMhmsjGGGhKbkAnB4hiuPvEtZptKvdhuDpqlylKMkADyjRC8ddcWTXbLk+
        +6ggRzi06uNo1
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr3076990wmd.90.1582028833198;
        Tue, 18 Feb 2020 04:27:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvdlcchraOkrSBJTxKY095h9HvMXtDI0WHiTHKtLH8hgQpaECMShQ1zGl1NVLObBHJBUIQjA==
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr3076948wmd.90.1582028832898;
        Tue, 18 Feb 2020 04:27:12 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b67sm3315284wmc.38.2020.02.18.04.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 04:27:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: rename apic_lvt_vector and apic_lvt_enabled
In-Reply-To: <1581995825-11239-1-git-send-email-linmiaohe@huawei.com>
References: <1581995825-11239-1-git-send-email-linmiaohe@huawei.com>
Date:   Tue, 18 Feb 2020 13:27:11 +0100
Message-ID: <87tv3o84io.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> As the func apic_lvt_enabled() is only used once with APIC_LVTT as the
> second argument, we can eliminate the argument and hardcode lvt_type as
> APIC_LVTT. And also rename apic_lvt_enabled() to apic_lvtt_enabled() to
> indicates it's used for APIC_LVTT only. Similar as apic_lvt_vector().
>
> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index eafc631d305c..4f14ec7525f6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -289,14 +289,14 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
> -static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
> +static inline int apic_lvtt_enabled(struct kvm_lapic *apic)
>  {
> -	return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
> +	return !(kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_LVT_MASKED);
>  }
>  
> -static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
> +static inline int apic_lvtt_vector(struct kvm_lapic *apic)
>  {
> -	return kvm_lapic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
> +	return kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_VECTOR_MASK;
>  }
>  
>  static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
> @@ -1475,10 +1475,9 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
>  static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
>  
>  	if (kvm_apic_hw_enabled(apic)) {
> -		int vec = reg & APIC_VECTOR_MASK;
> +		int vec = apic_lvtt_vector(apic);
>  		void *bitmap = apic->regs + APIC_ISR;
>  
>  		if (vcpu->arch.apicv_active)
> @@ -2278,7 +2277,7 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (apic_enabled(apic) && apic_lvt_enabled(apic, APIC_LVTT))
> +	if (apic_enabled(apic) && apic_lvtt_enabled(apic))
>  		return atomic_read(&apic->lapic_timer.pending);
>  
>  	return 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

