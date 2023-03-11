Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC136B6026
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 20:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCKTYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 14:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCKTYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 14:24:03 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D686594;
        Sat, 11 Mar 2023 11:24:01 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4PYtBj2l5Hz9sZH;
        Sat, 11 Mar 2023 20:23:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1678562637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lH9AHHviE6C2dDnsSme3238JPMfFnJr5VLt6Dh8/1sg=;
        b=PXtqDl57RqXJ+ohbtengAuV8GQSdKgqQ/ph0ZmS0sZSrL0fQk5xXgW/6au33OJx0r/lpM+
        kVqDKKGHBpr32P14pd6KFP29qOUlrh4atEoWd0kgcqRaADjPKSqFxyBEWqsWqyZ/3Ms6Hg
        3NRIi/tZfl5oi1tHV99cPITTMh1gji2GIt8K1UIF823YaKS5QmPg/vxkw+Nw5hpSMaojKn
        z3ygW4Kcy8Wo2PtrxL3c3qoUWlmq33yKYr35Kgq48VCVZRD6mMx0EPUTfIc5ScqCd/sUWa
        xjQ7fx109EvAoo+ov8APkCeZtsDH800KNLs2Ws2Hm2Br9YQ4r7maAk4fmqSOmw==
Message-ID: <0b55636e-326b-a366-4346-bedddcecc6d0@mailbox.org>
Date:   Sat, 11 Mar 2023 19:23:46 +0000
MIME-Version: 1.0
Subject: Re: [PATCH v14 00/12] Parallel CPU bringup for x86_64
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
 <16d9f738-18fd-a929-e711-f2a1e757e33f@mailbox.org>
 <18ec6bf2-c19a-5fcf-3d6b-4106e2372af1@molgen.mpg.de>
Content-Language: en-US
From:   Tor Vic <torvic9@mailbox.org>
In-Reply-To: <18ec6bf2-c19a-5fcf-3d6b-4106e2372af1@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 7b5726b73904097e23b
X-MBO-RS-META: n5gxo51d15qh19dt6shgw6h1fg8ci4oy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.03.23 20:18, Paul Menzel wrote:
> Dear Tor,
> 

Hi Paul,

> 
> Am 10.03.23 um 20:20 schrieb Tor Vic:
>> On 08.03.23 17:13, Usama Arif wrote:
>>> The main code change over v13 is to enable parallel bringup for 
>>> SEV-ES guests.
> 
> […]
> 
>>>   .../admin-guide/kernel-parameters.txt         |   3 +
>>>   arch/x86/include/asm/cpu.h                    |   1 +
>>>   arch/x86/include/asm/processor.h              |   6 +-
>>>   arch/x86/include/asm/realmode.h               |   4 +-
>>>   arch/x86/include/asm/sev-common.h             |   3 +
>>>   arch/x86/include/asm/sev.h                    |   5 +
>>>   arch/x86/include/asm/smp.h                    |  18 +-
>>>   arch/x86/include/asm/topology.h               |   2 -
>>>   arch/x86/kernel/acpi/sleep.c                  |  30 +-
>>>   arch/x86/kernel/apic/apic.c                   |   2 +-
>>>   arch/x86/kernel/apic/x2apic_cluster.c         | 126 +++---
>>>   arch/x86/kernel/asm-offsets.c                 |   1 +
>>>   arch/x86/kernel/cpu/common.c                  |   6 +-
>>>   arch/x86/kernel/cpu/topology.c                |   2 +-
>>>   arch/x86/kernel/head_64.S                     | 162 ++++++--
>>>   arch/x86/kernel/smpboot.c                     | 366 +++++++++++++-----
>>>   arch/x86/realmode/init.c                      |   3 +
>>>   arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>>>   arch/x86/xen/smp_pv.c                         |   4 +-
>>>   arch/x86/xen/xen-head.S                       |   2 +-
>>>   include/linux/cpuhotplug.h                    |   2 +
>>>   include/linux/smpboot.h                       |   7 +
>>>   kernel/cpu.c                                  |  31 +-
>>>   kernel/smpboot.h                              |   2 -
>>>   24 files changed, 614 insertions(+), 201 deletions(-)
>>>
>>
>> On Linux 6.2, Zen2 and Skylake, no issues or boot problems:
>>
>> Tested-by: Tor Vic <torvic9@mailbox.org>
> 
> Thank you for testing this. It’d be great if you shared the exact timing 
> numbers too. (Just to be sure, did you also test ACPI S3 suspend/resume?)
> 

I have just tested suspend/resume on the Zen2 machine, it works.
Not yet tested on the Skylake platform.

What is the best and simplest way to get these timings numbers?

> 
> Kind regards,
> 
> Paul
