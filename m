Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168281750A4
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCAWpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 17:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgCAWpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 17:45:06 -0500
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.6-rc4 (or rc5)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583102705;
        bh=mKACOZiHJVBFTfRENNFF9jSTkOILntNI6/EPmJUo+88=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zTO2YqUnyJ8ArqPH36rZAiYn3gg2Kcj9zire6GTVP+zodTe4NKFmJXwAmdlPrOWoe
         JNRl5gcAJKqWwiRhTseYiomytpc5siGPTDZ5omeugsG/b7Lo4jJ91U3RyeEDQwPMIJ
         8kViDtV2FX7DCzfZjejJ7w8dENYtfx9h7zjGz+j0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
References: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 86f7e90ce840aa1db407d3ea6e9b3a52b2ce923c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f853ed90e2e49f4f6e585f995ffb25e093fe4df6
Message-Id: <158310270580.24436.6955034502135182779.pr-tracker-bot@kernel.org>
Date:   Sun, 01 Mar 2020 22:45:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  1 Mar 2020 20:03:10 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f853ed90e2e49f4f6e585f995ffb25e093fe4df6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
