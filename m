Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5F75A899
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 10:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjGTIEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 04:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjGTIEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 04:04:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C52110
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 01:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689840269; x=1721376269;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=39Dggp7enhFoo7MLdXUlaWl9MJpPoloAlRN1UplYTLY=;
  b=T77mNDa5VbVSSLymkF6L/ONGHVWuMg/xwqiASPSH47GB5A4Zm8utfeok
   YxWJy1hty/X3V+cJG61hgCIQ3ReEc3xlugIH/aZ2iBfZEJ3Ho27YGz2/u
   URUblMp6Ycb3MicILnTHXRHERn+rdoAz3zauzicnjl87v12tZkybqA7Hn
   ZTpyP1WCRAMO7jqJgvPY/yIr13sYhoV2jYc0j3iSiuGvUvloZlXjqbKjN
   UXBVhT/DYZR6YNEWgiSpHd93V1AbnmhqCQVZgOXDupelC9IvzVjF5ky6w
   kfJmMRiPGdpHJCuc7Zj8JdGw7PmxNKgijpsK1WqyK4vKpkdKsCey5vGUv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346257552"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="346257552"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 01:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="898196424"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="898196424"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 20 Jul 2023 01:03:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 01:03:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 20 Jul 2023 01:03:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 20 Jul 2023 01:03:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+PFT4JFlaxQ66ueRP5Z/SWat3Xemj+/mHE5/ndMXaSFkF1ypqomvYf6WAZc/QweHjycCzRc2F4WXy7g3iTPNx/HuNQzMOdWRqnIUkzVTn1bBFa8NxFScG9FQ+4yoBTEDMDu3+CCxYSBfxdmXRS65ppWGcj4DYFGwhF7YCMzb9b1EeaYH3OoGSjfhvvXK17zKJ3BisuAz9ATunk3/T7myMI7Bl3wUyr4EfGtwQtObP5oknhyZSMUPTAoHVlNa3Kug9b71joBxJShBoOtRDrRynCyo60AwYolcHFDujajP7lZC95wNp+3PYOQCNc8P/+fMIAO5kWoeYcf1uTQC+IHDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tghiH1N7QMT2znCVYznLl7BvTo9GQhGwEF8usQohsOk=;
 b=RkvUq5dE6XqvoXq/vBwPDJgEPx764l2YjTWuIF/xdkr0q546cJ0b19pjvRaYMcHY1Sp/MK6CuZOn2dcZGwdGEWqOyKKSx//GmX+OrKq/t0GfRNoaZhKnfHYbZkZ0MRx/ZPnM3w3KYikxqDxwWZJ/LC39HtSWWz1k3m/H5R6PHArGzauwiN3Q2C92nmjxArJeSNlhqXhegKXAoOil+NEAzaf+qU0+uVaNia9eI1b7v33AEZ7a2aeVcGUmhtIeuuCkoWwrKSNxeUkMa8dPfSoXnAHXfZ+gfzBhBt36OqgpJd5nAFtMrtnZ2wRJYcrvsICwsiDFZreMHKEUwiN6es0LAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA2PR11MB5065.namprd11.prod.outlook.com (2603:10b6:806:115::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Thu, 20 Jul
 2023 08:03:43 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 08:03:43 +0000
