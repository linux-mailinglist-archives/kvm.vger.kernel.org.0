Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5917225FB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjFEMf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbjFEMft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C00103
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 05:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C38611EE
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 12:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353C2C433D2;
        Mon,  5 Jun 2023 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685968516;
        bh=YO4kZjmUvbXAnDKPdDvWLdTAf8U+N9HRehr/42w6f58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfOtbCT5BCEiUIpQkUW6rItahIiZoxlXaWV3r6bsBEPFIYD7srLkdiMZz/tdSeNBc
         Bsgf0hzYEv5ferLiW0eey69XKQiw0sKW9964rlAcJQc0e/AIMnTXdmOTkpzrn6eWg6
         ySdeG0MBVPahuT6TKJQc7fOS455Yt5TKHPFbaWqLf/0fCMsFvILMQWoycHwSlBBByV
         IIhsiUUhUfXzkbPJxf/QmQe6PURnzaQwqfRALYFT0JQ9PxSwmo6PsTO8mdJjtJjWMF
         9ah3jx6HBDDhaKAWiaXv2IoB1MxP6ddnxqy/hlqXEDQit7XuzO7gjbV/xNBPe5Ys7W
         wS+UbTzOqzcwQ==
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 0/2] Fix builds with clang
Date:   Mon,  5 Jun 2023 13:35:11 +0100
Message-Id: <168596774694.3021087.14677709843430607064.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230525144827.679651-1-andre.przywara@arm.com>
References: <20230525144827.679651-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 May 2023 15:48:25 +0100, Andre Przywara wrote:
> When trying to build kvmtool with clang, it warned about two problems,
> which are fatal since we use "-Werror".
> 
> Patch 1/2 is an easy one fixing an obvious bug (not sure why GCC didn't
> warn). Patch 2/2 removes an ugly hack which clang didn't want to let
> pass. This patch admittedly implements the most tedious solution to this
> problem, but I didn't want to just throw in a "__maybe_unused" (or
> "__used", as kvmtool puts it). If that solution is a bit over the top,
> let me know, maybe there is better solution which doesn't require to
> touch every user of the virtio endianess conversion functions - or
> __maybe_unused is OK after all.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] option parsing: fix type of empty .argh parameter
      https://git.kernel.org/will/kvmtool/c/c1eecc61558d
[2/2] virtio: sanitise virtio endian wrappers
      https://git.kernel.org/will/kvmtool/c/b17552ee6c97

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
