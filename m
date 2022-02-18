Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C6A4BB03E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 04:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiBRDaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 22:30:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiBRDaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 22:30:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5830824CCFA
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645155007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xw1y3Y5GPRCwK2rI9bTbjDesNaxerF8C/bHkJsfOTuA=;
        b=cEAP8FvstiLq8QWzktvEmuHdWGw8zfUNGiNxeJqVMjqvEafkFRJsCVn5ZTZoTx//wFHHhn
        sRJSrPVm3M02UmdFzQmnRFTKZxer/ISI3k1XcnsMtLHamwSBJlz7msO/v4tBNqToyL4wLN
        cPvl+jMNcnZT1AgnKYo+sgpcqop4zLE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-2GN_6dgBMaKWL_YN4wM4ZQ-1; Thu, 17 Feb 2022 22:30:06 -0500
X-MC-Unique: 2GN_6dgBMaKWL_YN4wM4ZQ-1
Received: by mail-lj1-f197.google.com with SMTP id m7-20020a2ea587000000b00244e2faf769so885878ljp.6
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xw1y3Y5GPRCwK2rI9bTbjDesNaxerF8C/bHkJsfOTuA=;
        b=EmA5/PwzvHQV7fp9/ChTrh/h8w8+Q2WVJFNnRm3M0Q7PI9NPARA7UfNVrUPfTzZG6n
         zUDIqTwaxVRHgLfcYC57DrXcqTdCmnuzPuW30HiK8IDf5fzNDreX42Ur79bwz6Y5p2jN
         E2XMoqwwD018ZdEDj+6q+hjVuNwfSdKqtqh02/V29zYTt58Ck+Gv5iKk+lDibh/Jn4bC
         4bT7wgvX+RQM6CuNQ3F9JI7ed1/ZTdjd7NMKY+P37O4cff6HcS5JDkknQKzCRH10XePe
         7dgpE40eRX33SHCoFMXCBQmUfmpSAkoCCvuFz+SRLe5WqOnzQMAecmF1HEDYRkfTXHQp
         0Jjw==
X-Gm-Message-State: AOAM533dfe4A3/zhRHX2wRSYdpRvrFF6AXiTl31phBc1LqPlwhyWvcMO
        a0gIyZEMl6fLlK1ZkkUEVFXTYdQeugOg6uYSmhlPmlbydUPIOaMimcbfxEb0zKId7eM31mCgVKb
        QiuaHHjMsP07Hbu699PVa4Oxlqcuf
X-Received: by 2002:a05:651c:1503:b0:244:c075:2103 with SMTP id e3-20020a05651c150300b00244c0752103mr4202674ljf.442.1645155004395;
        Thu, 17 Feb 2022 19:30:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyejGMEtWkyn6W71CB9p5OTwh3dJs2451OPm9Aq1+yMQjKQj60w3RpTpKWyBkodwBdc1PimqudPInpgYBGqV64=
X-Received: by 2002:a05:651c:1503:b0:244:c075:2103 with SMTP id
 e3-20020a05651c150300b00244c0752103mr4202668ljf.442.1645155004132; Thu, 17
 Feb 2022 19:30:04 -0800 (PST)
MIME-Version: 1.0
References: <202202180700.dnGoHs4Z-lkp@intel.com>
In-Reply-To: <202202180700.dnGoHs4Z-lkp@intel.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Fri, 18 Feb 2022 00:29:53 -0300
Message-ID: <CAJ6HWG6UHo+PBZnPhWhhXpy6ix5b-o+OcD20ARpAy3nfWoznig@mail.gmail.com>
Subject: Re: [kvm:master 22/22] arch/x86/kvm/x86.c:992:19: error: unused
 function 'kvm_guest_supported_xfd'
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Thu, Feb 17, 2022 at 8:13 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
> head:   988896bb61827345c6d074dd5f2af1b7b008193f
> commit: 988896bb61827345c6d074dd5f2af1b7b008193f [22/22] x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0
> config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220218/202202180700.dnGoHs4Z-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=988896bb61827345c6d074dd5f2af1b7b008193f
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm master
>         git checkout 988896bb61827345c6d074dd5f2af1b7b008193f
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> arch/x86/kvm/x86.c:992:19: error: unused function 'kvm_guest_supported_xfd' [-Werror,-Wunused-function]
>    static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)

It seems to fail under "non-x86_64" x86 configs, since
kvm_guest_supported_xfd()  is called only in x86_64 code.

I will send a new version for this patchset only, incorporating the
ifdefs in this function.
Rationale:
If MSR_IA32_XFD and MSR_IA32_XFD_ERR are in x86_64-only code, it only
makes sense that XFD is an x86_64 only feature.

>                      ^
>    arch/x86/kvm/x86.c:2364:19: error: unused function 'gtod_is_based_on_tsc' [-Werror,-Wunused-function]
>    static inline int gtod_is_based_on_tsc(int mode)
>                      ^
>    2 errors generated.

The same thing happens for this one (which is unrelated to my
patchset), but will require the same fix.
I will send an additional patch fixing this one also.

Is that ok?

Best regards,
Leo

