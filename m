Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC152B3787
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 19:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgKOSAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 13:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbgKOSAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 13:00:11 -0500
Subject: Re: [GIT PULL] More KVM fixes for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605463211;
        bh=waYViDpkNklLAsThlSV4fQfRyFSsKG5rixmvzsgeJYc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=v/u6gAdCKQQhz7jDZ3JwioFe4M5EP9lb+VSQWftkhf89k10uyA7XlT6tsO3JkHgMn
         eP30fuhTp23MlPUlEuoih9Cv0o0qvdIcNXh5bFsl6u8pGu/Qv5rdxu+oEfXsPGdymx
         K1WpZukUfzcoexudLmVG2EwplCeGhPj+DNkgiwXY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201115152907.1625371-1-pbonzini@redhat.com>
References: <20201115152907.1625371-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201115152907.1625371-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c887c9b9ca62c051d339b1c7b796edf2724029ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0062442ecfef0d82cd69e3e600d5006357f8d8e4
Message-Id: <160546321097.32406.10972791433529017618.pr-tracker-bot@kernel.org>
Date:   Sun, 15 Nov 2020 18:00:10 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 15 Nov 2020 10:29:07 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0062442ecfef0d82cd69e3e600d5006357f8d8e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
