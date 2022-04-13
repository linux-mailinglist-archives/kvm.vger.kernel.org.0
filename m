Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107304FEC36
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 03:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiDMB1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 21:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiDMB1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 21:27:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBC02DD7C;
        Tue, 12 Apr 2022 18:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A91618D7;
        Wed, 13 Apr 2022 01:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48B4CC385A5;
        Wed, 13 Apr 2022 01:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649813091;
        bh=2ysF3gPZ71kiGtAuwgzRK4DEDgpfU/pE4bCXFFigVkQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=RjB9ke3paQ/cW2a0CqerGCx2RmEvftQXp62/MvT8lR3kwhQnZLBgve6CK2ih5E+If
         /Z6oP/1vYyPpYY/O5hGgFVlKaoDF0iy60opXZSoMOt7HPwB/OBLrDdZ4m7eiH7M6Vl
         KtmFJ9csrTKVdKEpKhSbudz7BRKBlEBBnB2DRBCnyrve4BYnYRcsnOjS2wLQd9pYjY
         DFKE5H0+sXqp0VSgbel7KEYnGsJFgtvt4JR93BmgibNydCffUqK3XLK5STPRvqLoqK
         rDRL8+68GU/k+GXFQBCci3aZaoemG4h98SO6NEB/Di7MEGtVJw3sJeXkWUwAG93Jqs
         U86mt5uKsd20Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33D2CE8DD5E;
        Wed, 13 Apr 2022 01:24:51 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.18-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220412172648.1060942-1-pbonzini@redhat.com>
References: <20220412172648.1060942-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220412172648.1060942-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 42dcbe7d8bac997eef4c379e61d9121a15ed4e36
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 453096eb048ce613d5775ea21cdf7826d4340e80
Message-Id: <164981309120.9925.4926821331699757223.pr-tracker-bot@kernel.org>
Date:   Wed, 13 Apr 2022 01:24:51 +0000
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

The pull request you sent on Tue, 12 Apr 2022 13:26:48 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/453096eb048ce613d5775ea21cdf7826d4340e80

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
