Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1212E67C1E0
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 01:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbjAZAko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 19:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbjAZAkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 19:40:42 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034835D906
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 16:40:40 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 129so336135ybb.0
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 16:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QVTikVh23Nz7/oqaTDhOJkfD1q44Rl1yIxrFbre07N0=;
        b=CH3EvuNcH2wu/g6Cp3i8babyajItVa/+5jMvo5bhlH4gR9YkKdjBqqF1QwDLbDefFk
         BbhyZLBIUguWHC7Sefp/9gc8u+3IxKr/ELNFyQZeFwLkG9R0nCQJowFvZ4J4t3xn+XPC
         gb90+JPF0it3hOEbXLwH4bXJN5jUTBTdar/1WTEgYTQQq44lnY9SGLT/9F7qY2vRopQ7
         1k3RtcnC8xdOEVF4nI2Wjgxh5CgMQgvftGJIy0fqRTrC71tMbQ1hoe5hYDZk86C1CrdS
         9Qn8CndYMyaUtJhrm30g0CyX8rF8dbVx57lQAM/eXyBpR0xMMD2C2+MUOw24jlwMJpCo
         M9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVTikVh23Nz7/oqaTDhOJkfD1q44Rl1yIxrFbre07N0=;
        b=ZWFJGLsT5MWBBPO0neJ/dN+z1OJqsIxlSkhQ42+s427X2nDUHGqYynMpfsSTRKbhPw
         +DaGH6hrxBTTvwUzvkNq9i8ge6kOZ1VzhFWkl5weauXd/OsBIIJMmZMQOjGW2Edh/30A
         sbcYYSwJXxpG0Cvmjaze4HEBXzVa/mNCzR+UdvoTGrNTIPxDOvXLUUdmD8UXjSlTAhb3
         TbofYTasGmLlaYDPZA4dts79Dbau4Qu08zOMIgmVbECOc8Eib2UH+SddlyIdQWOX8LN/
         86sVi8QZRxi6opFEwvvHjPORaSFuQH7WUrQFjTj/MQo7Z1jHzNYTTH8BS6qO8WyM5GWo
         nUVQ==
X-Gm-Message-State: AO0yUKVl5DGiZFY589noSyy0Y0tVYNkQqpOOs0vf88CirjzS0eexTMqS
        Zco5NCreaSS57SjpSnVa4yg36D+2IWaN/uOcDZK5E6srHvbqlo2V
X-Google-Smtp-Source: AK7set/rg5Hoq17c701zjKhz91B5ukooY+0NzK+QMijbnBsrMK1I/Ejyq+7ozm07l+RH2hguwmUXCe/r+OkRX+SI5yE=
X-Received: by 2002:a25:2f4e:0:b0:80b:cd4c:1674 with SMTP id
 v75-20020a252f4e000000b0080bcd4c1674mr123181ybv.401.1674693639196; Wed, 25
 Jan 2023 16:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20230125213857.824959-1-vipinsh@google.com> <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
In-Reply-To: <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 25 Jan 2023 16:40:03 -0800
Message-ID: <CAHVum0f=xKkE7YhPuQ-A9uOZMRMUSuiFcB3sxi0b_Bp837M5aQ@mail.gmail.com>
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jan 25, 2023 at 2:25 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Jan 25, 2023 at 2:00 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Jan 25, 2023 at 01:38:57PM -0800, Vipin Sharma wrote:
> > > @@ -736,7 +749,12 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > >
> > >       old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
> > >
> > > -     __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> > > +     if (record_dirty_log)
> > > +             __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte,
> > > +                                   level, false);
> > > +     else
> > > +             handle_changed_spte_clear_dirty_log(as_id, gfn, old_spte,
> > > +                                                 new_spte, level);
> >
> > I find it very non-intuitive to tie this behavior to !record_dirty_log,
> > even though it happens to work. It's also risky if any future calls are
> > added that pass record_dirty_log=false but change other bits in the
> > SPTE.
> >
> > I wonder if we could get the same effect by optimizing
> > __handle_changed_spte() to check for a cleared D-bit *first* and if
> > that's the only diff between the old and new SPTE, bail immediately
> > rather than doing all the other checks.
>
> I would also prefer that course. One big lesson I took when building
> the TDP MMU was the value of having all the changed PTE handling go
> through one function. That's not always the right choice but the
> Shadow MMU has a crazy spaghetti code of different functions which
> handle different parts of responding to a PTE change and it makes the
> code very hard to read. I agree this path is worth optimizing, but the
> more we can keep the code together, the better.

Let me see if I am able to get the same improvement in __handle_changed_spte().
