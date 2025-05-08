Return-Path: <kvm+bounces-45841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E97AAF767
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EC711BC378B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 10:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA8D1F473C;
	Thu,  8 May 2025 10:05:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2581CAA62;
	Thu,  8 May 2025 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746698742; cv=none; b=F4m03h09z3GqVDzkXUBZtbUahXZi1XqgSnM6Azs75AMnfS149KCZIVwD1t5USG/+ON4LnppDgaHxcJq+2my5X//4rwHpMsDXHgdTQn1o6oyDhYaEp6Y56zJ9tdOahVvyeZpj7HxSPqpU/UePsJBxayJOvbUW/aR69kdmJlsi8mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746698742; c=relaxed/simple;
	bh=+EoBRL+MNS3W0sfQ0QqU7mTlWcsUatV8rDKofLHwKIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBClHR45kB/3pxqd9LIC7K9lPJKQB4QHEUY2pvICAxkJhkZIMzF7/WyaeOMKVi8ePSlO6anm1prJ3mT1KeCw23Tp5wkG7CC83Lzkx+0T84vHPcFMO5ChmipYmJnBdgMjdfPURj45FAkN6Ggx8uTarFYJtmD+XEzlyh3JGFTMUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C206106F;
	Thu,  8 May 2025 03:05:27 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5EA23F5A1;
	Thu,  8 May 2025 03:05:34 -0700 (PDT)
Date: Thu, 8 May 2025 11:05:32 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 03/16] configure: Export TARGET
 unconditionally
Message-ID: <aByB7IphzIq61BMN@raptor>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-4-alexandru.elisei@arm.com>
 <20250507-78bbc45f50ea8867b4fa7e74@orel>
 <aBxw1uaO1FZQ15VR@raptor>
 <20250508-0227212b80950becb999ad30@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508-0227212b80950becb999ad30@orel>

Hi Drew,

On Thu, May 08, 2025 at 11:39:54AM +0200, Andrew Jones wrote:
> On Thu, May 08, 2025 at 09:52:38AM +0100, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Wed, May 07, 2025 at 06:02:31PM +0200, Andrew Jones wrote:
> > > On Wed, May 07, 2025 at 04:12:43PM +0100, Alexandru Elisei wrote:
> > > > Only arm and arm64 are allowed to set --target to kvmtool; the rest of the
> > > > architectures can only set --target to 'qemu', which is also the default.
> > > > 
> > > > Needed to make the changes necessary to add support for kvmtool to the test
> > > > runner.
> > > > 
> > > > kvmtool also supports running the riscv tests, so it's not outside of the
> > > > realm of the possibily for the riscv tests to get support for kvmtool.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >  configure | 36 ++++++++++++++++++++++++------------
> > > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > > >
> > > 
> > > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > 
> > Thank you for the review!
> > 
> > Just to be clear, you are ok with this happening because of the patch:
> > 
> > $ git pull
> > $ make clean && make
> > $ ./run_tests.sh
> > scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
> > timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 2 #  /tmp/tmp.bME9I2BZRG
> > qemu-system-x86_64: 2: Could not open '2': No such file or directory
> > scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
> > FAIL apic-split
> > scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
> > timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 1 #  /tmp/tmp.11und6qZbL
> > qemu-system-x86_64: 1: Could not open '1': No such file or directory
> > scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
> > FAIL ioapic-split
> > [..]
> > 
> > That's because TARGET is missing from config.mak. If you're ok with the
> > error, I'll make it clear in the commit message why this is happening.
> >
> 
> It's not ideal, but I think it's pretty common to run configure before
> make after an update to the git repo, so it's not horrible. However,
> as you pointed out in your cover letter, this can be mitigated if we
> use function wrappers for the associative array accesses, allowing
> $TARGET to be checked before it's used. I'd prefer the function wrappers
> anyway for readability reasons, so let's do that.

I'm all for the function wrappers, I was planning to reply to that comment
later.

As to this patch, is this what you're thinking:

function vmm_optname_nr_cpus()
{
	if [ -z $TARGET ]; then
		echo vmm_opts[qemu:nr_cpus]
	else
		echo vmm_opts[$TARGET:nr_cpus]
	fi
}

But checking if $TARGET is defined makes this patch useless, and I would
rather drop it if that's the case.

Thanks,
Alex

> 
> Thanks,
> drew
> 

