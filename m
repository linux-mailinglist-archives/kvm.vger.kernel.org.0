Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC3508E5F
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381057AbiDTR1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381010AbiDTR10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:27:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14374665E
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96DC1B82115
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399F0C385A1;
        Wed, 20 Apr 2022 17:24:35 +0000 (UTC)
Date:   Wed, 20 Apr 2022 18:24:31 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 00/10] arm64: Add initial support for FEAT_WFxT
Message-ID: <YmBBz8yKPAWSHAJo@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 07:27:45PM +0100, Marc Zyngier wrote:
> A potential addition to this series would be to remove the event
> generation from the counters, and rely on the timeout where it
> matters (spinlocks?). Feedback welcome.

I think we still need to keep the event generation around, at least for
hardware bugs we don't know about. I don't think user-space rely on it
though, people tend to come up with weird delays like isb ;). But yes,
the WFET should be handy when it turns up in hardware.

-- 
Catalin
