Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C098C62064E
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 02:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiKHBtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 20:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiKHBta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 20:49:30 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D906193CC
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 17:49:29 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w14so18739833wru.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 17:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xuvE4F/C8mjsWtuoVxb3zdO4+CnchffIGABRmA+Vuh0=;
        b=Mdo/Cd0wbMHK75stARzp+VT1zkwi64tYYHeWBlv5vkB+zkrLZn72cRVp6p6edAXvyF
         cqGU3Vvyi/lXq5nEQnd0/ETKSw9Tn1U5QGNU6dr0B8oaDRLG15MvWfc8E5luC09s+Da3
         keOv5ywgRfe5ju+xfyswJEvczYPLyXEPl2KDJ2Crqukz+KN+nEwHVRLpk4xsQlQoab+5
         ATe2NhQcYxXC9vWwEkjloyML4sr1JGQyKMmtLKGZZUm9BzJq5lR5xVt86ZWbJXsO3r/K
         SLiOlq3unTkB+6smRWmj6sUV0t6pGahvH8FRTN65s3Q6NMvMLpUis+eIcH38aqcp2zjm
         Pbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xuvE4F/C8mjsWtuoVxb3zdO4+CnchffIGABRmA+Vuh0=;
        b=wJqv/32QqUhNni/oNsW7yrPHQQCsdZc8L2WF1wFj1hjIpRtDkz06HZxml+6X2sbCX5
         ji20TsRaWzKTvGmA9xc7ZLoGtKqZ25dtrWmE4jxwe41MiXpK5yQGKHOrEgtxRMPCvmcU
         djHXsBVFDMOwF+Eg4RYip3MlCFRx3UOsCp9rvgsDl/yJWnS3R3Za44qx2ugoic9wRbGi
         s3RkOYAH31ThoAERAJS/Bkvwpe6r8eaQ5+48At8G+aUMQf6msk3uTv/BMiQ9xy5mQ/mG
         xWAXb43UcrMevZ2+wTbYJPugooZQ6zo64wRHEdUza/sjyB5Dg6evXUV856NYZC1Y+9EA
         e8tA==
X-Gm-Message-State: ACrzQf102obYLNwr/eX2GfSlONcRllTVAR0x/PXNmyVbHrhLHGs5El9s
        r+/gTSlVh6I8WMSegVBZJXuZC4zWTximrezkBJxbrQ==
X-Google-Smtp-Source: AMsMyM45cXg/OhqoKKM/42Y8A1GcvODXHttPNpHG+ucd6vVaB/29yYBZSZRvZxDKG8k65RzBlCykj+hQyAqRS7DM0AI=
X-Received: by 2002:adf:e94a:0:b0:236:6f5a:e89b with SMTP id
 m10-20020adfe94a000000b002366f5ae89bmr33610623wrn.451.1667872167428; Mon, 07
 Nov 2022 17:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-6-vipinsh@google.com>
 <Y2lO1HQtaMBCGpcZ@google.com>
In-Reply-To: <Y2lO1HQtaMBCGpcZ@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 7 Nov 2022 17:48:51 -0800
Message-ID: <CAHVum0c2QVyuxQxOQHOxmU2csgE1RHtJ7nLBWCHt6=ywuB-Tmw@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: selftests: Move hypercall() to hyper.h
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 10:30 AM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Nov 04, 2022 at 09:57:03PM -0700, Vipin Sharma wrote:
> > hypercall() can be used by other hyperv tests, move it to hyperv.h.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  .../selftests/kvm/include/x86_64/hyperv.h       | 17 +++++++++++++++++
> >  .../selftests/kvm/x86_64/hyperv_features.c      | 17 -----------------
> >  2 files changed, 17 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > index 9d8c325af1d9..87d8d9e444f7 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > @@ -199,4 +199,21 @@ static inline uint64_t hv_linux_guest_id(void)
> >              ((uint64_t)LINUX_VERSION_CODE << 16);
> >  }
> >
> > +static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> > +                             vm_vaddr_t output_address, uint64_t *hv_status)
> > +{
> > +     uint8_t vector;
> > +
> > +     /* Note both the hypercall and the "asm safe" clobber r9-r11. */
> > +     asm volatile("mov %[output_address], %%r8\n\t"
> > +                  KVM_ASM_SAFE("vmcall")
> > +                  : "=a" (*hv_status),
> > +                    "+c" (control), "+d" (input_address),
> > +                    KVM_ASM_SAFE_OUTPUTS(vector)
> > +                  : [output_address] "r"(output_address),
> > +                    "a" (-EFAULT)
> > +                  : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> > +     return vector;
> > +}
>
> Since this function is Hyper-V specific it probably makes sense to
> rename it to hyperv_hypercall() as part of moving it to library, e.g. to
> differentiate it from kvm_hypercall().
>

Sounds good. Does it keeping it in header file "hyperv.h" seems fine
or should I create a new "hyperv.c" lib file and move function
definition there?

> > +
> >  #endif /* !SELFTEST_KVM_HYPERV_H */
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > index b5a42cf1ad9d..31b22ee07dfb 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > @@ -13,23 +13,6 @@
> >  #include "processor.h"
> >  #include "hyperv.h"
> >
> > -static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> > -                             vm_vaddr_t output_address, uint64_t *hv_status)
> > -{
> > -     uint8_t vector;
> > -
> > -     /* Note both the hypercall and the "asm safe" clobber r9-r11. */
> > -     asm volatile("mov %[output_address], %%r8\n\t"
> > -                  KVM_ASM_SAFE("vmcall")
> > -                  : "=a" (*hv_status),
> > -                    "+c" (control), "+d" (input_address),
> > -                    KVM_ASM_SAFE_OUTPUTS(vector)
> > -                  : [output_address] "r"(output_address),
> > -                    "a" (-EFAULT)
> > -                  : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> > -     return vector;
> > -}
> > -
> >  struct msr_data {
> >       uint32_t idx;
> >       bool available;
> > --
> > 2.38.1.273.g43a17bfeac-goog
> >
