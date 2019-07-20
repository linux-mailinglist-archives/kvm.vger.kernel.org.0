Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69A26F060
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2019 20:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfGTSk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Jul 2019 14:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbfGTSk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Jul 2019 14:40:27 -0400
Subject: Re: [GIT PULL] Second batch of KVM changes for 5.3 merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563648026;
        bh=eCzQkt5Mn8Q0ReLJaorah6wLlzoPigCHUh3ie9XalHg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=NqnaSxarR6KDM8n7yz4KS3Rt3JFYZxjIytuGHE4IN7A7zpSWxlqRPosbOCWb1pIMC
         cJ/jnOGvgDVoEiPM/ybNwMzg32xUzV7c8mGZqvDXVzD0XzFjLbg70bK8LaMqjdmrPr
         TVFtRRkos8dKDYVJ9leqpAGkr71mz1ODDOfXpPOA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1563622987-4738-1-git-send-email-pbonzini@redhat.com>
References: <1563622987-4738-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1563622987-4738-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 30cd8604323dbaf20a80e797fe7057f5b02e394d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 07ab9d5bc53d7fe84047be1d403566123ab9cfaa
Message-Id: <156364802618.20023.14003615157799136575.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Jul 2019 18:40:26 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 20 Jul 2019 13:43:07 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/07ab9d5bc53d7fe84047be1d403566123ab9cfaa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
