Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECA76A2B9B
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 20:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBYT6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 14:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjBYT6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 14:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ACD4C27;
        Sat, 25 Feb 2023 11:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0A2FB80B25;
        Sat, 25 Feb 2023 19:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 513D7C4339B;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677355091;
        bh=xfRZa2eV4B230MeS3PtExLBxB+21HccSzMaWS+4NGTY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nUpVaw8hYwmvT42mG4y8F0jdTcGUUVtwkK+ePqHKEwXxjG/kjkXe23/n/PKXwAwvc
         Pu/RrVmnnZmG+TfaqRiN2vwkcxmW1OBTMlsGQtyROhtG+uqDewBmkMagZalrj/Ep8W
         inBmYfRy36OXfq4h4SKT0eJA4189M6q6d/Fl2pl3R0pWF7jqEU5MzkclQV1EskFItL
         sobU9Sa3U1FyNnTONlEFBPdoDRmtwJ21INoXjyzDEz7H893iJ41afzhbfeWLRlNj64
         XcrMAun7p4bDFNYeaYjVT4O4yP739vFqI90W9Oa4pkpmAbGfaYVTcs3rHCw+e+At6n
         Ih3eE7nYdHBwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 396E4E68D34;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.3 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230224081105.2106665-1-pbonzini@redhat.com>
References: <20230224081105.2106665-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230224081105.2106665-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 49d575926890e6ada930bf6f06d62b2fde8fce95
Message-Id: <167735509123.12970.18091196941050254748.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Feb 2023 19:58:11 +0000
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

The pull request you sent on Fri, 24 Feb 2023 03:11:05 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/49d575926890e6ada930bf6f06d62b2fde8fce95

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
