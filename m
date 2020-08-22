Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B2924E90A
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgHVRcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Aug 2020 13:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVRcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Aug 2020 13:32:15 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.9-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117535;
        bh=8K0jUsGXkC83DrDlS2QiLNPUAJsU7P/a/bjYxNJzG5s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Bvo4VNWyvgEs3kERSEWP8hhgzFAI26YvP5JJPOrnD3ioTMDf0zidTAHmVJA3AEuRt
         wB4CqH7Ew8iEGiycv5b9JxhXi9sIlK06SlUP9X9WpHBgry1kL/6UxfyBr7I07u6mXp
         +C5twnxR6ZuGSA1yhfYt22oSK2Xhhi71esliEE8A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200822080647.722819-1-pbonzini@redhat.com>
References: <20200822080647.722819-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200822080647.722819-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: b5331379bc62611d1026173a09c73573384201d9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2d9e99622796576eb6faa236b2d1f592cc43ace
Message-Id: <159811753509.17427.9520000885402685829.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Aug 2020 17:32:15 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, maz@kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 22 Aug 2020 10:06:47 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2d9e99622796576eb6faa236b2d1f592cc43ace

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
