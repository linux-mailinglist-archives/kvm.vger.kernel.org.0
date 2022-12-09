Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D2647DE5
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLIGoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiLIGo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:44:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4258075BD3
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 22:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568256; x=1702104256;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iwSH3CkeVmDjzsCegN33YCcBTeyMQPhgJ1I5Ga+tfFY=;
  b=nQzwP1suIMOv8nOUmFJerwar7q9ODvivleVCPuSZKP8HomB5f0KQbcS3
   VY3tc08DAgIo6Xug7ZMchOuUH8Y/+qgKIjFJlG90wgGu1HcM7yA1PLJhg
   PsA2jdXUbLFD1ATnzTV0PzafwMDn0yhRwvyDWKV1ypMp7DZDe1URbESfT
   /XKVih02lbIlMAjslAaXn93tOWf07xLRKoTESxjVf2C3KGDUMH3YdtptP
   JhZFhqvwwXF2K5gq/7ZYCGedB/u0+6rLdW+LdOKPh0nfriQKerLyC6hmo
   74GBMxZKjUrc5W+rEvGVeSga4jB2dTnAvXNiDcXfESmeTjbly2ssRva0x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317421261"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="317421261"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:44:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753917159"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="753917159"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2022 22:44:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 22:44:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 22:44:10 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 22:44:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3LMmpvG+dXjorLvY1gnDENcPaWcLu++amP0bXde7OeMDSMr+J9tdrpAadSRkakVjMJ6XFHnChlmrI1AuOBWI8xc+f7D2dKF1Y96qKfJXRd7PnZzh3c4UFO9njxkuJgevdpbA3CcmBmcB44RYoRNDq1OV9LxsnL6I88YLcbQqR/66S7SLrDkFN9vww8B6Qsq7rFCDsLRPvlxtgiqrK4dqdwzQMBhCZc8cvXEjlPpDmybWMD7CIeRM81SD4QVwtXq1T0MyFU4gE8f4MTO2QNSUpaxillEFtL+0frU0emmhQK+45242JK8pA8aKbGiG/eDpjq7bsmrKa2ArQCUJBbfFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKrT4auWHI/wzQnfPFguqTa8thi1Lrz5qlol0PuYDLs=;
 b=X7s8/DlWGLgOPVnNQ6ySRPPBKDRVbkRDEJTTlNjiF3m7ekC9lTCUnoSHJcBykUGTB1VI/7WDBp9dvVN5OTgI9/gPTFteQrJsqPFRbHZCNECDPBcCjTSzSOK/DbET+X2lCKiPbm41DM7kZhp4jHdvok+ezo0zsr7yoUJudyTiZVJd6JJcFjC07wq75eiVFxxIVCJnajigf/jxnp3qvRRFqbKFpBtvyHIkfckepN5tGp+DqmfuhvaMQvbDo0Xqpgo/uDGtdQyIZN9kHXZMQh0lEr+AS9J7XKaeI+BZS5WRf7mQg9BRqDQWq4SOqKA4ISdeZRJaaSyQV9/0SaENI6l9pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 06:44:03 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327%9]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:44:03 +0000
