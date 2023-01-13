Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7F66885F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 01:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjAMA0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 19:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjAMA0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 19:26:06 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2712AC1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 16:26:01 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4c24993965eso257161357b3.12
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 16:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sF+Ifg4o7iFzS+LPlBmQjTys8EpS+9ESttiEgJFGACU=;
        b=fCKxksn44CJkdiB1PH5pxEZAu6AcP2A/lM/D/czASmGMx0qAyeVpzssa6+FhbpHFtj
         glp8/wKR6hMedZ8j8DsCiBaYRDxCsDd2ZBOyFkf1w/I0JvZbR270JI2KcjsT55SfCc5p
         RJLQhxkm2LyKZXpeg67M0/0uk0qx0Qc7HiRQaekRaYDMpqyJKKxGWOMqwpOfGbQXxlUl
         Q5SfBGFB3peVbSjia+6NQlLu4T9dIajvYLOESWH1zYz88rmsQRipIydKX2PRGGbcfbsL
         KX8hOTspCa7WejAraBYWu4Z1WAcVudTz8k/8nCT1BKFrLE0bbH62yjrAutPuwyaWOhHY
         B4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sF+Ifg4o7iFzS+LPlBmQjTys8EpS+9ESttiEgJFGACU=;
        b=E2czj76eP6wI0QyJJ9sSY/sYzBVGlibIXbkjBBmeT+tAPqwC3v8eWyNqeg33PK7U+l
         JRPN5S48+N/0xqsHEA2Nyz+zPbGltKUpTpEc6stJnpFsnkitL5eQrHHf+2joFNotqsfB
         cBELiXquxGBaWk30FlINPuN8f1RxQ/A4dPDt1zZrP/3eHg2P+BGYql8GZ/eG1BK4h9+Z
         0qYt2fzpXiUsZh+i4f/06+Lx1xEJaO6l4kE0sFw0j6EhKeSL90G1TKnvI7D8C2bHX5Hr
         +yyXO7RPdmFJVstI9y9rRoul6VNwilvWWfzvi/xt9vatvaaUsDZrg4bVKPQtWIU8TUO0
         0HUw==
X-Gm-Message-State: AFqh2kpr7/CW5SnkUFeVUkAK5xwIXDkaHRzuPdBiojGfEgB4CDhIBYQB
        lE4MTNrPtHBUpVHp6ZT0N6J2gpuwJfxofSeZEn3sfw==
X-Google-Smtp-Source: AMrXdXv4hI0nKL1ELl6lavzfPrvUORSRLkkrSP7WMMjeDcrilJExszKSJwDZB5dWXlHHELtJq9FSNlD6djOBACdVWBw=
X-Received: by 2002:a81:1352:0:b0:4dc:4113:f224 with SMTP id
 79-20020a811352000000b004dc4113f224mr316741ywt.455.1673569560616; Thu, 12 Jan
 2023 16:26:00 -0800 (PST)
MIME-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com> <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com> <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com> <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com> <Y8B5xIVChfatMio0@google.com>
 <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com>
In-Reply-To: <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 12 Jan 2023 16:25:49 -0800
Message-ID: <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jan 12, 2023 at 1:33 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 1/12/2023 1:21 PM, Mingwei Zhang wrote:
> >
> > The only comment I would have is that it seems not following the least
> > privilege principle as host process (QEMU) may not have the motivation
> > to do any matrix multiplication. But this is a minor one.
> >
> > Since this enabling once per-process, I am wondering when after
> > invocation of arch_prctl(2), all of the host threads will have a larger
> > fp_state? If so, that might be a sizeable overhead since host userspace
> > may have lots of threads doing various of other things, i.e., they may
> > not be vCPU threads.
>
> No, the permission request does not immediately result in the kernel's
> XSAVE buffer expansion, but only when the state is about used. As
> XFD-armed, the state use will raise #NM. Then, it will reallocate the
> task's fpstate via this call chain:
>
> #NM --> handle_xfd_event() --> xfd_enable_feature() --> fpstate_realloc()
>
> Thanks,
> Chang

Thanks for the info. But I think you are talking about host level AMX
enabling. This is known to me. I am asking about how AMX was enabled
by QEMU and used by vCPU threads in the guest. After digging a little
bit, I think I understand it now.

So, it should be the following: (in fact, the guest fp_state is not
allocated lazily but at the very beginning at KVM_SET_CPUID2 time).

  kvm_set_cpuid() / kvm_set_cpuid2() ->
    kvm_check_cpuid() ->
      fpu_enable_guest_xfd_features() ->
        __xfd_enable_feature() ->
          fpstate_realloc()

Note that KVM does intercept #NM for the guest, but only for the
handling of XFD_ERR.

Prior to the kvm_set_cpuid() or kvm_set_cpuid2() call, the QEMU thread
should ask for permission via arch_prctl(REQ_XCOMP_GUEST_PERM) in
order to become a vCPU thread. Otherwise, the above call sequence will
fail. Fortunately, asking-for-guest-permission is only needed once per
process (per-VM).

Because of the above, the non-vCPU threads do not need to create a
larger fp_state unless/until they invoke kvm_set_cpuid() or
kvm_set_cpuid2().

Now, I think that closes the loop for me.

Thanks.

-Mingwei
