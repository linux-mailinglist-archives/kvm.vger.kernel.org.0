Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C3A76A6D6
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjHACOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjHACOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:14:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5233F1A3;
        Mon, 31 Jul 2023 19:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690856056; x=1722392056;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=yMcxLFu7PNwSx8/ofUVcH2/9PCBNG2Gh1yBP9lWdBpM=;
  b=R4Zu1jfATNidZZijXERATxxupz2BPE09HsGWRBbqVn+LHtl0FQc8sYbr
   Sljpq2yP6kM77WPieWhJdWn9IbnRgiueNcKmYFxhT/cEcV8j00TYFqbmU
   QEkvfjhMwngf1cLsCl+BmKrDXYYb/xGS3zn02QDobvfsbNecqR6I+651G
   t6AkOri4lge9D8HuyNUTeUNrCSFguNhbjNWdfFCNYTRE4IfvEPSpQoO5Q
   2cLILSRLoeAtBeYZbRrio9JFOYj+o4fhMb6Ek0tqo6KIkyekG91sux0Gz
   zsQ32R/FXu/UHblWX8llJbsogMHMx1tYzpOoUDf4JsKiuhMlvoJWLXaqX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="369174015"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="369174015"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 19:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722310779"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722310779"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2023 19:14:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 19:14:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 19:14:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 19:14:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8MxvdjNFWA0Jl54Yz17rzxgt8QZRB1xYST53t2Pt/3D+FPpWMq0fhP2phtkxKk+DVrByCTeRccVjq3j5HKPGGVCtFQFxGy0a48ZME90ubKTbVf/zC1BOQtfLQwd6pAh42fAhvnLrvBwXT9RLQWNqk9hFYcaMj8EFUSTzzOgF6ZfkJzJAxfYFoEhXuMR0baiC5SWVwdZAwmg8vigzAV/LuykxdtDXZ/GpS63JVlzTeH8Kny8kjQ5QCd9G765Ri3qDHfQJ2ErvpVo8i8HnMrsvIP/CDFSKVrexUC6Zt90WfhV55z54t8nCH2aUuMuUJrjWZCTGYLbFksOpUnZDsm3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buHPO2DLGH9V/oeyvsEPI0CTYnxFWhktFRNOxLxHbQ8=;
 b=GtJfWKlARIs6/xLEQUtf80ZDiyKL8CxSGABLTTRsOSQXuxqJ0xFc/9J1sHnvtJReFhWjAs2207y0kVJKJliV1cbkGzyyNB3aaBbKZ3kcbBam9lWAYTrBrR/y37bqyvkakr1fnrcCNakXh0IEFzwGvMHA/QJtGRtVX0cCmuNRrlkrCPEq0/RUMkPzVwgtMa4o00wnVDbv34/X5zieRRE02H+5fjadwub/O6ZF+9lJga9eVJsFf9uXxIPfALAS+KriP3CIZqA+9nrWYF+SwJGTYaR4WVsh5n3p4M74qL1qxejne6/FiQtPmdOUmYlbCNmq7n4tQW80wm/nqwnLsD87eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Tue, 1 Aug
 2023 02:14:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 02:14:09 +0000
Date:   Tue, 1 Aug 2023 09:47:17 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 03/29] drm/i915/gvt: Verify hugepages are contiguous
 in physical address space
