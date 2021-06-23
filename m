Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02173B221D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFWVAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWVAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 17:00:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6303FC061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:58:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w71so3329988pfd.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dp1fF9+n2I2zz0c+5hy0HQx9qwqBJq8pHUaVofF7iuI=;
        b=Lq9uvoimFTnAECIU+IqG8YHBKcQzENoRgHKXedRQkBWvOYBoklSLajmMQQ9WHVOD1G
         z5a8YaC6K2J6lWP/u1Y5+32O86WbT/gXS1d82NKzZKzA+1xZV2KY09BRIVEi3q9GTiOH
         OylRYtf+r6UL6cekhN/RqeqTEqx5RNd+RwKCo/hofKSD3x5zronXzSXI3A+zxKN4vCLS
         Gc+i/iusmSXhizS6a5sxcyjF5CqYsWWOX2Lm+HACI2GZD96SbO/RXn0tdw2NXXv9XY2n
         krKr/MH/+OEby6Qed6nkgd7GvZui08k4wzdFHBhq5m8/LkEOeAJHmlXqvYBk+91gDNbX
         Y3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dp1fF9+n2I2zz0c+5hy0HQx9qwqBJq8pHUaVofF7iuI=;
        b=tGqJy9EQu4HL1Gt1x2rg5uCEdPLYFhmsiOb4M8Cau1WReT30o4Ty/575tJkJ6XNzJs
         PKkNt02HeVud7Q0lTt2o8sE0H806mHEdEaoQTwiQDJBFtCSIEZyTEAGZ3iXMePug1FLT
         AglNgXEvIqT/UoO88WfP5yXfyk1uHKM5a9U67MiGgkojzdOGj48vdR0qeMQ2eMDhIQ2+
         uSpUlNs3efsjxD585DHhRIQynKzx1Ijjy9R8lEJiCFvv1++ZGOadkWEqxuMG48lDmlzD
         e/8NMHorywjD51bevbdxTmReYhyGOI6p+fandCau0SX00Ov4YfK1lABUL2bIPLLqNKla
         3mXQ==
X-Gm-Message-State: AOAM5302dYj+1M23q2ZiDI/guuyKXy+MVcmA/3i60/UfGSd8RVPrPc77
        Ul/y3CfDaSTGup4xNmzT3RETr4WzJd1O/Q==
X-Google-Smtp-Source: ABdhPJy1i/YWeHHlOClBLZnQAS2RcCRI/xDCan7GcdFMJwheNKcswLN1eThAH/Z1gD4w7VB/kdTvWA==
X-Received: by 2002:a62:380c:0:b029:2f7:4057:c3ed with SMTP id f12-20020a62380c0000b02902f74057c3edmr1336275pfa.21.1624481903812;
        Wed, 23 Jun 2021 13:58:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f12sm630244pfc.100.2021.06.23.13.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:58:23 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:58:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 50/54] KVM: x86/mmu: Optimize and clean up so called
 "last nonleaf level" logic
Message-ID: <YNOga8/4fQlMGJHU@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-51-seanjc@google.com>
 <e7a290c6-aeca-bd7b-d0be-d1af44713138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7a290c6-aeca-bd7b-d0be-d1af44713138@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:57, Sean Christopherson wrote:
> > +#if PTTYPE == 32
> > +	/*
> > +	 * 32-bit paging requires special handling because bit 7 is ignored if
> > +	 * CR4.PSE=0, not reserved.  Clear bit 7 in the gpte if the level is
> > +	 * greater than the last level for which bit 7 is the PAGE_SIZE bit.
> > +	 *
> > +	 * The RHS has bit 7 set iff level < (2 + PSE).  If it is clear, bit 7
> > +	 * is not reserved and does not indicate a large page at this level,
> > +	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
> > +	 */
> > +	gpte &= level - (PT32_ROOT_LEVEL + !!mmu->mmu_role.ext.cr4_pse);
> 
> !! is not needed and possibly slightly confusing?  (We know it's a single
> bit).

Ah, I had it backwards.  I misremembered the "!!" logic added around the
mmu_role helpers, but that was to ensure that e.g. kvm_read_cr4_bits() was
squished down into a 0/1 value when setting the mmu_role bit.
