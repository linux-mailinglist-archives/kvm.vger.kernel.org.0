Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A84929E7
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346043AbiARPwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbiARPwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 10:52:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004CDC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 07:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=elPIXBW7FXq3S/Tn3+vEqhoqfslWkNd3tp++h3TA3AM=; b=DYcvSV5xjHgS0qbIzP0GhhL1A6
        KmeRCcUzSg9BcRT7sfLl/FT2cG9PyJrKimdxqToNiz4+ApSEQ2klP4ej6CgfKOQuFP0jg72VgyoPb
        3d9srHX7r5Cikv5azeY4Ks+p2jn9JXAvTWCG0u98z5O9boU29jC7w2NB1meAkkA2PuB+ZFxDk9wmw
        UKiHXbp0dwWHR7kspTw5K32qHn2LoyB7ujGaE7XWBkcly7g2v/vQN++48rwwhOvB7TfkBMu+GJ/UQ
        u2XzyQkxb5r55sEJkjdid8jdAcRq4gFx/9OqQnJlPPp3/1Q3vh5RhcqoLlW/R8Kl+q8FdBkwD7gKa
        DIDbgSjQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56762)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9qmv-0003wO-WB; Tue, 18 Jan 2022 15:52:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9qms-0004Pq-Jj; Tue, 18 Jan 2022 15:52:46 +0000
Date:   Tue, 18 Jan 2022 15:52:46 +0000
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
Subject: Re: [PATCH v5 13/69] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2
 to sane values
Message-ID: <YebiThx2+EoaFEeP@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-14-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-14-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:54PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
> let's be nice to a guest hypervisor behaving foolishly and reset these
> to something reasonable anyway.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
