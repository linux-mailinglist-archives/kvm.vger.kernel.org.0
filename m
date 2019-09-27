Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1772C0C7E
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 22:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfI0UPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 16:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfI0UPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 16:15:23 -0400
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.4 merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569615323;
        bh=+Y1n6w+ORIgVXGMRpd4/AKqxjnZseYX5L7TfWT//Jcw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HSzpypSmQK6e4BpxaGAoIzB8TWH0SLqrY/IeBca9tNOBi+KyqXCzdnsmMO5QkJ/tc
         5yIlF2U/L3olIBaZDbplcsedQfzuOsoJuGJI18V3ExIy2OL3gGfwUXXJ9cI3ICFdVh
         S+KNNcTyw2bWFaS1nKq+MUnRZtiv4N7SPOO+C5Qw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1569586082-13995-1-git-send-email-pbonzini@redhat.com>
References: <1569586082-13995-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1569586082-13995-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: fd3edd4a9066f28de99a16685a586d68a9f551f8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0
Message-Id: <156961532304.31800.16518789873372168937.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Sep 2019 20:15:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 27 Sep 2019 14:08:02 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
