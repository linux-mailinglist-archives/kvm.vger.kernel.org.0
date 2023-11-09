Return-Path: <kvm+bounces-1370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8CAE7E733F
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F91FB21016
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047C138DE1;
	Thu,  9 Nov 2023 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Y9ycm4y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA38D374DE
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:44 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C234F46B1
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:43 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7d261a84bso18619247b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563823; x=1700168623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Md8awSTbxdliEndjHBRSvaM0UbkXbzycQQEoteYw9Tc=;
        b=0Y9ycm4y/3xf8sk9ZFzus83L5v0vk1DvDokawmnvuc1PrRrsduwYRT4wUDEEzQdJbU
         0SFaGjrrgQwKlh3eLCX29Y1sv5P7jkXxFqiuy6jU0lZ+BI5DY5UtBau5l+LZ/Z0Mqfot
         wjhZVTxN0lbNOFJEYuWOujTUoD7PDEDfOZnO8iK4OUloBeYpEN4P/ewC9NVALIZbWe1j
         P8jAJwr+20s2c38S5vQviZspfkCIMk5XrM6lefIyg519sQX+B8FiZ0RkLnp37yg7okis
         xiUHeF3EKSQLvbkh0dTrt4s7dmxzjMsbP51fg1v/GoDXltvAdI2iBccmngUDd/GPUwmg
         EgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563823; x=1700168623;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Md8awSTbxdliEndjHBRSvaM0UbkXbzycQQEoteYw9Tc=;
        b=D561uOO9SRXG3mb9SDTsPJuewkjL+IMoPvBzHlRFSzdU58nEfTw3e3BIZEh8SPcShe
         pWB0KMNfeg22q7xTkJpz7fhjyTVL+1pO38Ji1xWuVuD7hbImRrx34lvshc5oFFVv3OCF
         PN5X8p6NQUTnG3Qu+pFg9F5ipbqhCqncESrAgx+Jry6UEXoIKteVLrBrBTwgSpB6JWcg
         xCbmozL8dz3AgRrJb6s/k+3ctQhsbU/EdFFuNZXGjxmq/laMGoNHdRt+McyXK2LP2+LU
         Wj2D+KtDItnBhboteJ8IvyTRSzah8hvelZ/5cY++F0vWhk0BYtf/02Q3WUA3Yw2Lvhq9
         g37Q==
X-Gm-Message-State: AOJu0YzJdxj9Z+s/+bVnzJv4bl1sSOjGkxOURjVB/rYi2VkmO3Tn+YjY
	NyoMOQqLIsrfFcPagOsQpuThmd5KAr01Uw==
X-Google-Smtp-Source: AGHT+IHazvMpaROGKsZ1EdyOYmyWtakXaPvGow3k+KCEXn7elKNcy7SpAS0xnJiwHKh3oL++JOhdlVVRPcsYag==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:490:0:b0:da3:7a5c:69bb with SMTP id
 n16-20020a5b0490000000b00da37a5c69bbmr153713ybp.8.1699563822927; Thu, 09 Nov
 2023 13:03:42 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-1-amoorthy@google.com>
Subject: [PATCH v6 00/14] Improve KVM + userfaultfd performance via
 KVM_MEMORY_FAULT_EXITs on stage-2 faults
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

This series adds an option to cause stage-2 fault handlers to
KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
the userspace mappings. Doing so allows userspace to receive stage-2
faults directly from KVM_RUN instead of through userfaultfd, which
suffers from serious contention issues as the number of vCPUs scales.

Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
demand_paging_test, which demonstrates the scalability improvements:
the following data was collected using [2] on an x86 machine with 256
cores.

vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
1       150     340
2       191     477
4       210     809
8       155     1239
16      130     1595
32      108     2299
64      86      3482
128     62      4134
256     36      4012

TODO
~~~~
No known issues/things to resolve. However, documentation/commit logs
merit a close look given how much feedback I've received on those :/

Base Commit
~~~~~~~~~~~
This series is based off of kvm/next (45b890f7689e) with v14 of the
guest_memfd series applied, with some fixes on top [3].

Links
~~~~~
[1] Original RFC from James Houghton:
    https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/

