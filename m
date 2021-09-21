Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8153413AAD
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhIUT0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 15:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbhIUT0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 15:26:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C08EC061575
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 12:25:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so398803pjv.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 12:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/sF6vDBPQtENY4PnJ/8XwK3HbUXNlrJIJQBSSE9vbI=;
        b=fWbX0xDo8U2ZnatPjBX47UgYg0iqOdULfaRNfdpJXUzsFOqbQPBZ5ulMrwJn54SyKw
         2Ens85w8fQYitomjl4iqqi4CFhLAL1jdYyn70mbZqZmmGFB0sJZyrMDrtioTEtAg27iB
         ITkv3xNUTLfyvrkKZhPXpUccMJ9rYy/u9iJfTrabLsop51SSGrgfQ6hYp56r61tdp07s
         xT+JJCdAG5MeIKSbvQfMURQQPQz0ROVosg4sMZ+Nqy9DxuZitSI4NUVliJYCAFK41vjm
         DjvpEE2KClktTISKx5zsWcdt7GedXa4QuiHE4dozH6Jol3VKPo0epJHXqiZkOlvzWyYf
         0BGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/sF6vDBPQtENY4PnJ/8XwK3HbUXNlrJIJQBSSE9vbI=;
        b=C8hx+LuHpcZtDBGN8Kz5d/8Jf247BTXBM+iKrPxHlcip6ghouL6+H7Ek6GdxArM8fo
         MVf8tGADFmT359wOrsxI+SNd1Aet41Li8mL1cetklwh+SK3TqQ4R8DtRw/XCmctC0dFJ
         iO9CS70k1O/Vgl+2tGWFYLnGlAxxAPwOtpM0maLnmpufiGyFvjWHnnveS+vpsLn5Zw3f
         GHulB+EtENr6kxDc4d3j7OrbDDmKLafkpCOjartuGs8HZCi7uNBaoGIqx5JR/MeJ6g/M
         pOkiCTUGbiUpGa69XpRbGJpoiJEVEy5kOxN+SFU3fdGjY5gizGnPUWsMYM9f3iOtAyJk
         zSPA==
X-Gm-Message-State: AOAM531QX68WWZ5XIIpca8RvciTBNcjRzyYPN5cnDJvmnrYrxIXHQpMG
        WfdpWX9Jbpsj6ddMGXe+UausE08SZhxbMMpA0BUXRw==
X-Google-Smtp-Source: ABdhPJzPH6XI7yR49/WYhgC3n5ZArm2hEgxUmQbfig+Y9g9qnDKrm4QAEW97NTxx7V92t4PQxePz1VE8Tg+VrJIqOuM=
X-Received: by 2002:a17:90b:4b51:: with SMTP id mi17mr7088788pjb.120.1632252309287;
 Tue, 21 Sep 2021 12:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210921150345.2221634-1-pgonda@google.com> <20210921150345.2221634-2-pgonda@google.com>
In-Reply-To: <20210921150345.2221634-2-pgonda@google.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Tue, 21 Sep 2021 12:24:58 -0700
Message-ID: <CAKiEG5rTnZNAyTZLR+JAbcQ=Hr8Nz5NQQjMRxc1Kvsu9-6RMUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 8:03 AM Peter Gonda <pgonda@google.com> wrote:
>
> For mirroring SEV-ES the mirror VM will need more then just the ASID.
> The FD and the handle are required to all the mirror to call psp
> commands. The mirror VM will need to call KVM_SEV_LAUNCH_UPDATE_VMSA to
> setup its vCPUs' VMSAs for SEV-ES.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Nathan Tempelman <natet@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Steve Rutherford <srutherford@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..08c53a4e060e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1715,8 +1715,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  {
>         struct file *source_kvm_file;
>         struct kvm *source_kvm;
> -       struct kvm_sev_info *mirror_sev;
> -       unsigned int asid;
> +       struct kvm_sev_info source_sev, *mirror_sev;
>         int ret;
>
>         source_kvm_file = fget(source_fd);
> @@ -1739,7 +1738,8 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>                 goto e_source_unlock;
>         }
>
> -       asid = to_kvm_svm(source_kvm)->sev_info.asid;
> +       memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
> +              sizeof(source_sev));
>
>         /*
>          * The mirror kvm holds an enc_context_owner ref so its asid can't
> @@ -1759,8 +1759,16 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>         /* Set enc_context_owner and copy its encryption context over */
>         mirror_sev = &to_kvm_svm(kvm)->sev_info;
>         mirror_sev->enc_context_owner = source_kvm;
> -       mirror_sev->asid = asid;
>         mirror_sev->active = true;
> +       mirror_sev->asid = source_sev.asid;
> +       mirror_sev->fd = source_sev.fd;
> +       mirror_sev->es_active = source_sev.es_active;
> +       mirror_sev->handle = source_sev.handle;
> +       /*
> +        * Do not copy ap_jump_table. Since the mirror does not share the same
> +        * KVM contexts as the original, and they may have different
> +        * memory-views.
> +        */
>
>         mutex_unlock(&kvm->lock);
>         return 0;
> --
> 2.33.0.464.g1972c5931b-goog
>
Looks good. Thanks for doing this Peter.

Reviewed-by: Nathan Tempelman <natet@google.com>
