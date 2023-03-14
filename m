Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6E6B8D43
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 09:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCNI0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 04:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCNIZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 04:25:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0163195440
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 01:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678782253; x=1710318253;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZsxVRugV7Yk/uKavH+BduC9Yiv9JGKCzD4Jg2co4eH8=;
  b=b7jDHPdynH01Owimyf08VtP4Oe2B6YEGURMNUx8uWWiOgGre3Z2RxLxj
   bVVEQQS5HMBiEfOsksattD0kBmN9wG/yLf00hukQQ7euq39OzHzmPkYJr
   Vq8unv9P+1mvs8qxoxT2Sfpzj6qX5MCzhadnPPBioo0GU6WE7UWqKGKcs
   9pXY94qOfRkkzoSycXvnVgalOHPbxzkyZAWyV8m4BasZ1fM+YBZDkUGWY
   4AzvGxGur+qZTez2vfs5VVuFJQAshiSQaI9vL9M0YKh3KcBTv8vapbO+t
   i8s1WTd06c9xRR9Kg2RbCnOi/0TeS5+lNMKiq7TA0LsoHCtjnfJqVomVo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338905436"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="338905436"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="768005194"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="768005194"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2023 01:22:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:22:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 01:22:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 01:22:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pld8LnNFbYq7sCegPXs+tDohR0xbVNY32fyXCkJlF5HMJr9B3owcoePHZYwHW67ilH0l1jg7fYIg+LoiAAR1kkaX9g6HQSQXYUb3v3ivfJyz2vEosC3dKT6uYMnEosopixKNrH4tVnjzafCslc9KR+fM6edN24NTCJI4hvAY8gZdg/0zhptgwcc0C0R15XIntuuPdMcZgAfZcyU1jZtRi5KerlQpfs+H9/cZnXj8d0hCh9jNlJUIRzhZ4ti07U5hz1P+JX7JZioE/657O7ry+WoD2yedj/advMJDe7RimL7kotseAtF28VqVxIQjKhDGFkxeNcJvIMkaa+jDiagMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6oKR2YThyltB16864591yp7chNX73OKY0/fr59mluM=;
 b=VfZGvsD0YjDKlp+JM33ELUF/Vv/u88hBCqu9Pl9O9cZTzqDgDbyKY4mFMXHVaQS+slcLpfOtN4pGji6XqcIyB+X2NPnNYijc8hG7TX25hfS4jMURnFjCTb+eb7aEPPGVoLFM7l8czF9nWYjpDu6CGjortsUXba/Z88arE3ipvbZkC/yE0lsyMNsRmuPfiNFpExnv4h67JufUX404rDCgHA6TbpN04Q0ALAlAld3JaoprDvTHitMfgPD8d/yiEK/u6XyCsT8ZaiowBFH9H85JoXFvLjmpkDalkqbP0LAU5pgr/cwxL6WlmY4mp3z+Kw2Q474ywohyHTy9Y64Lqvq2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by SJ0PR11MB5054.namprd11.prod.outlook.com (2603:10b6:a03:2d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 08:22:43 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62%6]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:22:43 +0000
