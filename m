Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB35679FDCC
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 10:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbjINIFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 04:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjINIFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 04:05:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADE68E
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 01:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694678708; x=1726214708;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=X/iE4ev0iOqD+SoN5k7Qd95iWxvJ01CxbOrlgH9EOG4=;
  b=Ff7eOEKCcrI5XrjO2AYEM+AozS47Fua5AF6eKQeHmDNYJGUua9XnI6tt
   wlfMoX6kF6pUdrBbvUuBJr5WmIAKzB/Ba81fkw18AvLEtk7OlxC5RhRE4
   LOsqJNCjNTs0Jf6VJRS1XlfJjIg9DSvE7hyYx9NGRfTIRQhhu3M3bSssR
   RbbcXiZP2cTwqBkXwKcQ6qNO73UFktXv2+LOFz+5PtfPlMq4FI5dPBYB8
   kOCiaS5+9tJM8qht2j8d/3z3CJFN2QV7tyAVF62fzGBTzY6VtT+xQmVXs
   EgjphltWhbu93r53Kfgf9m924F5k6+PMPZczdyNMlzx/Ou96JqrL4vLNT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="363924193"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="363924193"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 01:05:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="737831666"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="737831666"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 01:05:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 01:05:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 01:05:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 01:05:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5h6OZZG5K+k/ggVayuiFZGT9E6wvzfY+tZj2LWd9L3qM3rKTkQEdaCWpliM8kqPIYt3NoRCjfnpCX4+8KNTrjwQ6rwd0vxcUUHMzNFxoCHGYzvCjAuKpwUS3/kt1lBdjaeAWa6KcoHbIOQc9JODuSV9Uefv1wruOndzHveoJ0Qa9yhtGfwRTi8iJSqc8f7r43K0R+pUXrqsHDnEVbYATDaNmowPkj2Csu9vDlsSgqhSSdbrYO7dZabJIQuecIdRd47MnjJBP1EBUmxOWaTjGEJkL65Qzvc3lWenmHal9ysU4AYJTmz/CyBVRvLS2CQOHsfVEprxu4d/IZssFEpdKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmOPMX1QgPXTAzosjJnRPE1R515PGYVQeCg9xB2hSHI=;
 b=fg1Z6xTX5356JrHNNWcmqUjNOWYKICBlmHkA9a4c6NgXhafD1jScrVUdqNpRsO32FZpZTfJlRx+Ao0vf57IdUM78VouvIyakWhPd2EUJs48c8IjztRJ7/SCWFZ8XzkZILE91sxhg4pFXOfROUm1Nqoi9bEU/MEnl4puwNmffr8OFrhwkyY2gy7XIvumrXaNxqS1cgpTqpD+6W9IGenqbYi/ZHKRNMUXXlK85HHAGpO5GHQ9RqeZCEGPMHrq+vN0y0Y0+9WtDsclywLTENfeVBU3Pd1Z2HVzt4nZg8YbC1e2pMnLqNv/tCf3x8PLGHs0vNMtJG43Wf/fsnbxOA8Lk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by DM6PR11MB4642.namprd11.prod.outlook.com (2603:10b6:5:2a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Thu, 14 Sep
 2023 08:04:59 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6768.029; Thu, 14 Sep 2023
 08:04:59 +0000
Date:   Thu, 14 Sep 2023 16:04:47 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Anish Moorthy <amoorthy@google.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
        <seanjc@google.com>, <oliver.upton@linux.dev>,
        <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>, <maz@kernel.org>,
        <robert.hoo.linux@gmail.com>, <jthoughton@google.com>,
        <amoorthy@google.com>, <ricarkol@google.com>,
        <axelrasmussen@google.com>, <peterx@redhat.com>,
        <nadav.amit@gmail.com>, <isaku.yamahata@gmail.com>,
        <kconsul@linux.vnet.ibm.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v5 05/17] KVM: Annotate -EFAULTs from
 kvm_vcpu_read/write_guest_page()
