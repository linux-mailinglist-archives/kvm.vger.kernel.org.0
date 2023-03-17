Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7696BE576
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCQJXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCQJXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:23:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAC3B4814;
        Fri, 17 Mar 2023 02:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679045016; x=1710581016;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=91mFiWU+fEwn54Y2AzZ1Dg0FMIN1c10lQRxTIyNAzQo=;
  b=G4mWvjam89rejazEIv6sLo9IiyLgWhRfAb0vRTRwaiT9lfUvLZygZp7b
   WYstPPwOX4QGDVeLjdei/BZGIKAGNKtq4/apFevqkFeH5CygF6juxR++8
   yp1lkiTiv9z1esS4+XQD9uSdAXR3jZlmabFwsUYQxgv7iUUJt7Zkm98Ft
   U34j7NzvsH5CBHFfTjbwcQqLKQ8sY5lrNz7zp/FdbHssHx4CzcyelZFQW
   EKhhZS9uoq61bnoFWBQfR5ysQAGzA/HAkWTNNTTOftk/7fkTEHtAJTWkG
   3+jP+Q6l12n2nvmUaFrvBQhZ2uFTZi7mpsWGJrJQqRA4o+HAvmnNaeX4c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339760796"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339760796"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 02:23:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769299704"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="769299704"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Mar 2023 02:23:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:23:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 02:23:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 02:23:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiMO/u8+Hb9KjXnvHl9j1VBnVBMT9dwlgiEuIvMJmPzMkkXskoWQdxP7xU/jajZPrOe5JdslnMt7Xw44ifLjX8dutc6YRRv29xDE3eCUY2Kkoa9PpQnzEFMvZI2mMYbxsbVPJgRQzNZ6paW/IMRLFWoFhtUxzv0VS277QYN9wU19FdJbx0NOunvMaUVQLkwdOM65xOPXeiaiD+G1qzaeDtx9tGWpmmkc6Y84YHrtJ2rrU4JEG4SBBTX3SiePpdJtqZCg6S1N5ApN0c0DJ4sqwBevBLN6EbowCCnZW34ATrNXyJtI+R5xBTT+eno24Cm0zOOmnW/HoRRF+6qn0P8L1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ac3dN0SrYQHicW1uwnooyVf76drp0NH7oiyp1U1Ww9w=;
 b=SGY62CCVGCcoIXqgGgt1qfU27T2pmEF9TriXLrVjtNL4T+Q2AB8DUY9I0PHiGviDvDVjfD1YE0ShMDoZmSRDhoWqQ4usf1DdqFHeBYElorQidCu5ad0iyh6rhrnEdKeANEShD3dWEST/kf16/cNYlTDmWLD8Rgm0QuXVezkfQ04HiB7dD0EdAnzN4QUw7xlpaLf2yquaPCD+kaLUw2eDOoGGHLlr84ycWYDosNvAYxN06VGQGRce4SbLMiGsS2sufzPoPj9PyOJzzuTOfrUVMkBUvDRJNaMc8Ol9H5FO+xkiEvI8OXiXyOguTtR87LWdFtcmw3KJ6ugBDdPxAbmAIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.33; Fri, 17 Mar 2023 09:23:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 09:23:30 +0000
Date:   Fri, 17 Mar 2023 16:58:52 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 27/27] drm/i915/gvt: Drop final dependencies on KVM
 internal details
