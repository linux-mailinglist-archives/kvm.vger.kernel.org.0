Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8803C4F89B3
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiDGVTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiDGVTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 17:19:45 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B5F18B278
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 14:17:44 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id w21so3926014uan.3
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 14:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2UZnvHKVT+RSn7KzBoROaF7ppe0N+yUXrxxXIoW5cQ=;
        b=NRde8Udpa0fzUmYWUGIa2y+TMLicphp0YP1FxdyLiInbSRONN31LTYfw9J+ZkQIrVr
         SaP9jmOZseRLuHjTaS8/+DI7H9Y/PwQtd83V3kvjKqKCV7u6elpRVIWo7nB+bjA1tgnv
         hf56DvjcJNWLJHDl6c/8Nnn7rs6WvkEFHalj4Tmcmq9uvv3NGkq3zZfoFE2cS97uk7hM
         Le1N5tuX81k2d+QfJcsxcSRcJWaI7WjzU1qtGIQZswIkXMPtnNfr5Xk3VnmM5o5OwkTY
         QRAtpAD497ANr6wxriL34hQkjTfbKK/p5EEzzGEsoi2VTY2VvrVlsFggZsl48g0GLU7C
         LZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2UZnvHKVT+RSn7KzBoROaF7ppe0N+yUXrxxXIoW5cQ=;
        b=WljP6mzH2kNIX/W1t7nCep0rdnPkAfPcFsF+GotCOmqNsbd5aPTWZV3UYZieXpm+wg
         ZbKJHD6YScHoznvADgPnkJyDLMUGjKpRteEVfkycuxe1YC+3xJ2nSJE8TasedTHPpmhU
         J7e33By8kiYiyQgHwvlzli1oTLGcFU4PT2WZ4SAhzAGCHDIcVM1Ml/Ion4e2dcSJ6hvl
         INOqodh6S9qWeJ4SMUeVCAGhY2cLRA6h3SGxvayZfxKGqIj9OT6cwibObkdZHckzsyr5
         AC9ojkWj9Xvpyp5EGe0u4TAomj89eZAYuSyylook3DxqS4trP+aWeEAemcKgTUyJ2joc
         aU9g==
X-Gm-Message-State: AOAM530oUohJKjjEFGwAEQDVL0sMIUQu8Y9n7+ZbUmw1UIY6zIUlNngx
        TUpAlJfLzuD3kz/ypPmFd/z/hlC3qiGUO+T9kk6H5MJijrp+sg==
X-Google-Smtp-Source: ABdhPJw1w6Ya1oRpnvkQOIrxYpg62Xx5qx0taaCWyNi4YjFl9omGGO1rmT2EgoCiaV462ehDG4ibXAeknT3npQHqcBQ=
X-Received: by 2002:ab0:7541:0:b0:359:eb0b:8162 with SMTP id
 k1-20020ab07541000000b00359eb0b8162mr4673151uaq.15.1649366263664; Thu, 07 Apr
 2022 14:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com>
In-Reply-To: <20220407195908.633003-1-pgonda@google.com>
From:   John Sperbeck <jsperbeck@google.com>
Date:   Thu, 7 Apr 2022 14:17:32 -0700
Message-ID: <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
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

On Thu, Apr 7, 2022 at 12:59 PM Peter Gonda <pgonda@google.com> wrote:
>
> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
> source and target vcpu->locks. Mark the nested subclasses to avoid false
> positives from lockdep.
>
> Warning example:
> ============================================
> WARNING: possible recursive locking detected
> 5.17.0-dbg-DEV #15 Tainted: G           O
> --------------------------------------------
> sev_migrate_tes/18859 is trying to acquire lock:
> ffff8d672d484238 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
> but task is already holding lock:
> ffff8d67703f81f8 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>        CPU0
>        ----
>   lock(&vcpu->mutex);
>   lock(&vcpu->mutex);
>  *** DEADLOCK ***
>  May be due to missing lock nesting notation
> 3 locks held by sev_migrate_tes/18859:
>  #0: ffff9302f91323b8 (&kvm->lock){+.+.}-{3:3}, at: sev_vm_move_enc_context_from+0x96/0x740
>  #1: ffff9302f906a3b8 (&kvm->lock/1){+.+.}-{3:3}, at: sev_vm_move_enc_context_from+0xae/0x740
>  #2: ffff8d67703f81f8 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
>
> Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
> Reported-by: John Sperbeck<jsperbeck@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Peter Gonda <pgonda@google.com>
>
> ---
>
> V3
>  * Updated signature to enum to self-document argument.
>  * Updated comment as Seanjc@ suggested.
>
> Tested by running sev_migrate_tests with lockdep enabled. Before we see
> a warning from sev_lock_vcpus_for_migration(). After we get no warnings.
>
> ---
>  arch/x86/kvm/svm/sev.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..f66550ec8eaf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1591,14 +1591,26 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>         atomic_set_release(&src_sev->migration_in_progress, 0);
>  }
>
> +/*
> + * To suppress lockdep false positives, subclass all vCPU mutex locks by
> + * assigning even numbers to the source vCPUs and odd numbers to destination
> + * vCPUs based on the vCPU's index.
> + */
> +enum sev_migration_role {
> +       SEV_MIGRATION_SOURCE = 0,
> +       SEV_MIGRATION_TARGET,
> +       SEV_NR_MIGRATION_ROLES,
> +};
>
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> +static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> +                                       enum sev_migration_role role)
>  {
>         struct kvm_vcpu *vcpu;
>         unsigned long i, j;
>
> -       kvm_for_each_vcpu(i, vcpu, kvm) {
> -               if (mutex_lock_killable(&vcpu->mutex))
> +       kvm_for_each_vcpu(i, vcpu, kvm) {
> +               if (mutex_lock_killable_nested(
> +                           &vcpu->mutex, i * SEV_NR_MIGRATION_ROLES + role))
>                         goto out_unlock;
>         }
>
> @@ -1745,10 +1757,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>                 charged = true;
>         }
>
> -       ret = sev_lock_vcpus_for_migration(kvm);
> +       ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
>         if (ret)
>                 goto out_dst_cgroup;
> -       ret = sev_lock_vcpus_for_migration(source_kvm);
> +       ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
>         if (ret)
>                 goto out_dst_vcpu;
>
> --
> 2.35.1.1178.g4f1659d476-goog
>

Does sev_migrate_tests survive lockdep checking if
NR_MIGRATE_TEST_VCPUS is changed to 16?
