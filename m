Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2516C490B95
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiAQPkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240572AbiAQPkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:40:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958E2C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lzdw6Nwn/vFRWz9WPmMH5XAh3P+TxRDaZo1uvpfE2q0=; b=Lqxv7+kxwBdy26Iyw1jNLC3CKA
        2GHch2IuPp9L0uGBKnf5CnKD1T9t4qLvUHxB0iFZrOQjzOEOki5POQ7jakgBvFphqfGgvW4/R2Swk
        jUrp+WsL48NSDb6Xu/48XBqITKBCqhThTcwF4eEb3bMwDgQBD1G9bR6Stad2eJbGhGyacMqBPohiK
        2MMWj9Fq1gh8J4ZTU5PRJfeaX/NhwpC+09ZnrgHJcaUg+vN+KVbffD7ixUuopggIl/o/Y+SL2cIaf
        aB1EqpZCUwwECnAB/wnIGz0T+4LDsUUxIvaXq/J72f/4n6kT7p3LraIc2fgMy5fguhi2bFohZh3P3
        G0im24LA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56728)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9U7H-0002nI-KW; Mon, 17 Jan 2022 15:40:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9U7E-0003RF-Qr; Mon, 17 Jan 2022 15:40:16 +0000
Date:   Mon, 17 Jan 2022 15:40:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 03/69] KVM: arm64: Add minimal handling for the
 ARMv8.7 PMU
Message-ID: <YeWN4JoAB5UqN2/0@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-4-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:44PM +0000, Marc Zyngier wrote:
> When running a KVM guest hosted on an ARMv8.7 machine, the host
> kernel complains that it doesn't know about the architected number
> of events.
> 
> Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20211126115533.217903-1-maz@kernel.org

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
