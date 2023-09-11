Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DAC79A39B
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbjIKGlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIKGlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:41:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20F8B5
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 23:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694414494; x=1725950494;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ga/mhCirhyf6mgmcnNTlqNHSEDygj9B2TLzLZ3mhEiI=;
  b=Iz41uSWK9E1RzyvWjVAq4XytPh1CKD/LK9gWz36fcJNGoZYRpZlnWzhE
   v9q7CX5BuLmQ8Xux5WjGd1k6KNp5xOt2SzHFfG5taNok4mUzkBx5F7oBU
   kdARXj2D5mmqoIdPSGcXLD4h1NgqYej7bZiW8jVAuUy7lnhSYCIG4+fsx
   zlFle5DA+8nEYtcCyMryoBkN/ZNwEn9JByoVZYldJGxdizb+3/gAywNH7
   XJ4seKkbtfIhEdye0TGoH7YomL9lMR8k6ew5F8Ct+lO4K1MFaZzr6AmZ9
   e1dlWOLRfUZIw6gKpqj3rCJayVme2wgZa3FvwTJ5Qo1/NCZNTDC/AbdFF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="380706325"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="380706325"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:41:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="746300043"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="746300043"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:41:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:41:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:41:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:41:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:41:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtOvtvmDJN7JmEHpfsv7jyt0vBqmSBIohp5ZPls4aBFqmA0qmALzbdorl1VzJK/fYCeelo0YQc5EtrL8kU26sUx/4a24Iit5Ckn8cNO2UlQyGcPZJzJloekVjAvLlZG0GcRI5nC66UdTdNb+odvcaJldit6GFYFJBDEHIDNzoBSLHww6BdISOZ5qbgGx4EeNX0zXBdM22fxEnXudfGJmNtaHbNA9/X1yS2cPn+TQGTpHrsQFXAFMLts4HH6U3KsSHaT07CJYwi9tY+VcfFI5Zv4XIzGBKFyiGVJkr/36XOPGKzaWR9RqcizWcwm0/DwfzrKcXGRN9U3RqRV+ZxLKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2z7exCmtp+KmLn/rCF6RAq9OhpPOVN3jw5MP306Tjlc=;
 b=JkSsyutHrsIbKJAQEKW0ibpAEdPSGzlm+4detDUiQBaCciYSf1ZGcwIe4uAOJPFPVLlD1hiy9mqAid0DXSZhfPDThObPeqb8mAXq32qt976P1IbPeq9kKBpDRLXwdu3erdnLero+zFVQ8qLnLi6ryFBqv0mDDr1dmUtKagsQoma9LVm7ISjx4eh9G8nsSc9ZGdqXBetzRQIwWz/TFsaaWDwACcWpBV9iR6YutQNC330SBUSu/D352/2IpbVBpCAbvs2ocgrcIZXgJRNUyc5rgeQftvGz7Xv86t86Yg0Ad9rxD8o+QCnC+JlW/7tqtQvE4eAK8z532l6he4+JGjm4mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.33; Mon, 11 Sep
 2023 06:41:31 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:41:31 +0000
Date:   Mon, 11 Sep 2023 14:41:22 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
        <oliver.sang@intel.com>
Subject: [intel-tdx:guest-kexec] [x86/kvm]  ba13210a07:
 BUG:unable_to_handle_page_fault_for_address
