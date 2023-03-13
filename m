Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044BC6B7142
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 09:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCMIjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 04:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCMIjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 04:39:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D900C24BEF;
        Mon, 13 Mar 2023 01:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678696752; x=1710232752;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TTgLdwT4w573QFbc4FDXv0L2k8BBpYCoI+m9NOWJQbk=;
  b=SMWioV5qXZHE6xW08Oj2OF7BoLl8gGadgbR9RwPtZROUIBqTD4LZCu50
   Bd+hmzdfsTMZ+z44eGUNFkoqBaEu1njuKwrtjG0z1OTuztk4fg1hPX8AY
   i8GUWKbesj+lsCcUX/LiUZktlTgAfZV0Gno4hCDXL6ph6jnWtKC0J+CBu
   1T1MLpcF8nHtcn/nn14A/XAURHEYD0L1ySwJReYRg4jIHcrYLYYsPKrzz
   bRkjOAytV12+a6VxEGtOanLiqxJFNDI2LTw6EFYxM9mTCCP5dBIxoMlPd
   4DVbiIACzaNiou7jVD6s4o4FWt0IgUHyCGj5IQpS+IzlaTluXSnYtX1eL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320944759"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="320944759"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 01:39:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="655901956"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="655901956"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 13 Mar 2023 01:39:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 01:39:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 01:39:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 01:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJAvQVjhkBljCHNN/kbqkKtb/ldKqMKK7o4d/qELNx8zrLnN9qRY+xLcibXEiT8swY9aXFWYL18DQY82qgpMLwhfagwFkkR4uf2wvzHuosABa03dFk/CeMbJJV1Sb9qGe6ASTl7buNiFEDz3CR1BKL/x5XMH9YHdutpPp7FnRD+MOElfrhBiRroji4UrRJpcDbiVykLRnddJC0h3aU1lVaUL2jA+yRIA+bhqwei9CJOMXkHuqZ6wZjbuKQUWSYnTOEVLPvUVfCenR/WiLhDpIDt5Alvz7Yot7Qm4L6ZB075O5xBbYrvbsU95FtwXLFr0YTkdCZSPorPuaIqoQ/G62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqE8I3GT+gTnLVqRWIhnIzfwRp34apAJkoBqQBZIzS8=;
 b=VG8Y/vRf1K6yQFv+ufr8qnRa4Tq7fLWbb4UxCuGrNOK2xVbJuGEhwT/EfugeKow9sXsl6eqe+ikWyvcWyB31mC9tM12gnteLAB76rsbARCu650gy3R5l9b7WI7V2qFlnDnTIXqxT+42MDf3Yvwo0MDz6MkLnxR0AIaFu/Nom4GS/ARbxaVsUjlIZlPGp+/U+Oi7PfqBwzk4hqtbM1xQkxs0Lak5rsbooW1jVDuQYyu6XZdRqPwR7tvRdyb7DeWZT3cWqgWENXBrFQhZwQPT+R75ON+AypS8Nsf9ik/7yWV2FvYPDxlTuLtdRv9c9A9iQy7yqUAkc0b90lMQxl760Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB7989.namprd11.prod.outlook.com (2603:10b6:510:258::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 08:39:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 08:39:09 +0000
Date:   Mon, 13 Mar 2023 16:15:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: fix lockdep warning on posted intr wakeup
Message-ID: <ZA7bmJSN32y78lEC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230310155955.29652-1-yan.y.zhao@intel.com>
 <ZAtiEO/DST05GRRN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAtiEO/DST05GRRN@google.com>
X-ClientProxiedBy: PU1PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:803:15::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de026cf-709b-451d-081d-08db239e69de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ggJXZaCpNMZRHiaDh5karqasVGoyzSu7vUveTbsxKmAEJz1Oen7UNyncCXMUCRlTp8ZsJVaiLPlfSi4YtxJQIRjVw//sgzOQcwgB2pMT9hpi0/0GHFgzh9L+/Uno8taUJBDncT6ntHxiYWwMJXaoC1qisdVMYLqXUkemmSZejKV2J7ay1DlmQLpboSRt4oOSt8f8DbNEdRlo+bQfIcTpVnLwS6jAcbRXYpBdmKrp/K8EN1dDsyqxtzupzShiqAkeWYkjwqqS1SgOddi3MkqpJ0pt6c5aVD1Fwv12huoljU1f1li24Avtzw9fIYmPG1eMj1S8a7ytPcsXbBVX79pKyJo2gD+mZr1kg4FddZ/Ja/Vf6Qz59g88SnVR4lHS9jsBSoeSBJ1BQiaWUfdBWa+BeymWXww3X6+d8b9fbrnMZ0V1Gb32d2budMiSSVE3Kx/FNxObpfENQ1M2bin1C1fRUuXM1X3hzt0ur6uBoPnfoA3nE2AP9xyC+3VR9nX37HZxCua5/dYoFNJCyqupTcZX4Wg3w4m3DOwPFDdORclPTBOazkigJZy7kUrjzZcobma6o8EwosfN4onKC28e/UdHUktRY1CCwsd9QTkyTXozjmT4tE+JJuP6ZMO4oIk/z2hwROb4oBFaGoDsNWo/NGWucg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199018)(86362001)(186003)(41300700001)(26005)(4326008)(6506007)(6512007)(5660300002)(6916009)(8936002)(316002)(478600001)(8676002)(66946007)(6666004)(6486002)(66556008)(38100700002)(82960400001)(66476007)(3450700001)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Q34kXRXFF/cWqJzH12BoEV2CJGh4quCyvBKZDjX0OKvpWfM3T346LDnfDwF?=
 =?us-ascii?Q?OX9wyFzc53CkTxXQlyhG+G7ipdlYEDqMxDOcSDurZPs+NZuxWn0yVyun/VAT?=
 =?us-ascii?Q?F8DhvPhjx8fY7iyUo3mw6KKhW21d2eNKXyVyYOzqMWX79EDO0254jQ0pRnC1?=
 =?us-ascii?Q?nU6zFWufRtrZoa3HzScnbpEYXwxIMHQwXEfzfwU5G4cXzEqaQ6/UO0TZFYB9?=
 =?us-ascii?Q?3ofeVSWZWUPvVUGbbqHFLXI4YtzsVnp5lg2L8nyrdQv+C/wkPBcSbsRFjHog?=
 =?us-ascii?Q?aZjCi+YEzNYJd86KOKXvtQosvto1914vGaIX9CVamNbq2WsTHPgdsHzvNNsE?=
 =?us-ascii?Q?QMXTUIHRzhJFOWy64c900Y7atOaO2yF9y4JnS1/hNeDZiOkP2Y8tltdb9eRB?=
 =?us-ascii?Q?QHfmSfDC2O3e+Zh9dbMhAWLHjzW+k41CMYL8ykLrRdIVZBh0cGql30baoDAh?=
 =?us-ascii?Q?A3MZNfXecgl71ln3DzaBcu2Emt2r6PxUA9BLgnw+hA7/gsqUw8lcDILj3l/5?=
 =?us-ascii?Q?XtYY7QuXH0IcpxZEwt50eR8/jlbgNG3MOXVaRMHwiFL2rRRge/EYv5bCvFrf?=
 =?us-ascii?Q?6R+b0Ycs+dT8ySm62MLvxyz+TPfdMSIjPYwx9Mdjoi38nlgW+6PGam7o27kt?=
 =?us-ascii?Q?wSom3Tj5wX2EUDFXDDdj/tRUUGhZq3IeMcW8FWhOfyjUcgWmakok3Ca4F4eS?=
 =?us-ascii?Q?3CZI41OYmldruy51dwOyx+/bL8OnCqd0k9UVZf0GCY6uZ+Q65v9s+NLu0Mt2?=
 =?us-ascii?Q?WSI3UO3nE4F/vXYQAEyb+9ottbQtfZZqIe7uq0RmUP2pJBiQ/HIdx4ULngif?=
 =?us-ascii?Q?vx1oHBxldLpj7LkBx+Cq2kl3lhrpsFS7BMuXG6UyMPgG4iU/o+RfO9JionZi?=
 =?us-ascii?Q?H693INZ45Q/Eci5VYiD3wVs7nOOEXpA1cYm7axARjLiSEbSIP9IgJUOZuh/F?=
 =?us-ascii?Q?5mI8boitcF4IS5f1s7uZ6Zm4298o9txkfND/deVyPapV4oFuPqQateYk260o?=
 =?us-ascii?Q?ZE9x5B9AFa0m9LSMWlMd1WVsFOqbfLNJ9iENqkC8EgtB+yNcWe4bBEWOzyW2?=
 =?us-ascii?Q?qyt87rDqcFwgtm8iD/OCov8pYDJTVE83lHNaBd2xz4akK0kao5lP6gg6qwxi?=
 =?us-ascii?Q?56J8Hk/WI+TFvxd3bNDcTzg6kRuJ6a+POQ3MED6xw/GK+iAJVDFvM7G0R80n?=
 =?us-ascii?Q?bnUnnlvI9pDECYTMKKBwcql/iO6armFSiLU/pMPe7x/U1GexcPXPUrOrBjv3?=
 =?us-ascii?Q?/h1f+StqITTT/EMwoFIoaiSjPl7stec5ziMfEclb0XrXcf1UCVAZEUFLQzze?=
 =?us-ascii?Q?3mOVnbg672/aAjosn5hoZYsNC0MsDxJraSXnwLefU4YIuW0m2VcqaRy1VnA7?=
 =?us-ascii?Q?xQfH/l/2xvADZjfyV7qWM8NOoBYYMhQs5Wamtu8bzXLuEYiV0eQtUo7I5sIO?=
 =?us-ascii?Q?Z4elvCEQys4NQ15jE/Eo9G/YmAkL7C+IFZj/w2Bwty0o7yOsmuzt6nyKIg4B?=
 =?us-ascii?Q?M5jXTVh6PRtPq24ubi5KF9rSah2lJuWwzRVUj+dY7tUamO7PF0YNuugEk8Qo?=
 =?us-ascii?Q?qqbqWWcuT6Rwt5mwJ4v4ZdPH6ylFLjGQV6lDnwsAyjwVodZuxNDmzXxu8FxK?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de026cf-709b-451d-081d-08db239e69de
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 08:39:09.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tko4m3lAHHEjZqBbe46imlImL1qA3EYku0gRLdgAvebvLf32jKow27fFaD+uQoeu4/LOT/YLV0TSiM6iz/IweA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 09:00:00AM -0800, Sean Christopherson wrote:
> On Fri, Mar 10, 2023, Yan Zhao wrote:
> > Use rcu list to break the possible circular locking dependency reported
> > by lockdep.
> > 
> > path 1, ``sysvec_kvm_posted_intr_wakeup_ipi()`` --> ``pi_wakeup_handler()``
> >          -->  ``kvm_vcpu_wake_up()`` --> ``try_to_wake_up()``,
> >          the lock sequence is
> >          &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.
> 
> Heh, that's an unfortunate naming collision.  It took me a bit of staring to
> realize pi_lock is a scheduler lock, not a posted interrupt lock.
me too :)

