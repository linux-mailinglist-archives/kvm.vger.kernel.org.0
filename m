Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589BE5F176A
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJAAgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiJAAgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:36:13 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B75D105D7C
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:36:11 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id c17-20020a4aa4d1000000b0047653e7c5f3so3309023oom.1
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEj68H72nQy+Y4KTLxGfHt4WDRX9LokfW93feJ6rDfo=;
        b=XUxZnEbA/wYrU3YOx1d9SFLywhbUERj47YPTJrd3YjyK4ZDrPfSmfx5IgOfpyOqIHe
         TCeR1G9epd+1LS+vGPwitUfGMFiwPLrjt4uphMBVAPZpG0sWjeUQ0g4bZvGIVZkXraYq
         GFtJ4kLaU1QB2tIg/0cpY2W5izPDNrlfkf7ZiotuPs9twmGtudJtiTJh17tUnBS2W+bk
         CY0EXlysxmuN79KDjiPzWbtDE96ItrJdJ3BEt9RsgNWOt2ueLQ43S1AHX3uL1xT6zxDo
         v9+x975D2EKm5lK0qwCTaCSTWxiCNAJGRTKzC33ALEvqxhWfkQa+p0KrRxVRVzT7VOj+
         3M7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YEj68H72nQy+Y4KTLxGfHt4WDRX9LokfW93feJ6rDfo=;
        b=yZ0cQfi4hY6rBFypBaFtH4UxNCxKxvtNigIGGrH5bcpZR6mc4VfbEhJJbC+u/WZTxz
         ak8l4LoHkyktGU1QntnhOFMhEgDv90kKw2an3/4iIJJ1Auf15Vrn/Lf5llFKVMeZ0yu9
         +mIl8N6GyMajnbcOxxqnB48UNhmyNRfSOIjSUwQ888/3tP7hBS6OI4Q06s3ysA2qmkj2
         U2Ac07RD6lass/6bZIiDlOkaVjW5w3N7sYLhflufOI8aHYyn4SpP0gqVFgGvkM6BCOvF
         DI2SqBvq8x8k/mP/MgCXN4yiQg0rrteOLj/AXFjy1gzoaB1cn7cjXn9vL3dmplfxIXq4
         GjQw==
X-Gm-Message-State: ACrzQf3rIgotB2bAOXOuB8gpch90UipXT1PWl2QFWC2kJJOvdrfwuBqp
        cCukBodd2vuoF1gPH54qQCcqG8QtFCjSurqW7mu1Ig==
X-Google-Smtp-Source: AMsMyM4q3loTkNwtXagDTirdBe+OKCAKuEuKypS1PEH5fqf6hsmvhYGTQgeuylGTNA8wq5bsxMFnm+3dYQuQ2cd5Qok=
X-Received: by 2002:a05:6830:2705:b0:659:ebb0:ecad with SMTP id
 j5-20020a056830270500b00659ebb0ecadmr4263191otu.75.1664584570244; Fri, 30 Sep
 2022 17:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com> <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com> <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Sep 2022 17:35:59 -0700
Message-ID: <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
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

On Fri, Sep 30, 2022 at 4:59 PM Dong, Eddie <eddie.dong@intel.com> wrote:
>
> Hi Jim:
>
> > > > KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> > > > actually supports. CPUID.80000006H:EDX[17:16] are reserved bits and
> > > > should be masked off.
> > > >
> > > > Fixes: 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)")
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > ---
> > > >  arch/x86/kvm/cpuid.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
> > > > ea4e213bcbfb..90f9c295825d 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -1125,6 +1125,7 @@ static inline int __do_cpuid_func(struct
> > > > kvm_cpuid_array *array, u32 function)
> > > >               break;
> > > >       case 0x80000006:
> > > >               /* L2 cache and TLB: pass through host info. */
> > > > +             entry->edx &=3D ~GENMASK(17, 16);
> > >
> > > SDM of Intel CPU says the edx is reserved=3D0.  I must miss something=
.
> >
> > This is an AMD defined leaf. Therefore, the APM is authoritative.
>
> In this case, given this is the common place,  if we don't want to do con=
ditionally for different X86 architecture (may be not necessary), can you p=
ut comments to clarify?
> This way, readers won't be confused.

Will a single comment at the top of the function suffice?

>
> >
> > > BTW, for those reserved bits, their meaning is not defined, and the V=
MM
> > should not depend on them IMO.
> > > What is the problem if hypervisor returns none-zero value?
> >
> > The problem arises if/when the bits become defined in the future, and t=
he
> > functionality is not trivially virtualized.
>
> Assume the hardware defines the bit one day in future, if we are using ol=
d VMM, the VMM will view the hardware as if the feature doesn't exist, sinc=
e VMM does not know the feature and view the bit as reserved. This case sho=
uld work.

The VMM should be able to simply pass the results of
KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2, without masking off bits
that it doesn't know about.

Nonetheless, a future VMM that does know about the new hardware
feature can certainly expect that a KVM that enumerates the feature in
KVM_GET_SUPPORTED_CPUID has the ability to support the feature.

> If we run with the future VMM, which recognizes and handles the bit/featu=
re. The VMM could view the hardware feature to be disabled / not existed (i=
f "1" is used to enable or stand for "having the capability"), or view the =
hardware feature as enabled/ existed (if "0" is used to enable or stand for=
 "having the capability").
>
> In this case, whether we have this patch doesn=E2=80=99t give us definite=
 answer. Am I right?

Are you asking about the polarity of the CPUID bit?

It is unfortunate that both Intel and AMD have started to define
reverse polarity CPUID bits, because these do, in fact, cause a
forward compatibility issue. Take, for example, AMD's recent
introduction of CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20]. When
the bit is set, EFER.LMSLE is not available. For quite some time, KVM
has been reporting that this feature *is* available on CPUs where it
isn't, because KVM cleared the CPUID bit based on its previous
'reserved' definition. I have a series out to address that issue:
https://lore.kernel.org/kvm/CALMp9eQ-qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1a=
ykqQ@mail.gmail.com/.

Intel did the same thing with
CPUID.(EAX=3D7H,ECX=3D0):EBX.FDP_EXCPTN_ONLY[bit 6] and
CPUID.(EAX=3D7H,ECX=3D0):EBX.ZERO_FCS_FDS[bit 13].

In the vast majority of cases, however, '0' is the right value to
report for a reserved bit to ensure forward compatibility.
