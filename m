Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAC731FAE
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbjFOSHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 14:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbjFOSHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 14:07:37 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7849295C
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 11:07:35 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1badb8f9bso32994471fa.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 11:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686852454; x=1689444454;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YsbuR6mZR+PKczxv6oyLi4SMNSeIHqEiWS4r709fn04=;
        b=UUXpRN3fU2L6cwTFuueZezUvtJyPTaR4xnNoOBUoNUzzMm4mNHWnT7haSbW0YKfc4Q
         Wb5CZ2Jf9mJT4svgMSJobRz+ZWeIHPDukR27X47ABV0HpKU/Kac3pYI6fVX1oYKEDsPF
         FB7Kjiial9usISHW5VqGYzS2IhOieVlYc7ETCB9G9ZaYCJGHve6GBUxL1k5a7yhcuEW/
         ERa7VtKEXbiLeWaewJ61/SQzdOo0Cv4MWY1mr2Tmr4Zz0vwJ0DK8ODNva12kQG1ouhm+
         vQVqeQT/0GUGf0LlwYxRFJQQLisvlZX3v1n87cJErtxT6VL/KIJjpcQwsDL+JL8FFcCL
         Wl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686852454; x=1689444454;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsbuR6mZR+PKczxv6oyLi4SMNSeIHqEiWS4r709fn04=;
        b=QFuyvbrInWEjcAR4Yt0mK1KJwmXKi4aE7vGvEniiVCeVgI45sdK4bYY2qfr9m9trxK
         JNavIKUzeSIwQAkK2FnZ0nxImd3csqEb1+CO6RJC8bP5LGElHQ6PiYsoxADxnWJsjHNb
         zK7zvS3sk7cyMizOJWJisGTTWm+06cO+bzdzKJfwQTAFpbinxo+It1DU8eOyfeSQ3B2T
         Mjsqim82iOg64aSZQcUlPx4inI6obXX/HiQR/1sQMUzrf+lGY0e7zPtV2ddUqplLPceK
         fewakJPRukpAfVBjRv3pW9c9BjS6Z+H+v56tuEwl8iz+ACmASMReUDXbbm9OEj11BAQ0
         2cyQ==
X-Gm-Message-State: AC+VfDyFiXNpbdlAsZ5EKLK2rm0SH47zP+stSQ4wKwRZxHzKA4fuLrB6
        oIPYbPZg60SZKLN8ANYwYjC05g==
X-Google-Smtp-Source: ACHHUZ5djiiAKKVOfBN0hEUZEf8If5RIrGCK2bIqsDUnUJ7d+7OUta8STwpDShqU51fZ/7Exb7N5YQ==
X-Received: by 2002:a2e:83d7:0:b0:2af:1844:6fdb with SMTP id s23-20020a2e83d7000000b002af18446fdbmr159986ljh.5.1686852454047;
        Thu, 15 Jun 2023 11:07:34 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id c8-20020a2e6808000000b002af25598ef9sm3222472lja.0.2023.06.15.11.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 11:07:33 -0700 (PDT)
Message-ID: <dae80807-0c5b-1dd1-a473-1d9b3484e81f@semihalf.com>
Date:   Thu, 15 Jun 2023 20:07:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jason CJ Chen <jason.cj.chen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
 <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
 <ZIjInENnK5/L/Jsd@google.com>
Content-Language: en-US
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <ZIjInENnK5/L/Jsd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/23 21:50, Sean Christopherson wrote:
> On Fri, Jun 09, 2023, Dmytro Maluka wrote:
>> Yeah indeed, good point.
>>
>> Is my understanding correct: TLB flush is still gonna be requested by
>> the host VM via a hypercall, but the benefit is that the hypervisor
>> merely needs to do INVEPT?
> 
> Maybe?  A paravirt paging scheme could do whatever it wanted.  The APIs could be
> designed in such a way that L1 never needs to explicitly request a TLB flush,
> e.g. if the contract is that changes must always become immediately visible to L2.
> 
> And TLB flushing is but one small aspect of page table shadowing.  With PV paging,
> L1 wouldn't need to manage hardware-defined page tables, i.e. could use any arbitrary
> data type.  E.g. KVM as L1 could use an XArray to track L2 mappings.  And L0 in
> turn wouldn't need to have vendor specific code, i.e. pKVM on x86 (potentially
> *all* architectures) could have a single nested paging scheme for both Intel and
> AMD, as opposed to needing code to deal with the differences between EPT and NPT.
> 
> A few months back, I mentally worked through the flows[*] (I forget why I was
> thinking about PV paging), and I'm pretty sure that adapting x86's TDP MMU to
> support PV paging would be easy-ish, e.g. kvm_tdp_mmu_map() would become an
> XArray insertion (to track the L2 mapping) + hypercall (to inform L1 of the new
> mapping).
> 
> [*] I even though of a catchy name, KVM Paravirt Only Paging, a.k.a. KPOP ;-)

Yeap indeed, thanks. (I should have thought myself that it's rather
pointless to use hardware-defined page tables and TLB semantics in L1 if
we go full PV.) In pKVM on ARM [1] it already looks similar to what you
described and is pretty simple: L1 pins the guest page, issues
__pkvm_host_map_guest hypercall to map it, and remembers it in a RB-tree
to unpin it later.

One concern though: can this be done lock-efficiently? For example, in
this pKVM-ARM code in [1] this (hypercall + RB-tree insertion) is done
under write-locked kvm->mmu_lock, so I assume it is prone to contention
when there are stage-2 page faults occurring simultaneously on multiple
CPUs from the same VM. In pKVM on Intel we also have the same per-VM
lock contention issue, though in L0 (see
pkvm_handle_shadow_ept_violation() in [2]) and we are already seeing
~50% perf drop caused by it in some benchmarks.

(To be precise, though, eliminating this per-VM write-lock would not be
enough for eliminating the contention: on both ARM and x86 there is also
global locking in pKVM in L0 down the road [3], for different reasons.)

[1] https://android.googlesource.com/kernel/common/+/d73b3af21fb90f6556383865af6ee16e4735a4a6/arch/arm64/kvm/mmu.c#1341

[2] https://lore.kernel.org/all/20230312180345.1778588-9-jason.cj.chen@intel.com/

[3] https://android.googlesource.com/kernel/common/+/d73b3af21fb90f6556383865af6ee16e4735a4a6/arch/arm64/kvm/hyp/nvhe/mem_protect.c#2176

