Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34767740CAD
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 11:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjF1JZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 05:25:15 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:39554
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234421AbjF1JUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 05:20:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvPwTaz938sVGSHwErPNH+ONe1Th5Yi4/acErPGHbgsrVneyyeaUL6ve0+idZCCMqktxxk2AkXO70p7UUxzOnuR58eDmcYa/hjB8tIRNCZ2e0UEj4IMQBtdCLcFydfDZxt37kdXig8gyHGJ1mGU3e5nva6ymS6XNRcZ+LjZL+l/aJtduUsTzpvE4F8Ow4XwmYG6OlGCbHgH7+QAJOz7dKiwkEielyaIgwPbdjo96mVk1Ow1GAub2n0cWTLZOPK2k0vpW9MM3PIhu7iXbZv1PhyWFZ2H+miw9pmHtr6BGvMW1E0lytprEuTzS9dCcPM21QDaPHtgomvNCtSZUZNFLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mbk3wewxDA445/hH1NPMymaSSVLLWuPH8AAWYbXcJMw=;
 b=bjQI3nitg5lFPohfyavjM+4hI81HLBxHyOUZlk4YiJOqWcgh8HKCa7rDBBypnlbV20HmsPUJs3rQx7UoY0FxZuzdHr+q53x9yRxtHKAgROQBpGlWIbMRHpIcnuX1gBQF1YaGAAPdVZgzKdIrAHG/VwDPTQCatt3W1i6YxogI1K3iqcuYnkZLdxdkExRJHP933eCmXoCT5NYV0OHjkaqj3yNI+sSrndLcW0ZN3ljKSSrUv7nMcINYj/8C6OvvoUu6t9eiEP80jgKXiWvO+aOLUsAKbfm7MwZclayUvE3n8VUOBPJGmP9YtZrudCwsSBvHRx0/pz85auGMewlhLvjIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbk3wewxDA445/hH1NPMymaSSVLLWuPH8AAWYbXcJMw=;
 b=qTxV0UQLpshiSxjRx5HzSzSGqv3E0R2DgO4FmOSDbp0lcc+GFFVP7Q53D1H3sDFKEE5NOTt50EbRyU4Yd0v5qdLk7TymSL/+eVKtGxG5X0fls5xP40vvJWfoiq+DM6JtMBuM7y3gWxuYMkizQUSjGvUiwM8oE2TKQq5WmpvhEMnD6vwD6OOfeEmO9ZmIbcWk6vSinXLd8ZE+O9nJQCmbIgQbx/MKUjeAgvdP84KnaNPWd4IBYHOepY7MlnbMkj4oUKsHKc8I+fvsb4v1ng92nDegUJZi6+T6zTK+1lL7UvYqk7WBM2bqUAIKRvykBQM/BzRvM0xH6uqEmQdNycyftg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by VI1PR04MB7182.eurprd04.prod.outlook.com (2603:10a6:800:121::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 09:20:28 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 09:20:28 +0000
Message-ID: <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
Date:   Wed, 28 Jun 2023 12:20:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
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
 <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
In-Reply-To: <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::15) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|VI1PR04MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: cbef2c4f-0223-4851-47d7-08db77b8e9c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjMK5nqo8f2e+wX/4l+YHXRClTjjAwlR7brMeq6CCNlRw1orhx35t6NB8IhoCmFRGBP0jNEeImi04eKR+k7nZJsBCXdme+s3r29AZpnQnzKgr+yhtN0e4UsS9g+er8ipitycxxnRBlKuxJV86nXKGXV6rqW269+pihva81Xu0gJ0H5zx2QsRNDKeBziLNZ+mznmoPh896jElNeiTtNepQ9rSqxjau/w7GqbX6nm1a1mt6xRRS5N52t0tw0EI5tvpiJv902Sr6wNBOAS+JpN7CBjP+avraKNOlzCCbS1OmwaWMK/ddulf6ZPF0yEDmhymkmHGtOuxIyH/0yAdkAQXuQVJPjpKYiiaUBIFm9pV8QukoVSXTWnxet1K9JDIRupH3KefC2JFTzt5Mt0MAm+6xeMKkFVLujg7kkjLLSy43KEYFUNIGBxAVGT9jhv+mmf2ltB2j4rilBzRdipT1h9jZ7C9haAPl3UvzaiVmLm+USEDtoVHORxeB7Db5iY82HkMAryz8rdp/xdGv2cErwgqC9wGezQpAIIzPTRS8Sq8R+XymoE+A39Ji5bLZzy+0XQA6tevdp+r09pINhSTU0xgCezdQpkjIaVWnG3JVB1xZm9vxV9UV7QnVe01bAKkaj7qo+Inir1x+mKr+1SDMpUdnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(31686004)(186003)(2906002)(5660300002)(66476007)(6666004)(36756003)(7416002)(316002)(31696002)(6486002)(8676002)(86362001)(4326008)(478600001)(2616005)(38100700002)(66946007)(41300700001)(8936002)(66556008)(83380400001)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU9lRk9Fbm5VZmhtdkpyM29XOXM5VGtWYXhhYmVjOUJvbW5qTDdWcEtQbDJp?=
 =?utf-8?B?N2pXd3lqT2doNlcrcjlsUHdaaUFGVHEwR2dZQTZDaFdOZnBOZzdrVXphRHVw?=
 =?utf-8?B?OW5QQjBrU05UQWx0NlZxcGhhSTRNSVc5QUQ2cENiS2ZMak4rK3ZBSzFkcnFZ?=
 =?utf-8?B?Nk8zc05qSnRkRnBqOXJqOEtVeDlRa1huNmRCU2VSWEt0S0paUkxyQXcvZzZq?=
 =?utf-8?B?OG9qQnhFK1ZRT3FZak1NTzFCbHFtSFZNd25VNzFpS0NEeWc1RE1pMURzNmhW?=
 =?utf-8?B?Z3g2Zi9ZUVFyQWtpUnZiUHkxSU1hWk8zWXN1MFk3NVYvTzZUbFFRV2cwcE1E?=
 =?utf-8?B?cFpJbzhFL0VNZTYyNW0zd1NPMkpTd0RPVWxYVlVFaXBMTXF0REF3QjUvR1lw?=
 =?utf-8?B?NVBVaE5yb2xNd2xDS1ZTMnFuNGx3MGJicmtWZFJPbmhSaEh1VG0xVHJMWlVi?=
 =?utf-8?B?SXlXWTRMcG9yODdGUXc3dVFTbEdhTmFrRmpZUnphaG1ZSVhCWTFORmVJTUdN?=
 =?utf-8?B?NTVtOTJpRjhKU0FnQjhxeWpOTXBDcXU5bWx5UlFTSDhQL3pnb3FSakNraVIy?=
 =?utf-8?B?RytVaWZveVFOSkdzenFNZVk5T0VkdWFrRzBqV2V6YzBHaVptbmNiSkdQeWd3?=
 =?utf-8?B?UGt1VnNCa1BDMzFkdmkydGJwVWc3anJZZWcxc0pjMDFtMjM5SlJuUTRnTExN?=
 =?utf-8?B?RGRYWVJ5OWZIWXJFN2JzeHg1dzZlRzgweVI2bC9ycmNIZ1R5YjlQRHoxUFdM?=
 =?utf-8?B?VzEwQTdWWFpmZWkvcWc0Ri82OUtkRzR2Zm9jOGp5dDdJdllOZUlSY1R5OHg0?=
 =?utf-8?B?N2VvOTdCTlpoK3B3eEx6eGFyckVYUGNDMG43aitHckJCeHNPRW9NNFBvbWVV?=
 =?utf-8?B?Wkw4bTUrS2ZMQXptQmJsU0tzS1B0TE16NlpwcDUrbkJTOTRadmU4MGQ0bTk1?=
 =?utf-8?B?QUhmUHdPbi96cmZWTXd3VnZINGdRNnpPVFo2bkE0TEZVKy83NFAvbE5kSWZE?=
 =?utf-8?B?S0gvR1czRnJHQlk5dTNCdTBWZFI1ek5Cdk9IZytFTXVNK3k3aEJGMWl1MGx5?=
 =?utf-8?B?WFg1QkJWT0tkSmdqSTJ1MEhNSmN3YzJIVW9vSndHZjNsWjdKb2NGZEM2MDE4?=
 =?utf-8?B?QTNjeGNjTGMzN2NvUUxuYkRydndvc0VVZTR3SmFNZWVtNVFFS1lTdlJtZS9v?=
 =?utf-8?B?RkVid05PRjNkMTVJUVlOd3QwV1JUdUQxOWE2eEdhU1hkbnljZThHV3N3ZmZk?=
 =?utf-8?B?Tzd0U3VYUTJ2aHNYemliemQyalJERWRvY0JRbFg5b0taVk1Id0FqcFFaNnBE?=
 =?utf-8?B?TUk3bDVBRmVSUm1mVVhvSnZkclJmZmFQZ2M3UlpuOFZ6V05iUVF4WWVVY3Bx?=
 =?utf-8?B?VFd2VEVyZjBmeE0yKzVEa1JiYUlaZ2lGRDN4QmNSREZtK0VaVnV6QVdXdVdS?=
 =?utf-8?B?WVZyd2tOTi9rOE8yMjFwNkI0US90SkZnVkdJOGdQQndCd25LTkZmRnRVa21p?=
 =?utf-8?B?elNiejVqMk5pVnRuTTBRM3c3eGFNWWZXenl0N3FScEdNUUNaSGtFVnFVU1hY?=
 =?utf-8?B?akJkL1VacG1kQVQvNlczQkp5OUpIN3pTOEpaeXlMYTIzeEFiL3JDTE5aNFdt?=
 =?utf-8?B?SU01ODYwL0ZlQkRhU2UvUytzM0M3WVR2RVJxNERNVDI4Z1NXekdZY2p6MUk5?=
 =?utf-8?B?dnRJMFBPMUdERGtkM080aFBKaVRUT29wSU5yRll5R25nOXlERDlqdDNjUk1S?=
 =?utf-8?B?VFVlS0p4REdSVWtKeWJtd0hTcHRUZUVZYmhkbUphQnhrVlBNQTZqMkQrZG0z?=
 =?utf-8?B?dFNLZjhydzZuVjJod2xoSjJsWFdPL0NtZmhiMnFkczhKYWgvUEhEVytReWl1?=
 =?utf-8?B?UElhU0dRd0JIcGtnWnJ4SjFYUGVIcVJEZGl4c2diSXVRS2JHMU91OCtPTUlS?=
 =?utf-8?B?RVp4bWVhRVVEUUN3UmUrOWNJL2ZFTUl5L29FeUIrQjFPMUhVb21CMzJlY3Nz?=
 =?utf-8?B?cml3THpZcVRXT0hBR0pRSmtpaTlJcTdXbnA1aGI2UUg2UEduTjlXWCtZazRP?=
 =?utf-8?B?ZUZ1NFNzNUVWVHFCbHR4N29aOTd4MTZmSU8vUEtqMzRBRjFJMjFWU2dtTHI4?=
 =?utf-8?B?WmwvMnFla3lDM2Q3bVUyTHF4angyT25WZnNkSFdMbWhTYkJDWUthczBwZDQ5?=
 =?utf-8?Q?jByCdmG0VTrKCMLiQCqL3jpLXOpVvFB7mUo7hWoZZNhY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbef2c4f-0223-4851-47d7-08db77b8e9c2
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 09:20:28.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJy5fn4UFk7cYLtnHoSM8ySc6tQ6RiycxW5pyoSz0l0HBgACOf4EnLCForIjfXjLqBFRprCX12e0UvjIU5IupA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7182
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.23 г. 17:12 ч., Kai Huang wrote:

