Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DE22DF694
	for <lists+kvm@lfdr.de>; Sun, 20 Dec 2020 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgLTSxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 13:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgLTSxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Dec 2020 13:53:35 -0500
Subject: Re: [GIT PULL] KVM changes for Linux 5.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608490375;
        bh=2kq0SVXpFbbbHWfe2vPbHSgRRohRFH28EHUA6kH/ceE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=cp9ttskZwXVnBG3Y/ogCVyVL1vSLwoOZv/j/BsJt4L+Pg9wE1o+wqtgUAa5PIze3c
         51+51TOqzo/VyRvLxMZYCOXkaC82LHW61vyR9kIBBiM7c1XjujQlcmYIPJUUWBQns2
         sXlbVRc5YlS32DQvwDtyBtYWa7I2FOx1UR1qeAT4Cx19bA8/9aNZXrdc5aELpXGMlm
         MkB6dHuyTLj2RMfGIGSxvpKTkhMskm+NJazHVoQwIWGun7ABX49uNxjz8tARnIPXAj
         lrVe+gt5vKYs61MrOmmea/ZhXqsDdp942MjugtMoBD4OIooPX/XSXQEviKrdzJEU69
         jF/HuCsYf6IzA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201220091112.1772425-1-pbonzini@redhat.com>
References: <20201220091112.1772425-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201220091112.1772425-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d45f89f7437d0f2c8275b4434096164db106384d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a447b0e3151893f6d4a889956553c06d2e775c6
Message-Id: <160849037486.26331.1493261589510472196.pr-tracker-bot@kernel.org>
Date:   Sun, 20 Dec 2020 18:52:54 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 20 Dec 2020 04:11:12 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a447b0e3151893f6d4a889956553c06d2e775c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
