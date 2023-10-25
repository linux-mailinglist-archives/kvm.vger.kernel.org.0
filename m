Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770F7D7850
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjJYXA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYXA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 19:00:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DCF115;
        Wed, 25 Oct 2023 16:00:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E6E3C433C9;
        Wed, 25 Oct 2023 23:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698274824;
        bh=lz/tUZjBIuMxHa3VAr+OhFncTZRRuJ5ijaaZ4mQGKik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XA9mY78tNXJXAaxj4hgavf9QbP3BxWiucr9/4byNI9dcNU8rvR3zRBe/vjCoTJopg
         tZqtVsJAahhweokb53HijyNHBArB07P3gj4H+aDZ4w1anmTS7M2aqjLxciDqgKDv79
         GE7q8T53IO+HDQuzq3TA8A/mJatsSSVcg21SdOtHx1nqLBBr3G+/KFC3TvJ32/UVuk
         /8x/tH3EPKxU5gTfr/THzN81oAXe16XS8NuqX53AG/KkjS5Y6oETQnkYMgKforf/Dy
         XPPQ8jUCQwuZH/KnQ7EBmcH5uVYqJQrJB2ux2kGEzDuA+4go7CRjxiOV9/Nfue3Fp7
         EXbdFdIddnKtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 509CEC00446;
        Wed, 25 Oct 2023 23:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] vsock/virtio: initialize the_virtio_vsock before using VQs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169827482432.1442.13189880459066041057.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Oct 2023 23:00:24 +0000
References: <20231024191742.14259-1-alexandru.matei@uipath.com>
In-Reply-To: <20231024191742.14259-1-alexandru.matei@uipath.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mihai.petrisor@uipath.com, viorel.canja@uipath.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Oct 2023 22:17:42 +0300 you wrote:
> Once VQs are filled with empty buffers and we kick the host, it can send
> connection requests. If the_virtio_vsock is not initialized before,
> replies are silently dropped and do not reach the host.
> 
> virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
> set, but they won't be processed until vsock->tx_run is set to true. We
> queue vsock->send_pkt_work when initialization finishes to send those
> packets queued earlier.
> 
> [...]

Here is the summary with links:
  - [v4] vsock/virtio: initialize the_virtio_vsock before using VQs
    https://git.kernel.org/netdev/net/c/53b08c498515

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


