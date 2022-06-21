Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954FF553EE3
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355030AbiFUXJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 19:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354574AbiFUXJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 19:09:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F752B277
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:09:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g8so13816620plt.8
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cy4toclyMlICO1fw4f2pRj7YTFuPOLi7u+RsrPZ5wIc=;
        b=lntrtQsOxTL8kLd35Q2ayRXnKFcYSQdZmT+KxXcUeBLEOObII1mnQH6u+lrWlv7f22
         L2oFFB/DiDNYQRnMmZDptDToPqEnjApSeM3ywaxgNjSypfgvFTchLutgW8VlkH0zM4dR
         TTL3fZ4s/9oREuqicH/UXvreFaqBvJp6jsqpZngaehZ30YZ8QvIGuYGOktqUOlfMug/O
         WRBu+Zns4bTy3IwpJ1TvwhvoocbOUv4vrAEj6NUz0m6hmDky/g8ecRv9mw28TOnIhFRx
         DVBLvvESwmEZN91BmvXBcVPk0/Erb7IjULnF1xpt9qSTW5v02iamxisUIxG41KhC6ysJ
         TWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cy4toclyMlICO1fw4f2pRj7YTFuPOLi7u+RsrPZ5wIc=;
        b=olf17bwKTto9Tt/xBgMv6kjIuPhRhemV8FUuWXkwzvMA1Fa28ld8CBm2Xp/0VPQvWj
         8aSf9i9wIwZLs60jfk0ZALbM8L3IHEisHkVT3IsJjm1ETcGSjiKekVgUlQQyS/VLZPjw
         /wPHrKEAagDhlUWIURcxsBqy81jYoFAMJZfMa599EmQT7nm2S5/BJo/De5DbYptjWUgo
         GA71Hrg/QxjGPbgg4/NFxd0cIKy64sWvoTRbn1DiVLKHTA8b7tHfLmUYdO3wpBEZXw7g
         9e4dOeGCNpuqk6Ys4MPi9plwDHbjZ/DWoRJn/hQqx/PhGHF5Kt62v2tyr0TN/PEWoNEe
         qUoQ==
X-Gm-Message-State: AJIora+WL3CC/N9kfsOclMIogLgJmNgw4xUeu/gK4I+Q2/+oReVd1f6u
        mbCzCi+KFA11yDz3R8vkIJyvuQ==
X-Google-Smtp-Source: AGRyM1sQvUU10VSu/ajOX61LW32pLdpSr22xuvPnNyKPk5szXBlzyeIsJcYZ3OvR7giLsueMh8H/3g==
X-Received: by 2002:a17:90b:1b0e:b0:1ec:e2f6:349e with SMTP id nu14-20020a17090b1b0e00b001ece2f6349emr835888pjb.14.1655852982081;
        Tue, 21 Jun 2022 16:09:42 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id jd6-20020a170903260600b0016a1096bc95sm7264247plb.12.2022.06.21.16.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:09:41 -0700 (PDT)
