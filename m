Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C336BE251
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 08:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjCQH4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjCQH4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 03:56:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92A61CAEF;
        Fri, 17 Mar 2023 00:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679039778; x=1710575778;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uXUeH1zPJKahoE8UFOb1rbm0Y7GtPj7ezziSa6lHwCo=;
  b=kKPwKp30W8icFJEK7/h7xZPPXvquzvIVujzXtpcy7rjGJ4TmvSlY7fJb
   Q4Txw4hNwrw4oHeio5c0DoYxHSNzPmA2EpqzfjDfCRQyZgNprqT4YYn5a
   dnkPPkj8iLpKVchEPujd9TWT4lp52oseCJMNyNBcqUjU7YYQ5FaAJICeh
   N/It5uPi6GdGtRfLRH7o6DfCd9yDJkUFnwVtWB2DVji17J2o2ob0WqRSr
   OpWhCVedF9+Tii3ybUqfU1LYtFX6csWnx9rUanOU7WX/sJQb763DKvhWR
   bARwX/HojoVfmAq6uB/hK3cUIEug/GOWL20P3Jntb0vtI5ANM3/UhBpvp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="335699862"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="335699862"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 00:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="926050501"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926050501"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 00:55:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 00:55:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 00:55:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 00:55:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNH/bhWwmJLa+rGTEid4j89v2KgOGnWKS51AgU1yZZ25rF7iVIJy7ETumWDJCVgu3DbLWiye8g/viretPAJjVNIl5VpPO3h7IiCf82wL8QSfbzugCUQLeo8UYEH1Qw8kZxlGKUhz+VGh/xIaPGaqEH3ZjiBFQouCsVG13H0luSZES4zXjY8ENF9VTL/OP9A22Cksiag3oDLxBV73zW3L3e8iL98SDtvhZxI9VUa1vj9Qbry3bryBi7c43MdDkMqqX+7dcFJtwUV4z2RRUBsLzekwFM1AZCHnz1LQNs7OZJ5YQCj969FZeN7PVHf1TgGDsoSYUppMFcawZpPbyDWpTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEAgHtpwM+ml+K1kQnDC5QFwaZaCdnDOb9XsRSKPxEs=;
 b=odxaqYbYj+eDiEQzXaD+yM5qG9J6CrYx+4FTKrAvo56OqUnN0gxIaBYoYc+TyLE77TQNSgPtU0mwClCqO91MuaHjpMM2Zn3JDOP3lTNbLa3yNPw+ErLmOnJVNoM4uPEbtIYFPIA/zEuvzo6vTUCrun/rGyGGPRHsm2ciSM0b/nzBZm98nDCG8Y6pharZACjJHY7WucemDUFivqqub0SM5t6IWX4J6wyUEzDb8eyYRJrOfM3G9ItshPMdLgRiHW5qFFMTrR2OsHtrnLbAZn7V7TCBzYo8GOYOdQtuT23PHl4f4QOvAw8sRFwjwQi2UYmXX8QA+LNJ9A/Gd+H5yT21Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Fri, 17 Mar 2023 07:55:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 07:55:35 +0000
Date:   Fri, 17 Mar 2023 15:30:58 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 15/27] drm/i915/gvt: Don't bother removing
 write-protection on to-be-deleted slot