> 
> > path 2, ``schedule()`` --> ``kvm_sched_out()`` --> ``vmx_vcpu_put()`` -->
> >         ``vmx_vcpu_pi_put()`` --> ``pi_enable_wakeup_handler()``,
> >          the lock sequence is
> >          &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu).
> > 
> > path 3, ``task_rq_lock()``,
> >         the lock sequence is &p->pi_lock --> &rq->__lock
> > 
> > lockdep report:
> >  Chain exists of:
> >    &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)
> > 
> >   Possible unsafe locking scenario:
> > 
> >         CPU0                CPU1
> >         ----                ----
> >    lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> >                             lock(&rq->__lock);
> >                             lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> >    lock(&p->pi_lock);
> > 
> >   *** DEADLOCK ***
> 
> I don't think there's a deadlock here.  pi_wakeup_handler() is called from IRQ
> context, pi_enable_wakeup_handler() disable IRQs before acquiring
> wakeup_vcpus_on_cpu_lock, and "cpu" in pi_enable_wakeup_handler() is guaranteed
> to be the current CPU, i.e. the same CPU.  So CPU0 and CPU1 can't be contending
> for the same wakeup_vcpus_on_cpu_lock in this scenario.
> 
> vmx_vcpu_pi_load() does do cross-CPU locking, but finish_task_switch() drops
> rq->__lock before invoking the sched_in notifiers.
Right. Thanks for this analysis!
But the path of pi_wakeup_handler() tells lockdep that the lock ordering
is &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock,
cpu), so the lockdep just complains about it.

> 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/posted_intr.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 94c38bea60e7..e3ffc45c0a7b 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -90,7 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >  	 */
> >  	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> >  		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > -		list_del(&vmx->pi_wakeup_list);
> > +		list_del_rcu(&vmx->pi_wakeup_list);
> >  		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> 
> _If_ there is indeed a possible deadlock, there technically needs to be an explicit 
> synchonize_rcu() before freeing the vCPU.  In practice, there are probably multiple
> synchonize_rcu() calls in the destruction path, not to mention that it would take a
> minor miracle for pi_wakeup_handler() to get stalled long enough to achieve a
> use-after-free.
>
Yes, I neglected it.

Thanks for the quick and detailed review!
I will post v2 to fix it.

Yan

