Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84045154A29
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBFRUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 12:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbgBFRUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 12:20:16 -0500
Subject: Re: [GIT PULL] Second batch of KVM changes for 5.6 merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581009615;
        bh=sg5Bl2gB3Z2G9v1Z97tK3GzmZP1GB+aOvl3icI8GAPY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PD4oslKoKeu0/gcCiRjcdudqtHqd9tYA/MM3gkbEmcXzOxnNBccdjItJWIN6xrrNF
         W4e/oGE6IbSWrom1kYMftKgkn7n9wBrg9i/JutsaVqScqT197ZrJ/Y8wGxf/oohYRL
         SSMCq66CZg0WVCMovz9w2EKCZ/kVaYW8caYWyLh4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1581001831-17609-1-git-send-email-pbonzini@redhat.com>
References: <1581001831-17609-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1581001831-17609-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/kvm-5.6-2
X-PR-Tracked-Commit-Id: a8be1ad01b795bd2a13297ddbaecdb956ab0efd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 90568ecf561540fa330511e21fcd823b0c3829c6
Message-Id: <158100961570.16939.9475519437277008116.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Feb 2020 17:20:15 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  6 Feb 2020 16:10:31 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-5.6-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/90568ecf561540fa330511e21fcd823b0c3829c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
