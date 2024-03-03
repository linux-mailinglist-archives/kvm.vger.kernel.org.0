Return-Path: <kvm+bounces-10741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BEB86F757
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 22:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DE641F2128F
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 21:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5497AE64;
	Sun,  3 Mar 2024 21:57:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866287A71B
	for <kvm@vger.kernel.org>; Sun,  3 Mar 2024 21:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709503026; cv=none; b=aRg5bGdSSP51ekb57SKyX8Tv/iZz6VBYrZ9fwZc9RFOoAFJglMPsBOHdDFbKKknnjNLGgAC7sC0wf6uCckDdLAtE7YzTFwU1ZZuFRzES0GPgqm71KzB1OKI4KunNzBkMMAPoCk+GXqx3qLPGZVdkjEucu0CH4fAj5FMjO5wnPQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709503026; c=relaxed/simple;
	bh=OV9e2jPIKo/rNlzXHfAygNYg0D79kLqc77QOHE/JGl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oor2Zu610KjAbkhfGSSB0mhBlfsBv1KWuHlZeC8ZsBAH01MONfdzwUJhW/J8ByoOMjpJbOmY3yAlOFDR51YKMg+JvwqfpWFS2Acbo1AfsGg+UnFZ8V7O+Gln8xX4LJ0ZeanN1K+62Y0TDjP1ve1PumnFUI0g4bYpcSJTHRutxB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B18B21FB;
	Sun,  3 Mar 2024 13:57:40 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40A3F3F73F;
	Sun,  3 Mar 2024 13:57:02 -0800 (PST)
Message-ID: <1711b293-baf0-4466-aad8-2cf9432dd240@arm.com>
Date: Sun, 3 Mar 2024 21:57:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 03/18] arm64: efi: Don't create dummy
 test
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-23-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-23-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
> QEMU command line options that have been pulled together by the
> scripts will work. Since booting with UEFI and the -kernel command
> line is supported by QEMU, then we don't need to create a dummy
> test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
> execute it to prove the command line is OK, since we would have
> failed much before all that if it wasn't. Just run QEMU "normally",
> i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
> line options, in order to check the full command line.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 6872c337c945..e629abde5273 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -53,7 +53,14 @@ while (( "$#" )); do
>   done
>   
>   if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> -	EFI_CASE=dummy
> +	EFI_CASE_DIR="$EFI_TEST/dummy"
> +	mkdir -p "$EFI_CASE_DIR"
> +	$TEST_DIR/run \
> +		$EFI_CASE \
> +		-bios "$EFI_UEFI" \
> +		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +		"${qemu_args[@]}"
> +	exit
>   fi
>   
>   : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"

