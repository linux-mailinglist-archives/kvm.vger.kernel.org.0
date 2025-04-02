Return-Path: <kvm+bounces-42494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC95A794C4
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3813A188A225
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E1C1C8605;
	Wed,  2 Apr 2025 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KL4j9cuj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF481E89C
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743616833; cv=none; b=bUJow1LcohsjvW9n09e25uoeyYlSTkCcfG+OXemvftBZWvAS1om8b6nUpPN1AnDJ3h1wDW8xhpGj+VceckAZRJUetPnH/DmhwcJGGcI7jH+MB3W4MIQivIKV0nS6t4XbK1+l3ZV4/qWnwXOVwUQT3qTNcATUl+MbumS34f3pWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743616833; c=relaxed/simple;
	bh=iTVlCYSYzhNW2hTPaL3zevppQLWNvsPgslWnNFxKvFs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UgitBvNcqo8O/T1jGrhxvz4qXSgIU51N7c4qPNX+m+6Pd35tqdXM9hKfZu7G27yB7U80sfJcYL1pXVfvm8jq6q6slsZeXCmjkkN5sZ80L4RggkUh4jHzmwffngsV9EkkvKqLqgd+EP+OuC+fBvh44ZRnCDkMVwKjuIjkZ0OfjFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KL4j9cuj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743616831; x=1775152831;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=iTVlCYSYzhNW2hTPaL3zevppQLWNvsPgslWnNFxKvFs=;
  b=KL4j9cujgUKxk5PJjTFHIZM0DgG57ZeU63T+5dibAP6fobEta4zPY66c
   K3XDFR8FUBSn5GSn0RiI06nsO+0CjBQv5+2xzU3E10KflUVhdwtJO65jQ
   QVcd4oIf0zTM+FUV21vjXxR2spfY+HWgXrlHwFMDLwU9/OCXz/bjTEuZ9
   P+y+2R+6xSuVvO6iXscUi1sms30B0SiLZOwJXVG/JEaSnbuN4jRj/TmIB
   UGn/TTVBDvajlILnYbYL1qAwEMM0iDLP5fXsSmmQt2jeFdz6PZXkYQMHk
   RD+9YPHyPkJ4rv+4eR49GZHnTNSiHT4pFNnZv5J24mLHtXyqAi0qNLC2F
   g==;
X-CSE-ConnectionGUID: LWNNdXWCReS2gZRaNj+T1A==
X-CSE-MsgGUID: rUYbbM2iSlCxYveF48X7Pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="45140508"
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="45140508"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 11:00:30 -0700
X-CSE-ConnectionGUID: yKNvFQjQSRyf9thz3+x4kA==
X-CSE-MsgGUID: Y6OO3w+mR8yxyQEGcIflDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="157770652"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 02 Apr 2025 11:00:28 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u02O2-000AwY-02;
	Wed, 02 Apr 2025 18:00:26 +0000
Date: Thu, 3 Apr 2025 02:00:14 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 46/62]
 arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: error: invalid
 application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
