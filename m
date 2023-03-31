Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246506D1417
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 02:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCaAbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 20:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCaAbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 20:31:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A3912CF1;
        Thu, 30 Mar 2023 17:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680222682; x=1711758682;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+B0kDJPY3HyuzbE04LuO5/MwTl7H/z8qjwBVeKNMOE8=;
  b=mQ8KE7Eqn2K0tAQVNnrUzCU/kf5ARlNKY6PjDFpDuQ1KpdProB0XvGOD
   uUztDDtlTMBHBwSOAsWEcF2IniGLgN9e51EbbEQvquFmn0LcBUcPXil09
   2V/L5IOxBjoCPAcbscAt9bJ1mwb8ySzG11ZaxHIka2UJ7jhY+5h+FfyL/
   wiwBU66N3RCTsE+/qm7Rs/ZxiOztx0qkZf6nU19VTbEUG1pkOtMjRJ0+b
   KYKuj/EWwedkB34qEMilI01EuSGUEIbdoo5+2mQqyGczO7lD7VUN0CsGH
   7LVoVhlQJQmIBMzboheE42KOdTk3aMqXcgWF/GxmXXA2F0ylsr+8G4rF2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404019902"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="404019902"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 17:31:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="662230003"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="662230003"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2023 17:31:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 17:31:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 17:31:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 17:31:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2aeuyb01Jmnf9EnwCc34ddmHkwDgKzTnfPamYjbPUZf6tSotbkUCbyXmMBr64LXavbniPGMZAs017AwOu8pKsgkPw16sTyOicu8qhgokE6mwzyjzgOmlbdLzQ/UpaVmer9WgKT6UgfNwOu+UVl3d3l2qIjwvhmQJWoB8WIFMagKw0kX5B3MovJ3ZWU2EpjnDGCzGoahUGisKMfuO/M8sRFIk76+NluOeXKjGqSu0fPfxpJLaoEkvUoLoPjCI8q6b1l+IzDqPJIprnoF7gI1JQaXVNT5MJxMMDWprAthi5Y0qSMCFynXHJ90pwjrgftrKDAcGldwEmtiTJ/RIIWTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ivyQKgwrgVFRR6wFGquXRn+vOSCKHJfmK/xjnWMFYY=;
 b=oFD+oTdcSSm+4IIZVCfc1j6DhWfKSE/RxfGQbVGPNOjn86tr6LyKBZHEAWYRFaVjyMNUvTi9elkUEd4CYgKH5ClGF95WdwVKNz+6tkglAhInLbu3NNhAnCLA0MmZDphxn1tPld9BxILope1JVFnXgjqz79uuTjzHdDDSaITXf4gLgLvFiYCCiW4LbjuQCN0dOsJ/itGfRt2Feqd1mHHb4CXH78Jucvqed96dtnCTev7Rzoe1nRXwtqM04VhMd6et5Z6fH8FEv/P54HNeuqoMEAnCVNylTBmvHlDiIowcNFtJbi+n7uOc7nuUKGU8Ox77i52vfB3J5f5d3T7dtQDghQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8034.namprd11.prod.outlook.com (2603:10b6:510:247::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Fri, 31 Mar
 2023 00:31:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%5]) with mapi id 15.20.6222.030; Fri, 31 Mar 2023
 00:31:19 +0000
Date:   Fri, 31 Mar 2023 08:06:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: VMX: fix lockdep warning on posted intr wakeup
Message-ID: <ZCYj9yfbf+65OThn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230313111022.13793-1-yan.y.zhao@intel.com>
 <ZB4uoe9WBzhG9ddU@google.com>
 <ZCOaHWE6aS0vjvya@yzhao56-desk.sh.intel.com>
 <75ae80f7-b86e-3380-b3da-0e2201df4b7f@redhat.com>
 <ZCVcvuddkEFKW/0p@yzhao56-desk.sh.intel.com>
 <ZCXRgw5+5A7aluNc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCXRgw5+5A7aluNc@google.com>
