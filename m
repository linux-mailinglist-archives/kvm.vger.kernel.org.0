Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F10B558C02
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 01:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiFWXzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 19:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiFWXzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 19:55:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBDA60E27;
        Thu, 23 Jun 2022 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656028547; x=1687564547;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PfSQAn3RgHK0OeHzttMJxhhBeo//M6ci4Xa84xthkRM=;
  b=LEJjCredND3y8XUePgeixJQ2rW5baiRYltORi+n7iAnARO45P3FjI7Pa
   ImGWIz5yCZ0VJxTgpaKg8lnxtuF9M/JskneGvREoLJBg4ea/ViTs5hzsK
   5/e7/vzMHxPTFL9dJMp6CNLWdYg5H1wnq+YOgNfrm+JIrQ6FSCFEFqtaH
   9fQ00t+KUX001rjR5Bv+IThrHlCAowrMnfI44ai6AeDwxc/5YtIP6KBDR
   SwTvpjrPm012Ou5EcqJTtWRM1kqUdeDTT9419Rtrie1ZqnKO9WRr+HLkn
   VyNQ18sOFyNfyxlyLJOPbXv1WxTt9qjW6bkeMB1H1oYCQCB5B5lxc4mMZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="280920365"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="280920365"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 16:55:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="592948436"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2022 16:55:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 16:55:46 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 16:55:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 16:55:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 16:55:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TntNZ9sfgvxc+keTGDpNXI62TcRLXP3SCD0Gcb6Oifb8GFUue1ldoPtPY4UsRRrzDY+C7j3zs7zOsfHqkI5JMeuD6Ni+5yXq/MCdJ/s2B+PHc34CEn1m+sXQAYujhuQeT3PI/tdRbUbF2Hw1YRoYf3dDobbP8s9yEnZCPoodFBHPYx+549d1E/r9K019thLzmpRuP98EhVcdrtIf/a5NvLY5vBhCA5dkx2x1l8MFVmc8X+XitUAx2ij/597pDQyBKwP0rJ24VAgYR+iC5brXZSdKPWs1NZOyefOR5oCVKhfGmjrlHDu3CcyrJWY2fWBxMDLA5JHxmqQM2wzpAVATug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6s8YYwk47l+AU91Y+hiNdnb/IDHIJTX7tPgo9Abw/k8=;
 b=AVNq6Bthro8gDkXa1zU+H3wjgK+XKhuvVbaOuUxQH9/MtIqAAhbZSKZGaLS9LdGqcjQZqX3UOKeQKeN04/zaqvusb+QJXPCNOV5VM1IhT0mZAxx+pIb0HmVB+k9zwemyYWIbXF70jRzD63UdT8o8mBnEgQcSYtutgAZ2UtMIIlI5xR2KcJroYo0JaaIXGZeGFSDh/0TvPG/jhmT3g2WbY52ldtSETC8TqGP5klENgouChnVc9FnLOKSILngFNCMeRQESdbpQw1NCII5HxADokHW8pbdsVYzUZY51OV+49njRVphY9zeJWUWWpObdtt4YVwM/OAjtwdCKpAPtuIs4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SJ0PR11MB5939.namprd11.prod.outlook.com (2603:10b6:a03:42e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 23:55:44 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::1c70:a7e4:c7e5:1c9c]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::1c70:a7e4:c7e5:1c9c%7]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 23:55:44 +0000
Message-ID: <ec95b28f-51a1-a9cf-7d72-a3a865797c7d@intel.com>
Date:   Thu, 23 Jun 2022 16:55:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] Documentation/x86: Explain guest XSTATE permission
 control
Content-Language: en-CA
To:     Dave Hansen <dave.hansen@intel.com>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <rafael.j.wysocki@intel.com>,
        <reinette.chatre@intel.com>, <dan.j.williams@intel.com>
