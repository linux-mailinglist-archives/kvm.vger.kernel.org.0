Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1E51D0B7C
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 11:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgEMJG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 05:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730334AbgEMJG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 05:06:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3BBC061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 02:06:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so19892096wra.7
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 02:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sAz22Qf5FRJKdunB6aL5p2mmvJR5GBHWvdnGZkiVqTA=;
        b=NSVYfRzXzR7uUhwc5wpgdH4cy/nHDWl6Ycsvjllye+7k2RoNJaAbfSrhysBV3nQRFR
         Vv4hrCsx4XjIKsglu2ZKqe3WGYeQaI5yNPPde4hZU2ifJH4BlNEgtApcgN4fF8H4/jSQ
         a9LrjX5AAQFngrJM2YsZ79hofUuj3XXNEgAq+8wy+3WTfxSi+cByUp+9Bb6lGiq6kMZq
         E+tc9ZgM3iV6L9DmlObACm3hAUWvXh6ZQismk2m8LLAEX5OtD6Vqj4thsx+AWW+QXD4t
         Ot0diSIBEoeSy8j8NW+A2nDtCSWBGN/uPZM4o5K6GjnS8sZ0zcCbWseZ8BV1wW3VeztU
         0XnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAz22Qf5FRJKdunB6aL5p2mmvJR5GBHWvdnGZkiVqTA=;
        b=SBe4l57rW8D7vOejm80uO4BDGC5QUGIo6ZWDtTlE9mn+dCjcJaX83oEKzXc3sh6nOw
         nmQ3QCMJFnpz815LJs9Mtm7rHqqwsEjtnbxAl1KIMXcYSuqXAWtcKvKSu0XmfIcpv1uB
         guKnAl4GcOhnv83B5QliZrGcYQ9ATCVbBDLh/Ij8DSachvRFZusEPMfbZvTQwCAAVT/R
         E/Cm3glzGHFaxra5bxXHgmvHiO3A2efnBjDINGTcle5AQHYZ8ZiaA8pYvm4vlmWkpkKK
         I7SDQBH3Ocm5+eC8CHswpYlr1JCLnKhWwIFx7yqkfb+eubJP5NfcK6vtdMQTtRCo45BU
         qRPA==
X-Gm-Message-State: AGi0PuZvFm2aO+NVhgUu68v2YbxoX5y14G6MXIaT9z1vbiBe6REX0Ktt
        b6LnCT+8D6mN+fTQHaEw15nIGw==
X-Google-Smtp-Source: APiQypIIFOViZHe/I++TwFOrfnuWl7zhlP4ZWLO5ZAjebaUXaOhLLT0nrmxPGsJEtdQd9W5w4E+DNQ==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr20206671wru.407.1589360813739;
        Wed, 13 May 2020 02:06:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id w18sm27011053wro.33.2020.05.13.02.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 02:06:53 -0700 (PDT)
Date:   Wed, 13 May 2020 10:06:48 +0100
From:   Andrew Scull <ascull@google.com>
To:     James Morse <james.morse@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
Message-ID: <20200513090648.GA193035@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
 <20200507151321.GH237572@google.com>
 <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 01:04:31PM +0100, James Morse wrote:
> Hi Andrew,
> 
> On 07/05/2020 16:13, Andrew Scull wrote:
> >> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
> >>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
> >>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
> >>  	stage2_pud_clear(kvm, pud);
> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> >>  	stage2_pmd_free(kvm, pmd_table);
> >>  	put_page(virt_to_page(pud));
> >>  }
> >> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
> >>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
> >>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
> >>  	pmd_clear(pmd);
> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> >>  	free_page((unsigned long)pte_table);
> >>  	put_page(virt_to_page(pmd));
> >>  }
> > 
> > Going by the names, is it possible to give a better level hint for these
> > cases?
> 
> There is no leaf entry being invalidated here. After clearing the range, we found we'd
> emptied (and invalidated) a whole page of mappings:
> |	if (stage2_pmd_table_empty(kvm, start_pmd))
> |		clear_stage2_pud_entry(mmu, pud, start_addr);
> 
> Now we want to remove the link to the empty page so we can free it. We are changing the
> structure of the tables, not what gets mapped.
> 
> I think this is why we need the un-hinted behaviour, to invalidate "any level of the
> translation table walk required to translate the specified IPA". Otherwise the hardware
> can look for a leaf at the indicated level, find none, and do nothing.
> 
> 
> This is sufficiently horrible, its possible I've got it completely wrong! (does it make
> sense?)

Ok. `addr` is an IPA, that IPA is now omitted from the map so doesn't
appear in any entry of the table, least of all a leaf entry. That makes
sense.

Is there a convention to distinguish IPA and PA similar to the
distinction for VA or does kvmarm just use phys_addr_t all round?

It seems like the TTL patches are failry self contained if it would be
easier to serparate them out from these larger series?