Message-ID: <202309111410.32547f17-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: PS2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:300:59::34) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|CO1PR11MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: c4a7b1cb-d152-4510-ae6b-08dbb29221d5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dQPmFK5NQ+IeFrI9E/Duwt/w2QDSHFAwn8u+syFCG5Ha8xDKNSE3CvCk8CLvylZ5U0MmILha0vQjdSf/ZMbO37z7wsnKsv0m3Z0l3etllzenxZeQxou/xsPaZH5+aaQ4KdHBm/6aJQuJvW0Y+rCwsgVV2uUMVIaSQ6haATT0freedy+DcC35QnwJBddzWrRiAoFCVrCwsF05cK6IPOhUdLFiUgTr9UkmDJs9Y2fRfqmccTRzoCks4i7HRvRSLqN/bR9rbZ9q/FdISyYO2qQWOPuBqrcR9VAHZSyDfVNV3ezINruPK8CKKWp3x6AnxUrLOICnDXxxxaDkog6kamMSTyUjLyA6FNrAv2GLf+HOhT+qfWqtxszF8HHCbAih7U++swk09pWZSyYJ/7YMQlauG4qqSIYpnyT7WUJEPE5Atshyk8GXb+2dz6JvX4qIo/8Pbv4BqZkllSt1mON5CkZOwwpp2h5nl0Zt/cWyM5X7VA3OlAU5xYWKXROYlt6u1pCpBTjJfjdWMgPO+PzESQw46eSeIrsrAYTWxNdCQQI8Q6RSPMHTs2d33pf9LSKMJ4Zjww2xaoAzzQJf7q2uJJ4XIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(366004)(39860400002)(186009)(1800799009)(451199024)(41300700001)(6666004)(6486002)(6506007)(82960400001)(36756003)(86362001)(38100700002)(1076003)(2616005)(2906002)(966005)(45080400002)(6512007)(83380400001)(478600001)(316002)(8936002)(8676002)(4326008)(5660300002)(26005)(6916009)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQD8KE1SNXi+B+Xl1vIlst6NpmX/os0Va0veYDYfFuj07b24aSl2kLTXZrJu?=
 =?us-ascii?Q?UBstP18HUV5hPs1R+xZiKc9+/QwD9yCpv5eK+eEASCDTGRVs43FOVAGz2xtw?=
 =?us-ascii?Q?mWJ0Hq+qnjt2lNM+oMb28d1HiLNdOUOLF7IYAp6cTgIhWIJ0Qi8baucto8BM?=
 =?us-ascii?Q?/iJYn5YaA2q9EE4hh9/9JWXFGpefuBQx+2YxgCnYHe0sjNMnazWSvUrLtEH0?=
 =?us-ascii?Q?kmA43V8PjfTeFFcmsk6aEjFrroUJKo+NiHgF73gVpRW5eZtrtTCkb5BqDtnG?=
 =?us-ascii?Q?zULr/VsnGy5Xp7MZ+Xk0kSy2YrwVBLyjFdKECeeZvLN8IxWU3jNqiBqJs/I1?=
 =?us-ascii?Q?sQNxhtxkGpOaLp1dcvac9gHyAAORmJu2fk9WB/OwIFmIURpOjxEiaQNdF8GB?=
 =?us-ascii?Q?vht6nvgVNk7hRNaULkKqhrWqdMk3MstGjUDa+Y8W9w4guXxZHgp77IVyW5xq?=
 =?us-ascii?Q?Pi9qK2WRfO9RX9mBFm1qaeHVhVEvGXoOrthkmArnUrV45sAIcfJw7hSmkO2c?=
 =?us-ascii?Q?0YRY/W8PJfnHHF/jLol8fhAaj6opfmYZDTVdsntECZLizm4uM2PSC+e58ZG0?=
 =?us-ascii?Q?WNo/Q+GpOHbVpLuSgit+z3HE9Ja72vFvltIhG2e+vd2Naaazm5cau0LywUev?=
 =?us-ascii?Q?PAycXfBjtb7vLvGZbxv87Nb4pf+O3nYtz5+HtksMeXTyiNd26ZW1wNbw0yrg?=
 =?us-ascii?Q?DZ46tEKS28m2a0kZVY03u0BR3IxrktaS1guinlbMS/1/apRyZnSPB7dOJ7nX?=
 =?us-ascii?Q?MOXRqJLU5nLrm+PngQbXp5Yzi0uE1klPRGYDu0XE1i0YugTR2hyJNKCxfJ5T?=
 =?us-ascii?Q?mhS3Uhumu4jO0iUeNvX4UoU1anSeIizTxlqXNt5B472e+0JSyuSYHzQ7msjB?=
 =?us-ascii?Q?7ela2+1HABadsVox+7jkB07nuroqmjeF5NX7CIl0xf/+eUbKrsY/yUHhUsRi?=
 =?us-ascii?Q?9UncBX73G3pt6yjzSmzVeEUP7Kx8OVnOCG4eKJLC9yOXGTxd530DQ/0mAbE5?=
 =?us-ascii?Q?xiTZ6I0Llh9tZ71rMJH3mbWEgokR8fuiilS2FQ8w2MmLg57Uci3jbHazQ9yp?=
 =?us-ascii?Q?3GxV8sgQIKi4dZiqlznrboTNhm/TD7b/cLiJLskNJNlDNJYgbI8EtfBcrgbE?=
 =?us-ascii?Q?wVWg6Aa5yAaLJV8y9csG1YBgdcIuuKI9IHaDKl/FYSN9/v2KNsVFsLJfhHLO?=
 =?us-ascii?Q?CZD9FNmCdLnKfjeMx+Oqay9ybXB7JFTEfeQPcqZIph6q6VDztpPkii25cHAt?=
 =?us-ascii?Q?XjL2Wj9ZdbkfaYffnqLtlR32AFIdWDd2+5LRZTxjRqozf6TjcBa9b/I+Hi/v?=
 =?us-ascii?Q?I8AZkwgAX5ctNvg1wOGwh9nIG+2YDNW2F/HEyaZQsVvZXEUFE9PRzTlymfvC?=
 =?us-ascii?Q?4j9bqnhg/k1ohYe/fD+72joerPh3iN1jAlMOADcTgcp2U2iLjmBs7+FtnFZ1?=
 =?us-ascii?Q?suAP0+ZgZ+1bx7yw1PVOdwnnRdz22+Nxajbp8alzGAgFULp7AV/F0A9xMval?=
 =?us-ascii?Q?EKv+yfGMksyNEqWn40uGkNHa9Pahp2euueK2uJ5KUnLMfHzl7YEwoFa60M0e?=
 =?us-ascii?Q?KQKksfFroSd3KiMlf73HaiWpay/3Fqtaaaz4Scq4O1ZSfG0qSe1bhPqo+OSZ?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a7b1cb-d152-4510-ae6b-08dbb29221d5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 06:41:30.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMiJ/TRqak+orbf5nca1axUfNRhHWBjP9BkRVLNNhBRlV54Pwn3+Kve0Kr9U390If9H0Bn499rNeXoCMo/Qp8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4849
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hello,

