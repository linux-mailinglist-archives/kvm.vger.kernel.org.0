Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E737AC9D4
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjIXNso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 09:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjIXNsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 09:48:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E82F120;
        Sun, 24 Sep 2023 06:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695562718; x=1727098718;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=GOxXMOUJ57gkRDwlTy2eExa1PJxZXtVp4BmKfxKwSGo=;
  b=MPSaLgbRIgK2QxBxabpd5DAeonIcwwJAd7XFD/hX2QZv7YW40rfL9UGZ
   sVjBPe30FpZt0t7N9Eq3bOMEIL6dBwQ6CT1SMv1k7fQeYvVJaYg+8p20e
   temfFZ/WxSb+X7rH/jZRITfD/qBrj1RiQb6Rzy4O9MsZPm0J9Nl1AxatX
   HW/iqWWdtvQm3Q6VA9ayuvaU628czGMUhBbjK4DSJwQNwQYOz0a2pm5tc
   QgjO+tH1cBeUK2qx2h/7kB89GudSr3jcevD9Ya2nwmavqi9Fts3RxXLGC
   eiPhv0jlqQRsMSrCDqXFD/3HUInGwwr41O47lo25qkGm09dYiFLUay3Z9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="360485126"
X-IronPort-AV: E=Sophos;i="6.03,173,1694761200"; 
   d="scan'208";a="360485126"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 06:38:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="777391492"
X-IronPort-AV: E=Sophos;i="6.03,173,1694761200"; 
   d="scan'208";a="777391492"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 06:38:23 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 06:38:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 06:38:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 06:38:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgiTucodx1NlB9XxqrvRSWZlsJYksr96HtBhb3uEUu3tVj0mDXJLPZH+j+sX+78ZmkEt+VDYju57Xo+jbmS7OAsoLLh0c6TMW5Grx8G/Z0N4H8Q27LiF7awH9h41ZH3G3p3UDtK4wh/Z7qWS1yIvI95ZoLvx2Ukb6OUQyeKq+4N/DQ9cBSnHfyElCq0UWysCFeegsHMMJKZinDYBf60fO9w0W6hSxtR604LfMmwDk1EXgTj+1blMbcCoSAmjEI5hOF2SNY0gZrx4El0uQ5MZ9Q8ZXwIn8WuQG4NZjy1vomHIDmBjqfwQoJPn/I474LLIIJ7VjwFbaJgsrqViCvXg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou97SafkEPNMBWdDi4Hku6/e6dphaEJ7LJJRlg/Sdy8=;
 b=bsTEXk5JAHFkGpR2MtxIIwPgyozllU9o3r5nOgGGSPJNwCXF4EgbrHt0aaqynKLfi8zacPVZtJeqoRQgaZv8t3TtGULy7pg71jov9AsemznzYkGPbVMaP9e2bk03vyY3+biA/8pq/EwYBmHcJFU0ki88y79zx6uJ3LERvjgPUruU0/rvvKosUhlcb+L9ugmzF9Hgo8Ov5ldJXk5/UayyMvxxSxP+dQCTiFzmU77ppLCXIBvoG96L70Oep7bxQYjfvbWY6Z5Tm2BVaz+g9F0o0YFXjybkVfzLxbvf22cxSaN8uFfu/Rhpf76Mn9Zuog/5uVxfQFXTWVIMw3nJgWePYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by IA0PR11MB8335.namprd11.prod.outlook.com (2603:10b6:208:493::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Sun, 24 Sep
 2023 13:38:19 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6813.017; Sun, 24 Sep 2023
 13:38:18 +0000
Date:   Sun, 24 Sep 2023 21:38:05 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <weijiang.yang@intel.com>,
        <john.allen@amd.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Message-ID: <202309242050.90b36814-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230914063325.85503-24-weijiang.yang@intel.com>
X-ClientProxiedBy: SG3P274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::36)
 To PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|IA0PR11MB8335:EE_
