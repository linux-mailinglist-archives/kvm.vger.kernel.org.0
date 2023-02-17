Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9494F69B2E0
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 20:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBQTOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 14:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQTOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 14:14:51 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639F8305DB
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:14:50 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id by12so1032808vkb.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676661289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVTO4xFWAbGUXR7DKM9UY+o8NK6Xjb5cc7LUCkAe5ek=;
        b=TU7EaOIss2LMxfhHnSjxTI6eATQnooPOFypZFBxEiVOBoLDGsyOw/HtoRQqxytLRxR
         ZHqZ4VqQazMQ+Rw6mZUCmhedaI3yNc+Nx7Y9bLqzxx4XnrUWrK9GvwbFQyiZwvqfBaG3
         zGQKYSe5GCXV1EDgsYMazGLXL42HwtcfScBDROnVkBNzoEiEpfTrbUUsatsnhtO5236Y
         1G+K/N88GmD2yk4eU3sDhwxdA3/UeAR4NXVUg1RcGp7TDPJmOUiE4FAMhulbQsV0nWlX
         fJREDwCi1v32zQFx/qt+PWn6SPVnSrbrdsTBFjd+7SXh+NsjMI/wH+o/lNQP+VyhvFQq
         oT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676661289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVTO4xFWAbGUXR7DKM9UY+o8NK6Xjb5cc7LUCkAe5ek=;
        b=Yi7ewHzRkIp1UeKqO/kjAqj9MghSlz69wusc7/0vi0GCK7ilniF8w9AL9yfi0Q0YoJ
         YmZk5Pn1hGYHOBrP74HzM+lZ779k1UZ1kXY9ahH7FcJOpiS49V5xKueauwj48sODPcAs
         yOMWybO151Eg2ds217avf6N7JVybb0LNUejZqkoL/KvqpvnNllwQPhCaNHrjiiiPwXbz
         Hq1QvZZlLDL+HQFAHRJzdMt90BA8GOHJPPeFYvNGFEhOo3ojBLhFiJKdMAnLmgILZhgS
         gtUDV7P4RhKF701/4vkg3+TGpawuxbtXkbRnogLkGqyW+BoRp1Us1mjvHdndDFxxocQ6
         t0yA==
X-Gm-Message-State: AO0yUKW8bom8N0nTSeAXknlS2Vr1UWB5aDMf5ACd2mqpJ0CA4Zr2ZFAs
        qdYe70QUqX4uuZKaXF3gq+5pUSFg4OEPOlkekQSkVg==
X-Google-Smtp-Source: AK7set/nHg4O75YDiKYZI5ub4C/e2MbSF/pXe3H9JppCXn0NtJ+NxhDAJ16lg+WneuYDne2Gfma8eR4+a1Hn7LtP/bY=
X-Received: by 2002:a1f:2fd1:0:b0:407:fb48:8105 with SMTP id
 v200-20020a1f2fd1000000b00407fb488105mr183223vkv.38.1676661289103; Fri, 17
 Feb 2023 11:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com>
In-Reply-To: <Y+6iX6a22+GEuH1b@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Feb 2023 11:14:37 -0800
Message-ID: <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Feb 16, 2023 at 10:53=E2=80=AFAM Anish Moorthy <amoorthy@google.com=
> wrote:
>
> On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> wr=
ote:
> >
> > How is userspace expected to differentiate the gup_fast() failed exit
> > from the guest-private memory exit? I don't think flags are a good idea
> > for this, as it comes with the illusion that both events can happen on =
a
> > single exit. In reality, these are mutually exclusive.
> >
> > A fault type/code would be better here, with the option to add flags at
> > a later date that could be used to further describe the exit (if
> > needed).
>
> Agreed. Something like this, then?
>
> +    struct {
> +        __u32 fault_code;
> +        __u64 reserved;
> +        __u64 gpa;
> +        __u64 size;
> +    } memory_fault;
>
> The "reserved" field is meant to be the placeholder for a future "flags" =
field.
> Let me know if there's a better/more conventional way to achieve this.

