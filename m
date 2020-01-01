Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0A312DE9F
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2020 12:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAALDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jan 2020 06:03:24 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21176 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgAALDX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jan 2020 06:03:23 -0500
X-IronPort-AV: E=Sophos;i="5.69,382,1571695200"; 
   d="scan'208";a="429588079"
Received: from abo-154-110-68.mrs.modulonet.fr (HELO hadrien) ([85.68.110.154])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jan 2020 12:03:13 +0100
Date:   Wed, 1 Jan 2020 12:03:13 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Yang Weijiang <weijiang.yang@intel.com>
cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com,
        Yang Weijiang <weijiang.yang@intel.com>,
        kbuild-all@lists.01.org
Subject: Re: [PATCH v10 05/10] x86: spp: Introduce user-space SPP IOCTLs
 (fwd)
Message-ID: <alpine.DEB.2.21.2001011202220.3262@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1022410171-1577876593=:3262"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1022410171-1577876593=:3262
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

See lines 5185 and 5186.

julia

---------- Forwarded message ----------
Date: Wed, 1 Jan 2020 14:03:47 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v10 05/10] x86: spp: Introduce user-space SPP IOCTLs

CC: kbuild-all@lists.01.org
In-Reply-To: <20191231065043.2209-6-weijiang.yang@intel.com>
References: <20191231065043.2209-6-weijiang.yang@intel.com>
TO: Yang Weijiang <weijiang.yang@intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com, sean.j.christopherson@intel.com
CC: yu.c.zhang@linux.intel.com, alazar@bitdefender.com, edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>

Hi Yang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on vhost/linux-next tip/auto-latest linux/master linus/master v5.5-rc4 next-20191220]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Yang-Weijiang/Enable-Sub-Page-Write-Protection-Support/20191231-145254
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
:::::: branch date: 23 hours ago
:::::: commit date: 23 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

>> arch/x86/kvm/x86.c:5186:6-11: ERROR: reference preceded by free on line 5185

# https://github.com/0day-ci/linux/commit/148f2ec985f4ef45bcde3f5a787394f23a18e800
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 148f2ec985f4ef45bcde3f5a787394f23a18e800
vim +5186 arch/x86/kvm/x86.c

