Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06566CAE99
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 21:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjC0TaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 15:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjC0TaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 15:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EB02D48;
        Mon, 27 Mar 2023 12:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0410614A6;
        Mon, 27 Mar 2023 19:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14180C433D2;
        Mon, 27 Mar 2023 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679945421;
        bh=LevS0yAgLpnRo+F5wOeYeDEAjhjxSuqV+AxUGqatvjg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LdJRS4ogg/nB/N3Fa3NOpoar/Mdn9+8Lqh0rU6KlWpWggVXfOIX5cT2xxal5jTppu
         NGQqSFhybint61FpRgCSfVTCNIn6kJOK9Vbp5tqwoND1cjU5cvtXb4CKeLh5rT6dGg
         L+iByKvNRMWOVjVUeJ8gHzjfvK9N+aJqKcjX1sic0Zi8RFlakpVEv6okhtdAz/K+/r
         zUXc6oEjnYDzV9qKeikZwmTUg9IPxYfuepjSFNYeyCjR4NOffXTAi2ngEOOxpCv9jI
         bq2gnL6fmXoSJXJU1erbZhbrulFWvyCbQENHBOG45mV4A6jfbxQtXnfIYxqfdz/Ogs
         61p9zo0mjb6SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7F8AE2A038;
        Mon, 27 Mar 2023 19:30:20 +0000 (UTC)
Subject: Re: [GIT PULL] Non-x86 KVM fixes for Linux 6.3-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230327175315.3763370-1-pbonzini@redhat.com>
References: <20230327175315.3763370-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230327175315.3763370-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9e347ba03029e10e6405f8c3a7a91a5597943ed9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a93e40326c8f470e71d20b4c42d36767450f38f
Message-Id: <167994542093.14698.17733121885371184674.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Mar 2023 19:30:20 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
        apatel@ventanamicro.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 27 Mar 2023 13:53:15 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a93e40326c8f470e71d20b4c42d36767450f38f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
