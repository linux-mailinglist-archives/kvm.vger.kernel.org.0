Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFEE7A270
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfG3Hml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 03:42:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:57452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbfG3Hml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 03:42:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61295AE5A;
        Tue, 30 Jul 2019 07:42:39 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Anup Patel <anup@brainfault.org>
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv\@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/16] KVM RISC-V Support
References: <20190729115544.17895-1-anup.patel@wdc.com>
        <mvm5znkau8u.fsf@suse.de>
        <CAAhSdy2jKQspZNwvd5VnZ8iyWjwe0fGXR+3WwP9cn5pEOcSfVg@mail.gmail.com>
X-Yow:  FIRST, I was in a TRUCK...THEN, I was in a DINER...
Date:   Tue, 30 Jul 2019 09:42:38 +0200
In-Reply-To: <CAAhSdy2jKQspZNwvd5VnZ8iyWjwe0fGXR+3WwP9cn5pEOcSfVg@mail.gmail.com>
        (Anup Patel's message of "Tue, 30 Jul 2019 12:55:30 +0530")
Message-ID: <mvmo91c9de9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Jul 30 2019, Anup Patel <anup@brainfault.org> wrote:

> On Tue, Jul 30, 2019 at 12:23 PM Andreas Schwab <schwab@suse.de> wrote:
>>
>> ERROR: "riscv_cs_get_mult_shift" [arch/riscv/kvm/kvm.ko] undefined!
>> ERROR: "riscv_isa" [arch/riscv/kvm/kvm.ko] undefined!
>> ERROR: "smp_send_reschedule" [arch/riscv/kvm/kvm.ko] undefined!
>> ERROR: "riscv_timebase" [arch/riscv/kvm/kvm.ko] undefined!
>
> Strange, we are not seeing these compile errors.

None of these symbols are exported.

> Anyway, please ensure that you apply Atish's KVM prep patches
> (https://lkml.org/lkml/2019/7/26/1271) on Linux-5.3-rcX before applying
> this series.

None of these patches contain EXPORT_SYMBOL declarations.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
