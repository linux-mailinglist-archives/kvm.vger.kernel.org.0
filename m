Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1977C9281
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 05:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjJNDc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 23:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJNDc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 23:32:56 -0400
Received: from out-205.mta0.migadu.com (out-205.mta0.migadu.com [IPv6:2001:41d0:1004:224b::cd])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AEEBE
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 20:32:53 -0700 (PDT)
Date:   Sat, 14 Oct 2023 03:32:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697254370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oLvsxWswXaahyZapR9wNq3U+gs4SHEITbqa7yyhDkjg=;
        b=nkKrkV80GsiNRpb4OJXVy3FEoYr7FRCEh56ngj/t0VOHWIlBUNyjf+KC+oh/GDazxnItRs
        aLy0Q3D1vzQUsBe6IINymydIqWsBHLKFCXIz1hsZMfwdrzp6+AgjixR2MkZ5XCmL/2AwJt
        BpzgY+zRDfVlxKdVnghut/3kEuyoljk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the
 *32_EL2 sysregs
Message-ID: <ZSoL3vZDZk5RBhCS@linux.dev>
References: <20231013223311.3950585-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013223311.3950585-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 11:33:11PM +0100, Marc Zyngier wrote:
> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
> UNDEF when AArch32 isn't implemented, which is definitely the case when
> running NV.
> 
> Given that this is the only case where these registers can trap,
> unconditionally inject an UNDEF exception.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

If you intend to send this as a fix for 6.6:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Otherwise it is on the stack of patches I'll pick up for 6.7

-- 
Thanks,
Oliver
