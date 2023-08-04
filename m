Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC9476F984
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 07:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjHDFW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 01:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbjHDFUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 01:20:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BFD13E;
        Thu,  3 Aug 2023 22:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691126232; x=1722662232;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e1cpoVNcGs0kUXxIvP1Pk1UFLtW1Z3PkHvbpqT0KCQE=;
  b=E8tTOvAUy9buQI1MNBOiU07rtLMS9opIXbt4xrDJsyVS8NwxaYCdML9P
   +OEZi/06XEytWWaFhKSr+ZtQSykRcwZe/rltf71cDkVaIjOr4wr5vMtxR
   2cdKFpFWT3vmPh56g8n2C6faLAm+Y/c5dxCkCB32zFsEQB9pcnaaZZx2r
   MV9XBDtEWR0ZSIXrOiGoAcLpsxMayT67p6UXWsC2LB4KJsZLOycWyuXbG
   mK3Wrqe7rlXqmmSLBjRueaGdW1nC9FMpn1cJaFzZpnryH5BYo6p0yv5BA
   L4KzVdkbE5nLT5WEgqn2JNTUfW3S7O0m0Rfn+OF2IBIoo7kyIyT1W0fuR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="349660662"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="349660662"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 22:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="1060583122"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="1060583122"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2023 22:17:05 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qRnBQ-0002dU-1y;
        Fri, 04 Aug 2023 05:17:04 +0000
Date:   Fri, 4 Aug 2023 13:16:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Charlie Jenkins <charlie@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>
Subject: Re: [PATCH 10/10] RISC-V: Refactor bug and traps instructions
Message-ID: <202308041213.o49SRQWZ-lkp@intel.com>
References: <20230803-master-refactor-instructions-v4-v1-10-2128e61fa4ff@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803-master-refactor-instructions-v4-v1-10-2128e61fa4ff@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Charlie,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4]

url:    https://github.com/intel-lab-lkp/linux/commits/Charlie-Jenkins/RISC-V-Expand-instruction-definitions/20230804-101437
base:   5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
patch link:    https://lore.kernel.org/r/20230803-master-refactor-instructions-v4-v1-10-2128e61fa4ff%40rivosinc.com
patch subject: [PATCH 10/10] RISC-V: Refactor bug and traps instructions
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20230804/202308041213.o49SRQWZ-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230804/202308041213.o49SRQWZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308041213.o49SRQWZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/riscv/kernel/elf_kexec.c:326: warning: "RV_X" redefined
     326 | #define RV_X(x, s, n)  (((x) >> (s)) & ((1 << (n)) - 1))
         | 
   In file included from arch/riscv/include/asm/bug.h:14,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/riscv/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/ipc.h:5,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/compat.h:14,
                    from arch/riscv/include/asm/elf.h:12,
                    from include/linux/elf.h:6,
                    from arch/riscv/kernel/elf_kexec.c:15:
   arch/riscv/include/asm/insn.h:1915: note: this is the location of the previous definition
    1915 | #define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
         | 


vim +/RV_X +326 arch/riscv/kernel/elf_kexec.c

6261586e0c91db1 Liao Chang 2022-04-08  325  
838b3e28488f702 Li Zhengyu 2022-04-08 @326  #define RV_X(x, s, n)  (((x) >> (s)) & ((1 << (n)) - 1))
838b3e28488f702 Li Zhengyu 2022-04-08  327  #define RISCV_IMM_BITS 12
838b3e28488f702 Li Zhengyu 2022-04-08  328  #define RISCV_IMM_REACH (1LL << RISCV_IMM_BITS)
838b3e28488f702 Li Zhengyu 2022-04-08  329  #define RISCV_CONST_HIGH_PART(x) \
838b3e28488f702 Li Zhengyu 2022-04-08  330  	(((x) + (RISCV_IMM_REACH >> 1)) & ~(RISCV_IMM_REACH - 1))
838b3e28488f702 Li Zhengyu 2022-04-08  331  #define RISCV_CONST_LOW_PART(x) ((x) - RISCV_CONST_HIGH_PART(x))
838b3e28488f702 Li Zhengyu 2022-04-08  332  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
