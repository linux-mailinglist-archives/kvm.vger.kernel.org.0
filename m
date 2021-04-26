Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3B836B319
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhDZMdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 08:33:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233279AbhDZMdN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 08:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619440351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7ft+FJuoyaWZFH96qTL2gT73WOnML/rzPUiP2aXrO8=;
        b=RYihPoE9tcXVoApI2iCN3XnA3sfvwGILJufj7ZjrgVNwshf9r3vMPezcIqsR/sHHnAlube
        akbZi+RhZOMtfA4+xkKlSOB48A5lk+t8YH1QOkTrGuGCdQhc6SRMKuvUhNwVLgi7EUp2QE
        oDMBRcszbx7bky/L4Hx6owNQpbQstjI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-STJ3JLJxNSiL9O0_zNEXGA-1; Mon, 26 Apr 2021 08:32:29 -0400
X-MC-Unique: STJ3JLJxNSiL9O0_zNEXGA-1
Received: by mail-ed1-f70.google.com with SMTP id d6-20020a0564020786b0290387927a37e2so2032252edy.10
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 05:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q7ft+FJuoyaWZFH96qTL2gT73WOnML/rzPUiP2aXrO8=;
        b=pogdN1OgYtDP9iOQsX9Ll7cj4Dktw3AjsqFzB6t20MA0Z64hvPBt6BgCW+EhXQuu81
         mBYIU4vcJzrkEJUn8faWSDdaWhGKOiAzzpyM9gSxUL8kZludoX5uIAcskyiaxAjEKT+W
         6WH5CDws4OqBzWBxh2ZH2USdpZzhJBkWxr53uDcxnXXzZO2gQTjr/+wx5r2TVOvfFa3Q
         U9/zUsdultnC7XZYHdie/r61fEzEpz47VeWuzlgidB5LeGYfeS/SbEMFxCiXgTGSTgfV
         i8m/0SrUtGoVyx6wOYRIU8NRFK3mz+fjz6kgN0845FhAG5Y/QmiVf2OlxIgif5xf/QGL
         Itrg==
X-Gm-Message-State: AOAM530/J/Kdild69PhuMV3gUo+MJJgNXJo147MIaKYRYW2VeQnkkCXR
        FPsvyK/ILnmbS1TSu1h04n9Mzm4b7MfK65zD+XTg56+dBlOkFl6dOzf6KIZbBbBm+3P2sTL/Rlo
        0lJxbmcXvzkbO
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr18213038ejf.145.1619440348592;
        Mon, 26 Apr 2021 05:32:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx98SpHqrIShgDQiQwvrRqUS98bHoMpJXRGL/rNx8PhCExMvUUt8bj4tfMYahD10Bk25Oebmw==
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr18213015ejf.145.1619440348445;
        Mon, 26 Apr 2021 05:32:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y2sm2401527ejg.123.2021.04.26.05.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 05:32:27 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
 <20210426111333.967729-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/6] KVM: x86: Introduce KVM_GET_SREGS2 /
 KVM_SET_SREGS2
Message-ID: <898a9b18-4578-cb9d-ece7-f45ba5b7bb89@redhat.com>
Date:   Mon, 26 Apr 2021 14:32:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210426111333.967729-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/21 13:13, Maxim Levitsky wrote:
> +	if (sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID) {
> +
> +		if (!is_pae_paging(vcpu))
> +			return -EINVAL;
> +
> +		for (i = 0 ; i < 4 ; i++)
> +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
> +
> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> +		mmu_reset_needed = 1;
> +	}

I think this should also have

	else {
		if (is_pae_paging(vcpu))
			return -EINVAL;
	}

but perhaps even better, check it at the beginning:

	if ((sregs->cr4 & X86_CR4_PAE) &&
             !!(sregs->efer & EFER_LMA) == !!(sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID))
		return -EINVAL;

which technically means the flag is redundant, but there is some value in
having the flag and not allowing the user to shoot itself in the foot.

Paolo

