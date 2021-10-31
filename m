Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F194444106D
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 20:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhJaT1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 15:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhJaT1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 15:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F3E3860F0F;
        Sun, 31 Oct 2021 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635708279;
        bh=B4JQ/G/C0682OSRB6eJLx1VBdxV+Zedlp5L5IKs/IPw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mpwjHNKYcGLqX6gTjgDmE03E7q6tcAIJ2PMp3GwI51WP66y0s5Q6xCogF3fp2HXif
         IUGjIWUTiDMISGnsOesBqsWu2ITDvFCJyd3vTrydsIlLYF12GBgQ5HJvV1pQB83fJ1
         e/ZpIvqiv4CGWBovXlEdaAHb2u4iRzWbFm6gu+wMvnwMvB/wSvZ5zPWbKd3C+vYrmH
         RIF9jFjGII/f4dml5QiXXEZToMzsI01gM4B9hoNCmq4hg2fc+WfDbX8i51ZjOHS/6F
         DM7DgkvQGmhQBGQl7uge1lUCfLW3vDox/RcLhuMqYRStmQg3lXyXM9AFT3EFi4rwzD
         9rTFuF8q1+rsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EDCD760A25;
        Sun, 31 Oct 2021 19:24:38 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.15 (rc8 or final)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211031063520.4090094-1-pbonzini@redhat.com>
References: <20211031063520.4090094-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211031063520.4090094-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f3d1436d4bf8ced1c9a62a045d193a65567e1fcc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca5e83eddc8bc85db5698ef702b610ee64243459
Message-Id: <163570827896.30704.10889967667019099329.pr-tracker-bot@kernel.org>
Date:   Sun, 31 Oct 2021 19:24:38 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 31 Oct 2021 02:35:20 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca5e83eddc8bc85db5698ef702b610ee64243459

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
