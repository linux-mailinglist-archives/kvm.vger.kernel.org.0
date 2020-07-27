Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA8322F738
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 20:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgG0SBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 14:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbgG0SBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 14:01:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B5B8207FC;
        Mon, 27 Jul 2020 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872865;
        bh=LiT0HhpVCBd1KW3rnKmOUK2mjDwkRwzZ96Gt737VW3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wVbvqo+QOkquTPq8D8UIbArLkAANHWm9K2O8YKGLDhq7rVwWYCt8R+08PP8Uulyde
         tp+srKOoVdtxLtfaNacQ70XOYs2ZBh5PxFi2z4I9ytQRIwmhrWPtrKrTOkRTyzKY3y
         Cj4SA95BTOO1EVePed4aVL2S5Z+NBrdGP8Nrc1qc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k07Qu-00FO6r-66; Mon, 27 Jul 2020 19:01:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 19:01:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b9176783230caeb1224043ed150c4139@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-11 11:04, Andrew Jones wrote:
> The first three patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support (I'll reply
> to this mail with a link to the QEMU patches after posting - which I'll
> do shortly). The last patch is only a convenience for userspace, and I
> wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
> I'll be posting are currently written without the cap. However, if the
> cap is accepted, then I'll change the QEMU code to use it.
> 
> Thanks,
> drew
> 
> Andrew Jones (5):
>   KVM: arm64: pvtime: steal-time is only supported when configured
>   KVM: arm64: pvtime: Fix potential loss of stolen time
>   KVM: arm64: pvtime: Fix stolen time accounting across migration
>   KVM: Documentation minor fixups
>   arm64/x86: KVM: Introduce steal-time cap
> 
>  Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
>  arch/x86/kvm/x86.c                |  3 +++
>  include/linux/kvm_host.h          | 19 +++++++++++++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  7 files changed, 58 insertions(+), 21 deletions(-)

Hi Andrew,

Sorry about the time it took to get to this series.
Although I had a number of comments, they are all easy to
address, and you will hopefully be able to respin it quickly
(assuming we agree that patch #1 is unnecessary).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
