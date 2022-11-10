Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8241B624A65
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiKJTOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKJTOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF41275DB
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9541EB82314
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC41C433C1;
        Thu, 10 Nov 2022 19:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107641;
        bh=T79CFtYcyb6c1mZV9P2/O70KOCeYCcKUaMZB5RbWzdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M71ylMGIDoqohUmZgQHkfUullJTju+MiiJxtGl2+/DK3+Qe5lxPAOrA0bVmDx8pME
         TObqBbsw343dZSNcM+pdNcOA2W8p7uCF8r/VeNwnIb8aG8eSRO1hHzUb9G+ASqce+m
         CsOmTLmoxv+Ca+xzaCi56t1cLcxbQ+RGppq5plgPxP4kJJP7l46E/O1C8oOXHrIc4A
         QFbnsFVJpTwQ6zWpp84hWIWB/6XtPto7eP5f+LIlpRImONfGI/zz9i+DlZNBJQWJn4
         +5SqLoaK/TFPwCCUDIdcoeam5e7EQDyTmFYy3IFrrsQZFo6WP+bms9uIc3S/UBbkY1
         pONGyRuYZrC/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otCzu-005Ekr-OL;
        Thu, 10 Nov 2022 19:13:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu
Cc:     bgardon@google.com, oupton@google.com, reijiw@google.com,
        pbonzini@redhat.com, eric.auger@redhat.com, rananta@google.com,
        axelrasmussen@google.com, alexandru.elisei@arm.com,
        dmatlack@google.com, seanjc@google.com
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Date:   Thu, 10 Nov 2022 19:13:53 +0000
Message-Id: <166810762188.3361918.17667021556485650781.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: andrew.jones@linux.dev, kvm@vger.kernel.org, ricarkol@google.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, bgardon@google.com, oupton@google.com, reijiw@google.com, pbonzini@redhat.com, eric.auger@redhat.com, rananta@google.com, axelrasmussen@google.com, alexandru.elisei@arm.com, dmatlack@google.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Oct 2022 19:58:20 +0000, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling
> for various combinations of guest accesses (e.g., write, S1PTW), backing
> sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> hole, write on a readonly memslot). Each test tries a different combination
> and then checks that the access results in the right behavior (e.g., uffd
> faults with the right address and write/read flag). Some interesting
> combinations are:
> 
> [...]

Applied to next, thanks!

[01/14] KVM: selftests: Add a userfaultfd library
        commit: a93871d0ea9fd59fb5eb783619334183d7f07f51
[02/14] KVM: selftests: aarch64: Add virt_get_pte_hva() library function
        commit: 228f324dc718f702e8777164c4e2e7426824fb13
[03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
        commit: b6b03b86c0250a80b671313dbc0d7bcdbab78f41
[04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h macros
        commit: 41f5189ea9c08f7fc28340a7aefc93d0d2dcb769
[05/14] tools: Copy bitfield.h from the kernel sources
        commit: 590b949597b1e811d35df2f32021dd17d8e47f8c
[06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
        commit: bd3ed7e1a47eb7b3838ca09439f1eb289ec3be1f
[07/14] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
        commit: 290c5b54012b7f05e9c51af32d557574bf69a654
[08/14] KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and vm_vaddr_alloc()
        commit: 5485e822e31a75dfac3713d94b6b22025d4895da
[09/14] KVM: selftests: Use the right memslot for code, page-tables, and data allocations
        commit: 1446e331432d7f24ed56b870ad605a4345fee43f
[10/14] KVM: selftests: aarch64: Add aarch64/page_fault_test
        commit: 35c5810157124cb71aaa939cd2d5508192714877
[11/14] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
        commit: 3b1d915659c64dce079f4926a648f2271faea008
[12/14] KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
        commit: a4edf25b3e25656c69cbc768d1c704868e4a616f
[13/14] KVM: selftests: aarch64: Add readonly memslot tests into page_fault_test
        commit: 45acde40f538a30e759f3b3f4aa5089edf097b2f
[14/14] KVM: selftests: aarch64: Add mix of tests into page_fault_test
        commit: ff2b5509e1d252cd18bb1430b5461d5044701559

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


