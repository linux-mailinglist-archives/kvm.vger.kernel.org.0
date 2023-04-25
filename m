Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58356EDC61
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 09:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjDYHXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 03:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjDYHXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 03:23:32 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB9AF32
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682407407; x=1713943407;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gh+Dq+qpRluNFvtttvSFPUtMvQQemZXLhC07eDECZEQ=;
  b=lkd/F84CRNlhmnpYegMWlQdmNehwRl0PzBz37zl7houE3zIQc0Vokk3d
   aCztD6XXtlXnXuR2EQI+LddZgWuuyk5VNhOVhMhY1AIx6J/XGsebFvVr/
   IoEGk4YDBHtWj+D6yO77YJMlxZfxYAQNwhv7LMeyESQ2vh5bBdYDUbBp4
   GgWGRNxvz6+LXW8gU+E3V8ol/u2XJASWmQFHKhWV6/Om3lBwpPpgDXFry
   NcaUojuckSE54jffElyaYbAY3Jmw7hrsnmdhH5669l/cPa8FbijKjs3df
   IXH7fKvCBNCPEFIwXOleIlpgXWNSMPFKLFQJkj0N+PPf74dVBbs6mjceY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="344162713"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="344162713"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 00:23:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="837326036"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="837326036"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 25 Apr 2023 00:23:23 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prD1H-000j9L-0I;
        Tue, 25 Apr 2023 07:23:23 +0000
Date:   Tue, 25 Apr 2023 15:22:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     oe-kbuild-all@lists.linux.dev, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v7 2/6] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <202304251520.GoTtrhba-lkp@intel.com>
References: <20230424234704.2571444-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424234704.2571444-3-jingzhangos@google.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6a8f57ae2eb07ab39a6f0ccad60c760743051026]

url:    https://github.com/intel-lab-lkp/linux/commits/Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230425-074908
base:   6a8f57ae2eb07ab39a6f0ccad60c760743051026
patch link:    https://lore.kernel.org/r/20230424234704.2571444-3-jingzhangos%40google.com
patch subject: [PATCH v7 2/6] KVM: arm64: Save ID registers' sanitized value per guest
config: arm64-randconfig-r034-20230425 (https://download.01.org/0day-ci/archive/20230425/202304251520.GoTtrhba-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cca571c516149d39bbaf1b5e916df617940458a6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230425-074908
        git checkout cca571c516149d39bbaf1b5e916df617940458a6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 prepare

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304251520.GoTtrhba-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
   arch/arm64/include/asm/kvm_host.h: In function 'idreg_read':
>> arch/arm64/include/asm/kvm_host.h:1109:25: error: 'struct kvm_arch' has no member named 'config_lock'
    1109 |         mutex_lock(&arch->config_lock);
         |                         ^~
   arch/arm64/include/asm/kvm_host.h:1111:27: error: 'struct kvm_arch' has no member named 'config_lock'
    1111 |         mutex_unlock(&arch->config_lock);
         |                           ^~
   arch/arm64/include/asm/kvm_host.h: In function 'idreg_write':
   arch/arm64/include/asm/kvm_host.h:1118:25: error: 'struct kvm_arch' has no member named 'config_lock'
    1118 |         mutex_lock(&arch->config_lock);
         |                         ^~
   arch/arm64/include/asm/kvm_host.h:1120:27: error: 'struct kvm_arch' has no member named 'config_lock'
    1120 |         mutex_unlock(&arch->config_lock);
         |                           ^~
   make[2]: *** [scripts/Makefile.build:114: arch/arm64/kernel/asm-offsets.s] Error 1
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:1286: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:226: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +1109 arch/arm64/include/asm/kvm_host.h

  1104	
  1105	static inline u64 idreg_read(struct kvm_arch *arch, u32 id)
  1106	{
  1107		u64 val;
  1108	
> 1109		mutex_lock(&arch->config_lock);
  1110		val = _idreg_read(arch, id);
  1111		mutex_unlock(&arch->config_lock);
  1112	
  1113		return val;
  1114	}
  1115	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
