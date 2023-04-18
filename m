Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BA16E6B5A
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjDRRsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDRRr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:47:59 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F6FD
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:47:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4ec81779f49so2280212e87.3
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681840076; x=1684432076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7VHOL3a4oNcSicrpU2wfqbXD01GJZHRcgPEysQrHBM=;
        b=GNHSp2I09Zl9LB7eHbx0aGHUh6j+bHxHCQBbKwtzBWyzo2N11Jsm726VXDHHJSDn3v
         sMONNacQwy4KU3tqw3rhhtFJKNXjYVpEtf7gUMS+KeQXJftXBOy5GAy0AYktN/IJpdeK
         LM4zML8fpO9dG/kpJuSAvlPJRp4hEUxj1mXNktm2Eq6DZnhRZxL+K32qrnNCepTYL94K
         c4TkDSZOe/g0QN2t5UFVVTPXDPQTiknB8OH7X0iJphWg1+M2eAyklkwuZ2KOG82ehPOq
         lS5r9oHb9wffj9OdlbHJCSSYiqeqQe8UHRJGfLSvY4oPtYBBfqL4fYa0JdYgPLsZ05mi
         LdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681840076; x=1684432076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7VHOL3a4oNcSicrpU2wfqbXD01GJZHRcgPEysQrHBM=;
        b=dtItDvMZlYSUAKN4ixI/QJotpyzi48rsOmqNH25ELRFap758KLdYrqX3ter5KIzmtH
         7hAemVJnNL4k0Js0Xcr8YtapBm7l9EqSHuK19kRwTXRrdAKxE/r4skW1yVPPOwE86sJk
         oBjek4fQpGbL79SsVHHfDXzUE7Iw18zwGsVqGjLpRkOim0PrnXJLRd9AcdXZTsYFd2oa
         SIcyQo9Ob7vYW73aQPIBiZTTx2mjtdANaSsEvaPWsbeZ8xjb9HeQUMfU7LCLClzTzrK8
         YFTBHBefrWGx/L+Mh8lLGOUlqwc+sFl97Hh+4Hc1fsRm9MuWLUG3XcP9HLquCFsa83AZ
         ewqQ==
X-Gm-Message-State: AAQBX9drBZUDgGGwtZJvwzY8wnE4MccA2RC2JQnYjTSHuDvPccU40aow
        v64bikzt57U6ovmrV1vEz2mGhOwJuzF8FykR7SyziA==
X-Google-Smtp-Source: AKy350bNqaOsyaRvGcKKCm/o8W3yzMR1UZvLTRhVbBxbRfe+NIbLPArG46ZFrQ8IfE30X0M+uvZtDukKkr1LXEzQtIU=
X-Received: by 2002:ac2:5296:0:b0:4eb:f3d:94bf with SMTP id
 q22-20020ac25296000000b004eb0f3d94bfmr3406470lfm.9.1681840075852; Tue, 18 Apr
 2023 10:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com> <20230407201921.2703758-4-sagis@google.com>
 <20230418092830.00001bff.zhi.wang.linux@gmail.com>
In-Reply-To: <20230418092830.00001bff.zhi.wang.linux@gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 18 Apr 2023 10:47:44 -0700
Message-ID: <CAAhR5DFfgyGx9H-m4LE_L3zNmQZRyvmiWMYS1_sHxJihm3f0KA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
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

On Mon, Apr 17, 2023 at 11:28=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com=
> wrote:
>
> On Fri,  7 Apr 2023 20:19:19 +0000
> Sagi Shahar <sagis@google.com> wrote:
>
> Is there any reaon that TDX doesn't need .vm_copy_enc_context_from? Or it=
 is
> going to be deprecated? The patch comments needs to be refined according =
to
> Sean's KVM x86 maintainer book.

To clarify, there are 2 types of migrations. live migration (between
different hosts) and intra-host (between kvm instances in the same
host) migration. This patchset deals with intra-host migration and
doesn't add support for live migration.

vm_copy_enc_context_from is currently used for setting up the
migration helper for SEV live migration and therefore it is currently
not needed in this patcheset.

