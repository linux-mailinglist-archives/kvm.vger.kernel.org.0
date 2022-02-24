Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459B04C38E6
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 23:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiBXWlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 17:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiBXWlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 17:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EEE20C1B6;
        Thu, 24 Feb 2022 14:41:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C68AA61B48;
        Thu, 24 Feb 2022 22:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98D1BC340F4;
        Thu, 24 Feb 2022 22:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645742480;
        bh=EoJD4A54UC1BEv33pTg+hb7XnzOqDewO3QajY/x6iPM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZL3uixyJTZ7O0Je5PqnsXl0o0BMgOyO2vHboVA4y4jkgy2xMnANqLRXdexkAQdi2l
         ZNtR0YFlEufAAmjoObaFC2/cD/VgYUxD64YXliq5TZiM9vz0Fe5WAjoQrfUimlNLCB
         sbam9VM08plFS0IYB5w1OBqLzBTKuxPnlqLvkzotcR40nb+h9EbPn9nSpqtCKObnU0
         7cLxUG27a2/BbqLoxtHhsA+quQoIgvM+i4MgJn78x+eJHTdQNfDZGI3ednF913SCF7
         c1KsTwpaePTROCX1hD9Yjz748y0SXUxMPX4DVtv9kVQgbuWJ+DLdQ14N+OzutfAQo5
         v44enBWS9sSAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83109E6D453;
        Thu, 24 Feb 2022 22:41:20 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.17-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220224200833.2287352-1-pbonzini@redhat.com>
References: <20220224200833.2287352-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220224200833.2287352-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e910a53fb4f20aa012e46371ffb4c32c8da259b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f840c0ef44b7304d6a58499e0e5668084c0864d
Message-Id: <164574248053.13100.8169995214464494614.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Feb 2022 22:41:20 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 24 Feb 2022 15:08:33 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f840c0ef44b7304d6a58499e0e5668084c0864d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
