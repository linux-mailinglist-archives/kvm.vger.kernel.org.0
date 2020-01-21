Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF06143935
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAUJOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 04:14:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725789AbgAUJOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 04:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579598060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t567CbMgA9338UWtr+w2ck6M2sm+WFvSEhuhDePLGcE=;
        b=R5dVhzNLZOfmt0xHFXVBSsJ0aRK/PIk0VWK1VPox3p1+oI3qhG4yCrJZMpnO25q5p9Djie
        YwX6I9ajhd3tssOVwn/JGMncuywyhnI47OHX56CqX2lT8kHGyPRPsKWh8RYgR7za7zlK4h
        ZMDVYCwfnvCoTFOtIoJnsNcpeQoZJKE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-65_Iay4pOOanXiZtbpqcmQ-1; Tue, 21 Jan 2020 04:14:19 -0500
X-MC-Unique: 65_Iay4pOOanXiZtbpqcmQ-1
Received: by mail-wm1-f69.google.com with SMTP id n17so237699wmk.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 01:14:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=t567CbMgA9338UWtr+w2ck6M2sm+WFvSEhuhDePLGcE=;
        b=hlV0lM8TMjk9n9TVNJMsQMmYQ4V06wpY8jcTrjibVSz9tYIzSC7XCclOIlcP/wCZ+J
         e6M/OWkVdzssxJ3EkvhVBBrYMJgTG1TAb4rWihO2EEM4nxMo7AP8ASjFSDZHH0pti891
         nROzmICIWHdYRXO7Vcd1h+8Yn6uiaixB6JZ4qGWo6GXkxMBhi8m/kHg+HQr9OTGtuqke
         sFelpRTgp1yVWDxbPWJicl+i35AVCRTmDclJZ8eL6wcAi407mFHHdFUsRKnlt8DNZVFa
         dTonuLM9q9rkdTC+RIBtk0oICoNVIbjDXak25zD0qWOsME4VyUaGyXRkatTf6QDjqfES
         v7Hg==
X-Gm-Message-State: APjAAAUxaJuq0OHNQ5G8xXntUj0AMB7IU7plOlHzaSXhJD2MvMevRw12
        gFTX1MoztfVQERHZpVY8lYGyA6usiea+Plj3r3K6vka/44ytlPuz/v4G7tULZUF7EHxmWq7TYAY
        WbDsQJ6SSX2yw
X-Received: by 2002:adf:edd0:: with SMTP id v16mr4026372wro.310.1579598058560;
        Tue, 21 Jan 2020 01:14:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKY3be808KwDxDQnSOCDMPaR4S7dKImMyC2RkCvhOEp+act0tw14nv6fN+cok8F0tDj6w5qw==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr4026354wro.310.1579598058342;
        Tue, 21 Jan 2020 01:14:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t8sm51641178wrp.69.2020.01.21.01.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 01:14:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     linmiaohe@huawei.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: VMX: remove duplicated segment cache clear
In-Reply-To: <20200121151518.27530-1-linmiaohe@huawei.com>
References: <20200121151518.27530-1-linmiaohe@huawei.com>
Date:   Tue, 21 Jan 2020 10:14:16 +0100
Message-ID: <87eevtf9xz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Miaohe Lin <linmiaohe@huawei.com> writes:

> vmx_set_segment() clears segment cache unconditionally, so we should not
> clear it again by calling vmx_segment_cache_clear().
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b5a0c2e05825..b32236e6b513 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2688,8 +2688,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
>  
>  	vmx->rmode.vm86_active = 0;
>  
> -	vmx_segment_cache_clear(vmx);
> -
>  	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
>  
>  	flags = vmcs_readl(GUEST_RFLAGS);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

