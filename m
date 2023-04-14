Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB096E18B2
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 02:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDNAMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 20:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjDNAME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 20:12:04 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF1B3A86
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:12:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s77-20020a632c50000000b0050300a8089aso7017407pgs.0
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681431123; x=1684023123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkEj6q2IVKaYOP6wiiRLnj5ts2mBBZa+OIxL/GSTf98=;
        b=pcqniXtkoDuhBj1ErtiII5whYlqQKXls/eD75GxmwIVIT7IwHWM98je58mpaXvIHy3
         LpccSvtbLgAwcQZ8TwFwfgCX+ja4wUnKGA+h3WXVMEJOUUL2qBKR7YK0YIAIEO3pvgN1
         zW9QD8IGt6VEqoGPuqy1/S2tnc5hXy3msytIg5tT1Iqc1O/eLvazMFAHHJLgLEji9/Xc
         cM4/zrEVhrQXx6DBuORdlMp7jDyh/8S9e0xS/0Cs9WtOtn3b/TqstaJnZYkbovPSZruG
         /rQS9quj0Ux7V6cvIHkjY9Q+6FLYkk97nxdO9WMuM45XYHm0E4b9E/REWMpXFIXF8aGW
         YcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431123; x=1684023123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkEj6q2IVKaYOP6wiiRLnj5ts2mBBZa+OIxL/GSTf98=;
        b=LlasJ3Cik37xRRN1Bq4KOthMVqMIzLT26nhoUWRhYQyFJeom8QLldUqyd/yFB1Fst1
         MCMNaaTz7BHf5Lu3W8sMYVSb3yGfA6e8+DxTZ4Ak5h7+F5rZHZfAUi7nVp1/7+Z+/bUO
         Y1H72NfiAQsu/Pwok58Yj+O3IHGgfGKaJTWpk0Q1MG7aLQhDA4iHkEvkLd5fUqUdkbKK
         voqX4f/OtQjFhwxT3GkiBAboGLkmtK+bE7e29UDjOYkpjCMrc5yyKXNFvK3GU/RmQUPP
         L9J7OuEK32FoP1xpkK7Ic5wFA4kH9pw2UM9YOoNzMKqSoHD70BFM95qT5qEa2TpYTMsC
         OJHw==
X-Gm-Message-State: AAQBX9e5MO+HSEat9cTDdrywGyOAv4carEJbl+BTpdcd8utasqEcky0u
        1shEweO6lhYbFAfzAEyGeZlNa8PAHUY7h7RD5INYrUVt2MVV72N6zkzRAG0zPFcMdutfwxiPrx0
        lkH+VkDasy2e/qgSOgHbYxZ/k37nXub/o2mCDUIKrUjS3aqFr/BdGw8kTTDfzrQb86SkYmFk=
X-Google-Smtp-Source: AKy350avtllPlWwvIfTF15qlG1lqqPqwu/NAHA4tctgmwlguwviMhGUhrJ6084VLBRdQnA8mKuN5Lp3jk9IuHlWLyQ==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a63:1c09:0:b0:507:3e33:43e3 with SMTP
 id c9-20020a631c09000000b005073e3343e3mr240709pgc.7.1681431122125; Thu, 13
 Apr 2023 17:12:02 -0700 (PDT)
Date:   Fri, 14 Apr 2023 00:11:51 +0000
In-Reply-To: <cover.1681430907.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1681430907.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <cf43d4daa5e8dba22d2416cf46f586afcff0a33e.1681430907.git.ackerleytng@google.com>
Subject: [RFC PATCH 2/6] mm: mempolicy: Refactor out mpol_init_from_nodemask
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
        muchun.song@linux.dev, feng.tang@intel.com, brgerst@gmail.com,
        rdunlap@infradead.org, masahiroy@kernel.org,
        mailhol.vincent@wanadoo.fr, Ackerley Tng <ackerleytng@google.com>
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

Refactor out mpol_init_from_nodemask() to simplify logic in do_mbind().

mpol_init_from_nodemask() will be used to perform similar
functionality in do_memfd_restricted_bind() in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/mempolicy.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a256a241fd1d..a2655b626731 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1254,6 +1254,25 @@ static struct page *new_page(struct page *page, unsigned long start)
 }
 #endif
 
+static long mpol_init_from_nodemask(struct mempolicy *mpol, const nodemask_t *nmask,
+				    bool always_unlock)
+{
+	long err;
+	NODEMASK_SCRATCH(scratch);
+
+	if (!scratch)
+		return -ENOMEM;
+
+	/* Cannot take lock before allocating in NODEMASK_SCRATCH */
+	mmap_write_lock(current->mm);
+	err = mpol_set_nodemask(mpol, nmask, scratch);
+	if (always_unlock || err)
+		mmap_write_unlock(current->mm);
+
+	NODEMASK_SCRATCH_FREE(scratch);
+	return err;
+}
+
 static long do_mbind(unsigned long start, unsigned long len,
 		     unsigned short mode, unsigned short mode_flags,
 		     nodemask_t *nmask, unsigned long flags)
@@ -1306,17 +1325,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		lru_cache_disable();
 	}
-	{
-		NODEMASK_SCRATCH(scratch);
-		if (scratch) {
-			mmap_write_lock(mm);
-			err = mpol_set_nodemask(new, nmask, scratch);
-			if (err)
-				mmap_write_unlock(mm);
-		} else
-			err = -ENOMEM;
-		NODEMASK_SCRATCH_FREE(scratch);
-	}
+
+	err = mpol_init_from_nodemask(new, nmask, false);
 	if (err)
 		goto mpol_out;
 
-- 
2.40.0.634.g4ca3ef3211-goog

