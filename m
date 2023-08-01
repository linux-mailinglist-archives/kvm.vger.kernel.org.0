Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8317D76C128
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 01:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjHAXlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 19:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjHAXlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 19:41:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6B1BC7
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 16:41:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbb34b091dso43982185ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 16:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690933279; x=1691538079;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2LwGsT/iHwXLUwnaAgJ41gfE/Q8Bf1CWgRIFqYX6qY=;
        b=Kp5KNEahFVkBN4nOisbcXObQ2XDK++Z1WBCBukJjD13lAYFQnpOrEzdr18R049TWds
         aGTaSE1pyLRiaGz969hcC5l8nAiHl+nZEHbxxXhLkbgzAubCcewKD5rpgvoCFt2sM3bS
         tNPlJLFSVF3ob2tTHOmGt01BHcBOtQkBNGepPnv2Http9XcpTMXtS/yRCbmlwaI/eqR9
         D7iAUECPXeMgvLLmuuqFWQ3KcrERqIkeUwXdj+sVEiS9t3xyioF1mME9RQ1HLKCVhtA/
         5F7LQg7SFk76mhxxy81A+f/vLw6wIx7LGeR0ylt6GAVHqtZdTK4xR5zD4OoPx3XeS5Bb
         yz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690933279; x=1691538079;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z2LwGsT/iHwXLUwnaAgJ41gfE/Q8Bf1CWgRIFqYX6qY=;
        b=SA9UasWdFpXTxoetv8IzMGWdMu2B4bUkkG+6dszFdFT2mB58RBTj2OxiK8VklqVTof
         WA78kEg2QyBEVEZ1ggpjJLII96H+h1hcn9DidtNBoOw7ApXLcHWXvyc4ooEETsZpophW
         hz1wwUqNscyjO0F0PPYbbGB3dOqmMSQVqD1PdvA7VLtJOIVxfvRZ7H/SRqTWSWQm7eDc
         0AHIt69t20gf+oScUyOTsB/nBqWlsj7wt4icONglxASHfEHMOaLOZ1VsGOYBhlXVo7lc
         /wzA43kAPRnbGxd+bXJ/8B3GUDK1FOhI8gGoyWPD+xPQWtajTbOP4GEpqN3DJM4D/wtR
         YguA==
X-Gm-Message-State: ABy/qLbT328KYAdEt55N+zknbypBGEFiMNcbj+KIzx/9qx2PoYCu3v0/
        6J31T5oNnRZrRZpfoqtIFg9gJ6P0zhg=
X-Google-Smtp-Source: APBJJlH8Sbjqd6VGnpJCr5LDEnW46KjKTVgZmLtT1W13JnjOKdg2SzuAqH9H1wwxrEtFvf1wfad7JfYgdeI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40b:b0:1bb:a78c:7a3e with SMTP id
 k11-20020a170902c40b00b001bba78c7a3emr75641plk.3.1690933279379; Tue, 01 Aug
 2023 16:41:19 -0700 (PDT)
Date:   Tue, 1 Aug 2023 16:41:17 -0700
In-Reply-To: <8f2c1cf6-ae4d-f5fb-624f-16a1295612d7@linaro.org>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com> <20230729004722.1056172-11-seanjc@google.com>
 <8f2c1cf6-ae4d-f5fb-624f-16a1295612d7@linaro.org>
Message-ID: <ZMmYHQwWMpT8s9Vi@google.com>
Subject: Re: [PATCH v3 10/12] KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for
 KVM_MMU_WARN_ON() stub
From:   Sean Christopherson <seanjc@google.com>
To:     "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Philippe Mathieu-Daud=C3=A9 wrote:
> Hi Sean,
>=20
> On 29/7/23 02:47, Sean Christopherson wrote:
> > Use BUILD_BUG_ON_INVALID() instead of an empty do-while loop to stub ou=
t
> > KVM_MMU_WARN_ON() when CONFIG_KVM_PROVE_MMU=3Dn, that way _some_ build
> > issues with the usage of KVM_MMU_WARN_ON() will be dected even if the
> > kernel is using the stubs, e.g. basic syntax errors will be detected.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu_internal.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_int=
ernal.h
> > index 40e74db6a7d5..f1ef670058e5 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -9,7 +9,7 @@
> >   #ifdef CONFIG_KVM_PROVE_MMU
> >   #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
> >   #else
> > -#define KVM_MMU_WARN_ON(x) do { } while (0)
> > +#define KVM_MMU_WARN_ON(x) BUILD_BUG_ON_INVALID(x)
>=20
> No need to include <linux/build_bug.h> ?

It's indirectly included via

  linux/kvm_host.h =3D> linux/bug.h =3D> linux/build_bug.h

Depending on the day, I might argue for explicitly including all dependenci=
es, but
in this case build_bug.h is a "core" header, and IMO there's no value added=
 by
including it directly.
