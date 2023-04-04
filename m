Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00A6D583A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjDDFwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 01:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbjDDFwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 01:52:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55417211B
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 22:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680587525; x=1712123525;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JBcqT3876qwf52ISWqg5/LKSjqOk10L6SAyFwG8xXV4=;
  b=iMSMrog7q3BNPeKqkQSx0qdYK6+o6IOYwI+J+oALi/59ekx4R/nXMLYw
   szptSLMueEUymBr9mGu4XaSrnCnErOwbgYyXZ/j+jUKn5bqaPV6Drqdag
   QbIe22GtQuvUZRUo80D0gYq1MBsOhkL5NmzAvJ9wLuK5+kz4gAm/6HwYB
   DVotwLO96vrIdLt5ruiVGAEPq1oRK65XprobxbvzWz0bYvyAtVmFQpN7I
   RnwrzY+0RaX/WRVnqM7TMMhqRre/eGLbBY7XIkjALOjceL61LTXANSWB+
   ddYqMkMsiH6nPBG3Q90c69wPUwZRHgnsq3VrTQGWtL/u2ZZpsHLo9CRT6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="322489132"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="322489132"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775509808"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="775509808"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Apr 2023 22:51:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 22:51:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 22:51:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 22:51:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtZgKSBj/LQzLYHsyMNsuRgpT7QZPhbsmQthR0CHYyBtUQRhniALY96PFt7crWilqfHBK1e45fqa0zbM/R8H6dwcZ22qlDoDbDJZAd13Kw8vwkj1Q2iNe1aai8rSqt659V/FcDN7UN2QAaneo7RVlyg1wACYWz3lsVMnd3mwilZkQDqQ8iTEfVA8aJKSkkLtmF12rHSpkAQ4abrLAla8mdSvbhB9pii4mG3vrYD9HkQDIjiDoENIZ+/yvTfdCvIUR9BWt3CFIVpFgetgpReiavFD+aIB6V5m+bBOZDdH7gOqD5KsZpsnohnBXCvSB7rMTIU1xQtyXic6/JFB+J61VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygoNW2fU9KghtY16sxhy0fjVrAOU2D8KMfVhNoLN3OM=;
 b=dfGjwAGqGmeH5nQl0dRH9cBQqEOOmEJf3v4QRsz10dSKi59eSX9mdHds2pSfCiWG0Kr+4oJvMSFG9MaO67WtsL5rYr2h5605rz5x5hbW3DiTp26UB+f5K46I66aHbvqN3mmQE3HRaXLn/8bmYKXJbX8agvqA9+2RLmFroX1kzx2gnnZrfMGal406U3273h8orThTxJP1Xs6wIcnGqKxKlOkMjAVteOGZqJFVSwqTqFJEzHpMvHuX4oo9K2x3Tl8VLjW3ayKpiqTXzzMUALk8sz/Ptyhzd4i2aNKoxyeQkTnjEv/7CdeA5TFZ6KSNZ+KBxrZ44nShn8tk/VoW57OHkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7216.namprd11.prod.outlook.com (2603:10b6:8:11c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 05:51:25 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%6]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 05:51:25 +0000
Date:   Tue, 4 Apr 2023 13:51:54 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: Allow setting of CR3 LAM bits
 if LAM supported
