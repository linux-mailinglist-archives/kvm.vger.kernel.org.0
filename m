Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913A33C5AC5
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhGLKWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 06:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhGLKWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 06:22:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9C2C0613DD;
        Mon, 12 Jul 2021 03:19:18 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b12so15928232pfv.6;
        Mon, 12 Jul 2021 03:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UfspUjTnY0iCrcR2F7FJcbEXjfsubIXat9EqyG3E3Zg=;
        b=RxsWPlMNjdk5njDwBPLsA8luqUwRfTEJwlOmsWuLwy8cETyU9+IohNYjhGORLTEL4J
         5H3CpoPqnL7odx3di2RYBwjy+RY4naZRSPb18d2UJ24N5zYsmnnxEzBzXR5oOv5C+c9c
         UJhpz1ja+s+kro1WYKDVsqc2D7vInRQJULf8/9rFvCVC1nOSeO2gVt/B3jJYdJzC1a6z
         +pkz0TT236mOyCOUXEHjT12VU5hu3uatPy/vtATbXalxLCikzVs1qdCSueY0Y+WVopWP
         GseO26CgaXlcG+WiPcwU5ES1m6X+HOq3yNJONVYbFygKiF/8ZVgnRrT14+ZU4IVPWPKZ
         I+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UfspUjTnY0iCrcR2F7FJcbEXjfsubIXat9EqyG3E3Zg=;
        b=QKCZZzaVyye0fjsnBeMgiLQ8rQz/dvef6zEcFd+4W7llPeXG30cuSeP/u0hh85ETvK
         cXQA48j2UoI4aL995W8BKHWKOg3kDxkifKEYUcGPv3JhTDoiOVdq6SWxw9zKUlEUoLS9
         K0rQenL7msRnSh3+/cbZKthntNizP88fHzKoxY0Vue/c5lSFPaXR5Mi29d4oMD5zi0KX
         sozPuVZL3I827yONBuGzJ7V9cJX4X4uabb4Y4VSvvA1Atp9N67QlfHPNZY1aWdv5ARD+
         y9+HNG2ubxNQVWJN2QL1zStqARHnE3NeFMqMd3e3s2wB9gURHO/iN0aaPLZga/CtfJ9R
         eAKQ==
X-Gm-Message-State: AOAM5319XVHVbBH5hxRzNonjK1gkDt3wSqQWmC3bEPXJON8zADHNiMp5
        7MkVZdF+yof8KX12z7oU0eQ=
X-Google-Smtp-Source: ABdhPJxLjJNbCWd3tw94vz+uw/fREkrb/C21rcxOD42W6885aqZWG9ej8pqbtqOXIK4r4p1xHaSXaw==
X-Received: by 2002:a63:d347:: with SMTP id u7mr53156742pgi.434.1626085157913;
        Mon, 12 Jul 2021 03:19:17 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h9sm17583552pgi.43.2021.07.12.03.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 03:19:17 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL
 state
Message-ID: <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
Date:   Mon, 12 Jul 2021 18:19:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712095305.GE12162@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2021 5:53 pm, Yang Weijiang wrote:
> On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
>> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote:
>>>
>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>
>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
>>>> and reload it after vm-exit.
>>>
>>> I don't see anything being done here "before VM-entry" or "after
>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>>>
>>> In any case, I don't see why this one MSR is special. It seems that if
>>> the host is using the architectural LBR MSRs, then *all* of the host
>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
>>
>> It does seem like there is something special about IA32_LBR_DEPTH, though...
>>
>> Section 7.3.1 of the Intel® Architecture Instruction Set Extensions
>> and Future Features Programming Reference
>> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
>> XRSTORS in any circumstance." It seems like that would require some
>> special handling if the host depth and the guest depth do not match.
> In our vPMU design, guest depth is alway kept the same as that of host,
> so this won't be a problem. But I'll double check the code again, thanks!

KVM only exposes the host's depth value to the user space
so the guest can only use the same depth as the host.

A further reason is that the host perf driver currently
does not support different threads using different depths.
