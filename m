Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34630770745
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjHDRjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjHDRjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:39:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D2746B1
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:39:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-52256241c66so5057590a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 10:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691170739; x=1691775539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WJQF/s3rT1P+39oLCYPi5xllhzTzH9j+4r0ow7Ta0v4=;
        b=CJyUx8loeqVC+QoYGq4TsRo62LRMV5E4n6sHc9xUlC4rAUfYoqIHQQUopItKs2LyHn
         AZYLzFv3BHx1qyuT2nbvENd9nLtP5X91MUYD2+xZ5FW8SQXdjY/vNqG+fxhDRlZR7SIo
         33wTmnpBWHyQOb/6Ob2cb9ji1PH7VlZGWU2e1oapNct252S3fe2bZk8PnBOM9oA/KSu2
         Q0U50hFvPtOp53u4jfzDpv8LrErrHVNlULcSs5e/bfIH4dv3j51g2DCw6wg08+Y7jDgM
         x8PH8e8bXcynYWWGdW9t3MGr/N1y/ALAf6ULJPPyAH5GqyFH+QfZJTCjOhHf6n/EM0Xd
         +PfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170739; x=1691775539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJQF/s3rT1P+39oLCYPi5xllhzTzH9j+4r0ow7Ta0v4=;
        b=K8qionnXx/YgVVj8hjPHD3WYpa8q19KWQCT57uKHZwbqkiHxlbLXvxRhrakKer9d9A
         /YnfqBX3HQLTtAMshLIupPoYopveYHdR70nWPWz33jEeHMRGoWFouGfPwaKpWNL7HgY4
         NgNSSXmQBFMqAy9ITrYxsGNjpB4/MuAY/8WrAEMth9LSVWVF2jDLVu2q0d42m76OMqZY
         cB1ilOd6TDQN/hVspQbd8D4KzgGIj+bMNZ7rsLZwvxEiDzlpwc2ftHC79NLSR4BxJ46J
         Y5+1wn9Z8aXjTy1+L+LSI5tZioQtRYJMOuR2tytLUoULC+dKHue5xhujRG7Q2/uO81Ow
         wStA==
X-Gm-Message-State: AOJu0YxTCTilWIDqqtYShwUjQOC6lE0SMpIwvD2uSsdll4X39E9gf76J
        vKELvzLJ3BD2rrDmdJ6xn5f4ZubVC79JfhWnJB+4Lg==
X-Google-Smtp-Source: AGHT+IEQ930XjvM88a1W5rHGmhKOQbNzc1l2YidYQyIxFZ7q31M35uM2Sd24s6HPKS85BtZBsilBwRx6p6IPs/VUmlw=
X-Received: by 2002:a05:6402:2141:b0:522:582c:f427 with SMTP id
 bq1-20020a056402214100b00522582cf427mr434413edb.14.1691170739265; Fri, 04 Aug
 2023 10:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
 <20230727073134.134102-2-akihiko.odaki@daynix.com> <CAFEAcA_26e2G_qLA8DEcv74MADgquhiVkWEZkh_wL0+JxAf91Q@mail.gmail.com>
In-Reply-To: <CAFEAcA_26e2G_qLA8DEcv74MADgquhiVkWEZkh_wL0+JxAf91Q@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 4 Aug 2023 18:38:48 +0100
Message-ID: <CAFEAcA9gkKy=GBXNw0rRLeN80ekFY5JQB1Jn2b+F70oC1C5uxg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] kvm: Introduce kvm_arch_get_default_type hook
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Aug 2023 at 18:26, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> >
> > kvm_arch_get_default_type() returns the default KVM type. This hook is
> > particularly useful to derive a KVM type that is valid for "none"
> > machine model, which is used by libvirt to probe the availability of
> > KVM.
> >
> > For MIPS, the existing mips_kvm_type() is reused. This function ensures
> > the availability of VZ which is mandatory to use KVM on the current
> > QEMU.
> >
> > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > ---
> >  include/sysemu/kvm.h     | 2 ++
> >  target/mips/kvm_mips.h   | 9 ---------
> >  accel/kvm/kvm-all.c      | 4 +++-
> >  hw/mips/loongson3_virt.c | 2 --
> >  target/arm/kvm.c         | 5 +++++
> >  target/i386/kvm/kvm.c    | 5 +++++
> >  target/mips/kvm.c        | 2 +-
> >  target/ppc/kvm.c         | 5 +++++
> >  target/riscv/kvm.c       | 5 +++++
> >  target/s390x/kvm/kvm.c   | 5 +++++
> >  10 files changed, 31 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> > index 115f0cca79..ccaf55caf7 100644
> > --- a/include/sysemu/kvm.h
> > +++ b/include/sysemu/kvm.h
> > @@ -369,6 +369,8 @@ int kvm_arch_get_registers(CPUState *cpu);
> >
> >  int kvm_arch_put_registers(CPUState *cpu, int level);
> >
> > +int kvm_arch_get_default_type(MachineState *ms);
> > +
>
> New global functions should have a doc comment that explains
> what they do, what their API is, etc. For instance, is
> this allowed to return an error, and if so, how ?

Looks like this was the only issue with this patchset. So
I propose to take this into my target-arm queue for 8.2,
with the following doc comment added:

/**
 * kvm_arch_get_default_type: Return default KVM type
 * @ms: MachineState of the VM being created
 *
 * Return the default type argument to use in the
 * KVM_CREATE_VM ioctl when creating the VM. This will
 * only be used when the machine model did not specify a
 * type to use via the MachineClass::kvm_type method.
 *
 * Returns: type to use, or a negative value on error.
 */

unless anybody wants more time for review or for this
series to go into the tree some other way.

thanks
-- PMM
