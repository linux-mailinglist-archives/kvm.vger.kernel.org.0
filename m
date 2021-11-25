Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22045E1D5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbhKYUxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242404AbhKYUvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:51:45 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92905C06175A;
        Thu, 25 Nov 2021 12:48:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v1so30247273edx.2;
        Thu, 25 Nov 2021 12:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b7EFiuj7K2e0+37HC3ZL1/QOQUOX4faz2G6FqKq7a10=;
        b=SsfAgyvalk6mPWrobYQLcTdcfIW3I9Ub9dtg1WOyxlFxBZeBojvoI5eJ9gi8M+EBD8
         7aG5bphpb4bjWv9dAmMlWDt1v3aE2V6WQBlfJ03b76No1nUBLUwzC4kzcbrtUYj27EIB
         Q0CWL5N0qPN1cD+A69rrwuEozZf+hlaWHB1gTmpOHjDw6H3FrE54TGUk7NKu+yQ5Nczg
         mdBqlt4SYlsjnzJLWb9UURLEwam5Qk/oEIcK8S+FqUS4rrDjPR0zfj0AJiJHwAKYRqth
         BVy2YTNWDmf02lwtNfGVMnC8SjaR4VNl9XKRmr5pbvd1kVrI8oDjjzKeE6BKFrYI5XIf
         f81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b7EFiuj7K2e0+37HC3ZL1/QOQUOX4faz2G6FqKq7a10=;
        b=kA44dY47lBAIJ2B5Ejt3VqBuZnitsosdW/WkQC0icJq4AdFU6yWuEFbEcBa4qU6osu
         UquivGOryD4MzjngbgfLvyIOjyXLjgK/GXuYq2ZoUywLpj5CIH3TOPwNlxbmaI3ZQwVn
         wY5so90wta8s1ecaw1cvp5e1Q0KTIy05aB49TXE22VX9pVYnpQ9OITJ63XVsfZnclZ7J
         YZtOuQ6+6mk7eq43z0OcAgaf84+Jx8kfYHJIJnk0ngZJg4r/HspycDJTXWqL8if1iI8u
         VocjOo3dYaCGmf+xx8/7cPezYPuyskTWgWSu/Z2vO98xeJ2+ehSICqlHZ1ndGAu7Nb9/
         J0jw==
X-Gm-Message-State: AOAM531TZhsUVEBGmhNTe4D76ppMdRGCIQmepbI2rz8L0O7YTgEL6b53
        NebPcql/VDmizN1k3x47zNGy21b91Is=
X-Google-Smtp-Source: ABdhPJzTtWOkAd4Ryd+jwHVRFeUDqE8mMxCBoghNECyzqAp9gKSaNftNl+OQwRNsaXjN3tRWde7kDw==
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr41908628edc.103.1637873311140;
        Thu, 25 Nov 2021 12:48:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id he17sm2060462ejc.110.2021.11.25.12.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 12:48:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d2437c7c-1276-9c8a-8dbb-218ade7c91d1@redhat.com>
Date:   Thu, 25 Nov 2021 21:48:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Content-Language: en-US
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 01:20, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li<xiaoyao.li@intel.com>
> 
> Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
> for kvm_arch_vcpu_create().
> 
> This field is going to be used by TDX since TSC frequency for TD guest
> is configured at TD VM initialization phase.
> 
> Signed-off-by: Xiaoyao Li<xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>

Probably some incorrect squashing happened here, since...

>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/vmx/tdx.c          | 2233 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              |    3 +-
>  3 files changed, 2236 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx.c

This patch does a bit more than that. :)

Paolo
