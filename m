Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6018743522C
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhJTSBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhJTSBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:00 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A41DC061753
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:58:43 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q19so3617559pfl.4
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zzTtckqEaK0D3eLtoT277+iNWAcpGrNOCpj8PhXShIw=;
        b=pw+WlRWr2bWLgMUbGTBaR+nuplTIm4g/9ojt8+VtyMb/JXQ2WtU0QPxbMdJt04mYU6
         fDu6ynWL68MMwVDkhpHdnj3IMUT63SPjmwVD+e0Z9awj9/sr68LsybxcnnqpIprkVWvA
         Oc5JAiFfGl2xEK8NJJBsrPkevkn6wMeQelRrKl19SMwYsySN3oJZVcd3eS4mELT6n795
         D12BT+SN8eHcO/dQYWyuo24tSHS9WR5WjM/BIERDa3r5pkuvV5rGDXFcusy6NBsKyMx1
         iGAbGutMNhD3JQYZHTH6IWvXQPa2GTCYE5ORN0OqZblwBFk6cxXRUgnwcEvv84LDgu31
         OlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zzTtckqEaK0D3eLtoT277+iNWAcpGrNOCpj8PhXShIw=;
        b=B4DVFRzaklsDIra1qfEru0E69MUAbywL0VXTbN5stpo+VAr5PlLZMu/WpEx5Gmyy9A
         c4md5VkYKDw+9Eh+8uCDSPUzgPZ968lTzLQT9d+7SpCqwseyy3V0tTIVSr2rr5J1R3z0
         lBXtUXjya65o+K0boNC2yap2ju8h9bY4ZjkHjF67taH4uivC2EhVTHocG1xSMObpbpQU
         7B+CTz2Vgnnn6reKlRjX7m6quKPFaPh1mdjnoBAKqrcGdF4WPVvu1+jT9Wo9LZnTjDhO
         HVQfog/5qdb6l6QFBoW6Z5kTDKFV8ZRuFu3c9sPYyOFQAKKyNhkYtLOq8MEcI7OeOAAz
         GUzg==
X-Gm-Message-State: AOAM532hZlBr+jvprSDmhzaoXL5yW8vQOgLt8HnOovvo0uVrzh6tJNzr
        usIkhb+m3pVyTMJUpMBxqm27sQ==
X-Google-Smtp-Source: ABdhPJx9JplqllAZq+WnEaeOMijRmQHFSCKu/RYD3Z65A4p+FjrJVAwOKdvEdlRru2lyYRhn2z/ptQ==
X-Received: by 2002:a63:9844:: with SMTP id l4mr561370pgo.271.1634752722724;
        Wed, 20 Oct 2021 10:58:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t13sm2779047pgn.94.2021.10.20.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 10:58:42 -0700 (PDT)
Date:   Wed, 20 Oct 2021 17:58:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        jroedel@suse.de, varad.gautam@suse.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH kvm-unit-tests 1/2] unify structs for GDT descriptors
Message-ID: <YXBYzvnclL+HfIMr@google.com>
References: <20211020165333.953978-1-pbonzini@redhat.com>
 <20211020165333.953978-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020165333.953978-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Jim who is poking at this area too.

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> Use the same names and definitions (apart from the high base field)
> for GDT descriptors.  gdt_entry_t is for 8-byte entries and
> gdt_desc_entry_t is for when 64-bit tests should use a 16-byte
> entry.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index a6ffb38..3aa1eca 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -164,15 +164,28 @@ typedef struct {
>  } idt_entry_t;
>  
>  typedef struct {
> -	u16 limit_low;
> -	u16 base_low;
> -	u8 base_middle;
> -	u8 access;
> -	u8 granularity;
> -	u8 base_high;
> -} gdt_entry_t;
> -
> -struct segment_desc64 {
> +	uint16_t limit1;
> +	uint16_t base1;
> +	uint8_t  base2;
> +	union {
> +		uint16_t  type_limit_flags;      /* Type and limit flags */
> +		struct {
> +			uint16_t type:4;
> +			uint16_t s:1;
> +			uint16_t dpl:2;
> +			uint16_t p:1;
> +			uint16_t limit:4;
> +			uint16_t avl:1;
> +			uint16_t l:1;
> +			uint16_t db:1;
> +			uint16_t g:1;
> +		} __attribute__((__packed__));
> +	} __attribute__((__packed__));
> +	uint8_t  base3;
> +} __attribute__((__packed__)) gdt_entry_t;
> +
> +#ifdef __x86_64__
> +typedef struct {
>  	uint16_t limit1;

Changelog says "unify struct", yet gdt_entry_t and gdt_desc_entry_t have fully
redundant information.  Apparently anonymous structs aren't a thing (or I'm just
doing it wrong), but even so, fully unifying this is not hugely problematic for
the sole consumer.



