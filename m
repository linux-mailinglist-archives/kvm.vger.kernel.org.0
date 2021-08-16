Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC413EDB0D
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhHPQlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 12:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhHPQlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 12:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D36A660F58;
        Mon, 16 Aug 2021 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629132034;
        bh=sk8qGoJoZGQH5hp1xraEvcHCC3dirjN5OK63D7155cQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YutJrbv+C3erLbdNI8KUoSJyPZHbHDKr97TmPI0TgOsgglD+2+mwPrTmzOWB1hF5j
         YB0PB6I9MTdyidQp1YW2JgcAXImfHwtZ1Yh1X2Xuc0Gr9PZaeoUqJHsMv0eA8eGd7w
         WlX5xdi83IjVNcpteuMNLaGAE45hvR/BHdKVTh9Q9S8NopIqEbP6F1dTrw0K3QEaJx
         Ft0BFiT7AKjrT50bzTuQknKzLt+9iBHeiXL4McMR67W7WkxzIKmWMG5widUdaOMROu
         tqDf6QJt0xPXkHLtcAakw4MHW/HDsMegM/B10vDr4Mlqmrov7QatCnnsq5fU7wRgbD
         Gh8WVV0+5yKsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB4FF604EB;
        Mon, 16 Aug 2021 16:40:34 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.14-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210816135901.3838181-1-pbonzini@redhat.com>
References: <20210816135901.3838181-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210816135901.3838181-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 02a3715449a0edf06a37efe3862bc7732099a220
Message-Id: <162913203482.19716.11360865296215056065.pr-tracker-bot@kernel.org>
Date:   Mon, 16 Aug 2021 16:40:34 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 16 Aug 2021 09:59:01 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/02a3715449a0edf06a37efe3862bc7732099a220

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