Message-ID: <ZCu6+kqF2asJvwWU@gao-cwp>
References: <20230319083732.29458-1-binbin.wu@linux.intel.com>
 <20230319083732.29458-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319083732.29458-2-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: 50cb5c8b-47e0-4858-aada-08db34d0a020
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EcYTgBPjcRXvA6bE6CIcrsIm7XwDD6jo1ln26Utl58zn39Oh6dBGXz+6WeO5pr8HudloSS/UWEKblWwRe9MazOOVaRNRkcmscG0oowedncH49aAMFkWJ+aWLe9CoUv2ZMAvoxjOocMBNDpRW+GVG0z+7qdjQ6vZjb2qZ2rrTRgBJnYmTL1tBql/8gmy3mCm3P5Ners0BKPk534UhqqKgkgZsRlmpkSS/dD2+qZ5hY+gNBnKmdQriDAmYwSr6YK6dxLcfR1SbjmabaCdvWzwMGr0pGs6DUaTXaFRSUEuAYhR2G6ZddRfIHiCoTBlJCP3+HKbLHbRIXcfdylVE9WvqIg3Qx2rVt7aMmvNJMilQmcqsi9KD/bYpYhDdvBRGJiIyms/z6HE8SeEcYk+ENd3/hVAcxh6UajlR7yYQMFqed11yxfZ3V366CBweEALiW7rC7Cqus8a7xM6RJPn8qyiIQI1r2dnr2BtTGSSu4zPRYTq0Bm1QvVxo02jIqkYvwqq3RHNj5Dv6AYc8fzzxXuWmAYFfgJFrvGEgFxgmctRIWWicKx7jhH+m0lwFDauJH48k/IuTqy8bA4xAEdje6ZXe398UKLtHKoOJFXqqTkYcous=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199021)(4326008)(66556008)(66476007)(66946007)(478600001)(8676002)(6916009)(316002)(8936002)(5660300002)(38100700002)(44832011)(82960400001)(41300700001)(186003)(83380400001)(6486002)(6666004)(9686003)(6506007)(26005)(6512007)(86362001)(33716001)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZU54Uihe7ElsMELMM8DMsqYIEUHLiALy6UzYZ/L8ccqGWOkZtzGDmf0/RPeb?=
 =?us-ascii?Q?iClG0Jn3EaoMeo+oEs/a5xP3F+9wy9ppQpPtBko9ZznWl6AWNUtc9nmUKmu1?=
 =?us-ascii?Q?hyQPlxXZm7Q8imoJmHyyr28skfSOwZF0z1qI7k7f4ITCfJmmz+tvxQCFGnfG?=
 =?us-ascii?Q?wZl9dIP+TgJV0sEGq7yqydFiL1pVX4C1+JWqH/6Jg6v9oTXgryilYXJ9an+5?=
 =?us-ascii?Q?RprPnCKJslYemQ09s3V7vpZHI5+TW8Ja0OCvd01gSMv0nFpEGsXUSk7gy3fU?=
 =?us-ascii?Q?AG3vGI2IlOx1tJ2yOCB45PKbaUSBCSj+14QIxxF7YDGLYAYF9Ag+k/dbVMCp?=
 =?us-ascii?Q?0hIOsR6XoAFPgKpSR38lswcKvx7UuiuFXEr3H4y2d23IAhglZAB/8duJcKp/?=
 =?us-ascii?Q?joXunOud2IRitTk8+0TwgTHUwi1lmyxUPuL82OHJO6tsUBOwzOFEja1U299g?=
 =?us-ascii?Q?GMrYSj6t9Pv1Cbtx9fUnShRJQwcBGJUyKsB7Pz4Lq9lelkebACiXAVk/BFJG?=
 =?us-ascii?Q?MeDl72qKwMqFeZA9EhXTtoIodL01cB9MDihsRhrkxX24EsHkDy1Ddk1g7Pv5?=
 =?us-ascii?Q?m4e1o03Kw7tnjhv51tp3v0G9n3+HUuzfQfjZKYsVfGJK5WMNBAb2gGrrqtiA?=
 =?us-ascii?Q?FaCLJit1dTaJZZNc0RURbAeVGUbkGiVIx2vqltWP2l4zvwjn/bWB+HqE1epb?=
 =?us-ascii?Q?HfwAHkWJOsC6sKCX0muaqqVS8TlH1SMSJSjwrRjes5H/bnqC12vRXZwVqayI?=
 =?us-ascii?Q?QWYTK5cIzJZhh5I17iFbZ5BBzdTa5h/wLemfP4mF1NKKBr+4RTZH8NF65W4n?=
 =?us-ascii?Q?w0fo7plOZJ6HKHAOtSgBjPRIsS/8a3NWRTyAXuLEFL1csWgKfLT0EanktD4F?=
 =?us-ascii?Q?4u966eM6MKV+xgzNXkaDTvliK48lbVCDqYa6L95jut45i+fMhSI2NRmx/VOP?=
 =?us-ascii?Q?F7KtYW4F5v5crFWDWwjnBf0n1qM3Dfi1x9o+PmSSO/7fexnipoJYyI2iDI8r?=
 =?us-ascii?Q?MsLJDB+qEaQSti0G1ewfMM/Qv8iH6TWM/TFVWnFgeLKkoHYizZCn6JD+eoN+?=
 =?us-ascii?Q?dT1Ghtm9auyRYCY7oIO3R/MgZLPbwi8JkRZrejEYidPRF6CFjaTCXhrjCOdU?=
 =?us-ascii?Q?SZyCYPrlL7HlW7QBaNb3UPxo2xbteqTYLmINl1wbXWpWZOdqsztvJ3L0Uhqg?=
 =?us-ascii?Q?H2HQprsRCVNKoXDcP+PEt85eRfcir3C2CsXUgKZ8tAMP+VAJyrc/kK7lfNKD?=
 =?us-ascii?Q?iNDSnhUQG79LEOB7lwXSH/3K0ZgJ8TmebJ6XwknqfX5xMj0Pby0xQVndTU6f?=
 =?us-ascii?Q?CGDIW4JPdJCPi6xJT/x/28ULWNxtcJBRiiV1hrCHf7USI1+uskxkMDnCzE5A?=
 =?us-ascii?Q?82rXITLNyBW/ZONmMudVcp5bAoX03fL8j2mfw6kyFWLRPUlAqR3hU/V0Xam+?=
 =?us-ascii?Q?LQjnYSnq2zSHzJ21MEkYz0OKPS8VQQ61O3bQydJWJ7QoFilKCsFKtx5/JoZo?=
 =?us-ascii?Q?jRC1Dp+jWYEU93QngzmJaijAyVJ17+8rI1FjDIB95n2egZc2adg0fcDEg5SM?=
 =?us-ascii?Q?pUo6VsWDd7xAzy/uzJEQ/GvhONLaPnsOlj/t11FG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cb5c8b-47e0-4858-aada-08db34d0a020
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 05:51:25.0935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7CObSQ6+9ECUg1QmtruzU3JicUwqkOHeHwTSNY4Wnai0igeOoWG99ZUnnJ1T6CO1HvM7tZ90jbb8KK42R2xYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:37:29PM +0800, Binbin Wu wrote:
>If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
>(bit 61) to be set in CR3 field.
>
>Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
>on vmlaunch tests when LAM is supported.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

