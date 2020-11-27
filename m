Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529AB2C6132
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 09:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgK0IuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 03:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgK0IuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 03:50:05 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9496722249;
        Fri, 27 Nov 2020 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606467004;
        bh=MX9vJKbH3cxWgpHtoGd0wZlzLIS8UOK+zuJffSAUtew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=efktCWKGLzw7Um1ysYIPbSerZihvqFnqpGW/vr/Hcc/V/ddM4k8d485Tton7Q0I6i
         kPiXyzJHwrofdgbqqSOcB0hdrD+IvsHqBo1t48D2iXD6jctmEbVLhLbHIi4EVRhrxN
         8+OEVPuekmlC2pHLxhVYrhqMa2a7sC0TEisotaL8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiZS6-00E0id-EK; Fri, 27 Nov 2020 08:50:02 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Nov 2020 08:50:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 5/8] KVM: arm64: Remove PMU RAZ/WI handling
In-Reply-To: <cb7ebedb-5525-8493-007f-72c81b16189b@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-6-maz@kernel.org>
 <cb7ebedb-5525-8493-007f-72c81b16189b@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7ae93087a57bd5f6a348f0d4d6a7db2d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-26 15:06, Alexandru Elisei wrote:
> Hi Marc,
> 
> This patch looks correct to me, I checked in the Arm ARM DDI 0487F.b 
> and indeed
> all accesses to the PMU registers are UNDEFINED if the PMU is not 
> present.
> 
> I checked all the accessors and now all the PMU registers that KVM 
> emulates will
> inject an undefined exception if the VCPU feature isn't set. There's
> one register
> that we don't emulate, PMMIR_EL1, I suppose that's because it's part of 
> PMU
> ARMv8.4 and KVM advertises ARMv8.1; if the guest tries to access it, it 
> will get
> an undefined exception and KVM will print a warning in 
> emulate_sys_reg().

Funny that. I wrote a patch for that a long while ago, and obviously
never did anything with it [1]... Actually, the whole series was 
silently
dropped. I guess I had other things to think about at the time!

Let me pick that up again.

> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

         M.

[1] 
https://lore.kernel.org/kvmarm/20200216185324.32596-6-maz@kernel.org/
-- 
Jazz is not dead. It just smells funny...