>
> > This should mostly match the logic in sev_vm_move_enc_context_from.
> >
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    | 10 +++++++
> >  arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.h     |  2 ++
> >  arch/x86/kvm/vmx/x86_ops.h |  5 ++++
> >  4 files changed, 73 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 5b64fe5404958..9d5d0ac465bf6 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *=
vcpu, void __user *argp)
> >       return tdx_vcpu_ioctl(vcpu, argp);
> >  }
> >
> > +static int vt_move_enc_context_from(struct kvm *kvm, unsigned int sour=
ce_fd)
> > +{
> > +     if (!is_td(kvm))
> > +             return -ENOTTY;
> > +
> > +     return tdx_vm_move_enc_context_from(kvm, source_fd);
> > +}
> > +
> >  #define VMX_REQUIRED_APICV_INHIBITS                 \
> >  (                                                   \
> >         BIT(APICV_INHIBIT_REASON_DISABLE)|           \
> > @@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
> >       .dev_mem_enc_ioctl =3D tdx_dev_ioctl,
> >       .mem_enc_ioctl =3D vt_mem_enc_ioctl,
> >       .vcpu_mem_enc_ioctl =3D vt_vcpu_mem_enc_ioctl,
> > +
> > +     .vm_move_enc_context_from =3D vt_move_enc_context_from,
> >  };
> >
> >  struct kvm_x86_init_ops vt_init_ops __initdata =3D {
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8af7e4e81c860..0999a6d827c99 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2826,3 +2826,59 @@ int __init tdx_init(void)
> >               INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
> >       return 0;
> >  }
> > +
> > +static __always_inline bool tdx_guest(struct kvm *kvm)
> > +{
> > +     struct kvm_tdx *tdx_kvm =3D to_kvm_tdx(kvm);
> > +
> > +     return tdx_kvm->finalized;
> > +}
> > +
> > +static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_=
fd)
> > +{
> > +     struct kvm_tdx *dst_tdx =3D to_kvm_tdx(kvm);
> > +     struct file *src_kvm_file;
> > +     struct kvm_tdx *src_tdx;
> > +     struct kvm *src_kvm;
> > +     int ret;
> > +
> > +     src_kvm_file =3D fget(source_fd);
> > +     if (!file_is_kvm(src_kvm_file)) {
> > +             ret =3D -EBADF;
> > +             goto out_fput;
> > +     }
> > +     src_kvm =3D src_kvm_file->private_data;
> > +     src_tdx =3D to_kvm_tdx(src_kvm);
> > +
> > +     ret =3D pre_move_enc_context_from(kvm, src_kvm,
> > +                                     &dst_tdx->migration_in_progress,
> > +                                     &src_tdx->migration_in_progress);
> > +     if (ret)
> > +             goto out_fput;
> > +
> > +     if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
> > +             ret =3D -EINVAL;
> > +             goto out_post;
> > +     }
> > +
> > +     ret =3D tdx_migrate_from(kvm, src_kvm);
> > +     if (ret)
> > +             goto out_post;
> > +
> > +     kvm_vm_dead(src_kvm);
> > +     ret =3D 0;
> > +
> > +out_post:
> > +     post_move_enc_context_from(kvm, src_kvm,
> > +                              &dst_tdx->migration_in_progress,
> > +                              &src_tdx->migration_in_progress);
> > +out_fput:
> > +     if (src_kvm_file)
> > +             fput(src_kvm_file);
> > +     return ret;
> > +}
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 71818c5001862..21b7e710be1fd 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -24,6 +24,8 @@ struct kvm_tdx {
> >       atomic_t tdh_mem_track;
> >
> >       u64 tsc_offset;
> > +
> > +     atomic_t migration_in_progress;
> >  };
> >
> >  union tdx_exit_reason {
> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index d049e0c72ed0c..275f5d75e9bf1 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __us=
er *argp);
> >  void tdx_flush_tlb(struct kvm_vcpu *vcpu);
> >  int tdx_sept_tlb_remote_flush(struct kvm *kvm);
> >  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_=
level);
> > +
> > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_=
fd);
> >  #else
> >  static inline int tdx_init(void) { return 0; };
> >  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { re=
turn -ENOSYS; }
> > @@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcpu *v=
cpu, void __user *argp) { ret
> >  static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
> >  static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return =
0; }
> >  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_=
hpa, int root_level) {}
> > +
> > +static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
> > +                                            nsigned int source_fd) { r=
eturn -EOPNOTSUPP; }
> >  #endif
> >
> >  #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
>
