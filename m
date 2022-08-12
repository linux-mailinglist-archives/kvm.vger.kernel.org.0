Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1764C591483
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbiHLQ7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbiHLQ7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:59:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09ACB0B2E;
        Fri, 12 Aug 2022 09:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05982CE25EA;
        Fri, 12 Aug 2022 16:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 739C2C433D6;
        Fri, 12 Aug 2022 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660323573;
        bh=1C7h1bVkMm6dYRbvjw0y2ja4h678+iE9gwTLeql9SDE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fDwhIE+VnJayakbjT4AB78O4Lsx3EcoMHbKWG4+9u3C+DlO92Fk+rcN9CavSD+nC5
         qPSB3wvmaUJfxshD/j/RuKqaCF257zAf6MvchR9PxJfvf6MT6Ag/IdT5ys9zAFm33s
         t4eWvr8MGu/VXl0YhuM55efqnKhc8vIxdFydSR3uycWD58wZ/2NnSQ9Y0lT/vQ4AR2
         v27tE4wxDIdT02L78e3dCdb3LIWwTqDr6hMXzxKDGwXzKHppN2Xmorj8mLLijjkDjl
         4uOq8Sdh7t7KQeQ5BcMhJeSHGV6OS3XCOen8KVYCWLga+BBLWpQ8HSLFr0AiNqiodd
         frTokxr8ms9gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60AFEC43141;
        Fri, 12 Aug 2022 16:59:33 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.0-rc1 (part 2)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220811153632.0ce73f72.alex.williamson@redhat.com>
References: <20220811153632.0ce73f72.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220811153632.0ce73f72.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1pt2
X-PR-Tracked-Commit-Id: 0f3e72b5c8cfa0b57dc4fc7703a0a42dbc200ba9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d16b418fac3de0d2ac854b3a9a1a59a0ebf2a0e9
Message-Id: <166032357339.14629.3020749047556821805.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Aug 2022 16:59:33 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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

The pull request you sent on Thu, 11 Aug 2022 15:36:32 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1pt2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d16b418fac3de0d2ac854b3a9a1a59a0ebf2a0e9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
