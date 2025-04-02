Return-Path: <kvm+bounces-42449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DFBA78751
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10DBC16BBCD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3568F22DF9B;
	Wed,  2 Apr 2025 04:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXlIxM5u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2945320AF8B
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 04:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743568729; cv=none; b=Dkdp5W9JPk2ZtXf6OyL3WASkGoqF65ELMt3fcO5M0Rd9Ic/1LvHA7M4pqxkMfRpUTa6ginIc8jGTsv+N1nWnhTo9KFAG3kQ03Sd3qYtAukxcip23l7gjbfeeHbNyp27cM2ugnrZtLutcEhPBkRsoTHGd1lDppjVzXY1DgnDAzoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743568729; c=relaxed/simple;
	bh=ovqAUnu1CWBZSA9ZwyzyeWXQw7RAhcY8Fouwju/Azv0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BfPU/7Hl5Ht8bBtXXATlPPlfneQB+o0Fx/KXksTs5jEy+bp4p0Y8ZaMUIqGFzY2Fnk60yJp8m7ldwKXCWf987WIp6O4UfDmVLKg9Zb5/rBYmt89FFOn/QRj1K5GJHrZ3Kz+ATgaBFeX3Pp3sifuhSkyeWjasI1NyEeypHtQCzHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXlIxM5u; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743568727; x=1775104727;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ovqAUnu1CWBZSA9ZwyzyeWXQw7RAhcY8Fouwju/Azv0=;
  b=kXlIxM5uKL7a6AHkc50dOoiQQe3ekX2Fz+TFI4eDHNHWIhT6tjTXi2cn
   /0Gh0SGfzjk9nYNmEi5ZWWbkEdmFEkeiZjEx9FJOokznzpEGC1dWULc6C
   BKJIQucktMlPIp+JEZkyGEMHZcY2Xv0O50nUjs5EdypKkLE8mac6qv3Xo
   vUYWG1lmx3HO9KBimQlM6+9LJctYkTsximn9fGZCmMgxX6zS/plavoQjn
   0P6Z6dhNtNUyWB4s5fsXQ53Nr8mZxxvvKEbElmD9n60RFY5HYrMa5jKAS
   chJbuZ8Zy63zKNzuIg3Aoz2DeJzvdyo0OYdDz1H9z5QXsYBQAwVe1JhAe
   Q==;
X-CSE-ConnectionGUID: WPM+Sp+eRkKYUalR+Hs3cA==
X-CSE-MsgGUID: U4X6NS/wSA2BYGYWAgqpfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="62314145"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="62314145"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 21:38:46 -0700
X-CSE-ConnectionGUID: nFO+1BGWRvK4DOXC2Q/YRg==
X-CSE-MsgGUID: FuaOzrJDSficG2UxGReGfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="131773528"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 01 Apr 2025 21:38:44 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzps9-000ATU-0C;
	Wed, 02 Apr 2025 04:38:41 +0000
Date: Wed, 2 Apr 2025 12:38:12 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 46/62] include/uapi/linux/kvm.h:1427:54: error:
 invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