kernel test robot noticed "BUG:unable_to_handle_page_fault_for_address" on:

commit: ba13210a07cb255812dff0e660a6978923724b0d ("x86/kvm: Do not try to disable kvmclock if it was not enabled")
https://github.com/intel/tdx.git guest-kexec

in testcase: rcutorture
version: 
with following parameters:

	runtime: 300s
	test: cpuhotplug
	torture_type: tasks



compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309111410.32547f17-oliver.sang@intel.com


[  183.786472][   T21] BUG: unable to handle page fault for address: ffffffff85f6e650
[  183.786929][   T21] #PF: supervisor read access in kernel mode
[  183.787244][   T21] #PF: error_code(0x0000) - not-present page
[  183.787556][   T21] PGD 4492067 P4D 4492067 PUD 4493063 PMD 800ffffffa1ff062
[  183.787959][   T21] Oops: 0000 [#1] SMP KASAN PTI
[  183.788216][   T21] CPU: 1 PID: 21 Comm: cpuhp/1 Tainted: G        W          6.5.0-00004-gba13210a07cb #1
[  183.788723][   T21] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 183.789263][ T21] RIP: 0010:kvmclock_disable (arch/x86/kernel/kvmclock.c:198 (discriminator 1)) 
[ 183.789557][ T21] Code: 00 b8 01 00 00 00 5b 31 d2 31 ff c3 cc cc cc cc e8 58 a2 78 00 eb cb 66 0f 1f 44 00 00 48 83 ec 08 e8 67 ec ff ff 84 c0 74 0a <8b> 05 2d ee e2 04 85 c0 75 13 48 83 c4 08 31 c0 31 d2 31 c9 31 f6
All code
========
   0:	00 b8 01 00 00 00    	add    %bh,0x1(%rax)
   6:	5b                   	pop    %rbx
   7:	31 d2                	xor    %edx,%edx
   9:	31 ff                	xor    %edi,%edi
   b:	c3                   	retq   
   c:	cc                   	int3   
   d:	cc                   	int3   
   e:	cc                   	int3   
   f:	cc                   	int3   
  10:	e8 58 a2 78 00       	callq  0x78a26d
  15:	eb cb                	jmp    0xffffffffffffffe2
  17:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  1d:	48 83 ec 08          	sub    $0x8,%rsp
  21:	e8 67 ec ff ff       	callq  0xffffffffffffec8d
  26:	84 c0                	test   %al,%al
  28:	74 0a                	je     0x34
  2a:*	8b 05 2d ee e2 04    	mov    0x4e2ee2d(%rip),%eax        # 0x4e2ee5d		<-- trapping instruction
  30:	85 c0                	test   %eax,%eax
  32:	75 13                	jne    0x47
  34:	48 83 c4 08          	add    $0x8,%rsp
  38:	31 c0                	xor    %eax,%eax
  3a:	31 d2                	xor    %edx,%edx
  3c:	31 c9                	xor    %ecx,%ecx
  3e:	31 f6                	xor    %esi,%esi

