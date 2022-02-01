Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B214A6176
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiBAQiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 11:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiBAQiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 11:38:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27895C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1lTsDEbwIELOLsQQ3LW7YTALtUz0mwSPckKDI4izXLA=; b=MBrbQx2kPnS1qOhHR005ucRtL2
        QUby9b49hytlEAupmcgr6Lex8Lk+lBOpUqlEmuPYmUywvUjGI+mdVf3p87XZo6xKoue25YQHu2AmD
        LIgZ4VJrDA06LB4AqGx5DcB3++FmZ2AlnYQkdVwByjsfwHrhLTjrrQGA4Qq2ElyGlfQtt0QDRToZB
        C2YKg10OI51HN52UCV2ja7zIcO35E8mPUzZyxbswIRV6n0jeqtNvezBp9K7n2BBOLoulB+kg0lmNw
        MWPYxtCUk+ANHPmRxLQNU7WUrDVFKZYb7vQrHksQmrRyUf/gv2cAKE/r4NLEJKqSNdvu3jDeZp9/R
        OYHfBUVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56968)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nEwAJ-0000oc-3y; Tue, 01 Feb 2022 16:37:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nEwA5-0002D4-92; Tue, 01 Feb 2022 16:37:45 +0000
Date:   Tue, 1 Feb 2022 16:37:45 +0000
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
Subject: Re: [PATCH v6 12/64] KVM: arm64: nv: Add non-VHE-EL2->EL1
 translation helpers
Message-ID: <Yflh2ad0lkoqTSqX@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-13-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-13-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 12:18:20PM +0000, Marc Zyngier wrote:
> Some EL2 system registers immediately affect the current execution
> of the system, so we need to use their respective EL1 counterparts.
> For this we need to define a mapping between the two. In general,
> this only affects non-VHE guest hypervisors, as VHE system registers
> are compatible with the EL1 counterparts.
> 
> These helpers will get used in subsequent patches.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
>  arch/arm64/include/asm/kvm_nested.h | 54 +++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index fd601ea68d13..5a85be6d8eb3 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -2,6 +2,7 @@
>  #ifndef __ARM64_KVM_NESTED_H
>  #define __ARM64_KVM_NESTED_H
>  
> +#include <linux/bitfield.h>
>  #include <linux/kvm_host.h>
>  
>  static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
> @@ -11,4 +12,57 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
>  		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>  
> +/* Translation helpers from non-VHE EL2 to EL1 */
> +static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
> +{
> +	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;

I frowned about the use of FIELD_GET() but not FIELD_PREP(), which
would be:

	return FIELD_PREP(TCR_IPS_MASK, FIELD_GET(TCR_EL2_PS_MASK, tcr_el2));

However, I'm not bothered by this beyond frowning!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
