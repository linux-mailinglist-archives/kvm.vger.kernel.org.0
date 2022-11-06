Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF661E55D
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 19:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiKFSts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 13:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKFStq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 13:49:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989BBFCDD;
        Sun,  6 Nov 2022 10:49:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EA360DB9;
        Sun,  6 Nov 2022 18:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 943AAC4347C;
        Sun,  6 Nov 2022 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667760584;
        bh=TS22UlXBZzw9lnLYXVYSy24EambyAYe9oVjaQL3V7yQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BWwZTDOcOguPkxi7cy8phCamSjxaPcNhUNyCUolclik81J5SsbTsqzVotmeK4Su3U
         XS3XyQLnCZKGVxnlsPefd541z9O0ZN7hj+YHHAYeJKiUf/8S2jljVIIcTHz4xJiSSx
         JOomvL7W4aTc5s4EZSxUMTuXUQiqun+72gS88UgCF2J9BkP/Fd1pSjkj0e1uvyfIpg
         L7zNIPDb/tqv5o5q6bs8P2piRcbj+WtZ12j1+T8GplKxCJ/1NO/czlDO8YNoQc1TM5
         /Oxr5aUg3blEIYihzDw1lZBsXBwDHPMDNKoACcjnBmDgRgXvtw9kFTD02fLgjB8PMN
         Z8FDJ37Tu8L6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C0E9E43EFF;
        Sun,  6 Nov 2022 18:49:44 +0000 (UTC)
Subject: Re: [GIT PULL] More KVM fixes for Linux 6.1-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221106084656.148797-1-pbonzini@redhat.com>
References: <20221106084656.148797-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221106084656.148797-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f4298cac2bfcced49ab308756dc8fef684f3da81
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 089d1c31224e6b266ece3ee555a3ea2c9acbe5c2
Message-Id: <166776058450.6751.10930293407617236291.pr-tracker-bot@kernel.org>
Date:   Sun, 06 Nov 2022 18:49:44 +0000
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

The pull request you sent on Sun,  6 Nov 2022 03:46:56 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/089d1c31224e6b266ece3ee555a3ea2c9acbe5c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
