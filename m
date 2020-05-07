Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C331C97EC
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgEGRfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 13:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgEGRfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 13:35:05 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.7-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588872905;
        bh=ASNy/2e1zfLpRcSs4NhltLEnFps/ycNPUpbuPsuzhbA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rUxP5+sES0IjTkkdI9Ou6Y0gCh5I1jx50D2LYCD6D4UtnqlMeEIkLYcuWtgSoGG7R
         4YxxEaVvB103ushyOzBniANJw0skI4vPYWqWuGgMnQY34bMCGJlv6C/qvXZ4pxvHN7
         6kYDZBdpvriYnCn3mIqg9Lj4Ginhl0Nxf2jNiM9M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200507115332.495930-1-pbonzini@redhat.com>
References: <20200507115332.495930-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200507115332.495930-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 2673cb6849722a4ffd74c27a9200a9ec43f64be3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c16ec94dc767a4d8c48149d646e8c835512cf8f
Message-Id: <158887290507.22656.14504039152108528383.pr-tracker-bot@kernel.org>
Date:   Thu, 07 May 2020 17:35:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  7 May 2020 07:53:32 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c16ec94dc767a4d8c48149d646e8c835512cf8f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
