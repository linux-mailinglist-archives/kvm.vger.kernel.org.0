Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA63B900E
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 11:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhGAJ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 05:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhGAJ5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 05:57:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9FFC061756;
        Thu,  1 Jul 2021 02:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4ISMbJgxh4MN3I/dz1+lt1f6neKYoIuu0hFv4GIRZlY=; b=qYEKPVrHK+H/GAfvYbUJQQGaj
        pR59K5u22mfe210Cug69+BOdYcbVAsOr7zJiMfigpQ8/p9DCXiwzIQvzA5zPF/ngZ2uNNNiHMI9Tj
        wh950U+REOku26aYcn76EPBFWERoBIcpgjYbznoGTch+4c3WQrHbQatqknwf3XcsLSvVwGrpQo/rL
        4P2MbAPmKh0N1Y8rGRsQVp40HbFf6iJ5TtaiMa/xOTSt0GIKsR5g+3SmHbQdbGqxhoQLQd+uVl3DK
        n+v0zftYuwG3xWa03AsXHsmWJ48c9es5kBYW0wTEGWMXEndO5h2+nGTSDx8TIW/ypXi7EVnCUz9My
        Iyrw1J2yw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45572)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lytPO-00011Z-Bt; Thu, 01 Jul 2021 10:54:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lytPK-0003zt-Oz; Thu, 01 Jul 2021 10:54:54 +0100
Date:   Thu, 1 Jul 2021 10:54:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH 4/5] KVM: arm64: Pass hypercalls to userspace
Message-ID: <20210701095454.GI22278@shell.armlinux.org.uk>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <20210608154805.216869-5-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608154805.216869-5-jean-philippe@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 05:48:05PM +0200, Jean-Philippe Brucker wrote:
> * Untested for AArch32 guests.

That really needs testing; you may notice Will Deacon has been
posting patches for aarch32 guests over the last few months, and
there are other users out there who run aarch32 guests on their
aarch64 hardware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
