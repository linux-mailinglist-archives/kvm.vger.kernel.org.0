Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD7635FA0
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbiKWNbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiKWNak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:30:40 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA3A85164
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:11:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso1268484wmo.1
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qO5DEzg9eRRuBV8jaHiQFeKu/GccCwk1qPJfoU46Cww=;
        b=CnW9K5MsY6Wf3jSh4utny6DqmahPNJagWfriIUNy/qkhQn32bRwL97MDUUxOZnePgy
         FNj9HyyK3YrOn4SJlbbd0p0tzEzvPBASXSZxdsEzqRQjbLbAoqwCmzTg3x+JE5kD3uF6
         OPIYScYRFaexia9m7Q+XiCf8wJJIOeuMu4BweOJRP5UCLo3sujWNFSCrgRP32HNL7hR/
         cytBZ4+TqETXckTFUcKymTjTCM60UNgWiTLFmJN1MweY3sagJKkpu9ODoHe1Yhp/k8+5
         NGpAK4e+LCmx96FgecBhWn1uOBVCA42nTf4wb/bMXvH8ndaqKyffyhmywl3KlYDCH3bI
         njxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qO5DEzg9eRRuBV8jaHiQFeKu/GccCwk1qPJfoU46Cww=;
        b=erPwSN/Rr6lITGINT5JyUobnec2ejp9BU4cLsdI4xWEqxxAVYJaf2q/hU/onfjjlzS
         31BCNS884D6e+p272LtF3ZdUoSF+qru/cvdWxkOERwRFtSeWzzSKtOMjcd6/A5IZltcS
         rc4Ig5ZBfJu3opq0ifjdj2XNchPKeOsytjzy3I/2p4zAi45ZzvutIXUg/DY0vDdAuyBc
         d3LMd7LltLIHW8Nh7OfwlYyxKzcRxz+KKNc09aaIxBuNlK9hiqcYvzLbCwjpFMST5ZwG
         Edevyg3E1vS1BazmlT416c3Cy/W3lIF73sHYpTU1LlC0E7HgvsbTyY1KSwo664sOSSsq
         tiwg==
X-Gm-Message-State: ANoB5pltps2V3gpasfCCDUKO/FagjWfUgZh5iPA0Y9L3e6Hxuy3QKt6v
        OgZkecpZqNhi7MPDFvEBk/OTBQ==
X-Google-Smtp-Source: AA0mqf76uYwMlzyOM+qud4kNA0YszPN/V2Rdqoq71qfx3tbuoZucNH9evqNJ+7NlMDTFJJOvHad5ug==
X-Received: by 2002:a05:600c:4f12:b0:3cf:e7bd:303a with SMTP id l18-20020a05600c4f1200b003cfe7bd303amr7157554wmq.151.1669209066243;
        Wed, 23 Nov 2022 05:11:06 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
        by smtp.gmail.com with ESMTPSA id dn14-20020a05600c654e00b003cf4d99fd2asm2372934wmb.6.2022.11.23.05.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:11:05 -0800 (PST)
Date:   Wed, 23 Nov 2022 14:11:04 +0100
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
Message-ID: <20221123131104.zglb3osa5tsgkkkb@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-6-atishp@rivosinc.com>
 <20221101141329.j4qtvjf6kmqixt2r@kamzik>
 <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 04:46:14PM -0800, Atish Patra wrote:
...
> > > +     kvpmu->num_hw_ctrs = num_hw_ctrs;
> > > +     kvpmu->num_fw_ctrs = num_fw_ctrs;
> >
> > Maybe it's coming later, but we need to give KVM userspace control over
> > the number of counters to allow it to migrate to a larger set of hosts.
> > Also, a previous patch said the virtual width must be the same as the
> > host width for the hw counters, so we need userspace to know what that
> > is in order to determine to which hosts it can migrate a guest.
> >
> 
> Yes. The entire user space access control needs to be sketched out.
> We probably need another one reg interface to set/get the number of
> counters/width.
> 
> However, Is it a common to migrate a guest between different hosts
> with different PMU capabilities ?
>

Ideally we'd be able to define a virtual CPU+PMU which represents the
least common denominator of a set of hosts, allowing VMs which use that
VCPU model to migrate among all the hosts. x86 pulls this off pretty well,
but arm64 doesn't. In the least, I think a goal should be to enable
migration of VMs from hosts with less extensions and less PMU counters to
hosts with more, as that would support host upgrades without having to
recreate VMs.

Thanks,
drew
