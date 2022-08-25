Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A2B5A1D0B
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiHYXV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243863AbiHYXV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:21:26 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16269AFEE
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:21:24 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id r10so76813oie.1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9B7NG9IIEguT1hVUVREa1K+l0UW23cFMYp7Xko7sDvU=;
        b=rnvllA09PhkWF1rz5Q9dDBciTpGrAEnMbJrKWffx6D/OzoYXjQKuIkdHBy6kKRGEl4
         41FBDuwySDKBW/fxuOcA0PBpr8zJYIjpx7Fk3y5iPlB9OcluBHKfHJOA38EBdxl5G1c5
         j99jEs5p7zjoNgvQ68imC646OuQbsLp1Pv7AP1oSDHcK/CiOH8m6eAXXU6G5/HTarMGP
         lhNNr4ZhKAZgSkfgyCrIPGeyW7EWq2sJxAJpGRrSn0O3hFXCxU0QBiaMLT3wcvgIv35C
         c9Xb0MEm7Ok9BSVS8lAyBLw0pAxCJpRyYClkI4PHpuGSLoR9tLAvs3vsu3mJyfhbggL5
         ybEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9B7NG9IIEguT1hVUVREa1K+l0UW23cFMYp7Xko7sDvU=;
        b=WJMHJ+gT5E/P11SVKou0ln3ZzjkfIcDXpb8sKWhSj/ItDoiX8mvRsc538r2GzTpUAR
         4L7m/LCFUmXiWEAn48o53sa5JSimNLly3A/mgnuky3JHsjr1Y3Bb7eFaeT3ljG6ijiGh
         46N58LcyX9yV2TWnyZaFBo4npyVHifnkvM3qhHh8AvhVdxiw0cilCvFW4yjLg4iPa+c4
         B5TaIS2SdVL8bg8C8Ai7C8r/fDBf9kRDGW29mkLpfh1ySvn4r2OMBm0qByLXaPx1MLnl
         odOSF0jz2hTo/rWB0CvmfPTVbCpoeTAzxTfeHlqdmOcQYjE4fpuGW3CxqYgeabzHuBKH
         Etvw==
X-Gm-Message-State: ACgBeo0GO83gXjN8x8NmyDvShZAlqXKGGtpZHOBC2KHRfX81RCbAyVal
        kGalWTGUrGeqXpur14XTjds6JPdoM86sEtPrLof/sA==
X-Google-Smtp-Source: AA6agR66fIxXXQzBHyC+k8cHMYcfmCpqYIaEJ39eYcZJeWOISR7vPlfote5qBPf1xIwi/2K44MuvF1oNKD9XhDzoRhI=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr559807oiw.112.1661469684086; Thu, 25
 Aug 2022 16:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com> <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com> <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
 <Ywa+QL/kDp9ibkbC@google.com> <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
 <YweJ+hX8Ayz11jZi@google.com> <CAL715WK4eqxX9EUHzwqT4o-OX4S_1-WcTr5UuGnc-KEb7pk6EQ@mail.gmail.com>
 <Ywe3IC7OlF/jYU1X@google.com> <CAL715WJEkT6heVT1P2RZw_5NxBcORCrBTS60L_RZT-05zr_zsw@mail.gmail.com>
In-Reply-To: <CAL715WJEkT6heVT1P2RZw_5NxBcORCrBTS60L_RZT-05zr_zsw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 25 Aug 2022 16:21:13 -0700
Message-ID: <CALMp9eR22CHU9pkN-WCpVktCQiBKh80=qZSaO_AzLJujNGbi+Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending interrupts
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
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

On Thu, Aug 25, 2022 at 1:35 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> > There are two uses of KVM_REQ_GET_NESTED_STATE_PAGES:
> >
> >   1. Defer loads when leaving SMM.
> >
> >   2: Defer loads for KVM_SET_NESTED_STATE.
> >
> > #1 is fully solvable without a request, e.g. split ->leave_smm() into two helpers,
> > one that restores whatever metadata is needed before restoring from SMRAM, and
> > a second to load guest virtualization state that _after_ restoring all other guest
> > state from SMRAM.
> >
> > #2 is done because of the reasons Jim listed above, which are specific to demand
> > paging (including userfaultfd).  There might be some interactions with other
> > ioctls() (KVM_SET_SREGS?) that are papered over by the request, but that can be
> > solved without a full request since only the first KVM_RUN after KVM_SET_NESTED_STATE
> > needs to refresh things (though ideally we'd avoid that).
>
> Ack on the fact that the 2-step process is specific to demand paging.
>
> Currently, KVM_SET_NESTED_STATE is a two-step process in which the 1st
> step does not require vmcs12 to be ready. So, I am thinking about what
> it means to deprecate KVM_REQ_GET_NESTED_STATE_PAGES?
>
> For case #2, I think there might be two options if we deprecate it:
>
>  - Ensuring vmcs12 ready during the call to
> ioctl(KVM_SET_NESTED_STATE). This requires, as Jim mentioned, that the
> thread who is listening to the remote page request ready to serve
> before this call (this is true regardless of uffd based or Google base
> demand paging). We definitely can solve this ordering problem, but
> that is beyond KVM scope. It basically requires our userspace to
> cooperate.

The vmcs12 isn't the problem, since its contents were loaded into L0
kernel memory at VMPTRLD. The problem is the structures hanging off of
the vmcs12, like the posted interrupt descriptor. The new constraints
need to be documented, and every user space VMM has to follow them
before we can eliminate KVM_REQ_GET_NESTED_STATE_PAGES.

>  - Ensuring vmcs12 ready before vmenter. This basically defers the
> vmcs12 checks to the last second. I think this might be a better one.
> However, isn't it the same as the original implementation, i.e.,
> instead of using KVM_REQ_GET_NESTED_STATE_PAGES, we have to use some
> other flags to tell KVM to load a vmcs12?

Again, the vmcs12 is not a problem, since its contents are already
cached in L0 kernel memory. Accesses to the structures hanging off of
the vmcs12 are already handled *during KVM_RUN* by existing demand
paging mechanisms.

> Thanks.
> -Mingwei
> >
> > In other words, if the demand paging use case goes away, then KVM can get rid of
> > KVM_REQ_GET_NESTED_STATE_PAGES.
> >
> > > KVM_SET_NESTED_STATE in VMX, while in SVM implementation, it is simply
> > > just a kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> >
> > svm_set_nested_state() very rougly open codes enter_svm_guest_mode().  VMX could
> > do the same, but that may or may not be a net positive.
> >
> > > hmm... so is the nested_vmx_enter_non_root_mode() call in vmx
> > > KVM_SET_NESTED_STATE ioctl() still necessary? I am thinking that
> > > because the same function is called again in nested_vmx_run().
> >
> > nested_vmx_run() is used only to emulate VMLAUNCH/VMRESUME and wont' be invoked
> > if the vCPU is already running L2 at the time of migration.
>
> Ack.
