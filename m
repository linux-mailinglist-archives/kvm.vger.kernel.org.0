Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C79121851
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 19:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfLPSmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 13:42:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33992 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfLPR75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:57 -0500
Received: by mail-pl1-f194.google.com with SMTP id x17so4811580pln.1
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 09:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DJGBGvTAS/i0iYU7uRr6zHHSNaYAfvF1fKpLbSg2osI=;
        b=KO0fUUxTz3mIKnh2o8stIaHBKDJy4a0Sc3zH32h6OoVde0KKE1Ne65jA1Z3fn0BvXE
         GSu/1gUbrSo5KfZdxNmUWB/K1AvEg4MvfxiCcUANexOkDwxGN3Oyj5WXkoaQyxgVAR3/
         5C4yQsQS61VeZghqqA4hZJVx8UI1eF8MlTCatlpDdGYBIubTWA7LDrXfOsNOtm8olk7M
         /WSAdAISwANmc7M+ANY1fqRhBsuHDj4Lyg3RflUojnVbnyBRjDSfqgLN7DmVNm2G06zl
         nX/0531PHuoPQwvxysjGCttHwIZO3itx9oF+3Th9NFQYHPL2novcu6kZz7LKPo/nyPrs
         6dJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJGBGvTAS/i0iYU7uRr6zHHSNaYAfvF1fKpLbSg2osI=;
        b=HhkkhyVlNFLhk2wyw6rVuJ47ixjvllzIYWiAQKepZ2pHNH81TWRLi9/VbGeQUU1/90
         Biy2LSVo+x7YsZJYyFrtAkdW/04m7tDHQbiyVi1csUN1Jx8nKrrScKFeSBPJGDa45k7H
         14io9HGRvLkY+BS/4e4Lh7jFUsOGpqzmRXfoc4HXcEWgRAPhlm98m8LwYxDzS42WFgzx
         S51G0901ngvWf7Ax+t0naf9T8OLV/L6CDVbzPmwuZ/U1jsZcdUP9P4B7NvpUi/6qe0bh
         s2sWAVvfrJ1UAKkk4fKCtKEkAGaAKgTAnysIbIl++v4O/ppyR9f2JorPleIG+yoHHzQB
         1Hdw==
X-Gm-Message-State: APjAAAV8skKJOmxaKSgMldIBYw2iGcqLK3ywQ0qGoEg5VHHp664+Jgx+
        uUU37bM33m8S/7NayLtwl1xV7Q==
X-Google-Smtp-Source: APXvYqwOJXNcFn1m98nkQulGDUAoyGF9vWbS/blvOgPSgK75hoZXtx3/MHs96VgAKvmCjNr5114E/Q==
X-Received: by 2002:a17:90a:c790:: with SMTP id gn16mr428610pjb.76.1576519196210;
        Mon, 16 Dec 2019 09:59:56 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:ad22:1cbb:d8fa:7d55])
        by smtp.googlemail.com with ESMTPSA id e9sm23597209pgn.49.2019.12.16.09.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 09:59:55 -0800 (PST)
Subject: Re: [PATCH v5 1/2] mm: make dev_pagemap_mapping_shift() externally
 visible
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-2-brho@google.com>
 <20191213174702.GB31552@linux.intel.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <e004e742-f755-c22c-57bb-acfe30971c7d@google.com>
Date:   Mon, 16 Dec 2019 12:59:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213174702.GB31552@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/19 12:47 PM, Sean Christopherson wrote:
>> +unsigned long dev_pagemap_mapping_shift(unsigned long address,
>> +					struct mm_struct *mm)
>> +{
>> +	pgd_t *pgd;
>> +	p4d_t *p4d;
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +
>> +	pgd = pgd_offset(mm, address);
>> +	if (!pgd_present(*pgd))
>> +		return 0;
>> +	p4d = p4d_offset(pgd, address);
>> +	if (!p4d_present(*p4d))
>> +		return 0;
>> +	pud = pud_offset(p4d, address);
>> +	if (!pud_present(*pud))
>> +		return 0;
>> +	if (pud_devmap(*pud))
>> +		return PUD_SHIFT;
>> +	pmd = pmd_offset(pud, address);
>> +	if (!pmd_present(*pmd))
>> +		return 0;
>> +	if (pmd_devmap(*pmd))
>> +		return PMD_SHIFT;
>> +	pte = pte_offset_map(pmd, address);
>> +	if (!pte_present(*pte))
>> +		return 0;
>> +	if (pte_devmap(*pte))
>> +		return PAGE_SHIFT;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(dev_pagemap_mapping_shift);
> 
> This is basically a rehash of lookup_address_in_pgd(), and doesn't provide
> exactly what KVM needs.  E.g. KVM works with levels instead of shifts, and
> it would be nice to provide the pte so that KVM can sanity check that the
> pfn from this walk matches the pfn it plans on mapping.

One minor issue is that the levels for lookup_address_in_pgd() and for 
KVM differ in name, although not in value.  lookup uses PG_LEVEL_4K = 1. 
  KVM uses PT_PAGE_TABLE_LEVEL = 1.  The enums differ a little too: x86 
has a name for a 512G page, etc.  It's all in arch/x86.

Does KVM-x86 need its own names for the levels?  If not, I could convert 
the PT_PAGE_TABLE_* stuff to PG_LEVEL_* stuff.

> 
> Instead of exporting dev_pagemap_mapping_shift(), what about replacing it
> with a patch to introduce lookup_address_mm() and export that?
> 
> dev_pagemap_mapping_shift() could then wrap the new helper (if you want),

I might hold off on that for now, since that helper is used outside of 
x86, and I don't know if 'level' makes sense outside of x86.

Thanks,

Barret
