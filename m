Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3973B128676
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfLUBtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:49:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39150 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbfLUBtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xpJ+lIL1WdaXz/BCzKHdKAiz9jNb7HE3HwznYCminRs=;
        b=MsId0a/6j24DN63B/5fJ2wpFEAVesDYxlh50HwUTZ6Ca5SevTDHhBCpEjDpX6RNfNh4jEf
        n5cbQ/wkHqHksFZBvkihQcW2t6waKjDny+/BnVyS8XuwJjnbOo0hGBSPoNWxOLTaSkC3xU
        7S1sa81UxT3rE2KsvUfh2935Jp8pfpk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-E78Z2xGcMoajxeW9d4Pt7g-1; Fri, 20 Dec 2019 20:49:43 -0500
X-MC-Unique: E78Z2xGcMoajxeW9d4Pt7g-1
Received: by mail-qt1-f199.google.com with SMTP id m30so7206939qtb.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpJ+lIL1WdaXz/BCzKHdKAiz9jNb7HE3HwznYCminRs=;
        b=c18e8rKSv8325pvrQMU+fALYc7WN/wrlvlWhuo6mWrkTfZ3voksgLxTUb7azUWNsWl
         4EAusXHn8X4d/xehpTzZZMNUDdX0dvN/Xvb2Q3K2lk2+0c2EkQHY/KMFoZOvxFvbeY4k
         84DPFZX4JEuZBc7Zm86/ftXJFTenbaJQh25AKtpKXiq1NwvqUBn1SMaf4GsHRS+/0fBJ
         GIRtogrktcTFQJcX6AKL8OxXtbuVhItR6YaVs5KR4iXzvY7g5mH5EEyqFMcYk7ZUFqv4
         sGnVSw/vKE2CatJltaAlD+J3CGj3nJpcoDRv90iYJzKmnx4/hYMLO+JSOcvGHJYRpupy
         zD4w==
X-Gm-Message-State: APjAAAXFK5zzUm/iXcQXnpruG589RY4gIdafXxIVGl2KwsuAFlXb1aqd
        SH7OnSuwgE6Y4IpAlW0Vq5OG9M8cMB3KbopKtEiTi2W4Xk7lM3V/wIA62aSSy7KgNnKDsMz5yMJ
        H4DYtvC/+4ZPH
X-Received: by 2002:a37:674a:: with SMTP id b71mr16718552qkc.471.1576892982601;
        Fri, 20 Dec 2019 17:49:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqzfv9xjdg8Jai4eu6KsWDYVzIgo0LO/qzp6gAZdszcZHmYwWLIVMeCSfyKeBtV2i0p9e1hhTg==
X-Received: by 2002:a37:674a:: with SMTP id b71mr16718528qkc.471.1576892982219;
        Fri, 20 Dec 2019 17:49:42 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:41 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 00/17] KVM: Dirty ring interface
Date:   Fri, 20 Dec 2019 20:49:21 -0500
Message-Id: <20191221014938.58831-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
(based on 5.4.0)

This is v2 of the dirty ring series, and also the first non-RFC
version of it.  I didn't put a changelog from v1-rfc because I feel
like it would be easier to go into the patchset comparing to read that
lengthy and probably helpless changelog.  However I do like to do a
summary here on what has majorly changed, and also some conclusions on
the previous v1 discussions.

======================

* Per-vm ring is dropped

For x86 (which is still the major focus for now), we found that kvmgt
is probably the only one that still writes to the guest without a vcpu
context.  It would be a complete pity if we keep the per-vm ring only
for kvmgt (who shouldn't write directly to guest via kvm api after
all...), so remove it.  Work should be ongoing in parallel to refactor
kvmgt to not use kvm apis like kvm_write_guest().

However I don't want to break kvmgt before it's fixed.  So this series
uses an interim way to solve this by fallback no-vcpu-context writes
to vcpu0 if there is.  So we will keep the interface clean (per-vcpu
only), while we don't break the code base.  After kvmgt is fixed, we
can probably even drop this special fallback and kvm->dirty_ring_lock.

* Waitqueue is still kept (for now)

We did plan to drop the waitqueue, however again if with kvmgt we
still have chance to ful-fill a ring (and I feel like it'll definitely
happen if we migrate a kvmgt guest).  This series will only trigger
the waitqueue mechanism if it's the special case (no-vcpu-context) and
actually it naturally avoids another mmu lock deadlock issue I've
encountered, which is good.

For vcpu context writes, now the series is even more strict that we'll
directly fail the KVM_RUN if the dirty ring is soft full, until the
userspace collects the dirty rings first.  That'll guarantee the ring
will never be full.  With that, I dropped KVM_REQ_DIRTY_RING_FULL
together because then it's not needed.

Potentially this could still also be used by ARM when there're code
paths that dump the ARM device information to the guests
(e.g. KVM_DEV_ARM_ITS_SAVE_TABLES).  We'll see.  No matter what, even
if the code is there, x86 (as long as without kvmgt) should never
trigger waitqueue.

Although the waitqueue is kept, I dropped the complete waitqueue test,
simply because now I can never trigger it without kvmgt...

* Why not virtio?

There's already some discussion during v1 patchset on whether it's
good to use virtio for the data path of delivering dirty pages [1].
I'd confess the only thing that we might consider to use is the vring
layout (because virtqueue is tightly bound to devices, while we don't
have a device contet here), however it's a pity that even we only use
the most low-level vring api it'll be at least iov based which is
already an overkill for dirty ring (which is literally an array of
addresses).  So I just kept things easy.

======================

About the patchset:

Patch 1-5:    Mostly cleanups
Patch 6,7:    Prepare for the dirty ring interface
Patch 8-10:   Dirty ring implementation (majorly patch 8)
Patch 11-17:  Test cases update

Please have a look, thanks.

[1] V1 is here: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com

Paolo Bonzini (1):
  KVM: Move running VCPU from ARM to common code

Peter Xu (16):
  KVM: Remove kvm_read_guest_atomic()
  KVM: X86: Change parameter for fast_page_fault tracepoint
  KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
  KVM: Cache as_id in kvm_memory_slot
  KVM: Add build-time error check on kvm_run size
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

 Documentation/virt/kvm/api.txt                |  96 ++++
 arch/arm/include/asm/kvm_host.h               |   2 -
 arch/arm64/include/asm/kvm_host.h             |   2 -
 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/mmu.c                            |   6 +
 arch/x86/kvm/mmutrace.h                       |   9 +-
 arch/x86/kvm/vmx/vmx.c                        |  25 +-
 arch/x86/kvm/x86.c                            |   9 +
 include/linux/kvm_dirty_ring.h                |  57 +++
 include/linux/kvm_host.h                      |  44 +-
 include/trace/events/kvm.h                    |  78 ++++
 include/uapi/linux/kvm.h                      |  31 ++
 tools/include/uapi/linux/kvm.h                |  36 ++
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 420 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  64 +++
 .../selftests/kvm/lib/kvm_util_internal.h     |   3 +
 virt/kvm/arm/arch_timer.c                     |   2 +-
 virt/kvm/arm/arm.c                            |  29 --
 virt/kvm/arm/perf.c                           |   6 +-
 virt/kvm/arm/vgic/vgic-mmio.c                 |  15 +-
 virt/kvm/dirty_ring.c                         | 201 +++++++++
 virt/kvm/kvm_main.c                           | 269 +++++++++--
 27 files changed, 1274 insertions(+), 145 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 virt/kvm/dirty_ring.c

-- 
2.24.1

