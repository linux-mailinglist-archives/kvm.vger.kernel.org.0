Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F967930BA
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 23:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbjIEVIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 17:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbjIEVIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 17:08:45 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FF6CFA
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 14:08:30 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-50095f6bdc5so477e87.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 14:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693948108; x=1694552908; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UtgOQUTnvsg8LqXUGehogATK7JC4MN9JVIJsfm4tuQ=;
        b=GNelMF0AaV3PkxVWUXie0i31i0oF7rhBM/OKWRNDgYFT6fhKZ9Nuhvdrm1KdLdz5sq
         2RUqdWfXJ8D6V5dxDbM/dNUSLVsrt5wItlZrc89TvNNKwIVzhckvnGQwII9cz9qwt6Gl
         scIsrSSAvB2/5f2gjVUYyAf4RnSidtTYjA0NYF/BlZTgWCeqcEn7WlHU7OLdY1lPq0Yc
         dzQ85XKVkiPHKTAkqQXHK0pZUAlmMeBSaS52GVhcb3NReeH49NwJqJ/GC9N+DKj52+tU
         yyPIco5SAv/zaAuqRGqSy0Tp9zWieIeMHTvofSv5EM9Kf8+p2NiGzFx4Zllcgkykds1s
         IVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693948108; x=1694552908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UtgOQUTnvsg8LqXUGehogATK7JC4MN9JVIJsfm4tuQ=;
        b=Qtimfdrk5VhMvfav7gAcoxtuiH98gTMBkCH6mLVkyT3lda7jybMiOIRgO8IYvkENdb
         KPeqbu4d6SpDLOF4G7UQ60V7sCeSPk08vEmOC/fSH3W6eAHHJk1tkZ2YY2ZEZlAsUhWk
         yFQJe6Ioh0BTgfMOlBFyaQvPI0VM6E3R8gK9jsZMmVj+6NanPsYssoz8HB/A7Jt2PdO8
         EYH7pkWTQvhHZwpOAwpPXWssMP8DeZ7bS+QTu6jAo2ynAPkNfEm/L+lNvBmeeMJKt2WE
         BS+6+QWoXBd9Zty+qqQHzVzNM6qKrPc3rGJ7M1QJdCkyiDOvaAu9JhBRtsqhRFKWr8Sw
         SHnw==
X-Gm-Message-State: AOJu0YxpYWuWqz2JkGWNDL8CWDboUOswjVk3eXMHm7UmpJvGeL+N1VUT
        poRVMs7WfQ8L6YYbNbgcFIM4ZuF1BUHWPYoousx/xQ==
X-Google-Smtp-Source: AGHT+IGi3r+D8G/m6L/u8s3c3u9ly6kqm/fYyRUgxE2gdVAY6ZpMN36MDzAzf+bQYHc/wP4eqlM/AnJ1aPr9KwBrIAA=
X-Received: by 2002:ac2:54b6:0:b0:501:3d3:cbc0 with SMTP id
 w22-20020ac254b6000000b0050103d3cbc0mr36289lfk.2.1693948108334; Tue, 05 Sep
 2023 14:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230905161048.3178838-1-pgonda@google.com> <ZPeWXNpwYua9S+tV@google.com>
In-Reply-To: <ZPeWXNpwYua9S+tV@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 5 Sep 2023 15:08:16 -0600
Message-ID: <CAMkAt6qTF0oMFJg0ZJsyUY88TegjuETdLj9WsJvDG+jDxO_Thg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Update SEV-ES shutdown intercepts with more metadata
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Sep 5, 2023 at 2:58=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Sep 05, 2023, Peter Gonda wrote:
> > Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
> > only the INVALID_ARGUMENT. This is a very limited amount of information
> > to debug the situation. Instead KVM can return a
> > KVM_SYSTEM_EVENT_SEV_TERM to alert userspace the VM is shutting down an=
d
> > is not usable any further. This latter point can be enforced using the
> > kvm_vm_dead() functionality.
>
> Add the kvm_vm_dead() thing in a separate patch.  If we want to actually =
harden
> KVM against consuming a garbage VMSA then we do need to mark the VM dead,=
 but on
> the other hand that will block _all_ KVM ioctls(), which will make debug =
even
> harder.

Will do. Do we have better functionality for just blocking running the vCPU=
?

>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> >
> > ---
> >
> > I am not sure if this is the right path forward maybe just returning
> > KVM_EXIT_SHUTDOWN is better. But the current behavior is very unhelpful=
.
>
> Ya, KVM_EXIT_SHUTDOWN is better, we should leave KVM_SYSTEM_EVENT_SEV_TER=
M to
> explicit "requests" from the guest.

Sounds good to me. I'll send a V2 that just updates to KVM_EXIT_SHUTDOWN.
