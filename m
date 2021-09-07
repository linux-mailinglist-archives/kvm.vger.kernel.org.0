Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFA84026FE
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245393AbhIGKSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245377AbhIGKSm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 06:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631009856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7jzGz9ueYeBwNeZnfKBYm3m4e8M7rY4sBRCa4uTJkE=;
        b=BD0ydpIm+o7IDyugEPNCAn7EMoEOp71kRrJrpi7cavxg+vssuSzH+0JVGAq2b3U2HnlwHv
        6sLPKSKj8Ibcp+lG3Q3G8aGnv4bToPKQE/Z9PhlgPPmPIUa5ZIrArYjLLDXf6jY4sCpcHL
        qIhkYn0i3QGJvbZMRz5dr7QZY50IyIA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-sqKLjPIVMRGQdS3AoW8UiQ-1; Tue, 07 Sep 2021 06:17:35 -0400
X-MC-Unique: sqKLjPIVMRGQdS3AoW8UiQ-1
Received: by mail-wm1-f69.google.com with SMTP id c4-20020a1c9a04000000b002e864b7edd1so3212291wme.6
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 03:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E7jzGz9ueYeBwNeZnfKBYm3m4e8M7rY4sBRCa4uTJkE=;
        b=OhRxwoptHMixRFJTE0SimmmE/HXLx3gwfyQ9C6cc5MidUDAmhTYnbCM986Ela4zfQB
         tBfcUU9LJbUj381IUF6RpsPEFefCx7/CNFDe6QYrlSOf+gVCN6z/LpFrDF9h2USq0/9C
         H0MgoxhYPKRhaPVwNdVaUS2QtLG8kgx4LK8oB8rv18ZB81+5R2Zv5BDGS1aYSoA9k1fA
         TufAnFcJUraG1rv4g0hPmnjIqWQ3M6zBKOI948nYTp/co+J+3coFggUKfQg16BLoJ9YS
         o1jzBX3LWcvEvgTKQalKILRCilHzqcgIkt+z4joc/XiCeJzK05v+prA7wyoh4ulh/cp5
         YXew==
X-Gm-Message-State: AOAM5330yd+EkH3AgmtIWVtVB6xn54gS7MkuI+hIZk6u4BfijsJ2c/b5
        A94ElbwmAzkmEfRYQ3AhYrKx871mzYaKcRf2yTnf8yE2vRc1apEol1hMdgRKjFkaFGlwIJWrN+P
        IajpxJwjNBc5Z
X-Received: by 2002:a1c:f405:: with SMTP id z5mr3090242wma.33.1631009853464;
        Tue, 07 Sep 2021 03:17:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgSxJzEzGtjuQ7/P/lyGwL52Z9NQtXChjcUhJeozsVSdJmhPRhvmjvI3MRF13V/Y3GohBrYg==
X-Received: by 2002:a1c:f405:: with SMTP id z5mr3090192wma.33.1631009852931;
        Tue, 07 Sep 2021 03:17:32 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id z1sm1997446wmi.34.2021.09.07.03.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 03:17:32 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:17:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210907101730.trnsig2j4jmhinyu@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702163122.96110-4-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 05:31:20PM +0100, Alexandru Elisei wrote:
