Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A7878891A
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbjHYNza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245306AbjHYNzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:55:11 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F042137
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:55:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-529fa243739so14946a12.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692971707; x=1693576507; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOsznFJKBgF85tKjvsggmyh6xgrLZeKfBDJV/ZCTx7o=;
        b=4jx9OgP1Gpl1xz/tD9iah8v6s2uF716KS0Yg0qihPAiTQhOw9oXKuR5ahEuUvUWMaa
         WCrKxV/oFx78BgL+VrpYAWrD6HKmPlCc9eZlw4Cg/+/jOOY+3+IV+uxueyTFs5aC57rR
         C+8M4BfssNhvEsx6oXyXKZZQMRCoZ4N4OVTbb9pb/XhwqYp0hloJKJ0jxI9NtdIphrQl
         nsysJK+wqPIF8qYh6rmKS1L5gnsp9Kp+sHWAwQia0Hx2GB+dfAYFkex03ASFEnQkzV3+
         S77yIhibz2fPo3y/GVrJDjx19QEyh/ST7hDNpUgfNHsuqOE7BDJM0gFuxJRXBdvXlQ5k
         RX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692971707; x=1693576507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOsznFJKBgF85tKjvsggmyh6xgrLZeKfBDJV/ZCTx7o=;
        b=PHwT7QzNbJKE2ABdk0Z8/kVyLo0+Y//9MYcH6asVuddajcTdSU55kVd24J9d7rfMv/
         HR60RH3mq69KtbLPbVtPv5mbfyB0s9fjzDr7VGoi4mcSpbbJggXkWoBZ5OelQwS9DMiA
         2Cn41yQMxCC0KtoKhnYq7UDIUVm1QhdeeVNW7WjHI/EgqAUR2EZHJHsRIt0NN5vEkNy8
         wxvSuDdsMj7QONQTowm77SA+jgUwcf2SMxaApVikSUm0agkFFjIwvW4TsCcJBelsUyxB
         i3y4PJ2jCvdFn5tern51INIowe6X6MeZceUs2PhDYAkcVgC6q6JMV0AiFrgazw2qily/
         3dRw==
X-Gm-Message-State: AOJu0YzhyOgsMSXYEF9JeBfMLPNRYX+2Pr2l7IyLLn2OAtXret+znKq6
        jAS999o4MUUvQOzl5nOikqZ9eOVLP9DML7WEjc2lXC4wYYHjJlGG75c=
X-Google-Smtp-Source: AGHT+IFuPrXo7G2xRd1QBRdmwZINjLU2wZmGwLjYFt3kPJexf5ykFEfKfZc+8gu0AUUkd6grYvcCwqeM07WVgdJKkXM=
X-Received: by 2002:a50:8e18:0:b0:522:28a1:2095 with SMTP id
 24-20020a508e18000000b0052228a12095mr170486edw.3.1692971707521; Fri, 25 Aug
 2023 06:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230825022357.2852133-1-seanjc@google.com> <20230825022357.2852133-2-seanjc@google.com>
 <a08dc726-0251-0063-398f-cc0872ebf285@amd.com>
In-Reply-To: <a08dc726-0251-0063-398f-cc0872ebf285@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 25 Aug 2023 07:54:55 -0600
Message-ID: <CAMkAt6oPU0S7FZ9snY9JKSApaeysm4yj6RgHC1Tmd8ZCotN0mQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Get source vCPUs from source VM for SEV-ES
 intrahost migration
To:     "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Aug 25, 2023 at 4:23=E2=80=AFAM Gupta, Pankaj <pankaj.gupta@amd.com=
> wrote:
>
> On 8/25/2023 4:23 AM, Sean Christopherson wrote:
> > Fix a goof where KVM tries to grab source vCPUs from the destination VM
> > when doing intrahost migration.  Grabbing the wrong vCPU not only hoses
> > the guest, it also crashes the host due to the VMSA pointer being left
> > NULL.
> >
> >    BUG: unable to handle page fault for address: ffffe38687000000
> >    #PF: supervisor read access in kernel mode
> >    #PF: error_code(0x0000) - not-present page
> >    PGD 0 P4D 0
> >    Oops: 0000 [#1] SMP NOPTI
> >    CPU: 39 PID: 17143 Comm: sev_migrate_tes Tainted: GO       6.5.0-smp=
--fff2e47e6c3b-next #151
> >    Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.28.=
0 07/10/2023
> >    RIP: 0010:__free_pages+0x15/0xd0
> >    RSP: 0018:ffff923fcf6e3c78 EFLAGS: 00010246
> >    RAX: 0000000000000000 RBX: ffffe38687000000 RCX: 0000000000000100
> >    RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffe38687000000
> >    RBP: ffff923fcf6e3c88 R08: ffff923fcafb0000 R09: 0000000000000000
> >    R10: 0000000000000000 R11: ffffffff83619b90 R12: ffff923fa9540000
> >    R13: 0000000000080007 R14: ffff923f6d35d000 R15: 0000000000000000
> >    FS:  0000000000000000(0000) GS:ffff929d0d7c0000(0000) knlGS:00000000=
00000000
> >    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >    CR2: ffffe38687000000 CR3: 0000005224c34005 CR4: 0000000000770ee0
> >    PKRU: 55555554
> >    Call Trace:
> >     <TASK>
> >     sev_free_vcpu+0xcb/0x110 [kvm_amd]
> >     svm_vcpu_free+0x75/0xf0 [kvm_amd]
> >     kvm_arch_vcpu_destroy+0x36/0x140 [kvm]
> >     kvm_destroy_vcpus+0x67/0x100 [kvm]
> >     kvm_arch_destroy_vm+0x161/0x1d0 [kvm]
> >     kvm_put_kvm+0x276/0x560 [kvm]
> >     kvm_vm_release+0x25/0x30 [kvm]
> >     __fput+0x106/0x280
> >     ____fput+0x12/0x20
> >     task_work_run+0x86/0xb0
> >     do_exit+0x2e3/0x9c0
> >     do_group_exit+0xb1/0xc0
> >     __x64_sys_exit_group+0x1b/0x20
> >     do_syscall_64+0x41/0x90
> >     entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >     </TASK>
> >    CR2: ffffe38687000000
> >
> > Fixes: 6defa24d3b12 ("KVM: SEV: Init target VMCBs in sev_migrate_from")
> > Cc: stable@vger.kernel.org
> > Cc: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 2cd15783dfb9..acc700bcb299 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1739,7 +1739,7 @@ static void sev_migrate_from(struct kvm *dst_kvm,=
 struct kvm *src_kvm)
> >                * Note, the source is not required to have the same numb=
er of
> >                * vCPUs as the destination when migrating a vanilla SEV =
VM.
> >                */
> > -             src_vcpu =3D kvm_get_vcpu(dst_kvm, i);
> > +             src_vcpu =3D kvm_get_vcpu(src_kvm, i);
> >               src_svm =3D to_svm(src_vcpu);
> >
> >               /*
>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Thanks Sean.

Reviewed-by: Peter Gonda <pgonda@google.com>
>
