Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3833740CA1
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjF1JZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 05:25:07 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:7776
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234245AbjF1JEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 05:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UATYBZ4SI2z/OaeJ1Md5yZ8tlBYQ988KMt9ZFyNH8uACscohwQupIwj88UByc9NO5QKs50yocgm3Tan8h40NcvWuZJGAplv9Joue8tIqndRUDuv14n3vaPsriDsO21WRhTgty7HIvJPCFOCdfX+zfw0OlyLSz0wVnu8lxNO/gc4uOEPBjVublQ4U2yX3euWekTTln86Iu+vwDFBE6PgtNsDC2cLcjrggIljGFlOfz4cnaSG72rTIXwmy8e9QF8fRbyTPX9E2q3etiAYYC7c93Kq1qcGbykiWi/KzQmQxOKLpV5BioQLWKSGlXfCBlSybGlPVvmQCtllJ5zopIDHwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfwlJtTfb9o9ohq3M0TQpLto4k+BBMEQAZTxXuFBJ3w=;
 b=MRb6zaPilBszisb/Nm9HCYq9m/SI1PU+cDoCANmSP/UeT3rEjhWJbi48EcOVI36s0RJIuBTtSQkh8+YcOYz9m+JW9jhmiQcP8kzZcHIBTzoZ4+4QqVqTa1TKZnct5jXTVe21SJMZsE2fSxHYUfJdzLGZ37bg8a/pTfBaMirkL15AJTfPghgG5/4CDoAmJVPkvW3XdoQ6nt8tTNlZy5MFZG/tQm8Zzh1vF1aFffnDkpaYqzSwvJQcGh+irMxd5WGsu5Z2puBwd5OPHcUpPFCVyPTUIXHHKUmvNWyuoNLPSmgGL5soQyYspUrBRrqcaEzYsNfrB+crBk57zpEF3oqnTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfwlJtTfb9o9ohq3M0TQpLto4k+BBMEQAZTxXuFBJ3w=;
 b=xFVX8VvJMjksRa3HAeksthJexIQxwQ8WCB3IR5fbwJ8xV/pYZZio6F3v5jPBDt43yIz2+47YBfvu/ml+ulUCmvuDddtj17Z4bbGk8dykhMFOS+oDGWR9pXcqzv59TvFQY5PGZChJvZzPF2Il33l+bioNNilrSmOUg155v64y0rDbPD6lPNj4Mh4SXulbVY/I374Ro5IcdDc8NirwTSGAon4Y3YypmcPtkZNufvbaiAFsJ0nd45dhoQMQb7ikEZ3eNAF1o1KQKyDCWu670xUvvYy/CNECGrGeUMCKxXLYCkLYboJjNj/iCDX6bTO23Cicv/FQF6aqFf2syOeNSQ8a2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB9154.eurprd04.prod.outlook.com (2603:10a6:102:22d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 09:04:48 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 09:04:48 +0000
Message-ID: <b8ba66c0-ea3c-24ec-9966-e8438d7c5626@suse.com>
Date:   Wed, 28 Jun 2023 12:04:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1687784645.git.kai.huang@intel.com>
 <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::15) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: f7762d01-4be7-4d28-7fe5-08db77b6b911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5eOTrXe4OS5fkFFVbfkiV2PjbsXUP5QyFI6+TWBUYMUPUXuLkdQ0AGGGIC9cXzj/stdWLAXiycUd+hWPGPiD3tqE1gDQnlYlMmzgl2QaeYq2xkUvL7JYNuhI6H6q5zi6HKkZnuwgSLBFFSMlsJnSJrXa7uptfJKVPEpBS9ebr9aBQS0jWvzvc/pa4CxW0BvPJJKavIJxkmU8qS34zu5UOahmPg0uUTGdBLL1+Z3sNASnVFGp/jJ2HiNC5S2rP1cG1SwB4GnWQ4as7zUq82T0w7r+ktoTRkO3T+6Lw7oAf8mTT3P3gTdeWvlnsCTujw3pSWAzf4NfeiTuYdmKZN+RlRtG/A4GqD0BbgXpxJyggUb2YvMqbm8lTIAPF5e/ffN8angepxshLJkZEqjML5Rm95i8o7OnfH0WDABdGxvCQpkOgVGMguomxTCZzVZsVpaVmFPeMOr/kVxDLVRofc0pPxSKfQqYxNu0Tgx2xa8nI0sK7vjxg7Pj73W/Bl6MP004y+Tev9lMgANKrpQTGM2UozffzwZcE4ujiwOddFHP+h/Mg1VZWnXDCbubSP9t6SRbjpcwjDiC3vQmXFldKSj8B8uUviu4RaAPacRUdjMGn0Wk9qElsKR+Cfed7bjutmnSVN4knvrBPyvoq8pSW2MTDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(31686004)(6666004)(478600001)(6486002)(83380400001)(2616005)(86362001)(31696002)(66476007)(66556008)(6506007)(186003)(2906002)(6512007)(66946007)(4326008)(36756003)(8936002)(41300700001)(38100700002)(316002)(7416002)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWxqaW1ib3FiTHNFQnVNY2Y1bnYySFp6dnV3RUZ3TWwzcWxxT1VCV0xNamRF?=
 =?utf-8?B?WW52Z3VJZzhwK2dHdzBQZ1NNMENtZ1FyWjh5akZaTTZaVkdzajE4bDlVRlh3?=
 =?utf-8?B?ODlmQkxDblRJUklMUllTT0h5V3kzUU95ZzZrV0p4Rm5xakoySEhyR0NYV2ta?=
 =?utf-8?B?T3J4Vm9ibTlsRVR3NTlnZXRJKzVEeEZrVG9sL2xSOGtURmpHVFlOUis1Uzc4?=
 =?utf-8?B?MUpoTTkwanJBT01laDJEWjUrTzlCZmYyWWRBWkxUajJ3UlZub3dhaXB3YnMv?=
 =?utf-8?B?dEZadHJNYzJLK2phMTJKRm1PbzRUTGdoNXVLMm5xWjFGNVVQMXd5enNiZS9h?=
 =?utf-8?B?U0k3NUJCTm5HVFdOYlFSRXFZK3d6Z2pNRlh6UWZqWEpmbk1Zbk9ISEZENE13?=
 =?utf-8?B?MVpFZ2FmbkJ3QmhrVVBmTzZKcTBwbjJ2RXZ6b2JKb2RjWTYyaGJ4d3p5WEhl?=
 =?utf-8?B?SmFyd0QvOCtxakxPTmwvV0d4OUwxNUhyK24rTGI1T1Bhc01TSm1kWGUyeVEw?=
 =?utf-8?B?SFBLYkVTNERsS29LNHRvdWozMzhTZlZEemJ4Y3djTFU4WlRjciszWTNGdDEw?=
 =?utf-8?B?N291L2h6MHpOTUptMUxxc0thSHVBOGIvMlRCVyt0RFZjZTRVakJxSEpCQ1l2?=
 =?utf-8?B?Nnh5aEEzWGVhOEMvcUdOSEVBZ0JXZUVnK0dMU200UVpmVi91cFJWZGNtNTQ1?=
 =?utf-8?B?b0Y5K2NYSzJBQWtZN0pVY2prQXJucDVGQk0zV3g1N3NyY3NDbDd0Z044UWFl?=
 =?utf-8?B?bldGVlRSSDRIcU1hVzlUVFh3MEpIeGZvUUNWQjliMVAvL29KY2w1eDlBcS8z?=
 =?utf-8?B?Ly84ODlYc2EzV0prcWFKamx2TTdTUGpaQjljc21OQ0ZmZWFsVnpsNmxxcUwy?=
 =?utf-8?B?aFFhSHpDNTRWa3o0VjhsTTFjemVXZldhcjFsRnJJQTYvUzZYNGl1ZWRGVnZn?=
 =?utf-8?B?OUFFVmxxcW4rQVZwNUgxUWFSSDMyTW1OazIzaXp0amQrNXlGYXg3Z3M4dFBl?=
 =?utf-8?B?bUVYNXNBSDMzb0VaMjllc0duOWd0YlpVOFhZYnF1VzdtdEpkUWRIaFNFWU1z?=
 =?utf-8?B?QzdKZVFjTmEwcjB1b2ovbnVsaHc2Tzg4YnJwbG0vVU9PaXI4b1hITXcxREhp?=
 =?utf-8?B?UmRhMUJ5TzhMLzFvVE9CQzRRSmZOUDk3RXU1eGc1N0tOQXZLY3lVNHlGeFhC?=
 =?utf-8?B?a0ZjZC82NGJ1eTJkNEhYWTdjTkhwR2xjZ0Q4dVdKTnhpRE1TdVVHbDR2OXMz?=
 =?utf-8?B?bVN1MVhqeVVwcklYMFBvVGZLSFRrNmdNRTM2WEhqYU1UMWVZK1prMy81SllM?=
 =?utf-8?B?SEcyRnZmMzVaT0tmQUo0SVB0S0ZJT2Jna2t3SytvWHM1TkNvZ1M0WjZiaFll?=
 =?utf-8?B?RU5GZE9rQW1JR0RHRDBYcE42L2lRaTFhdHpwVmZ3SE92UmNwU2VJaS9UcHda?=
 =?utf-8?B?c0UzVVRtSnJPLyswa3UxWXV6MVcvRzBEajVIM1NJMGNlRzVJWE1MSlh0eDdk?=
 =?utf-8?B?U2VSQUJTeGRWTkw4MDQ4cWMzTG9ITTNmN2prWGZ1QXlFLzRuK0ZVcTBzek1z?=
 =?utf-8?B?aGlsMXcxajZ4N1hwSTU0dlBDU3lBYm9uL2gzWXJxZ09jQ2Q1SzhabEFnL1U0?=
 =?utf-8?B?TDhjUUZrSm9rczk5VXdxTFdRSmRpak5HejExZmcwSUJQTjhGUzhvc3c0S1BP?=
 =?utf-8?B?K1BlQWQ1MFE3TUlBY2liWWRiYklEUXVhd1lIb1RuSUFzTWhCeGM2TDdwVENQ?=
 =?utf-8?B?eFY2UEZsVWE2ZG8zSFRjdnhjT1hEd0xxdmVZSS94MWRXMG9PNnBrRjNzTGtD?=
 =?utf-8?B?cS9NeUs0WmU3QTVhQUNaOFJBWVpxK1BQb1hJWWxlTXNhZXF6dXpCRnB2RXNJ?=
 =?utf-8?B?Qm9lRkJpcUV1UlpScE1vRnRtUjFIb01Ib0hNNEpJSDM5YVR3OEtYQmhQQ2d1?=
 =?utf-8?B?a0M5ZmNiVXRNd3o3NHFTeE4rWWg1VmJENEc5RTQxVUNUZXg3YTQyVEU5MUd0?=
 =?utf-8?B?NFNqUTRIemtGSlMzMnVUUE0wdll3OGRRbUN0ZkpUSnJyc0U1ejlxQjlIVU0v?=
 =?utf-8?B?WUI1TGdsR0srVTVsekZCQkNOUGpWQXFIUGovYlppZ3BiNHNyZ1Avb0RwQTJD?=
 =?utf-8?B?a0NsQkJJTWVoMFlvMjFNTFkwVXUxc2hNeVBIbUVJVnNqYll1YnBySnI2cy9a?=
 =?utf-8?Q?bSL+96vmds3ZXE+GBjelWjuhfVNmUlurdK78cBqz1T7s?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7762d01-4be7-4d28-7fe5-08db77b6b911
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 09:04:47.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6PhLJKU0w/rKpk9SGMj0V2W/+4W+D5Ba/dHPsXLQLmdFsK0MwGd4nBAWC6xkVuGqK/YK8fNgZRnzFbkPw+Y8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9154
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.23 г. 17:12 ч., Kai Huang wrote:
> On the platforms with the "partial write machine check" erratum, the
> kexec() needs to convert all TDX private pages back to normal before
> booting to the new kernel.  Otherwise, the new kernel may get unexpected
> machine check.
> 
> There's no existing infrastructure to track TDX private pages.  Change
> to keep TDMRs when module initialization is successful so that they can
> be used to find PAMTs.
> 
> With this change, only put_online_mems() and freeing the buffer of the
> TDSYSINFO_STRUCT and CMR array still need to be done even when module
> initialization is successful.  Adjust the error handling to explicitly
> do them when module initialization is successful and unconditionally
> clean up the rest when initialization fails.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v11 -> v12 (new patch):
>    - Defer keeping TDMRs logic to this patch for better review
>    - Improved error handling logic (Nikolay/Kirill in patch 15)
> 
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 84 ++++++++++++++++++-------------------
>   1 file changed, 42 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 52b7267ea226..85b24b2e9417 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -49,6 +49,8 @@ static DEFINE_MUTEX(tdx_module_lock);
>   /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
>   static LIST_HEAD(tdx_memlist);
>   
> +static struct tdmr_info_list tdx_tdmr_list;
> +
>   /*
>    * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>    * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> @@ -1047,7 +1049,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>   static int init_tdx_module(void)
>   {
>   	struct tdsysinfo_struct *sysinfo;
> -	struct tdmr_info_list tdmr_list;
>   	struct cmr_info *cmr_array;
>   	int ret;
>   
> @@ -1088,17 +1089,17 @@ static int init_tdx_module(void)
>   		goto out_put_tdxmem;
>   
>   	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, sysinfo);
>   	if (ret)
>   		goto out_free_tdxmem;
>   
>   	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, sysinfo);

nit: Does it make sense to keep passing those global variables are 
function parameters? Since those functions are static it's unlikely that 
they are going to be used with any other parameter so might as well use 
the parameter directly. It makes the code somewhat easier to follow.

<snip>
