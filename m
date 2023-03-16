Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB46BC289
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbjCPAbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbjCPAbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:31:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588E59F061
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i7-20020a626d07000000b005d29737db06so169627pfc.15
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678926673;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hT7y2XaFexWW4GTLeQpLaRg79NNFfwA0Go2glRLgBd0=;
        b=N3FCbOb23ou0MR9YDAguhm+QUSLW64t2U/7PPQUqV0UHXOSSwZIRzXKjdSOcMLpgxY
         jX1wEFqBqTSgtmw1W+c2YHMygh8Dbwr2N9F0I3exfyzRcEzxWz9HhNb82ApkF/z8x7Ga
         cL/eC/XkctgAsiVP/AFxutYKeKSXMsBQtApF1kHqJwwo2mE0jmFNyLPZZefA3FOunQK+
         xAil55WrnoGGzEmFfPLG/uP4zJDBBDkBk3wABf0O3gP3lWCt9RSd9GzvAl/5Kpgdg854
         w0RKIJY23ID+CBvF1DCydnX+07kHwg1xqKJjc1NRlI49QEjeGmOai55QnIAWqKYhUX7F
         esvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926673;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hT7y2XaFexWW4GTLeQpLaRg79NNFfwA0Go2glRLgBd0=;
        b=FOlPBWwqnexTDXnkFSxFMFHGJWcDEty7vLn40vcoC/bg2qd507f2dUSgZtwmhFnzpX
         nIolLisf+8TlVDba8X/YzA90AS0FpzqphSuFH9xjSyZJNU7uCMgfMMsUIJfecwEWXp5m
         0BYg1f6N0YfLgaViHW0EbnGtuvgM1/hUl1UY6GvPaLiQ84bC2fAwR9gerSJMOXse0G8p
         TwlUhDQsK/ZrjzoqM3MIxfZAsJsquCAzUAIx6LgzhM2n8IPMM4d5+KCc7orqDorr+SjN
         3NsTBv2pnCg+NcRYe2vEvqal5s4o6EKeiT8WgnwgER/UZ6mie0Rd6f5VO9WxiiaxPVdF
         Ft/g==
X-Gm-Message-State: AO0yUKXdeHbISshqtYANmCA5Rb3ZEiWarc2SMMbhwW7lmCDBMkoxV9rP
        YmsyO8DlYgPrk2+BFBgDHKtbsvZ6FprsLpID7gAXXV2ccCKgfBpzL5penN0SS9j5cQVXxkeSF8R
        ynIMCiK/lrPkPZF8U39gS4xa72vrcENGyPPjZT4A8oNrGi6t7s/9zJg2xKTQfd8mATbUazI4=
X-Google-Smtp-Source: AK7set8RzBYOsHbOBr2r5L/IBVJur+dXP5lqulE2m7qrJjHyB4MEFVa/vv90/0ZD7J2Luh92QLgQMrMQJM0g7dhFsw==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a17:90a:ea89:b0:237:2516:f76a with
 SMTP id h9-20020a17090aea8900b002372516f76amr548955pjz.2.1678926672510; Wed,
 15 Mar 2023 17:31:12 -0700 (PDT)
Date:   Thu, 16 Mar 2023 00:30:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <cover.1678926164.git.ackerleytng@google.com>
Subject: [RFC PATCH 00/10] Additional selftests for restrictedmem
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

This is a series containing additional selftests for restrictedmem,
prepared to be used with the next iteration of the restrictedmem
series after v10.

restrictedmem=C2=A0v10 is available at
https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.int=
el.com/T/.

The tree can be found at
https://github.com/googleprodkernel/linux-cc/tree/restrictedmem-additional-=
selftests-rfc-v1/.

Dependencies
+ The next iteration of the restrictedmem series
    + branch: https://github.com/chao-p/linux/commits/privmem-v11.4
    + commit: https://github.com/chao-p/linux/tree/ddd2c92b268a2fdc6158f82a=
6169ad1a57f2a01d
+ Proposed fix to adjust VM's initial stack address to align with SysV
  ABI spec: https://lore.kernel.org/lkml/20230227180601.104318-1-ackerleytn=
g@google.com/

Ackerley Tng (10):
  KVM: selftests: Test error message fixes for memfd_restricted
    selftests
  KVM: selftests: Test that ftruncate to non-page-aligned size on a
    restrictedmem fd should fail
  KVM: selftests: Test that VM private memory should not be readable
    from host
  KVM: selftests: Exercise restrictedmem allocation and truncation code
    after KVM invalidation code has been unbound
  KVM: selftests: Generalize private_mem_conversions_test for parallel
    execution
  KVM: selftests: Default private_mem_conversions_test to use 1 memslot
    for test data
  KVM: selftests: Add vm_userspace_mem_region_add_with_restrictedmem
  KVM: selftests: Default private_mem_conversions_test to use 1
    restrictedmem file for test data
  KVM: selftests: Add tests around sharing a restrictedmem fd
  KVM: selftests: Test KVM exit behavior for private memory/access

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  46 ++-
 .../selftests/kvm/set_memory_region_test.c    |  29 +-
 .../kvm/x86_64/private_mem_conversions_test.c | 295 +++++++++++++++---
 .../kvm/x86_64/private_mem_kvm_exits_test.c   | 124 ++++++++
 tools/testing/selftests/vm/memfd_restricted.c |   9 +-
 7 files changed, 455 insertions(+), 53 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_kvm_exit=
s_test.c

--
2.40.0.rc2.332.ga46443480c-goog
