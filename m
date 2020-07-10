Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF7F21BBA1
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGJQzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgGJQzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:55:05 -0400
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594400105;
        bh=nowGvXNA3DjOHHb09qf1pz/Mu96aKprdOOoau4Dv8+s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vO0Xbk//ewD00d19ni9JxxE8bHR4GVydUooXgt96D5k3FPMv8Jf0N/KcXtdB8DkAZ
         WJDEugHPvH/HT6bzQonv8xXIVoFv6hzwx6N8L6T7l9W1DV4K70pOxj2uah0iVQrYSF
         /ke3cgxamgtLrjUSYwofVWPzKRH0hEcViIXsppyw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200710130659.10507-1-pbonzini@redhat.com>
References: <20200710130659.10507-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200710130659.10507-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 3d9fdc252b52023260de1d12399cb3157ed28c07
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb24c61b53c3f47d4ba596fe37076202f7189676
Message-Id: <159440010506.18761.14423608163514612269.pr-tracker-bot@kernel.org>
Date:   Fri, 10 Jul 2020 16:55:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 10 Jul 2020 09:06:59 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb24c61b53c3f47d4ba596fe37076202f7189676

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
