Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6972D342950
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 01:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCTAJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 20:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCTAJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 20:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FAD761987;
        Sat, 20 Mar 2021 00:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616198961;
        bh=52Oxk7pD0F9HhMNX4sbSTYc3zbeGdV2dEoP3OKi3N1w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YehSIjmqCABWlvsDAxPm8wh60Txg000hk8PR+HQxoAgfjqwu1LYhFvD+N3nBmSDSQ
         xxfbsNBDcG8nw2B1HPq4mYQape9It7X5W2xNV2orS2qW0Sl5XOuSlAoXPNeNGEViYJ
         +bKVs1XgWWOaFJCzhI5KaTMvJeYkDUCDkkEZvLOAUZ9hAjTcDcVyZWnvyXMd/rpSUc
         unPZ/pbftcaQpJmrKBXlrVIiTyrLZXaSyzir/K2U1fOdMsn6oaW0ZshP4TGccHpOLJ
         +v22s1sT+Tzz9ehe6Wl3Ed4Ik2smKFMxYbmS2RuHrOTaFKfFnzUP6zxdQOm3CpZphl
         UgvP3ypboHahA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 279A8626EB;
        Sat, 20 Mar 2021 00:09:21 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.12-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210319202516.2235406-1-pbonzini@redhat.com>
References: <20210319202516.2235406-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210319202516.2235406-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9ce3746d64132a561bceab6421715e7c04e85074
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ecd8ee7f9c1af253738ca4321509ddee727d468d
Message-Id: <161619896115.24257.10607580677188682781.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Mar 2021 00:09:21 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 19 Mar 2021 16:25:16 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ecd8ee7f9c1af253738ca4321509ddee727d468d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
