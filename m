Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5123E303
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 22:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHFUSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 16:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgHFUSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 16:18:22 -0400
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596745102;
        bh=zJ3eJOnJZ7ZiJQ6aX1VbeNDUBiQ3Ztg6enPxU46oNH8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OyFkDvt2CNRYJADAk3MC29J7O21quN21PooHKe7IH8W7IKj609BqwbAvVP+Jm43xj
         D7OzsHp238eGKPFALnpbpCfTOIwIbNKOxB1I1sgBvKVd8P/McoLVCp3ScSoPtKxakD
         xY216voFu6opM8Qu5Fy6olspUtJo5QQKCFJ3Hjvs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200805182606.12621-1-pbonzini@redhat.com>
References: <20200805182606.12621-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200805182606.12621-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f3633c2683545213de4a00a9b0c3fba741321fb2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 921d2597abfc05e303f08baa6ead8f9ab8a723e1
Message-Id: <159674510213.4984.18107283985942506496.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Aug 2020 20:18:22 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  5 Aug 2020 14:26:06 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/921d2597abfc05e303f08baa6ead8f9ab8a723e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
