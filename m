Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5748D68AC2A
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 20:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjBDTzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 14:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjBDTzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 14:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E112686E;
        Sat,  4 Feb 2023 11:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8779B80B65;
        Sat,  4 Feb 2023 19:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54A3CC433D2;
        Sat,  4 Feb 2023 19:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675540508;
        bh=rqwNfCUnO6uOfxDfd4GI+CPUL2JXvfCw0EL8cjEO1X4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gimdVk3wKXa6nUTZMQ8IRvpnfooubD1E4jmSj0q8bCKWp3RT3TvfvqVHBz3uvkKND
         b/Y7/9AGPCqojaIsZPq+ld3tEDHNPbYgZNfZmTuQSiSqCe542bsq1NuKbWlI4pTDN0
         ExqquoM8UlqT/gxGa8yAnAPlQO3kcrgDbP33fiI3mSGRrrYfqHisZRJ8Khy53QPABX
         AKXnxk9+cC8khbTK2tJNSmpVeL1c8MuIZM8lP98AZhpXQZCE2fa1MH1eyT7dgnQG6z
         LDw9hOrU69yvbQhGOO5UZHVLkZSeBEHtbu8fol1yBNINmG6MixSsrCdex2bTU1rKzk
         uJh74QlLM2qPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 425CAC0C40E;
        Sat,  4 Feb 2023 19:55:08 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.2-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230204141405.875815-1-pbonzini@redhat.com>
References: <20230204141405.875815-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230204141405.875815-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 25b72cf7da9f0d66eef3979187ddfda98d4efcd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c00f4ddde0943cf54499bc380ffca6376af2d945
Message-Id: <167554050826.7014.18053454050940455118.pr-tracker-bot@kernel.org>
Date:   Sat, 04 Feb 2023 19:55:08 +0000
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

The pull request you sent on Sat,  4 Feb 2023 09:14:05 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c00f4ddde0943cf54499bc380ffca6376af2d945

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
