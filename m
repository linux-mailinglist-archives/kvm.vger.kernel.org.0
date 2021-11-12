Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5516444E2B1
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 08:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhKLH6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 02:58:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233279AbhKLH6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 02:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636703739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lF7lzRoeZrlEIt3gHEFyVsRoWpbej1ntDFwYNAiQdJI=;
        b=OoH/RlDgLrBZ4NE0Egiv2jYH8u01kIkq7gOxapj3QCEpGv+UEvV8YL1k8ZDawXVwBCBY9L
        S/PngiPfgXjne44ijbUWRyM9MJdCI2gzYe1HdEMfP3KVnjv+4tEjyXNuQeDess5Ff4y0/O
        eBFVMOdsntqB/H6Yt6IMd0RSpBwt2rg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-RL6eXvF0MRKHtxsI7xNXpw-1; Fri, 12 Nov 2021 02:55:38 -0500
X-MC-Unique: RL6eXvF0MRKHtxsI7xNXpw-1
Received: by mail-ed1-f71.google.com with SMTP id y12-20020a056402270c00b003e28de6e995so7543851edd.11
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 23:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lF7lzRoeZrlEIt3gHEFyVsRoWpbej1ntDFwYNAiQdJI=;
        b=S/d1MtNFli6EBP0J+MTZJ16H2FkqHSISNX+gQCO60D2fncVws7D8HhMXEjwSfGWqln
         9Ohi80wm0qOPuQkX7z80eIuJBAg2MHuPuom7zR5OWB8oX81efnBQ7/ghBKKWy2YyXRu9
         JZ2RyUQi0EBJ8mrrmH/9GGSa1VK87kZsPz9URer+pDMnjH/ZpJTLcwlGlgC6YD+TOPIK
         KLaJlx9t+2a4WkTtmB3cnt/XPlF9eWQjCaWnrg8E0RLHgTjhdPr1z4YnSWMOVE+LKtCQ
         RoC3mh3PdWXo5ipERqan9ynDzbM+/b+bzKfTCdMgnNcVl2UvtYNCTA4j+LZt6TJ2mqOZ
         f/ng==
X-Gm-Message-State: AOAM531i+zeqLb7kG8mRDmA/I3AqNqDn5wCLuKtmIn1toDV8+j8/9jvx
        3WR1O5kzKSvBufclh0vbOHnnaxoQDz9OV75L+W/KRJsPluHK4Do/c7bRCj3o2r9njmWfodeRyek
        lN2s2+DSIfisF
X-Received: by 2002:a17:907:6e10:: with SMTP id sd16mr17768032ejc.158.1636703737516;
        Thu, 11 Nov 2021 23:55:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVTSyaI9bwf+cK3HRTYkkEGrfXsl4Cvt+Fkmz/7JDyaorMKEA4Mec75P9Nt6V8a8edl3Ld8g==
X-Received: by 2002:a17:907:6e10:: with SMTP id sd16mr17767982ejc.158.1636703737318;
        Thu, 11 Nov 2021 23:55:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n1sm2700678edf.45.2021.11.11.23.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 23:55:36 -0800 (PST)
Message-ID: <016d5b91-6910-2aca-0db1-a65079449454@redhat.com>
Date:   Fri, 12 Nov 2021 08:55:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v4 01/17] perf: Protect perf_guest_cbs with RCU
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-2-seanjc@google.com>
 <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
 <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 11:47, Peter Zijlstra wrote:
>> This technically could be RCU_INIT_POINTER but it's not worth a respin.
>> There are dozens of other occurrences, and if somebody wanted they
>> could use Coccinelle to fix all of them.
> I've been pushing the other way, trying to get rid of RCU_INIT_POINTER()
> since rcu_assign_pointer(, NULL) actualy DTRT per __builtin_constant_p()
> etc.

Oh, that's pretty cool to know, thanks!

Paolo

> There's a very few sites where we use RCU_INIT_POINTER() with a !NULL
> argument, and those are 'special'.
> 

