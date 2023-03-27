Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5B36CA9C1
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjC0QAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjC0QAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:00:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5750C30E0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:00:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m10-20020a17090a4d8a00b0023fa854ec76so4863923pjh.9
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679932807;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mAmapc1h2/zUGtfRb73ywDzpB2MYvKSxif+WSZz20gk=;
        b=jLWDoZbwHwB4mTozuWWzTVJsgQ++DRHbDKBRAmJ2Ye4/tqeZ8WRBqLPqDeOyJB/Vl9
         KmABEnph4x/Xb5iRvoY7agFFgTAAH7xBmcuTD6w8hh3QHWB44qDuI4SdFCEDwJ89zxo5
         jtb+rQGoFdQGL6dgQeWs4DZZPNBGMA2yLWwqw/4dyr08EmBt6XC5exK5kN4AT2DjWBVy
         FSYBfU/JarBoPXimnInHhSy6cdkX90HZXaAm89/TfbKHz8faGM8wveg71HI7B8MZci7c
         NvFu+DzBwbFRRA4griTQMpFO5av6mdAY77pZuJ7bYRWurmpvtc12i/EXtRo6CD02kvF/
         mA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679932807;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mAmapc1h2/zUGtfRb73ywDzpB2MYvKSxif+WSZz20gk=;
        b=NeBHR6h52/z20q+Ap0RcjfuldhKQsW9D1eP2ifHSqqT1PEqgUWEQV8WFCCdPZ6gLap
         17LWMeQIwbsysTJoKBVZScuQnSqZl4WQp4IeY3yoCpylCx0HGuDh64/CkrgEKaxUdjuU
         o0NqbMHEu+fg3voT0IW1XtzmvBIK2wiq6cJ8MLGccv13a6q7ZrC0KkDEuR/9HP/5F81B
         TGuG+3AftLTXpjiqmgcFeWGzgQbA1/DWVEkEG6kuZxJ40CRwl5+PZjP/X0LGr/Ifi6tl
         s7JOFVgP7p6JAGQ9Il2Qj8BsQTaCiggD+SgkL/lIB1ILB/2+NR9XYV6aOyImmFl6sH9k
         hmfg==
X-Gm-Message-State: AAQBX9cfpwiTQRxc3wuJgdEoDssVcpnABk7bKBjVVFyPDfOJs1Dm51wX
        p5VaIvzygoQ691oMksPXgC7NipBbgq0=
X-Google-Smtp-Source: AKy350aK3wtIhiuEt9gpavh2VO+xVZy1A/To5g+BMkE7l/9OE7xspwBeQampekX7o68R3A5B/gBJEZkfQ0g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7892:b0:1a1:f9f7:b752 with SMTP id
 q18-20020a170902789200b001a1f9f7b752mr4074759pll.0.1679932806751; Mon, 27 Mar
 2023 09:00:06 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:00:05 -0700
In-Reply-To: <CALMp9eTEG5o2jQ457BTAL=srPYFbFi2Jx1YLp+a3NW3tQ19wDQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com> <20230322011440.2195485-6-seanjc@google.com>
 <373823f7-00ba-070c-53c7-384d29889e40@intel.com> <CALMp9eTEG5o2jQ457BTAL=srPYFbFi2Jx1YLp+a3NW3tQ19wDQ@mail.gmail.com>
Message-ID: <ZCG9hdSHvM56z/FZ@google.com>
Subject: Re: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough MSR_IA32_FLUSH_CMD
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023, Jim Mattson wrote:
> On Sun, Mar 26, 2023 at 8:33=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com>=
 wrote:
> >
> > On 3/22/2023 9:14 AM, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index c83ec88da043..3c58dbae7b4c 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3628,6 +3628,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> > >
> > >               wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> > >               break;
> > > +     case MSR_IA32_FLUSH_CMD:
> > > +             if (!msr_info->host_initiated &&
> > > +                 !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
> > > +                     return 1;
> > > +
> > > +             if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1=
D_FLUSH))
> > > +                     return 1;
> > > +             if (!data)
> > > +                     break;
> > > +
> > > +             wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> > > +             break;
> >
> > Then KVM provides the ability to flush the L1 data cache of host to
> > userspace. Can it be exploited to degrade the host performance if
> > userspace VMM keeps flushing the L1 data cache?
>=20
> The L1D$ isn't very big. A guest could always flush out any previously
> cached data simply by referencing its own data. Is the ability to
> flush the L1D$ by WRMSR that egregious?

Yeah, AFAIK RDT and the like only provide QoS controls for L3, so L1 is fai=
r game.
