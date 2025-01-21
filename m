Return-Path: <kvm+bounces-36155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA0EA18246
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629581680DE
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596C31F4297;
	Tue, 21 Jan 2025 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rtj0/bwz"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCA13BC0C
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478213; cv=none; b=tB34CUlchFF91DPz++Xd7SwhUe9eCehKSScBUi5f7qcw7eKMUk1Ncu45cHRr0nGVpjW3+xr8fVuPltslwGd9HEn6iR1ClkQLo3CH2pBgYrdgU5FnYwbZrZG61wC3KvgOPz1hMVmIyILpHkDPrcKcd9fRZHAUYABUn3EM+p7Fjug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478213; c=relaxed/simple;
	bh=piUGgdwH9PSJieSwqBbK0u+RpbIcCW8WVuA1yil4zWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmIFTPlXO5YWSIV3u6+Q4o8CQqzxww0k58dYiHXELkPKDgJAryavEGrBnBedq3CO7vr+MEWwNXp3CGjGl9I/Igpm8mD6grTMqdyoPo+JwhJNRaA7unhjD/tBtJ/odSjVx++P91eniW+GiOg9erSYdC4Uw24759608m/nWBoZx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rtj0/bwz; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 17:50:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737478209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9o9toXjXchxuXb1mbAx2+gmT8fvOBZnIXdfInm+D/aM=;
	b=rtj0/bwzCyqvtrhaxqugGe2yTMMDMyQdQVt26GYW3LfnEZGr/FkaHtaK+9BBohA9Fer3GU
	iQxCzAawmvRe5+YcIMPEJ0HfhT6HVkpz1//kiNxxGLa+cVveUDP9L5rTqnXsMZwW4m9nx1
	34ELjNr9KI9WUusTseG9Fu9SnLCc+bY=
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
Subject: Re: [kvm-unit-tests PATCH v2 11/18] arm/run: Add support for kvmtool
Message-ID: <20250121-98b6da755bc353722fae5f1f@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-12-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-12-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:09PM +0000, Alexandru Elisei wrote:
> Teach the arm runner to use kvmtool when kvm-unit-tests has been configured
> appropriately.
> 
> The test is ran using run_test_status() because kvmtool does not have a
> testdev device to return the test exit code, so kvm-unit-tests must always
> parse the "EXIT: STATUS" line for the exit code.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run | 183 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 110 insertions(+), 73 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index 9b11feafffdd..880d5afae86d 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -17,77 +17,114 @@ qemu)
>     exit 3
>  esac
>  
> -processor="$PROCESSOR"
> +arch_run_qemu()
> +{
> +    processor="$PROCESSOR"
> +
> +    if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> +       [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> +       [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> +        ACCEL="tcg"
> +    fi
> +
> +    set_qemu_accelerator || exit $?
> +    if [ "$ACCEL" = "kvm" ]; then
> +        QEMU_ARCH=$HOST
> +    fi
> +
> +    qemu=$(search_qemu_binary) ||
> +        exit $?
> +
> +    if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
> +        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> +        exit 2
> +    fi
> +
> +    M='-machine virt'
> +
> +    if [ "$ACCEL" = "kvm" ]; then
> +        if $qemu $M,\? | grep -q gic-version; then
> +            M+=',gic-version=host'
> +        fi
> +    fi
> +
> +    if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> +        if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> +            processor="host"
> +            if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> +                processor+=",aarch64=off"
> +            fi
> +        fi
> +    fi
> +
> +    if [ "$ARCH" = "arm" ]; then
> +        M+=",highmem=off"
> +    fi
> +
> +    if ! $qemu $M -device '?' | grep -q virtconsole; then
> +        echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> +        exit 2
> +    fi
> +
> +    if ! $qemu $M -chardev '?' | grep -q testdev; then
> +        echo "$qemu doesn't support chr-testdev. Exiting."
> +        exit 2
> +    fi
> +
> +    if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
> +        chr_testdev='-device virtio-serial-device'
> +        chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +    fi
> +
> +    pci_testdev=
> +    if $qemu $M -device '?' | grep -q pci-testdev; then
> +        pci_testdev="-device pci-testdev"
> +    fi
> +
> +    A="-accel $ACCEL$ACCEL_PROPS"
> +    command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> +    command+=" -display none -serial stdio"
> +    command="$(migration_cmd) $(timeout_cmd) $command"
> +
> +    if [ "$UEFI_SHELL_RUN" = "y" ]; then
> +        ENVIRON_DEFAULT=n run_test_status $command "$@"
> +    elif [ "$EFI_USE_ACPI" = "y" ]; then
> +        run_test_status $command -kernel "$@"
> +    else
> +        run_qemu $command -kernel "$@"
> +    fi
> +}
> +
> +arch_run_kvmtool()
> +{
> +    local command
> +
> +    kvmtool=$(search_kvmtool_binary) ||
> +        exit $?
> +
> +    if [ "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
> +        echo "kvmtool does not support $ACCEL" >&2
> +        exit 2
> +    fi
> +
> +    if ! kvm_available; then
> +        echo "KVM required by kvmtool but not available on the host" >&2
> +        exit 2
> +    fi
> +
> +    command="$(timeout_cmd) $kvmtool run"
> +    if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
> +	    run_test_status $command --kernel "$@" --aarch32
> +    else
> +	    run_test_status $command --kernel "$@"
> +    fi
> +}
>  
> -if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> -   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> -   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> -	ACCEL="tcg"
> -fi
> -
> -set_qemu_accelerator || exit $?
> -if [ "$ACCEL" = "kvm" ]; then
> -	QEMU_ARCH=$HOST
> -fi
> -
> -qemu=$(search_qemu_binary) ||
> -	exit $?
> -
> -if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
> -	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> -	exit 2
> -fi
> -
> -M='-machine virt'
> -
> -if [ "$ACCEL" = "kvm" ]; then
> -	if $qemu $M,\? | grep -q gic-version; then
> -		M+=',gic-version=host'
> -	fi
> -fi
> -
> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> -		processor="host"
> -		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> -			processor+=",aarch64=off"
> -		fi
> -	fi
> -fi
> -
> -if [ "$ARCH" = "arm" ]; then
> -	M+=",highmem=off"
> -fi
> -
> -if ! $qemu $M -device '?' | grep -q virtconsole; then
> -	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> -	exit 2
> -fi
> -
> -if ! $qemu $M -chardev '?' | grep -q testdev; then
> -	echo "$qemu doesn't support chr-testdev. Exiting."
> -	exit 2
> -fi
> -
> -if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
> -	chr_testdev='-device virtio-serial-device'
> -	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> -fi
> -
> -pci_testdev=
> -if $qemu $M -device '?' | grep -q pci-testdev; then
> -	pci_testdev="-device pci-testdev"
> -fi
> -
> -A="-accel $ACCEL$ACCEL_PROPS"
> -command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> -command+=" -display none -serial stdio"
> -command="$(migration_cmd) $(timeout_cmd) $command"
> -
> -if [ "$UEFI_SHELL_RUN" = "y" ]; then
> -	ENVIRON_DEFAULT=n run_test_status $command "$@"
> -elif [ "$EFI_USE_ACPI" = "y" ]; then
> -	run_test_status $command -kernel "$@"
> -else
> -	run_qemu $command -kernel "$@"
> -fi
> +case "$TARGET" in
> +qemu)
> +    arch_run_qemu "$@"
> +    ;;
> +kvmtool)
> +    arch_run_kvmtool "$@"
> +    ;;
> +esac
> -- 
> 2.47.1
> 
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

