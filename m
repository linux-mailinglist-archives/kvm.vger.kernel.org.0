Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C47EC1A2E30
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 06:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgDIEFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 00:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgDIEF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 00:05:27 -0400
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586405127;
        bh=1xW8kN2yqWmv57JHAaFToSciFy2sqNwu2DUej9DniPQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=K4AxF5CNOiXnQqUeTdl/NyYDjLTjk/1+60dk9GLkLjds0QK0u7C3nbI7fp8LSG6fs
         akowsmy37yK2sgHYJ7f1cbPlpkJ/I17iPoRTA1GIO/+R6tWsXbxtC4Md/1g/wC0b8J
         LBShwEUJLd8q4QwwP0ZRH00STsRvVVukRdBMIiWI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200407182111.23659-1-pbonzini@redhat.com>
References: <20200407182111.23659-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200407182111.23659-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: dbef2808af6c594922fe32833b30f55f35e9da6d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0339eb95403fb4664219be344a9399a3fdf1fae1
Message-Id: <158640512788.12302.996590418957242955.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:05:27 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  7 Apr 2020 14:21:11 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0339eb95403fb4664219be344a9399a3fdf1fae1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
