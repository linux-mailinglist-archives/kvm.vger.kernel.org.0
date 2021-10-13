Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB642C48A
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhJMPNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbhJMPNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 11:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634137905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0g1uQp5+rGbXrxfLTXwqievrvV6EIKzK3sIM3pZ9TKs=;
        b=fmL9RTZMr325j3tvykcFNYjHv7B51bqEOb50WAfd7nCazt6aG4nC8lNBxlls3D1/oktJ0g
        z1qPyN4uFC9iX6gsNj3ineoaQ7Q4Fvo16LZdRy/RoFHGDjj/oFyjxeFaQdnDJJJtULUdeR
        u+GxZRLBMflSnbb2YANFQ681fsXrSz8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-igAvgcOIPOe-efzAMdRDaA-1; Wed, 13 Oct 2021 11:11:43 -0400
X-MC-Unique: igAvgcOIPOe-efzAMdRDaA-1
Received: by mail-ed1-f70.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso2550695edn.4
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0g1uQp5+rGbXrxfLTXwqievrvV6EIKzK3sIM3pZ9TKs=;
        b=3mDW8/gonUgq9wmfyst29Q15+RU8kSdqtIugoHlkPNAwQQF7pMO+hgkjXMdNuLzAdI
         +jvLEJSxdEcYTawFB2DN51zEcxXSTy7E+KE0qOXYhZd/8vPsZiW4m5f5tzZKN6PkjW8t
         4Zza5rAeK0kx/D3LuxynZ54Rhnk41j0MDqMmCSadNh5zTOgEBML89jcBH6jAYw7aE4Bv
         fTZ+q/ywv4ZkpBk1lUfxP1MNE0jNr8FJegznsmB9xh89f0o7PVOcb0ObmrAkLOayNkFW
         1hQXAX986zQ6pqTLUFoc463U8KXGhnlLXAjacyCsaMPSkZgYcP+5k8AR/pg/HiAyLt0v
         /96A==
X-Gm-Message-State: AOAM533D9p8LIxsXuwCbfkSJXJkqQbVq7OFyeJ6oDx3yzUopsQSNKIUS
        DlQoyuZc4Mmo4vNKVzci4UioJjsOiSMYvyz8BCsKcFs8dAxnHh1kS9hzcIUD27FrvVGku0W7oXz
        UWrYQcUFJDimP
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr114748eje.112.1634137902454;
        Wed, 13 Oct 2021 08:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeiL2TAH+e1mlhR/iCAxD+5eZ5rlY38mxxrsDti8Miyy0J3ItGSWnn0mUU/TFTkQ1bkHw1Ug==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr114718eje.112.1634137902217;
        Wed, 13 Oct 2021 08:11:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r19sm8234847edt.54.2021.10.13.08.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 08:11:41 -0700 (PDT)
Message-ID: <d405824e-66d3-a1ec-6bcb-f560687b758d@redhat.com>
Date:   Wed, 13 Oct 2021 17:11:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 05/21] x86/KVM: Convert to fpstate
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211013142847.120153383@linutronix.de>
 <20211013145322.451439983@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211013145322.451439983@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 16:55, Thomas Gleixner wrote:
> Convert KVM code to the new register storage mechanism in preparation for
> dynamically sized buffers.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
>   arch/x86/kvm/x86.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10389,7 +10389,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct k
>   
>   	vcpu_load(vcpu);
>   
> -	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
> +	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
>   	memcpy(fpu->fpr, fxsave->st_space, 128);
>   	fpu->fcw = fxsave->cwd;
>   	fpu->fsw = fxsave->swd;
> @@ -10412,7 +10412,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
>   
>   	vcpu_load(vcpu);
>   
> -	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
> +	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
>   
>   	memcpy(fxsave->st_space, fpu->fpr, 128);
>   	fxsave->cwd = fpu->fcw;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

