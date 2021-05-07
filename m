Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC6C37615A
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbhEGHpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:45:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231165AbhEGHpq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AzHD+mIX/ZO5hVREmfYA68VAf490QyrXZtGAVC/kOM=;
        b=YKejhakt5IDRuJ5pP3ubY+6zssGTW+/3dcpLu4cNgnR/IycYkqVG7EJSBj9TOHn4S1Av6X
        sRFWa/YWDDsbDv6DWyNAEKRA1Z7klkd1ryrn5PwjeZnO64T5IBp7ATXHBBUgh5RsYf69VT
        kcC/5il+gzn9u0aTW5h1Fy5ugOOVj3w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-kv0MdnPTPZ6IljH3tYphvw-1; Fri, 07 May 2021 03:44:44 -0400
X-MC-Unique: kv0MdnPTPZ6IljH3tYphvw-1
Received: by mail-ej1-f71.google.com with SMTP id w2-20020a1709062f82b0290378745f26d5so2652703eji.6
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2AzHD+mIX/ZO5hVREmfYA68VAf490QyrXZtGAVC/kOM=;
        b=iT6CiBNe2kpEgyd5akaB6Icw9mXldUu8I+HxtDbvJjN9wrWq3Apcy8ZiUAgt8fVYZj
         aufwi3NZ0ReMkkthoiSYwLqGSFKiI28SL++MmTcFbXN7Rp7qJ41hohJ7QJQAMS2l9S/u
         KWiiOAyRthoz+hz6+565hihyHUBepSrXeooE4Ibd2knyWpP56fLgz2qFgW+sXwM+oR+B
         46v4MiKCVBIOfDnJNNpTQdr6SEonHcq8I1GLjWuK7WHU5KNa2HXfon9Gr5ZwRI+aHc+z
         ETUSD0Ktg6ihPoFvccXLVfWt/bLQFyxnh2OtE0goTBi9pWqwzQNZuqsTXypH8wKUhKma
         ECBQ==
X-Gm-Message-State: AOAM5322HTO7XhDLWiaHtT8MuiV0SZKtv2aXMixbKPbvsiaz+A5hoxUg
        dU+Qgtts7vfZExb632h+yid8gi23MgWZM/c5FnX07baIltMuEbNvpaGPyKZR2v9ez2lSA6KH+Xu
        UNv3c6PQP41hG
X-Received: by 2002:a17:906:270a:: with SMTP id z10mr8366865ejc.204.1620373482885;
        Fri, 07 May 2021 00:44:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrHYChoRh6PU4Ww0EjZj5mIN8mZ9JJJDr1JHotMaiY/gnOK9+ycDQry9whFHdEmo/KzVd50Q==
X-Received: by 2002:a17:906:270a:: with SMTP id z10mr8366856ejc.204.1620373482717;
        Fri, 07 May 2021 00:44:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r17sm3596059edt.33.2021.05.07.00.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:44:42 -0700 (PDT)
Subject: Re: [kvm:queue 11/44] arch/x86/kernel/kvm.c:672:2: error: implicit
 declaration of function 'kvm_guest_cpu_offline'
To:     kernel test robot <lkp@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <202105070840.f1TZQ4rC-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e671b62d-0324-2835-2726-6b28a0202b7a@redhat.com>
Date:   Fri, 7 May 2021 09:44:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <202105070840.f1TZQ4rC-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/21 02:13, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   c6d517aecd40b25ea05c593962b2c4b085092343
> commit: 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc [11/44] x86/kvm: Teardown PV features on boot CPU as well
> config: x86_64-randconfig-a001-20210506 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 8f5a2a5836cc8e4c1def2bdeb022e7b496623439)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install x86_64 cross compiling tool for clang build
>          # apt-get install binutils-x86-64-linux-gnu
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>          git fetch --no-tags kvm queue
>          git checkout 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

kvm_guest_cpu_offline must be placed outside #ifdef CONFIG_SMP.  I fixed 
it up.

Paolo

> 
> All errors (new ones prefixed by >>):
> 
>>> arch/x86/kernel/kvm.c:672:2: error: implicit declaration of function 'kvm_guest_cpu_offline' [-Werror,-Wimplicit-function-declaration]
>             kvm_guest_cpu_offline();
>             ^
>     arch/x86/kernel/kvm.c:672:2: note: did you mean 'kvm_guest_cpu_init'?
>     arch/x86/kernel/kvm.c:332:13: note: 'kvm_guest_cpu_init' declared here
>     static void kvm_guest_cpu_init(void)
>                 ^
>>> arch/x86/kernel/kvm.c:679:2: error: implicit declaration of function 'kvm_cpu_online' [-Werror,-Wimplicit-function-declaration]
>             kvm_cpu_online(raw_smp_processor_id());
>             ^
>     2 errors generated.
> 
> 
> vim +/kvm_guest_cpu_offline +672 arch/x86/kernel/kvm.c
> 
>     669	
>     670	static int kvm_suspend(void)
>     671	{
>   > 672		kvm_guest_cpu_offline();
>     673	
>     674		return 0;
>     675	}
>     676	
>     677	static void kvm_resume(void)
>     678	{
>   > 679		kvm_cpu_online(raw_smp_processor_id());
>     680	}
>     681	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

