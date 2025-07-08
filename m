Return-Path: <kvm+bounces-51724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA3FAFC18B
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 05:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B4133A4230
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 03:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4855623C4FC;
	Tue,  8 Jul 2025 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="16478LQd"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-19.ptr.tlmpb.com (sg-3-19.ptr.tlmpb.com [101.45.255.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FEB7464
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 03:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751946226; cv=none; b=m0Dbyxm3Nu1w9JdxbRr5e0oCYO6E4Q3W0SDPLvPZa4cecEP+TDv2wAvFkpRzHjHxwk9QYDk4jDuahfYv3g2JXZ0aiCp0RllPHi4DgHTOaZLgn8zcjAfcTAhp8P5pZBLaAlquWcQw5g4eTnrsjUfPEgMBshKsVxF9km/ZjZtyrmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751946226; c=relaxed/simple;
	bh=dlqjyOc5QFaRUTdJOcecWoOAlINKUDZQlIQVHK/D8UQ=;
	h=To:From:Message-Id:References:Mime-Version:Cc:Subject:Date:
	 Content-Type:In-Reply-To; b=iFF4dBYpb4V4Z/BXVtUvmEgUIIM+6sTQhnuouuZChzJ9sfJqqnnIko+jhc8b8mACBlIoP/Rm4dRc+q69J2me+QansgtFEf3/nK/OecXeNhx+tQ9hV5h5kXs7+vBYqhk0QDKaLbElIelFndWgLUKEY2ECdtVyhqzTj54Jlu1Tkq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=16478LQd; arc=none smtp.client-ip=101.45.255.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1751946211;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uG5ka7LNUg6mP21RjQcaH3JCOJLOzMGM1lk9S67I8rE=;
 b=16478LQdsNe1oE2zDqnLRLuAnQl1WUJTbYc4p6q4KwlntWA4xikASg7XBFlPBIwzVdVCst
 9r3gf+bdH25jTB59UGNruMsjyYomQha04beehqncs5u2lZvVZRtlPrlIVeGmkSj2rUsTP2
 GNTcdEUDesMmv8EtROFn/SyfBKPYGbDe9sdtGRjWSzOVQoUjKtwDph4GrDYDAVjkxIwekv
 LphHCk3Rf2HfSeIUCoDFhbPiEmRyg8REYAxpNiXwrYp0iUWmrGPhwXyRalefvEZLVXqlOl
 zTsYirLsbYeR3Fx3sJDcWks+ChMUzCLAc28jfJeH9Nbouqr7w+LbIQHHaTzvHQ==
X-Lms-Return-Path: <lba+2686c93e1+d9ff4c+vger.kernel.org+liujingqi@lanxincomputing.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>, 
	<kvmarm@lists.linux.dev>, <kvm-riscv@lists.infradead.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Message-Id: <285b7059-c64e-45e1-b923-eaafa1655b56@lanxincomputing.com>
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Tue, 08 Jul 2025 11:43:28 +0800
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Cc: <alexandru.elisei@arm.com>, <cleger@rivosinc.com>, <jesse@rivosinc.com>, 
	<jamestiotio@gmail.com>, "Atish Patra" <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: Add kvmtool support
Date: Tue, 8 Jul 2025 11:43:26 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20250704151254.100351-6-andrew.jones@linux.dev>

On 7/4/2025 11:12 PM, Andrew Jones wrote:
> arm/arm64 supports running tests with kvmtool as a first class citizen.
> Most the code to do that is in the common scripts, so just add the riscv
> specific bits needed to allow riscv to use kvmtool as a first class
> citizen too.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty
> ---
>   README.md     |   7 ++--
>   configure     |  12 ++++--
>   riscv/efi/run |   6 +++
>   riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
>   4 files changed, 96 insertions(+), 39 deletions(-)
>
> diff --git a/README.md b/README.md
> index 723ce04cd978..cbd8a9940ec4 100644
> --- a/README.md
> +++ b/README.md
> @@ -65,8 +65,8 @@ or:
>   
>   to run them all.
>   
> -All tests can be run using QEMU. On arm and arm64, tests can also be run using
> -kvmtool.
> +All tests can be run using QEMU. On arm, arm64, riscv32, and riscv64 tests can
> +also be run using kvmtool.
>   
>   By default the runner script searches for a suitable QEMU binary in the system.
>   To select a specific QEMU binary though, specify the QEMU=path/to/binary
> @@ -97,8 +97,7 @@ variable. kvmtool supports only kvm as the accelerator.
>   
>   Check [x86/efi/README.md](./x86/efi/README.md).
>   
> -On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
> -tests under UEFI.
> +This is only supported with QEMU; kvmtool cannot run the tests under UEFI.
>   
>   # Tests configuration file
>   
> diff --git a/configure b/configure
> index 470f9d7cdb3b..6d549d1ecb5b 100755
> --- a/configure
> +++ b/configure
> @@ -90,7 +90,7 @@ usage() {
>   	                           selects the best value based on the host system and the
>   	                           test configuration.
>   	    --target=TARGET        target platform that the tests will be running on (qemu or
> -	                           kvmtool, default is qemu) (arm/arm64 only)
> +	                           kvmtool, default is qemu) (arm/arm64 and riscv32/riscv64 only)
>   	    --cross-prefix=PREFIX  cross compiler prefix
>   	    --cc=CC                c compiler to use ($cc)
>   	    --cflags=FLAGS         extra options to be passed to the c compiler
> @@ -284,7 +284,8 @@ fi
>   if [ -z "$target" ]; then
>       target="qemu"
>   else
> -    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
> +    if [ "$arch" != "arm" ] && [ "$arch" != "arm64" ] &&
> +       [ "$arch" != "riscv32" ] && [ "$arch" != "riscv64" ]; then
>           echo "--target is not supported for $arch"
>           usage
>       fi
> @@ -393,6 +394,10 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
>       testdir=riscv
>       arch_libdir=riscv
>       : "${uart_early_addr:=0x10000000}"
> +    if [ "$target" != "qemu" ] && [ "$target" != "kvmtool" ]; then
> +        echo "--target must be one of 'qemu' or 'kvmtool'!"
> +        usage
> +    fi
>   elif [ "$arch" = "s390x" ]; then
>       testdir=s390x
>   else
> @@ -519,7 +524,8 @@ EFI_DIRECT=$efi_direct
>   CONFIG_WERROR=$werror
>   GEN_SE_HEADER=$gen_se_header
>   EOF
> -if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
> +if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ] ||
> +   [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
>       echo "TARGET=$target" >> config.mak
>   fi
>   
> diff --git a/riscv/efi/run b/riscv/efi/run
> index 5a72683a6ef5..b9b75440c659 100755
> --- a/riscv/efi/run
> +++ b/riscv/efi/run
> @@ -11,6 +11,12 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/arch-run.bash
> +source scripts/vmm.bash
> +
> +if [[ $(vmm_get_target) == "kvmtool" ]]; then
> +	echo "kvmtool does not support EFI tests."
> +	exit 2
> +fi
>   
>   if [ -f RISCV_VIRT_CODE.fd ]; then
>   	DEFAULT_UEFI=RISCV_VIRT_CODE.fd
> diff --git a/riscv/run b/riscv/run
> index 0f000f0d82c6..7bcf235fb645 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -10,35 +10,81 @@ if [ -z "$KUT_STANDALONE" ]; then
>   	source scripts/vmm.bash
>   fi
>   
> -# Allow user overrides of some config.mak variables
> -mach=$MACHINE_OVERRIDE
> -qemu_cpu=$TARGET_CPU_OVERRIDE
> -firmware=$FIRMWARE_OVERRIDE
> -
> -: "${mach:=virt}"
> -: "${qemu_cpu:=$TARGET_CPU}"
> -: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
> -: "${firmware:=$FIRMWARE}"
> -[ "$firmware" ] && firmware="-bios $firmware"
> -
> -set_qemu_accelerator || exit $?
> -[ "$ACCEL" = "kvm" ] && QEMU_ARCH=$HOST
> -acc="-accel $ACCEL$ACCEL_PROPS"
> -
> -qemu=$(search_qemu_binary) || exit $?
> -if [ "$mach" = 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
> -	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> -	exit 2
> -fi
> -mach="-machine $mach"
> -
> -command="$qemu -nodefaults -nographic -serial mon:stdio"
> -command+=" $mach $acc $firmware -cpu $qemu_cpu "
> -command="$(migration_cmd) $(timeout_cmd) $command"
> -
> -if [ "$UEFI_SHELL_RUN" = "y" ]; then
> -	ENVIRON_DEFAULT=n run_test_status $command "$@"
> -else
> -	# We return the exit code via stdout, not via the QEMU return code
> -	run_test_status $command -kernel "$@"
> -fi
> +vmm_check_supported
> +
> +function arch_run_qemu()
> +{
> +	# Allow user overrides of some config.mak variables
> +	mach=$MACHINE_OVERRIDE
> +	qemu_cpu=$TARGET_CPU_OVERRIDE
> +	firmware=$FIRMWARE_OVERRIDE
> +
> +	: "${mach:=virt}"
> +	: "${qemu_cpu:=$TARGET_CPU}"
> +	: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
> +	: "${firmware:=$FIRMWARE}"
> +	[ "$firmware" ] && firmware="-bios $firmware"
> +
> +	set_qemu_accelerator || exit $?
> +	[ "$ACCEL" = "kvm" ] && QEMU_ARCH=$HOST
> +	acc="-accel $ACCEL$ACCEL_PROPS"
> +
> +	qemu=$(search_qemu_binary) || exit $?
> +	if [ "$mach" = 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
> +		echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> +		exit 2
> +	fi
> +	mach="-machine $mach"
> +
> +	command="$qemu -nodefaults -nographic -serial mon:stdio"
> +	command+=" $mach $acc $firmware -cpu $qemu_cpu "
> +	command="$(migration_cmd) $(timeout_cmd) $command"
> +
> +	if [ "$UEFI_SHELL_RUN" = "y" ]; then
> +		ENVIRON_DEFAULT=n run_test_status $command "$@"
> +	else
> +		# We return the exit code via stdout, not via the QEMU return code
> +		run_test_status $command -kernel "$@"
> +	fi
> +}
> +
> +function arch_run_kvmtool()
> +{
> +	local command
> +
> +	if [ "$HOST" != "riscv32" ] && [ "$HOST" != "riscv64" ]; then
> +		echo "kvmtool requires KVM but the host ('$HOST') is not riscv" >&2
> +		exit 2
> +	fi
> +
> +	kvmtool=$(search_kvmtool_binary) ||
> +		exit $?
> +
> +	if [ "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
> +		echo "kvmtool does not support $ACCEL" >&2
> +		exit 2
> +	fi
> +
> +	if ! kvm_available; then
> +		echo "kvmtool requires KVM but not available on the host" >&2
> +		exit 2
> +	fi
> +
> +	command="$(timeout_cmd) $kvmtool run"
> +	if ( [ "$HOST" = "riscv64" ] && [ "$ARCH" = "riscv32" ] ) ||
> +	   ( [ "$HOST" = "riscv32" ] && [ "$ARCH" = "riscv64" ] ); then
> +		echo "Cannot run guests with a different xlen than the host" >&2
> +		exit 2
> +	else
> +		run_test_status $command --kernel "$@"
> +	fi
> +}
> +
> +case $(vmm_get_target) in
> +qemu)
> +	arch_run_qemu "$@"
> +	;;
> +kvmtool)
> +	arch_run_kvmtool "$@"
> +	;;
> +esac

