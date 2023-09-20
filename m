Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701687A8422
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 15:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbjITN4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 09:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbjITNzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 09:55:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76062D9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 06:55:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c15767524so66874727b3.0
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 06:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695218106; x=1695822906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0APReAt4bNnnd5kx+NahuCYj0tgbUgwxY6/xmv3q1x8=;
        b=qYN6MLIfTj4icmmBpIkd0WLhJxjSRWRnp5CVrZ5zO23Hc6SEWKaxnDv2NJItwfDuFQ
         6RVvMGhZPLFVWocauiDyLryXn63S6KPTLdALA3Qsdgqj3uuPB/A2o/4ptf1HYp9bQI/0
         1cYLmwlGz2SJqRrIPPncawpZ4aDzCTJ8sW2gL6tfKGnzilsZLa6El4ASlO1PaFkjNm/O
         bYywfPO/0UW/nevxIlFfp0aeaozdgulhoho9Sa50zXYSvg9W6zOTkgKB/8FODKp3Zw2Z
         dwA7/f8AInE7LDVv1jVJABSqsl1VCpa8fzDiXuUQzjW4V/dFydMGpeKFv2KS3ghLlvrS
         QzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695218106; x=1695822906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0APReAt4bNnnd5kx+NahuCYj0tgbUgwxY6/xmv3q1x8=;
        b=LDJr9JGxr8qEOv/sPhjkexLqpags/m7YiKsLcVZ+at60cfhw7hvLgOhh2kKzKSjLRk
         JmL1zY62EZr+urL9lhIVSxdzCqc7uwa9oiN+G9GkLf81dFJ1N9cKFM0fGStIs/x6AlyK
         6Vg/biGQTsWDLzfFXfFk3BI8fJ0VfIE5d30ug4g9HcDC6r0mjsgKRYoFCJjO5d3lWy1p
         GamCxqgB5YgEd2MEC0caS9MMRuK+KYEzCmrPWMvEQr5TauDOzUQz5Yc1N9KX0lEuor+s
         0StoyFcNQv+t4r1YJNOTuEyTFCPvXIjHrYAGs6d5F/T4sXIRZl0sPAOS4dt2tzgHp7uy
         Kxfg==
X-Gm-Message-State: AOJu0YyxF6y3+lDAE5H7u4AJeMY7wBNzdkVKzbS/O3BC0cZ9l9vdwggu
        SzPcrBRAj0zRUidVwlJrS4oTX22dXtw=
X-Google-Smtp-Source: AGHT+IHuQ24Hy0wlZqpKThD2hndi3rYWapG+J/d1L/ai4z7W/k7rmZdxNg2zwHr4zmYKJTJyjaSKmjFgB/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae57:0:b0:59b:ee27:bbe9 with SMTP id
 g23-20020a81ae57000000b0059bee27bbe9mr35901ywk.9.1695218106527; Wed, 20 Sep
 2023 06:55:06 -0700 (PDT)
Date:   Wed, 20 Sep 2023 06:55:05 -0700
In-Reply-To: <ZQqMBEL61p739dpF@yilunxu-OptiPlex-7050>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-3-seanjc@google.com>
 <ZQqMBEL61p739dpF@yilunxu-OptiPlex-7050>
Message-ID: <ZQr5uXhV6Cnx4DYT@google.com>
Subject: Re: [RFC PATCH v12 02/33] KVM: Use gfn instead of hva for mmu_notifier_retry
From:   Sean Christopherson <seanjc@google.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023, Xu Yilun wrote:
> On 2023-09-13 at 18:55:00 -0700, Sean Christopherson wrote:
> > +void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> > +
> > +	WARN_ON_ONCE(!kvm->mmu_invalidate_in_progress);
> > +
> >  	if (likely(kvm->mmu_invalidate_in_progress == 1)) {
> >  		kvm->mmu_invalidate_range_start = start;
> >  		kvm->mmu_invalidate_range_end = end;
> 
> IIUC, Now we only add or override a part of the invalidate range in
> these fields, IOW only the range in last slot is stored when we unlock.

Ouch.  Good catch!

> That may break mmu_invalidate_retry_gfn() cause it can never know the
> whole invalidate range.
> 
> How about we extend the mmu_invalidate_range_start/end everytime so that
> it records the whole invalidate range:
> 
> if (kvm->mmu_invalidate_range_start == INVALID_GPA) {
> 	kvm->mmu_invalidate_range_start = start;
> 	kvm->mmu_invalidate_range_end = end;
> } else {
> 	kvm->mmu_invalidate_range_start =
> 		min(kvm->mmu_invalidate_range_start, start);
> 	kvm->mmu_invalidate_range_end =
> 		max(kvm->mmu_invalidate_range_end, end);
> }

Yeah, that does seem to be the easiest solution.

I'll post a fixup patch, unless you want the honors.
