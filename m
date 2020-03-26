Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE2A194BD7
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 23:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCZWzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 18:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZWzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 18:55:08 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.6 final (or -rc8)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585263307;
        bh=jMl3BK0o/qDJ0LsnNsZVyWi7jHq5tYHljO8r3BkfhIk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PyFwN5umv0u5eqpI9H6ByVHzvHGYTCJ42r/xjas2FPJpVhfD9uTiWoWg+Ard0mr2E
         ooJlosi05Y916RDJRDBwy+exeHnH6sYQ25zmlw9dzVPPvNe0Z79B+iAqfc2QMeHovh
         yM2/WozBkrGpQlNkG24Dce/Z8vZgyWFVsMTuYEsQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200326200311.28222-1-pbonzini@redhat.com>
References: <20200326200311.28222-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200326200311.28222-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: e1be9ac8e6014a9b0a216aebae7250f9863e9fc3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a53071bd340171d258ddaf3f3c951708044ff455
Message-Id: <158526330750.848.3907726372153034381.pr-tracker-bot@kernel.org>
Date:   Thu, 26 Mar 2020 22:55:07 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 26 Mar 2020 16:03:11 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a53071bd340171d258ddaf3f3c951708044ff455

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
