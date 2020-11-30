Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968BA2C804B
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 09:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgK3Iwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 03:52:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgK3Iwg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 03:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606726270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IfhR367gJyQi+IqH9Qg+155OiV0npyw4vEgjmNlOLaQ=;
        b=dIU5rRB5mnZqJ9gQpaqkMMJzsa48qjZ7U2XXFRjvXyAtEl3ZccDjmnmJDh3yMtxjqZ6H78
        T0pAO0RXO4346xUsv63ftiMcLy+TgEc/yH3rw6RzzJpMyGIeQXQYP+vL7r2WjbunImDrPQ
        /IjqQwUjhwIOniiOWjkHvdldqG3oiTY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-pWKbxCe4NG-s-2QTMoNU4Q-1; Mon, 30 Nov 2020 03:50:15 -0500
X-MC-Unique: pWKbxCe4NG-s-2QTMoNU4Q-1
Received: by mail-wm1-f72.google.com with SMTP id o203so4061511wmo.3
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 00:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IfhR367gJyQi+IqH9Qg+155OiV0npyw4vEgjmNlOLaQ=;
        b=T9G1Qy3rK4sdZJlwXnIS8nrYiG07JyZfRtYOx9kv81D4BbJTER2EjvDU7ocIbf32Aj
         /Ucpb89J3tUnDcPfQkfAv6PK6DRAAfvrksZxbIA5Q9vtTKNdQMrdKYA4lTBajCmIkDAf
         mSIVrA1Qw7a26w8B7lsTbA35Nzz6HALiI4dH1oBaRPS5g4OjFr/SllHtQghmy4t7xsgF
         jvEgZ6oZmoKakIpucx474DR77t+aOFsvZ5ixn+sqO3c2R4Cv+QE+/T6BGkwhTtSP9G8E
         +iEXnNxSFbScUWg4IyI8JBcVqobU63ITw/8co+1NEpLv4tuDdbJiBGnyD95kQnPXK61w
         nbGQ==
X-Gm-Message-State: AOAM530bDnTafS7HWbewVelBWqfpzdJ0NF8KfvLs5rJP8AG8lhIhE6AM
        IpDF9ISoRT6bt2/kQC4KmFg1cUmPDCIs7AGEy5p6oS1ezS7q7XV8diVzILPNe3zSFNrmW12h0us
        oQvR6+CZNTdvN
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr15059096wme.5.1606726213696;
        Mon, 30 Nov 2020 00:50:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0lcq9LYEeQweeQ1PUtnvowfMkCnfs7A6y+pZ1luBu47l3TNrIhMMTxE9tXFN2kqV6KXqSzQ==
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr15059071wme.5.1606726213486;
        Mon, 30 Nov 2020 00:50:13 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id 21sm12930310wme.0.2020.11.30.00.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:50:12 -0800 (PST)
Date:   Mon, 30 Nov 2020 03:50:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, michael.christie@oracle.com, mst@redhat.com,
        sgarzare@redhat.com, si-wei.liu@oracle.com, stefanha@redhat.com
Subject: [GIT PULL] vhost,vdpa: bugfixes
Message-ID: <20201130035010-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 418baf2c28f3473039f2f7377760bd8f6897ae18:

  Linux 5.10-rc5 (2020-11-22 15:36:08 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ad89653f79f1882d55d9df76c9b2b94f008c4e27:

  vhost-vdpa: fix page pinning leakage in error path (rework) (2020-11-25 04:29:07 -0500)

----------------------------------------------------------------
vhost,vdpa: fixes

A couple of minor fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Mike Christie (1):
      vhost scsi: fix lun reset completion handling

Si-Wei Liu (1):
      vhost-vdpa: fix page pinning leakage in error path (rework)

Stefano Garzarella (1):
      vringh: fix vringh_iov_push_*() documentation

 drivers/vhost/scsi.c   |  4 ++-
 drivers/vhost/vdpa.c   | 80 ++++++++++++++++++++++++++++++++++++++------------
 drivers/vhost/vringh.c |  6 ++--
 3 files changed, 68 insertions(+), 22 deletions(-)

