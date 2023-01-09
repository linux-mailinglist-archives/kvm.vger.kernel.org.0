Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9E3662323
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbjAIKX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 05:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbjAIKXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 05:23:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22AF186C1;
        Mon,  9 Jan 2023 02:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673259719; x=1704795719;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dP5PKW36TfoCDW+euB+Leu/9hWMcDZodzG5CmkWzXpQ=;
  b=kAhayZ1KySsaeVnjzr+XanxG4z83t3lVsr4/O441qctV7W/E4mhoAd0k
   g0XmUCBssCouCigJrEyVxD7kU0dyjwiRDrIm2fxee25IXOSGaxd6sbEd0
   AX9fSsy2e98LRL+04NA1Ckk55dzw+ZEGmq4o+bfpQW/FBluIIgt3nSuax
   WPawnHJXNkbrB5LyNjRu20s4LoqCdHyI53ZIkP0jkDELvPMK5J3fGuNVV
   g/I6vrtQjx94kUxox3c/OEL4WjAIT4XW8t3ABIukXgbZTZpREkW2H62aC
   P2WxywLHZMYn6WTkEy3C3zDAOlw7xCwmNXF27j6eyXfAoHh54RfxYGJ1+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="385140985"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="385140985"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 02:21:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="658545023"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="658545023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jan 2023 02:21:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 02:21:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 02:21:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 02:21:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXH4yttQb2YZlrUa+HSYa61MPFRYN+MkXtTNGtuGb2gNEEa3/CEBhQxST2Xy+i+nnANvNGhatUA3Vj7xLIi/Pu6hR+HHEBbSSJP2Z2UHDemkEDoRIjT0OI4NmC+Yr6O1E5YqwRbUCtLi/0rwOveFSuNRspyYlxjatgi+X1SihxxCphPaRGIaZu20tWhf1WKlcVgtFl3GKZHpUqTZUH4Cpb2zNCVbOHowlSn+QWS+uB7bjJB00ogaB9CLpyOLN1aaFRlVEwE5JiemWjgBGarE6DzEETjZ9BGGKXRUxJa8XSRRrmhuIwlrCMa90K2lICsN30wwtz5zgZCns5ahlbeRQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhpobEb25S9Am1Kijn4DaEId1uFi1yP3kdxqyHVKyms=;
 b=Fx/qV+LVT2hxjONhPl4G4GyWHfVFiLh98PGSGjU/tjC2xe4NwZiDfaE40oKwrI/H9qJCXuHInMY0ULmndf+4BIsbqZVdhddmxZfBp2X0RGZgczRbBLpzbqh0lSDVDKH++hqLfiV8/moPfzCOl7VdB+OKHnrHN6YZ7c3FUHP8+pFp/1+if+bHHe/wCfOsHrH3w93lHocWm78rG/4Hu31/z0Rm9wwqkjn3wdGkEawzr4c4OislQzER8pYli9+VDbCwT8OQFPcCfBE7vBAl5Rqy+Hx8EO0blmgZmchk4EZH6z+tZCt1nBtK4Bqblgfm74yiN6EsZBVaF5hUVOdQMuQvgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6748.namprd11.prod.outlook.com (2603:10b6:510:1b6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 10:21:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:21:49 +0000
Date:   Mon, 9 Jan 2023 17:58:16 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y7vlOCKkJ+QyO3EM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
 <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
 <Y7ioYegkgKIH8uJL@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7ioYegkgKIH8uJL@google.com>
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d6f725-68d7-4897-9ce5-08daf22b5165
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlaGeaAcmrsA+jKxpwG/DuLnON6XUXnNByMzIvWX8xMSkbW6O8qTNLo58ZZ6/veM6hP33+BXGFOB0mpt6gzETpbpbxChbBHjUoBcBzBacEwnjHHSYuDeS3fEsF/YtG/ZCm5QMpzJvEw7QrXwvHZaGJsU+pjf7Z1EOU3uYgVdTn3DBnlC6EJUSfW+AZuSzyFgc5Ph5SHlTe75uYlUrrcmeQzNzIkTFBJPY3nYOEmBLzsYPfCrAZQbgY9l11+yt4AEU2WpF66pvTKUiIw5ORba04edZj4vD+2OD4FUID0YdqDH4GET3Q/STGzDnJrLBHTTSBizFwCGKCaTdEQF5x99WsChXH1Tn7eIxVYqRhMNT91GR5wvsHLpFhbr8SSMZvdcc7PgwxqhyVjgiNMTYd81DbVLfsdPJjdq8fX671n0xX8uXyUUsP4IQJhrbLV/mAORwIm3G/AeXrSqIkxCboos3UEqJFp4FTyw6rhmx3MpddCKI6S7VSqFjf4AawSqDJxhosYj4Y7aRJaOxj+q2l/636X30NGWstSXl9k1tFIuH4OL1h5Cn68hvK4Y4sbRuSR0eGgsZBqNKXwtMRdfI2HnhmmxjjcJ5VNBWgJIN8o1YvqX5LUtd3XAxCnVi3rdzTHlu++37+CyhkdwfVknfA4iraRjNgg+Q0BUyjWRgid3UmWW7ogye3PMk58H5EI4VnlS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(6506007)(38100700002)(82960400001)(6666004)(3450700001)(2906002)(6486002)(478600001)(26005)(186003)(6512007)(5660300002)(316002)(83380400001)(8936002)(86362001)(41300700001)(66476007)(8676002)(66946007)(66556008)(6916009)(54906003)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TYO3WTHbBewWiWCKIdn9FGRgxwl4SwWKfTRVbyuatC584Y2R8D/hPJWRggym?=
 =?us-ascii?Q?A6WNsYHX8wcxZFnE3cjhb6taxYnrOZb3c4r+1e0PoEwgAY8VfjghIKBJSG9t?=
 =?us-ascii?Q?0Ou2ChSrVd3laL5xNFbZwhknUdyL/7pUSEbTUPMY6iIO+ehr0S9k6MlQ6qwG?=
 =?us-ascii?Q?CTRkB7lUeWvQwZu0NZniaEqrB22ZTJyO/aZ5xa7ucWx9zyY+m5XB1eLm/+6s?=
 =?us-ascii?Q?f9xtVCqb9+30JxckDiBWscnpPHAJOtd1zmXtuC6Getv8kejInKSwTwCMmlrb?=
 =?us-ascii?Q?3LO37p70h4ySyiGP+E4GKhmS/akWrEtREgkOvHQNCLND3E+mch47hoF1I4L4?=
 =?us-ascii?Q?5sLrwMZ6mwzX1I7vaIiHwte4eCGhq7JnxRvReXis7VXvpMWArs2ydPiT6a4z?=
 =?us-ascii?Q?oUgW15+/EzY6nhLQJO0eMrEAh2de8eCz3nl0ZlPki6tHWzvJbEnsmVNS/b2N?=
 =?us-ascii?Q?10siX4GSv93FLrqCeCVa6q5NLKOcKZtTmGmiJz8bcMiXl8/MUse8+5dXxLWh?=
 =?us-ascii?Q?h2U67z9UhZevUezI6ijoKUDyGhgPmy1k3hWLqCCv34H6bFvQLAUhfoij8iyg?=
 =?us-ascii?Q?O7izxDsfzEfh2/y4Ys7nZPrWeFShnCE/ZHjeCwc1l+DtVoPQfDszt/JZRBWj?=
 =?us-ascii?Q?vHbUjVjFEL3hHLOmVULop8qfbMOpXd1MpyTbI4i302dY/otj81MWDiDrqwfd?=
 =?us-ascii?Q?n2LUo4nk9A6RhrMrJGfmvg0ENj9iH730dyquLfyTMT9/IlQ8nWkTSRJQOgWN?=
 =?us-ascii?Q?efZEM8O0V6jKyYLYrXU7c19BwCwp3fswCbCZjMqBfYN7S1qk0GafEwJNQulU?=
 =?us-ascii?Q?T4ZrFOUMis2N4zlIlNXCV+ll64MMj0RUdoa2wyHN2PnEsGt4ZXfWlj621G6O?=
 =?us-ascii?Q?7u2MM+0PkYlZSOBHzHGJ4/JngkuE7cBabFrKPNAl7TDluKS4WMR5mg+t0BOT?=
 =?us-ascii?Q?otKPVnUT9uRRQRb4eP/KdCfzCUaXAspYt1fhqOhQKnkX2XiCCbT09F+oXRuC?=
 =?us-ascii?Q?qVDESTxgZ9uj4w/ICLfFE8ylxxeq1O7GADzBX/Ra44UdYLILp/ecNRbNirg9?=
 =?us-ascii?Q?uOQ4PWab+JMsSxRGNTavszNMDFMMnF5l5QArIkt3VMH/JTQ7vHa6kkeaBx1l?=
 =?us-ascii?Q?OI/IPJIOVMz5VSrk5DrCEkDTlgum38DAQ2E+g92nP7zrBQxjE2PSaMHkQWeA?=
 =?us-ascii?Q?aqEq7pkVesS2NTnDAxo41cO7XKkMA4jh6/G2vGnXhiCZ628AaG/5Q6BY6U9H?=
 =?us-ascii?Q?6m8EUvEpIOYfPB3Jty2hTiIzE22WNN7TLe+2pfZnLR1Ar9wr1mTjINA/Gr/s?=
 =?us-ascii?Q?rN5N91goSJAeG2am9NBgRMZ4RzkCyhc0TUUj2hrxM0BGuEmyCR4FCflge0BV?=
 =?us-ascii?Q?AVyfX6bB2Eg6p7miIx3SWt0A0N2qlNRJGX11kviwqXs/PKIcRzTFi1jvbhQ0?=
 =?us-ascii?Q?u2B4aRQc6TQapYjcmXbmPx1rmT5iesihE9diKdFsERdlw7PJFciiGECBx7S/?=
 =?us-ascii?Q?yC5d7L74HAQ8zQKBLaAYqoRonvroCcz7pa4MAmV9sR25HLPsBOMcWC6m8Ta+?=
 =?us-ascii?Q?cofpHeehUqKdj6ud4macjXQW/oW2FNziBId8N/3h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d6f725-68d7-4897-9ce5-08daf22b5165
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 10:21:49.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tc84UTapZ+5MwSmJ28UdF8B+I9cXyjsX3dF2SjNi+EzGSMqv07zFewmmbyaeWIolOZAQdOV0nH8slV0ksYQ2/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 11:01:53PM +0000, Sean Christopherson wrote:
> On Fri, Jan 06, 2023, Yan Zhao wrote:
> > On Thu, Jan 05, 2023 at 05:40:32PM +0000, Sean Christopherson wrote:
> > > On Thu, Jan 05, 2023, Yan Zhao wrote:
> > > I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
> > > and permissions, and that the only requirement for KVM memslots is that GTT page
> > > tables need to be visible in KVM's memslots.  But if that's the ABI, then
> > > intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
> > > ("drm/i915/gvt: validate gfn before set shadow page entry").
> > > 
> > > In other words, pick either VFIO or KVM.  Checking that X is valid according to
> > > KVM and then mapping X through VFIO is confusing and makes assumptions about how
> > > userspace configures KVM and VFIO.  It works because QEMU always configures KVM
> > > and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
> > > unaware readers because the code is technically flawed.
> > >
> > Agreed. 
> > Then after some further thought, I think maybe we can just remove
> > intel_gvt_is_valid_gfn() in KVMGT, because
> > 
> > (1) both intel_gvt_is_valid_gfn() in emulate_ggtt_mmio_write() and
> > ppgtt_populate_spt() are not for page track purpose, but to validate bogus
> > GFN.
> > (2) gvt_pin_guest_page() with gfn and size can do the validity checking,
> > which is called in intel_gvt_dma_map_guest_page(). So, we can move the
> > mapping of scratch page to the error path after intel_gvt_dma_map_guest_page().
> 
> IIUC, that will re-introduce the problem commit cc753fbe1ac4 ("drm/i915/gvt: validate
> gfn before set shadow page entry") solved by poking into KVM.  Lack of pre-validation
> means that bogus GFNs will trigger error messages, e.g.
> 
> 			gvt_vgpu_err("vfio_pin_pages failed for iova %pad, ret %d\n",
> 				     &cur_iova, ret);
> 
> and
> 
> 			gvt_vgpu_err("fail to populate guest ggtt entry\n");

Thanks for pointing it out.
I checked this commit message and found below original intentions to introduce
pre-validation:
   "GVT may receive partial write on one guest PTE update. Validate gfn
    not to translate incomplete gfn. This avoids some unnecessary error
    messages incurred by the incomplete gfn translating. Also fix the
    bug that the whole PPGTT shadow page update is aborted on any invalid
    gfn entry"

(1) first intention -- unnecessary error message came from GGTT partial write.
    For guest GGTT writes, the guest calls writeq to an MMIO GPA, which is
    8 bytes in length, while QEMU splits the MMIO write into 2 4-byte writes.
    The splitted 2 writes can cause invalid GFN to be found.

    But this partial write issue has been fixed by the two follow-up commits:
        bc0686ff5fad drm/i915/gvt: support inconsecutive partial gtt entry write
        510fe10b6180 drm/i915/gvt: fix a bug of partially write ggtt enties

    so pre-validation to reduce noise is not necessary any more here.

(2) the second intention -- "the whole PPGTT shadow page update is aborted on any
    invalid gfn entry"
    As PPGTT resides in normal guest RAM and we only treat 8-byte writes
    as valid page table writes, any invalid GPA found is regarded as
    an error, either due to guest misbehavior/attack or bug in host
    shadow code. 
    So, direct abort looks good too. Like below:

@@ -1340,13 +1338,6 @@ static int ppgtt_populate_spt(struct intel_vgpu_ppgtt_spt *spt)
                        ppgtt_generate_shadow_entry(&se, s, &ge);
                        ppgtt_set_shadow_entry(spt, &se, i);
                } else {
-                       gfn = ops->get_pfn(&ge);
-                       if (!intel_gvt_is_valid_gfn(vgpu, gfn)) {
-                               ops->set_pfn(&se, gvt->gtt.scratch_mfn);
-                               ppgtt_set_shadow_entry(spt, &se, i);
-                               continue;
-                       }
-
                        ret = ppgtt_populate_shadow_entry(vgpu, spt, i, &ge);
                        if (ret)
                                goto fail;

(I actually found that the original code will print "invalid entry type"
warning which indicates it's broken for a while due to lack of test in
this invalid gfn path)


> One thought would be to turn those printks into tracepoints to eliminate unwanted
> noise, and to prevent the guest from spamming the host kernel log by programming
> garbage into the GTT (gvt_vgpu_err() isn't ratelimited).
As those printks would not happen in normal conditions and printks may have
some advantages to discover the attack or bug, could we just convert
gvt_vgpu_err() to be ratelimited ?

Thanks
Yan

> 
> > > On a related topic, ppgtt_populate_shadow_entry() should check the validity of the
> > > gfn.  If I'm reading the code correctly, checking only in ppgtt_populate_spt() fails
> > > to handle the case where the guest creates a bogus mapping when writing an existing
> > > GTT PT.
> > Don't get it here. Could you elaborate more?
> 
> AFAICT, KVMGT only pre-validates the GFN on the initial setup, not when the guest
> modifies a write-tracked entry.  I believe this is a moot point if the pre-validation
> is removed entirely.
> 
> > > 	gfn = pte_ops->get_pfn(ge);
> > > 	if (!intel_gvt_is_valid_gfn(vgpu, gfn, ge->type))
> > > 		goto set_shadow_entry;
> > As KVMGT only tracks PPGTT page table pages, this check here is not for page
> > track purpose, but to check bogus GFN.
> > So, Just leave the bogus GFN check to intel_gvt_dma_map_guest_page() through
> > VFIO is all right.
> > 
> > On the other hand, for the GFN validity for page track purpose, we can
> > leave it to kvm_write_track_add_gfn().
> > 
> > Do you think it's ok?
> 
> Yep, the only hiccup is the gvt_vgpu_err() calls that are guest-triggerable, and
> converting those to a tracepoint seems like the right answer.
