Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C6654A0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfGKKoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:44:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbfGKKoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:44:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0AF6181F01;
        Thu, 11 Jul 2019 10:44:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A90460600;
        Thu, 11 Jul 2019 10:44:15 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL 00/19] Migration patches
Date:   Thu, 11 Jul 2019 12:43:53 +0200
Message-Id: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 11 Jul 2019 10:44:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:

  Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)

are available in the Git repository at:

  https://github.com/juanquintela/qemu.git tags/migration-pull-request

for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:

  migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)

----------------------------------------------------------------
Migration pull request

----------------------------------------------------------------

Juan Quintela (3):
  migration: fix multifd_recv event typo
  migration-test: rename parameter to parameter_int
  migration-test: Add migration multifd test

Peng Tao (1):
  migration: allow private destination ram with x-ignore-shared

Peter Xu (10):
  migration: No need to take rcu during sync_dirty_bitmap
  memory: Don't set migration bitmap when without migration
  bitmap: Add bitmap_copy_with_{src|dst}_offset()
  memory: Pass mr into snapshot_and_clear_dirty
  memory: Introduce memory listener hook log_clear()
  kvm: Update comments for sync_dirty_bitmap
  kvm: Persistent per kvmslot dirty bitmap
  kvm: Introduce slots lock for memory listener
  kvm: Support KVM_CLEAR_DIRTY_LOG
  migration: Split log_clear() into smaller chunks

Wei Yang (5):
  migration/multifd: call multifd_send_sync_main when sending
    RAM_SAVE_FLAG_EOS
  migration/xbzrle: update cache and current_data in one place
  cutils: remove one unnecessary pointer operation
  migration/multifd: sync packet_num after all thread are done
  migratioin/ram.c: reset complete_round when we gets a queued page

 accel/kvm/kvm-all.c          |  260 +-
 accel/kvm/trace-events       |    1 +
 exec.c                       |   15 +-
 include/exec/memory.h        |   19 +
 include/exec/memory.h.rej    |   26 +
 include/exec/ram_addr.h      |   92 +-
 include/exec/ram_addr.h.orig |  488 ++++
 include/qemu/bitmap.h        |    9 +
 include/sysemu/kvm_int.h     |    4 +
 memory.c                     |   56 +-
 memory.c.rej                 |   17 +
 migration/migration.c        |    4 +
 migration/migration.h        |   27 +
 migration/migration.h.orig   |  315 +++
 migration/ram.c              |   93 +-
 migration/ram.c.orig         | 4599 ++++++++++++++++++++++++++++++++++
 migration/ram.c.rej          |   33 +
 migration/trace-events       |    3 +-
 migration/trace-events.orig  |  297 +++
 tests/Makefile.include       |    2 +
 tests/migration-test.c       |  103 +-
 tests/test-bitmap.c          |   72 +
 util/bitmap.c                |   85 +
 util/cutils.c                |    8 +-
 24 files changed, 6545 insertions(+), 83 deletions(-)
 create mode 100644 include/exec/memory.h.rej
 create mode 100644 include/exec/ram_addr.h.orig
 create mode 100644 memory.c.rej
 create mode 100644 migration/migration.h.orig
 create mode 100644 migration/ram.c.orig
 create mode 100644 migration/ram.c.rej
 create mode 100644 migration/trace-events.orig
 create mode 100644 tests/test-bitmap.c

-- 
2.21.0

