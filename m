Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4CC46E430
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 09:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhLIIcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 03:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhLIIcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 03:32:21 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B8C061746;
        Thu,  9 Dec 2021 00:28:48 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g18so4749551pfk.5;
        Thu, 09 Dec 2021 00:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=wAw4GaETCJwFjSf4QQMuKwI7SfoEPjcbvTNAwY41CxU=;
        b=gSzw9JRB2fiY4afJoqjnlHvcsG6jmpKu78PqDvH77WB/RT4EoQ/41wVvTrlN5qKY6R
         BwJg7seS9PMR67CfpFQ8Fnnn9NUnQrdYb6NUkf7NmpcsrDcCxD4fiCPjpYR+voDMlZdE
         poPOFdz/CaXmEuKP7yItwHYTgFZydyuUxbCDZqHBGxE9GL569xeXOBK6Nz7CLKuXq8Kg
         cBvOA1nkAriQIcukF6ZCArtm/rZ/V8F3JjPZC0jN7a45kfklF+EVu4nj1EG9SSRsf36q
         PjyYU+GlL6DzD3oobi1gYraUAiQ18hdtih/KCYejXtpmTA+ktqTR/L4qwKzAtkG+Rlxg
         gNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=wAw4GaETCJwFjSf4QQMuKwI7SfoEPjcbvTNAwY41CxU=;
        b=H36E8jC4waxrAprEixqUyedTz+kPbcI0kVW2uWYBgsXspAyKzlhyjF6bSHijcLYriE
         SOmzCdfxq7g881aCuEQ27mDNVfFG7RkkNzq629UuKDUTZwBc9UAvwgRE5fTE1r/a2Xy6
         KwmCh0jb67xOVMnUdH+ULkECwtSc41Q57jlRbHhs34XzPICtnaZAcq0RP2rCYETwQCKL
         Z3lpsrpBJyDzsBNi9SqJibX+KA6OGPbqk7cu8plvsNV0DwhTY7qUTjlo8S3M7FFVkLsq
         3usQpczo7haDvnvZt/6UUC6fA0k1blw8jjUBv22MHH+Fc8wVEmjl9/yX41rB07iNyyFZ
         knvQ==
X-Gm-Message-State: AOAM530HzWTkCC0MPW/oyq7WDA/guAi6sFVQ79M0by6QqucJS2vuqN5p
        C61+bXmk+H0JnpThmjF38B0=
X-Google-Smtp-Source: ABdhPJzEdVCrSE380Ni7T2O3O4DKiN67b8IYbPut5TaX6Is4X8iiWYY64y08Nm/HZz55SA+0Yc/FCg==
X-Received: by 2002:a63:80c8:: with SMTP id j191mr34100523pgd.143.1639038527583;
        Thu, 09 Dec 2021 00:28:47 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a3sm4774959pgj.2.2021.12.09.00.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:28:47 -0800 (PST)
Message-ID: <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com>
Date:   Thu, 9 Dec 2021 16:28:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor
 kvm_perf_overflow{_intr}()
In-Reply-To: <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/12/2021 12:25 pm, Jim Mattson wrote:
> 
> Not your change, but if the event is counting anything based on
> cycles, and the guest TSC is scaled to run at a different rate from
> the host TSC, doesn't the initial value of the underlying hardware
> counter have to be adjusted as well, so that the interrupt arrives
> when the guest's counter overflows rather than when the host's counter
> overflows?

I've thought about this issue too and at least the Intel Specification
did not let me down on this detail:

	"The counter changes in the VMX non-root mode will follow
	VMM's use of the TSC offset or TSC scaling VMX controls"

Not knowing if AMD or the real world hardware
will live up to this expectation and I'm pessimistic.

cc Andi and Kim.

