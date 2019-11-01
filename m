Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0608EC747
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfKARKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbfKARKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:10:06 -0400
Subject: Re: [GIT PULL] KVM patches for Linux 5.4-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572628205;
        bh=X+Cew2hq/ZN5wUIiN3m/lsnmILD3307MY6hSlGmW6m4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1AQCgVCSWk98TCs0nqC23MJxz2fb8IDuti2K8UDsyj9bPvMgQKaOdEpE3Eaxnyys9
         zNXavKPVjhT8OyJnIS95eOOlmKW5+kx7sz+EQmOzNzr83+C6qOegowuQ2/qqjLOKio
         JNqeb+jaW5T4iIYXmK5yadi5BcldiQIgiBqSHeX4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191031225347.26587-1-pbonzini@redhat.com>
References: <20191031225347.26587-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191031225347.26587-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 9167ab79936206118cc60e47dcb926c3489f3bd5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b88866b60d98f2fe1f66f2a4e1a181d9f2b36b5d
Message-Id: <157262820591.11375.16865235101517885078.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Nov 2019 17:10:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@kernel.org, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 31 Oct 2019 23:53:47 +0100:

> git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b88866b60d98f2fe1f66f2a4e1a181d9f2b36b5d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
