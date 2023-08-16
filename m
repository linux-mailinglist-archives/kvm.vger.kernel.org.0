Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68B877DD58
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbjHPJdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243373AbjHPJdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:33:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E24D26A4;
        Wed, 16 Aug 2023 02:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692178429; x=1723714429;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=bad9D/VNLuDF9rj1Ow3B3ElZXq2J7r9Rsj64XapPZpQ=;
  b=RFTb5Px1pcht+B04Eo4nyhb5PiCf1pd6b9/EUjKgfJy6RShYZRJV/kek
   rP+odhw2dWOuYPglaOtE8RK65HW7hAj+ie8KPuQ+61L5VhjP0SdsQtUVX
   mPhMA+U2vP/eEXF//oZ66DZ3mkAc+WCG6R4WJ2/HHHTep3tYXBcNifzNH
   CBmHrZpmYCmZ1IQaunaCiHHnSip1CnMuMYC7E+YJhsWaEf3ykGhpwQ9UU
   D4Y66j3bqWLnC5iliQ+BQ78zaOFxV+3DdSfAEz/wC+S5/45f2KWrlP67s
   k0EuXFSQjc1XzEraA9LKfOK4vWc0nVhVgjyHmbAQ9qHv1mBPEelaXibsg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375257565"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="375257565"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 02:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="877720360"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2023 02:33:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 02:33:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 02:33:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 02:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvMkuCxI4WlJxzXvwQM+HJkZ/7mxUajWdwQScQD+sa5HtxY+m5K7AoQl2Aew9P5P8qH8XBKN9kc5jMb+/MjqQqWCFo8B4D4L3BiIFXUvWpej6IiDaE/57bWIolknhh85CxWHemCC1UvHMQnxxaMZrPL8PziVqyEPdiuzGH7CW6Wfe8kuS5AngkOlC+4IRNJ//UFotlO+arFd9jQDYyXeflUCcY/2xl8Ki5BK6PRgZXK30Qn7bP+i0TH+PZNvZhsE2OY3N3ntxHAhXf7n405/itdNGA1U6/ehMn0EV/atnf+/4UXDs19OmvNhcjBvwgdBQc0nlZ2YSVW8rxxu9feH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqdWU9oLlc0oy/l1sU0cL+Jg0fY30Lbtl1Xtmzhv1fE=;
 b=dcMsB689t9AMlgSn+H2Daand6D5MP+vmnfyS7YFy9Yvp2gF/p9AALTFsf6dIZkNkjY6hsh/L2kggTamzEVns2WQTMUSjrpzLQdCM333MFrAz6QrnuCHZkorplNg31zMLQ6NWX/ozYVowbMsiynoPB79EyDO9aP0Qy2xilnjJEB9ZCBuHFVFtQVjCtUCNgY0d0BFLRXXFlgiOr41gmkvVgF08mbkMAUFtUYGyvLox5RD1NsE/vAs+kM6mXpQw0vIByUYfgpfJE2zjzDwjkNT2vjmMnWO/6/h6uEEdBLzR/oFo0YiExW0p8/K3z4M/a6jM746ZAtwEx1RssinHv+WRRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB6400.namprd11.prod.outlook.com (2603:10b6:8:c7::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Wed, 16 Aug 2023 09:33:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 09:33:41 +0000
Date:   Wed, 16 Aug 2023 17:06:37 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     David Hildenbrand <david@redhat.com>
CC:     John Hubbard <jhubbard@nvidia.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
X-ClientProxiedBy: SG2PR03CA0125.apcprd03.prod.outlook.com
 (2603:1096:4:91::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 44be887c-2c06-4bc7-a81e-08db9e3be0ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /k/00bLKGFkhBeHUCUGYx8wsuYeVd24z3fvCHI/QHZxjieVy1ZmZq5CDI1eMpZ3yLSIX6cyRe0Tbj4epdVKmGYaPQm5B1Qp1H/rZ91SDib7a5ZNSYOwKjfOhC1F9qrffPZjBKQ7rl6UepkJyEDoPaCGjyhyzjAM+/Wtf0dqZ5I0TDnn1rO3nA1bD8GzmGLSO7wF9XC4anl2+s8B3RptaNrffWXEMvRADXUx772TLjQJgNeYFyE/ZHaKevVc9pZVoExwKKveq9udOLTinwiXXtsSeHLgaPDeXgxdwwZBhuKDSCc90/y/hZLwdVs/+Q6dR5gVYQlGD52RTfT2JK1irzlGBze0/q56n8FOm+A5F1roYQC3tVRNrdL1y8LNC9ZLhhceyIoBcifj7qpaSXrxdYaV76bkD3Y1AZ9AlRbBYPknW5zLoN2Gwv8MSHCjmkw9/gg2v/JVNdtYN25TVTn2W5wouluNidplnf5/4R3z1Pz7hmxlFdzAjheutO3+xoBeUBe7+fnD3fdlu+3jtcwNFHrs9Ta2HhghmXIS3/hvKNduN495yLySMC1zR5HNSodHeo2btuMYZMsxOt/AEMasgA4rRGmj2P44Q1FcyGpsq+dg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(1800799009)(451199024)(186009)(6666004)(54906003)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(2906002)(478600001)(26005)(6916009)(7416002)(5660300002)(83380400001)(41300700001)(3450700001)(316002)(53546011)(8936002)(4326008)(8676002)(38100700002)(82960400001)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IFGbuI0eg357rxuRCb/+W4VZsTOP5sdf+JgAld4ZTSXDoUBS0kYOm0J5DEfi?=
 =?us-ascii?Q?g+Zok90XqY7RribNX/mtJd7rUHg6A8kXuy0sL6Y1AnUtMLgrI0457yD5njeF?=
 =?us-ascii?Q?MhnhxWqLQn6CYP1Cru2zQndOvvNq9tPU2d3JlMKoYEls+Uev2OAekOSF9D3i?=
 =?us-ascii?Q?cX6KgaFvUJyMQmDMs0HJVWmaOnO2FrjziR1+RBTQZEBsQrasK3fNsdYeK99I?=
 =?us-ascii?Q?NMKepKOgT/BW02e1aKfTu3x67KXuTs19ArXRWz1s92FACvxqSCMD6Uapp1ZN?=
 =?us-ascii?Q?CSUqEqJBqYEw/P1Edzi6leoSUdE3WnULdm3kGzXOBr+1lFpnQVIcvd+escCX?=
 =?us-ascii?Q?GRjrDb3uySZW9JEyH2/HTu8/zGDmi+fN8ZYaauSl+g0tUICDnlxHVwGSpNy3?=
 =?us-ascii?Q?XvG/T7mzbtFrUNu99cdjzNSBGwWRn3LO8cLU/klabeMdVFtCrxgp5qlFOE53?=
 =?us-ascii?Q?iLuaRgA9IukbZXytpubCNGZUdrOMqz6xELa9EWamD+WlsU5xr09EF0Es2pCE?=
 =?us-ascii?Q?m48mDu9AictCkEVp+EdnV7zrWE/sroiEd27yVxWGZkk9OZEglGtfI3dvxfCc?=
 =?us-ascii?Q?OLPD9ETCTOgg/rl0EkplaqwMMxQK3mZ7uaEFN711A5IcaCyEwDUg8IhAFGlq?=
 =?us-ascii?Q?UftS/INQz6VYFwdhQpIWxqGqDl8ML2bqu5tqw1vNnc9Pt7wqks55IvcBUuv5?=
 =?us-ascii?Q?CHvheit65bWIFZFM9QQYmMMuaruICLSPr6nAy/rWKXau5s8RXJmdNtPgJYEG?=
 =?us-ascii?Q?ZgjkaBGaTLm0DO+Jyaq6VpI90KSSP9R+xmsDMPmhqPE8RS3e3EKg4LDHRRqj?=
 =?us-ascii?Q?JAEP0L7SWSkmFGcGVRw/IVfo+E1G7HFSFrKleYF+AxCfRqhU78ssrNdEMY+a?=
 =?us-ascii?Q?NHgd45GTZwq4unyqFSv4tt8S93iq49WmsfuHQKt00m++TOeFDs4SEddVLm1U?=
 =?us-ascii?Q?aTm2HD+WGrhUf7/uwttDMuN8nzC9UvngILJrKM2LeygFU46lu4uAztMC67Bc?=
 =?us-ascii?Q?ZX2tJvrBONH1MPaXVf9uPGJ6PYt68kPFJffjvH0/8wfb2RXg15NdzUfeH80x?=
 =?us-ascii?Q?ywuOG82n39RALqjUeqHUI9j21vcY66lRH80iOwkcM5a1ZNz4vT2+D8BQdrCA?=
 =?us-ascii?Q?Lo28R0Od9HEUwVeJXluhP5IKy1wKqKyh6G5ZTIidQGNQnvwVrPHIFMaUqdQg?=
 =?us-ascii?Q?rKD5eG+CFgv8qr1MNC3n/fP5jj/pitZVJKVH4/VQABxhNL4iC3byXjr8fPXT?=
 =?us-ascii?Q?J+XVrPArc2Wj50Cig8DgrzZD/x74BPScU+pveP6P/r+XGSFPF5/fp+KwSjHI?=
 =?us-ascii?Q?hdJ3VMitqoOHTRAFHqlAcTpqTcdnrcd8WSCizonlf5m5+OTv3BhatEyRjOca?=
 =?us-ascii?Q?xOJrWwp4ODjif4I4U+x/DL2lyILEyP/hS7yqtPH5w7UK8BO9Nbyk+bKrsynD?=
 =?us-ascii?Q?KGCkWntas6aYIrmav0IHGDojl6NVhuuG+ZEonMsh6HBn7Hs9kc+yG7+CeMld?=
 =?us-ascii?Q?35vDb93Zrk2GK58FzFLKHgwYJQ9ZJiSneaO5mPtgA0K8bxIrgqWLLaKtdUf3?=
 =?us-ascii?Q?ynxUCFV55q3NV5MLkr6wmuhI+Z9zpJZoADeprokW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44be887c-2c06-4bc7-a81e-08db9e3be0ad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 09:33:41.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQdr6s64jw25h1ZgqfTe+Ebawo4tqQ03PRCLrSkxKCDKXNE0GXjfWQt/RDPTtjLvSY/EPtGhq3OT3d/fX75wxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6400
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

On Wed, Aug 16, 2023 at 09:43:40AM +0200, David Hildenbrand wrote:
> On 15.08.23 04:34, John Hubbard wrote:
> > On 8/14/23 02:09, Yan Zhao wrote:
> > ...
> > > > hmm_range_fault()-based memory management in particular might benefit
> > > > from having NUMA balancing disabled entirely for the memremap_pages()
> > > > region, come to think of it. That seems relatively easy and clean at
> > > > first glance anyway.
> > > > 
> > > > For other regions (allocated by the device driver), a per-VMA flag
> > > > seems about right: VM_NO_NUMA_BALANCING ?
> > > > 
> > > Thanks a lot for those good suggestions!
> > > For VMs, when could a per-VMA flag be set?
> > > Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
> > > after it's mapped into VFIO.
> > > Then, should VFIO set this flag on after it maps a range?
> > > Could this flag be unset after device hot-unplug?
> > > 
> > 
> > I'm hoping someone who thinks about VMs and VFIO often can chime in.
> 
> At least QEMU could just set it on the applicable VMAs (as said by Yuan Yao,
> using madvise).
> 
> BUT, I do wonder what value there would be for autonuma to still be active
Currently MADV_* is up to 25
	#define MADV_COLLAPSE   25,
while madvise behavior is of type "int". So it's ok.

But vma->vm_flags is of "unsigned long", so it's full at least on 32bit platform.

> for the remainder of the hypervisor. If there is none, a prctl() would be
> better.
Add a new field in "struct vma_numab_state" in vma, and use prctl() to
update this field?

e.g.
struct vma_numab_state {
        unsigned long next_scan;
        unsigned long next_pid_reset;
        unsigned long access_pids[2];
	bool no_scan;
};

> 
> We already do have a mechanism in QEMU to get notified when longterm-pinning
> in the kernel might happen (and, therefore, MADV_DONTNEED must not be used):
> * ram_block_discard_disable()
> * ram_block_uncoordinated_discard_disable()
Looks this ram_block_discard allow/disallow state is global rather than per-VMA
in QEMU.
So, do you mean that let kernel provide a per-VMA allow/disallow mechanism, and
it's up to the user space to choose between per-VMA and complex way or
global and simpler way?
