Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE5B7B0BE1
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 20:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjI0SYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 14:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjI0SYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 14:24:18 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7368F
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 11:24:16 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-65b2463d651so24961206d6.3
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 11:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695839056; x=1696443856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWpsRjwmUIn37reupPi+utPeMXSOLSGyvQ+OBrd+Mx8=;
        b=I5oavEoBnIiboxie1Zt6K9sZiTMIvkSwudD4A85sCapnx1Esj3z95PHJ4FhXAe4ujn
         TRIS8EbVAnp79AkGBkU5J0JBFXs+6c9CVRLd+BZZFtEsVX0N7oCDs5pUYHJqxWzg1BcN
         aMRWYo/FSBq1WaDu10Adkm+J92N+031WtengHkYvx4haNQhBjgm4JCT1YDGKSYK5GY6P
         Pm3xTXYebguK1NG/7V6ufn9zKtCC0sw/e2lZnCbWDUiTAULs1T+kxEaHZINxybFE9lDd
         J0IYm5g8X4AckiuLYq8MQIq/P/zvMndBWnrr3He7g/NUjrlDEsgai5XyuPSyyN5MzYIN
         MWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695839056; x=1696443856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWpsRjwmUIn37reupPi+utPeMXSOLSGyvQ+OBrd+Mx8=;
        b=CTQTjEPzl8kZJ5TlWn1dut11NvjuEIdt6aOWsSs7XTTjHQF66HqZzUwrV/l3vcfHKl
         cqaswVu1eKpepRNUullkfq/i77/v/9UtphmirsqRmzZ3Jb0S8VaTzsmb2EjRZ8qujTe8
         XvOvzxfYzgdCeGTy8w44hhRSG8gSj3+ok4aQoslxiCIyIkEclA1LpfjUiwZNhrXzWJfv
         hJzBuSClbFyD1lZe8TPwftV+pzZ+9lwoFE8sBwG66+DsLYUEw1c45CyCw/OwKoM+duO5
         prONaHH4Lu5+wZGbBMESv2wZo61syfBnfmGuxNpNfCxQ0AzLhU4AkU2sIoV20CvqIEWN
         0ZBg==
X-Gm-Message-State: AOJu0YzN1fZqFG7nz9k4QpIQBtzZvddnoLTq58LFbFusdG8HXswKQ/eJ
        bSeb6WyyjKIWEctpetcYKB6vEUB5m+TqWpV9znmpJAZWOWVEjtswNoQ=
X-Google-Smtp-Source: AGHT+IGhWGRmm8dUh/cNFf9vDCIt/TP02tK4GmYi2a3Wv5AszHwFSzVOwvN7DhycV7sCeV+X7NZt8SA7Hj1jotnQqeo=
X-Received: by 2002:a05:6214:b2b:b0:65c:fec5:6f0 with SMTP id
 w11-20020a0562140b2b00b0065cfec506f0mr2355028qvj.45.1695839055820; Wed, 27
 Sep 2023 11:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230927040939.342643-1-mizhang@google.com> <CAL715WJM2hMyMvNYZAcd4cSpDQ6XPFsNhtR2dsi7W=ySfy=CFw@mail.gmail.com>
 <2c79115e-e16d-49cc-8f5b-2363d7910269@zytor.com> <ZRRT8zUfekA1QrQL@google.com>