Code starting with the faulting instruction
===========================================
   0:	8b 05 2d ee e2 04    	mov    0x4e2ee2d(%rip),%eax        # 0x4e2ee33
   6:	85 c0                	test   %eax,%eax
   8:	75 13                	jne    0x1d
   a:	48 83 c4 08          	add    $0x8,%rsp
   e:	31 c0                	xor    %eax,%eax
  10:	31 d2                	xor    %edx,%edx
  12:	31 c9                	xor    %ecx,%ecx
  14:	31 f6                	xor    %esi,%esi
[  183.790582][   T21] RSP: 0018:ffffc9000016fd90 EFLAGS: 00210002
[  183.790903][   T21] RAX: 0000000040000001 RBX: 0000000000000001 RCX: 0000000000000000
[  183.791318][   T21] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  183.791731][   T21] RBP: ffff8883aee27300 R08: 0000000000000000 R09: 0000000000000000
[  183.792143][   T21] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  183.792556][   T21] R13: ffffffff84550898 R14: ffff8883aee27328 R15: ffffffff84550888
[  183.792970][   T21] FS:  0000000000000000(0000) GS:ffff8883aee00000(0000) knlGS:0000000000000000
[  183.793435][   T21] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  183.793785][   T21] CR2: ffffffff85f6e650 CR3: 000000012e91c000 CR4: 00000000000406a0
[  183.794240][   T21] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  183.794652][   T21] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  183.795063][   T21] Call Trace:
[  183.795239][   T21]  <TASK>
[ 183.795394][ T21] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 183.795603][ T21] ? page_fault_oops (arch/x86/mm/fault.c:707) 
[ 183.795864][ T21] ? show_fault_oops (arch/x86/mm/fault.c:635) 
[ 183.796124][ T21] ? kernelmode_fixup_or_oops (arch/x86/mm/fault.c:758) 
[ 183.796421][ T21] ? exc_page_fault (arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1542) 
[ 183.796670][ T21] ? asm_exc_page_fault (arch/x86/include/asm/idtentry.h:570) 
[ 183.796938][ T21] ? kvmclock_disable (arch/x86/kernel/kvmclock.c:198 (discriminator 1)) 
[ 183.797193][ T21] kvm_cpu_down_prepare (arch/x86/kernel/kvm.c:714 (discriminator 1)) 
[ 183.797461][ T21] cpuhp_invoke_callback (include/linux/jump_label.h:270 include/trace/events/cpuhp.h:65 kernel/cpu.c:196) 
[ 183.797746][ T21] ? io_schedule_timeout (kernel/sched/core.c:6592) 
[ 183.798036][ T21] ? cpuhp_thread_fun (kernel/cpu.c:109 kernel/cpu.c:1094) 
[ 183.798303][ T21] cpuhp_thread_fun (kernel/cpu.c:1080) 
[ 183.798561][ T21] ? __cpuhp_state_remove_instance (kernel/cpu.c:1037) 
[ 183.798884][ T21] ? smpboot_thread_fn (kernel/smpboot.c:112) 
[ 183.799152][ T21] ? smpboot_thread_fn (kernel/smpboot.c:112) 
[ 183.799416][ T21] smpboot_thread_fn (kernel/smpboot.c:164 (discriminator 4)) 
[ 183.799678][ T21] ? sort_range (kernel/smpboot.c:109) 
[ 183.799906][ T21] kthread (kernel/kthread.c:389) 
[ 183.800123][ T21] ? kthread_complete_and_exit (kernel/kthread.c:346) 
[ 183.800418][ T21] ret_from_fork (arch/x86/kernel/process.c:151) 
[ 183.800664][ T21] ? kthread_complete_and_exit (kernel/kthread.c:346) 
[ 183.800959][ T21] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  183.801216][   T21]  </TASK>
[  183.801379][   T21] Modules linked in: rcutorture torture ppdev crc32_pclmul polyval_clmulni input_leds led_class aesni_intel rtc_cmos parport_pc drm drm_panel_orientation_quirks
[  183.802235][   T21] CR2: ffffffff85f6e650
[  183.802457][   T21] ---[ end trace 0000000000000000 ]---
[ 183.802741][ T21] RIP: 0010:kvmclock_disable (arch/x86/kernel/kvmclock.c:198 (discriminator 1)) 
[ 183.803026][ T21] Code: 00 b8 01 00 00 00 5b 31 d2 31 ff c3 cc cc cc cc e8 58 a2 78 00 eb cb 66 0f 1f 44 00 00 48 83 ec 08 e8 67 ec ff ff 84 c0 74 0a <8b> 05 2d ee e2 04 85 c0 75 13 48 83 c4 08 31 c0 31 d2 31 c9 31 f6
All code
========
   0:	00 b8 01 00 00 00    	add    %bh,0x1(%rax)
   6:	5b                   	pop    %rbx
   7:	31 d2                	xor    %edx,%edx
   9:	31 ff                	xor    %edi,%edi
   b:	c3                   	retq   
   c:	cc                   	int3   
   d:	cc                   	int3   
   e:	cc                   	int3   
   f:	cc                   	int3   
  10:	e8 58 a2 78 00       	callq  0x78a26d
  15:	eb cb                	jmp    0xffffffffffffffe2
  17:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  1d:	48 83 ec 08          	sub    $0x8,%rsp
  21:	e8 67 ec ff ff       	callq  0xffffffffffffec8d
  26:	84 c0                	test   %al,%al
  28:	74 0a                	je     0x34
  2a:*	8b 05 2d ee e2 04    	mov    0x4e2ee2d(%rip),%eax        # 0x4e2ee5d		<-- trapping instruction
  30:	85 c0                	test   %eax,%eax
  32:	75 13                	jne    0x47
  34:	48 83 c4 08          	add    $0x8,%rsp
  38:	31 c0                	xor    %eax,%eax
  3a:	31 d2                	xor    %edx,%edx
  3c:	31 c9                	xor    %ecx,%ecx
  3e:	31 f6                	xor    %esi,%esi

Code starting with the faulting instruction
===========================================
   0:	8b 05 2d ee e2 04    	mov    0x4e2ee2d(%rip),%eax        # 0x4e2ee33
   6:	85 c0                	test   %eax,%eax
   8:	75 13                	jne    0x1d
   a:	48 83 c4 08          	add    $0x8,%rsp
   e:	31 c0                	xor    %eax,%eax
  10:	31 d2                	xor    %edx,%edx
  12:	31 c9                	xor    %ecx,%ecx
  14:	31 f6                	xor    %esi,%esi


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230911/202309111410.32547f17-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

