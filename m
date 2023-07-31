Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCECB769B09
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjGaPpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 11:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjGaPpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 11:45:49 -0400
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 988BE170A;
        Mon, 31 Jul 2023 08:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Message-ID:Date:
        MIME-Version:User-Agent:Subject:To:Cc:References:From:
        In-Reply-To:Content-Type:Content-Transfer-Encoding; bh=vFtCHrIgi
        gSbtoNV1mnQVn3W557qU3XL1eHMMQCtsxQ=; b=PnDU1XgfaWjFE0R/iRY8ZcwRU
        PjF2z+Wk29ng5gv49OSFr41GNTf65fqJWqn7Huyen1+xoHtIeLwBZAF6xoTxNxRZ
        0jGAyVnVPUc2GFTo2bDCnab2avuPJu9z69eqpWqf3CDIcZHRF4uR9A4XexwkYqIW
        h5ePxnbDqU1FyLL47w=
Received: from [192.168.199.152] (unknown [180.158.176.68])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDHNJAZ18dkdd_iAA--.31594S2;
        Mon, 31 Jul 2023 23:45:29 +0800 (CST)
Message-ID: <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
Date:   Mon, 31 Jul 2023 23:45:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
From:   wuzongyong <wuzongyo@mail.ustc.edu.cn>
In-Reply-To: <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygDHNJAZ18dkdd_iAA--.31594S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1fJrWxWw1kAF1kCryxuFg_yoW8uFy7pF
        Z7ta4YyFsrGr1kAr12yr48Za4Fv39xJFsrXrn8J3s8AayUZas2gFWI9rZ8A3WDZrWfWw1j
        qa4IqrZru39rArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUy2b7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s02
        6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
        I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
        6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
        0_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j
        6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jeXdbUUUUU=
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/7/31 23:03, Tom Lendacky wrote:
> On 7/31/23 09:30, Sean Christopherson wrote:
>> On Sat, Jul 29, 2023, wuzongyong wrote:
>>> Hi,
>>> I am writing a firmware in Rust to support SEV based on project td-shim[1].
>>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
>>> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
>>> #UD.
>>
>> ...
>>
>>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
>>> #BP.
>>> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
>>> Any suggestion is appreciated!
>>
>> Have you tried my suggestions from the other thread[*]?
Firstly, I'm sorry for sending muliple mails with the same content. I thought the mails I sent previously 
didn't be sent successfully.
And let's talk the problem here.
>>
>>    : > > I'm curious how this happend. I cannot find any condition that would
>>    : > > cause the int3 instruction generate a #UD according to the AMD's spec.
>>    :
>>    : One possibility is that the value from memory that gets executed diverges from the
>>    : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
>>    : be the case in this test), stale cache/tlb entries, etc.
>>    :
>>    : > > BTW, it worked nomarlly with qemu and ovmf.
>>    : >
>>    : > Does this happen every time you boot the guest with your firmware? What
>>    : > processor are you running on?
>>    :
Yes, every time.
The processor I used is EPYC 7T83.
>>    : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
>>    : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
>>    : tracepoints.
>
> I have a feeling that KVM is injecting the #UD, but it will take instrumenting KVM to see which path the #UD is being injected from.
>
> Wu Zongyo, can you add some instrumentation to figure that out if the trace points towards KVM injecting the #UD?
Ok, I will try to do that.
>
> Thanks,
> Tom
>
>>
>> [*] https://lore.kernel.org/all/ZMFd5kkehlkIfnBA@google.com

