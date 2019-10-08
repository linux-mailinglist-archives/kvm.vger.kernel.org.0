Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C9CF315
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 08:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfJHG5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 02:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfJHG5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 02:57:30 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C00B7FDF0
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 06:57:29 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id v18so8640021wro.16
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 23:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQeVN1hH98xgpYnMm68phCOZgGPtIs2VOwfxn1PaBbs=;
        b=CY0ku7ipQfptVlRvTTRBjdQbZTLfTi85umOuMj4hkwReRepU4mAPyvOQfG3vae/hGh
         2Se1w+iF6zQBKYUSc5jyl7/XPTLvFVY+D0b09K7XyElHsQOj30GrGiSEEHWjcd768D2u
         vTkfaIWBDXPSHyqPyDAlE9q8lkJJXjFmGjTZErzitrcmIh0jqJFk++qUYlVETjSdOpkg
         YR1tWneaT1mijCUtGNLb4QfH2C3XP3zESExBSqM/4jHQ/eK6pKxHniI8/oT/BSYXglUI
         06cs9rI+kRWrCCoOokpMbkgOVjxvI7gdNrt5BJJTzio0ETAyT3I00VG10xxEdYCPcKiQ
         2nJQ==
X-Gm-Message-State: APjAAAWRvlIhuCmHN3Z9taAnyjRYImQA7QxCijqtsVyzGO7qmlQQicWB
        wyBdHm8lLvp4LorKuWHixQdgE3lIbcnG1f1110lO27wWRi6z3lz9iMyWNoKgDI6+NJccpqbDcb+
        hWAruarU/NJy9
X-Received: by 2002:a7b:caaa:: with SMTP id r10mr2604587wml.100.1570517848241;
        Mon, 07 Oct 2019 23:57:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqym7378uK2SLHrM9bzukYU6fxbMPVQT8VT0yZc3RrKv9/pub3+g7Lhk8O5PyNr59Jjaojk69g==
X-Received: by 2002:a7b:caaa:: with SMTP id r10mr2604563wml.100.1570517847946;
        Mon, 07 Oct 2019 23:57:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e876:e214:dc8e:2846? ([2001:b07:6468:f312:e876:e214:dc8e:2846])
        by smtp.gmail.com with ESMTPSA id 90sm24379233wrr.1.2019.10.07.23.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 23:57:27 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bd2cffea-6427-b3cc-7098-a881e3d4522d@redhat.com>
Date:   Tue, 8 Oct 2019 08:57:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007195638.GG18016@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/19 21:56, Sean Christopherson wrote:
> On Mon, Oct 07, 2019 at 07:12:37PM +0200, Paolo Bonzini wrote:
>> On 04/10/19 23:56, Sean Christopherson wrote:
>>> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
>>> index cb2e49810d68..4eec8889b0ff 100644
>>> --- a/arch/x86/kernel/cpu/proc.c
>>> +++ b/arch/x86/kernel/cpu/proc.c
>>> @@ -7,6 +7,10 @@
>>>  
>>>  #include "cpu.h"
>>>  
>>> +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>>> +extern const char * const x86_vmx_flags[NVMXINTS*32];
>>> +#endif
>>> +
>>>  /*
>>>   *	Get CPU information for use by the procfs.
>>>   */
>>> @@ -102,6 +106,17 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>>>  		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
>>>  			seq_printf(m, " %s", x86_cap_flags[i]);
>>
>> I'm afraid this is going to break some scripts in the wild.  I would
>> simply remove the seq_puts below.
> 
> Can you elaborate?  I'm having trouble connecting the dots...

Somebody is bound to have scripts doing "grep ^flags.*ept /proc/cpuinfo"
or checking for VMX flags under some kind of "if (/^flags/)", so it's
safer not to separate VMX and non-VMX flags.

Paolo

>> Paolo
>>
>>> +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>>> +	if (cpu_has(c, X86_FEATURE_VMX) && c->vmx_capability[0]) {
>>> +		seq_puts(m, "\nvmx flags\t:");
>>> +		for (i = 0; i < 32*NVMXINTS; i++) {
>>> +			if (test_bit(i, (unsigned long *)c->vmx_capability) &&
>>> +			    x86_vmx_flags[i] != NULL)
>>> +				seq_printf(m, " %s", x86_vmx_flags[i]);
>>> +		}
>>> +	}
>>> +#endif
>>> +
>>>  	seq_puts(m, "\nbugs\t\t:");
>>>  	for (i = 0; i < 32*NBUGINTS; i++) {
>>>  		unsigned int bug_bit = 32*NCAPINTS + i;

