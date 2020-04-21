Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949571B1BC9
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDUCWe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 Apr 2020 22:22:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2117 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbgDUCWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 22:22:33 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 31BB7AA1B46B6E864557;
        Tue, 21 Apr 2020 10:22:31 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.234]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0487.000;
 Tue, 21 Apr 2020 10:22:24 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     George Cherian <gcherian@marvell.com>,
        "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        Anil Kumar Reddy H <areddy3@marvell.com>,
        Ganapatrao Kulkarni <gkulkarni@marvell.com>
Subject: RE: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2v//iESA//MqKcCAGX9aAP/4ImVggBBPsoCAAVt7AP/+wAyAALytmoD//ruGUA==
Date:   Tue, 21 Apr 2020 02:22:24 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A550CD0@dggemm526-mbx.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
 <3e84aaf8b757bc5a7685a291e54c232b@kernel.org> <20200417160602.26706917@why>
 <678F3D1BB717D949B966B68EAEB446ED3A545C71@dggemm526-mbx.china.huawei.com>
 <dd1283e9b31fd01ac5c9f434aa00d34e@kernel.org>
In-Reply-To: <dd1283e9b31fd01ac5c9f434aa00d34e@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Marc Zyngier
> Sent: Monday, April 20, 2020 10:03 PM
> To: Zengtao (B)
> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
> andre.przywara@arm.com; christoffer.dall@arm.com;
> james.morse@arm.com; jintack@cs.columbia.edu;
> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> Virtualization support
> 
> On 2020-04-18 03:49, Zengtao (B) wrote:
> > -----Original Message-----
> >> From: Marc Zyngier [mailto:maz@kernel.org]
> >> Sent: Friday, April 17, 2020 11:06 PM
> >> To: Zengtao (B)
> >> Cc: George Cherian; Dave.Martin@arm.com;
> alexandru.elisei@arm.com;
> >> andre.przywara@arm.com; christoffer.dall@arm.com;
> >> james.morse@arm.com; jintack@cs.columbia.edu;
> >> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> >> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> >> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
> >> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> >> Virtualization support
> >>
> >> On Thu, 16 Apr 2020 19:22:21 +0100
> >> Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> > Hi Zengtao,
> >> >
> >> > On 2020-04-16 02:38, Zengtao (B) wrote:
> >> > > Hi Marc:
> >> > >
> >> > > Got it.
> >> > > Really a bit patch set :)
> >> >
> >> > Well, yeah... ;-)
> >> >
> >> > >
> >> > > BTW, I have done a basic kvm unit test
> >> > > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> >> > > And I find that after apply the patch KVM: arm64: VNCR-ize
> ELR_EL1,
> >> > > The psci test failed for some reason, I can't understand why, this
> >> > > is only the test result.(find the patch by git bisect + kvm test)
> >> >
> >> > That it is that mechanical, we should be able to quickly nail that
> one.
> >> >
> >> > > My platform: Hisilicon D06 board.
> >> > > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> >> > > Could you help to take a look?
> >> >
> >> > I'll have a look tomorrow. I'm in the middle of refactoring the series
> >> > for 5.7, and things have changed quite a bit. Hopefully this isn't a
> VHE
> >> > vs non-VHE issue.
> >>
> >> So I've repeatedly tried with the current state of the NV patches[1],
> >> on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid
> junk
> >> (vim3l). PSCI is pretty happy, although I can only test with at most 8
> >> vcpus (GICv2 gets in the way).
> >>
> >> Can you please:
> >>
> >> - post the detailed error by running the PSCI unit test on its own
> > I tried to trace the error, and I found in kernel function
> > kvm_mpidr_to_vcpu,
> > casually, mpidr returns zero and we can't get the expected vcpu, and
> > psci
> >  test failed due to this.
> 
> Can you post the exact error message from the unit test?
> 
Some debug code added as follow(virt/kvm/arm/arm.c):

unsigned long saved_mpidr[256];

static void dump_saved_mpidr(struct kvm *kvm, unsigned long mpidr)
{
	struct kvm_vcpu *vcpu;
	int i;

	printk("target mpidr:%lx\n", mpidr);
	kvm_for_each_vcpu(i, vcpu, kvm) {
		printk("saved_mpidr:%lx latest mpidr:%lx\n", saved_mpidr[i], 
		kvm_vcpu_get_mpidr_aff(vcpu));
	}
}

struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
{
	struct kvm_vcpu *vcpu;
	int i;

	mpidr &= MPIDR_HWID_BITMASK;
	kvm_for_each_vcpu(i, vcpu, kvm) {
		saved_mpidr[i] = kvm_vcpu_get_mpidr_aff(vcpu);
		if (mpidr == saved_mpidr[i])
			return vcpu;
	}

	dump_saved_mpidr(kvm, mpidr);

	return NULL;
}