Message-ID: <ZBQXMmjKNPIyowUF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-16-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-16-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: 8343c8ed-7cf3-42f4-4b16-08db26bcfd29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yENQPc5KUvI6qT4Sx/h11xz48HVo8IYGRIlO1AkEOH2h2X5290XZocTgMmxqRkzEFMUu+ua2RzyZ/HitfWxkRThicfBaB0krRJjDUQCZrgXH2oBND4aOywzaE62nbGuyJDCvmtzoNgqgw5nuLn+XAXrjM3XXZEmSVZuVoN4EHZAmJ6CJuWjUFvFBqGOdeFl2lSNIa6/Nq57n2wA4JqCK5LHkZ2PBaIrKKqLOEK0tTq7KLkHwB3nJyxmHE4H0tVVH9Vi6wxyRlN7fdHYUbB5A59vbwNWGNCUsh5F8uPlb8Two/CWsYGUiuE8XLb+muCX/Z9qR/nDGiWEbBNRpdnq7NqLxC/tmLSmVfSv51UPPd6yzYFC3T52OkZNdZenjdAHkYYsWggAoZKwPf5WlDGclI5IWWT4OZ3V09DAM48iBlvKkd+hEczc3aqce67zLSYl6Nb6kBvQZC482G8UEKBqXPNj1K80pI4bS289f+wLMnaMNvBJ9fk+00/4np7UQg0KTpxgeyBH/eT+Fo0vLZwd63ntAaOQbriFX0uFSYZRY+OnYnm8ZeA/FkhhTb3At/1JgmEl19+eaQX7jiQ9qnvM2miYQxQD74nJoxfCYioDBI7fiLwMvz0Ps3n4wjf1WWV7G7AFatcy2E6UVcjozM24PGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(186003)(6486002)(478600001)(6666004)(54906003)(6512007)(6506007)(26005)(316002)(8676002)(6916009)(66946007)(66476007)(4326008)(41300700001)(66556008)(83380400001)(8936002)(2906002)(3450700001)(5660300002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EXWp0FMyMhuTSQXdv+C+F44vXUg+eJVl/vz1a1+/suROpm+gTaqq4xmUdBcW?=
 =?us-ascii?Q?4YRHEHn8+2bJ8rbBDJ2sEz/Uxq1S0jk5fJlKoagPDY9UiwTv0j5JUNu5eZqT?=
 =?us-ascii?Q?P6V7Comf0tkxZz6mGDDxpH58Du7DKLs2iY+D0U2hdRWMcJNHEo5NfLfpRyFI?=
 =?us-ascii?Q?NApSG05aAJFc9In6vwEDM7a9QgO2Gj7WWD/a7JHEJT8rddwAVQIql4SgWCCa?=
 =?us-ascii?Q?Wfj72n+g5FrOjGx/+jFLPBewYs58x2VGVXu55iZfUW2QR2CnL2Js7URjq1yG?=
 =?us-ascii?Q?Gf65PYqF/tjJlq5YJXsGsM6bj8INZSEa+ZujrWFDuoh7C7eIDa152c10rSeW?=
 =?us-ascii?Q?6kDZV3pH+ZDcRGjw+CkJD+4QJygVUkDR28he0zssRfpa1U/UpI+tAxl2iDiV?=
 =?us-ascii?Q?JfA8HtAP6D5WiA7frn1LqoZ0AqU+Ge7a9M57WlbFAI+Vd4jXFAQkWZv798XL?=
 =?us-ascii?Q?DJa+zDMIOa5BkaxxiOfi+ojl3EKLuIwZmt7dxJddimwWJypcHUQunzlml5IM?=
 =?us-ascii?Q?NTAu9RdediYIykizNUdIfeBp7VIMDzvOV50HYt5owFJtmIQ2XjB/huDANTtG?=
 =?us-ascii?Q?HTlDdEOsuVnCv6bpjj1LNn1L+Zv91WzIZkEaRXaEpp5howO7X218R5CmK5LO?=
 =?us-ascii?Q?dyyZ21uUTzmEgXVDwo6SE2fsHJ74AVLHqafTCbssp7g8U2+Z+DefQG+OMjAu?=
 =?us-ascii?Q?RDQJdQkIvXqLffr9r2wOxvpJT7wS0C2HE1J3ZkBo3zBctNfaiUwiRRi/WFN0?=
 =?us-ascii?Q?1B3N6ag9g0sPfU9/ogdNq+53eN2MgbTYwszYisAvaVW8hr7UX0apF1bumCRJ?=
 =?us-ascii?Q?zFkjYR4LDCqRTcKYEC1/Z+AttVV/quW3p/oMIUPgtEsE2g0P5zNUSiEFheDY?=
 =?us-ascii?Q?hzGigZKXetlD0nG2WJAyLCJzwd2QkgpxidJ3GG8nAlAVX6NOtqDGrr30Q4LB?=
 =?us-ascii?Q?AbfCQTzEeRm1bRYSsD4d4bLbp1v6q8XPY044lRfzBW7n2u3RNJbwseGc4QLv?=
 =?us-ascii?Q?3YluefJZiHLBIvnQfTdWD1joWmCTViEKSARHazsnkRTc45snNRtKot/xOU7P?=
 =?us-ascii?Q?uJqXd4Bmf0pT3Kfw2T/kewu/yPFRpG+4Q4FhCgO5fu6Gpf2L41jUQlORGR9m?=
 =?us-ascii?Q?t98Qn4mg0txsGJRq57ccgC3lNOPborb/qjJAUGJeHHyu4s3/ZNa/+9+fUKuW?=
 =?us-ascii?Q?7q9JqeU881Z35m4KxxruG+VG5pMO2DDy2Jwh8M5INX0Wt9fjLTE2KWN/GjIO?=
 =?us-ascii?Q?GTBjxv0a19K4lLYi82xKNsm3fRRVU8TDY8+rptbx4QIasHXsp/4kPF4jPCHT?=
 =?us-ascii?Q?jVfDSqb78qy0oFHxOvw5VTDBDJ+ew5up1Ugvkl2sEYkiU0RKSPll/bvcBEbG?=
 =?us-ascii?Q?a9s8ilKUzDUOximpguyVnVW0nILSLE7O+LsGih386QvBODjeqioYHSq0XqOA?=
 =?us-ascii?Q?a0A3ms3rO0oeRtbP49L+u7Popz9Hc7dC22GarrIA4XhHKA64YkOQVLJy6xeV?=
 =?us-ascii?Q?fhO1qWlFA2xSp46ZoTHnMI2bfKZX4LgmDYQcT1gXF2EHPp0Xr+FSZQklErHy?=
 =?us-ascii?Q?Jc/3ZzmvwEVIORNN17IVTQZiadzhamr2hmawqn97LzCm/ybR3TtNd5PdcFzw?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8343c8ed-7cf3-42f4-4b16-08db26bcfd29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 07:55:34.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxUnt8W7SuPXKGuFrk9ojyOfEXtcuNXX3dPWcYPfl9JVAtIzcziWjxJTEUXdn7wkPDSn5cOB4qDuaioD0BaL7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272
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

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:46PM -0800, Sean Christopherson wrote:
> When handling a slot "flush", don't call back into KVM to drop write
> protection for gfns in the slot.  Now that KVM rejects attempts to move
> memory slots while KVMGT is attached, the only time a slot is "flushed"
> is when it's being removed, i.e. the memslot and all its write-tracking
> metadata is about to be deleted.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 292750dc819f..577712ea4893 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1644,14 +1644,8 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>  
>  	for (i = 0; i < slot->npages; i++) {
>  		gfn = slot->base_gfn + i;
> -		if (kvmgt_gfn_is_write_protected(info, gfn)) {
> -			write_lock(&kvm->mmu_lock);
> -			kvm_slot_page_track_remove_page(kvm, slot, gfn,
> -						KVM_PAGE_TRACK_WRITE);
> -			write_unlock(&kvm->mmu_lock);
> -
> +		if (kvmgt_gfn_is_write_protected(info, gfn))
>  			kvmgt_protect_table_del(info, gfn);
> -		}
>  	}
>  	mutex_unlock(&info->vgpu_lock);
>  }
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
