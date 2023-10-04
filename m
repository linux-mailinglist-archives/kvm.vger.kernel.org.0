Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480367B78BC
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 09:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbjJDHa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 03:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241479AbjJDHa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 03:30:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E556AA7;
        Wed,  4 Oct 2023 00:30:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D900C433C8;
        Wed,  4 Oct 2023 07:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696404624;
        bh=p4yLinEjIJBrFuw8sXLaLQnAZFkhWiUPbGiv8DnPTD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qLrfTSxxcorg5t4dgwYQ9KAYYXZ1iL19zW+mWGa9Y6BVy2W0gsBct/LFcyWaD/XuC
         SbTdMVqE9Gcs8b8dbJ5TCuf4bBDkhmNZ8l6ShyFnf/9utRnuo/GPUdzJoVTTT7QsNg
         p60f6U/92iIBJeL3iVcB/iUjjFYfi5gs5QlSd/PLiBiKPQ4F4nF+GHGk6FnGfFDSJv
         +/6bFrGSieIFs8rlp+hFIcGCQAjD4YItalzzDLPaFfS1XR1Uzhf3eQerpdRRjv71hY
         3E6/hp2BgX59AL0LJ7uoXGPEd4Ovw3M9gIwXR1lC8gqpaUf4B8ECh5BeDFDOhi8/i+
         UJCtjNVUiGbEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CCFCC595D0;
        Wed,  4 Oct 2023 07:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vringh: don't use vringh_kiov_advance() in vringh_iov_xfer()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169640462443.26245.17654721515803300599.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Oct 2023 07:30:24 +0000
References: <20230925103057.104541-1-sgarzare@redhat.com>
In-Reply-To: <20230925103057.104541-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Sep 2023 12:30:57 +0200 you wrote:
> In the while loop of vringh_iov_xfer(), `partlen` could be 0 if one of
> the `iov` has 0 lenght.
> In this case, we should skip the iov and go to the next one.
> But calling vringh_kiov_advance() with 0 lenght does not cause the
> advancement, since it returns immediately if asked to advance by 0 bytes.
> 
> Let's restore the code that was there before commit b8c06ad4d67d
> ("vringh: implement vringh_kiov_advance()"), avoiding using
> vringh_kiov_advance().
> 
> [...]

Here is the summary with links:
  - vringh: don't use vringh_kiov_advance() in vringh_iov_xfer()
    https://git.kernel.org/netdev/net/c/7aed44babc7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


