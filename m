Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692C42FAB94
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbhARUdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388579AbhARUdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 15:33:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611001932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnd9UYXeayu93vqSZFMjHfttOu7XAptPBbeNJT44DOc=;
        b=Nt6YG0Cgk/n06E5yBnKxAHDd4VkPkAdr6vkJXzdX7gSTUVV9oHCsuU4VawbpxExTbO6r6V
        VZ3PnoaMOph7qAIZW7e6xzXx/ayB4PG1nXYGSEA+BDUhiyDpTAVufXcrYsXkxOMOs2sGmh
        uXFEXtdvgY9ZJyLrP850uoMbQdwqhBE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-jQbGa8qeM66M1LojitJ7jg-1; Mon, 18 Jan 2021 15:32:10 -0500
X-MC-Unique: jQbGa8qeM66M1LojitJ7jg-1
Received: by mail-ej1-f69.google.com with SMTP id z2so1161773ejf.3
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 12:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnd9UYXeayu93vqSZFMjHfttOu7XAptPBbeNJT44DOc=;
        b=d5Z/kEoGbjeo0ALRqLV65HJbf36kN3KQh/trWUyNUKihNWNozjhM39C+eobpsv4uVJ
         zfInrOqdNVCO2KrQTpC26ModnUgB2e0ERryYmxLXp7N900uJCnpe/opY6niV0Op79dBE
         Rhh4NAPMlD00odo0+Pj/sCMs7wt202TpuIQpqnAx2VCV+fx0szckpFUMWrMmagarzOiq
         SKzv48pnahCTbXFIg5TgZof1erR8Yn+OLF9eIDnxvh3DsmDv3vBK0FQNXhavtffqzoeV
         +G8knYqsDC8jbu9t9lICH/AlpnIcl4KVHQdrAic9ZCGrOqOB0N9lmViJjDOwHFtXmMjB
         c8JQ==
X-Gm-Message-State: AOAM530mQ5ByGCjRpiZ+TV1mrjcWXRjva/45xAxN9l4DRSPoRCOk3rht
        fxmLZ70MU3pm9AwVfnmUOF7MvFKMCkkD6FQKg1jnzt1MUgRCUl7NnGbIEiykZx5AQgR3n91YlX8
        jVChl3KF6AZQ1
X-Received: by 2002:a50:a69c:: with SMTP id e28mr914592edc.139.1611001929514;
        Mon, 18 Jan 2021 12:32:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVSVkSJlecNGIkeTie5EcqZVFLyoyYXystA5v6mITGGcWISc5PaXK2JNsMIVR1a6pwAYsuUA==
X-Received: by 2002:a50:a69c:: with SMTP id e28mr914579edc.139.1611001929372;
        Mon, 18 Jan 2021 12:32:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f11sm1343946eje.114.2021.01.18.12.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 12:32:08 -0800 (PST)
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
 <20210118202931.GI30090@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f7bbd70-35c3-24ca-7ec5-047c71b16b1f@redhat.com>
Date:   Mon, 18 Jan 2021 21:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118202931.GI30090@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/21 21:29, Borislav Petkov wrote:
> On Fri, Jan 15, 2021 at 04:25:17PM -0800, Sean Christopherson wrote:
>> Introduce a new Kconfig, AMD_SEV_ES_GUEST, to control the inclusion of
>> support for running as an SEV-ES guest.  Pivoting on AMD_MEM_ENCRYPT for
>> guest SEV-ES support is undesirable for host-only kernel builds as
>> AMD_MEM_ENCRYPT is also required to enable KVM/host support for SEV and
>> SEV-ES.
> 
> Huh, what?
> 
> I'm not sure I understand what you're trying to say here and am not
> convinced why yet another Kconfig symbol is needed?

I think it makes sense because AMD_SEV_ES_GUEST's #VC handling is quite 
a bit of code that you may not want or need.  The commit message does 
need a rewrite though.

Paolo

