Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AFB6F62FF
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 04:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjEDCmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 22:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEDCmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 22:42:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470B4E65;
        Wed,  3 May 2023 19:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683168161; x=1714704161;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=13cZr1M2fmpLTMqDo35HiN6KirFvEojyf+Y0NLP0acA=;
  b=YLlgm/Eo9WgluJj/7xMp2IROZnyQZxm7GYWpd31HBrLpHgiUU/LrlAp4
   wqcGliKiDURgluDm67ypeQk7iTxgW6n8RQEOefceqc43Va8bSgvAxZRzy
   fNpyxTLua7L534/XyHEJJIM0/Mwb93aGvnnDjwy2VTQujS3hCCSF0gJb7
   oMDNCIkb8tEHX6kly2o1clUCny7x+DdBWLysE0Y/2z8Nmyav644CZwhBB
   4TZIQE5I55/CvhP1/EGOjnSj/24fNddq7NQ+UiCy/zlZ7LsXJzOZMw3Za
   saz2aMwx2OLwiZAUjiF6nadrsf/IZikR0kDd95BPh4MsxeTNcooWdiNS5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="333186768"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="333186768"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 19:42:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="1026755153"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="1026755153"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 03 May 2023 19:42:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 19:42:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 19:42:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 19:42:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMM4Dbr6i+IuC4GoU6tnM7sGpzMX6yfO87+5BgEUUGAxYC+22iDhUarsxAvdCc/HHxQwtEctgSnGl9i4aUeZbTC3OF/N20VtX/4EMlJGgSt9ppcbr7e5NnbhgzPrUoyZqw18Etkg4As2swm5B8htSLw40zrsO6vRn3H5EymHdLzFXoSHdSETXjgrU/AGXDADHLEk1nMGPhz9QKuoPc7D63gq0jJNdhpoS1WH7jJWJ/y4nNbCQ/LlQkJ9HgE3eNC1xQB3PUuOAeYN4JrPsI/edQkleaXGBku6+jIzLQN8lDnLc+Hur4tGN3eNiCuQNKjUt6qs4AD1gn+Z6eAo5fOneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjZQDQaYX7bw+RTKMRV8bAEKkcEOxANCpr8AoXbEGAc=;
 b=AKqCdzYhGb0C/qYHv0gpFXekyi6tNsLbxxdMgMg2diheaUIfEuXRUvat/v46q/+o4d0n/QqQwYpqgxCDcA7WICltaaOh37jq0FBjSoRlERCviqcyXpZNzJ4GueV+kb3cbcAhJjQpS8mYRa01oE/FLdwaUBb8JDrVy2BKzk1sXFqmO5uOtdU6Gt/Zs0gCTaYA3gliti5yIXUFd/uCsL93dkR8GGe7O5/daLaMimSdnwAWaKMm5vVUzpsz5Y4adhmBwV7jCHN7/ZwGGyO5HtQebTzbuSBiIZo6Xy805GrDUykX8npW2QXmZsN+JVZIUcTg06OV9IkXH3mWlD/TPmFrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.22; Thu, 4 May 2023 02:42:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 02:42:38 +0000
Date:   Thu, 4 May 2023 10:17:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
Message-ID: <ZFMVsFzpN16hiPUH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
 <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
 <ZFLrOgUL4T/lrVLo@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFLrOgUL4T/lrVLo@google.com>
