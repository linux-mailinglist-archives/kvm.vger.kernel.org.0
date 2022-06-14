Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4954B73A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355782AbiFNRCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353105AbiFNRBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC77949FAA;
        Tue, 14 Jun 2022 10:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E52B81A1C;
        Tue, 14 Jun 2022 17:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37EC0C3411B;
        Tue, 14 Jun 2022 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655226072;
        bh=1XZxaOJMKDpanHxkmr7Tnpx6ZIBhY6H/i3lFguyLLN4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lIlAyfSxKBinUFUsW1EEW6FhV/KYgWAu4AlHljZZNUhEoqNf406GcWcNDDlUbfCbl
         n7XHQINOO1ERkus+/oZ4bVnN5q3HQ71eMaFPTUJicbb5HAXFeJWybUG/b/94sBn7L3
         azAirIf6YN7SXr/VfZAyoFUVqJO/DSHLkd80N7zw9inl468eB2IDNLjtdWXSwc59GR
         zotBLGV1DSux0zo76Wiw7L5z9Pyz/4DMBv7HVDl7ihcDCBO/ttikXDKdqclwZh40SQ
         3fUhQTasgnp7GOE9uBB6gngVMxb36p06W3FWV4G3bAsX/vzJoqWDdu6rqlAAUvnvJf
         Fjd+9/gmDpHQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26A0CE6D466;
        Tue, 14 Jun 2022 17:01:12 +0000 (UTC)
Subject: Re: [GIT PULL] More KVM changes for Linux 5.19-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220614083552.1559600-1-pbonzini@redhat.com>
References: <20220614083552.1559600-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220614083552.1559600-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e0f3f46e42064a51573914766897b4ab95d943e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 24625f7d91fb86b91e14749633a7f022f5866116
Message-Id: <165522607215.24379.2895241049246462864.pr-tracker-bot@kernel.org>
Date:   Tue, 14 Jun 2022 17:01:12 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 14 Jun 2022 04:35:52 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/24625f7d91fb86b91e14749633a7f022f5866116

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
