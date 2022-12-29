Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD96590A0
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 20:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiL2TBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 14:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiL2TBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 14:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECBFCD8;
        Thu, 29 Dec 2022 11:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09971617F3;
        Thu, 29 Dec 2022 19:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 711A8C433EF;
        Thu, 29 Dec 2022 19:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672340461;
        bh=zMB6H7h74wGxfNz0cRcftOrmlaCbTZHcr59RfmoyDi0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UjD4KUeYpIlcephh/hkMkZd/BCzTY6mqfKRs4/1UVEz9OoCoVsPE1SOLO71bsC4MQ
         WETaSkpPh1ieIjHkzU6lseqYH9RCQbBObqqvy6B+mWzNYpgeOHNtsh9rrw00DPriQQ
         wkX5OccTNLIDUTz36k4oJeN5nT1gT8kV65d3ax50i1VdIbT1bbzSJhEZ1OEs4ysJzH
         WfbNWOTXSiTou9tVMrLM1x/Y242q31nLIJWbKeFsgY6M4CkY9sj8zwSsHmVhxykANL
         UYRvfX/IHmjV+HoDtvQX1tZMO3qTw+QeEjaW4JlVSViEGzOn7hn4KUChOfshXxL5Sh
         wuvavQNH0NKcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 609A8C43141;
        Thu, 29 Dec 2022 19:01:01 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.2-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221229173354.1769443-1-pbonzini@redhat.com>
References: <20221229173354.1769443-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221229173354.1769443-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: a5496886eb130ea08b1a5cd5c284543909bde749
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2258c2dc850b8605cb66b3383e50b9dddd1c6580
Message-Id: <167234046138.22788.7479638686857586892.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Dec 2022 19:01:01 +0000
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

The pull request you sent on Thu, 29 Dec 2022 12:33:54 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2258c2dc850b8605cb66b3383e50b9dddd1c6580

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
