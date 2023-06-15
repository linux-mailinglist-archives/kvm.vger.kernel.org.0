Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA82D7311D1
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbjFOIMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 04:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbjFOIMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 04:12:16 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2083.outbound.protection.outlook.com [40.107.14.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298621BF3;
        Thu, 15 Jun 2023 01:12:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT9uwyFg4QlvWh1YjhuGtUDR+folX7de5NGQ4bv6vcfA+OW2N/k55eyLPMyriXIfLXN0FhQaLDb7FzWC2Ad/kUzV5YknnsUjsSfZhdzZ/73192Rhm2ux4zM2IAY2XFbedDhU6MaCjXgP1H8Lb1T8IKYe/ndqwemAAJZLPlKJgwtrA+S4P8IYQGQIVu4ONeK1lggXDR+ardP5YZqYiFsJL0wKxSm9GyqiwaQ30n+oaUMqiULDU4f3u6Xz0O8s3taojql5yR4xA+RaQl2j73PoUB+vWJFpmTfUxwO323dFGn8rz5FDJNOgQyd/g6uxF8e2ltkyvS5U9FalWuPl4XjvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POdgV+/h8/6JZvObxSP2a2vbbWXvHNMo4Qg7oCJGwD8=;
 b=CLzLqq7WKufUEYEJHzdGxE52IW3HAR20F9Gc0IjR5Y5zx9EMFzSq9kF+7FUrnWCVfMX1VbxNIkWlSJRCseQuvGoWTcOCHyM549lxwvwvQayag0fVs0BvZt3gW6we4mEG7eHQ4YVwTxGQ2Wj0RKoL+HS/tAsg5uGi7ERss3hcXyFxG6CaC3RxR7i65z7WMoRLio8OPwH8Owas1mbcFfd2MLDsPyuZRAC9LOVEBBL2/CsxiWgQvABkLe3flOfWQdnhRgQNwAxVmNohIrdUZ6E62nPjHErgtR57DZ+WVksce5Np2o0d0sb9+0rMQoISxhhxeUKJqHOn3OjxhEbSJJIeeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POdgV+/h8/6JZvObxSP2a2vbbWXvHNMo4Qg7oCJGwD8=;
 b=uKsirPw+aFwErwdBVvr8ocPVNM3GuRSiSJpoTYRmYES76pmFtotgpNenDj4tb27pkDsRCJIn7mrh5BCtKJnChbk5va/1SeZijQ4EJnPqTQaoq3OcRh9D4ho6Q9ZChwqFZchSIGq8RLFhGED/bwmw5+CyROQ90y17GRGBc6/YKt9ZWJgRoZC8f5eVLtNhFxoR9T8FzUfc/WF+ptGlen5UnT08iWJfGnHVvO4XBcGrhwBoFrZLR5zkIXbEDC4mtzJ3R3WVt8qGWhXn6BIqolp2zQoDQaxUa7tCnT76y2DB5DrKYmxY9NXoFX9Ujv0ZAcm7o7S3YH27hvXnlZUTT13nUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DB8PR04MB6825.eurprd04.prod.outlook.com (2603:10a6:10:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 08:12:10 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 08:12:10 +0000
Message-ID: <49bd9f7f-9a2b-8b8c-f408-49b9b5982eb7@suse.com>
Date:   Thu, 15 Jun 2023 11:12:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0067.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:52::14) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DB8PR04MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: b6959fe2-1443-4645-f245-08db6d7837aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sv6rLF2NanLr1C2MA2jRhCcYydw/lytXy9fQ4CLeryETlsvZdOPe7v5Ax+QyImy+4nP4CcWrXwwpcE2ibmtTvxAuy+deJkddCL0B0pWcd8bkv01DPKjZqIkIvHJOr3TnPbPEcfsRRPpen+YwYZq1Brzq2wdfq6s/XVOZyNaZfUCTCZGYtdV7k9qRG8+h4AIjCM1LSzyGj1uCHt2c9kUutK1C9xMMwzFHvtpmU+wjirlrrAmQBkseYLHbuut17I2Jf392WXTtPdkMrBBCFIxUQ+GOs88TLa6Hph4qaCo4mWjS7OTIfC6mCJdAuvCi/lM6gcSgUNWwSmsVSysOdNJdOhO5Eip/ZKCFoZCx/MBqHib81JLNCN8+zcfbaWdi7epEcVZFYCcBDxxU7RLW0//ov6iQR3pbgmFpNqxcar7aAwfzs5pEBTLKxsT9uvk5HAzHwNq4Gdg/bumzkizhuhG1X97D0NW40jYT5kby/085NF3abuGeEKCh0SO7ghF8cgy2nedoxynLgocDPf0MMqS7s5kebltWvqYgDEkOKvaGZEslRky6tbSWyeNTZ9jAUDjrJBw7opdXQXPis+lTtiF+1Nmw9j7lFbbg9o57bMPT/GXRgnj5UuYK7suz6W9xlfTTWVBorFFzlFcPNAE+81Z9ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(5660300002)(83380400001)(186003)(6506007)(2906002)(31686004)(7416002)(2616005)(6512007)(41300700001)(8936002)(8676002)(6486002)(31696002)(316002)(6666004)(36756003)(478600001)(4326008)(66556008)(66476007)(86362001)(66946007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVhmYWhMUUZ0TGdtY0xuaUVLK3pERXhERDZZUHlILzNucHp2NDFQR0FYNUxZ?=
 =?utf-8?B?VTJJYmhDWjFLS3FiS0pGc00zMkIzcWwyZXRvTDlRVWI5bDRMeVJtYU1saXB4?=
 =?utf-8?B?UmlXTHNONENlb2l4bFNqZk42aUhscmcyZDJRakpZT0htQlZSNXo3c2drQVVO?=
 =?utf-8?B?MGxHM2NueURuUHlTOWZHYlpOeW5ZNjFmOTVvc2VYM3RNM1oxdHYwd3J1UUdt?=
 =?utf-8?B?MW5NbVRmTHNNa3pReFd1alg0NE5QbmJjcnc4N1EwSW14RnRhYmp5WmdmYjdF?=
 =?utf-8?B?UjMwcnMvUHJ1UzIvZnBhUHM0di84YUR1UmNBUmRFTnRLQkJwSnZJTkdzYUVz?=
 =?utf-8?B?dUZyNXhYNjFaeWlpcUN4d2RKNlZFMVp3dXF3ZkYvMlpkaFdVRUxtNEQ0eU5Q?=
 =?utf-8?B?OTJ0OFMvR01CUVREa1JsRjl1QzAwZU13NVFwSE1vcDdQM24weEI0Y1RmZ0t5?=
 =?utf-8?B?dmRkcGpBd0NEUytBMnhpRlQwUnJ4SUtmM0ZYTXhSZUJNbTY1bnZLK1RpUXU2?=
 =?utf-8?B?VUtFYUVOYXQrdU8xdmMxSVMva085WWV3Z2ZFWEVEdnVwWFlRcG56RDJlNnEz?=
 =?utf-8?B?aUVxd0VkVjY1bklSeHRCUjc1ZmRYc2gyOW43eStORWxlQldPN1k2M2lRRnA1?=
 =?utf-8?B?Y3pXNHB6a2oyb2dqL2MzaVVLR0l2VnI2dWRITHM5MkNQWmhXSHRSbGlvdjRp?=
 =?utf-8?B?ZGVPS0tzaUNZdnRxR3FaYVRmUklaNW9XWW5yMk42MVIvRVgxeUdBRTV2aGFj?=
 =?utf-8?B?SmF0bWo2UG56MHF4QXR0bFNLU3BoM3lrUGlKRlJSUHJXQW15dE55SFpvdGRZ?=
 =?utf-8?B?WU5DblMyWnpDRFBobmhBVm5rdkV0U0dYN3BOTFhYSXp6ZVhjbjRrb1RTY3A4?=
 =?utf-8?B?a29QN3JLTFB6L2N4UDkwUzZrbDRZZG93S3VuaGJ0all5MGJIM0crWGk5aTYr?=
 =?utf-8?B?VjhYeG9PeUJPUmxNT1lpK256YW5qSWVtTVJiUUNTVDUrNm9tOFVYSERBU2pB?=
 =?utf-8?B?NUdGSVMwYmN3Q25YdW5UVlF6d21MS1BHdHprTFozQmVwL1RrM3lrWnpUWjdV?=
 =?utf-8?B?QnR2dE03WS9odFhJbjd4N0JES0dQeFUxOEkwdXhZTjBHTkZHOHVHdEUrT1RB?=
 =?utf-8?B?TlRmanV4S0dzdlZCWnJ6aE5pSS9mQlppV3kvTXhCMThaZjU1TVh6eWk2TjVJ?=
 =?utf-8?B?LzliQnFkekU0eTM3dDBVUnFPQ0V1NnNBMUZNbi9jaXYyWmxNajNpUWM2a21W?=
 =?utf-8?B?RmV3NmNRVE1ObXE2K1NneHRhdkJZLzR2L3FZMTNqVDVCMlV4VVFZcVhrK0dy?=
 =?utf-8?B?Qk5XNmdjR1NYNWpZUHBQakcwRVZ6TWcrT29vYVhEdzA3NUl0Y1E3ZCtBN09L?=
 =?utf-8?B?Z3VwMHZKczg0ZFJoRHZsYzhWaDMwSXVxclJDVkUrbFFZM2ZsL1E3cld0SFVW?=
 =?utf-8?B?VEI3TldrUVBTU1M1Q2lTODFQdFk2d2VuMmpPZUdXTkVJSEY1VVYzTXAxdU9M?=
 =?utf-8?B?R1UyMW5hRHl3M0ZPdXdlOHIrMEwrK3BKSjgrZHZGYWpoWkR4MlVVTW0xdlg0?=
 =?utf-8?B?aTJFQ3FvWlFBRkd2bWpLRkdGclFQUWMrSUI1VDVqbHU2WFRFTGdzbHhMYjhz?=
 =?utf-8?B?YXdoR3RtSWFTMWtQY2RHejJ3biswS1kzTXh6cmRFYWJQTTFqL05vcE9pM1lu?=
 =?utf-8?B?WlgzUEszWDQ2SVFXSXZMYWJCZEdMRzZGcmJRODRlbldCV0hqa3dMbGtNbHU5?=
 =?utf-8?B?Q2ZsMU5ITCtoa3U1YmxkaWlvTTJ5RXU3SVVxSjVuYlFKUkpPSUMrVDNtNUdU?=
 =?utf-8?B?OFV6VUZnSVZQbGdzU3poaitnZDg1TTlianJScWRPZjBwaXhDL29XMUJidWg5?=
 =?utf-8?B?OEtxN3RremVFQkY0WTJrSlhGRlNoeWJva0tzYW16aDdrWHlaN1dPaklYUENs?=
 =?utf-8?B?elVwMlA0Y2VPUVZ4Wk1pZTNTVTJIVnk3TlVyUFNmeWtEbW5NaFR2Sk0yU1NO?=
 =?utf-8?B?bHdOU2U2Z1BJVEVCUXgrTHRORW5iMVpUSFAxTlh3Kzl2cm5CclVZc0Z3U1lF?=
 =?utf-8?B?VXRiWEJlbTZRdDdGNStzKzhpeWhIQVF3ZEZFZ0VDczIyNkR1UHRDN3ZWY3Zt?=
 =?utf-8?B?TkFHN21YazRyYXMybFBzWVVob2F3Nm9mQk81TVVDWGpCbWlQQ3FxdU5PWGhU?=
 =?utf-8?B?aC9yYWN5ZUVnemxUUy9Ra2VQd2J6VGROUEpTcUFyN1lFczVrYXdSL0owbDZL?=
 =?utf-8?B?S25MbFJKN21sODROQlVLMlV4dnpBPT0=?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6959fe2-1443-4645-f245-08db6d7837aa
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 08:12:10.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qi6xcL2M865v4dsw2CgD5wxDCgCFIwkBISd9GP78ROcg8wJ4AOT/gNuR7X4fJucVMSY06QoAMhzp2xrFC/ugmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6825
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4.06.23 г. 17:27 ч., Kai Huang wrote:
> After the list of TDMRs and the global KeyID are configured to the TDX
> module, the kernel needs to configure the key of the global KeyID on all
> packages using TDH.SYS.KEY.CONFIG.
> 
> This SEAMCALL cannot run parallel on different cpus.  Loop all online
> cpus and use smp_call_on_cpu() to call this SEAMCALL on the first cpu of
> each package.
> 
> To keep things simple, this implementation takes no affirmative steps to
> online cpus to make sure there's at least one cpu for each package.  The
> callers (aka. KVM) can ensure success by ensuring that.

The last sentence is a bit hard to read due to the multiple use of 
ensure/ensuring. OTOH I find the comment in the code somewhat more 
coherent:

 > + * This code takes no affirmative steps to online CPUs.  Callers (aka.
 > + * KVM) can ensure success by ensuring sufficient CPUs are online for
 > + * this to succeed.
 > + */

I'd suggest you just use those words. Or just saying "Callers (such as 
KVM) can ensure success by onlining at least 1 CPU per package."

