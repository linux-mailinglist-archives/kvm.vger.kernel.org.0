Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3D6C3DDD
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjCUWuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCUWuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1072D19C49;
        Tue, 21 Mar 2023 15:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE5261EB3;
        Tue, 21 Mar 2023 22:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0ECECC433D2;
        Tue, 21 Mar 2023 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679439010;
        bh=2b6lm32ifiFsKE1ACN9TbPLw1nGUCVWS0D8yXpRVo3I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kmscqlOdqeY+Ezmc9gRiaT+of/VOH66hzkFTQT2x+CadZimqYzaBcYphbPbMfsd6f
         1iiADvcWTwub0OT55h4gGQR/+VrwIuXeMVrdy1UrZgpdsE4dNd7Cb1xLgtnT8QCDSx
         cEmE3Ki9YlnySPKayhHhjL4fa7OZE/2ACsCWRXFRCYnrOoS74v9hhg/y1JNtInavW9
         iol8+3/CyMqIMLGZNp2csd5xB6qL/5FV3FAYtHrqaNR6QPwlc/kDeBEMDCnFov33so
         rdkkiM/HHes0wwi3SnFV92DIP4qggJdNKStOBJviE0HZLYVQjlKxWna7O6A7U3CByp
         DAi07VQKmYD/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFCB2C39563;
        Tue, 21 Mar 2023 22:50:09 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.3-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230321163547.19f15996.alex.williamson@redhat.com>
References: <20230321163547.19f15996.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230321163547.19f15996.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.3-rc4
X-PR-Tracked-Commit-Id: 4928f67bc911e46a43004251a4d7eb2259ba6077
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1effab7a3a35a837dd9d2b974a1bc4939df1ad5
Message-Id: <167943900997.3744.6674058419348479514.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Mar 2023 22:50:09 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 21 Mar 2023 16:35:47 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.3-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1effab7a3a35a837dd9d2b974a1bc4939df1ad5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
