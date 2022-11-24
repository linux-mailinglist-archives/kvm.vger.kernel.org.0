Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19ABC6374B3
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiKXJEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiKXJED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:04:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2D10EA2D
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:04:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso3419063wme.5
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eSHkE7V37eRRB+OmAQ0+m49WziMhPUEY6R34db9KS7g=;
        b=LYeXwgcLWttOK+PTUktaFMrFBa3suPjmv61D7Mt4V1wBx0WHj3M/BrOrlmmMnwoUhY
         0y6yMjEdu60ceVb/+E9euPcn9cedsz6AUGhQorRP1Zq4qu+/fcYlxFbof6M/Mn1r7ix6
         BwAvWjBPdbl1qF9nWLbFL64A6A13E3MKWeQYlI+Gme5RYfMaWff/r/8Yjq5u4pe6r7QH
         D6lWtvxoRcDOO1ce2l8S864c7nUBs/khNMND/HMDUXQeFj84WzY2KFxI9tDR2WByaTk+
         Z7Yd64/GTmLkJHheav3I1dPQ+o2i4yTvWE/EvnhflODTshEWOij4ANS5FAlpA1UXKPQU
         BqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eSHkE7V37eRRB+OmAQ0+m49WziMhPUEY6R34db9KS7g=;
        b=crzzw2qYbnGVmNsgdJf+5Z4Cm3Gv6X/JEYUNT7YL5sUg8rXRXFlPWQv25RwKR/8ZXh
         aAHow+FcALm7aeWe783n9AQ3F5GZnAC7ZzMA4Qr42mb2HgWt55kUOeeKwlnjknvYeThx
         P1OBw7WRsDoRsNPF67I+n5rJkrpvsyhIWqd4q4oMc96T2lsOv1kbPkA51c8tnvXjSBVl
         0K2o2/ep7cfNLfAyj0pQ0xRxSWzmxH65bRJuPBLkJfk8Owtha7bYZ+VD9ex++GVLycSY
         DGjMA0dtxJmkzQVU+jIVP47IPenjHx1VtcrqEp6X3F0TGz1ymmkES7ZEZVOlUE5QMZwS
         CelA==
X-Gm-Message-State: ANoB5pmBS6U38aKjSilCEIif0l69vaxjOzkUSpoQ4YnuK6fMLwzmwDUS
        AGKQXQGXu5sXh2/ztaBXX0ZlJ/7VcLbU7SKQuO9Jmw==
X-Google-Smtp-Source: AA0mqf6x/ExsicSzIsXDel57lNri4Nr6Rn5qOOTdUHWDHAIoH+gIEH9T7LCfz9Epl6npOtEKL/DyWoeDA2/2pjnVpVk=
X-Received: by 2002:a05:600c:2108:b0:3cf:aae0:802a with SMTP id
 u8-20020a05600c210800b003cfaae0802amr13202014wml.112.1669280640770; Thu, 24
 Nov 2022 01:04:00 -0800 (PST)
MIME-Version: 1.0
References: <20221121234026.3037083-1-vipinsh@google.com> <20221121234026.3037083-3-vipinsh@google.com>
 <87bkozosvh.fsf@ovpn-194-185.brq.redhat.com> <CAHVum0eW4WMHe1vNsWn-2xbMxgckFwu_pOQR7hs0NbFj3sM8Tg@mail.gmail.com>
 <87wn7koik7.fsf@ovpn-192-146.brq.redhat.com>
In-Reply-To: <87wn7koik7.fsf@ovpn-192-146.brq.redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 24 Nov 2022 01:03:24 -0800
Message-ID: <CAHVum0fZZwsCEL-bMM2phfiukSF0_M_-DiTEhYg562FYSnf6_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86: hyper-v: Add extended hypercall support
 in Hyper-v
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
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

On Thu, Nov 24, 2022 at 12:36 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vipin Sharma <vipinsh@google.com> writes:
>
> > On Tue, Nov 22, 2022 at 8:29 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Vipin Sharma <vipinsh@google.com> writes:
> >>
> >> > +/*
> >> > + * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
> >> > + * after the base capabilities extended hypercall.
> >> > + */
> >> > +#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
> >> > +
> >>
> >> First, I thought there's an off-by-one here (and should be '63') but
> >> then I checked with TLFS and figured out that the limit comes from
> >> HvExtCallQueryCapabilities's response which doesn't include itself
> >> (0x8001) in the mask, this means it can encode
> >>
> >> 0x8002 == bit0
> >> 0x8003 == bit1
> >> ..
> >> 0x8041 == bit63
> >>
> >> so indeed, the last one supported is 0x8041 == 0x8001 + 64
> >>
> >> maybe it's worth extending the commont on where '64' comes from.
> >>
> >
> > Yeah, I will expand comments.
> >
> >> >  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
> >> >                               bool vcpu_kick);
> >> >
> >> > @@ -2411,6 +2417,9 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
> >> >       case HVCALL_SEND_IPI:
> >> >               return hv_vcpu->cpuid_cache.enlightenments_eax &
> >> >                       HV_X64_CLUSTER_IPI_RECOMMENDED;
> >> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> >> > +             return hv_vcpu->cpuid_cache.features_ebx &
> >> > +                             HV_ENABLE_EXTENDED_HYPERCALLS;
> >> >       default:
> >> >               break;
> >> >       }
> >> > @@ -2564,6 +2573,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >> >               }
> >> >               goto hypercall_userspace_exit;
> >> >       }
> >> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> >> > +             if (unlikely(hc.fast)) {
> >> > +                     ret = HV_STATUS_INVALID_PARAMETER;
> >>
> >> I wasn't able to find any statement in TLFS stating whether extended
> >> hypercalls can be 'fast', I can imagine e.g. MemoryHeatHintAsync using
> >> it. Unfortunatelly, our userspace exit will have to be modified to
> >> handle such stuff. This can stay for the time being I guess..
> >>
> >
> > I agree TLFS doesn't state anything about "fast" extended hypercall
> > but nothing stops in future for some call to be "fast". I think this
> > condition should also be handled by userspace as it is handling
> > everything else.
> >
> > I will remove it in the next version of the patch. I don't see any
> > value in verification here.
>
> The problem is that we don't currently pass 'fast' flag to userspace,
> let alone XMM registers. This means that it won't be able to handle fast
> hypercalls anyway, I guess it's better to keep your check but add a
> comment saying that it's an implementation shortcoming and not a TLFS
> requirement.
>

I think "fast" flag gets passed to the userspace via:
  vcpu->run->hyperv.u.hcall.input = hc.param;

Yeah, XMM registers won't be passed, that will require userspace API change.
I will keep the check and explain in the comments.

>
> >
> >> > +                     break;
> >> > +             }
> >> > +             goto hypercall_userspace_exit;
> >> >       default:
> >> >               ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> >> >               break;
> >> > @@ -2722,6 +2737,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> >> >
> >> >                       ent->ebx |= HV_POST_MESSAGES;
> >> >                       ent->ebx |= HV_SIGNAL_EVENTS;
> >> > +                     ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
> >> >
> >> >                       ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> >> >                       ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
> >>
> >> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >>
> >> --
> >> Vitaly
> >>
> >
>
> --
> Vitaly
>