Message-ID: <ZBQrzFlsjTWylzGf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-28-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-28-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:4:7c::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a029227-dfcc-4ee3-7fc5-08db26c94597
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGwugKGgH7s0X8EMPx+mex6V5B6HQ494G1y+VupVgypENk6niTYQLxIqj/beO+PQQDHQsuERINfD4clM0YjchHc5JrtCUFXxTXyiB7IlnChEGVtycY0YInhWUrskSaXJBMrWV28Ozw5vuXmdSYz10gB7B2QsKeuz9Q8EMtxkWWXrXFlDbj3tLk6crV2fPe03iEZh+pEvfUpBQ0qMrIrYQTCHN8R0rX9zI/QXPkAMov2zGPzKcxhYe7j9L21szBXmsAVY/v0iCmAzcMiUwRbXLx23RL9v29ugeWWshrhCKDCGCnQmiu2o3x9zSFogbJ+DZnzeAsUHL0c96oauwG9nwnbuN3mKJNauV5A2SWX/xIZdcPCADc9AwKdcg8QRww7g4UXG2cmYao67+EeQTik2o91CEzUgfazOnvjrVVLIoHHj08cBeJIXYEDixn/r9UuqvR2FKGO1sb220qJrcNjtWhb0CdgJarPSApi/msl39wss4UWVqfhvjnDQXtybJ/3TWZsBUuCjOzHhMey9sifhLoZ1cClcd66VYbdj8da+5yG7TmPsRXUAiCXTGjLRMkdHjr2LLcelvSUglfZqHPS1aOSF45JDISjGsgpKimyNK5N3Fwqc7Mn33uXpmhseZfVdseooqkI72tW3bk/28aayhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199018)(8936002)(5660300002)(41300700001)(83380400001)(38100700002)(82960400001)(86362001)(3450700001)(2906002)(6506007)(54906003)(316002)(6512007)(478600001)(6666004)(26005)(6486002)(186003)(66556008)(8676002)(66946007)(66476007)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E8RVpR+BC0o4hm0PWzhcJqpEzK4Pf/7e5C7dAOUXSMRVsFO3uLWy3hfFNS4Z?=
 =?us-ascii?Q?nv3PZG7OIJh/MCVoJ3kBnuO8EpeBwfWCD8AyzFxb8EA3Ctd7KSv3dkhSe8Iv?=
 =?us-ascii?Q?Wj847D529v5oLXZ3J2qKRYcHX+RtDC81L9wOZBZhoF3nB/3SS1KgZzZuBJC/?=
 =?us-ascii?Q?QXU5FMs59OWJRNNG9EH3TCOoknFEUHcvIwaBiwKip4HeAFXxqov1iY8svJJV?=
 =?us-ascii?Q?PIu8DLp8ewE0CMqJMEGAirKhMC62GWe7JOQqsTLv5kgPfScsw4OPZ5FN2Oq1?=
 =?us-ascii?Q?6gg3Oephlo8pgu5zmjfh3DeG1INd5/eGRNzYUsZcDO40alwR33hG2XFw/UVU?=
 =?us-ascii?Q?ulnL1vZfy2gs9HcBT46Im8lJ5FCvTbIZJrBfnxK4ybOhQZ440ChiNafGMyyy?=
 =?us-ascii?Q?9Bc9wdK1dhhcNYWNqPaagpwZzBdRTRCu7tSGLiVKwBtuRzLEWeUw6OwbSq9E?=
 =?us-ascii?Q?E9Yw/qrzCZMAC7QGTqSTv3sCZMsWzqaRhrkeunAJth6u9xEDNbpE5iXSmvTO?=
 =?us-ascii?Q?pP72UA/nIjI607oxMJOjqNXyq0y2/TA4oxZCGoBdsPAO8K1njpp6qG0QJft8?=
 =?us-ascii?Q?SzWp5YNm2/ozBCb6z4E/sy1Ox5hbQyQoasuOUEOpShJHtpipVmOHrrnN3CP2?=
 =?us-ascii?Q?6SGZ7jKhZmwCYaxeIpA7p4vU6NYxLGjU0LkrU7XvXnbYeATvGRKtOWJDaquk?=
 =?us-ascii?Q?29tWsqQUB5IQk5uljMyimCCtvc6NwxmmMLVDMObXNYsvpfUlMDnlfdWGupD0?=
 =?us-ascii?Q?7VI9IqwYlVP89a1EqBUl37i9+DmeURusm9G6BtsEygt3XzSJURFTyaKsBZza?=
 =?us-ascii?Q?NWt0A4t2/ILyRYJT9f3IziRLX2Y1p9WqD0ybAeDzFP8/f5VkEeG4gBEbnLnQ?=
 =?us-ascii?Q?FzDy3CU6+7v09Pb06ToY/rJ9ShmSpRXV10rkFE8A2Dy7aKD2mx2HMoGfMHeB?=
 =?us-ascii?Q?2cJzBgOsRkLxlX1zH/umNHsCBjmx76p7x+ThZl2nGQCGKDyMa1WDYxM2D+Y2?=
 =?us-ascii?Q?jzQ5SrQ9dhemSDZ2Pv/XfeQQq5ooTYzALLr4eHDuyehNbBOZ8I99yvO7rNQz?=
 =?us-ascii?Q?sTbxqGc4wKypzDdvKC25GrG6XwXGzjE3dZBp33tQBoRcpChwI9lhpzA7vsAc?=
 =?us-ascii?Q?CYlmDBCwHNXh6w4JoSzH4pX53XNMT76mKpm/bKOs3tKrZyqi4bFvpWVPHEOs?=
 =?us-ascii?Q?jRrt9vLxVA9AWt3ENKLRL8XBeFOMjHOZJvOZofvk0OCI4jat0PLdSW1MCHX2?=
 =?us-ascii?Q?k5cBC12TUPcJHiSa6Zx3eQpaUpHAH3VOqHCPs6Ef8GMUDDArcriZQB/0c+Zz?=
 =?us-ascii?Q?B1Mpxagd3xlksCwg+7PgY3O0StfqvtPhNsCMnxP0ZUq8LUiI1xM0c1unYhBW?=
 =?us-ascii?Q?2WA3TfV9q4k53OE6eCYOecXMqBvReBijUMwTY0RmbUtMMk/K1q61wgILvToI?=
 =?us-ascii?Q?obRdXQfHQ386wlT18iZcJKa3ApXcJpgL+5n8WINtxoYH6Z8HzFdXeOCsHE31?=
 =?us-ascii?Q?ZmoTFE3JaqN/Of547SBEe/o4uIOsb7v/JopBkmvfNuuV8sGMVKDI9RqdHonU?=
 =?us-ascii?Q?INS72eGKAcyjDYTyaRSTAdfnoIEU6E8+zen0cdCexjPJ99Ynolva3PN7r+q3?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a029227-dfcc-4ee3-7fc5-08db26c94597
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 09:23:30.2926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB1R4GiY69cPwyeh+j7quyirWoe6hnMslNKWbZkRiGV2FDByAoNO23UNsbVKpmL4YbykQUuREmM/SRe+IO9YBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:58PM -0800, Sean Christopherson wrote:
> Open code gpa_to_gfn() in kvmgt_page_track_write() and drop KVMGT's
> dependency on kvm_host.h, i.e. include only kvm_page_track.h.  KVMGT
> assumes "gfn == gpa >> PAGE_SHIFT" all over the place, including a few
> lines below in the same function with the same gpa, i.e. there's no
> reason to use KVM's helper for this one case.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gvt.h   | 3 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 2d65800d8e93..53a0a42a50db 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -34,10 +34,11 @@
>  #define _GVT_H_
>  
>  #include <uapi/linux/pci_regs.h>
> -#include <linux/kvm_host.h>
>  #include <linux/vfio.h>
>  #include <linux/mdev.h>
>  
> +#include <asm/kvm_page_track.h>
> +
>  #include "i915_drv.h"
>  #include "intel_gvt.h"
>  
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index d16aced134b4..798d04481f03 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1599,7 +1599,7 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>  
>  	mutex_lock(&info->vgpu_lock);
>  
> -	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
> +	if (kvmgt_gfn_is_write_protected(info, gpa >> PAGE_SHIFT))
>  		intel_vgpu_page_track_handler(info, gpa,
>  						     (void *)val, len);
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
