Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66272778667
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjHKEMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjHKEMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:12:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50521E4F;
        Thu, 10 Aug 2023 21:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691727157; x=1723263157;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HHBt1KhimbH5B5dXpmC/3G1z2b4/wYFS1dzDI3o0QMg=;
  b=Li77cwnB+aVAOjsb6R5Vr79aOE+XiPj54NdL2c1eQQfiVvHADEMmZ8cV
   1Avfcd2ny63JJHvO9mDMTJeHxM9CtqnP6C4o9a8baMh9oURfoNSG1D00o
   qI9Q4MltxeU1NXGpA/ePGXjEeUw2FbTfQC/enQRyRXVh+FD52gL71s8Nk
   Vg6Yh8JVK0X3AgBboyWkgaxad+W2dPZUqB39rolOclYlamFMVmjGFxF9U
   tYGMYEiY2C+xJWrF+TcW2LcT+Yh/3avkblUmO4gUGazCYMvHVAXvVse0s
   hmYsOulgoS/W474ih2VJvx6A3njXo11+no6/AgjJjvxZ8b65F3f+7LeWL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="370489724"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="370489724"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 21:12:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="726106282"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="726106282"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 10 Aug 2023 21:12:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 21:12:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 21:12:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 21:12:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYPkl1XWcQrD/d1+TqKN5+HTJKgtDA1H4PzOw3zM6+/OkOk68EsnM+49iIn1/gSK/cc35ucPZCPLen0dsW5OBOeRnu6qH0yMbCry5DM9jKPRajL7eg3zv6xrk3gNDHEpz9NkAN5uue7lJnVSsoSNUgAor2SnVlxQSvLmKhFtMrnd71Oim+2CuLbyY+Mnuh85ZSwC88BRP2a05nipMAiLOc8QResXwHYZYP6ISOy2X2a79XGg2wLwbIWyM17CbD6/5J+fBxhpO9NnppQZdLviqLsD0ti4ib3t5Gm1o4KgYaIJR/lSIB+C0Cp/bnj7BfDgGUo5dYfMKmxpIb1+84UIBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk+eueFcIiJXTyN4O5elOEYy89cQTk5KWY+2NJogL8E=;
 b=TIgike5ZlSY4MV7IrRmXSrlSfziol9N1/9eqpVXKQ0eCgLv1hpeL49FBysQlr3gbVbJTwN3yE5YztSeFqdb/zvl7oWtPIw8GgsO4IntsSAvcaiURwM/qTQ/godNZTv1ZDcz89fX+r4yE9N5gMHYzHX3b0A0Gs9AYG3e/fMQRsa6hnpnPbBRHnuJaeBXMMZrDXn4krs8Oo1A53croraHKQj+hcmw/u6kHr4iIRXG5Vk8d2nU89optKkBEIVGwg4fH20oT6SzVh6J38O6D9W+lGq2iyjxbbCXszxFkljC9OM7l9PsGbWoA2QktNxMuYEFlWW8d0j75ZdKlty+r+YWH0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7653.namprd11.prod.outlook.com (2603:10b6:806:306::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 04:12:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 04:12:29 +0000
Date:   Fri, 11 Aug 2023 11:45:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     bibo mao <maobibo@loongson.cn>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
X-ClientProxiedBy: SG3P274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::29)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb1a123-f96b-48e8-20a1-08db9a212d48
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0kT1yKgi3bmuTIifUpgFWDKEcyBLn9QtpG/oyBE4sXEyVpKmAb/XVeBE1unzwtMHVKtkVzixAqDQe+LRi0rbo3xiNcR0r9SKH3SWJqeLLYr0ZdD1eJ/8S2Doxq2ZTNcggGNbxr6hUcvMUfVy62GHiiqzKigl/on8Zcr9H5fpfP4g3bYQijmhnjjMbGATG25amtcBlPfmiRmdgUkngQNsTAWdrp3bhEqx65g+8xyD5DNiNFzvdd1J7HPwpk0e1huVvqact5ftuPcz0ebbYrWJE0dNeKBH2VRGZYaGZsOOT0GaJWtnf2WvRWzxS3GVj8JXsRVv+CO2+nHALFHW6VRGQOd24Nm/Sk6B213Jk6WPMV/r4QZiSmNRO+Ap6U3tICKR8VOUzUXUteIVO2crQflEtG3HAqtLA3UMjHQPglf7KVXjzUgcKhytje3Rn3UTQcaBi83XhD8I7YUNkiwjnjBjzwmtodqWJKekhdd5/h0Hjjzi3UqtezjiT6I42Jd312LT3wQdBfYI8GHAq1Ym4gNL7Sx69Qs0GCIPzUuhJvO7ax3WeeRM04NwZPT53CQp2kd+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199021)(1800799006)(186006)(6512007)(478600001)(6486002)(66476007)(66556008)(4326008)(6916009)(66946007)(5660300002)(316002)(54906003)(41300700001)(8676002)(8936002)(6506007)(26005)(86362001)(82960400001)(7416002)(38100700002)(83380400001)(3450700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZlP2YB4pCnPAEXiTD+7x1REHtGq4AOB2AWCRtUFSiZ+2ivfomW/EkNHzre/s?=
 =?us-ascii?Q?rVy2/8pZ0+txf8sM/TvZKZZBEyS5ti91y3IuruHqWVdUWmFtvACjfJP0Djke?=
 =?us-ascii?Q?JEuWsIf096WRwv31M+jvKtasohnowu5oT2MCkRaWzbyqXLyOfvdojZot7JzV?=
 =?us-ascii?Q?LsK8+VH3XOPibxmVdwVtwE7FRKSOjbbUVwS2vrcdOJi99iAI8JHGZbBTWkh8?=
 =?us-ascii?Q?LjH9hBajHvTywoogcAFoFjmqFole42VA93XHFOdbTqcoPc2uUOOmeWd04uC/?=
 =?us-ascii?Q?2QHLXiJ5GLm6yqRePRvZ5H1NhONIiU4Bgz1mUGqeBYsblkKMfoIGvmhNu9MZ?=
 =?us-ascii?Q?fv2zeSyaIKA/hAhJTqvrh/uXT4phVczm5kxn6wzc4AICA/+ucZAblY8/JEEw?=
 =?us-ascii?Q?l00CJ4TtajxBNkUxY94GRtOX2DXl9rmH7dxvDh2R0LrDG4yBwaKF+/LKk4Ug?=
 =?us-ascii?Q?ZezjXsrtdwLpOynbili6sETvU146If5pKV7BuEoLovdeUjGLL8xLrYoMcCIa?=
 =?us-ascii?Q?xmA1d+7xMQsu8ms7f7sHS1HYkhPDPIki/WGRI2MLpEV2/mxcuUsJVlY9RQRy?=
 =?us-ascii?Q?5kIFdaP+eVfDrchE71vSU54flkVlTebqIcqA+exPLLjOGks/c9nb4GpfPXuW?=
 =?us-ascii?Q?XOHliNb3TWF8ljb3zppwYuDYqBVwxxmDq4TTR8Zif+4jNBfsVaUnR/jSD1Ej?=
 =?us-ascii?Q?+PQxvi/8gpIM1NGahDuULoPBoSJDy5zMrg1URC/j4wLmZn4JlLHACCbSsV+q?=
 =?us-ascii?Q?xYKQxpmS5kProeXYj1LAFJgrh1awMlYXS8Zdx1cngPFrxH17fWzEF7W+yTwa?=
 =?us-ascii?Q?LNxEFdQjbsv/l26jGQxBbUUsRfuc1EtVhaEiLx01trIduADMVQ8dAURNg2d7?=
 =?us-ascii?Q?1zqZfpKCIdkZxGuaK1UxwR43NwBquwrnu4USNITG4TRBpT3NPjiRHTF6fVGU?=
 =?us-ascii?Q?HTcrvzp29tccr3710ESiXZ1AmVDnHtgxRWUdI/cbjy21NeFDSoX333z4/mib?=
 =?us-ascii?Q?hM+F2aADMbcCyXfZHw4USilt99HepqIEan7xecl0cpmzbaHch7X7Hc1wqzN+?=
 =?us-ascii?Q?8C9unBc5YJEy3fL+au7Fm+YQEIaMbYNXZNdBlESEhinpvYrBQt2uIhmn8yAb?=
 =?us-ascii?Q?rpbtmUZ65ebmqM15feXZdGk0Zeg2RAAHzgHbuwi8eubw4lEyPMEEWcyFIfuT?=
 =?us-ascii?Q?nYK98nhNkuUjKf0OeSrWNX42AMbCufkQcyO6S73NdnM1O4+OH1o/w+b6YWPk?=
 =?us-ascii?Q?lujLm55UBqj5jpE2KPONbPwARyLWrMR7KRpy9hhAzgcW2JasYyK4Xq7yCGKo?=
 =?us-ascii?Q?awfduixAhabpGhRYNl2iCKRPKVCewx1YMNT+ZypMt+dyUVJWXG2xYXJhHPRE?=
 =?us-ascii?Q?0U7PpGbC24uAVvM9ncGsA0ATpHPdFCoSC0B9LZbyBU8aKeGcHUk4JrQO2gsU?=
 =?us-ascii?Q?zCmx6IAzgzkJcM4Si7/suvVlcf8BVAutEdJuShBKHSkXD0DtlTSKtgODm5/q?=
 =?us-ascii?Q?lTN+5ONezKa81NhM9VmekumhiF+xCBQ2boKVo1FXr/8ciwZqVG/JGl/oOWu9?=
 =?us-ascii?Q?1DwCJIZb7bczxpPiA/niiiq/aBizy1dtpA/RPea0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb1a123-f96b-48e8-20a1-08db9a212d48
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 04:12:28.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Am7wUuUb+ZWscWRylPo6BzE0jhoIEy7xDYhdisDMpuNbV1Smf2LbT4bOn9T6ToSJdagfEKBcTJZ+jo7U6v8b1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7653
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
> > +					  struct mm_struct *mm,
> > +					  unsigned long start,
> > +					  unsigned long end)
> > +{
> > +	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> > +
> > +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> > +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
> > +		return;
> > +
> > +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
> > +}
> numa balance will scan wide memory range, and there will be one time
Though scanning memory range is wide, .invalidate_range_start() is sent
for each 2M range.