Message-ID: <202504021254.Jd6scCkT-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git planes-20250401
head:   73685d9c23b7122b44f07d59244416f8b56ed48e
commit: 3455b6bc4ac390780723801ed54b80fed8311764 [46/62] KVM: implement vCPU creation for extra planes
config: riscv-randconfig-002-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021254.Jd6scCkT-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021254.Jd6scCkT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021254.Jd6scCkT-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/ioctl.h:5:0,
                    from ./arch/riscv/include/generated/uapi/asm/ioctl.h:1,
                    from include/uapi/linux/ioctl.h:5,
                    from include/uapi/linux/random.h:12,
                    from include/linux/random.h:10,
                    from include/linux/nodemask.h:98,
                    from include/linux/mmzone.h:18,
                    from include/linux/topology.h:33,
                    from include/linux/irq.h:19,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/riscv/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/kvm_host.h:7,
                    from arch/riscv/kvm/../../../virt/kvm/kvm_main.c:15:
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_arch_is_vcpu_plane_ioctl':
>> include/uapi/linux/kvm.h:1427:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: in expansion of macro '_IOR'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: in expansion of macro 'KVM_GET_DEBUGREGS'
     case KVM_GET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_debugregs'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: in expansion of macro '_IOR'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: in expansion of macro 'KVM_GET_DEBUGREGS'
     case KVM_GET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1427:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: in expansion of macro '_IOR'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: in expansion of macro 'KVM_GET_DEBUGREGS'
     case KVM_GET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1427:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: in expansion of macro '_IOR'
    #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: in expansion of macro 'KVM_GET_DEBUGREGS'
     case KVM_GET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: in expansion of macro '_IOW'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4531:7: note: in expansion of macro 'KVM_SET_DEBUGREGS'
     case KVM_SET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_debugregs'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: in expansion of macro '_IOW'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4531:7: note: in expansion of macro 'KVM_SET_DEBUGREGS'
     case KVM_SET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: in expansion of macro '_IOW'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4531:7: note: in expansion of macro 'KVM_SET_DEBUGREGS'
     case KVM_SET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_debugregs'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: in expansion of macro '_IOW'
    #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4531:7: note: in expansion of macro 'KVM_SET_DEBUGREGS'
     case KVM_SET_DEBUGREGS:
          ^~~~~~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1395:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: in expansion of macro '_IOR'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: in expansion of macro 'KVM_GET_LAPIC'
     case KVM_GET_LAPIC:
          ^~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_lapic_state'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: in expansion of macro '_IOR'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: in expansion of macro 'KVM_GET_LAPIC'
     case KVM_GET_LAPIC:
          ^~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1395:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: in expansion of macro '_IOR'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: in expansion of macro 'KVM_GET_LAPIC'
     case KVM_GET_LAPIC:
          ^~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1395:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: in expansion of macro '_IOR'
    #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: in expansion of macro 'KVM_GET_LAPIC'
     case KVM_GET_LAPIC:
          ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: in expansion of macro '_IOW'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4535:7: note: in expansion of macro 'KVM_SET_LAPIC'
     case KVM_SET_LAPIC:
          ^~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_lapic_state'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: in expansion of macro '_IOW'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4535:7: note: in expansion of macro 'KVM_SET_LAPIC'
     case KVM_SET_LAPIC:
          ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: in expansion of macro '_IOW'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4535:7: note: in expansion of macro 'KVM_SET_LAPIC'
     case KVM_SET_LAPIC:
          ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_lapic_state'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: in expansion of macro '_IOW'
    #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4535:7: note: in expansion of macro 'KVM_SET_LAPIC'
     case KVM_SET_LAPIC:
          ^~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1389:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: in expansion of macro '_IOWR'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                      ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: in expansion of macro 'KVM_GET_MSRS'
     case KVM_GET_MSRS:
          ^~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_msrs'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: in expansion of macro '_IOWR'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                      ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: in expansion of macro 'KVM_GET_MSRS'
     case KVM_GET_MSRS:
          ^~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1389:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: in expansion of macro '_IOWR'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                      ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: in expansion of macro 'KVM_GET_MSRS'
     case KVM_GET_MSRS:
          ^~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1389:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: in expansion of macro '_IOWR'
    #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
                                      ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: in expansion of macro 'KVM_GET_MSRS'
     case KVM_GET_MSRS:
          ^~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:35: note: in expansion of macro '_IOW'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4537:7: note: in expansion of macro 'KVM_SET_MSRS'
     case KVM_SET_MSRS:
          ^~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_msrs'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:35: note: in expansion of macro '_IOW'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4537:7: note: in expansion of macro 'KVM_SET_MSRS'
     case KVM_SET_MSRS:
          ^~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:35: note: in expansion of macro '_IOW'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4537:7: note: in expansion of macro 'KVM_SET_MSRS'
     case KVM_SET_MSRS:
          ^~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:54: error: invalid application of 'sizeof' to incomplete type 'struct kvm_msrs'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                                         ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1390:35: note: in expansion of macro '_IOW'
    #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
                                      ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4537:7: note: in expansion of macro 'KVM_SET_MSRS'
     case KVM_SET_MSRS:
          ^~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1480:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1480:38: note: in expansion of macro '_IOWR'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                         ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4538:7: note: in expansion of macro 'KVM_GET_NESTED_STATE'
     case KVM_GET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_nested_state'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1480:38: note: in expansion of macro '_IOWR'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                         ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4538:7: note: in expansion of macro 'KVM_GET_NESTED_STATE'
     case KVM_GET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1480:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1480:38: note: in expansion of macro '_IOWR'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                         ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4538:7: note: in expansion of macro 'KVM_GET_NESTED_STATE'
     case KVM_GET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
