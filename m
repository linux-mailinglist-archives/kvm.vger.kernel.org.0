Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF06C9AF75
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394705AbfHWM2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:28:20 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:63478 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389266AbfHWM2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566563299; x=1598099299;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gZe9dv7UhZ0T/4gNWDLLPmXvjNu2lShnoO5YUyoC53g=;
  b=tYPOT4idYO91bzSUhGJziZeEGw74A4TGah3/DkOZjsLamQXVkCBuTgh7
   d0PG4kAVzoMdjCw9BT2HIO3tkfnY2OsY5Cy1yXq4PeSmwj3SaAJVyoyxA
   agUKLrEE+Vok16phS+C+POSEXt96KA/1tNZt7G5UEZJlXFXOLdxc94FyQ
   k=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="411336772"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Aug 2019 12:28:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 523ABA2782;
        Fri, 23 Aug 2019 12:28:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 12:28:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 12:28:09 +0000
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
 <CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
 <757C929B-D26C-46D9-98E8-1191E3B86F3C@amazon.com>
 <fda67a5d-6984-c3ef-8125-7805d927f15b@redhat.com>
 <CAAhSdy1k96m8GinxAhcfRL_gOxCzK+ODfyjDxCmr-AF2ycntwA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <5a9ccf5f-ee75-9289-814e-0c8b9b3c3f00@amazon.com>
Date:   Fri, 23 Aug 2019 14:28:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy1k96m8GinxAhcfRL_gOxCzK+ODfyjDxCmr-AF2ycntwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.67]
X-ClientProxiedBy: EX13D03UWC001.ant.amazon.com (10.43.162.136) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.08.19 14:19, Anup Patel wrote:
> On Fri, Aug 23, 2019 at 5:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 23/08/19 13:44, Graf (AWS), Alexander wrote:
>>>> Overall, I'm quite happy with the code. It's a very clean implementation
>>>> of a KVM target.
>>
>> Yup, I said the same even for v1 (I prefer recursive implementation of
>> page table walking but that's all I can say).
>>
>>>> I will send v6 next week. I will try my best to implement unpriv
>>>> trap handling in v6 itself.
>>> Are you sure unpriv is the only exception that can hit there? What
>>> about NMIs? Do you have #MCs yet (ECC errors)? Do you have something
>>> like ARM's #SError which can asynchronously hit at any time because
>>> of external bus (PCI) errors?
>>
>> As far as I know, all interrupts on RISC-V are disabled by
>> local_irq_disable()/local_irq_enable().
> 
> Yes, we don't have per-CPU interrupts for async bus errors or
> non-maskable interrupts. The local_irq_disable() and local_irq_enable()
> affect all interrupts (excepts traps).

Awesome, so that means you really only need to worry about traps. Even 
easier then! :)

Also, you want to look out for a future extension that adds any of the 
above (NMI, MCE, SError on local bus), as that would then break the 
function ;)


Alex
