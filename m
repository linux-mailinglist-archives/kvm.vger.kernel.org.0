Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C72A0A96
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgJ3QAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:00:55 -0400
Received: from foss.arm.com ([217.140.110.172]:38568 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgJ3QAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:00:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93CCD1435;
        Fri, 30 Oct 2020 09:00:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3CA13F719;
        Fri, 30 Oct 2020 09:00:52 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Andrew Jones <drjones@redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
Message-ID: <a231b40f-ff99-1529-387b-d9708862cc62@arm.com>
Date:   Fri, 30 Oct 2020 16:02:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Adding Andrew to CC list, somehow I forgot, sorry for that.

Thanks,

Alex

On 10/27/20 5:19 PM, Alexandru Elisei wrote:
> This series implements two basic tests for KVM SPE: one that checks that
> the reported features match what is specified in the architecture,
> implemented in patch #3 ("arm64: spe: Add introspection test"), and another
> test that checks that the buffer management interrupt is asserted
> correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
> of the patches are either preparatory patches, or a fix, in the case of
> patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").
>
> This series builds on Eric's initial version [1], to which I've added the
> buffer tests that I used while developing SPE support for KVM.
>
> KVM SPE support is current in RFC phase, hence why this series is also sent
> as RFC. The KVM patches needed for the tests to work can be found at [2].
> Userspace support is also necessary, which I've implemented for kvmtool;
> this can be found at [3]. This series is also available in a repo [4] to make
> testing easier.
>
> [1] https://www.spinics.net/lists/kvm/msg223792.html
> [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3
> [3] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
> [4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v2
>
> Alexandru Elisei (3):
>   lib/{bitops,alloc_page}.h: Add missing headers
>   lib: arm/arm64: Add function to unmap a page
>   am64: spe: Add buffer test
>
> Eric Auger (2):
>   arm64: Move get_id_aa64dfr0() in processor.h
>   arm64: spe: Add introspection test
>
>  arm/Makefile.arm64        |   1 +
>  lib/arm/asm/mmu-api.h     |   1 +
>  lib/arm64/asm/processor.h |   5 +
>  lib/alloc_page.h          |   2 +
>  lib/bitops.h              |   2 +
>  lib/libcflat.h            |   1 +
>  lib/arm/mmu.c             |  32 +++
>  arm/pmu.c                 |   1 -
>  arm/spe.c                 | 506 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |  15 ++
>  10 files changed, 565 insertions(+), 1 deletion(-)
>  create mode 100644 arm/spe.c
>
