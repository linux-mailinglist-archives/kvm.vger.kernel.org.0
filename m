Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9510037626A
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 10:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhEGIxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 04:53:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231906AbhEGIxa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 04:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620377550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kk51ztpoBo8Zvuxk9OuoeLtIDzxLHuq4PIJWw7SMpro=;
        b=jTfoq8LRernkd2qYblxMt2LcGtwaW86j9hwLynnjDeFMq7JnypuGAPloLI0sWf35I1WcXx
        zHSsTv5aF0yhfJcFfhfmrtPyPeYOnz1cMg5F3L0LTBV2vV+0+NpaP+zDyKNehL56qj6auP
        JTkZQldLApQI+it9bzo7gjfCqkTj2Hg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-J9ECXxWwNHCfoS3eJsp0Pg-1; Fri, 07 May 2021 04:52:27 -0400
X-MC-Unique: J9ECXxWwNHCfoS3eJsp0Pg-1
Received: by mail-wr1-f71.google.com with SMTP id 4-20020adf91840000b029010d9c088599so3302255wri.10
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 01:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kk51ztpoBo8Zvuxk9OuoeLtIDzxLHuq4PIJWw7SMpro=;
        b=UBq/oYXMg0yr2YT6IpUpee+J2uHYxKF7YDh+8+1uWZho9gfxzEE1ZHcMzUPGs1BgfU
         28Cb4IidMKOXBGG6OZWh0bICVhnNV8nk7SzSojhHfwOiqVMpuDg/lXm02aFltIzH4cV1
         JiJnJJM2I9AKUb9GK5lwzKR+ISQFdzjJUTfLs7dtSW3jgUPPo+Y8ill1M9luSwE7Zrr3
         VcjTAaqZcqJzI2nBhbuSXTxH1LJBEwPY6NfWj4OCSlUQMndm/Zd4NRdg+vJvr0HC7Tzo
         +ySYbaaOJ6nIx+Cm1It94zolo2tBKuv0lz7CiYMzeZJ9Ivx/ISs10wOC1r8Q9WwFVJSl
         rCpg==
X-Gm-Message-State: AOAM5314OpPfqeMHXjdzlB5Lah+CKPsvkgl0PnfiLJMAsEkfTAj0zkAw
        tfQlT625M73zQCHvMRkgdCl9bjJBrWmqEJ9ycaJZQ0OHGzh9ssmBsU8gCmo6dVRPHmbe1KMKImN
        9x9G+myENKKUd
X-Received: by 2002:adf:cd06:: with SMTP id w6mr10724171wrm.93.1620377546892;
        Fri, 07 May 2021 01:52:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8NUi0XxZzefIeXt1PapQXTeV91tOCHaHhl9MTITyV5W/oYaino3SMQ2F5ksLu1/6OeQqhvA==
X-Received: by 2002:adf:cd06:: with SMTP id w6mr10724160wrm.93.1620377546768;
        Fri, 07 May 2021 01:52:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i3sm8908664wrb.46.2021.05.07.01.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:52:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: Re: [kvm:queue 11/44] arch/x86/kernel/kvm.c:672:2: error: implicit
 declaration of function 'kvm_guest_cpu_offline'
In-Reply-To: <e671b62d-0324-2835-2726-6b28a0202b7a@redhat.com>
References: <202105070840.f1TZQ4rC-lkp@intel.com>
 <e671b62d-0324-2835-2726-6b28a0202b7a@redhat.com>
Date:   Fri, 07 May 2021 10:52:25 +0200
Message-ID: <87v97vvsc6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 07/05/21 02:13, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
>> head:   c6d517aecd40b25ea05c593962b2c4b085092343
>> commit: 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc [11/44] x86/kvm: Teardown PV features on boot CPU as well
>> config: x86_64-randconfig-a001-20210506 (attached as .config)
>> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 8f5a2a5836cc8e4c1def2bdeb022e7b496623439)
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # install x86_64 cross compiling tool for clang build
>>          # apt-get install binutils-x86-64-linux-gnu
>>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>>          git fetch --no-tags kvm queue
>>          git checkout 9140e381e0f2f8cb1c628c29730ece2a52cb4cbc
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=x86_64
>> 
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>
> kvm_guest_cpu_offline must be placed outside #ifdef CONFIG_SMP.  

... and kvm_guest_cpu_online() too.

> I fixed  it up.
>

Thanks!

-- 
Vitaly

