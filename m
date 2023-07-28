Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04C67675A2
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbjG1Sjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjG1Sjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE16423B;
        Fri, 28 Jul 2023 11:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79408621E2;
        Fri, 28 Jul 2023 18:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE298C433C8;
        Fri, 28 Jul 2023 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690569570;
        bh=ekJmFxg2g3kH89CuUtzM5Ayd0aUXp/XgOQDgCNBy2h0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NXS6m11RWNORjqdODWImtvNmtDOg31IkCPkoBnP6RSI0DZ6WzOinUTXRoYuE0LJJk
         XQgFTkdLeqddpUjDH3+7g4sqnYdxVpk0Md7ObmPXuCptojNd6OO3qpB7tdiUfUErnH
         JELOWY7ahcntFDJC7j8j2PY03BRskhSHhQSW/rwS5uapHM+5Ppb2Vn9XProsKvZL+P
         xfmXPRcDg1zb837Ml0rlJEQWzqb1b7NUZc5bWKavbMLu0+jDPoEKqja9A1sHaa5KSO
         zBkQXwsWZ94Lz3LQAtk14FVSzDbRpPOENjju+xBIFgyKzPN70mznmTY98ZWIeeUd+d
         d32Pls2gHUbzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8EA1C4166F;
        Fri, 28 Jul 2023 18:39:30 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZMPHGPLDXK46QF+K@nvidia.com>
References: <ZMPHGPLDXK46QF+K@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZMPHGPLDXK46QF+K@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: b7c822fa6b7701b17e139f1c562fc24135880ed4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0299a13af0be43f2679047c7236e3a58e587f3f8
Message-Id: <169056957081.21363.12613540591613546001.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Jul 2023 18:39:30 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 28 Jul 2023 10:48:08 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0299a13af0be43f2679047c7236e3a58e587f3f8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
