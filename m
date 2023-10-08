Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BBE7BCFE9
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 21:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344476AbjJHT6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 15:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjJHT6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 15:58:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E5DAC;
        Sun,  8 Oct 2023 12:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696795109; x=1728331109;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cKwxlSWZrewmQgKrJB6brf7XXi0sqVpTNLHHsR9nXbk=;
  b=iKzYpjOTzqKhKXQMSN+eojWZ8S0Fnupg6Lm05Jfs3CG2UNx84ZjYaKeA
   Y0f5n6vzTdRCRv/5BSTp0p20dnnXNEUR7qw0GbKUn6oZmgSA0EoOggYWl
   /RlP4M4ih8h7AeEWkC+iDMlGmgl9L2uNc9KhOKhQDIK1W5Zg48aqkObH2
   xK3i5oQDR83q9LKAncTBseRj/QzuugSED/Bci97xo79vnkbGrq8ruFdWb
   esWW4xjNEfEykbdf2fthyoDNaLet92EtNer0O6S/B01TvfFYmk+yAFbYA
   26gPG2UnV9SmW/HHOr1UvAFZI5+N7idEKA6fY5m+YnRahylb6pClIsbaj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="415019063"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="415019063"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 12:58:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="869002523"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="869002523"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2023 12:58:13 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qpZul-0005hz-1T;
        Sun, 08 Oct 2023 19:58:11 +0000
Date:   Mon, 9 Oct 2023 03:57:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianyi Liu <i.pear@outlook.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
Message-ID: <202310090338.4PmYjmBS-lkp@intel.com>
References: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianyi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB108433024762F1F292D47C2A9DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20231009/202310090338.4PmYjmBS-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231009/202310090338.4PmYjmBS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310090338.4PmYjmBS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/events/core.c: In function 'perf_callchain_guest32':
>> arch/x86/events/core.c:2784:43: warning: passing argument 1 of 'perf_guest_read_virt' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2784 |                 if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
         |                                           ^~~~~~~~~~~~~~~
   In file included from arch/x86/events/core.c:15:
   include/linux/perf_event.h:1531:41: note: expected 'void *' but argument is of type 'const u32 *' {aka 'const unsigned int *'}
    1531 | static inline bool perf_guest_read_virt(void*, void*, unsigned int)     { return 0; }
         |                                         ^~~~~
   arch/x86/events/core.c:2787:43: warning: passing argument 1 of 'perf_guest_read_virt' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2787 |                 if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
         |                                           ^~~~~~~~~~~~~~~~~~~
   include/linux/perf_event.h:1531:41: note: expected 'void *' but argument is of type 'const u32 *' {aka 'const unsigned int *'}
    1531 | static inline bool perf_guest_read_virt(void*, void*, unsigned int)     { return 0; }
         |                                         ^~~~~
   arch/x86/events/core.c: In function 'perf_callchain_guest':
   arch/x86/events/core.c:2808:51: warning: passing argument 1 of 'perf_guest_read_virt' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2808 |                         if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
         |                                                   ^~~~~~~~~~~~~~~
   include/linux/perf_event.h:1531:41: note: expected 'void *' but argument is of type 'struct stack_frame * const*'
    1531 | static inline bool perf_guest_read_virt(void*, void*, unsigned int)     { return 0; }
         |                                         ^~~~~
   arch/x86/events/core.c:2811:51: warning: passing argument 1 of 'perf_guest_read_virt' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2811 |                         if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
         |                                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/perf_event.h:1531:41: note: expected 'void *' but argument is of type 'const long unsigned int *'
    1531 | static inline bool perf_guest_read_virt(void*, void*, unsigned int)     { return 0; }
         |                                         ^~~~~


vim +2784 arch/x86/events/core.c

  2775	
  2776	static inline void
  2777	perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
  2778	{
  2779		struct stack_frame_ia32 frame;
  2780		const struct stack_frame_ia32 *fp;
  2781	
  2782		fp = (void *)perf_guest_get_frame_pointer();
  2783		while (fp && entry->nr < entry->max_stack) {
> 2784			if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
  2785				sizeof(frame.next_frame)))
  2786				break;
  2787			if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
  2788				sizeof(frame.return_address)))
  2789				break;
  2790			perf_callchain_store(entry, frame.return_address);
  2791			fp = (void *)frame.next_frame;
  2792		}
  2793	}
  2794	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
