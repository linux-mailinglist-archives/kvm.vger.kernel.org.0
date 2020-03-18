Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04E818A095
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgCRQhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:37:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55183 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbgCRQhs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+UbzLGkfckNn6naER8zwWd5/jxYv9RSpbtDrZv7dGK0=;
        b=N23P3NtM6TvNWJmUPrdKuHUPmvbb4+das99xq1GRX1ZVDUHAR9cKHOU7vCj5U/8hoLaiXP
        QQc5APoZ1e3CIXH8kI212SWWZyxTfBdhVS/+3wzbf0K+thcxq9dV+4ZduptqXWGHxkRFxv
        tSLlzlqGUKS45kGnGk6dF9PnwVHNFdw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-_Csrk2oINm6MunH5n8YpNQ-1; Wed, 18 Mar 2020 12:37:28 -0400
X-MC-Unique: _Csrk2oINm6MunH5n8YpNQ-1
Received: by mail-wm1-f69.google.com with SMTP id z16so1287576wmi.2
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UbzLGkfckNn6naER8zwWd5/jxYv9RSpbtDrZv7dGK0=;
        b=BNvnpbP2TjvZsw//a+br6FKGNU7uOoI6j2LzpDtC/zrHdSU/iV4cpijOEdpPh0PXbp
         8rNsDKcWWeDYdckCIaz+Gjdo3R2puD5TyFrRfgjfMQpVUTZ1WseryOZ+InU5gaYKTFzd
         E8GDrC+t2VBp9+krVvxni/dJnhkEXVKFXr0y0sjrz+M7Bh+SxaJYpKImI5njQhmtqs2U
         AZSPApZ530NIwtwse6Cu0H51ZHvY12+vkVX/z8bUG3YOvNpfZikXMJCVDo/YCBbwHmD5
         ySGZetVL+n+zwhTgXq+BVF0ECJG29aHNq9v8aCnSQzR4xnPMvx8xUhnlmYS3vE4xvBmh
         tlFQ==
X-Gm-Message-State: ANhLgQ0BBQwsdsiWBXSgDQ8vawqvEafDwv2RXZO4A1TEPsI48U+19kqU
        hCNqbR74D8R41QrBVcvvUdzjVPRiw6HdDWkwxtszGDgirvN4X0thDvYXbmPWnqBxfNCOL6jZe+P
        1QlW6p190G/z1
X-Received: by 2002:a1c:9658:: with SMTP id y85mr6012859wmd.63.1584549447218;
        Wed, 18 Mar 2020 09:37:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuErvTnZoNeMlI+5nYQs8Cqq5KfLf5VuUoka93mGML+mnpnKCUgo64dYCWUTANi1F5x7RA5fg==
X-Received: by 2002:a1c:9658:: with SMTP id y85mr6012823wmd.63.1584549446877;
        Wed, 18 Mar 2020 09:37:26 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i4sm10411120wrm.32.2020.03.18.09.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:37:26 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 00/14] KVM: Dirty ring interface
Date:   Wed, 18 Mar 2020 12:37:06 -0400
Message-Id: <20200318163720.93929-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM branch:
  https://github.com/xzpeter/linux/tree/kvm-dirty-ring

QEMU branch for testing:
  https://github.com/xzpeter/qemu/tree/kvm-dirty-ring

v7
- rebase to kvm/queue
- make as_id an u16 [Sean]
- init_rmode_tss: rename idx to i, remove data init to zero [Sean]
- update doc for __x86_set_memory_region on ret value after rebase [Sean]
- fix sparse warnings for __x86_set_memory_region [syzbot]
- test cases [Drew]
  - use print_skip()
  - dump log modes without '\b'
  - support "all" log mode
  - exit(s/-1/1/)
  - assert gfns mmap in vcpu_map_dirty_ring
  - make vcpu_thread/current_vm static

For previous versions, please refer to:

V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
V3: https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com
V4: https://lore.kernel.org/kvm/20200205025105.367213-1-peterx@redhat.com
V5: https://lore.kernel.org/kvm/20200304174947.69595-1-peterx@redhat.com
V6: https://lore.kernel.org/kvm/20200309214424.330363-1-peterx@redhat.com

Overview
============

This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo
Bonzini on the KVM dirty ring interface.

