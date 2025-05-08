Return-Path: <kvm+bounces-45839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F8FAAF6E9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 11:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 418747B645B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 09:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04381264629;
	Thu,  8 May 2025 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jLBeEIJe"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F66C5A79B
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697206; cv=none; b=ATwQVYG1neQF0kEA9JCl0/HmYxf9WzXD/u6IX6yNvPxzgDH8Z1PQZd/rP0FjR8se88cqXwk8z3HDbXpoPVdSwjMBZ3tMn7bFK1AKGrvg3fRtUxi6jItfFVhKCE0cTwlY3fdf6UfJmHlJOGlnbsogpagvIGlihCSneO+fKL2VPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697206; c=relaxed/simple;
	bh=/MD1glYJ22G+1xYg/D3pBI8G/udznkaKIjT531/TtfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gnw/A4irDdLEMWTfvIcK23gala9KqKswPH2uoGf/uRaOADPkVacoh9YK3szBcIDXkGW1RnPKmJeP54vlgdCl02FcU/eWt01p/9E4J8KjW3MRvR0xSHQQBMbtKc+Mi9sd/YY1hGkdsuwrJiHe18lx7TqtIIKqwipRLJ7ROlIYiYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jLBeEIJe; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 May 2025 11:39:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746697201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rd4X9VJub0p8Z48NlXuvNR1+VIxbKa4gUctZklcxAAU=;
	b=jLBeEIJeOs0a7cKKkC/3kmj0tYlNG1kh/EykuU2zvp/el6AjEn9I0nJ/oYuSPya996hXJ7
	0BY3GuiOuGEJdPcMm0C6wo/G5NP9fGfOXApSp8xqVFUfH48j1Gp3KfpXnJYN4kMETZhjR9
	YW9/YoXzBRvzfQWGf1w/pvq9/l2FV80=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 03/16] configure: Export TARGET
 unconditionally
Message-ID: <20250508-0227212b80950becb999ad30@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-4-alexandru.elisei@arm.com>
 <20250507-78bbc45f50ea8867b4fa7e74@orel>
 <aBxw1uaO1FZQ15VR@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBxw1uaO1FZQ15VR@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, May 08, 2025 at 09:52:38AM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Wed, May 07, 2025 at 06:02:31PM +0200, Andrew Jones wrote:
> > On Wed, May 07, 2025 at 04:12:43PM +0100, Alexandru Elisei wrote:
> > > Only arm and arm64 are allowed to set --target to kvmtool; the rest of the
> > > architectures can only set --target to 'qemu', which is also the default.
> > > 
> > > Needed to make the changes necessary to add support for kvmtool to the test
> > > runner.
> > > 
> > > kvmtool also supports running the riscv tests, so it's not outside of the
> > > realm of the possibily for the riscv tests to get support for kvmtool.
> > > 
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  configure | 36 ++++++++++++++++++++++++------------
> > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > >
> > 
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Thank you for the review!
> 
> Just to be clear, you are ok with this happening because of the patch:
> 
> $ git pull
> $ make clean && make
> $ ./run_tests.sh
> scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 2 #  /tmp/tmp.bME9I2BZRG
> qemu-system-x86_64: 2: Could not open '2': No such file or directory
> scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
> FAIL apic-split
> scripts/runtime.bash: line 24: scripts/arch-run.bash: line 444: [: =: unary operator expected
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel _NO_FILE_4Uhere_ 1 #  /tmp/tmp.11und6qZbL
> qemu-system-x86_64: 1: Could not open '1': No such file or directory
> scripts/arch-run.bash: line 19: 1: command not found: No such file or directory
> FAIL ioapic-split
> [..]
> 
> That's because TARGET is missing from config.mak. If you're ok with the
> error, I'll make it clear in the commit message why this is happening.
>

It's not ideal, but I think it's pretty common to run configure before
make after an update to the git repo, so it's not horrible. However,
as you pointed out in your cover letter, this can be mitigated if we
use function wrappers for the associative array accesses, allowing
$TARGET to be checked before it's used. I'd prefer the function wrappers
anyway for readability reasons, so let's do that.

Thanks,
drew

