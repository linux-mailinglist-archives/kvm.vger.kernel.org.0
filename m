Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968EC1682F8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgBUQOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:14:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728299AbgBUQOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:14:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582301649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sG/qxfL50KvHqT7UfD+irY9EmnZdcQz1VfBLgZqPoxs=;
        b=iRr5f2G6w5ZhNFN3KIwSi1kcCP8wRmI4UG5x7tXqgy6WpGc44VA+CHOjUBU0RfyFVonVVq
        0D6W1L3k5UGhWX5psPd/dMCBYYIgWtNrRGf/RaWQllB/+061lVTkL86JyCJ2cCQylomCwP
        amnBetO2exkZzbXoVP/V4/1/bAIciHM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-1rZEBZ9EPguLoxblXMrl9w-1; Fri, 21 Feb 2020 11:14:07 -0500
X-MC-Unique: 1rZEBZ9EPguLoxblXMrl9w-1
Received: by mail-wr1-f72.google.com with SMTP id p8so1232870wrw.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:14:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sG/qxfL50KvHqT7UfD+irY9EmnZdcQz1VfBLgZqPoxs=;
        b=W2uKO82VaKXIHybbMTAoD9BfTHfvrQkx7Yd1KsvT4QEwniM8SO2hKaiykMy/47OCW3
         8606xcenV3t2lDGvUaXeWXQmtYt++L3SutDRgJx+gYuhh+4bJIqCF88vW744S08g9cSd
         ixH3rYVn4VqWfn0YLNj0ncI76FMVrUkQc7gXfgjVm+mTVa+Z7zKJrz2qZF3STYEX8Rmh
         VMbQ9ac6SXMvtbXx99BWK2qT+cHc6Wo+qjuwPbddb9P/YmMKP/1hnJuhBsK1c9vU0jfa
         N2IBhE6RrVXyU6dJZp0Cfb46bHxYwHN5oaJc2PHFOdCEmJvgfRAHdegcqLOBwW5PSRN6
         GCTQ==
X-Gm-Message-State: APjAAAWOgEXAVfbi/86fhYvj/4EkbVM6Ay/RSXGhfX84mZsUkGd0XK6h
        wM1nzKTIsK6QZ5hVW9vkqH2azOVDMewPaYbRzdybuI4OhX+W3wz2jO+Ps3NKNKgp0gb+uVy0wLR
        AQYbtKPMuiRSE
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr4605532wmg.86.1582301646487;
        Fri, 21 Feb 2020 08:14:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqwke2sDU6jfLxQYJRrrHGm8vyfSBWYb99TFtIKX5F/sdOW44JfeZnpvYOIhr+mQWgUjE1ASJw==
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr4605492wmg.86.1582301646173;
        Fri, 21 Feb 2020 08:14:06 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 4sm4205116wmg.22.2020.02.21.08.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:14:05 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: apic: avoid calculating pending eoi from an uninitialized val
In-Reply-To: <1582293886-23335-1-git-send-email-linmiaohe@huawei.com>
References: <1582293886-23335-1-git-send-email-linmiaohe@huawei.com>
Date:   Fri, 21 Feb 2020 17:14:04 +0100
Message-ID: <8736b3rk8j.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When pv_eoi_get_user() fails, 'val' may remain uninitialized and the return
> value of pv_eoi_get_pending() becomes random. Fix the issue by initializing
> the variable.

Well, now the 'perfect' commit message doesn't match the patch :-). I
think you (or Paolo upon commit) can just drop the last sentence.

>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v1->v2:
> Collect Vitaly' R-b.
> Use Vitaly' alternative wording.
> Explicitly handle the error, as suggested by Sean.
> ---
>  arch/x86/kvm/lapic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4f14ec7525f6..b4aca77efc8e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -627,9 +627,11 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
>  static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>  {
>  	u8 val;
> -	if (pv_eoi_get_user(vcpu, &val) < 0)
> +	if (pv_eoi_get_user(vcpu, &val) < 0) {
>  		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> +		return false;
> +	}
>  	return val & 0x1;
>  }

-- 
Vitaly

