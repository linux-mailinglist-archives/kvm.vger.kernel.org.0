Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590C64F6F36
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiDGAeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiDGAeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:34:12 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A25C3348
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:32:14 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x33so481225lfu.1
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=riJKAE7xRLmvs2ID+ha5y5ZOFJDzvSy2J3viYV2w+mc=;
        b=q3d1cFnaYkQWAl5xZlUEcFNpvcRNtJ4NEA+fbE2BUQ26uM5N8/qq6GOqiy05lJXyNw
         4cZk+w5i/glUbhnPtqTRSEsdwDKs3B2q49kEbHstFJY6a5FTAvyR0a9sln5JCPHhoSMP
         HIydGSf35g3q22OUzg7Kg6bqc04Cv0BnN0BO9+cbw8bxgjb2zSJv/Af2yKisqmSndlAg
         5eEdO3bR4HWCMpMtYIccWvIE1u69fRi/jzGiCiG5fwXitYXMLjfSOUFP281uE4f9Vxhz
         pqSZZcORG7HrmEvavccT1ypqwGOgAvIXfzhtpDjF7OynfYH6HE9x8PZlX2x8A+xh1SRf
         T2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=riJKAE7xRLmvs2ID+ha5y5ZOFJDzvSy2J3viYV2w+mc=;
        b=rTBaWXDd588ZWj2T64GklmIcd/Vz1D6GZYNfjCAdzf2cBxsp6V1ZgsbK/BNKaCnX/E
         26Xl1HpfUtIt8rmPx46SvjcBEHTdJE/KijpG0FvUdcjGp8afRZkCnQaFBCYn/pquP85g
         0RPLJd79Y5IS67F7ASIvsqx4GZId6GdF9YXUtwZeB6RYrkIvGpi+bAr7kVGRXWcq4Jw2
         9Wg67qpuNq1mvwsSnH6CSYJC+3jUOhc4y09ZaZL8OcIzIYPtokTtoRVnLy+Cyk/n5g2a
         AkWKAR1s5AQ28lgg0QqJ+1+Db0bnY7h4kdeVBUZc6OygRqSOJL5S3U7IDjHugXZnUT9+
         9Pjg==
X-Gm-Message-State: AOAM531jXasKVVGClwrOWFEiatvqLbJlNsBYe3BHsM2CT/eGY8SpYEcZ
        pVLd2KJ1z5pHYTYnQIaK0MfeevmrxB7qe2PgtjFzeA==
X-Google-Smtp-Source: ABdhPJwAM8Lu+6GLNp3C1L56HJ0FMQzsMqhZl9udY3/NJBoRCCcMga3mhl50Co9/mGpBS6JAtxOBXFJr7T4SdX39PyM=
X-Received: by 2002:ac2:510f:0:b0:44a:5ccc:99fb with SMTP id
 q15-20020ac2510f000000b0044a5ccc99fbmr7432556lfb.38.1649291532487; Wed, 06
 Apr 2022 17:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com> <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com> <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com> <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com> <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
 <Yk4vqJ1nT+JxEpKo@google.com> <CAOQ_Qsj6KwV_OjDS-JwOkPs76Z9FiCBVBTGgp-_hZHQ6BAeExg@mail.gmail.com>
In-Reply-To: <CAOQ_Qsj6KwV_OjDS-JwOkPs76Z9FiCBVBTGgp-_hZHQ6BAeExg@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 6 Apr 2022 17:32:01 -0700
Message-ID: <CAOQ_QsiUtbRYgX5g14wzNzFGNgBeK0uF9ve3GQ1PwBm3bKb+gg@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
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

On Wed, Apr 6, 2022 at 5:29 PM Oliver Upton <oupton@google.com> wrote:
>
> Hey Sean,
>
> On Wed, Apr 6, 2022 at 5:26 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > > On 3/4/22 00:44, Sean Christopherson wrote:
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > > > index c92cea0b8ccc..46dd1967ec08 100644
> > > > --- a/arch/x86/kvm/vmx/nested.h
> > > > +++ b/arch/x86/kvm/vmx/nested.h
> > > > @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
> > > >  }
> > > >
> > > >  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> > > > -#define nested_guest_cr4_valid nested_cr4_valid
> > > > -#define nested_host_cr4_valid  nested_cr4_valid
> > > > +#define nested_guest_cr4_valid kvm_is_valid_cr4
> > > > +#define nested_host_cr4_valid  kvm_is_valid_cr4
> > >
> > > This doesn't allow the theoretically possible case of L0 setting some
> > > CR4-fixed-0 bits for L1.  I'll send another one.
> >
> > Are you still planning on sending a proper patch for this?
> >
> > And more importantly, have we shifted your view on this patch/series?
>
> Sorry, I should've followed up. If nobody else complains, let's just
> leave everything as-is and avoid repeating the mistakes of the patches
> to blame (hey, I authored one of those!)

Well, that is to say we do nothing to plug the half-baked behavior of
changing MSRs based on CPUID. Quirk the rest of it away if we don't
want to fudge with these bits any more :)

--
Thanks,
Oliver
