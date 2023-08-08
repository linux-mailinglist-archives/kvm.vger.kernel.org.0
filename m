Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D8C774BA2
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjHHUvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjHHUuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:50:51 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F285F46717
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:46:44 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-407db3e9669so1581cf.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 09:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691513202; x=1692118002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5cUkGvBinqrQEB7Ikj5Ug8tOjVRS6TZ8gJMeTTJk/U=;
        b=MEkJuLCCzNqujltO/2hEBF2IZ8JWjwedY1wVwMFzuxok1cUuORptjOLuKh3jhngmbg
         OszqqJ2FqeHwHlyz5sFzOsmGpkD/3QVma5URjR1jvw5cArnTbvACynfjopC1KnzTKMyP
         LXtBLl+32K1Fk6s33cihV9KIyTralnRC9ZedyF08T1fha1zO1t3FCcIBW73zDo4JKWLl
         vJ8fFQFUq8E0fvlL0hxqbxzzMtCdpELvpY0iRowFTc93kwORZVBnOlcAefdf1Jr8F9Be
         CvcMGmnUR49gQaXX06ieIIW2SXQ7B8dXiV4ZHtlX/+YS3IaUh5D5bc+PU8DnZ2XozQpU
         wELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691513202; x=1692118002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5cUkGvBinqrQEB7Ikj5Ug8tOjVRS6TZ8gJMeTTJk/U=;
        b=GigybbufftKW2LS8f3ClZjr+V83dPeg91vuwFes8vebIO+eKQ5iod3tTTnnR98X6QF
         +MtX0YqG8q5tWfAz7FQqpdmmRjfTIGZmyOqE/VuVBUimwwZIs67IRhei7CZ4l4SdwHWf
         4/y4QTN1FnvlaIpUPS/pBaHpsh6QrljAy2YYJyQh9TyTKh9L83mtr/aoQ+5o3U4tgnaw
         eNEyF1JfHxjdcNDbWmSuY0jK32ANjr36HnUE0t94AlIT2/MajHczFuzpObvjThv40DA8
         EqirSj+XXmI78jNKx6M2YdCvvcWaALlKOAnyi3J5A8Wsp2KZDhVyaXPC0ixNvs7p7Xd5
         hbGQ==
X-Gm-Message-State: AOJu0Yx70NijgXlZumIE76xIg4jTylnsBsqvDK2ymEnujYYttH6mnYMj
        RcbHQNkjGiIqfVhzjtdCuSdl9DexzgtLxvSOMKmUkg==
X-Google-Smtp-Source: AGHT+IF4HzuUwWkMUsGsweRhCwPAzuoceDkfaSL4D3AD1VB/sy6hMsEVitqG7c6zwkKT6LNm7NuGpkKpwVJ6D73FF6Q=
X-Received: by 2002:a05:622a:11d3:b0:40f:dc70:fde2 with SMTP id
 n19-20020a05622a11d300b0040fdc70fde2mr2783qtk.26.1691513201715; Tue, 08 Aug
 2023 09:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com>
 <877cqdqw12.wl-maz@kernel.org> <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
 <ZNJaPxTtPRCv0HOl@google.com> <CAJHc60yiGnVc=ysdOaNemWaDpTBSk02mRLenK3sN2XtN_Cp98g@mail.gmail.com>
 <fc430350dd7d8ac664054a99f1e452c1@kernel.org>
In-Reply-To: <fc430350dd7d8ac664054a99f1e452c1@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 8 Aug 2023 09:46:30 -0700
Message-ID: <CAJHc60zspGChscVTj5K31=gzRmFu5d++FZNLz8eaZMxfOV+KAQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 8, 2023 at 9:43=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2023-08-08 17:19, Raghavendra Rao Ananta wrote:
> > On Tue, Aug 8, 2023 at 8:07=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com>
> > wrote:
> >>
> >> On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
> >> > On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Raghavendra Rao Ananta
> >> > <rananta@google.com> wrote:
> >> > >
> >> > > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
> >> > >
> >> > While working on the renaming, I realized that since this function i=
s
> >> > called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rena=
me
> >> > this and the other kvm_flush_*() functions that the series introduce=
s
> >> > to match their kvm_arch_flush_*() counterparts?
> >>
> >> Hmm, if we're going to rename one arch hook, then yes, I think it
> >> makes sense to
> >> rename all the common APIs and arch hooks to match.
> >>
> >> However, x86 is rife with the "remote_tlbs" nomenclature, and renaming
> >> the common
> >> APIs will just push the inconsistencies into x86.  While I 100% agree
> >> that the
> >> current naming is flawed, I am not willing to end up with x86 being
> >> partially
> >> converted.
> >>
> >> I think I'm ok renaming all of x86's many hooks?  But I'd definitely
> >> want input
> >> from more x86 folks, and the size and scope of this series would
> >> explode.  Unless
> >> Marc objects and/or has a better idea, the least awful option is
> >> probably to ignore
> >> the poor "remote_tlbs" naming and tackle it in a separate series.
> >>
> > Sure, I think it's better to do it in a separate series as well. I'm
> > happy to carry out the task after this one gets merged. But, let's
> > wait for Marc and others' opinion on the matter.
>
> Yeah, let's punt that to a separate series. I'm more interested in
> getting this code merged than in the inevitable bike-shedding that
> will result from such a proposal.
>
> Raghavendra, any chance you could respin the series this week?
> I'd really like it to spend some quality time in -next...
>
No problem. I'll send out v8 by today or tomorrow.

Thank you.
Raghavendra
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
