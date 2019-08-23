Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF49AEDC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405341AbfHWML2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:11:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34564 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405323AbfHWML2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:11:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so8451686wrn.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRAIEkmwp6JE/WX2NGJMgDWxiWJMs7wvHv42hCwyQfI=;
        b=YEpPQAEvWA9shVqsD3mh8d8r/uR1cXm76LWodn7SiQ5pxKz7XzPS/ZenBR9boBZyaG
         caGIKN8nTkYwxmJT/mzu7KBhHgk4GeQi8KzLsfjZvbcWPNgfjk8U7abtLLKyXdj5Iamh
         WEsHh//w59EZk4ZHq2zco+dvqKcSqeOpqKfAgAxs24rR3jk7qj70m/eSqghKeO27BCbg
         57q5BniRpmfS+Onee+Wyw2JZmiPvY2YoeKKMT+7msYpvsBdu8lDwXAgn8HTnnVp8Mqhf
         ANB5y7OGnpvyOk+4i8bGpz2IwFMlbb8/P8hrdq+BDZUs4bKztK084OcOQFc10fpgUOCS
         PrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRAIEkmwp6JE/WX2NGJMgDWxiWJMs7wvHv42hCwyQfI=;
        b=D1nErf8LIjBCgx3yL+ihh4pZiSCcOXaaFAlvb+Ckf3m/JlUYEvPTaL/aa3UJDutNYI
         XQkexEbOhKgt7ojPoaU6HYb0g6jPjggtWA4cS6VHWzMUC8Ic5wt4ahC4rsanuhZ20Bsd
         zeoBPXFTa9tKLB/rRcCiP8XHrUn/E9CyfODhtxYWzw2qCTlpR11wYQXVwo1z/75nTuJE
         JtGAx2r0s2ZIAX9Q3xIoXQwDC6W35enOTUx/bzsIP3Q/RAveN8iC3nHBs7/xckfco1Lf
         HmgbCa07Tl9oh1EqeVHcjjwBk7yRLMp2rbJv062UNimERFSBzo14raOJNIjJb5Suvkeh
         QlJg==
X-Gm-Message-State: APjAAAXPoeZpmuGbBEBED1Bj6u2Axx4AawaeuDWOdnwoEKXG+CyvopRc
        RJsXGg2zgfu0YErCMD7xcvRl2BJM3XKhsdkfLTQp2g==
X-Google-Smtp-Source: APXvYqweuPNty8ifIydMeMGqUfpAmO11I/wuZUHMJ01iiMWWORMqB38dG8e4+ued1WCyfTwxqp2l51dVxUm9msyVfcc=
X-Received: by 2002:a5d:4ecb:: with SMTP id s11mr4728857wrv.323.1566562285504;
 Fri, 23 Aug 2019 05:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-16-anup.patel@wdc.com>
 <09d74212-4fa3-d64c-5a63-d556e955b88c@amazon.com> <CAAhSdy36q5-x8cXM=M5S3cnE2nvCMhcsfuQayVt7jahd58HWFw@mail.gmail.com>
 <CA3A6A8A-0227-4B92-B892-86A0C7CA369E@amazon.com> <CAAhSdy2FFmCZJhNnMojp8QbiD-t6=4XrNtE9KGnCG_-mPb19-A@mail.gmail.com>
 <e369eba6-e659-2892-9cb9-a631dd10153a@amazon.com>
In-Reply-To: <e369eba6-e659-2892-9cb9-a631dd10153a@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 17:41:13 +0530
Message-ID: <CAAhSdy2sknED0W5-SpS4cP46cnS6biHYs_jRDgCj_Ucw5PUYzg@mail.gmail.com>
Subject: Re: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 5:19 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 23.08.19 13:46, Anup Patel wrote:
> > On Fri, Aug 23, 2019 at 5:03 PM Graf (AWS), Alexander <graf@amazon.com> wrote:
> >>
> >>
> >>
> >>> Am 23.08.2019 um 13:05 schrieb Anup Patel <anup@brainfault.org>:
> >>>
> >>>> On Fri, Aug 23, 2019 at 1:23 PM Alexander Graf <graf@amazon.com> wrote:
> >>>>
> >>>>> On 22.08.19 10:46, Anup Patel wrote:
> >>>>> From: Atish Patra <atish.patra@wdc.com>
> >>>>>
> >>>>> The RISC-V hypervisor specification doesn't have any virtual timer
> >>>>> feature.
> >>>>>
> >>>>> Due to this, the guest VCPU timer will be programmed via SBI calls.
> >>>>> The host will use a separate hrtimer event for each guest VCPU to
> >>>>> provide timer functionality. We inject a virtual timer interrupt to
> >>>>> the guest VCPU whenever the guest VCPU hrtimer event expires.
> >>>>>
> >>>>> The following features are not supported yet and will be added in
> >>>>> future:
> >>>>> 1. A time offset to adjust guest time from host time
> >>>>> 2. A saved next event in guest vcpu for vm migration
> >>>>
> >>>> Implementing these 2 bits right now should be trivial. Why wait?
> >>>
>
> [...]
>
> >>>> ... in fact, I feel like I'm missing something obvious here. How does
> >>>> the guest trigger the timer event? What is the argument it uses for that
> >>>> and how does that play with the tbfreq in the earlier patch?
> >>>
> >>> We have SBI call inferface between Hypervisor and Guest. One of the
> >>> SBI call allows Guest to program time event. The next event is specified
> >>> as absolute cycles. The Guest can read time using TIME CSR which
> >>> returns system timer value (@ tbfreq freqency).
> >>>
> >>> Guest Linux will know the tbfreq from DTB passed by QEMU/KVMTOOL
> >>> and it has to be same as Host tbfreq.
> >>>
> >>> The TBFREQ config register visible to user-space is a read-only CONFIG
> >>> register which tells user-space tools (QEMU/KVMTOOL) about Host tbfreq.
> >>
> >> And it's read-only because you can not trap on TB reads?
> >
> > There is no TB registers.
> >
> > The tbfreq can only be know through DT/ACPI kind-of HW description
> > for both Host and Guest.
> >
> > The KVM user-space tool needs to know TBFREQ so that it can set correct
> > value in generated DT for Guest Linux.
>
> So what access methods do get influenced by TBFREQ? If it's only the SBI
> timer, we can control the frequency, which means we can make TBFREQ
> read/write.

There are two things influenced by TBFREQ:
1. TIME CSR which is a free running counter
2. SBI calls for programming next timer event

The Guest TIME CSR will be at same rate as Host TIME CSR so
we cannot show different TBFREQ to Guest Linux.

In future, we will be having a dedicated RISC-V timer extension which
will have all programming done via CSRs but until then we are stuck
with TIME CSR + SBI call combination.

Regards,
Anup

>
>
> Alex
