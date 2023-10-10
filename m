Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52FC7C4531
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343967AbjJJXCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbjJJXCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:02:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6669292
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:01:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3248ac76acbso5514345f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696978916; x=1697583716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdRL4y1cTCFXmyMFKustVLIgbPKJzRBqwfNfiJOWZO8=;
        b=nSKmYeSceDtc4VwBWj4gPOEpSXKA3pYdqwM1iKLlskRG1IFprYsYc+bsqybBDmtPTI
         zdJS5iWhppxb2sZqgsWLluJVCovsoOJnU6YnbVCayrOxGHTD40G3FvgmFpKPcNFa2MFR
         JcYh7P1dIeUOZR8BSod7gjKtWkhLwmMCzLtygzF0yRRnBlCNMa2LygK1/eLUipRxlqFi
         1pvhmQ6Jjz5dbACgI+9gx00Ll2VUiVi0MEbj8tlENANWQ+a0zPUdZIGGuKKXJ2WLThV+
         6QDGyM6xbAym9Io/55qQ9I365+wtkGJZIe0jBI3arNShCwxTUi66aTqVIsoOog9zHf5+
         NNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696978916; x=1697583716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdRL4y1cTCFXmyMFKustVLIgbPKJzRBqwfNfiJOWZO8=;
        b=n2QHxR0HpFu288Snibb3G6XnPdvbnI00kXDOYsgAtNSYXc8LlZ+Qcwv/LK7rYaldtr
         6IoSiLKgiKPFi3KtzgzmbrUNs60I8dXZkVmkLpgIR/oi4NtjGP0sMsw9sqLf0zOV/S3a
         lKjXspNDtlenWhmy3pgAG5kHf427/NZyGxdmY/uvb4sWjdb3q8INpaW7RHoA4ebGsl9/
         lh0tUPkFon3Gz5Fi5igcVm40SQ09sXGwwGnQc5OaHfXvy2UxAJjPVSczOG2e1UTMcgnw
         d+vlwDwGU6KvwJFab8DNCHdB0aYXrZ2pzlVL+lLDcpkQHKVf40QRLreZTjUM6l+C7iJe
         atCA==
X-Gm-Message-State: AOJu0Yw0+Q0e4LF/5g33Qxha9aC+UwCkThVTGmr10iBnQ9wyNdDDqz+G
        m/cwwTfQG6kPXJRcUQXIA4nEUIfPJcDvlfa5tnjJanJNRQDe35eDovJiz3fv
X-Google-Smtp-Source: AGHT+IHzhd3JKjUkEBkPi958g3DnO7+xRps/XVocUHHHRRU2TV7BqApmiCT22okMhkBb70Feyl/KpPt3TmnyND1MuRc=
X-Received: by 2002:a05:6000:1f02:b0:32c:d7e6:4054 with SMTP id
 bv2-20020a0560001f0200b0032cd7e64054mr2728992wrb.53.1696978915793; Tue, 10
 Oct 2023 16:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 10 Oct 2023 16:01:29 -0700
Message-ID: <CALzav=fZ6cEJO+YO1vHFBxiTmLj3kv0pX=ss1f-NCC=Opp==Ag@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
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

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
> user_mem_abort().
>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 587a104f66c3..8ede6c5edc5f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1408,6 +1408,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
> +       uint64_t memory_fault_flags;
>
>         fault_granule =3D 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level=
);
>         write_fault =3D kvm_is_write_fault(vcpu);
> @@ -1507,8 +1508,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, p=
hys_addr_t fault_ipa,
>                 kvm_send_hwpoison_signal(hva, vma_shift);
>                 return 0;
>         }
> -       if (is_error_noslot_pfn(pfn))
> +       if (is_error_noslot_pfn(pfn)) {
> +               memory_fault_flags =3D 0;
> +               if (write_fault)
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_EXEC=
;
> +               else if (exec_fault)
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_EXEC=
;
> +               else
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_READ=
;
> +               kvm_handle_guest_uaccess_fault(vcpu, round_down(gfn * PAG=
E_SIZE, vma_pagesize),

I think gfn * PAGE_SIZE is already rounded down to vma_pagesize. See
earlier in this function:

1484         vma_pagesize =3D 1UL << vma_shift;
1485         if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SI=
ZE)
1486                 fault_ipa &=3D ~(vma_pagesize - 1);
1487
1488         gfn =3D fault_ipa >> PAGE_SHIFT;


> +                                              vma_pagesize, memory_fault=
_flags);
>                 return -EFAULT;
> +       }
>
>         if (kvm_is_device_pfn(pfn)) {
>                 /*
> --
> 2.42.0.283.g2d96d420d3-goog
>
