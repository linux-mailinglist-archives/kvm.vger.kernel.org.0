Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3274E490BCA
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbiAQPv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiAQPv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:51:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C293BC061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ijFecGAxiZjgRedLXwFR1clSAj6Wz+yJdh4E5o7HuoE=; b=1FTGT8UpCjgQ7BPui+BQjp6SvJ
        PQ9ZdgVrevLOCJaNhvwLBv2OajAFdBOywlaLaF71u37NEKL2EPtUuPy2GtcvBpeehA6Y605cXsDow
        4mGHXndr1C08bjeBTnXkDeRD+xweGJx0xX/yMZCiLAzUQomHNwr+xT52si9PdXJGqr5NRWyzUmQmV
        hpBl1IswT1UlO2TrEKm2c5e6js4h3SpvJa197ug3bzoZPDRARi7oG1cjty9YmyvDiMVq6NOzpauoT
        pvol1L3mX24FgkKPpXVqNFh1bfz0CxbUP4JWstKDJXl22Vs3pIRKCLwx70GOpN7a2XHGfz7F/7fQW
        rE8s5fKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56732)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9UIQ-0002oN-3d; Mon, 17 Jan 2022 15:51:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9UIO-0003RX-3U; Mon, 17 Jan 2022 15:51:48 +0000
Date:   Mon, 17 Jan 2022 15:51:48 +0000
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
Subject: Re: [PATCH v5 05/69] KVM: arm64: Allow preservation of the S2 SW bits
Message-ID: <YeWQlNdI7OvLjeNv@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-6-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:46PM +0000, Marc Zyngier wrote:
> The S2 page table code has a limited use the SW bits, but we are about

I think the opening clause needs to be rewritten.

> to need them to encode some guest Stage-2 information (its mapping size
> in the form of the TTL encoding).
> 
> Propagate the SW bits specified by the caller, and store them into
> the corresponding entry.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
