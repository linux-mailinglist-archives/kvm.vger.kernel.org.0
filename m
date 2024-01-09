Return-Path: <kvm+bounces-5916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9BD828FCF
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F48A1F289BA
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C996D3F8CA;
	Tue,  9 Jan 2024 22:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ipMeTyAW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA73C6A4;
	Tue,  9 Jan 2024 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glZyEfEpxdgF4C+TsUTtFiiiR9Tzp1jBkEn3yr3GlXe6nPDGaH1nv5wAsOk/TJnEMl2etEWj6K/pLnxu6iYLywp/TmhTdWOeWnwgvOa4Qb4qWu53Mi1FzNAjIoz7WSuIWVzR6Kl0MZ9dmWiDNjQxNUscjqyx5fhlk/WoX4cERloejfYob7fskEvgfM2PrtcpbIILyCyrU+87JiOlBI9pv59Obam7KSFpyM3BvKwv1FgBZPyCJM3Xa8hJgbU3aGHg8GAQAiaDL3aN/bVvM9uqaPbOZ/AC70xymt0xXFuqa9doIV4eRG9Lixk9ySPQG3rVe66u1kynO6uZ0vNPrOmsFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0n6S1IhJFL+vYOedd5EP4plpcRrdfl1wNTTgjL8YbRg=;
 b=Rx6iUNCBXcmOXDq8aACWmWgGHWMU03okpiTwY33HYs/huCLM7AC99n3Sy0j72pjjhCgzew2R9ybnAkTUc3T+H9NkYKwb+o6O+N/QtWr0op1UCTJAo6LFali0nNJDz1hnrT2DH5qPwFUIv7Y1MfvN1q6A9mRWQLTLONMmlNBtg9BqKgXZFxRJ1DYBo9KvzCSfgXI8GG6yth7QKJS0QgtZysiBHZi9sUk3VpfqJJ3ZUYoXJygzc8j19KNBr3wKhdvT3pPBSDrFfuPQjzLaMGzvWwEZgGt31HbpAs2neQvJYnNpMsZdvOwPTPmnOboNdSNzH1xhpRHIDbmVGE9S1LYBNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n6S1IhJFL+vYOedd5EP4plpcRrdfl1wNTTgjL8YbRg=;
 b=ipMeTyAW+a38uAoKfbajM8/64/Zqpno8KBTunc8/7wwmEelALBoVDYvnZHEJdeou18VcSb1nJworRQJwrTMFVYZxW5OGEfTuDP7BqjTTorYDMhr35ulEh9iuLMGUjyx0H8vSRCAv7hX46pVwSA4/gNuHTFvUdZzt65TkhWYM0Bs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by IA1PR12MB8333.namprd12.prod.outlook.com (2603:10b6:208:3fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Tue, 9 Jan
 2024 22:19:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49%5]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 22:19:05 +0000
