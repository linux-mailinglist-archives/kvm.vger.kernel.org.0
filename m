Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F114A32472
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfFBRZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 13:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfFBRZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 13:25:15 -0400
Subject: Re: [GIT PULL] KVM fixes for 5.2-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559496314;
        bh=TfLxWpOC4SbTif7Gsn4xrF0ocHhDsjWMGlOTKoLN1lc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jtlJlsakSJYX9uj2Oy+0tv6IkDt2Tx5c5zRgVRVvWmFuJ6eLxnf7SJ1aFy4wTXvjw
         HiwaZEYuaMlw6Tr7ofB3fKeEy6EFuParAVTgUI6O6K1ojmWwiktYoiVew9jDdaTbk3
         8y3CjuSP+D+54oaqdvV0tKlmAS5HVa/wB58Sf8OY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1559469039-42045-1-git-send-email-pbonzini@redhat.com>
References: <1559469039-42045-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1559469039-42045-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: f8d221d2e0e1572d0d60174c118e3554d1aa79fa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b44a1dd3f648a433c525efcdd6ba95ad89d50e27
Message-Id: <155949631467.24242.16308911266332915750.pr-tracker-bot@kernel.org>
Date:   Sun, 02 Jun 2019 17:25:14 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  2 Jun 2019 11:50:39 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b44a1dd3f648a433c525efcdd6ba95ad89d50e27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
