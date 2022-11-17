Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55FD62E40C
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiKQSYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiKQSYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:24:38 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E324047A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:24:36 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bp15so4148343lfb.13
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H7dDqdIlCjvsWgxNVSFjkDsElNbTau2O0NNvYuTHUpw=;
        b=SPbTUosw8SXNkyeEDowqNWOxhv8w/JTycOQeqV9xw4J28R3GexzPcP3FFvfMWL0QTi
         bZng422c7hcq6KOuHADNXqSjctUnDjuLan2j6HTykh/mNZ4Z08s4tnwFDqzCyd3KZYis
         bds60HnNiyvl2GonooIrgRkfO9lb1811QXYa5z15UexvxS6EEAn7K/NUHRuw5h3yp0CU
         GE/QmS3KYcVw1hvuOLE9xOf2y1TVYGR5YjYplIphxETfaQjhsvlg9sQ8wQwP7IW66ikB
         u2lMNUnL4bALtArhaJzk7ZMkD26jyC4V0Vzua029zQlliYDZUPn0m84aj037h8X3+Hbb
         CV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H7dDqdIlCjvsWgxNVSFjkDsElNbTau2O0NNvYuTHUpw=;
        b=OP0L3jvhZtSJ6GSRJyL1LWBo1+uWEyTPbUe4sZoVQDW5a9l0pW8fKuKEIoXd/yatQg
         sHDcw8UJYqkBjK3CQGqXI0kocTjFhz/f+DTxNjZBuUbGfzZoFjjZ+lYHLGEEB7ATpTjd
         RSea3sUCxfKEjnbboc+wFBa6zfM2sqHD0izZ5v48XCWoodKaAbdk9HZU/E6rQKTtoqN2
         k0yJGSHqZQ4pPIVCmdByFwD3pQ1TgjpJU3uNpL9L5TtO5biv/7YKLW4Zr5MGKNLLOTiX
         MGLrjUblebii4WPvcDEV86d2+u+DC+2AT38Yo3dKkyzOuXB1fE9tPCfaWlJfQ8y6T/CJ
         yixw==
X-Gm-Message-State: ANoB5pnUbHJEdHdFPv9z7BAvs9qjhZC4WGEJ4fdt63bdpCz0RMXCzzx7
        rdfawGDODg2gveU6UO2/5k8G6usoOYVMFswA0Bp6jJ1GvTo=
X-Google-Smtp-Source: AA0mqf4rmxzvFrD7I/LvJo+9vRYkb9lb/6KvWdljA1XyhAomVOpFlEGi5CFamel4tcOgm4QERv6c80rzBvdTF8+dPXI=
X-Received: by 2002:a05:6512:3710:b0:4b3:a367:b916 with SMTP id
 z16-20020a056512371000b004b3a367b916mr1264614lfr.340.1668709474789; Thu, 17
 Nov 2022 10:24:34 -0800 (PST)
MIME-Version: 1.0
References: <20221115213845.3348210-1-vannapurve@google.com>
 <20221115213845.3348210-3-vannapurve@google.com> <Y3Uh3cvVYfH0ZFEr@google.com>
In-Reply-To: <Y3Uh3cvVYfH0ZFEr@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Thu, 17 Nov 2022 10:24:23 -0800
Message-ID: <CAGtprH9H8OU0QU_3G0hjVp1P5OHLiTeVWEkUtynZjCx1Z8pdLQ@mail.gmail.com>
Subject: Re: [V4 PATCH 2/3] KVM: selftests: Add arch specific initialization
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, oupton@google.com,
        peterx@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        pgonda@google.com, andrew.jones@linux.dev
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

On Wed, Nov 16, 2022 at 9:46 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 15, 2022, Vishal Annapurve wrote:
> > Introduce arch specific API: kvm_selftest_arch_init to allow each arch to
> > handle initialization before running any selftest logic.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Reviewed-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h      |  5 +++++
> >  .../selftests/kvm/lib/aarch64/processor.c      | 18 +++++++++---------
> >  tools/testing/selftests/kvm/lib/kvm_util.c     |  6 ++++++
> >  3 files changed, 20 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index e42a09cd24a0..eec0e4898efe 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -838,4 +838,9 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> >       return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
> >  }
> >
> > +/*
> > + * API to execute architecture specific setup before executing main().
> > + */
>
> I find the "API" blurb to be somewhat confusing.  When I think of APIs, I think
> of functions that are provided by a library that are called by users of the
> library.
>
> An example might also help readers understand what types of setup can/should be
> done with this hook.
>
> Maybe something like this?
>
> /*
>  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
>  * to allow for arch-specific setup that is common to all tests, e.g. computing
>  * the default guest "mode".
>  */

Ack, that looks better.
