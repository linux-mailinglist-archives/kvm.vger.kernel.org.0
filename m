Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4C791D50
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 20:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349772AbjIDSno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 14:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbjIDSnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 14:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281DCD4;
        Mon,  4 Sep 2023 11:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAC5B80EF6;
        Mon,  4 Sep 2023 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EABEC433C8;
        Mon,  4 Sep 2023 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693853018;
        bh=P3waEknk93lpso15++IpTOfJPAM5bzNhE1bMrPIVuGA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sViUpbyqkVXlv+vATJFmoAi3Q8ukaUKgpv2qd7NPVzJxoY4IX4NRs2tk7AOq8DZUB
         PhM+6Z9G9DpU8XfimpDLGM/XloyZS+Jlu2OfFMCj/Bxy0NYwUkI7/mLQUneIZIjSau
         ARjsCnKT5mcS5iR9dbTY9iNWfvRjA8n6iWeIeU8bW/yPwqmSLh3XEVwRSDCy3KD4N6
         AXyPJadCGthdjr31o23gEAIui2CLUjppxRyIsuAiqSd/hob/HROCz5RsVurUSdOQMt
         /ghwUhXVAkUOprAJcSq5jY9wgxtZTj+DfkM9SGELhx/NMCr373nCayNJVQudDMRxXw
         ypLljV/qmmgog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BF9AC04DD9;
        Mon,  4 Sep 2023 18:43:38 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230903181338-mutt-send-email-mst@kernel.org>
References: <20230903181338-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230903181338-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e4f1b8202fb59c56a3de7642d50326923670513f
Message-Id: <169385301813.15626.4404495470670396580.pr-tracker-bot@kernel.org>
Date:   Mon, 04 Sep 2023 18:43:38 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, jasowang@redhat.com, mst@redhat.com,
        shannon.nelson@amd.com, xuanzhuo@linux.alibaba.com,
        yuanyaogoog@chromium.org, yuehaibing@huawei.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 3 Sep 2023 18:13:38 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e4f1b8202fb59c56a3de7642d50326923670513f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
