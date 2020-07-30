Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52A023390E
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgG3TaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 15:30:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726853AbgG3TaH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 15:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596137406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Zo62zBr05G4i/w6uOCrF5bcIwehfjUuSBLT3HlEcuYQ=;
        b=TK4/ArutFiX30RTVSeQP72Z2Gg3T069qDEa8QhEdpHXY4H9Wb9h/Q4PtRO7epGbvlxFCR6
        b7xh+gPHuedTwoEnaJewZS1w/y+Nxl6KOj3YtkbirOPQVc/+g6xkdBIucTEE8VtXApf05t
        HdtsZRI1T2jnHEfDUECFPrFB3Ys83mA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-QKL0iWxkNVC7_REwZ5NrHw-1; Thu, 30 Jul 2020 15:30:04 -0400
X-MC-Unique: QKL0iWxkNVC7_REwZ5NrHw-1
Received: by mail-wr1-f70.google.com with SMTP id j16so8341336wrw.3
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 12:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Zo62zBr05G4i/w6uOCrF5bcIwehfjUuSBLT3HlEcuYQ=;
        b=pMu+rGIQOXWiASM29rI/HxGXPUEgciNPy0lROlNtLHP4uqCp10+U9XWvx0UipMdQ2n
         Ton8/3kk17w9LoLST9vwCTgeZ9LQLHeAfpn6nOPB8lNyTSTG/6a5YSfwA4h2F22VEAyn
         Fgp8GcklsoXmhhP3pyyI24zN4GCWwDuNaNi9RuUVDGfoWQSFKyOtceGytR3SN+Dqy9Fx
         0xey4aJ9cF70mD2Ym5U0lF7aYwtSpHvoRS945l2nTSwr0egN7XlDcvYeInh/FJ4KO4Fg
         JImMMh9UndBEemGKp/2J1DVNFiJWqoO2CFnZ2vla20dFTPs9mY0Tf+qSAM0s5juK2bEl
         wp8A==
X-Gm-Message-State: AOAM53315x3EZhZovYgluwcWc5EXfQPVIX0qizDHNSDa6YrhorVLgQmQ
        R2g3WflLfwXP8OY4itBpFJXLu+vaFZjOrzwGAzWJ18Cw9J6meaSAYN3ko7sB9+COn3PECzgLdT6
        ZMAsuMMCJJUNP
X-Received: by 2002:a5d:538a:: with SMTP id d10mr267393wrv.280.1596137403065;
        Thu, 30 Jul 2020 12:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM38R/gaJ4B9lHJnwY7CoXgiuKGr1JOva2N2K51sHps4St8QHQsZSys7gU+zLzyFwcYWboVQ==
X-Received: by 2002:a5d:538a:: with SMTP id d10mr267372wrv.280.1596137402764;
        Thu, 30 Jul 2020 12:30:02 -0700 (PDT)
Received: from redhat.com (bzq-79-179-105-63.red.bezeqint.net. [79.179.105.63])
        by smtp.gmail.com with ESMTPSA id w64sm9081104wmb.26.2020.07.30.12.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:30:01 -0700 (PDT)
Date:   Thu, 30 Jul 2020 15:29:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, chenweilong@huawei.com,
        david@redhat.com, jasowang@redhat.com, mst@redhat.com,
        rdunlap@infradead.org, stable@vger.kernel.org, wu000273@umn.edu
Subject: [GIT PULL] virtio, qemu_fw: bugfixes
Message-ID: <20200730152958-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 92ed301919932f777713b9172e525674157e983d:

  Linux 5.8-rc7 (2020-07-26 14:14:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a96b0d061d476093cf86ca1c2de06fc57163588d:

  virtio-mem: Fix build error due to improper use 'select' (2020-07-30 11:28:17 -0400)

----------------------------------------------------------------
virtio, qemu_fw: bugfixes

A couple of last minute bugfixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alexander Duyck (1):
      virtio-balloon: Document byte ordering of poison_val

Michael S. Tsirkin (2):
      vhost/scsi: fix up req type endian-ness
      virtio_balloon: fix up endian-ness for free cmd id

Qiushi Wu (1):
      firmware: Fix a reference count leak.

Weilong Chen (1):
      virtio-mem: Fix build error due to improper use 'select'

 drivers/firmware/qemu_fw_cfg.c  |  7 ++++---
 drivers/vhost/scsi.c            |  2 +-
 drivers/virtio/Kconfig          |  2 +-
 drivers/virtio/virtio_balloon.c | 11 ++++++++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

