Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE445708F5
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 19:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiGKRex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 13:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiGKRew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 13:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD102A43F;
        Mon, 11 Jul 2022 10:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D709B810F6;
        Mon, 11 Jul 2022 17:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB464C34115;
        Mon, 11 Jul 2022 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657560889;
        bh=qAld/Lu5HMwexyE0/WL6CDfZTPrZG8hp/e2DAELTrC8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sWfX9GN7+uy96tSL4WGUWViv0ltNu2YZwOAHZ3gc6T0DxhCR0VZJFRD2h7DnVWzu6
         6TDy5QG0+M1AzOO1PGhTpNqS2jU9z089ISZqxWdEVqaeZgWhn4D7+9bApUYrinhHMk
         RDJHldXfBS9cTWw1fEXR/JbeqJPgS9uHl/jZwp8n6sW0RBrkA4jX0MxT//DQVhhcKu
         R1wbb2wLHdcSwx/eSQxEVwtGuNz5AqN5aTOHuKaTkEnhV7Am46d3AwZsQe4yqGiGV5
         WMMaQocOYltmC1iq1zDYuihyz9NrHrGkDp5kBapLjb2EYw2fMwqsnhLhOkC6dGagq0
         0TUZ7ah2ZtMdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7D8AE45222;
        Mon, 11 Jul 2022 17:34:48 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v5.19-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220711073813.3134a64f.alex.williamson@redhat.com>
References: <20220711073813.3134a64f.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220711073813.3134a64f.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v5.19-rc7
X-PR-Tracked-Commit-Id: afe4e376ac5d568367b447ca90c12858d0935b86
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 816e51dfb5ba47e4f989af656c956a8c0cc686c0
Message-Id: <165756088887.12473.817112809346882602.pr-tracker-bot@kernel.org>
Date:   Mon, 11 Jul 2022 17:34:48 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 11 Jul 2022 07:38:13 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v5.19-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/816e51dfb5ba47e4f989af656c956a8c0cc686c0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
