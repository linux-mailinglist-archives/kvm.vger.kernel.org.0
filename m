Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C15E5B0B02
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiIGRFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIGRFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:05:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B5D3D59A;
        Wed,  7 Sep 2022 10:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662570311; x=1694106311;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qM0bqqkBVtqiL3Ey0dI2fK4VZedie4/Shtzj82aH2uA=;
  b=PhW70yRVJfYz2bEhtD7amIagiLyzP00diFrKH0sI72zvfxa+wmo5G15Q
   FxP4H2eKOgFvg7eu1XDmG5tG9Da91BsmNpxWXft4uWGQtT7p36xaUq9Q6
   FchuWc0ZCguYOyIlvekQWHAvFhncZVOAjsFrTPssAqjE0Ze6lge0hZM7C
   RZc+LbYuI4jMwkUe7BQH7jDh/gqb1MVSArlFZDSs1xcgnUe5ynsbic31L
   /rB0WiTLG8OFig+wvx/Fg7mg6hPqYt7IUmWrd0couVuXm19CKqDdhnaQM
   3bJANMN3WqNxjSj+dRmCrz3bclrjHIcHkAIkmk5WW8QNGRaSWdsNmrYpM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="358674445"
X-IronPort-AV: E=Sophos;i="5.93,297,1654585200"; 
   d="scan'208";a="358674445"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 10:03:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,297,1654585200"; 
   d="scan'208";a="676287164"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Sep 2022 10:03:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 10:03:43 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 10:03:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 7 Sep 2022 10:03:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 7 Sep 2022 10:03:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nS52ibliqWUlJcbojHc2qTkAbEn9Ne+gp9x6Ba+3QCR3nBS+W5IjZxLYqt10L+Avv+Z+N9HgX7GNw2hQH4YlKaiN1I9l7zJ8FBykTjWtzeiZTiYt9p+pfYArpsM1YZp9bBGDkKC045lvLRdImNQjXZ5+IW1o42i7lJdflJxMQzbET2T0B63rGMSjuuy/iqR16JcC+RUrrO7qAGc4p/ew91t0sxdAH+AdGgeW3nkYVbOtVzoEZY8JBDeLv8nYTwR/WAklY/lejfXDl9cOMnc+bj4yf4agdkhzYpbJOhZxawVS0a4IW0AIKczvJi6+2qZHY22U77CR2bNc9EHwdL+Fmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8pwDjctojOEQ0XJD/jHZ+5QCHC3pt99R3meT9NE+7g=;
 b=DJGum6nFZoMvFXCklxB64erLKUazw5ICpDqxPjgRCEtNTdL1D0v+QrvfRjMjg9E2cV4PhPpotSVy8O8DeX/8RzE/XsYyFgnYRwdSvcxZIBXNx9GO27mAfEnCntmGu/P4n0QNzVmZD8Pxxeyx76OevvxyMRv9+ryLc7bXWeGgv2RT/4C3eoMYLZ2vbdO8jR+tWuVjLHEkVh4W4e0Rp4ya1u9By+AqKbMUZBAiEqc4r3LCFggx+jfu6T7ovqJQQfnO9YVLTDwBXxumN+kn3Yy7pjlRQvD0eApD53F1Gw5vJgpHpLxoeZDVlFfB23hgdaJud5adwp1fOyM8x3X9DerpgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW3PR11MB4761.namprd11.prod.outlook.com
 (2603:10b6:303:53::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Wed, 7 Sep
 2022 17:03:41 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5588.017; Wed, 7 Sep 2022
 17:03:41 +0000
Date:   Wed, 7 Sep 2022 10:03:38 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <6318ceeaae7ec_166f294b7@dwillia2-xfh.jf.intel.com.notmuch>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org>
 <YxiPh4u/92chN02C@nvidia.com>
 <Yxiq5sjf/qA7xS8A@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yxiq5sjf/qA7xS8A@infradead.org>
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 238670ed-c4c2-4d1a-a42c-08da90f2ea3f
X-MS-TrafficTypeDiagnostic: MW3PR11MB4761:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StIDhDr0We4IpY1tB6H/98GvPYibhs5KIJnmkr49JQwZFZjd0gLfZpW6/oGYsk5E6IIJ2HK3CWaGjSVxXyQWZjxFu2UmSwLkCx7nR2Q8tBkLS179rgvAuuMRABhsZwwIEd12dljSn8LOUcXKmGf9m2rJmnXssWHxiL7w4GXNcDYnWYWOC1nDldl6w2RC4N8ZboKF6Y6J8NHLmMnuoCtdb43VoLxzzsJLCgK2mnrIePlo6enNl52JuHWfDyxFKlZyTN8MGi4qPOReZVR7BDqdJwpkQvojYnEFTti+8XTHGXR260NrHMPfZ3VtIaqrh1apYMNaCjYcSh8LmIwJZPDrV10CckbNPcL47NuZDt3+fI4K2ME6JYOYGO5hrMZ8kPOa34gGSId/o/sQnuWf2PAGDlwV4B7CazqkAb5wYSoKcpv5jK5r08sJ8tlOwNHRfOzO0btPjH1aW4QDlGfte64B/nb6AqdVCWnaPk39K+aO/ArhZINE0iRFGyO8XblPVkc+Nat3d7PEywL7jXbRfkK5zxBgD7+GkQHCrnKrickCQFAUVMpNb926yA1LHtLBPHYjS68BEr2smTjRI4NjkWQgOSAPLXDxH/ns72zv7qjZ4hH3RUU5yL9L3xVZqLDjQ+Y1Lx64JZdKPsg1+3qkrsg0x6Rdhi3laIxNTj2rd9ii6V1LXCgcTZcJDUhZaamnegcYnycK27LgvbvscX2Wb3U5uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(376002)(39860400002)(366004)(110136005)(9686003)(86362001)(54906003)(316002)(2906002)(38100700002)(82960400001)(66556008)(8936002)(5660300002)(8676002)(4326008)(66476007)(83380400001)(66946007)(6512007)(41300700001)(6486002)(6666004)(186003)(7416002)(6506007)(107886003)(26005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?exabrjhtmMgan4IHbCIIJ8p1LXfypjw0jedLyZ+SMG/wlw5D63ODYlpA7+Qc?=
 =?us-ascii?Q?yMh5JMN3J4uWK2uvbZ+FeJ820W6CFAVm/6OQqa4Lkd7CIDa2HgcSdxM8PL0H?=
 =?us-ascii?Q?jf12VxmEoNYJThVkxnghD3t52eLk5dB8b++2oVEM169mTunivCmt5+a7OVRt?=
 =?us-ascii?Q?DXi+FhO8Jcfypob0CVnJgMh4NIBPdV/1y0tFx7/3oIm+GgdkwDE424n1qfzp?=
 =?us-ascii?Q?AZhLcxI7R/Uyk0LFxmclkEFBnPtDeXAX1V6wiFpFXLVX9bFJNOW91+tA7NxE?=
 =?us-ascii?Q?+EaemRq0dHjbEoTdyCRMpbkuRv9cKFOT7MlzVPhQGRxQQI1leh7hvxQpD5hl?=
 =?us-ascii?Q?q/axDkH8wTXojXaRSGPNzJcHU1gfQZs0NIKebbWsQEolIIcvBcXFHEq7DGPZ?=
 =?us-ascii?Q?1LA7aRDUUmKlRbQgTwQILpwod6mqAK47SgaqA518B7UlKEWHk38wLV+l7d1t?=
 =?us-ascii?Q?EYXI6fuAOoJy+0lLeKhfJutxWZkBtIU1IdWwC5mGkSbNsaOmHSq+mC8sEBDq?=
 =?us-ascii?Q?n0Qx4h4Ea8MBROXC+Au+2olaKpq4VOxjojY5tt8r3LFdGrU+NeyBroojZVYj?=
 =?us-ascii?Q?of2s7mqC0twPCbfJ3gYPStU33vdxBXqJuosXvt3HZQZJEkuO96uafyLUblgP?=
 =?us-ascii?Q?Y6cPH/FV7NA3ILWquGWQb889DE1lcLgnKEQFhPGWTT0UD+DGPrQVSy8uytMs?=
 =?us-ascii?Q?DfdGrmnZy0Uj/Pv25kj4t8GY1zdkkB4HQIzMjdC3qmhOJHTRZIALRwofnsg1?=
 =?us-ascii?Q?Efo5FEc4jXUUbKPXv/IILxYsapi69XSPDgs7w8q6BEuwf+wB4Czzo3TVGxAI?=
 =?us-ascii?Q?U4MVbNLa+a9rXP44iqvtPA9UJEom8m7r6c7l2CGWvB+FU4u+yEf7m2D/STSk?=
 =?us-ascii?Q?X4hd9NHBfer3L/oWPTJqFJK4RBaM7BGB8zInn6b6LwlxDsSi9rVKlS/4xOrz?=
 =?us-ascii?Q?j6134SHU46FeaknzChGb3BGvIKQdQAbL8QEnzxzQzMxcc0s0pOQei6Vrv5WK?=
 =?us-ascii?Q?yFmECfNqa2oC05nBSP48DxO0SOasyZF/aheygJjODlZVX5OckgtKxrhBxTWz?=
 =?us-ascii?Q?mW9HaqNFBGn7RfDAlABzC/cgQBOQFKvZlZcDJVxIq/Xaws1jq5bIc/VB5txp?=
 =?us-ascii?Q?oPrAHVy8tPeFyeXCk5qrNf9oUJ4eBJ+ceCkN8vM/BFsbe5n0yh9yQDFNC7WU?=
 =?us-ascii?Q?p5wjhfpnOb2ZFWx3TC2g6gSEb1WxcxCmNi36Jzun5mqpvNSm3W2X69cmvdOU?=
 =?us-ascii?Q?nmUDsZFf47U+bmfK1s7PgxuMN1eLsXc/7o0SHEkhYskazP+in9qu7PiBxIwD?=
 =?us-ascii?Q?96NvFfvqZoMZyr8KUKZE3IT7ODzoP634uYw/4nKjB8u87gQy26reqviAGgf1?=
 =?us-ascii?Q?GHOqTCoxVau2g3qt+LFG3eTX1D8Z9O4qMBIsLp8uaMfyeCHFLJmNDdtq4xqZ?=
 =?us-ascii?Q?+56Wwx/86dmPF9VxlDqWLgn2c534gjFl9nrw1ui38O0phgG6jrPz1lYYALia?=
 =?us-ascii?Q?V+tOn3CIV/jZl/Z4Pw0lp8s1rXO03VC+qK4+zvkSHwsfFjfn43JK/tSor2LT?=
 =?us-ascii?Q?pggMDzmgmyQqe69JYD1l2C9Wv72HUa6WjuIc7Yig4X4FZlBTS6QDig4gaNMM?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 238670ed-c4c2-4d1a-a42c-08da90f2ea3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 17:03:41.4121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Y2UavbO+gpYfAMQO8WLKN9D0ZxsQf7b3pqxNt5ip/N6u8PsuT9avsEVOHBX2fCIgBN1MO8Yp9+lJ//5Wfw3xtAbdJUnhUnsp7XtZrMyKQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Sep 07, 2022 at 09:33:11AM -0300, Jason Gunthorpe wrote:
> > Yes, you said that, and I said that when the AMD driver first merged
> > it - but it went in anyhow and now people are using it in a bunch of
> > places.
> 
> drm folks made up their own weird rules, if they internally stick
> to it they have to listen to it given that they ignore review comments,
> but it violates the scatterlist API and has not business anywhere
> else in the kernel.  And yes, there probably is a reason or two why
> the drm code is unusually error prone.
> 
> > > Why would small BARs be problematic for the pages?  The pages are more
> > > a problem for gigantic BARs do the memory overhead.
> > 
> > How do I get a struct page * for a 4k BAR in vfio?
> 
> I guess we have different definitions of small then :)
> 
> But unless my understanding of the code is out out of data,
> memremap_pages just requires the (virtual) start address to be 2MB
> aligned, not the size.  Adding Dan for comments.

The minimum granularity for sparse_add_section() that memremap_pages
uses internally is 2MB, so start and end need to be 2MB aligned. Details
here:

ba72b4c8cf60 mm/sparsemem: support sub-section hotplug
