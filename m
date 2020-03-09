Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765FC17EB69
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCIVod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:44:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgCIVod (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 17:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583790271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+ICtR2v0xNomH1WLkex46Nm+YSPs83aCqTW2zuVdMA4=;
        b=KfggPge5R51zEnrozMLwxsTSWUAjVuCTznd3SN1LJhpj8GOs8BtmvloEFdB4wlXOasRvCZ
        0CFcakKCEkA8Yu9xMNlfzd3o/YoyMTLlZafN53U9S9xBddwjHWNVogRt00dKC+eUrbDC0b
        jkU29E7vuTNPHqEswmktUx8X/2dsHeQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-02TW3aEKNF-67w_EybCobQ-1; Mon, 09 Mar 2020 17:44:27 -0400
X-MC-Unique: 02TW3aEKNF-67w_EybCobQ-1
Received: by mail-qt1-f198.google.com with SMTP id b10so3710100qto.21
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ICtR2v0xNomH1WLkex46Nm+YSPs83aCqTW2zuVdMA4=;
        b=AqGhFe7oj97K/d1UQVwpQ5PNCQcydKoc0OJkXkVEg2AFdc0qYkjzJ8j7Ti7NS38p8c
         GNlwZrXnO8VkXd4IZASPQCKU4TyIzocq238lD3jD+IbfVeizOReAea1SQpRNh9w8W5FE
         tO8oLafbFq8RK1mwqdOFaUkM2lqLws5v5zH5FuNBF51SdGm5zAqiBikrgSpc3GrZrnif
         rXJHaL7/IOihG4S/lO6dV8RbWqRQCjeBFmsRpL+yGSKKiGq6UfiFxQOd+pdHtoNDb0H+
         OiN3+jiVM7gMOe5YdAK9whbZJUsW6U7Sj650gvpfD0SCTYZNqaNXzRV/IcYhiHhP5nXi
         bOUg==
X-Gm-Message-State: ANhLgQ26Rg1LVcw7+32Lc7Nt3sjuyqdYOF7yUwbwbQ/J+qsQ56Vi5i25
        8UePRWW1omx0kMsXJ77PMifpqeBkzH8/u7+hDaUNnZuIeLYybFEAJAbNuYBcidtwEdKWUDCYKd1
        SwFM8+0yGZYSQ
X-Received: by 2002:a37:4ec1:: with SMTP id c184mr2019112qkb.0.1583790266997;
        Mon, 09 Mar 2020 14:44:26 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vstAS1kAHk1yzYK0Qv2/bUTpVaVnkqEMcxpVeMGOT8PFcgZlWN3qpoiuGO6oI0meC5+JHYWaw==
X-Received: by 2002:a37:4ec1:: with SMTP id c184mr2019077qkb.0.1583790266685;
        Mon, 09 Mar 2020 14:44:26 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 82sm10504502qko.91.2020.03.09.14.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:44:25 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 00/14] KVM: Dirty ring interface
Date:   Mon,  9 Mar 2020 17:44:10 -0400
Message-Id: <20200309214424.330363-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM branch:=0D
  https://github.com/xzpeter/linux/tree/kvm-dirty-ring=0D
=0D
QEMU branch for testing:=0D
  https://github.com/xzpeter/qemu/tree/kvm-dirty-ring=0D
=0D
v6:=0D
- fix typo in test case (LOG_MODE_CLERA_LOG) [Dave]=0D
- fix s390 build (again), by moving kvm_reset_dirty_gfn into=0D
  kvm_dirty_ring.c, with some macro movements [syzbot]=0D
=0D
For previous versions, please refer to:=0D
=0D
V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com=0D
V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com=0D
V3: https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com=0D
V4: https://lore.kernel.org/kvm/20200205025105.367213-1-peterx@redhat.com=0D
V5: https://lore.kernel.org/kvm/20200304174947.69595-1-peterx@redhat.com=0D
=0D
Overview=0D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
=0D
This is a continued work from Lei Cao <lei.cao@stratus.com> and Paolo=0D
Bonzini on the KVM dirty ring interface.=0D
=0D
The new dirty ring interface is another way to collect dirty pages for=0D
the virtual machines. It is different from the existing dirty logging=0D
interface in a few ways, majorly:=0D
=0D
  - Data format: The dirty data was in a ring format rather than a=0D
    bitmap format, so dirty bits to sync for dirty logging does not=0D
    depend on the size of guest memory any more, but speed of=0D
    dirtying.  Also, the dirty ring is per-vcpu, while the dirty=0D
    bitmap is per-vm.=0D
=0D
  - Data copy: The sync of dirty pages does not need data copy any more,=0D
    but instead the ring is shared between the userspace and kernel by=0D
    page sharings (mmap() on vcpu fd)=0D
=0D
  - Interface: Instead of using the old KVM_GET_DIRTY_LOG,=0D
    KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses the new=0D
    KVM_RESET_DIRTY_RINGS ioctl when we want to reset the collected=0D
    dirty pages to protected mode again (works like=0D
    KVM_CLEAR_DIRTY_LOG, but ring based).  To collecting dirty bits,=0D
    we only need to read the ring data, no ioctl is needed.=0D