Message-ID: <202309141107.30863e9d-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230908222905.1321305-6-amoorthy@google.com>
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|DM6PR11MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: e791b323-78a0-4fc1-bb77-08dbb4f94a56
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSHGuhlDc3sc3frYTPN5XGdDsWL1590lkP/l+5EEFZOfylfQK8Is8awjv73BJsQEyVmvDKB92HmJmRgQFzIKqVrUWfoDFvau1HfxdEfGqm8Ri6oE9tIUKZQhsG1Xs6O5peY9TYq16QEzr3rlNfYPDpgwvfUMhK1IxtNZCBK5Yk/3Bd6BSz9opefr2hO5BuHKERZovLqzhbinSu6C0HNudWBP/1o7U8zPa2TK3aAw2FvdO9bCydkIBlQwTq63t6sURNtL/N7+NC/v7ZyFb5N0jKjkHZOwXVDQhrY6kgEi3yAqWFed6zqyB2VKOPstSahETQH/K1AeP9qd9pLo9SgmZ1xfKX5YjVVE2wVJe6MP5LSAWodzJ7hrwCvwFC+Ln5aTQCMlU05ZYBlPqUTvIqCKH0fjfjniWsGiSQO+YY9ltp92nxynh/WtkW8sKjkF6JOvRuDjztETm2oGVmVlNX0sHf7J4OyxbN3jnZVHvM4EWqEf1Cv2vGYEaS4n/Hvaiu0dXGyobPU8aLeR00t4AlZcQFWQywwTqFzstCXEPtkBOWM+rkG/+LHGcEjWVhiqLsRNvTAbgd1O2OAndOMdm09hkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199024)(186009)(1800799009)(36756003)(86362001)(38100700002)(6916009)(66556008)(45080400002)(316002)(41300700001)(478600001)(66946007)(82960400001)(8676002)(8936002)(6486002)(6506007)(6512007)(7416002)(2616005)(83380400001)(1076003)(107886003)(26005)(66476007)(4326008)(2906002)(30864003)(6666004)(966005)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XD5QylyfcU+QWAdD1Fic6aPw0YlK4mSjodVSvmP9wtbTXRJpk9jgzafTils1?=
 =?us-ascii?Q?Cj58hUkNSIJUfmRyeUH6Y/CEpU8L6f/02Bi9GpXCuo84t8oGRAFYL6zOPWqI?=
 =?us-ascii?Q?Gm5WhlJZWfjsfKj91cPJE4L980NGSEgvYtndPNOafWEirm9oF42AppfaKi5l?=
 =?us-ascii?Q?4jGYSocMWatfl6BhyePxGuOjNRNdBFN7ADbjtQtjGJgRvHau3a/lvLTYE7ce?=
 =?us-ascii?Q?BVDRYayVVXBTEhP7PaujXBHOfMS3rpnry40Y6F2MDHrWsc6/yLLWLGmY6vm5?=
 =?us-ascii?Q?mRIeQ9Ob2hU1x5Hu9fzu5HX2tG4kzgGRjC9Fwu6IfGpNwVeGyumHCpll/RdT?=
 =?us-ascii?Q?OuEg1HIe2rNdktoyKes4bALZcm8qOoZ9sw3OPTWw+B6KAWpf0gaqe0pr2v8K?=
 =?us-ascii?Q?MwRqSp+S37LjWzO1tivzzGIr8aurv2I1dpKgBPPMsMslDvfzXV2EZUwPusIT?=
 =?us-ascii?Q?HRf2ds6OCfWZgX2Zn5tN6FvAC/pXTgMrAkeDp/enUR6PsxQwYeEwXtBpIQZQ?=
 =?us-ascii?Q?tJ+K4ptoxODUlnVhxVQqtRN0SwurJdll58U3KXO7tKOvugMqqt8hBj9aRoAO?=
 =?us-ascii?Q?U2U90F7SdR/LMFcYBZzTeAhj4zQoSgUWl1gxJgnHrgROT0F4WJYLe6hZqx1J?=
 =?us-ascii?Q?yvBIKnVANrOX0IhmoKDrzX4K4OtvgWX6QzBj2VNE3npFJhv0TzyzYSu6NQEb?=
 =?us-ascii?Q?dj6fGzhBGkraSnE/YDvLASUOKVwHPvUpijY9lKwMMgH3qFJt/AWWSITKTTnW?=
 =?us-ascii?Q?+27visRPM5OwxAAHgVn+Lb2COEYLXq1LuFFHU3ZNpJtO/U1vEU3tVoiIZaEv?=
 =?us-ascii?Q?H+Ec1oKeQmvonZXcOegil0aRXjyS+GP5XtMTmxomSKzw+Pg5uqSU/Um46FmR?=
 =?us-ascii?Q?nu3bV0pV6g1MusgUBfQrrAidSCQVtPCrNU8ilnMlQp8NnZ1ThsruMRgwWgQG?=
 =?us-ascii?Q?/ByNbj1jIM0D3KWzR2+TLz4IGd890ylqCuB4F2GP5aKC6nkusGZHkvPbT4Qc?=
 =?us-ascii?Q?yKTWu4UIsoaRGRZZQ51b3G+x2dd7/pgwgpSpJ3cJdVZGx+K0M8xl/lJeE2EL?=
 =?us-ascii?Q?i0LZXrJgoIh4xSeks4jR9y7gCLbcjcquDFYtdHuIbdjny2tFKtn9cxE2oIzL?=
 =?us-ascii?Q?NjB7u51lKGlnI65K3/lEwBQXmKjEG+VkItnbxNEq3AANi9OCuFH3IHF5uAwq?=
 =?us-ascii?Q?XqzoANTpqwRZYJmg8igx7mjQf4JYEDhirR7v/FvbBKBTdh+ogzY4RlCRbcY8?=
 =?us-ascii?Q?zSULw49tF2n4YLJJWMJNA495KAxgxECMUucTqGYAXRXnOI8g5eLZZug+mUEi?=
 =?us-ascii?Q?ZvEH9tsllZR7jW4++mwD9lrsoI1bEhrCmXL4tJQAtb1T8lWqI0GI1dpKDrU8?=
 =?us-ascii?Q?gBsnarcBz5JFSdnSFKQedJBrdQoEmZRUs3qyYF1Qnv9lhHOrSXDvdIw04tsa?=
 =?us-ascii?Q?3Gf2Z/86p9Wd6/m9/OUg4xOm5Bf1qsdeSQSxk+NRZhc3MM4isJ4Qev7XkNQd?=
 =?us-ascii?Q?iSxQWr+EEx3/twC6lGcg8e11mQsbhooGWGGFF8ReiV+d2cuMoUAoV5AAM4XP?=
 =?us-ascii?Q?g74el0XhTKJ4f4JvuzJ++98undmL8r/9iVBQOmmmd74wPvAuEhE/JM4azBWA?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e791b323-78a0-4fc1-bb77-08dbb4f94a56
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 08:04:59.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YNZxELlqIe5HWkm/VVi98rFp4sFgZdz322WdPu84gZWgiS6FMdWBsAZdrO8+Tb41b36bLRZ1CuTk0eTyhpwXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4642
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hello,

