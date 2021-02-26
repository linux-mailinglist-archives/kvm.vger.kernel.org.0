Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3E3266F0
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 19:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBZSdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 13:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhBZScy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 13:32:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C07C64F29;
        Fri, 26 Feb 2021 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614364333;
        bh=iIagenv9uDS3xtZUSMnd0XikBNbOrQ7Ke0HNEtwi09Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UGV1qshRdkfyW11PSIVge4S6luTOzquzGTH6P+Jic5pIh4RKxjVQC+nEDlKJ5mBoI
         VIY37x3jHMThHSqUKIYmipFrAP6RlRR/J3Gx5QYfFBoWA2hVwtUJET0G9KaEJThEzY
         /lOlW8lnDPWoimjFNNTi9xDkmHYqms/FaIgMLnzot54rGgg0xW05NU/6WBCtwoshJ4
         7pzE99mqj89344wErsWwWbEVrUjZHZH6omJ8KjjIT7ltYCSnWOdPsBdiSZBbR3d3T0
         /g1IK8cszDFb0VoJmTW/xJiBfu4d0zqbGpVfW7wwh0o3IvM5NwIBIEl8d/kNCzI65S
         QFBNQrX3hqtBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8867B60A0E;
        Fri, 26 Feb 2021 18:32:13 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.12
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210225205912.61184-1-pbonzini@redhat.com>
References: <20210225205912.61184-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210225205912.61184-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2df8d3807ce7f75bb975f1aeae8fc6757527c62d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d94d14008efed91a6de5de03627e0cdadb32c588
Message-Id: <161436433355.9780.17262421068810370908.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Feb 2021 18:32:13 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 25 Feb 2021 15:59:12 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d94d14008efed91a6de5de03627e0cdadb32c588

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
