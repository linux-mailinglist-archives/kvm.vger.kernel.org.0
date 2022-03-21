Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B34E2EB6
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351560AbiCURDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351665AbiCURDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:03:17 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F167179417
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:01:51 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2e5757b57caso162919837b3.4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+wORUoNfICBtxmGPwtdgPTUaJLcSyMgmBDuQ2HCAno=;
        b=IeyG5ExpMtTqyaIwUHCF/IOH7aYaWYNAr1yot4O1eNYRTzjb0lkspVlKTsPwL8phzi
         606KemObIc7ChoYqhUL65J3/Y9r7y1h4k5p4lK4SxACbwwpL5J/ES2jZbiSTC8zjYxw3
         EjJHOoWPC+LkY8cjfj1HUTqloG6/ygcXnnSvc7+tYlJLuAR9aKDBt6QxDUN7rJsKzBkA
         V7GAGPUS1zBcgASkBCxxTWbXgtTgAzvFW7ylslsR2P3nMwzlolgI3cONVlIyZR9eK4OU
         Zmh2xfrYm+cPLFWBAGWW/TkKsGtop8E0wyCImRneAZEvwYbd4sIcXnEGv0YgIYNYuCOj
         /ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+wORUoNfICBtxmGPwtdgPTUaJLcSyMgmBDuQ2HCAno=;
        b=3M7SRDLz3et0HnV6uJIS31xWGyyZY7rsrYw2y1lWhVsWQ8/o6o6UnptDMsX5BW66U0
         VHb6LvEsTp2tjAoUq83muC42Awu9BEJnYn9HDycUPUhXiNMPduKpb76YEc5cN8I4qUn+
         /UDIm/qA/u9VYrVYcCpE1l1gHdWSqzj9GlRl4M0r4N9wIuUebNmINJxXogq4/CQazhtM
         pi0FdL9ihMiSg3+rjXmyW/sMoQU6LCvlGx5R+p7yziX23J4ygSxbPY22OD9Cajlgs0SC
         JUaj1celaWLjXO3Vq7lEwtvSM6IL+pJ1z0GG9HRrEYj7uUnNkkF5s47WDB9I9t4gUmmh
         YnUA==
X-Gm-Message-State: AOAM530kaJ0hOMyQNCtoyj3x2cVLp8E7D4W4D3WfY4YpsQlILUCBg/xU
        i+Sp1KxhZ3qXvoBmz0Cv2SjQYuQ3btGf43k3D9djUw==
X-Google-Smtp-Source: ABdhPJy5WiSeEDwjtsW7VTh7ar42L2Iwd9KZtr8ajbdqynfYg2O5DFVnLDKH95thDtcrPtTUuOYSD5sxkur7ut9Ijts=
X-Received: by 2002:a81:15ce:0:b0:2e5:e189:7366 with SMTP id
 197-20020a8115ce000000b002e5e1897366mr16268503ywv.188.1647882110705; Mon, 21
 Mar 2022 10:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com> <20220311060207.2438667-3-ricarkol@google.com>
 <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com> <YjTrz40SD3HmebBh@google.com>
In-Reply-To: <YjTrz40SD3HmebBh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 21 Mar 2022 10:01:39 -0700
Message-ID: <CANgfPd9kbyfkOoBasqMtDuC4SD=j99Y0fMReC8hOHDOYhv5AQQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 1:30 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Mar 16, 2022 at 12:08:23PM -0600, Ben Gardon wrote:
> > On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > Add a library function to get the backing source FD of a memslot.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >
> > This appears to be dead code as of this commit, would recommend
> > merging it into the commit in which it's actually used.
>
> I was trying to separate lib changes (which are mostly arch independent)
> with the actual test. Would move the commit to be right before the one
> that uses be better? and maybe add a commit comment mentioning how it's
> going to be used.

Ah, that makes sense, I can see why you'd want to separate them.
Moving it right before the commit where it's used sounds fine to me.
Thanks!

>
>
> >
> > > ---
> > >  .../selftests/kvm/include/kvm_util_base.h     |  1 +
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
> > >  2 files changed, 24 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > index 4ed6aa049a91..d6acec0858c0 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> > >  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> > >  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
> > >  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> > > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
> > >  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> > >  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
> > >  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index d8cf851ab119..64ef245b73de 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> > >         return &region->region;
> > >  }
> > >
> > > +/*
> > > + * KVM Userspace Memory Get Backing Source FD
> > > + *
> > > + * Input Args:
> > > + *   vm - Virtual Machine
> > > + *   memslot - KVM memory slot ID
> > > + *
> > > + * Output Args: None
> > > + *
> > > + * Return:
> > > + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> > > + *
> > > + * Returns the backing source fd of a memslot, so tests can use it to punch
> > > + * holes, or to setup permissions.
> > > + */
> > > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> > > +{
> > > +       struct userspace_mem_region *region;
> > > +
> > > +       region = memslot2region(vm, memslot);
> > > +       return region->fd;
> > > +}
> > > +
> > >  /*
> > >   * VCPU Find
> > >   *
> > > --
> > > 2.35.1.723.g4982287a31-goog
> > >
