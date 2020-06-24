Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE65207A4A
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405562AbgFXRaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 13:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405427AbgFXRaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 13:30:18 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.8-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593019818;
        bh=oxPIjg4Y7WtOZI+S9vhkTY+465B5ALE8m4DMhounppY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ySQXhDLqBjhg+F8lAocq3TViw/g7mrEkkHRRyl1ZFze65Df7fZSWpfRU+UpGXl3xP
         AtSsK15e2AzHgYtBo+fB+ZAWjMW47nygKSPDoAMC1jpWguQwXUlnGhXuWvly4ZoJiG
         nwj8VieFuXzhWhHIl2KQIia1vQ3dBm9ESRPw3JGo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200623171117.326222-1-pbonzini@redhat.com>
References: <20200623171117.326222-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200623171117.326222-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: e4553b4976d1178c13da295cb5c7b21f55baf8f9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 26e122e97a3d0390ebec389347f64f3730fdf48f
Message-Id: <159301981836.18191.11209681669909428701.pr-tracker-bot@kernel.org>
Date:   Wed, 24 Jun 2020 17:30:18 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 23 Jun 2020 13:11:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/26e122e97a3d0390ebec389347f64f3730fdf48f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
