Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4B1159369
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgBKPmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 10:42:50 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34619 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgBKPmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 10:42:49 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so13203620oig.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 07:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pd5As4/L2oTjSBZjWpPOMKqBaFJ2ADt2yHhVgPMSRMg=;
        b=NgbxyWkY7QLXWCbElISLSiWcF/s7LTdVaFB+VXa8xsn1F/e7JfYIPCMIKBEQCXs5nW
         iXI+lGmftjS4OwXM1uikkl0qHoPcgl0A7DSAXpDV/lrluZA6CiSTEoUq92TyQaNVgo0s
         /OufFYqsDyXdkgxkQqXIZhR/gn2hKjRt+DQG8idlZbE7kgI2SFYEcROBNbcJLk6j3cEh
         /CqMY4GMl6dhkdmQzr7kTNo1+lrBjIxHTQtCRI7+McqZKg42LNfa1nLKL34X3jNcL9La
         xvhIiQEk9HnxRhb7Fy0CjnmAop0gorfnt2hoFTSxgquVxnuLd8s9nlZHgy7p6DjSKqr4
         E0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pd5As4/L2oTjSBZjWpPOMKqBaFJ2ADt2yHhVgPMSRMg=;
        b=tDnigCyaGJGNaDEtXfKgomDDTZ8OgYt/cCfWjmhbEGhjRrpmMkJnESgmR4hwkJaBea
         aTsJt5QdJkx09Brn4vbQjuwFojnrNSDY4q6Ncp4uOL1CfgdLBZ303PpWZ/ZUuHQ93eL6
         BrFbBcovx0w/wTr3SrsZFyKDceMWoN0XMZ5V6P+97GQU4nY8TISHCVX4ayiX3jzyhFA5
         ChoLP/Q8dY4r/mwPJ7Kd9pzMJO4aau2Ir8qMBTQkDTxVOauekfzabXO4xcpJtrdcbZdK
         4P+c3S87dNNIPiSVIhfptl1cUGdXyu3sogrikJJl4coir1MF93x252G8LilxCyVccVrw
         zbFA==
X-Gm-Message-State: APjAAAUZ4MJbkxxF8cGB2YMCgTtzAhRlSZQAh8Yljlf0gaX7e6RyrW6p
        j379FU8eWUDpvVhs4R/HFT8KBPWn9aLU1ii15TTgbA==
X-Google-Smtp-Source: APXvYqzbKMnFsR97qzwElnPnwovDkYV7Zzu3AUttOV+j0mhUDouh3J3SUypPbNHSVUfPQ6WO115YGcX7PLsQ24pG4y8=
X-Received: by 2002:a05:6808:289:: with SMTP id z9mr3174520oic.48.1581435769182;
 Tue, 11 Feb 2020 07:42:49 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Feb 2020 15:42:38 +0000
Message-ID: <CAFEAcA8iBvM2xguW2_6OFWDjPPEzEorief4F2aoh0Vitp466rQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/9] KVM: arm64: PMUv3 Event Counter Tests
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Eric Auger <eric.auger.pro@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>
> This series implements tests exercising the PMUv3 event counters.
> It tests both the 32-bit and 64-bit versions. Overflow interrupts
> also are checked. Those tests only are written for arm64.
>
> It allowed to reveal some issues related to SW_INCR implementation
> (esp. related to 64-bit implementation), some problems related to
> 32-bit <-> 64-bit transitions and consistency of enabled states
> of odd and event counters (See [1]).
>
> Overflow interrupt testing relies of one patch from Andre
> ("arm: gic: Provide per-IRQ helper functions") to enable the
> PPI 23, coming from "arm: gic: Test SPIs and interrupt groups"
> (https://patchwork.kernel.org/cover/11234975/). Drew kindly
> provided "arm64: Provide read/write_sysreg_s".
>
> All PMU tests can be launched with:
> ./run_tests.sh -g pmu
> Tests also can be launched individually. For example:
> ./arm-run arm/pmu.flat -append 'chained-sw-incr'
>
> With KVM:
> - chain-promotion and chained-sw-incr are known to be failing.
>   [1] proposed a fix.
> - On TX2, I have some random failures due to MEM_ACCESS event
>   measured with a great disparity. This is not observed on
>   other machines I have access to.
> With TCG:
> - all new tests are skipped

I'm having a go at using this patchset to test the support
I'm adding for TCG for the v8.1 and v8.4 PMU extensions...

Q1: how can I get run_tests.sh to pass extra arguments to
QEMU ? The PMU events check will fail unless QEMU gets
the '-icount 8' to enable cycle-counting, but although
the underlying ./arm/run lets you add arbitrary extra
arguments to QEMU, run_tests.sh doesn't seem to. Trying to
pass them in via "QEMU=/path/to/qemu -icount 8" doesn't
work either.

Q2: do you know why arm/pmu.c:check_pmcr() insists that
PMCR.IMP is non-zero? The comment says "simple sanity check",
but architecturally a zero IMP field is permitted (meaning
"go look at MIDR_EL1 instead"). This causes TCG to fail this
test on '-cpu max', because in that case we set PMCR.IMP
to the same thing as MIDR_EL1.Implementer which is 0
("software use", since QEMU is software...)

thanks
-- PMM
