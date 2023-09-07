Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC8797ED2
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 00:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbjIGWxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236163AbjIGWxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 18:53:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C73D1BDA;
        Thu,  7 Sep 2023 15:53:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8E65C433C8;
        Thu,  7 Sep 2023 22:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694127223;
        bh=FQg5MGMUUhHyWsbcSzaL+Xz2wFkrfIbAdHUGu+3PPsg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sKX+pBkFPgDNuJSlsJUI454Lwj9++bmuXhfOrhGDnylhrfIzTeFZhGoL+y8AicIOz
         THMQcqwNhuPLIvDFKgSX8AH7c3FMQqdMER9jC/DhKF/EzV8H7sqPG7bu4UiVnZlSl7
         FVmsQoZkqucL62NDrqqARuMijLcC8RmpeAcDWCr2fpiGjJBjbWdb60QxdYCSOxtmIa
         De61NINmpEG0oF/TQRqzVU+lxfKQWpZLGXfRUYMnJ7Q9ns1m0XlmP/A1meHMFa6+TH
         exI9Tc1CslKKlhDtmcSPVwxdPqDoD2qbUGXI3R+jWKAPBMrPfKWYcaeLPhwrmyjrRw
         mdCLlXlSTqAow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8E52C4166F;
        Thu,  7 Sep 2023 22:53:43 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.6 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230906174846.234274-1-pbonzini@redhat.com>
References: <20230906174846.234274-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230906174846.234274-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d011151616e73de20c139580b73fa4c7042bd861
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0c02183427b4d2002992f26d4917c1263c5d4a7f
Message-Id: <169412722375.28163.4459184427658337590.pr-tracker-bot@kernel.org>
Date:   Thu, 07 Sep 2023 22:53:43 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  6 Sep 2023 13:48:46 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0c02183427b4d2002992f26d4917c1263c5d4a7f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
