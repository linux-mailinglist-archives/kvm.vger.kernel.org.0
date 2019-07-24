Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712A2734A4
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 19:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfGXRKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 13:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbfGXRKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 13:10:20 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.3-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563988220;
        bh=xAhl0C0csUV8JTXFW2xkr4vyIY3HtsxxZk+pzzR9NyM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1+NlSG6k/RJZ8sVwO+m8XK8z02aYybIA8kDaxUmz84SOcgkADpJVN6lCpPmnecZkw
         CMSM3YzdU15eYmGSJA2H3jowPy+0GP4l9mjPACliROPhkWfw6iZz6OkWQrA4nP5EC2
         K3gAiQC1RmfcLUG83GUDE7JPt6WEAAaP4UTUhMOU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1563970561-44925-1-git-send-email-pbonzini@redhat.com>
References: <1563970561-44925-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1563970561-44925-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 266e85a5ec9100dcd9ae03601453bbc96fefee5d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 76260774575c0ff7464bf5a4beabc9852180799f
Message-Id: <156398822001.2764.12907694831246058752.pr-tracker-bot@kernel.org>
Date:   Wed, 24 Jul 2019 17:10:20 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 24 Jul 2019 14:16:01 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/76260774575c0ff7464bf5a4beabc9852180799f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
