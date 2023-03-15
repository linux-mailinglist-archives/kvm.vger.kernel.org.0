Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC7B6BACE0
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 11:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjCOKAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 06:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjCOKAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 06:00:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E57E67038;
        Wed, 15 Mar 2023 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678874354; x=1710410354;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KEvmmopAOBQJfLWOSR4/G1tSbhe3hxUoqxMoulNnuyg=;
  b=ApoN1pDBOvRnafVcGfHgFNDdCh9oxAm7ocwVrvOm04WAvbeTwLZxioU1
   3qX8xoBre9ojjBjInjxQSw5ICxgbobeKf3UBlHCAiXYvjVxlWeE++MxiQ
   ozkjI6reRYuXvc+Dp5bEy0TP3rSs6qQK0+SUQtMrgZQMp60WClePlsaHE
   yFhZdDbZGGaRYQo5p5wCyUZKzhY5mLSA8zCpz/HinfUFz1nOpN7vFXXEX
   R+htiTgrZhpXUG0Ts9cXZ8FC6Dd8MjR2rt84aZwbZA6S+gSPZH+iluU+d
   cb4sR+gay6AHBRbywDUhg7dmlz/xbH3zXvbtdENX6+OohxqXOkjd8pirt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335146350"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335146350"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:59:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822714823"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="822714823"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 02:59:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:59:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:59:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:59:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g86s7Kto/OUCBQpRV00UX/nFsD2r8HGOar8nXvzNc0jnjJEiBAL42hwzTvseBVCRjCUqDAJ6nO9iGfh29X0FKuGdYi+QYLZBO/FoYrr+mqmh6ZnY4Tmp2FEGbcwAcXZQ5cvSmI7F0sk9HWPWTw2MifV9n4QsghqMs2nujwUcvhmSQoUpp6j1XOwWL8Y+V2dLJdlM4h372yM7s+r2HdeVnq9GS7O/AL3Y8XVKvid/0vtHQtTBIstkYcV84iGoFGTOb6nB8T4jnEHbvA66vs0bnKqYiHwx0m+I7YZf+thJSu2Zinyc3iXbHuyHnL6xXqsp/zv7reT9c7xQG68p8VuqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qN6hn7K1ItB5UAGg0PFpx/0wirNeYeFtr+0oAdV6Is=;
 b=FWQm04zu1dMFz1EF/v//G0vn01MdeO0fc5xE6n4RzpZIvwrLUy3yG/VQrLfJFdKhCQyMobCKOdmpCmbAuWsv76rPvoR+my8DpYjLXEGcpjUnP2P00ucLOC/3t3DHSZJKT0NThasGsDXqKvVSe85qKLxJXeLVyMIlhGeCKHC/SGj6dYrsbhwKaDgshBKTiMgOoF+40r/O5Wh601Cl/CTa1yPuJ4bYLbDcVSgff+ZWq2xGNMHIQT1ZiVFx8rRIDR57d6rvk1BPfzhgkFp/BpRsYCVbDkvnmzox9H49BvMrZe4Au6kVyh+A8VfAVsQQAlTitlWMjEZQ6c82iO+YpucV0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6169.namprd11.prod.outlook.com (2603:10b6:208:3eb::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 09:59:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:59:05 +0000
Date:   Wed, 15 Mar 2023 17:34:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff
 there are external users
