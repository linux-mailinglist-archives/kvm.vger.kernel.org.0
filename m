Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8670135C06
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbgAIO5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729136AbgAIO5h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dTjYPWrRS50vXb+awZBlOczchH8zUZfJ4o80FlJt42o=;
        b=LmG0qflDS9+mBFF78IGeryXTToe5g3DYUFgajGm/nOdssoPk8ZDH8Dgn0fQA0dqMYsVVgP
        yrbF8ENkYMkFDvb9ZoqVG7RmXuBTn/pg9rBmqcFEW72wtKQ0JrUrxQMHYXdF+1oznqMmDX
        f8xBVe46Ody5u20J9Fdm9tTDoe42u5E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-azuK9gvbPPyN0B6Tn0RgAA-1; Thu, 09 Jan 2020 09:57:34 -0500
X-MC-Unique: azuK9gvbPPyN0B6Tn0RgAA-1
Received: by mail-qt1-f200.google.com with SMTP id d18so4352372qtp.16
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dTjYPWrRS50vXb+awZBlOczchH8zUZfJ4o80FlJt42o=;
        b=N5aZlGEIxRSzHDl4msPObiG7COIeZOSCTGgDIlxuLWCGt3NAPIwm8UeqzoDs/wF7OA
         3ohSf20bR6Z0rAbiP3s9GfRfl94pLpPV/LGQIwr1GPTYBJ6CIPA33Hod+eyP4Sij0JXf
         DguuzSnje5aCzAxB955fJnkfgw1AiOALAMcz1zB+Vd//eoQbH0ZcIIfeRT/r5CEGmvdd
         Jy1feDSWNbNQhNJmrvE1zvxk8pLuO9/ii8tddMv1LeGQQCxFwTOtU7DMPO7Bt4X0eD9Y
         EGAMdVKFaXic/oyDuE3q3js/QCFCe/ze6FDvICslTB68SHOJ0nQWNu0wX59Pf3OhG/Wi
         gg/A==
X-Gm-Message-State: APjAAAW4oHiVJYZ9Ck4aUEfuSZJCPtJAQr7bOgGosCSrtpWkGU1LCh0f
        r39dg8D0bDRmlTpDOmed42MKnPDD6V9I8jzPMqYhxftp2pdYP01uPJu6Vhg9QORpJ6xGuGs0NQa
        Yk/it4bLo3cZQ
X-Received: by 2002:ae9:f442:: with SMTP id z2mr10147929qkl.130.1578581852981;
        Thu, 09 Jan 2020 06:57:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvlKadDyijtWYeJ2Wd9k4rTi/vdyU+ZnfMwnSTOg0LZPt/qEGbYJRt3o/7E1ao7PmCs8P0Ng==
X-Received: by 2002:ae9:f442:: with SMTP id z2mr10147895qkl.130.1578581852605;
        Thu, 09 Jan 2020 06:57:32 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:31 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 00/21] KVM: Dirty ring interface
Date:   Thu,  9 Jan 2020 09:57:08 -0500
Message-Id: <20200109145729.32898-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
(based on kvm/queue)

Please refer to either the previous cover letters, or documentation
update in patch 12 for the big picture.  Previous posts:

V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com

The major change in V3 is that we dropped the whole waitqueue and the
global lock. With that, we have clean per-vcpu ring and no default
ring any more.  The two kvmgt refactoring patches were also included
to show the dependency of the works.

Patchset layout:

Patch 1-2:         Picked up from kvmgt refactoring
Patch 3-6:         Small patches that are not directly related,
                   (So can be acked/nacked/picked as standalone)
Patch 7-11:        Prepares for the dirty ring interface
Patch 12:          Major implementation
Patch 13-14:       Quick follow-ups for patch 8
Patch 15-21:       Test cases

V3 changelog:

- fail userspace writable maps on dirty ring ranges [Jason]
- commit message fixups [Paolo]
- change __x86_set_memory_region to return hva [Paolo]
- cacheline align for indices [Paolo, Jason]
- drop waitqueue, global lock, etc., include kvmgt rework patchset
- take lock for __x86_set_memory_region() (otherwise it triggers a
  lockdep in latest kvm/queue) [Paolo]
- check KVM_DIRTY_LOG_PAGE_OFFSET in kvm_vm_ioctl_enable_dirty_log_ring
- one more patch to drop x86_set_memory_region [Paolo]
- one more patch to remove extra srcu usage in init_rmode_identity_map()
- add some r-bs for Paolo

Please review, thanks.

Paolo Bonzini (1):
  KVM: Move running VCPU from ARM to common code

Peter Xu (18):
  KVM: Remove kvm_read_guest_atomic()
  KVM: Add build-time error check on kvm_run size
  KVM: X86: Change parameter for fast_page_fault tracepoint
  KVM: X86: Don't take srcu lock in init_rmode_identity_map()
  KVM: Cache as_id in kvm_memory_slot
  KVM: X86: Drop x86_set_memory_region()
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

Yan Zhao (2):
  vfio: introduce vfio_iova_rw to read/write a range of IOVAs
  drm/i915/gvt: subsitute kvm_read/write_guest with vfio_iova_rw

 Documentation/virt/kvm/api.txt                |  96 ++++
 arch/arm/include/asm/kvm_host.h               |   2 -
 arch/arm64/include/asm/kvm_host.h             |   2 -
 arch/x86/include/asm/kvm_host.h               |   7 +-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/mmu/mmu.c                        |   6 +
 arch/x86/kvm/mmutrace.h                       |   9 +-
 arch/x86/kvm/svm.c                            |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  86 ++--
 arch/x86/kvm/x86.c                            |  43 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  25 +-
 drivers/vfio/vfio.c                           |  45 ++
 drivers/vfio/vfio_iommu_type1.c               |  81 ++++
 include/linux/kvm_dirty_ring.h                |  55 +++
 include/linux/kvm_host.h                      |  37 +-
 include/linux/vfio.h                          |   5 +
 include/trace/events/kvm.h                    |  78 ++++
 include/uapi/linux/kvm.h                      |  33 ++
 tools/include/uapi/linux/kvm.h                |  38 ++
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 420 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  72 +++
 .../selftests/kvm/lib/kvm_util_internal.h     |   3 +
 virt/kvm/arm/arch_timer.c                     |   2 +-
 virt/kvm/arm/arm.c                            |  29 --
 virt/kvm/arm/perf.c                           |   6 +-
 virt/kvm/arm/vgic/vgic-mmio.c                 |  15 +-
 virt/kvm/dirty_ring.c                         | 162 +++++++
 virt/kvm/kvm_main.c                           | 215 +++++++--
 32 files changed, 1379 insertions(+), 208 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

-- 
2.24.1

