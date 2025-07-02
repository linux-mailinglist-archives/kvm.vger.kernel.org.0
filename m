Return-Path: <kvm+bounces-51295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD3DAF5946
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAF474E3A9B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A12283CBF;
	Wed,  2 Jul 2025 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fEcHzlCz"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537F3280A52
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751462720; cv=none; b=oAujhvTBGqmQn7dRPcWXs2s3kVnxkGZDR8qQj58Aj8X6RxMjz02GB1/9caqZx5w3dp7xyU3ojJ5q8s0fqlSAxhbKUAHCsWjqiyBdSySv8xXsqhvH9VixnmZ3HbTUHLIYOCG5IzoUIjny6cYMSO2Od0GOaCiX4oJes6I+V+DOmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751462720; c=relaxed/simple;
	bh=MdRMMy04lIaDZD3VtMFnBPIPBh10oPPKF2nlCw+gDhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRXFamJbHH520TafFhyxuU7gKlsd2SFdgg0cy9EPvluuv/s1JFEjJViP+U/COQO5dbHv2mFELc4PxKTgs46s/3rHlvZ7ORxBIRwgfZkKCbwHvC/pNYpzEovIU2mA/Ctx4dWky1E25DJDcYvtdF4WcIkTDImgPrCBR9gS7JXMcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fEcHzlCz; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 15:25:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751462716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2AtJHOMqWJ6F384E1w5rTvvzxDPe7+FoXKxbqUWmqh0=;
	b=fEcHzlCzoPeE8qMosDj/PqdbnAnnkrLQNiWkgozTiYWQq6moOFQNZ4ULGlSvdSNKqwQ4S9
	nMXZblScAuwIsDzDRl15678OpFRLRdgz43IY9yL+B+sgJrH05LN+7X+kCVgKG4C/cwuq8I
	Jkon6MWpJl2/v5wgBBDf4twpORJobbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add kvmtool to the
 runner script
Message-ID: <20250702-c37fbf095d2665019da2c037@orel>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Paolo, Thomas, and others,

This series has a subject of arm, but it makes lots of changes to
common scripts. Can I get an ack on it? I'd like to merge it.

Thanks,
drew


On Wed, Jun 25, 2025 at 04:48:00PM +0100, Alexandru Elisei wrote:
> v3 can be found here [1]. Based on top of the series that add qemu_params and
> test_args [2].
> 
> To goal is to allow the user to do:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ ./run_tests.sh
> 
> to run all the tests automatically with kvmtool.
> 
> Reasons to use kvmtool:
> 
> * kvmtool is smaller and a lot easier to modify compared to qemu, which
> means developers may prefer it when adding or prototyping new features to
> KVM, and being able to run all the tests reliably and automatically is very
> useful.
> 
> * kvmtool is faster to run the tests (a couple of times faster on
> my rockpro64), making for a quick turnaround. But do keep in mind that not
> all tests work on kvmtool because of missing features compared to qemu.
> 
> * kvmtool does things differently than qemu: different memory layout,
> different uart, PMU emulation is disabled by default, etc. This makes it a
> good testing vehicule for kvm-unit-tests itself.
> 
> Changes v3->v4
> --------------
> 
> Overview of the changes:
> 
> * Gathered Reviewed-by tags - thanks for the review!
> 
> * Sent patches #1 ("scripts: unittests.cfg: Rename 'extra_params' to
> 'qemu_params'") and #2 ("scripts: Add 'test_args' test definition parameter")
> as a separate series.
> 
> * Fixed the typos reported during the review.
> 
> * Ran shellcheck on the patches, this resulted in minor changes.
> 
> * Dropped patch "configure: Export TARGET unconditionally" - now the functions
> in vmm.bash will check if TARGET is set, instead of having the other scripts use
> $TARGET to directly index the vmm_opts array.
> 
> * Direct reads of $TARGET have been replaced with vmm_get_target(), to account
> for the fact that most architectures don't configure $TARGET (only arm and
> arm64 do that).
> 
> * Renamed check_vmm_supported() to vmm_check_supported() to match the
> function names introduced in subsequent patches.
> 
> * Renamed vmm_opts->vmm_optname to match the new function names.
> 
> * Reordered the key-value pairs from vmm_optname in alphabetical order.
> 
> * Use the "," separator for the composite keys of the associative array instead
> of ":" (don't remember why I originally settled on ":", but it was a really poor
> choice).
> 
> * Dropped the Reviewed-by tags from Drew and Shaoqin Huang from patch #6
> ("scripts: Use an associative array for qemu argument names") - the review is
> much appreciated, but the way the vmm_opts array (now renamed to vmm_optname) is
> created, and used, has changed, and since the patch is about introducing the
> associative array, I thought it would be useful to have another round of review.
> 
> * Use functions instead of indexing vmm_opts (now vmm_optname) directly.
> 
> * Fixed standalone test generation by removing 'source vmm.bash' from
> scripts/arch-run.bash, $arch/run and scripts/runtime, and having
> scripts/mkstandalone.sh::generate_test() copy it directly in the final test
> script. Didn't catch that during the previous iterations because I was
> running the standalone tests from the top level source directory, and
> "source scripts/vmm.bash" happened to work.
> 
> More details in the changelog for the modified patches.
> 
> [1] https://lore.kernel.org/kvm/20250507151256.167769-1-alexandru.elisei@arm.com/
> [2] https://lore.kernel.org/kvm/20250625154354.27015-1-alexandru.elisei@arm.com/
> 
> Alexandru Elisei (13):
>   run_tests.sh: Document --probe-maxsmp argument
>   scripts: Document environment variables
>   scripts: Refuse to run the tests if not configured for qemu
>   scripts: Use an associative array for qemu argument names
>   scripts: Add 'kvmtool_params' to test definition
>   scripts: Add support for kvmtool
>   scripts: Add default arguments for kvmtool
>   scripts: Add KVMTOOL environment variable for kvmtool binary path
>   scripts: Detect kvmtool failure in premature_failure()
>   scripts: Do not probe for maximum number of VCPUs when using kvmtool
>   scripts/mkstandalone: Export $TARGET
>   scripts: Add 'disabled_if' test definition parameter for kvmtool to
>     use
>   scripts: Enable kvmtool
> 
>  README.md               |  18 +++-
>  arm/efi/run             |   8 ++
>  arm/run                 | 161 ++++++++++++++++-----------
>  arm/unittests.cfg       |  31 ++++++
>  configure               |   1 -
>  docs/unittests.txt      |  26 ++++-
>  powerpc/run             |   5 +-
>  riscv/run               |   5 +-
>  run_tests.sh            |  35 +++---
>  s390x/run               |   3 +-
>  scripts/arch-run.bash   | 112 +++++++------------
>  scripts/common.bash     |  30 ++++--
>  scripts/mkstandalone.sh |   8 +-
>  scripts/runtime.bash    |  35 ++----
>  scripts/vmm.bash        | 234 ++++++++++++++++++++++++++++++++++++++++
>  x86/run                 |   5 +-
>  16 files changed, 525 insertions(+), 192 deletions(-)
>  create mode 100644 scripts/vmm.bash
> 
> -- 
> 2.50.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