X-MS-Office365-Filtering-Correlation-Id: 81a54514-c66a-4b31-dcc6-08dbbd03824f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWsqxc1X4jEde6THGcp+6APyAtgqPNsuXjW5DTYviKn1IAtVeu6gW5v4aocpXZNaFR6cQyCP/Pdvi1j46f8Yjx8MhpXL5OhDsdYtF9PkDAKFR5HHbCi8ANxdJUBsfMgs0Ro9PL+a0g18wIVWr0I3gZGmK1T056XMLayLjicNDuT+2z4MJakWRa4MnMFZbWWr0XUfA2MKh3myGxM0UtZ1/16QJfoNRMYNq6ef7yR1D5yfgCvvacbo6yAjDNmgif1JSGwya+rEFJPsgZJoGBiFH7w/lpukGdx67IblqT6v3vQcP6Z1GQIRSb4OloGJjY2/adniz3+fZMKoZ5cw3VcYJvqxMrpuQ0o7WGR6jIeA4tkVZNS3507597ghySikbVGq8kwjvE3cXFrYDynWw3KjAzUGmKZRme8NzJEP/5+a/nQRJSreppZZR7WL5VircLAurio5CTmfEMyDb9FQ2egiMzVndccxZDYcX/wCQxjGCmFx3gb+wYQL6lply6VFjvXC0x2HKQDKDS7aXGLI24unBEqJEDB9BwwFTz4FYHCSvwUCxx6CjLW1NPSJPv5CX2ymvRak9m4WTvOsbxVwLqnDgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(186009)(1800799009)(451199024)(26005)(45080400002)(83380400001)(107886003)(6486002)(6506007)(66476007)(6636002)(4326008)(1076003)(966005)(8936002)(478600001)(8676002)(316002)(6666004)(66946007)(41300700001)(66556008)(37006003)(2906002)(5660300002)(6862004)(82960400001)(36756003)(86362001)(38100700002)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0I3CkTLjzEgwJ0//35D4AEZGHV1cfP735xhMDalOBlSq5xTcULmcY5NvGeuZ?=
 =?us-ascii?Q?0qUBNo/qzrT0Nok6zs2e/q126RKob6CjQLqDeg2SMCTU9pEjRn5UzcEgdXo4?=
 =?us-ascii?Q?VcImACS6V1UzCblV98HZgHadxUnZjC2qmMMrf0jSKloEwjSvkwhYUL0bAX3H?=
 =?us-ascii?Q?3CLsDbaUc0V4nFDBy2copHdbBjdMZzqvp9AOqSOWXjy8yd1eVUMMAs44qtth?=
 =?us-ascii?Q?1isFVWyaYF//VPmA3YTNWIRJeTIEILp/AZjt11QQkf82offc6KZTk+IMONPG?=
 =?us-ascii?Q?73h0N5CQsH4A21MsFmax5EX9SLovWjLAdd4lOb03+/G15OQb6UmyFO33+hyX?=
 =?us-ascii?Q?GKLzN/jVkcum8cI9ZiUKGgHrlOjeau8OtZLKQsAiT+yHTMDgwzaaNXUbIArE?=
 =?us-ascii?Q?qzDqMQGHU4d+gIZ0UQI2yQeqmFiOsjJnWKjLmDDIU+5mAvGuztQG99ekK4NZ?=
 =?us-ascii?Q?mtG4rWw0v3giAXq1bC3vjSz5Hycw+TsSljOVlDlS3Cx+89D7VkZ8Z2ssz7T4?=
 =?us-ascii?Q?RkCkyoIFpxR5vughBWb1Tx/8mashDUGiHpyDKr1IN7YdUnXT8hn5RgP3mYCM?=
 =?us-ascii?Q?LTgy5h+aWs+pfBgouWNdtlsTLjh6Hr2DsnYz7ob8UAi9LjoAJr9WXl93MgCZ?=
 =?us-ascii?Q?ooCXPf68vcIALr1vb+4LRJdk/xmkTtKcOgFx3bVBY+pm3V5cE/f+3NOuivCc?=
 =?us-ascii?Q?4yr8y9STPXsCZIdX5t7hbM8t9Y+VXqt1G+uptpHCXDnT66yLaduXrVRnzkIj?=
 =?us-ascii?Q?FRqO1/KhW0U9alcjEq9npEjbfq+Mr2BHc0nZyANeslC2NaV2Jq+nyZKqxoO8?=
 =?us-ascii?Q?zBLZ8o13Hj1UFwkSCIeBE1UzbDTjopN9+Na/m0wbQL/flCsa0YxktcNwwfj/?=
 =?us-ascii?Q?VzSqjRb8avNqAgLGsOAMcngeHTcmlN/XqEN7pa20H2tbEZEyBwc3BQdZtbd6?=
 =?us-ascii?Q?iutwFA0OPL6+9N61rwayGCsJouRXEyyHwJMTCfji7Wyj5QOc2RGbgYIHVMc5?=
 =?us-ascii?Q?gEWW+bYapOxYMnX8k+10+YX5ecQnEEHzsRko5GNBDU548C4rAKEUUzsC/lqP?=
 =?us-ascii?Q?taf4BAYICxWdF9mw6zimG5p3EMMB2Ko1rO7SyhF6vyiA7gJCjd/o24gj8CcN?=
 =?us-ascii?Q?ssmokrFzzB2Zfk9Sck7ZXgG+lOY/lLppNzpHcYorUTF6HPTH6m6gz+csFxk9?=
 =?us-ascii?Q?iOq7QkfnC91//Pdg5OiSKhOwow+Co+HdVyIYl/CFErf/ga8pMF0Gqzc1vuUl?=
 =?us-ascii?Q?TEVQJjhFf9gD8GMR8/tq+tvK6wtFhACUr9uvgZGuH+adEPhwy3/OjzeCJGSw?=
 =?us-ascii?Q?IDgF4VT1CbLWG4EED42laO6F8OOKyU+wsqB5goafvwncgk4P+U25tmjwu7/L?=
 =?us-ascii?Q?B7odhqfxMfwRwm7DF9aORok16/G4wiSgYBaZfLFPz67IM2Hwy+ebom03E8wi?=
 =?us-ascii?Q?5JdSBEgJBJUXCsXkchf5b94mEhnD4ha2Ji1c3Nfu8m3lCa5L+weIAICpd58w?=
 =?us-ascii?Q?AZZlfJn3L8HtVLZ4mIylgsABDLzsciiP9Iei+/HLMehmy2oqt5oOd/h1UDhK?=
 =?us-ascii?Q?DfABa5Y90wjZe7G2tLm+TjhVVItCzB3nDpPV7Mc+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a54514-c66a-4b31-dcc6-08dbbd03824f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2023 13:38:17.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7wvDWqZkErlj75uHyj3r/L2rEkkOFoM1c552S2TQbIcCJvS4gezNE5NCIgJ5wo9I8RiLwEQhSROJo4lmpZ0Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hello,

