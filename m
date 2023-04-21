Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1046EAE15
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjDUPck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjDUPcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:32:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C895C646
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682091157; x=1713627157;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=qvRQgq0RQvi5BqpB1QnVInQDt85n8glfh0lAfEwdIuw=;
  b=EsIO8e/D4qhZpT62ac9WDTh4JHQhT98dWhcUoxbJITrCWbqaRvYyaQxD
   AdA9RpAyTbmAmL9VGzB1OL5aUF8zEtduYvW80dhgR5r485r6sJz3fd8NF
   J3ztcJ3JJmEgOTrNqnwnZ2uEW9QKr+WfUKqL/Hegyn5Ef9Lb0k1GsnUn1
   mO9B0jJ5nOG5W97CFcRQlpqxT+CcZ9g8Veznk6uOpEEvnzORq3QEgn731
   4McEVr56fsRRPCd2OKmyAldQj7gQEQqfdA9ykx01WQxiQuvsVwH8uRpTV
   5aZhnsWFSQzC1dd5DaE1dzoGKztUDTT9dbhX1IVVTijutlXEaMij1b2dK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="325617887"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="325617887"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 08:32:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="642545905"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642545905"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2023 08:32:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 08:32:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 08:32:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 08:32:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 08:32:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+Q9sHSbCTtAMz8NWO54KmFgl84KCuuetq40yEMN6p+rspgDsRGW3EZXNSxgiJ+XNJOTRbRB9w9nh1RQEC72op4D0TloHAEFiL2SnrGnFo9BJF4WN1gWz4L8Cq2Ckxm6l8gEvt+ea625OsY7JuBpLC5ddrINpDUQ+1q/0uf0HQm+g3wxk8QZ4hjOUuXdjTlAjv14rzQAtFpJ6ynPiOxx5DuCnnToI8un23KeBzg9TtF1ljfyj7xGneQznZN8SBfY93kQ1CPGOwF5Qjk+JqLsJx9pluUIAnrnVWRzH7ko9JXCLvNJAV9K4dZuwz1tMWJvGL4Q2hhWROcJyEnJQcwm2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2R+CidF7rM7Qaa8ZuOjZEKe66Zfu8MzbZsPDJ2Bqvao=;
 b=j8KncT1fON2k5UymkiCT3N8XNZJT0Moo5DmwCsHhD+UsTiZL2ZGWI7qsT5XUR0yg5QfgbPF00WjKUtBo7/nGv/CPrX8pnxCBhoAsDaSW9iEJ1rIc0pVqaOANzLZM1+UgCCCPnTte5980q0IIAkm07DkjUkZkrvQowt0BCPcqZzYw3aQKKfsnkHIuwN5QMxWVGPflG58XsDnI9GDIcaN82yaPQaude8/NZJLZPZgatwJYLKDXD8/9cnoPOx1w8utL/BN+lHRNlMm+kMjWh19IA6BYXCUrTn2Xog8Zibm0VPZR0w+RhVIzLdbZNedTV5MvmPSn03B38gTz7RHwPmaxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5165.namprd11.prod.outlook.com (2603:10b6:a03:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 15:32:33 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 15:32:33 +0000
Date:   Fri, 21 Apr 2023 23:32:17 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZEKsgceQo6MEWbB5@chao-email>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d3a459-184a-4ac2-66a5-08db427da00a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osHtkiALPeyMQCKquQAOiNMD3nn1LF7Okjf9+pJtkuvgfNGzPt1rEZLzUM/aMZDcS1Ng8LW9b5QNJDS+S7/JgHzD8SECvBadoMWDGlDdoX9Uz9j3OoSnd59aPqxIO8XIQ4FZ777s7xM+oJYUMHshVFx/jzcOxduHs0PJb3Tz7rjKhBMtFsxRb0vAeIIS5LTh5yFs21HR+UJJGinGfjQRvhOUKilSpHxOO/zAaDDyowpEa00Vg5cVD02hAKqfApQDjPXbc91iiiP1hzmDXxTjQuS87lI5n+ILTR785Ed2ruEj0c85Bgl3bXtNQbLnORL9pPCXJLJLfBZTCEUZCTb0m0dBmlf0K2OFcil5R2qtYI1Oe2jPK0+9gk1lg8kb1mdzXObrVfY5vwTg2pKCxnMAM8v4jLS6q784ijHNpt6BQarPRfgVCMTqapxxwVp9eRTMNznCYqJHPl0D6HguMC737igvVpUdr11VlJOdA0m2Fq/cYjj7H9ixtFMBdskTapw5fAY1rothX3692Zqx9HLDidtAin6TN5K39wT2C4TmjRPDnruWdZl+ylbvo2YGjp3k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(41300700001)(44832011)(5660300002)(38100700002)(2906002)(6862004)(8676002)(8936002)(33716001)(86362001)(6486002)(6666004)(9686003)(6506007)(6512007)(26005)(54906003)(6636002)(53546011)(478600001)(186003)(66556008)(66946007)(66476007)(316002)(4326008)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?OPjVzULLzKFcBdxi4qysryEq7MgspI4XqDOtbGFgy99U4Hj8VtTGkxB3+b?=
 =?iso-8859-1?Q?iaWDwndCkWutzBJc9RJUtbAorCJNTWcaAvqU7Neytwp8jDbG9tHfn3UvwJ?=
 =?iso-8859-1?Q?4AVKVQvGqX0sPR9jRKDU0qlZP1j8vGZq8hebJKeKerxZvm0uq4s1lDpOFO?=
 =?iso-8859-1?Q?i5m7StIu1g8zerhr93m24xJ9h+lotb4iL0oiXY/AOa7mSJIEua9TT3ZZ2Q?=
 =?iso-8859-1?Q?TY3FD0O+p8Yi98YqRB/BojIQzfUkaI+sVEEMkRkrj3QYc+9eVBbzPtMi7J?=
 =?iso-8859-1?Q?TAgUetsFZYLs2yFxrrjG0CGV0yKjYbPV+fwfcxvq+qpBVHD3XVfDXVsvto?=
 =?iso-8859-1?Q?2IzHFg6MnO0q/ZifhLBvhect1VTUsGMOSmk+ntkhw6pnoaF0CWrWqIVLGZ?=
 =?iso-8859-1?Q?DsZbf2Vbwz4X+k7Xb9BcAoW43z+3mqBprAgM2Jq0+6VJXaNW04DCJrgrh+?=
 =?iso-8859-1?Q?4hQXXBTuluoOzQFdKtgJCv7WNBNlPCe1ODefHj+KJP6np9G1P0/hhtfvpy?=
 =?iso-8859-1?Q?ErQOtHMwA41eOKCQ8SYWjrErBGFArawziQQ8o8cvdgClhVTIZmNv7Xl20q?=
 =?iso-8859-1?Q?RiYZqHgV/cN2y59z/yszpq/9Iu4A71mt1ESnfbl6SFsjEysWlZYDiMTiRf?=
 =?iso-8859-1?Q?o5rQfUGkLZE+9CwP/zWtNSFcwFk6cu3V4vL7XL0f/ZnDN8ERLOPxt2uwx4?=
 =?iso-8859-1?Q?JrbpRTJE7mWsrh90m3TFBTTtAc4fezZZ7hgbq/s0KGh7ZQ62G3a8wcla54?=
 =?iso-8859-1?Q?NhpUL7ybE5j7aWCxiVDUQXEKd7e5rgoRtJv6nCBZYDKLwlOlYG3wvTniA2?=
 =?iso-8859-1?Q?rouj2MS20EDUrb53KzMGa3pGHy/9MMoIcgDgyBA1Wm8xoOdIMGlZN2RCVf?=
 =?iso-8859-1?Q?wOoJFyI/WQPn1iV0av3NtuzmvyC0SfbzLaQ2zqs25TRadreZ8AIi4wNt7M?=
 =?iso-8859-1?Q?8Op1++U4sn6jS6gwy7tZJGm8b5x5y0Q/s0/1iLQuekyrvS3OCKI4qf65cq?=
 =?iso-8859-1?Q?vr/bQHbIWAa8HCKvUlr54qz9kBHidSQUDazeCWFN4lxrfsXWaT8TR6O1er?=
 =?iso-8859-1?Q?Vg5C67YUeDdjApViy6aqh/fc3iA5s27S7lSliVaX0n7t1TkKqB0G7k5JIi?=
 =?iso-8859-1?Q?YQVrRFq3kc9L+pCOdi2TZgaeSwd0W7MIR6WExw1yf08bR7W2BgXEKLwNvB?=
 =?iso-8859-1?Q?kkmQKLXLTs4xEq+HZZSU52UaRRZuqsSLeNveZx3ALRAMklqQI1+u4UDFVU?=
 =?iso-8859-1?Q?iEAVZ78oxdwfLPNv9huyr+gyWZ6YgVmDnKFcBwNpRvEtZKdMVtGWy155BL?=
 =?iso-8859-1?Q?LuFRxsUshcJiEJA6cHiJszX14PH+povIgH/jQ6rNPF1yKRYguoi+vs+4Lr?=
 =?iso-8859-1?Q?4xHWzMDP4S2vZJ3A/LE3tX+6hEOJQlvEqoc3lQeFmLa2IRr8yJ5ILFB4v0?=
 =?iso-8859-1?Q?n0oy49sjxRs3txYWM22qUX0cuh7Wm9Y/ZmGDUpIHjpOt51xtDWg9XFJSOG?=
 =?iso-8859-1?Q?a5Vq+j5Vom5CBtuIavm0b3/Lof1bOS7bXX63m22VkU9jxYqhMpFE9ytWgW?=
 =?iso-8859-1?Q?v3jh2/dbDPo42VDMGoL5txrnbXPj+0jyn3EZf8UG1xV5M76Z1I3gCcr8Jc?=
 =?iso-8859-1?Q?sY3ZDKfcGyH7cJWimmy/knHPuFWcMpD7aj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d3a459-184a-4ac2-66a5-08db427da00a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 15:32:33.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IN1YeAa3xh78V/7W3pLn3hEbKxckti4e2rny/oNg1gy6WLenuqWaNDySSQIhzRaIcXqfh0osRel0jlWIRZQOOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5165
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 07:43:52PM +0800, Huang, Kai wrote:
>On Fri, 2023-04-21 at 14:35 +0800, Binbin Wu wrote:
>> On 4/13/2023 5:13 PM, Huang, Kai wrote:
>> > > On 4/13/2023 10:27 AM, Huang, Kai wrote:
>> > > > On Thu, 2023-04-13 at 09:36 +0800, Binbin Wu wrote:
>> > > > > On 4/12/2023 7:58 PM, Huang, Kai wrote:
>> > > > > 
>> > > ...
>> > > > > > > +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>> > > > > > Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this
>> > > > > > way, below
>> > > > > > mmu_check_root() may potentially catch other invalid bits, but in
>> > > > > > practice there should be no difference I guess.
>> > > > > In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.
>> > > > > 
>> > > > > However, Sean pointed out that the return value of
>> > > > > mmu->get_guest_pgd(vcpu) could be
>> > > > > EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.
>> > > > Yes, although EPTP's high bits don't contain any control bits.
>> > > > 
>> > > > But perhaps we want to make it future-proof in case some more control
>> > > > bits are added to EPTP too.
>> > > > 
>> > > > > Since the guest pgd has been check for valadity, for both CR3 and
>> > > > > EPTP, it is safe to mask off non-address bits to get GFN.
>> > > > > 
>> > > > > Maybe I should add this CR3 VS. EPTP part to the changelog to make it
>> > > > > more undertandable.
>> > > > This isn't necessary, and can/should be done in comments if needed.
>> > > > 
>> > > > But IMHO you may want to add more material to explain how nested cases
>> > > > are handled.
>> > > Do you mean about CR3 or others?
>> > > 
>> > This patch is about CR3, so CR3.
>> 
>> For nested case, I plan to add the following in the changelog:
>> 
>>      For nested guest:
>>      - If CR3 is intercepted, after CR3 handled in L1, CR3 will be 
>> checked in
>>        nested_vmx_load_cr3() before returning back to L2.
>>      - For the shadow paging case (SPT02), LAM bits are also be handled 
>> to form
>>        a new shadow CR3 in vmx_load_mmu_pgd().
>> 
>> 
>
>I don't know a lot of code detail of KVM nested code, but in general, since your
>code only changes nested_vmx_load_cr3() and nested_vmx_check_host_state(), the
>changelog should focus on explaining why modifying these two functions are good
>enough.

the patch relaxes all existing checks on CR3, allowing previously reserved bits
to be set. It should be enough otherwise some checks on CR3 are missing in the
first place.

>
>And to explain this, I think we should explain from hardware's perspective
>rather than from shadow paging's perspective.
>
>From L0's perspective, we care about:
>
>	1) L1's CR3 register (VMCS01's GUEST_CR3)
>	2) L1's VMCS to run L2 guest
>		2.1) VMCS12's HOST_CR3 
>		2.2) VMCS12's GUEST_CR3
>
>For 1) the current changelog has explained (that we need to catch _active_
>control bits in guest's CR3 etc).  For nested (case 2)), L1 can choose to
>intercept CR3 or not.  But this isn't the point because from hardware's point of
>view we actually care about below two cases instead:
>
>	1) L0 to emulate a VMExit from L2 to L1 by VMENTER using VMCS01 
>	   to reflect VMCS12
>	2) L0 to VMENTER to L2 using VMCS02 directly
>
>The case 2) can fail due to fail to VMENTER to L2 of course but this should
>result in L0 to VMENTER to L1 with a emulated VMEXIT from L2 to L1 which is the
>case 1).
>
>For case 1) we need new code to check VMCS12's HOST_CR3 against guest's _active_
>CR3 feature control bits.  The key code path is:
>
>	vmx_handle_exit()
>		-> prepare_vmcs12()
>		-> load_vmcs12_host_state().  
>
>For case 2) I _think_ we need new code to check both VMCS12's HOST_CR3 and
>GUEST_CR3 against active control bits.  The key code path is 

...

>
>	nested_vmx_run() -> 
>		-> nested_vmx_check_host_state()
>		-> nested_vmx_enter_non_root_mode()
>			-> prepare_vmcs02_early()
>			-> prepare_vmcs02()
>
>Since nested_vmx_load_cr3() is used in both VMENTER using VMCS12's HOST_CR3
>(VMEXIT to L1) and GUEST_CR3 (VMENTER to L2), and it currently already checks
>kvm_vcpu_is_illegal_gpa(vcpu, cr3), changing it to additionally check guest CR3
>active control bits seems just enough.

IMO, current KVM relies on hardware to do consistency check on the GUEST_CR3
during VM entry.

>
>Also, nested_vmx_check_host_state() (i.e. it is called in nested_vmx_run() to
>return early if any HOST state is wrong) currently checks
>kvm_vcpu_is_illegal_gpa(vcpu, cr3) too so we should also change it.
>
>That being said, I do find it's not easy to come up with a "concise" changelog
>to cover both non-nested and (especially) nested cases, but it seems we can
>abstract some from my above typing?  
>
>My suggestion is to focus on the hardware behaviour's perspective as typed
>above.  But I believe Sean can easily make a "concise" changelog if he wants to
>comment here :)