<snip>



> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 85b24b2e9417..1107f4227568 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -51,6 +51,8 @@ static LIST_HEAD(tdx_memlist);
>   
>   static struct tdmr_info_list tdx_tdmr_list;
>   
> +static atomic_t tdx_may_has_private_mem;
> +
>   /*
>    * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>    * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> @@ -1113,6 +1115,17 @@ static int init_tdx_module(void)
>   	 */
>   	wbinvd_on_all_cpus();
>   
> +	/*
> +	 * Starting from this point the system may have TDX private
> +	 * memory.  Make it globally visible so tdx_reset_memory() only
> +	 * reads TDMRs/PAMTs when they are stable.
> +	 *
> +	 * Note using atomic_inc_return() to provide the explicit memory
> +	 * ordering isn't mandatory here as the WBINVD above already
> +	 * does that.  Compiler barrier isn't needed here either.
> +	 */

If it's not needed, then why use it? Simply do atomic_inc() and instead 
rephrase the comment to state what are the ordering guarantees and how 
they are achieved (i.e by using wbinvd above).

> +	atomic_inc_return(&tdx_may_has_private_mem);
> +
>   	/* Config the key of global KeyID on all packages */
>   	ret = config_global_keyid();
>   	if (ret)
> @@ -1154,6 +1167,15 @@ static int init_tdx_module(void)
>   	 * as suggested by the TDX spec.
>   	 */
>   	tdmrs_reset_pamt_all(&tdx_tdmr_list);
> +	/*
> +	 * No more TDX private pages now, and PAMTs/TDMRs are
> +	 * going to be freed.  Make this globally visible so
> +	 * tdx_reset_memory() can read stable TDMRs/PAMTs.
> +	 *
> +	 * Note atomic_dec_return(), which is an atomic RMW with
> +	 * return value, always enforces the memory barrier.
> +	 */
> +	atomic_dec_return(&tdx_may_has_private_mem);

Make a comment here which either refers to the comment at the increment 
site.

>   out_free_pamts:
>   	tdmrs_free_pamt_all(&tdx_tdmr_list);
>   out_free_tdmrs:
> @@ -1229,6 +1251,63 @@ int tdx_enable(void)
>   }
>   EXPORT_SYMBOL_GPL(tdx_enable);
>   
> +/*
> + * Convert TDX private pages back to normal on platforms with
> + * "partial write machine check" erratum.
> + *
> + * Called from machine_kexec() before booting to the new kernel.
> + */
> +void tdx_reset_memory(void)
> +{
> +	if (!platform_tdx_enabled())
> +		return;
> +
> +	/*
> +	 * Kernel read/write to TDX private memory doesn't
> +	 * cause machine check on hardware w/o this erratum.
> +	 */
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return;
> +
> +	/* Called from kexec() when only rebooting cpu is alive */
> +	WARN_ON_ONCE(num_online_cpus() != 1);
> +
> +	if (!atomic_read(&tdx_may_has_private_mem))
> +		return;

I think a comment is warranted here explicitly calling our the ordering 
requirement/guarantees. Actually this is a non-rmw operation so it 
doesn't have any bearing on the ordering/implicit mb's achieved at the 
"increment" site.

<snip>

