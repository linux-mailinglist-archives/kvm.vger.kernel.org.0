Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B249746676
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 02:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjGDAQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 20:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjGDAQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 20:16:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EADF2;
        Mon,  3 Jul 2023 17:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDEE561093;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48B7EC433C7;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688429808;
        bh=4Arucsbx7xXqBiJTMaZ2sHKWBFMCtusx1d5m5Uphgso=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DkAAGrdnnnfiwiC89o0VZ3uslqIdbGQ6SfUpM7T/TzojYaMGDyAxiJ2vC2uTbN4zk
         NssPpXz/RhgXyiib8WCc8DEqbGdbxZ4E1v2zDLT9CFBSnk9HVAQfERCOUV6XgdswW4
         yRZ1eSozjbVnr8qyOpiGZ7tial8XQDe2GHfmWsl1GkbTJTy10GyHLhefqUq6nVBYFT
         CffYwH9WR7ydcQoSL3QV+a+TLWW/StZElppe/qNzKvfgP3Ye9tDCetQykuTJ+iPuYI
         EjyL1N2CHSQn2ckHuPh2bicLfW/tRh93bFF7XkKRzB9m3XOrEYxjtpwEW2bAiOYhCQ
         0M1lH9fBRUkJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33BBCC561EE;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230703123256-mutt-send-email-mst@kernel.org>
References: <20230703123256-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230703123256-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 9e396a2f434f829fb3b98a24bb8db5429320589d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8d70602b186f3c347e62c59a418be802b71886d
Message-Id: <168842980820.28751.12949460743497751873.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Jul 2023 00:16:48 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, dtatulea@nvidia.com, elic@nvidia.com,
        feliu@nvidia.com, horms@kernel.org, jasowang@redhat.com,
        krzysztof.kozlowski@linaro.org, lingshan.zhu@intel.com,
        maxime.coquelin@redhat.com, michael.christie@oracle.com,
        mst@redhat.com, peng.fan@nxp.com, saeedm@nvidia.com,
        shannon.nelson@amd.com, tianxianting.txt@alibaba-inc.com,
        xianting.tian@linux.alibaba.com, xieyongji@bytedance.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 3 Jul 2023 12:32:56 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8d70602b186f3c347e62c59a418be802b71886d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
