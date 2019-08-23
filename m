Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1451B9AE58
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393012AbfHWLot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:44:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:61375 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392869AbfHWLos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566560687; x=1598096687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RHYS8jGRkdr3gB9hs1d2WnBjre+WbM/f68EhPrZ6uEY=;
  b=aGd0V+IFmEhhOVD6XFz1K+hfKvUvwxfmSd6QCGoGaf4e+wUT9E9EiYZb
   He8XU0JP3cP7cfdRu42bUEwkdkYCAEbd3Y1S/ddvbmxrUvtsx4povt5K/
   JS3B7XnAFsCGx/Oqou/Z7KIkiQsOIT+mK3N0NBI0Yu70rg8mSBHGu/4p/
   k=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="823019313"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Aug 2019 11:44:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 901A6A24D2;
        Fri, 23 Aug 2019 11:44:44 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:44:44 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:44:43 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Fri, 23 Aug 2019 11:44:43 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.com>
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
Thread-Topic: [PATCH v5 00/20] KVM RISC-V Support
Thread-Index: AQHVWYn+hiT/O4W/4EWKNvIhq6UCB6cIl+EAgAAFWns=
Date:   Fri, 23 Aug 2019 11:44:43 +0000
Message-ID: <757C929B-D26C-46D9-98E8-1191E3B86F3C@amazon.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>,<CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
In-Reply-To: <CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 23.08.2019 um 13:26 schrieb Anup Patel <anup@brainfault.org>:
>=20
>> On Fri, Aug 23, 2019 at 1:39 PM Alexander Graf <graf@amazon.com> wrote:
>>=20
>>> On 22.08.19 10:42, Anup Patel wrote:
>>> This series adds initial KVM RISC-V support. Currently, we are able to =
boot
>>> RISC-V 64bit Linux Guests with multiple VCPUs.
>>>=20
>>> Few key aspects of KVM RISC-V added by this series are:
>>> 1. Minimal possible KVM world-switch which touches only GPRs and few CS=
Rs.
>>> 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
>>> 3. KVM ONE_REG interface for VCPU register access from user-space.
>>> 4. PLIC emulation is done in user-space. In-kernel PLIC emulation, will
>>>    be added in future.
>>> 5. Timer and IPI emuation is done in-kernel.
>>> 6. MMU notifiers supported.
>>> 7. FP lazy save/restore supported.
>>> 8. SBI v0.1 emulation for KVM Guest available.
>>>=20
>>> Here's a brief TODO list which we will work upon after this series:
>>> 1. Handle trap from unpriv access in reading Guest instruction
>>> 2. Handle trap from unpriv access in SBI v0.1 emulation
>>> 3. Implement recursive stage2 page table programing
>>> 4. SBI v0.2 emulation in-kernel
>>> 5. SBI v0.2 hart hotplug emulation in-kernel
>>> 6. In-kernel PLIC emulation
>>> 7. ..... and more .....
>>=20
>> Please consider patches I did not comment on as
>>=20
>> Reviewed-by: Alexander Graf <graf@amazon.com>
>>=20
>> Overall, I'm quite happy with the code. It's a very clean implementation
>> of a KVM target.
>=20
> Thanks Alex.
>=20
>>=20
>> The only major nit I have is the guest address space read: I don't think
>> we should pull in code that we know allows user space to DOS the kernel.
>> For that, we need to find an alternative. Either you implement a
>> software page table walker and resolve VAs manually or you find a way to
>> ensure that *any* exception taken during the read does not affect
>> general code execution.
>=20
> I will send v6 next week. I will try my best to implement unpriv trap
> handling in v6 itself.

Are you sure unpriv is the only exception that can hit there? What about NM=
Is? Do you have #MCs yet (ECC errors)? Do you have something like ARM's #SE=
rror which can asynchronously hit at any time because of external bus (PCI)=
 errors?

Alex

>=20
> Regards,
> Anup
>=20
>>=20
>>=20
>> Thanks,
>>=20
>> Alex
