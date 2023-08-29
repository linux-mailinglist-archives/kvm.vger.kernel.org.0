Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842C278BEFE
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 09:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjH2HNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 03:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjH2HNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 03:13:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D0C11C
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 00:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693293224; x=1724829224;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=FmypMD+wxhIxZ6VtCoLh5TxNR85Ln1suWjNfyRH1P7A=;
  b=E8B8jX6/7bJrszJdTng8EtmRSVMe76SlBYpkcC+lJ3ea6ogUxeIj+A2H
   PUXxv/rHOw5/DYMGocHGQkKchwqRq3s/akVoris/Y6POmt3aythbUQq1w
   GzQe3VcwpZSphrNLW9hBh525IfEbzfeRh+AUQfVZc19+TfQ6O7onna/ew
   FOD42VYk5/uokEBuQ2jFAJGFozLN8D/yWcYoEvn+QJovw9+2eaEFWcLIF
   +v0SNRHNsYZ0fjfrFeVCYBoo9cESqIPkSl1dOuovsTnmE7+Nrq1PBf+9g
   fgU0w2Kr5dyY9Dn9dQNusKOSEoN0jHxj0v2Ur9AFUD/1DL8t2IYmAZENf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="360295154"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="360295154"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 00:13:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="715413255"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="715413255"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 29 Aug 2023 00:13:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 00:13:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 29 Aug 2023 00:13:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 29 Aug 2023 00:13:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0KkCOxWv/rRqXSQPZwSGUKUK5NRRwrDNHk99y04nWNVSqBMUz5WRUt8FRfQD8O1B/UTKwBRc+PtpTFqlvSPU+iv0eWcP4rosorRBlLELeGHHAHQNmvKKevR/rYKGdrG1TrhAw5YD/3u3vgc+UZ/HknCinzkPJr+E2zMv2cWci4qJqwCeVQl1L/tKA7CGcdd/6iFpvwa8+8lsKnhkSw3U8PiKPILOplzwrpOE+1uV7tkXsSN8lCAFhZGju6iILEoptIjgPz29qIvGcUKK9HjBmRy0bV5KGGw0EnSDATlRT2439Gz5tuINTTuk1HN/jmobpIn4RfnVC4SDZWm07lehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncuaK+8HHJ66IRnolHVeg/CPRgfGB4AsR8+b0GjVE5Y=;
 b=bGqFdQnTHKdy7zAQ4W0VQnzg5NKE/3/bpw/so4xNZ9/OGAiKeFQNsWcVnbsNqojvFF+2TrYrTQLCvQl6dUchr4qysPYBd3BEFBhaKGgyWdb8/bgBYIpCYb0f5LmKi9td/87b7AHUXrEkmQtMdC5DvkJhEerUk5rZzOMvJnVoogyKvjZ7bv3oPlTVB5oH89CLiXvTblSBXwzHOJ/RJ/ZVIOunj/mWR4L73QqJjAqhJgrKPxwbHrpe+VSOXLp07v1Pe7fZAzufno+HjuevrTNkFDuKUc7NkewzUqik5RRqjeIDiokoeXHORR3YjRAJlqUE3N6wy6pXBC1XqVxkqd2RhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by DM4PR11MB8132.namprd11.prod.outlook.com (2603:10b6:8:17e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Tue, 29 Aug
 2023 07:13:32 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6699.034; Tue, 29 Aug 2023
 07:13:32 +0000
Date:   Tue, 29 Aug 2023 15:13:22 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
        <oliver.sang@intel.com>
Subject: [sean-jc:x86/dynamic_mmu_page_hash] [KVM] 9a65885b67:
 canonical_address#:#[##]
Message-ID: <202308291427.85de5a98-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: KL1PR01CA0129.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::21) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|DM4PR11MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 696a064a-ec60-4818-baa5-08dba85f73cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2uKSa0ys0mktMpJt50tJ0bBpDXjsqhC8Uv+1/xS5roYrERFNVTPoahcomaanMrKAqyzN0HKmjSILhgi2tpq72/iVIApKSDlnqjb6/64Zljm8jSQpT9XNXTxSNa3eeKvWhZFAYF66mrwpsHV2ikEb+3PfK8GjzL6NDqHead3v8T7Xr3xPXGFISWMi09pG7/oyAqcmji03b5UzTdb1CvIJLLfTOvxtnpPIHUedw0ZWnFep6WKSzHZ8UZQ3RHFpEZkA5RMqe7u1B0zfXKGOBM8mIBuygru1Dm41zkW6giCaJqZgBbG0vBlWcEg/XfUcSAvqbLZ6/1T/Z1+YlYmo5C4VmHoZ2rU4Bmo20wg3hSEcDe5JoEo1BtPm/6d9htyjZ5R8be7ibJtW/ZADgzcuZ8RMyot0EHv9bvyThE0rLUNHd3GHVMD7YOcMg9U3o7fdmTyoG8EAoNG3gioWdY8PdXZ2k9Ugxvq1MBQ0Wecvmy9egW66wftjponE9tNZtrjXBD3QN23xNOK4P7Jb3kTnBWw7A68dYDcKfk0FkBMO7ridrhiatYwSsAVq3C+dOQPMDo6aLLy4DbFaepZ7rS76gLHJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(1800799009)(451199024)(186009)(6512007)(38100700002)(316002)(6916009)(41300700001)(82960400001)(4326008)(2906002)(83380400001)(86362001)(2616005)(107886003)(26005)(36756003)(5660300002)(1076003)(8676002)(8936002)(6666004)(6506007)(966005)(6486002)(66556008)(66476007)(66946007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8yYWyrFxDWq7nNCasEcASeO3OWiDVr3gKssQH9RoDofjNV4jkNTN7hzf4GhT?=
 =?us-ascii?Q?ehPiWrpSbnNVcAnW0iO3uZzqPD3PSzD/uTEFRkwXQMqsWfVnNJ7q2fAKNZLz?=
 =?us-ascii?Q?3sbn330/VpQWFsNQYvGQoVazRRA4/fJ/Z4ww/H1OJwjMEjNF8lCDUYsLCo9A?=
 =?us-ascii?Q?xdLYO2OBVop53wAE9GX2vKfHelp4EhH8Sn8JcvY0HuEAE6xByDxpWWRZrQ5r?=
 =?us-ascii?Q?bWcbnvvZZgl5W+YTQb+peOq3WFDranauhu88dxG90+n9EzhvBrlJwxTomyuy?=
 =?us-ascii?Q?7hUGwZQ9sM3YLkcwCHy2BXdQ6lhKU/8nMBGMbmtuFkx/G+sywQKofpUO7Rku?=
 =?us-ascii?Q?huMjrj48LezB5N/ZIutOWG3w8fn5xWIcD0UaxYFqjUYsQYKkFwpL6xM5+BlW?=
 =?us-ascii?Q?lsoayVxXkRaHAM0ySrLIQoze19qlk3K+orZ2tPzae+IQKNLGT5X74ei5gnQI?=
 =?us-ascii?Q?XnnknYgx/LQhZQvsS9PD8Q34lueHmK6JksDz/8S3xZmiJCwh0VG9Sob5qMrn?=
 =?us-ascii?Q?dqnbcXTeVTs72cw8U7sWOFA0BueVEDkv+0ZR1rEjhH6+9k/NGp8blkscgoTh?=
 =?us-ascii?Q?wwLbrL6+H4iop1kI0aPSHywP24QcC4m2Lv1lSsAqQFbflHa82/1eZwyRg7tV?=
 =?us-ascii?Q?ct+Zw0p7ZNadV9OTKn22CunBnUVFn6fGGdkWfVSB7dxL9S8JYfAs7ePSofH8?=
 =?us-ascii?Q?VE8CI3UMbLgfSO4Vc08E305gCZS8QI+cCBi2yA3nk5/IEXPosqnwqJzDNsZQ?=
 =?us-ascii?Q?hojDsY1fgm8RULeVJ8Vd0FAeB26x+FNiMitSurPEdN08QyIOS3juVvSDIjWA?=
 =?us-ascii?Q?dtjmn8HVm3I1Gxa6O3Ou7jWNgAnwkhPV19verYX2NCh6s4uKUt6ZiHochJH6?=
 =?us-ascii?Q?Xu0cziX+f+z1hDqBLGdMNRAF7GDtx3siblV6eSVvVNKhIQUNoHrIhWgcAARY?=
 =?us-ascii?Q?f84mkilf/KpDryPjQoMBXQO3ijc7TKt9zhdofgaundst2LTm0guXn1pGYZS4?=
 =?us-ascii?Q?eCAvmBIxm25R6g/LnB4CWuNbWqCFLGdiocvHDV4FOWD0ugumQFUZhqoI7tw4?=
 =?us-ascii?Q?iXcTKJbBW0Udj0gzH/PJD+E+0mDthppwBBJA53+OZ+PQMrSoqKxhyCAxuG6k?=
 =?us-ascii?Q?byddRmIcezR8YFjlXOh47EA51gV9zO5x+dia5eFaMFK3DFkF0pihyzueKnY5?=
 =?us-ascii?Q?2vkvHuc7vRroR6P9nWdshx63vZUPIwsOOrY14NaLz/hHq5CANmxXz72G+iAl?=
 =?us-ascii?Q?SPdsOGNKJE+qgkQ9CL2CLMBc8V8xpsQhi9+inDiHTLc87uU88Wx+Ck8MHCiZ?=
 =?us-ascii?Q?qQqY6XT0req2I4MBEsluse9cOl8Q+FrszAVmMUPLbDWIHrwKZ1wRxPapBfmr?=
 =?us-ascii?Q?I3LRnlB4OZppPbC8qUMQu52P23nB4txSnPbjh5EiJmN1fItnOlXvs2ZBLAt/?=
 =?us-ascii?Q?wwOMovH/0P4A7st+FxuBE4hl8/4pwNn2wa+IO8kKwo+F5OYRuygETbIFUCNj?=
 =?us-ascii?Q?qceSoNMlFQaX31SV4Cvq22kp/Mj/iGkFPs/ctKYLleT5hrsfRzb9/ZmVHyv+?=
 =?us-ascii?Q?yZhcJ3Pi38FBnNpaflvXQNAmLCgZEHTqmINFOefIsI0MV2/br6LG74AYA7Rs?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 696a064a-ec60-4818-baa5-08dba85f73cc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 07:13:32.2924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BPyF3pmn7kfYdyz7sUlvcogRc1TmrB7h/hNi+TBVErwOmwl7EadfBroViRllbfPASegCqxEFwFMDFYBkYNWqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8132
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hello,

kernel test robot noticed "canonical_address#:#[##]" on:

commit: 9a65885b675adcef145312ef0e2e9447194aecda ("KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list")
https://github.com/sean-jc/linux x86/dynamic_mmu_page_hash

in testcase: kvm-unit-tests-qemu
version: 
with following parameters:




compiler: gcc-12
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202308291427.85de5a98-oliver.sang@intel.com


[  360.237618][ T1478] make[1]: Leaving directory '/lkp/benchmarks/qemu/build'
[  360.237641][ T1478]
[  360.294097][T15381] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=15381 'qemu-system-x86'
[  362.275836][ T1478] 2023-08-24 21:56:55 ./run_tests.sh
[  362.275856][ T1478]
[  363.747534][T15500] general protection fault, probably for non-canonical address 0xdffffc000000032b: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  363.761514][T15500] KASAN: probably user-memory-access in range [0x0000000000001958-0x000000000000195f]
[  363.771827][T15500] CPU: 119 PID: 15500 Comm: qemu-system-x86 Tainted: G S                 6.5.0-rc2-00178-g9a65885b675a #1
[  363.783889][T15500] Hardware name: Intel Corporation M50CYP2SB1U/M50CYP2SB1U, BIOS SE5C620.86B.01.01.0003.2104260124 04/26/2021
[363.797245][T15500] RIP: kvm_uevent_notify_change+0x13e/0x350 kvm
[ 363.805596][T15500] Code: c0 74 08 3c 03 0f 8e 91 01 00 00 48 8d bd 58 19 00 00 41 8b 95 50 09 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <0f> b6 04 01 84 c0 74 08 3c 03 0f 8e 6c 01 00 00 89 95 58 19 00 00
All code
========
   0:	c0 74 08 3c 03       	shlb   $0x3,0x3c(%rax,%rcx,1)
   5:	0f 8e 91 01 00 00    	jle    0x19c
   b:	48 8d bd 58 19 00 00 	lea    0x1958(%rbp),%rdi
  12:	41 8b 95 50 09 00 00 	mov    0x950(%r13),%edx
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df 
  23:	48 89 f9             	mov    %rdi,%rcx
  26:	48 c1 e9 03          	shr    $0x3,%rcx
  2a:*	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax		<-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 6c 01 00 00    	jle    0x1a6
  3a:	89 95 58 19 00 00    	mov    %edx,0x1958(%rbp)

