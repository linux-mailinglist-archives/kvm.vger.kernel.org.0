Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5114A619E
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 17:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbiBAQwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 11:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbiBAQv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 11:51:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3ABC061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 08:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4RYLbPYhwvz3vodCfFsOAXqcVYhkJQJgonJ0Dgy6/18=; b=qOKwGJKjRULYfRSB8qLlAl6/Sw
        hp8JAMx372ifqhLcNsJaRart9AJw8OM1b2dVTSjxOHh6fPlYNrDoipHQDvlHLr5fIgj8yLl7FCWWw
        8vJyEdFvTqF6T+7mrDhvJxkwiGLXDvGTG9G2l8cjdcxmN+DFFQ/bsKdtDHKNYZMuCcAftv5ZGYl6b
        IPA1LQf+Crr2qlgz1UkHsqjK6Dr57BOoeeoZV5cUbAW2SXvwv5jvB/0ufj03HkwZ+9RsVOKMC6u/I
        HSIkTTuQmhNPt16ZDWyD6XNV/qC2LbzlMmCVT/bUlPXuB5iwR5WjGgIA5GYbUtqz9jrPSTc8JvPhG
        CXdahTxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56974)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nEwNm-0000ps-43; Tue, 01 Feb 2022 16:51:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nEwNj-0002EH-LT; Tue, 01 Feb 2022 16:51:51 +0000
Date:   Tue, 1 Feb 2022 16:51:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 15/64] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Message-ID: <YfllJ9WPx45nzeCZ@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-16-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-16-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 12:18:23PM +0000, Marc Zyngier wrote:
> HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
> we deal with a lot of the state. So when the guest flips this bit
> (sysregs are live), do the put/load dance so that we have a consistent
> state.
> 
> Yes, this is slow. Don't do it.

I'd hope this is very unlikely!

> 
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
