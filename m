Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA674ECC61
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350968AbiC3SiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352833AbiC3SgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:36:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCCBF56C3A
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648665265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BO423QJpHjYuJkP0ZfVrkV5p4JcZ6+8e4Hhk2wmOLQ4=;
        b=irXBaQGlWjn8xxvUtHFR1Nx1ZqBp5AO3u9OgTUkkmW7UeQgaMNZvhYdHcAve+QWmVTpugk
        VLgpjhD1JgBNdSAK+Qc35RNbnZIVQaKO/CUa5P4MAKYXu2fZQvqA+qbr8fQfKE8yhyRW6j
        sk6YS/Yx0A7PNpOmsmU262X30YSsuuw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-uuXTMUGwPO2yxfd4hDwC6Q-1; Wed, 30 Mar 2022 14:34:24 -0400
X-MC-Unique: uuXTMUGwPO2yxfd4hDwC6Q-1
Received: by mail-qv1-f71.google.com with SMTP id t16-20020ad44850000000b00440e0f2a561so16695556qvy.11
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BO423QJpHjYuJkP0ZfVrkV5p4JcZ6+8e4Hhk2wmOLQ4=;
        b=c/C3FxAY/VQshfbT0EVrss4yybptekpVaLRj+ZnEH4iOoo868FtywXhQp6kEpUVcRs
         QFO2gsal8W1Qx91im4qONwBsyebsPLeDGuQ4zZRLaRTdIj+iOs/pZ2+OCpSqsCIj4mvM
         sz2pUpMhsRjPH0s96I/e60n6Amt/CX0/H0H+gVTq+ow12EoJuszhK/pAAFDU6C2+mKHz
         GZZkWte+iCTRdeGuH6V/oTR64tziMQiR9ZFc93CAMJUk9puzz9f8M3LjGAyRnamiLtFu
         R+tCm5QP8JO7D5IF/Pi1e6g3zK7LkrdIRhDjJKtPyfqK7XLkWo4xDORpwHuBg1FABlOp
         4cJw==
X-Gm-Message-State: AOAM532cOYMUZquiHH63LYgI/yNXmCKrJ1UX8TaAvG5EhOEElZp5/yaB
        9nweYqgJiFJZ/2/5XjnXRVTboT709Y5NJgYOw+syUav4ojC31PfQM99ApaNwTNadQQvg/3egxtr
        fYZBNDse/m8jo
X-Received: by 2002:a05:6214:52:b0:440:f824:a7f3 with SMTP id c18-20020a056214005200b00440f824a7f3mr680785qvr.125.1648665263568;
        Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpEYagEUKrFreUNZJWPbgOd2iyA4mWjJAcuNj/S06/ZmWXmhH8bpHqRFw8Cg5TxB9Aa+BVhQ==
X-Received: by 2002:a05:6214:52:b0:440:f824:a7f3 with SMTP id c18-20020a056214005200b00440f824a7f3mr680755qvr.125.1648665263302;
        Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id m14-20020a05622a054e00b002e2072cffe6sm17042300qtx.5.2022.03.30.11.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:34:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 20/26] KVM: x86/mmu: Extend Eager Page Splitting to
 the shadow MMU
Message-ID: <YkSirYT6s8YtUr4w@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-21-dmatlack@google.com>
 <YjG7Zh4zwTDsO3L1@xz-m1.local>
 <CALzav=fRFzbGEVhdMSwhX1Gs1++DGW6MOWvKzeQ-RTtLsus=SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=fRFzbGEVhdMSwhX1Gs1++DGW6MOWvKzeQ-RTtLsus=SQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 04:58:08PM -0700, David Matlack wrote:
> > > +static int prepare_to_split_huge_page(struct kvm *kvm,
> > > +                                   const struct kvm_memory_slot *slot,
> > > +                                   u64 *huge_sptep,
> > > +                                   struct kvm_mmu_page **spp,
> > > +                                   bool *flush,
> > > +                                   bool *dropped_lock)
> > > +{
> > > +     int r = 0;
> > > +
> > > +     *dropped_lock = false;
> > > +
> > > +     if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
> > > +             return -ENOSPC;
> > > +
> > > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > > +             goto drop_lock;
> > > +
> >
> > Not immediately clear on whether there'll be case that *spp is set within
> > the current function.  Some sanity check might be nice?
> 
> Sorry I'm not sure what you mean here. What kind of sanity check did
> you have in mind?

Something like "WARN_ON_ONCE(*spp);"?

> 
> >
> > > +     *spp = kvm_mmu_alloc_direct_sp_for_split(true);
> > > +     if (r)
> > > +             goto drop_lock;
> > > +
> > > +     return 0;

Thanks,

-- 
Peter Xu

