Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5E14CEA9C
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 11:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiCFKzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 05:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiCFKzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 05:55:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 495835131D
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 02:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646564086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6C+14RT/WBu/+yhSoFqCrDNXOq/wjuT0/qYJr4t18Zo=;
        b=NtGEoeSWuWyC4w8LVSEho9ZdhEKlYyB+WyGwV3cWAm4jUrRf62KEtIKtnevOVERPo6Pctt
        JtEEoqj+wLz8UJ+ebjev8FqBmWCddutipPOQ1s4PfOU/PwmXzjhxHnN7BcPCSMY/FUMQ9T
        dZAanj+AS46O+X8tbxdZymmw3ECYxbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-p2wh5w0zNHCENBnLgi_j4A-1; Sun, 06 Mar 2022 05:54:41 -0500
X-MC-Unique: p2wh5w0zNHCENBnLgi_j4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2F78659;
        Sun,  6 Mar 2022 10:54:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73B271F467;
        Sun,  6 Mar 2022 10:54:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More KVM fixes for Linux 5.17-rc7
Date:   Sun,  6 Mar 2022 05:54:39 -0500
Message-Id: <20220306105439.141939-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit ece32a75f003464cad59c26305b4462305273d70:

  Merge tag 'kvmarm-fixes-5.17-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-02-25 09:49:30 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8d25b7beca7ed6ca34f53f0f8abd009e2be15d94:

  KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run (2022-03-02 10:55:58 -0500)

----------------------------------------------------------------
x86 guest:

* Tweaks to the paravirtualization code, to avoid using them
when they're pointless or harmful

x86 host:

* Fix for SRCU lockdep splat

* Brown paper bag fix for the propagation of errno

----------------------------------------------------------------
Dexuan Cui (1):
      x86/kvmclock: Fix Hyper-V Isolated VM's boot issue when vCPUs > 64

Li RongQing (1):
      KVM: x86: Yield to IPI target vCPU only if it is busy

Like Xu (1):
      KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()

Paolo Bonzini (1):
      KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run

Wanpeng Li (2):
      x86/kvm: Don't use PV TLB/yield when mwait is advertised
      x86/kvm: Don't waste memory if kvmclock is disabled

 arch/x86/kernel/kvm.c      |  4 +++-
 arch/x86/kernel/kvmclock.c |  3 +++
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/x86.c         | 25 +++++++++++++------------
 4 files changed, 20 insertions(+), 14 deletions(-)

