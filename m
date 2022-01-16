Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01ED48FDD2
	for <lists+kvm@lfdr.de>; Sun, 16 Jan 2022 17:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiAPQWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 11:22:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49144 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiAPQWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 11:22:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B937860F57;
        Sun, 16 Jan 2022 16:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 288B4C36AF2;
        Sun, 16 Jan 2022 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642350142;
        bh=/cVJUxqVWnjlYUt4WXjbLuM0FITLRLEwxn+8tcPu1JM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=I38mDq+IyB+w2PRcSUyRPxW1y5qxW4fBp1RdXmnfJayvMulgm7DMZWwIOtqJ78vJa
         KClOjlIRn6PXpsJZQaRGJWjc2b2wmSMwlwVPTnx3WV1EwIubcai5QdJmxMzOC1ZKG3
         RekyrZRauWu83uEbGdqUir7lMq+QOmETEynckX1PKFMAJsWptX9elatZXsW4baVmbn
         VvMzDVsDGXcZi/ouDlztve9xTG1baV0HdG8r1NtS4favSUziNmjTjEQhQaOFYG/Uyo
         0JWaKlh97zjaJmGU3p5jl3ilZQQP6P13BzzslU3c9w5UE7XDGueQgUcJQcJXeW2t+x
         XbbYMzleXvKgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16A10F60796;
        Sun, 16 Jan 2022 16:22:22 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.17
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220114191402.808664-1-pbonzini@redhat.com>
References: <20220114191402.808664-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220114191402.808664-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c862dcd199759d4a45e65dab47b03e3e8a144e3a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24
Message-Id: <164235014208.4755.2133021697223237200.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Jan 2022 16:22:22 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 14 Jan 2022 14:14:02 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/79e06c4c4950be2abd8ca5d2428a8c915aa62c24

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
