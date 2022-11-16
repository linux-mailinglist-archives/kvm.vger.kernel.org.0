Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED8562B3E1
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 08:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiKPH1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 02:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKPH1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 02:27:34 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFF4A446;
        Tue, 15 Nov 2022 23:27:33 -0800 (PST)
Date:   Wed, 16 Nov 2022 07:27:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668583652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QTadVoqTlZKm9VTvcDO0wveHBTpSFQKiIG+uKAG+8kM=;
        b=V9pS43higRceJa5AF+9MmdQqVOFLDPCAwKI1AmsPGuPobz+Q0p1LSPwm1Q5+C4DFql5b7T
        MijRBdX22IcazcREY5/9LVAwgx3USgWhVzi5ei6y2tHNSKu4G261ko5CYgb7yp2YwvSH8D
        fEAuY323ZCDbqMrpdyfbPkYtQwA5GCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3SQ3wogsVUEu1Qe@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868rkbppdq.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> I'm not crazy about this sort of parameters. I think it would make a
> lot more sense to pass a pointer to the walker structure and do the
> flag check inside the helper.
> 
> That way, we avoid extra churn if/when we need extra state or
> bookkeeping around the walk.

Sure, let's go that way instead. v3 on the way lol :)

--
Thanks,
Oliver