and two nits below:

>---
> lib/x86/processor.h | 2 ++
> x86/vmx_tests.c     | 6 +++++-
> 2 files changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>index 3d58ef7..8373bbe 100644
>--- a/lib/x86/processor.h
>+++ b/lib/x86/processor.h
>@@ -55,6 +55,8 @@
> #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
> 
> #define X86_CR3_PCID_MASK	GENMASK(11, 0)
>+#define X86_CR3_LAM_U57_BIT	(61)
>+#define X86_CR3_LAM_U48_BIT	(62)
> 
> #define X86_CR4_VME_BIT		(0)
> #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
>diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>index 7bba816..1be22ac 100644
>--- a/x86/vmx_tests.c
>+++ b/x86/vmx_tests.c
>@@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
> 		cr3 = cr3_saved | (1ul << i);
> 		vmcs_write(HOST_CR3, cr3);
> 		report_prefix_pushf("HOST_CR3 %lx", cr3);
>-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>+		if (this_cpu_has(X86_FEATURE_LAM) &&

Nit: X86_FEATURE_LAM should be defined in this patch (instead of patch 2).

>+		    ((i==X86_CR3_LAM_U57_BIT) || (i==X86_CR3_LAM_U48_BIT)))

Nit: spaces are needed around "==" i.e.,

	((i == X86_CR3_LAM_U57_BIT) || (i == X86_CR3_LAM_U48_BIT)))

>+			test_vmx_vmlaunch(0);
>+		else
>+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> 		report_prefix_pop();
> 	}
> 
>-- 
>2.25.1
>
