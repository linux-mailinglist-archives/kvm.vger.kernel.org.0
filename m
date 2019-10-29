Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F349BE8499
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 10:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbfJ2JlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 05:41:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35376 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbfJ2JlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 05:41:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id d13so8095941pfq.2;
        Tue, 29 Oct 2019 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CAwKwW00jVJm51PG91lfRY/TjBZMpZIpgU/Tpy8p9zA=;
        b=j9criezCX7eU0jJjWFTxMlc2b+idSvhrzjxVluwqNar9ukM81im9ZVYrPuM8JcGaPV
         X3fHe7ZsPocJiki6ovRutrBu/PFxi257dA2t9gIz7bUxkWX0VLtscV8pLt7rpI7d2sX3
         6wM6Sy8fPpIDQwhXgvqz6FBB8W/1+U03argQsOO3H3Tg1jM3hX212sN5GJOwbtyUZ/jt
         clkcw/lrbfiz9xwE5JiAYjK5CUEzC/UA51JwZjUYPCCE5/OYsq5P5YKzPOJ2wxGwt3d8
         t9UncDYXCkJXkGphbT2+cjxYsvlh1lou5Xtrkik0/1WUnkWhbjdIczBdwBicfoM0NUtl
         arCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CAwKwW00jVJm51PG91lfRY/TjBZMpZIpgU/Tpy8p9zA=;
        b=bVps3cnUJhR+QnrTT2I4v3LSTI1i4PCmOB7Jz+jwnhNfU1IA3SdZso+ot80t19DLCa
         H87zp9kTO92MUlybjTmA7TUtztWqThete4lfzLi2kzcJdGPZwRgDZyDfIeTi3mAyx48x
         beWZVCBf+rqGV6xgVMqVVxXBfghXD5DxRHVq/R72a+SX5qwIjLiYKnwjqgNIwb1xgaBX
         bmoTxXBQp6hvzI0K/LHJDjWh0M7a/wYj48SYfzTVF+0NI0d7fgu+YlFGY1n1oPQ3tDF/
         sNIQtQM/Hh8SoPpGfqwadQm5SVZ4I6135arX7qK2s81IO4/Zcc+JBVpRo4h7+EIpTcYq
         sbMQ==
X-Gm-Message-State: APjAAAULJhS+ND+vNUDv0o8WO4S/fp9f5dNrDjvwIe399iVJbR0gXGOx
        MqFnZnSVym/iuBnAbXyEucKsHArkwe8=
X-Google-Smtp-Source: APXvYqw86yuRdfHlvx/v3GOZgKl4ljAECR5j49//D1MsdQt1P0dDSM3APydSUDfp9PJvAghARaHOXQ==
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr5375829pja.100.1572342073174;
        Tue, 29 Oct 2019 02:41:13 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id q3sm16251023pgj.54.2019.10.29.02.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 02:41:12 -0700 (PDT)
Date:   Tue, 29 Oct 2019 15:11:04 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
Message-ID: <20191029094104.GA11220@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use true/false for bool type "dbg" in mmu.c

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..c0b1df69ce0f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -68,7 +68,7 @@ enum {
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
-static bool dbg = 0;
+static bool dbg = true;
 module_param(dbg, bool, 0644);
 
 #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-- 
2.20.1

