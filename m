Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739921135A7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfLDTZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbfLDTZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:25:25 -0500
Subject: Re: [GIT PULL] Second batch of KVM changes for 5.5 merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575487524;
        bh=Bl0XAG6YKNxcSUTwIztkWslGYq/SShSJKu/LEM/SAko=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1MuPsQqsBXwpLVj8iSdfiTJQqoOKCDx7YPHV9ZBNZlUp49Htu0Vl2okocr7LJ/NWp
         c7Kfn8WMP5mkzmWStMl4DgsIg4HpBBcNctNpoayPepf6yc7wCsBTkvgAXeyYxUqY/l
         15joDiCZ2KxuQsn7QIAzFUs3Od7jqizMDx3OnABU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1575460467-29531-1-git-send-email-pbonzini@redhat.com>
References: <1575460467-29531-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1575460467-29531-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 7d73710d9ca2564f29d291d0b3badc09efdf25e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aedc0650f9135f3b92b39cbed1a8fe98d8088825
Message-Id: <157548752478.30814.10501502507850281561.pr-tracker-bot@kernel.org>
Date:   Wed, 04 Dec 2019 19:25:24 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@kernel.org, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  4 Dec 2019 12:54:27 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aedc0650f9135f3b92b39cbed1a8fe98d8088825

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
