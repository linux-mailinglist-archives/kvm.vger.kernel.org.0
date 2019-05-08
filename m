Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C816117C64
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfEHOvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:51:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:57649 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728251AbfEHOoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656539"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:39 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id AF1AFA17; Wed,  8 May 2019 17:44:29 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 20/62] mm/page_ext: Export lookup_page_ext() symbol
Date:   Wed,  8 May 2019 17:43:40 +0300
Message-Id: <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

page_keyid() is inline funcation that uses lookup_page_ext(). KVM is
going to use page_keyid() and since KVM can be built as a module
lookup_page_ext() has to be exported.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/page_ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index 1af8b82087f2..91e4e87f6e41 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -142,6 +142,7 @@ struct page_ext *lookup_page_ext(const struct page *page)
 					MAX_ORDER_NR_PAGES);
 	return get_entry(base, index);
 }
+EXPORT_SYMBOL_GPL(lookup_page_ext);
 
 static int __init alloc_node_page_ext(int nid)
 {
@@ -212,6 +213,7 @@ struct page_ext *lookup_page_ext(const struct page *page)
 		return NULL;
 	return get_entry(section->page_ext, pfn);
 }
+EXPORT_SYMBOL_GPL(lookup_page_ext);
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
 {
-- 
2.20.1

