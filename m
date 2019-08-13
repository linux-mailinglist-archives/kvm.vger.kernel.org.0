Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FA68B295
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfHMIfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:35:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:62264 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbfHMIfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:35:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 01:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="gz'50?scan'50,208,50";a="351471529"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 13 Aug 2019 01:35:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hxSGj-000Ayr-1V; Tue, 13 Aug 2019 16:35:01 +0800
Date:   Tue, 13 Aug 2019 16:34:57 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kbuild-all@01.org, nitesh@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v5 4/6] mm: Introduce Reported pages
Message-ID: <201908131650.yQgS9S59%lkp@intel.com>
References: <20190812213344.22097.86213.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hasjxodgduzemjqp"
Content-Disposition: inline
In-Reply-To: <20190812213344.22097.86213.stgit@localhost.localdomain>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hasjxodgduzemjqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/mm-virtio-Provide-support-for-unused-page-reporting/20190813-150543
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

    
   In file included from include/linux/thread_info.h:38:0,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/thread_info.h:9:0: note: this is the location of the previous definition
    #define THREAD_SIZE_ORDER CONFIG_KERNEL_STACK_ORDER
    
   In file included from arch/x86/include/asm/page_types.h:48:0,
                    from arch/x86/include/asm/pgtable_types.h:8,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/page_64_types.h:16:0: warning: "THREAD_SIZE" redefined
    #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
    
   In file included from include/linux/thread_info.h:38:0,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/thread_info.h:10:0: note: this is the location of the previous definition
    #define THREAD_SIZE ((1 << CONFIG_KERNEL_STACK_ORDER) * PAGE_SIZE)
    
   In file included from arch/x86/include/asm/pgtable_types.h:249:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_64_types.h:21:34: error: conflicting types for 'pte_t'
    typedef struct { pteval_t pte; } pte_t;
                                     ^~~~~
   In file included from arch/um/include/asm/thread_info.h:15:0,
                    from include/linux/thread_info.h:38,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/page.h:57:39: note: previous declaration of 'pte_t' was here
    typedef struct { unsigned long pte; } pte_t;
                                          ^~~~~
   In file included from include/linux/page_reporting.h:8:0,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_types.h:265:47: error: conflicting types for 'pgprot_t'
    typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;
                                                  ^~~~~~~~
   In file included from arch/um/include/asm/thread_info.h:15:0,
                    from include/linux/thread_info.h:38,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/page.h:80:42: note: previous declaration of 'pgprot_t' was here
    typedef struct { unsigned long pgprot; } pgprot_t;
                                             ^~~~~~~~
   In file included from include/linux/page_reporting.h:8:0,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_types.h:267:34: error: conflicting types for 'pgd_t'
    typedef struct { pgdval_t pgd; } pgd_t;
                                     ^~~~~
   In file included from arch/um/include/asm/thread_info.h:15:0,
                    from include/linux/thread_info.h:38,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/page.h:58:39: note: previous declaration of 'pgd_t' was here
    typedef struct { unsigned long pgd; } pgd_t;
                                          ^~~~~
   In file included from arch/x86/include/asm/pgtable_types.h:346:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
>> include/asm-generic/pgtable-nopud.h:21:0: warning: "PUD_SHIFT" redefined
    #define PUD_SHIFT P4D_SHIFT
    
   In file included from arch/x86/include/asm/pgtable_types.h:249:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_64_types.h:83:0: note: this is the location of the previous definition
    #define PUD_SHIFT 30
    
   In file included from arch/x86/include/asm/pgtable_types.h:346:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
>> include/asm-generic/pgtable-nopud.h:22:0: warning: "PTRS_PER_PUD" redefined
    #define PTRS_PER_PUD 1
    
   In file included from arch/x86/include/asm/pgtable_types.h:249:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_64_types.h:84:0: note: this is the location of the previous definition
    #define PTRS_PER_PUD 512
    
   In file included from arch/x86/include/asm/pgtable_types.h:346:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
>> include/asm-generic/pgtable-nopud.h:23:0: warning: "PUD_SIZE" redefined
    #define PUD_SIZE   (1UL << PUD_SHIFT)
    
   In file included from arch/x86/include/asm/pgtable_types.h:249:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_64_types.h:100:0: note: this is the location of the previous definition
    #define PUD_SIZE (_AC(1, UL) << PUD_SHIFT)
    
   In file included from arch/x86/include/asm/pgtable_types.h:346:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
>> include/asm-generic/pgtable-nopud.h:24:0: warning: "PUD_MASK" redefined
    #define PUD_MASK   (~(PUD_SIZE-1))
    
   In file included from arch/x86/include/asm/pgtable_types.h:249:0,
                    from include/linux/page_reporting.h:8,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_64_types.h:101:0: note: this is the location of the previous definition
    #define PUD_MASK (~(PUD_SIZE - 1))
    
   In file included from include/linux/page_reporting.h:8:0,
                    from include/linux/mmzone.h:774,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/x86/include/asm/pgtable_types.h:360:34: error: conflicting types for 'pmd_t'
    typedef struct { pmdval_t pmd; } pmd_t;
                                     ^~~~~
   In file included from arch/um/include/asm/thread_info.h:15:0,
                    from include/linux/thread_info.h:38,
                    from include/asm-generic/current.h:5,
                    from ./arch/um/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:3,
                    from arch/um/kernel/asm-offsets.c:1:
   arch/um/include/asm/page.h:61:39: note: previous declaration of 'pmd_t' was here
    typedef struct { unsigned long pmd; } pmd_t;
                                          ^~~~~
   make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [sub-make] Error 2
   4 real  4 user  2 sys  157.04% cpu 	make prepare

vim +/PUD_SHIFT +21 include/asm-generic/pgtable-nopud.h

^1da177e4c3f41 Linus Torvalds     2005-04-16  20  
048456dcf2c56a Kirill A. Shutemov 2017-03-09 @21  #define PUD_SHIFT	P4D_SHIFT
^1da177e4c3f41 Linus Torvalds     2005-04-16 @22  #define PTRS_PER_PUD	1
^1da177e4c3f41 Linus Torvalds     2005-04-16 @23  #define PUD_SIZE  	(1UL << PUD_SHIFT)
^1da177e4c3f41 Linus Torvalds     2005-04-16 @24  #define PUD_MASK  	(~(PUD_SIZE-1))
^1da177e4c3f41 Linus Torvalds     2005-04-16  25  

:::::: The code at line 21 was first introduced by commit
:::::: 048456dcf2c56ad6f6248e2899dda92fb6a613f6 asm-generic: introduce <asm-generic/pgtable-nop4d.h>

:::::: TO: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--hasjxodgduzemjqp
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--hasjxodgduzemjqp--
