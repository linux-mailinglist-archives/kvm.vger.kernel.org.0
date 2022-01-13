Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D1E48E077
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiAMWk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiAMWk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:40:58 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49459C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:40:58 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t32so1166460pgm.7
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UIBiUOD4DHxlB4Cj1VhTqRpz44USNMdFSO01fjoq5FI=;
        b=hhvywSawdWtzXtNOd8th/sNW0pSKLEKPS1bgmmbAacqW7ZPwKofRns/b6LNdx1u4k7
         Clt885hY2v2buaUsa8uA9hqodC09+jsJp1QE5FzkGudB/giZHsCUpiEWQp2+/Fhp0y/+
         pSAsvMzdDSB7Uwo+lxaBJM5YvzjrqoRtK0wEymBT4d0bdvFSVRCGDnVA8oNR+4sVe45n
         9DejGVDnvWOoJouKzvwFw49HnYnrtYqgY1ioM71iHnA44OYZr5tcbPq7C3sVTC4VGW4I
         6PyL/BcvhVffY3K33PJCIuEbbBHN8HrzphKGBd2JbXOUxkJeY8u8vMx/MogToiKcG8SD
         QkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UIBiUOD4DHxlB4Cj1VhTqRpz44USNMdFSO01fjoq5FI=;
        b=4NCn2p5hgEPGn7T9vj94Jzlawdj64D4O0uknRfTkn+z4eGuKwzszhGr2J3ELzFlMBv
         G1orYkokn84hdiI4p3eCrHrMIxqFMv0TuhJx/uwy8J7NzsYuQLjIwowv7E/PNY1AmI28
         fxes0Z90wuif7qR/xDTsTG2LyqVh5ZrIFZAj7tO2K9Wt/sQZ8KkehswRyNveZ0nsPAmQ
         bXrKkeTE83JaKLF2ZlgjWZFZs+TBGDny2PSPMZK/Oe6LkDD/Nn430STt2FbyHKlGRCY5
         cFoSYPbMUY9E59j0q4sY5Xx0dlKDFUbG0me66D0c9/xOfw3g3chmIeXd+gPUvdvkDIL1
         dzxg==
X-Gm-Message-State: AOAM530UFglBS4VtRerWpH+LhzNY3BdOPmYTUQZafH6hsUV+wOIfC/sz
        46SQFZ/5l1RTGCEdWlX/o3Ifig==
X-Google-Smtp-Source: ABdhPJwQaTU9PuMVsmXCOaBlT7jxLXNw9JMVp+npjhVVU8JDE9yam4Mt8zLMkIrZPdPRgOYc+lME4A==
X-Received: by 2002:a63:7118:: with SMTP id m24mr5641168pgc.603.1642113657649;
        Thu, 13 Jan 2022 14:40:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s35sm3561396pfw.193.2022.01.13.14.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:40:57 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:40:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Improve comment about TLB flush
 semantics for write-protection
Message-ID: <YeCqdds2r/q+0Zog@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-3-dmatlack@google.com>
 <Yd92T8RoZZi6usxH@google.com>
 <CALzav=dhd3rLh6tDJV0BR7aH0FV=Xv9xVm5XdbVitQYfSAqfYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dhd3rLh6tDJV0BR7aH0FV=Xv9xVm5XdbVitQYfSAqfYg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> On Wed, Jan 12, 2022 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
> > So something like this?  Plus more commentry in spte.h.
> >
> >         /*
> >          * It's safe to flush TLBs after dropping mmu_lock as making a writable
> >          * SPTE read-only for dirty logging only needs to ensure KVM starts
> >          * logging writes to the memslot before the memslot update completes,
> >          * i.e. before the enabling of dirty logging is visible to userspace.
> >          *
> >          * Note, KVM also write-protects SPTEs when shadowing guest page tables,
> >          * in which case a TLB flush is needed before dropping mmu_lock().  To
> >          * ensure a future TLB flush isn't missed, KVM uses a software-available
> >          * bit to track if a SPTE is MMU-Writable, i.e. is considered writable
> >          * for shadow paging purposes.  When write-protecting for shadow paging,
> >          * KVM clears both WRITABLE and MMU-Writable, and performs a TLB flush
> >          * while holding mmu_lock if either bit is cleared.
> >          *
> >          * See DEFAULT_SPTE_{HOST,MMU}_WRITEABLE for more details.
> >          */
> 
> Makes sense. I'll rework the comment per your feedback and also
> document the {host,mmu}-writable bits. Although I think it'd make more
> sense to put those comments on shadow_{host,mmu}_writable_mask as
> those are the symbols used throughout the code and EPT uses different
> bits than DEFAULT_..._WRITABLE.

I don't necessarily disagree, but all of the existing comments for SPTE bits are
in spte.h, even though the dynamic masks that are actually used in code are defined
elsewhere.  I'd prefer to keep all the "documentation" somewhat centralized, and it
shouldn't be too onerous to get from shadow_*_mask to DEFAULT_*_WRITABLE.