In-Reply-To: <ZRRT8zUfekA1QrQL@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 27 Sep 2023 11:23:39 -0700
Message-ID: <CAL715WKn1RPiY23x3WAi7BASyLDSZuEO7CJ6FObCxOmRpBwh7Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xin Li <xin@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 9:10=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Sep 26, 2023, Xin Li wrote:
> > On 9/26/2023 9:15 PM, Mingwei Zhang wrote:
> > > ah, typo in the subject: The 2nd KVM_REQ_NMI should be KVM_REQ_PMI.
> > > Sorry about that.
> > >
> > > On Tue, Sep 26, 2023 at 9:09=E2=80=AFPM Mingwei Zhang <mizhang@google=
.com> wrote:
> > > >
> > > > Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ=
_NMI).
> >
> > Please remove it, no need to repeat the subject.
>
> Heh, from Documentation/process/maintainer-kvm-x86.rst:
>
>   Changelog
>   ~~~~~~~~~
>   Most importantly, write changelogs using imperative mood and avoid pron=
ouns.
>
>   See :ref:`describe_changes` for more information, with one amendment: l=
ead with
>   a short blurb on the actual changes, and then follow up with the contex=
t and
>   background.  Note!  This order directly conflicts with the tip tree's p=
referred
>   approach!  Please follow the tip tree's preferred style when sending pa=
tches
>   that primarily target arch/x86 code that is _NOT_ KVM code.
>
> That said, I do prefer that the changelog intro isn't just a copy+paste o=
f the
> shortlog, and the shortlog and changelog should use conversational langua=
ge instead
> of describing the literal code movement.
>
> > > > When vPMU is active use, processing each KVM_REQ_PMI will generate =
a
>
> This is not guaranteed.
>
> > > > KVM_REQ_NMI. Existing control flow after KVM_REQ_PMI finished will =
fail the
> > > > guest enter, jump to kvm_x86_cancel_injection(), and re-enter
> > > > vcpu_enter_guest(), this wasted lot of cycles and increase the over=
head for
> > > > vPMU as well as the virtualization.
>
> As above, use conversational language, the changelog isn't meant to be a =
play-by-play.
>
> E.g.
>
>   KVM: x86: Service NMI requests *after* PMI requests in VM-Enter path
>
>   Move the handling of NMI requests after PMI requests in the VM-Enter pa=
th
>   so that KVM doesn't need to cancel and redo VM-Enter in the likely
>   scenario that the vCPU has configured its LVPTC entry to generate an NM=
I.
>
>   Because APIC emulation "injects" NMIs via KVM_REQ_NMI, handling PMI
>   requests after NMI requests means KVM won't detect the pending NMI requ=
est
>   until the final check for outstanding requests.  Detecting requests at =
the
>   final stage is costly as KVM has already loaded guest state, potentiall=
y
>   queued events for injection, disabled IRQs, dropped SRCU, etc., most of
>   which needs to be unwound.
>
> > Optimization is after correctness, so please explain if this is correct
> > first!
>
> Not first.  Leading with an in-depth description of KVM requests and NMI =
handling
> is not going to help understand *why* this change is being first.  But I =
do agree
> that this should provide an analysis of why it's ok to swap the order, sp=
ecificially
> why it's architecturally ok if KVM drops an NMI due to the swapped orderi=
ng, e.g.
> if the PMI is coincident with two other NMIs (or one other NMI and NMIs a=
re blocked).
>
> > > > So move the code snippet of kvm_check_request(KVM_REQ_NMI) to make =
KVM
> > > > runloop more efficient with vPMU.
> > > >
> > > > To evaluate the effectiveness of this change, we launch a 8-vcpu QE=
MU VM on
>
> Avoid pronouns.  There's no need for all the "fluff", just state the setu=
p, the
> test, and the results.
>
> Really getting into the nits, but the whole "8-vcpu QEMU VM" versus
> "the setup of using single core, single thread" is confusing IMO.  If the=
re were
> potential performance downsides and/or tradeoffs, then getting the gory d=
etails
> might be necessary, but that's not the case here, and if it were really n=
ecessary
> to drill down that deep, then I would want to better quantify the impact,=
 e.g. in
> terms latency.
>
>   E.g. on Intel SPR running SPEC2017 benchmark and Intel vtune in the gue=
st,
>   handling PMI requests before NMI requests reduces the number of cancele=
d
>   runs by ~1500 per second, per vCPU (counted by probing calls to
>   vmx_cancel_injection()).
>
> > > > an Intel SPR CPU. In the VM, we run perf with all 48 events Intel v=
tune
> > > > uses. In addition, we use SPEC2017 benchmark programs as the worklo=
ad with
> > > > the setup of using single core, single thread.
> > > >
> > > > At the host level, we probe the invocations to vmx_cancel_injection=
() with
> > > > the following command:
> > > >
> > > >      $ perf probe -a vmx_cancel_injection
> > > >      $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10=
 seconds
> > > >
> > > > The following is the result that we collected at beginning of the s=
pec2017
> > > > benchmark run (so mostly for 500.perlbench_r in spec2017). Kindly f=
orgive
> > > > the incompleteness.
> > > >
> > > > On kernel without the change:
> > > >      10.010018010              14254      probe:vmx_cancel_injectio=
n
> > > >      20.037646388              15207      probe:vmx_cancel_injectio=
n
> > > >      30.078739816              15261      probe:vmx_cancel_injectio=
n
> > > >      40.114033258              15085      probe:vmx_cancel_injectio=
n
> > > >      50.149297460              15112      probe:vmx_cancel_injectio=
n
> > > >      60.185103088              15104      probe:vmx_cancel_injectio=
n
> > > >
> > > > On kernel with the change:
> > > >      10.003595390                 40      probe:vmx_cancel_injectio=
n
> > > >      20.017855682                 31      probe:vmx_cancel_injectio=
n
> > > >      30.028355883                 34      probe:vmx_cancel_injectio=
n
> > > >      40.038686298                 31      probe:vmx_cancel_injectio=
n
> > > >      50.048795162                 20      probe:vmx_cancel_injectio=
n
> > > >      60.069057747                 19      probe:vmx_cancel_injectio=
n
> > > >
> > > >  From the above, it is clear that we save 1500 invocations per vcpu=
 per
> > > > second to vmx_cancel_injection() for workloads like perlbench.
>
> Nit, this really should have:
>
>   Suggested-by: Sean Christopherson <seanjc@google.com>
>
> I personally don't care about the attribution, but (a) others often do ca=
re and
> (b) the added context is helpful.  E.g. for bad/questionable suggestsions=
/ideas,
> knowing that person X was also involved helps direct and/or curate questi=
ons/comments
> accordingly.

For sure! I will also pay more attention to that in the future.

Thanks.
-Mingwei
