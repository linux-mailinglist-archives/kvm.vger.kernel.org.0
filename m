Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD14C350174
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhCaNjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 09:39:31 -0400
Received: from foss.arm.com ([217.140.110.172]:42456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235772AbhCaNjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 09:39:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13C4DD6E;
        Wed, 31 Mar 2021 06:39:05 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1DCF3F694;
        Wed, 31 Mar 2021 06:39:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Elect Alexandru as a replacement for Julien
 as a reviewer
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210331131620.4005931-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4a55b56b-5a47-9ccd-566c-f75961a85970@arm.com>
Date:   Wed, 31 Mar 2021 14:39:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331131620.4005931-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/31/21 2:16 PM, Marc Zyngier wrote:
> Julien's bandwidth for KVM reviewing has been pretty low lately,
> and Alexandru has accepted to step in and help with the reviewing.
>
> Many thanks to both!

Happy to help!

Acked-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aa84121c5611..803bd0551512 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9765,7 +9765,7 @@ F:	virt/kvm/*
>  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
>  M:	Marc Zyngier <maz@kernel.org>
>  R:	James Morse <james.morse@arm.com>
> -R:	Julien Thierry <julien.thierry.kdev@gmail.com>
> +R:	Alexandru Elisei <alexandru.elisei@arm.com>
>  R:	Suzuki K Poulose <suzuki.poulose@arm.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	kvmarm@lists.cs.columbia.edu
