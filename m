Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C744ECC5F
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350550AbiC3SiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351289AbiC3Sd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:33:27 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF94B87A
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:30:46 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 17so28904868lji.1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KXz4jX/1RvaOeW5K5aku8Xx+S8uCJJg7lNaIyrndCYc=;
        b=frqv9Lra3sJ1hmBQk1xcR/thRy/JxxiQUadtvz+DMIkXvKrJabZbpPUhpx+Ve91aKc
         fLtY+UckqqT5YbdQA6Bky2RLFbQGh3k/vghn4LAPKw2vzDDLZU8Djq3wr+waC5oPb6L1
         OmcgLSd750msUztwjdciWczDq24pauhcEFfzo8gsEcqI3INuIwXc8ZKgtbeeROpqBcea
         TWj8QVrS7lwjkJ/gwXL55djUOd1ZT2y0CjXJB2SaDuaaaaenT5X+byGZTDIlcyjz0gxd
         tZKQNwA4kvDKzqYqykOxvB1FCoKLfdgKaUrBgUw1JjNJ9dp679PQP6+DUBuAvPampRj8
         TsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KXz4jX/1RvaOeW5K5aku8Xx+S8uCJJg7lNaIyrndCYc=;
        b=Cpuox40hYZ1sNgZfmSVkk0Innp75P/rNmCH6oT37CzU8osi1I2pPdsLG0XalfjlhTR
         mb3xUybWRFYNmygkw4RD1LIHY/Ld/KPjc/h6PtQNDbJHBfPa3SgRjugFPBYhfa363SvZ
         baj21T0O6wjTAUDScUUuMD8iWAASuePdi2PMqXqtE8ng8RDmFE8/0ATTuLcaaxtIDgSX
         BIg5TIPT7QBH0sR84ukcdlUngQQg3CIp25grgCtAOJX8dRQeKndR1dazWUTeMJrF3ck2
         IJ0Nu2W329Z+0GQeBNd5ZqtR3RBJs9mC/qlRJNIlzsaq8KvU3iyHbPwys9zGejcrRziS
         GQMQ==
X-Gm-Message-State: AOAM530IU7jLwbsqqk+IDXdQa4dUAGcMnPaaGlc5+u7sgvDPQZJPFmLT
        +0S0mEv3qzWmdFSjX/nOwEnXcAB0NCuUi2592eJzefgE088=
X-Google-Smtp-Source: ABdhPJxkJ9NLcGGxc1sMNi6f38U3o2OW0nZw+JbR7XSZZ4ykgVP08KAUGWyfphqVLg8WNP0f2n2s2VFEsZJtak2cP9w=
X-Received: by 2002:a2e:988e:0:b0:24a:cf5d:24cf with SMTP id
 b14-20020a2e988e000000b0024acf5d24cfmr7486340ljj.282.1648665039455; Wed, 30
 Mar 2022 11:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220325152758.335626-1-pgonda@google.com> <d0366a14-6492-d2b9-215e-2ee310d9f8ae@redhat.com>
 <CAMkAt6rACYqFXA_6pa9JUnx0=3vyM6PeaNkq-Yih4KM6saf6PQ@mail.gmail.com> <632d3601-ecf4-12f3-4f3b-408c35f028f6@redhat.com>
In-Reply-To: <632d3601-ecf4-12f3-4f3b-408c35f028f6@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 30 Mar 2022 12:30:28 -0600
Message-ID: <CAMkAt6q-wTxiQnFXhiw3gR_8ktfz9pLp3gZS3EFakGcBgxUJ2A@mail.gmail.com>
Subject: Re: [PATCH v2] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 25, 2022 at 10:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/25/22 16:31, Peter Gonda wrote:
> > On Fri, Mar 25, 2022 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 3/25/22 16:27, Peter Gonda wrote:
> >>> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> >>> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> >>> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> >>> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> >>> struct the userspace VMM can clear see the guest has requested a SEV-ES
> >>> termination including the termination reason code set and reason code.
> >>>
> >>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>> Cc: Borislav Petkov <bp@alien8.de>
> >>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>> Cc: Brijesh Singh <brijesh.singh@amd.com>
> >>> Cc: Joerg Roedel <jroedel@suse.de>
> >>> Cc: Marc Orr <marcorr@google.com>
> >>> Cc: Sean Christopherson <seanjc@google.com>
> >>> Cc: kvm@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>
> >> This is missing an update to Documentation/.
> >>
> >
> > My mistake. I'll send another revision. Is the behavior of
> > KVM_CAP_EXIT_SHUTDOWN_REASON OK? Or should we only return 1 for SEV-ES
> > guests?
>
> No, you can return 1 unconditionally, but you should also set reason and
> clear ndata in the other cases that return KVM_EXIT_SHUTDOWN.


Sounds good! Done in V3, thanks