> Modify run_tests.sh to use kvmtool instead of qemu to run tests when
> kvm-unit-tests has been configured with --target=kvmtool.
> 
> Example invocation:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ ./run_scripts.sh
> 
> A custom location for the kvmtool binary can be set using the environment
> variable KVMTOOL:
> 
> $ KVMTOOL=/path/to/kvmtool/binary ./run_scripts.sh
> 
> Standalone test support is absent, but will be added in subsequent patches.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/arch-run.bash   |  48 ++++++++++++++++--
>  scripts/runtime.bash    |  94 ++++++++++++++++++++++++++++------
>  scripts/mkstandalone.sh |   5 ++
>  arm/run                 | 110 ++++++++++++++++++++++++----------------
>  run_tests.sh            |  11 +++-
>  5 files changed, 204 insertions(+), 64 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8ceed53ed7f8..b916b0e79aca 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -69,16 +69,39 @@ run_qemu ()
>  	return $ret
>  }
>  
> +run_kvmtool()
> +{
> +	local stdout errors ret sig
> +
> +	# kvmtool doesn't allow an initrd argument with --firmware, but configure
> +	# sets CONFIG_ERRATA_FORCE in lib/config.h for the kvmtool target.
> +
> +	# stdout to {stdout}, stderr to $errors and stderr
> +	exec {stdout}>&1
> +	errors=$("${@}" </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout)
> +	ret=$?
> +	exec {stdout}>&-
> +
> +	# ret=0 success, everything else is failure.
> +	return $ret
> +}
> +
>  run_test_status ()
>  {
> -	local stdout ret
> +	local stdout ret exit_status
>  
>  	exec {stdout}>&1
> -	lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
> +	if [ "$TARGET" = "kvmtool" ]; then
> +		lines=$(run_kvmtool "$@" > >(tee /dev/fd/$stdout))
> +		exit_status=0
> +	else
> +		lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
> +		exit_status=1
> +	fi

Now that we're adding a second VMM, let's assume that we may want to add
more. (Actually, I have low priority aspirations to try and also use a
Rust VMM, for example). To prepare for another VMM, everywhere we add a
kvmtool case like this, we should use a case statement instead, e.g.

   case "$TARGET" in
   qemu)
     lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
     exit_status=1
     ;;
   kvmtool)
     lines=$(run_kvmtool "$@" > >(tee /dev/fd/$stdout))
     exit_status=0
   *) echo "$BASH_SOURCE $LINENO"; exit 2;;
   esac

This means we also need to modify configure to unconditionally do

  echo "TARGET=$target" >> config.mak

Right now it only does that for arm/arm64.

>  	ret=$?
>  	exec {stdout}>&-
>  
> -	if [ $ret -eq 1 ]; then
> +	if [ $ret -eq $exit_status ]; then
>  		testret=$(grep '^EXIT: ' <<<"$lines" | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
>  		if [ "$testret" ]; then
>  			if [ $testret -eq 1 ]; then
> @@ -193,6 +216,25 @@ search_qemu_binary ()
>  	export PATH=$save_path
>  }
>  
> +search_kvmtool_binary ()
> +{
> +	local lkvm kvmtool
> +
> +	for lkvm in ${KVMTOOL:-lkvm vm lkvm-static}; do
> +		if $lkvm --help 2>/dev/null | grep -q 'The most commonly used'; then
> +			kvmtool="$lkvm"
> +			break
> +		fi
> +	done
> +
> +	if [ -z "$kvmtool" ]; then
> +		echo "A kvmtool binary was not found." >&2
> +		echo "You can set a custom location by using the KVMTOOL=<path> environment variable." >&2
> +		return 2
> +	fi
> +	command -v $kvmtool
> +}
> +
>  initrd_create ()
>  {
>  	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 132389c7dd59..23b238a6ab6f 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -12,14 +12,19 @@ extract_summary()
>      tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
>  }
>  
> -# We assume that QEMU is going to work if it tried to load the kernel
> +# We assume that QEMU/kvmtool is going to work if it tried to load the kernel

assume that the VMM

>  premature_failure()
>  {
>      local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
>  
> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> -        return 1
> +    if [ "$TARGET" = "kvmtool" ]; then
> +        echo "$log" | grep "Fatal: unable to load firmware image _NO_FILE_4Uhere_" &&
> +            return 1
> +    else
> +        echo "$log" | grep "_NO_FILE_4Uhere_" |
> +            grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +            return 1
> +    fi

Another place for a switch.

>  
>      RUNTIME_log_stderr <<< "$log"
>  
> @@ -30,7 +35,14 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    local smp_param
> +
> +    if [ "$TARGET" = "kvmtool" ]; then
> +        smp_param="--cpus $smp"
> +    else
> +        smp_param="-smp $smp"
> +    fi

switch

> +    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel $smp_param $opts"
>  }
>  
>  skip_nodefault()
> @@ -70,6 +82,35 @@ function find_word()
>      grep -Fq " $1 " <<< " $2 "
>  }
>  
> +fixup_kvmtool_opts()
> +{
> +    local opts=$1
> +    local groups=$2
> +    local gic
> +    local gic_version
> +
> +    if find_word "pmu" $groups; then
> +        opts+=" --pmu"
> +    fi
> +
> +    if find_word "its" $groups; then
> +        gic_version=3
> +        gic="gicv3-its"
> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> +        gic_version="${BASH_REMATCH[1]}"
> +        gic="gicv$gic_version"
> +    fi
> +
> +    if [ -n "$gic" ]; then
> +        opts=${opts/-machine gic-version=$gic_version/}
> +        opts+=" --irqchip=$gic"
> +    fi
> +
> +    opts=${opts/-append/--params}
> +
> +    echo "$opts"
> +}

