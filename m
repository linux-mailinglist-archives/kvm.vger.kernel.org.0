Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E253534FA
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhDCRnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Apr 2021 13:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbhDCRnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Apr 2021 13:43:09 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B236C061794
        for <kvm@vger.kernel.org>; Sat,  3 Apr 2021 10:43:06 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id c6so7136306lji.8
        for <kvm@vger.kernel.org>; Sat, 03 Apr 2021 10:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/IBHWY9KNBBG6nCdTgxJNzHRop44ReYjl5lJIYYJHDQ=;
        b=EfS5LLvX3kU4+qQlEroXp84UFgM7EjtkSw2FfILegRS42vivBkZ7RR2MoGlv8+dRbi
         1acuh9KHT7n9AFDUVT3Q0qHd8a7twsus/RwsjzQ2PyhI54fauvY2FBUy3lzoJhSc8VYp
         G8Cju+PDs14tS1te2kd1HiHMw4cfxrb3XHTaCXx0Zpq3Xd/Pa4C5k8D7a4hCclp5vyxs
         3BQpos0LsADLfyv2xTDioRz/bsdv6Jnd/a54wdHR9p/37YCw58vQrjsm/M7Ao40eS6Ml
         Xsp3JsuzxNKH9s/jCWOQcApw1S/ksfxwA6FUq23rvEfMMgJ1VSIQTBdB8l2r2WWTrtH0
         wmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/IBHWY9KNBBG6nCdTgxJNzHRop44ReYjl5lJIYYJHDQ=;
        b=tC7EQ+GYCK9gQVS1u3R973JG+k230TBGuMzi38/lqMwl6V90QCcKntcsfL91Izl4wD
         TqiX84qikCCXsFUHcFccCk6Y9dYciaoK2jTqIbC75/2/9IRYz5cAdVsk3dibH5I3zXfH
         Nm8QPdT1PW9l54E8O7sYJDDMg53pYSmh6wG5jwKZWUZySvHVhOOQCPL04BjXtJ2gclhj
         fCIHCD3IP4FnZG8UY5wDC1fXvhw6x8Z1GwjMN46YgvnGJzvqT+a7dxtNqu7u6PKJ0k61
         3TbNnjzP7vzn0CBYqPVjIeX3eqHlIWPxw/STVTag3GIcixsQr6OE2lwhyq/BWnhXifPp
         hLXw==
X-Gm-Message-State: AOAM530G1ujTkuETziOSfaKjXLb8bwCZHXYNoeCpazD3BKo9WsbrM89a
        ZMpcz6It5TY0ocDYrO4CENMSHADLVCjDcfpYazMhWw==
X-Google-Smtp-Source: ABdhPJxEjp5gonu+hQHB4Abduquvh78zo5GomYM0ev+L22zJaVtT8zAODonDrRhIx1y/0PA+aUruMV2Qf67ktMgTwEk=
X-Received: by 2002:a2e:9907:: with SMTP id v7mr11657200lji.256.1617471784580;
 Sat, 03 Apr 2021 10:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210402224359.2297157-3-jingzhangos@google.com> <202104031344.oNE1vaQq-lkp@intel.com>
In-Reply-To: <202104031344.oNE1vaQq-lkp@intel.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Sat, 3 Apr 2021 12:42:52 -0500
Message-ID: <CAAdAUthtA8K1bpB1W4pm+Bgi10JokPi=Q_tv037qMu7+5b9N6Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: stats: Add fd-based API to read binary stats data
To:     kernel test robot <lkp@intel.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 3, 2021 at 12:25 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Jing,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on f96be2deac9bca3ef5a2b0b66b71fcef8bad586d]
>
> url:    https://github.com/0day-ci/linux/commits/Jing-Zhang/KVM-statistics-data-fd-based-binary-interface/20210403-064555
> base:   f96be2deac9bca3ef5a2b0b66b71fcef8bad586d
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> cocci warnings: (new ones prefixed by >>)
> >> arch/x86/kvm/x86.c:270:36-37: WARNING: Use ARRAY_SIZE
>    arch/x86/kvm/x86.c:235:34-35: WARNING: Use ARRAY_SIZE
>
> vim +270 arch/x86/kvm/x86.c
>
>    267
>    268  struct _kvm_stats_header kvm_vcpu_stats_header = {
>    269          .name_size = KVM_STATS_NAME_LEN,
>  > 270          .count = sizeof(kvm_vcpu_stats_desc) / sizeof(struct _kvm_stats_desc),
Thanks, will do.
>    271          .desc_offset = sizeof(struct kvm_stats_header),
>    272          .data_offset = sizeof(struct kvm_stats_header) +
>    273                  sizeof(kvm_vcpu_stats_desc),
>    274  };
>    275
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
