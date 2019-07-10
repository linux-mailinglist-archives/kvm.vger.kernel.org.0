Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4164B25
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfGJRCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 13:02:40 -0400
Received: from foss.arm.com ([217.140.110.172]:36902 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727291AbfGJRCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 13:02:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0A3A344;
        Wed, 10 Jul 2019 10:02:38 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F16C3F246;
        Wed, 10 Jul 2019 10:02:38 -0700 (PDT)
Date:   Wed, 10 Jul 2019 18:02:35 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
Message-ID: <20190710180235.25c54b84@donnerap.cambridge.arm.com>
In-Reply-To: <20190710132724.28350-1-graf@amazon.com>
References: <20190710132724.28350-1-graf@amazon.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jul 2019 15:27:24 +0200
Alexander Graf <graf@amazon.com> wrote:

Hi,

> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
> It just pokes basic functionality. I've mostly written it to familiarize myself
> with the device, but I suppose having the test around does not hurt, as it also
> exercises the GIC SPI interrupt path.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arm/Makefile.common |   1 +
>  arm/pl031.c         | 227 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h   |   1 +
>  3 files changed, 229 insertions(+)
>  create mode 100644 arm/pl031.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f0c4b5d..b8988f2 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>  tests-common += $(TEST_DIR)/gic.flat
>  tests-common += $(TEST_DIR)/psci.flat
>  tests-common += $(TEST_DIR)/sieve.flat
> +tests-common += $(TEST_DIR)/pl031.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/arm/pl031.c b/arm/pl031.c
> new file mode 100644
> index 0000000..a364a1a
> --- /dev/null
> +++ b/arm/pl031.c
> @@ -0,0 +1,227 @@
> +/*
> + * Verify PL031 functionality
> + *
> + * This test verifies whether the emulated PL031 behaves correctly.

                                     ^^^^^^^^

While I appreciate the effort and like the fact that this actually triggers an SPI, I wonder if this actually belongs into kvm-unit-tests.
After all this just test a device purely emulated in (QEMU) userland, so it's not really KVM related.

What is the general opinion on this?
Don't we care about this hair-splitting as long as it helps testing?
Do we even want to extend kvm-unit-tests coverage to more emulated devices, for instance virtio?

Cheers,
Andre.