Date:   Thu, 20 Jul 2023 16:03:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <ZLjqVszO4AMx9F7T@chao-email>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0025.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA2PR11MB5065:EE_
X-MS-Office365-Filtering-Correlation-Id: 9daf9937-d932-480c-6d3d-08db88f7d587
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxzDvGOlcBtEc3VhMdWWJofl62GZAw8/cIZfXHpnNWeOj1LP7eD3Kr/efhfTg0pt+o4NgWsXQiP7O7Sj9ykCYelVYxtTqgy2NahST+R/il6ehfAy0b/f1/UAZ+gS2OonmGuXldRoZfDhPXt8Zi+bWj1oMvfFkc4KGJWUYh5tJurM6vohFVRz8SSoFwegYcUDyaKj2PWM34shBTJygRlz71XHXKH1SQwneY6fKyehshDz9JDYCj9EdCHj6uKEMBXqc6NJkg8Bsy9BPzj9KSd2D7si5qcgI6yFG9JIdBBU+/9cm+CmM3DirDke/pmo208q0mJxIIHUubMIoeIM4jNs3Pk92zP5A84VhmkWh+x5CAODGPX8aON6IlwE2yykk60M1hG2BREGsLJMKhJ4GqxcdJPlEtKxrAvPvSDZe5A18qy9//ZRoraqLMu1jnswE0q9Dvh3SpX1ndfhCM3rUDCg9RunZmrjeV4OOKqPz6jv6TrRsMvYveJKgI4u6ftQ/4iHNcw7cG1mUtaRvVcFD3pQyjWtIxXbGGezem9L4cQMXq9o4QWrTq2BQZw9uk3hbMKYInspnf1iK1oFp5e3Sgg7hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(9686003)(6512007)(316002)(4326008)(6666004)(6506007)(26005)(41300700001)(186003)(54906003)(5660300002)(66946007)(66556008)(66476007)(8936002)(8676002)(6486002)(966005)(6916009)(478600001)(44832011)(83380400001)(2906002)(38100700002)(82960400001)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE1lNGJURmltVjRHaGtUclFHTG1RWUR0UWN2NVBGL3RlTUJ0c2ZVVkxUd3Jl?=
 =?utf-8?B?b2hEQjRjNTJmbkJxNFJDVzBCK2szRHVGSCtoRHV0ZDkyc3BucjF2dHJPdW5K?=
 =?utf-8?B?UTRKU3FlMDBwYnR0TkdpZGFBbTVuOW9odEtQNEwxODVQb1NqMzN0bmt5VGEw?=
 =?utf-8?B?aHFyZ2xNc0h2eG9RRHlpMnRIZHdIMXkzRkFQeUM0ZGxXR3ViMHQ3NlhDYVVw?=
 =?utf-8?B?aS85N1FhdFN2Z3BKODIwcno5TWc2NE5tekRjeDRQOE82VzZlM0VVRjJFVm9q?=
 =?utf-8?B?bVJGQU1XWHIvTjl4cDB0ak5uWVN1RzI1L3IxdW9PYVQ1clJhdjA4QVQwWTBE?=
 =?utf-8?B?OFAvTllzaTd6SUlVR2d3K0xnTWtKRmN1RmZoQ0lwVWRaK2RMT3NoTCtiZVhT?=
 =?utf-8?B?M3J0S1R5TkVqZ2lNZXFWMVNObmxOYlRmNDZ2R2x4eTBWbWxaeWxtT0FTYTc4?=
 =?utf-8?B?RFVGZUFqL3AyTHBBWVlwR0VOb0hlRG05aXBsdTZUZ2Y5OFZuS0VSVHBubDBH?=
 =?utf-8?B?Um5OWnYzQzlFNllOQ2xrTnNpZnV4VlRobkZHL2V5QXNLUFRnWUpqcGNtN2J5?=
 =?utf-8?B?WjFySEducDA2L2l5ZzVDbWw4OEVobkZNSHh2NVFtMktlQmNOaG5aR2c2K1A2?=
 =?utf-8?B?V09DNDJKTVFkeVNRRE1neEhBcmdXQ2dhVWNETTBjSEsrVjMzckM0V0YvakUz?=
 =?utf-8?B?Ni9ucS8yY0tNZ25iOGJoc1hmTWRHbmNSbjdqYmRMOFV3T1I1WnhrTGdUMm5r?=
 =?utf-8?B?ZGJGRlhzR3l6TWhvN1gyOFVOR3psRkNydStON0U4RHBIQXN2cnkzMDZDeUNp?=
 =?utf-8?B?c2pZenpra2xzRVh2TXhmUGxTMmRvSU1uSGhSM0huS2dBOFVpK01sdjdmeVAw?=
 =?utf-8?B?WFB1OVRMT21ySWlpR2JtVVRkU3FabG5OcEFobjBVWjIvbzAwUm9aY2lVdm1n?=
 =?utf-8?B?OEdxTlhpUEI5NVlDQU0vaWVRMjF2OUs0QWJXZHVoVERIMjRTWmg3ektrcXVt?=
 =?utf-8?B?a0dLSjdKTC9kVzR0RXJQVkNxazJDZ2pNendPa3kvc3JHY2t4S3ZsZjBjRkVn?=
 =?utf-8?B?YlRDL3ZiaGZjVGtTMitqMFE1Q29RMGpoKzNSeW85OHBGWUNGb3czZ2VyTlBH?=
 =?utf-8?B?akE0RzlCaUlmVDdZQnJJeTgzS1pPemNHaXJ4QnBhS1VCSjZaQjc2aDNMTE5o?=
 =?utf-8?B?YkhsSzhJcXZkcjNUQlNpWlBPZXFKaUxRdnRQaGJldHJXcmwrRGNvaTM0RXVu?=
 =?utf-8?B?aURERDVtdVk5L1grdzVVUlliQ0krYjd3SnRuRTZjc0o4MUtGZnBNTm5wRzlH?=
 =?utf-8?B?ckZGcDM5OVFzeHh5NlMvcUtvWG1CK21TOUw0ZHQwUFJNd1o4U1ZRSThPWEpX?=
 =?utf-8?B?OExXSldhdUU2RkxsZk9YbnRyVk9LbVROUDh2Zm9HeTlrcFlpYUtjY2ZKbEc4?=
 =?utf-8?B?NTB6eUJ1dk53N0tVRk9idXVCTnVlL0JDQ0ViOXRGdGgxZGJqMzNTQTdJclE0?=
 =?utf-8?B?anhrMjZ1Z2hsMzRNNDhjcEM0RUlVMmxYYWozMy81LzhhM0V1T0drS2xMTkNz?=
 =?utf-8?B?M2lQTUFwdVVIT3E2SjUrUEVjQzZKLzBZUGE2VUYwS3JIaWJtbDIvUUQxeGNL?=
 =?utf-8?B?MzEzWWhwcmRvSTZWMHlQb2ZEdXZvTDI1UkN4cVVOM0dLNkNROWMzQS8rZFlv?=
 =?utf-8?B?bU12bVpWa2FEWlB1TFhINDNjbzg2QU5ZVTBUY3MrMzZBRk5NSUo4cXVxdy9m?=
 =?utf-8?B?eXRIQ3hORkRueG4wd2ZlQ3Y4T2lxWjdQazl2QnRWblNUbU1oQXQwZTNJdWF0?=
 =?utf-8?B?TUdiYk05dExTOGx0cUpvMHFhcmUrU2p1RXovbE02SDNmS3NCcmJwRTN2RktB?=
 =?utf-8?B?SlQrKzhndm8zOVhvL0h1STB5M2Y3MlN2NzI2a1JldHYyWjhKbW4wSFJFZjB3?=
 =?utf-8?B?VlFkMWxMRW1VZnNRVzkrVEtyYWtub1R3WjE2RDBPTEZuRDRub3V1NUFPYVM5?=
 =?utf-8?B?djRQY0VMVmlLNWFPTlBkR0JOUC9pYXBIb2pSYkM2Zi9JQUJ1U1h6MW90QjNz?=
 =?utf-8?B?Rml3RXM4ZWlhemVsRFdENDRaSTJRUmdLRDl6V1l1c1pxZ3JtdDFCWGZtOEZH?=
 =?utf-8?Q?1ByYcSh/0njfIEerBB7s3COOw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9daf9937-d932-480c-6d3d-08db88f7d587
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:03:42.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unBWyeF0Rmo411hUp/QbZSx/j7Bhv/+Ly3yc9rFXzpR5B9F8UOIMjk8z9Or9WvcGqg8nc7SBx+O9hSke5hHn+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5065
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 09:04:58PM -0700, Jim Mattson wrote:
>On Wed, Jul 19, 2023 at 6:58 PM Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
>> >On 7/20/2023 2:08 AM, Jim Mattson wrote:
>> >> Normally, we would restrict guest MSR writes based on guest CPU
>> >> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
>> >> the case.
>>
>> This issue isn't specific to the two MSRs. Any MSRs that are not
>> intercepted and with some reserved bits for future extenstions may run
>> into this issue. Right? IMO, it is a conflict of interests between
>> disabling MSR write intercept for less VM-exits and host's control over
>> the value written to the MSR by guest.
>
>I've clearly been falling behind in tracking upstream development. I
>didn't realize that we passed through any other MSRs that had bits
>reserved for future extensions (virtual addresses don't count). It
>looks like we've decided to virtualize IA32_FLUSH_CMD as well, even
>though Konrad had the good sense to talk me out of it when I first
>proposed it. Are there others I'm missing?

MSR_IA32_XFD{_ERR}, I think

SDM says:
Bit i of either MSR can be set to 1 only if CPUID.(EAX=0DH,ECX=i):ECX[2]
is enumerated as 1 (see Section 13.2). An execution of WRMSR that
attempts to set an unsupported bit in either MSR causes a
general-protection fault (#GP)

>
>Philosophically, there are three principles potentially in conflict
>here: security, correctness, and performance. Userspace should perhaps
>be given the option of prioritizing one over the others, but the
>default precedence should be security first, correctness second, and
>performance last.

I am not sure about the default precedence. I can name a few other cases
in which KVM behavior doesn't align with this precedence.
1. new instructions w/o control bits in CR0/4
2. CR3.LAM_U57/U48 can always be set by guests if KVM doesn't trap CR3
   writes, e.g., when EPT is enabled. This case is identical to the PSFD
   case you mentioned below.
3. GBPAGES*

*: https://lore.kernel.org/all/20230217231022.816138-3-seanjc@google.com/

>
>> We may need something like CR0/CR4 masks and read shadows for all MSRs
>> to address this fundamental issue.
>
>Not *all* MSRs, but some, certainly. That is one possible solution,
>but I get the impression that you're not really serious about this
>proposal.

I meant we need a generic mechanism applicable to all MSRs. There are up
to 2K MSRs (MSR-bitmap is 4KB). Then adding a mask and read shadow e.g.,
16 Bytes for each MSR needs about 32KB. I don't think it is completely
unacceptable because, IIRC, IPI virtualization takes up to 64KB. To
reduce the memory consumption, we can even let CPU consume a list of MSR
index, mask and read shadow, like VM-entry/exit "MSR-load" count/address.

>
>> >>
>> >> For the first non-zero write to IA32_SPEC_CTRL, we check to see that
>> >> the host supports the value written. We don't care whether or not the
>> >> guest supports the value written (as long as it supports the MSR).
>> >> After the first non-zero write, we stop intercepting writes to
>> >> IA32_SPEC_CTRL, so the guest can write any value supported by the
>> >> hardware. This could be problematic in heterogeneous migration pools.
>> >> For instance, a VM that starts on a Cascade Lake host may set
>> >> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
>> >> CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
>> >> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
>> >> IA32_SPEC_CTRL to its current value, because Skylake doesn't support
>> >> PSFD.
>>
>> It is a guest fault. Can we modify guest kernel in this case?
>
>The guest should not have set the bit. The hypervisor should not have
>allowed it. Both are at fault.
>
>I'm willing to bet that Intel has a CPU validation suite that includes
>such tests as setting reserved bits in MSRs and ensuring that #GP is
>raised. Those tests should also work in a VM. If they don't, the
>hypervisor is broken.

I agree hypervisor is broken in this specific case. I just doubt if it
is worthwhile to fix this issue i.e., the benefit is significant. I am
assuing the benefit of fixing the issue is just guests won't be able to
set reserved bits and attempts to do that cause #GP.

And is it fair to good citizens that won't set reserved bits but will
suffer performance drop caused by the fix?

>
>> >>
>> >> We disable write intercepts IA32_PRED_CMD as long as the guest
>> >> supports the MSR. That's fine for now, since only one bit of PRED_CMD
>> >> has been defined. Hence, guest support and host support are
>> >> equivalent...today. But, are we really comfortable with letting the
>> >> guest set any IA32_PRED_CMD bit that may be defined in the future?
>> >>
>> >> The same question applies to IA32_SPEC_CTRL. Are we comfortable with
>> >> letting the guest write to any bit that may be defined in the future?
>> >
>> >My point is we need to fix it, though Chao has different point that sometimes
>> >performance may be more important[*]
>> >
>> >[*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/
>>
>> Maybe KVM can provide options to QEMU. e.g., we can define a KVM quirk.
>> Disabling the quirk means always intercept IA32_SPEC_CTRL MSR writes.
>
>Alternatively, we can check the host value of IA32_SPEC_CTRL on
>VM-entry, since we have to read it anyway. If any bits are set that
>cannot be cleared in VMX non-root operation without compromising
>security, then writes to IA32_SPEC_CTRL should be intercepted.
>
>> >
>> >> At least the AMD approach with V_SPEC_CTRL prevents the guest from
>> >> clearing any bits set by the host, but on Intel, it's a total
>> >> free-for-all. What happens when a new bit is defined that absolutely
>> >> must be set to 1 all of the time?
>>
>> I suppose there is no such bit now. For SPR and future CPUs, "virtualize
>> IA32_SPEC_CTRL" VMX feature can lock some bits to 0 or 1 regardless of
>> the value written by guests.
>
>As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] is
>such a bit. If the host has this bit set and you allow the guest to
>clear it, then you have compromised host security.

If guest can compromise host security, I definitly agree to intercept
IA32_SPEC_CTRL MSR.
