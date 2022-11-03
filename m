Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7BB618805
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 19:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiKCS5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 14:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiKCS5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 14:57:09 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986FA1A061
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 11:57:08 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k8so4172627wrh.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 11:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dVz063XgoahxZN0vEmjhonAG9FWv7u/nq/h+jplyBm4=;
        b=NQ9du519KUL8FCmgySHYK2ektc3YEtni/LyN+1Qn5Hmuko9RTqgyGiYm155DQBGPUO
         ENOvr+1zm/UFMgEKO3qR3GZv8bB8YjN6R3ooT8lzE8jPVmb4qKD1RKGBqsnyWZvep2pz
         AcTVoQy0s5ggFUQ8fmB7RsV4qEMWOlskHcTTSzapR5GaiRqMiR+bnYkoqA3us9k6H4wU
         sJwygp4yOkxlpTr+iynZvAS8NgEvMEWzwkJ7b+H141WV/mT+OUWMQQcWz0IekfNC0ctB
         0qCgo15SrcbmI+yuseUnT3odLiVddHaDRwsu96WowWkv2Oi0J38bv38cgsR4ZcvI181U
         D/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVz063XgoahxZN0vEmjhonAG9FWv7u/nq/h+jplyBm4=;
        b=sW7zb5OfxbAA9jiTd2Cj0l4IKK1uvNSBriIjdMlCRvHIdEJHTEap/xyFlyXoTDrYx3
         g08mKetmaWaxknwBRtLual+ZN0wK3HpVlL0Bth3iSoQUrNWuPuVjMYq3EzmDUdKkXKgX
         cW4l0g+/Oy8nYVrMXhV1MwgUytmxMGZYuz+yqube/zUkBqxH3Po+b/YW8hfQeB72n3hZ
         UqHXbeEBro0QuX4snSM+YhD0TPnrQ+uK7+qzzj/rqsnDHaonaGRcQaVmQhhJSjVFwjUH
         +xrOKfkjlxp6FVpXeZ9g0a5xJHSn9MXutQGeB86EygKss9ZijtJIIqli/J2YE9Q4XVwi
         gsoA==
X-Gm-Message-State: ACrzQf23cuR0cA3BTjcfpgdvgm4sAxPM2RuPis6VmRR7RlAuGUh+CdSI
        LA7/kuW/ZL713g0dQPSl40QEFDW1cPoPSGM06OFCLA==
X-Google-Smtp-Source: AMsMyM7znoQWh5RDbYSU48z4MoDO2qP/u0NWSjMfYRZUeQRIf87ScC+UEicCRBDjzyQG1FyikIJ7nA2fFfERTzHOCNg=
X-Received: by 2002:a5d:47a1:0:b0:236:6f4d:1db3 with SMTP id
 1-20020a5d47a1000000b002366f4d1db3mr19531006wrb.383.1667501826938; Thu, 03
 Nov 2022 11:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221102232737.1351745-1-vipinsh@google.com> <20221102232737.1351745-6-vipinsh@google.com>
 <Y2MBNA7pLIb6ugU2@google.com> <Y2MIVxzVQkGcEwlL@google.com>
In-Reply-To: <Y2MIVxzVQkGcEwlL@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 3 Nov 2022 11:56:30 -0700
Message-ID: <CAHVum0fXeN8+G=C7rvZhsxJWCS+ez_A0nvSCXELB9e_HDmc8bw@mail.gmail.com>
Subject: Re: [PATCH v8 5/7] KVM: selftests: Shorten the test args in memslot_modification_stress_test.c
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Nov 2, 2022 at 5:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 02, 2022, Sean Christopherson wrote:
> > On Wed, Nov 02, 2022, Vipin Sharma wrote:
> > > Change test args memslot_modification_delay and nr_memslot_modifications
> > > to delay and nr_iterations for simplicity.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> >
> > I don't care about the credit so much as I don't want you getting yelled at for
> > one of my random ideas :-)
> >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++---------
> > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > > index d7ddc8a105a2..d6089ccaa484 100644
> > > --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > > +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > > @@ -87,8 +87,8 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
> > >  }
> > >
> > >  struct test_params {
> > > -   useconds_t memslot_modification_delay;
> > > -   uint64_t nr_memslot_modifications;
> > > +   useconds_t delay;
> > > +   uint64_t nr_iterations;
> > >     bool partition_vcpu_memory_access;
> > >  };
> > >
> > > @@ -107,8 +107,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >
> > >     pr_info("Started all vCPUs\n");
> > >
> > > -   add_remove_memslot(vm, p->memslot_modification_delay,
> > > -                      p->nr_memslot_modifications);
> > > +   add_remove_memslot(vm, p->delay,
> > > +                      p->nr_iterations);
> >
> > This wrap is no longer necessary (which was part of the motivation for the
> > rename).
>
> Almost forgot.  Nit aside,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

I will update in v9.
Thanks