Hmm, I don't think we want to write a QEMU parameter translator for
all other VMMs, and all other VMM architectures, that we want to
support. I think we should add new "extra_params" variables to the
unittest configuration instead, e.g. "kvmtool_params", where the
extra parameters can be listed correctly and explicitly. While at
it, I would create an alias for "extra_params", which would be
"qemu_params" allowing unittests that support more than one VMM
to clearly show what's what.

> +
>  function run()
>  {
>      local testname="$1"
> @@ -105,7 +146,12 @@ function run()
>          return 2
>      fi
>  
> -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> +    if [ "$TARGET" = "kvmtool" ]; then
> +        if [ -n "$accel" ] && [ "$accel" != "kvm" ]; then
> +            print_result "SKIP" $testname "" "$accel not supported by kvmtool"
> +            return 2
> +        fi
> +    elif [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then

switch

>          print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
>          return 2
>      elif [ -n "$ACCEL" ]; then
> @@ -126,6 +172,10 @@ function run()
>          done
>      fi
>  
> +    if [ "$TARGET" = "kvmtool" ]; then
> +        opts=$(fixup_kvmtool_opts "$opts" "$groups")
> +    fi
> +
>      last_line=$(premature_failure > >(tail -1)) && {
>          print_result "SKIP" $testname "" "$last_line"
>          return 77
> @@ -165,13 +215,25 @@ function run()
>  #
>  # Probe for MAX_SMP, in case it's less than the number of host cpus.
>  #
> -# This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> +# This probing currently only works for ARM, as x86 bails on another error
> +# first. Also, this probing isn't necessary for any ARM hosts running kernels
> +# later than v4.3, i.e. those including ef748917b52 "arm/arm64: KVM: Remove
> +# 'config KVM_ARM_MAX_VCPUS'". So, at some point when maintaining the while loop
> +# gets too tiresome, we can just remove it...
> +#
> +# We don't need this check for kvmtool, as kvmtool will automatically limit the
> +# number of VCPUs to what the host supports instead of exiting with an error.
> +# kvmtool prints a message when that happens, but it's harmless and the chance
> +# of running a kernel so old that the number of VCPUs is smaller than the number
> +# of physical CPUs is vanishingly small.
> +#
> +# For qemu this check is still needed. For qemu-system-aarch64 version 6.0.0,
> +# using TCG, the maximum number of VCPUs that mach-virt supports is 8. If a test
> +# is running on a recent x86 machine, there's a fairly good chance that more
> +# than 8 logical CPUs are available.
> +if [ "$TARGET" = "qemu" ]; then
> +    while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +            |& grep -qi 'exceeds max CPUs'; do
> +        MAX_SMP=$((MAX_SMP >> 1))
> +    done
> +fi
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index cefdec30cb33..16f461c06842 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -95,6 +95,11 @@ function mkstandalone()
>  	echo Written $standalone.
>  }
>  
> +if [ "$TARGET" = "kvmtool" ]; then
> +	echo "Standalone tests not supported with kvmtool"
> +	exit 2
> +fi
> +
>  if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
>  	exit 2
> diff --git a/arm/run b/arm/run
> index a390ca5ae0ba..cc5890e7fec4 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -8,59 +8,81 @@ if [ -z "$STANDALONE" ]; then
>  	source config.mak
>  	source scripts/arch-run.bash
>  fi
> -processor="$PROCESSOR"
>  
> -ACCEL=$(get_qemu_accelerator) ||
> -	exit $?
> +run_test_qemu()
> +{
> +    processor="$PROCESSOR"
>  
> -qemu=$(search_qemu_binary) ||
> -	exit $?
> +    ACCEL=$(get_qemu_accelerator) ||
> +        exit $?
>  
> -if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> -	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> -	exit 2
> -fi
> +    qemu=$(search_qemu_binary) ||
> +        exit $?
>  
> -M='-machine virt'
> +    if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> +        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> +        exit 2
> +    fi
>  
> -if [ "$ACCEL" = "kvm" ]; then
> -	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> -		M+=',gic-version=host'
> -	fi
> -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> -		processor="host"
> -		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> -			processor+=",aarch64=off"
> -		fi
> -	fi
> -fi
> +    M='-machine virt'
>  
> -if [ "$ARCH" = "arm" ]; then
> -	M+=",highmem=off"
> -fi
> +    if [ "$ACCEL" = "kvm" ]; then
> +        if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> +            M+=',gic-version=host'
> +        fi
> +        if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> +            processor="host"
> +            if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> +                processor+=",aarch64=off"
> +            fi
> +        fi
> +    fi
>  
> -if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> -	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> -	exit 2
> -fi
> +    if [ "$ARCH" = "arm" ]; then
> +        M+=",highmem=off"
> +    fi
>  
> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> -		| grep backend > /dev/null; then
> -	echo "$qemu doesn't support chr-testdev. Exiting."
> -	exit 2
> -fi
> +    if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> +        echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> +        exit 2
> +    fi
>  
> -chr_testdev='-device virtio-serial-device'
> -chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +    if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> +            | grep backend > /dev/null; then
> +        echo "$qemu doesn't support chr-testdev. Exiting."
> +        exit 2
> +    fi
>  
> -pci_testdev=
> -if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
> -	pci_testdev="-device pci-testdev"
> -fi
> +    chr_testdev='-device virtio-serial-device'
> +    chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +
> +    pci_testdev=
> +    if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
> +        pci_testdev="-device pci-testdev"
> +    fi
> +
> +    M+=",accel=$ACCEL"
> +    command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
> +    command+=" -display none -serial stdio -kernel"
> +    command="$(migration_cmd) $(timeout_cmd) $command"
> +
> +    run_qemu $command "$@"
> +}
> +
> +run_test_kvmtool()
> +{
> +    kvmtool=$(search_kvmtool_binary) ||
> +        exit $?
>  
> -M+=",accel=$ACCEL"
> -command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
> -command+=" -display none -serial stdio -kernel"
> -command="$(migration_cmd) $(timeout_cmd) $command"
> +    local command="$(timeout_cmd) $kvmtool run --firmware "
> +    run_test_status $command "$@"
> +}
>  
> -run_qemu $command "$@"
> +case "$TARGET" in
> +    "qemu")
> +        run_test_qemu "$@"
> +        ;;
> +    "kvmtool")
> +        run_test_kvmtool "$@"
> +        ;;
> +esac