Message-ID: <ZBGRJaV3tDTVyE/q@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-21-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-21-seanjc@google.com>
X-ClientProxiedBy: KL1P15301CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c97ef9-9aeb-489e-0999-08db253be934
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kc1xt2+7+pbqcfgldzacXzxRQbQoQp8/LPoNiP/ZbVR6OvY/HoAgTYbf9vem51S5Ziz58tEJfKDaRYxiHC5NOwOHQ7Jqhkg0goK2obcZmuGdxWkkjwlLbQ9ig2SCkalINNyNg19wGByH8LoEKCcRLhut1VbB7kKE+hMuMF7u4w+g3m3rQdz0H+GXi9hDFk7tC4cBuOdY5YdF4bnHruhC5Tz2hsOU/xrsRQDsSNbjjb6VUXOO2xLHoS+dHsfB0o8lZ3bUMAeP55Srv0qilv/lKzoKbovsM40/XN6Jll6CBZfs+/38ewZVZkc1walmG4CW6pAd3I+R/bg7G6nkBCMiol/DoxG1TfcKICmcC0QgIF1GfoKSXiIGs0RWH1OLGMAJX2We8hhjZ9KKD8+atf+dVAqjTUo3QE6BNE1hkBuDKXqS366kLTEfgWK+QGniA1hg/vHx79Ln2IgqCVFIObUTHgIp1H5120pUQXkpLGJQZky3z8hf6e8+q+l8+XcVwWIg/bm2s7lq/uPWsOXFT/F9V2saLQrRZ+wsQhMUtKAmBOQXTnRSN+vJNt3ErDssBbzgyEGadctZdpBCRTwcFfNg2P+laObtwRE/Kddyt9T0zTdbU3fjLRIj4ZFvdu3SADVatvzRKlFK0PPLy8PNl67PYfHEFLZ5dfM3vrm54dFCWyDor3OdWkJaHQXiJVibxAEEtNM8s7X3X3QqNmd0wZE1zNFeHmXHygOucwpO6LPlwRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199018)(5660300002)(4744005)(66476007)(6512007)(478600001)(6486002)(26005)(6666004)(6506007)(4326008)(66946007)(6916009)(41300700001)(66556008)(8936002)(8676002)(186003)(86362001)(316002)(54906003)(38100700002)(2906002)(3450700001)(82960400001)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ILDWmNN+s7QlydClF2TDArve67WmE/DCZZH4je2d9hPWAw/mhD1QDWZmseFS?=
 =?us-ascii?Q?74K17lKXheyUixxQlH0fDrZct4XmPnwMGvYum6gvjJj6ti65azHvsZ9F25Xn?=
 =?us-ascii?Q?/+1McWnx+0TGu0XiayqTG/CxVCfdyfxJu0fXvPRtmT+d4Qo5jEQaYZ8hUssg?=
 =?us-ascii?Q?yAwW38w1O5wzwgW3EQXQ9ctL1DtI7Qzq9ojXGYk8omgJdbdHe/W3wD3FU3Zv?=
 =?us-ascii?Q?u0QWxS57KMdJYItUg5vKLr4nAhMlIccTTe1tQV60rNpQ4ZiczZ2YJBGQwBfd?=
 =?us-ascii?Q?ksOhY/OhpsH3WdQsJLcxpOFse3UmdT1D4KIhh/AF+mzTwMaHMtInzyLMeTrn?=
 =?us-ascii?Q?cc0mzkXqdcE3Vtgch72cFxyrzggzh3ISitEU8wTsRci37U0UL79dDqW3szC2?=
 =?us-ascii?Q?8z2R/QJd0zKX87sjkMTcRffNL69+2QHH1z8l7h0ZPja+Emo8OP5aKU4MtL8K?=
 =?us-ascii?Q?Z4BvhAMftmch2hVaVgKKtloB3AhnUXGbe90AP2zmRaQlhA9tQuVahsmKhvYL?=
 =?us-ascii?Q?NGUpW8sh056utGe49vzTsT4aa2NXOpzpkJO/ZPz2ZJ3f7TSc2fFHUFfaOlwt?=
 =?us-ascii?Q?UarvTp+eYTLmUWEjnHk9a4Bz8LiHuSJNdGoBYCubk1OgH7yRyT27boAzh1m8?=
 =?us-ascii?Q?QWtlblMsQsMmKjDgCxSNME/m+cMOA7iairSucNzqeNZCIyR0HHzkI+8UCJ38?=
 =?us-ascii?Q?XybShyHTpkAnP3UN/JwY8jY7DgpRnvRmzn+RKYCXHCJurrk80PYKQpDtZxMx?=
 =?us-ascii?Q?/wctTbrjkhhKqv1Ojv7Q1bqSXRX7Z54Lj6vFZEI8rJD1wb4XVPmaAZh2nfgz?=
 =?us-ascii?Q?dY8Fp2Mub3IwwO1sd2BJlAV1lS2Ne3jRsvijUkwHUD3D4BEpmP2A46QHOnfT?=
 =?us-ascii?Q?2j5JEoI/a8LQWQ5Ai611ylCN+htHxegtGhMXH0EzIkOvgjfTf26KvPVgj8yJ?=
 =?us-ascii?Q?PSw/Y3xu7obE5KGAovvcz3fK60l5opWAY/wTnxXVyGltbCygbeSqWApwpWD1?=
 =?us-ascii?Q?He6MZ5m1bZypNvtV2WlE2dmRTzSXfxEr4+ATY4A2ZO3Q2Na1LVEb1FvsKrnn?=
 =?us-ascii?Q?sLsoXBawE7aps7TLzSj4xpBpHNiOif4UlwLAmbQYIzJnMXXAyxQ/ok5CEf7r?=
 =?us-ascii?Q?eVXv2Q3cxomfcxiNEk3vjQ0wncHnugliNWcGh+Z7OgQ6G/U0LknGKCDdTHc8?=
 =?us-ascii?Q?aFkMBlplWNPB0Rel/CEfuojmEp22wChjhz1C34CiyhW9W3cLVEIOsy5cnMX3?=
 =?us-ascii?Q?j8FxR22vG0GJNhLDrzzZK+/mNejgec/gQLWP1xEB8ghqht1vb4BckFWJBEnI?=
 =?us-ascii?Q?vHe0tVrO2mJp0W7oU3CsTmgjtncHhZrTdebIZYU5ekui3/2ZyUlR3N9cTwhh?=
 =?us-ascii?Q?yxTCPXv2rVni6a40BGcODLvwaXvqqKD716uM2SkaZ/bXMr1kW6RkCE1wDvCH?=
 =?us-ascii?Q?6cnGHy1Xw4r13zn9ELjSxnm7PHqfCroqSqIRy55+R1KJhAcDh4CwD56hbfmh?=
 =?us-ascii?Q?SnDCZfNdRzRSYSEMDqZ6Li8OLBy0Gw8GUyQxJyqftcZhgCyAMg12P2LAQ7To?=
 =?us-ascii?Q?ZsFVE+dUreI0ElQ53V76pXb8NTI7353RGbDmukqcRqrHtH0qhkJIB4vR8XOX?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c97ef9-9aeb-489e-0999-08db253be934
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:59:05.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkkJWrXG2/x/mktcWVywn7RhjUjsNiPJulbNOudepF0VS/bDQyWQVMxKhqP0g0QGReRQsylOCON3QDtHoOhd5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6169
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

Nit: there is a typo in the commit header: "iff" -> "if"

> -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			  int bytes)
> +void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes)
Line length is 81 characters. A little longer than 80 :)

> +static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return false; }
This line is also too long.

