Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690C1242FC3
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHLT6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLT6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 15:58:32 -0400
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597262311;
        bh=VVhBVHav3ExhH8kIgaVB9k1YSbyTb0vgcsz3MLhaaM8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DuT5tFUXIzxYhLJ9b8IPVqJ3uielKNi+fUCSy5KMYQDHffRR5w5QZMkDC8lrq9ym+
         U9JJjsTrl4XKVnRkbzjLgQMMTeCEbfqMXBTaNQFk8l7GowjwLgY0kfSf9tXbrRtC7N
         /5wJmo2yVEdjV3XODFvPiUNZaVnDoBbrX04u2K8I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200812082938.18976-1-pbonzini@redhat.com>
References: <20200812082938.18976-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200812082938.18976-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e792415c5d3e0eb52527cce228a72e4392f8cae2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8cd84b709647a015790a94bc809068b7a55cc05a
Message-Id: <159726231190.30367.5315438051063519093.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Aug 2020 19:58:31 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 12 Aug 2020 04:29:38 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8cd84b709647a015790a94bc809068b7a55cc05a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
