Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A24742AA1
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 18:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjF2Q0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjF2Q0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 12:26:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D236C187
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 09:26:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c361777c7f7so1370139276.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 09:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688055992; x=1690647992;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xMCpFTi4MEZLbHfM6PilnIIZPnyzbN27S0/lWwHLYHI=;
        b=GMBD/LpzELPsRbxZKKzblbYWJ+sxqCFJh8sqXPWlxGp8U0A+UAgRmx8mtN4RFIKJLS
         tWShDw0jJHclaaBavEJWjBB6dGPUFZoVr5twyAtBHN6qebVtacCXdYDnd93pZVkyKoZw
         0+WJ/aWT6RPc8Os5dCvJyiYl0a4On2PNUBwQYaQq5U78afKLGz6jg3nVF/2Qhr5TQX0q
         EK4td6N0JI9F5orF6SckKRYtzUbWYAUY5E5soJH6YcA1rYDGWhTJIbgdvG8mpTgqleWV
         cCtNrROuiOoldk/CP0QNltmh6FMzC+iqKVsmsBNTqPYeMGPgjNuoHfAlcELNKCgayqlJ
         pn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688055992; x=1690647992;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xMCpFTi4MEZLbHfM6PilnIIZPnyzbN27S0/lWwHLYHI=;
        b=MFgs2Zf2snjrqz7TbhGqLR7QZFEbH9G7cczQD49xXIevtPXvAvZTxeGmHA5uXn0uBq
         i6Xs+NdAayy0L9Xh1t1rYqG9LcT1V9OFeHrubzkopzLHdeX/ozdZyupVoXO3JsP2+Cao
         WKodfPvPugfDelQo7XPOYBV3jTx8kUjwxNAtjCYcsjpo2EpuunDXSq2NaVTcEeNflAur
         tYA6MoGkjDE/jUgE+d11j7BjpIsJxXLMPJtq/c5+9dPBtpsfZPyyl58Wb8kTz2ELNZ5o
         5NRwVaDMJLvntuODngU9c2dhjsDvA0cTtPsXm4tuIYtAXi6x58VYxFKTwPHs9dF+YzsZ
         AMfg==
X-Gm-Message-State: ABy/qLYgsASj25G/4QxzZIQBdMUQH8JEjv8Q1mKifEyrawEl7sMbAgUL
        dwPbQKK0gJJ3bEtXeaQNLs4I6epBaQQ=
X-Google-Smtp-Source: APBJJlH5xRb4gXx8WB/VIhDJtQKmlpyV6We+v5eXJyNoDqtd/JFAFS3IGZnTMhoFhIMqhyEzV4FkH8V/jS8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1105:b0:bc3:cdb7:4ec8 with SMTP id
 o5-20020a056902110500b00bc3cdb74ec8mr66497ybu.6.1688055992045; Thu, 29 Jun
 2023 09:26:32 -0700 (PDT)
Date:   Thu, 29 Jun 2023 09:26:30 -0700
In-Reply-To: <9d9e9156-b9d9-86b4-9d20-77305e1e4d63@linux.intel.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com> <20230217231022.816138-2-seanjc@google.com>
 <9d9e9156-b9d9-86b4-9d20-77305e1e4d63@linux.intel.com>
Message-ID: <ZJ2wtg5KJyhD3cUe@google.com>
Subject: Re: [PATCH 01/12] KVM: x86: Add a framework for enabling KVM-governed
 x86 features
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Binbin Wu wrote:
>=20
>=20
> On 2/18/2023 7:10 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 792a6037047a..cd660de02f7b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -835,6 +835,17 @@ struct kvm_vcpu_arch {
> >   	struct kvm_cpuid_entry2 *cpuid_entries;
> >   	struct kvm_hypervisor_cpuid kvm_cpuid;
> > +	/*
> > +	 * Track whether or not the guest is allowed to use features that are
> > +	 * governed by KVM, where "governed" means KVM needs to manage state
> > +	 * and/or explicitly enable the feature in hardware.  Typically, but
> > +	 * not always, governed features can be used by the guest if and only
> > +	 * if both KVM and userspace want to expose the feature to the guest.
> > +	 */
> > +	struct {
> > +		u32 enabled;
> Although there are some guidances/preconditions of using the framework,
> is it possible that u32 will be ran out quickly after people starts to us=
e
> the framework?

It's definitely possible.  And there's no reason to limit this to a u32, I =
really
have no idea why I did that.=20

Ah, it's because "struct kvm_vcpu_arch" is defined in arch/x86/include/asm/=
kvm_host.h,
and I didn't want to expose governed_features.h in arch/x86/include/asm.  H=
rm,
that's really annoying.

Aha!  A better workaround for that conudrum would be to define an explicit =
"max"
and use that, with a FIXME to call out that this really should use
KVM_NR_GOVERNED_FEATURES directly.  I have aspirations of moving kvm_host.h=
 to
arch/<arch>/kvm, at which point this can be cleaned up by declaring "enum
kvm_governed_features" in kvm_host.h (though it'll likely be named somethin=
g
like kvm_arch.h at that point).

	/*
	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
	 * when "struct kvm_vcpu_arch" is no longer defined in an
	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
	 * can be increased as necessary.
	 */
#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG

	/*
	 * Track whether or not the guest is allowed to use features that are
	 * governed by KVM, where "governed" means KVM needs to manage state
	 * and/or explicitly enable the feature in hardware.  Typically, but
	 * not always, governed features can be used by the guest if and only
	 * if both KVM and userspace want to expose the feature to the guest.
	 */
	struct {
		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
	} governed_features;


> Of course, I noticed there is build=EF=BF=BD bug check on the length, it =
should be
> OK to increase the length when needed.

> > +static __always_inline int kvm_governed_feature_index(unsigned int x86=
_feature)
> > +{
> > +	switch (x86_feature) {
> > +#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
> > +#include "governed_features.h"
> > +	default:
> > +		return -1;
> > +	}
> > +}
> > +
> > +static __always_inline int kvm_is_governed_feature(unsigned int x86_fe=
ature)
> Is it better to use bool instead of int?

Yes, this definitely should return a bool.

Thanks!
