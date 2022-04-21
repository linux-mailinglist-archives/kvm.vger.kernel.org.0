Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38215097E8
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 08:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385032AbiDUGqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 02:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385064AbiDUGqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 02:46:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694CD15A00;
        Wed, 20 Apr 2022 23:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650523374; x=1682059374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z2/yOxLXZzMxax9tKl9sDB+/ZZcCczbZrzJWUWTvHXY=;
  b=koOI02jAqDwcwFanXIJ85PzReoRRWl+fysNnwke8kaVbTrEDLLx0//2H
   wRr6OuohafjAywSbHV7qzkcVlTcRnr0a0QQFGyLwFrMA5gf8ptebOVf9X
   tqDjU74czzMs5EL1G6TysaSvjpgfiBXdz/TY/MykUTl+NW99n/+09f0NL
   zlTBtkMr9XnTxzZmErUvZYqkdk5iOj3xwCMNxCBXla1iJBseikGOCAOw9
   j/DPTfi31yR7RQwQP9zvd2S2eHkrLODWZINV2QBhuY0i3leHeTe4iGL3R
   odql6pOpl3HhnML37es+gD38ymX0lpTmNykUWHP7u16zTxSSreePJGt0R
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244189868"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244189868"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 23:42:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="702961334"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2022 23:42:50 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhQWg-0007ze-C3;
        Thu, 21 Apr 2022 06:42:50 +0000
Date:   Thu, 21 Apr 2022 14:41:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, pmorel@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 2/2] s390x: KVM: resetting the Topology-Change-Report
Message-ID: <202204210249.JUYt00GG-lkp@intel.com>
References: <20220420113430.11876-3-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420113430.11876-3-pmorel@linux.ibm.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Pierre,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/master]
[also build test WARNING on v5.18-rc3]
[cannot apply to kvms390/next mst-vhost/linux-next next-20220420]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Pierre-Morel/s390x-KVM-CPU-Topology/20220420-194302
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20220421/202204210249.JUYt00GG-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0bdeef651636ac2ef4918fb6e3230614e2fb3581
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pierre-Morel/s390x-KVM-CPU-Topology/20220420-194302
        git checkout 0bdeef651636ac2ef4918fb6e3230614e2fb3581
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_sca_clear_mtcr':
>> arch/s390/kvm/kvm-s390.c:1773:13: warning: variable 'val' set but not used [-Wunused-but-set-variable]
    1773 |         int val;
         |             ^~~


vim +/val +1773 arch/s390/kvm/kvm-s390.c

  1758	
  1759	/**
  1760	 * kvm_s390_sca_clear_mtcr
  1761	 * @kvm: guest KVM description
  1762	 *
  1763	 * Is only relevant if the topology facility is present,
  1764	 * the caller should check KVM facility 11
  1765	 *
  1766	 * Updates the Multiprocessor Topology-Change-Report to signal
  1767	 * the guest with a topology change.
  1768	 */
  1769	static int kvm_s390_sca_clear_mtcr(struct kvm *kvm)
  1770	{
  1771		struct bsca_block *sca = kvm->arch.sca;
  1772		struct kvm_vcpu *vcpu;
> 1773		int val;
  1774	
  1775		vcpu = kvm_s390_get_first_vcpu(kvm);
  1776		if (!vcpu)
  1777			return -ENODEV;
  1778	
  1779		ipte_lock(vcpu);
  1780		val = READ_ONCE(sca->utility);
  1781		WRITE_ONCE(sca->utility, sca->utility & ~SCA_UTILITY_MTCR);
  1782		ipte_unlock(vcpu);
  1783	
  1784		return 0;
  1785	}
  1786	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
