Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38686C3B7C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCUUQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCUUQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:16:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7CE584B3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:15:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-540e3b152a3so165222827b3.2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679429743;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2RhtQenWH6Mmh2njKfsOonde6iRcUbhqsfef2trssA=;
        b=ClsvgBBQATzAxtG/gc1hzpVY/T+GSviFU2hQ3UKtZoAsyandd9FyD0yLb8NrYb4ht5
         SjtxnaoAhF4efqeapcNFyLaolp7WuoQPSmenPl/8ik0fPXK6e1hl1CvxZlDyMrPane5r
         fKwlNoMJeTEnq6d0rODj32nRgmEVAapEIm14QQbT2B15KQCKXBU8ZxvcGJRNsRJvZ4XJ
         N7XPNKxQAOD73Y8xeXSFPjjlY/0SBVySAIzu81k2G9C9QAT2ZJCKSCBBuQ2KwvixcfrJ
         ivc7vv8kYOIZBHtRp+n3DWGDyx9grB8qOG4vEqKagJpOh84jSbdFmOXnwsKkeo5zHbWB
         s0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679429743;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2RhtQenWH6Mmh2njKfsOonde6iRcUbhqsfef2trssA=;
        b=3KYNGB4c+1YAfg/nY/fbIhPKbKN9pjt/85vqozOGw9aux/gPtE0b9RBw2V+y9NlxpY
         PqvAzpf9W9X1ksUw5kruFsOo0HpuzcUon4NTEiv9a+d+gIDceT9T/Ra4q+eM+I3huyqV
         MvQ4FD6W/7uMi42H2RW3AWQKNs6gjFDzmJ5r5jRs5KzGdmMSf6q7NdWm51vnM+ityzlD
         Em3jxUffGRz897QAiYm7x2DTQVMM4ViJV7cUkbARgxTR5UGZLQ16wveRYVUcgDD0MO/M
         3tvvWTd1Q2TAZwJdSKHprQ+85W+p1b5LLfofBVOA3RQWaMQhzc4IPbVEK8YKChGoBnJV
         2u5A==
X-Gm-Message-State: AO0yUKUIJv/XqrBEUiAnYaVcio8OoX/7HdebVJH5pN7ZkLsQTeh+aB4i
        DmfQDRTJ5SMGI8MSD4X7Olv8M+skqKone+Yj5Z4Qr8kpFoZrHwGJwm6NnTirrg0PPYrCFb50nYW
        CTFX+boDRRFjXip8DOdrhJS+tMVn8k6SYhN3jV35AmG5zetQXuqKIvmdzUprF7CWgK1rgsxk=
X-Google-Smtp-Source: AK7set/rS/BOrm2SUEMWHr+PlfeqSewwcb3Q0X8SWpfhSHb/ZXYj5MKa4Pc4uyKe/dNqM06Z778BYQX2stVtaLtYJQ==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:d88:b0:544:bbd2:74be with
 SMTP id da8-20020a05690c0d8800b00544bbd274bemr11229418ywb.4.1679429742690;
 Tue, 21 Mar 2023 13:15:42 -0700 (PDT)
Date:   Tue, 21 Mar 2023 20:15:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <cover.1679428901.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 0/2] Providing mount in memfd_restricted() syscall
From:   Ackerley Tng <ackerleytng@google.com>
To:     kvm@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, qemu-devel@nongnu.org
Cc:     aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org,
        arnd@arndb.de, bfields@fieldses.org, bp@alien8.de,
        chao.p.peng@linux.intel.com, corbet@lwn.net, dave.hansen@intel.com,
        david@redhat.com, ddutile@redhat.com, dhildenb@redhat.com,
        hpa@zytor.com, hughd@google.com, jlayton@kernel.org,
        jmattson@google.com, joro@8bytes.org, jun.nakajima@intel.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        luto@kernel.org, mail@maciej.szmigiero.name, mhocko@suse.com,
        michael.roth@amd.com, mingo@redhat.com, naoya.horiguchi@nec.com,
        pbonzini@redhat.com, qperret@google.com, rppt@kernel.org,
        seanjc@google.com, shuah@kernel.org, steven.price@arm.com,
        tabba@google.com, tglx@linutronix.de, vannapurve@google.com,
        vbabka@suse.cz, vkuznets@redhat.com, wanpengli@tencent.com,
        wei.w.wang@intel.com, x86@kernel.org, yu.c.zhang@linux.intel.com,
        Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patchset builds upon the memfd_restricted() system call that was
discussed in the 'KVM: mm: fd-based approach for supporting KVM' patch
series, at
https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.int=
el.com/T/#m7e944d7892afdd1d62a03a287bd488c56e377b0c

The tree can be found at:
https://github.com/googleprodkernel/linux-cc/tree/restrictedmem-provide-mou=
nt-fd

In this patchset, a modification to the memfd_restricted() syscall is
proposed, which allows userspace to provide a mount, on which the
restrictedmem file will be created and returned from the
memfd_restricted().

Allowing userspace to provide a mount allows userspace to control
various memory binding policies via tmpfs mount options, such as
Transparent HugePage memory allocation policy through
'huge=3Dalways/never' and NUMA memory allocation policy through
'mpol=3Dlocal/bind:*'.

Changes since RFCv1:
+ Use fd to represent mount instead of path string, as Kirill
  suggested. I believe using fds makes this syscall interface more
  aligned with the other syscalls like fsopen(), fsconfig(), and
  fsmount() in terms of using and passing around fds
+ Remove unused variable char *orig_shmem_enabled from selftests

Dependencies:
+ Sean's iteration of the =E2=80=98KVM: mm: fd-based approach for supportin=
g
  KVM=E2=80=99 patch series at
  https://github.com/sean-jc/linux/tree/x86/upm_base_support
+ Proposed fixes for these issues mentioned on the mailing list:
    + https://lore.kernel.org/lkml/diqzzga0fv96.fsf@ackerleytng-cloudtop-sg=
.c.googlers.com/

Links to earlier patch series:
+ RFC v1:
  https://lore.kernel.org/lkml/cover.1676507663.git.ackerleytng@google.com/=
T/

Ackerley Tng (2):
  mm: restrictedmem: Allow userspace to specify mount for
    memfd_restricted
  selftests: restrictedmem: Check hugepage-ness of shmem file backing
    restrictedmem fd

 include/linux/syscalls.h                      |   2 +-
 include/uapi/linux/restrictedmem.h            |   8 +
 mm/restrictedmem.c                            |  63 ++-
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/restrictedmem/.gitignore        |   3 +
 .../testing/selftests/restrictedmem/Makefile  |  15 +
 .../testing/selftests/restrictedmem/common.c  |   9 +
 .../testing/selftests/restrictedmem/common.h  |   8 +
 .../restrictedmem_hugepage_test.c             | 459 ++++++++++++++++++
 9 files changed, 561 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/restrictedmem.h
 create mode 100644 tools/testing/selftests/restrictedmem/.gitignore
 create mode 100644 tools/testing/selftests/restrictedmem/Makefile
 create mode 100644 tools/testing/selftests/restrictedmem/common.c
 create mode 100644 tools/testing/selftests/restrictedmem/common.h
 create mode 100644 tools/testing/selftests/restrictedmem/restrictedmem_hug=
epage_test.c

--
2.40.0.rc2.332.ga46443480c-goog
