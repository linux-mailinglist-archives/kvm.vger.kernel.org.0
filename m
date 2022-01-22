Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD15496AE2
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 09:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiAVIGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 03:06:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55520 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiAVIGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 03:06:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E83EEB81FCD;
        Sat, 22 Jan 2022 08:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5E13C340E5;
        Sat, 22 Jan 2022 08:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642838800;
        bh=kITc9FV85vtPCj6OQ3wBy0H+DeeIyog9drcTZRIOVDo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=J2IAZv02LGm3U3d6jfriwoqr/sYEo9C3xUgSL5CqxxcjkjyoqnI2lShE4q1oEZ28G
         poJ33I/8mtiLKUhuvoMoD6qGlRvNslcofWDhPOp3GMfaZHNcORlnR+jsMuitIeXdes
         xWmcHKeMMCAOOFMwU480/DfS7srs6+Ea0pev43WEbFmEKKHj1ARvX10Jzl1E8gxQPJ
         s49krY6AamX9po8n7OH+7aKRzkzApJgHASX4fg1XBRZRQm6kPCODHDZ9qJ/9MkoEj/
         TYr0xMSMFUe6mImZABLGAwEr0MYC0fFTHG1H445TsrSZ16UNCGHQwOq7w07NxGg8FS
         8zol05twsU2FQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 912DFF60798;
        Sat, 22 Jan 2022 08:06:40 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.17
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220121173422.2056022-1-pbonzini@redhat.com>
References: <20220121173422.2056022-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220121173422.2056022-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e2e83a73d7ce66f62c7830a85619542ef59c90e4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 636b5284d8fa12cadbaa09bb7efa48473aa804f5
Message-Id: <164283880058.17909.12769482965812874369.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Jan 2022 08:06:40 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 21 Jan 2022 12:34:22 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/636b5284d8fa12cadbaa09bb7efa48473aa804f5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
