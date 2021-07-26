Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA123D66CE
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGZSAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhGZSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 14:00:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78F6C061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:41:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id nn2-20020a17090b38c2b02901738be23a47so1103826pjb.7
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iEmiK8Z2pf1Smw+rofDrwaZXK2WpNJEBwftoW1LRiJo=;
        b=FYQIip9d4viByvDmbXAF3NaBRNWa3pbSBKRHDqmiOKEXS/NX2SxDWrm/ptdtS4h7UG
         79WMEe1q7yHzPmMz/hHisngDjdF3IOjk68nffGqGyVRopv3NykusOYdU+mq1HZ4XHuQ/
         K49l6ZRa/kISjgt0DiwDu6SYaomjmzzXiOc+ZVRJuLb3dRZlPSsu4V9PSYNlID+50g1R
         a1fJq0D8DUhXAn1vaGxI4OgqrJqbsuibpsKgk+vPfA5dcMiYKNV5e2VWTue4a1Pqo/Gp
         Dm/bWehxUQ6vQwYPpvqJ5qJHloPNGZ6qFhIZvQezoQ2z9JpDak6SZgLYcm4GszUk5bmB
         RKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iEmiK8Z2pf1Smw+rofDrwaZXK2WpNJEBwftoW1LRiJo=;
        b=k00Zf2OkJn2d2bsD3AYnYpaA4N4ZS9ddmwse+fG9Gtc9Ryy8+XFehNVQXuomFHD6DH
         6JUPwX9MSyiA3V65a9W+UeOBk4aFovkHqZPt8CVe/OojT52R4h+OD7OnM9w0bRpqzf8S
         FXHk6rkQ/NOLUM262Sr8FSCsgpUDAbtWb+wwoaOgewlV3et+GkuJ5zxyojC+xT4EjP79
         8yys6hxGcX/KmVm55mVMoyNTSP3HlnILvX9V/vQfJ8RRxz7eHtnKDEyKN2cGr5uG8KGj
         eFY32UPuCR6r1Lg4wOJ3Q47uabCHG4ctd/Ok7lX0d5quNRMAnEhk7ejArZi3MouMzo9P
         Md6Q==
X-Gm-Message-State: AOAM532vwBj4AaB94H+DMrkzIDsuWTU4m4/bLXyota1carzgSzpt4plO
        s8nCZlb7QaFO4BH7wlD6JDGDS2ZH5IjVYGwj
X-Google-Smtp-Source: ABdhPJwhyw2nDMfdUBXFrDmSb5jH2sLfPxtEUlcwhkFsZvtG0pnBJ5f7eIcUAw0aasQ0PV8e/dbbCXMyJSv055Nd
X-Received: from nehir.kir.corp.google.com ([2620:15c:29:204:e222:115f:790c:cd0f])
 (user=erdemaktas job=sendgmr) by 2002:a17:90a:7789:: with SMTP id
 v9mr19208144pjk.159.1627324881416; Mon, 26 Jul 2021 11:41:21 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:37:53 -0700
Message-Id: <20210726183816.1343022-1-erdemaktas@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [RFC PATCH 0/4] TDX KVM selftests
From:   Erdem Aktas <erdemaktas@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     erdemaktas@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        David Matlack <dmatlack@google.com>,
        Like Xu <like.xu@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX stands for Trust Domain Extensions which isolates VMs from the
virtual-machine manager (VMM)/hypervisor and any other software on the
platform.

Intel has recently submitted a set of RFC patches for KVM support for
TDX and more information can be found on the latest TDX Support 
Patches: https://lkml.org/lkml/2021/7/2/558

Due to the nature of the confidential computing environment that TDX
provides, it is very difficult to verify/test the KVM support. TDX
requires UEFI and the guest kernel to be enlightened which are all under
development.

We are working on a set of selftests to close this gap and be able to
verify the KVM functionality to support TDX lifecycle and GHCI [1]
interface.

We are looking for any feedback on:
- Patch series itself
- Any suggestion on how we should approach testing TDX functionality.
Does selftests seems reasonable or should we switch to using KVM
unit tests. I would be happy to get some perspective on how KVM unit
tests can help us more.
- Any test case or scenario that we should add.
- Anything else I have not thought of yet.

Current patch series provide the following capabilities:

- Provide helper functions to create a TD (Trusted Domain) using the KVM
  ioctls
- Provide helper functions to create a guest image that can include any
  testing code
- Provide helper functions and wrapper functions to write testing code
  using GHCI interface
- Add a test case that verifies TDX life cycle 
- Add a test case that verifies TDX GHCI port IO 

TODOs:
- Use existing function to create page tables dynamically 
  (ie __virt_pg_map())
- Remove arbitrary defined magic numbers for data structure offsets
- Add TDVMCALL for error reporting
- Add additional test cases as some listed below
- Add #VE handlers to help testing more complicated test cases

Other test cases that we are planning to add:
(with credit to sagis@google.com)

VM call interface        Input                        Output                Result
GetTdVmCallInfo          R12=0                        None                VMCALL_SUCCESS
MapGPA                   Map private page (GPA.S=0)                       VMCALL_SUCCESS
MapGPA                   Map shared page (GPA.S=1)                        VMCALL_SUCCESS
MapGPA                   Map already private page as private              VMCALL_INVALID_OPERAND
MapGPA                   Map already shared page as shared                VMCALL_INVALID_OPERAND
GetQuote                        
ReportFatalError                        
SetupEventNotifyInterrupt   Valid interrupt value (32:255)                 VMCALL_SUCCESS
SetupEventNotifyInterrupt   Invalid value (>255)                          VMCALL_INVALID_OPERAND
Instruction.CPUID        R12(EAX)=1, R13(ECX)=0       EBX[8:15]=0x8        
                                                      EBX[16:23]=X        
                                                      EBX[24:31]=vcpu_id        
                                                      ECX[0]=1        
                                                      ECX[12]=Y        
Instruction.CPUID       R12(EAX)=1, R13(ECX)=4                            VMCALL_INVALID_OPERAND
VE.RequestMMIO                        
Instruction.HLT                                                           VMCALL_SUCCESS
Instruction.IO          Read/Write 1/2/4 bytes                            VMCALL_SUCCESS
Instruction.IO          Read/Write 3 bytes                                VMCALL_INVALID_OPERAND
Instruction.RDMSR       Accessible register           R11=msr_value       VMCALL_SUCCESS
                        Inaccessible register                             VMCALL_INVALID_OPERAND
Instruction.RDMSR       Accessible register                               VMCALL_SUCCESS
                        Inaccessible register                             VMCALL_INVALID_OPERAND
INSTRUCTION.PCONFIG                        

[1] Intel TDX Guest-Hypervisor Communication Interface
    https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf


Erdem Aktas (4):
  KVM: selftests: Add support for creating non-default type VMs
  KVM: selftest: Add helper functions to create TDX VMs
  KVM: selftest: Adding TDX life cycle test.
  KVM: selftest: Adding test case for TDX port IO

 tools/testing/selftests/kvm/Makefile          |   6 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  29 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  23 ++
 tools/testing/selftests/kvm/lib/x86_64/tdx.h  | 220 ++++++++++++
 .../selftests/kvm/lib/x86_64/tdx_lib.c        | 314 ++++++++++++++++++
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 209 ++++++++++++
 8 files changed, 800 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/tdx.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/tdx_lib.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c

-- 
2.32.0.432.gabb21c7263-goog