Message-ID: <ZMhkJa2/9/aboPju@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230729013535.1070024-4-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0047.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: db333ebf-a3d2-470b-dd87-08db9234fd40
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nv0v1jtcMnmYdhjCJsZTtt+vHVaMhhcVpZbH6C8QXiLvPYwYYDN3NA2Elw+THMpGG4AN9c7d/rIACQVRhv3RqWwOulu65aN9iA5/Dcxu3Z80lUL/lXxTgR3OvVAimSh8lk5RC1+CAyqGp1ei00mRVmSnEP84kJ+rRI8qBjaSW6JZ9I0+LU6eopn0splfcGs/E0LbWMmiN1fu58XyaqhvPTuqaWLoEKhOBKFgLp5P0a8xIrjhwEdNPbkDtQEtSeG5RxF3vBjvQjNZJtuKWSZ8VHedf1+6QYRN44y2FjlaVqmlVoo/97C6HLi7ZfymFW26EiuiA7qby8iYvIU56uo+M+/huwDWGvK/4DTrKLqrYyXB0wHUsQ1qRCX6xh+SGSkyqaBIFi5CWO1K2gkIk7zbFHHTpXweBtnNbPGKXrMQwxSZe5OgfpVHKQa1qHeE1HtGf75IjDNcG6JMc56kdfZ8HbB2ouTxDmvqkkZd995M3JA445SP2rLiWTpPZhOC7De9eF5t33od5sF08nC7K7XEJmkz9HIN6z8ptOS3XXk0Fl9i8NcuvJgRpdHiVX9JcuiF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(6512007)(6486002)(6506007)(26005)(83380400001)(186003)(66946007)(66556008)(54906003)(82960400001)(15650500001)(41300700001)(38100700002)(86362001)(66476007)(316002)(5660300002)(6916009)(4326008)(8676002)(8936002)(2906002)(3450700001)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?23b/OrVYJ/Mins+wsQ7Wzwt9YJgGvGpdcVN6UJv7dsxAakt1sZbybBLJuLDj?=
 =?us-ascii?Q?BUHtI+60vb4+/HOdzsy9OGr7xrcV2S3gBME8lrPkVvMjmbMLnlcbxQCfmSjM?=
 =?us-ascii?Q?EzjO0pl4mNKSxlHE8Pi0jr9TEi7/H5UvH0Z2vgJSRzlQbQUManIGhR7YxoiV?=
 =?us-ascii?Q?EeHaQAgUuG2bySWm8iYLNfFQAtt9THgwNaVmptH0hOVLJYjM4h8qleE1k3Ai?=
 =?us-ascii?Q?R7cOiErxcpju1RdgOlKTtwYc/uAp0vRglZzkA6OfIJindDRMugr7+IIYkCHH?=
 =?us-ascii?Q?ZEi4rPVTWI7It8PMfGU8spWQep5Ukw5FKqArXOxKHLQSWc5LNIaHl1mT5ZO3?=
 =?us-ascii?Q?T/S7UmQjm8dJG3RYK6XEyvN5OwL1GpiU+vP8fQwgIbLyO7nvwhghg/7cwws9?=
 =?us-ascii?Q?xZwQhCWcfDKbdZb5KNRl9qOlWTsXDwYFigec0uwwo3bu2hdSxj7eT+vpUpUl?=
 =?us-ascii?Q?u3ykdc4UtOzKiLlEUud5blpvfWy/MUr2S6Y+KhNVK4imCwwJC+Lc1+jFUM9w?=
 =?us-ascii?Q?PpW2MrbLfcrd0nGcELtFIi5Gj/Uiz7gYw3keGdfL+UFiiMH8HJjOoQyO7ulw?=
 =?us-ascii?Q?wiJ8mOppuZHtEAIO+pSN90BkAJfu8uzxmylzDnklcIGRwA20mTxbYZ22NAul?=
 =?us-ascii?Q?pWKOM1koyGbRnZjaJKNVFm+4hfL2cmVdK5E5arpSQkwfXgK9Z18siRt1wA16?=
 =?us-ascii?Q?9teZzm6AT5vPunfC6GNMV5BMd19fok7kv6YCXeRoxKBAd/VAuJJwYHSlxURK?=
 =?us-ascii?Q?UBJ6KZTggf+34UES+PbWsbcc5LuDN3TWpKxMtFNVTb39wccGM/vmE6cfHMxM?=
 =?us-ascii?Q?YYEimhZypgpla85qSgjzTdfx1VJwAxRa9hypgVbSuQADEij9oG8/6ssHHPNh?=
 =?us-ascii?Q?kDmsVTzoB3AbLl3bltSbTAzNjqN51S/hzzFUh5/3i+yUWFWw+vBg+b0Y3QhF?=
 =?us-ascii?Q?EaRUKxLMDALEiJpFrPFHczV3b1zBM2rEthp3kmDyGaL2JfxpKt2mBTtE8El/?=
 =?us-ascii?Q?oRKuCNraJbxk7le/bPLxtXWoqudz8Bu25aXQzTab0U67ZkdXU4wSZMSxLO1P?=
 =?us-ascii?Q?KX5n7U7WhUMZdTeBQ11BjjxmTj8d4edYFVqEKJY3rQDZ3xjV7aGMRFf6ukvy?=
 =?us-ascii?Q?RcfBcjhwQwqGz6Kx/P1fkluDEH1m68Szw8K34YvMZIuDm7n1yBHEN5UTcGD3?=
 =?us-ascii?Q?f0a+jHpSqNDLtfP1KpQtu03lMJEoXncRV5cz10jHNDC1Agsyo/CdKt77YxRd?=
 =?us-ascii?Q?7gxQdTpVFozhZZ5/McKJn/FmwNnaRden4HFc6Xf2Yh5BAFJG0Bp1v19XTTGm?=
 =?us-ascii?Q?+HkW68IRhosJ2q4CbY0kqtGIC4Twc58hThfzJ+CadGhl641qpVdtk8oghPix?=
 =?us-ascii?Q?6xiwxF/yvBtIUhN7oKEVuyS8lzy+T93aYrL84iUHcwH4WUcBd1d8It8quX27?=
 =?us-ascii?Q?qfOKdvicRoRTHgRaTdj0KYHtSY4irNbf+RUqJ54Q113SnrqT5EhKgdFWLgY3?=
 =?us-ascii?Q?SNCIvRVQBm28bGisQ725DhjOIuALiBB6W0n3rWmOJ1hkMj4fq+1YKhXcDLo0?=
 =?us-ascii?Q?tCOnnitwJ6rvspiywGSzO5UNIeMdMakDY0wJ6xdY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db333ebf-a3d2-470b-dd87-08db9234fd40
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 02:14:09.1287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4H9Iwdh+QmSGjKzpwvT7xVBTVrFEDZ5qvNwn88XUbuEY3iRJV8QtbRfcuTVu3Z08Kul2ndw/MEXfZZdzr4gVPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Jul 28, 2023 at 06:35:09PM -0700, Sean Christopherson wrote:
> When shadowing a GTT entry with a 2M page, verify that the pfns are
> contiguous, not just that the struct page pointers are contiguous.  The
> memory map is virtual contiguous if "CONFIG_FLATMEM=y ||
> CONFIG_SPARSEMEM_VMEMMAP=y", but not for "CONFIG_SPARSEMEM=y &&
> CONFIG_SPARSEMEM_VMEMMAP=n", so theoretically KVMGT could encounter struct
> pages that are virtually contiguous, but not physically contiguous.
> 
> In practice, this flaw is likely a non-issue as it would cause functional
> problems iff a section isn't 2M aligned _and_ is directly adjacent to
> another section with discontiguous pfns.
> 
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index de675d799c7d..429f0f993a13 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -161,7 +161,7 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>  
>  		if (npage == 0)
>  			base_page = cur_page;
> -		else if (base_page + npage != cur_page) {
> +		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
>  			gvt_vgpu_err("The pages are not continuous\n");
>  			ret = -EINVAL;
>  			npage++;
> -- 
> 2.41.0.487.g6d72f3e995-goog
> 
