Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D443D4929D6
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345998AbiARPqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345950AbiARPqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 10:46:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937EC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 07:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rBYDtx+yhdQCukEhQ6wlaxPBRfixnikoYw7y1W9myjE=; b=l4NGkUF39DsBamx0uJYsnKdZA5
        CNVr74NCCopmw/rmLfSOPHW2qdCrCIwZUlBkDBZZHaedmhx8A+elaNpOHo8atdoZNRaTiHnr0kWyA
        7yrb2j4l1aUexB9Y/TCpMXz74siG+Svtgk19Yx/tFc9D+ZwKHBpwEjWeChYEC6BDRnMg10f8C5LCX
        GhcVOFSxsSGdHZ3NTq1Y8HS1Kf0p4SsVrcbIvoinpCd/M96ZbcdEbEQNEKcDkqV5rMo/Fkz1e7JX4
        8PwpkcLsnNToqzrcMH1dWaQjx7gl51R5dhbN2dW76smQ9utuR0abdVpdIg8gfy8hyhIe/ACmeBOzA
        52izWP4A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56758)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9qgM-0003vV-RC; Tue, 18 Jan 2022 15:46:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9qgF-0004PY-Lq; Tue, 18 Jan 2022 15:45:55 +0000
Date:   Tue, 18 Jan 2022 15:45:55 +0000
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
Subject: Re: [PATCH v5 11/69] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <Yebgs/vsczGLfLqP@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-12-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-12-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:52PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
