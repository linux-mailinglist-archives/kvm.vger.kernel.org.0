Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD7252F4A9
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353580AbiETUvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353581AbiETUvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9518366
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 13:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F56F61D23
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 20:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244EEC34115;
        Fri, 20 May 2022 20:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653079875;
        bh=debJamhWu4mwFhoKyhYkWrak+H1GjYl0qGFH/48mPCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv+ZPTNsf7lV5B9KtI6C59rZqNLcgXhEzhSkG+zJDmm9edWXJLwq8eIBrGKGtF/5C
         nwcmfTTk7Bs4I1IQj/CGQG0/ju5pcQC9MZ36lCPGnPXvED9WO2fUhDVy0e6+QLNmJu
         iASNS2Uyawo7QSvSbPYWErP3rP8v/YoJ2l58v2qX7sjb2bn4+jSdhD9hq8iK0m39bt
         02WABIG8HROLwsRtoTgvr9MhRoHzqn+eSTnD+Wt7B2HJq2YtKYPXkjsxSfylX7lNLZ
         do69TBlFkhVeyOJzxk0l2LqSyqN6LxwRlqIdwt25p4CtrODyuw5KNgmR5nTqzse5SB
         Q3sxDajgw6xcg==
From:   Will Deacon <will@kernel.org>
To:     Martin Radev <martin.b.radev@gmail.com>, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, alexandru.elisei@arm.com
Subject: Re: [PATCH v3 kvmtool 0/6] Fix few small issues in virtio code
Date:   Fri, 20 May 2022 21:51:08 +0100
Message-Id: <165307807003.1660192.8414115538147562065.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 May 2022 23:39:34 +0300, Martin Radev wrote:
> Thank you for the patience and for the reviews.
> 
> Here is the patchset with all of the changes.
> 
> Kind regards,
> Martin
> 
> [...]

Applied to kvmtool (master), thanks!

[1/7] kvmtool: Add WARN_ONCE macro
      https://git.kernel.org/will/kvmtool/c/143ffa2221d3
[2/7] mmio: Sanitize addr and len
      https://git.kernel.org/will/kvmtool/c/52d4ee7cb520
[3/7] virtio: Use u32 instead of int in pci_data_in/out
      https://git.kernel.org/will/kvmtool/c/06e1e6fe2e11
[4/7] virtio/9p: Fix virtio_9p_config allocation size
      https://git.kernel.org/will/kvmtool/c/3510a7f7b45f
[5/7] virtio: Sanitize config accesses
      https://git.kernel.org/will/kvmtool/c/e47302846cc5
[6/7] virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
      https://git.kernel.org/will/kvmtool/c/31e0eacca520
[7/7] kvmtool: Have stack be not executable on x86
      https://git.kernel.org/will/kvmtool/c/a68a52cd8ab7

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
