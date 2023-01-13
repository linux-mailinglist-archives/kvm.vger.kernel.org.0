Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D66669CC2
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjAMPrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjAMPqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:46:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B1E9087F
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673624202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I700DdA5+87CqalrCgVe0wgjpImXv87ud6g5vJ4qa4U=;
        b=XtZkmSOm7mAheFiANi2xeNLMzlTPZyVPXg0pSVZpvmdyFs9hXPnXUN4hG3d80kwBOLMg8e
        88PNlZwqcfKXcoE5Q2Pdl2/duMR4ogu2Vebl8Aqwn53zVsOI+klxpmCxbBUcITbq5pGDNp
        Xhb9YgaFth+yhe0G0tLnHKVg5ZPPdOE=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-280-A2qFQDunPIilL8Plcjwrwg-1; Fri, 13 Jan 2023 10:36:41 -0500
X-MC-Unique: A2qFQDunPIilL8Plcjwrwg-1
Received: by mail-ua1-f71.google.com with SMTP id l42-20020ab0166d000000b00445260e9ad6so9528206uae.13
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I700DdA5+87CqalrCgVe0wgjpImXv87ud6g5vJ4qa4U=;
        b=h+djfse8CMoDAdnDsb7UbY30o2c8Gka1kgr5SoFKjyHNF20vi3+hV63yzTJjymMaAg
         eawMGMxVPflYuZscSJna53u136rBbMg1ncU51af2WAHncT+/W13PMQVK7qwkfw/EFryR
         LfBfIg7JEZtMVv350QrZK7uzOvQ/c4Oktns2dNq5tOkatMFiFp+E6ihvFQRe/xIOZw3J
         d2sHEuqpgDdo5lmXSCDyge9ykZezfLviPbV0TLzh1aiwVVhdqgWeaqOKsvZw4YnIi6dQ
         FCa2BekPzuDd3gfeITcmlayJXnL+eb/cTsyHcLFSV5RUPKfF98x6TE/oEZRY3TqUKPkl
         BUPg==
X-Gm-Message-State: AFqh2kpSpBnIucJ2cgWM/X7tRUiVoPBKeSPze++ukQ2odBY66Tr+yHyH
        EJVbuXZSXfOsWRCCYIELNWNaSjQpYrUO5cPajVcIoM1qGzNy4nfr6U4eIgzSGWTLOxcTAJYOeti
        lEmJYt9vaI+HiJXK3fnqjtL6ZPwxg
X-Received: by 2002:a05:6122:e20:b0:3dd:f386:1bca with SMTP id bk32-20020a0561220e2000b003ddf3861bcamr108734vkb.33.1673624199263;
        Fri, 13 Jan 2023 07:36:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsTcquavVHh2LGJon70r35hTGFJQHVvioXxV5viax0L+CXfJlSCxa4WETUFcgzBaSXMtuGTn7XNGrboTMumTbM=
X-Received: by 2002:a05:6122:e20:b0:3dd:f386:1bca with SMTP id
 bk32-20020a0561220e2000b003ddf3861bcamr108726vkb.33.1673624199039; Fri, 13
 Jan 2023 07:36:39 -0800 (PST)
MIME-Version: 1.0
References: <202301062107.EPkAEoe2-lkp@intel.com>
In-Reply-To: <202301062107.EPkAEoe2-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 13 Jan 2023 16:36:27 +0100
Message-ID: <CABgObfZQC3qaiKqLifcfiPoRPrqti3A16G-hyvmFW2F3TvFNnA@mail.gmail.com>
Subject: Re: [kvm:queue 121/153] arch/arm64/kvm/arm.c:2211: warning: expecting
 prototype for Initialize Hyp(). Prototype was for kvm_arm_init() instead
To:     kernel test robot <lkp@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 6, 2023 at 2:52 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   91dc252b0dbb6879e4067f614df1e397fec532a1
> commit: db139c0c865d775b19709cc4671e2e611815e575 [121/153] KVM: arm64: Do arm/arch initialization without bouncing through kvm_init()
> config: arm64-randconfig-r022-20230106
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 8d9828ef5aa9688500657d36cd2aefbe12bbd162)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=db139c0c865d775b19709cc4671e2e611815e575
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout db139c0c865d775b19709cc4671e2e611815e575
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/kvm/ drivers/gpu/drm/mxsfb/ drivers/gpu/drm/udl/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    arch/arm64/kvm/arm.c:133: warning: Function parameter or member 'type' not described in 'kvm_arch_init_vm'
>    arch/arm64/kvm/arm.c:1933: warning: expecting prototype for Inits Hyp(). Prototype was for init_hyp_mode() instead
> >> arch/arm64/kvm/arm.c:2211: warning: expecting prototype for Initialize Hyp(). Prototype was for kvm_arm_init() instead

Ok, this is just a "/**" comment where one ought to have just "/*" instead.

Paolo

