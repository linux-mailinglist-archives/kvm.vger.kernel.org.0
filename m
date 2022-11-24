Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B16376DE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiKXKzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiKXKzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:55:14 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B76E179AA4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:55:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z18so2011846edb.9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cDjZkRfpYrY5I/MR6Qn4PLWFtgP7s/Bq564G/WDROg8=;
        b=QO7D86gaGFb5ZRyhP30L+tC9SacJbP+BnjiLVrXG1Hp1YNn8JYwTlPi5lxcrIDPR+a
         dnPFJq1vznqQ8DZIYdMjtsTvyr6fy+fBcUwdKOZA5MOZ5EHTRGfcCK8b150A8FCivC2l
         /xTKmQi1XygjlmKoT3qKOmrwHR+KDqrBvYfq3BMC/SfAV5Tye7wieU17VkZO08MCIh2u
         r7W0oOo4lwfhlVeMoeiKznszaFzh4unoLaPEcwyT5s7/rELHPpC5uIlZsRRONGgs9aF0
         6atYfxlJSfwUXrZXo4kSH9QxNUwE3yOArldb/1+BjRqS56mPUocvI5YnZlCn67l4bOCl
         Jh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDjZkRfpYrY5I/MR6Qn4PLWFtgP7s/Bq564G/WDROg8=;
        b=K4Lr/glSd+yMMRdx04kMG4+Rpm/MHxg2LKmGQC+3tao5yIhPVVtlHqbQrw8z2W9Fyc
         Vo0YOtQp8nUr+65v2a+RpvuAdoCpvLjhsrOg5utdWQpguAdsd7gZAi21euq1B8Sbfbzd
         mfsdez6NUkHr0jTrZ+EO7dSuehMJe9L42cUv1BG1K7idUp5ta72U7BAI+3zPeNHwXJxh
         tut+YRtkjXsldpSHus0+FK6zIG6w1aUO1HaNEHjjFUp2oxuhokSVLJdf82ZLD7jiNhAx
         xYyV+HxbhSCwjKKcZyR6ih1H6O7WaHX3BcvVIJhNVmlkXafE3TNYIj3o07mQI7vk8QSs
         0M9g==
X-Gm-Message-State: ANoB5pmcOIx4hVm/DKWNZK7mn16gSta/RdJEv6cpE+CyBG/9eCpQffN0
        fb8w070FPn6RvaqMSpq26nqdMQ==
X-Google-Smtp-Source: AA0mqf6K3vDrC0uZkJNyI9i4bspr18Xc3wQ9f3KL4neh3mJKaDF3CSz4f3mCXc4rH7HQpdqr59HPug==
X-Received: by 2002:aa7:c9d0:0:b0:458:ed79:ed5 with SMTP id i16-20020aa7c9d0000000b00458ed790ed5mr13691602edt.374.1669287311864;
        Thu, 24 Nov 2022 02:55:11 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x22-20020a1709064bd600b0078d3f96d293sm306881ejv.30.2022.11.24.02.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:55:11 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:55:09 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 5/9] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20221124105509.3kwnardcxvbbkf67@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-6-atishp@rivosinc.com>
 <20221101141329.j4qtvjf6kmqixt2r@kamzik>
 <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
 <CAOnJCUKpdV3u8X6BSC+-rhV0Q8q2tdsa8r_KTH5FWCh2LV2q8Q@mail.gmail.com>
 <20221123133636.gke3626aolfrnevy@kamzik>
 <CAOnJCULUH09HPZL6Ks-xUsiDLQPR6xOv2g+ic9Gd3uwea6hCyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCULUH09HPZL6Ks-xUsiDLQPR6xOv2g+ic9Gd3uwea6hCyQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 01:04:15AM -0800, Atish Patra wrote:
> On Wed, Nov 23, 2022 at 5:36 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > ...
> > > > > > -     csr_write(CSR_HCOUNTEREN, -1UL);
> > > > > > +     /* VS should access only TM bit. Everything else should trap */
> > > > > > +     csr_write(CSR_HCOUNTEREN, 0x02);
> > > > >
> > > > > This looks like something that should be broken out into a separate patch
> > > > > with a description of what happens now when guests try to access the newly
> > > > > trapping counter registers. We should probably also create a TM define.
> > > > >
> > > >
> > > > Done.
> > > >
> > >
> > > As we allow cycles & instret for host user space now [1], should we do the same
> > > for guests as well ? I would prefer not to but same user space
> > > software will start to break
> > > they will run inside a guest.
> > >
> > > https://lore.kernel.org/all/20220928131807.30386-1-palmer@rivosinc.com/
> > >
> >
> > Yeah, it seems like we should either forbid access to unprivileged users
> > or ensure the numbers include some random noise. For guests, a privileged
> > KVM userspace should need to explicitly request access for them, ensuring
> > that the creation of privileged guests is done by conscious choice.
> >
> 
> If I understand you correctly, you are suggesting we only enable TM
> bit in hcounteren ?

Yeah, and also that I think it'd be nice to revisit this for userspace.

> We also need a mechanism to enable the hcounteren bits from KVM guest userspace.
> 
> I can think of the following approaches.
> 
> 1. The CYCLE, INSTRET enabling can also be via one reg interface.
> 2. We can enable it during first virtual instruction trap if these
> bits in guest scounteren
> are enabled.

Those sound good to me.

Thanks,
drew
