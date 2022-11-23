Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65D7636053
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbiKWNrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238919AbiKWNrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:47:22 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEA6101DE
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:36:39 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso1302144wms.4
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hMgYAJPhRyqpy0UXUjrB3ea5pmGtcKs5Fqde6i7Nj3I=;
        b=SW/c4hJbN8TTlANr3vNJK5slrOe41QSdJUahynWVeaw6FftkA/D1M969Dg4QQXXFV6
         GR2ncUeFn5gUnpSLm6ukuUfqPRt8Ca4GwFzVx9Kdzq5hv9btgU1O4mgNhNWS120gfd4E
         hzaahcWhaeXT2YCmHJla7yl6H+7EiZUPOEHwDL2bfk0rgRD23d+NsVTa20B/jl47MT0K
         ibpDPRWjVRGb0nAkvvNu8cHQ10x6ukbxL0Ju/cGV7YIkfjWS3aFRog5lEI72USAC78W/
         Z9tLCNOjeOpkptob1pUoV036dzwMl4nLBstCpxxDpTnNFL8FxohNFTje5WAaqKKOv9Bn
         GBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMgYAJPhRyqpy0UXUjrB3ea5pmGtcKs5Fqde6i7Nj3I=;
        b=1oCQpZObRistol8PxNBnrrEISRoxz0gQPXowy/tcvxogSB+4R5zTG21FNp9CQfiUQV
         YbQf9RsZNfUwrMFeEDF0ov59H+GH2zMdT7508XKmnN6i4aN7QyF/Oa67dJIanFECbeHi
         qW2RXEH6p5CloXzgARk6eFx5XR3GoqPl1JXMHP3xl+qOcwhh5le49UeKPw0P/8Bh78bT
         1HPYMs5v85HQx2Tizv52Rpkc9ucP+IRWLMoHP14J4W6ZCC7fTXTfzOWauvKULeSLuTRx
         1bjHaduIPJK7A6Ec9DwjK1L302JJQvq2nP6e543Ysbkuj2+VxjrwkzgHs88uH8aYrFYu
         roPw==
X-Gm-Message-State: ANoB5pkWqpK2jhuY3AHI1Jx1I9A5Thur4ZOwxcju8CZj+Wzsn4UbkKK4
        cidiMV1v7qIm2A/eDXOZoXzMNg==
X-Google-Smtp-Source: AA0mqf53LRFa5Bbp5he9If0mv7pYNlmgIJ7+W+KuA3BYsVtGKFjDhkCi0Sb0k6NCu1LaVjh9Ww7qBw==
X-Received: by 2002:a05:600c:1ca4:b0:3cf:7125:fc1d with SMTP id k36-20020a05600c1ca400b003cf7125fc1dmr6594039wms.70.1669210598097;
        Wed, 23 Nov 2022 05:36:38 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c315100b003cf483ee8e0sm2511573wmo.24.2022.11.23.05.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:36:37 -0800 (PST)
Date:   Wed, 23 Nov 2022 14:36:36 +0100
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
Message-ID: <20221123133636.gke3626aolfrnevy@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-6-atishp@rivosinc.com>
 <20221101141329.j4qtvjf6kmqixt2r@kamzik>
 <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
 <CAOnJCUKpdV3u8X6BSC+-rhV0Q8q2tdsa8r_KTH5FWCh2LV2q8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUKpdV3u8X6BSC+-rhV0Q8q2tdsa8r_KTH5FWCh2LV2q8Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

...
> > > > -     csr_write(CSR_HCOUNTEREN, -1UL);
> > > > +     /* VS should access only TM bit. Everything else should trap */
> > > > +     csr_write(CSR_HCOUNTEREN, 0x02);
> > >
> > > This looks like something that should be broken out into a separate patch
> > > with a description of what happens now when guests try to access the newly
> > > trapping counter registers. We should probably also create a TM define.
> > >
> >
> > Done.
> >
> 
> As we allow cycles & instret for host user space now [1], should we do the same
> for guests as well ? I would prefer not to but same user space
> software will start to break
> they will run inside a guest.
> 
> https://lore.kernel.org/all/20220928131807.30386-1-palmer@rivosinc.com/
>

Yeah, it seems like we should either forbid access to unprivileged users
or ensure the numbers include some random noise. For guests, a privileged
KVM userspace should need to explicitly request access for them, ensuring
that the creation of privileged guests is done by conscious choice.

Thanks,
drew
