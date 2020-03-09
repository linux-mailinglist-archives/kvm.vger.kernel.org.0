Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B068C17DA47
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCIIIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:08:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43549 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726217AbgCIIIg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583741316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=T8KT/+n14Cn5HelmWM4TG6Zo6L21o7FLn2E43AQONUI=;
        b=djy4DDw0GWO/FlipTcCuReTRQdxU7CCeyznNX6plnt1Fnk2hzBgVjY0Gg7u9QOHKd/V6op
        qCM0yiU97aSGDOJCMWfyvInwVJaWxcCD1HH9MymtbUWe59vQc4VQ0uOFroV8eDrs6LCZ6f
        UaCVAZ64wWh/fxmffJE0CZtx4OiW2A8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-0xLf21sZPNe_ca2UoHEFjw-1; Mon, 09 Mar 2020 04:08:33 -0400
X-MC-Unique: 0xLf21sZPNe_ca2UoHEFjw-1
Received: by mail-qk1-f200.google.com with SMTP id t186so6703189qkh.22
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 01:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=T8KT/+n14Cn5HelmWM4TG6Zo6L21o7FLn2E43AQONUI=;
        b=r5Cfunm7j3CalAFyuIuLU8G9p3diuRqMPqWKdTOC43+6hUomxQrQK5vY9MevQrt/M1
         JYNPGubKw8GzIDWr6m0AeIY7votWKimRyuD0tvvMWvAx7ttRMBlkwhQXtqa0ATIR8aPR
         1r1a2AVgZ1p0f+Eelvq3EVjewy58L7UYiqovctKq4GpPSZ3ZrcEM899b+x2RbZ26cJaF
         lamlXI0Ker4bCLMoXSyVsMyaniT67LudeFNNcsvTAYrHptmUaTAyUYSh1jvoJO0SMbt7
         MZB9dwIYFkc2bnGzDjx8TqyAuZ5a0jfOFlp1GHy5nU3ke3PuvvjmbYTgIlsNeqgzn+9C
         07bA==
X-Gm-Message-State: ANhLgQ2NJd8H1hAephK0x1oCo57DKyd7lwHVmUGyykVz/II1E4ceDdfJ
        oiP25JTwNoIcXKFBM6HyY2YHNeKeyoLNJFlEqXzkbBS0nDLDgE+ixY09lO0/IVIclUuZKm8aWH9
        CEoQaBTZDnToy
X-Received: by 2002:a0c:c244:: with SMTP id w4mr13815581qvh.104.1583741311604;
        Mon, 09 Mar 2020 01:08:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsDCYFx3tgEt/18zqy2Hj0onYaUrEMtYoBKu3yJ+l1tw+IzBr80xlV0fKvKv/QcwEaRhnxGPw==
X-Received: by 2002:a0c:c244:: with SMTP id w4mr13815565qvh.104.1583741311386;
        Mon, 09 Mar 2020 01:08:31 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id k11sm21885175qti.68.2020.03.09.01.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 01:08:30 -0700 (PDT)
Date:   Mon, 9 Mar 2020 04:08:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jasowang@redhat.com, mst@redhat.com,
        natechancellor@gmail.com, pasic@linux.ibm.com, s-anna@ti.com
Subject: [GIT PULL] virtio: fixes
Message-ID: <20200309040825-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 98d54f81e36ba3bf92172791eba5ca5bd813989b:

  Linux 5.6-rc4 (2020-03-01 16:38:46 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6ae4edab2fbf86ec92fbf0a8f0c60b857d90d50f:

  virtio_balloon: Adjust label in virtballoon_probe (2020-03-08 05:35:24 -0400)

----------------------------------------------------------------
virtio: fixes

Some bug fixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Halil Pasic (2):
      virtio-blk: fix hw_queue stopped on arbitrary error
      virtio-blk: improve virtqueue error to BLK_STS

Nathan Chancellor (1):
      virtio_balloon: Adjust label in virtballoon_probe

Suman Anna (1):
      virtio_ring: Fix mem leak with vring_new_virtqueue()

 drivers/block/virtio_blk.c      | 17 ++++++++++++-----
 drivers/virtio/virtio_balloon.c |  2 +-
 drivers/virtio/virtio_ring.c    |  4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

