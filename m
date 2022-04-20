Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64265508E6C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381091AbiDTRbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381084AbiDTRbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E26A46B08
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E1061A2D
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F9EC385A0;
        Wed, 20 Apr 2022 17:28:16 +0000 (UTC)
Date:   Wed, 20 Apr 2022 18:28:13 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 09/10] arm64: Add wfet()/wfit() helpers
Message-ID: <YmBCrbWRFcTgeBDg@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
 <20220419182755.601427-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-10-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 07:27:54PM +0100, Marc Zyngier wrote:
> Just like we have helpers for WFI and WFE, add the WFxT versions.
> Note that the encoding is that reported by objdump, as no currrent
> toolchain knows about these instructions yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