Message-ID: <202504030136.Uapa2ld0-lkp@intel.com>
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
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20250403/202504030136.Uapa2ld0-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250403/202504030136.Uapa2ld0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504030136.Uapa2ld0-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4471:15: warning: unused variable 'argp' [-Wunused-variable]
    4471 |         void __user *argp = (void __user *)arg;
         |                      ^~~~
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:4: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: error: array has incomplete element type 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1427:35: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                   ^
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                                                     ^
   include/asm-generic/ioctl.h:13:25: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |                                ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:14:4: note: expanded from macro '_IOC_TYPECHECK'
      14 |           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1427:35: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:15:4: note: expanded from macro '_IOC_TYPECHECK'
      15 |           sizeof(t) : __invalid_size_argument_for_IOC)
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4531:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4531 |         case KVM_SET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: expanded from macro 'KVM_SET_DEBUGREGS'
    1428 | #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:4: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4531:7: error: array has incomplete element type 'struct kvm_debugregs'
    4531 |         case KVM_SET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1428:35: note: expanded from macro 'KVM_SET_DEBUGREGS'
    1428 | #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
         |                                   ^
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                                                      ^
   include/asm-generic/ioctl.h:13:25: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |                                ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4531:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4531 |         case KVM_SET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: expanded from macro 'KVM_SET_DEBUGREGS'
    1428 | #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:14:4: note: expanded from macro '_IOC_TYPECHECK'
      14 |           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4531:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_debugregs'
    4531 |         case KVM_SET_DEBUGREGS:
         |              ^~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1428:35: note: expanded from macro 'KVM_SET_DEBUGREGS'
    1428 | #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:15:4: note: expanded from macro '_IOC_TYPECHECK'
      15 |           sizeof(t) : __invalid_size_argument_for_IOC)
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4530:7: note: forward declaration of 'struct kvm_debugregs'
    4530 |         case KVM_GET_DEBUGREGS:
         |              ^
   include/uapi/linux/kvm.h:1427:61: note: expanded from macro 'KVM_GET_DEBUGREGS'
    1427 | #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:4: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: error: array has incomplete element type 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1395:35: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                   ^
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                                                     ^
   include/asm-generic/ioctl.h:13:25: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |                                ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:14:4: note: expanded from macro '_IOC_TYPECHECK'
      14 |           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1395:35: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:86:60: note: expanded from macro '_IOR'
      86 | #define _IOR(type,nr,argtype)           _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:15:4: note: expanded from macro '_IOC_TYPECHECK'
      15 |           sizeof(t) : __invalid_size_argument_for_IOC)
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4535:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4535 |         case KVM_SET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: expanded from macro 'KVM_SET_LAPIC'
    1396 | #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:4: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4535:7: error: array has incomplete element type 'struct kvm_lapic_state'
    4535 |         case KVM_SET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1396:35: note: expanded from macro 'KVM_SET_LAPIC'
    1396 | #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
         |                                   ^
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                                                      ^
   include/asm-generic/ioctl.h:13:25: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |                                ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4535:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4535 |         case KVM_SET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: expanded from macro 'KVM_SET_LAPIC'
    1396 | #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:14:4: note: expanded from macro '_IOC_TYPECHECK'
      14 |           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4535:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_lapic_state'
    4535 |         case KVM_SET_LAPIC:
         |              ^~~~~~~~~~~~~
   include/uapi/linux/kvm.h:1396:35: note: expanded from macro 'KVM_SET_LAPIC'
    1396 | #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:87:61: note: expanded from macro '_IOW'
      87 | #define _IOW(type,nr,argtype)           _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:15:4: note: expanded from macro '_IOC_TYPECHECK'
      15 |           sizeof(t) : __invalid_size_argument_for_IOC)
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4534:7: note: forward declaration of 'struct kvm_lapic_state'
    4534 |         case KVM_GET_LAPIC:
         |              ^
   include/uapi/linux/kvm.h:1395:61: note: expanded from macro 'KVM_GET_LAPIC'
    1395 | #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_msrs'
    4536 |         case KVM_GET_MSRS:
         |              ^~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: expanded from macro '_IOWR'
      88 | #define _IOWR(type,nr,argtype)          _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:13:4: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: forward declaration of 'struct kvm_msrs'
   include/uapi/linux/kvm.h:1389:61: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: error: array has incomplete element type 'struct kvm_msrs'
    4536 |         case KVM_GET_MSRS:
         |              ^
   include/uapi/linux/kvm.h:1389:35: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                   ^
   include/uapi/asm-generic/ioctl.h:88:72: note: expanded from macro '_IOWR'
      88 | #define _IOWR(type,nr,argtype)          _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                                                                ^
   include/asm-generic/ioctl.h:13:25: note: expanded from macro '_IOC_TYPECHECK'
      13 |         ((sizeof(t) == sizeof(t[1]) && \
         |                                ^
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: forward declaration of 'struct kvm_msrs'
   include/uapi/linux/kvm.h:1389:61: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                                             ^
>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: error: invalid application of 'sizeof' to an incomplete type 'struct kvm_msrs'
    4536 |         case KVM_GET_MSRS:
         |              ^~~~~~~~~~~~
   include/uapi/linux/kvm.h:1389:35: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/asm-generic/ioctl.h:88:72: note: expanded from macro '_IOWR'
      88 | #define _IOWR(type,nr,argtype)          _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(argtype)))
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/ioctl.h:14:4: note: expanded from macro '_IOC_TYPECHECK'
      14 |           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
         |           ^
   include/uapi/asm-generic/ioctl.h:73:5: note: expanded from macro '_IOC'
      73 |          ((size) << _IOC_SIZESHIFT))
         |            ^~~~
   arch/s390/kvm/../../../virt/kvm/kvm_main.c:4536:7: note: forward declaration of 'struct kvm_msrs'
   include/uapi/linux/kvm.h:1389:61: note: expanded from macro 'KVM_GET_MSRS'
    1389 | #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
         |                                                             ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   1 warning and 20 errors generated.


vim +4530 arch/s390/kvm/../../../virt/kvm/kvm_main.c

  4467	
  4468	static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl,
  4469				      unsigned long arg)
  4470	{
> 4471		void __user *argp = (void __user *)arg;
  4472	
  4473		switch (ioctl) {
  4474	#ifdef CONFIG_HAVE_KVM_MSI
  4475		case KVM_SIGNAL_MSI: {
  4476			struct kvm_msi msi;
  4477	
  4478			if (copy_from_user(&msi, argp, sizeof(msi)))
  4479				return -EFAULT;
  4480			return kvm_send_userspace_msi(plane, &msi);
  4481		}
  4482	#endif
  4483	#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
  4484		case KVM_SET_MEMORY_ATTRIBUTES: {
  4485			struct kvm_memory_attributes attrs;
  4486	
  4487			if (copy_from_user(&attrs, argp, sizeof(attrs)))
  4488				return -EFAULT;
  4489			return kvm_vm_ioctl_set_mem_attributes(plane, &attrs);
  4490		}
  4491	#endif
  4492		case KVM_CHECK_EXTENSION:
  4493			return kvm_plane_ioctl_check_extension(plane, arg);
  4494		case KVM_CREATE_VCPU_PLANE:
  4495			return kvm_plane_ioctl_create_vcpu(plane, arg);
  4496		default:
  4497			return -ENOTTY;
  4498		}
  4499	}
  4500	
  4501	static long kvm_plane_ioctl(struct file *filp, unsigned int ioctl,
  4502				     unsigned long arg)
  4503	{
  4504		struct kvm_plane *plane = filp->private_data;
  4505	
  4506		if (plane->kvm->mm != current->mm || plane->kvm->vm_dead)
  4507			return -EIO;
  4508	
  4509		return __kvm_plane_ioctl(plane, ioctl, arg);
  4510	}
  4511	
  4512	static int kvm_plane_release(struct inode *inode, struct file *filp)
  4513	{
  4514		struct kvm_plane *plane = filp->private_data;
  4515	
  4516		kvm_put_kvm(plane->kvm);
  4517		return 0;
  4518	}
  4519	
  4520	static struct file_operations kvm_plane_fops = {
  4521		.unlocked_ioctl = kvm_plane_ioctl,
  4522		.release = kvm_plane_release,
  4523		KVM_COMPAT(kvm_plane_ioctl),
  4524	};
  4525	
  4526	
  4527	static inline bool kvm_arch_is_vcpu_plane_ioctl(unsigned ioctl)
  4528	{
  4529		switch (ioctl) {
> 4530		case KVM_GET_DEBUGREGS:
  4531		case KVM_SET_DEBUGREGS:
  4532		case KVM_GET_FPU:
  4533		case KVM_SET_FPU:
> 4534		case KVM_GET_LAPIC:
  4535		case KVM_SET_LAPIC:
> 4536		case KVM_GET_MSRS:
  4537		case KVM_SET_MSRS:
  4538		case KVM_GET_NESTED_STATE:
  4539		case KVM_SET_NESTED_STATE:
  4540		case KVM_GET_ONE_REG:
  4541		case KVM_SET_ONE_REG:
  4542		case KVM_GET_REGS:
  4543		case KVM_SET_REGS:
  4544		case KVM_GET_SREGS:
  4545		case KVM_SET_SREGS:
  4546		case KVM_GET_SREGS2:
  4547		case KVM_SET_SREGS2:
  4548		case KVM_GET_VCPU_EVENTS:
  4549		case KVM_SET_VCPU_EVENTS:
  4550		case KVM_GET_XCRS:
  4551		case KVM_SET_XCRS:
  4552		case KVM_GET_XSAVE:
  4553		case KVM_GET_XSAVE2:
  4554		case KVM_SET_XSAVE:
  4555	
  4556		case KVM_GET_REG_LIST:
  4557		case KVM_TRANSLATE:
  4558			return true;
  4559	
  4560		default:
  4561			return false;
  4562		}
  4563	}
  4564	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

