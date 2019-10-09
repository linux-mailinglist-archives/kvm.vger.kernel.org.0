Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5504D1AA3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 23:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfJIVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 17:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729865AbfJIVNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 17:13:37 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 844DAC054C58
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 21:13:36 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id k184so1614161wmk.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 14:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4srZFXoAl41HjwhPn0PJA307c6SlqrVerXwZloWaCYs=;
        b=b9+KEyWf6xhud5XKOV8+O4JhQWN6YC9yWdamcnJahS5U16MdBCSmlfgWyPw7uGTTXs
         AqIuEFwx4+tk9r3qSY0bTaRaf0lq0NGLvuvscUvtIQ+kVuxHvvNf5oA+Rsme/5gUDZGK
         xhzim2BvPXzU7j8wmOdeZ1EPaEcApVSrmB+/bpSbSLSv1gWTuUxV3/7TapIOb3srtEnB
         NLFzSozVlgzQme42pX51upZlMGo0csHJVu6vXUY3ItAMJNaCOa6pDQAeha6pzHafz2Nk
         LuyjXtKrbsl1x++KAysWRGgxzP/CFVVgbewYy/PlPKsF7D6P+Lm9w18JcmZq/zF2JDYd
         fiGw==
X-Gm-Message-State: APjAAAXf8wSkp6uQVmZ1nXU1Ip81rTYyY8AArJGyvC6d9jETBy7hzDNv
        k/Fbicx7wv3Zo5wuS+9KE3xO3V7MkxCLqRxc6/yMk2AtY6Xd/vs1UzF73qW1aYm8YKnaTB5Qlcs
        6OcQUEWKC8tCY
X-Received: by 2002:a05:600c:21c8:: with SMTP id x8mr3881365wmj.123.1570655615061;
        Wed, 09 Oct 2019 14:13:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2AbIvADQSSyhOiJlB+z4XqKp1hB0A+xqyOScWcvgzaR5G5AnV7fVPrUgvzkI0EucrzYJUlw==
X-Received: by 2002:a05:600c:21c8:: with SMTP id x8mr3881331wmj.123.1570655614775;
        Wed, 09 Oct 2019 14:13:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1032:7ea1:7f8f:1e5? ([2001:b07:6468:f312:1032:7ea1:7f8f:1e5])
        by smtp.gmail.com with ESMTPSA id b22sm3460841wmj.36.2019.10.09.14.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 14:13:34 -0700 (PDT)
Subject: Re: [PATCH 11/16] x86/cpu: Print VMX features as separate line item
 in /proc/cpuinfo
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-12-sean.j.christopherson@intel.com>
 <55f45459-47bf-df37-a12b-17c4c5c6c19a@redhat.com>
 <20191007195638.GG18016@linux.intel.com>
 <bd2cffea-6427-b3cc-7098-a881e3d4522d@redhat.com>
 <20191009191659.GE19952@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a6007c5e-a91d-0f4a-7432-aab46bb52763@redhat.com>
Date:   Wed, 9 Oct 2019 23:13:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009191659.GE19952@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 21:16, Sean Christopherson wrote:
> On Tue, Oct 08, 2019 at 08:57:30AM +0200, Paolo Bonzini wrote:
>> On 07/10/19 21:56, Sean Christopherson wrote:
>>> On Mon, Oct 07, 2019 at 07:12:37PM +0200, Paolo Bonzini wrote:
>>>> On 04/10/19 23:56, Sean Christopherson wrote:
>>>>> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
>>>>> index cb2e49810d68..4eec8889b0ff 100644
>>>>> --- a/arch/x86/kernel/cpu/proc.c
>>>>> +++ b/arch/x86/kernel/cpu/proc.c
>>>>> @@ -7,6 +7,10 @@
>>>>>  
>>>>>  #include "cpu.h"
>>>>>  
>>>>> +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>>>>> +extern const char * const x86_vmx_flags[NVMXINTS*32];
>>>>> +#endif
>>>>> +
>>>>>  /*
>>>>>   *	Get CPU information for use by the procfs.
>>>>>   */
>>>>> @@ -102,6 +106,17 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>>>>>  		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
>>>>>  			seq_printf(m, " %s", x86_cap_flags[i]);
>>>>
>>>> I'm afraid this is going to break some scripts in the wild.  I would
>>>> simply remove the seq_puts below.
>>>
>>> Can you elaborate?  I'm having trouble connecting the dots...
>>
>> Somebody is bound to have scripts doing "grep ^flags.*ept /proc/cpuinfo"
>> or checking for VMX flags under some kind of "if (/^flags/)", so it's
>> safer not to separate VMX and non-VMX flags.
> 
> Are the names of the flags considered ABI?  If so, then the rename of
> "vnmi" to "virtual_nmis" also needs to be dropped.  :-(

Yes, they are. :/

Paolo

