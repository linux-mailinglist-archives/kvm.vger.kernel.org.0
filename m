Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A9D13678
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 02:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfEDAKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 20:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfEDAKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 20:10:03 -0400
Subject: Re: [GIT PULL] KVM fixes for 5.1-rc8 or final
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556928602;
        bh=nsZC0USU0psqXiLgGlN+iWonkITiOE1mFKRnJulUJaY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=kD30eDf/18ex/fkL1b2c+zwAazR0GDfR4wL3CNG3rM/IqUyI5PoxBcBIkBHPNNZKh
         ts6E7lHd2+H1QRrr8B0CtVtssl1QPInDmEaS78iRaqKVnKuVoecmCb01b5DvSzu2do
         tvzGLMDrfRpRHeIZKa/giw71rgRO51q2QFl+bI48=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190503214614.21250-1-pbonzini@redhat.com>
References: <20190503214614.21250-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190503214614.21250-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: e8ab8d24b488632d07ce5ddb261f1d454114415b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa1be08f52585fe36ecfaf5bddfdc784eb4c94cf
Message-Id: <155692860261.31859.12161279767404451309.pr-tracker-bot@kernel.org>
Date:   Sat, 04 May 2019 00:10:02 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@kernel.org, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  3 May 2019 15:46:14 -0600:

> git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa1be08f52585fe36ecfaf5bddfdc784eb4c94cf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