Date:   Tue, 14 Mar 2023 16:29:29 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
Message-ID: <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZA9WM3xA6Qu5Q43K@google.com>
X-ClientProxiedBy: SG2PR01CA0156.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::36) To SA1PR11MB5923.namprd11.prod.outlook.com
 (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|SJ0PR11MB5054:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ecf1dbb-1323-42e3-0747-08db24654899
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f4SZbt0NPn8J4whCq7878gg37KFZD1ySLlJv8A0utDDpbLDVkCM3Q7L4crtrESpYA1dy4FABrJ+hocSyM5jhtYi5UAS8JaIr+ggRgkTj7trwKUxZJWcC/ujahufVzA2EgoLCOhitewc7wW+C8E6TlGMmgSUqilLAa0tYtdN3e3k1GOv0rTHeSUHKzHID+doQJmDiUYVZwOQQ0ZMk3a5PEYTvsDPiiArylFxNeVwqHXYZ7FCsraGqzGGn6Rhybz9Y59vrE/yhHyOmjKUJEVbqJAq+l7il2w0f11gEU9y2z50KF0rK6VwHbEyQ9X2L5lK2WU2s1xcL0v3nZIEu0+dFnV0VZVrKAwXgNxijCHq8iVjcpbTSOGetNkilI7K80gI+onYoMHBrgjNDo6Fxnl27WzqTIe9RSoc1uyrPLlcW4q+aLke7DxyYZeuaokmnfKDgBWWO7ZJG7bBtoQgVwc5/nnh1ei5n6mp2bUMDjhLxxWsjSQiMhX7bBtXzEr6CqHBPg0G2U3/FKdolgIU8mS8qexWtrAmU3a7MpXe4WcSpUVC4SzyFLGJSWgEk25VuIm02mLzIjb2+H3AovKM70JELJulKgrlZfS53Smx97JtAEYY8uUzXP1wzH/jyyQCGGgR4GK8pgsUmZ7W3/tjKbfh1bOA15+xCenjnqUZ2Odbxl6X/TLHf97HHyIQiokjaVunykq4swETCYhqGGOI27Ajzzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199018)(5660300002)(8936002)(6666004)(4326008)(6916009)(8676002)(66476007)(66556008)(66946007)(6486002)(83380400001)(478600001)(316002)(41300700001)(33716001)(86362001)(2906002)(82960400001)(186003)(38100700002)(6506007)(9686003)(6512007)(26005)(399854003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Z9BcCLCNLcyYgZll6HCAZxClDGRJedQRp6vCM/0UkQqYhornfY/vhzOU3S/?=
 =?us-ascii?Q?iLB04G9KaLg0XKWjs3Wsubee9WWo31uPeHJE5CvqszePvFGOVGKE6aRYrKvm?=
 =?us-ascii?Q?eVWMHTwSaKxS4TmpgR8chPx1AJlzGW7LdoWuFGjkFW5+jAsBubCe38zH8GEG?=
 =?us-ascii?Q?2mXHacEkXYzn3v/TjFl3MSaen55bG0kiPDsHqCmaE13dld9t7S5U+Fgm/5Mf?=
 =?us-ascii?Q?gIFD4a+iTQ82gFuT+1fGxBedkwDC4C4mHigHSemZ5CJCGIT0qXPRRar42fwV?=
 =?us-ascii?Q?R90wliGsGXm+EFiYemjZc3tJ17Dx5s+AoLAWCHLQuTDg5DoN2nK+SbI5yTdq?=
 =?us-ascii?Q?HNgi4wwSpyekJCwAYEOfXVHdEwfupdkxy79qHbS/iLCkNSxnfqZ9oMlxEPoL?=
 =?us-ascii?Q?Y+31W/jDb5/NVQF9ZsXWaF3YxV1qfArgBowMvkaOFJzS9CaAzXzzCNQ+fDEF?=
 =?us-ascii?Q?9UcLuMcdYLiQHXVuQOY8V16V57FavLk1WkWZhWauszH0H68zsGbV0rGym7Kj?=
 =?us-ascii?Q?tSHawtS7ubnao2hcYsJnYP+1p09W5e+L4ZEMtZdTOXJShqkocj5C8yRI9p7G?=
 =?us-ascii?Q?qs9nQmR6gTfjMqS+bdFGO0SiVE7R5vqqqnNP8pGlcgIi0IKnwYGEbEuIzErN?=
 =?us-ascii?Q?Zw4CNAU0VHHHMimJUEFWuxEXPZoEbNRftJE/+CY6m1jVILO2kW+TXeBGsoaj?=
 =?us-ascii?Q?jwkFgwwlgICuG3tTc0QMVvvD2nWtHP7ni+xTTRjS79FGYbRgEoiBqUW14+Wt?=
 =?us-ascii?Q?5zvu4864B8m4Yz11ie605Cjk3PiMdUO29fM5aAh7I7RHazmCNJZSCtxCEK20?=
 =?us-ascii?Q?Awvc1N28hq8ZYGLiQvLU+EmCyMRXvRm0+TGeG9x+DivpzKNstnGKGH2daiba?=
 =?us-ascii?Q?iFNdjOUcWaxMQaXkJ0dIktiZsr0pqLOgkCqqVnQgoSp791UEpzAzCh66sLCk?=
 =?us-ascii?Q?Tgp5O5eLRB7kxNUdspJL4gYDK1+kAjOYcCvSs+e+zaxf1AVQ1B6Tgm4L+hcM?=
 =?us-ascii?Q?QLIwOwrVZAsHZ/3MLTw4PWLacBp3hHPbAWz93z82Vv6H9TKDGerjqBc2vFQn?=
 =?us-ascii?Q?Bp8cjBbsqY2Aj+t1wzZ8ukw2NSh1E77nQWPOZx2gD3li+BZpgRatK13TF90F?=
 =?us-ascii?Q?ZIEZRLsBrmBuY6lZZaAcN+aSzNr8/KWzqTMT/dQWJgjNDcR2fyX5yYCbTpDU?=
 =?us-ascii?Q?bbDOHVnqKjRvS1nrdP3dNvZLoH5TeYq/YOVdvXTZqfjpdFUvBfWHDrmB7J/n?=
 =?us-ascii?Q?Uo/C8mYSOyXm3LuUPxQRxtnnfxDmiBmQAJdilmD9CM2FxkwbL+YWywxI7lMw?=
 =?us-ascii?Q?RCs2bDKXlNtgaFlcl5jN7nLbxJ/TV5tZ6dfDL6I0ZWAyQNI85fJDYmHRYg0g?=
 =?us-ascii?Q?+Q9jiIbEcxX47iYNGhAtFgL5DFYrTOS26OjrFvH9LMc1zVgBfoPxxMjUg5Hn?=
 =?us-ascii?Q?cg90U/dqnh4OKJtffMQvHhrcvo5vWSrhoHDpV1yhbrz8H6WltZ/8Qy9X0k/f?=
 =?us-ascii?Q?0pdMPqN3i/MBIgbhEWrCFHtw07FH4GM/Gp8x6bYvVWQz5PZtJkiLGDxw4B/1?=
 =?us-ascii?Q?Q2y/Yq0/CLZyafRyW8EbaMbLvFu7roeilluSievlx6Af5kDq4KIFQoTROJYe?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecf1dbb-1323-42e3-0747-08db24654899
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:22:43.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KtYuAPKT4sirnF+TxYlElJvGkvQkA95QS2OXLuEUns6kX9o0Y4oUxwQNgy3IKriFfECnp8UHdZ610LlRYu70Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 09:58:27AM -0700, Sean Christopherson wrote:
> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> > This patch set is part-5 of this RFC patches. It introduces VMX
> > emulation for pKVM on Intel platform.
> > 
> > Host VM wants the capability to run its guest, it needs VMX support.
> 
> No, the host VM only needs a way to request pKVM to run a VM.  If we go down the
> rabbit hole of pKVM on x86, I think we should take the red pill[*] and go all the
> way down said rabbit hole by heavily paravirtualizing the KVM=>pKVM interface.

hi, Sean,

Like I mentioned in the reply for "[RFC PATCH part-1 0/5] pKVM on Intel
Platform Introduction", we hope VMX emulation can be there at least for
normal VM support.

> 
> Except for VMCALL vs. VMMCALL, it should be possible to eliminate all traces of
> VMX and SVM from the interface.  That means no VMCS emulation, no EPT shadowing,
> etc.  As a bonus, any paravirt stuff we do for pKVM x86 would also be usable for
> KVM-on-KVM nested virtualization.
> 
> E.g. an idea floating around my head is to add a paravirt paging interface for
> KVM-on-KVM so that L1's (KVM-high in this RFC) doesn't need to maintain its own
> TDP page tables.  I haven't pursued that idea in any real capacity since most
> nested virtualization use cases for KVM involve running an older L1 kernel and/or
> a non-KVM L1 hypervisor, i.e. there's no concrete use case to justify the development
> and maintenance cost.  But if the PV code is "needed" by pKVM anyways...

Yes, I agree, we could have performance & mem cost benefit by using
paravirt stuff for KVM-on-KVM nested virtualization. May I know do I
miss other benefit you saw?

> 
> [*] You take the blue pill, the story ends, you wake up in your bed and believe
>     whatever you want to believe. You take the red pill, you stay in wonderland,
>     and I show you how deep the rabbit hole goes.
> 
>     -Morpheus

-- 

Thanks
Jason CJ Chen
