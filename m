Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434601606AA
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBPVKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 16:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgBPVKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 16:10:19 -0500
Subject: Re: [GIT PULL v2] KVM changes for Linux 5.6-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887418;
        bh=U68SFLI72USa7BtGHEfcQZ6q/QO/ejuG19BXxmni6Ro=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BEXPLgo0b421cSQu0g0zuwYqU4HN2tc1/wc0cLEDWEG5ad/V0G1LAGtECC6+ljeXa
         /UlIWuFnJyTXd7tB8WXeKthN7D4nEiOYOpFKxKOr+eUVZD5+qPlwRIi3ua01xTYO6T
         9/ejUqhokFpRaUNWZi+N4oxkqXwPWhr9vx5xW55k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1581630529-5236-1-git-send-email-pbonzini@redhat.com>
References: <1581630529-5236-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1581630529-5236-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 120881b9e888689cbdb90a1dd1689684d8bc95f3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44024adb4aabefd275c6f9c00cac323473447dd5
Message-Id: <158188741880.12275.3916382760765840120.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Feb 2020 21:10:18 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 13 Feb 2020 22:48:49 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44024adb4aabefd275c6f9c00cac323473447dd5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