[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables the new capabilities.
    All data was collected after applying the entire series

[3] https://lore.kernel.org/kvm/20231105163040.14904-1-pbonzini@redhat.com/T/#m56361120ee1dd5265a5710e6a814906cda8e1020
    The following fixes are required to get the KVM selftests to compile
    on arm64
    - https://lore.kernel.org/kvm/20231108233723.3380042-1-amoorthy@google.com/
    - https://lore.kernel.org/kvm/affca7a8-116e-4b0f-9edf-6cdc05ba65ca@redhat.com/
    - Unguarding the definitions of MEM_REGION_GPA/SLOT in set_memory_region_test
      (not sure if this is the "right" fix for that test, but it compiles)

---

v6
  - Rebase onto guest_memfd series [Anish/Sean]
  - Set write fault flag properly in user_mem_abort() [Oliver]
  - Reformat unnecessarily multi-line comments [Sean]
  - Drop the kvm_vcpu_read|write_guest_page() annotations [Sean]
  - Rename *USERFAULT_ON_MISSING to *EXIT_ON_MISSING [David]
  - Remove unnecessary rounding in user_mem_abort() annotation [David]
  - Rewrite logs for KVM_MEM_EXIT_ON_MISSING patches and squash
    them with the stage-2 fault annotation patches [Sean]
  - Undo the enum parameter addition to __gfn_to_pfn_memslot(), and just
    add another boolean parameter instead [Sean]
  - Better shortlog for the hva_to_pfn_fast() change [Anish]

v5: https://lore.kernel.org/kvm/20230908222905.1321305-1-amoorthy@google.com/
  - Rename APIs (again) [Sean]
  - Initialize hardware_exit_reason along w/ exit_reason on x86 [Isaku]
  - Reword hva_to_pfn_fast() change commit message [Sean]
  - Correct style on terminal if statements [Sean]
  - Switch to kconfig to signal KVM_CAP_USERFAULT_ON_MISSING [Sean]
  - Add read fault flag for annotated faults [Sean]
  - read/write_guest_page() changes
      - Move the annotations into vcpu wrapper fns [Sean]
      - Reorder parameters [Robert]
  - Rename kvm_populate_efault_info() to
    kvm_handle_guest_uaccess_fault() [Sean]
  - Remove unnecessary EINVAL on trying to enable memory fault info cap [Sean]
  - Correct description of the faults which hva_to_pfn_fast() can now
    resolve [Sean]
  - Eliminate unnecessary parameter added to __kvm_faultin_pfn() [Sean]
  - Magnanimously accept Sean's rewrite of the handle_error_pfn()
    annotation [Anish]
  - Remove vcpu null check from kvm_handle_guest_uaccess_fault [Sean]

v4: https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google.com/T/#t
  - Fix excessive indentation [Robert, Oliver]
  - Calculate final stats when uffd handler fn returns an error [Robert]
  - Remove redundant info from uffd_desc [Robert]
  - Fix various commit message typos [Robert]
  - Add comment about suppressed EEXISTs in selftest [Robert]
  - Add exit_reasons_known definition for KVM_EXIT_MEMORY_FAULT [Robert]
  - Fix some include/logic issues in self test [Robert]
  - Rename no-slow-gup cap to KVM_CAP_NOWAIT_ON_FAULT [Oliver, Sean]
  - Make KVM_CAP_MEMORY_FAULT_INFO informational-only [Oliver, Sean]
  - Drop most of the annotations from v3: see
    https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.com/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf
  - Remove WARN on bare efaults [Sean, Oliver]
  - Eliminate unnecessary UFFDIO_WAKE call from self test [James]

v3: https://lore.kernel.org/kvm/ZEBXi5tZZNxA+jRs@x1n/T/#t
  - Rework the implementation to be based on two orthogonal
    capabilities (KVM_CAP_MEMORY_FAULT_INFO and
    KVM_CAP_NOWAIT_ON_FAULT) [Sean, Oliver]
  - Change return code of kvm_populate_efault_info [Isaku]
  - Use kvm_populate_efault_info from arm code [Oliver]

v2: https://lore.kernel.org/kvm/20230315021738.1151386-1-amoorthy@google.com/

    This was a bit of a misfire, as I sent my WIP series on the mailing
    list but was just targeting Sean for some feedback. Oliver Upton and
    Isaku Yamahata ended up discovering the series and giving me some
    feedback anyways, so thanks to them :) In the end, there was enough
    discussion to justify retroactively labeling it as v2, even with the
    limited cc list.

  - Introduce KVM_CAP_X86_MEMORY_FAULT_EXIT.
  - API changes:
        - Gate KVM_CAP_MEMORY_FAULT_NOWAIT behind
          KVM_CAP_x86_MEMORY_FAULT_EXIT (on x86 only: arm has no such
          requirement).
        - Switched to memslot flag
  - Take Oliver's simplification to the "allow fast gup for readable
    faults" logic.
  - Slightly redefine the return code of user_mem_abort.
  - Fix documentation errors brought up by Marc
  - Reword commit messages in imperative mood

v1: https://lore.kernel.org/kvm/20230215011614.725983-1-amoorthy@google.com/

Anish Moorthy (14):
  KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic'
    parameter
  KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
  KVM: Simplify error handling in __gfn_to_pfn_memslot()
  KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
    userspace
  KVM: Try using fast GUP to resolve read faults
  KVM: Add memslot flag to let userspace force an exit on missing hva
    mappings
  KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
    stage-2 fault handler
  KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
  KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from
    stage-2 fault-handler
  KVM: selftests: Report per-vcpu demand paging rate from demand paging
    test
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  33 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |   7 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |   8 +-
 include/linux/kvm_host.h                      |  21 +-
 include/uapi/linux/kvm.h                      |   5 +
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  46 ++-
 22 files changed, 444 insertions(+), 175 deletions(-)

-- 
2.42.0.869.gea05f2083d-goog


