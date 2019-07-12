Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2731B6715F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfGLOcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfGLOcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:32:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 525C2B9ADD;
        Fri, 12 Jul 2019 14:32:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63BD864024;
        Fri, 12 Jul 2019 14:32:10 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 00/19] Migration patches
Date:   Fri, 12 Jul 2019 16:31:48 +0200
Message-Id: <20190712143207.4214-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 12 Jul 2019 14:32:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit a2a9d4adabe340617a24eb73a8b2a116d28a6b38:

  Merge remote-tracking branch 'remotes/dgibson/tags/ppc-for-4.1-20190712' into staging (2019-07-12 11:06:48 +0100)

are available in the Git repository at:

  https://github.com/juanquintela/qemu.git tags/migration-pull-request

for you to fetch changes up to a48ad5602f496236b4e1955d9e2e8228a7d0ad56:

  migration: allow private destination ram with x-ignore-shared (2019-07-12 16:25:59 +0200)

----------------------------------------------------------------
Migration pull request

Fix the issues with the previous pull request and 32 bits.

Please apply.

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
  migration/ram.c: reset complete_round when we gets a queued page

 accel/kvm/kvm-all.c      | 260 ++++++++++++++++++++++++++++++++++++---
 accel/kvm/trace-events   |   1 +
 exec.c                   |  15 ++-
 include/exec/memory.h    |  19 +++
 include/exec/ram_addr.h  |  92 +++++++++++++-
 include/qemu/bitmap.h    |   9 ++
 include/sysemu/kvm_int.h |   4 +
 memory.c                 |  56 ++++++++-
 migration/migration.c    |   4 +
 migration/migration.h    |  27 ++++
 migration/ram.c          |  93 ++++++++++----
 migration/trace-events   |   3 +-
 tests/Makefile.include   |   2 +
 tests/migration-test.c   | 103 ++++++++++++----
 tests/test-bitmap.c      |  72 +++++++++++
 util/bitmap.c            |  85 +++++++++++++
 util/cutils.c            |   8 +-
 17 files changed, 770 insertions(+), 83 deletions(-)
 create mode 100644 tests/test-bitmap.c

-- 
2.21.0

