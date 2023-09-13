Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C2379E586
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbjIMK7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbjIMK7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:59:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B51726;
        Wed, 13 Sep 2023 03:59:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-68cbbff84f6so589142b3a.1;
        Wed, 13 Sep 2023 03:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694602778; x=1695207578; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ubgqvuuz8XHqik/hJYWfjAamtvsH9U0hXkXetLfYO0A=;
        b=JmbCaHRPDdlM9HolGGCW1VUl+AXxIHZyUxQyA9plZfoHajqMXhmdWU+osZERHhJLKk
         fOlPlECU7Wm6cgdKWsa+o6ZLemCzX/yrDrJ+0vl8wzhPMp5ptDccAEpaAynVt9CxcNl7
         /qkangzivd+w3Abz2UQ5JLVzW+B+Ii1vIrOqVqXUVYdu8hrxLqE2Dgrr6Ea6eaITR4M2
         z5Oh8wK5cMzTRqye7JbQ6+6kjSedlAs4zUwqIOYt7t5vevWTcA0UcmAt454rr/8Mf7iu
         3yHGyw3i91hoW+wO2Wk0N/M6SctvJoJKghVd5LgIssF9U5QM5GTFTp4G1y3bT40xh4Yf
         sY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694602778; x=1695207578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ubgqvuuz8XHqik/hJYWfjAamtvsH9U0hXkXetLfYO0A=;
        b=gh+vWBdrIN4EXEYRoCCmsChWMVcx+k1NKRYCs78K0GVGyVp1rm0F/dgx3qNgo346JR
         golWatnYnLklNb7g7ULSxTL8qUp1CGCvPZo9EuUOUxNxkujBZ9ej7oAkLkdjtxyPn2GI
         4r6/fY4CbpvhuE4+qoSS4GzBn0IhgRB0JwnQasi7IX7opq5Na5XZdtZVcBHIDqj2Rvkr
         8z5QZFKh2ZH3IL6dff/VkVq+evGqRzi2hUThCVyOpIqBbCn3OZpoEyvOit1Kjf5HsrHk
         pKTffoUfXv9VEMKx8q0IjHFchCCaciSH1Sku6tnG/BZlvf/ReylKEMxSYYmLbwwAjn6s
         cxcw==
X-Gm-Message-State: AOJu0Yy1IwR3tRv6UnVrBXLLR++VRnINrXiCN69FRRGS5u8ta5LAkcEZ
        +ueNHp3VB1jF5mhFTLhnNKoSm+xwiOC6B7Mo
X-Google-Smtp-Source: AGHT+IH21c5s+ckMoB7Fyelz8QE+InDXhU5BCLTtJTn6EWPHMbijP8MJnwC8p7Em4tfSBDwa6/pIWw==
X-Received: by 2002:a05:6a20:8e06:b0:14d:a7d8:5856 with SMTP id y6-20020a056a208e0600b0014da7d85856mr3329892pzj.2.1694602777931;
        Wed, 13 Sep 2023 03:59:37 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ay29-20020a056a00301d00b0068fd653321esm4147406pfb.58.2023.09.13.03.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 03:59:37 -0700 (PDT)
Message-ID: <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
Date:   Wed, 13 Sep 2023 18:59:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20230913103729.51194-1-likexu@tencent.com>
 <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/9/2023 6:51 pm, David Woodhouse wrote:
> On Wed, 2023-09-13 at 18:37 +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> The legacy API for setting the TSC is fundamentally broken, and only
>> allows userspace to set a TSC "now", without any way to account for
>> time lost to preemption between the calculation of the value, and the
>> kernel eventually handling the ioctl.
>>
>> To work around this we have had a hack which, if a TSC is set with a
>> value which is within a second's worth of a previous vCPU, assumes that
>> userspace actually intended them to be in sync and adjusts the newly-
>> written TSC value accordingly.
>>
>> Thus, when a VMM restores a guest after suspend or migration using the
>> legacy API, the TSCs aren't necessarily *right*, but at least they're
>> in sync.
>>
>> This trick falls down when restoring a guest which genuinely has been
>> running for less time than the 1 second of imprecision which we allow
>> for in the legacy API. On *creation* the first vCPU starts its TSC
>> counting from zero, and the subsequent vCPUs synchronize to that. But
>> then when the VMM tries to set the intended TSC value, because that's
>> within a second of what the last TSC synced to, it just adjusts it to
>> match that.
>>
> Proofreading my own words here... "it just adjusts it to match" is
> using the same pronoun for different things and is probably hard to
> follow. Perhaps "KVM just adjusts it to match" is nicer.
> 
>> The correct answer is for the VMM not to use the legacy API of course.
>>
>> But we can pile further hacks onto our existing hackish ABI, and
>> declare that the *first* value written by userspace (on any vCPU)
>> should not be subject to this 'correction' to make it sync up with
>> values that only from the kernel's default vCPU creation.
> 
>                    ^^
>       ... that only *come* from the kernel's...
> 
> 
>>
>> To that end: Add a flag in kvm->arch.user_set_tsc, protected by
>> kvm->arch.tsc_write_lock, to record that a TSC for at least one vCPU in
>> this KVM *has* been set by userspace. Make the 1-second slop hack only
>> trigger if that flag is already set.
>>
>> Reported-by: Yong He <alexyonghe@tencent.com>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
>> Original-by: Oliver Upton <oliver.upton@linux.dev>
>> Original-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Tested-by: Yong He <alexyonghe@tencent.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> Please remove the 'Signed-off-by' from me. You must never ever *type* a
> signed-off-by line for anyone else. You only ever cut and paste those
> intact when they have provided them for *themselves*.

Nice rule, sorry and thanks for the guidance.

> 
> It's OK to remove the Co-developed-by: too. You did the actual typing
> of the code here; I just heckled :)

Thank you for reviewing it.

I'll wait for a cooling off period to see if the maintainers need me to post v7.
