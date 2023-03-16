Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B576BD843
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 19:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCPSi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjCPSiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 14:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE5B8628;
        Thu, 16 Mar 2023 11:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F297620D5;
        Thu, 16 Mar 2023 18:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09ED0C4339C;
        Thu, 16 Mar 2023 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678991925;
        bh=sLStqHtyJir3k2H7/tIph4L5QHtAI6FBSqOvvSGvH4Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Y2WgQLdLpIE1Y2eeT4GWo3tIzck4ifepxRfLFRu/G011zOPByJ903/IN5OGwKlkp8
         paWZX75muwVvh1ymTBtqnlCoARI70v93zMjyHMWdOTdw4OmsAAs4izLmNbmm2Ymh3d
         SN++Gqqwkv85tf8JnWXvgNyppzGMCiH74Mami1lgRB2PxLp01xoQ7dRnJNRQIRaDUv
         1JRc0ab3lIarMvYCvlZ8NxQYuSrfVS4xbt+UGTp5WjESmJrEU/63hSkH+S8Jzk/zqI
         A66hsLR0GX7jn/BgNr5P03nZrlDJzmR+4rpx7oDGAhMW6xgnjzTd7KrBfWL3B7LnLo
         eYlIXBEQJsGEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7EFEE66CBB;
        Thu, 16 Mar 2023 18:38:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230316140543.3253564-1-pbonzini@redhat.com>
References: <20230316140543.3253564-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230316140543.3253564-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f3e707413dbe3920a972d0c2b51175180e7de36b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ddc84d2dd43e2c2c3f634baa05ea10abd31197e
Message-Id: <167899192493.26804.5062627150123186031.pr-tracker-bot@kernel.org>
Date:   Thu, 16 Mar 2023 18:38:44 +0000
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

The pull request you sent on Thu, 16 Mar 2023 10:05:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ddc84d2dd43e2c2c3f634baa05ea10abd31197e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
