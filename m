Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A9D7741B3
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbjHHR0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbjHHRZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:25:41 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF53205DF
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:11:08 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-786d27c9f6eso596190639f.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 09:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691511025; x=1692115825;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BaiJ+rWGolW4ovI22gadBn2AFu8/7ikdaAkBdyz0qCk=;
        b=1zctfH+5bNyB7juNxMuNyN0uB0hwYs9csxinYQ/nhKjaHDXtNVHo23es9Bf3RRMrUU
         6rNIiqGKkiF9U1U4NlIOXSEh4f7/x0xSu+0Ujg2gQqPonEB/0B5AzME7yThSXCl5qdjJ
         gBr0E1KWMl7RGgtGY66+qhLcWZIoraYoLM82LseAEKkq7ooolUvGlKuxlGUCQtuXxt4w
         oWRP2PUQmDLZf2CZuW5lo/j0Yt/MldMYajwjhjFJtPof+1JbxM6OgXHYyljWch2YbpeV
         DV8TMgiJbpVqgcrTaaa/NqDrVLpRAzQ6HrmWH7yxYgiLWFdl7rCRVYoLo8N5mg5SOwIL
         ge0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511025; x=1692115825;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BaiJ+rWGolW4ovI22gadBn2AFu8/7ikdaAkBdyz0qCk=;
        b=UYwwZ4kkpw7aCqEYjykxVO4grmwpyGO1gLlTiKoSKIIyFuF1z9Qx61P79plA6UKeh2
         j04n9kFzzOH/4KUma/QDZ5SJFNQPLC8ya8MV4e2kJ+ax5LDXGrlnk9yMMvLt9K2+TzlB
         sgZozuOGZEVU2cQOWcEsU29nSVCCS+yF13VgXHILRqrjFbB6LvyXEzlZ/rUaBWeHSRHy
         PNEUtDFBpH7dIwgBBZsAeuaZVhCsZ50Jb+I6d/7b3fr3KP1xrH/4IkW8GhNJjiA34cGh
         mBt6A25AjYgPfngMdzkk6gka305I0jJHWUVy36X2Ejf3w7yHHvFk94BSkBeCyURmJWPa
         L6jw==
X-Gm-Message-State: AOJu0Yww0fLPWF1TIsUC+JZaizsMtC34bAtHY+reX3z5pBoErz5tvawB
        iox1FCMGelFKcpYcpUsYI1IfKlX0Mek=
X-Google-Smtp-Source: AGHT+IG5/N2ZE1Ejorc8NLEsKzeCITxV+EG+130yb+21WD/iP5VWmZCCV6UyxFu6UTgxWYvax2jHbb68fQQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3c11:0:b0:564:179a:d5cb with SMTP id
 j17-20020a633c11000000b00564179ad5cbmr56114pga.8.1691507265754; Tue, 08 Aug
 2023 08:07:45 -0700 (PDT)
Date:   Tue, 8 Aug 2023 08:07:43 -0700
In-Reply-To: <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com>
 <877cqdqw12.wl-maz@kernel.org> <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
Message-ID: <ZNJaPxTtPRCv0HOl@google.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
> On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
> >
> While working on the renaming, I realized that since this function is
> called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rename
> this and the other kvm_flush_*() functions that the series introduces
> to match their kvm_arch_flush_*() counterparts?

Hmm, if we're going to rename one arch hook, then yes, I think it makes sen=
se to
rename all the common APIs and arch hooks to match.

However, x86 is rife with the "remote_tlbs" nomenclature, and renaming the =
common
APIs will just push the inconsistencies into x86.  While I 100% agree that =
the
current naming is flawed, I am not willing to end up with x86 being partial=
ly
converted.

I think I'm ok renaming all of x86's many hooks?  But I'd definitely want i=
nput
from more x86 folks, and the size and scope of this series would explode.  =
Unless
Marc objects and/or has a better idea, the least awful option is probably t=
o ignore
the poor "remote_tlbs" naming and tackle it in a separate series.

Sorry for not noticiing this earlier, I didn't realize just how much x86 us=
es
remote_tlbs.

> (spiraling more into this, we also have the 'remote_tlb_flush_requests' a=
nd
> 'remote_tlb_flush' stats)

Regardless of what we decide for the APIs, definitely leave the stats alone=
.  The
names are ABI.  We could preserve the names and changes the struct fields, =
but that
would be a net negative IMO.
