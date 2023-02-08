Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7540C68FB72
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 00:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBHXpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 18:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjBHXpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 18:45:49 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754CC1D902
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 15:45:27 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o1so54494ioo.10
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 15:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WcL9PGaCG/ZWPbc4t5z1SGMh6BK/zmCar/KhfLe+fCA=;
        b=WMk2sU3V2q9RN7UHizT8GLu66ul4VuFxWG/EcxZYRWb52x9YQvWnJSvJhjn59hsIEA
         PD6E8AIWsK9ey6W2uWygOvTPNnJ6rv9VqGcE8cfBCjlealBblZfBjHl1iK7RjFDVemeK
         P5n58V1H4QX+TSbLh7UzBWYdEu+FFm5eSsqsDqa08y5nN3XYWCxUkYlgRIvvkvK6cVHU
         EnIPTVsbMT53LD+OF+QAp+Z4Sieu48sjXa+SYgWl/ImMRgwAK1PEp8Z3/I3FnDn2bNlc
         aXPhkMtl8sID8xD45vH9hXeGse/HxBWFjFqR8OY6m099MicCnc+Qk/r/NgsvxF5xnGU6
         uVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WcL9PGaCG/ZWPbc4t5z1SGMh6BK/zmCar/KhfLe+fCA=;
        b=XK/s5D6NSCWLYMFSSwxBRIRZ60qEoQWQNjiJd+uSMcwo65XAx7Hz1Cx9l6HjOwncQ0
         XMtTXubGWwKevmAiEXjbWBs6FVV/Py5rOpYXVSm9sxOBdPt1/TQYVvRg19apcC8rtYj/
         NAzKNRmS+ykFIHRgLFMXIeygLpPKf0upl+QTmYLA40rv1Nnbkyb0KNAu/9f5DSBFOK0c
         JhOm0ja2oNGIjPAWTT/5UeITLaqlkX/Abjm991BM6DnvZrARn2fMKOOs6tJlSyaZMNBM
         /OqEzsDqiruQPiejbGLx3T3PXB2/RDRWwZuXNrunF8JzHIvn5SDcFIJ6rKs1TAMd1DrG
         pGYQ==
X-Gm-Message-State: AO0yUKXWu8D9ti+Hm4Ptq4K7PYLFZsNkBC0q6pVDIcAFpNMxkhZMYPl/
        DbKJFjXPpVtCLuRAmN+OFACmvjqDZdHXPs5CoSIHeQ==
X-Google-Smtp-Source: AK7set/vIivBAhFl0h/g2TdhIqP2JE36ugcgpMZ2ismjRq5JV/l/1Bu58cOwPeO8EOLmTzH9t7sSyhl9ZO6AuC/UebA=
X-Received: by 2002:a6b:1545:0:b0:71b:796c:851c with SMTP id
 66-20020a6b1545000000b0071b796c851cmr4888966iov.50.1675899921946; Wed, 08 Feb
 2023 15:45:21 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-3-vipinsh@google.com>
 <Y+GQNXDlNbJNvDd2@google.com> <CAHVum0d2dRvNaS+AMqdbF35D05dDQrtZ4TBQ1QOYx6he-Cy6YA@mail.gmail.com>
 <CALzav=dw8hzbfOtWFo+tb6aKavrdfjrbuJ-o0_F39o=53u95MQ@mail.gmail.com>
In-Reply-To: <CALzav=dw8hzbfOtWFo+tb6aKavrdfjrbuJ-o0_F39o=53u95MQ@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 8 Feb 2023 15:44:45 -0800
Message-ID: <CAHVum0ejx5D_fKMqdHzpZgv7GKj3ziEb+cnDXJpx2DYfBbdr6w@mail.gmail.com>
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
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

On Tue, Feb 7, 2023 at 9:47 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Feb 7, 2023 at 9:37 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Mon, Feb 6, 2023 at 3:41 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Fri, Feb 03, 2023 at 11:28:19AM -0800, Vipin Sharma wrote:
> > >
> > >         if (wrprot || spte_ad_need_write_protect(iter.old_spte))
> > >                 clear_bits = PT_WRITABLE_MASK;
> > >         else
> > >                 clear_bits = shadow_dirty_mask;
> > >
> > >         if (!(iter->old_spte & clear_bits))
> > >                 continue;
> > >
> > >         iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);
> > >
> >
> > Yeah, this is better. Even better if I just initialize like:
> >
> > u64 clear_bits = shadow_dirty_mask;
> >
> > This will also get rid of the else part.
>
> On that topic... Do we need to recalculate clear_bits for every spte?
> wrprot is passed as a parameter so that will not change. And
> spte_ad_need_write_protect() should either return true or false for
> all SPTEs in the TDP MMU. Specifically, make_spte() has this code:
>
> if (sp->role.ad_disabled)
>         spte |= SPTE_TDP_AD_DISABLED_MASK;
> else if (kvm_mmu_page_ad_need_write_protect(sp))
>         spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
>
> sp->role.ad_disabled is never modified in TDP MMU pages. So it should
> be constant for all pages. And kvm_mmu_page_ad_need_write_protect()
> will always return false for TDP MMU pages since sp->role.guest_mode
> is always false.
>
> So this can just be:
>
> u64 clear_bit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
> shadow_dirty_mask;

I discussed it offline with David to understand more about it. It
makes sense as TDP MMU pages will not have nested SPTEs (they are in
rmaps). So, this looks good, I will add it in the next version.

Thanks
