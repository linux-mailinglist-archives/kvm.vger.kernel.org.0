Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF16746674
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 02:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjGDAQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 20:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjGDAQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 20:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237EDE1;
        Mon,  3 Jul 2023 17:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6E36108E;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22CAFC433C9;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688429808;
        bh=Q9t82D0XHv4OWmTe/RwOQDGGsULJk3SPsKOLkKVGSwg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EF+rI0UZy991UFGmXXD7R9ymiubcJMAewschJbFdPWiPI3ov3WtJPNxLizrUdgite
         tpPN5emhEurTtPLGqJIG+hv/nt1LcyGKVEjfG4rplJnm3FdeksHIipUf9xcZLlkV9n
         R0uP+NdIP3MqlhuUjsy9xi72AE+SrNMj0U2d4yQbNF2LvY5xOsO9Qg20excRz7zNBh
         Ajab1KxH80uiL+LkGPEIEnuXKPf4sW9Jud7Z86X+VYLWAZcW9vrXLUrh85h+IucgsR
         H6IbCpOxTARtvmN4mbo9K2D48sr6AxR7ytbLnrClFdMoxZpgSsG8FlQyQfX4m3AJ2J
         d5SbvVYS0QIvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11D2BC39563;
        Tue,  4 Jul 2023 00:16:48 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230703114435.645750-1-pbonzini@redhat.com>
References: <20230703114435.645750-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230703114435.645750-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 255006adb3da71bb75c334453786df781b415f54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8069f5a8e3bdb5fdeeff895780529388592ee7a
Message-Id: <168842980806.28751.3192519412776943013.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Jul 2023 00:16:48 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon,  3 Jul 2023 07:44:35 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8069f5a8e3bdb5fdeeff895780529388592ee7a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
