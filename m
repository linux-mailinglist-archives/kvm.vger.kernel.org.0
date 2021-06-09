Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDBF3A0BBC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 07:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFIFK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 01:10:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:64165 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhFIFK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 01:10:27 -0400
IronPort-SDR: cxP8NVVvmqygplcSXHAFIaZ6W/up02GKm1ydlJ8Ewmr6KuEgOsxlqrG7wjosTsf7ZW+6Mh2o6l
 1iUExr0GhLUA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="184691678"
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="gz'50?scan'50,208,50";a="184691678"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 22:08:33 -0700
IronPort-SDR: GFZM0DA7ypzcvE3D2Mw/ZPceGdk8/TSNMTtPpniyYepxpYRegRvmgRsCBb3tjc4ItmIAvIuSLv
 gXSNKtb/L+Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="gz'50?scan'50,208,50";a="419156860"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2021 22:08:30 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lqqS5-0009Pk-GT; Wed, 09 Jun 2021 05:08:29 +0000
Date:   Wed, 9 Jun 2021 13:08:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        joro@8bytes.org
Subject: Re: [PATCH 3/3 v3] KVM: x86: Add a new VM statistic to show number
 of VCPUs created in a given VM
Message-ID: <202106091342.Y0objnbq-lkp@intel.com>
References: <20210609011935.103017-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20210609011935.103017-4-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Krish,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on v5.13-rc5 next-20210608]
[cannot apply to vhost/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Krish-Sadhukhan/KVM-nVMX-nSVM-Add-more-statistics-to-KVM-debugfs/20210609-101158
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: s390-randconfig-r034-20210608 (attached as .config)
compiler: s390-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/8b558261089468777eaf3ec89ca30eb954242e4e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Krish-Sadhukhan/KVM-nVMX-nSVM-Add-more-statistics-to-KVM-debugfs/20210609-101158
        git checkout 8b558261089468777eaf3ec89ca30eb954242e4e
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vm_ioctl_create_vcpu':
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:3321:11: error: 'struct kvm_vm_stat' has no member named 'vcpus'
    3321 |  kvm->stat.vcpus++;
         |           ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:3398:11: error: 'struct kvm_vm_stat' has no member named 'vcpus'
    3398 |  kvm->stat.vcpus--;
         |           ^


vim +3321 arch/s390/kvm/../../../virt/kvm/kvm_main.c

  3301	
  3302	/*
  3303	 * Creates some virtual cpus.  Good luck creating more than one.
  3304	 */
  3305	static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
  3306	{
  3307		int r;
  3308		struct kvm_vcpu *vcpu;
  3309		struct page *page;
  3310	
  3311		if (id >= KVM_MAX_VCPU_ID)
  3312			return -EINVAL;
  3313	
  3314		mutex_lock(&kvm->lock);
  3315		if (kvm->created_vcpus == KVM_MAX_VCPUS) {
  3316			mutex_unlock(&kvm->lock);
  3317			return -EINVAL;
  3318		}
  3319	
  3320		kvm->created_vcpus++;
> 3321		kvm->stat.vcpus++;
  3322		mutex_unlock(&kvm->lock);
  3323	
  3324		r = kvm_arch_vcpu_precreate(kvm, id);
  3325		if (r)
  3326			goto vcpu_decrement;
  3327	
  3328		vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
  3329		if (!vcpu) {
  3330			r = -ENOMEM;
  3331			goto vcpu_decrement;
  3332		}
  3333	
  3334		BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
  3335		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
  3336		if (!page) {
  3337			r = -ENOMEM;
  3338			goto vcpu_free;
  3339		}
  3340		vcpu->run = page_address(page);
  3341	
  3342		kvm_vcpu_init(vcpu, kvm, id);
  3343	
  3344		r = kvm_arch_vcpu_create(vcpu);
  3345		if (r)
  3346			goto vcpu_free_run_page;
  3347	
  3348		if (kvm->dirty_ring_size) {
  3349			r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
  3350						 id, kvm->dirty_ring_size);
  3351			if (r)
  3352				goto arch_vcpu_destroy;
  3353		}
  3354	
  3355		mutex_lock(&kvm->lock);
  3356		if (kvm_get_vcpu_by_id(kvm, id)) {
  3357			r = -EEXIST;
  3358			goto unlock_vcpu_destroy;
  3359		}
  3360	
  3361		vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
  3362		BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
  3363	
  3364		/* Now it's all set up, let userspace reach it */
  3365		kvm_get_kvm(kvm);
  3366		r = create_vcpu_fd(vcpu);
  3367		if (r < 0) {
  3368			kvm_put_kvm_no_destroy(kvm);
  3369			goto unlock_vcpu_destroy;
  3370		}
  3371	
  3372		kvm->vcpus[vcpu->vcpu_idx] = vcpu;
  3373	
  3374		/*
  3375		 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
  3376		 * before kvm->online_vcpu's incremented value.
  3377		 */
  3378		smp_wmb();
  3379		atomic_inc(&kvm->online_vcpus);
  3380	
  3381		mutex_unlock(&kvm->lock);
  3382		kvm_arch_vcpu_postcreate(vcpu);
  3383		kvm_create_vcpu_debugfs(vcpu);
  3384		return r;
  3385	
  3386	unlock_vcpu_destroy:
  3387		mutex_unlock(&kvm->lock);
  3388		kvm_dirty_ring_free(&vcpu->dirty_ring);
  3389	arch_vcpu_destroy:
  3390		kvm_arch_vcpu_destroy(vcpu);
  3391	vcpu_free_run_page:
  3392		free_page((unsigned long)vcpu->run);
  3393	vcpu_free:
  3394		kmem_cache_free(kvm_vcpu_cache, vcpu);
  3395	vcpu_decrement:
  3396		mutex_lock(&kvm->lock);
  3397		kvm->created_vcpus--;
  3398		kvm->stat.vcpus--;
  3399		mutex_unlock(&kvm->lock);
  3400		return r;
  3401	}
  3402	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--x+6KMIRAuhnl3hBn
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--x+6KMIRAuhnl3hBn--
