Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96355258B6A
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIAJYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 05:24:01 -0400
Received: from foss.arm.com ([217.140.110.172]:39056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgIAJYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 05:24:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC94D30E;
        Tue,  1 Sep 2020 02:24:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E6123F71F;
        Tue,  1 Sep 2020 02:23:59 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC 0/4] KVM: arm64: Statistical Profiling
 Extension Tests
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        qemu-devel@nongnu.org, drjones@redhat.com, andrew.murray@arm.com,
        sudeep.holla@arm.com, maz@kernel.org, will@kernel.org,
        haibo.xu@linaro.org
References: <20200831193414.6951-1-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b5eb2cd0-9798-6e40-7690-78992eca30fd@arm.com>
Date:   Tue, 1 Sep 2020 10:24:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831193414.6951-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

These patches are extremely welcome! I took over the KVM SPE patches from Andrew
Murray, and I was working on something similar to help with development.

The KVM series on the public mailing list work only by chance because it is
impossible to reliably map the SPE buffer at EL2 when profiling triggers a stage 2
data abort. That's because the DABT is reported asynchronously via the buffer
management interrupt and the faulting IPA is not reported anywhere. I'm trying to
fix this issue in the next iteration of the series, and then I'll come back to
your patches for review and testing.

Thanks,

Alex

On 8/31/20 8:34 PM, Eric Auger wrote:
> This series implements tests exercising the Statistical Profiling
> Extensions.
>
> This was tested with associated unmerged kernel [1] and QEMU [2]
> series.
>
> Depending on the comments, I can easily add other tests checking
> more configs, additional events and testing migration too. I hope
> this can be useful when respinning both series.
>
> All SPE tests can be launched with:
> ./run_tests.sh -g spe
> Tests also can be launched individually. For example:
> ./arm-run arm/spe.flat -append 'spe-buffer'
>
> The series can be found at:
> https://github.com/eauger/kut/tree/spe_rfc
>
> References:
> [1] [PATCH v2 00/18] arm64: KVM: add SPE profiling support
> [2] [PATCH 0/7] target/arm: Add vSPE support to KVM guest
>
> Eric Auger (4):
>   arm64: Move get_id_aa64dfr0() in processor.h
>   spe: Probing and Introspection Test
>   spe: Add profiling buffer test
>   spe: Test Profiling Buffer Events
>
>  arm/Makefile.common       |   1 +
>  arm/pmu.c                 |   1 -
>  arm/spe.c                 | 463 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |  24 ++
>  lib/arm64/asm/barrier.h   |   1 +
>  lib/arm64/asm/processor.h |   5 +
>  6 files changed, 494 insertions(+), 1 deletion(-)
>  create mode 100644 arm/spe.c
>
