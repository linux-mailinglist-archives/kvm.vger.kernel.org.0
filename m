Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D3C7AA7B
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 16:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfG3OCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 10:02:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46130 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfG3OCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 10:02:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so65887356wru.13
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 07:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9EuouZv6KkAfnXeYgN1dDIcC6u4TgIuceUgUlR6uEAU=;
        b=IYie+gIAJBo6rwW5fe6D46LX3Jy3JOkiILhKTesCN4KV9SaZi4VkyGHGNg6ftjUt1K
         qcbd+LzDMJVme1SOahC+FxLrpo0KfYeNJXYEhi7D7qfHKueVzb8HVmHY3+oHWqffLz5J
         GeAdjSDdbOOoIbhlDTN4XlU5VMdSqtjLzO1aItZIqNJsUhLUFWAGoO0/zswFdrJdPzma
         ueYYvqDb7Aq1c4S5hlQxnOLVyqa7MFeoppB/2lGEgwD00y5HdRoZjAuHpSTdWEIKL4t4
         98/XVIWQg6pm0NEWjTw3fP47+1JwGV9HKNamlY1jsR+F3lbGeChoBBmmqd/7me67rB/T
         lkTg==
X-Gm-Message-State: APjAAAWmCu/ET1kWJup/07T/4ZTlYb+vX+C7pc6RRGn4n9EQm3qgv9nB
        zG6njRW7g1BzICyKoAa72mab+w==
X-Google-Smtp-Source: APXvYqz444q5M6LOXoHcyZ0+5NhLAV2GC/dilLeCMRigSflzkicbG33/VTK0UCpeR27ntA61CsOd8w==
X-Received: by 2002:a5d:518d:: with SMTP id k13mr32991874wrv.40.1564495330668;
        Tue, 30 Jul 2019 07:02:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id j17sm107585902wrb.35.2019.07.30.07.02.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:02:09 -0700 (PDT)
Subject: Re: [RFC PATCH 00/16] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <72e9f668-f496-3fca-a1a8-a3c3122a3fd9@redhat.com>
 <CAAhSdy3Z6d2phRGo20eNWfa4onFwFtsOUPM+OCD465y0tvQ5wg@mail.gmail.com>
 <965cffdb-86e2-b422-9c23-345c7100fd88@redhat.com>
 <CAAhSdy0Sy9YV5ymdFk0URLY4GvOkWaWOpC_Dju+1ada_yc=Pmw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c430df93-836a-3cd4-eac1-493833e79ca9@redhat.com>
Date:   Tue, 30 Jul 2019 16:02:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy0Sy9YV5ymdFk0URLY4GvOkWaWOpC_Dju+1ada_yc=Pmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 15:50, Anup Patel wrote:
>> BTW, since IPIs are handled in the SBI I wouldn't bother with in-kernel
>> PLIC emulation unless you can demonstrate performance improvements (for
>> example due to irqfd).  In fact, it may be more interesting to add
> 
> I thought VHOST requires irqfd and we would certainly endup providing
> in-kernel PLIC emulation to support VHOST.

vhost only needs an eventfd, userspace can poll the eventfd and inject
the irq as usual with KVM_INTERRUPT.  Of course that can be slower, but
you can benchmark it and see if it's indeed a good reason for in-kernel
PLIC.

>> plumbing for userspace handling of selected SBI calls (in addition to
>> get/putchar, sbi_system_reset and sbi_hart_down look like good
>> candidates in SBI v0.2).
> 
> The get/putchar SBI v0.1 calls won't be encouraged going forward because
> we already have earlycon implmentation in-place and Guest kernel can directly
> write to UART registers for earlyprints.

> If we still wanted to implement get/putchar calls then we would need a RISC-V
> specific exit reason in KVM. We have tried to avoid RISC-V specific IOCTLs
> or exit reason in this series.

Sounds good.

Paolo

>>
>>> We were thinking to keep KVM RISC-V disabled by default (i.e. keep it
>>> experimental) until we have validated it on some FPGA or real HW. For now,
>>> users can explicitly enable it and play-around on QEMU emulation. I hope
>>> this is fine with most people ?
>>
>> That's certainly okay with me.
>>
> 
> Thanks,
> Anup
> 

