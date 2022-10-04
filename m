Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333AD5F4C62
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 01:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJDXFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 19:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJDXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 19:05:48 -0400
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAA68275EF
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 16:05:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-005-115.95.117.pool.telefonica.de [95.117.5.115])
        by csgraf.de (Postfix) with ESMTPSA id 295E46080113;
        Wed,  5 Oct 2022 00:56:45 +0200 (CEST)
From:   Alexander Graf <agraf@csgraf.de>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 0/3] Add TCG & KVM support for MSR_CORE_THREAD_COUNT
Date:   Wed,  5 Oct 2022 00:56:40 +0200
Message-Id: <20221004225643.65036-1-agraf@csgraf.de>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 027ac0cb516 ("target/i386/hvf: add rdmsr 35H
MSR_CORE_THREAD_COUNT") added support for the MSR_CORE_THREAD_COUNT MSR
to HVF. This MSR is mandatory to execute macOS when run with -cpu
host,+hypervisor.

This patch set adds support for the very same MSR to TCG as well as
KVM - as long as host KVM is recent enough to support MSR trapping.

With this support added, I can successfully execute macOS guests in
KVM with an APFS enabled OVMF build, a valid applesmc plus OSK and

  -cpu Skylake-Client,+invtsc,+hypervisor


Alex

Alexander Graf (3):
  x86: Implement MSR_CORE_THREAD_COUNT MSR
  i386: kvm: Add support for MSR filtering
  KVM: x86: Implement MSR_CORE_THREAD_COUNT MSR

 target/i386/kvm/kvm.c                | 145 +++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h           |  11 ++
 target/i386/tcg/sysemu/misc_helper.c |   5 +
 3 files changed, 161 insertions(+)

-- 
2.37.0 (Apple Git-136)

