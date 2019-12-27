Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5429A12B224
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 07:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfL0GwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 01:52:23 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2918 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfL0GwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 01:52:22 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 78BE4E4F3F2AAFF53153;
        Fri, 27 Dec 2019 14:52:16 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Dec 2019 14:52:15 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 27
 Dec 2019 14:52:15 +0800
Subject: Re: [PATCH v2 5/6] KVM: arm64: Add interface to support VCPU
 preempted check
To:     kbuild test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <maz@kernel.org>,
        <james.morse@arm.com>, <linux@armlinux.org.uk>,
        <suzuki.poulose@arm.com>, <julien.thierry.kdev@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <will@kernel.org>, <steven.price@arm.com>,
        <daniel.lezcano@linaro.org>
References: <20191226135833.1052-6-yezengruan@huawei.com>
 <201912270236.nkxsDrid%lkp@intel.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <47879233-4437-4166-b61a-2d1cc8e7e44b@huawei.com>
Date:   Fri, 27 Dec 2019 14:52:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <201912270236.nkxsDrid%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2019/12/27 2:51, kbuild test robot wrote:
> Hi Zengruan,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvmarm/next]
> [also build test ERROR on kvm/linux-next linus/master v5.5-rc3 next-20191220]
> [cannot apply to arm64/for-next/core]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Zengruan-Ye/KVM-arm64-VCPU-preempted-check-support/20191227-000637
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> config: arm64-alldefconfig (attached as .config)
> compiler: aarch64-linux-gcc (GCC) 7.5.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.5.0 make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/spinlock.h:89:0,
>                     from include/linux/radix-tree.h:16,
>                     from include/linux/idr.h:15,
>                     from include/linux/kernfs.h:13,
>                     from include/linux/sysfs.h:16,
>                     from include/linux/kobject.h:20,
>                     from include/linux/of.h:17,
>                     from include/linux/irqdomain.h:35,
>                     from include/linux/acpi.h:13,
>                     from include/acpi/apei.h:9,
>                     from include/acpi/ghes.h:5,
>                     from include/linux/arm_sdei.h:8,
>                     from arch/arm64/kernel/asm-offsets.c:10:
>    arch/arm64/include/asm/spinlock.h: In function 'vcpu_is_preempted':
>>> arch/arm64/include/asm/spinlock.h:18:9: error: implicit declaration of function 'pv_vcpu_is_preempted'; did you mean 'vcpu_is_preempted'? [-Werror=implicit-function-declaration]
>      return pv_vcpu_is_preempted(cpu);
>             ^~~~~~~~~~~~~~~~~~~~
>             vcpu_is_preempted
>    cc1: some warnings being treated as errors
>    make[2]: *** [arch/arm64/kernel/asm-offsets.s] Error 1
>    make[2]: Target '__build' not remade because of errors.
>    make[1]: *** [prepare0] Error 2
>    make[1]: Target 'prepare' not remade because of errors.
>    make: *** [sub-make] Error 2
>    27 real  5 user  7 sys  48.63% cpu 	make prepare
> 
> vim +18 arch/arm64/include/asm/spinlock.h
> 
>     14	
>     15	#define vcpu_is_preempted vcpu_is_preempted
>     16	static inline bool vcpu_is_preempted(long cpu)
>     17	{
>   > 18		return pv_vcpu_is_preempted(cpu);
>     19	}
>     20	
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
> 

Thanks for posting this, I'll update the code to fix this issue.

Thanks,

Zengruan


---
 arch/arm64/include/asm/spinlock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index 45ff1b2949a6..b5d1982414c5 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -12,10 +12,12 @@
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()

+#ifdef CONFIG_PARAVIRT
 #define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(long cpu)
 {
 	return pv_vcpu_is_preempted(cpu);
 }
+#endif // CONFIG_PARAVIRT

 #endif /* __ASM_SPINLOCK_H */
-- 
2.19.1




