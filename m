Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FBE245E26
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHQHjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgHQHjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:39:15 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CC420758;
        Mon, 17 Aug 2020 07:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597649954;
        bh=5f7u17TvsjTrzreApIZ4x0jr/04LEQs1hIO1IBZJBVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZk/ZzO0Xwj51vzBkOh6djd6cauo+roP/pRXxR0PLsTP9CxwmDwEQWJzTOZ+efS5N
         QUUrA+K/1xW95pGQ2wvCVRVUyJzPQ17UZXIXt1cfl5+9y6EMMgKTNeEDjcoRzAfaIj
         XlILTLZZUpgl+E35JmvL+d76aYnLmH9VvHC3F0nA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7Zjc-003T4X-BL; Mon, 17 Aug 2020 08:39:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Aug 2020 08:39:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>, wanghaibin.wang@huawei.com
Subject: Re: [PATCH 2/3] KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in
 kvm_device_type
In-Reply-To: <20200817033729.10848-3-zhukeqian1@huawei.com>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-3-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <f97633b4a39c301f916bb76030dcabf0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, steven.price@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-17 04:37, Keqian Zhu wrote:
> ARM64 PV-time ST is configured by userspace through vCPU attribute,
> and KVM_DEV_TYPE_ARM_PV_TIME is unused.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  include/uapi/linux/kvm.h       | 2 --
>  tools/include/uapi/linux/kvm.h | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf303..9a6b97e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_XIVE,
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
> -	KVM_DEV_TYPE_ARM_PV_TIME,
> -#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>  	KVM_DEV_TYPE_MAX,
>  };
> 
> diff --git a/tools/include/uapi/linux/kvm.h 
> b/tools/include/uapi/linux/kvm.h
> index 4fdf303..9a6b97e 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_XIVE,
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
> -	KVM_DEV_TYPE_ARM_PV_TIME,
> -#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>  	KVM_DEV_TYPE_MAX,
>  };

No. You can't drop anything from UAPI, used or not. Doing so will
break the compilation of any userspace that, for any reason, references
this value. We cannot reuse this value in the future either, as it would
create a we wouldn't know which device to create.

It is pretty unfortunate that PV time has turned into such a train 
wreck,
but that's what we have now, and it has to stay.

         M.
-- 
Jazz is not dead. It just smells funny...
