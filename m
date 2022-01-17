Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9178490F4E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbiAQRUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243299AbiAQRTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 12:19:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B5C08E6DC
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dk8rF/wXUma+XU6t5xUQYc4WvxL35VCCnB3SoO679NE=; b=EYxsMyOn4TiECRcnoyrdJTUcl9
        iTrCKoj8mE6558FoEFHaEwj9iouXl7DWxyKDyU1qS4fb3Vqog664RIUo2bj0WBJd2sh7uduUf/JUK
        AGO4wD9gfvhm4UMmhTv/HSK08b3QkE8AyfoYaUVCOnkVzmE5+URoHhen67iSHLHh6Bo4BxOCaIkPr
        bqRc1UsdZXVkwlp70g/NHNLtvfzHLUrlAw/S4o8dEm8EgXDMd8O+kiA5L3LO57LbLRC7QIgIRF/vG
        wHNB1z6qXW+ODvqJY1UhKZQVVRafXvRyVkS2L9ZRqsPLosm1JGHW7Vr1k15IOJlJcyljnonrs0vnE
        Qj6vhKMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56740)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9VaQ-0002uH-RE; Mon, 17 Jan 2022 17:14:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9VaN-0003VQ-26; Mon, 17 Jan 2022 17:14:27 +0000
Date:   Mon, 17 Jan 2022 17:14:27 +0000
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
Subject: Re: [PATCH v5 10/69] KVM: arm64: nv: Add EL2 system registers to
 vcpu context
Message-ID: <YeWj82BipOSA8jIe@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-11-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:51PM +0000, Marc Zyngier wrote:
> Add the minimal set of EL2 system registers to the vcpu context.
> Nothing uses them just yet.
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