> ipi notification with kvm_flush_remote_tlbs. With page level notification,
> it may bring out lots of flush remote tlb ipi notification.

Hmm, for VMs with assigned devices, apparently, the flush remote tlb IPIs
will be reduced to 0 with this series.

For VMs without assigned devices or mdev devices, I was previously also
worried about that there might be more IPIs.
But with current test data, there's no more remote tlb IPIs on average.

The reason is below:

Before this series, kvm_unmap_gfn_range() is called for once for a 2M
range.
After this series, kvm_unmap_gfn_range() is called for once if the 2M is
mapped to a huge page in primary MMU, and called for at most 512 times
if mapped to 4K pages in primary MMU.


Though kvm_unmap_gfn_range() is only called once before this series,
as the range is blockable, when there're contentions, remote tlb IPIs
can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resched())
if the pages are mapped in 4K in secondary MMU.

With this series, on the other hand, .numa_protect() sets range to be
unblockable. So there could be less remote tlb IPIs when a 2M range is
mapped into small PTEs in secondary MMU.
Besides, .numa_protect() is not sent for all pages in a given 2M range.

Below is my testing data on a VM without assigned devices:
The data is an average of 10 times guest boot-up.
                   
    data           | numa balancing caused  | numa balancing caused    
  on average       | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
-------------------|------------------------|--------------------------
before this series |         35             |     8625                 
after  this series |      10037             |     4610                 

For a single guest bootup,
                   | numa balancing caused  | numa balancing caused    
    best  data     | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
-------------------|------------------------|--------------------------
before this series |         28             |       13                  
after  this series |        406             |      195                  

                   | numa balancing caused  | numa balancing caused    
   worst  data     | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
-------------------|------------------------|--------------------------
before this series |         44             |    43920               
after  this series |      17352             |     8668                 


> 
> however numa balance notification, pmd table of vm maybe needs not be freed
> in kvm_unmap_gfn_range.
> 
 
