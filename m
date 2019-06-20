Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5354DC70
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 23:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfFTVZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 17:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbfFTVZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 17:25:06 -0400
Subject: Re: [GIT PULL] KVM changes for 5.2-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561065905;
        bh=9EoO62JLk1jVQvtIT4L9YOC63Emf0v9KKVGZozkBpeU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bMvUIZoMRPY9RQHn0a0FnE5RQ3lTM5nwODadh6klXBkQmGJvOYFeuok9dFBOo8AS/
         h3rQV11UyY7NP5r/881qX5VkrdVLi5xLruWHtbkA2crixxldsp+xPS6zaV5X0NLuKl
         hzLyBJB5s1r0SIBXXvzmLEPVyB4Dzb8c3509DjDI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1561048719-38059-1-git-send-email-pbonzini@redhat.com>
References: <1561048719-38059-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1561048719-38059-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: b21e31b253048b7f9768ca7cc270e67765fd6ba2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b3e978337b25b042aa653652a029e3d798814c12
Message-Id: <156106590588.13749.10359742865855568161.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Jun 2019 21:25:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 20 Jun 2019 18:38:39 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b3e978337b25b042aa653652a029e3d798814c12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
