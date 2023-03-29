Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084F86CD0A9
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 05:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjC2D3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 23:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC2D3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 23:29:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F82C19F;
        Tue, 28 Mar 2023 20:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680060582; x=1711596582;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zux2cGUIRDkE6Z2IVIQOmNv5GDDvZe8t52R5ff09Pnc=;
  b=Cv3O0WExDU7a747t/vfnU81U3HsATfzfwmIAh+GzNYQfVMq02XKAFDhh
   jbOLwm9ssaWT7QGZ3oBVOuRiF7zQwB6fMwYSdRa2fZZKdgB2KUqr0BxGT
   YSChHZWz1bdL/bqXUMiY1I16/UFvzQlzGa0pqU9oBe89TFtWYAn3TCyOK
   l0aIiiA3i/Um+G7UdxtDS5nT750hD7CEGrPHlSknz5m3FxntkL589yaz/
   05poVXZLulQyYKdFznPvKmSKPKK0X9RknaX6AUiiUv9PUCnueplD0w2DS
   TG5GbgiLMJ0xPEPHzjwVkt+Bfmr/JE/DO5ksb538s/8mZCD69hzXJyglM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="329226698"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="329226698"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 20:29:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="686660204"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="686660204"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 28 Mar 2023 20:29:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phMVD-000JB9-0G;
        Wed, 29 Mar 2023 03:29:35 +0000
Date:   Wed, 29 Mar 2023 11:29:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Reinette Chatre <reinette.chatre@intel.com>, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Message-ID: <202303291158.UlMhtYCO-lkp@intel.com>
References: <81a6066c0f0d6dfa06f41c016abfb7152064e33e.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81a6066c0f0d6dfa06f41c016abfb7152064e33e.1680038771.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reinette,

I love your patch! Yet something to improve:

[auto build test ERROR on 197b6b60ae7bc51dd0814953c562833143b292aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Reinette-Chatre/vfio-pci-Consolidate-irq-cleanup-on-MSI-MSI-X-disable/20230329-055735
base:   197b6b60ae7bc51dd0814953c562833143b292aa
patch link:    https://lore.kernel.org/r/81a6066c0f0d6dfa06f41c016abfb7152064e33e.1680038771.git.reinette.chatre%40intel.com
patch subject: [PATCH V2 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
config: i386-randconfig-a014-20230327 (https://download.01.org/0day-ci/archive/20230329/202303291158.UlMhtYCO-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/39bc54993b029037b12b4a7e947d6cd500065c6b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Reinette-Chatre/vfio-pci-Consolidate-irq-cleanup-on-MSI-MSI-X-disable/20230329-055735
        git checkout 39bc54993b029037b12b4a7e947d6cd500065c6b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/pci/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303291158.UlMhtYCO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vfio/pci/vfio_pci_core.c:1116:6: error: implicit declaration of function 'pci_msix_can_alloc_dyn' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                     !pci_msix_can_alloc_dyn(vdev->pdev)))
                      ^
   1 error generated.


vim +/pci_msix_can_alloc_dyn +1116 drivers/vfio/pci/vfio_pci_core.c

  1082	
  1083	static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
  1084					       struct vfio_irq_info __user *arg)
  1085	{
  1086		unsigned long minsz = offsetofend(struct vfio_irq_info, count);
  1087		struct vfio_irq_info info;
  1088	
  1089		if (copy_from_user(&info, arg, minsz))
  1090			return -EFAULT;
  1091	
  1092		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
  1093			return -EINVAL;
  1094	
  1095		switch (info.index) {
  1096		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
  1097		case VFIO_PCI_REQ_IRQ_INDEX:
  1098			break;
  1099		case VFIO_PCI_ERR_IRQ_INDEX:
  1100			if (pci_is_pcie(vdev->pdev))
  1101				break;
  1102			fallthrough;
  1103		default:
  1104			return -EINVAL;
  1105		}
  1106	
  1107		info.flags = VFIO_IRQ_INFO_EVENTFD;
  1108	
  1109		info.count = vfio_pci_get_irq_count(vdev, info.index);
  1110	
  1111		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
  1112			info.flags |=
  1113				(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
  1114		else if ((info.index != VFIO_PCI_MSIX_IRQ_INDEX) ||
  1115			 (info.index == VFIO_PCI_MSIX_IRQ_INDEX &&
> 1116			  !pci_msix_can_alloc_dyn(vdev->pdev)))
  1117			info.flags |= VFIO_IRQ_INFO_NORESIZE;
  1118	
  1119		return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
  1120	}
  1121	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
