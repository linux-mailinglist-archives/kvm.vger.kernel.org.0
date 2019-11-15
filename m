Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF8BFE420
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 18:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfKORfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 12:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfKORfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 12:35:07 -0500
Subject: Re: [GIT PULL] More KVM fixes for 5.4-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573839307;
        bh=6uhqrn3Os1/XNjxcZCalQTem+EZ16y4aWUfR5yeVMGc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=CiVN4sUOvwxz/qHaVnig89D6TLmCpvrI59TEecFHopwRn+9Gf/LWdecW9Cn4NqOcb
         lNpNFxNGVQvzQmBsXn1grfcI+IeEeVIdVA3XLsC/88cSIkzDy4jdJn44UwbAaD2QKE
         HAeaJkuoEZEmg5VCFmMmELd7E+ATKVt4WmFIHyrg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1573811092-12834-1-git-send-email-pbonzini@redhat.com>
References: <1573811092-12834-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1573811092-12834-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 9cb09e7c1c9af2968d5186ef9085f05641ab65d9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 74bc8acd6cb4f5cee25fcfe4e9afb06f75949081
Message-Id: <157383930726.31249.8445509197480847010.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Nov 2019 17:35:07 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 15 Nov 2019 10:44:52 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/74bc8acd6cb4f5cee25fcfe4e9afb06f75949081

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
