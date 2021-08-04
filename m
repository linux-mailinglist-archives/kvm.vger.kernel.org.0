Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83503DFCCA
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhHDI0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhHDI0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:26:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B755C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:26:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u16so2235990ple.2
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkczZ102d6X9iUWX5eY6ukSEVSaDUSd1MxUDmIIaQhg=;
        b=bTw0AUBxchh0aYY1EQoMhoeszxlZXOhkPRe0lZS2bpOsTcJ6DfU00mAZzKB0VFb257
         gpl4rqcNAs7qyGeWJGapqCCDw0Dcdy44KrPV8DKAdBwfYptffmWVLloRgj3kriZa53d8
         Shcis8EsENB/qwL6Cr0a0yTroDkOJjhHQFudpZ/erDUuDcibdhitTUV31qHfmdhPStp1
         3TFgmo6i4YFGh4/yxlf6E6b7dwGG1c1RTkhKQ9tbnD79x5wOS33akrZCwNeRExorsL4z
         M0nK/z1olyqYRnpylRKKpmsTNFLcjNIqEdtdcPAV+FIUbzLEtlUFA/ydkVeul4tI6W0B
         0tWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XkczZ102d6X9iUWX5eY6ukSEVSaDUSd1MxUDmIIaQhg=;
        b=hpMn54+sY45kyNyjvPfb7XrCpyhJlppDAhR6A9j/ktnpabYBzV+Yoj0JzgQQRetu12
         7uYj2In4Prn/yqk/vJN9fDy5k6PPbEQjPj9QBaOg3nji3EdZHnt7ouC268468kUI+wOV
         IIyybV/bScFJv9Cb6i0XCLq5uIgzOT2qVN1OtydV7GmO+y/LQlCtdlR6OEBBWbK97cbM
         EduPxu97O90LiFUEeNxhzm9zHwDrUFGAkyF17sunOSgCvG7M7PoHvlw6UkLvWrVVtMNC
         5aW4ux8c/Ly7M3eKiMmMqc9vMUIhIwXujT8rOMJwoISvrCsQPKB93zGPeIIsbQmyqCl6
         Jngg==
X-Gm-Message-State: AOAM531S1iUnHNber8r7SjNvmGoXE5vaHDrAM4xKPr51zUN2RfRZwcQn
        K4gCbvl26tYXq0QwxvFwT5w=
X-Google-Smtp-Source: ABdhPJzl7o1Cvi4DStYrzpOZGO59YgqA4DaQ7AzlptWnkeP6Hz2MXEcj+Aubps5jJhIDnSReyiB+YQ==
X-Received: by 2002:a63:d458:: with SMTP id i24mr148543pgj.289.1628065593741;
        Wed, 04 Aug 2021 01:26:33 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t19sm2000664pfg.216.2021.08.04.01.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:26:33 -0700 (PDT)
Subject: Re: [kvm:queue 89/92] arch/x86/kvm/debugfs.c:115:18: error: implicit
 declaration of function 'kvm_mmu_slot_lpages'
To:     Peter Xu <peterx@redhat.com>
Cc:     clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
References: <202108040409.71rYZOtR-lkp@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <79f2b495-4277-5794-e7ca-34eca755f673@gmail.com>
Date:   Wed, 4 Aug 2021 16:26:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <202108040409.71rYZOtR-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 0ba436e56da7 ("KVM: X86: Introduce kvm_mmu_slot_lpages() helpers")

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 62a61bfdd680..4fa519caaef7 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -7,6 +7,7 @@
  #include <linux/kvm_host.h>
  #include <linux/debugfs.h>
  #include "lapic.h"
+#include "mmu.h"
  #include "mmu/mmu_internal.h"

  static int vcpu_get_timer_advance_ns(void *data, u64 *val)

On 4/8/2021 4:37 am, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   6cd974485e2574d94221268760d84c9c19d1c4ff
> commit: 53c1304cfe8446c0bfbe2dcac1995bfa5907a1d2 [89/92] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
> config: x86_64-randconfig-a011-20210803 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 4f71f59bf3d9914188a11d0c41bedbb339d36ff5)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=53c1304cfe8446c0bfbe2dcac1995bfa5907a1d2
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>          git fetch --no-tags kvm queue
>          git checkout 53c1304cfe8446c0bfbe2dcac1995bfa5907a1d2
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> arch/x86/kvm/debugfs.c:115:18: error: implicit declaration of function 'kvm_mmu_slot_lpages' [-Werror,-Wimplicit-function-declaration]
>                                     lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
>                                                  ^
>     1 error generated.
> 
> 
> vim +/kvm_mmu_slot_lpages +115 arch/x86/kvm/debugfs.c
> 
>      85	
>      86	static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
>      87	{
>      88		struct kvm_rmap_head *rmap;
>      89		struct kvm *kvm = m->private;
>      90		struct kvm_memory_slot *slot;
>      91		struct kvm_memslots *slots;
>      92		unsigned int lpage_size, index;
>      93		/* Still small enough to be on the stack */
>      94		unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
>      95		int i, j, k, l, ret;
>      96	
>      97		memset(log, 0, sizeof(log));
>      98	
>      99		ret = -ENOMEM;
>     100		for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
>     101			log[i] = kzalloc(RMAP_LOG_SIZE * sizeof(unsigned int), GFP_KERNEL);
>     102			if (!log[i])
>     103				goto out;
>     104		}
>     105	
>     106		mutex_lock(&kvm->slots_lock);
>     107		write_lock(&kvm->mmu_lock);
>     108	
>     109		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>     110			slots = __kvm_memslots(kvm, i);
>     111			for (j = 0; j < slots->used_slots; j++) {
>     112				slot = &slots->memslots[j];
>     113				for (k = 0; k < KVM_NR_PAGE_SIZES; k++) {
>     114					rmap = slot->arch.rmap[k];
>   > 115					lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
>     116					cur = log[k];
>     117					for (l = 0; l < lpage_size; l++) {
>     118						index = ffs(pte_list_count(&rmap[l]));
>     119						if (WARN_ON_ONCE(index >= RMAP_LOG_SIZE))
>     120							index = RMAP_LOG_SIZE - 1;
>     121						cur[index]++;
>     122					}
>     123				}
>     124			}
>     125		}
>     126	
>     127		write_unlock(&kvm->mmu_lock);
>     128		mutex_unlock(&kvm->slots_lock);
>     129	
>     130		/* index=0 counts no rmap; index=1 counts 1 rmap */
>     131		seq_printf(m, "Rmap_Count:\t0\t1\t");
>     132		for (i = 2; i < RMAP_LOG_SIZE; i++) {
>     133			j = 1 << (i - 1);
>     134			k = (1 << i) - 1;
>     135			seq_printf(m, "%d-%d\t", j, k);
>     136		}
>     137		seq_printf(m, "\n");
>     138	
>     139		for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
>     140			seq_printf(m, "Level=%s:\t", kvm_lpage_str[i]);
>     141			cur = log[i];
>     142			for (j = 0; j < RMAP_LOG_SIZE; j++)
>     143				seq_printf(m, "%d\t", cur[j]);
>     144			seq_printf(m, "\n");
>     145		}
>     146	
>     147		ret = 0;
>     148	out:
>     149		for (i = 0; i < KVM_NR_PAGE_SIZES; i++)
>     150			if (log[i])
>     151				kfree(log[i]);
>     152	
>     153		return ret;
>     154	}
>     155	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
