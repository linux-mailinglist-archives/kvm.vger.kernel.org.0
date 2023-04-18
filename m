Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0C6E6AC5
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjDRRRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbjDRRRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:17:50 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7E3B472
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:17:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4ec8133c1feso2391767e87.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681838265; x=1684430265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vKm2QA4Z7z2PgvahkSHjoU+vQH6E9mN4eaKiKCtOoU=;
        b=6iQ4Bmd9TRR+Arb9hXMlDhyC++Zo1iPW5ruyANVIXhdZZ2hO+35p/4unl84A43scOx
         g9MEvEfQxqcdATnHjl/yrWZWhhn6mGHvlTJwIhan3AqsejZpfZjd5HINhWgOnFy4ncrB
         BvBI2gczB9Oj5Q/kCCtGCQI6DOCIcDuzNDzi0+IlRJH7fpdW/z3BrjhE1WICjtx1drGB
         PEcnGUCAxalgsjRqisAOHdqTEgZXUTJuP0fzjceJ7L+u+H+F6laUGTur1ZvfAlYZMo7y
         UR2Gr6zrC0vFw4LjKh2Er5thhoHZ28H5gj74mVqwCe1O4T1G/bxcpkG9LFdknsjRPCoo
         lEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681838265; x=1684430265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vKm2QA4Z7z2PgvahkSHjoU+vQH6E9mN4eaKiKCtOoU=;
        b=Rd+1+HGvuk8S86zu2/obmputoZ6NRJYeHs14bS1rT6KrvsrVqfrDKa5Q+CSMoc9TSq
         0FguknbQnDPoSdtUSNzHRkgfZ4wV/NXziXb47kVa7I5g/BNOPYwEmawE877GVuPfB+Uq
         JkB7QR0fP/9hNkhiMunlDfWsyugEOxcsn/83VePGiZBtlJI+3GdN8m4uZWzvczbHRV4W
         pJ9FtiViFrMGrF9aMjC2g/BjxIJwoQIXd2UBPAFGAovvbiRwGx1+T5hHbod+cBujZQOx
         cmO/QEy8uF0is3h53rvIyUqU4vXfiydTIIoQXiQAF14s56VgtwIpTrFJGg+GJ8mXiFNX
         EWFw==
X-Gm-Message-State: AAQBX9daTE7h3eG502AMYt9c1xNQYmpsXNU9T1tUIgujklXKFh+F/cvK
        jVkz5YugZMpkdProPsyPLagclFNKV3OjHFjIBNXSCntzZyPuGcz7/0YKSQ==
X-Google-Smtp-Source: AKy350ZXxnqH/JTTSf2Dx04pKSKM6s55fG5RiAVwYBCflq3W49UA3B+hjlkkppvnOCzozYkScg3XmP82DYN5ay86kOM=
X-Received: by 2002:ac2:4428:0:b0:4ec:893d:3ada with SMTP id
 w8-20020ac24428000000b004ec893d3adamr3345508lfl.9.1681838265185; Tue, 18 Apr
 2023 10:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com> <20230407201921.2703758-3-sagis@google.com>
 <20230417224546.00001f73.zhi.wang.linux@gmail.com>
