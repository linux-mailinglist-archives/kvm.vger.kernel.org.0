Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853446260C6
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 19:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiKKSDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 13:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiKKSDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 13:03:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372C3654E0;
        Fri, 11 Nov 2022 10:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C977E62083;
        Fri, 11 Nov 2022 18:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 395D9C433C1;
        Fri, 11 Nov 2022 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668189782;
        bh=QorvEQxUp4F8/9/PUAmmTiY3/3gp7gSELu2inow5DkM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TVEc0F23/Bmyn1lk6AWJe2XcoowRjOfPyRk6J1FqhM6vU7VrycmclW0CayySoHeJM
         sS/PQIF/FavtLVnmJvNoaMt1Izy5gMo7flTvZe6XyRF1FK8qMlsycMrLJT+rcWNNPd
         akMtrT8Be7lhcLI9l8ywTdLO5Jsu2qFiKZoy162VHL4UYLVNVFRI3+F7w+dvGIRAgj
         igiqOnW6DdPjkT6R0JWhiwP7sJu9LMUqr/fPanCbaDpw/0OFB8cQeqQrV/SFUdk3oM
         NsoHJ/ys8leJpvqUBjrk/ZP+QNB8V6RAmUtNOuJ1Y/tzcrYE+fuQSzfJcIqej9HOvL
         90EjMzW6hKTwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27C48C395FE;
        Fri, 11 Nov 2022 18:03:02 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.1-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221111142332.1352383-1-pbonzini@redhat.com>
References: <20221111142332.1352383-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221111142332.1352383-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6d3085e4d89ad7e6c7f1c6cf929d903393565861
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 74bd160fd59f104ca15f4582fee97807146a3a7e
Message-Id: <166818978215.15878.7245694347621533397.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Nov 2022 18:03:02 +0000
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

The pull request you sent on Fri, 11 Nov 2022 09:23:32 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/74bd160fd59f104ca15f4582fee97807146a3a7e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
