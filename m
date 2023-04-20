Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970F36E9B8C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjDTSXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDTSXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 14:23:50 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722473C28
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 11:23:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2fbb99cb297so758122f8f.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 11:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682015028; x=1684607028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1945gIeyUKxf634eLSB+UhkKwLsC3xo7b0I4NgmBVls=;
        b=5F9+meUbuKL3RiauX8BCJVKDSb1T6kfNGhz96hh/fWuOztbgnQQ274N6eOQiUPlvqu
         5vW4YctMX5rfg1GtYuurir7iGQwXklNUvitEdJn93MDysY+CjCAnHxB6plosAcsrVyXX
         FNrxtIfL+jFS+aJmc32SEmBvr0RlpccNdVvR79DN6Jf4FB0qBvPPJRmCWBH64gKY5HOM
         an11cwhv2lE/SHJzENIjaI/qyajrLmdqRliywUAVbGbM43B5ZFwzO/PABTOzenTGaBC+
         x3fEW2zLn7Ncs2JdM+E5UzAQ6nOgQnLzAnML0gbMMtyoci0S+wCiiherXsvw473Nolfl
         AzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015028; x=1684607028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1945gIeyUKxf634eLSB+UhkKwLsC3xo7b0I4NgmBVls=;
        b=GALTgbUe3WUqwqDClH9ZaZ6bI8dq5eCW/XLdJLqUzDNB0s2BbrnWSbLM66y6V6eNqi
         +F19yN4oRbLOQ4rgLKIYWJw3r1vQT0/jC2U1LLZ6qaNKc5SW+BYWoGMo8m44+2Vs5wdE
         SW8dH78/a1dtpFpswuyoNUkMVIgYKQTBcifW3F59huPl/nMtw0Aq+VwRGOB5P5njU01s
         e8/ZJmfj1MUe54ofDOwtGHKXZCGJubS6iZCOUqgq1dKazxfCM2jhxczla15UVCvRV05Q
         PPiItanG9outZcKGtypirU/AL/9L0x+t6iAyApVjeh7OCMiV+78RHrb6jQjR2GTeYBVh
         G6xg==
X-Gm-Message-State: AAQBX9fk+oKtGuwT7Pi37jBkuuyUuDYK/od6/eb2pjrQVHDL1OKfJyk3
        ku7LPZyGx5JYNfopv1pIfizA6WcdKarjISFFLrqLrg==
X-Google-Smtp-Source: AKy350aS/frzXk0mzLXwkFJVv8/EWEWXdE3KEmqrhkdHEnMgBbMXKq4FyvdmjQvx8/jHNs93jMEptZxwXOvhqztKBcQ=
X-Received: by 2002:a5d:6585:0:b0:2f5:953a:4f59 with SMTP id
 q5-20020a5d6585000000b002f5953a4f59mr1948320wru.5.1682015027841; Thu, 20 Apr
 2023 11:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
 <8d974125-163c-f61c-a988-5e5e6d762d73@gmail.com>
In-Reply-To: <8d974125-163c-f61c-a988-5e5e6d762d73@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 11:23:11 -0700
Message-ID: <CAF7b7mqqDzD0wXC__KfCdY66tz2pQaw4=xJ=g4ECgCosb+jHcg@mail.gmail.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
To:     Hoo Robert <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Wed, Apr 19, 2023 at 7:00=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
> > +static inline bool kvm_slot_fault_on_absent_mapping(
> > +                                                     const struct kvm_=
memory_slot *slot)
>
> Strange line break.

Fixed: there's now a single indent on the second line.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f3be5aa49829a..7cd0ad94726df 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct=
 kvm_userspace_memory_region *m
> >       valid_flags |=3D KVM_MEM_READONLY;
>
> Is it better to also via kvm_vm_ioctl_check_extension() rather than
> #ifdef __KVM_HAVE_READONLY_MEM?

Probably, that's unrelated though so I won't change it here