In-Reply-To: <20230417224546.00001f73.zhi.wang.linux@gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 18 Apr 2023 10:17:32 -0700
Message-ID: <CAAhR5DFg9-2OayDTOU=jLxZP-uGWnbOmoJ3Ze8rJn-g_12N+Vg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] KVM: SEV: Refactor common code out of sev_vm_move_enc_context_from
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Apr 17, 2023 at 12:45=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com=
> wrote:
>
> On Fri,  7 Apr 2023 20:19:18 +0000
> Sagi Shahar <sagis@google.com> wrote:
>
> > Both SEV and TDX are going to use similar flows for intra-host
> > migration. This change moves some of the code which will be used by bot=
h
> > architecture into shared code in x86.h
> >
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 175 +++++------------------------------------
> >  arch/x86/kvm/x86.c     | 166 ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.h     |  16 ++++
> >  3 files changed, 201 insertions(+), 156 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c25aeb550cd97..18831a0b7734e 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1553,116 +1553,6 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_=
id)
> >       return false;
> >  }
> >
> > -static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
> > -{
> > -     struct kvm_sev_info *dst_sev =3D &to_kvm_svm(dst_kvm)->sev_info;
> > -     struct kvm_sev_info *src_sev =3D &to_kvm_svm(src_kvm)->sev_info;
> > -     int r =3D -EBUSY;
> > -
> > -     if (dst_kvm =3D=3D src_kvm)
> > -             return -EINVAL;
> > -
> > -     /*
> > -      * Bail if these VMs are already involved in a migration to avoid
> > -      * deadlock between two VMs trying to migrate to/from each other.
> > -      */
> > -     if (atomic_cmpxchg_acquire(&dst_sev->migration_in_progress, 0, 1)=
)
> > -             return -EBUSY;
> > -
> > -     if (atomic_cmpxchg_acquire(&src_sev->migration_in_progress, 0, 1)=
)
> > -             goto release_dst;
> > -
> > -     r =3D -EINTR;
> > -     if (mutex_lock_killable(&dst_kvm->lock))
> > -             goto release_src;
> > -     if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTI=
NG))
> > -             goto unlock_dst;
> > -     return 0;
> > -
> > -unlock_dst:
> > -     mutex_unlock(&dst_kvm->lock);
> > -release_src:
> > -     atomic_set_release(&src_sev->migration_in_progress, 0);
> > -release_dst:
> > -     atomic_set_release(&dst_sev->migration_in_progress, 0);
> > -     return r;
> > -}
> > -
> > -static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kv=
m)
> > -{
> > -     struct kvm_sev_info *dst_sev =3D &to_kvm_svm(dst_kvm)->sev_info;
> > -     struct kvm_sev_info *src_sev =3D &to_kvm_svm(src_kvm)->sev_info;
> > -
> > -     mutex_unlock(&dst_kvm->lock);
> > -     mutex_unlock(&src_kvm->lock);
> > -     atomic_set_release(&dst_sev->migration_in_progress, 0);
> > -     atomic_set_release(&src_sev->migration_in_progress, 0);
> > -}
> > -
> > -/* vCPU mutex subclasses.  */
> > -enum sev_migration_role {
> > -     SEV_MIGRATION_SOURCE =3D 0,
> > -     SEV_MIGRATION_TARGET,
> > -     SEV_NR_MIGRATION_ROLES,
> > -};
> > -
> > -static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> > -                                     enum sev_migration_role role)
> > -{
> > -     struct kvm_vcpu *vcpu;
> > -     unsigned long i, j;
> > -
> > -     kvm_for_each_vcpu(i, vcpu, kvm) {
> > -             if (mutex_lock_killable_nested(&vcpu->mutex, role))
> > -                     goto out_unlock;
> > -
> > -#ifdef CONFIG_PROVE_LOCKING
> > -             if (!i)
> > -                     /*
> > -                      * Reset the role to one that avoids colliding wi=
th
> > -                      * the role used for the first vcpu mutex.
> > -                      */
> > -                     role =3D SEV_NR_MIGRATION_ROLES;
> > -             else
> > -                     mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> > -#endif
> > -     }
> > -
> > -     return 0;
> > -
> > -out_unlock:
> > -
> > -     kvm_for_each_vcpu(j, vcpu, kvm) {
> > -             if (i =3D=3D j)
> > -                     break;
> > -
> > -#ifdef CONFIG_PROVE_LOCKING
> > -             if (j)
> > -                     mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THI=
S_IP_);
> > -#endif
> > -
> > -             mutex_unlock(&vcpu->mutex);
> > -     }
> > -     return -EINTR;
> > -}
> > -
> > -static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> > -{
> > -     struct kvm_vcpu *vcpu;
> > -     unsigned long i;
> > -     bool first =3D true;
> > -
> > -     kvm_for_each_vcpu(i, vcpu, kvm) {
> > -             if (first)
> > -                     first =3D false;
> > -             else
> > -                     mutex_acquire(&vcpu->mutex.dep_map,
> > -                                   SEV_NR_MIGRATION_ROLES, 0, _THIS_IP=
_);
> > -
> > -             mutex_unlock(&vcpu->mutex);
> > -     }
> > -}
> > -
> >  static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
> >  {
> >       struct kvm_sev_info *dst =3D &to_kvm_svm(dst_kvm)->sev_info;
> > @@ -1744,25 +1634,6 @@ static void sev_migrate_from(struct kvm *dst_kvm=
, struct kvm *src_kvm)
> >       }
> >  }
> >
> > -static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
> > -{
> > -     struct kvm_vcpu *src_vcpu;
> > -     unsigned long i;
> > -
> > -     if (!sev_es_guest(src))
> > -             return 0;
> > -
> > -     if (atomic_read(&src->online_vcpus) !=3D atomic_read(&dst->online=
_vcpus))
> > -             return -EINVAL;
> > -
> > -     kvm_for_each_vcpu(i, src_vcpu, src) {
> > -             if (!src_vcpu->arch.guest_state_protected)
> > -                     return -EINVAL;
> > -     }
> > -
> > -     return 0;
> > -}
> > -
> >  int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_=
fd)
> >  {
> >       struct kvm_sev_info *dst_sev =3D &to_kvm_svm(kvm)->sev_info;
> > @@ -1777,19 +1648,20 @@ int sev_vm_move_enc_context_from(struct kvm *kv=
m, unsigned int source_fd)
> >               ret =3D -EBADF;
> >               goto out_fput;
> >       }
> > -
> >       source_kvm =3D source_kvm_file->private_data;
> > -     ret =3D sev_lock_two_vms(kvm, source_kvm);
> > +     src_sev =3D &to_kvm_svm(source_kvm)->sev_info;
> > +
> > +     ret =3D pre_move_enc_context_from(kvm, source_kvm,
> > +                                     &dst_sev->migration_in_progress,
> > +                                     &src_sev->migration_in_progress);
> >       if (ret)
> >               goto out_fput;
> >
> > -     if (sev_guest(kvm) || !sev_guest(source_kvm)) {
> > +     if (sev_guest(kvm) || !sev_es_guest(source_kvm)) {
> >               ret =3D -EINVAL;
> > -             goto out_unlock;
> > +             goto out_post;
> >       }
> >
> > -     src_sev =3D &to_kvm_svm(source_kvm)->sev_info;
> > -
> >       dst_sev->misc_cg =3D get_current_misc_cg();
> >       cg_cleanup_sev =3D dst_sev;
> >       if (dst_sev->misc_cg !=3D src_sev->misc_cg) {
> > @@ -1799,34 +1671,21 @@ int sev_vm_move_enc_context_from(struct kvm *kv=
m, unsigned int source_fd)
> >               charged =3D true;
> >       }
> >
> > -     ret =3D sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
> > -     if (ret)
> > -             goto out_dst_cgroup;
> > -     ret =3D sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TA=
RGET);
> > -     if (ret)
> > -             goto out_dst_vcpu;
> > -
> > -     ret =3D sev_check_source_vcpus(kvm, source_kvm);
> > -     if (ret)
> > -             goto out_source_vcpu;
> > -
> >       sev_migrate_from(kvm, source_kvm);
> >       kvm_vm_dead(source_kvm);
> >       cg_cleanup_sev =3D src_sev;
> >       ret =3D 0;
> >
> > -out_source_vcpu:
> > -     sev_unlock_vcpus_for_migration(source_kvm);
> > -out_dst_vcpu:
> > -     sev_unlock_vcpus_for_migration(kvm);
> >  out_dst_cgroup:
> >       /* Operates on the source on success, on the destination on failu=
re.  */
> >       if (charged)
> >               sev_misc_cg_uncharge(cg_cleanup_sev);
> >       put_misc_cg(cg_cleanup_sev->misc_cg);
> >       cg_cleanup_sev->misc_cg =3D NULL;
> > -out_unlock:
> > -     sev_unlock_two_vms(kvm, source_kvm);
> > +out_post:
> > +     post_move_enc_context_from(kvm, source_kvm,
> > +                                &dst_sev->migration_in_progress,
> > +                                &src_sev->migration_in_progress);
> >  out_fput:
> >       if (source_kvm_file)
> >               fput(source_kvm_file);
> > @@ -2058,7 +1917,11 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm=
, unsigned int source_fd)
> >       }
> >
> >       source_kvm =3D source_kvm_file->private_data;
> > -     ret =3D sev_lock_two_vms(kvm, source_kvm);
> > +     source_sev =3D &to_kvm_svm(source_kvm)->sev_info;
> > +     mirror_sev =3D &to_kvm_svm(kvm)->sev_info;
> > +     ret =3D lock_two_vms_for_migration(kvm, source_kvm,
> > +                                      &mirror_sev->migration_in_progre=
ss,
> > +                                      &source_sev->migration_in_progre=
ss);
> >       if (ret)
> >               goto e_source_fput;
> >
> > @@ -2078,9 +1941,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm,=
 unsigned int source_fd)
