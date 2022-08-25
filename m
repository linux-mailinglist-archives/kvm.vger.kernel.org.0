Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D2B5A17D0
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbiHYRQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiHYRQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:16:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69478A50C7
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:16:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o4so1004726pjp.4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kXvA442rNX297fyG/Fyw0vfNRXroRxF/pdkw6Qxv8UE=;
        b=ToZvmVtN0p6cjcXv9Y3Nir8/tTLpU8oAKTTXY8BnakyanfxEZ8x3PRjpKKZqm8fS0y
         NXX5W+9ZWMqepi4v8sFZIiHT9mASAYrThJl/YCihJTrc9FUpoV9/zyiUdsxJYZXcrAfy
         BKSDQ6WrDpfiWoUynYxmgSOp7dQjmRKQNjhawEk6bnFddnrwziL7gNIKWBuhFqojnKYu
         +gOh3T9opmBkHTzdTxjwLaxAkhhGY7WdH61OmSe/Ku59drVzSysnTes4IuJS+gbLo9uy
         lnYYvDBrQMmoFtb9PwWTE2MCvHaKWctNNlKrmlIBkl03TgohWXCiUy/fY3w3a4gWQEZE
         gOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kXvA442rNX297fyG/Fyw0vfNRXroRxF/pdkw6Qxv8UE=;
        b=LIah3ncugWFLtcEYec/Do0nALy1CzD3p6Z6L4+rRq9hJClgFknhzlcsqsZWj1M7EH+
         DH+KDaQqGk4K3nktMHoVRvrQc+1j2wIuxmay2vcA6tO0JEF6Vq6q+a/3CPUaxbgWCo//
         wn5VtIqL3iQ49E6uphGrxItg28OcLBWbZGt7fkR5GGU1xDHezhUCZVSUbcLfvpshGsT/
         IUVVttZ/rw91q1sw3c5ilc9M1XHDyWFeX3c8B40/HavKWO4R/ZaoOhj7DcLN3hincJ7T
         w1gNYHVvwW1/1h/kr/++2WU2eMO70wrV3hawdXGXSrPee+CAzUZ6AFuHoYvr4keiHjMK
         bpSA==
X-Gm-Message-State: ACgBeo1tjTBsRiqi64BgXHHyyp7C613B8XoMYb7dmBmC7lhS3BBk1lAu
        yrX/GKDVojpxascqXjePUT7GLia/bJXcOW+sTn3LKw==
X-Google-Smtp-Source: AA6agR4hn6gmJhbjSFERXxwBvcmYC7EtXXgsXsbXOIEW4+3tSmkY0a52Bm/w8MGxU4KSXuqD1WeNS4O+76Pdhwpxxxs=
X-Received: by 2002:a17:903:41d1:b0:172:ee09:e89e with SMTP id
 u17-20020a17090341d100b00172ee09e89emr3200ple.61.1661447798596; Thu, 25 Aug
 2022 10:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com> <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com> <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
 <Ywa+QL/kDp9ibkbC@google.com> <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
 <YweJ+hX8Ayz11jZi@google.com>
In-Reply-To: <YweJ+hX8Ayz11jZi@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 25 Aug 2022 10:16:27 -0700
Message-ID: <CAL715WK4eqxX9EUHzwqT4o-OX4S_1-WcTr5UuGnc-KEb7pk6EQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending interrupts
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 7:41 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 24, 2022, Jim Mattson wrote:
> > On Wed, Aug 24, 2022 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > > @google folks, what would it take for us to mark KVM_REQ_GET_NESTED_STATE_PAGES
> > > as deprecated in upstream and stop accepting patches/fixes?  IIUC, when we eventually
> > > move to userfaultfd, all this goes away, i.e. we do want to ditch this at some point.
> >
> > Userfaultfd is a red herring. There were two reasons that we needed
> > this when nested live migration was implemented:
> > 1) our netlink socket mechanism for funneling remote page requests to
> > a userspace listener was broken.
> > 2) we were not necessarily prepared to deal with remote page requests
> > during VM setup.
> >
> > (1) has long since been fixed. Though our preference is to exit from
> > KVM_RUN and get the vCPU thread to request the remote page itself, we
> > are now capable of queuing a remote page request with a separate
> > listener thread and blocking in the kernel until the page is received.
> > I believe that mechanism is functionally equivalent to userfaultfd,
> > though not as elegant.
> > I don't know about (2). I'm not sure when the listener thread is set
> > up, relative to all of the other setup steps. Eliminating
> > KVM_REQ_GET_NESTED_STATE_PAGES means that userspace must be prepared
> > to fetch a remote page by the first call to KVM_SET_NESTED_STATE. The
> > same is true when using userfaultfd.
> >
> > These new ordering constraints represent a UAPI breakage, but we don't
> > seem to be as concerned about that as we once were. Maybe that's a
> > good thing. Can we get rid of all of the superseded ioctls, like
> > KVM_SET_CPUID, while we're at it?
>
> I view KVM_REQ_GET_NESTED_STATE_PAGES as a special case.  We are likely the only
> users, we can (eventually) wean ourselves off the feature, and we can carry
> internal patches (which we are obviously already carrying) until we transition
> away.  And unlike KVM_SET_CPUID and other ancient ioctls() that are largely
> forgotten, this feature is likely to be a maintenance burden as long as it exists.

KVM_REQ_GET_NESTED_STATE_PAGES has been uniformly used in
KVM_SET_NESTED_STATE ioctl in VMX (including eVMCS) and SVM, it is
basically a two-step setting up of a nested state mechanism.

We can change that, but this may have side effects and I think this
usage case has nothing to do with demand paging.

I noticed that nested_vmx_enter_non_root_mode() is called in
KVM_SET_NESTED_STATE in VMX, while in SVM implementation, it is simply
just a kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);

hmm... so is the nested_vmx_enter_non_root_mode() call in vmx
KVM_SET_NESTED_STATE ioctl() still necessary? I am thinking that
because the same function is called again in nested_vmx_run().

Thanks.
-Mingwei
