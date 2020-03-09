Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43AD17D7A2
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 01:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCIA6x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 8 Mar 2020 20:58:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:16346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgCIA6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Mar 2020 20:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Mar 2020 17:58:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="260255816"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga002.jf.intel.com with ESMTP; 08 Mar 2020 17:58:50 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 8 Mar 2020 17:58:50 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.50]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.144]) with mapi id 14.03.0439.000;
 Mon, 9 Mar 2020 08:58:47 +0800
From:   "Xu, Like" <like.xu@intel.com>
To:     lkp <lkp@intel.com>, "Kang, Luwei" <luwei.kang@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>
Subject: RE: [PATCH v1 05/11] KVM: x86/pmu: Add support to reprogram PEBS
 event for guest counters
Thread-Topic: [PATCH v1 05/11] KVM: x86/pmu: Add support to reprogram PEBS
 event for guest counters
Thread-Index: AQJvPzxww5HXayZ7yL4sj1CxXq+eMQM8p73NpvL3z6A=
Date:   Mon, 9 Mar 2020 00:58:47 +0000
Message-ID: <F7FC466FA1E455449AD0F9063BBE758E0C868500@shsmsx102.ccr.corp.intel.com>
References: <1583431025-19802-6-git-send-email-luwei.kang@intel.com>
 <202003070038.amFy5Etu%lkp@intel.com>
