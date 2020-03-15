Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BD518590A
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgCOCaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgCOCaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:30:07 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584239406;
        bh=tk92C7wpo0+tJ43JQEXLvNEnhUABP22VVpnH1VsRMuk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=xH9oWVXwU0Mgzc3EgzAlcYMrcqwFV6C4+wKB2a8LAnYHyfrKxwQy+QeCf7VQr+TsC
         0Lbl2GL7CpxFM4XRjsw7gnBGIKdcEDmvu2spYYBW6LveBAYbN9YXpVGtp52KxDFijS
         522GxACzEHvizVQ/cApDzJbCMVopjOjNvat5dlTA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1584212970-13453-1-git-send-email-pbonzini@redhat.com>
References: <1584212970-13453-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1584212970-13453-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 018cabb694e3923998fdc2908af5268f1d89f48f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6693075e0f46979f956fefdd51997f533b392615
Message-Id: <158423940681.21543.9577172131450678750.pr-tracker-bot@kernel.org>
Date:   Sun, 15 Mar 2020 02:30:06 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 14 Mar 2020 20:09:30 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6693075e0f46979f956fefdd51997f533b392615

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
