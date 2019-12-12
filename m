Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B211CF79
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 15:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfLLONw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 09:13:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729560AbfLLONv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 09:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576160031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZExjJXZmAxrisVlHnSSzmAF44okPSODnrWMGgB8ZBE=;
        b=aIqcQsQXNrc8tYiriXSHQ1CbdhuKI8HlTnqvaMlqbOIjrBauLTjC+ySlulhogYTZ6KsOFU
        pgThq5RA7DydALkyWOVHc3YETtY/Yxzvzc3Oa6wcl9Y+mozyQ3Thk2wR4txvwLS/GtfA7b
        seZVWJXXOTiTrKj0UHepLmNxgeB9njU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-KKe_USCbPROCz7MNQh6q_w-1; Thu, 12 Dec 2019 09:13:49 -0500
X-MC-Unique: KKe_USCbPROCz7MNQh6q_w-1
Received: by mail-wm1-f69.google.com with SMTP id p2so906022wma.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 06:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ZExjJXZmAxrisVlHnSSzmAF44okPSODnrWMGgB8ZBE=;
        b=bIlDWEoouZwE/cFc/Ws5TVh9bZAlfVrWu4LaahR+sS3Em3FXDCg8T2gcletMGuYNh6
         41vddZhg/1rF/MrSGxy5YgBGPOnJ6mgqF9Cg9EPg1zCDcD8m1KrOa/tD78smvOWdtDAb
         ctQ9SYntvq07VQSgxXtKGH1OwQmFSqA/NywTdIpSJ9370cL7Yja/j3T2RfqB6uXuc1FI
         jUQKP3p02U8H+LukwZjIlkS17pFlfAB6qTab+aEw5x7EneW5bApdRi6dFTGa0R0jAv/z
         T/+nU8aMgCmF7bokxXv4GxpyTpJH1Um+X8P6txv50lb5m6+tqNtkpB64L622oxEPtFSh
         pqig==
X-Gm-Message-State: APjAAAWshHl3I8GJNyMxuVKXY/kaaCd/6HAB2X/z5jnggBPTKR2A+quh
        fIFctAy/neS6L+3PhJuKjJ2U0xZq0ciiUyMon/resnpkqpmO4Bjmwoh6NnOTED8aD2lQ8zHrjCt
        VZQ7T0fiTMN8c
X-Received: by 2002:a1c:1d16:: with SMTP id d22mr7146068wmd.158.1576160028582;
        Thu, 12 Dec 2019 06:13:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXF4yU0mb+JGHuD4jVpmfrMhrWl7mkfC0/B+dcZzKjBOfKW3ZFj8XtTi3XukYIj/A/1colAQ==
X-Received: by 2002:a1c:1d16:: with SMTP id d22mr7146033wmd.158.1576160028358;
        Thu, 12 Dec 2019 06:13:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id v3sm6151298wml.47.2019.12.12.06.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 06:13:47 -0800 (PST)
Subject: Re: [PATCH v4 11/19] x86/cpu: Print VMX flags in /proc/cpuinfo using
 VMX_FEATURES_*
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Len Brown <lenb@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20191128014016.4389-1-sean.j.christopherson@intel.com>
 <20191128014016.4389-12-sean.j.christopherson@intel.com>
 <20191212122646.GE4991@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0b21e7e-69f5-09f9-3e1c-14d49fa42b9f@redhat.com>
Date:   Thu, 12 Dec 2019 15:13:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212122646.GE4991@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 13:26, Borislav Petkov wrote:
> 
> vmx flags       : virtual_nmis preemption_timer invvpid ept_x_only ept_ad ept_1gb flexpriority tsc_offsetting virtual_tpr mtf virt_apic_accesses ept vpid unrestricted_guest ple shadow_vmcs pml mode_based_ept_exec
> 
> virtual_nmis		-> vnmis

Even vnmi

> preemption_timer	-> preempt_tmr

I would prefer the full one here.

> flexpriority		-> flexprio

Full name?

> tsc_offsetting		-> tsc_ofs

tsc_offset?

> virtual_tpr		-> vtpr

Do we need this?  It's usually included together with flexpriority.

> virt_apic_accesses	-> vapic

apicv

> unrestricted_guest	-> unres_guest

Full? Or just unrestricted

In general I would stick to the same names as kvm_intel module
parameters (sans "enable_" if applicable) and not even bother publishing
the others.  Some features are either not used by KVM or available on
all VMX processors.

Paolo

> and so on. Those are just my examples - I betcha the SDM is more
> creative here with abbreviations. But you guys are going to grep for
> them. If it were me, I'd save on typing. :-)