90de4a1875180f arch/x86/kvm/x86.c Nadav Amit        2015-04-13  4844
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4845  long kvm_arch_vm_ioctl(struct file *filp,
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4846  		       unsigned int ioctl, unsigned long arg)
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4847  {
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4848  	struct kvm *kvm = filp->private_data;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4849  	void __user *argp = (void __user *)arg;
367e1319b22911 arch/x86/kvm/x86.c Avi Kivity        2009-08-26  4850  	int r = -ENOTTY;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4851  	/*
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4852  	 * This union makes it completely explicit to gcc-3.x
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4853  	 * that these two variables' stack usage should be
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4854  	 * combined, not added together.
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4855  	 */
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4856  	union {
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4857  		struct kvm_pit_state ps;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  4858  		struct kvm_pit_state2 ps2;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4859  		struct kvm_pit_config pit_config;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4860  	} u;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4861
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4862  	switch (ioctl) {
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4863  	case KVM_SET_TSS_ADDR:
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4864  		r = kvm_vm_ioctl_set_tss_addr(kvm, arg);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4865  		break;
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4866  	case KVM_SET_IDENTITY_MAP_ADDR: {
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4867  		u64 ident_addr;
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4868
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4869  		mutex_lock(&kvm->lock);
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4870  		r = -EINVAL;
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4871  		if (kvm->created_vcpus)
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4872  			goto set_identity_unlock;
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4873  		r = -EFAULT;
0e96f31ea4249b arch/x86/kvm/x86.c Jordan Borgner    2018-10-28  4874  		if (copy_from_user(&ident_addr, argp, sizeof(ident_addr)))
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4875  			goto set_identity_unlock;
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4876  		r = kvm_vm_ioctl_set_identity_map_addr(kvm, ident_addr);
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4877  set_identity_unlock:
1af1ac910bb339 arch/x86/kvm/x86.c David Hildenbrand 2017-08-24  4878  		mutex_unlock(&kvm->lock);
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4879  		break;
b927a3cec081a6 arch/x86/kvm/x86.c Sheng Yang        2009-07-21  4880  	}
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4881  	case KVM_SET_NR_MMU_PAGES:
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4882  		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4883  		break;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4884  	case KVM_GET_NR_MMU_PAGES:
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4885  		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4886  		break;
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4887  	case KVM_CREATE_IRQCHIP: {
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4888  		mutex_lock(&kvm->lock);
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4889
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4890  		r = -EEXIST;
35e6eaa3df5582 arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4891  		if (irqchip_in_kernel(kvm))
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4892  			goto create_irqchip_unlock;
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4893
3e515705a1f46b arch/x86/kvm/x86.c Avi Kivity        2012-03-05  4894  		r = -EINVAL;
557abc40d12135 arch/x86/kvm/x86.c Paolo Bonzini     2016-06-13  4895  		if (kvm->created_vcpus)
3e515705a1f46b arch/x86/kvm/x86.c Avi Kivity        2012-03-05  4896  			goto create_irqchip_unlock;
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4897
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4898  		r = kvm_pic_init(kvm);
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4899  		if (r)
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4900  			goto create_irqchip_unlock;
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4901
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4902  		r = kvm_ioapic_init(kvm);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4903  		if (r) {
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4904  			kvm_pic_destroy(kvm);
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4905  			goto create_irqchip_unlock;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4906  		}
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4907
399ec807ddc38e arch/x86/kvm/x86.c Avi Kivity        2008-11-19  4908  		r = kvm_setup_default_irq_routing(kvm);
399ec807ddc38e arch/x86/kvm/x86.c Avi Kivity        2008-11-19  4909  		if (r) {
72bb2fcd23afe8 arch/x86/kvm/x86.c Wei Yongjun       2010-02-09  4910  			kvm_ioapic_destroy(kvm);
099413664c71fc arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4911  			kvm_pic_destroy(kvm);
71ba994c94a81c arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  4912  			goto create_irqchip_unlock;
399ec807ddc38e arch/x86/kvm/x86.c Avi Kivity        2008-11-19  4913  		}
49776faf93f807 arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4914  		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
71ba994c94a81c arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  4915  		smp_wmb();
49776faf93f807 arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4916  		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4917  	create_irqchip_unlock:
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4918  		mutex_unlock(&kvm->lock);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4919  		break;
3ddea128ad75bd arch/x86/kvm/x86.c Marcelo Tosatti   2009-10-29  4920  	}
7837699fa6d7ad arch/x86/kvm/x86.c Sheng Yang        2008-01-28  4921  	case KVM_CREATE_PIT:
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4922  		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4923  		goto create_pit;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4924  	case KVM_CREATE_PIT2:
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4925  		r = -EFAULT;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4926  		if (copy_from_user(&u.pit_config, argp,
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4927  				   sizeof(struct kvm_pit_config)))
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4928  			goto out;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4929  	create_pit:
250715a6171a07 arch/x86/kvm/x86.c Paolo Bonzini     2016-06-01  4930  		mutex_lock(&kvm->lock);
269e05e48502f1 arch/x86/kvm/x86.c Avi Kivity        2009-01-05  4931  		r = -EEXIST;
269e05e48502f1 arch/x86/kvm/x86.c Avi Kivity        2009-01-05  4932  		if (kvm->arch.vpit)
269e05e48502f1 arch/x86/kvm/x86.c Avi Kivity        2009-01-05  4933  			goto create_pit_unlock;
7837699fa6d7ad arch/x86/kvm/x86.c Sheng Yang        2008-01-28  4934  		r = -ENOMEM;
c5ff41ce66382d arch/x86/kvm/x86.c Jan Kiszka        2009-05-14  4935  		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
7837699fa6d7ad arch/x86/kvm/x86.c Sheng Yang        2008-01-28  4936  		if (kvm->arch.vpit)
7837699fa6d7ad arch/x86/kvm/x86.c Sheng Yang        2008-01-28  4937  			r = 0;
269e05e48502f1 arch/x86/kvm/x86.c Avi Kivity        2009-01-05  4938  	create_pit_unlock:
250715a6171a07 arch/x86/kvm/x86.c Paolo Bonzini     2016-06-01  4939  		mutex_unlock(&kvm->lock);
7837699fa6d7ad arch/x86/kvm/x86.c Sheng Yang        2008-01-28  4940  		break;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4941  	case KVM_GET_IRQCHIP: {
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4942  		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4943  		struct kvm_irqchip *chip;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4944
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4945  		chip = memdup_user(argp, sizeof(*chip));
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4946  		if (IS_ERR(chip)) {
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4947  			r = PTR_ERR(chip);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4948  			goto out;
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4949  		}
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4950
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4951  		r = -ENXIO;
826da32140dada arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4952  		if (!irqchip_kernel(kvm))
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4953  			goto get_irqchip_out;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4954  		r = kvm_vm_ioctl_get_irqchip(kvm, chip);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4955  		if (r)
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4956  			goto get_irqchip_out;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4957  		r = -EFAULT;
0e96f31ea4249b arch/x86/kvm/x86.c Jordan Borgner    2018-10-28  4958  		if (copy_to_user(argp, chip, sizeof(*chip)))
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4959  			goto get_irqchip_out;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4960  		r = 0;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4961  	get_irqchip_out:
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4962  		kfree(chip);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4963  		break;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4964  	}
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4965  	case KVM_SET_IRQCHIP: {
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4966  		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4967  		struct kvm_irqchip *chip;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4968
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4969  		chip = memdup_user(argp, sizeof(*chip));
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4970  		if (IS_ERR(chip)) {
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4971  			r = PTR_ERR(chip);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4972  			goto out;
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4973  		}
ff5c2c0316ff0e arch/x86/kvm/x86.c Sasha Levin       2011-12-04  4974
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4975  		r = -ENXIO;
826da32140dada arch/x86/kvm/x86.c Radim Krčmář      2016-12-16  4976  		if (!irqchip_kernel(kvm))
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4977  			goto set_irqchip_out;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4978  		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4979  	set_irqchip_out:
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4980  		kfree(chip);
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4981  		break;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  4982  	}
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4983  	case KVM_GET_PIT: {
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4984  		r = -EFAULT;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4985  		if (copy_from_user(&u.ps, argp, sizeof(struct kvm_pit_state)))
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4986  			goto out;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4987  		r = -ENXIO;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4988  		if (!kvm->arch.vpit)
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4989  			goto out;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4990  		r = kvm_vm_ioctl_get_pit(kvm, &u.ps);
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4991  		if (r)
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4992  			goto out;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4993  		r = -EFAULT;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  4994  		if (copy_to_user(argp, &u.ps, sizeof(struct kvm_pit_state)))
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4995  			goto out;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4996  		r = 0;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4997  		break;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4998  	}
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  4999  	case KVM_SET_PIT: {
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5000  		r = -EFAULT;
0e96f31ea4249b arch/x86/kvm/x86.c Jordan Borgner    2018-10-28  5001  		if (copy_from_user(&u.ps, argp, sizeof(u.ps)))
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5002  			goto out;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5003  		r = -ENXIO;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5004  		if (!kvm->arch.vpit)
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5005  			goto out;
f0d662759a2465 arch/x86/kvm/x86.c Dave Hansen       2008-08-11  5006  		r = kvm_vm_ioctl_set_pit(kvm, &u.ps);
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5007  		break;
e0f63cb9277b64 arch/x86/kvm/x86.c Sheng Yang        2008-03-04  5008  	}
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5009  	case KVM_GET_PIT2: {
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5010  		r = -ENXIO;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5011  		if (!kvm->arch.vpit)
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5012  			goto out;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5013  		r = kvm_vm_ioctl_get_pit2(kvm, &u.ps2);
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5014  		if (r)
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5015  			goto out;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5016  		r = -EFAULT;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5017  		if (copy_to_user(argp, &u.ps2, sizeof(u.ps2)))
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5018  			goto out;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5019  		r = 0;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5020  		break;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5021  	}
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5022  	case KVM_SET_PIT2: {
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5023  		r = -EFAULT;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5024  		if (copy_from_user(&u.ps2, argp, sizeof(u.ps2)))
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5025  			goto out;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5026  		r = -ENXIO;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5027  		if (!kvm->arch.vpit)
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5028  			goto out;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5029  		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5030  		break;
e9f4275732add0 arch/x86/kvm/x86.c Beth Kon          2009-07-07  5031  	}
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5032  	case KVM_REINJECT_CONTROL: {
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5033  		struct kvm_reinject_control control;
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5034  		r =  -EFAULT;
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5035  		if (copy_from_user(&control, argp, sizeof(control)))
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5036  			goto out;
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5037  		r = kvm_vm_ioctl_reinject(kvm, &control);
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5038  		break;
52d939a0bf4408 arch/x86/kvm/x86.c Marcelo Tosatti   2008-12-30  5039  	}
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5040  	case KVM_SET_BOOT_CPU_ID:
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5041  		r = 0;
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5042  		mutex_lock(&kvm->lock);
557abc40d12135 arch/x86/kvm/x86.c Paolo Bonzini     2016-06-13  5043  		if (kvm->created_vcpus)
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5044  			r = -EBUSY;
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5045  		else
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5046  			kvm->arch.bsp_vcpu_id = arg;
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5047  		mutex_unlock(&kvm->lock);
d71ba788345c2b arch/x86/kvm/x86.c Paolo Bonzini     2015-07-29  5048  		break;
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5049  	case KVM_XEN_HVM_CONFIG: {
51776043afa415 arch/x86/kvm/x86.c Paolo Bonzini     2017-10-26  5050  		struct kvm_xen_hvm_config xhc;
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5051  		r = -EFAULT;
51776043afa415 arch/x86/kvm/x86.c Paolo Bonzini     2017-10-26  5052  		if (copy_from_user(&xhc, argp, sizeof(xhc)))
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5053  			goto out;
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5054  		r = -EINVAL;
51776043afa415 arch/x86/kvm/x86.c Paolo Bonzini     2017-10-26  5055  		if (xhc.flags)
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5056  			goto out;
51776043afa415 arch/x86/kvm/x86.c Paolo Bonzini     2017-10-26  5057  		memcpy(&kvm->arch.xen_hvm_config, &xhc, sizeof(xhc));
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5058  		r = 0;
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5059  		break;
ffde22ac53b6d6 arch/x86/kvm/x86.c Ed Swierk         2009-10-15  5060  	}
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5061  	case KVM_SET_CLOCK: {
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5062  		struct kvm_clock_data user_ns;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5063  		u64 now_ns;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5064
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5065  		r = -EFAULT;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5066  		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5067  			goto out;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5068
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5069  		r = -EINVAL;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5070  		if (user_ns.flags)
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5071  			goto out;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5072
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5073  		r = 0;
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5074  		/*
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5075  		 * TODO: userspace has to take care of races with VCPU_RUN, so
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5076  		 * kvm_gen_update_masterclock() can be cut down to locked
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5077  		 * pvclock_update_vm_gtod_copy().
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5078  		 */
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5079  		kvm_gen_update_masterclock(kvm);
e891a32e7ae0c6 arch/x86/kvm/x86.c Marcelo Tosatti   2017-04-17  5080  		now_ns = get_kvmclock_ns(kvm);
108b249c453dd7 arch/x86/kvm/x86.c Paolo Bonzini     2016-09-01  5081  		kvm->arch.kvmclock_offset += user_ns.clock - now_ns;
0bc48bea36d178 arch/x86/kvm/x86.c Radim Krčmář      2017-05-16  5082  		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5083  		break;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5084  	}
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5085  	case KVM_GET_CLOCK: {
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5086  		struct kvm_clock_data user_ns;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5087  		u64 now_ns;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5088
e891a32e7ae0c6 arch/x86/kvm/x86.c Marcelo Tosatti   2017-04-17  5089  		now_ns = get_kvmclock_ns(kvm);
108b249c453dd7 arch/x86/kvm/x86.c Paolo Bonzini     2016-09-01  5090  		user_ns.clock = now_ns;
e3fd9a93a12a10 arch/x86/kvm/x86.c Paolo Bonzini     2016-11-09  5091  		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
97e69aa62f8b5d arch/x86/kvm/x86.c Vasiliy Kulikov   2010-10-30  5092  		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5093
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5094  		r = -EFAULT;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5095  		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5096  			goto out;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5097  		r = 0;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5098  		break;
afbcf7ab8d1bc8 arch/x86/kvm/x86.c Glauber Costa     2009-10-16  5099  	}
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5100  	case KVM_MEMORY_ENCRYPT_OP: {
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5101  		r = -ENOTTY;
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5102  		if (kvm_x86_ops->mem_enc_op)
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5103  			r = kvm_x86_ops->mem_enc_op(kvm, argp);
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5104  		break;
5acc5c063196b4 arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5105  	}
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5106  	case KVM_MEMORY_ENCRYPT_REG_REGION: {
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5107  		struct kvm_enc_region region;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5108
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5109  		r = -EFAULT;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5110  		if (copy_from_user(&region, argp, sizeof(region)))
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5111  			goto out;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5112
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5113  		r = -ENOTTY;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5114  		if (kvm_x86_ops->mem_enc_reg_region)
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5115  			r = kvm_x86_ops->mem_enc_reg_region(kvm, &region);
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5116  		break;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5117  	}
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5118  	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5119  		struct kvm_enc_region region;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5120
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5121  		r = -EFAULT;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5122  		if (copy_from_user(&region, argp, sizeof(region)))
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5123  			goto out;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5124
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5125  		r = -ENOTTY;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5126  		if (kvm_x86_ops->mem_enc_unreg_region)
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5127  			r = kvm_x86_ops->mem_enc_unreg_region(kvm, &region);
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5128  		break;
69eaedee411c1f arch/x86/kvm/x86.c Brijesh Singh     2017-12-04  5129  	}
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5130  	case KVM_HYPERV_EVENTFD: {
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5131  		struct kvm_hyperv_eventfd hvevfd;
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5132
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5133  		r = -EFAULT;
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5134  		if (copy_from_user(&hvevfd, argp, sizeof(hvevfd)))
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5135  			goto out;
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5136  		r = kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5137  		break;
faeb7833eee0d6 arch/x86/kvm/x86.c Roman Kagan       2018-02-01  5138  	}
66bb8a065f5aed arch/x86/kvm/x86.c Eric Hankland     2019-07-10  5139  	case KVM_SET_PMU_EVENT_FILTER:
66bb8a065f5aed arch/x86/kvm/x86.c Eric Hankland     2019-07-10  5140  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
66bb8a065f5aed arch/x86/kvm/x86.c Eric Hankland     2019-07-10  5141  		break;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5142  	case KVM_SUBPAGES_GET_ACCESS: {
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5143  		struct kvm_subpage spp_info, *pinfo;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5144  		u32 total;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5145
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5146  		r = -ENODEV;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5147  		if (!kvm->arch.spp_active)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5148  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5149
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5150  		r = -EFAULT;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5151  		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5152  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5153
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5154  		r = -EINVAL;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5155  		if (spp_info.flags != 0 ||
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5156  		    spp_info.npages > KVM_SUBPAGE_MAX_PAGES)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5157  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5158  		r = 0;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5159  		if (!spp_info.npages)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5160  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5161
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5162  		total = sizeof(spp_info) +
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5163  			sizeof(spp_info.access_map[0]) * spp_info.npages;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5164  		pinfo = kvzalloc(total, GFP_KERNEL_ACCOUNT);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5165
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5166  		r = -ENOMEM;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5167  		if (!pinfo)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5168  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5169
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5170  		r = -EFAULT;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5171  		if (copy_from_user(pinfo, argp, total))
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5172  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5173
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5174  		r = kvm_vm_ioctl_get_subpages(kvm,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5175  					      pinfo->gfn_base,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5176  					      pinfo->npages,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5177  					      pinfo->access_map);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5178  		if (r != pinfo->npages)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5179  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5180
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5181  		r = -EFAULT;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5182  		if (copy_to_user(argp, pinfo, total))
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5183  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5184
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31 @5185  		kfree(pinfo);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31 @5186  		r = pinfo->npages;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5187  		break;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5188  	}
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5189  	case KVM_SUBPAGES_SET_ACCESS: {
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5190  		struct kvm_subpage spp_info, *pinfo;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5191  		u32 total;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5192
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5193  		r = -ENODEV;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5194  		if (!kvm->arch.spp_active)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5195  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5196
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5197  		r = -EFAULT;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5198  		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5199  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5200
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5201  		r = -EINVAL;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5202  		if (spp_info.flags != 0 ||
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5203  		    spp_info.npages > KVM_SUBPAGE_MAX_PAGES)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5204  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5205
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5206  		r = 0;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5207  		if (!spp_info.npages)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5208  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5209
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5210  		total = sizeof(spp_info) +
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5211  			sizeof(spp_info.access_map[0]) * spp_info.npages;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5212  		pinfo = kvzalloc(total, GFP_KERNEL_ACCOUNT);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5213
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5214  		r = -ENOMEM;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5215  		if (!pinfo)
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5216  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5217
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5218  		r = -EFAULT;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5219  		if (copy_from_user(pinfo, argp, total))
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5220  			goto out;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5221
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5222  		r = kvm_vm_ioctl_set_subpages(kvm,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5223  					      pinfo->gfn_base,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5224  					      pinfo->npages,
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5225  					      pinfo->access_map);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5226  		kfree(pinfo);
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5227  		break;
148f2ec985f4ef arch/x86/kvm/x86.c Yang Weijiang     2019-12-31  5228  	}
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5229  	default:
ad6260da1e23cf arch/x86/kvm/x86.c Paolo Bonzini     2017-03-27  5230  		r = -ENOTTY;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5231  	}
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5232  out:
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5233  	return r;
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5234  }
1fe779f8eccd16 drivers/kvm/x86.c  Carsten Otte      2007-10-29  5235

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
--8323329-1022410171-1577876593=:3262--
