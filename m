Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23B575B3C5
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 18:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjGTQEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjGTQEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 12:04:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E96910FC
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 09:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46D961B59
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 16:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4B6C433C8;
        Thu, 20 Jul 2023 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689869086;
        bh=/STk+I4XHbAtkpf7FZs+JivKi7EAAEEjumJLtcR8Ll0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCqj0YODUyWReHl1caoY5dTg/OwLd6VFMLrkDULP4uJ5Wf+K7vmSCHTI8QQU1J9fN
         W+O3VV2CYD3lk2/Z6wY7gkV+KNvu3ZfT9uMipDSKPd4mKvtrOKlO6/pHqhuc4SajTy
         Me8RSXJ6FnVo0kdjSx85W8rTWQYZ1OAp2jZ3CWVRSVLRJEjIj7Z8ZrIWIqVCw6yyKT
         8dDm/RQdlQgeGv65QMttlu8su0qmFlM2JnXGLiYVFaJk/OpwIQMmB2vtG/uK+KxARB
         MF65g9zy39nFR7GfCzWRQMaoQP4NQ/ho5wFCfxlJnuRde1Ir/mlFBE8Fhfusie8wnm
         1AW8He1jO466Q==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        jean-philippe.brucker@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        oliver.upton@linux.dev, apatel@ventanamicro.com, maz@kernel.org,
        andre.przywara@arm.com, Suzuki.Poulose@arm.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] virtio-net: Don't print the compat warning for the default device
Date:   Thu, 20 Jul 2023 17:04:38 +0100
Message-Id: <168986515165.3086213.4288799069467644194.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230714152909.31723-1-alexandru.elisei@arm.com>
References: <20230714152909.31723-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jul 2023 16:29:09 +0100, Alexandru Elisei wrote:
> Compat messages are there to print a warning when the user creates a virtio
> device for the VM, but the guest doesn't initialize it.
> 
> This generally works great, except that kvmtool will always create a
> virtio-net device, even if the user hasn't specified one, which means that
> each time kvmtool loads a guest that doesn't probe the network interface,
> the user will get the compat warning. This can get particularly annoying
> when running kvm-unit-tests, which doesn't need to use a network interface,
> and the virtio-net warning is displayed after each test.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio-net: Don't print the compat warning for the default device
      https://git.kernel.org/will/kvmtool/c/15757e8e6441

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
