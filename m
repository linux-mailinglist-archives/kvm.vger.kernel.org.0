Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F02494D87
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbiATL7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 06:59:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38502 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiATL7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 06:59:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D2F061692;
        Thu, 20 Jan 2022 11:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3353C340E0;
        Thu, 20 Jan 2022 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642679950;
        bh=UWqWrMEsC8tsiCxSdPd/pvKEe2QS8rGx7mI4OF/u3zg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VRGNeIAefqN04+IAaTIhya9+RCOAShuL6/7AUyS8UoKDMGjPJmxc6Szb6hqJnKqzX
         UQkEinVsXemqv7zNKcPTZGWgw/fm0SheteZVyVVkagBK8j0bE0ysKtGl/8fqQN+SGQ
         djXEqNSsbppR6rGGF4ZrREA9PPzwzG+G2noYtcdSK5jCea6xMa6rv1Lnk/JyI6q6Wm
         gzKK8ZeuCeqmpBnay7BEeKqfGiLEvDEzGaAzeMIOSa9bOfMGq750+CoksGa0jJydj5
         gl67Sr7+RjWvZ2QoD4tGVhFqtEziFdwk2ExrBaKOGVvjHVErrCeM8v98Kuf+QNSalI
         m/KTTySI03tPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2F46F6079A;
        Thu, 20 Jan 2022 11:59:10 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.17-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220119111142.6ecbab24.alex.williamson@redhat.com>
References: <20220119111142.6ecbab24.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220119111142.6ecbab24.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.17-rc1
X-PR-Tracked-Commit-Id: 2bed2ced40c97b8540ff38df0149e8ecb2bf4c65
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5a0b6e40d0b8c040dbfc37f7403e99867768d92
Message-Id: <164267995085.31408.1926198916452921954.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Jan 2022 11:59:10 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 19 Jan 2022 11:11:42 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.17-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5a0b6e40d0b8c040dbfc37f7403e99867768d92

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
