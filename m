Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535C33E82D3
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhHJSUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 14:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhHJSTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 14:19:05 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8ACC0619D4
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 11:00:46 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c11-20020ac87dcb0000b0290293566e00b1so5739255qte.15
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 11:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZDsAyuyusmciA2jiuLhkX1nPCmYyecrodVye11rLd9Q=;
        b=W4lyCmEWtEn5ycLPtZ5uDc3331Cbl+GU78dXD1fIggb7r5XOIzNGFYWRQs/u4ouCxr
         bChbsah2+heDHScZ+z8ZCwUR/DBMW0rNIiY6Yr5AzqX6g2A5tiKpJTo1InBQJKDRQLPk
         xgdnRvjZAjEOzkYtFHu1MR0+Dsxh9im01Y3ujy1hUCTUVTRnzwxs3ykAD/rvSbYJTkSF
         YvzJKYt7XXknwvMQUUYaI7fs7u+pCOrEJpzduqIoptGwjrmuDgjNpUwYo9O5KhmSPpIU
         xF+CtkWMIKFrXtJdErkMNHI+inLWCKGYbYggu5I37fao0dBXvPUdAwyj3svkVoMsH2w1
         zsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZDsAyuyusmciA2jiuLhkX1nPCmYyecrodVye11rLd9Q=;
        b=qnGl6wI7FwZLzJl7yq7piFG/5wCQbiugv7ZGc2bSFN5ww5ITRaW+4Fl+0Vl8NSRvXu
         Lq9eUJ+Tq12zVplosMVZn844kXPxcvVxMD4y3Rli4q7qUdYhHtb/jvOvOyIPQw4BJqqX
         U5BGd+rRjqslzloKygx2GoosdPkAQZ0DNY/JVO8TstL9LZvKiCmwnydcS3Ycrk+ou2U+
         E69icUo98oXmnWxvXDydiuetnhFJ7dezTAPK7D3DPsi26jIDZbGXb8ob69ze2LLxlOF3
         AoiMpvefoqIGitRc6LDltaFGBXtGiiDqMgozIFflEQvxCYyQsX5syBH+ypxrRYfJQGV8
         K2YQ==
X-Gm-Message-State: AOAM531ZMI6HOsf9D5O8zOmJAmlvICWgCeGjGC+1jE2Rxhs6kpsSTt7v
        +mUkThgKaK9pjklKmknzlFh91jwUTABTXIFFmt04VwMcM+mtQQyae+BKJZRR+VCsUy3YHEbbyW3
        +ieqdgJO7W/VQ/YIkRNlKxxkLTgKRl5L8/9aTTHww4awz1m4yifeHh6dWiWOBo5jYWnFA6BY=
X-Google-Smtp-Source: ABdhPJyiek44iHjdvj08SYsBGaFQYUJXKpN8kPEeKzUx8QYEIxcpDdQzWI3zurb29W8usy1UnVj1TDmnJ8MDSx4PTg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:1c47:: with SMTP id
 if7mr19170630qvb.6.1628618445702; Tue, 10 Aug 2021 11:00:45 -0700 (PDT)
Date:   Tue, 10 Aug 2021 18:00:42 +0000
Message-Id: <20210810180042.453089-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] KVM: stats: Remove unnecessary value store
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <rong.a.chen@intel.com>
Cc:     Jing Zhang <jingzhangos@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variables 'remain' and 'dest' don't need to be updated in the end.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 virt/kvm/binary_stats.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index e609d428811a..eefca6c69f51 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -136,9 +136,7 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		src = stats + pos - header->data_offset;
 		if (copy_to_user(dest, src, copylen))
 			return -EFAULT;
-		remain -= copylen;
 		pos += copylen;
-		dest += copylen;
 	}
 
 	*offset = pos;

base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
-- 
2.32.0.605.g8dce9f2422-goog

