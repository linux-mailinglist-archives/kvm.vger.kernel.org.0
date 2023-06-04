Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511CB721726
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 15:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjFDNAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 09:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjFDNAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 09:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1B1D3;
        Sun,  4 Jun 2023 05:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9390E60CEC;
        Sun,  4 Jun 2023 12:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 043F3C433D2;
        Sun,  4 Jun 2023 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685883593;
        bh=uUWO1qfFr04qaobCD53g0KwTjhHGOPN0a13Woz2TM7I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Rd0f6YDUfZRQlfldfuIQPNXpLe5Ek1fmkMEZNWkODWKgmBk6+W3wcNdA5Gnpe6ON0
         1Nm4riOqtv/yBZDgf4gT63yT9LsrGDPZdOmEMC+UszB2tCnjBZCidYTLNdQGNtlmS0
         DvRQQn37PgMiXBwSOaySqz7au0C9Vqw2JX9SxH/5HVQ3AE0LLJps3Yl2s1oPaFEFtC
         Lm3KlVF22xVA/MxsmRCrcr/BpLkBJ0iFZd3/twhI+qVC/dYUJAwGJ4qRbpke3k4/+P
         xd2tHFZV7c149qrtUSl275RnFdyTFeXgCuASj4P7MrErpOWvxo703HVb5Uct0EyPFn
         Sp8YKlTi70vvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1F2AE52C02;
        Sun,  4 Jun 2023 12:59:52 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.4-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230604102538.8867-1-pbonzini@redhat.com>
References: <20230604102538.8867-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230604102538.8867-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f211b45057d8b0264b494f1acebf2e8d7f9432c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b066935bf83371c34ab8ba3b15f4232536e2786f
Message-Id: <168588359289.18655.10586020172284166645.pr-tracker-bot@kernel.org>
Date:   Sun, 04 Jun 2023 12:59:52 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  4 Jun 2023 12:25:38 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b066935bf83371c34ab8ba3b15f4232536e2786f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