Date:   Tue, 21 Jun 2022 16:09:38 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 23/23] arm64: Add an efi/run script
Message-ID: <YrJPsmon33EAfe54@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-24-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-24-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:56:05PM +0100, Nikos Nikoleris wrote:
> This change adds a efi/run script inspired by the one in x86. This
> script will setup a folder with the test compiled as an EFI app and a
> startup.nsh script. The script launches QEMU providing an image with
> EDKII and the path to the folder with the test which is executed
> automatically.
> 
> For example:
> 
> $> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  scripts/runtime.bash | 14 +++++-----
>  arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
>  arm/run              |  8 ++++--
>  arm/Makefile.common  |  1 +
>  arm/dummy.c          |  4 +++
>  5 files changed, 78 insertions(+), 10 deletions(-)
>  create mode 100755 arm/efi/run
>  create mode 100644 arm/dummy.c
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 7d0180b..dc28f24 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -131,14 +131,12 @@ function run()
>      fi
>  
>      last_line=$(premature_failure > >(tail -1)) && {
> -        skip=true
> -        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
> -            skip=false
> -        fi
> -        if [ ${skip} == true ]; then
> -            print_result "SKIP" $testname "" "$last_line"
> -            return 77
> -        fi
> +        if [ "${CONFIG_EFI}" == "y" ] && [ "${ARCH}" = x86_64 ]; then
> +		if ! [[ "${last_line}" =~ "enabling apic" ]]; then
> +			print_result "SKIP" $testname "" "$last_line"
> +			return 77
> +		fi
> +	fi
>      }
>  
>      cmdline=$(get_cmdline $kernel)
> diff --git a/arm/efi/run b/arm/efi/run
> new file mode 100755
> index 0000000..dfff717
> --- /dev/null
> +++ b/arm/efi/run
> @@ -0,0 +1,61 @@
> +#!/bin/bash
> +
> +set -e
> +
> +if [ $# -eq 0 ]; then
> +	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
> +	exit 2
> +fi
> +
> +if [ ! -f config.mak ]; then
> +	echo "run './configure --enable-efi && make' first. See ./configure -h"
> +	exit 2
> +fi
> +source config.mak
> +source scripts/arch-run.bash
> +source scripts/common.bash
> +
> +: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> +: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
> +: "${EFI_TEST:=efi-tests}"
> +: "${EFI_CASE:=$(basename $1 .efi)}"
> +
> +if [ ! -f "$EFI_UEFI" ]; then
> +	echo "UEFI firmware not found: $EFI_UEFI"
> +	echo "Please install the UEFI firmware to this path"
> +	echo "Or specify the correct path with the env variable EFI_UEFI"
> +	exit 2
> +fi
> +
> +# Remove the TEST_CASE from $@
> +shift 1
> +
> +# Fish out the arguments for the test, they should be the next string
> +# after the "-append" option
> +qemu_args=()
> +cmd_args=()
> +while (( "$#" )); do
> +	if [ "$1" = "-append" ]; then
> +		cmd_args=$2
> +		shift 2

Does this work with params like this (2 words)?

	[pmu-cycle-counter]
	file = pmu.flat
	groups = pmu
	extra_params = -append 'cycle-counter 0'

> +	else
> +		qemu_args+=("$1")
> +		shift 1
> +	fi
> +done
> +
> +if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> +	EFI_CASE=dummy
> +fi
> +
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +mkdir -p "$EFI_CASE_DIR"
> +
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> +echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +
> +EFI_RUN=y $TEST_DIR/run \
> +       -bios "$EFI_UEFI" \
> +       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       "${qemu_args[@]}"
> diff --git a/arm/run b/arm/run
> index 28a0b4a..e96875e 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -67,7 +67,11 @@ fi
>  
>  A="-accel $ACCEL"
>  command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> -command+=" -display none -serial stdio -kernel"
> +command+=" -display none -serial stdio"
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
> -run_qemu $command "$@"
> +if [ "$EFI_RUN" = "y" ]; then
> +	ENVIRON_DEFAULT=n run_qemu $command "$@"
> +else
> +	run_qemu $command -kernel "$@"
> +fi
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a8007f4..aabd335 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.$(exe)
>  tests-common += $(TEST_DIR)/psci.$(exe)
>  tests-common += $(TEST_DIR)/sieve.$(exe)
>  tests-common += $(TEST_DIR)/pl031.$(exe)
> +tests-common += $(TEST_DIR)/dummy.$(exe)
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/arm/dummy.c b/arm/dummy.c
> new file mode 100644
> index 0000000..5019e79
> --- /dev/null
> +++ b/arm/dummy.c
> @@ -0,0 +1,4 @@
> +int main(int argc, char **argv)
> +{
> +	return 0;
> +}
> -- 
> 2.25.1
> 
