Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0B532CE9
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbiEXPGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238651AbiEXPGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:06:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2D94B1E9
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:06:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E064223A;
        Tue, 24 May 2022 08:06:17 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65AEC3F70D;
        Tue, 24 May 2022 08:06:16 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keir Fraser <keirf@google.com>
Subject: [PATCH kvmtool 0/4] Update virtio headers (to fix build)
Date:   Tue, 24 May 2022 16:06:07 +0100
Message-Id: <20220524150611.523910-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we implement some virtio devices in kvmtool, we were including
older copies of some virtio UAPI header files in our tree, but were
relying on some other headers to be provided by the distribution.
This leads to problems when we need to use newer virtio features (like
the recent virtio_balloon stat update), which breaks compilation on some
(older) distros.

To fix this and avoid similar problems in the future, just copy in the
virtio UAPI headers from the kernel tree, as we do already for the
actual KVM interface headers. To simplify future syncs, also update our
update_headers.sh script on the way.

Please have a look!

Cheers,
Andre

Andre Przywara (4):
  update virtio_mmio.h
  util: include virtio UAPI headers in sync
  include: update virtio UAPI headers
  include: add new virtio uapi header files

 include/linux/virtio_9p.h      |  44 ++++++
 include/linux/virtio_balloon.h | 119 ++++++++++++++++
 include/linux/virtio_blk.h     | 203 +++++++++++++++++++++++++++
 include/linux/virtio_config.h  | 101 ++++++++++++++
 include/linux/virtio_console.h |  78 +++++++++++
 include/linux/virtio_ids.h     |  63 +++++++--
 include/linux/virtio_mmio.h    |  55 +++++++-
 include/linux/virtio_net.h     | 200 +++++++++++++++++++++++----
 include/linux/virtio_pci.h     | 208 ++++++++++++++++++++++++++++
 include/linux/virtio_ring.h    | 244 +++++++++++++++++++++++++++++++++
 include/linux/virtio_rng.h     |   8 ++
 include/linux/virtio_scsi.h    | 118 ++++++++--------
 include/linux/virtio_vsock.h   |  16 ++-
 util/update_headers.sh         |  10 ++
 virtio/mmio.c                  |   8 +-
 15 files changed, 1372 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/virtio_9p.h
 create mode 100644 include/linux/virtio_balloon.h
 create mode 100644 include/linux/virtio_blk.h
 create mode 100644 include/linux/virtio_config.h
 create mode 100644 include/linux/virtio_console.h
 create mode 100644 include/linux/virtio_pci.h
 create mode 100644 include/linux/virtio_ring.h
 create mode 100644 include/linux/virtio_rng.h

-- 
2.25.1

