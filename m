Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5182E72CBF1
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbjFLQ74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbjFLQ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 12:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F20E7D
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 09:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2AD462493
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E89C433EF;
        Mon, 12 Jun 2023 16:59:41 +0000 (UTC)
Date:   Mon, 12 Jun 2023 17:59:38 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 02/17] arm64: Prevent the use of
 is_kernel_in_hyp_mode() in hypervisor code
Message-ID: <ZIdO+vz57U4RiJ2J@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-3-maz@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 05:21:45PM +0100, Marc Zyngier wrote:
> Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
> mistake. This helper only checks for CurrentEL being EL2, which
> is always true.
> 
> Make the compilation fail if using the helper in hypervisor context
> Whilst we're at it, flag the helper as __always_inline, which it
> really should be.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
