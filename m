Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA8641A1E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 03:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408328AbfFLBzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 21:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404758AbfFLBzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 21:55:11 -0400
Subject: Re: [GIT PULL] VFIO fixes for v5.2-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560304511;
        bh=qlNkLT4spnpEfd+L838OBJlNx2DAQrldqfx6iJBh698=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=YpcV/lfMDn6YqKfnIehNmSCR9kWDwWEkC1oYlTAox85/PfBuTw2FNkeiH6Zr60oCS
         ndGLCxP5vqwnPTbU8q+Shb2auFhUr7M0/aF4FTVMnh3SbEHms7mBJxORBtvoS6l1VB
         Rm7/vXfq8njoS+Ipx2AxqyzI+LlkzWYuhLHZtIGY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190611114955.2d0b6388@x1.home>
References: <20190611114955.2d0b6388@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190611114955.2d0b6388@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.2-rc5
X-PR-Tracked-Commit-Id: 5715c4dd66a315515eedef3fc4cbe1bf4620f009
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c23b07125f8aebf8b39fffa325145826098f7d8f
Message-Id: <156030451113.13515.13439301806650379331.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Jun 2019 01:55:11 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 11 Jun 2019 11:49:55 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.2-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c23b07125f8aebf8b39fffa325145826098f7d8f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
