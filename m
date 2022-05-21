Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1554252F951
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 08:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354694AbiEUGjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 02:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiEUGjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 02:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD97015BACD;
        Fri, 20 May 2022 23:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D84B82E24;
        Sat, 21 May 2022 06:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35F49C385A5;
        Sat, 21 May 2022 06:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653115176;
        bh=PjWUq/sQpVQrE1XAvuSdBstJvgO5z0YsLAH65wCmyys=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uldLrNAt9it/xVFPCKRm2kHO5X7lvchfiW1efnYGaV1rJLRBS9VWBabDg4JUshBnc
         Scoe6YDGa+3rJQZJS4wIn/+rE8CJcWegbImTAM2PqauxsJ8b0Z4uB+5T+lhLWpQc2J
         XfSl/2VegBEFf7WmeAxJCShF0LTyHi+xAL8BZG/Fh3MDT91KYe+PtPF/Se/urDM1S2
         L0JvVq/O2yG52PS+e6KH6g78DaSKdYnCjVerEiATFo1MYUpUxwBtCqV22FTvrwAJDN
         SBy6+urojPf+emgH+MIsL0TsEamEyCZOIXTQynKjgNh0ir/lxeWAykZw2178821a3n
         zaAsKZFrKyf2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22643F0383D;
        Sat, 21 May 2022 06:39:36 +0000 (UTC)
Subject: Re: [GIT PULL] Final batch of KVM fixes for 5.18
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220521063133.70137-1-pbonzini@redhat.com>
References: <20220521063133.70137-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220521063133.70137-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9f46c187e2e680ecd9de7983e4d081c3391acc76
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c3f5bec9b40b9437410abb08eccd5cdd1598a3c
Message-Id: <165311517612.31073.1215130008475593144.pr-tracker-bot@kernel.org>
Date:   Sat, 21 May 2022 06:39:36 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 21 May 2022 02:31:33 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c3f5bec9b40b9437410abb08eccd5cdd1598a3c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
