Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A47C6C21FE
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjCTTys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCTTyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 15:54:44 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB171ADC7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 12:54:16 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id e12so3866096uaa.3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 12:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679342055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmKlEHd5lDVdblYYQfTmcOKjG1A+qwUi68rL/2+9+OU=;
        b=CVyGZS5ElhQkN0JAl8qStcpsoH9dSltU+ZBkuFiookVTRR/UnePf0WnoIjbDfCjhJb
         7DaCkhnT6WWPOMjaaOlj4kqRBDFi3tE1PEChfsgLc4enxPQx6mqqf+h50yuW3tvi/RYM
         WRPPkOZUhtsq3qBCMQDC+ymHxjFYbjHrVdMDjLI8lse3p1c/g0lvHD0SmlCCr+ISAP8P
         9sQgfaz3mfxoaHdelQBLpHwOSkWBqHn5QjYeQy+LkPtxLBrU/TxMmpo6aM/Mj+2WFeil
         hHAvHEpjZksplKvuWbcaaPK/OpVDVnkNyOW8ZtbvYZFR6wYzHK+7KxZ0rBReuWg0ASRl
         eLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmKlEHd5lDVdblYYQfTmcOKjG1A+qwUi68rL/2+9+OU=;
        b=2uFH5f4muxiFjBSc4Q18uB1UIafUEj4hy8Eij3XbflPpwxICumP8MyHNEL9NeDqiWP
         y566qgKa42kXhidnqp/fpjGeRbq2fbWjKw9dk+fTeE7J0wCtoLlExaIxmnz3540Lx3vm
         m+AwEhNvF5iCf5mf2znrz44qxtOLvybZb0Ppb70vyxYgyMSDKPHwBQqLEX9dlQ176QfB
         sjqFN0i+oJRZbQsIy1jcJnPibhMvFZdoym7FC+zrIYjBbHzIvk+6G2hfZlUFinF5NNpr
         zBRPDiMH0QD4s47CccLdRDa+yTxpx2N1qk9Hv/0W0tdCn37brPbmbvufnd3zTqZpo8Ib
         S5kw==
X-Gm-Message-State: AO0yUKVcRUp8D+DOSNz+0GqPj2xDK7zpxkk3WK03voUSwVZz8SKevq+U
        yoJEieDQG8cKlqla6cIc+UEhvAXdZCgS7kmsmaeNFA==
X-Google-Smtp-Source: AK7set/dbx3ar6C+pcdHXtUqHneyHD+3dZrOv1RUftDYZJtZ+h2yym50AepZL7m4Qis37jvvN4Dh818xPa9N4PWxYEY=
X-Received: by 2002:a1f:a0d5:0:b0:432:48db:732c with SMTP id
 j204-20020a1fa0d5000000b0043248db732cmr276259vke.1.1679342055027; Mon, 20 Mar
 2023 12:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
 <ZBTTlNrWeT9f1mjZ@google.com> <CAF7b7moHksTv6c=zSEmO0zg79cs4p513oSBtGmMooXL5+7828g@mail.gmail.com>
 <ZBh4EpKrIVGbQumu@google.com>
In-Reply-To: <ZBh4EpKrIVGbQumu@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 20 Mar 2023 12:53:38 -0700
Message-ID: <CAF7b7mr1KJGj5XztKjaduT3uw3Bz7Yg62-2ZU6Qy7t04=yrKWg@mail.gmail.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
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

On Mon, Mar 20, 2023 at 8:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 17, 2023, Anish Moorthy wrote:
> > On Fri, Mar 17, 2023 at 1:17=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > And as I argued in the last version[*], I am _strongly_ opposed to KV=
M speculating
> > > on why KVM is exiting to userspace.  I.e. KVM should not set a specia=
l flag if
> > > the memslot has "fast only" behavior.  The only thing the flag should=
 do is control
