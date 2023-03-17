Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2616BF69A
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 00:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCQXnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 19:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCQXnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 19:43:15 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796BF28E9B
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:43:14 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id g23so4399315uak.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679096593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6OqdmKbii1+Ph7+AGfmxKhon5E2C8txbe5dBoVF1nM=;
        b=p6dGlK37laE7jE2NsbWwb+gvv3K6U78o8hORtdrd/dBJoJBqZAWKgcAA4JHtgMYG/n
         Qd7xr/52pBIY2kaj116+/uRGo8NIW5tfVVH+cSi+hfR5/l92V4Y0031Kte1g0e0zvBKd
         birXg2IPBRg0V+PDqOWx60qW77iW4As9Zv9gn74pX9jS6vFlmzAtGRnVtmMpS704u7fh
         2PaWwai6QBpqTwRXD7J7vPojK3zk1obXf0lowllmkpDvPohl96sfx0342xtH/4Oc+Xnj
         h3+reo0lxPDmgVNAkHpQbOT/AOfgau1+u+T5/4rlfsQ+gGwhsyEFQxvTUxRf0qC7gouB
         cjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679096593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6OqdmKbii1+Ph7+AGfmxKhon5E2C8txbe5dBoVF1nM=;
        b=QFtoQC1hwDb2aL29qRqPvFbs64V4F51EqrmP8q/dpSfrfkajKbf72s++yHqzpmL3Mu
         CBM5/Jq3Wk0CZ8/8nS9GwNK2mn7YpYVY6AyptBecuDpzSu2dOgLBbGDd2VI9JS1QuLR6
         sfzVKgSWg4lzUsC9MPG9l3KUYOgelSdjazUQWduWBjByJfLuYykGrDPjEmjkM25MNE/G
         hqGINjP987T3J9MtZa+iM0ahhzTPetbxXifnNCg1UC3lU/GO+f/68TnCq53BgnFReeCg
         GOkWbQ/mGvsPOVOGVNeoveGE2m/9BzW2g1MgVYLzpr7Q4wZbPkfFkvQ3EwMF48Zi4X8C
         w6xQ==
X-Gm-Message-State: AO0yUKWZDNWOo40ceGuYXPVz6CAw0GcdYyYJQ9OJlEN6kODsAnlc8P+x
        gGgGGhlc3WIGz6MzkTIZpS+ueqgjwVmcBypOqxhKNQ==
X-Google-Smtp-Source: AK7set9hiPCkdQ/+calmY86QIuJ8/lh1RI63zI34Ym6Fjo4ERoKH1eriik204aBpGCgmLK/b4tVdm01O8sCfXQ7xNBE=
X-Received: by 2002:a1f:1e0c:0:b0:435:b4a5:d3c0 with SMTP id
 e12-20020a1f1e0c000000b00435b4a5d3c0mr175395vke.10.1679096593459; Fri, 17 Mar
 2023 16:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
 <ZBTTlNrWeT9f1mjZ@google.com>
In-Reply-To: <ZBTTlNrWeT9f1mjZ@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 16:42:37 -0700
Message-ID: <CAF7b7moHksTv6c=zSEmO0zg79cs4p513oSBtGmMooXL5+7828g@mail.gmail.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     jthoughton@google.com, kvm@vger.kernel.org
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

On Fri, Mar 17, 2023 at 1:17=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> And as I argued in the last version[*], I am _strongly_ opposed to KVM sp=
eculating
> on why KVM is exiting to userspace.  I.e. KVM should not set a special fl=
ag if
> the memslot has "fast only" behavior.  The only thing the flag should do =
is control
> whether or not KVM tries slow paths, what KVM does in response to an unre=
solved
> fault should be an orthogonal thing.

I'm guessing you would want changes to patch 10 of this series [*]
then, right? Setting a bit/exit reason in kvm_run::memory_fault.flags
depending on whether the failure originated from a "fast only" fault
is... exactly what I'm doing :/ I'm not totally clear on your usages
of the word "flag" above though, the "KVM should not set a special
flag... the only thing *the* flag should do" part is throwing me off a
bit. What I think you're saying is

"KVM should not set a special bit in kvm_run::memory_fault.flags if
the memslot has fast-only behavior. The only thing
KVM_MEM_ABSENT_MAPPING_FAULT should do is..."

[1] https://lore.kernel.org/all/20230315021738.1151386-11-amoorthy@google.c=
om/

On Fri, Mar 17, 2023 at 1:54=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Strictly speaking, if y'all buy my argument that the flag shouldn't contr=
ol the
> gup behavior, there won't be semantic differences for the memslot flag.  =
KVM will
> (obviously) behavior differently if KVM_CAP_MEMORY_FAULT_EXIT is not set,=
 but that
> will hold true for x86 as well.  The only difference is that x86 will als=
o support
> an orthogonal flag that makes the fast-only memslot flag useful in practi=
ce.
>
> So yeah, there will be an arch dependency, but only because arch code nee=
ds to
> actually handle perform the exit, and that's true no matter what.
>
> That said, there's zero reason to put X86 in the name.  Just add the capa=
bility
> as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the docume=
ntation.
>
> That said, there's zero reason to put X86 in the name.  Just add the capa=
bility
> as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the docume=
ntation.

Again, a little confused on your first "flag" usage here. I figure you
can't mean the memslot flag because the whole point of that is to
control the GUP behavior, but I'm not sure what else you'd be
referring to.

Anyways the idea of having orthogonal features, one to -EFAULTing
early before a slow path and another to transform/augment -EFAULTs
into/with useful information does make sense to me. But I think the
issue here is that we want the fast-only memslot flag to be useful on
Arm as well, and with KVM_CAP_MEMORY_FAULT_NOWAIT written as it is now
there is a semantic differences between x86 and Arm.

I don't see a way to keep the two features here orthogonal on x86 and
linked on arm without keeping that semantic difference. Perhaps the
solution here is a bare-bones implementation of
KVM_CAP_MEMORY_FAULT_EXIT for Arm? All that actually *needs* to be
covered to resolve this difference is the one call site in
user_mem_abort. since KVM_CAP_MEMORY_FAULT_EXIT will be allowed to
have holes anyways.
