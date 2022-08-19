Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72459A783
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 23:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352286AbiHSVOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 17:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351674AbiHSVOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 17:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA2A719AD;
        Fri, 19 Aug 2022 14:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1D961737;
        Fri, 19 Aug 2022 21:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF71AC433C1;
        Fri, 19 Aug 2022 21:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660943679;
        bh=gdoHNEL75+MVZBcr5Yhk+hJfR6N5vjhPex8MTgidlAo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kJ2hSp1/OwI9neSirzjKKXusl38J7nnBQWWSzx5lMKVw4mDeHcZ6iKxELVDyo3wpw
         XOYDGI11784Do6DYiEJyCxePtGpTt8Io5/Ywv1R0jttQAfkEqjHgtwWTt4+lCfyXmN
         +IjdyI77WdgkcSNiNe48UwUTO16RZ3PPSJXmtOWNuwG94oAYT60qDbKeg/Py4URATq
         TSvCSiq20WQX56YxlJY3q4n66qaiE5XYbF9qozWy1R9VgbbM1WwHW9Ndu6ChUi/1Da
         DO3Kzkm3NMac19lDLl2jOyRh2bWrGOcSkN8gQGQXxzf7+SnDyJ1sAN1+fwMkn2r+Ut
         a1IBBgV0hvW4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC4A3E2A050;
        Fri, 19 Aug 2022 21:14:39 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.0-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220819103357.2346708-1-pbonzini@redhat.com>
References: <20220819103357.2346708-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220819103357.2346708-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 959d6c4ae238b28a163b1b3741fae05391227ad9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca052cfd6ee5d3358f2929439e0c7f0424bedc9e
Message-Id: <166094367976.15089.1525473485551266176.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Aug 2022 21:14:39 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 19 Aug 2022 06:33:57 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca052cfd6ee5d3358f2929439e0c7f0424bedc9e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
