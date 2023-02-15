Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6D697360
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjBOBSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjBOBSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:18:06 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A67C3431C
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:17:47 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id h11-20020a056a00230b00b00593b9e6ee79so8740614pfh.8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676423866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uRPhNs2fvcPvmeVYvLM8FnThh5hezg+ueTPGVBYG8fI=;
        b=c7vHfv1/77aNFSSJ5A4BvFatprB1Qu2jQQwElF3DwWOJkpZmSMUCxsO5U5i40pok3F
         n3Bc7iphM7viH8wkgL8bK0oSqHHvWTv2zdzXERTQ4rJ0BCl5kHqHdNcsMLIEugDQMRrf
         QMxagDnepS9VA0f1bOLsnUZqoZzzqKP2YfRzxZwOix1FnwrUHiNwKCvwXSwnL9UHLsKM
         Z0qx7LTybCY4KlB00I9T1bIc/oor++0BSCan6bkAhE65yeQPgkCqwrPGTzVUiGdnzvHW
         nsDqjRDS60yLpR7FpUDFbuxtjHfrW5Otz3Jo6R/dRAjDhMH8KFgkr83IjNHMIn20nKew
         wy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676423866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRPhNs2fvcPvmeVYvLM8FnThh5hezg+ueTPGVBYG8fI=;
        b=QZZficp4EU4OzkIO+3cJaRCn5DtyeUXK2Vi+vBRZNg0d53DZuxHmVxBBJtRDsg9aeZ
         mgvdspsAOjaz2Gugkj5ar43BKK74lZASprHPjZkl9TIpl5MUtwoWDmdJDN2a2JKOVof2
         v7eZsFux9glw2zkk01fCl+5EGvi1NahA0FKcqVslPAefUd6GNrrCD++6qZj0jkMOQ6+S
         rWWU1fJBQCls6go5g+q65aXpHJHzckOlcO1HoeiXfalSITJIiUyaL7S9EGGflfEaWqG+
         5ibNDF/PXXZ5w8kOxfcn7DOvXG2dX8BjiGdCnwt8zX8I3MOLRtNtxKtT8lg7cMl3lW4B
         IsSQ==
X-Gm-Message-State: AO0yUKW/HuRxktXizw6oY8Ev3xatR5ZV5HSDlVvcv6fK964WctpDVanF
        2g9mu8z40VttRwAstawV9Fxp0E5VWBI=
X-Google-Smtp-Source: AK7set8oxYUjhOh1jb1xrjurh28uErk0YuuJG6nxR5HDgo0GkR1A1Ksy7Ptkdaoeqd4aXi20VUtFKoagldc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8ecd:0:b0:5a8:be84:3ba8 with SMTP id
 b13-20020aa78ecd000000b005a8be843ba8mr21006pfr.46.1676423317418; Tue, 14 Feb
 2023 17:08:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:16 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM selftests changes for 6.3.  The highlight is Vishal's work to stop relying
on KVM to patch in VMMCALL when running on AMD.

There's one small series to cleanup the Xen shinfo test that I didn't grab, but
that arguably could/should go into 6.3:

  https://lore.kernel.org/all/20230204024151.1373296-1-seanjc@google.com


The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.3

for you to fetch changes up to 695fa5a64cf52ab1aa2c89c93bbb1fd08995304a:

  KVM: selftests: Remove duplicate macro definition (2023-02-08 06:53:14 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.3:

 - Cache the CPU vendor (AMD vs. Intel) and use the info to emit the correct
   hypercall instruction instead of relying on KVM to patch in VMMCALL

 - A variety of one-off cleanups and fixes

----------------------------------------------------------------
Aaron Lewis (1):
      KVM: selftests: Fix a typo in the vcpu_msrs_set assert

Gavin Shan (2):
      KVM: selftests: Remove duplicate VM creation in memslot_perf_test
      KVM: selftests: Assign guest page size in sync area early in memslot_perf_test

Jing Zhang (1):
      KVM: selftests: Stop assuming stats are contiguous in kvm_binary_stats_test

Michal Luczaj (1):
      KVM: selftests: Clean up misnomers in xen_shinfo_test

Reiji Watanabe (1):
      KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should close fd

Shaoqin Huang (2):
      selftests: KVM: Replace optarg with arg in guest_modes_cmdline
      KVM: selftests: Remove duplicate macro definition

Vishal Annapurve (3):
      KVM: selftests: x86: Use "this_cpu" prefix for cpu vendor queries
      KVM: selftests: x86: Cache host CPU vendor (AMD vs. Intel)
      KVM: selftests: x86: Use host's native hypercall instruction in kvm_hypercall()

zhang songyi (1):
      KVM: x86/xen: Remove unneeded semicolon

 .../selftests/kvm/include/x86_64/processor.h       | 30 ++++++++++++--
 .../testing/selftests/kvm/kvm_binary_stats_test.c  | 10 +----
 tools/testing/selftests/kvm/lib/elf.c              |  2 +
 tools/testing/selftests/kvm/lib/guest_modes.c      |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  3 --
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 46 ++++++++++------------
 tools/testing/selftests/kvm/memslot_perf_test.c    |  5 +--
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |  4 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       |  2 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |  4 +-
 .../vmx_exception_with_invalid_guest_state.c       |  2 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 15 +++----
 12 files changed, 63 insertions(+), 62 deletions(-)
