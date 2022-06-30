Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D054562004
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiF3QLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 12:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbiF3QLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 12:11:46 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F4C31516
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 09:11:46 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31772f8495fso184055657b3.4
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 09:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35ohpAR7cqH9U9RyAn52Y1KeS3AQQHvr9QCi1XZdTpg=;
        b=eY95lJBmcdlK0EwfQODP9AvJyJ99kW8OGcAWWEwWNSPGJw35l3xlz1W+pqvmj9u7RK
         f1kUgkjbYzJbpRm7P76ezLacp/vW9dEG4h8sTRXcgjGYwwW4jJeWuc4Ya1XOfRh9waE3
         RFS38djZZIrfRz0j+WrPk9kSf77f3PNzXWId3Sjxy5lUJb9iUIbm8LJysjLiaCHUzb9d
         vDS6NeAKNVbWRr2Q4NibE5QK+J4E1Nsec42oOnZu4VtD3tR0NEQIWWgtfM5Fe0C8EYHy
         FFvUu8DqrUFaCN9p/OQan5xeK0UUhe+ebMLQtPYV3KFr5hQd0I3WNayF9KUoyoNJT5Gt
         nhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35ohpAR7cqH9U9RyAn52Y1KeS3AQQHvr9QCi1XZdTpg=;
        b=UUj5BeoZX/d2X+BNiWXbvswuPldHr1KAmDR4/og5JOMDHybf5cJV/CB2gCEZdKosts
         VlhfVUkNnH3oCo+/D+EszTuVqRBJ3cJsTQQa3fwj9C4N9yv0PLe9SMpIs3bNwvDzsVuX
         BdSD9c83b7veJKqAPswP9/boegRONWB1YyUPQrIRKAwlbLbX/XuvDLOxFWKiSuL+T7Qb
         IbUZ7W6ceVDo3Usa9+xZkc5mI7ysDHQ3arYq/CSe4Aceo+ST3bKSgIKmfxVpsyhu5G4K
         rHthqTyXpEAGktYEGaoJXLGSr7q61CyFhEcThvYdCNsQikwFHWOUrKtt+gZ6wU/87kvc
         KMUQ==
X-Gm-Message-State: AJIora9YORAhnNUhvqZ/OzvlsOWCMUfIO9qMP8e3NFMx72KrkgAFtoQZ
        H2f5Bi9IXO7quBG5gS4T8t5mP9CAG6vBZQRXBK7ldg==
X-Google-Smtp-Source: AGRyM1vCpZl3xnje8qjilvDpbsZrN0PzMVWLXy9VUU8EQRUjnBeOmcQvMf4njaP/oZniXnjDYvJIJNG6poE1xy2BsdM=
X-Received: by 2002:a0d:d416:0:b0:318:88a8:ca4f with SMTP id
 w22-20020a0dd416000000b0031888a8ca4fmr11812662ywd.371.1656605505325; Thu, 30
 Jun 2022 09:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220629193701.734154-1-dionnaglaze@google.com>
 <Yr1bYiA1w/lMX76k@redhat.com> <be2ebbbf-1568-1eb5-b2ff-73819d4e872d@amd.com>
In-Reply-To: <be2ebbbf-1568-1eb5-b2ff-73819d4e872d@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 30 Jun 2022 09:11:34 -0700
Message-ID: <CAAH4kHaLbOjsqWEB2EehwcHpQwH8vaqgqmRUiNpEnMDtUyT4oA@mail.gmail.com>
Subject: Re: [PATCH v2] target/i386: Add unaccepted memory configuration
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, Xu@google.com, Min M <min.m.xu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Gerd Hoffman <kraxel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
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

> > The most recent patches I recall for SEV-SNP introduced a new
> > 'sev-snp-guest' object instead of overloading the existing
> > 'sev-guest' object:
> >
> >    https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04757.html
> >
>
> Correct, the SNP support for Qemu is only RFC at this point until the KVM
> support for SNP is (near) finalized.
>

Ah okay, should I wait until that RFC patch set is merged to propose
an extension to it, or should I coordinate with y'all at AMD to
include this in your patch set?

Apologies Pankaj, I forgot the change log (still new to git
send-email). The change is that the configuration option is no longer
in MachineState, but part of SevGuestState, with accessor functions
for fw_cfg.c to know if it needs to add the fw_cfg file and what its
value should be. That was the main feedback on v1.

-- 
-Dionna Glaze, PhD (she/her)
