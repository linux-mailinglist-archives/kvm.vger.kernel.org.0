Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606EC3FE530
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhIAWFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbhIAWFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:05:06 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D90C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:04:09 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f6so1189200iox.0
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uAcZD9SKFW1AVCpO9fy2xcE9RkcQWlr+7iJy1aKTS5k=;
        b=IqadqVyNMf/GZSVQLByPmoGST5Yoe6VHJSXDJKjBpMmn12ALTuYElYhDRaFxgUJUnh
         Ei97BB4BG2dhB0qxmaygwLY66TG2qW8NKDzECdYdgqAl8nmRSlDYtcr3TI42eifXXsRf
         MtTeSKtV9bxupkt2+vheAfn70IzWWR3OgdmgxiY6RCP+/kIpsMylxa88a9gECQKYBM12
         QorJM/x/GLXBb/UWm+hzcrkGhoCM/gBGgmi1sB9G7jJUnEXBvG+5ngzDKj2d+aV7WZJS
         fgMm5+8NEGJTfXvzf0xCZHa9BSFI3GGL68GZkKT/EJ18Ym4XqeRflMw+VXgeQEZmaJFk
         VAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uAcZD9SKFW1AVCpO9fy2xcE9RkcQWlr+7iJy1aKTS5k=;
        b=goHaK2Kpdm4hDUJ3l+MsN+YEP5cszPiFuSfNRdKXrj92EytMpJ8ucmy4Bit63hNwWE
         uuKGCKhyMRitHLeIuYDpuNj1QZQXjgQzlLE0LUynD8L34Dap/bjN2N3S3M5goBMHMjM6
         oYGvCe34LDihxDYj5ot3P2L13qw5SIFNSXxCVW7d+bizt81wi0LyZUMMs0W5jHXimYf2
         kmbxVZT6pRqwbRYPNeg8nU0jK0UIa3Dxyfhm8igu6+BCH57TOidozQBLOlwpprfog+X+
         /V09IvSsCSHCneW4+ySQ3QgLdV2wgj6RaPi0ZJrbqTM0xjKL7G1GF3aM4vbPWR+wTzc7
         PsYw==
X-Gm-Message-State: AOAM530j8P3eHfXqVI9HAQcYPwdpvN39FnHL6m5HN/wseEe/I45Q/9+x
        TRV5qcubxP9evR0WyjTcrqhd0g==
X-Google-Smtp-Source: ABdhPJwTRdJFJ6ex11gPL8dYES9aQ8TT1xcF+pPFPuvFnHsEfoKjvOB5PvAT01pIWLgFdsX/2UcxFA==
X-Received: by 2002:a5d:8d06:: with SMTP id p6mr20177ioj.7.1630533848737;
        Wed, 01 Sep 2021 15:04:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id g14sm418990ila.28.2021.09.01.15.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:04:08 -0700 (PDT)
Date:   Wed, 1 Sep 2021 22:04:04 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer
 selftest
Message-ID: <YS/41Mj4KES1VMrm@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:00PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-11). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Patch-12 adds an option to randomly migrate the vCPUs to different
> physical CPUs across the system. The bug for the fix provided by
> Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
> pending state on deactivation") was discovered using arch_timer
> test with vCPU migrations.
> 
> Since the test heavily depends on interrupts, patch-10 adds a host
> library to setup ARM Generic Interrupt Controller v3 (GICv3). This
> includes creating a vGIC device, setting up distributor and
> redistributor attributes, and mapping the guest physical addresses.
> Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
> which includes initializing the controller, enabling/disabling the
> interrupts, and so on.
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, and so on, are also
> introduced that the test/GICv3 takes advantage of (patches 1 through 8).
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 
> Regards,
> Raghavendra

For later submissions, can you include a lore.kernel.org link to your
older revisions of the series? NBD now, its easy to find in my inbox but
just for future reference.

--
Best,
Oliver