>  	uint16_t base1;
>  	uint8_t  base2;
> @@ -193,7 +206,10 @@ struct segment_desc64 {
>  	uint8_t  base3;
>  	uint32_t base4;
>  	uint32_t zero;
> -} __attribute__((__packed__));
> +} __attribute__((__packed__)) gdt_desc_entry_t;

This is misleading, only system descriptors have the extra 8 bytes.

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 3aa1eca..3b213c2 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -186,29 +186,13 @@ typedef struct {

 #ifdef __x86_64__
 typedef struct {
-       uint16_t limit1;
-       uint16_t base1;
-       uint8_t  base2;
-       union {
-               uint16_t  type_limit_flags;      /* Type and limit flags */
-               struct {
-                       uint16_t type:4;
-                       uint16_t s:1;
-                       uint16_t dpl:2;
-                       uint16_t p:1;
-                       uint16_t limit:4;
-                       uint16_t avl:1;
-                       uint16_t l:1;
-                       uint16_t db:1;
-                       uint16_t g:1;
-               } __attribute__((__packed__));
-       } __attribute__((__packed__));
+       gdt_entry_t common;
        uint8_t  base3;
        uint32_t base4;
        uint32_t zero;
-} __attribute__((__packed__)) gdt_desc_entry_t;
+} __attribute__((__packed__)) gdt_system_desc_entry_t;
 #else
-typedef gdt_entry_t gdt_desc_entry_t;
+typedef gdt_entry_t gdt_system_desc_entry_t;
 #endif

 #define DESC_BUSY ((uint64_t) 1 << 41)
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index 24870d7..4d82617 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -134,7 +134,7 @@ static void set_tss_ioperm(void)
 {
        struct descriptor_table_ptr gdt;
        gdt_entry_t *gdt_table;
-       gdt_desc_entry_t *tss_entry;
+       gdt_system_desc_entry_t *tss_entry;
        u16 tr = 0;
        tss64_t *tss;
        unsigned char *ioperm_bitmap;
@@ -143,11 +143,11 @@ static void set_tss_ioperm(void)
        sgdt(&gdt);
        tr = str();
        gdt_table = (gdt_entry_t *) gdt.base;
-       tss_entry = (gdt_desc_entry_t *) &gdt_table[tr / sizeof(gdt_entry_t)];
-       tss_base = ((uint64_t) tss_entry->base1 |
-                       ((uint64_t) tss_entry->base2 << 16) |
-                       ((uint64_t) tss_entry->base3 << 24) |
-                       ((uint64_t) tss_entry->base4 << 32));
+       tss_entry = (gdt_system_desc_entry_t *) &gdt_table[tr / sizeof(gdt_entry_t)];
+       tss_base = ((uint64_t) tss_entry->common.base1 |
+                  ((uint64_t) tss_entry->common.base2 << 16) |
+                  ((uint64_t) tss_entry->base3 << 24) |
+                  ((uint64_t) tss_entry->base4 << 32));
        tss = (tss64_t *)tss_base;
        tss->iomap_base = sizeof(*tss);
        ioperm_bitmap = ((unsigned char *)tss+tss->iomap_base);
