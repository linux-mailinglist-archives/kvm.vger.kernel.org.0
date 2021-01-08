Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D002EFBD7
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 00:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbhAHXtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 18:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbhAHXto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 18:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D87B23A9B;
        Fri,  8 Jan 2021 23:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610149743;
        bh=BBgpMZt1TLqVaT1JH4+pvytqjDxH8kaUow4RNXlUHWI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cZNt04dEO86kE5zqUVPnz5pB4CFAKKU9oevc/u9PNhqUy4Gk6H+N1OjjW9zr6eXjW
         iW+oi0Ki1fXgQgQhENhFSTLWjlz3tDdlU38kQP0W7VwdZkeycRO6e/Qm7h0tPG1ueM
         SI78eEQ1rd6OhHinwU1ZpoCp4oUoMNiLf5Wb55FWrtieOW1A9yFS3OkZKo+3lTuxFb
         DBw/uvzvDUK/F+pkIPKrGq7ReTpzWoQRQj+yaloajsXxv1QibukEK1GhoewtU6qeyI
         XTyrPyc6H9n8Iefb3vMKq5EMVVvQXaCaFzRWz3E6h17Z34nStYiDLZutvAnTLTAr3m
         1qo1u4HbrW7tw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 893B960157;
        Fri,  8 Jan 2021 23:49:03 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.11-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210108162849.49465-1-pbonzini@redhat.com>
References: <20210108162849.49465-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210108162849.49465-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 872f36eb0b0f4f0e3a81ea1e51a6bdf58ccfdc6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a190b22aa1149cda804527aa603db45f75439c3
Message-Id: <161014974355.3246.12663082759589384162.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Jan 2021 23:49:03 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  8 Jan 2021 11:28:49 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a190b22aa1149cda804527aa603db45f75439c3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
