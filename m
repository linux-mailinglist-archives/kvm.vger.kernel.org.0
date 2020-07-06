Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9D216108
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGFVpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 17:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFVpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 17:45:05 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594071905;
        bh=I6s7SLLl9CrLJQTqhiYP2IySylUhXABE1lP+3FhcVyU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=aEohjcJZOOeeAAUAUMpHHvVwiA3rhH5HefLo6IyHiysVxRn34dpk9XLE4cTbrgOza
         CusaF/BW4B21jdKO3S6+TgLL1Wf/nLbF4aJ704fF+lExhlIdoF35N1LVQy7dDjmKbb
         SYpLDwv0tv8nEAkORjYSqxu7i8TWld8EE962TWFQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200706171523.12441-1-pbonzini@redhat.com>
References: <20200706171523.12441-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200706171523.12441-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 8038a922cf9af5266eaff29ce996a0d1b788fc0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bfe91da29bfad9941d5d703d45e29f0812a20724
Message-Id: <159407190556.6756.3773283832084647870.pr-tracker-bot@kernel.org>
Date:   Mon, 06 Jul 2020 21:45:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon,  6 Jul 2020 13:15:23 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bfe91da29bfad9941d5d703d45e29f0812a20724

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
