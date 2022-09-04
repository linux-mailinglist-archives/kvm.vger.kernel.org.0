Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9A5AC22A
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 05:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiIDDzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 23:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiIDDzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 23:55:18 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A3220EA
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 20:55:17 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-11f11d932a8so14528642fac.3
        for <kvm@vger.kernel.org>; Sat, 03 Sep 2022 20:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fSeaghmzLkeAaPv9VENyUcy/Zxo9VrVvOErKCJv6U5o=;
        b=mQ4i3livPfHmUFHRri/hWRtAoHMRA6LQkD6yC9cdAln4psFUf4alvy2TIJ+WnMhngq
         q/CWr/zhAG/K/m3lgsv6CqP7g//mradyacpoRQEvJGitqTOrRx+tAjFNEQt8ED6ySzsY
         DWy4jR4yioSRLY0sjB9yLx5nDnul8RichNVzmoByKfIgyOYylyscdjYJeM+p98sGinMA
         +ajmaeAeb3aTNLjC0w2gUErlxcYPRmA7ljY8nN3X3HQIQbxAS3dCwjCe0gUDbpyqAGmg
         ZDzUadkaUQIdUSq+hWaOd6t+9eCi3QtLuAuitiV1X3ardCJA3D0SNC/TApMwdJY/p3V/
         WZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fSeaghmzLkeAaPv9VENyUcy/Zxo9VrVvOErKCJv6U5o=;
        b=MUoTaaXOL9NZrWG+CMmh5ieFqjzwQ1i5xPBcdPk+xYpPHbYAEyC+yl8VPkivKzby5H
         IKkqSOX36p6enGOXVqu8D7TON3+768M9KArtpTqvQUMmLDlvXR3qpII72ZBbql+EXb3c
         bqiRIKMBzwPG6ud46F4IVYHM8TinudHlw7NJE4em2e86PzhGyIQMbq2zXAZtyr1onDoH
         b48a2hPlqF/CSpWRPQrd2lQQ/v9Rw70NaJWKTfvIc9TI2jpl4GGwqp0I6H/B1wyoUYk6
         BlYKZbdddSf1e3cTt8uyKCX3OBabdyJ/IF2ahUvHZManr3+xq4QXCrnKCMPZczLSvAKG
         K5jw==
X-Gm-Message-State: ACgBeo0MS02oojogn0gmSVQW1tDQf2sB03vwZQ/NOmmG21gPXJq96NR9
        MWuGjsrlL1Nyz3CzrY7usDy90V/D8NyIBkEzff/arQLyEJ4j5g==
X-Google-Smtp-Source: AA6agR69kcPAeiavFxtpfagxlGYNGpm17hq61sWw1ItA9kOPplNxGfhtYE4Y6+dDRGodIRhb/T8WMwLCwXcu70vptcY=
X-Received: by 2002:a05:6870:41d0:b0:126:5d06:28a5 with SMTP id
 z16-20020a05687041d000b001265d0628a5mr1867608oac.181.1662263715163; Sat, 03
 Sep 2022 20:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble> <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
In-Reply-To: <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 3 Sep 2022 20:55:04 -0700
Message-ID: <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
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

On Sat, Sep 3, 2022 at 8:30 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> > [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
> >     window of opportunity where the SMT sibling can help force a
> >     retbleed attack on a RET between the MSR write and the vmrun.  But
> >     that's really unrealistic IMO.
>
> That was my concern. How big does that window have to be before a
> cross-thread attack becomes realistic, and how do we ensure that the
> window never gets that large?

Per https://developer.amd.com/wp-content/resources/111006-B_AMD64TechnologyIndirectBranchControlExtenstion_WP_7-18Update_FNL.pdf:

When this bit is set in processors that share branch prediction
information, indirect branch predictions from sibling threads cannot
influence the predictions of other sibling threads.

It does not say that upon clearing IA32_SPEC_CTRL.STIBP, that only
*future* branch prediction information will be shared.

If all existing branch prediction information is shared when
IA32_SPEC_CTRL.STIBP is clear, then there is no window.