Code starting with the faulting instruction
===========================================
   0:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
   4:	84 c0                	test   %al,%al
   6:	74 08                	je     0x10
   8:	3c 03                	cmp    $0x3,%al
   a:	0f 8e 6c 01 00 00    	jle    0x17c
  10:	89 95 58 19 00 00    	mov    %edx,0x1958(%rbp)
[  363.827013][T15500] RSP: 0018:ffa000002714fe48 EFLAGS: 00010206
[  363.833927][T15500] RAX: dffffc0000000000 RBX: ff110010e99bc000 RCX: 000000000000032b
[  363.842760][T15500] RDX: 0000000000003c8c RSI: 1ff4000004e29f97 RDI: 0000000000001959
[  363.851588][T15500] RBP: 0000000000000001 R08: ff110010e99bc218 R09: fff3fc0004e29f67
[  363.860411][T15500] R10: 0000000000000003 R11: 000000000000000a R12: ffffffff8424d5d0
[  363.869223][T15500] R13: ff11001211108000 R14: 0000000000000001 R15: 0000000000000001
[  363.878032][T15500] FS:  00007fb8cd2b8c80(0000) GS:ff11002020380000(0000) knlGS:0000000000000000
[  363.887789][T15500] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  363.895177][T15500] CR2: 000056119a3bc320 CR3: 00000011a77dc004 CR4: 0000000000771ee0
[  363.903973][T15500] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  363.912759][T15500] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  363.921532][T15500] PKRU: 55555554
[  363.925873][T15500] Call Trace:
[  363.929948][T15500]  <TASK>
[363.933659][T15500] ? die_addr (kbuild/src/consumer/arch/x86/kernel/dumpstack.c:421 kbuild/src/consumer/arch/x86/kernel/dumpstack.c:460) 
[363.938586][T15500] ? exc_general_protection (kbuild/src/consumer/arch/x86/kernel/traps.c:786 kbuild/src/consumer/arch/x86/kernel/traps.c:728) 
[363.944897][T15500] ? asm_exc_general_protection (kbuild/src/consumer/arch/x86/include/asm/idtentry.h:564) 
[363.951376][T15500] ? kvm_uevent_notify_change+0x13e/0x350 kvm


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230829/202308291427.85de5a98-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

