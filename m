Return-Path: <kvm+bounces-45838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D58AAF60F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 10:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBBC69C1FED
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 08:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E192620CA;
	Thu,  8 May 2025 08:52:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0149723D2AE;
	Thu,  8 May 2025 08:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746694367; cv=none; b=SX1pMTIvQ7xDGgoG1nZPfqpv+QjlTFMZJ5q0eiK/EHpUC3CsoWbRxl40tzvkdbLLwQDpoT+hSsBmREUbroYza7iO3wBN1qhBX78Iy+sX/l+MLznD0jAHAKDUvlTl9ylFO6TMZwUcjvCEXW0amUf9zWAGLg13whnV7O8TxHWi5q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746694367; c=relaxed/simple;
	bh=NkTSapsrn+gYyqlk3WGioQ33WT4lYLgGat1uFHaF1lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcyD0V5YbVnicxibfW3tP3jdjL1L5S/9cuzA7JnhACUv0HlRN+dNP+Gbv6M7r0BJ5HkXkSe8z+adL+wlVmeM1VmigpLzmDbE3tj36QgW9NL8t9zMTn9qKwx8VOLIDFrdrCFeFNmdXj67afid3rupP0CiLPLBg1d4kZqtwjrlcH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4BB81688;
	Thu,  8 May 2025 01:52:33 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15DB03F673;
	Thu,  8 May 2025 01:52:40 -0700 (PDT)
Date: Thu, 8 May 2025 09:52:38 +0100
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
Message-ID: <aBxw1uaO1FZQ15VR@raptor>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-4-alexandru.elisei@arm.com>
 <20250507-78bbc45f50ea8867b4fa7e74@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507-78bbc45f50ea8867b4fa7e74@orel>

Hi Drew,

On Wed, May 07, 2025 at 06:02:31PM +0200, Andrew Jones wrote:
> On Wed, May 07, 2025 at 04:12:43PM +0100, Alexandru Elisei wrote:
> > Only arm and arm64 are allowed to set --target to kvmtool; the rest of the
> > architectures can only set --target to 'qemu', which is also the default.
> > 
> > Needed to make the changes necessary to add support for kvmtool to the test
> > runner.
> > 
> > kvmtool also supports running the riscv tests, so it's not outside of the
> > realm of the possibily for the riscv tests to get support for kvmtool.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  configure | 36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> >
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thank you for the review!

Just to be clear, you are ok with this happening because of the patch:

$ git pull
$ make clean && make
$ ./run_tests.sh
scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 2 #  /tmp/tmp.bME9I2BZRG
qemu-system-x86_64: 2: Could not open '2': No such file or directory
scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
FAIL apic-split
scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 1 #  /tmp/tmp.11und6qZbL
qemu-system-x86_64: 1: Could not open '1': No such file or directory
scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
FAIL ioapic-split
[..]

That's because TARGET is missing from config.mak. If you're ok with the
error, I'll make it clear in the commit message why this is happening.

Thanks,
Alex

