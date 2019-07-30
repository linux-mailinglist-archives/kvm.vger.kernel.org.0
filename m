Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C07A261
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 09:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfG3Hg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 03:36:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45865 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730585AbfG3Hg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 03:36:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so64537936wre.12
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 00:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6U2acd1QmQp/fq0L96aRRGzLE2S05j+iUMMl/7Ujgp4=;
        b=I1JeO/u2t/9GtL4gb/6m3g7NQxNda7RBoL3u/BA4m3wmjG5pt9vru1WU9kUlKHh+TC
         5B5w9WYYre+FTnHTNqUp1FeYn/NuopIyDJJ5jD22bCDNEtLOl2qp7mqD5yUp0iPxbHMs
         U5KnIhavW/n2QLqF37U2bM9CqL7CPSf7Blg3DxyVQwBTruspAU+/kTvscIiG1RojUOUT
         q/fACG+tK3bBrNQXzYUjfKHji27uEAeZE/AA1o7lA/5MlHRq1MtiF8EgSuog2xvJ3RE2
         0tUerzh5y9KoUC7nN7zl+rVjq7brxpYDqrP+GsPO9SR8uFrWI/SkZFF6FerhO2zo5j87
         dzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6U2acd1QmQp/fq0L96aRRGzLE2S05j+iUMMl/7Ujgp4=;
        b=OZaT0fNO1NiT83TfUhHmrYh7rN8CgL7OpWPooeLXtaPwe5BROBX5b5ForXzuZbYWW9
         OQerxmN3fjpIiyRdnXxSZkkYd05g9lXHeH2GXObSHTexsbdhhUAEcn9I74VeD/JDQBxE
         qx6FzxeT6QOTf6/2IVai6Yf/1fMcK2cgcHe9YimBzxrSrm9sQSouuvX19eAOK0yiGd9D
         jkIMQ8GT0uHa1zjZ6KQoVgxn0Zpn5QxYFqltCvzNe8mFvkLHBPQOzVhYC5hQB7UXG4CB
         0sCTKE10M7nRktS2eindSUQawKEtex10HYu/ddMQbNp9kK5q4IAvooZHc4Aegt9dq0qR
         rdZg==
X-Gm-Message-State: APjAAAVriyTq0JSbjyDIa3mR8zuyFHJ+DVrwfw3XfifFF6bBCfqIoNyc
        z66ElK8K7s9TOIuqrSB3VGtKLw+TUXy43Aeg9PE=
X-Google-Smtp-Source: APXvYqySD/VhLD/1gRxFJ7qx4IrEkz4AhGCFJYUHqM5n38YeZUjiLceMw/XbhrPAFunOMf8mFEW26/rfKEpjphPolrI=
X-Received: by 2002:a5d:6284:: with SMTP id k4mr93182866wru.179.1564472186392;
 Tue, 30 Jul 2019 00:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <mvm5znkau8u.fsf@suse.de>
In-Reply-To: <mvm5znkau8u.fsf@suse.de>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 13:06:15 +0530
Message-ID: <CAAhSdy3+vkJkugqrDrw4tnPWRsPw0L8r_49pEWqrqxes69X2Pw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] KVM RISC-V Support
To:     Andreas Schwab <schwab@suse.de>
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

On Tue, Jul 30, 2019 at 12:23 PM Andreas Schwab <schwab@suse.de> wrote:
>
> ERROR: "riscv_cs_get_mult_shift" [arch/riscv/kvm/kvm.ko] undefined!
> ERROR: "riscv_isa" [arch/riscv/kvm/kvm.ko] undefined!
> ERROR: "smp_send_reschedule" [arch/riscv/kvm/kvm.ko] undefined!
> ERROR: "riscv_timebase" [arch/riscv/kvm/kvm.ko] undefined!

Found the issue.

These symbols are not exported and you are building KVM RISC-V as module.

Thanks for reporting. We will fix it.

Regards,
Anup
