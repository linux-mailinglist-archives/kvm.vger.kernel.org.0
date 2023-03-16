Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBFE6BC293
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjCPAbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjCPAb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:31:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09722A219F
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l1-20020a170903244100b001a0468b4afcso18668pls.12
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678926679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vx2+K6b7VucsfYU5uvwShdem3MP0VCFQdKNh537WPsg=;
        b=EA4KfJjpxzMBA8ocOUJxskwPBqMOEPIbHdsbcZbccXhBPZcwGYtMOllXq3ZDv1ORrB
         QiGXSeCrawIV7Ob35Ad38AzhJQ6BmfNPeqo9bO2jMmgbTKuCwOKW52r8qmivCl54zpk4
         88+8R8AG50cALhrkX6rRkPAgkUbqtisQ5dY73WaxL3k9+gqFrwu9ZnTOHigxZwCRoFw5
         oEoLsQ0vn6DI5C8JkbS3LjnqPEppdpTWdzwEEBPNvCCLSrBJZbkjPpf2Wve4VtPR3n5N
         YKB4fD3PfGLhtkzjKoNrJ8iamdLexrkhHgeNyx0cQIIYAFnZZoWRNc9PQUU2ONHo7FAf
         gprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vx2+K6b7VucsfYU5uvwShdem3MP0VCFQdKNh537WPsg=;
        b=N3MRl1WA63EWKNqI6RbogItEbyIoQHgQlBGtRXMeITqBdXggOqnF4QjHRgAYDrSYs3
         Bzo+dKZBus9fWODkhk7cQINAcRKszsPh4h5P+JXerGvGWpuNYeMp122LsNH1qql0xlWo
         QcXi3yBrxjhyOaIr6gXxUhAosMetsY1xcp+BQJnxZd7gOasWHbxv2qEb6mdyzb03T25O
         6U00BoGxMXLXKTRVH2jrQVxDGt3DmlhCI6cfgKKLOD7nYjkUIOm/vsc9iL6Os21341yQ
         5RdWBBDM6eIuNY15r8ZzT6GV+skPfGb1TiEKSnVb/F/BNmnma0ETtKLgRrHhXud+1lQl
         Lvfg==
X-Gm-Message-State: AO0yUKVzYEAGPpUu+IRMqlnYwokE5/4woANdb1xYoFLYkBZQ5CXiQegJ
        8KyY7cDAseVmVYXgs8HM5eH3z/oAytduJqoL/7TrRWX3+u19wU85UAcxk/n1DSpmeaLpnldyBOc
        sAmdrN4cITXt7WSn0vPaTKY3jvwhb67Qjdp/V+jUFKJ+EDsbv6+lf6JMU9yVMt1Y8+vbamCU=
X-Google-Smtp-Source: AK7set8pxVyKhYzeYJbLh/hwRd4Uu3vEs7a87hlm2FvbWgBf9tOHOVoa9Y6GzuIXe4LVFtgGHHuaVLgOE52DzxfEww==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a05:6a00:23d6:b0:625:cf6d:b272 with
 SMTP id g22-20020a056a0023d600b00625cf6db272mr580538pfc.6.1678926678685; Wed,
 15 Mar 2023 17:31:18 -0700 (PDT)
Date:   Thu, 16 Mar 2023 00:30:55 +0000
In-Reply-To: <cover.1678926164.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1678926164.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <75eba82a2666b0caa96ed0484a713037045ed114.1678926164.git.ackerleytng@google.com>
Subject: [RFC PATCH 02/10] KVM: selftests: Test that ftruncate to
 non-page-aligned size on a restrictedmem fd should fail
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/vm/memfd_restricted.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/vm/memfd_restricted.c b/tools/testing/selftests/vm/memfd_restricted.c
index 43a512f273f7..9c4e6a0becbc 100644
--- a/tools/testing/selftests/vm/memfd_restricted.c
+++ b/tools/testing/selftests/vm/memfd_restricted.c
@@ -38,6 +38,11 @@ static void test_file_size(int fd)
 {
 	struct stat sb;
 
+	if (!ftruncate(fd, page_size + 1)) {
+		fail("ftruncate to non page-aligned sizes should fail\n");
+		return;
+	}
+
 	if (ftruncate(fd, page_size)) {
 		fail("ftruncate failed\n");
 		return;
-- 
2.40.0.rc2.332.ga46443480c-goog

