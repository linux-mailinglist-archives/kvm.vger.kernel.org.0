Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190CD7D3E7D
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjJWSDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbjJWSDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:03:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CECD7A;
        Mon, 23 Oct 2023 11:03:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A741C433C9;
        Mon, 23 Oct 2023 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698084208;
        bh=XO15aQ4OaTTwsEmZcdXBiWanfxRs+POYEmcfVMrr2lw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CTid+8KpEObxYzsmWNTkSTB3TZ7cfgnFSx3Lm3oOYagfFERmHC2k5TA8M1oHTFqHc
         t/1DVjyduRj3cE8NbE/OT/v93W2Z43a3NaO8R/pvXQXN9Fxv9jha0Qm1e7qxExnAsi
         WcuKsYtWoo+9CDWPZ9RWQJk/PD34TRlAr92B4HauLNYikhQpV9EJylX/F+kVfoNWw2
         lzhaXev0drhvOOKvE2nA7SEZwcJwOOaV3R7fgd/1yqWguWdvFAo1HprWMjD1tCl0Iz
         vfE96Zi2U6jYPk5cd2/xVuiKZPlYCqchq6oieryg9XWvNnCSwCvJJsFG7BlFWCDRGe
         WL/id1mV2QNfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57A55E4CC11;
        Mon, 23 Oct 2023 18:03:28 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231023010207-mutt-send-email-mst@kernel.org>
References: <20231023010207-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231023010207-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 061b39fdfe7fd98946e67637213bcbb10a318cca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c14564010fc1d0f16ca7d39b0ff948b43344209
Message-Id: <169808420834.25326.6759202324452461756.pr-tracker-bot@kernel.org>
Date:   Mon, 23 Oct 2023 18:03:28 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, catalin.marinas@arm.com,
        dtatulea@nvidia.com, eric.auger@redhat.com, gshan@redhat.com,
        jasowang@redhat.com, liming.wu@jaguarmicro.com, mheyne@amazon.de,
        mst@redhat.com, pasic@linux.ibm.com, pizhenwei@bytedance.com,
        shawn.shao@jaguarmicro.com, xuanzhuo@linux.alibaba.com,
        zhenyzha@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 23 Oct 2023 01:02:07 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c14564010fc1d0f16ca7d39b0ff948b43344209

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
