Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48BC47C84F
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 21:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhLUUgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 15:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhLUUgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 15:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DF4C061574;
        Tue, 21 Dec 2021 12:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC1B617B3;
        Tue, 21 Dec 2021 20:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BD0DC36AE9;
        Tue, 21 Dec 2021 20:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640119005;
        bh=0dGDXK0zmfm5iJR/CfdOM5Gi00X1MGfjd+HnzV15jLc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=D9WLOo+qtbqJUnhDxvoBtmMM0FEwKvnxe4luK6UIk9Ah2SUfCDtne9euWZiIdwf7Q
         my7uOwY93BOxWamgHKHwMUz9X9w7FCQG4Yjlp0leYjKknGdQRK09ObCKcZfWMfafXG
         J6RNtsSx1fJNNay+gIefghUFgVVo4V489wYL7hS2Yl9EhaSX/PZPi3zgcRK5u+Briq
         rs0ONPQ7Npb+6k5abd6NWVRA3JswiWuza1PXgyhgwNGk88zKzchQAXXZ+Aa/35fK1t
         /kRpnxtFUbPasffIs0ACrZ5MHrSAgAM5TOMiVZJvFjbFDragPYCAd3r8QKA/xmUvKA
         VLZKVXxiheZ0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62334609B3;
        Tue, 21 Dec 2021 20:36:45 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.16-rc7 (and likely final)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211221183201.307603-1-pbonzini@redhat.com>
References: <20211221183201.307603-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211221183201.307603-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: fdba608f15e2427419997b0898750a49a735afcb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca0ea8a60b40ecde7362ce295408c5038599f5d0
Message-Id: <164011900533.14510.14062658761664412359.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Dec 2021 20:36:45 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 21 Dec 2021 13:32:01 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca0ea8a60b40ecde7362ce295408c5038599f5d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
