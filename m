Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F667C589E
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjJKPyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 11:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjJKPyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 11:54:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB6B8F
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 08:54:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D7C433C7;
        Wed, 11 Oct 2023 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697039691;
        bh=jQoCWV0LLSnpXnSUdI4fT3RNp9XP0wcuYGalGwjpAJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DJpupm4Kiv4tPJPKCZlHQcWxk1Vkukq5KyySJz2yJm8vTQQQ66njkuCxCN+f5cdsm
         JPwXGdxWeOnUHOaNl0nZtwJYrnHuGfntBfFeZEscsa/uF70UU5pxdAc4TC2+FPcxZJ
         wNQbAH5RHQfimRSlHLlZ9I5EJR0wK39Em52Cho9GGxtev+PxXNOe6+yJTkx20+Z1JP
         U3YYKmBtww8d3CeNA237Z7np2QbOAqhiYMGAcG5yg7GuSDNMEnbXDyDgg2LDjinAUf
         94JD3BzhCB1NIGqrLsuZlBXO9cg55VHk934yDLZ8lVJY4pCTY2SihVdPculhGEdOob
         Rhr2kyQCGegaw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qqbXt-003Cki-Ao;
        Wed, 11 Oct 2023 16:54:49 +0100
MIME-Version: 1.0
Date:   Wed, 11 Oct 2023 16:54:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
In-Reply-To: <20231011081649.3226792-2-oliver.upton@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-2-oliver.upton@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <281b88c0d74b9260b659e6be579a4984@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, rananta@google.com, mark.rutland@arm.com, will@kernel.org, james.clark@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-11 09:16, Oliver Upton wrote:
> The existing PMU emulation code is inadequate for use with nested
> virt. Disable the feature altogether with NV until the hypervisor
> controls are handled correctly.

Could you at least mention *what* is missing? Most of the handling
should identical, and the couple of bits what would need to be
handled (such as MDCR_EL2) are not covered by this disabling.

As it is stands, I'm not there is much to be gained from this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