On Thu, Feb 16, 2023 at 10:53=E2=80=AFAM Anish Moorthy <amoorthy@google.com=
> wrote:
>
> 1. As Oliver touches on earlier, we'll probably want to use this same fie=
ld for
>    different classes of memory fault in the future (such as the ones whic=
h Chao
>    is introducing in [1]): so it does make sense to add "code" and "flags=
"
>    fields which can be used to communicate more information to the user (=
and
>    which can just be set to MEM_FAULT_NOWAIT/0 in this series).

Let me walk back my responses here: I took a closer look at Chao's series, =
and
it doesn't seem that I should be trying to share KVM_EXIT_MEMORY_FAULT with=
 it
in the first place. As far as I can understand (not that much, to be clear =
:)
we're signaling unrelated things, so it makes more sense to use different e=
xits
(ie, rename mine to KVM_EXIT_MEMORY_FAULT_NOWAIT). That would prevent any
potential confusion about mutual exclusivity.

That also removes the need for a "fault_code" field in "memory_fault", whic=
h I
could rename to something more general like "guest_memory_range". As for th=
e
"reserved" field, we could keep it around if we care about reusing
"guest_memory_range" between exits, or discard it if we don't.

On Thu, Feb 16, 2023 at 1:38=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Feb 16, 2023, Anish Moorthy wrote:
> > On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> =
wrote:
> > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > index 109b18e2789c4..9352e7f8480fb 100644
> > > > > --- a/include/linux/kvm_host.h
> > > > > +++ b/include/linux/kvm_host.h
> > > > > @@ -801,6 +801,9 @@ struct kvm {
> > > > >     bool vm_bugged;
> > > > >     bool vm_dead;
> > > > >
> > > > > +   rwlock_t mem_fault_nowait_lock;
> > > > > +   bool mem_fault_nowait;
> > > >
> > > > A full-fat rwlock to protect a single bool? What benefits do you
> > > > expect from a rwlock? Why is it preferable to an atomic access, or =
a
> > > > simple bitop?
> > >
> > > There's no need to have any kind off dedicated atomicity.  The only r=
eaders are
> > > in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs a=
re created.
> >
> > I think we do need atomicity here.
>
> Atomicity, yes.  Mutually exclusivity, no.  AFAICT, nothing will break if=
 userspace
> has multiple in-flight calls to toggled the flag.  And if we do want to g=
uarantee
> there's only one writer, then kvm->lock or kvm->slots_lock will suffice.
>
> > Since we want to support this without having to pause vCPUs, there's an
> > atomicity requirement.
>
> Ensuring that vCPUs "see" the new value and not corrupting memory are two=
 very
> different things.  Making the flag an atomic, wrapping with a rwlock, etc=
... do
> nothing to ensure vCPUs observe the new value.  And for non-crazy usage o=
f bools,
> they're not even necessary to avoid memory corruption...

Oh, that's news to me- I've learned to treat any unprotected concurrent acc=
esses
to memory as undefined behavior: guess there's always more to learn.

> I think what you really want to achieve is that vCPUs observe the NOWAIT =
flag
> before KVM returns to userspace.  There are a variety of ways to make tha=
t happen,
> but since this all about accessing guest memory, the simplest is likely t=
o
> "protect" the flag with kvm->srcu, i.e. require SRCU be held by readers a=
nd then
> do a synchronize_srcu() to ensure all vCPUs have picked up the new value.
>
> Speaking of SRCU (which protect memslots), why not make this a memslot fl=
ag?  If
> the goal is to be able to turn the behavior on/off dynamically, wouldn't =
it be
> beneficial to turn off the NOWAIT behavior when a memslot is fully transf=
ered?

Thanks for the suggestions, I never considered making this a memslot flag
actually. so I'll go look into that.
