Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25D45E8EC
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 08:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359252AbhKZICU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 03:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244652AbhKZIAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 03:00:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8746DC061748;
        Thu, 25 Nov 2021 23:57:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t5so35535906edd.0;
        Thu, 25 Nov 2021 23:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xVmmFD53SJ7PAnxPXhXSC2iqJgq0Jvekhj0t+s7AyaU=;
        b=FTL6dnLrUTwY/7rxSMfQXftU8kZycSuCvNLCn4RCM9UWZEhyz8YijN+E9dNJsN/LnC
         K9/n6Mw5S+roeS9WIRu4SYgXxlQs5pU4uxTcZVOcFvLwkDCrsm7slJIgaJMPwkcULGSq
         fWLTde4vsPoSGp7S75DzTJZgnJ9lCQLGVCK1rKISxiIpy/KcdEj3zxo7z++eAZ0JYNTR
         Cb6VqHYrb7rE8WKgFfrR17ckiMjprdO1s3zSFQq3n+Ew7E///SR4Ft0L0XKhBYn4+NOB
         7cZIWHl0eDHznmV6Qw+wm2dJpgB0aDRW0R8yjp6gjXQj9q339Yy5cb8CME4qHEl0z5hM
         OwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xVmmFD53SJ7PAnxPXhXSC2iqJgq0Jvekhj0t+s7AyaU=;
        b=srVllVQ8Z7CqmrueOFGx4wVjs7oD+qPg9ZCyiS3YVKjTXHI//Uwxy/368yDeFup2wB
         E/xuC4kKTWkFXZyQYohUdgLlniqMuP6VMDixcYEhg5pxNIAwYOaDKWQYV6CgiIsHuHbT
         Yi47SgbKBpHF/3DrztxZO6GTp8Jdncrz/IIclp3KWXpWq6dPLeLo5Ma8Bt95QvMTXTgb
         APIpwkn5ep+PUad94Mz9OTo/Vze+e2JPmwtJkS45RLfDtDR6En9VwvyUw+5Kh5iykYcD
         PnanQ3zsCqowXnWDgk/XwlQ9WlO+UC0wlmqlo31hRhfPxlXJmEp+GvIlAaAP1uGZmn8b
         BSTw==
X-Gm-Message-State: AOAM531NmmDtZy0Zramm++w/Au6bL13kDwLk2gWaHAiR/uZ+vwruGxMm
        Bzi3FFenx6ZN1sz3vnolGvM=
X-Google-Smtp-Source: ABdhPJyDz71af7EXgWAaGgYwa2idTzNkbdSFiRbkPP2U0d2sbxmNputA7cWH5t5IlEDL2bX2eElpbA==
X-Received: by 2002:a17:907:c03:: with SMTP id ga3mr36176792ejc.180.1637913425099;
        Thu, 25 Nov 2021 23:57:05 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id g21sm2624155ejt.87.2021.11.25.23.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 23:57:04 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d8b3c2cb-f0a0-52dd-2dfd-64fa190dd372@redhat.com>
Date:   Fri, 26 Nov 2021 08:56:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
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
 <875ysghrp8.ffs@tglx> <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
 <87tufzhl56.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87tufzhl56.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 00:26, Thomas Gleixner wrote:
> Paolo,
> 
> On Thu, Nov 25 2021 at 23:13, Paolo Bonzini wrote:
>> On 11/25/21 22:05, Thomas Gleixner wrote:
>> If there are some patches that are actually independent, go ahead and
>> submit them early.  But more practically, for the bulk of the changes
>> what you need to do is:
>>
>> 1) incorporate into patch 55 a version of tdx.c that essentially does
>> KVM_BUG_ON or WARN_ON for each function.  Temporarily keep the same huge
>> patch that adds the remaining 2000 lines of tdx.c
> 
> There is absolutely no reason to populate anything upfront at all.
> Why?
> 
> Simply because that whole muck cannot work until all pieces are in place.

It can, sort of.  It cannot run a complete guest, but it could in 
principle run a toy guest with a custom userspace, like the ones that 
make up tools/testing/selftests/kvm.  (Note that KVM_BUG_ON marks the VM 
as bugged but doesn't hang the whole machine).

AMD was working on infrastructure to do this for SEV and SEV-ES.

> So why would you provide:
> 
> handle_A(...) { BUG(); }
> ..
> handle_Z(...) { BUG(); }
> 
> with all the invocations in the common emulation dispatcher:
> 
>    handle_stuff(reason)
>    {
>          switch(reason) {
>          case A: return handle_A();
>          ...
>          case Z: return handle_Z();
>          default: BUG();
>          }
>    };

If it's a switch statement that's good, but the common case is more 
similar to this:

  vmx_handle_A(...) { ... }
+tdx_handle_A(...) { ... }
+
+vt_handle_A(...) {
+    if (is_tdx(vcpu->kvm))
+        tdx_handle_A(...);
+    else
+        vmx_handle_A(...);
+}

...

-     .handle_A = vmx_handle_A,
+     .handle_A = vt_handle_A,

And you could indeed do it in a single patch, without adding the stub 
tdx_handle_A upfront.  But you would have code that is broken and who 
knows what the effects would be of calling vmx_handle_A on a TDX virtual 
machine.  It could be an error, or it could be memory corruption.


> In both scenarious you cannot boot a TDX guest until you reached $Z, but
> in the gradual one you and the reviewers have the pleasure of looking at
> one thing at a time.

I think both of them are gradual.  Not having the stubs might be a 
little more gradual, but it is a very minor issue for the reviewability 
of the whole thing.

Paolo
