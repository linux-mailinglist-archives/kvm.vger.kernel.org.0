Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37438705B05
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 01:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjEPXL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 19:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjEPXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 19:11:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4959149CC
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 16:11:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae4a0b5a90so1263955ad.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684278715; x=1686870715;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vy9cnxdi/Kt1r7giZiNimssgKy53ZU01/HMnFiDIX5o=;
        b=W5MbdP/JLglW0MFVW/4S2icBwEJjF8Ym0ZyIgAK3/HFEJcU5VIyvy1NwDpazTDlcWL
         NYNfsHKrT1IGE33Cy+q2hHoKBqKiSBaIYYrHHujFhsPELAoKzFznj+amZmZsxZiQZ/yP
         1mTbHe9WRXs9yIMLGTO6VNg+KbnkzcVGQnTI5Gt9Mx6xcMJ6ODxlZ8RXzmk2TabmZfGt
         keKKQuYgx1i2izeA4buO+WgYhyhRbYTdfpQKJilNr2+n4/xABLXPHoZ1JmCK/tfzEVT5
         zDoIpjp1BbxuGO+hLAvgwhSRvN7XUa7t1q0tlPLp2PDMeImlGyt2BKvD9Cqj1dK1OAea
         DUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684278715; x=1686870715;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vy9cnxdi/Kt1r7giZiNimssgKy53ZU01/HMnFiDIX5o=;
        b=DS8L4dc3UfpQ02U2iG2sJoz0JDqv7oXiJ7LpXWoFHHgm5vtsWrqTg3X7uvjhAkfJXm
         ty+Z8WP0FruYyM/iwpJvPPwBuwNrClhDn+FqzaforqB2PC9zdakj6CppiDBcYNLqdfqs
         +UxbFOAKqF/zxVvRwBNtE2LHYNWSsu/E1QYVREA4OrYZ/51NC0tgocH06K1ZzG7vDbG7
         wYdnVPLPRmbH4FGK/Wghk0jlFUAhq8bHRRiUFjSU1aUfQ2cQZjHX8nd+pt++daUvfF7Y
         K6V8LPnDo+OB94hr5mpY6QyAuS45DTQgzsno9QQTZr5GkQT6mghU36IDfwnrHITXw7ic
         WUtw==
X-Gm-Message-State: AC+VfDxt6rw9KXPdx8FpAyI/8qFKjN80Qs3cpH9Pc45iGyK0Ct9hz5E1
        mBkQxEQbVP6wAgriFMsJXbsbhAPHZdw=
X-Google-Smtp-Source: ACHHUZ60FkRU5dvymYwQ0l72xzrClmfH0NiXOrfFeiJFy6q6dGZojiHnaSsel+tktd0eg4omGFIrK9vtGn0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f908:b0:1ae:4d1c:1282 with SMTP id
 kw8-20020a170902f90800b001ae4d1c1282mr426459plb.7.1684278714788; Tue, 16 May
 2023 16:11:54 -0700 (PDT)
Date:   Tue, 16 May 2023 16:11:53 -0700
In-Reply-To: <CALMp9eRQC-U4f9imkwsMM1=ewtJFuUORjseFPNskib4t-AL6-w@mail.gmail.com>
Mime-Version: 1.0
References: <20220225012959.1554168-1-jmattson@google.com> <YhgxvA4KBEZc/4VG@google.com>
 <CALMp9eRQC-U4f9imkwsMM1=ewtJFuUORjseFPNskib4t-AL6-w@mail.gmail.com>
Message-ID: <ZGQNubdv5zyzCFPd@google.com>
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023, Jim Mattson wrote:
> On Thu, Feb 24, 2022 at 5:32=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Feb 24, 2022, Jim Mattson wrote:
> > > From: Jacob Xu <jacobhxu@google.com>
> > >
> > > Include a definition of WARN_ON_ONCE() before using it.
> > >
> > > Fixes: bb1fcc70d98f ("KVM: nVMX: Allow L1 to use 5-level page walks f=
or nested EPT")
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Jacob Xu <jacobhxu@google.com>
> > > [reworded commit message; changed <asm/bug.h> to <linux/bug.h>]
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/include/asm/vmx.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > > index 0ffaa3156a4e..447b97296400 100644
> > > --- a/arch/x86/include/asm/vmx.h
> > > +++ b/arch/x86/include/asm/vmx.h
> > > @@ -14,6 +14,7 @@
> > >
> > >  #include <linux/bitops.h>
> > >  #include <linux/types.h>
> > > +#include <linux/bug.h>
> >
> > Paolo, any chance you want to put these in alphabetical order when appl=
ying? :-)
> >
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> >
> > >  #include <uapi/asm/vmx.h>
> > >  #include <asm/vmxfeatures.h>
> > >
>=20
> Ping.

I'll grab this for 6.5 unless Paolo beats me to the punch.
