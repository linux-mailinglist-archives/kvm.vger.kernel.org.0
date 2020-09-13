Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6508B26800B
	for <lists+kvm@lfdr.de>; Sun, 13 Sep 2020 17:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgIMPxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Sep 2020 11:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgIMPxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Sep 2020 11:53:19 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.9-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600012399;
        bh=xra+6P9hnCeC2XNPRGatRBZteCN6A1ANgXxoOJI4SiY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=TryMfu3/S3BWwLwae3DnoBJ7G/rI3/ufFD2eqp2lg7QI13m5xwXeKaSzRt34qoQPz
         u5TCqesoG2SBxQf4yjBLJAEa2UQcsmnOt4KgQZYFZjLyz33ddkTjDWLCL6HwQDLHxU
         bV+G6dsCS+3OtdqBwDlTNSIQaqH8QHacZajMYjEQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200913081125.28980-1-pbonzini@redhat.com>
References: <20200913081125.28980-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200913081125.28980-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 37f66bbef0920429b8cb5eddba849ec4308a9f8e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 84b1349972129918557b7593c37ae52855bdc2e8
Message-Id: <160001239906.19188.11970538897183629855.pr-tracker-bot@kernel.org>
Date:   Sun, 13 Sep 2020 15:53:19 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 13 Sep 2020 04:11:25 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/84b1349972129918557b7593c37ae52855bdc2e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
