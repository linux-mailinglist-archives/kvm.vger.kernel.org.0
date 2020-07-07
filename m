Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11C821698C
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGGJw5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Jul 2020 05:52:57 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2433 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbgGGJw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 05:52:57 -0400
Received: from lhreml705-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 74C4A9A111BCD6BA87D2;
        Tue,  7 Jul 2020 10:52:55 +0100 (IST)
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 lhreml705-chm.china.huawei.com (10.201.108.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 7 Jul 2020 10:52:55 +0100
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1913.007;
 Tue, 7 Jul 2020 10:52:55 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "david@redhat.com" <david@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>
Subject: RE: [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for
 ARM64
Thread-Topic: [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for
 ARM64
Thread-Index: AQHWSvaqb7PlQuQ2I0aISfnbFH95/aj77kPg
Date:   Tue, 7 Jul 2020 09:52:54 +0000
Message-ID: <8efc4efe284641eda3ffeb2301fcca43@huawei.com>
References: <20200625133757.22332-1-salil.mehta@huawei.com>
In-Reply-To: <20200625133757.22332-1-salil.mehta@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.76.134]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
A gentle reminder, any comments regarding this series will help us know
your opinion and also confirm/correct our understanding about the topic
and will be much appreciated.

Thanks in anticipation!

Best regards
Salil

> From: Salil Mehta
> Sent: Thursday, June 25, 2020 2:38 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> christoffer.dall@arm.com; andre.przywara@arm.com; james.morse@arm.com;
> mark.rutland@arm.com; lorenzo.pieralisi@arm.com; sudeep.holla@arm.com;
> qemu-arm@nongnu.org; peter.maydell@linaro.org; richard.henderson@linaro.org;
> imammedo@redhat.com; mst@redhat.com; drjones@redhat.com; pbonzini@redhat.com;
> eric.auger@redhat.com; gshan@redhat.com; david@redhat.com;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>; mehta.salil.lnk@gmail.com; Salil Mehta
> <salil.mehta@huawei.com>
> Subject: [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for ARM64
> 
> Changes to support virtual cpu hotplug in QEMU[1] have been introduced to the
> community as RFC. These are under review.
> 
> To support virtual cpu hotplug guest kernel must:
> 1. Identify disabled/present vcpus and set/unset the present mask of the vcpu
>    during initialization and hotplug event. It must also set the possible mask
>    (which includes disabled vcpus) during init of guest kernel.
> 2. Provide architecture specific ACPI hooks, for example to map/unmap the
>    logical cpuid to hwids/MPIDR. Linux kernel already has generic ACPI cpu
>    hotplug framework support.
> 
> Changes introduced in this patch-set also ensures that initialization of the
> cpus when virtual cpu hotplug is not supported remains un-affected.
> 
> Repository:
> (*) Kernel changes are at,
>      https://github.com/salil-mehta/linux.git virt-cpuhp-arm64/rfc-v1
> (*) QEMU changes for vcpu hotplug could be cloned from below site,
>      https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1
> 
> 
> THINGS TO DO:
> 1. Handling of per-cpu variables especially the first-chunk allocations
>    (which are NUMA aware) when the vcpu is hotplugged needs further attention
>    and review.
> 2. NUMA related stuff has not been fully tested both in QEMU and kernel.
> 3. Comprehensive Testing including when cpu hotplug is not supported.
> 4. Docs
> 
> DISCLAIMER:
> This is not a complete work but an effort to present the arm vcpu hotplug
> implementation to the community. This RFC is being used as a way to verify
> the idea mentioned above and to support changes presented for QEMU[1] to
> support vcpu hotplug. As of now this is *not* a production level code and might
> have bugs. Only a basic testing has been done on HiSilicon Kunpeng920 ARM64
> based SoC for Servers to verify the proof-of-concept that has been found working!
> 
> Best regards
> Salil.
> 
> REFERENCES:
> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg712010.html
> [2] https://lkml.org/lkml/2019/6/28/1157
> [3] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-July/032316.html
> 
> Organization of Patches:
> [Patch 1-3]
> (*) Changes required during guest boot time to support vcpu hotplug
> (*) Max cpu overflow checks
> (*) Changes required to pre-setup cpu-operations even for disabled cpus
> [Patch 4]
> (*) Arch changes required by guest kernel ACPI CPU Hotplug framework.
> 
> 
> Salil Mehta (4):
>   arm64: kernel: Handle disabled[(+)present] cpus in MADT/GICC during
>     init
>   arm64: kernel: Bound the total(present+disabled) cpus with nr_cpu_ids
>   arm64: kernel: Init cpu operations for all possible vcpus
>   arm64: kernel: Arch specific ACPI hooks(like logical cpuid<->hwid
>     etc.)
> 
>  arch/arm64/kernel/smp.c | 153 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 123 insertions(+), 30 deletions(-)
> 
> --
> 2.17.1
> 

