Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B42313D35
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhBHSVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:21:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234042AbhBHSU3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 13:20:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612808342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIoYvaPz6WOCEvbZt11C1gEQUT4M4c60EhE6OZiuqm8=;
        b=Y2c4sTpG5Ub0GupaxoOJZnCrhSskUsb0l7No5ubgDBeUVNaqZ4VxpYwquuazIQVNV4/AVu
        h6W46/YfUolREzJYr6ti6VZ4FzfjBLk30Zm7xXvHTRNql72IkzFh5vMhpcSrtDNmgpDcH6
        wYa0QrH2nT9FEa37EYkYMqVlKKWu19k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-RhvMY71NPNeVdJQDrk0ELA-1; Mon, 08 Feb 2021 13:18:59 -0500
X-MC-Unique: RhvMY71NPNeVdJQDrk0ELA-1
Received: by mail-wm1-f72.google.com with SMTP id y9so14987wmj.7
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 10:18:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIoYvaPz6WOCEvbZt11C1gEQUT4M4c60EhE6OZiuqm8=;
        b=oyp9t5a/CDaAh80KkGSZ4YWmEIvJ4mFLX2RJoq4F5CaM955nI2bbs9IKSOjKSSnTgE
         +EyH0ukwsAiSYSd7aU//pZA3+r85XJVMWP24cCSPsgzwErn0XhlspxNX+ODjsYv2SA9f
         /4UjkAbPE/NphCWj3Jni5rcXl7Nrgv6OUY2py8Vj5wOUtqb+aA7me0oo2XwHfuf0D/AR
         lEc1Qfmf4Ajh0Fggkkldw2JUmurlqY9vhkz2+kaWzHk/OytdR/n/Gq1WaFVctbKYQoat
         jqw2NpmNZuau4dh5ZjY3RHF75yflmLugY+8AhqXI3UXOJt8HW5lphDeOWyC+8mrkstLk
         A4Og==
X-Gm-Message-State: AOAM532dQTrNeP4G0S6WXnPxPngV6bN9dhSocEqWAto2EMeQxaTlM9vW
        kzODdFu2C1afW18UJ1+SQvaWFvElUFVHBAx2MbjMTFFOinHa8etRCMNaIwWjAubywaIXwO6cTOi
        aD3n9RosjzuR8
X-Received: by 2002:a5d:4708:: with SMTP id y8mr12696784wrq.402.1612808338180;
        Mon, 08 Feb 2021 10:18:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyx3sos0n8tHVOC1iptrkVQW4o0j1fKrwhhKnTVlDfzopi0rkSvYbUXaXRWtKNy7vPxFtXNIQ==
X-Received: by 2002:a5d:4708:: with SMTP id y8mr12696762wrq.402.1612808337962;
        Mon, 08 Feb 2021 10:18:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y15sm11968095wrm.93.2021.02.08.10.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 10:18:57 -0800 (PST)
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@ziepe.ca,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205103259.42866-2-pbonzini@redhat.com>
 <20210208173936.GA1496438@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] mm: provide a sane PTE walking API for modules
Message-ID: <3b10057c-e117-89fa-1bd4-23fb5a4efb5f@redhat.com>
Date:   Mon, 8 Feb 2021 19:18:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208173936.GA1496438@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 18:39, Christoph Hellwig wrote:
>> +int follow_pte(struct mm_struct *mm, unsigned long address,
>> +	       pte_t **ptepp, spinlock_t **ptlp)
>> +{
>> +	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
>> +}
>> +EXPORT_SYMBOL_GPL(follow_pte);
>
> I still don't think this is good as a general API.  Please document this
> as KVM only for now, and hopefully next merge window I'll finish an
> export variant restricting us to specific modules.

Fair enough.  I would expect that pretty much everyone using follow_pfn 
will at least want to switch to this one (as it's less bad and not 
impossible to use correctly), but I'll squash this in:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 90b527260edf..24b292fce8e5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1659,8 +1659,8 @@ void free_pgd_range(struct mmu_gather *tlb, 
unsigned long addr,
  int
  copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct 
*src_vma);
  int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
-			  spinlock_t **ptlp);
+			  struct mmu_notifier_range *range, pte_t **ptepp,
+			  pmd_t **pmdpp, spinlock_t **ptlp);
  int follow_pte(struct mm_struct *mm, unsigned long address,
  	       pte_t **ptepp, spinlock_t **ptlp);
  int follow_pfn(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index 3632f7416248..c8679b15c004 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4792,6 +4792,9 @@ int follow_invalidate_pte(struct mm_struct *mm, 
unsigned long address,
   * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
   * should be taken for read.
   *
+ * KVM uses this function.  While it is arguably less bad than
+ * ``follow_pfn``, it is not a good general-purpose API.
+ *
   * Return: zero on success, -ve otherwise.
   */
  int follow_pte(struct mm_struct *mm, unsigned long address,
@@ -4809,6 +4812,9 @@ EXPORT_SYMBOL_GPL(follow_pte);
   *
   * Only IO mappings and raw PFN mappings are allowed.
   *
+ * This function does not allow the caller to read the permissions
+ * of the PTE.  Do not use it.
+ *
   * Return: zero and the pfn at @pfn on success, -ve otherwise.
   */
  int follow_pfn(struct vm_area_struct *vma, unsigned long address,


(apologies in advance if Thunderbird destroys the patch).

Paolo

