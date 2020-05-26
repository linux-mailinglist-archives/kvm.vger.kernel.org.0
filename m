Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A5D1C3916
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgEDMPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 08:15:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728592AbgEDMPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 08:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588594547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=q5qLe/YbLa8g+76m0wKCJz9sEFGWHkbwiwLtZx/ZVFk=;
        b=BoupBZjinqWOG60CRL1nwi+ttchJJbX0UNYWrTc0U4ZfNvu8j01xdyxYUaoMen9ob3/VDH
        7+LD20bUUoSII35T8mXnqx1GIKOuO0P4it5g/LcjFyLFTrwGngSlhuHxMoamfcPP0o91iJ
        2DHfcVLnxELFkWrWpBwBu80wkVqpQRI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-CKNQnk91P8CmDVosj7Xg8g-1; Mon, 04 May 2020 08:15:43 -0400
X-MC-Unique: CKNQnk91P8CmDVosj7Xg8g-1
Received: by mail-wm1-f71.google.com with SMTP id j5so4754081wmi.4
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 05:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=q5qLe/YbLa8g+76m0wKCJz9sEFGWHkbwiwLtZx/ZVFk=;
        b=OOaJQ76+aFh9ivsxBHSoYkxc2H0aFoxrvb3HVcE5OalE0OmZbXeaJcXRsAOJE1GAGE
         2UKFrZGahU2Gfm4WV3iISDiBFGkIr8YnrifF3uZnB6h5WteUJ1Tgec34AMQ660C30mZt
         7K3mnpOJ4F78w7IoK/243MWXyFq8ioVVWo4XP26NXMETeJwv23IdZXm9niowlUqXQLvN
         GZLdfv16dZn+EWbZKqdNHEGH8XNRICzeFhHeYzsRbuR3w48Z+cwm6FZvM7NaGL1e6Cdb
         TwT55AnkH0TF1u9XLF5M+9vlxho2z07/Pe6RB4JdwuiXFcjMzKOwRvc+HqUOyBuaCDQA
         pcBg==
X-Gm-Message-State: AGi0PuZB9XBOAKuvVnbwahEngcuwmi/bXxQBXuXef5CuFev4nJg9N/n4
        +3akgWwPmALse8hOxOflPLMW7Tx2hWK2NM8xFn6BGuoIJxh/2F202uLRSgTw7TsSeISZlTM/ypp
        lkiQxukiXLqFn
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr14085622wmh.186.1588594542756;
        Mon, 04 May 2020 05:15:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypIAWbJGa73k/tJK0QUm1DfayD29dwoou70hN0HhHJnMSNr/UKPo3sTuvVCseBF2z+tgI/8tzQ==
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr14085601wmh.186.1588594542532;
        Mon, 04 May 2020 05:15:42 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id s24sm13455322wmj.28.2020.05.04.05.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:15:41 -0700 (PDT)
Date:   Mon, 4 May 2020 08:15:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin.he@arm.com, ldigby@redhat.com, mst@redhat.com, n.b@live.com,
        stefanha@redhat.com
Subject: [GIT PULL] vhost: fixes
Message-ID: <20200504081540-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:

  Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0b841030625cde5f784dd62aec72d6a766faae70:

  vhost: vsock: kick send_pkt worker once device is started (2020-05-02 10:28:21 -0400)

----------------------------------------------------------------
virtio: fixes

A couple of bug fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jia He (1):
      vhost: vsock: kick send_pkt worker once device is started

Stefan Hajnoczi (1):
      virtio-blk: handle block_device_operations callbacks after hot unplug

 drivers/block/virtio_blk.c | 86 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vsock.c      |  5 +++
 2 files changed, 83 insertions(+), 8 deletions(-)