Hey, here's a switch :-) But I'd add a default case that errors out for
good measure.

> diff --git a/run_tests.sh b/run_tests.sh
> index 65108e73a2c0..b010ee3ab348 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -26,7 +26,9 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
>      -t, --tap13     Output test results in TAP format
>  
>  Set the environment variable QEMU=/path/to/qemu-system-ARCH to
> -specify the appropriate qemu binary for ARCH-run.
> +specify the appropriate qemu binary for ARCH-run. For arm/arm64, kvmtool
> +is also supported and the environment variable KVMTOOL=/path/to/kvmtool
> +can be used to specify a custom location for the kvmtool binary.

How about changing this last sentence (as a separate patch first) in usage
to

ENVIRONMENT
    QEMU            Path to QEMU binary for ARCH-run
    ACCEL           QEMU accelerator to use, e.g. "kvm", "hvf" or "tcg"
    TIMEOUT         Timeout duration for the timeout(1) command

And then in this patch adds

    KVMTOOL         Path to KVMTOOL binary for ARCH-run

>  
>  EOF
>  }
> @@ -41,6 +43,13 @@ if [ $? -ne 4 ]; then
>      exit 1
>  fi
>  
> +if [ "$TARGET" = "kvmtool" ]; then
> +    if [ -n "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
> +        echo "kvmtool supports only the kvm accelerator"
> +        exit 1
> +    fi
> +fi

I think this belongs in arm/run, because run_tests.sh isn't always used to
run the tests.

> +
>  only_tests=""
>  args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
>  [ $? -ne 0 ] && exit 2;
> -- 
> 2.32.0
> 

Thanks,
drew

