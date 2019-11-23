Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1729E107F8A
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 17:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKWQ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 11:56:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25915 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726774AbfKWQ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Nov 2019 11:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574528161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2zzmCXVL6/qiRxw5VRJxtFFVEelD3xq1/ujpmzsTxFU=;
        b=JzpLZLrzk6jE0OJzJZRM42axKnIR4fRaH3HqIPofqa7Bc7dFqCowBr+7HxAbqFiEr+IywM
        rx/xlNOVmZt0D6uw2MOh76b4nLd3PotJeJV7HYoWLqYIc5gVmp53iVAPOD44itlzW57Phs
        D0n8GbQpuTvTNgqFsyOg25XSssqDZhw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-xOZBn8t1P3SX8ej7uJ299w-1; Sat, 23 Nov 2019 11:55:59 -0500
Received: by mail-qk1-f199.google.com with SMTP id 6so6612830qkc.4
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 08:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=oUPi4IjzCEcsGqjHvxV40TwATuFQ6qhdtMszb+yQ4YA=;
        b=hEeFjkK9b+ilECJyaaRwlEg7gd6ew9ygxiZ0cYqxtaQ8dJShSPLzbg8Huf1M5WH9aU
         oEVHuQlzRu+HEVkvnJXP5k9D2ottoIDjYxQqRWS7+rO2JLILS0+QwoyVIGU0GEFD+FU6
         RKRw6VsISNHkxwekPw6bkRjt6Qm9aicP1A+QyLpBmqtjDsA/JoTNJKKyuZdmhuGkm6sK
         0bCb5Zu0SG/Y8GFaM08XIw6Z4Pv8wKYG9QjKGc2EaSs8fUHeUAqjWXiJW8p+VSIjSzTC
         DtscqHigmS+W9Pn3TOao0sKhdEgoMS0TffXXEoUQQvkIHc8x1CecO4RQ8T8GWxB26ad4
         DSbw==
X-Gm-Message-State: APjAAAV8pED5z89Psz07kgqrITUFGb3McPdScwVUDBQ9GyvzjSKNqEzS
        OrI+maYt7Q4YCf7eZN/PXRic58co/t4ITUmr9mPO/UVjSmLq7MhTYrcvRywPkLj+H098O75H+Ks
        KrxCd1yGa8wt4
X-Received: by 2002:ac8:109:: with SMTP id e9mr10744664qtg.233.1574528158667;
        Sat, 23 Nov 2019 08:55:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5oU6z7kIgkAY+TdwrAkagYjcdcvZ06XXDl+M6D2/wPofNwFAEDJeY+TKLUO56xn44s6qvMg==
X-Received: by 2002:ac8:109:: with SMTP id e9mr10744651qtg.233.1574528158492;
        Sat, 23 Nov 2019 08:55:58 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id a3sm618985qkd.67.2019.11.23.08.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 08:55:57 -0800 (PST)
Date:   Sat, 23 Nov 2019 11:55:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, khazhy@google.com, lvivier@redhat.com,
        mimu@linux.ibm.com, pasic@linux.ibm.com, wei.w.wang@intel.com
Subject: [PULL] virtio: last minute bugfixes
Message-ID: <20191123115552-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
X-Mutt-Fcc: =sent
X-MC-Unique: xOZBn8t1P3SX8ej7uJ299w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit af42d3466bdc8f39806b26f593604fdc54140bcb=
:

  Linux 5.4-rc8 (2019-11-17 14:47:30 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_li=
nus

for you to fetch changes up to c9a6820fc0da2603be3054ee7590eb9f350508a7:

  virtio_balloon: fix shrinker count (2019-11-20 02:15:57 -0500)

----------------------------------------------------------------
virtio: last minute bugfixes

Minor bugfixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Halil Pasic (1):
      virtio_ring: fix return code on DMA mapping fails

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Michael S. Tsirkin (1):
      virtio_balloon: fix shrinker scan number of pages

Wei Wang (1):
      virtio_balloon: fix shrinker count

 drivers/char/virtio_console.c   | 28 +++++++++++++---------------
 drivers/virtio/virtio_balloon.c | 20 +++++++++++++-------
 drivers/virtio/virtio_ring.c    |  4 ++--
 3 files changed, 28 insertions(+), 24 deletions(-)

