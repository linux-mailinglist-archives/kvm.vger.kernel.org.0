Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF803BD6AD
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhGFMmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231730AbhGFMg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625574828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJLDkY2gPeOkvFS4cKNtvwysWqnJZP3On3EDRZyLY2Y=;
        b=YiixaekAtgOGJTogJaa1sfrZOY8AzbnVkmEk5KfhguwZIjDqZIRE1WWaWif94UkTc98jJ2
        14qAbqkoXuXze0WoFA+KIpYtpxqLbzFLYIjpgzKc0Omf+Ht+z4ok8RFRcDS5o9OW69IlfE
        JDt4Nnm/SwRopCfDbLvHjLbm6TQR36A=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-LVd5PIe2MESZv2kJuhijMw-1; Tue, 06 Jul 2021 08:33:47 -0400
X-MC-Unique: LVd5PIe2MESZv2kJuhijMw-1
Received: by mail-ej1-f69.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso5754292ejp.3
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 05:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJLDkY2gPeOkvFS4cKNtvwysWqnJZP3On3EDRZyLY2Y=;
        b=AwfNnw/Rb2v0JHzDi60+wnvSiPnjT1QcgrrDhWq/bOoBwZVvmEnLrvL9xuxTDLKUyC
         W1g1Mcgy1TMnQGV+Avo6wmnzuJRqEhoaK6szzKxLlhIp23U0QcxC1N2M3y7Q6kDz83tm
         CQqqLHW4NIolL0Qzw7SjgdfM6Hxl1+1JvwX3wYyOVJF9elbWtddyqFCIF8uVk3KpdDRg
         tqKrTZ0scJQqJxpg9Rk/H/rcPLZBrX8PQ3Czgi9CTT2x+cyhMI1LpjRb5W7D+rMBTvgq
         tRm84mxIVmnaT1DySCvipA5t2unKtoY0ln9q7BRUlBz1DWp8RERKGCJplZBAtn4Wljbe
         dO/g==
X-Gm-Message-State: AOAM531TeqkznPIo9orA7WF5m1IhkH/LSwA03OxnSr3xGDd/FEYEqZIP
        LAIxHE5/BkiEw6oqfwQyugAjkTjGHc99SLFXL1gwLgdrj1T8LgFrU0VBFneJ5QKQ9r7kqSy9tLg
        ynsvKir3euueb
X-Received: by 2002:a50:ed82:: with SMTP id h2mr22762110edr.165.1625574825854;
        Tue, 06 Jul 2021 05:33:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrGvPa3AW6VZ51OAEcOUS0D09XGWsEEMzPBFmzWvZmeih97PLkwzzf0GvX9ZuaFSxWSaqFmg==
X-Received: by 2002:a50:ed82:: with SMTP id h2mr22762082edr.165.1625574825715;
        Tue, 06 Jul 2021 05:33:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s7sm5884278ejd.88.2021.07.06.05.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:33:45 -0700 (PDT)
Subject: Re: [RFC PATCH v2 03/69] KVM: X86: move out the definition
 vmcs_hdr/vmcs from kvm to x86
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <62b61eb968f867518aedd98a0753b7fd29958efb.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ecb20c33-0f45-2c96-24bd-3099891bbb97@redhat.com>
Date:   Tue, 6 Jul 2021 14:33:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <62b61eb968f867518aedd98a0753b7fd29958efb.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This is preparation for TDX support.
> 
> Because SEAMCALL instruction requires VMX enabled, it needs to initialize
> struct vmcs and load it before SEAMCALL instruction.[1] [2]  Move out the
> definition of vmcs into a common x86 header, arch/x86/include/asm/vmx.h, so
> that seamloader code can share the same definition.
> 
> [1] Intel Trust Domain CPU Architectural Extensions
> https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf
> 
> [2] TDX Module spec
> https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/vmx.h | 11 +++++++++++
>   arch/x86/kvm/vmx/vmcs.h    | 11 -----------
>   2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..035dfdafa2c1 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -17,6 +17,17 @@
>   #include <uapi/asm/vmx.h>
>   #include <asm/vmxfeatures.h>
>   
> +struct vmcs_hdr {
> +	u32 revision_id:31;
> +	u32 shadow_vmcs:1;
> +};
> +
> +struct vmcs {
> +	struct vmcs_hdr hdr;
> +	u32 abort;
> +	char data[];
> +};
> +
>   #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
>   
>   /*
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 1472c6c376f7..ac09bc4996a5 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -11,17 +11,6 @@
>   
>   #include "capabilities.h"
>   
> -struct vmcs_hdr {
> -	u32 revision_id:31;
> -	u32 shadow_vmcs:1;
> -};
> -
> -struct vmcs {
> -	struct vmcs_hdr hdr;
> -	u32 abort;
> -	char data[];
> -};
> -
>   DECLARE_PER_CPU(struct vmcs *, current_vmcs);
>   
>   /*
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