error log:
[root@localhost test]# ./psci
BUILD_HEAD=b16df9ee
timeout -k 1s --foreground 90s /sbin/qemu-system-aarch64 -nodefaults 
-machine virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device
-device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev
-display none -serial stdio -kernel /tmp/tmp.QDQH5cBotg -smp 128
 # -initrd /tmp/tmp.uW5pheTN1jINFO: psci: PSCI version 1.0
PASS: psci: invalid-function
PASS: psci: affinity-info-on
PASS: psci: affinity-info-off
[  218.891944] target mpidr:1
[  218.894645] saved_mpidr:0 latest mpidr:0
[  218.898569] saved_mpidr:0 latest mpidr:1
[  218.902481] saved_mpidr:2 latest mpidr:2
[  218.906393] saved_mpidr:3 latest mpidr:3
[  218.910308] saved_mpidr:4 latest mpidr:4
[  218.914223] saved_mpidr:5 latest mpidr:5
[  218.918138] saved_mpidr:6 latest mpidr:6
[  218.922051] saved_mpidr:7 latest mpidr:7
[  218.925965] saved_mpidr:8 latest mpidr:8
[  218.929878] saved_mpidr:9 latest mpidr:9
[  218.933788] saved_mpidr:a latest mpidr:a
[  218.937703] saved_mpidr:b latest mpidr:b
[  218.941618] saved_mpidr:c latest mpidr:c
[  218.945533] saved_mpidr:d latest mpidr:d
[  218.949445] saved_mpidr:e latest mpidr:e
[  218.953359] saved_mpidr:f latest mpidr:f
[  218.957274] saved_mpidr:100 latest mpidr:100
[  218.961536] saved_mpidr:101 latest mpidr:101
[  218.965798] saved_mpidr:102 latest mpidr:102
[  218.970059] saved_mpidr:103 latest mpidr:103
[  218.974319] saved_mpidr:104 latest mpidr:104
[  218.978584] saved_mpidr:105 latest mpidr:105
[  218.982842] saved_mpidr:106 latest mpidr:106
[  218.987105] saved_mpidr:107 latest mpidr:107
[  218.991362] saved_mpidr:108 latest mpidr:108
[  218.995624] saved_mpidr:109 latest mpidr:109
[  218.999881] saved_mpidr:10a latest mpidr:10a
[  219.004133] saved_mpidr:10b latest mpidr:10b
[  219.008389] saved_mpidr:10c latest mpidr:10c
[  219.012643] saved_mpidr:10d latest mpidr:10d
[  219.016898] saved_mpidr:10e latest mpidr:10e
[  219.021152] saved_mpidr:10f latest mpidr:10f
[  219.025408] saved_mpidr:200 latest mpidr:200
[  219.029664] saved_mpidr:201 latest mpidr:201
[  219.033919] saved_mpidr:202 latest mpidr:202
[  219.038171] saved_mpidr:203 latest mpidr:203
[  219.042426] saved_mpidr:204 latest mpidr:204
[  219.046681] saved_mpidr:205 latest mpidr:205
[  219.050934] saved_mpidr:206 latest mpidr:206
[  219.055188] saved_mpidr:207 latest mpidr:207
[  219.059442] saved_mpidr:208 latest mpidr:208
[  219.063698] saved_mpidr:209 latest mpidr:209
[  219.067952] saved_mpidr:20a latest mpidr:20a
[  219.072206] saved_mpidr:20b latest mpidr:20b
[  219.076463] saved_mpidr:20c latest mpidr:20c
[  219.080722] saved_mpidr:20d latest mpidr:20d
[  219.084976] saved_mpidr:20e latest mpidr:20e
[  219.089229] saved_mpidr:20f latest mpidr:20f
[  219.093483] saved_mpidr:300 latest mpidr:300
[  219.097738] saved_mpidr:301 latest mpidr:301
[  219.101994] saved_mpidr:302 latest mpidr:302
[  219.106250] saved_mpidr:303 latest mpidr:303
[  219.110504] saved_mpidr:304 latest mpidr:304
[  219.114756] saved_mpidr:305 latest mpidr:305
[  219.119010] saved_mpidr:306 latest mpidr:306
[  219.123267] saved_mpidr:307 latest mpidr:307
[  219.127521] saved_mpidr:308 latest mpidr:308
[  219.131779] saved_mpidr:309 latest mpidr:309
[  219.136034] saved_mpidr:30a latest mpidr:30a
[  219.140289] saved_mpidr:30b latest mpidr:30b
[  219.144544] saved_mpidr:30c latest mpidr:30c
[  219.148798] saved_mpidr:30d latest mpidr:30d
[  219.153054] saved_mpidr:30e latest mpidr:30e
[  219.157308] saved_mpidr:30f latest mpidr:30f
[  219.161562] saved_mpidr:400 latest mpidr:400
[  219.165817] saved_mpidr:401 latest mpidr:401
[  219.170071] saved_mpidr:402 latest mpidr:402
[  219.174324] saved_mpidr:403 latest mpidr:403
[  219.178578] saved_mpidr:404 latest mpidr:404
[  219.182834] saved_mpidr:405 latest mpidr:405
[  219.187093] saved_mpidr:406 latest mpidr:406
[  219.191350] saved_mpidr:407 latest mpidr:407
[  219.195609] saved_mpidr:408 latest mpidr:408
[  219.199861] saved_mpidr:409 latest mpidr:409
[  219.204117] saved_mpidr:40a latest mpidr:40a
[  219.208371] saved_mpidr:40b latest mpidr:40b
[  219.212625] saved_mpidr:40c latest mpidr:40c
[  219.216881] saved_mpidr:40d latest mpidr:40d
[  219.221133] saved_mpidr:40e latest mpidr:40e
[  219.225388] saved_mpidr:40f latest mpidr:40f
[  219.229642] saved_mpidr:500 latest mpidr:500
[  219.233898] saved_mpidr:501 latest mpidr:501
[  219.238155] saved_mpidr:502 latest mpidr:502
[  219.242411] saved_mpidr:503 latest mpidr:503
[  219.246665] saved_mpidr:504 latest mpidr:504
[  219.250920] saved_mpidr:505 latest mpidr:505
[  219.255175] saved_mpidr:506 latest mpidr:506
[  219.259428] saved_mpidr:507 latest mpidr:507
[  219.263680] saved_mpidr:508 latest mpidr:508
[  219.267935] saved_mpidr:509 latest mpidr:509
[  219.272189] saved_mpidr:50a latest mpidr:50a
[  219.276444] saved_mpidr:50b latest mpidr:50b
[  219.280699] saved_mpidr:50c latest mpidr:50c
[  219.284957] saved_mpidr:50d latest mpidr:50d
[  219.289212] saved_mpidr:50e latest mpidr:50e
[  219.293470] saved_mpidr:50f latest mpidr:50f
[  219.297725] saved_mpidr:600 latest mpidr:600
[  219.301982] saved_mpidr:601 latest mpidr:601
[  219.306237] saved_mpidr:602 latest mpidr:602
[  219.310493] saved_mpidr:603 latest mpidr:603
[  219.314749] saved_mpidr:604 latest mpidr:604
[  219.319003] saved_mpidr:605 latest mpidr:605
[  219.323258] saved_mpidr:606 latest mpidr:606
[  219.327511] saved_mpidr:607 latest mpidr:607
[  219.331766] saved_mpidr:608 latest mpidr:608
[  219.336020] saved_mpidr:609 latest mpidr:609
[  219.340276] saved_mpidr:60a latest mpidr:60a
[  219.344532] saved_mpidr:60b latest mpidr:60b
[  219.348783] saved_mpidr:60c latest mpidr:60c
[  219.353036] saved_mpidr:60d latest mpidr:60d
[  219.357290] saved_mpidr:60e latest mpidr:60e
[  219.361545] saved_mpidr:60f latest mpidr:60f
[  219.365799] saved_mpidr:700 latest mpidr:700
[  219.370054] saved_mpidr:701 latest mpidr:701
[  219.374308] saved_mpidr:702 latest mpidr:702
[  219.378560] saved_mpidr:703 latest mpidr:703
[  219.382815] saved_mpidr:704 latest mpidr:704
[  219.387072] saved_mpidr:705 latest mpidr:705
[  219.391326] saved_mpidr:706 latest mpidr:706
[  219.395582] saved_mpidr:707 latest mpidr:707
[  219.399840] saved_mpidr:708 latest mpidr:708
[  219.404098] saved_mpidr:709 latest mpidr:709
[  219.408351] saved_mpidr:70a latest mpidr:70a
[  219.412605] saved_mpidr:70b latest mpidr:70b
[  219.416860] saved_mpidr:70c latest mpidr:70c
[  219.421114] saved_mpidr:70d latest mpidr:70d
[  219.425370] saved_mpidr:70e latest mpidr:70e
[  219.429622] saved_mpidr:70f latest mpidr:70f
INFO: psci: unexpected cpu_on return value: caller=CPU117, ret=-2
FAIL: psci: cpu-on
SUMMARY: 4 tests, 1 unexpected failures
FAIL psci (4 tests, 1 unexpected failures)

> > And as I mentioned in my last before, the psci error is introduced by
> > the
> >  patch KVM: arm64: VNCR-ize ELR_EL1.(Only test result)
> > Maybe you have to try tens of times to reproduce. :)
> > Deep into the patch itself, I don't find any connection between the
> > patch
> > and the issue.
> 
> Me neither, and I haven't managed to reproduce your issue.
> 
> >> - test with the current state of the patches
> > I test with your nv-5.7-rc1-WIP branch and latest kvm_unit_test, the
> > error still exist.
> 
> How many vcpus do you create with this PSCI test?
> 

128.

> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
