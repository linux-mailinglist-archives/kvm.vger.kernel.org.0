Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38204786400
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 01:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbjHWXjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 19:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbjHWXiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 19:38:52 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8DE76
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 16:38:50 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-48d11f47ee6so1395480e0c.3
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 16:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692833930; x=1693438730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZO+KG5SZiqTJzrTe4qbDf++hcu2xNBSHjZPSg9a/xEU=;
        b=6D+mHd3IWBZKLdtdzYNiMB6DOZFCi7JVeFDt/lv3fYYQymcqj8phGrx+ok2GI0EFP6
         cFv+lQF7btCFFf36r062ahQEDaD2gN8P0Zr/PeE10lOYsrlhAMWiBin6pMvNM/N61rnf
         cOxB/2IbI5gQOPsnOZ9KQxi1Ws4YTiU8GUL2gU6eqrGr09m5p8psQ50V5NBPpENSVVtL
         UStcfj/IBcusR1NfFsAVC0RAem7W7Ex/bQ6+v55ywOohE7KRXA933vEfW2fmt7lNQf8u
         X6nI+7RSZpmeMn7EVBSKO9T+tg3KEZhOWkDG7LtHV8O+thUnM0hyHoqZ/AYZCf32FPRm
         vN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692833930; x=1693438730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZO+KG5SZiqTJzrTe4qbDf++hcu2xNBSHjZPSg9a/xEU=;
        b=e+9OL04rq+tbseUeHT58uT2g+e6/Yzl34uEbc2oefuqwb4lCJ1+o3jxuNEdOi2tADF
         YN78dO6NajKGDhq+7Es/aeGoLwTnIOhqv5WYVvEBHdg4vi+WAE8IGJCJVjOLpzUjMVrs
         eNU5yBhFQ82RriUJMc8JXRW9D43EMhiig6EZKjz/A8KJO6y9nqUVg9lrlFR9xw2quAPl
         iGiYb1K5YKfGumKSwJuel3alUxd+jcJ6bm4mNXKsCGv40kz5q44Vy3LkbL6zb11J4oEk
         z6dTdVOdIITCeUv2dmxRmxj3tXWi3+T/nvChfpTbTCrq7c89vV3crcSgqlj6f7LWI9P2
         D8Fw==
X-Gm-Message-State: AOJu0YxRwCY8DyQRqtN5B8rAWzy632NGbkQKe0Zn8gnzM27p3PzzKafZ
        Cuh/IElEM2tuYXBs+2t2zpAormVv9MiEA8MMqINy3Q==
X-Google-Smtp-Source: AGHT+IF4vsULjLW/zRCh3C4yJKU8FcP6P7QTILApdW/ZpmC/o073sGFstB8anaNRyNqf/nv2pnGJr9AWsWpdMgY+/FI=
X-Received: by 2002:a1f:e3c3:0:b0:48c:fdfe:aa41 with SMTP id
 a186-20020a1fe3c3000000b0048cfdfeaa41mr12395044vkh.0.1692833929618; Wed, 23
 Aug 2023 16:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
 <ZN60KPh2uzSo8W4I@google.com> <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
 <ZOaGF6pE5xk7C1It@google.com>
In-Reply-To: <ZOaGF6pE5xk7C1It@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 23 Aug 2023 16:38:13 -0700
Message-ID: <CAF7b7mpPcbxLKhPvLwVg4mwSbXRQ-zRhz8Osj-CVqhMnG6NRkw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> I don't anticipate anything beyond the memory fault case.  We essentially=
 already
> treat incomplete exits to userspace as KVM bugs.   MMIO is the only other=
 case I
> can think of where KVM doesn't complete an exit to usersapce, but that on=
e is
> essentially getting grandfathered in because of x86's flawed MMIO handlin=
g.
> Userspace memory faults also get grandfathered in because of paravirt ABI=
s, i.e.
> KVM is effectively required to ignore some faults due to external forces.

Well that's good to hear. Are you sure that we don't want to add even
just a dedicated u8 to indicate the speculative exit reason though?
I'm just thinking that the different structs in speculative_exit will
be mutually exclusive, whereas flags/bitfields usually indicate
non-mutually exclusive conditions.
