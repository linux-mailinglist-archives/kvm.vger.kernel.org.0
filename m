Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E44B2DDE
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 20:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346901AbiBKTir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 14:38:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiBKTiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 14:38:46 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B7BCEB
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 11:38:44 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id q22so13860444ljh.7
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 11:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJqXyhceq7GUP1xyb1H5uP8ZCL2EIyPfZA6lTRew5yk=;
        b=nK75MzXPk1Og5DF8TEwxL8A3Ihk5G3SoyK2htdoZv/JgpqRY/LE566YdPgOIQP1XHu
         6qwjnzVEg05ATA9k0qergsadjwksDzPWM6nPgJ/6VElQd2wUHJDbuBZL44D5FOLEKnrY
         eAuvuAW6vQWCJ3BF1zELGrr5c3caER4x4TN3es/pYmMAfbBKNnhIfoM7QCxtbKlnUdBk
         IUxKFAdWhbfp4G11sXpNMLzwuKe8pX7W3tfy3aoyXPFe0Aqg0Q2j1qsCMvasJJ2v/J3F
         ilrgmc6T44jsAU+1sV4wSeQ7+9B7BpIEBpWsm2TblSBacr1AaBO2urHJeRLCMSHEl0Dc
         UNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJqXyhceq7GUP1xyb1H5uP8ZCL2EIyPfZA6lTRew5yk=;
        b=Px+AQnd6rNPEFPhOcdwDecTgnq0DB6IL85/QgnVZw4nmG3AIZzEGjy90GEC+tfbiJ0
         YFia62bxd9RgrcAEpDP1ycmrLCilIZj9mafYOZKjgqUfF0ox4xzOiT5CLsVz4eXKERiZ
         f2qulp/XWhfwhBlQXzI/CpDwlL424bYfadUQbvDrN0fFRv1RmFQEj/m0et1/uBk0fmy9
         61l/Ffn4DObe648SSS0SDFXuG6zONSOoP3TkfpIWxsQg/ebeMQ8RT4A1G3OJV9kqv/w+
         PQtihb0X7bXiW+qKNau9sHxsceSOOdlJboKQ7aqYVhx+zOZrsw727008d3PCh6Qt3Vev
         5kgw==
X-Gm-Message-State: AOAM530gTllundEcHTgUg+8u2V4cy1FPCqe1WwmUKflkC/o0YNtzfbmO
        soNHl/PzDUdpHJiNR/hR6slft8+rsJIXx1yLCj1twA==
X-Google-Smtp-Source: ABdhPJxO8RGkJaN8by+e1FmoAk9vlcPrHmlkLMgaFhX8cGowxp0QRzcoDJ/NGqtGgKms3x1ch5xS/GoTZ+1LNMK4ZZg=
X-Received: by 2002:a2e:a781:: with SMTP id c1mr1830386ljf.527.1644608322049;
 Fri, 11 Feb 2022 11:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20220111154048.2108264-1-pgonda@google.com> <YgGo/5GyJVfGH00T@google.com>
