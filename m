Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E618C33A7BC
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 21:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhCNUB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 16:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhCNUBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 16:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9433664EB7;
        Sun, 14 Mar 2021 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615752104;
        bh=Pd8wrCDrlQ26BWd8g7FFAh5or0qZru131GmxCsF6dDw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TH7jqp3owpEidvrfZwHPQxi0VgdioziKOKiJWXT0OcdYyRQ1tT8d9HVoxKDhdpclT
         5B/j66qJpE89UXD97QTZ7+2bPHGiAQ0ILebIVkF8okZ5Ja+doGdKVyYvfTkRBt/O8K
         o6LN6X8QZuap3UF+hzBNag8Kr/ah6dd0Dpl/u313+2UqjhgZDWZTMOG3/e1euXBJSt
         nRBEQ2Mt+mmbBF3imTY4AtS1UXyGN03D9Fd897rfXYi02xZs5nrnxyeYv+7iMNXsOx
         s+YzU3kq639nG8ezPSSETMwIuDyGLIGIKY+gs4IzGVSlQZjl47ZitaY0N3r3W6CllH
         kymUWWBrzc/SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8FF3960A45;
        Sun, 14 Mar 2021 20:01:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.12-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210314083811.1431665-1-pbonzini@redhat.com>
References: <20210314083811.1431665-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210314083811.1431665-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 35737d2db2f4567106c90060ad110b27cb354fa4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d0c8e793f0eb0613efe81d2cdca8c2efa0ad33c
Message-Id: <161575210458.6248.14358119361012020657.pr-tracker-bot@kernel.org>
Date:   Sun, 14 Mar 2021 20:01:44 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 14 Mar 2021 04:38:11 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d0c8e793f0eb0613efe81d2cdca8c2efa0ad33c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
