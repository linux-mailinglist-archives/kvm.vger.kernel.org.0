Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3BD508E6A
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381089AbiDTRam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381084AbiDTRal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:30:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99D846678
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73D466198E
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF626C385A0;
        Wed, 20 Apr 2022 17:27:51 +0000 (UTC)
Date:   Wed, 20 Apr 2022 18:27:48 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 08/10] arm64: Add HWCAP advertising FEAT_WFXT
Message-ID: <YmBClAXRSsiUDK/f@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
 <20220419182755.601427-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-9-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 07:27:53PM +0100, Marc Zyngier wrote:
> In order to allow userspace to enjoy WFET, add a new HWCAP that
> advertises it when available.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I assume this series will go in via the kvm tree? Could we have the
HWCAP changes at the beginning, I'm sure they'll conflict with other
series (I plan to queue the SME patches).

-- 
Catalin
