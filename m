Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB264E218
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiLOUAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiLOUAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B4554365;
        Thu, 15 Dec 2022 12:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C6B0B81C28;
        Thu, 15 Dec 2022 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F289CC43396;
        Thu, 15 Dec 2022 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671134419;
        bh=FG/gOmOr9ZDg61B858vTymx0MZqUIHhXzja2FrmWfaM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=o+zhfqD/tjbhOE1LrEyFvQrLrO9aHxbgZPEAHHoHGMxejKri5zLEBP+iowY+Ii9IR
         gvAGlMpD5jLOQGfNW+X2YfblFUOd7TN+Q3PTSK2IC3odUWVM8vlpAR1dUA79xo/srA
         JEELmlrnfhkdFfSp32td5y0xkTEfZZACOKR18RrG7m8XpDw0BdaMl2s8SuT/m7a0jP
         0lEGbSUGagVjkeAMeGVKFYHpwoQyaFT//v7WkEnnjjxxVw1r/+AiJbq4r1XXSQ+jiI
         jiQ+hPVZ3C5twGHEpBCaLlGVD9wHUMZICsSdXUlwYbLGc/L9tvhNfU9w8sN6DURyPL
         pNMSaUyUyi9Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9395E50D6E;
        Thu, 15 Dec 2022 20:00:18 +0000 (UTC)
Subject: Re: [GIT PULL v2] First batch of KVM changes for Linux 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221215184456.368121-1-pbonzini@redhat.com>
References: <20221215184456.368121-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221215184456.368121-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 549a715b98a13c6d05452be3ad37e980087bb081
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8fa590bf344816c925810331eea8387627bbeb40
Message-Id: <167113441886.3532.4616915121436503922.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Dec 2022 20:00:18 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 15 Dec 2022 13:44:56 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8fa590bf344816c925810331eea8387627bbeb40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
