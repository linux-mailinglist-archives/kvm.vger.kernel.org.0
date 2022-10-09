Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485DE5F8EE8
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 23:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiJIVRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 17:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiJIVRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 17:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C28F17E18;
        Sun,  9 Oct 2022 14:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A1C1B80D9C;
        Sun,  9 Oct 2022 21:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C8F7C433C1;
        Sun,  9 Oct 2022 21:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665350236;
        bh=F+hCRegYJM3EoNi5MkVVNBez5o1o01fKIlYVdx9lS+0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PsGOXDmAOKWln4H09DuImB0b2R0pKVR1jGfaQRu5QBvlNnZ7FfTqPZ+lP9fIPmKyI
         D/aTC2VErgByKcVUzelPXB/HdIugAF8yrKsTkfoebdbwdz0gLjbX10eJoH2w+/BPZ3
         kNUl9SgbbS1jUlkUUfRGItfooYe7ds/MxTlKeO9EhkXjn8SAxMxYPFUaIxFXe+P76C
         9yZPvk0zR3P8eSYF92HJx3WiQ4a+IBzvCoA+T3hOM2bzKpHVXGTkRiZ9KWf+XTndM0
         ixD8MuU6z9NrTFVUFgWdZuX/cJNpPYpSymooIWAyLJmoqf7gp7pVXj6iLFEH2en3hp
         9jcxUYU4BIoiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DE34C73FE7;
        Sun,  9 Oct 2022 21:17:16 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220930190836.116605-1-pbonzini@redhat.com>
References: <20220930190836.116605-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220930190836.116605-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c59fb127583869350256656b7ed848c398bef879
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef688f8b8cd3eb20547a6543f03e3d8952b87769
Message-Id: <166535023624.11566.10999547709539586648.pr-tracker-bot@kernel.org>
Date:   Sun, 09 Oct 2022 21:17:16 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 30 Sep 2022 21:08:36 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef688f8b8cd3eb20547a6543f03e3d8952b87769

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