>> include/uapi/linux/kvm.h:1480:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOWR(type,nr,argtype)  _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                           ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1480:38: note: in expansion of macro '_IOWR'
    #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
                                         ^~~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4538:7: note: in expansion of macro 'KVM_GET_NESTED_STATE'
     case KVM_GET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:38: note: in expansion of macro '_IOW'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                         ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4539:7: note: in expansion of macro 'KVM_SET_NESTED_STATE'
     case KVM_SET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
>> include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_nested_state'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:38: note: in expansion of macro '_IOW'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                         ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4539:7: note: in expansion of macro 'KVM_SET_NESTED_STATE'
     case KVM_SET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:38: note: in expansion of macro '_IOW'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                         ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4539:7: note: in expansion of macro 'KVM_SET_NESTED_STATE'
     case KVM_SET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:57: error: invalid application of 'sizeof' to incomplete type 'struct kvm_nested_state'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOW(type,nr,argtype)  _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                                ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1481:38: note: in expansion of macro '_IOW'
    #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
                                         ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4539:7: note: in expansion of macro 'KVM_SET_NESTED_STATE'
     case KVM_SET_NESTED_STATE:
          ^~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:55: error: invalid application of 'sizeof' to incomplete type 'struct kvm_sregs2'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                                          ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:36: note: in expansion of macro '_IOR'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                       ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4546:7: note: in expansion of macro 'KVM_GET_SREGS2'
     case KVM_GET_SREGS2:
          ^~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:25: error: array type has incomplete element type 'struct kvm_sregs2'
     ((sizeof(t) == sizeof(t[1]) && \
                            ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:36: note: in expansion of macro '_IOR'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                       ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4546:7: note: in expansion of macro 'KVM_GET_SREGS2'
     case KVM_GET_SREGS2:
          ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:55: error: invalid application of 'sizeof' to incomplete type 'struct kvm_sregs2'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                                          ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:36: note: in expansion of macro '_IOR'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                       ^~~~
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:4546:7: note: in expansion of macro 'KVM_GET_SREGS2'
     case KVM_GET_SREGS2:
          ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:55: error: invalid application of 'sizeof' to incomplete type 'struct kvm_sregs2'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
                                                          ^
   include/uapi/asm-generic/ioctl.h:73:5: note: in definition of macro '_IOC'
      ((size) << _IOC_SIZESHIFT))
        ^~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: in expansion of macro '_IOC_TYPECHECK'
    #define _IOR(type,nr,argtype)  _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
                                                               ^~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1516:36: note: in expansion of macro '_IOR'
    #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)


vim +1427 include/uapi/linux/kvm.h

852b6d57dc7fa3 include/uapi/linux/kvm.h Scott Wood                  2013-04-12  1378  
bccf2150fe62dd include/linux/kvm.h      Avi Kivity                  2007-02-21  1379  /*
bccf2150fe62dd include/linux/kvm.h      Avi Kivity                  2007-02-21  1380   * ioctls for vcpu fds
bccf2150fe62dd include/linux/kvm.h      Avi Kivity                  2007-02-21  1381   */
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1382  #define KVM_RUN                   _IO(KVMIO,   0x80)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1383  #define KVM_GET_REGS              _IOR(KVMIO,  0x81, struct kvm_regs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1384  #define KVM_SET_REGS              _IOW(KVMIO,  0x82, struct kvm_regs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1385  #define KVM_GET_SREGS             _IOR(KVMIO,  0x83, struct kvm_sregs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1386  #define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1387  #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1388  #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01 @1389  #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01 @1390  #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
739872c56f3322 include/linux/kvm.h      Avi Kivity                  2007-03-01  1391  #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
1961d276c877b9 include/linux/kvm.h      Avi Kivity                  2007-03-05  1392  #define KVM_SET_SIGNAL_MASK       _IOW(KVMIO,  0x8b, struct kvm_signal_mask)
b8836737d92c13 include/linux/kvm.h      Avi Kivity                  2007-04-01  1393  #define KVM_GET_FPU               _IOR(KVMIO,  0x8c, struct kvm_fpu)
b8836737d92c13 include/linux/kvm.h      Avi Kivity                  2007-04-01  1394  #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
96ad2cc6132479 include/linux/kvm.h      Eddie Dong                  2007-09-06 @1395  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
96ad2cc6132479 include/linux/kvm.h      Eddie Dong                  2007-09-06 @1396  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
0771671749b59a include/linux/kvm.h      Dan Kenigsberg              2007-11-21  1397  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
0771671749b59a include/linux/kvm.h      Dan Kenigsberg              2007-11-21  1398  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
b209749f528488 include/linux/kvm.h      Avi Kivity                  2007-10-22  1399  /* Available with KVM_CAP_VAPIC */
b209749f528488 include/linux/kvm.h      Avi Kivity                  2007-10-22  1400  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
b93463aa59d67b include/linux/kvm.h      Avi Kivity                  2007-10-25  1401  /* Available with KVM_CAP_VAPIC */
b93463aa59d67b include/linux/kvm.h      Avi Kivity                  2007-10-25  1402  #define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)
ba5c1e9b6ceebd include/linux/kvm.h      Carsten Otte                2008-03-25  1403  /* valid for virtual machine (for floating interrupt)_and_ vcpu */
ba5c1e9b6ceebd include/linux/kvm.h      Carsten Otte                2008-03-25  1404  #define KVM_S390_INTERRUPT        _IOW(KVMIO,  0x94, struct kvm_s390_interrupt)
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1405  /* store status for s390 */
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1406  #define KVM_S390_STORE_STATUS_NOADDR    (-1ul)
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1407  #define KVM_S390_STORE_STATUS_PREFIXED  (-2ul)
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1408  #define KVM_S390_STORE_STATUS	  _IOW(KVMIO,  0x95, unsigned long)
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1409  /* initial ipl psw for s390 */
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1410  #define KVM_S390_SET_INITIAL_PSW  _IOW(KVMIO,  0x96, struct kvm_s390_psw)
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1411  /* initial reset for s390 */
b0c632db637d68 include/linux/kvm.h      Heiko Carstens              2008-03-25  1412  #define KVM_S390_INITIAL_RESET    _IO(KVMIO,   0x97)
62d9f0dbc92d7e include/linux/kvm.h      Marcelo Tosatti             2008-04-11  1413  #define KVM_GET_MP_STATE          _IOR(KVMIO,  0x98, struct kvm_mp_state)
62d9f0dbc92d7e include/linux/kvm.h      Marcelo Tosatti             2008-04-11  1414  #define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
44b5ce73c99c38 include/uapi/linux/kvm.h Christoffer Dall            2014-08-26  1415  /* Available with KVM_CAP_USER_NMI */
c4abb7c9cde24b include/linux/kvm.h      Jan Kiszka                  2008-09-26  1416  #define KVM_NMI                   _IO(KVMIO,   0x9a)
d0bfb940ecabf0 include/linux/kvm.h      Jan Kiszka                  2008-12-15  1417  /* Available with KVM_CAP_SET_GUEST_DEBUG */
d0bfb940ecabf0 include/linux/kvm.h      Jan Kiszka                  2008-12-15  1418  #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debug)
890ca9aefa78f7 include/linux/kvm.h      Ying Huang                  2009-05-11  1419  /* MCE for x86 */
890ca9aefa78f7 include/linux/kvm.h      Ying Huang                  2009-05-11  1420  #define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
890ca9aefa78f7 include/linux/kvm.h      Ying Huang                  2009-05-11  1421  #define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
890ca9aefa78f7 include/linux/kvm.h      Ying Huang                  2009-05-11  1422  #define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
3cfc3092f40bc3 include/linux/kvm.h      Jan Kiszka                  2009-11-12  1423  /* Available with KVM_CAP_VCPU_EVENTS */
3cfc3092f40bc3 include/linux/kvm.h      Jan Kiszka                  2009-11-12 @1424  #define KVM_GET_VCPU_EVENTS       _IOR(KVMIO,  0x9f, struct kvm_vcpu_events)
3cfc3092f40bc3 include/linux/kvm.h      Jan Kiszka                  2009-11-12 @1425  #define KVM_SET_VCPU_EVENTS       _IOW(KVMIO,  0xa0, struct kvm_vcpu_events)
a1efbe77c1fd7c include/linux/kvm.h      Jan Kiszka                  2010-02-15  1426  /* Available with KVM_CAP_DEBUGREGS */
a1efbe77c1fd7c include/linux/kvm.h      Jan Kiszka                  2010-02-15 @1427  #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
a1efbe77c1fd7c include/linux/kvm.h      Jan Kiszka                  2010-02-15 @1428  #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
d938dc55225a72 include/uapi/linux/kvm.h Cornelia Huck               2013-10-23  1429  /*
22725266bdf95b include/uapi/linux/kvm.h Binbin Wu                   2023-05-18  1430   * vcpu version available with KVM_CAP_ENABLE_CAP
d938dc55225a72 include/uapi/linux/kvm.h Cornelia Huck               2013-10-23  1431   * vm version available with KVM_CAP_ENABLE_CAP_VM
d938dc55225a72 include/uapi/linux/kvm.h Cornelia Huck               2013-10-23  1432   */
71fbfd5f38f735 include/linux/kvm.h      Alexander Graf              2010-03-24  1433  #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13  1434  /* Available with KVM_CAP_XSAVE */
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13 @1435  #define KVM_GET_XSAVE		  _IOR(KVMIO,  0xa4, struct kvm_xsave)
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13  1436  #define KVM_SET_XSAVE		  _IOW(KVMIO,  0xa5, struct kvm_xsave)
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13  1437  /* Available with KVM_CAP_XCRS */
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13 @1438  #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
2d5b5a665508c6 include/linux/kvm.h      Sheng Yang                  2010-06-13 @1439  #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
dc83b8bc0256ee include/linux/kvm.h      Scott Wood                  2011-08-18  1440  /* Available with KVM_CAP_SW_TLB */
dc83b8bc0256ee include/linux/kvm.h      Scott Wood                  2011-08-18  1441  #define KVM_DIRTY_TLB		  _IOW(KVMIO,  0xaa, struct kvm_dirty_tlb)
e24ed81fedd551 include/linux/kvm.h      Alexander Graf              2011-09-14  1442  /* Available with KVM_CAP_ONE_REG */
e24ed81fedd551 include/linux/kvm.h      Alexander Graf              2011-09-14  1443  #define KVM_GET_ONE_REG		  _IOW(KVMIO,  0xab, struct kvm_one_reg)
e24ed81fedd551 include/linux/kvm.h      Alexander Graf              2011-09-14  1444  #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
1c0b28c2a46d98 include/linux/kvm.h      Eric B Munson               2012-03-10  1445  /* VM is being stopped by host */
1c0b28c2a46d98 include/linux/kvm.h      Eric B Munson               2012-03-10  1446  #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
749cf76c5a363e include/uapi/linux/kvm.h Christoffer Dall            2013-01-20  1447  #define KVM_ARM_VCPU_INIT	  _IOW(KVMIO,  0xae, struct kvm_vcpu_init)
42c4e0c77ac915 include/uapi/linux/kvm.h Anup Patel                  2013-09-30  1448  #define KVM_ARM_PREFERRED_TARGET  _IOR(KVMIO,  0xaf, struct kvm_vcpu_init)
749cf76c5a363e include/uapi/linux/kvm.h Christoffer Dall            2013-01-20  1449  #define KVM_GET_REG_LIST	  _IOWR(KVMIO, 0xb0, struct kvm_reg_list)
41408c28f283b4 include/uapi/linux/kvm.h Thomas Huth                 2015-02-06  1450  /* Available with KVM_CAP_S390_MEM_OP */
41408c28f283b4 include/uapi/linux/kvm.h Thomas Huth                 2015-02-06  1451  #define KVM_S390_MEM_OP		  _IOW(KVMIO,  0xb1, struct kvm_s390_mem_op)
30ee2a984f07b0 include/uapi/linux/kvm.h Jason J. Herne              2014-09-23  1452  /* Available with KVM_CAP_S390_SKEYS */
30ee2a984f07b0 include/uapi/linux/kvm.h Jason J. Herne              2014-09-23  1453  #define KVM_S390_GET_SKEYS      _IOW(KVMIO, 0xb2, struct kvm_s390_skeys)
30ee2a984f07b0 include/uapi/linux/kvm.h Jason J. Herne              2014-09-23  1454  #define KVM_S390_SET_SKEYS      _IOW(KVMIO, 0xb3, struct kvm_s390_skeys)
47b43c52ee4b04 include/uapi/linux/kvm.h Jens Freimann               2014-11-11  1455  /* Available with KVM_CAP_S390_INJECT_IRQ */
47b43c52ee4b04 include/uapi/linux/kvm.h Jens Freimann               2014-11-11  1456  #define KVM_S390_IRQ              _IOW(KVMIO,  0xb4, struct kvm_s390_irq)
816c7667ea97c6 include/uapi/linux/kvm.h Jens Freimann               2014-11-24  1457  /* Available with KVM_CAP_S390_IRQ_STATE */
816c7667ea97c6 include/uapi/linux/kvm.h Jens Freimann               2014-11-24  1458  #define KVM_S390_SET_IRQ_STATE	  _IOW(KVMIO, 0xb5, struct kvm_s390_irq_state)
816c7667ea97c6 include/uapi/linux/kvm.h Jens Freimann               2014-11-24  1459  #define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
f077825a8758d7 include/uapi/linux/kvm.h Paolo Bonzini               2015-04-01  1460  /* Available with KVM_CAP_X86_SMM */
f077825a8758d7 include/uapi/linux/kvm.h Paolo Bonzini               2015-04-01  1461  #define KVM_SMI                   _IO(KVMIO,   0xb7)
4036e3874a1ce4 include/uapi/linux/kvm.h Claudio Imbrenda            2016-08-04  1462  /* Available with KVM_CAP_S390_CMMA_MIGRATION */
949c0336948640 include/uapi/linux/kvm.h Gleb Fotengauer-Malinovskiy 2017-07-11  1463  #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
4036e3874a1ce4 include/uapi/linux/kvm.h Claudio Imbrenda            2016-08-04  1464  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
5acc5c063196b4 include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1465  /* Memory Encryption Commands */
5acc5c063196b4 include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1466  #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
d98e6346350ac9 include/linux/kvm.h      Hollis Blanchard            2008-07-01  1467  
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1468  struct kvm_enc_region {
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1469  	__u64 addr;
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1470  	__u64 size;
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1471  };
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1472  
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1473  #define KVM_MEMORY_ENCRYPT_REG_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1474  #define KVM_MEMORY_ENCRYPT_UNREG_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
69eaedee411c1f include/uapi/linux/kvm.h Brijesh Singh               2017-12-04  1475  
faeb7833eee0d6 include/uapi/linux/kvm.h Roman Kagan                 2018-02-01  1476  /* Available with KVM_CAP_HYPERV_EVENTFD */
faeb7833eee0d6 include/uapi/linux/kvm.h Roman Kagan                 2018-02-01  1477  #define KVM_HYPERV_EVENTFD        _IOW(KVMIO,  0xbd, struct kvm_hyperv_eventfd)
faeb7833eee0d6 include/uapi/linux/kvm.h Roman Kagan                 2018-02-01  1478  
8fcc4b5923af5d include/uapi/linux/kvm.h Jim Mattson                 2018-07-10  1479  /* Available with KVM_CAP_NESTED_STATE */
8fcc4b5923af5d include/uapi/linux/kvm.h Jim Mattson                 2018-07-10 @1480  #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
8fcc4b5923af5d include/uapi/linux/kvm.h Jim Mattson                 2018-07-10 @1481  #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
faeb7833eee0d6 include/uapi/linux/kvm.h Roman Kagan                 2018-02-01  1482  
d7547c55cbe747 include/uapi/linux/kvm.h Peter Xu                    2019-05-08  1483  /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
2a31b9db153530 include/uapi/linux/kvm.h Paolo Bonzini               2018-10-23  1484  #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
2a31b9db153530 include/uapi/linux/kvm.h Paolo Bonzini               2018-10-23  1485  
c21d54f0307ff4 include/uapi/linux/kvm.h Vitaly Kuznetsov            2020-09-29  1486  /* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
2bc39970e9327c include/uapi/linux/kvm.h Vitaly Kuznetsov            2018-12-10  1487  #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
2bc39970e9327c include/uapi/linux/kvm.h Vitaly Kuznetsov            2018-12-10  1488  
7dd32a0d0103a5 include/uapi/linux/kvm.h Dave Martin                 2018-12-19  1489  /* Available with KVM_CAP_ARM_SVE */
7dd32a0d0103a5 include/uapi/linux/kvm.h Dave Martin                 2018-12-19  1490  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
7dd32a0d0103a5 include/uapi/linux/kvm.h Dave Martin                 2018-12-19  1491  
7de3f1423ff943 include/uapi/linux/kvm.h Janosch Frank               2020-01-31  1492  /* Available with  KVM_CAP_S390_VCPU_RESETS */
7de3f1423ff943 include/uapi/linux/kvm.h Janosch Frank               2020-01-31  1493  #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
7de3f1423ff943 include/uapi/linux/kvm.h Janosch Frank               2020-01-31  1494  #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
7de3f1423ff943 include/uapi/linux/kvm.h Janosch Frank               2020-01-31  1495  
29b40f105ec8d5 include/uapi/linux/kvm.h Janosch Frank               2019-09-30  1496  /* Available with KVM_CAP_S390_PROTECTED */
29b40f105ec8d5 include/uapi/linux/kvm.h Janosch Frank               2019-09-30  1497  #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
29b40f105ec8d5 include/uapi/linux/kvm.h Janosch Frank               2019-09-30  1498  
1a155254ff937a include/uapi/linux/kvm.h Alexander Graf              2020-09-25  1499  /* Available with KVM_CAP_X86_MSR_FILTER */
1a155254ff937a include/uapi/linux/kvm.h Alexander Graf              2020-09-25  1500  #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
1a155254ff937a include/uapi/linux/kvm.h Alexander Graf              2020-09-25  1501  
fb04a1eddb1a65 include/uapi/linux/kvm.h Peter Xu                    2020-09-30  1502  /* Available with KVM_CAP_DIRTY_LOG_RING */
fb04a1eddb1a65 include/uapi/linux/kvm.h Peter Xu                    2020-09-30  1503  #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
fb04a1eddb1a65 include/uapi/linux/kvm.h Peter Xu                    2020-09-30  1504  
3e3246158808d4 include/uapi/linux/kvm.h David Woodhouse             2021-02-02  1505  /* Per-VM Xen attributes */
a76b9641ad1c0b include/uapi/linux/kvm.h Joao Martins                2020-12-03  1506  #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
a76b9641ad1c0b include/uapi/linux/kvm.h Joao Martins                2020-12-03  1507  #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
a76b9641ad1c0b include/uapi/linux/kvm.h Joao Martins                2020-12-03  1508  
3e3246158808d4 include/uapi/linux/kvm.h David Woodhouse             2021-02-02  1509  /* Per-vCPU Xen attributes */
3e3246158808d4 include/uapi/linux/kvm.h David Woodhouse             2021-02-02  1510  #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
3e3246158808d4 include/uapi/linux/kvm.h David Woodhouse             2021-02-02  1511  #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
3e3246158808d4 include/uapi/linux/kvm.h David Woodhouse             2021-02-02  1512  
35025735a79eaa include/uapi/linux/kvm.h David Woodhouse             2022-03-03  1513  /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
35025735a79eaa include/uapi/linux/kvm.h David Woodhouse             2022-03-03  1514  #define KVM_XEN_HVM_EVTCHN_SEND	_IOW(KVMIO,  0xd0, struct kvm_irq_routing_xen_evtchn)
35025735a79eaa include/uapi/linux/kvm.h David Woodhouse             2022-03-03  1515  
6dba940352038b include/uapi/linux/kvm.h Maxim Levitsky              2021-06-07 @1516  #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
6dba940352038b include/uapi/linux/kvm.h Maxim Levitsky              2021-06-07 @1517  #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
6dba940352038b include/uapi/linux/kvm.h Maxim Levitsky              2021-06-07  1518  

:::::: The code at line 1427 was first introduced by commit
:::::: a1efbe77c1fd7c34a97a76a61520bf23fb3663f6 KVM: x86: Add support for saving&restoring debug registers

:::::: TO: Jan Kiszka <jan.kiszka@siemens.com>
:::::: CC: Avi Kivity <avi@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

