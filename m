Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB674C2BDF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 04:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJAC1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 22:27:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:4955 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfJAC1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 22:27:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 19:27:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,569,1559545200"; 
   d="gz'50?scan'50,208,50";a="342844428"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 30 Sep 2019 19:27:21 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iF7sm-000Hbp-N6; Tue, 01 Oct 2019 10:27:20 +0800
Date:   Tue, 1 Oct 2019 10:27:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     kbuild-all@01.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf/core: Provide a kernel-internal interface to
 recalibrate event period
Message-ID: <201910011012.hrxsct0p%lkp@intel.com>
References: <20190930072257.43352-2-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y6hkg7ownhbp6ulw"
Content-Disposition: inline
In-Reply-To: <20190930072257.43352-2-like.xu@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--y6hkg7ownhbp6ulw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Like,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/linux-next]
[cannot apply to v5.4-rc1 next-20190930]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/perf-core-Provide-a-kernel-internal-interface-to-recalibrate-event-period/20191001-081543
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
config: nds32-allnoconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 8.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=8.1.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   nds32le-linux-ld: init/do_mounts.o: in function `perf_event_period':
>> do_mounts.c:(.text+0xc): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: init/noinitramfs.o: in function `perf_event_period':
   noinitramfs.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: arch/nds32/kernel/sys_nds32.o: in function `perf_event_period':
   sys_nds32.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: arch/nds32/kernel/syscall_table.o: in function `perf_event_period':
   syscall_table.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: arch/nds32/mm/fault.o: in function `perf_event_period':
   fault.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/fork.o: in function `perf_event_period':
   fork.c:(.text+0x374): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/exec_domain.o: in function `perf_event_period':
   exec_domain.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/cpu.o: in function `perf_event_period':
   cpu.c:(.text+0xd4): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/exit.o: in function `perf_event_period':
   exit.c:(.text+0xf30): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sysctl.o: in function `perf_event_period':
   sysctl.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sysctl_binary.o: in function `perf_event_period':
   sysctl_binary.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/capability.o: in function `perf_event_period':
   capability.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/ptrace.o: in function `perf_event_period':
   ptrace.c:(.text+0x3f4): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/signal.o: in function `perf_event_period':
   signal.c:(.text+0x580): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sys.o: in function `perf_event_period':
   sys.c:(.text+0x70c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/umh.o: in function `perf_event_period':
   umh.c:(.text+0x4c8): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/pid.o: in function `perf_event_period':
   pid.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/nsproxy.o: in function `perf_event_period':
   nsproxy.c:(.text+0x14c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/reboot.o: in function `perf_event_period':
   reboot.c:(.text+0x6c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/core.o: in function `perf_event_period':
   core.c:(.text+0x338): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/loadavg.o: in function `perf_event_period':
   loadavg.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/clock.o: in function `perf_event_period':
   clock.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/cputime.o: in function `perf_event_period':
   cputime.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/idle.o: in function `perf_event_period':
   idle.c:(.text+0x94): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/fair.o: in function `perf_event_period':
   fair.c:(.text+0xe68): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/rt.o: in function `perf_event_period':
   rt.c:(.text+0x9bc): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/deadline.o: in function `perf_event_period':
   deadline.c:(.text+0x138c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/wait.o: in function `perf_event_period':
   wait.c:(.text+0x16c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/wait_bit.o: in function `perf_event_period':
   wait_bit.c:(.text+0x70): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/swait.o: in function `perf_event_period':
   swait.c:(.text+0x28): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/sched/completion.o: in function `perf_event_period':
   completion.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/power/qos.o: in function `perf_event_period':
   qos.c:(.text+0xbc): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/printk/printk.o: in function `perf_event_period':
   printk.c:(.text+0x1cc): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/time/time.o: in function `perf_event_period':
   time.c:(.text+0x3c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/time/timer.o: in function `perf_event_period':
   timer.c:(.text+0x3a4): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/time/hrtimer.o: in function `perf_event_period':
   hrtimer.c:(.text+0x5c4): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/time/posix-stubs.o: in function `perf_event_period':
   posix-stubs.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: kernel/time/tick-common.o: in function `perf_event_period':
   tick-common.c:(.text+0x18c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/fadvise.o: in function `perf_event_period':
   fadvise.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/page-writeback.o: in function `perf_event_period':
   page-writeback.c:(.text+0x668): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/readahead.o: in function `perf_event_period':
   readahead.c:(.text+0x198): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/debug.o: in function `perf_event_period':
   debug.c:(.text+0x74): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/mincore.o: in function `perf_event_period':
   mincore.c:(.text+0x184): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/mlock.o: in function `perf_event_period':
   mlock.c:(.text+0x528): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/mmap.o: in function `perf_event_period':
   mmap.c:(.text+0x63c): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/mprotect.o: in function `perf_event_period':
   mprotect.c:(.text+0x2b8): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/mremap.o: in function `perf_event_period':
   mremap.c:(.text+0xdc): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: mm/msync.o: in function `perf_event_period':
   msync.c:(.text+0x0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: fs/open.o: in function `perf_event_period':
   open.c:(.text+0x3f4): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: fs/read_write.o: in function `perf_event_period':
   read_write.c:(.text+0x300): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here
   nds32le-linux-ld: fs/stat.o: in function `perf_event_period':
   stat.c:(.text+0x2f0): multiple definition of `perf_event_period'; init/main.o:main.c:(.text+0x0): first defined here

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--y6hkg7ownhbp6ulw
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AA==

--y6hkg7ownhbp6ulw--
