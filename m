Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74926691497
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjBIXgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBIXfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:35:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21A66E8B8
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TYT45XB4DWXycv/oNPbZHzoL4jOw/uhzINL37WWviCI=;
        b=A8Sq7J05ujDRReAAtr7qXBnbbkqKdylylUzHhXTPugvrCdBYTvZUW/CiJCmo+9SdNH/wct
        0M7hum9sPhD8xhxfz1WoDduK1+u8XOY/UXJRtJCQCW/EnmmlvzpgFTPQ95ZGAOOKt2azGA
        YwC3DN/MsYEpOXGPzQOQfJzxbgTxzFU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-Ny2QYQhtMr--h0DAvMYLsw-1; Thu, 09 Feb 2023 18:34:29 -0500
X-MC-Unique: Ny2QYQhtMr--h0DAvMYLsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D77C1C05AB0;
        Thu,  9 Feb 2023 23:34:29 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11BEF440BC;
        Thu,  9 Feb 2023 23:34:26 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PULL 00/17] Migration 20230209 patches
Date:   Fri, 10 Feb 2023 00:34:09 +0100
Message-Id: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 417296c8d8588f782018d01a317f88957e9786d6:

  tests/qtest/netdev-socket: Raise connection timeout to 60 seconds (2023-02-09 11:23:53 +0000)

are available in the Git repository at:

  https://gitlab.com/juan.quintela/qemu.git tags/migration-20230209-pull-request

for you to fetch changes up to 858191aebda251a4d1e3bc77b238096673241cdd:

  migration: Postpone postcopy preempt channel to be after main (2023-02-09 21:26:02 +0100)

----------------------------------------------------------------
Migration Pull request

Hi

This are all the reviewed patches for migration:
- AVX512 support for xbzrle (Ling Xu)
- /dev/userfaultd support (Peter Xu)
- Improve ordering of channels (Peter Xu)
- multifd cleanups (Li Zhang)
- Remove spurious files from last merge (me)
  Rebase makes that to you
- Fix mixup between state_pending_{exact,estimate} (me)
- Cache RAM size during migration (me)
- cleanup several functions (me)

Please apply.

----------------------------------------------------------------

Juan Quintela (7):
  migration: Remove spurious files
  migration: Simplify ram_find_and_save_block()
  migration: Make find_dirty_block() return a single parameter
  migration: Split ram_bytes_total_common() in two functions
  migration: Calculate ram size once
  migration: Make ram_save_target_page() a pointer
  migration: I messed state_pending_exact/estimate

Li Zhang (2):
  multifd: cleanup the function multifd_channel_connect
  multifd: Remove some redundant code

Peter Xu (6):
  linux-headers: Update to v6.1
  util/userfaultfd: Support /dev/userfaultfd
  migration: Rework multi-channel checks on URI
  migration: Cleanup postcopy_preempt_setup()
  migration: Add a semaphore to count PONGs
  migration: Postpone postcopy preempt channel to be after main

ling xu (2):
  AVX512 support for xbzrle_encode_buffer
  Update bench-code for addressing CI problem

 MAINTAINERS                                   |    1 +
 .../x86_64-quintela-devices.mak               |    7 -
 .../x86_64-quintela2-devices.mak              |    6 -
 meson.build                                   |   17 +
 include/standard-headers/drm/drm_fourcc.h     |   34 +-
 include/standard-headers/linux/ethtool.h      |   63 +-
 include/standard-headers/linux/fuse.h         |    6 +-
 .../linux/input-event-codes.h                 |    1 +
 include/standard-headers/linux/virtio_blk.h   |   19 +
 linux-headers/asm-generic/hugetlb_encode.h    |   26 +-
 linux-headers/asm-generic/mman-common.h       |    2 +
 linux-headers/asm-mips/mman.h                 |    2 +
 linux-headers/asm-riscv/kvm.h                 |    4 +
 linux-headers/linux/kvm.h                     |    1 +
 linux-headers/linux/psci.h                    |   14 +
 linux-headers/linux/userfaultfd.h             |    4 +
 linux-headers/linux/vfio.h                    |  142 ++
 migration/migration.h                         |   15 +-
 migration/postcopy-ram.h                      |    4 +-
 migration/xbzrle.h                            |    4 +
 migration/migration.c                         |  122 +-
 migration/multifd.c                           |   70 +-
 migration/postcopy-ram.c                      |   31 +-
 migration/ram.c                               |  136 +-
 migration/savevm.c                            |   56 +-
 migration/xbzrle.c                            |  124 ++
 tests/bench/xbzrle-bench.c                    |  473 ++++++
 tests/unit/test-xbzrle.c                      |   42 +-
 util/userfaultfd.c                            |   32 +
 meson_options.txt                             |    2 +
 migration/multifd.c.orig                      | 1274 -----------------
 scripts/meson-buildoptions.sh                 |    3 +
 tests/bench/meson.build                       |    4 +
 util/trace-events                             |    1 +
 34 files changed, 1257 insertions(+), 1485 deletions(-)
 delete mode 100644 configs/devices/x86_64-softmmu/x86_64-quintela-devices.mak
 delete mode 100644 configs/devices/x86_64-softmmu/x86_64-quintela2-devices.mak
 create mode 100644 tests/bench/xbzrle-bench.c
 delete mode 100644 migration/multifd.c.orig

-- 
2.39.1

