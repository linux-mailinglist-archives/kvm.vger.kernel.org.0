Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D6E403031
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347166AbhIGVXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 17:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347128AbhIGVXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 17:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAF6C610C9;
        Tue,  7 Sep 2021 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049747;
        bh=T40cB3S44WxRTkIeUq7YZ9g3ktTtPPiNAjJ+/MV2VPs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rTJ+93Dsx/+MDR4VGiwZ6JfZyocrf6FWuC9uFZhGzX7cZFzLRp88VOPXlM+eab80/
         OVmTfweZ/VM2MaOq1tDXway5ACMlEs1x0sHV4xPjPf4a6h0PSToI9Wo5501lpSjSPh
         aR2ZG0xn8rrrEedCps5k5Wk8TEwK/Ju+jxxn07dvniG6Sv5FUYsIoB4eSrjF8pHkrA
         Q3nuyrGVNmt1c+BdmNoGgCzgQcS2iweonVTKG8yS6R/YtXnfI1KOQ45peJTT0mgIhk
         qArR5ciKVO6Ds/n7b/hhS2tXacAhCxNb3bIg/lHkzmqp3Xx2L964ZENq3UpyJRfOXE
         yUsnRddwlneAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B511D609F5;
        Tue,  7 Sep 2021 21:22:27 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210907171639.574037-1-pbonzini@redhat.com>
References: <20210907171639.574037-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210907171639.574037-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 109bbba5066b42431399b40e947243f049d8dc8d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 192ad3c27a4895ee4b2fa31c5b54a932f5bb08c1
Message-Id: <163104974773.25074.8564070895508947960.pr-tracker-bot@kernel.org>
Date:   Tue, 07 Sep 2021 21:22:27 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  7 Sep 2021 13:16:39 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/192ad3c27a4895ee4b2fa31c5b54a932f5bb08c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