> >        * The mirror kvm holds an enc_context_owner ref so its asid can'=
t
> >        * disappear until we're done with it
> >        */
> > -     source_sev =3D &to_kvm_svm(source_kvm)->sev_info;
> >       kvm_get_kvm(source_kvm);
> > -     mirror_sev =3D &to_kvm_svm(kvm)->sev_info;
> >       list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms)=
;
> >
> >       /* Set enc_context_owner and copy its encryption context over */
> > @@ -2101,7 +1962,9 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm,=
 unsigned int source_fd)
> >        */
> >
> >  e_unlock:
> > -     sev_unlock_two_vms(kvm, source_kvm);
> > +     unlock_two_vms_for_migration(kvm, source_kvm,
> > +                                  &mirror_sev->migration_in_progress,
> > +                                  &source_sev->migration_in_progress);
> >  e_source_fput:
> >       if (source_kvm_file)
> >               fput(source_kvm_file);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 870041887ed91..865c434a94899 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13596,6 +13596,172 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcp=
u, unsigned int size,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
> >
> > +/* vCPU mutex subclasses.  */
> > +enum migration_role {
> > +     MIGRATION_SOURCE =3D 0,
> > +     MIGRATION_TARGET,
> > +     NR_MIGRATION_ROLES,
> > +};
> > +
>
> > +static int lock_vcpus_for_migration(struct kvm *kvm, enum migration_ro=
le role)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     unsigned long i, j;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +             if (mutex_lock_killable_nested(&vcpu->mutex, role))
> > +                     goto out_unlock;
> > +
> > +#ifdef CONFIG_PROVE_LOCKING
> > +             if (!i)
> > +                     /*
> > +                      * Reset the role to one that avoids colliding wi=
th
> > +                      * the role used for the first vcpu mutex.
> > +                      */
> > +                     role =3D NR_MIGRATION_ROLES;
> > +             else
> > +                     mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> > +#endif
> > +     }
> > +
> > +     return 0;
> > +
> > +out_unlock:
> > +
> > +     kvm_for_each_vcpu(j, vcpu, kvm) {
> > +             if (i =3D=3D j)
> > +                     break;
> > +
> > +#ifdef CONFIG_PROVE_LOCKING
> > +             if (j)
> > +                     mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THI=
S_IP_);
> > +#endif
> > +
> > +             mutex_unlock(&vcpu->mutex);
> > +     }
> > +     return -EINTR;
> > +}
> > +
> > +static void unlock_vcpus_for_migration(struct kvm *kvm)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     unsigned long i;
> > +     bool first =3D true;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +             if (first)
> > +                     first =3D false;
> > +             else
> > +                     mutex_acquire(&vcpu->mutex.dep_map, NR_MIGRATION_=
ROLES,
> > +                                   0, _THIS_IP_);
> > +
> > +             mutex_unlock(&vcpu->mutex);
> > +     }
> > +}
> > +
> > +int lock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kv=
m,
> > +                            atomic_t *dst_migration_in_progress,
> > +                            atomic_t *src_migration_in_progress)
> > +{
> > +     int r =3D -EBUSY;
> > +
> > +     if (dst_kvm =3D=3D src_kvm)
> > +             return -EINVAL;
> > +
> > +     /*
> > +      * Bail if these VMs are already involved in a migration to avoid
> > +      * deadlock between two VMs trying to migrate to/from each other.
> > +      */
> > +     if (atomic_cmpxchg_acquire(dst_migration_in_progress, 0, 1))
> > +             return -EBUSY;
> > +
> > +     if (atomic_cmpxchg_acquire(src_migration_in_progress, 0, 1))
> > +             goto release_dst;
> > +
> > +     r =3D -EINTR;
> > +     if (mutex_lock_killable(&dst_kvm->lock))
> > +             goto release_src;
> > +     if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTI=
NG))
> > +             goto unlock_dst;
> > +     return 0;
> > +
> > +unlock_dst:
> > +     mutex_unlock(&dst_kvm->lock);
> > +release_src:
> > +     atomic_set_release(src_migration_in_progress, 0);
> > +release_dst:
> > +     atomic_set_release(dst_migration_in_progress, 0);
> > +     return r;
> > +}
> > +EXPORT_SYMBOL_GPL(lock_two_vms_for_migration);
> > +
> > +void unlock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src=
_kvm,
> > +                               atomic_t *dst_migration_in_progress,
> > +                               atomic_t *src_migration_in_progress)
> > +{
> > +     mutex_unlock(&dst_kvm->lock);
> > +     mutex_unlock(&src_kvm->lock);
> > +     atomic_set_release(dst_migration_in_progress, 0);
> > +     atomic_set_release(src_migration_in_progress, 0);
> > +}
> > +EXPORT_SYMBOL_GPL(unlock_two_vms_for_migration);
> > +
> > +int pre_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm=
,
> > +                           atomic_t *dst_migration_in_progress,
> > +                           atomic_t *src_migration_in_progress)
> > +{
> > +     struct kvm_vcpu *src_vcpu;
> > +     unsigned long i;
> > +     int ret =3D -EINVAL;
> > +
> > +     ret =3D lock_two_vms_for_migration(dst_kvm, src_kvm,
> > +                                      dst_migration_in_progress,
> > +                                      src_migration_in_progress);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D lock_vcpus_for_migration(dst_kvm, MIGRATION_TARGET);
> > +     if (ret)
> > +             goto unlock_vms;
> > +
> > +     ret =3D lock_vcpus_for_migration(src_kvm, MIGRATION_SOURCE);
> > +     if (ret)
> > +             goto unlock_dst_vcpu;
> > +
> > +     if (atomic_read(&dst_kvm->online_vcpus) !=3D
> > +         atomic_read(&src_kvm->online_vcpus))
> > +             goto unlock_dst_vcpu;
> > +
> > +     kvm_for_each_vcpu(i, src_vcpu, src_kvm) {
> > +             if (!src_vcpu->arch.guest_state_protected)
> > +                     goto unlock_dst_vcpu;
> > +     }
> > +
> > +     return 0;
> > +
> > +unlock_dst_vcpu:
> > +     unlock_vcpus_for_migration(dst_kvm);
> > +unlock_vms:
> > +     unlock_two_vms_for_migration(dst_kvm, src_kvm,
> > +                                  dst_migration_in_progress,
> > +                                  src_migration_in_progress);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(pre_move_enc_context_from);
> > +
> > +void post_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_k=
vm,
> > +                             atomic_t *dst_migration_in_progress,
> > +                             atomic_t *src_migration_in_progress)
> > +{
> > +     unlock_vcpus_for_migration(src_kvm);
> > +     unlock_vcpus_for_migration(dst_kvm);
> > +     unlock_two_vms_for_migration(dst_kvm, src_kvm,
> > +                                  dst_migration_in_progress,
> > +                                  src_migration_in_progress);
> > +}
> > +EXPORT_SYMBOL_GPL(post_move_enc_context_from);
> > +
>
> It would be nice to have kvm_ prefix for the functions exported.

Sure, I'll update it in the next version.
>
> >  bool kvm_arch_dirty_log_supported(struct kvm *kvm)
> >  {
> >       return kvm->arch.vm_type !=3D KVM_X86_PROTECTED_VM;
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 33a1a5341e788..554c797184994 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -502,4 +502,20 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, un=
signed int size,
> >                        unsigned int port, void *data,  unsigned int cou=
nt,
> >                        int in);
> >
> > +int lock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kv=
m,
> > +                            atomic_t *dst_migration_in_progress,
> > +                            atomic_t *src_migration_in_progress);
> > +
> > +void unlock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src=
_kvm,
> > +                               atomic_t *dst_migration_in_progress,
> > +                               atomic_t *src_migration_in_progress);
> > +
> > +int pre_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm=
,
> > +                           atomic_t *dst_migration_in_progress,
> > +                           atomic_t *src_migration_in_progress);
> > +
> > +void post_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_k=
vm,
> > +                             atomic_t *dst_migration_in_progress,
> > +                             atomic_t *src_migration_in_progress);
> > +
> >  #endif
