Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91EF77FEB2
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 21:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354748AbjHQTrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 15:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243326AbjHQTqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 15:46:44 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EAB359B
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 12:46:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56385c43eaeso220872a12.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 12:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692301603; x=1692906403;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38OjwvLryGdRHNnQWvsk2mgWrNDTfqIkNTH/PDjk+4c=;
        b=jxJyj8vSc6MVlvwD3uyMXulv8nXM55AWC9xP41lj7Vv/PPFEby+CxZdmmt0CNvuHOH
         TH9kLw8p++GjtH1j8/hd4kIG8jRZEUotTPHb0Hfr4dtL2YfI+c1IZ9jhNcaIwS/Brv6b
         KKXsVS5CPcB1ginpNzN2uXhSew0+N2RgepwQd5vEyqVnpItfJcK20+eUs46gU5e5NdLF
         ZWoRgewhJBv+ehRh49D5L7rS22AyO0ub77AQOOLv1cNoT6y/F+Z3334WyDyrk7F7RMVc
         e3DitMFKj1rOjnvoqpgM+cvYv93cUinXdWtPlw28mzywXfuQb+5s6w6+DaztqYxvwqgC
         j7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692301603; x=1692906403;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=38OjwvLryGdRHNnQWvsk2mgWrNDTfqIkNTH/PDjk+4c=;
        b=BgChTc7mVzZ2XydEYo002veBJSBWx3p6yTUXOgzrwwQF9xqEhgeYRUcDMHAIJu/cO9
         Du8wVWR9ZhKTpbOf1KjAzJT25B1X+Rv7lwbqWo7WudzoBJkIJniAnoJu/XR9KLp3D+UH
         aQ1Ux0RKNDfTuG0957psy9f4liwpCGNoLBPfsZhgoN7WpMlUPGDzXNO8PJOq8NACOL0N
         ztaJdtAZhziLL5qlIEdGrk5voC0aONh0Q4Fx23856ldUlT77pfy3d8+dzrqnRQjBFUg8
         e65URf5wFjcW2vn3KNYKLyrJTk8+P+KgXWbuagn25XYq2i7XIvPRVSkAi0FP6cq828f0
         A3FQ==
X-Gm-Message-State: AOJu0YwFW+/BnijqqdPanUMdzMdeIJ/QK9+4pnU2mrOTLOBMfWeRBKx2
        YoiDX1HW8FLCNOjIVK6S10rkO+q/q24=
X-Google-Smtp-Source: AGHT+IFBe9aniLvKThqqpWnXRIW+Ce6rpM3SxSMATIg5sCkf4FHEzKrUMBQUwCkNZWjSzdkkdkLSS3NKUoQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:295a:0:b0:565:dc04:c912 with SMTP id
 bu26-20020a63295a000000b00565dc04c912mr76598pgb.5.1692301602857; Thu, 17 Aug
 2023 12:46:42 -0700 (PDT)
Date:   Thu, 17 Aug 2023 12:46:40 -0700
In-Reply-To: <244a3f0b-16fd-eac8-f207-1dfe7859410b@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-4-binbin.wu@linux.intel.com> <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
 <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com> <aa17648c001704d83dcf641c1c7e9894e65eb87a.camel@intel.com>
 <ZN1Ardu9GRx7KlAV@google.com> <244a3f0b-16fd-eac8-f207-1dfe7859410b@linux.intel.com>
Message-ID: <ZN55IJoxTMb1niP7@google.com>
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@aculab.com>,
        Guang Zeng <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023, Binbin Wu wrote:
>=20
>=20
> On 8/17/2023 5:33 AM, Sean Christopherson wrote:
> > On Wed, Aug 16, 2023, Kai Huang wrote:
> > > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > > @@ -7783,6 +7783,9 @@ static void vmx_vcpu_after_set_cpuid(stru=
ct kvm_vcpu *vcpu)
> > > > > >    		vmx->msr_ia32_feature_control_valid_bits &=3D
> > > > > >    			~FEAT_CTL_SGX_LC_ENABLED;
> > > > > > +	if (boot_cpu_has(X86_FEATURE_LAM))
> > > > > > +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
> > > > > > +
> > > > > If you want to use boot_cpu_has(), it's better to be done at your=
 last patch to
> > > > > only set the cap bit when boot_cpu_has() is true, I suppose.
> > > > Yes, but new version of kvm_governed_feature_check_and_set() of
> > > > KVM-governed feature framework will check against kvm_cpu_cap_has()=
 as well.
> > > > I will remove the if statement and call
> > > > kvm_governed_feature_check_and_set()=C2=A0 directly.
> > > > https://lore.kernel.org/kvm/20230815203653.519297-2-seanjc@google.c=
om/
> > > >=20
> > > I mean kvm_cpu_cap_has() checks against the host CPUID directly while=
 here you
> > > are using boot_cpu_has().  They are not the same.
> > >=20
> > > If LAM should be only supported when boot_cpu_has() is true then it s=
eems you
> > > can just only set the LAM cap bit when boot_cpu_has() is true.  As yo=
u also
> > > mentioned above the kvm_governed_feature_check_and_set() here interna=
lly does
> > > kvm_cpu_cap_has().
> > That's covered by the last patch:
> >=20
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index e961e9a05847..06061c11d74d 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -677,7 +677,7 @@ void kvm_set_cpu_caps(void)
> >          kvm_cpu_cap_mask(CPUID_7_1_EAX,
> >                  F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
> >                  F(FZRM) | F(FSRS) | F(FSRC) |
> > -               F(AMX_FP16) | F(AVX_IFMA)
> > +               F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
> >          );
> >          kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> >=20
> >=20
> > Which highlights a problem with activating a goverened feature before s=
aid feature
> > is actually supported by KVM: it's all kinds of confusing.
> >=20
> > It'll generate a more churn in git history, but I think we should first=
 enable
> > LAM without a goverened feature, and then activate a goverened feature =
later on.
> > Using a goverened feature is purely an optimization, i.e. the series ne=
eds to be
> > function without using a governed feature.
> OK, then how about the second option which has been listed in your v9 pat=
ch
> series discussion.
> https://lore.kernel.org/kvm/20230606091842.13123-1-binbin.wu@linux.intel.=
com/T/#m16ee5cec4a46954f985cb6afedb5f5a3435373a1
>=20
> Temporarily add a bool can_use_lam in kvm_vcpu_arch and use the bool
> "can_use_lam" instead of guest_can_use(vcpu, X86_FEATURE_LAM).
> and then put the patch of adopting "KVM-governed feature framework" to th=
e
> last.

No, just do the completely unoptimized, but functionally obvious thing:

	if (kvm_cpu_cap_has(x86_FEATURE_LAM) &&
	    guest_cpuid_has(vcpu, x86_FEATURE_LAM))
		...

I don't expect anyone to push back on using a governed feature, i.e. I don'=
t expect
to ever see a kernel release with the unoptimized code.  If someone is bise=
cting
or doing something *really* weird with their kernel management, then yes, t=
hey
might see suboptimal performance.

Again, the goal is to separate the addition of functionality from the optim=
ization
of that functionality, e.g. to make it easier to review and understand each=
 change.