Message-ID: <c920ff81-0231-b70f-5ede-b1085c583086@intel.com>
Date:   Fri, 9 Dec 2022 14:43:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 4/8] target/i386/intel-pt: print special message for
 INTEL_PT_ADDR_RANGES_NUM
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-5-xiaoyao.li@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20221208062513.2589476-5-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|DM4PR11MB6117:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a095d6f-7284-4c08-189f-08dad9b0c26e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9R9jQT1tmv2+Ih899zB+ZIPoqzkuuMk9W8DPY6ydzU+YyXIhxxs5OZ3gsLC3b/bbSVOeEno0xRId/v/NjzVFCLL0NYivfRsoxhUq+9ujo7dViKLzfEQ+k+Pnsu4aq7iul8VoRu1fWsyi6TzF/xLe75j1+1vDY8EIn+1j631Ichq83KQgQfS7+lu1V18IkU+Ois7g3zRRPkzsbjlt5r0kSqV3pbSi07WpgwjvB1lAimZBbzRTwEOPh8v3wwPTVXtcgWJKrVa/CPfrjQ03fsIBBZYD0EyADtJ98RU4Njkovlbs5U5FWaj/8S50MPV3luzu1U4LvLXv2Sk6pbCJdtc4VTclNEe3ZLPEh8fQnDkAu2tZYPamH39LVXaSk/86ZUs6/4KlpBsvBRaZMyBrUAng8TFdOzEvofXReGMhNy4+SOABFGljZzvA/9xhuAKu1Nzq10ujwOAqh1+8Vl6nDLmsJJO6p1JMfhlhQ95H6QsS6rysuu1pwNsKPF7JG+YBkLXh7RRVSKKBVvqqMJ/plAtoisoRUk6XK2VFc01UsoqA7Ja+yqcdoQAGQw3fQltlq7Ckw2roD+qwfljiN3LbfZWFNx2qHMZHcNF++VlYRS8hnKJ4i5RCeUKn++mykYb0Gzwcnj1MmjM7fNELdv0vjYP7nYnqW9M3m6dPKWLGBNYYPtBlUf9c9o1hBbKHQPgyuA8DJn6tBdUAyndZ9ZdqzniLJAfd4bL/OhDwaxZG4LLRV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(31696002)(316002)(110136005)(36756003)(86362001)(8676002)(66476007)(8936002)(4326008)(66946007)(66556008)(82960400001)(186003)(83380400001)(38100700002)(6512007)(478600001)(2616005)(26005)(41300700001)(5660300002)(44832011)(53546011)(6666004)(6506007)(6486002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RURkYWt6OTlnTlAyNWt1NWZjeGlUUG1uTTg4VjBvcEJrMXlncVVuTk5MSGEx?=
 =?utf-8?B?MGMxR2Y0dGMyM3FoZUhiQ2tqSUtDMWZLajRubGx0SEQwaGN1Q3R5R1dJdUtG?=
 =?utf-8?B?djA3T1VFeWFlMDNidGlib29CNzBGckZUQVVQN3FVVWh3YmV3VEdEQ1dveHZX?=
 =?utf-8?B?ejdGU05IWFhGOTFSQ2cwWTdyWnNWVEFxOUx6NERGZHlQa3BHTlVvNGhrRU1S?=
 =?utf-8?B?RHJDNEsrRDRsMXdiZ0s1NzMrQkxBU2xrSVFsbzBZaDVNclhjLzZMV25LY3ZB?=
 =?utf-8?B?WEZYU2FxKzJUdk1qcWFQWXh2WUwxUjZoSXBLMzRjMnh2RzVYVUtQWDhYTzdj?=
 =?utf-8?B?U0wwNkNFRytLME1GZXI1L25LczFZTW9udGw3b2FuRFVnb2tEbVRDMWo1dkZu?=
 =?utf-8?B?YTl5MSt2REJkSkxBWFV1NzZ3NU4yMnpiNDRaRU11eHZ1NkRacUROemJqVkho?=
 =?utf-8?B?TkV0TmNFSEk3VnVoVDJhMXNZbXFMWkVpZ0FCSEp0dFBHUjhmVnVIU1RGRlFT?=
 =?utf-8?B?TDBDaUdtcEo3Y2tQVFFKbCtlQUF6MG03OXNFVlYxR2hZV3F0eXZKVXd6L0VJ?=
 =?utf-8?B?em9tK21NeG1TTkdvbGlLZmg5UXlTRVVvdEpiNVZLRzVIYmVsT0phb0V0Znlh?=
 =?utf-8?B?Mnl2ZzJOenhXek1sNkRsTjdqcllaYTE3dytXWG8xWmdLb1NzbEwrcmlSS1Nq?=
 =?utf-8?B?bGprbWRMbG9RQWFVMXphQ1FFbWVQeThCQ09TZUIrSDVFYlpSODlRbkwwdHBT?=
 =?utf-8?B?L2xlNnlFTzZzbEgwa3ZMdVg2bXo3WlNHWVpTaXNITWcvTVM5VTYyd1NFNjhr?=
 =?utf-8?B?a29vL2EyS1hLTGFzVTRVTmJJWEJnY0NPa01YK2NTUkdnSFRCRDVERllycVpW?=
 =?utf-8?B?Mm5jUEtRSmx0ajlwZ2VlMXBabkRET3REQ1Zsdzd4WHV5NnVrMXlpV0MzVU9y?=
 =?utf-8?B?RlB1dWtya1VuWk1QemdtOEIwYitRblJnQjBqZ2M5dDNRcVZORmVoOHYwNkZt?=
 =?utf-8?B?QXhJNE9RV3FDMkV5UGZTVkFQOVV6Ylc1bjE5QWRWWCtnY284TmVTdkJ5MndF?=
 =?utf-8?B?NHhraGdTMm1qVkJtY2ptRjBhL0hnVG13dURsVUxwMFVQVmtWdFAxZzBsR2RP?=
 =?utf-8?B?WUNLai9xU3BJUjdiU3Bpc0xUcFhmWFRGRE9QM2tINGlEKy9qZ2ZVYW9xelNu?=
 =?utf-8?B?ZlNNV3ljMFJMSkZkN1Z2SmttcjlHV20zNllPVTlTekkyeC9HdUNzZTdhQXVT?=
 =?utf-8?B?Sldua09zcW8vZlNndW1SWGhLc3BFR2FMNFc2OUE3Tm1lL1FHMWIzK2s5UTVR?=
 =?utf-8?B?a21kNjhRNUJYOXphSDM4Ulc3a09jN2ZlOUtNa29KbTJxQ3YxY0pONldVaW9L?=
 =?utf-8?B?Sm85QVpqK0U4VERXMCsyalVqbldYb24rbHpyc25EbDE2UDk3MjhYQ1NoNkI0?=
 =?utf-8?B?NWpsZlNNazFKYzIzNnM2TWxnTUltN3BndlEzQWI5VlZ2VkxhdExwN1pnWjhP?=
 =?utf-8?B?eHJVZXNnSTZ5TDZEa3JzbytjWFNTQTlNTEhaaHBUbVZic0dZeGhrOEF5b2p1?=
 =?utf-8?B?bWd4WUhRTmRvUGljOFZPNjZZanRKeldUWHgyWG96Mkc4R3FHRWZCZXk3dVdV?=
 =?utf-8?B?N24yZEVOM3UrVk9CWkRPVVVxY3VNekU0d0FlTXgxbS9zbTNiZXRvT29DMnRv?=
 =?utf-8?B?WEdTQ3pYbWErcnJnREhESWFaUEswbEI3eWxadVRwL0Z1cS92VFBRSUUxUFFi?=
 =?utf-8?B?dzkxSHQ0VW4rRk8zVFRmQ2g2dUZvRDVyKzZMcGdQNk0vb1JpU2oyYlE0S0pD?=
 =?utf-8?B?aCs4SFZLN0dPc0RranN5aUNNbVB2RXRjbWoyUDFoV0JhcFBLNGlqVGtNeVJo?=
 =?utf-8?B?blBvT1E1K2VUSEVzSFVIbkdTTjZTWGllK2pxT3Z5U25KSEpaTjlHdktyOEVT?=
 =?utf-8?B?ektINDNoNnhTUjJSM0hEVEE3cTQyREcyK25VcE1GdHVLL2dzTGhndWVUWHRV?=
 =?utf-8?B?WmpIQjdFNXVwWDZsNDVJZTl0cG9JdkZTUURmenlVaC9EeFE5d3dyeUJNSk9C?=
 =?utf-8?B?NWlDdWZORHhRUVd1Qitza1l6VzMxZjNFWjVCNk8xZW9OUGZUOGg1WWlYLzhJ?=
 =?utf-8?B?a1c4bDJpRjFUZ2k2WjhLWkh3TmM1TUxtSVRBeFFSN2p0QnB5bHc0dHIwczEv?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a095d6f-7284-4c08-189f-08dad9b0c26e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:44:02.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVdfmiuexf5ITbOeckj1rMysICaWOff0Ug6cd6khCaMfzfBbIycqtEiQvsDjylf3l7NK3tVdBqV7fUumZWXtYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6117
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
> Bit[2:0] of CPUID.14H_01H:EAX stands as a whole for the number of INTEL
> PT ADDR RANGES. For unsupported value that exceeds what KVM reports,
> report it as a whole in mark_unavailable_features() as well.
> 

Maybe this patch can be put before 3/8.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 65c6f8ae771a..4d7beccc0af7 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -4387,7 +4387,14 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>          return;
>      }
>  
> -    for (i = 0; i < 64; ++i) {
> +    if ((w == FEAT_14_1_EAX) && (mask & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
> +        warn_report("%s: CPUID.14H_01H:EAX [bit 2:0]", verbose_prefix);
> +        i = 3;
> +    } else {
> +        i = 0;
> +    }
> +
> +    for (; i < 64; ++i) {
>          if ((1ULL << i) & mask) {
>              g_autofree char *feat_word_str = feature_word_description(f, i);
>              warn_report("%s: %s%s%s [bit %d]",
