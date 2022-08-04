Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E973589E17
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbiHDPCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 11:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiHDPCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 11:02:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ACD14014
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 08:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9ECD9CE26C9
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 15:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD9DC433D7;
        Thu,  4 Aug 2022 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659625359;
        bh=7/nAiCB8mfZXVlpCrRokx4547/D1y9STKRIEvFIx0B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks9rUpNWcxqnnPPjuWV7K1RWjRtMjiSZJ1NeoG4iw3qzKLWrj0XtDQ/bG+FsUzRjH
         sBWf9XmGzIwQ0qamlv3ONlOBsjWlkO7nzTV33mBNXV+qu2LrrjY9dGvgyANTK/P1Vx
         +tgZTvE2eYHB+MmJqRN9ycoCs8EpsLRtvFS+jhm0ffxWysstRDAUFtRrkKPrnf/Oym
         csPkVt3prJry6zdA7OK4h2HvJdf1g/37plYAlXL/l1trpd1sT4dby3dEBHZlCIqaYA
         e970oiruI1nt3urzi+ESbVwIhVahWRleVeT4RUpBnto2B+Il3wq1jZb5TX5aNJ4KPj
         /8Q3N45XJ6apA==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, sami.mujawar@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 0/4] Makefile and virtio fixes
Date:   Thu,  4 Aug 2022 16:02:27 +0100
Message-Id: <165962469392.742851.16474615486987710130.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220722141731.64039-1-jean-philippe@linaro.org>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 15:17:28 +0100, Jean-Philippe Brucker wrote:
> A few small fixes for kvmtool:
> 
> Patch 1 fixes an annoying issue when building kvmtool after updating
> without a make clean.
> 
> Patch 2 enables passing ARCH=i386 and ARCH=x86_64.
> 
> [...]

I wasn't sure whether you were going to respin patch 2 based on Alexandru's
comment, but I actually ran into the legacy IRQ issue so I went ahead and
applied the series. I can, of course, queue extra stuff on top if you like!

Applied to kvmtool (master), thanks!

[1/4] Makefile: Add missing build dependencies
      https://git.kernel.org/will/kvmtool/c/3863f34bd767
[2/4] Makefile: Fix ARCH override
      https://git.kernel.org/will/kvmtool/c/ae22ac7a81e5
[3/4] virtio/pci: Deassert IRQ line on ISR read
      https://git.kernel.org/will/kvmtool/c/fe2182731b72
[4/4] virtio/rng: Zero-initialize the device
      https://git.kernel.org/will/kvmtool/c/6c88c26f701f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
