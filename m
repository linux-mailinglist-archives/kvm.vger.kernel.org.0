Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0E7172DE
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 03:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbjEaBLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 21:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjEaBLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 21:11:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030D8F;
        Tue, 30 May 2023 18:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685495508; x=1717031508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AHaEjrQVljH3N6f+zhgBMbYBA7sY8UvFKfuyIL7qCvw=;
  b=dDIC13ZT7PgEtQHo5u/Aqc3xsMa+6YTRruKzN1ot/OpNE74mADROJcC8
   gnflfYEsgPHnfAZhPhXiwfdtbLugN4uykmuh85wq1QzLVLD+v4kOX8nGi
   6Omc7EXUWEj7zHiQu5oDWStRxok2fpZvwLBCb6kPQCFnUqFjOd8FWV85j
   SJ46iADieHBWFifRbn4Y3hSYVvTbsHn+707Ha8CR8p5UfCTHMehhu0PK3
   iwhK264k+0t4liV6Hzr+wR9UCUs6LOGNLBTKcDCp0qDmdEQur+wA2bP2i
   UTv22rLla54gakZziulGUmAhxO+eZbbZu7rIE6AWZ6MLT1DAkY9piTy9S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="357481768"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="357481768"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 18:11:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776561227"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="776561227"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 18:11:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 18:11:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 18:11:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 18:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILH8xQUQ8EvE0ZeCnddpo3HU79RpznS9N5j+jqDyfbOI59BsDg1mb6pKaP3t+TRuzKYrREzwkvUJ9s6TvKcHNwlzpyGAwWuOcUAAfHH1SA4Gm6RvxaqBK9Taw1hOS2aUzOSyZi/4knvTTu/M5hJc1zY07UeDEPn0SJPx8GuLOOO7FC/Ua0s32yKWQWT9AAqZL4N8DdKqEsLLsGNXYTZY3R5EhYVjdtmWb3kKZAluoZ6SLp1DkUC6VF9njpC62m0ZDGjYgf1NWCIjIuchKAcD3tjX4LALtBh+0n7XZV+qoEN12aNLYrLPKgnDCUvdM6j1fBkZa20wU1CkMywywqXrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TcqTDgTtXgTtwzoKBQcmTocmfQOob/NhgJtHj+cbdlo=;
 b=MIsgi9jnqmO2jyW3ZB1Vhy5dX9cC9Ln/io/pXxj/aWvHVF9GuYz8kur2ggkhBVpula3Zj9zo8vxr9JqYqm/yG3MJ2gyoLxNa9OnibTDDf8dS5I4Mupmb91bZn4mbpH9Bj/Qni5zvt1MbhDUGSh92pFHCMcvLHvLwuPsEZECp8JJBqI7UeV4d5zZ5h9VY7oUebStzYEB6H8zjBIdV7ZSdKWMhF3rqL1PiFL25KcA7SYaInUH9XiyinPwewtHyg2ae9+JDeDiEc3mZCaWc9E2pRGxCp5LH3GjVpIYaDCsbMOfRWffZZSu2ycrsBd5CEDdumxkWUNvg9RbJTFqvWileWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 01:11:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 01:11:40 +0000