> > > whether or not KVM tries slow paths, what KVM does in response to an =
unresolved
> > > fault should be an orthogonal thing.
> >
> > I'm guessing you would want changes to patch 10 of this series [*]
> > then, right? Setting a bit/exit reason in kvm_run::memory_fault.flags
> > depending on whether the failure originated from a "fast only" fault
> > is... exactly what I'm doing :/ I'm not totally clear on your usages
> > of the word "flag" above though, the "KVM should not set a special
> > flag... the only thing *the* flag should do" part is throwing me off a
> > bit. What I think you're saying is
>
> Heh, the second "the flag" is referring to the memslot flag.  Rewriting t=
he above:
>
>   KVM should not set a special flag in kvm_run::memory_fault.flags ... th=
e
>   only thing KVM_MEM_FAST_FAULT_ONLY should do is ..."
>
> > "KVM should not set a special bit in kvm_run::memory_fault.flags if
> > the memslot has fast-only behavior. The only thing
> > KVM_MEM_ABSENT_MAPPING_FAULT should do is..."
> >
> > [1] https://lore.kernel.org/all/20230315021738.1151386-11-amoorthy@goog=
le.com/

Ok so, just to be clear, you are not opposed to

(a) all -EFAULTs from kvm_faultin_pfn populating the
kvm_run.memory_fault and setting kvm_run.memory_fault.flags to, say,
FAULTIN_FAILURE if/when kvm_cap_memory_fault_exit is enabled

but *are* opposed to

(b) the combination of the memslot flag and kvm_cap_memory_fault_exit
providing any additional information on top of: for instance, a
kvm_run.memory_fault.flags of FAULTIN_FAILURE & FAST_FAULT_ONLY.

Is that right?


> > On Fri, Mar 17, 2023 at 1:54=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Strictly speaking, if y'all buy my argument that the flag shouldn't c=
ontrol the
> > > gup behavior, there won't be semantic differences for the memslot fla=
g.  KVM will
> > > (obviously) behavior differently if KVM_CAP_MEMORY_FAULT_EXIT is not =
set, but that
> > > will hold true for x86 as well.  The only difference is that x86 will=
 also support
> > > an orthogonal flag that makes the fast-only memslot flag useful in pr=
actice.
> > >
> > > So yeah, there will be an arch dependency, but only because arch code=
 needs to
> > > actually handle perform the exit, and that's true no matter what.
> > >
> > > That said, there's zero reason to put X86 in the name.  Just add the =
capability
> > > as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the do=
cumentation.
> > >
> > > That said, there's zero reason to put X86 in the name.  Just add the =
capability
> > > as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the do=
cumentation.
> >
> > Again, a little confused on your first "flag" usage here. I figure you
> > can't mean the memslot flag because the whole point of that is to
> > control the GUP behavior, but I'm not sure what else you'd be
> > referring to.
> >
> > Anyways the idea of having orthogonal features, one to -EFAULTing
> > early before a slow path and another to transform/augment -EFAULTs
> > into/with useful information does make sense to me. But I think the
> > issue here is that we want the fast-only memslot flag to be useful on
> > Arm as well, and with KVM_CAP_MEMORY_FAULT_NOWAIT written as it is now
> > there is a semantic differences between x86 and Arm.
>
> If and only if userspace enables the capability that transforms -EFAULT.
>
> > I don't see a way to keep the two features here orthogonal on x86 and
> > linked on arm without keeping that semantic difference. Perhaps the
> > solution here is a bare-bones implementation of
> > KVM_CAP_MEMORY_FAULT_EXIT for Arm? All that actually *needs* to be
> > covered to resolve this difference is the one call site in
> > user_mem_abort. since KVM_CAP_MEMORY_FAULT_EXIT will be allowed to
> > have holes anyways.
>
> As above, so long as userspace must opt into transforming -EFAULT, and ca=
n do
> so independent of KVM_MEM_FAST_FAULT_ONLY (or whatever we call it), the b=
ehavior
> of KVM_MEM_FAST_FAULT_ONLY itself is semantically identical across all
> architectures.
>
> KVM_MEM_FAST_FAULT_ONLY is obviously not very useful without precise info=
rmation
> about the failing address, but IMO that's not reason enough to tie the tw=
o
> together.
