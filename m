Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D341D7ACC08
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjIXVYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjIXVYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 17:24:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E2FC;
        Sun, 24 Sep 2023 14:24:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D47B9C433C9;
        Sun, 24 Sep 2023 21:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695590657;
        bh=cIT0rYiC5Ub6oyym0KkxczfLpe4xL0GlLhKWrU52Nnk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=etemFzPpcgeQQxCsF06/CzSRjygy7hxcydCTWeu1hdFgFvuF7kc3O7Ax9BN9TAeur
         GQ9WJ6A/zSQ7DklAvrBu/QGxLFxbV2OUwu3jWUsNA8rQqvPWwhcu16CZQHhP4skuGj
         HpXA8iFlGVqt7BjTyUFQYI6Ys+9AmyaD4n+dHGAOoI2LimtpBJ6Oq9DDUe1K8Ic1+j
         W4uvJpqW2olNfqPSQySJcqhOubrYlEsPWj93TyiADdusn1qkz67HQC+drLHsWn2Xx9
         9Us1+rjZt5DrUyA6nMVtMfhUTnccW7zzPmKIG5oj1tL2wXssLcXgngJJf0fiouFKsy
         HP34N/DKtmxmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE93FE11F7C;
        Sun, 24 Sep 2023 21:24:17 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.6-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230924092700.1192123-1-pbonzini@redhat.com>
References: <20230924092700.1192123-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230924092700.1192123-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 5804c19b80bf625c6a9925317f845e497434d6d3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a511e7efc5a72173f64d191f01cda236d54e27a
Message-Id: <169559065777.13804.9785573496678153177.pr-tracker-bot@kernel.org>
Date:   Sun, 24 Sep 2023 21:24:17 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 24 Sep 2023 05:27:00 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a511e7efc5a72173f64d191f01cda236d54e27a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