Message-ID: <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com>
Date:   Wed, 31 May 2023 09:11:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
 <ZHXnP5bEvxPrDg3m@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZHXnP5bEvxPrDg3m@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0085.apcprd02.prod.outlook.com
 (2603:1096:4:90::25) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: a391ef12-3194-4f06-22ac-08db6173fcfe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZ2tsIzcOPYu8klBC7lSXj//a9stYPzgdl7qLfqgRq8pijL7NDnm+hhSjvMkLflf9DTZIHg2LgqX/MBOHfpK4K+S8e3AayD+GY6FUJB6P2m2sk34pgaf8MVD4OTw+rZkDcddl1AkqZHmWn3oq2TsFnsEOb7HNRsF5Uhgyn894qGEZsBSCu60OGoVkVUoqjINXyDdx1oI/oy11WN2HauXOyJ15p9TeoZlesWD17Zg4O/CQNrLjmvjCLDXQhk4ywaiNWyMAlIOTEitBOS+XoetTwhANa34/mZcjRvx15+g8y6ImSOSB5p9cYpKmFMAKyRR0TnsYxxHpjjQUJRCmKHhcYrw6WzoJ/jEw8WO7K+bddmoGb6K/ZYaDsdSh0thPeAZ+rnm3QDRepk1yHD8QC99oRkbQqyfTNg1zMHBpvLAW2XeqrFP6pnZvlhzppdUOtLYNsRBo9Q2g5Ixk7IslhdkEokRUKCz5a7GmSU4Op5tD/s4R8dNHPKJ8R3qpChSpfMf+wcfQlHp4wo1RfkTjIULLyP+KdNyg/lGVpVStD77kR0W0hbCfMT2n50pkeXE3fgM86Vo2v00Ykv7B9mcSEMPhffSG0+srvq9Jg2SihBOaoY+KKdKsZWel+T+PwBxHbKeOW3GZHwPmag48T+D1ohCzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199021)(186003)(2616005)(38100700002)(41300700001)(31686004)(53546011)(6506007)(6486002)(26005)(6512007)(6666004)(6862004)(478600001)(37006003)(4326008)(82960400001)(66476007)(66556008)(66946007)(6636002)(316002)(8936002)(5660300002)(8676002)(31696002)(2906002)(4744005)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzJpdmMxV1JBKzd2MnFNWTRQODA2aWxGaTBFK0N0aE4vem91cUF2Y2wrMjR6?=
 =?utf-8?B?SUNQQWRXMzdpYW9YdnVNbXFUeTBGeDlOL2lxOXhVODVheG9JaytWU09ydGk0?=
 =?utf-8?B?LzNrczhjd29VSU9FNlh1K0FiWnY4bVRmYmI0SE5NN01RWkN5cGk3d2RGS3J4?=
 =?utf-8?B?c2J2Mk1nRmJFVXVvWDBqemIwV1E3VHI1ZXNIVjFXRjhyYmtOQXRLVThqOW1J?=
 =?utf-8?B?RW9ndzJPNjhTanpDR0VnbC9MR29GYzE3dmhiU1pBeHB2N2t0QW9ocXJuL1dM?=
 =?utf-8?B?ZEVDa1BnUXJSeDVPVzkwaytQZCtxcS9HQ0FZKzFwS1FuaDYzQ0pUQ3VycnVM?=
 =?utf-8?B?MDd2S2thTjczV01QajBuaFNPMWwwbTJmU1hWTXBRNENrWmE1NFZBN3FhRzc4?=
 =?utf-8?B?ak02RHJBZGROL0wxU1A1UTFmMUN2Q050M241bTRaR3VETUtWdFROcDl6cktk?=
 =?utf-8?B?MEEwL3hyNGpSTWhEK3g2R0pSZnRvTDNucU0rWDMra3hHOTJXWjVGcnVBQTF4?=
 =?utf-8?B?dmJ6OGlhbkRicVljb2xLazRNcmNPeUFWVVhCQ0cxL3BpK3orbHJBN3RzT1h5?=
 =?utf-8?B?KytTVHN5N3VjdWY4RTJTYU9lZ2JHVFhTdEpJVlZLeG1hNmM3aTFZZ0hZSC9N?=
 =?utf-8?B?dC9MOE9ocEpHSVhkRzN1dm1BclIva3l1VnNGcWMzcU11aGlPbnNFMExEcXFw?=
 =?utf-8?B?K1JxNU1BTFU5Qk9CNXJsbEI4RmhiRk1mb2dwYzNQVW4vV1JEbzR3YitqZDFP?=
 =?utf-8?B?WG4rOEcvNmJrWkUyZnpra0FKY2xvYUlFdnV4S09zNVNXeGFlZFR2aFdCWmVB?=
 =?utf-8?B?YWpqUmorMXpyS3Z5T0xTNGcwbzFXT2JZOFVCVHU2WHBzR2tGbkFqMDFseXVY?=
 =?utf-8?B?UU9ic3lNcUgwNkk4NXlseHozNXliNWhRWUJLaDQ5Z2VRRHZaNElZQ0ZYbVht?=
 =?utf-8?B?RjNaNWtJNWxWaWZqNlFpTVNkbkZ6UW8zNjMrbG93VDBVK2pNNHo4VnVxcTh4?=
 =?utf-8?B?NTJ2M0VCQWUvQXQ5TzFyODVJazZwSTBodDFkcjRTTXdLb1E3c1RrU2JmWTNU?=
 =?utf-8?B?cnFVUFl6QjIwSnJpa2oxR3FyVjYvNDhWL1FodExQQVFaOUlvY1lTZjRKSFRs?=
 =?utf-8?B?MVNobXpHWGNVdmVIOU9vdDVIeVM2NUNyeEpFbzltb2ZHSVcyRDlpTG93UDl2?=
 =?utf-8?B?MGxPSlJVdmRtY01PZ1FNNTAzMjBHanJ4OTQxeXBTMFRiZGs3UUpRYS9leW1z?=
 =?utf-8?B?TjJVTE9tS3pHelZRL3dEdlNRaUJHM054RnNBaUlEbmc5UldHMmNHbXl4RW1h?=
 =?utf-8?B?V3c0L3JGZjhSYXREbzQ2RTFRRVduZFhxNU53UHFmdWJVdERRc1ExdzZsZWds?=
 =?utf-8?B?TGlGNzBqeSs3Wld0YmRLV29XRjRoRDBSU3h0RDN3ZnFoWXpPdUVyVUZoWlRs?=
 =?utf-8?B?S1B1aVFVZXd6c2xvYlpldlZVUC9mZTFkYVdlbEo0cjkyRk9kZkVUdEp0aldV?=
 =?utf-8?B?Tmc0YmpHRDlQbnl6SzFrSXM1ZnJvU1gzUFVDYWllUkpZNi9ROVMrSFBodXl5?=
 =?utf-8?B?dXdkOFMraDdaNGErNFhMN0VSMWNDbEpKN0ZiVGg2QzgrcXh4Q1g0T2VYVUh0?=
 =?utf-8?B?WExXci8zZVVjdGhrQUxpTzhodmd5WlhTYUpURHhJVjR1VUR3eUNMZUMzbDht?=
 =?utf-8?B?ZlVwSEdaKzB5OVpjM1gvQ3E3QmkzTmNCTWpDV0R0cTlDRzUvdHZWMlhRM0dF?=
 =?utf-8?B?bkduYVJMN1lLV1JzQVBRR09IaUhyTkpYQWdpTklyeXdkaDI2ZUhENmZwZExq?=
 =?utf-8?B?UXFjSVM5czEyZzBtT1dJSUVZMkUzcHZwaUZiQ21jS0s4Z3FtdEg5RldDRGpK?=
 =?utf-8?B?bUdHSGtvYmRSWUpmcHNheWEzNkpEZ1lBd1BDVDk3RHZ6ZVBTZ2Q5MEl4OGRK?=
 =?utf-8?B?U0dDTEczcVo3RktHRWNReDRoYlpUMysyaHlITXpBMGNOby9NNmprOG4rZ0ht?=
 =?utf-8?B?elprZVNMazNqRng4eUtKTWJENmhxU0JrdG5TcFZ2UDlkNWdzdFRvVmcyZmZs?=
 =?utf-8?B?eDAvNDY4U1pTOEZDd2cwTzhnZTRVbWFGT20wNTRpWlpaZE5hVXdxZGtoaDFx?=
 =?utf-8?B?dHkwbktsZGhqcHFUNUg2R3hTeW5rTjZoWmNVOWdsOEcxRnFEMm9OcGFEYUFD?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a391ef12-3194-4f06-22ac-08db6173fcfe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 01:11:40.0365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCbgi8/5Yg1F5SMdrHXvgVqdLy+0g110aZHgN828akTzKAqyhkXFzkQeFHxarbatlWfszmy0fwgRefi1IV1CAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/30/2023 8:08 PM, Chao Gao wrote:
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>> 		 */
>>>> 		if (data & ~kvm_caps.supported_xss)
>>> Shouldn't we check against the supported value of _this_ guest? similar to
>>> guest_supported_xcr0.
>> I don't think it requires an extra variable to serve per guest purpose.
>>
>> For guest XSS settings, now we don't add extra constraints like XCR0, thus
> QEMU can impose constraints by configuring guest CPUID.0xd.1 to indicate
> certain supervisor state components cannot be managed by XSAVES, even
> though KVM supports them. IOW, guests may differ in the supported values
> for the IA32_XSS MSR.

OK, will change this part to align with xcr0 settings. Thanks!

