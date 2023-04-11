Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A416C6DE453
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 20:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDKSwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 14:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjDKSwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 14:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812D1ED;
        Tue, 11 Apr 2023 11:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED0B62335;
        Tue, 11 Apr 2023 18:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81A95C433D2;
        Tue, 11 Apr 2023 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681239148;
        bh=mSnbGsMR4SI5aq+KU6O+gjNS18/DJIBc5MUBlVa+nEA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B4AMr9u7u1s4hB5ZbSVf1nmhtxJX7ERT4etW2qNaRdEX5gEi3ER+bPoQiKMqxY9kN
         7Ryao7YnQ3ZB3w+AiKwQcez9WKRo4Va4XR75Qz+uD320rMB1+MUxbnw9UERaqWGqTR
         zMlNRyRZzjTjr+AwsV92u8TH8OQAIs+nN9SJvG64+LSlC7erajDOdJzUPZ9OWgd0Jc
         MMDk6if0BRlgJOgn25+MXYQSZUBjZbSj4EhWUrx7/k6X81Yu7naqp7c/IKQpzhqJ85
         jNOQCjUKNWt06ZRJgN05vLqOvsGoMFVzWcNZgp6ks4Kl3NCtPSKKDlYURWFfgsqFgd
         oMC+Ukh8wcwbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 702F0E52441;
        Tue, 11 Apr 2023 18:52:28 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.3-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230410153917.1313858-1-pbonzini@redhat.com>
References: <20230410153917.1313858-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230410153917.1313858-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa4c9185f0a16662c25d814c713b3cd0b4f4e97a
Message-Id: <168123914845.3950.12244729448044204339.pr-tracker-bot@kernel.org>
Date:   Tue, 11 Apr 2023 18:52:28 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, oliver.upton@linux.dev
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 10 Apr 2023 11:39:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa4c9185f0a16662c25d814c713b3cd0b4f4e97a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