kernel test robot noticed "WARNING:at_include/linux/kvm_host.h:#kvm_vcpu_write_guest_page[kvm]" on:

commit: 00aaa25de7f10dfd5ac7afec09d6b4d72c379451 ("[PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()")
url: https://github.com/intel-lab-lkp/linux/commits/Anish-Moorthy/KVM-Clarify-documentation-of-hva_to_pfn-s-atomic-parameter/20230909-063310
base: https://git.kernel.org/cgit/virt/kvm/kvm.git queue
patch link: https://lore.kernel.org/all/20230908222905.1321305-6-amoorthy@google.com/
patch subject: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()

in testcase: kernel-selftests
version: kernel-selftests-x86_64-60acb023-1_20230329
with following parameters:

	group: kvm



compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphire Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309141107.30863e9d-oliver.sang@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230914/202309141107.30863e9d-oliver.sang@intel.com


[  216.317580][ T6089] ------------[ cut here ]------------
[  216.324543][ T6089] WARNING: CPU: 117 PID: 6089 at include/linux/kvm_host.h:2346 kvm_vcpu_write_guest_page+0x23b/0x2a0 [kvm]
[  216.338385][ T6089] Modules linked in: openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 intel_rapl_msr intel_rapl_common btrfs x86_pkg_temp_thermal blake2b_generic intel_powerclamp xor coretemp raid6_pq kvm_intel zstd_compress libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel nvme sha512_ssse3 nvme_core rapl t10_pi intel_cstate mei_me ast dax_hmem crc64_rocksoft_generic crc64_rocksoft drm_shmem_helper i2c_i801 crc64 i2c_ismt mei i2c_smbus drm_kms_helper wmi ipmi_ssif acpi_ipmi joydev ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad binfmt_misc fuse drm ip_tables
[  216.406963][ T6089] CPU: 117 PID: 6089 Comm: mmio_warning_te Not tainted 6.5.0-00313-g00aaa25de7f1 #1
[  216.418660][ T6089] RIP: 0010:kvm_vcpu_write_guest_page+0x23b/0x2a0 [kvm]
[  216.427008][ T6089] Code: c1 8b 04 24 e9 d0 fe ff ff 89 04 24 e8 3e 3c 09 c1 8b 04 24 e9 1f ff ff ff 0f 1f 44 00 00 e9 5b fe ff ff 0f 0b e9 24 fe ff ff <0f> 0b e9 89 fe ff ff 48 89 df 48 89 34 24 e8 52 3c 09 c1 48 8b 34
[  216.450579][ T6089] RSP: 0018:ffa000001ad0f638 EFLAGS: 00010202
[  216.457880][ T6089] RAX: 00000000fffffff2 RBX: ff1100019e5a8040 RCX: 1fe2200033cb53c9
[  216.467703][ T6089] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffa00000177e1000
[  216.477457][ T6089] RBP: 000000000000fffc R08: 0000000000000ffc R09: 0000000000000002
[  216.487445][ T6089] R10: ffa00000177eafd3 R11: 0000000000000001 R12: ff1100019e5a9e48
[  216.497466][ T6089] R13: 0000000000000002 R14: ff11000500a72cd0 R15: 000000000000000f
[  216.507485][ T6089] FS:  00007fd4160036c0(0000) GS:ff110017fe680000(0000) knlGS:0000000000000000
[  216.518653][ T6089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  216.526450][ T6089] CR2: 00007fd416002f78 CR3: 0000000154bb0003 CR4: 0000000000f73ee0
[  216.536508][ T6089] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  216.546584][ T6089] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  216.556682][ T6089] PKRU: 55555554
[  216.561031][ T6089] Call Trace:
[  216.565102][ T6089]  <TASK>
[  216.568851][ T6089]  ? __warn+0xcd/0x2b0
[  216.573882][ T6089]  ? kvm_vcpu_write_guest_page+0x23b/0x2a0 [kvm]
[  216.581406][ T6089]  ? report_bug+0x267/0x2d0
[  216.586914][ T6089]  ? handle_bug+0x3c/0x70
[  216.592099][ T6089]  ? exc_invalid_op+0x17/0x40
[  216.597749][ T6089]  ? asm_exc_invalid_op+0x1a/0x20
[  216.603751][ T6089]  ? kvm_vcpu_write_guest_page+0x23b/0x2a0 [kvm]
[  216.611219][ T6089]  ? kvm_vcpu_write_guest_page+0x5b/0x2a0 [kvm]
[  216.618594][ T6089]  kvm_vcpu_write_guest+0x4b/0x80 [kvm]
[  216.625453][ T6089]  write_emulate+0x23/0x50 [kvm]
[  216.631477][ T6089]  emulator_read_write_onepage+0x2ff/0x4a0 [kvm]
[  216.638944][ T6089]  ? vcpu_mmio_gva_to_gpa+0x730/0x730 [kvm]
[  216.645902][ T6089]  ? em_clflushopt+0x10/0x10 [kvm]
[  216.651976][ T6089]  emulator_read_write+0x149/0x510 [kvm]
[  216.658642][ T6089]  segmented_write+0xce/0x120 [kvm]
[  216.665492][ T6089]  ? em_sgdt+0x70/0x70 [kvm]
[  216.670959][ T6089]  ? vmx_read_guest_seg_selector+0x2c/0x290 [kvm_intel]
[  216.679008][ T6089]  push+0x316/0x5f0 [kvm]
[  216.684164][ T6089]  ? emulator_get_segment+0xbe/0x410 [kvm]
[  216.690978][ T6089]  ? load_state_from_tss16+0x940/0x940 [kvm]
[  216.697979][ T6089]  __emulate_int_real+0x306/0x690 [kvm]
[  216.704485][ T6089]  ? vmx_read_guest_seg_ar+0x2f/0x2b0 [kvm_intel]
[  216.711940][ T6089]  ? em_call+0x120/0x120 [kvm]
[  216.717583][ T6089]  ? kvm_guest_time_update+0x420/0xae0 [kvm]
[  216.724596][ T6089]  ? trace_event_raw_event_kvm_exit+0x2d0/0x2d0 [kvm]
[  216.732449][ T6089]  ? validate_chain+0x151/0xfe0
[  216.738101][ T6089]  ? slab_free_freelist_hook+0x11e/0x1e0
[  216.744690][ T6089]  emulate_int_real+0x79/0xc0 [kvm]
[  216.750867][ T6089]  kvm_inject_realmode_interrupt+0x102/0x260 [kvm]
[  216.758433][ T6089]  kvm_check_and_inject_events+0x805/0x1090 [kvm]
[  216.765924][ T6089]  vcpu_enter_guest+0xbd3/0x3780 [kvm]
[  216.773487][ T6089]  ? kvm_check_and_inject_events+0x1090/0x1090 [kvm]
[  216.781257][ T6089]  ? lock_acquire+0x193/0x4b0
[  216.786793][ T6089]  ? kvm_arch_vcpu_ioctl_run+0x12d/0x1630 [kvm]
[  216.794064][ T6089]  ? lock_sync+0x170/0x170
[  216.799259][ T6089]  ? mark_held_locks+0x9e/0xe0
[  216.804829][ T6089]  ? vcpu_run+0xb2/0xa00 [kvm]
[  216.810443][ T6089]  vcpu_run+0xb2/0xa00 [kvm]
[  216.815883][ T6089]  ? __local_bh_enable_ip+0xa6/0x110
[  216.822064][ T6089]  kvm_arch_vcpu_ioctl_run+0x39f/0x1630 [kvm]
[  216.829166][ T6089]  kvm_vcpu_ioctl+0x51c/0xcb0 [kvm]
[  216.835258][ T6089]  ? kvm_vcpu_kick+0x320/0x320 [kvm]
[  216.841460][ T6089]  ? find_held_lock+0x2d/0x110
[  216.847022][ T6089]  ? __lock_release+0x111/0x440
[  216.853383][ T6089]  ? __fget_files+0x1c5/0x380
[  216.858863][ T6089]  ? reacquire_held_locks+0x4e0/0x4e0
[  216.865134][ T6089]  ? __fget_files+0x1c5/0x380
[  216.870640][ T6089]  ? lock_release+0xe3/0x200
[  216.876005][ T6089]  ? __fget_files+0x1dd/0x380
[  216.881470][ T6089]  __x64_sys_ioctl+0x130/0x1a0
[  216.887004][ T6089]  do_syscall_64+0x59/0x80
[  216.892164][ T6089]  entry_SYSCALL_64_after_hwframe+0x5e/0xc8
[  216.898974][ T6089] RIP: 0033:0x7fd416905bab
[  216.904137][ T6089] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  216.927031][ T6089] RSP: 002b:00007fd416002e70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  216.937130][ T6089] RAX: ffffffffffffffda RBX: 00007fd4169ef000 RCX: 00007fd416905bab
[  216.946672][ T6089] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
[  216.956171][ T6089] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fff966831e7
[  216.965766][ T6089] R10: 0000000000000008 R11: 0000000000000246 R12: ffffffffffffff80
[  216.975342][ T6089] R13: 0000000000000000 R14: 00007fff966830f0 R15: 00007fd415803000
[  216.985071][ T6089]  </TASK>
[  216.988860][ T6089] irq event stamp: 1547
[  216.993931][ T6089] hardirqs last  enabled at (1561): [<ffffffff81385452>] __up_console_sem+0x52/0x60
[  217.005280][ T6089] hardirqs last disabled at (1580): [<ffffffff81385437>] __up_console_sem+0x37/0x60
[  217.016487][ T6089] softirqs last  enabled at (1574): [<ffffffff83a997a5>] __do_softirq+0x545/0x814
[  217.027532][ T6089] softirqs last disabled at (1569): [<ffffffff811eb372>] __irq_exit_rcu+0x132/0x180
[  217.038927][ T6089] ---[ end trace 0000000000000000 ]---
[  217.045467][ T6089] ------------[ cut here ]------------
[  217.051961][ T6089] WARNING: CPU: 117 PID: 6089 at include/linux/kvm_host.h:2346 kvm_vcpu_read_guest_page+0x21f/0x270 [kvm]
[  217.065501][ T6089] Modules linked in: openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 intel_rapl_msr intel_rapl_common btrfs x86_pkg_temp_thermal blake2b_generic intel_powerclamp xor coretemp raid6_pq kvm_intel zstd_compress libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel nvme sha512_ssse3 nvme_core rapl t10_pi intel_cstate mei_me ast dax_hmem crc64_rocksoft_generic crc64_rocksoft drm_shmem_helper i2c_i801 crc64 i2c_ismt mei i2c_smbus drm_kms_helper wmi ipmi_ssif acpi_ipmi joydev ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad binfmt_misc fuse drm ip_tables
[  217.134216][ T6089] CPU: 117 PID: 6089 Comm: mmio_warning_te Tainted: G        W          6.5.0-00313-g00aaa25de7f1 #1
[  217.147426][ T6089] RIP: 0010:kvm_vcpu_read_guest_page+0x21f/0x270 [kvm]
[  217.155531][ T6089] Code: 24 04 e9 d0 fe ff ff 89 44 24 04 e8 db 38 09 c1 8b 44 24 04 e9 1d ff ff ff 0f 1f 44 00 00 e9 59 fe ff ff 0f 0b e9 22 fe ff ff <0f> 0b e9 87 fe ff ff 89 44 24 04 e8 91 39 09 c1 8b 44 24 04 e9 25
[  217.179210][ T6089] RSP: 0018:ffa000001ad0f8b8 EFLAGS: 00010202
[  217.186390][ T6089] RAX: 00000000fffffff2 RBX: ff1100019e5a8040 RCX: 1fe2200033cb53c9
[  217.196363][ T6089] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  217.206324][ T6089] RBP: 000000000000001a R08: 0000000000000002 R09: fff3fc0002efd5fa
[  217.216274][ T6089] R10: ffa00000177eafd3 R11: 0000000000000001 R12: ff1100019e5a9e48
[  217.226228][ T6089] R13: 0000000000000002 R14: ffa000001ad0f9a0 R15: ffa000001ad0f9a0
[  217.236138][ T6089] FS:  00007fd4160036c0(0000) GS:ff110017fe680000(0000) knlGS:0000000000000000
[  217.247194][ T6089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  217.254995][ T6089] CR2: 00007fd416002f78 CR3: 0000000154bb0003 CR4: 0000000000f73ee0
[  217.264906][ T6089] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  217.274788][ T6089] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  217.284600][ T6089] PKRU: 55555554
[  217.289083][ T6089] Call Trace:
[  217.293161][ T6089]  <TASK>
[  217.296927][ T6089]  ? __warn+0xcd/0x2b0
[  217.301964][ T6089]  ? kvm_vcpu_read_guest_page+0x21f/0x270 [kvm]
[  217.309368][ T6089]  ? report_bug+0x267/0x2d0
[  217.314868][ T6089]  ? handle_bug+0x3c/0x70
[  217.320085][ T6089]  ? exc_invalid_op+0x17/0x40
[  217.325731][ T6089]  ? asm_exc_invalid_op+0x1a/0x20
[  217.331757][ T6089]  ? kvm_vcpu_read_guest_page+0x21f/0x270 [kvm]
[  217.339112][ T6089]  ? kvm_vcpu_read_guest_page+0x3d/0x270 [kvm]
[  217.346393][ T6089]  kvm_read_guest_virt_helper+0x97/0x150 [kvm]
[  217.353707][ T6089]  __emulate_int_real+0x478/0x690 [kvm]
[  217.360268][ T6089]  ? vmx_read_guest_seg_ar+0x2f/0x2b0 [kvm_intel]
[  217.367857][ T6089]  ? em_call+0x120/0x120 [kvm]
[  217.373544][ T6089]  ? kvm_guest_time_update+0x420/0xae0 [kvm]
[  217.380580][ T6089]  ? trace_event_raw_event_kvm_exit+0x2d0/0x2d0 [kvm]
[  217.388496][ T6089]  ? validate_chain+0x151/0xfe0
[  217.394204][ T6089]  ? slab_free_freelist_hook+0x11e/0x1e0
[  217.400874][ T6089]  emulate_int_real+0x79/0xc0 [kvm]
[  217.407014][ T6089]  kvm_inject_realmode_interrupt+0x102/0x260 [kvm]
[  217.414639][ T6089]  kvm_check_and_inject_events+0x805/0x1090 [kvm]
[  217.422140][ T6089]  vcpu_enter_guest+0xbd3/0x3780 [kvm]
[  217.429792][ T6089]  ? kvm_check_and_inject_events+0x1090/0x1090 [kvm]
[  217.437587][ T6089]  ? lock_acquire+0x193/0x4b0
[  217.443085][ T6089]  ? kvm_arch_vcpu_ioctl_run+0x12d/0x1630 [kvm]
[  217.450366][ T6089]  ? lock_sync+0x170/0x170
[  217.455537][ T6089]  ? mark_held_locks+0x9e/0xe0
[  217.461108][ T6089]  ? vcpu_run+0xb2/0xa00 [kvm]
[  217.466753][ T6089]  vcpu_run+0xb2/0xa00 [kvm]
[  217.472164][ T6089]  ? __local_bh_enable_ip+0xa6/0x110
[  217.478296][ T6089]  kvm_arch_vcpu_ioctl_run+0x39f/0x1630 [kvm]
[  217.485359][ T6089]  kvm_vcpu_ioctl+0x51c/0xcb0 [kvm]
[  217.491433][ T6089]  ? kvm_vcpu_kick+0x320/0x320 [kvm]
[  217.497653][ T6089]  ? find_held_lock+0x2d/0x110
[  217.503209][ T6089]  ? __lock_release+0x111/0x440
[  217.509571][ T6089]  ? __fget_files+0x1c5/0x380
[  217.515022][ T6089]  ? reacquire_held_locks+0x4e0/0x4e0
[  217.521289][ T6089]  ? __fget_files+0x1c5/0x380
[  217.526854][ T6089]  ? lock_release+0xe3/0x200
[  217.532235][ T6089]  ? __fget_files+0x1dd/0x380
[  217.537777][ T6089]  __x64_sys_ioctl+0x130/0x1a0
[  217.543329][ T6089]  do_syscall_64+0x59/0x80
[  217.548489][ T6089]  entry_SYSCALL_64_after_hwframe+0x5e/0xc8
[  217.555297][ T6089] RIP: 0033:0x7fd416905bab
[  217.560474][ T6089] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  217.583524][ T6089] RSP: 002b:00007fd416002e70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  217.593465][ T6089] RAX: ffffffffffffffda RBX: 00007fd4169ef000 RCX: 00007fd416905bab
[  217.603087][ T6089] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
[  217.612606][ T6089] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fff966831e7
[  217.622354][ T6089] R10: 0000000000000008 R11: 0000000000000246 R12: ffffffffffffff80
[  217.632027][ T6089] R13: 0000000000000000 R14: 00007fff966830f0 R15: 00007fd415803000
[  217.641658][ T6089]  </TASK>
[  217.645355][ T6089] irq event stamp: 2949
[  217.650299][ T6089] hardirqs last  enabled at (2961): [<ffffffff81385452>] __up_console_sem+0x52/0x60
[  217.661481][ T6089] hardirqs last disabled at (2978): [<ffffffff81385437>] __up_console_sem+0x37/0x60
[  217.672743][ T6089] softirqs last  enabled at (2974): [<ffffffff83a997a5>] __do_softirq+0x545/0x814
[  217.683899][ T6089] softirqs last disabled at (2969): [<ffffffff811eb372>] __irq_exit_rcu+0x132/0x180


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