<snip>


>   static int init_tdx_module(void)
>   {
>   	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
> @@ -980,15 +1073,47 @@ static int init_tdx_module(void)
>   	if (ret)
>   		goto out_free_pamts;
>   
> +	/*
> +	 * Hardware doesn't guarantee cache coherency across different
> +	 * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
> +	 * (associated with KeyID 0) before the TDX module can use the
> +	 * global KeyID to access the PAMT.  Given PAMTs are potentially
> +	 * large (~1/256th of system RAM), just use WBINVD on all cpus
> +	 * to flush the cache.
> +	 */
> +	wbinvd_on_all_cpus();
> +
> +	/* Config the key of global KeyID on all packages */
> +	ret = config_global_keyid();
> +	if (ret)
> +		goto out_reset_pamts;
> +
>   	/*
>   	 * TODO:
>   	 *
> -	 *  - Configure the global KeyID on all packages.
>   	 *  - Initialize all TDMRs.
>   	 *
>   	 *  Return error before all steps are done.
>   	 */
>   	ret = -EINVAL;
> +out_reset_pamts:
> +	if (ret) {

Again with those conditionals in the error paths. Just copy the 
put_mem_online(); ret 0. and this will decrease the indentation level 
and make the code linear. Here;s what the diff looks like:


diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4aa41352edfc..49fda2a28f24 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1131,6 +1131,8 @@ static int init_tdx_module(void)
         if (ret)
                 goto out_free_pamts;

+       pr_info("%lu KBs allocated for PAMT.\n",
+               tdmrs_count_pamt_pages(&tdx_tdmr_list) * 4);
         /*
          * Hardware doesn't guarantee cache coherency across different
          * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
@@ -1148,36 +1150,32 @@ static int init_tdx_module(void)

         /* Initialize TDMRs to complete the TDX module initialization */
         ret = init_tdmrs(&tdx_tdmr_list);
+
+       put_online_mems();
+
+       return 0;
  out_reset_pamts:
-       if (ret) {
-               /*
-                * Part of PAMTs may already have been initialized by the
-                * TDX module.  Flush cache before returning PAMTs back
-                * to the kernel.
-                */
-               wbinvd_on_all_cpus();
-               /*
-                * According to the TDX hardware spec, if the platform
-                * doesn't have the "partial write machine check"
-                * erratum, any kernel read/write will never cause #MC
-                * in kernel space, thus it's OK to not convert PAMTs
-                * back to normal.  But do the conversion anyway here
-                * as suggested by the TDX spec.
-                */
-               tdmrs_reset_pamt_all(&tdx_tdmr_list);
-       }
+       /*
+        * Part of PAMTs may already have been initialized by the
+        * TDX module.  Flush cache before returning PAMTs back
+        * to the kernel.
+        */
+       wbinvd_on_all_cpus();
+       /*
+        * According to the TDX hardware spec, if the platform
+        * doesn't have the "partial write machine check"
+        * erratum, any kernel read/write will never cause #MC
+        * in kernel space, thus it's OK to not convert PAMTs
+        * back to normal.  But do the conversion anyway here
+        * as suggested by the TDX spec.
+        */
+       tdmrs_reset_pamt_all(&tdx_tdmr_list);
  out_free_pamts:
-       if (ret)
-               tdmrs_free_pamt_all(&tdx_tdmr_list);
-       else
-               pr_info("%lu KBs allocated for PAMT.\n",
-                               tdmrs_count_pamt_pages(&tdx_tdmr_list) * 4);
+       tdmrs_free_pamt_all(&tdx_tdmr_list);
  out_free_tdmrs:
-       if (ret)
-               free_tdmr_list(&tdx_tdmr_list);
+       free_tdmr_list(&tdx_tdmr_list);
  out_free_tdx_mem:
-       if (ret)
-               free_tdx_memlist(&tdx_memlist);
+       free_tdx_memlist(&tdx_memlist);
  out:
         /*
          * @tdx_memlist is written here and read at memory hotplug time.


<snip>
