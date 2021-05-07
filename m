Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2D0376214
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 10:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhEGIeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 04:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231675AbhEGIeF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 04:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620376386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EeKZB0wqiajbVNAhTf1/l9rORSNICeHE6bPmOq5humM=;
        b=LFb38bijBApQ/x9nHTf1FeDFdPArebNECPyz6Hgc4EsJjclo27E2bVs0RX6LGmsCb2X72E
        uEgrQp8Ug+NztAacpGRBRrrehnoE8Wm3tn/YUShAD4jhOB4Mobare527qgWggMfe4+EmaK
        rQnbDpzz4Vtucd1jeo8d9MLbo30I++s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-gc3ulAPMPPKLVi14UIJvHQ-1; Fri, 07 May 2021 04:33:04 -0400
X-MC-Unique: gc3ulAPMPPKLVi14UIJvHQ-1
Received: by mail-wr1-f70.google.com with SMTP id p19-20020adfc3930000b029010e10128a04so3260572wrf.3
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 01:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EeKZB0wqiajbVNAhTf1/l9rORSNICeHE6bPmOq5humM=;
        b=hfT1bchp4W9zsLdJjboJ09Qj4A+ICLv5MatHhLyxCRGxZKYLHQtdJbkk6803HK+mX1
         kg0h3gHzrSxvvFeeh9n/Bhey7d6bCfdWNaWr9jiAj5ipiFpuV5Ng4hAVo05pcn+bokiC
         cNPXaim76uEcMTbv1oaP4mTX+HTkJRaqJkDxx0+3uZqBK1Rk5fwDCkZOQado/mOvuVF5
         /x6Fd7J7q5c2diqQmRi+kyZoZKXSqr4Y9mPOEIJpvLOFJmQNJmYLsQ0oARelW8sz2pf1
         S0Sj+WOd8fTJMyVqiWDwpazdXNy53dxYIsU685FMgzeIjfx/ix6kKot0S4Tdf6lEqQMe
         Dx/w==
X-Gm-Message-State: AOAM530ltBVeDYOSfFW1ZqQgcF4E62rT0sX8pDveA0zumJIFPkiXMnBQ
        W48sfT6eg3AdYH355D1+5sJzGlX9MIHv0g5UCqXt+uWrEwPsHgKDj01kYQemPpRB8jV1PgqqHPT
        Yg0QZ6pHqmH3X
X-Received: by 2002:a5d:6e06:: with SMTP id h6mr10664769wrz.201.1620376382847;
        Fri, 07 May 2021 01:33:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOOIBygUel12ScIg4AxeDnaFGRN+6RY4lqDgXmi4mTTJRIDud/TlW8RGqKZVxAFGfisDqt+w==
X-Received: by 2002:a5d:6e06:: with SMTP id h6mr10664740wrz.201.1620376382609;
        Fri, 07 May 2021 01:33:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y21sm12701163wmc.46.2021.05.07.01.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:33:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 11/44] arch/x86/kernel/kvm.c:672:2: error: implicit
 declaration of function 'kvm_guest_cpu_offline'; did you mean
 'kvm_guest_cpu_init'?
In-Reply-To: <202105070437.l17T7fhB-lkp@intel.com>
References: <202105070437.l17T7fhB-lkp@intel.com>
Date:   Fri, 07 May 2021 10:33:01 +0200
Message-ID: <87y2crvt8i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   c6d517aecd40b25ea05c593962b2c4b085092343
> commit: 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc [11/44] x86/kvm: Teardown PV features on boot CPU as well
> config: x86_64-randconfig-c022-20210506 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>         # save the attached .config to linux build tree
>         make W=1 W=1 ARCH=x86_64 
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arch/x86/kernel/kvm.c: In function 'kvm_suspend':
>>> arch/x86/kernel/kvm.c:672:2: error: implicit declaration of function 'kvm_guest_cpu_offline'; did you mean 'kvm_guest_cpu_init'? [-Werror=implicit-function-declaration]
>      672 |  kvm_guest_cpu_offline();
>          |  ^~~~~~~~~~~~~~~~~~~~~
>          |  kvm_guest_cpu_init
>    arch/x86/kernel/kvm.c: In function 'kvm_resume':
>>> arch/x86/kernel/kvm.c:679:2: error: implicit declaration of function 'kvm_cpu_online'; did you mean 'irq_cpu_online'? [-Werror=implicit-function-declaration]
>      679 |  kvm_cpu_online(raw_smp_processor_id());
>          |  ^~~~~~~~~~~~~~
>          |  irq_cpu_online
>    cc1: some warnings being treated as errors
>


Oh well, we just need a quantum PC and something like 
'make allpossibleconfig' to make issues like this one go away forever
:-)

I'm on it, soemthing needs to be done for !CONFIG_SMP case.


-- 
Vitaly