CC:     <corbet@lwn.net>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-3-chang.seok.bae@intel.com>
 <a32831e7-5e01-db1a-ef89-cc5e1479299f@intel.com>
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <a32831e7-5e01-db1a-ef89-cc5e1479299f@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:74::38) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfabd37a-3218-4af3-3b82-08da5573e2b2
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5939:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yesBK99X/lhPVFWm9TpyoZ04Y8PP76I9CSd7BExAPQ/Va9U/bOTtxo/saqZ7qpK9Q2FoIaBGAyERtps7+/YxC/0CzSgyEclOayU+Lh69od7vC3S1YbjVMJ40Hfn9PThorpRJ+T5i9jWnJuJjuVUn2Sea0BeUUnEMmbunjr8SdQIXA3fsLjcQDBcNOymB+uDSVkYsRoYO2dIYbSgSWism2uBB8pSlHvoKBXe9UcgeYe8XkrMe0RTK3m2OKwwzRSMWLDgYqaC+GhRRaQ0id6vyqPb65B4rZlP6UlufQdynaowLxE8MDrmFxyZvLxFTxR9Vd8+/xELc+9uTYASNItL/RpnoQyvpy/FCBslgA7eOsByH23T1pg8Xxpo62uEsrFpcpGzgRt512Kc6V904jP8tflOs9B5xPs/IbfiCecpM3pWg1kayU1cjzpv9utsyRbPaDH9n4tKUpI7I2zvw8scWPI7whRsWm3SiL91KpWFyne+jbk4HtGy3r2sGdXv32cupC56ouACGQHi4zIo1GTeVHmdjelQCLCipw/4YlF1oTVXq4Mjm3i07TT0WPrzli4Cae6HFNElFb8eawtpcg+095lbsBuG+xbMdqljhTiM/c6neWjIeZC1hmmGNSjdvQltAMiYGVwwDB7XAYpBE8407ORoZ6bzuDmApaXxlkKRCPCtzYa6wmh9MyvOZTwJaAlyc3XynM5PxBohu7W1r7KFqCOHxbbiEod1sPolWGXw0icymkKSeakHsU7LdxyHAo+1QZw6xiVzH5av0bpp951NkrkWTxeboXEh8cT4vFKfWqmTezAkpgAfMpwymagN2L0m+nah6QhtMqa/iVxRm+9sVLrA676rgqbVzd2pdhWNwRzu09mfM8opvHfJ6qRto3hpEFoqpAz7LwXYNmzHqXKkozw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(376002)(136003)(346002)(396003)(66556008)(66946007)(316002)(8676002)(4326008)(6512007)(66476007)(41300700001)(82960400001)(2906002)(6666004)(38100700002)(31686004)(31696002)(36756003)(6636002)(53546011)(5660300002)(83380400001)(8936002)(478600001)(966005)(6486002)(186003)(26005)(86362001)(6506007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEE1bFNldXRNZ1F3ZGc4TUVMdCtrZk5CVjNzc2E0VWpBOUxJY2laUUNhVldP?=
 =?utf-8?B?Q2UzdjIveFRLUXNkR1cydTAwdHVDcDdRMHNKeVBuVEJRdlYySVVyeFh4U2M3?=
 =?utf-8?B?eTcrMjRMcnc2NllTeWdFamJGc3Nvb3puc3NtZFdXZUcwL284RDBRckh0YVkv?=
 =?utf-8?B?NFc4T0dlN0YyajRZQXdoSzA2bStXMFpNWnlhL1d2SlpOU0lMSEMyVzlVTnNJ?=
 =?utf-8?B?MGhNWjZaVGZVWHFEOU9tbkZHbHZWZVExYnRqbEdWazlRSXZiamZFdWk1VDRU?=
 =?utf-8?B?NkJvVUlEK212R2ExUWNUMWJCQUR4bVBOUFZsM3pMVHROUDVZSDg0ZnVmUE9q?=
 =?utf-8?B?NXpsdDNqd1ZhVkRUL2tZcHlrY1pQMEQyajNvK0g5QUhWeDFrZHhnUjlrZWtT?=
 =?utf-8?B?VFRtTnNObDU3cjVJK2lsUEJGekVvNlZ6aUhDamVHUXRxUml2OStvMjd1bkVp?=
 =?utf-8?B?TUNyYnBqTzRKNy9BK0lYMnJmUjZmdldLUnYrd2pUUm5oZUg5R2NlRGs5QmpK?=
 =?utf-8?B?OWUwU2pxbFpybWpYNXcrWGI3T0ZoTUdWVHRuaWk5dEVEQ1F6STJqeWdtcFgw?=
 =?utf-8?B?Mzd6Q3QzQWlUY0N1K2lva0Z6RUZ1OVBoSGpvUUk4SFl1L0tZNlhLOHdHSHA2?=
 =?utf-8?B?dGk5b2tIWWFwd3F1UVdyWktERUh2NG9RQ0ZzWUdEODc2bCt6WGdSTW1vRnlI?=
 =?utf-8?B?OEY0NHdUSWl4ZDNVYXZFSWdOeHp4SGNzallPbDFJeUtpUXRZRVMrN1EyTERE?=
 =?utf-8?B?d0pnUDVuZUhIQkE2UmVQVlc0SnlvSWVyZlFodTlvOFZETzIwaG0wZEkySURh?=
 =?utf-8?B?dURoSUFVSFppaUF5Y0Mybmplelp4RmFIK0FRNDNhNnM2OTYxb0d4TEJFQXBF?=
 =?utf-8?B?T1Y0MEZBVUJlMVpzdkdzcjFZUjJrWUxnbG1PQ1hiR2JnSHdMcVVSaS9FM09I?=
 =?utf-8?B?QUZpcmYyUElKTFphV3ltZmx4Wjg2cURnT0lFcGlieWcvS1RKR0ZVbUpEMUlI?=
 =?utf-8?B?Zm9BYWRmczQ4WDB2YVo4MEtFVHl4b25wUVJvb3ZzdWZDVGdvcVVQbEZrRWFi?=
 =?utf-8?B?ZEZvYkRYeWt5OU9yMXFPWC91SlRLcFh1Q0pCZCtXRXJTWjJTT0krTnhJRVM5?=
 =?utf-8?B?ZjdETTF4M1hvLzJhelFYaE1QYzlZSk5rZGluVUVwZ0VDemJRR2FzQjd0b0J4?=
 =?utf-8?B?M0swYjNaOTVvTzIyTHpET1VtMXVpa2RvQ2NqSEVIVGwzelc5czZuZ3FUMkJT?=
 =?utf-8?B?b3BuNmx0WVpzaGd2QitrWWZJZ25IeE5BMU9Zc24xMGxkYjFmMk5LYitDTEx4?=
 =?utf-8?B?QXcrK1V2dkhVRHJ1M3ErTkkwaE1QVGpuTFhmZExrRGYrbTBWMjJHQU5CTzF0?=
 =?utf-8?B?bTdvanYrSzV6YkY2d24rb0VwblBLZkxIV1pIREZoRk0vSFFWQXZFK2wrMHBF?=
 =?utf-8?B?Z1BaRnVxNXRDRE5oS004UFRBSG5Ybk1lVTJsMmZnTXNFbW14U1hLNWtHYi92?=
 =?utf-8?B?eS9YVDhwNWJ3c3ArVkVDMjhFUS9JdFExdWFZYVByYUd5NXdGcnNXUDFyVHJK?=
 =?utf-8?B?SzlQNDlpOEdkN29HNjduS0krNURJeHlYYTRTNm44djJnclZzL3ZMenlpbmlr?=
 =?utf-8?B?c09OM3hkQk5pTHZtcUtkbTdWVHZRWmgyMmFNcmoxcFN3UjB0d0E5ck9udThz?=
 =?utf-8?B?VFJkaTRDSHFpRWU4d3RYMTBibTZVQzNDY0MvdjcyK1MrRlVOazAwOXoxK2Qx?=
 =?utf-8?B?ZGI3VzdEUWVUVUlRak8xZWZxMVc1UzBRSUp2N0QveXZpaG9qQys1QzdCT2xG?=
 =?utf-8?B?MjRrdENQak5wOWVBOUgxb29rb2g2dGQ5azJkL3VSNlZ1NDJPQmMwZlJpSTl6?=
 =?utf-8?B?SUdFb2c4S0xNZ2ppRDR2dkRTM2VOa1dVRGluVTd2VnRscEVPQTJpZ0NRVW9B?=
 =?utf-8?B?TFNzeU00K2lFTjhaZ2E1cW9NWUtlTGlWUlFFbWRON3ZJanAySTgvckxUaW1s?=
 =?utf-8?B?YitSbE9mWHErbjZUZE5mWHVQK3VmZXR4V0pnWTdrcWVkRFFKbUxxeHdXWVQw?=
 =?utf-8?B?UHdkT0czRnNaQkc4ZHh0NDFxaWpxRlJrZVdLVUxCdGRuRyszOXZDNTNCV2RK?=
 =?utf-8?B?dldPcFhJRUxpV1ZIKzZscVVUOEJEL2lraXdBSytoeXNITzVJVW8xVTVIOUp3?=
 =?utf-8?B?dHBCUnFwdzBkbFpXNkZ3emNBU3J5SnR2ZklKNG4ydlNUaGpweDVabHQxdmRw?=
 =?utf-8?B?NUx0bmR2eVUwU2t4dEhOZmhFbUpDcUsxQkxIN3A0ZDNjMjAyS1I5OFNsZGdL?=
 =?utf-8?B?dHJxbUlNOWM4Z2xnRFkzSk15QzA1UGFXdFAvWm00d1dzZGx1YlByRytNVXJo?=
 =?utf-8?Q?+LKk7lPAJzfM4HK8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfabd37a-3218-4af3-3b82-08da5573e2b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 23:55:44.0528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MO7Koo8YgUP+eLQbQiHLUTnIHrUO2PNtOU690AppguDqBhYVUuSp2IkPELh2eOxQ1FcOQBHOzYDoo3iWpI3cdVEAbS8Mtl1NDhCEMPDWtzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5939
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/2022 3:49 PM, Dave Hansen wrote:
> On 6/16/22 14:22, Chang S. Bae wrote:
>> +In addition, a couple of extended options are provided for a VCPU thread.
>> +The VCPU XSTATE permission is separately controlled.
>> +
>> +-ARCH_GET_XCOMP_GUEST_PERM
>> +
>> + arch_prctl(ARCH_GET_XCOMP_GUEST_PERM, &features);
>> +
>> + ARCH_GET_XCOMP_GUEST_PERM is a variant of ARCH_GET_XCOMP_PERM. So it
>> + provides the same semantics and functionality but for VCPU.
> 
> This touches on the "what", but not the "why".  Could you explain in
> here both why this is needed and why an app might want to use it?

[ while studying on this a bit further, found a few things here ]

They (ARCH_{REQ|GET}_XCOMP_GUEST_PERM) provide a userspace VMM to 
request & check guest permission.

In general, KVM looks to have an API as a set of ioctls [1]. A guest VMM 
uses KVM_GET_DEVICE_ATTR::KVM_X86_XCOMP_GUEST_SUPP to query the 
available features [2][3]. ARCH_GET_XCOMP_SUPP is not usable here 
because KVM wants to control those exposed features [4] (via 
KVM_SUPPORTED_XCR0).

But oddly this mask does not appear to be actively referenced by those 
two arch_prctl options. I can see this ioctl attribute is currently 
disconnected from these arch_prctl options.

Also I failed to find the documentation about this 
KVM_X86_XCOMP_GUEST_SUPP interface:

	$ git grep KVM_X86_XCOMP_GUEST_SUPP ./Documentation/
	$

I guess people will be confused with having these two options only. I 
think documenting this has to come along with these missing pieces (and 
potential fix). So I'm inclined to drop this one at the moment.

Thanks,
Chang

[1] https://kernel.org/doc/html/latest/virt/kvm/index.html
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/kvm/lib/x86_64/processor.c#n641
[3] 
https://github.com/qemu/qemu/blob/58b53669e87fed0d70903e05cd42079fbbdbc195/target/i386/kvm/kvm.c#L428
[4] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/x86.c#n9008
