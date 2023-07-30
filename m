Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2941E76878E
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjG3Tna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjG3Tn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 15:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8716E102;
        Sun, 30 Jul 2023 12:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A80860D17;
        Sun, 30 Jul 2023 19:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FC34C433C7;
        Sun, 30 Jul 2023 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690746203;
        bh=inAbZRhVnK840T5qp8BWpTtxQxhH3eGRnSyuVYDvnko=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pA2/v9D2IuoSd2fNkVUd4q0lDmOqH/zhVtsawHD5XMWG1Miavn6XTjU1uATndPE1s
         GUaiapPSFRb31c0T3Dzsh/hnHO8oXeNcWy8kwmZ5VdMb7AJUfU1RuH4uZTF4ikB0ME
         fry0bvt2cFIh4Fz+Tc+ASkmnJHiD9PcqDx83Dsvq8feL/bNwRbAFoAd6NQ+EgIEZG+
         H8+fQre3OUAI7tD4TiYvyZ4GTk7TkzsC9hkPXK75Ssc4wiBd02yES16Px0nb4pBJsp
         XAMp7XiIXld2y2iLohEYQZjheZox7KopAtg0iCfWkTorpblHSWPudE199jVImwxIi2
         P5mwyzoZbV9lA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D82FC39562;
        Sun, 30 Jul 2023 19:43:23 +0000 (UTC)
Subject: Re: [GIT PULL] KVM x86 fixes for Linux 6.5-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230730133753.2839616-1-pbonzini@redhat.com>
References: <20230730133753.2839616-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230730133753.2839616-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 5a7591176c47cce363c1eed704241e5d1c42c5a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 98a05fe8cd5e0afe2b4c52b5013b53c44d615148
Message-Id: <169074620344.25913.15340546245275799973.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Jul 2023 19:43:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 30 Jul 2023 09:37:53 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/98a05fe8cd5e0afe2b4c52b5013b53c44d615148

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
