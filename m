Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D1C2AC7EE
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgKIWBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730284AbgKIWBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:01:43 -0500
Subject: Re: [GIT PULL] KVM fixes and selftests for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604959302;
        bh=9LVHdOL5dfNlFej2f8TcrAjDTNDnRNbp51CcPp1jZR0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=iAfiUzHQ64fuRgB2Kn1QXgg16S5NLFzIjkGI4sTQsDt0IDF1ClrDVN8w6UjlkOvBS
         YOZMBQZmQatsL2kUAqygaHZj4o0pXlZd8qYygV94inEhHbltHzDlOjXZ9I08GgobTT
         5APEV5KJu2c7g0u7I2i7atxe2GJmMYg6wzDzISxk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201109194739.1035120-1-pbonzini@redhat.com>
References: <20201109194739.1035120-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201109194739.1035120-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6d6a18fdde8b86b919b740ad629153de432d12a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 407ab579637ced6dc32cfb2295afb7259cca4b22
Message-Id: <160495930279.30617.9344510389814115164.pr-tracker-bot@kernel.org>
Date:   Mon, 09 Nov 2020 22:01:42 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon,  9 Nov 2020 14:47:39 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/407ab579637ced6dc32cfb2295afb7259cca4b22

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
