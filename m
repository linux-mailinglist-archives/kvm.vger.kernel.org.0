Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8001C731BB7
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345086AbjFOOrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345076AbjFOOrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 10:47:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 683E82972
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:47:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5534F2F4;
        Thu, 15 Jun 2023 07:48:04 -0700 (PDT)
Received: from [10.57.85.226] (unknown [10.57.85.226])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C25D3F663;
        Thu, 15 Jun 2023 07:47:19 -0700 (PDT)
Message-ID: <75f436e9-f7a9-a0da-46d3-e924ccab9091@arm.com>
Date:   Thu, 15 Jun 2023 15:47:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH 2/3] arm/efi/run: Add Fedora's path to
 QEMU_EFI
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
 <20230607185905.32810-3-andrew.jones@linux.dev>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230607185905.32810-3-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/2023 19:59, Andrew Jones wrote:
> Try Fedora's default path too.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index c61da31183a7..f75ef157acf3 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -15,8 +15,14 @@ source config.mak
>   source scripts/arch-run.bash
>   source scripts/common.bash
>   
> +if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
> +	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> +elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> +	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
> +fi
> +
>   : "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> -: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
> +: "${EFI_UEFI:=$DEFAULT_UEFI}"
>   : "${EFI_TEST:=efi-tests}"
>   : "${EFI_CASE:=$(basename $1 .efi)}"
>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
> @@ -24,9 +30,8 @@ source scripts/common.bash
>   [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
>   
>   if [ ! -f "$EFI_UEFI" ]; then
> -	echo "UEFI firmware not found: $EFI_UEFI"
> -	echo "Please install the UEFI firmware to this path"
> -	echo "Or specify the correct path with the env variable EFI_UEFI"
> +	echo "UEFI firmware not found."
> +	echo "Please specify the path with the env variable EFI_UEFI"
>   	exit 2
>   fi
>   
