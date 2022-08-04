Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DAF58A360
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 00:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbiHDWqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 18:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240276AbiHDWqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 18:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F221C135;
        Thu,  4 Aug 2022 15:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F79B826E4;
        Thu,  4 Aug 2022 22:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC962C433C1;
        Thu,  4 Aug 2022 22:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659653174;
        bh=3SXjkKzMoNRBoftx3iJE0Yfgok89Adz5QnbI0LJky7I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mtjEIAMX8LYm+bRL7+wbnpxSNOw+eBkDIUVjAzDy2N/lxel6aLlFs3lfoM4/Q7sxH
         lqJKy697eAChIentN9xhgOL4lhwlFkcdpRd9zxb7F7LCxX5XM4dRT3Nq8i3BP3bxPR
         b5OOmuI++eW0qd2YXh+at3+KbBHrnTDHrqKUkOQFGVZ6jhqSfre2hfkT+ChNHZnt40
         XrDS5Su9OLOmit4DBstarT5M0n/DehJ5l6owQ5ZpsfsitsoF37rCMiSXu+3KDLPkgQ
         LnOVzhd0RGFnfDVscBhAPuG9TB56TdgZcfcBgwYjqLQN/MlUM91+lgaSjLt5pEVWlL
         Eii7wzHUUmiJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A95F4C43140;
        Thu,  4 Aug 2022 22:46:14 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.20 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220802171243.1267278-1-pbonzini@redhat.com>
References: <20220802171243.1267278-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220802171243.1267278-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 281106f938d3daaea6f8b6723a8217a2a1ef6936
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c5c3a6177fa9646884114fc7f2e970b0bc50dc9
Message-Id: <165965317468.20279.2430561946622748831.pr-tracker-bot@kernel.org>
Date:   Thu, 04 Aug 2022 22:46:14 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  2 Aug 2022 13:12:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c5c3a6177fa9646884114fc7f2e970b0bc50dc9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
