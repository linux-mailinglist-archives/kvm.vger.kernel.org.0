Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC407492A08
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346177AbiARQEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346164AbiARQE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:04:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D718C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DsH535g+sCum3U0D/7MO9h2z+P8yeHq8a+8/WjWKEG8=; b=lAgjVtqbAX+LcI51G6OoJziCSP
        +PrjYIH1LIcTJ27BFDyc6TICiYuORE8KbFWM87OaPCyDKPuiWNdHmd1lqpZpiBEixGdtboC+WSRlv
        eIYlwGwLqbAzWJGYv4gaPLm6nx9gAeQVFJmDoBum0ojSZA2oTjIhLimSw3fcsJYdEV9t5+e0KifNy
        BUn7pR24xdUCkr6AKWU02zOOEjsl8jVEVgyM0YAKSBQvhjiPCnDLAFEu1kP021BQ2AVAN9iaAAyxz
        Jh3akb2htT7s6ES2QT5WDoIEjv1CYaBvA1yywrg/vIipwJc4CWBU7vPjNJ7TZ0t8SkM7tmjCuDRO6
        NmTfrimw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9qy8-0003x8-09; Tue, 18 Jan 2022 16:04:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9qy5-0004QA-JB; Tue, 18 Jan 2022 16:04:21 +0000
Date:   Tue, 18 Jan 2022 16:04:21 +0000
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
Subject: Re: [PATCH v5 15/69] KVM: arm64: nv: Inject HVC exceptions to the
 virtual EL2
Message-ID: <YeblBbmkvD7XwmIt@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-16-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-16-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:56PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> As we expect all PSCI calls from the L1 hypervisor to be performed
> using SMC when nested virtualization is enabled, it is clear that
> all HVC instruction from the VM (including from the virtual EL2)
> are supposed to handled in the virtual EL2.
> 
> Forward these to EL2 as required.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: add handling of HCR_EL2.HCD]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 11 +++++++++++

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