In-Reply-To: <202003070038.amFy5Etu%lkp@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: kbuild test robot <lkp@intel.com>
> Sent: Saturday, March 7, 2020 12:28 AM
> To: Luwei Kang <luwei.kang@intel.com>
> Cc: kbuild-all@lists.01.org; x86@kernel.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; peterz@infradead.org; mingo@redhat.com;
> acme@kernel.org; mark.rutland@arm.com;
> alexander.shishkin@linux.intel.com; jolsa@redhat.com;
> namhyung@kernel.org; tglx@linutronix.de; bp@alien8.de; hpa@zytor.com;
> pbonzini@redhat.com; sean.j.christopherson@intel.com;
> vkuznets@redhat.com; wanpengli@tencent.com; jmattson@google.com;
> joro@8bytes.org; pawan.kumar.gupta@linux.intel.com; ak@linux.intel.com;
> thomas.lendacky@amd.com; fenghua.yu@intel.com;
> kan.liang@linux.intel.com; like.xu@linux.intel.com
> Subject: Re: [PATCH v1 05/11] KVM: x86/pmu: Add support to reprogram PEBS
> event for guest counters
> 
> Hi Luwei,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/linux-next] [also build test ERROR on
> tip/perf/core tip/auto-latest v5.6-rc4 next-20200306] [if your patch is applied to
> the wrong git tree, please drop us a note to help improve the system. BTW, we
> also suggest to use '--base' option to specify the base tree in git format-patch,
> please see https://stackoverflow.com/a/37406982]
> 
> url:
> https://github.com/0day-ci/linux/commits/Luwei-Kang/PEBS-virtualization-ena
> bling-via-DS/20200306-013049
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
> config: x86_64-randconfig-h003-20200305 (attached as .config)
> compiler: gcc-7 (Debian 7.5.0-5) 7.5.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: arch/x86/kvm/pmu.o: in function `pmc_reprogram_counter':
> >> arch/x86/kvm/pmu.c:199: undefined reference to
> `perf_x86_pmu_unset_auto_reload'

Since we may not lose PEBS functionality for other x86 vendors on KVM
and we already have defined PERF_X86_EVENT_AUTO_RELOAD in the general
arch/x86/events/perf_event.h,

one of the ways to fix this issue is to
move the definition of perf_x86_pmu_unset_auto_reload()
to the end of arch/x86/events/core.c
instead of making it Intel specific
in previous patch "perf/x86: Expose a function to disable auto-reload."

Thanks,
Like Xu

> 
> vim +199 arch/x86/kvm/pmu.c
> 
>    101
>    102	static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>    103					  unsigned config, bool exclude_user,
>    104					  bool exclude_kernel, bool intr,
>    105					  bool in_tx, bool in_tx_cp)
>    106	{
>    107		struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
>    108		struct perf_event *event;
>    109		struct perf_event_attr attr = {
>    110			.type = type,
>    111			.size = sizeof(attr),
>    112			.pinned = true,
>    113			.exclude_idle = true,
>    114			.exclude_host = 1,
>    115			.exclude_user = exclude_user,
>    116			.exclude_kernel = exclude_kernel,
>    117			.config = config,
>    118			.disabled = 1,
>    119		};
>    120		bool pebs = test_bit(pmc->idx, (unsigned long
> *)&pmu->pebs_enable);
>    121
>    122		attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
>    123
>    124		if (in_tx)
>    125			attr.config |= HSW_IN_TX;
>    126		if (in_tx_cp) {
>    127			/*
>    128			 * HSW_IN_TX_CHECKPOINTED is not supported with
> nonzero
>    129			 * period. Just clear the sample period so at least
>    130			 * allocating the counter doesn't fail.
>    131			 */
>    132			attr.sample_period = 0;
>    133			attr.config |= HSW_IN_TX_CHECKPOINTED;
>    134		}
>    135
>    136		if (pebs) {
>    137			/*
>    138			 * Host never knows the precision level set by guest.
>    139			 * Force Host's PEBS event to precision level 1, which will
>    140			 * not impact the accuracy of the results for guest PEBS
> events.
>    141			 * Because,
>    142			 * - For most cases, there is no difference among precision
>    143			 *   level 1 to 3 for PEBS events.
>    144			 * - The functions as below checks the precision level in
> host.
>    145			 *   But the results from these functions in host are
> replaced
>    146			 *   by guest when sampling the guest.
>    147			 *   The accuracy for guest PEBS events will not be
> impacted.
>    148			 *    -- event_constraints() impacts the index of counter.
>    149			 *	The index for host event is exactly the same as guest.
>    150			 *	It's decided by guest.
>    151			 *    -- pebs_update_adaptive_cfg() impacts the value of
>    152			 *	MSR_PEBS_DATA_CFG. When guest is switched in,
>    153			 *	the MSR value will be replaced by the value from
> guest.
>    154			 *    -- setup_sample () impacts the output of a PEBS
> record.
>    155			 *	Guest handles the PEBS records.
>    156			 */
>    157			attr.precise_ip = 1;
>    158			/*
>    159			 * When the host's PMI handler completes, it's going to
>    160			 * enter the guest and trigger the guest's PMI handler.
>    161			 *
>    162			 * At this moment, this function may be called by
>    163			 * kvm_pmu_handle_event(). However the next
> sample_period
>    164			 * hasn't been determined by guest yet and the left period,
>    165			 * which probably be 0, is used for current sample_period.
>    166			 *
>    167			 * In this case, perf will mistakenly treat it as non
>    168			 * sampling events. The PEBS event will error out.
>    169			 *
>    170			 * Fill it with maximum period to prevent the error out.
>    171			 * The guest PMI handler will soon reprogram the counter.
>    172			 */
>    173			if (!attr.sample_period)
>    174				attr.sample_period = (-1ULL) & pmc_bitmask(pmc);
>    175		}
>    176
>    177		event = perf_event_create_kernel_counter(&attr, -1, current,
>    178							 (intr || pebs) ?
>    179							 kvm_perf_overflow_intr :
>    180							 kvm_perf_overflow, pmc);
>    181		if (IS_ERR(event)) {
>    182			pr_debug_ratelimited("kvm_pmu: event creation failed %ld
> for pmc->idx = %d\n",
>    183				    PTR_ERR(event), pmc->idx);
>    184			return;
>    185		}
>    186
>    187		if (pebs) {
>    188			event->guest_dedicated_idx = pmc->idx;
>    189			/*
>    190			 * For guest PEBS events, guest takes the responsibility to
>    191			 * drain PEBS buffers, and load proper values to reset
> counters.
>    192			 *
>    193			 * Host will unconditionally set auto-reload flag for PEBS
>    194			 * events with fixed period which is not necessary. Host
> should
>    195			 * do nothing in drain_pebs() but inject the PMI into the
> guest.
>    196			 *
>    197			 * Unset the auto-reload flag for guest PEBS events.
>    198			 */
>  > 199			perf_x86_pmu_unset_auto_reload(event);
>    200		}
>    201		pmc->perf_event = event;
>    202		pmc_to_pmu(pmc)->event_count++;
>    203		perf_event_enable(event);
>    204		clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>    205	}
>    206
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
