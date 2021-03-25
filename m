Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCE349685
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYQP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:15:59 -0400
Received: from foss.arm.com ([217.140.110.172]:53318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhCYQPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 12:15:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8086B143D;
        Thu, 25 Mar 2021 09:15:30 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [10.57.23.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE85A3F718;
        Thu, 25 Mar 2021 09:15:29 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/2] arm64: argc is an int
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com
References: <20210325155657.600897-1-drjones@redhat.com>
 <20210325155657.600897-2-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <24a4beef-7c27-cceb-8029-4110e26affcf@arm.com>
Date:   Thu, 25 Mar 2021 16:15:28 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325155657.600897-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 15:56, Andrew Jones wrote:
> If argc isn't aligned to eight bytes then loading it as if it's
> eight bytes wide is a bad idea. It's only four bytes wide, so we
> should only load four bytes.
> 
> Reported-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Thanks for fixing this.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/cstart64.S | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 89321dad7aba..0a85338bcdae 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -100,7 +100,7 @@ start:
>   1:
>   	/* run the test */
>   	adrp	x0, __argc
> -	ldr	x0, [x0, :lo12:__argc]
> +	ldr	w0, [x0, :lo12:__argc]
>   	adrp	x1, __argv
>   	add	x1, x1, :lo12:__argv
>   	adrp	x2, __environ
> 
