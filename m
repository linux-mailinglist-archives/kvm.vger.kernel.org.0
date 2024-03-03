Return-Path: <kvm+bounces-10740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C9986F749
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 22:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5914B20CEF
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 21:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE187A70B;
	Sun,  3 Mar 2024 21:50:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8EA883C
	for <kvm@vger.kernel.org>; Sun,  3 Mar 2024 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709502649; cv=none; b=urcyRP4dfml/0wGBAHCdP7eob2+GrY9nqQ3tFQaZtkRB/JXfDsRrtg2YYQ61qjTW8nj3mmTf7MlxAA2ABwTXpWLBF7ae+dQx94ALwmyM7hMIeV5yRl7MPdEQAAj+5irR2vYhlQZnGaq2oFFoDN9PNe5ryJa9MOR0c2NewfuXCME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709502649; c=relaxed/simple;
	bh=HS+oah7zz1X4UBuMxGTCh8tcmd1A9IK2XAK4zv7mYqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdJI5YfXLx0jnUuUDdJFo3BKqBRJpYySEK4keNJzhAsW3vrVup/dWfA3lkBQJjOY1ycdd8IYq+HAkWdbLFC3CvCTWyx95gsHIqYydmWlR5GyhMYTuAj41F3dyLaf1Z7aTUMw6AdtebBUW5Mc5hJTmz/YOWKXmuWDKVhzTI1I/q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 588A61FB;
	Sun,  3 Mar 2024 13:51:22 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334C83F73F;
	Sun,  3 Mar 2024 13:50:44 -0800 (PST)
Message-ID: <b806b4d8-f7d7-4d65-8ef5-3abfe07b87b6@arm.com>
Date: Sun, 3 Mar 2024 21:50:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 02/18] runtime: Add yet another 'no
 kernel' error message
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-22-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-22-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> When booting an Arm machine with the -bios command line option we
> get yet another error message from QEMU when using _NO_FILE_4Uhere_
> to probe command line support. Add it to the check in
> premature_failure()
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   scripts/runtime.bash | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f2e43bb1ed60..255e756f2cb2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -18,7 +18,7 @@ premature_failure()
>       local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
>       echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
>           return 1
>   
>       RUNTIME_log_stderr <<< "$log"

