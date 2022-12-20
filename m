Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3918C651CE2
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLTJKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLTJKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:10:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380D16540
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 01:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671527415; x=1703063415;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=czJrqpO+h7rCRUNib9GS2yZNQ4kDCd5jcbQu4O4q6L4=;
  b=jCnaf2cEKDG+7DeSIvidaDQD4YuPmdWGDhzJqMstX3606htvDRYZS2sd
   1kO7yGfcfaxlW5sCrHMD1C3UoD9IBuJ6Z+lxKKv/cZAH3c/YXFlhsb4rN
   mZHnbkGK8X1GYBa8ExB69RPMtF+32UMI/BbNw53yzrvZwVxwUCGUEzJWW
   gZDEvBtvLV2UIicE+++mjhrm7YKwQWtCZEnW2nldJkrzb8kWCJtYytYSH
   1Q2p4Bf7623vOmEOsTFzw9fKxxu/QKEMJ0CMKsGAm1mBbx9rbA9rbAjNz
   54bBRt7yRDoTNKUG0wApuHhmt+Sum9HMi7+cMnJuGTKrd7dJBVOsnaLBj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="383913092"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="383913092"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 01:10:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="714354194"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="714354194"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2022 01:10:14 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 01:10:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 01:10:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 01:10:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gywY5Xa5MhJcqchhMwJw2KfaFfqYAB5J5QXvNr1r7Vjb+DTPlAvfFSURmRKLdH6ae5CB3feA1gLhV6dVxJr/eXubwMaxZ68How64q+OdxSIvJYLXO7f7Ccpmt36X1rDjk6nPRL1fgIM/QNDBJNBn0313OJ2x6ZmKOf5RAeXmqE0aY3R8fx6l+uBQGqieaBdh5Tq8rFF9hW+HBN/STbOKG68DDXhFl3+ivRUFZnHfUjo7BWMNb+WljE9UTaX1EJdUgvlHj/10dHeUMLEmQL+EoYsW55g8bvMIH2auBo8hwbT6ElTuKBlbYqvDtpx1/28dJ9vn6U3iPi1qyDbdTNxoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNtLXyzVRdBifZRjnxb0zofCDfAcVqGfw+zWyibhnrw=;
 b=LThTUMs7D9Sn4UW10VLOhGKWph66wGsPPYYJqFOGoeEmnlYzjr2sth/y0h88PJ5Bd3502mkyambyp+QBsY/KCefPKDqcwYUSBxE28btWFqb8z4oFccb/rhnYeUWrlEWRKtiWBRvSoIFKncyxu1r1nAeb5VIUbdbu59hGJEQQ92cfhbh3YSQTnjNtw8UnSffJCcqpPh1IMcWbgVTwZds78znxfOxrhOh0OZkNRCM32iWnJgumZ6uv0D6XVWwNc33NWmxq9EqO/CFCDmZQVEHdAz4BpQitTAPf7YOAHt+ZWbM65ncDVfmJUVWBH2kNj5iwH5TfidZlXVjkyaJtzyjHxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 09:10:09 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::3469:4423:b988:65db]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::3469:4423:b988:65db%5]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 09:10:09 +0000