Message-ID: <5cdd2093-b007-404d-96a8-89b3aa6e6e4b@amd.com>
Date: Tue, 9 Jan 2024 16:19:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/26] x86/sev: Introduce snp leaked pages list
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Michael Roth <michael.roth@amd.com>,
 x86@kernel.org
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-16-michael.roth@amd.com>
 <f221ad9d-6fc3-466b-bacf-23986b8655f5@suse.cz>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <f221ad9d-6fc3-466b-bacf-23986b8655f5@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0057.namprd05.prod.outlook.com
 (2603:10b6:803:41::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|IA1PR12MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e0c4860-42cb-4455-bedc-08dc1160fe0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jFElfiQML6gAx3uii+bok8dqoPCGUIM6kpw51H1ISdLZXwrvJcl/kl7kcZAaFxDHdIzIMSUSa9144WRy65C8kAS4jPuO7cODA4aEAGH3SUEPl1oYp459ahcAU+KsxxFq/6PKq0Ar6QFfCiWf9Vv8WrIO8jjsgCtrtH4u1dyeRtfd3aQiR03WIgjgKrY8GwryFxwBSogXe+W8+HMe0efusizDBs098GcGnKxlcYTDR/ilxu9ic+DPxZwiwoyEHPs/b/z+PxGtfp3gkAtORUNt0aE27Hlum/M7i00Kum+bfAPzYSda539MyRGDDXLHlaIG47favqj4wcgzvG3atXDbWJ8KPXEOoayBlfQ4IoV6g4dp9DjpeG8ZDiRrd/XXF2VU5yNaOnIHhGHhepc0tLVnF1avQlwAccIsWBNFmi2HlS/K1mlF4h+ktAuvAfl4dD3YyjzHz7LrepYXfjgooqDqYaciQwBLA/hl0V8e0e1tQJtccIn9YHQ82BuOc71kuQzuLyitpow+htLkdanM3DPkAR9uTPBfOy+P0ME5zADD2MfQySbrYMr+RNHxe3KhqeQgjENuE4JJ3rE0YEdRfZ9WbLoyeQ7uMAn6C1d0TvbrKP75SuiaTLpJdB/O195FG42JGzor7HdD+AEq9WDRBdihIEd/JrYbtJvqtdkatZPJpgzfWe6GcIHnLAvqs9HDd8Jp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(39860400002)(366004)(396003)(230922051799003)(230273577357003)(230173577357003)(451199024)(186009)(1800799012)(64100799003)(478600001)(6486002)(66556008)(966005)(66946007)(6666004)(316002)(110136005)(4326008)(66476007)(83380400001)(2616005)(26005)(6512007)(53546011)(6506007)(8676002)(8936002)(31686004)(5660300002)(7416002)(7406005)(2906002)(41300700001)(31696002)(86362001)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U00vZUFXY05xMUs5aDdhZFZramZTajFmM2FDUGRLNlRLL2ZmYytlVlJ2NlpC?=
 =?utf-8?B?dVhzTHhMS3ZKQ1pZZTQ1YnM1cTc4TkNNZkZjR0ZEWjBGcVBhbTR3NSswVy9l?=
 =?utf-8?B?NnowNW9iS3hKYlRWY2hqZW9Sd2tBZHBnT3Y2aU40TlREUEpxS0dHK0c2MEg0?=
 =?utf-8?B?ZkZ6Vksxb1h4U2tEdW9vVDF0RnJyZjBlZFBXd0dWblF5aG1LRk9HTk5BSU4y?=
 =?utf-8?B?MnpkTXpaWDBKbG4yLytLNGEyc2RCa0ZHaEhLdFRkcTBhOTIvZXhVelhBQ0Zu?=
 =?utf-8?B?ZzBBWjVUS2QyZm8rYVJYQUdib3dsVjhYaVVSL2V5bThaSVl1NnVIeEVqQkJP?=
 =?utf-8?B?azBSbTRGd0lCVVB1QWcwK3lmUUlkcWhKU0RMc1pZTmlHMDdNMy9GWk1jU2JM?=
 =?utf-8?B?ckYySmNEWS9nV0NmcjVCQTVLVnRYUWJLZnZWQTF4L3dyNFUrRzRlVmsxSGoz?=
 =?utf-8?B?VlNDLzgxSDB1TThSMDAvRkJPbXZySWljWG44VGpsOVFwK0Z0eE9OSzlzSVlD?=
 =?utf-8?B?Mk44NXFvK0JaQW9yV3QrVHYrK1BabmsrUzV6SXRydGJic0RtWTNZcnR2TDU3?=
 =?utf-8?B?RlZmWWswTzJqV1VIS3d0S0Y3dDJhb0JSK04yS25JckxVdU01UHkwbUx4clVu?=
 =?utf-8?B?bE81QVpydDIzdkgyT252NHpGN0xuK2xQRFZOU0RBaGZvaFkvY25iN2VEcXc3?=
 =?utf-8?B?MzZ0QzRsYkpsdnFOS3ZVTlMySUZ4MENzdVQzQ05HRVU2KzBCYm1TaC85TWJI?=
 =?utf-8?B?V0orZFcxUnBzRjhGYXBLNmMyN1laRjhWWkJFZEdEeXVTTEo3cUJPcFRUUUhL?=
 =?utf-8?B?M3VsWEVrY05DOUFXOGcyWHdTRmJ6L3dFSkJUNDM2akE3QTkxVDNkZzhHNGdm?=
 =?utf-8?B?RnNnc2JqK3VYTEw2TVA5NUcwaDNtWjU4YU8yTlVldzJ0Zk1mb2lSUERQOUVD?=
 =?utf-8?B?Q0Z0N2JBeHRIRlBWbSt1M0hUejVTYlY3WjRnRVl1SG9ucjNyMzFpTHpWWlJN?=
 =?utf-8?B?UWlpamoyTytWVWxkZHFEMWVwbkpWQlBubHFXTVVtWk42WUZPeitmWmhlRmVl?=
 =?utf-8?B?cSsvNkhNb2lha2MyWDBSZ2RHT3ZidkpLd0x0bTc1T2ViSit4eWhoaksxMmRa?=
 =?utf-8?B?TXpWeldMTy9RaEhUYUR6SlIxZmlyTlVYYlBBblJIaW9tVTJ0SDJUOW4wQU1a?=
 =?utf-8?B?Y2FMUWNDOW9EeEJ1cmp6UlhBdDlXWSszMlRYSDEvY09Id21jM0F0MkpITkJk?=
 =?utf-8?B?OGhBVEk3aXpGY0ZyRllQYkgrY0g1ajgrUW1ueFNDNDMweU9ZMGs0MmllMEU1?=
 =?utf-8?B?TThZdnBKalp1VHZMSjlzSit1a2ZaN2VRNXRVRzlud0xETVJoK2RPcTVpTm1G?=
 =?utf-8?B?VTJNSlg5ejlEN2t2enM4d1NOQ3lIbU9JTmVjQW9WaFcwM2tYbDZqQXJKTWY2?=
 =?utf-8?B?REJ0TkxxLzMzOWpZWUM0QWEzUllQK1ZFVktCSndKVlRjaE45RlNUTnUwRWxK?=
 =?utf-8?B?RHpKRlM2SER3T25NUVR6K000VkczY1g1WTVFY3VYNmtwWVRvMDRxWVFqc0dk?=
 =?utf-8?B?dnFuU3RRQ3lWZHoyTXJlRy9IcGFLL0VzbG5YaWttMHZpUUZwaW0weTQvRVdW?=
 =?utf-8?B?OVhva1RnSXZCK3FMRGdESmVHbllGUVJieHFUNGJvaklKUEJTcHpUZmNtdjRl?=
 =?utf-8?B?OG1lSXBvcXR4blVHVlg5RnNQZTgvMXhFNHhtdXdQVWxlQlVERGVUS2NQNVpI?=
 =?utf-8?B?L3NmZCtVaDVwL2xKdzZJTEh1emxZOUllcS80SE1zSE9XQjROY0ZvWGMzQXNE?=
 =?utf-8?B?N3pRcFVBcTcySWdMdWliYzFYT1QwWUJ3bG1uZWFNaUpzamgzSy9Kak1rWE0y?=
 =?utf-8?B?VWZ0bXBGeHVpdDNJcVJhL05FWGVWMGdveXhsanU0ZXAvWit4ekkzRTk1bVI0?=
 =?utf-8?B?cFJnVTJ2dEEzV0loZWsyaWN1QjlUdzhwcExCMXRZQS95WkNVaUZaL0kwTGpq?=
 =?utf-8?B?S3dLRE12V1R3M1BGV1c1RUFhdW1QMW92NGxvTjdWeDJnbnhiUGEvZjVqK1ZZ?=
 =?utf-8?B?M0F6OXJQdTJpSTNIbWpmMDVwaGl5bEJUZnZyNm9FaWkxZTZvcnljQ2RzMzJj?=
 =?utf-8?Q?bvM2OaOt3OioNN0rx2JcyYcmQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0c4860-42cb-4455-bedc-08dc1160fe0c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2024 22:19:05.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlJmXGWhY5tCxB+ITpClkD1nGrM6lU+uWbxcxs+3cFzJ7sifpwYn74nqzPXJl6Iv82FIb3dQa4l/kzxur22x/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8333

Hello Vlastimil,

On 1/8/2024 4:45 AM, Vlastimil Babka wrote:
> On 12/30/23 17:19, Michael Roth wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Pages are unsafe to be released back to the page-allocator, if they
>> have been transitioned to firmware/guest state and can't be reclaimed
>> or transitioned back to hypervisor/shared state. In this case add
>> them to an internal leaked pages list to ensure that they are not freed
>> or touched/accessed to cause fatal page faults.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> [mdr: relocate to arch/x86/virt/svm/sev.c]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Hi, sorry I didn't respond in time to the last mail discussing previous
> version in
> https://lore.kernel.org/all/8c1fd8da-912a-a9ce-9547-107ba8a450fc@amd.com/
> due to upcoming holidays.
>
> I would rather avoid the approach of allocating container objects:
> - it's allocating memory when effectively losing memory, a dangerous thing
> - are all the callers and their context ok with GFP_KERNEL?
> - GFP_KERNEL_ACCOUNT seems wrong, why would we be charging this to the
> current process, it's probably not its fault the pages are leaked? Also the
> charging can fail?
> - given the benefit of having leaked pages on a list is basically just
> debugging (i.e. crash dump or drgn inspection) this seems too heavy
>
> I think it would be better and sufficient to use page->lru for order-0 and
> head pages, and simply skip tail pages (possibly with adjusted warning
> message for that case).
>
> Vlastimil
>
> <snip

Considering the above thoughts, this is updated version of 
snp_leak_pages(), looking forward to any review comments/feedback you 
have on the same:

void snp_leak_pages(u64 pfn, unsigned int npages)
{
         struct page *page = pfn_to_page(pfn);

         pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, 
pfn, pfn + npages);

         spin_lock(&snp_leaked_pages_list_lock);
         while (npages--) {
                 /*
                  * Reuse the page's buddy list for chaining into the leaked
                  * pages list. This page should not be on a free list 
currently
                  * and is also unsafe to be added to a free list.
                  */
                 if ((likely(!PageCompound(page))) || (PageCompound(page) &&
                     !PageTail(page) && compound_head(page) == page))
                         /*
                          * Skip inserting tail pages of compound page as
                          * page->buddy_list of tail pages is not usable.
                          */
                         list_add_tail(&page->buddy_list, 
&snp_leaked_pages_list);
                 sev_dump_rmpentry(pfn);
                 snp_nr_leaked_pages++;
                 pfn++;
                 page++;
         }
         spin_unlock(&snp_leaked_pages_list_lock);
}

Thanks, Ashish


