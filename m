Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEEB2CBC
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfINTjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbfINTjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C03D8553A
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2019 19:39:05 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id h4so17494043qkd.18
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2019 12:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vaylEgrlIg+lPjH544xVFYytAlsLACbCpY321J/9g4E=;
        b=Y8qyZCYblRDuyfLuFVCRskwd3D2UvbWedBK/L69ta6e6sPN5NMpqD56ZtEjvjD8PCu
         B7jWDSqbvs3XDIzKfkaCuzfiVexNnQYEAyXSpmvo7TyH7YPMPeYnyQ78XyKxMxADbGN1
         UhSwhQTlFsx6IB38A/U11uHDcJ4m7rOty1WxJV35gWOdBgI/eA1smq+rIZkWgzQmT5vV
         WJMGwINFikfn294N9ucevAfR5U6k4zR0P6kOIOAkFgnoErO38OFpTpeWvDdNRNaEChHg
         7tFDYMe/bYHrOA2hDhFJXb3Hek2C0hoorjVAC5TDb/eM5yCxQjiWmtoEAnW39Wm8Tsm2
         ZVJQ==
X-Gm-Message-State: APjAAAWKAyqlBBji4Dgon128dHXb4B4tf7IOC8nXYMiP2CwO+4ynsiJy
        z0UVh7X4IC2lMHTx0FbdIr9f1d8nRfEJuNq74CmJGCtDqlvVTQ8LPP6O+IruUqGb7YABWBkPXlX
        UTGJgypKtRJ6f
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500321qka.310.1568489944596;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwD6rz0Xz1EID/JFGdbYv8ZxwisBunlJJE5csAnnPdoREA9Pde8LY2vagubbz6rBIS1caMDgg==
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500312qka.310.1568489944423;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id y17sm17211975qtb.82.2019.09.14.12.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 12:39:03 -0700 (PDT)
Date:   Sat, 14 Sep 2019 15:38:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
Subject: [PULL] vhost: a last minute revert
Message-ID: <20190914153859-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So I made a mess of it. Sent a pull before making sure it works on 32
bit too. Hope it's not too late to revert. Will teach me to be way more
careful in the near future.

The following changes since commit 060423bfdee3f8bc6e2c1bac97de24d5415e2bc4:

  vhost: make sure log_num < in_num (2019-09-11 15:15:26 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0d4a3f2abbef73b9e5bb5f12213c275565473588:

  Revert "vhost: block speculation of translated descriptors" (2019-09-14 15:21:51 -0400)

----------------------------------------------------------------
virtio: a last minute revert

32 bit build got broken by the latest defence in depth patch.
Revert and we'll try again in the next cycle.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      Revert "vhost: block speculation of translated descriptors"

 drivers/vhost/vhost.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
