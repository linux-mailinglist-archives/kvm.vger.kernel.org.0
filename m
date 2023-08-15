Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AEA77C7CA
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 08:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbjHOGay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 02:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbjHOGa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 02:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1758B173B;
        Mon, 14 Aug 2023 23:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BAA261D45;
        Tue, 15 Aug 2023 06:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D254BC433C7;
        Tue, 15 Aug 2023 06:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692081025;
        bh=/r9zQqPcKHXB+/YvF7yHrkr2SnbTZmcfogf/eo9mkOw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cJxPxsG17aAMpcZSikIySt2PtxQWKUNj/mhChyqABDGEiXCKdQ07P9M/AJCnVmxGz
         5oIQIJ4dSh3j38iEIgGswQWJr9RhGgCC3R1MxSXnbMVXYiSwMk+uyBxl3QDxW/odgv
         XvktYKCquvmtwMppHmtSAs9LDVuefondZZwQVqqK5tvH9wJB3jcDgH7nirQhvtOBFU
         zGNqAXN6i0z4reLupSqs7/QN2+XEeZx8S5/Lk6CJH/NISrkM+AnfoCHWnll0BlKiQI
         xWX6BRIYgn5F0araMzIX1wc6RbQF2oJnj+6YW1fZ7945JoyzqKl/OYiZAz4lkdjgdT
         ciTwsOVVVW/aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF043E93B37;
        Tue, 15 Aug 2023 06:30:25 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230813190803-mutt-send-email-mst@kernel.org>
References: <20230813190803-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230813190803-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: f55484fd7be923b740e8e1fc304070ba53675cb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91aa6c412d7f85e48aead7b00a7d9e91f5cf5863
Message-Id: <169208102577.2851.3010271963190642664.pr-tracker-bot@kernel.org>
Date:   Tue, 15 Aug 2023 06:30:25 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allen.hubbe@amd.com, andrew@daynix.com, david@redhat.com,
        dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com,
        gal@nvidia.com, jasowang@redhat.com, leiyang@redhat.com,
        linma@zju.edu.cn, maxime.coquelin@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, rdunlap@infradead.org,
        sgarzare@redhat.com, shannon.nelson@amd.com,
        stable@vger.kernel.org, stable@vger.kernelorg, stefanha@redhat.com,
        wsa+renesas@sang-engineering.com, xieyongji@bytedance.com,
        yin31149@gmail.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 13 Aug 2023 19:08:03 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91aa6c412d7f85e48aead7b00a7d9e91f5cf5863

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
