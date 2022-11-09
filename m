Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26EC623347
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 20:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiKITOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 14:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiKITOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 14:14:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCFE186C8;
        Wed,  9 Nov 2022 11:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A96C961CBA;
        Wed,  9 Nov 2022 19:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF08C433C1;
        Wed,  9 Nov 2022 19:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668021254;
        bh=1uVDPNJRQ+D3xfqxDufJ9hfMqQFP0sCRLukEn84C9tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqEgvkKsUshQBVyh05e4wb4YfxyMwRH1UulPWrOWqpOtoNuwcva78j9sr3AGlX1GK
         SUaJpgJZ0MR3VDUnzXk64yKL+xO35EwSlp6e6g8pH//Uxcoq/EoQ0t8Gc65g7uTArl
         Fo+7DHewb1AydQT641SYKiRl8eViJTyw9r7sKuKRHPjkjbVLYlH1mlFZwN34tleoTj
         6SXL8gKdpkyOxgnCvcvs1alzDCWABQQRJrECrkRBtLdefzVWetFYM+E6mUpQzpmc9M
         7es1n20IMzpLYxGUKfGuGulLiXY7khojzo3/hSzxRDi5Ujq+6aJpBNmq8gQd3deSmn
         9pa4COGZY2Nww==
From:   Will Deacon <will@kernel.org>
To:     mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        Usama Arif <usama.arif@bytedance.com>, steven.price@arm.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        linux@armlinux.org.uk, yezengruan@huawei.com,
        catalin.marinas@arm.com, virtualization@lists.linux-foundation.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        punit.agrawal@bytedance.com, liangma@liangbit.com,
        fam.zheng@bytedance.com
Subject: Re: [PATCH] arm64: paravirt: remove conduit check in has_pv_steal_clock
Date:   Wed,  9 Nov 2022 19:14:00 +0000
Message-Id: <166801751676.863548.12274621159317849693.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221104061659.4116508-1-usama.arif@bytedance.com>
References: <20221104061659.4116508-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Nov 2022 06:16:59 +0000, Usama Arif wrote:
> arm_smccc_1_1_invoke() which is called later on in the function
> will return failure if there's no conduit (or pre-SMCCC 1.1),
> hence the check is unnecessary.
> 
> 

Applied to arm64 (for-next/trivial), thanks!

[1/1] arm64: paravirt: remove conduit check in has_pv_steal_clock
      https://git.kernel.org/arm64/c/1e55b44d9ecd

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
