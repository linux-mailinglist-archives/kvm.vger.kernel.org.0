Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE56246E4F
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 19:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgHQR1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 13:27:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59154 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729355AbgHQRTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 13:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597684762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFPMSvpIlcEi9vKnp4yTX8jZZSPCc4zsy0BQSz8767o=;
        b=EAFr4JEWWQ1W9fFaNEYjFcMfuqqotR1MBG4PrKluQXH3oLA3b1XTfoV967oQVUO9uauML9
        d6EPl6OZv4n4EofMd0YoDvGPPzs4zpmbO4GZamXXlUfEDJi8O6ena2ngev+WhACfsbosz6
        Xt2Bc8qhQ1faPG/x+9GnyTQ2FtIcAP0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-iYWO3XKgM06Te2RTUAEHHg-1; Mon, 17 Aug 2020 13:19:20 -0400
X-MC-Unique: iYWO3XKgM06Te2RTUAEHHg-1
Received: by mail-wr1-f71.google.com with SMTP id f14so7266521wrm.22
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 10:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eFPMSvpIlcEi9vKnp4yTX8jZZSPCc4zsy0BQSz8767o=;
        b=pJYwggA/p6j9B5aiq6f7iTGecqlbp+UECEFQwDvcKPGBH7NVjrechBw2HiITCtCeLy
         4Gk4g4Tux0kE8hLChtALj/f/DOTaUFOjdeMgrVcDiL1Hn5ksmD970TNK1f1rIWVGzwC6
         TbBpjsqgxU/cCUstijIV1FcRvwD6bEnoGvQWozGCzdORFpd4HR/2GOm5YFOLzwO1C7dS
         5J4yxe3ZEaOJ6C/6FotvX6AT6yDYZd0oJyW5xlOt+NFroYNh41AALslIbZQAoCd7hyII
         oYqAt+Dg+AE6q4k+T3y10U7wsmMRBkq5twTKVUw+B8Q1IFPbH0NLogZe5JgIbV9DRlMX
         blWQ==
X-Gm-Message-State: AOAM532EQuE+UlQEY4V659hd7DKD4jtQ92A3ihX1LHX4+rJoHKzWbMbk
        8pic0fK3vDtj7SZih/xjGY1Ci1V471r2RRjUvS+vpkye2Mmo73piURtWbtz9ByNWv+vQrLluGGC
        +e70k7G7hgbsU
X-Received: by 2002:adf:e486:: with SMTP id i6mr16096845wrm.258.1597684759141;
        Mon, 17 Aug 2020 10:19:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBsO9sI7JfPb/GTHTpiEfT134+1sQNfi3YoKjidFt0K8JQ4tn1XRcdb2IstK/hgHWmfZIjMg==
X-Received: by 2002:adf:e486:: with SMTP id i6mr16096831wrm.258.1597684758913;
        Mon, 17 Aug 2020 10:19:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id p8sm32192744wrq.9.2020.08.17.10.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 10:19:18 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: Fix an unexpected failure with newer gcc
 compiler
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        linux-kselftest@vger.kernel.org
References: <20200814132105.5122-1-weijiang.yang@intel.com>
 <20200817164238.GD22407@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ad0f9fa-bb57-4c19-475b-3439d7a61bcd@redhat.com>
Date:   Mon, 17 Aug 2020 19:19:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817164238.GD22407@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 18:42, Sean Christopherson wrote:
> On Fri, Aug 14, 2020 at 09:21:05PM +0800, Yang Weijiang wrote:
>> If debug_regs.c is built with newer gcc, e.g., 8.3.1 on my side, then the generated
>> binary looks like over-optimized by gcc:
>>
>> asm volatile("ss_start: "
>>              "xor %%rax,%%rax\n\t"
>>              "cpuid\n\t"
>>              "movl $0x1a0,%%ecx\n\t"
>>              "rdmsr\n\t"
>>              : : : "rax", "ecx");
>>
>> is translated to :
>>
>>   000000000040194e <ss_start>:
>>   40194e:       31 c0                   xor    %eax,%eax     <----- rax->eax?
>>   401950:       0f a2                   cpuid
>>   401952:       b9 a0 01 00 00          mov    $0x1a0,%ecx
>>   401957:       0f 32                   rdmsr
>>
>> As you can see rax is replaced with eax in taret binary code.
> 
> It's an optimization.  `xor rax, rax` and `xor eax, eax` yield the exact
> same result, as writing the lower 32 bits of a GPR in 64-bit mode clears
> the upper 32 bits.  Using the eax variant avoids the REX prefix and saves
> a byte of code.

I would have expected that from binutils though, not GCC.

> Use `xor %%eax, %%eax`.  That should always generate a 2 byte instruction.
> Encoding a 64-bit operation would technically be legal, but I doubt any
> compiler would do that in practice.

Indeed, and in addition the clobbers are incorrect since they miss rbx
and rdx.  I've sent a patch.

Paolo