In-Reply-To: <YgGo/5GyJVfGH00T@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 11 Feb 2022 12:38:30 -0700
Message-ID: <CAMkAt6qh+8kw5w52wCq=foyxnPQy+=M4OF23UrA4tP1x3fN2Rg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Allow SEV intra-host migration of VM with mirrors
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 7, 2022 at 4:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 11, 2022, Peter Gonda wrote:
> > @@ -1623,22 +1624,41 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> >       }
> >  }
> >
> > -static void sev_migrate_from(struct kvm_sev_info *dst,
> > -                           struct kvm_sev_info *src)
> > +static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
> >  {
> > +     struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
> > +     struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
> > +     struct kvm_sev_info *mirror, *tmp;
> > +
> >       dst->active = true;
> >       dst->asid = src->asid;
> >       dst->handle = src->handle;
> >       dst->pages_locked = src->pages_locked;
> >       dst->enc_context_owner = src->enc_context_owner;
> > +     dst->num_mirrored_vms = src->num_mirrored_vms;
> >
> >       src->asid = 0;
> >       src->active = false;
> >       src->handle = 0;
> >       src->pages_locked = 0;
> >       src->enc_context_owner = NULL;
> > +     src->num_mirrored_vms = 0;
> >
> >       list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
> > +     list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
> > +
> > +     /*
> > +      * If this VM has mirrors we need to update the KVM refcounts from the
> > +      * source to the destination.
> > +      */
>
> It's worth calling out that a reference is being taken on behalf of the mirror,
> that detail is easy to miss.  And maybe call out that the caller holds a reference
> to @src_kvm?
>
>         /*
>          * If this VM has mirrors, "transfer" each mirror's refcount of the
>          * source to the destination (this KVM).  The caller holds a reference
>          * to the source, so there's no danger of use-after-free.
>          */

Thanks took your comment.

>
> > +     if (dst->num_mirrored_vms > 0) {
> > +             list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
> > +                                       mirror_entry) {
> > +                     kvm_get_kvm(dst_kvm);
> > +                     kvm_put_kvm(src_kvm);
> > +                     mirror->enc_context_owner = dst_kvm;
> > +             }
> > +     }
> >  }
> >
> >  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>
> ...
>
> > @@ -2050,10 +2062,17 @@ void sev_vm_destroy(struct kvm *kvm)
> >       if (is_mirroring_enc_context(kvm)) {
> >               struct kvm *owner_kvm = sev->enc_context_owner;
> >               struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
> > +             struct kvm_sev_info *mirror, *tmp;
> >
> >               mutex_lock(&owner_kvm->lock);
> >               if (!WARN_ON(!owner_sev->num_mirrored_vms))
> >                       owner_sev->num_mirrored_vms--;
> > +
> > +             list_for_each_entry_safe(mirror, tmp, &owner_sev->mirror_vms,
> > +                                       mirror_entry)
> > +                     if (mirror == sev)
> > +                             list_del(&mirror->mirror_entry);
> > +
>
> There's no need to walk the list just to find the entry you already have.  Maaaaybe
> if you were sanity checking, but it's not like we can do anything helpful if the
> sanity check fails, so eating a #GP due to consuming e.g. LIST_POISON1 is just as
> good as anything else.
>
>         if (is_mirroring_enc_context(kvm)) {
>                 struct kvm *owner_kvm = sev->enc_context_owner;
>
>                 mutex_lock(&owner_kvm->lock);
>                 list_del(&->mirror_entry);
>                 mutex_unlock(&owner_kvm->lock);
>                 kvm_put_kvm(owner_kvm);
>                 return;
>         }

Thats better thanks.

>
> >               mutex_unlock(&owner_kvm->lock);
> >               kvm_put_kvm(owner_kvm);
> >               return;
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index daa8ca84afcc..b9f5e33d5232 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -81,6 +81,10 @@ struct kvm_sev_info {
> >       u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
> >       struct kvm *enc_context_owner; /* Owner of copied encryption context */
> >       unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
> > +     union {
> > +             struct list_head mirror_vms; /* List of VMs mirroring */
> > +             struct list_head mirror_entry; /* Use as a list entry of mirrors */
> > +     };
>
>
> Whoops.  IIRC, I suggested a union for tracking mirrors vs mirrored.  After seeing
> the code, that was a bad suggestion.  Memory isn't at a premimum for a per-VM
> object, so storing an extra list_head is a non-issue.
>
> If we split the two, then num_mirrored_vms goes away, and more importantly we won't
> have to deal with bugs where we inevitably forget to guard access to the union with
> a check against num_mirrored_vms.
>
> E.g. (completely untested and probably incomplete)

Done. Thats more readable I think now.

>
> ---
>  arch/x86/kvm/svm/sev.c | 32 +++++++++-----------------------
>  arch/x86/kvm/svm/svm.h |  7 ++-----
>  2 files changed, 11 insertions(+), 28 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 369cf8c4da61..41f7e733c33e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1635,29 +1635,25 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>         dst->handle = src->handle;
>         dst->pages_locked = src->pages_locked;
>         dst->enc_context_owner = src->enc_context_owner;
> -       dst->num_mirrored_vms = src->num_mirrored_vms;
>
>         src->asid = 0;
>         src->active = false;
>         src->handle = 0;
>         src->pages_locked = 0;
>         src->enc_context_owner = NULL;
> -       src->num_mirrored_vms = 0;
>
>         list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>         list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
>
>         /*
> -        * If this VM has mirrors we need to update the KVM refcounts from the
> -        * source to the destination.
> +        * If this VM has mirrors, "transfer" each mirror's refcount from the
> +        * source to the destination (this KVM).  The caller holds a reference
> +        * to the source, so there's no danger of use-after-free.
>          */
> -       if (dst->num_mirrored_vms > 0) {
> -               list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
> -                                         mirror_entry) {
> -                       kvm_get_kvm(dst_kvm);
> -                       kvm_put_kvm(src_kvm);
> -                       mirror->enc_context_owner = dst_kvm;
> -               }
> +       list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms, mirror_entry) {
> +               kvm_get_kvm(dst_kvm);
> +               kvm_put_kvm(src_kvm);
> +               mirror->enc_context_owner = dst_kvm;
>         }
>  }
>
> @@ -2019,7 +2015,6 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>          */
>         source_sev = &to_kvm_svm(source_kvm)->sev_info;
>         kvm_get_kvm(source_kvm);
> -       source_sev->num_mirrored_vms++;
>         mirror_sev = &to_kvm_svm(kvm)->sev_info;
>         list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>
> @@ -2053,7 +2048,7 @@ void sev_vm_destroy(struct kvm *kvm)
>         struct list_head *head = &sev->regions_list;
>         struct list_head *pos, *q;
>
> -       WARN_ON(sev->num_mirrored_vms);
> +       WARN_ON(!list_empty(&sev->mirror_vms));
>
>         if (!sev_guest(kvm))
>                 return;
> @@ -2061,18 +2056,9 @@ void sev_vm_destroy(struct kvm *kvm)
>         /* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
>         if (is_mirroring_enc_context(kvm)) {
>                 struct kvm *owner_kvm = sev->enc_context_owner;
> -               struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
> -               struct kvm_sev_info *mirror, *tmp;
>
>                 mutex_lock(&owner_kvm->lock);
> -               if (!WARN_ON(!owner_sev->num_mirrored_vms))
> -                       owner_sev->num_mirrored_vms--;
> -
> -               list_for_each_entry_safe(mirror, tmp, &owner_sev->mirror_vms,
> -                                         mirror_entry)
> -                       if (mirror == sev)
> -                               list_del(&mirror->mirror_entry);
> -
> +               list_del(&mirror->mirror_entry);
>                 mutex_unlock(&owner_kvm->lock);
>                 kvm_put_kvm(owner_kvm);
>                 return;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0876329f273d..79bf568c2558 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,11 +79,8 @@ struct kvm_sev_info {
>         struct list_head regions_list;  /* List of registered regions */
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
> -       unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
> -       union {
> -               struct list_head mirror_vms; /* List of VMs mirroring */
> -               struct list_head mirror_entry; /* Use as a list entry of mirrors */
> -       };
> +       struct list_head mirror_vms; /* List of VMs mirroring */
> +       struct list_head mirror_entry; /* Use as a list entry of mirrors */
>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
>         atomic_t migration_in_progress;
>  };
>
> base-commit: 618a9a6fda17f48d86a1ce9851bd8ceffdc57d75

I added a base commit to my V2 patch.

> --
>
