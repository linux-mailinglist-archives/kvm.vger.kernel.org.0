Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA5468185B
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbjA3SJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjA3SJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:09:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C732132
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:09:37 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so11946758pjl.0
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GwMCaJkiuu9dUQGSTtRfkqzhklHrqGUBoKCbRnwbvNA=;
        b=msNkNKQCARbow2quufuUP6XBXt05UKY9BuMS5QudCCTO7kZsCK65UDKC9L5jFRdfOa
         7IfOKoV3rWtjrmXsJUnQcMsvWSL5jVUAsvDtTODBEn6e/tG68Wc+bw7YdadMI5T7kj1Q
         SFTzsgaFawAAHKSuBNiQ7GhL3M/PL6rOmZCZ6eqQwe99Ntcd2AXxFeOkfSKTCWY3n5D/
         ZxoSlgHJAHkCgQhIa4Bj7UtZFvz/ybjzXXkK+BQ1G1GSE47KJ8s1a0fFmyDDW/0xtWej
         UnzwIRdCq1ITU9XgkFzEysWBNbgsmRCzzntQ4YtE7ITdrKKGIuCwYGFm/suUhgdVT+Vk
         AKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwMCaJkiuu9dUQGSTtRfkqzhklHrqGUBoKCbRnwbvNA=;
        b=rURnehr8VIE8UyfETZUWNLol3iVGl9WKBSXYRTKPDe//zWTa4LWHHyn6Dh5/UcAzaw
         gFs+EhYtK+oogUYA2EJxHmF+i3QqImKsQEht/SKuOm/Lv4tRWI56/YTXV5yN8bl/p7Us
         LzHVOOz1i3GSzddMRw3LKUHpBIaIg97dk0Qvw7erHuFreYhbqf43g69I+grG0AcZ+6g3
         7EYkiD9f5ORG72tNJasG3uPrNKxW4PUw6Dcgp+gza9Beqv+AKiXSEK0rVHbF10HWZuhj
         q/VG+fP8mPYiXY00mhHHmZJf9RLBQa3JINaU0YYeayB9bGB2ldvUH0RG/KvnG6QWywCt
         eaRQ==
X-Gm-Message-State: AO0yUKUGOU62t7MzP39M9Bj8ybmEwHYNsWdZSb0Sdn7dge5tc3oCkt5t
        X+EbEGR2gmvt2a/orKf1e96r/w==
X-Google-Smtp-Source: AK7set9alnel22luOhCFvoJXZvXQuKJoLkRDSJR3vVmhxW1Zfy1XrP8oMqDAOEs4hUK1xsFBML4wAw==
X-Received: by 2002:a17:903:2303:b0:196:5f76:1e8b with SMTP id d3-20020a170903230300b001965f761e8bmr827976plh.3.1675102176794;
        Mon, 30 Jan 2023 10:09:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m6-20020a170902db8600b001947738ec7fsm8095718pld.158.2023.01.30.10.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 10:09:36 -0800 (PST)
Date:   Mon, 30 Jan 2023 18:09:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
Message-ID: <Y9gH3OHA4ftegU7X@google.com>
References: <20230125213857.824959-1-vipinsh@google.com>
 <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
 <Y9HcHRBShQgjxsQb@google.com>
 <CAHVum0cd=YKvEKi7xZZHCTBn9XAxiax92JHV_W47R8rYvvnF-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cd=YKvEKi7xZZHCTBn9XAxiax92JHV_W47R8rYvvnF-g@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023, Vipin Sharma wrote:
> On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
> > -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -                               u64 old_spte, u64 new_spte, int level,
> > -                               bool shared)
> > -{
> > -       __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> > -                             shared);
> >         handle_changed_spte_acc_track(old_spte, new_spte, level);
> > -       handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> > -                                     new_spte, level);
> > +
> > +       /* COMMENT GOES HERE. */
> 
> Current "shared" callers are not making a page dirty. If a new
> "shared" caller makes a page dirty then make sure
> handle_changed_spte_dirty_log is called.
> 
> How is this?

I was hoping for a more definitive "rule" than "KVM doesn't currently do XYZ".

> > +       if (!shared)
> > +               handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> > +                                             new_spte, level);
> >  }
> >
> >  /*
> >   * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
> > - * and handle the associated bookkeeping.  Do not mark the page dirty
> > - * in KVM's dirty bitmaps.
> > + * and handle the associated bookkeeping.
> >   *
> >   * If setting the SPTE fails because it has changed, iter->old_spte will be
> >   * refreshed to the current value of the spte.

...

> > @@ -1703,9 +1657,11 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
> >                                 new_spte = iter.old_spte & ~shadow_dirty_mask;
> >                         else
> >                                 continue;
> > +
> > +                       kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
> >                 }
> >
> 
> Shouldn't we handle spte_ad_need_write_protect(iter.old_spte)
> separately and if this function returns true then on clearing
> PT_WRITABLE_MASK, kvm_set_pfn_dirty be called?
> My understanding is that the spte_ad_need_write_protect() will return
> true for nested VM sptes when PML mode is enabled.

Ah rats.  I missed that is_dirty_spte() checks WRITABLE in that case.  So yeah,
kvm_set_pfn_dirty() should be called in both paths.  I was thinking KVM would mark
the page dirty when faulting the PFN for write, but I have my flows all mixed up.
