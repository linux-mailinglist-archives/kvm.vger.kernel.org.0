Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3260E82
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 04:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfGFCfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 22:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfGFCfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 22:35:06 -0400
Subject: Re: [GIT PULL] Final KVM changes for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562380505;
        bh=gxOXfyqZ4mCJRsIHx8JOT5PxKHa87DM2FX7okPEq6Bw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=cK+WcEZvB8dx8D0DWLz+pgDxEn4NlJ85xwB4qCKo/BhwPtRYaNNhxVA9RuH2bsXdh
         oX+hRmFEeAxXAUmZNDuosOgXnrgq/+uQv8l/WBIqZmqDeiCUq0rgg+LIPibIprtF4e
         USVAbMpA0+ZRIjXIVSrhUnlbeLWd3ZRJR1/l+bSU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1562358570-30670-1-git-send-email-pbonzini@redhat.com>
References: <1562358570-30670-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1562358570-30670-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: e644fa18e2ffc8895ca30dade503ae10128573a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9fdb86c8cf9ae201d97334ecc2d1918800cac424
Message-Id: <156238050551.5324.18308686881980395353.pr-tracker-bot@kernel.org>
Date:   Sat, 06 Jul 2019 02:35:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  5 Jul 2019 22:29:30 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9fdb86c8cf9ae201d97334ecc2d1918800cac424

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
