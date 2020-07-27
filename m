Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184B122F28B
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 16:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbgG0OkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 10:40:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729587AbgG0OkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 10:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595860818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izsbK+ZOKnq7dNSVt0IlxJ0IbYW71pzFLmCjbU4plCU=;
        b=RqDt+MsweS6EvRG9tfmqUpufgUqnG+n5cqkctIwXoQ7L+bxHWqTPXEDiEZSxtRxNcQIz5p
        T0hyaF2Ptc2tAVy3WWUa1As20J+YA/gJfznyAwdS1UyrRR1/dU86Ttnq3Kp8taB0GYXECA
        tSiD2pcnn2jXXTzw3lQGvQXU2cOspVo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-a1f61aY3MF26s_bcPsMxjQ-1; Mon, 27 Jul 2020 10:40:15 -0400
X-MC-Unique: a1f61aY3MF26s_bcPsMxjQ-1
Received: by mail-wr1-f70.google.com with SMTP id e14so579591wrr.7
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 07:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izsbK+ZOKnq7dNSVt0IlxJ0IbYW71pzFLmCjbU4plCU=;
        b=XoNvk0JTAEnvJUnPQen+tRAexsMxT5jsmFhP/E7aUasmkHPah57k89MlBFVL1Bpaz2
         4FlWsqnBSleRzdUiznrQ64/T8QiE2e4yXbp9jbrvl4iTiojeTUajmhB+wwMDy5GiO+V+
         4uFd5uyNJngGrYa34318x8VH4Kb6kiXQhwhsWxONYKlwOm54jHzvrQJBAK/zSdMhqKIh
         HwSMcfwbP/QcJkxnTIEBLrllXkUDWZoBAxVIzTzBKGo+WLU6iZcLfUj0Nrcegj4kQu7C
         xKFYMBqtcH8UBp0+mFF/nPVvJhUEVhw0Luifr1NYiJ6oX6yZHKD+LLqgFv6UXtIn3kE3
         KXqg==
X-Gm-Message-State: AOAM530HOPxqep3e9/QJwxPZXe4ESMRG/3/SME5F73s6vnM3VyT3KQ1f
        dbH69casFiysp1OEsNm4yia1mtcqarXlt2dhsWMveu8u3u4DhSRC7mtp1GOoJxdVAFjRFx8tWx1
        FOc610B4XPKUA
X-Received: by 2002:a1c:5982:: with SMTP id n124mr20918666wmb.77.1595860814726;
        Mon, 27 Jul 2020 07:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgZuIogu5hzxAcWaxVai3d/DsyPRSUKU7GcLo+4TZTFJ/k5uN+y5FA8hkMBW9RTUIKGPi0nA==
X-Received: by 2002:a1c:5982:: with SMTP id n124mr20918640wmb.77.1595860814402;
        Mon, 27 Jul 2020 07:40:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4502:3ee3:2bae:c612? ([2001:b07:6468:f312:4502:3ee3:2bae:c612])
        by smtp.gmail.com with ESMTPSA id z127sm4591641wme.44.2020.07.27.07.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 07:40:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: Using macros instead of magic values
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, mingo@redhat.com,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
References: <4c072161-80dd-b7ed-7adb-02acccaa0701@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92cd8fd2-d838-a1e3-dc39-7e6e5c4e68ca@redhat.com>
Date:   Mon, 27 Jul 2020 16:40:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4c072161-80dd-b7ed-7adb-02acccaa0701@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/20 10:23, Haiwei Li wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> Instead of using magic values, use macros.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 47801a4..d5fb2ea 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2083,7 +2083,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic,
> u32 reg, u32 val)
> 
>      case APIC_SELF_IPI:
>          if (apic_x2apic_mode(apic)) {
> -            kvm_lapic_reg_write(apic, APIC_ICR, 0x40000 | (val & 0xff));
> +            kvm_lapic_reg_write(apic, APIC_ICR,
> +                        APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>          } else
>              ret = 1;
>          break;
> -- 
> 1.8.3.1
> 

Queued, thanks.

Paolo