The new dirty ring interface is another way to collect dirty pages for
the virtual machines. It is different from the existing dirty logging
interface in a few ways, majorly:

  - Data format: The dirty data was in a ring format rather than a
    bitmap format, so dirty bits to sync for dirty logging does not
    depend on the size of guest memory any more, but speed of
    dirtying.  Also, the dirty ring is per-vcpu, while the dirty
    bitmap is per-vm.

  - Data copy: The sync of dirty pages does not need data copy any more,
    but instead the ring is shared between the userspace and kernel by
    page sharings (mmap() on vcpu fd)

  - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
    KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses the new
    KVM_RESET_DIRTY_RINGS ioctl when we want to reset the collected
    dirty pages to protected mode again (works like
    KVM_CLEAR_DIRTY_LOG, but ring based).  To collecting dirty bits,
    we only need to read the ring data, no ioctl is needed.

Ring Layout
===========

KVM dirty ring is per-vcpu.  Each ring is an array of kvm_dirty_gfn
defined as:

struct kvm_dirty_gfn {
        __u32 flags;
        __u32 slot; /* as_id | slot_id */
        __u64 offset;
};

Each GFN is a state machine itself.  The state is embeded in the flags
field, as defined in the uapi header:

/*
 * KVM dirty GFN flags, defined as:
 *
 * |---------------+---------------+--------------|
 * | bit 1 (reset) | bit 0 (dirty) | Status       |
 * |---------------+---------------+--------------|
 * |             0 |             0 | Invalid GFN  |
 * |             0 |             1 | Dirty GFN    |
 * |             1 |             X | GFN to reset |
 * |---------------+---------------+--------------|
 *
 * Lifecycle of a dirty GFN goes like:
 *
 *      dirtied         collected        reset
 * 00 -----------> 01 -------------> 1X -------+
 *  ^                                          |
 *  |                                          |
 *  +------------------------------------------+
 *
 * The userspace program is only responsible for the 01->1X state
 * conversion (to collect dirty bits).  Also, it must not skip any
 * dirty bits so that dirty bits are always collected in sequence.
 */

Testing
=======

This series provided both the implementation of the KVM dirty ring and
the test case.  Also I've implemented the QEMU counterpart that can
run with the new KVM, link can be found at the top of the cover
letter.  However that's still a very initial version which is prone to
change and future optimizations.

I did some measurement with the new method with 24G guest running some
dirty workload, I don't see any speedup so far, even in some heavy
dirty load it'll be slower (e.g., when 800MB/s random dirty rate, kvm
dirty ring takes average of ~73s to complete migration while dirty
logging only needs average of ~55s).  However that's understandable
because 24G guest means only 1M dirty bitmap, that's still a suitable
case for dirty logging.  Meanwhile heavier workload means worst case
for dirty ring.

More tests are welcomed if there's bigger host/guest, especially on
COLO-like workload.

Please review, thanks.

Peter Xu (14):
  KVM: X86: Change parameter for fast_page_fault tracepoint
  KVM: Cache as_id in kvm_memory_slot
  KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
  KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
  KVM: X86: Implement ring-based dirty memory tracking
  KVM: Make dirty ring exclusive to dirty bitmap log
  KVM: Don't allocate dirty bitmap if dirty ring is enabled
  KVM: selftests: Always clear dirty bitmap after iteration
  KVM: selftests: Sync uapi/linux/kvm.h to tools/
  KVM: selftests: Use a single binary for dirty/clear log test
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test
  KVM: selftests: Add dirty ring buffer test
  KVM: selftests: Let dirty_log_test async for dirty ring test
  KVM: selftests: Add "-c" parameter to dirty log test

 Documentation/virt/kvm/api.rst                | 123 +++++
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/mmu/mmu.c                        |  10 +-
 arch/x86/kvm/mmutrace.h                       |   9 +-
 arch/x86/kvm/svm.c                            |   9 +-
 arch/x86/kvm/vmx/vmx.c                        |  89 +--
 arch/x86/kvm/x86.c                            |  50 +-
 include/linux/kvm_dirty_ring.h                | 103 ++++
 include/linux/kvm_host.h                      |  19 +
 include/trace/events/kvm.h                    |  78 +++
 include/uapi/linux/kvm.h                      |  53 ++
 tools/include/uapi/linux/kvm.h                |  99 +++-
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 505 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  68 +++
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +
 virt/kvm/dirty_ring.c                         | 195 +++++++
 virt/kvm/kvm_main.c                           | 162 +++++-
 22 files changed, 1460 insertions(+), 138 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

-- 
2.24.1

