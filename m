Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A47B310FB8
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhBEQde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhBEQbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:31:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CAE5A64E4F;
        Fri,  5 Feb 2021 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612548782;
        bh=d/fhpgYA4tqMSIDukgjbRU+O4N6UkDxKCfNKwJtRD20=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=q3BOR8vU7sVK54fGbS95lzy+GSH7g577XOmuTNh5xm9dQ1RlFujlHKmBNQ0J+Help
         NKqRop8cR5+vh6QDNgVWIwB0kKVDawdEB+y3tBIfbLHmO4tNvHyKw0gFjJgXKbdTo2
         nNvAU5R2IHKW+5CWdI2Hb37yswoBjeLP/8lSocoMTFnIPDLEfyah8mJJ3s1MXrDg99
         XdvrLHwpveVCdbryYF+3JmHCTCbhDyRS69JSzi5/AXlVPPVcPhiKQfCtO+TskmQ7JY
         nacbSQ9GztTAmTLjSJGudEBssgZHskUPetQK2kIL0zMmqPyKiBREOFvvv/GyguA4se
         pggVxVJ96Ph1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C585860978;
        Fri,  5 Feb 2021 18:13:02 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.11-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210205080456.30446-1-pbonzini@redhat.com>
References: <20210205080456.30446-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210205080456.30446-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 031b91a5fe6f1ce61b7617614ddde9ed61e252be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6157ce59bf318bd4ee23769c613cf5628d7f457b
Message-Id: <161254878280.14736.12215442394994778995.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Feb 2021 18:13:02 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  5 Feb 2021 03:04:56 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6157ce59bf318bd4ee23769c613cf5628d7f457b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
