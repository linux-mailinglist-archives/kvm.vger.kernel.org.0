Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7230325B84F
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 03:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgICBbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICBbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 21:31:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE4FC061245;
        Wed,  2 Sep 2020 18:31:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c142so865468pfb.7;
        Wed, 02 Sep 2020 18:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1UF8ZswLm2YxPJUQw7iNkdBHKwOAXGZ5uov9qTxwmRc=;
        b=c0yR4ztOj4dfTuQZ8tjWP/FbwDQwfjTWhGH1SMjiqIQAJ8TFCNmeixm4EMJMZP5t7F
         aSppoxWlKq552Zel3apcxSqpZFWL6rG6hCN6Y//bRlAmYPYwsY/9Tk38sv0J5wqpuijv
         C+DC+BUIUfbcuRn6f+oH5rQ+vKkizIhZQwpXX+FzD0Het1xcUUYfd5pBh06FIj095Zfd
         zcDdcghrcrid58fKddqk5TwYHX8ZHEVR+2++v3se8FcA+H82K6xOEGEj88boIKfDQ+JT
         lt6Sr7eJdNycbFAXumlV8ZiZo2D0Dk3jg7FmdmWUDYXBu1m0BAMb302hBIgA6KkkzCYU
         vb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1UF8ZswLm2YxPJUQw7iNkdBHKwOAXGZ5uov9qTxwmRc=;
        b=kG/iJVYuKNjpt/mJFx5KocABPBJ+YNnGphFTKqBdSCuOndH0uh25OMQhNTg3Lsy8HE
         RODboWtQYE3MtlR3OZZvKR7cHgEEGGvnvTohmyWSJozlZHP/PNI3kD3r2vA2X5jS27rQ
         zgz1PyUimn4tx/EvZeFZ29sDCVOyg64IpfxJ6o/LtjohAJW/v924GimaYjb2mTwSFJ60
         osRmX0c6yTHZ3xgQzkCJdrX2SVqp3h47HWDh+9kI85j966fpsqNsfEMCq+ejsVl5D+ui
         DcbPY3wfukSTgcFw9529u34rIrk/4SvtS4qF17lS96RCM2aCQIHyC/lvv+zD3AiQHQ7E
         MyAA==
X-Gm-Message-State: AOAM532bT9mWxg1LZFlIzYFZMdAwP8p118WedvBVhFqpOVGwlCunt9Wk
        0Q8e5IsSNCPk0SilGH8Plg==
X-Google-Smtp-Source: ABdhPJxSrG72vbPbb3WkCe57SzDFywWC5U4+HNhUe59sV8VPeueYQ4SuOTcf2u73iZnYdxdnjyRMqg==
X-Received: by 2002:a62:3814:: with SMTP id f20mr1227163pfa.23.1599096709093;
        Wed, 02 Sep 2020 18:31:49 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id y29sm834242pfq.207.2020.09.02.18.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 18:31:48 -0700 (PDT)
Subject: Re: [PATCH] KVM: Check the allocation of pv cpu mask
To:     kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
References: <d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com>
 <202009020129.H90h8RdM%lkp@intel.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <cca7f343-6b0f-2717-a24b-a66b307f8888@gmail.com>
Date:   Thu, 3 Sep 2020 09:31:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <202009020129.H90h8RdM%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/2 01:35, kernel test robot wrote:
> Hi Haiwei,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/linux-next]
> [also build test ERROR on linus/master v5.9-rc3 next-20200828]
> [cannot apply to linux/master vhost/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Haiwei-Li/KVM-Check-the-allocation-of-pv-cpu-mask/20200901-195412
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
> config: x86_64-randconfig-a011-20200901 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c10e63677f5d20f18010f8f68c631ddc97546f7d)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install x86_64 cross compiling tool for clang build
>          # apt-get install binutils-x86-64-linux-gnu
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> arch/x86/kernel/kvm.c:801:35: error: use of undeclared identifier 'kvm_send_ipi_mask_allbutself'
>             apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>                                              ^
>     1 error generated.

THX, i will fix and resend.

> 
> # https://github.com/0day-ci/linux/commit/13dd13ab0aefbb5c31bd8681831e6a11ac381509
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Haiwei-Li/KVM-Check-the-allocation-of-pv-cpu-mask/20200901-195412
> git checkout 13dd13ab0aefbb5c31bd8681831e6a11ac381509
> vim +/kvm_send_ipi_mask_allbutself +801 arch/x86/kernel/kvm.c
> 
>     791	
>     792		if (alloc)
>     793			for_each_possible_cpu(cpu) {
>     794				if (!zalloc_cpumask_var_node(
>     795					per_cpu_ptr(&__pv_cpu_mask, cpu),
>     796					GFP_KERNEL, cpu_to_node(cpu))) {
>     797					goto zalloc_cpumask_fail;
>     798				}
>     799			}
>     800	
>   > 801		apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>     802		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>     803		return 0;
>     804	
>     805	zalloc_cpumask_fail:
>     806		kvm_free_pv_cpu_mask();
>     807		return -ENOMEM;
>     808	}
>     809	arch_initcall(kvm_alloc_cpumask);
>     810	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
