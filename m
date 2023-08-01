Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C78076B351
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjHALc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbjHALc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:32:56 -0400
Received: from mgamail.intel.com (unknown [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E18E1;
        Tue,  1 Aug 2023 04:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889574; x=1722425574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TzSEaSzQL9u9ekleAO7fPDY/vHwfdTwqjFeCTI054Hk=;
  b=nfJFoT56ZjmElmW2VQhOvKxg/7Q8OpiHs0wHVGnUXz8IUna+0suuKsOm
   /Zerrny7+to6hek1TVXK9n/5+Pb9HGIQICH8jvcJFJCwGu9CfsXPVbgR4
   H4CrU/cpZvZ5EWlSnF9lhkBBfOOQ1x5Hj8VUs1N1AwrpQW5QY+UTgl2BM
   t2d8m6Rp4zsvsF2juEvpjmOAAgRSukqe8hnVGsTso2+EW0+aQHhwwIsHv
   940rBFdQGp+e3qx1sX+QS6tfeHFr7vIvx++r60WYm0122ncz0mzbTSlGl
   OiMvt18yYwSOC3nbn7YXzxYnxdbstPLG3oniiUmEQ7ABUNRdd0qvRQpvn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="349568105"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="349568105"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:32:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722454740"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722454740"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2023 04:32:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:32:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:32:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:32:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoNdTLLy7oaAstY0bm0jSeXyWEfeNQJQIvtUpkzQmpq9wbWWYX3IZh1cuCyQuwBamfZQHVY1ZElZz39/c8r4A2wAOlWDKpqhOxjq86biG/fEdec+c/soP8DJ0cbw2406WPulzlU/noLak7hJRKGyUgp27Ol7CX9Z0V9zpWXLfIil6shuaCKD4ICp1Mh6Qbofy2KP+1CB5hM/7yUpDIZQ2cVIxRAvjPV7jcy+wZrewS88nSfP/hzo/aITXmymEA/ExbihTnVwRzM68Q7iNEAs3P5mOrVVd5Tt2LstvMRxLZgg/XPUNYajETAzUQRQ9YKKbnpdiuarETW5eGO/EPAj7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UUIGBYy/1i8L7tcMofNc7ZXSDAHLocj60UHSrbIYsc=;
 b=F7EIjeI/6Wqp11ZGZvtT8pUGp+noM1Iqp/nKGIs5SB9lp6AtLkOVAMX3eUpyRUbXvjUgQBI+CGLG+9wlHNk+GAihQdivr3jz82JPjcWmouO6XGISNLmTL85Q1Jcs3x+ch74rmnX88asZA7p/aelC03GCWixjXFsw3QLyBiNu+m6zHEpVBeucg2PMHVqsQOObFCF9v3FeXCLB6VnVvpQPcP+Iz5fmlmfYxBy1rzeR/giUtW89H4plLJVl6khIzMvTyniA15gIJEJ6YQy51aUQYknuM2X6772WRh1vHYWsb7oPhcfjkjcK9ZrFntOs713GVdJguPxuBm8TeD7LppfQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Tue, 1 Aug 2023 11:32:43 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:32:43 +0000
Message-ID: <8c7af6c1-903f-6c4c-67d5-3765315f05b4@intel.com>
Date:   Tue, 1 Aug 2023 14:32:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 11/29] drm/i915/gvt: Protect gfn hash table with
 vgpu_lock
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-12-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::10) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: b97d1065-6d8b-4104-25d4-08db92830543
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iksA+hMH1CZfOk7HYl5VWYQ8Tkm+p8AxZ+Q+5GJwEPCpVPI9wAC7pSO/+VfZx+RaLHOdbha4qavaWuY+bRonZGqaJsiCPSthV6XdL1PBjMLAUy1EiDsHS6WgEPUcttU4Ea0wloF2Yfz9ZmR6B09uBKkkj/AV5GzXIYiNyFbt8crIFPvG+w05+JaZskh4psofm0A3CPWwFtwvJyh4HxoEkzp0pLlcXwj8uJbYYJr67o+2hoP/UVXGJkV8Trr+PxRnsLx/nAhnk1Vk/5yCbcyk8HdrDQuHgoqYUrdjSod2PgDOH7zfE1Ldpw/+H/Y+CAuX77UiU+RlnJm+iYIVVhFD7XZrFtViX0xeNYLAnOCs9nQtQLkgR8pKRADxcBT+YMi0k3OXouyitk/OKlDIKqrBXrOmbEJG582X8Y6x4RgAWb0Jqjl256gmZHUAoSQzGxsENt7JjsZt8ILfNHuKPVPiI/2GBqr8DxD8BQHMR85Pt7VAViRTi22BBPAkA+yBG4M6hNGMsGvpjR9ABjpTvJC8oWqKTiY8ukKtf2q7tWV5/HFxSu7a52tm8mSg1kWSQcNJymW45kbu9ZcF73KhcGD11UqZ1YDUMCji49nfH7P6GVesh8sXcB6+GDUqAjWDbakhz75HEv1kax+1aR0d9xVATw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(38100700002)(82960400001)(31696002)(86362001)(36756003)(6512007)(478600001)(6666004)(6486002)(2616005)(186003)(26005)(53546011)(8676002)(8936002)(6506007)(5660300002)(66946007)(66556008)(66476007)(110136005)(31686004)(54906003)(4326008)(316002)(41300700001)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjgwV3YxKy91NnhheXZUZHQrSU9GdTlBaFdiNnFjYmVUUnJHZXN2N2ZSWTdr?=
 =?utf-8?B?QnB3dWZ5MXYyWHcvTmh4Y2FHN2tXSFludDZQQUxjcVVkZytEdHZxZ3hWbjVP?=
 =?utf-8?B?ZnhZSkZ6RVNSajVBYVVmYkxwOHlwelRFdU5vNTJYK2M0d3ZMZXlWUFZMUlNw?=
 =?utf-8?B?VHdVSDlPVXA3K1k4Zi9QL0wyVFB6TFhRQUQwSjlMZGgyRDJFazNDK3FzK2xn?=
 =?utf-8?B?MVh1cXhYSk04L09qZWZDRVd5OTBxbVE3N2NMMCtNYThQVlR2aElCRUxtZ1J3?=
 =?utf-8?B?M1h3aU5sVkVlREdsL1E0cHE1UDFiemhSeUYxN2JuTTl4TTV5MzNtQUs2aXp5?=
 =?utf-8?B?bXkxVVNoMHBHZHdlNnpSR3V2dGZzb3pJUmJ1d3diaUh6MnlFSVNubHRXMUhp?=
 =?utf-8?B?NUdwKzQwME9zblhReVQxVFFDbklvV3VBSlhLemR0MTk5OFBHMXZvaE5pcDdM?=
 =?utf-8?B?OUlERllPb0E0SGxxWExtaHNIZlBiOHZQUmV3Q1JUOVVVNlRGVFo5eDRkT2JQ?=
 =?utf-8?B?R0E5Y2crbG9MNVBORC82OXFxTGtOOWRqVUk1N2JJZ09sVFZFdlkvWTJWd3F0?=
 =?utf-8?B?S0pjMVQ4Y251ejBOSnhpYXNLOElQbXF3dVVFT2RmeGc0MEFXOFkwVDdJcWNR?=
 =?utf-8?B?UkxaTVF1ejZYR1kzUlN3QmJ1RXY2WFNtbE5UNTFvWS9iVE9TYVZpS1JVb3pv?=
 =?utf-8?B?NE1RbWJkd1Q4bGYxbUFTclpzQ2taeHpqa2pLTmFVUTNnZ1VDSS9vYlc2V2VE?=
 =?utf-8?B?VWNFTE9iM0oxZGZRNVc3TGVmcExtdldxTUp0emVYRTlYZFNIL3g1VVpReGpp?=
 =?utf-8?B?LzlvYzlCUnd6U3FuN0hsQjY0b3FiODZzSkJOeGEwZkhjc1JTcVhUazRUZ3I0?=
 =?utf-8?B?WGxvUVRPOXp3b2M4NzVDcHk1UVQ3aytpWFhicVY4MlMvVzRqdDVkaHJ0UE41?=
 =?utf-8?B?UWQzaHh3bm5Fa2NpUUdRMkEwZ3Q5VXlmU0RaclAxSzRVUmp5eEZXcVFrdTR6?=
 =?utf-8?B?ZzBSTFM4SEFVZkorc2pGeG8xQU5LZHFGRGxGMGFPYjlYODNPbkdBSlU0eU1m?=
 =?utf-8?B?aGQwY1NuZndEUzNQVjRrWVJsMUpPNVNrcFBCUjBiZk00V3Z6cGpRZFRVdDhh?=
 =?utf-8?B?WHgvNUlzQ3MyeExEQnVwVGlEbHBGVnFJRVZSWnBBa1RWR0VwYmx6OUNEWDFH?=
 =?utf-8?B?T0pJd0JmUTNROXYxQkw1UFpJZ1dpd3dHZU9vczBWalE5cTVZK0dhWnJlaU40?=
 =?utf-8?B?bXdiYXlWVFlORFk5bzFXUjljNXlJUGY0akV5cEU3cWV4TVpGcHEyRWhjcTVq?=
 =?utf-8?B?RmwvUFR3bUIvTUZiaVR2eW1FQlRUL01VNkRpQnpSVElBVEl0Z29ZbzRrcXdi?=
 =?utf-8?B?SXZLbm9SZzF3WlVrVFc4VzkvOFNybmZMWlI2eDl5WnZDQ21aOHd2VWlUcHJG?=
 =?utf-8?B?U3Ayay9RY3BzRVRlQUFhbUZMNjN6bnRQZUxRTDc4cVpYVzgwb1c0T0pUQnRs?=
 =?utf-8?B?VHEwM1A4VlE4emRpalFvK2V0aDVlMFUwNHg2RzRUMkVIYzNxa08yaU9xRW9t?=
 =?utf-8?B?Zzl5Y0tTQjZTQkR3M2w2YkFZU09TcVp4aitMVitiWUxWMjhzN0ZVN1BJTXMr?=
 =?utf-8?B?MlFHQkllOXJRTHA2UGZQYy8zT215WDVDTFlPT0dYTVhubE55eUJKUHF6dFov?=
 =?utf-8?B?T3lXVFFmUzZMcnhZY2NKaEV0enEvdlJ6cTg4K3VzcG02azZXV2V6encwNnM1?=
 =?utf-8?B?SWNoQ2YvOVl1MmphMDZWdEJHbTNjVlpXWTVjM2tWNU5yMUpmMmcvdll0WG01?=
 =?utf-8?B?eEZ5cDk0SHFObTBkeUw3dFlrUEFINVNFbGJpaVNCazJGeXpiVG15VWlZT3Fn?=
 =?utf-8?B?MmFPZFR3OVpJcStxU1hwRExNSWo4UlNpZTBwV2p2VnpVeGozcEdZbzZwei9r?=
 =?utf-8?B?N2NqcVpwcDJjSGY2ZDFmSDNjRlEzTE5vcUUzT09PNGU5eGdXVmUvaitxbVZL?=
 =?utf-8?B?c3h2eUs5bjJHMEFvTk1IRFpzSWtYbXJKNTk0N2hhdE8xVDA4enY0UHJQckRl?=
 =?utf-8?B?WW5IcG1FMUl3MGtsWDVGSTg1MVZwRmpONzFwYlZOblA1bld4d2ZGL00wU1VV?=
 =?utf-8?Q?5uZwNrpwo0L1df+AJodZZFrfv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b97d1065-6d8b-4104-25d4-08db92830543
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:32:43.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xAtVU2o3fuyvqmLAQ3Nd/VWXNpYEv0Gzm68RU2YkFBvX3mX3psRzxcHNqSBEbKWdnGIS6jPJfFYYVHKlhlfpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Use vgpu_lock instead of KVM's mmu_lock to protect accesses to the hash
> table used to track which gfns are write-protected when shadowing the
> guest's GTT, and hoist the acquisition of vgpu_lock from
> intel_vgpu_page_track_handler() out to its sole caller,
> kvmgt_page_track_write().
> 
> This fixes a bug where kvmgt_page_track_write(), which doesn't hold
> kvm->mmu_lock, could race with intel_gvt_page_track_remove() and trigger
> a use-after-free.
> 
> Fixing kvmgt_page_track_write() by taking kvm->mmu_lock is not an option
> as mmu_lock is a r/w spinlock, and intel_vgpu_page_track_handler() might
> sleep when acquiring vgpu->cache_lock deep down the callstack:
> 
>    intel_vgpu_page_track_handler()
>    |
>    |->  page_track->handler / ppgtt_write_protection_handler()
>         |
>         |-> ppgtt_handle_guest_write_page_table_bytes()
>             |
>             |->  ppgtt_handle_guest_write_page_table()
>                  |
>                  |-> ppgtt_handle_guest_entry_removal()
>                      |
>                      |-> ppgtt_invalidate_pte()
>                          |
>                          |-> intel_gvt_dma_unmap_guest_page()
>                              |
>                              |-> mutex_lock(&vgpu->cache_lock);
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c      | 55 +++++++++++++++------------
>   drivers/gpu/drm/i915/gvt/page_track.c | 10 +----
>   2 files changed, 33 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 6f52886c4051..034be0655daa 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -352,6 +352,8 @@ __kvmgt_protect_table_find(struct intel_vgpu *info, gfn_t gfn)
>   {
>   	struct kvmgt_pgfn *p, *res = NULL;
>   
> +	lockdep_assert_held(&info->vgpu_lock);
> +
>   	hash_for_each_possible(info->ptable, p, hnode, gfn) {
>   		if (gfn == p->gfn) {
>   			res = p;
> @@ -1553,6 +1555,9 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>   	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
>   		return -ESRCH;
>   
> +	if (kvmgt_gfn_is_write_protected(info, gfn))
> +		return 0;
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   	slot = gfn_to_memslot(kvm, gfn);
>   	if (!slot) {
> @@ -1561,16 +1566,12 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>   	}
>   
>   	write_lock(&kvm->mmu_lock);
> -
> -	if (kvmgt_gfn_is_write_protected(info, gfn))
> -		goto out;
> -
>   	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
>   	kvmgt_protect_table_add(info, gfn);
> -
> -out:
> -	write_unlock(&kvm->mmu_lock);
> -	srcu_read_unlock(&kvm->srcu, idx);
>   	return 0;
>   }
>   
> @@ -1583,24 +1584,22 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>   	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
>   		return -ESRCH;
>   
> -	idx = srcu_read_lock(&kvm->srcu);
> -	slot = gfn_to_memslot(kvm, gfn);
> -	if (!slot) {
> -		srcu_read_unlock(&kvm->srcu, idx);
> -		return -EINVAL;
> -	}
> -
> -	write_lock(&kvm->mmu_lock);
> -
>   	if (!kvmgt_gfn_is_write_protected(info, gfn))
> -		goto out;
> +		return 0;
>   
> +	idx = srcu_read_lock(&kvm->srcu);
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		return -EINVAL;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
>   	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
> +	write_unlock(&kvm->mmu_lock);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
>   	kvmgt_protect_table_del(info, gfn);
> -
> -out:
> -	write_unlock(&kvm->mmu_lock);
> -	srcu_read_unlock(&kvm->srcu, idx);
>   	return 0;
>   }
>   
> @@ -1611,9 +1610,13 @@ static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	struct intel_vgpu *info =
>   		container_of(node, struct intel_vgpu, track_node);
>   
> +	mutex_lock(&info->vgpu_lock);
> +
>   	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
>   		intel_vgpu_page_track_handler(info, gpa,
>   						     (void *)val, len);
> +
> +	mutex_unlock(&info->vgpu_lock);
>   }
>   
>   static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> @@ -1625,16 +1628,20 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>   	struct intel_vgpu *info =
>   		container_of(node, struct intel_vgpu, track_node);
>   
> -	write_lock(&kvm->mmu_lock);
> +	mutex_lock(&info->vgpu_lock);
> +
>   	for (i = 0; i < slot->npages; i++) {
>   		gfn = slot->base_gfn + i;
>   		if (kvmgt_gfn_is_write_protected(info, gfn)) {
> +			write_lock(&kvm->mmu_lock);
>   			kvm_slot_page_track_remove_page(kvm, slot, gfn,
>   						KVM_PAGE_TRACK_WRITE);
> +			write_unlock(&kvm->mmu_lock);
> +
>   			kvmgt_protect_table_del(info, gfn);
>   		}
>   	}
> -	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&info->vgpu_lock);
>   }
>   
>   void intel_vgpu_detach_regions(struct intel_vgpu *vgpu)
> diff --git a/drivers/gpu/drm/i915/gvt/page_track.c b/drivers/gpu/drm/i915/gvt/page_track.c
> index df34e73cba41..60a65435556d 100644
> --- a/drivers/gpu/drm/i915/gvt/page_track.c
> +++ b/drivers/gpu/drm/i915/gvt/page_track.c
> @@ -162,13 +162,9 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
>   	struct intel_vgpu_page_track *page_track;
>   	int ret = 0;
>   
> -	mutex_lock(&vgpu->vgpu_lock);
> -
>   	page_track = intel_vgpu_find_page_track(vgpu, gpa >> PAGE_SHIFT);
> -	if (!page_track) {
> -		ret = -ENXIO;
> -		goto out;
> -	}
> +	if (!page_track)
> +		return -ENXIO;
>   
>   	if (unlikely(vgpu->failsafe)) {
>   		/* Remove write protection to prevent furture traps. */
> @@ -179,7 +175,5 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
>   			gvt_err("guest page write error, gpa %llx\n", gpa);
>   	}
>   
> -out:
> -	mutex_unlock(&vgpu->vgpu_lock);
>   	return ret;
>   }
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
