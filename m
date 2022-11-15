Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3A62A359
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 21:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiKOUtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 15:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiKOUtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 15:49:45 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA602628
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:49:44 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id r12so26374016lfp.1
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C7tUVYpO4jLfaqvMhqdCpmO66QWigemFPvbjNEjHSJ4=;
        b=RyLafPpZTU9ucYBbhpi+V1I+plIAPNE+NaFEVe8vgquDBY5QK468W6QDDSEN/Mmm43
         LZVO7gl6lIXfpB0iwaQxCkcGNLItecm1m2/BkLtsSkLOfglZhL3F0SjGriWHvkKRkZ2s
         Vvfv9uZpepq1qCE9WtMYr8HPKBNUFSfJUHiUk+RfXCkBU8khtTwrMd/jIOBaZkd4cghz
         wKluyqtiwaKMedUhhO9BYERvAWoVo6wkgXxnpbbc0O1Ygvr2twjQZAjABkcWUI6LPbfj
         0Gsnk6vfJS0hbRtVxZANMdLI6GXXXNSS81PqVQz9odjXxcl7bdji87g6n5mgX8BqwZIB
         lYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7tUVYpO4jLfaqvMhqdCpmO66QWigemFPvbjNEjHSJ4=;
        b=qGpU8j7SpHvFBfj8I+VYiRdYk7RFLY8ta3tHjPOQOZQ0SfQyh8+cNvlam3PXD5Fk8L
         EV8mkTjAKKX8zmBJMAmOdowCg4QBg7MUXe0gbw29+cAKqc8lnytdZ+MWHWlUreE4z/G3
         yNMpWGD1ZiPgMK7V5u3Zbi6Ws/2OFlVBFJtWifJWQ2kl4seyJ+1Oakl8hjiSbI2QEm32
         dFautKL5OJbJpUSoiczeXizXIatCGpeOsVF2EnEmbZxGXQZmngzOfBtJ8uON6TrevjZ1
         YWKHtkNDdkW/GWQoIyyT0TNX9BubCMVEszbb2IIdUzEL6v+5Eut7vFNILjPSuN3LU5eV
         kW1Q==
X-Gm-Message-State: ANoB5pmn3tfCmXOYzsJuV2N+8wJ6ZMkayKJnyzRu+b7Y8VmVd5okEGH0
        cervKssdUkfKPaScBnEpAK3hiWtPNhz93VKHwB9I0LnyfmAb+lhI
X-Google-Smtp-Source: AA0mqf5WE1OmCxTm3+6oYR82HozAdj/Ug60zwqHh4bKRK7ZYXXfslyMmWoI+6oqiZ0xsQo42WdTsDLFKfuF4n/4M12A=
X-Received: by 2002:a19:7411:0:b0:4b1:215b:167d with SMTP id
 v17-20020a197411000000b004b1215b167dmr6765094lfe.558.1668545382694; Tue, 15
 Nov 2022 12:49:42 -0800 (PST)
MIME-Version: 1.0
References: <20221013121319.994170-1-vannapurve@google.com>
 <20221013121319.994170-4-vannapurve@google.com> <20221013140112.ppm6jgoxd5oqvlgw@kamzik>
In-Reply-To: <20221013140112.ppm6jgoxd5oqvlgw@kamzik>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 15 Nov 2022 13:49:31 -0700
Message-ID: <CAMkAt6rgvo6rVhehTZYMMa2qetehc_gEXeTfQBoJFGgftUEkfg@mail.gmail.com>
Subject: Re: [V3 PATCH 3/4] KVM: selftests: Add arch specific post vm creation hook
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Vishal Annapurve <vannapurve@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022 at 8:03 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Thu, Oct 13, 2022 at 12:13:18PM +0000, Vishal Annapurve wrote:
> > Add arch specific API kvm_arch_vm_post_create to perform any required setup
> > after VM creation.
> >
> > This API will be used in followup commit to convey cpu vendor type to the
> > guest vm.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util_base.h | 4 ++++
> >  tools/testing/selftests/kvm/lib/kvm_util.c          | 9 ++++++---
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c  | 6 ++++++
> >  3 files changed, 16 insertions(+), 3 deletions(-)
> >
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Peter Gonda <pgonda@google.com>
