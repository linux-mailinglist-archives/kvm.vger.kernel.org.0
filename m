Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209984CEDB9
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 21:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiCFUfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 15:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiCFUfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 15:35:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BABA5D5D2;
        Sun,  6 Mar 2022 12:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10908B80EF7;
        Sun,  6 Mar 2022 20:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE548C340EF;
        Sun,  6 Mar 2022 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646598845;
        bh=4ZfEcSkalupFo+hO0X6Sp0yj1e5CwOSw8E7hUHVFyF0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tSzlh75sZ6AUcqp25fgrEGc2UAU4ya3BLzzCHWLAWycHASekoIFXSLLmC+yZZcZcM
         CWJbbMr3Tjdpv+/zsRBC7IhJnpTbd8MVPaQaRfdXBZ6/Ocd/vM8wXR/SqiHLMXYrY8
         jRtowBbkjUpw0BpeS8JVy7/t6zGhMjSOyYvcOE9hlC1liwt/xooXwNw7S/ArCEyPgm
         +AjtAFij4K9OcMweu59oAhXkGEyEN8kIHvU0JfX71oKCyOZpXspChZYETAdesgI8qj
         QtMQTw25D6D9KLCUqTGBZ/Otnd84+2ZY8JQiAY5mUw35on4ZcxApTzSTe1SVCpjRog
         r8n+DnNnaWFgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9FEAE8DD5B;
        Sun,  6 Mar 2022 20:34:05 +0000 (UTC)
Subject: Re: [GIT PULL] More KVM fixes for Linux 5.17-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220306105439.141939-1-pbonzini@redhat.com>
References: <20220306105439.141939-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220306105439.141939-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8d25b7beca7ed6ca34f53f0f8abd009e2be15d94
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f81664f760046ac9b5731d9340f9e48e70ea7c8d
Message-Id: <164659884575.14106.5597583608786571695.pr-tracker-bot@kernel.org>
Date:   Sun, 06 Mar 2022 20:34:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  6 Mar 2022 05:54:39 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f81664f760046ac9b5731d9340f9e48e70ea7c8d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
