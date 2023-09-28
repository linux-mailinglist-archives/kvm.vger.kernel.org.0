Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4317B24F5
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjI1SLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjI1SL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:11:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E21A1B0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:11:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c6147ea811so96124785ad.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695924686; x=1696529486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3K3OcXUIZlyHiQujf4H1r+veO7DYVI9kt+g/p8aiVWg=;
        b=nPqAySzjXtovxpRtzSERHIs/5NPmEyF6CzwLhYIMoQ/GgojvijSn8Sz2dJIrOP3HZg
         4yLOhyTQwAOoILTMt1WuKPFfXxGIQvriwCIwSTw8gw4RON+smGw3BLdBVMq1tLIeeEc9
         uT4Cvm4davSBDuYWl9pcejUdYP/d3pNjyp1bDEzT8zBkvoZ6PWHXqYf9DQ8MD/VEr3nv
         YbOQuRRL1I2CcbeA4/jno14MlAUJbvhi/qNmUwWKG7hco6MkHejz2tdAOjxL4XYA7Sv7
         LtiJqgOKV6G4Q/VlUNtxoVTihIP6ElO3cW9mpOQOfbi09nEZLtbgFyybuDQqowXKKO56
         GT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695924686; x=1696529486;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3K3OcXUIZlyHiQujf4H1r+veO7DYVI9kt+g/p8aiVWg=;
        b=GuZh6xepdIrWf39xJHSYDk5GlznsfqRQr5KO/8SmZhqBGYpfreZFlv+MjGBZwSu3zN
         ohmTpLUyTRuCtQp5cvOp6O3uq4bzt1Qtrzl66x52amOHzVj0haxrH8t+XEOb7LTRb/P7
         lHYgE1uR02qLf1RkWfYEQDvCpeik87pWaN454xvkxul0XsaP4eIDN+btjnAB6xvAEHNB
         Oy1Hyi+CHHcYYCuL/dbpQTVAGPMYSaXFZ3SOZYn/zFHdnXNx9j4aaf9vehdUW4QVASTI
         +1G84OeX8U/w4efON8NsxmMmB9ZF0fWPK7OxfuuX/K/xtXRzioY85g4uikeDJEkemOqe
         PN6w==
X-Gm-Message-State: AOJu0YwKvNWMTwFDOJRBaFEih+3XZgrfjUeJ8wk60EshVuRKC+8GOYql
        yHw1TUw8kW1TNK0y2UddIbvmcq2Gz6E=
X-Google-Smtp-Source: AGHT+IG/xeSKSWDrjUnSnauQhpFmESuw5TvE/OCLZlz0n2YcWK5OqQSKvR8fdO5LRdL28kr6xQ6xAMA1ruQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32cf:b0:1c6:1e4e:b78f with SMTP id
 i15-20020a17090332cf00b001c61e4eb78fmr26726plr.6.1695924685737; Thu, 28 Sep
 2023 11:11:25 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:11:24 -0700
In-Reply-To: <7be47fe7-9587-dd1b-fac1-5c4d5c6e2ff6@linux.intel.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com> <20230921203331.3746712-5-seanjc@google.com>
 <7be47fe7-9587-dd1b-fac1-5c4d5c6e2ff6@linux.intel.com>
Message-ID: <ZRXBzEOfD93xwVg0@google.com>
Subject: Re: [PATCH 04/13] KVM: WARN if there are danging MMU invalidations at
 VM destruction
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023, Binbin Wu wrote:
>=20
>=20
> On 9/22/2023 4:33 AM, Sean Christopherson wrote:
> > Add an assertion that there are no in-progress MMU invalidations when a
> > VM is being destroyed, with the exception of the scenario where KVM
> > unregisters its MMU notifier between an .invalidate_range_start() call =
and
> > the corresponding .invalidate_range_end().
> >=20
> > KVM can't detect unpaired calls from the mmu_notifier due to the above
> > exception waiver, but the assertion can detect KVM bugs, e.g. such as t=
he
> > bug that *almost* escaped initial guest_memfd development.
> >=20
> > Link: https://lore.kernel.org/all/e397d30c-c6af-e68f-d18e-b4e3739c5389@=
linux.intel.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   virt/kvm/kvm_main.c | 9 ++++++++-
> >   1 file changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 54480655bcce..277afeedd670 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1381,9 +1381,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >   	 * No threads can be waiting in kvm_swap_active_memslots() as the
> >   	 * last reference on KVM has been dropped, but freeing
> >   	 * memslots would deadlock without this manual intervention.
> > +	 *
> > +	 * If the count isn't unbalanced, i.e. KVM did NOT unregister between
> Nit: Readers can get it according to the code context, but is it better t=
o
> add "MMU notifier"=C2=A0 to tell what to "unregister" to make the comment=
 easier
> to understand?

Agreed, I'll add that when applying.
