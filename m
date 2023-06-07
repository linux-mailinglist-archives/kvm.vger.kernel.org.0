Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ED97262BF
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbjFGO0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbjFGO0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 10:26:42 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9071BCC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 07:26:39 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QbqR15MCqzMqD7J;
        Wed,  7 Jun 2023 16:26:37 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QbqR069WfzMprYb;
        Wed,  7 Jun 2023 16:26:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1686147997;
        bh=m5/OU8ZA8BTOAguX4rFhNG92rAq6z9BOAQWIqfh1lpM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HC7D6SuBn1pj6U+C0vEMnwbov6Cw7weqK0rSI/0YxUUCHYIWQ15Hjuv5JdaYdulRj
         cs03XpEcjog/kSrqgS7+O5HgWuYEqXWQGJwh8cuId70OkOJVIdY8JoUrkeBRqX4AR9
         U8EI+YWlqscxalhMP4/cTz1piCFXlIryyb3S8J8g=
Message-ID: <3fd0f245-bad6-ab5b-5b52-c44a8afe2bfe@digikod.net>
Date:   Wed, 7 Jun 2023 16:26:36 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Content-Language: en-US
To:     Keir Fraser <keirf@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>, kvm@vger.kernel.org,
        android-kvm@google.com, x86@kernel.org,
        linux-hardening@vger.kernel.org
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com> <ZB17s69rC9ioomF7@google.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ZB17s69rC9ioomF7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 24/03/2023 11:30, Keir Fraser wrote:
> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>
>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>> There are similar use cases on x86 platforms requesting protected
>>>>> environment which is isolated from host OS for confidential computing.
>>>>
>>>> What exactly are those use cases?  The more details you can provide, the better.
>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
>>>> the pKVM implementation.
>>>
>>> Thanks Sean for your comments, I am very appreciated!
>>>
>>> We are expected
>>
>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
>> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
>> then please work with whoever you need to in order to get permission to fully
>> disclose the use case.  Because realistically, without knowing exactly what is
>> in scope and why, this is going nowhere.
> 
> This is being seriously evaluated by ChromeOS as an alternative to
> their existing ManaTEE design. Compared with that (hypervisor == full
> Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
> "VM" runs closer to native and without nested scheduling, demonstrated
> better performance, and closer alignment with Android virtualisation
> (that's my team, which of course is ARM focused, but we'd love to see
> broader uptake of pKVM in the kernel).

This pKVM implementation would definitely be useful to protect the host 
from itself (i.e. improved kernel self-protection) thanks to the 
Hypervisor-Enforced Kernel Integrity patch series: 
https://lore.kernel.org/all/20230505152046.6575-1-mic@digikod.net/

Use cases would then include all bare metal Linux systems with security 
requirements. They would initially configure pKVM with the dedicated 
Heki hypercalls, but not necessarily launch guest VMs.


> 
>   -- Keir
> 
>>> to run protected VM with general OS and may with pass-thru secure devices support.
>>
>> Why?  What is the actual use case?
>>
>>> May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
>>> work out a SW-TDX solution, or just do some leverage from SEAM code?
>>
>> Throw away TDX and let KVM run its own code in SEAM.
>>
> 
