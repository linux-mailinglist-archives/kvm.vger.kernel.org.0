Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E249E7A22F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 09:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbfG3H0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 03:26:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42093 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfG3HZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 03:25:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so14623560wrr.9
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 00:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHsfGOiHudmcq3LRs8Aej8bkXt/7q6tGTs328qFT3fk=;
        b=LrczV40PBYaEexs2nulDPR9CbIEw7ONJ5yLSnCOFXbBboSYj4LvB840cLolZPaw7D7
         2SH/3EZ21korc3Uq3tCl5SXaAiI8mZ/Qh6D+mIJstzIy1ez/cPVHYOdwB0h2O0dVyohc
         nxGd5YiRj3L5zZ7QzRfEaUwQFuL2R8291rzLiLCJWEY7dWxNSKh525tdU02FOSmR67l0
         5qd8nclSVf1X3wt81DKacMW3Az7iMY2pq0tKyalbqZ0+SpswNxqkNPCeKU5+CW++CaT0
         0i00b+aNdPcm9Ydin1BMYTueOxMbaRh5qYlmxtwSbiG1CjFl/xxjpkuVu0HVzlN7I/2z
         BolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zHsfGOiHudmcq3LRs8Aej8bkXt/7q6tGTs328qFT3fk=;
        b=lJz4Bbo/tNUxLOJx2n1iUjz2lrY5uwnMwAT9yZPwLB8nOvKckisuQNieJY6DNGrBGU
         efIhfZ8sBTs/17vT5l6jKWMpu8OVplAg9joss+4/vwot8cXGHizEP/kgWa+dACHqpRMb
         Sr21sRgFNZWWUoFS0McWznOQsDOjs19jWOqeFVBBoPv4DekkPDnfn7I+6YtXK1A1/J7A
         6MRspBUUd+qxUajR8HtLQ5PTkfc0wmEy97AYhZhF5Tw/ckcF0+zglGklES747cTpu6dq
         1CkKDsfr9mATeUtH8nKhb+UNfj9TN6ob/RgHavGOgqav/xgr8oxQB7TaMyP+UZS8urlV
         k2IA==
X-Gm-Message-State: APjAAAVS4FWBtFP3LXqy/QhHsRuqBlKK3DAvvi5qahpL3NmYobSYDo1v
        qBlC1x8WRxtBC6EJa7/7HHE20TRPpmwLz2h1U+s=
X-Google-Smtp-Source: APXvYqzfPqQlTpifZXrLgaPOHcYZc+NXl65yC/U+gpC8aBM5EAS2Ozjrobt3zBDfVK+pW5CxK1jdZLTWfym4UfgP5I0=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr118068531wra.328.1564471542194;
 Tue, 30 Jul 2019 00:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <mvm5znkau8u.fsf@suse.de>
In-Reply-To: <mvm5znkau8u.fsf@suse.de>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 12:55:30 +0530
Message-ID: <CAAhSdy2jKQspZNwvd5VnZ8iyWjwe0fGXR+3WwP9cn5pEOcSfVg@mail.gmail.com>
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

Strange, we are not seeing these compile errors.

Anyway, please ensure that you apply Atish's KVM prep patches
(https://lkml.org/lkml/2019/7/26/1271) on Linux-5.3-rcX before applying
this series.

Regards,
Anup