kernel test robot noticed "WARNING:at_arch/x86/kvm/vmx/vmx.c:#vmwrite_error[kvm_intel]" on:

commit: 68d0338a67df85ab18482295976e7bd873987165 ("[PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and advertise to userspace")
url: https://github.com/intel-lab-lkp/linux/commits/Yang-Weijiang/x86-fpu-xstate-Manually-check-and-add-XFEATURE_CET_USER-xstate-bit/20230914-174056
patch link: https://lore.kernel.org/all/20230914063325.85503-24-weijiang.yang@intel.com/
patch subject: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and advertise to userspace

in testcase: kvm-unit-tests-qemu
version: 
with following parameters:




compiler: gcc-12
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309242050.90b36814-oliver.sang@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230924/202309242050.90b36814-oliver.sang@intel.com



[  271.856711][T15436] ------------[ cut here ]------------
[  271.863011][T15436] vmwrite failed: field=682a val=0 err=12
[  271.869458][T15436] WARNING: CPU: 117 PID: 15436 at arch/x86/kvm/vmx/vmx.c:444 vmwrite_error+0x16b/0x2e0 [kvm_intel]
[  271.880940][T15436] Modules linked in: kvm_intel kvm irqbypass btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl intel_cstate ipmi_ssif ahci ast libahci mei_me drm_shmem_helper intel_uncore dax_hmem ioatdma joydev drm_kms_helper acpi_ipmi libata mei intel_pch_thermal dca wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad fuse drm ip_tables [last unloaded: irqbypass]
[  271.939752][T15436] CPU: 117 PID: 15436 Comm: qemu-system-x86 Not tainted 6.5.0-12553-g68d0338a67df #1
[  271.950090][T15436] RIP: 0010:vmwrite_error+0x16b/0x2e0 [kvm_intel]
[  271.957256][T15436] Code: ff c6 05 f1 4b 82 ff 01 66 90 b9 00 44 00 00 0f 78 c9 0f 86 e0 00 00 00 48 89 ea 48 89 de 48 c7 c7 80 1c d9 c0 e8 c5 b7 c4 bf <0f> 0b e9 ae fe ff ff 48 c7 c0 a0 6f d9 c0 48 ba 00 00 00 00 00 fc
[  271.978720][T15436] RSP: 0018:ffa000000e117980 EFLAGS: 00010286
[  271.985599][T15436] RAX: 0000000000000000 RBX: 000000000000682a RCX: ffffffff82216eee
[  271.994345][T15436] RDX: 1fe2200403fd57c8 RSI: 0000000000000008 RDI: ffa000000e117738
[  272.003044][T15436] RBP: 0000000000000000 R08: 0000000000000001 R09: fff3fc0001c22ee7
[  272.011865][T15436] R10: ffa000000e11773f R11: 0000000000000001 R12: ff110011b12a4b20
[  272.020632][T15436] R13: 0000000000000000 R14: 0000000000000000 R15: ff110011b12a4980
[  272.029340][T15436] FS:  00007f79fd975700(0000) GS:ff1100201fe80000(0000) knlGS:0000000000000000
[  272.039141][T15436] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  272.046484][T15436] CR2: 00007f79e8000010 CR3: 00000010d23c0003 CR4: 0000000000773ee0
[  272.055167][T15436] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.063980][T15436] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  272.072749][T15436] PKRU: 55555554
[  272.076985][T15436] Call Trace:
[  272.080947][T15436]  <TASK>
[  272.084650][T15436]  ? __warn+0xcd/0x260
[  272.089420][T15436]  ? vmwrite_error+0x16b/0x2e0 [kvm_intel]
[  272.096014][T15436]  ? report_bug+0x267/0x2d0
[  272.101163][T15436]  ? handle_bug+0x3c/0x70
[  272.106130][T15436]  ? exc_invalid_op+0x17/0x40
[  272.111483][T15436]  ? asm_exc_invalid_op+0x1a/0x20
[  272.117132][T15436]  ? llist_add_batch+0xbe/0x130
[  272.122685][T15436]  ? vmwrite_error+0x16b/0x2e0 [kvm_intel]
[  272.129113][T15436]  vmx_vcpu_reset+0x2382/0x30b0 [kvm_intel]
[  272.135741][T15436]  ? init_vmcs+0x7230/0x7230 [kvm_intel]
[  272.141988][T15436]  ? irq_work_sync+0x8a/0x1f0
[  272.147302][T15436]  ? kvm_clear_async_pf_completion_queue+0x2e6/0x4c0 [kvm]
[  272.155191][T15436]  kvm_vcpu_reset+0x8cc/0x1080 [kvm]
[  272.161154][T15436]  kvm_arch_vcpu_create+0x8c5/0xbd0 [kvm]
[  272.167584][T15436]  kvm_vm_ioctl_create_vcpu+0x4be/0xe20 [kvm]
[  272.174297][T15436]  ? __alloc_pages+0x1d5/0x440
[  272.179723][T15436]  ? kvm_get_dirty_log_protect+0x5f0/0x5f0 [kvm]
[  272.186757][T15436]  ? __alloc_pages_slowpath+0x1cf0/0x1cf0
[  272.194079][T15436]  ? do_user_addr_fault+0x26c/0xac0
[  272.199837][T15436]  ? mem_cgroup_handle_over_high+0x570/0x570
[  272.206405][T15436]  ? _raw_spin_lock+0x85/0xe0
[  272.211721][T15436]  ? _raw_write_lock_irq+0xe0/0xe0
[  272.217414][T15436]  kvm_vm_ioctl+0x939/0xde0 [kvm]
[  272.223014][T15436]  ? __mod_memcg_lruvec_state+0x100/0x220
[  272.229278][T15436]  ? kvm_unregister_device_ops+0x90/0x90 [kvm]
[  272.235978][T15436]  ? __mod_lruvec_page_state+0x1ad/0x3a0
[  272.242092][T15436]  ? perf_trace_mm_lru_insertion+0x7c0/0x7c0
[  272.248627][T15436]  ? folio_batch_add_and_move+0xc1/0x110
[  272.254832][T15436]  ? do_anonymous_page+0x5e2/0xc10
[  272.260431][T15436]  ? up_write+0x52/0x90
[  272.265006][T15436]  ? vfs_fileattr_set+0x4e0/0x4e0
[  272.270502][T15436]  ? copy_page_range+0x880/0x880
[  272.275831][T15436]  ? __count_memcg_events+0xdd/0x1e0
[  272.281564][T15436]  ? handle_mm_fault+0x187/0x7a0
[  272.286855][T15436]  ? __fget_light+0x236/0x4d0
[  272.291883][T15436]  __x64_sys_ioctl+0x130/0x1a0
[  272.296994][T15436]  do_syscall_64+0x38/0x80
[  272.301756][T15436]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  272.307993][T15436] RIP: 0033:0x7f79fe886237
[  272.312758][T15436] Code: 00 00 00 48 8b 05 59 cc 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 29 cc 0d 00 f7 d8 64 89 01 48
[  272.333241][T15436] RSP: 002b:00007f79fd974808 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  272.342024][T15436] RAX: ffffffffffffffda RBX: 000000000000ae41 RCX: 00007f79fe886237
[  272.350428][T15436] RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 000000000000000d
[  272.358789][T15436] RBP: 00005606ece4cc90 R08: 0000000000000000 R09: 0000000000000000
[  272.367151][T15436] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  272.375587][T15436] R13: 00007ffefe5a1daf R14: 00007f79fd974a80 R15: 0000000000802000
[  272.383950][T15436]  </TASK>
[  272.387416][T15436] ---[ end trace 0000000000000000 ]---
[  272.393295][T15436] kvm_intel: vmwrite failed: field=682a val=0 err=12



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