X-ClientProxiedBy: SG2PR04CA0183.apcprd04.prod.outlook.com
 (2603:1096:4:14::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6037:EE_
X-MS-Office365-Filtering-Correlation-Id: fd927f50-4b7d-43c8-6c26-08db4c493920
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /98dg1bH0a2gLo+doovEnFABBzCkDtCbN1RyI+bMijeky/oM9aMH51NWv2OlQIRutRqTH+kBI9SxLsClji5XL0ynJndDYWhaZnHVX41fkASAvaBGVy5ck8vJTkRga1ESXmP/e2foBGGn9e6+zQOaWkYCupwtY3TMZKBiQX34Mr0jjQaYIJWPKL8qoMilQIf43KkitlVJCVETwhV/+Z3OWX8FOsEJfFxqhsK0qi9og14A+iDG6dk0yXbFbgNR8w4SmgCWCenPhomlROz9eHXBgKscJNzwKEFlZpFjpZV8EZ4aGio48uGScamraZT0ktUaI/JVfXkTKFH2ncSTye++Msay7RjzCoM5z/hKXAaKcgs1qM03uFlvJTg9C5x7SEp74NGtdJQQu/eU7iBcVgLc/Yu6iveHokJ5RzrRd9ZFFEncc40E2j6ZZ5NMom5Ni2tDPDbnLqQC7pi6oXXcuVxQ9Jk/T/qLmmgXvn6XESTRFeC9hYXrThuaIZtqUY/RTbfWnwmt3/cgulcV7Z9fXvZcaZul0hpqLeACWrwpWBY9XAWGfTs5k2k8UcHhglIL8iL3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199021)(2906002)(3450700001)(38100700002)(82960400001)(6512007)(26005)(6506007)(186003)(83380400001)(8676002)(8936002)(5660300002)(316002)(478600001)(6666004)(86362001)(6486002)(4326008)(6916009)(54906003)(41300700001)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CXZ0mvht+KkfntOfubiXKpfoofpI7FMaAA1bpjj2UOthiKhBEHHHhlku3SYv?=
 =?us-ascii?Q?+KTTqH9QxpXQ0vw2iy6jysE0EOOmCkoPEDpLjW799LgfSdOQSEe20ZWu29nG?=
 =?us-ascii?Q?vfg9kfBP462rJwyYT5DYPwB7hJ0RyKARceEedO23Oz0Jsn88AM/7v7eN4Ah8?=
 =?us-ascii?Q?0rH/URYByja5+5y9djS12J9QdtYSV5EOwcyN8taqBPDrP/2DfOhj1Xwq5ajj?=
 =?us-ascii?Q?meFc5Rl1d6KjR+w6ctIUsGzpCEAKpJbWtNFTqwGVAYZtjLIRhPOKFHncF6At?=
 =?us-ascii?Q?WSWf3xWiNIsUsTjjueXAI8oK9cnYk06Yh+hhW/PgEqAPuvRycv0Scq+6uF5J?=
 =?us-ascii?Q?AlWhEUT5rYfJ4AQrT/XXa/spEaEdf434ygxiWUVJFu9/mR2a+d1/dO8nqe7z?=
 =?us-ascii?Q?TOF9x4cOUCtx9vqPPm8HagZRjZNyuSvJcN+S9Hka1Lpmx9kLbYNSAsvMLsa8?=
 =?us-ascii?Q?nncpiDWbBN+Z4gamhT16RcNp35Vp5JQZ6I5hL+vmPtV8UDsO884kyRnxFbQP?=
 =?us-ascii?Q?evMcmGPL6MPb4afacHNBmlpS40/TAZ2lOfIVSdLoSOyq9OGvKDMNg4VgW7JD?=
 =?us-ascii?Q?SLmKJygnD/Eww2++QVUiqy7Gh13HIEaqea7N0RT+Z1OcJfADfIoHo5xW+slA?=
 =?us-ascii?Q?XTEWjhEvN5W38Z48edQcU4BTKm0oh7dNxz8MphZjEwhY+NMF/oJtgJ1+p4ug?=
 =?us-ascii?Q?jS3XbYtM1203F96j/rxDd56aCmdgH9oDw8yyHjJCF7ivnJOfT7FNmUvwPsop?=
 =?us-ascii?Q?XMCDP2rdy7H18HkdOmEznYKsE96qgb2yVIASun9yG67R7kYPInnNWFRW2o8t?=
 =?us-ascii?Q?Jrl9GWhMwCIUMJuYBU5dJ5cic7035sbYv8PpX6DK9LjexdbkQrv1vY1IgEN4?=
 =?us-ascii?Q?Rmu+G0EGW7lUyzDtjiTeh+aH7y4FVOhD0XyrgIP7wZIpzjfpgFjd5thfiIAc?=
 =?us-ascii?Q?tGXTqChdWzI6Bqo4LQi2DsUFm+K/FwKF6liOgJUqm5CRbGbq/qRjy7NSD7AP?=
 =?us-ascii?Q?HS6XvI9q3ZoSfS/MtkrAY0Pfi1nQyTM3MH+hFGBtbsxT1IlUjYcwf9MBcdfW?=
 =?us-ascii?Q?jTF9r5MFU8MnTLDNRtEYiuKn1h7IWXuKWXzPz9ScgCpbbNa26IZiXoi6+fMi?=
 =?us-ascii?Q?p+yQtgtKZ9J4bgi8gLDI6PSYZ4Jw8NjrVyzmEs8QRf9Du4/c4V74hWcte0Ti?=
 =?us-ascii?Q?EoIAfIxylrgpClpbhwODsidP4ik2y/6eFMn5Id/Rafb8ZCFX3MvEouPws5ZS?=
 =?us-ascii?Q?pVyo960vtk9LdDUNeJijgvuO11YHcRTMpuUh4jT8t6yxKyypqW1TodwANGGF?=
 =?us-ascii?Q?vqeSc/kSr2e7B0DDRpWbxKKvYTzrUb7mRiF26CoRvMCicKhSgRjrRnQALFQQ?=
 =?us-ascii?Q?JsApRrOWv0A6niI8WPDNuOeIJLaBjObpMNfPzWVJUsQwR16PAEPlOJChAYo+?=
 =?us-ascii?Q?5UZp3L7/HXte9btetX3Z9rOLKVgqq4aMxUj0rcATwJzevRFoexFJ4vlQgEHg?=
 =?us-ascii?Q?7hiQRaPZps5WL/4xFPqNRFsXs8S2Cqydh3OxfF5ffE0Vug9esZ2Km/CCv/1P?=
 =?us-ascii?Q?0EoSavMuuPF/UCpQBMamjzCC9PbrBWpxixz5eQ9v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd927f50-4b7d-43c8-6c26-08db4c493920
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 02:42:38.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5M6Cl7lCwjP8nQ0s4cFtGyTzcosgrqdob7FzpVZVrqHRBionlcSybp5P4UT6+07UFV/9B2N6tv0iS+azEyCxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 04:16:10PM -0700, Sean Christopherson wrote:
> Finally getting back to this series...
> 
> On Thu, Mar 23, 2023, Yan Zhao wrote:
> > On Fri, Mar 17, 2023 at 04:28:56PM +0800, Yan Zhao wrote:
> > > On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
> > > ...
> > > > +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> > > > +{
> > > > +	struct kvm_memory_slot *slot;
> > > > +	int idx;
> > > > +
> > > > +	idx = srcu_read_lock(&kvm->srcu);
> > > > +
> > > > +	slot = gfn_to_memslot(kvm, gfn);
> > > > +	if (!slot) {
> > > > +		srcu_read_unlock(&kvm->srcu, idx);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
> > > There should exist a window for external users to see an invalid slot
> > > when a slot is about to get deleted/moved.
> > > (It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).
> > 
> > Or using
> >         if (!kvm_is_visible_memslot(slot)) {
> > 		srcu_read_unlock(&kvm->srcu, idx);
> > 		return -EINVAL;
> > 	}
> 
> Hrm.  If the DELETE/MOVE succeeds, then the funky accounting is ok (by the end
> of the series) as the tracking disappears on DELETE, KVMGT will reject MOVE, and
> KVM proper zaps SPTEs and resets accounting on MOVE (account_shadowed() runs under
> mmu_lock and thus ensures all previous SPTEs are zapped before the "flush" from
> kvm_arch_flush_shadow_memslot() can run).
> 
> If kvm_prepare_memory_region() fails though...
> 
> Ah, KVM itself is safe because of the aforementioned kvm_arch_flush_shadow_memslot().
> Any accounting done on a temporarily invalid memslot will be unwound when the SPTEs
> are zapped.  So for KVM, ignoring invalid memslots is correct _and necessary_.
> We could clean that up by having accounted_shadowed() use the @slot from the fault,
> which would close the window where the fault starts with a valid memslot but then
> sees an invalid memslot when accounting a new shadow page.  But I don't think there
> is a bug there.
> 
> Right, and DELETE can't actually fail in the current code base, and we've established
> that MOVE can't possibly work.  So even if this is problematic in theory, there are
> no _unknown_ bugs, and the known bugs are fixed by the end of the series.
> 
> And at the end of the series, KVMGT drops its tracking only when the DELETE is
> committed.  So I _think_ allowing external trackers to add and remove gfns for
> write-tracking in an invalid slot is actually desirable/correct.  I'm pretty sure
> removal should be allowed as that can lead to dangling write-protection in a
> rollback scenario.   And I can't think of anything that will break (in the kernel)
> if write-tracking a gfn in an invalid slot is allowed, so I don't see any harm in
> allowing the extremely theoretical case of KVMGT shadowing a gfn in a to-be-deleted
> memslot _and_ the deletion being rolled back.
Yes, you are right!
I previously thought that
invalid_slot->arch.gfn_write_track and old->arch.gfn_write_track are
pointing to different places. But I'm wrong.
Yes, allowing INVALID slot here is more desired for deletion rolling-back.