=0D
Ring Layout=0D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
=0D
KVM dirty ring is per-vcpu.  Each ring is an array of kvm_dirty_gfn=0D
defined as:=0D
=0D
struct kvm_dirty_gfn {=0D
        __u32 flags;=0D
        __u32 slot; /* as_id | slot_id */=0D
        __u64 offset;=0D
};=0D
=0D
Each GFN is a state machine itself.  The state is embeded in the flags=0D
field, as defined in the uapi header:=0D
=0D
/*=0D
 * KVM dirty GFN flags, defined as:=0D
 *=0D
 * |---------------+---------------+--------------|=0D
 * | bit 1 (reset) | bit 0 (dirty) | Status       |=0D
 * |---------------+---------------+--------------|=0D
 * |             0 |             0 | Invalid GFN  |=0D
 * |             0 |             1 | Dirty GFN    |=0D
 * |             1 |             X | GFN to reset |=0D
 * |---------------+---------------+--------------|=0D
 *=0D
 * Lifecycle of a dirty GFN goes like:=0D
 *=0D
 *      dirtied         collected        reset=0D
 * 00 -----------> 01 -------------> 1X -------+=0D
 *  ^                                          |=0D
 *  |                                          |=0D
 *  +------------------------------------------+=0D
 *=0D
 * The userspace program is only responsible for the 01->1X state=0D
 * conversion (to collect dirty bits).  Also, it must not skip any=0D
 * dirty bits so that dirty bits are always collected in sequence.=0D
 */=0D
=0D
Testing=0D
=3D=3D=3D=3D=3D=3D=3D=0D
=0D
This series provided both the implementation of the KVM dirty ring and=0D
the test case.  Also I've implemented the QEMU counterpart that can=0D
run with the new KVM, link can be found at the top of the cover=0D
letter.  However that's still a very initial version which is prone to=0D
change and future optimizations.=0D
=0D
I did some measurement with the new method with 24G guest running some=0D
dirty workload, I don't see any speedup so far, even in some heavy=0D
dirty load it'll be slower (e.g., when 800MB/s random dirty rate, kvm=0D
dirty ring takes average of ~73s to complete migration while dirty=0D
logging only needs average of ~55s).  However that's understandable=0D
because 24G guest means only 1M dirty bitmap, that's still a suitable=0D
case for dirty logging.  Meanwhile heavier workload means worst case=0D
for dirty ring.=0D
=0D
More tests are welcomed if there's bigger host/guest, especially on=0D
COLO-like workload.=0D
=0D
Please review, thanks.=0D
=0D
Peter Xu (14):=0D
  KVM: X86: Change parameter for fast_page_fault tracepoint=0D
  KVM: Cache as_id in kvm_memory_slot=0D
  KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]=0D
  KVM: Pass in kvm pointer into mark_page_dirty_in_slot()=0D
  KVM: X86: Implement ring-based dirty memory tracking=0D
  KVM: Make dirty ring exclusive to dirty bitmap log=0D
  KVM: Don't allocate dirty bitmap if dirty ring is enabled=0D
  KVM: selftests: Always clear dirty bitmap after iteration=0D
  KVM: selftests: Sync uapi/linux/kvm.h to tools/=0D
  KVM: selftests: Use a single binary for dirty/clear log test=0D
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test=0D
  KVM: selftests: Add dirty ring buffer test=0D
  KVM: selftests: Let dirty_log_test async for dirty ring test=0D
  KVM: selftests: Add "-c" parameter to dirty log test=0D
=0D
 Documentation/virt/kvm/api.rst                | 123 +++++=0D
 arch/x86/include/asm/kvm_host.h               |   6 +-=0D
 arch/x86/include/uapi/asm/kvm.h               |   1 +=0D
 arch/x86/kvm/Makefile                         |   3 +-=0D
 arch/x86/kvm/mmu/mmu.c                        |  10 +-=0D
 arch/x86/kvm/mmutrace.h                       |   9 +-=0D
 arch/x86/kvm/svm.c                            |   9 +-=0D
 arch/x86/kvm/vmx/vmx.c                        |  85 +--=0D
 arch/x86/kvm/x86.c                            |  49 +-=0D
 include/linux/kvm_dirty_ring.h                | 103 ++++=0D
 include/linux/kvm_host.h                      |  19 +=0D
 include/trace/events/kvm.h                    |  78 +++=0D
 include/uapi/linux/kvm.h                      |  53 ++=0D
 tools/include/uapi/linux/kvm.h                |  44 ++=0D
 tools/testing/selftests/kvm/Makefile          |   2 -=0D
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -=0D
 tools/testing/selftests/kvm/dirty_log_test.c  | 488 ++++++++++++++++--=0D
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +=0D
 tools/testing/selftests/kvm/lib/kvm_util.c    |  67 +++=0D
 .../selftests/kvm/lib/kvm_util_internal.h     |   4 +=0D
 virt/kvm/dirty_ring.c                         | 195 +++++++=0D
 virt/kvm/kvm_main.c                           | 164 +++++-=0D
 22 files changed, 1393 insertions(+), 125 deletions(-)=0D
 create mode 100644 include/linux/kvm_dirty_ring.h=0D
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c=0D
 create mode 100644 virt/kvm/dirty_ring.c=0D
=0D
-- =0D
2.24.1=0D
=0D