Message-ID: <d9f576df-04b4-1d30-438c-7296e5b4f359@intel.com>
Date:   Tue, 20 Dec 2022 17:10:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-9-robert.hu@linux.intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20221209044557.1496580-9-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0243.apcprd06.prod.outlook.com
 (2603:1096:4:ac::27) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|PH0PR11MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e91b6b2-c342-48fa-3b3b-08dae269fe24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fg3PLIQbbTE/2MVcfxiqW60NYsnpWgBBX4++GL9cfgRLasTJYfwCmZ1aKa3HGw/3R9Mvt76dNzd2NCjBzd1ySo0mmiXa9eUI1N6egKlcwKBlKF+z8drMrC2O7UMGN7bWJ+8iFtZ9Qp5rxdzFhs+CKiKvRo7llPwtfFW0owsX9YbdKDz+empj/ExCghW1WwY69dOcreWDhPdAVdWoIV7wBMptP17kuiOTGlOuoDHHiMCDws37dLYXPQMX4O/UxrDf4mtNxvcEOIyiXcej2Nn7wSLN69ko909Yd8VUBHYZuRQPHdCSVTjVWVllkS3KgH+Y8JcLZfKGnP2sQU7fDmJKJi6QmEjjgD9lVHQ5WA4qoAeVe9xwJOck9JL/FjJGEGSyGktOpORiZrVCt4Cv6t2T1YIfOBgC6c+NkiP6hLKNAOTH/rGA4yvq7Kvd0rmPINVOQXJZY2tCGpn/Yvor8xrLN2QrMjqFKKH4amUUqOrvwPYLD9s9ZIqC7VmR41ngqlgk8OqiirqWgz6Cp0ug/HfeB0WtlFFRWeosibtD+CVgN99WF6IO+JpBMKoglMNrsRrSCKJHAgUuwOb3B700Gl7+Xa5zYilOUh5eVfHwu53ZJMW5kRNHnQt8jgdV1AAiLR4oQQ2lvXgFB8uq3bJwQBZbhusHM4WNfmJ+CbnloShS7N00vw6ShRqAvtCUyRkimblPjTLYJ9rLvD/DE/5VKqueZK44ZHG4IZ4oLidPMUH58WCSbxu7g6foK2mOAmhYtfLh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199015)(316002)(31696002)(86362001)(83380400001)(6666004)(5660300002)(41300700001)(8936002)(31686004)(2906002)(66556008)(478600001)(36756003)(53546011)(6506007)(6486002)(66476007)(2616005)(82960400001)(8676002)(66946007)(6512007)(26005)(186003)(38100700002)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckMyUFB4ZFdCdEpBM1AzSWxNTHQ4WENtZDZRVFdxZU03OW9vVVYrSWM5Wmtt?=
 =?utf-8?B?ZkM4RnFUdmdQa1NlWTd6UjVBRjRHMVRrblBHNTF4UEVNU2M1dXV0MnE3RVFH?=
 =?utf-8?B?Qi9Gd3RVZlB2MmF3eG1vekFIY0ZXSXJ0SnJFWDViK0xiN0hIbTd6dU5GSGMw?=
 =?utf-8?B?anY5eEE1YU14VmdRSitXUG1jRkZaQXN5WTFlWDF0U21qMTNad1Z1dFZRRzdT?=
 =?utf-8?B?UEFiZFFPMGo0QVp4VGxRbWJuUThaaFROUUQ2R0lwQ0xKcitKRlM1SDllYnhC?=
 =?utf-8?B?YTZVcnJrWGFhU1FFdTVTc08xWGN6OGFERzJpN1c2UVhSVVIxQk9RNWNjdmxM?=
 =?utf-8?B?NFJ5OVV4ekRqM05QRXJrQ1ZoYzdLd3A5d0JpSGlKQXdub0MwM2hQb3ppcTVY?=
 =?utf-8?B?NzFjWGVyRk01RzI2WUFVY3RiYjk0QldFMjFtTjcrRG96UFRqNWNQQ0FiL2xM?=
 =?utf-8?B?VWkzZUNxWkdRTlI0cWY2aC92MjNyZFdNakxxbHNMZW8wWVRGRU9zY3poYU1U?=
 =?utf-8?B?MXhYZmEwNnUzVnQ0ZTBFNzVaWGEreGczVkl6MWFuR2VXTnRDeTFFZTV3WGVE?=
 =?utf-8?B?cTBkQVlsMDc4M2lTcWQ2TjExQnlEaXRzcHhhZjhGTXRGRGlnN2YzUG9rS1Nq?=
 =?utf-8?B?blg4Mk44enJJVyt6R1l5SFF1NHQ0dmZqUkw3NnQ3UGVmbjMyeWI4U0FyOXNN?=
 =?utf-8?B?dzRKaWI3QVdoeGEzUUJwbGIvNHB2WmJnU2dRUDNMWGdGSmkyL1Q1TkRwVDBP?=
 =?utf-8?B?MmRtVUJheWQycllVcStvczdiU0dqM1NuMUoxc21iRXI0QWtEZ0k3aDgwanRH?=
 =?utf-8?B?M2t4TjhKeVRPVjBwMDBLUXFyaGduRSt4eWNXQjhFZlFkaWg0Y2JEc2MweWZz?=
 =?utf-8?B?ZzArOFQ1d0dHdHh1ZEFLWmlvay9IbjNrRGlpd0Fqc1VWRHFldjVQZElRM0tr?=
 =?utf-8?B?MjdLa2VrL05UMklyUEtySmkzOTJ2V3JoUXF0ZzdWcEh2b1I4VndaWGFLMGdr?=
 =?utf-8?B?SkVSUkF3WTY0azBqTjhiUnVLaXY4ajY3QStuMGhHWWFhQTNjVXJsdW8zcVlk?=
 =?utf-8?B?RlA4TFc3WStGYWEyZnZPbWt1MFVHRXlzQVhBU2xhdi9hK2tzZGpWWWQ1MkZQ?=
 =?utf-8?B?cnF3VmphQitOOE1JbHoyMXhrLy9iSk55VmIwR3E0V29zOGxTczNjdGdYNTJS?=
 =?utf-8?B?SW9ESnBuV2o4V0FyLysyNWc2eFY1VkxrRVFsUEFoNFUzaGJNMTAzNVZhTDlP?=
 =?utf-8?B?RGovM2JvTy9nSzVzdmhpK0hQQmlQSjNRTHp0R0dUbkZ6Wm1uc2xmdVFWeDZ4?=
 =?utf-8?B?bXNSSm1QOXVPbUVQM2x4aDh0NDBJeUUxRXFhT2hEN0FTUHlhT1hYRmZkMXVE?=
 =?utf-8?B?a2dYbVBhRHl3UkYyK0VGNzVTWC9uVllKdHcwdmxydmZxSFBCQ1Q0bXU5VEht?=
 =?utf-8?B?eC9Bc0VOVHFSRjBuS1dmdnFDMVdYUWM2SUtPUzlZT2h5UUhnTWtrOW05RzRr?=
 =?utf-8?B?RTM1MUlndTRyRm5SMGtnMThpZXBsNkNLeS94VDAvUFB3YUE1R28xc1RNNW8x?=
 =?utf-8?B?OG9vdHZyYkpOMUQzaVBHQWhoU0pzRGVDTDlWSlFoalNxM013a1ozcjBHODEw?=
 =?utf-8?B?SW5WZnRQMFkvWi9FTVpXa0twcnZQVVFlSWNPRGxkY3N2T3JnZU5EOEV4T0hm?=
 =?utf-8?B?cW9nbml1MEVKZ2Zka2I0SERDb1VHbHloZFFBbk9IblVOWVdPVXNiM0ZBRndy?=
 =?utf-8?B?TkM3SGhUWU15NzAzWVNNeFZKRUpsN2RMZHdFOW15ZmtOWlVOQWJwcFZ3Y05h?=
 =?utf-8?B?YkF6QmRSVDJ2ODNUUHVYcFBHNE1LMW0zZmdRR0trYUduSm1TWG5OTmhMUTRS?=
 =?utf-8?B?MFJSUDJMYjdpYS9GR25RbTNXbzA3V1M3WmtCK0o3WXVvRktMSzEyS2NYMjU0?=
 =?utf-8?B?dXdoRW1OcnVOWk9zWkFOQldOYy9yZXJMVDdrQ1JTeDIycGdtVmF5aytFY3Zh?=
 =?utf-8?B?OHFRQWJIdXpwY1I2ZC9Bc2I2RjBwekpqRVJ3M1V2ZGdBQWNDYXhjaFRzSmtF?=
 =?utf-8?B?SmhTU2pzTDlIVXp5UDkyMVFrS3hMZk5TUnVWeTFxNlRCR2swSHorRTRqcE5h?=
 =?utf-8?Q?ANd3hdX2HnyJ9/K8Tll9PENCv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e91b6b2-c342-48fa-3b3b-08dae269fe24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 09:10:09.2389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGRSJyn6xSQPy5f2ST3wkLpXSmIwoQehcxIzp5p4js0gPWtAt5zFLrOosNoVli2TC700rBKWtZCaMcY/ZKARqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 12:45 PM, Robert Hoo wrote:
> When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
> will build new CR3 with LAM bits updates. No TLB flush needed on this case.
> When changes on effective addresses, no matter LAM bits changes or not, go
> through normal pgd update process.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>   arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 48a2ad1e4cd6..6fbe8dd36b1e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1248,9 +1248,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   {
>   	bool skip_tlb_flush = false;
> -	unsigned long pcid = 0;
> +	unsigned long pcid = 0, old_cr3;
>   #ifdef CONFIG_X86_64
> -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>   
>   	if (pcid_enabled) {
>   		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> @@ -1263,6 +1263,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
>   		goto handle_tlb_flush;
>   
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> +		return	1;
> +
>   	/*
>   	 * Do not condition the GPA check on long mode, this helper is used to
>   	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
> @@ -1274,8 +1278,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>   		return 1;
>   
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +	old_cr3 = kvm_read_cr3(vcpu);
> +	if (cr3 != old_cr3) {
> +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> +					X86_CR3_LAM_U57));
"CR3_ADDR_MASK" should not contain "X86_CR3_LAM_U48 | X86_CR3_LAM_U57"
But seems it is not defined explicitly.
Besides this, looks good for me.
Reviewed-by: Jingqi Liu<jingqi.liu@intel.com>
> +		} else {
> +			/*
> +			 * Though effective addr no change, mark the
> +			 * request so that LAM bits will take effect
> +			 * when enter guest.
> +			 */
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		}
> +	}
>   
>   	vcpu->arch.cr3 = cr3;
>   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
