Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805876DCAD4
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjDJSfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJSfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:35:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F7B11B
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:35:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 194-20020a6301cb000000b00513c951ff2bso8546433pgb.10
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681151743;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0x07BDO+LgGROL/luelDnJChUJfEc+xFRbSJ1/HiDU=;
        b=W8lhZlmDnMN5RqM24VFC6xKJJeY5FTrwww0P/RHavmAItvekrMRtsdJbilnBFAfa4C
         UF329M0HSTRXxvsPsmaZzfVMLQuf94OM8Zku7unL1Ro4aWm4KNhGnzNQlcM0butopAYv
         D75G0BZvh0AfF3aKuJlSQbVFyjCucp93hjyCdHc1YPIPaVzEaqEl7FvH3b0bPQS2o6Pc
         BIW/w+9vuknVLoLWMqJS51gfELYhD6Hgll/+nh2n+4jnQ1ZPnrKLgzYxLPSi63n3Zzfq
         9EV9ox0lF5QTGKJAFB2u82EMPDTMh7PQc5l6eMXtlh3GuF9mzkLDQmgNNB5H050zkors
         uLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681151743;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y0x07BDO+LgGROL/luelDnJChUJfEc+xFRbSJ1/HiDU=;
        b=sr2blf7//1UY7V7OmOKEsCSpkgkYOdbWNp/ObLVVjy1eWFlmJawTP3Ax2KwL0sEmhy
         sjpRfLmNoe6m/dChcZ4mXPIWyXuKXWCSBP1TMf/w+jt+SLHK3SrnESWnbqVwxr823zF5
         AfkTwpAd6IQO/f4I6TO3zQD0izPxbh4s7rPnUGK/TQl9B9iKkhO3Y6cIkSCsRT79DrQ+
         UB8YIQ/zT5nVd+oThntR+nf88dhJWOD8srumu2rC7RLbR9ccAxm4Ts2rszw+g8vhg5zD
         rWIKp5u7JQqYTa8EDwu0IuOV8LdWDg2WPmAR5Ta0XVLs9PQ7qwWkXwmIihUsUWiHmMEL
         MVtQ==
X-Gm-Message-State: AAQBX9dB2ewRm0o0RVaGNj3tLzf/EWeI0hdWbn4H8lX/K0pO+Q9DjqJZ
        NL4N39X485iuHkG1ceBJ3fCsIO9S0oE=
X-Google-Smtp-Source: AKy350aYhip30ugHybbCIlWqr2vIe8XA1WMp+Zh05XpasktbH4F0SFvwK6da7rgK4je2vRNvXzAU++AwkN0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa8f:b0:1a1:f9f5:4dac with SMTP id
 d15-20020a170902aa8f00b001a1f9f54dacmr6818687plr.5.1681151743287; Mon, 10 Apr
 2023 11:35:43 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:35:41 -0700
In-Reply-To: <CA+wubQBN0LAW3aqTm8Psja7jBghdi1+9x=R18TpczxTSBXN4xg@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-4-robert.hu@intel.com>
 <ZAtaY8ISOZyXB3V+@google.com> <CA+wubQBN0LAW3aqTm8Psja7jBghdi1+9x=R18TpczxTSBXN4xg@mail.gmail.com>
Message-ID: <ZDRW/aNDnuWiYAx3@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Use the canonical interface to read
 CR4.UMIP bit
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
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

On Fri, Mar 31, 2023, Robert Hoo wrote:
> Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=
1=E6=97=A5=E5=91=A8=E5=85=AD 00:27=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, Mar 10, 2023, Robert Hoo wrote:
> > > Use kvm_read_cr4_bits() rather than directly read vcpu->arch.cr4, now=
 that
> > > we have reg cache layer and defined this wrapper.
> >
> > kvm_read_cr4_bits() predates this code by ~7 years.
> >
> > > Although, effectively for CR4.UMIP, it's the same, at present, as it'=
s not
> > > guest owned, in case of future changes, here better to use the canoni=
cal
> > > interface.
> >
> > Practically speaking, UMIP _can't_ be guest owned without breaking UMIP=
 emulation.
> > I do like not open coding vcpu->arch.cr4, but I don't particuarly like =
the changelog.
> >
> > This would also be a good time to opportunistically convert the WARN_ON=
() to a
> > WARN_ON_ONCE() (when it fires, it fires a _lot).
> >
> > This, with a reworded changelog?
> >
> >         /*
> >          * UMIP emulation relies on intercepting writes to CR4.UMIP, i.=
e. this
> >          * and other code needs to be updated if UMIP can be guest owne=
d.
> >          */
> >         BUILD_BUG_ON(KVM_POSSIBLE_CR4_GUEST_BITS & X86_CR4_UMIP);
> >
> >         WARN_ON_ONCE(!kvm_read_cr4_bits(vcpu, X86_CR4_UMIP));
> >         return kvm_emulate_instruction(vcpu, 0);
>=20
> Are you going to have this along with your "[PATCH] KVM: VMX: Treat
> UMIP as emulated if and only if the host doesn't have UMIP"?

Sure, I'll add a patch for that.
