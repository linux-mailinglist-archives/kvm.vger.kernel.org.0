Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52A0295DE9
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 14:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503373AbgJVMBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 08:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503002AbgJVMBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 08:01:45 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAD7C0613CF
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 05:01:45 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r127so1893855lff.12
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 05:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9tdVLshVcb2kwPka4/LRhjHcSm9h075NEyjA4ZLCJYs=;
        b=kT5yuwwiXiJF2DtrWExMlv8mrMLi4ANew/WS18n4lRB+EeAfz0t5d91A/PEXNSN86X
         dK9ybkCXThawY/2h24j8xRthMDWaoShIJhFjaNypNhpMnE4cCtBhLRX2fLZtmMo6sAvB
         o4S9LmZtXuiCcNLYTafAglVOzUDsoDqc+YLN6pCbYYKlp4retHnv9iGhzOgjD7Iu7VKO
         Tvf6cabWLTTDKUZPlfuy1rQx3rjQY1DaQ8uu7kOHwEah5WjJJ5/cmDK0vdntQlyc4c8B
         rP3amoie/cJpfOZwF9dGeqmrVI6mbRFhSumVxCogR6XQm3o73dTDtaXW25SXq/V+mImd
         CpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9tdVLshVcb2kwPka4/LRhjHcSm9h075NEyjA4ZLCJYs=;
        b=SCLoT0bi110k++9arw1ITDOPv3dqZZE12W/PqvlgMZN77NvR5+CqeVjHfZasw8G8fy
         wXxlEZtRyyCAf65PrlECm0GNLYgwy9KT8DTZX0Oob/BL7nJ/PHuHZAL69HDRraVbH+k/
         HPcw8FiEFsTwgqXjSYJNoSziWQ5TsiR2gUjfBPSMnlWeemygUrR9YjWys6jku4ePMzo4
         GsP6grKuiI68jTgw1cPgNha3/K9Eavalidlxx40sGoZG8hoFSDk39USwlDz28TQsNdCa
         tYEho7nKnA09R9IqdcNrvXgWGO75DpL0396QzGjEI2thSHtlxtbY0d4aWtYH1KhkVTdI
         CapQ==
X-Gm-Message-State: AOAM532vdMktEVlrZlKWgdILQW71zD2pEdTl0kvKhn7oP/tYiZ/G7G+A
        1B/lgBFvF60vhxwF3sAT/fhT5w==
X-Google-Smtp-Source: ABdhPJylsP0EOfZL91sCKiPlZBvQTPHp1k3qJrpQ1C2jumtYhoAtSzGrCTDOaiPG8ukt2kTvSNZ+Ow==
X-Received: by 2002:ac2:4545:: with SMTP id j5mr664027lfm.267.1603368103725;
        Thu, 22 Oct 2020 05:01:43 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id s14sm272993ljp.92.2020.10.22.05.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 05:01:43 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id AEBFC102F6D; Thu, 22 Oct 2020 15:01:42 +0300 (+03)
Date:   Thu, 22 Oct 2020 15:01:42 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "wad@chromium.org" <wad@chromium.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 09/16] KVM: mm: Introduce VM_KVM_PROTECTED
Message-ID: <20201022120142.uzephkci7pfy3kwq@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-10-kirill.shutemov@linux.intel.com>
 <b13e29ea41e1961ea5cfea9e941320842c2d1695.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b13e29ea41e1961ea5cfea9e941320842c2d1695.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 06:47:32PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2020-10-20 at 09:18 +0300, Kirill A. Shutemov wrote:
> >  include/linux/mm.h  |  8 ++++++++
> >  mm/gup.c            | 20 ++++++++++++++++----
> >  mm/huge_memory.c    | 20 ++++++++++++++++----
> >  mm/memory.c         |  3 +++
> >  mm/mmap.c           |  3 +++
> >  virt/kvm/async_pf.c |  2 +-
> >  virt/kvm/kvm_main.c |  9 +++++----
> >  7 files changed, 52 insertions(+), 13 deletions(-)
> 
> There is another get_user_pages() in
> paging_tmpl.h:FNAME(cmpxchg_gpte). 

Right, I will look into it. I wounder why I don't step onto it.

> Also, did you leave off FOLL_KVM in gfn_to_page_many_atomic() on
> purpose? It looks like its only used for pte prefetch which I guess is
> not required.

FOLL_FAST_ONLY is going to fail anyway. The caller has to handle it
gracefully.

-- 
 Kirill A. Shutemov
