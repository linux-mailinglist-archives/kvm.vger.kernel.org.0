Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D3C6F4C5F
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjEBVq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 17:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBVq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 17:46:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089C810E4
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 14:46:57 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f19323259dso43141405e9.3
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 14:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683064015; x=1685656015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkakKPnXdIbwhp3qELgh3mzIzgc5pZX2Ojek8iG0RyE=;
        b=fACx6mF2xuwefnFQeDZSjfuFRH9n6cXIZ3o0YwzNNDTbAVajDEGBng/RhJW7g+DUpf
         lgq7FvtbDnKdMDN0DHjNZFOSWDgSA3o3eE0AOOcIuXdmWx2q5To4NDp8rlM3kiQJEpBU
         3V73gGptU8Jof3O9JyXhd6V8e0mDR/SJFlgV3SepmPyJQzAOAh0SbsxPoQgWiygW5LgE
         KfN58BApR1oCOwgJH8QFZI3n9uGGjqC8XRtgzN4e2s8FY2AFOQfikRBdChNZTg0kro6g
         MCyZL+YZNAtdHyCBWDDFlj2QZ/V4w2qeea1Tp8C7xHEcFbNpOAFizsK/4iX7HAuddtGy
         m2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683064015; x=1685656015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkakKPnXdIbwhp3qELgh3mzIzgc5pZX2Ojek8iG0RyE=;
        b=g/t+VE6pxetoT7IUgmR5MyKl3PrXZczbxHlqJ6iKzZfnfrbaTSYBXSvtOUlpKmd98y
         GXJwJlK5sX0CPsuwh+JCyjKgcwxqvhxQ1n+mFjW1iLsIHw0qBmVHqnG3x5VF1GSWZVXk
         k5DWrPsa5vMpqZ1sCI8Z6BvtZJeb1ASk2PIzMRQ64pCO6lOEkZmf7sOGQ7wMxZGyc06p
         X5W6R0IwZon1lzBjG13maMzhYM1VevcXT/PYVh/plcYwWt1OWbnKSFDjY2e8QJIYLQT6
         gSAJgOd5lDDhoNZGet5ANlE9DF8cecxhC0gRb2N4HF3wZnbM+6GxMwkY5cb19YCoeczJ
         koZg==
X-Gm-Message-State: AC+VfDxN+fFMqR7yjDlhvZQZ/7O3lq2I/UnWqFc0MiuFxARhUmld6yfm
        GGdEgUDerDg/DiR95DLlQ5vFiL0d/tvcC7tBuYlGvg==
X-Google-Smtp-Source: ACHHUZ7LJi1Shbt1CFcWQbc6/FosMafNfZN0vuGJxJL7Kri+kUr9e3Xx9lDcdl6InlfdY5njNxX+bZ74agQJHMmLDgk=
X-Received: by 2002:adf:dec1:0:b0:306:2e62:7716 with SMTP id
 i1-20020adfdec1000000b003062e627716mr4856286wrn.56.1683064015454; Tue, 02 May
 2023 14:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
 <ZFF1ibyPZHKYzEuY@google.com>
In-Reply-To: <ZFF1ibyPZHKYzEuY@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 2 May 2023 14:46:18 -0700
Message-ID: <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, May 2, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking a=
t the
> code, the cui() aspect is a moot point.  As I stated in the previous disc=
ussion,
> the WARN_ON_ONCE() in question needs to be off-by-default.
>
>  : Hmm, one idea would be to have the initial -EFAULT detection fill kvm_=
run.memory_fault,
>  : but set kvm_run.exit_reason to some magic number, e.g. zero it out.  T=
hen KVM could
>  : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN wo=
uld need to
>  : be buried by a Kconfig or something since kvm_run can be modified by u=
serspace,
>  : but other than that I think it would work.

Ah, ok: I thought using WARN_ON_ONCE instead of WARN might have
obviated the Kconfig. I'll go add one.
