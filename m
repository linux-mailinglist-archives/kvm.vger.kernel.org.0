Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2594F2D898B
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439793AbgLLTCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 14:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407793AbgLLTBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Dec 2020 14:01:54 -0500
Subject: Re: [GIT PULL] Final batch of KVM changes for Linux 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607799674;
        bh=e0XhBJEFfQXkJyASd3RGAWHAXUtjpIg4zeRywyMt4ww=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=YiXtckxOz148gFc6Y2M2u/1iJ2Jma/ljjSeXOxO/j2QlBVOWWtbk+GJFb2qH0j+HW
         VsHa6CT/JdU167/5vMas2mQ+rFDGIXqbfd7Mjw6XhIbq/hi8wTp+iyiI6mT1X5jRxG
         zBGEWi1uFSzGGZP54bhDU0nJUMHwtuURCgEVu/HZVkWzVIsFGeKN/1hnYdZTnW16ZQ
         GTKtoqRjYpJFK/9OuiJBml6ze2E9JRiK9BdZ4+pcO4ebN83betE9fhM0XVnzRowBSI
         nIMN3//aMkKUvxnEmL++qrjEVVNO3Hi+2bKgVt2Jt8dbi4QRYxX8rk7GAWmC+kat0o
         gMW7XTf+PJDRA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201212155342.812596-1-pbonzini@redhat.com>
References: <20201212155342.812596-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201212155342.812596-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 111d0bda8eeb4b54e0c63897b071effbf9fd9251
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b1b868e1d9156484ccce9bf11122c053de82617
Message-Id: <160779967418.16081.12374781157946596.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Dec 2020 19:01:14 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 12 Dec 2020 10:53:42 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b1b868e1d9156484ccce9bf11122c053de82617

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
