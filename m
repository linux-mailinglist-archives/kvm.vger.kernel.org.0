Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC33453E90
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 03:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhKQCw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 21:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhKQCw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 21:52:26 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA2C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 18:49:28 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so921217plp.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 18:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=yOK7KmyANujMhPt1HIewTX/LOnMS9U4aiw+rKqPlJik=;
        b=eMfLQHQQHj2PMMj322FsJ8bJxi173/+LvnP4jdWks5tZ2VgXHhr+j1KnmVMXmqwE4e
         wvZp1uh2fT91VR39DPyyUClSyFrJkI33/Lv4S1fCANnrQK9WCFFQOEB+VNm4cZ3+QJKB
         Y4uDKSi9EbD3AMtcWUf2W0ctBJU4AR0FsJDn0d/mGmpeXg8K0TO/y8wqbBnw+AmqKkoz
         Buc+TSs4/VYg5PPhwR2EF94LTNbwOMAAYSYAP0EUzM+yJhN0tndOeFpORCF+uuDl3oPu
         FXboajNu/fkrMQeXUrifMlkkqWpQKj8xzg8L+pg5qUM5lx2k0bhyvpft4ebx4NFgTsJm
         3emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=yOK7KmyANujMhPt1HIewTX/LOnMS9U4aiw+rKqPlJik=;
        b=T6wNFlwxh0wsYBg84sI7B/gyBPLlltlLBEpeTHVm801Idc9x9YSMbegpZpA1WB8Hl7
         rbYCYGBd1HdOnJRQ5fiU+5H5lyFbcPBoSP7Yedv6izWi9NVJGsLHcIzMEzEcgbNOop4o
         4cY4wINUESmYEUxHEqBzjmuaDPAYw0TTI1w40AvGuJrS+czHfZuvBQplfrBd8zxI824W
         /ueTL/iRcVo2eCCx6TfxDq1cblRJ9AurBb0X60yRxvrs41hw29Mpp2U39j4Deit1f1do
         pBuxmGEE0ldjou4mZAo1LGL6AD6yiDfOqpjIfkg/7HFvm2SgX3gNfqe4dWUZ9XGOJrL4
         g8iw==
X-Gm-Message-State: AOAM530YvSDYTFRi0JZF9grtXPLr6tA8oP0yzhvTx+v72WKyOtXdUJef
        15hM14M+bEh4jGI4ZdDPZWvFT7UfzbY=
X-Google-Smtp-Source: ABdhPJxtbZm09E0VZWkGD3/VQWq2BTdrs4ue0o/XW8+7yjksk6mc7ms/XmVZezF9McLbd6pIylEWeA==
X-Received: by 2002:a17:90b:3e85:: with SMTP id rj5mr5302593pjb.172.1637117368349;
        Tue, 16 Nov 2021 18:49:28 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k12sm7848563pgi.23.2021.11.16.18.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 18:49:27 -0800 (PST)
Message-ID: <2225eda6-33f4-d315-71e4-f0a22ef66487@gmail.com>
Date:   Wed, 17 Nov 2021 10:49:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20211116105038.683627-1-pbonzini@redhat.com>
 <CALMp9eSy7-ziFeOrz+zsdBPOC7AqULYRSrP1kKSMWkFwrmzy8w@mail.gmail.com>
 <ea98ccf5-059b-11b3-e071-a46bad687699@redhat.com>
 <CALMp9eQ09Gkd=H=wWkwZicB7=6VywkL-R8dZhJHusuzBRdDh3A@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
In-Reply-To: <CALMp9eQ09Gkd=H=wWkwZicB7=6VywkL-R8dZhJHusuzBRdDh3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/2021 4:00 am, Jim Mattson wrote:
> On Tue, Nov 16, 2021 at 10:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 11/16/21 18:49, Jim Mattson wrote:
>>> Thanks for fixing this. By the way, one of the reasons that we don't
>>> expose a virtual PMU to more customers is the conflict with the NMI
>>> watchdog. We aren't willing to give up the NMI watchdog on the host,
>>> and we don't really want to report a reduced number of general purpose

The NMI watchdog is definitely a good feature to me as well.

>>> counters to the guest. (On AMD, we *can't* report a reduced number of
>>> counters to the guest; the architectural specification doesn't allow
>>> it.)

Yes, AMD has more architectural design troubles with the guest PMU,
which I am trying to resolve part of them (such as disabling vpmu or guest IBS 
stuff).

>>
>> FWIW we also generally use the PMU emulation only for debugging of guest
>> performance issues.

More and more customers are interfacing with me since application developers
nowadays cannot access to the host environment for their performance issues.

> 
> We do have quite a few customers who want it, but I'm not sure that
> they really know what it is they will be getting. :-)

My cloud-based customers ask me for almost everything about the host PMU 
capabilities.
For example, the Intel Guest PEBS has been a stable out-of-tree feature for a year.

> 
>>> We can't be the only ones running with the NMI watchdog enabled. How
>>> do others deal with this? Is there any hope of suspending the NMI
>>> watchdog while in VMX non-root mode (or guest mode on AMD)?
>>
>> Like, what do you think?

Suspending the host NMI watchdog for guest code would be easy to implement,
but difficult to get upstream buy-in, especially for security researchers.

For Intel, the enabled NMI watchdog unconditionally seizes a counter
from vCPU usage, causing inaccuracy for guest pmu emulation.

For AMD, we have the dedicated "CPU Watchdog Timer Register",
which may help the issue, but I'm just getting into the AMD world.

I guess Google has a perf scheduler code diff for static allocation counters
and in that case the NMI watchdog occupies a specific counter all the time.

The current upstream status is that we allow guest pmu emulation to fail
temporarily since we expect the vPMU users will run profiling agent repeatedly.

>>
>> Paolo
>>
>>>> This also hid a typo for the force_emulation_prefix module parameter,
>>>> which is part of the kvm module rather than the kvm_intel module,
>>>> so fix that.
>>>>
>>>> Reported-by: Like Xu <like.xu.linux@gmail.com>
>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>
>>
