Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C73C72CF33
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 21:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbjFLTRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 15:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbjFLTQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 15:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FF91980
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 12:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9297760C53
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 19:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE35C433D2;
        Mon, 12 Jun 2023 19:16:09 +0000 (UTC)
Date:   Mon, 12 Jun 2023 20:16:06 +0100
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
Subject: Re: [PATCH v3 16/17] arm64: Allow arm64_sw.hvhe on command line
Message-ID: <ZIdu9mV5v7Wy7puI@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-17-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-17-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 05:21:59PM +0100, Marc Zyngier wrote:
> Add the arm64_sw.hvhe=1 option to force the use of the hVHE mode
> in the hypervisor code only.
> 
> This enables the hVHE mode of operation when using KVM on VHE
> hardware.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
