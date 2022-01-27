Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB59649DC39
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 09:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiA0II4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 03:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiA0IIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 03:08:55 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61485C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 00:08:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so6790454pjj.4
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 00:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ukAePQcf9i0MGvA93UEEE3eWPNIcxKo3bKjwJk0vYgM=;
        b=Uhb7uzZ89NE6F6e1HJRS7fnGaaQhKXxyGA8iLxQ1f4pkmT6lEVYQGyAWlnj9IsOg1Z
         Vq49UNsdGuu8baiVUxA81oAmTS9IsBmLKwBw+lzG6qsd+U/J5bgClivPd1GPej9I17s2
         g6RNa3yx97npsN0+i4gHsMW2oh3e3cPFhO9iDDwJeT7PGvhoG4FvV8/E9JuOYicgntZJ
         UJAROeZIntKfGiPilraLq+P7tPd9uljJO9+Qq1ccTYMLIrox6d1rCfi/2jjLlj4K7K6s
         HnTz9SvUKQAm5GXu+o5si0Q+ranoqohtM2M4dAnEOHirT07aYurd1WNbKQt+yMJtlPsG
         oYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ukAePQcf9i0MGvA93UEEE3eWPNIcxKo3bKjwJk0vYgM=;
        b=Tev6cVLMDq/0hdqsy8TaUh9xjIS/SqfYj4GsdHuddaZDgHh8440Urvs9S6jAbzYmfI
         9zSP2oaz5aP2KJHP1gMQvjPgWiIZcSqp+9c4jcidQ+lGuuqKlbqcj+CJLC+FNGKbwIGC
         gnvZ0YYmd9BU+Z0HIun6Gx4PtUAK/Y4viemAF4nbay0qV043B4mml8gTcy0oZDPAmL1N
         Vu3NcW4BJ6uqPYgxB/JUGkf/L8RExseqvZZ7s0wM1jKJkIrtRpG20scejXzRvfn5ABTQ
         2yA3p14ypjI1nrKUiz0vdifbeFgDrATYwvWcyGgPGpbzdfXiGshyg1aA87VMWSBWebft
         yBhQ==
X-Gm-Message-State: AOAM531KhhnZuS9Kuf25Qh1X4Nz9qjufiRYtO9D5T4g1IRenlIlUoKcd
        7o3F0S82xc5UMlCVzy1SXAA=
X-Google-Smtp-Source: ABdhPJyduXrHWfK1hAI5gdVlTBM1OhGiL6kjUZduDacN/AeT3oWCQmpCNeRPUJ9CTWGtutYvocOklA==
X-Received: by 2002:a17:90b:4b88:: with SMTP id lr8mr12890029pjb.166.1643270934215;
        Thu, 27 Jan 2022 00:08:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p42sm4501760pfw.71.2022.01.27.00.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 00:08:53 -0800 (PST)
Message-ID: <32f14a72-456d-b213-80c5-5d729b829c90@gmail.com>
Date:   Thu, 27 Jan 2022 16:08:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [kvm:queue 305/328] arch/x86/kvm/x86.c:4345:32: warning: cast to
 pointer from integer of different size
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        kernel test robot <lkp@intel.com>
References: <202201270930.LTyNaecg-lkp@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <202201270930.LTyNaecg-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/1/2022 9:52 am, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   b029c138e8f090f5cb9ba77ef20509f903ef0004
> commit: db9556a4eb6b43313cee57abcbbbad01f2708baa [305/328] KVM: x86: add system attribute to retrieve full set of supported xsave states
> config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220127/202201270930.LTyNaecg-lkp@intel.com/config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=db9556a4eb6b43313cee57abcbbbad01f2708baa
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>          git fetch --no-tags kvm queue
>          git checkout db9556a4eb6b43313cee57abcbbbad01f2708baa
>          # save the config file to linux build tree
>          mkdir build_dir
>          make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>     In file included from include/linux/uaccess.h:11,
>                      from include/linux/sched/task.h:11,
>                      from include/linux/sched/signal.h:9,
>                      from include/linux/rcuwait.h:6,
>                      from include/linux/percpu-rwsem.h:7,
>                      from include/linux/fs.h:33,
>                      from include/linux/huge_mm.h:8,
>                      from include/linux/mm.h:717,
>                      from include/linux/kvm_host.h:16,
>                      from arch/x86/kvm/x86.c:19:
>     arch/x86/kvm/x86.c: In function 'kvm_x86_dev_get_attr':
>>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |                                ^

Similar to kvm_arch_tsc_{s,g}et_attr(), how about this fix:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8033eca6f..6d4e961d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4342,7 +4342,7 @@ static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)

         switch (attr->attr) {
         case KVM_X86_XCOMP_GUEST_SUPP:
-               if (put_user(supported_xcr0, (u64 __user *)attr->addr))
+               if (put_user(supported_xcr0, (u64 __user *)(unsigned 
long)attr->addr))
                         return -EFAULT;
                 return 0;
         default:

>     arch/x86/include/asm/uaccess.h:221:24: note: in definition of macro 'do_put_user_call'
>       221 |  register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);  \
>           |                        ^~~
>     arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |       ^~~~~~~~
>>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |                                ^
>     arch/x86/include/asm/uaccess.h:223:14: note: in definition of macro 'do_put_user_call'
>       223 |  __ptr_pu = (ptr);      \
>           |              ^~~
>     arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |       ^~~~~~~~
>>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |                                ^
>     arch/x86/include/asm/uaccess.h:230:31: note: in definition of macro 'do_put_user_call'
>       230 |          [size] "i" (sizeof(*(ptr)))   \
>           |                               ^~~
>     arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
>      4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>           |       ^~~~~~~~
> 
> 
> vim +4345 arch/x86/kvm/x86.c
> 
>    4337	
>    4338	static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
>    4339	{
>    4340		if (attr->group)
>    4341			return -ENXIO;
>    4342	
>    4343		switch (attr->attr) {
>    4344		case KVM_X86_XCOMP_GUEST_SUPP:
>> 4345			if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>    4346				return -EFAULT;
>    4347			return 0;
>    4348		default:
>    4349			return -ENXIO;
>    4350			break;
>    4351		}
>    4352	}
>    4353	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