X-ClientProxiedBy: SG2PR06CA0218.apcprd06.prod.outlook.com
 (2603:1096:4:68::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: 54da3857-b905-4ae8-0ba2-08db317f3e87
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97OSToYfdpI+PIULkPShA8tz2771WZ4YcgKzsiDFAOeRmFbtMrcA8bIHLLq/w9K14SlPivH9utBjOxCd0uVdkLe/QWG3xjFIBplDy4HAx6qJq0UjYXsYTNZTODA86zS+ZFLB9nOtML/OYiztEosrCHwp5w2X2CGHoyyqJyUy23xbT89fJ7v9QcKwloiyZiquC8NG2krghSe3I8NVDAlhEKS7Mt74y5DT4fERkBjPGNfH6Oc1vxIqnTSrlUVNgbB/iljbyVqtU87AcJg5ZrTgA13C1CEDnv+nS0DZNgKZNEtP93x1uSAW3SJYJk8QOJt8gea91/gsmIWXxKefHdkxOcVMvlLrPReKCU+dqmxwD16IWSGD+sP1V33gK1X0vXUCGBe5dUoV4Pc1WHRh9FUCuTkAVtzlqE35hUrkgLoT85FxQhKWIm9cQApXCh06c1KzYr/XQaMebe+ODxAT+4XfuNkIEp2UtDrT6IQHH4vtfV+6TsTtI8IMHAUV6EbMyQPCQ4EbC2wFR9S0LLILAlvTz64I/fFOYF6fZHlmqAHacy4nhYgLnNcU86teJl1uGYfabZC+kkL71nj9znl0/whRqMPdqNwesHhpkefmK6j5jvc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(6916009)(6666004)(26005)(38100700002)(8676002)(66946007)(186003)(6512007)(316002)(5660300002)(8936002)(41300700001)(6506007)(82960400001)(478600001)(66556008)(4326008)(83380400001)(53546011)(6486002)(86362001)(3450700001)(66476007)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C6zrNpj3waKWkynffBVMnISjFdg9LRhaSgsJpxJvidPO8RWOZdBxiKW5UAbb?=
 =?us-ascii?Q?sZkAKAK4MyhBQJGkOxIXz4nLnw3YAodovf1HLwA/HvaTvipKCHBCF2WtyhHp?=
 =?us-ascii?Q?BDndz6K8bKWca1ycQD8PkFAttQ3yMZ4Cs1QrNIwBh6Cyn/kHdp+z64JBLKYY?=
 =?us-ascii?Q?p3oJfzz4j+YcYUjUPm05ptyARs5CuvRpKpWxcr6vbBdwttIihXWfLIQMFwAs?=
 =?us-ascii?Q?vmsAXrltery5ib7bl0uvyRjmhd9428V7fLTS45VJS6c5leMv/GoVbbGbegpk?=
 =?us-ascii?Q?ICFTx472fZ+mfh79x5xw4itjFMQpbGd+GfgfwSPZMz1NJxgEpQw5QEB3TDku?=
 =?us-ascii?Q?rAqUBdLyW0kuLXEyuXnZ8M2Cgr5uR9+0SHRAlrRmWudiJ+2PGDXq60BwPkk/?=
 =?us-ascii?Q?jkGRjPv7I2jdwLzc5lB2rOwuigoDvu75LGoWwa51RPEjeo7DJwLQvWuOR4yU?=
 =?us-ascii?Q?B/xOpUmzKqGSpgTCjfEgZFc1XFlhguiuZ3WbxX9dUoGCsqgWvDtN0MTOn0E9?=
 =?us-ascii?Q?67bZYBFcnZQF2GosoH1w2zkGsIPba4egnUfp2tcLHWhYxU/A6+PqGlLM67Pi?=
 =?us-ascii?Q?m7TxLrarn4h6eQzknyoyS2+XGmtyHvpmJoqATjXi5nVaRIgrDZL37NlRorMp?=
 =?us-ascii?Q?0zbQkp73GqSLmf3Q5rb6mTgQzeVZhlS1haLXUPuU9/RbAGcWWbGa/NvfNuh/?=
 =?us-ascii?Q?sWHW5HLT+joW2HVAteDxN0nsvoDsWQu94HK843yS7DfJd5vrtiLEPy84JYQF?=
 =?us-ascii?Q?b4oS82x9isAJZ/BGfbbeomjV4ccS/2WmdrVjZ8xUN5HE0hEpGqTku6te6etH?=
 =?us-ascii?Q?5lsHRRCykpkvwQZ30lT87+VmWTVT+SlUMNb0Bq5pP3pyUipBSIrt8zNHjb+f?=
 =?us-ascii?Q?N4XFL7MurswdsV22xnpnX5Y2+Bcr/d1l0w79EWWv8apeWNEELNaYX3tBA+Wf?=
 =?us-ascii?Q?hWp5pMxf8+2RbkgbL6xPQNIj8xJbd3R/QYbKAffV+cOUM0IEATC7FQsUScK6?=
 =?us-ascii?Q?gA2OCBmCY7hk4okc+3o2igp2NMmOyerydgYZcoUY15cIJR3iEq/9RZoi0Zdu?=
 =?us-ascii?Q?96Ufw/SDXmtzqWYTGUC9iKMFmnLdChrcFhZwFslhh5N5PkOkbCgij8cWXdaJ?=
 =?us-ascii?Q?kwiVp4Y3xyaIapVDl511TiZcAyK4ELZ2D7Kua6mhRZ+XeinHlU5uVPR/IiZo?=
 =?us-ascii?Q?sZ9BW2poZq0Mh//ZdBCeltz5Cp5//fwoyghtvX+/F5fN3IVi/ih8AQwFg/nJ?=
 =?us-ascii?Q?fcoG1k6jSDacnmN9dfw+Y6nS6MkU2GSRWoG8GjYNZ018hw1EVSxMpr1lSF/h?=
 =?us-ascii?Q?My32I3ZhrHjUihKXEe3kBJuBPzmUXyEa6Q6dDScNkPL+IoshOTFjDVUVG5rm?=
 =?us-ascii?Q?B43w1HdbJWV6AxSI4LdPphklWySm4v7fcE9ty2+8oNqRZr5qIM97NMRSZTiV?=
 =?us-ascii?Q?5nVdeF6pGGA4J5/gkTUOCDCR5YB3SCyxASX2UG81yG3w4ys3T28bLbrYCQ/q?=
 =?us-ascii?Q?mwTlCbdPdPvoaGHkiqMsvi+QMNjK9PmdwyO+Zt2HbMb3FTYokKcO2XWP4a3J?=
 =?us-ascii?Q?vB2LUX6Abgech48dSdiGWTc3HQ8aUdR6yjMI9asF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54da3857-b905-4ae8-0ba2-08db317f3e87
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:31:18.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSyWV6+hIwOZcYVCcIN1jtFuXIZvrHM8NiEZbYi/2Aj+iMm4yYk1fbfiNw1LTvlJhXzTuyeBQCItv2eDrIrGyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 11:14:27AM -0700, Sean Christopherson wrote:
> On Thu, Mar 30, 2023, Yan Zhao wrote:
> > On Wed, Mar 29, 2023 at 01:51:23PM +0200, Paolo Bonzini wrote:
> > > On 3/29/23 03:53, Yan Zhao wrote:
> > > > Yes, there's no actual deadlock currently.
> > > > 
> > > > But without fixing this issue, debug_locks will be set to false along
> > > > with below messages printed. Then lockdep will be turned off and any
> > > > other lock detections like lockdep_assert_held()... will not print
> > > > warning even when it's obviously violated.
> > > 
> > > Can you use lockdep subclasses, giving 0 to the sched_in path and 1 to the
> > > sched_out path?
> > 
> > Yes, thanks for the suggestion!
> > This can avoid this warning of "possible circular locking dependency".
> > 
> > I tried it like this:
> > - in sched_out path:
> >   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
> > 
> > - in irq and sched_in paths:
> >   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > 
> > But I have a concern:
> > If sched_in path removes vcpu A from wakeup list of its previous pcpu A,
> > and at the mean time, sched_out path adds vcpu B to the wakeup list of
> > pcpu A, the sched_in and sched_out paths should race for the same
> > subclass of lock.
> > But if sched_in path only holds subclass 0, and sched_out path holds
> > subclass 1, then lockdep would not warn of "possible circular locking
> > dependency" if someone made a change as below in sched_in path.
> > 
> > if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> >             raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> >             list_del(&vmx->pi_wakeup_list);
> > +            raw_spin_lock(&current->pi_lock);
> > +            raw_spin_unlock(&current->pi_lock);
> >             raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > }
> > 
> > While with v3 of this patch (sched_in path holds both out_lock and in_lock),
> > lockdep is still able to warn about this issue.
> 
> Couldn't we just add a manual assertion?  That'd also be a good location for a
> comment to document all of this, and to clarify that current->pi_lock is a
> completely different lock that has nothing to do with posted interrupts.
> 
> It's not foolproof, but any patches that substantially touch this code need a
> ton of scrutiny as the scheduling interactions are gnarly, i.e. IMO a deadlock
> bug sneaking in is highly unlikely.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 94c38bea60e7..19325a10e42f 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -90,6 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>          */
>         if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
>                 raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +               lockdep_assert_not_held(&current->pi_lock);
>                 list_del(&vmx->pi_wakeup_list);
>                 raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>         }
Hmm...No. It's not about "current->pi_lock" cannot be held, it's about
the lock ordering.
In sched_out thread, the lock ordering is
"current->pi_lock" --> "rq->__lock" --> "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)",
then in sched_in thread, if the lock ordering is
"per_cpu(wakeup_vcpus_on_cpu_lock, cpu)" --> "current->pi_lock",
circular locking dependency will happen.
while if the lock ordering in sched_in thread is
"current->pi_lock" --> "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)",
it's fine!

If sched_out thread and sched_in thread actually should hold the same
subclass of lock, we can't fool the lockdep just to let it shut up.
And, we may not be able to list or document out all potential locks that cannot
be held inside the "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)", right?

BTW, could you tell me why you think v3 complicates KVM's functionality?
It just splits a single lock into two sub locks, and let irq path only
takes in_lock, sched_out path only takes out_lock, while sched_in path takes
both in_lock and out_lock.
IMHO, it does not make any functional change to KVM code.
Maybe it's because the commit message is not well written and gave people a wrong
impression that the logic changes a lot?


Thanks
Yan



