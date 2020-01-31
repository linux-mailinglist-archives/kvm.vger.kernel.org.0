Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5D14F2CF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 20:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgAaTfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 14:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgAaTfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 14:35:14 -0500
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580499313;
        bh=n+1puxnQdfiMf2Hc14tv+8FmaI+04z0Yv1atq3Ckd9o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jLn/UizCq8hpTv9DNPcef2FpfKVu0wX1ZNqVAnoW/8BdX2stcUK+Q4JRoHH+Qj6KN
         Ie7GmTI9bsg6T1Z3uFe9tLxX30G15phg/sNyM/+tpkmgeBBhWDvZaZ0mebAEXizjiS
         skMTcNxshNfurG8/tdl4eyyp9UYgM3K5xlqtPBXQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/kvm-5.6-1
X-PR-Tracked-Commit-Id: 4cbc418a44d5067133271bb6eeac2382f2bf94f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e813e65038389b66d2f8dd87588694caf8dc2923
Message-Id: <158049931382.14867.15030052529297301776.pr-tracker-bot@kernel.org>
Date:   Fri, 31 Jan 2020 19:35:13 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 30 Jan 2020 19:20:42 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-5.6-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e813e65038389b66d2f8dd87588694caf8dc2923

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
