Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27FC6F4A11
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjEBTDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 15:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjEBTDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 15:03:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D742ADC;
        Tue,  2 May 2023 12:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7300260FC9;
        Tue,  2 May 2023 19:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC791C433EF;
        Tue,  2 May 2023 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683054196;
        bh=7FgPD409KK8TS9Canekh+lYrA2A8e2msl4W+I8D2a8k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aQnCUoj9Sj7GnlwMVrKO1SoF0/Jd2kDAOHN9+oK+t9ZydUr3jS0gUmY+Q+Nn1RHQE
         ph/NQHTLzAf9uYaINJRyOnRu9VVqFdgibxwpNTLZSeJCXF3HeXmJNEAgvyIss0zDpI
         MhyDDK0oJsuBEPyGfC3bjp+XgXFhtxRtbIOpS4r8zfiOSDI6dMQJJagN9tnezCpo5j
         oxMOfc9zCgm5QundhOqjL6WzQQkE8huiOeso03saPUU0YuZCmbGJt8SwxSZp8eT0Wg
         hD7LqWDvucZOwdoiquVSkI1lLN+dMVMu/M02DVpFXJwEwUC6vLcxScu3e8++Pz3DxV
         ADtrk646BEKmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C99D9C3959E;
        Tue,  2 May 2023 19:03:16 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230502124625.355ec05e.alex.williamson@redhat.com>
References: <20230502124625.355ec05e.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230502124625.355ec05e.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc1
X-PR-Tracked-Commit-Id: 705b004ee377b789e39ae237519bab714297ac83
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7df047b3f0aa0c0ba730b6be9ab35c0053a3d4fd
Message-Id: <168305419681.12714.4398273369995372776.pr-tracker-bot@kernel.org>
Date:   Tue, 02 May 2023 19:03:16 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 2 May 2023 12:46:25 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7df047b3f0aa0c0ba730b6be9ab35c0053a3d4fd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
