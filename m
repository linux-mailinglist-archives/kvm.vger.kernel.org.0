Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5308B6A7D14
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 09:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCBIzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 03:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCBIzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 03:55:06 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8842C23675
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 00:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677747303; x=1709283303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QVO9Xrx7ofcH1MrUq1Qd1JZudhcEH6tTZ7MwCBb9dUM=;
  b=MTLylMacqdeQkoyNQZA4jsqRSqEjorghgXuXWDbPZnQE/Z2dtzoMoB78
   gspvC9QAqRO4KgczI/RpRZKrYP59Cr5NNPyyrM4mKu2z34YIRs7Lf6x9e
   YQ+J6ygNwkLHPJ0dPgXZX25lGsMOsdU83VwQNax0+AWpRHvxlbiuQOCPC
   M5Vh2KZf2Y49asoZoJuZsJyzJns/j5EWC8mWwqxSwRfkwpFMmTi0XYXUG
   7sfNXOQeee895IaOkT8Y2//0dxPX+YJTY9Xz3OheJiMVtazvexgE6At4Q
   3lPOF7EtYDiyeIEd6Elroy/LwAEz77cFbKDvF5P3oZcfIfSwSdeYEMzl+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="315085246"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="315085246"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 00:55:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="1004034319"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="1004034319"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2023 00:54:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 00:54:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 00:54:57 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 00:54:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0bE1HuwNXzlJwNf9/fy+0gnapa8rXjKZ12o8SqeeETXpA+Z5fI7JbTbsRtypvAbTUBBD62D3uLMmmUymfqTGdJE0NU+vNOJYKeFvxOgysAs+Lc/vQsDUfXxs6/j6zCv/+T6CIayK03G+QYOsq9HZ4Nbc+PddPEKlXcehpf32saAAAOfW7lCZOBYUdlGlw1p/qDaG74PtCGBGEUKspJM6ixZ9vtnO5IPFDHfyKM4aKSOvU7JRTBhLQKVGZlvTH3w5H40iG7nF65TVTLvCeuh4SnoI0Tt+w/0HBGUSWONxh5/pSqJDhABworbQaKX2jEdIh3h9sE+Ygm07BYyV/6nFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BeP6INekHuJpL/zYWhX5USLZRcLz05e0h2SiJ2bcLE=;
 b=Ngq13T6AniOUK0Vr0MlyZP2JSJkuH0vepD/zg5kb8XOKLa+7mU6oAr7WeGgp4qPvyRbG0TqDQ7kWWGaI6MiTp8QXdTw16F523rw5zmfLWrV+kHP5Kt1V4oEm6SA8hvaJs/D+yWTl+weppC/Vfm98HIDEg+qebBq/UaZnDgzsE1aZi2GEIhNz6at7VpoyEoLOGQN1OWf+lPm2X5mSNhwd4YJ6gROXeV3VXUxBXzCGyK1qUMB1XIOMpfnT7IOO6x6bDhJ54G3Ao9zLpYA5+s10nt+tYFBb0KW9zZcMyEfKjhzYtWDZhgDjt+QddK5jw7s2MTV4e40G/OyvYaBJajvbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 08:54:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6134.028; Thu, 2 Mar 2023
 08:54:49 +0000
Date:   Thu, 2 Mar 2023 16:55:11 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when
 emulating data access in 64-bit mode
Message-ID: <ZABkb0wPffBt9W8u@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-5-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230227084547.404871-5-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:4:188::15) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA3PR11MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b7292f-8b0c-4bae-c0a1-08db1afbc749
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fn0N/j4GPwS786TH7n77s0FJQ94n+vqcOgkkeOsMNd/uLM+MBTUkMjG5fe4OSy66GEg96eJ4Hvx6XfPaU04O5QzeD24ZX8ataWJ5g/P8n6GmQmB/q1hnL96vzUpNcGPahCc3BrIUDQB5IX2SVKsy2Sln1JP1S10oCo5bGFhQAqgHoc4JJ4uPjDQeu0wbFbb3T/UpvqKDiZfSSg4qMgaEDAjZLUKXlrfUgHQ8C7qEoqljTKqhLwEC6ccqjyvVPh7UaZU8o3OFWLsrdU+lRWlHuMnPAyQvL6TOkX8eyPS4zBtoluKD03r7Z9kio5Q3TwQkeQ8PXiYqVzdE5vy670bAQLqiww1Rqo19uKBiW9bmMinPJE+GnPYdGZA0qJdrlO9jmCpJQ8aID/2U2utDOI1MQUtX4cJAW/PKesbQ+ctEzkhwQ9ZaOayyYs7eTGUmamo+R3TH6fPYXzeif5CESSbS/q+St6T0Dl1h+M9CNFrEEiABafvlzl11qy8XXxKnlpoRplkvWfpH5roMfjs6/6Q5iIvcQFibXofnx2zMw0QXK6f3Q+AF2sQtQQfxoTGYtTBqXyx9vVjYLxakSpQR+pfgjx6zRvjI2DuBWEU7mQbHtjeqSWmw4DXlR4+SZL4iwI/F+iEGV9UqukCnP3lq/qSyKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199018)(6666004)(6512007)(6486002)(6506007)(26005)(9686003)(186003)(316002)(41300700001)(4326008)(6916009)(8676002)(66476007)(66556008)(44832011)(2906002)(8936002)(5660300002)(478600001)(82960400001)(38100700002)(33716001)(86362001)(66946007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2nqPllHUX1tkcJXKuvg7OuSOVydqgKD6tR4aYtr5cVmy7OjCSRz5xV3mC995?=
 =?us-ascii?Q?r20ZttlbRVk66eW/oHjJeaXd88cotfGICq2t0ICSDqGgT0t64E9xR6kLGFtR?=
 =?us-ascii?Q?I6ZLoSuYH3fFbL0Y80QQB4fON1AMQ3kFmiW88+5MCimeVfc6PhDWkNFdmrTP?=
 =?us-ascii?Q?w8g5VNLNKKWQelr5KvVYox7a6LvkGe/8MRl7slPjGm1VtYyCpzaXO8hWDxsa?=
 =?us-ascii?Q?Knn54BALinPRiWLh00wpio2RaMBJ0DIVxS2pVW5VIKTwCncxfSmoZjKy6Xlg?=
 =?us-ascii?Q?RQWRoaEZcXYp7/6MXb6jOy0MQRvHdQiQfck3w03x6HQAlWk5ELFsuUwdw1zt?=
 =?us-ascii?Q?iNucWUZmRkd1rQA9028VuA4HauM7QIBHExSMEsLedjrwjGQrDdN5Fn3Du2SZ?=
 =?us-ascii?Q?576Hp26MsA/NTdvo8p9WW/2wfTg8hbDZhogDYpyOWK1yIBsTgyg7xuCS26/U?=
 =?us-ascii?Q?R48NCRIruR/udimMgiLR3YpQdjtY/yUKwRr0boRgP5Msq7HSE8dx1Saij2/+?=
 =?us-ascii?Q?YTatLcywhL70NZSKLR5EiaeMQS/MJQJg1oLjEq9RgSNPObgZy1J0mUW58jxt?=
 =?us-ascii?Q?jg0D7ix+9NKX8I6JYkKgXbhuoTxOzjZcrgQEMAyBXZeh4ABVaE2qSTgK3Xa7?=
 =?us-ascii?Q?tJkp7VR+1ucDagN3J/ZDEILkKab0GaDLB+ErY+BYwhUPWmXFhK+WtiY0Dsmi?=
 =?us-ascii?Q?SMDbjcIDV2DCIvtjbjHaEcVsH9f9LEhVR4Ae+T6LlOb9b0KV+A+y3xG/FbRq?=
 =?us-ascii?Q?kXf4NOkReYCBQGNan+ena0e9dyfzK8+ai1CNCKBiogC0uvOuIYEh4dG44Ot2?=
 =?us-ascii?Q?5AiUviy6Esb9+dj9r7f3MLAEpC+p63l1GfcjadfZPbdHEEyNJuodZm3w8rUk?=
 =?us-ascii?Q?IffAvREV/SL0pZ5SOW/XzUuJ5oi5dT4tpBALaAN0yTJDEaxSOacmJmEaaQ1l?=
 =?us-ascii?Q?lCSPCD+eKpXnkDKg7R65k+bICDoQKBMhIKagnDJEDzWC1pQX1Ks73Om3QPbB?=
 =?us-ascii?Q?prua4jbDNDbdJl2EjgEOEaV7EJOtxFLcUZ1rG9f/Nd7CNOtayWMkC3HWNKBU?=
 =?us-ascii?Q?7GGLDakTGPOX7RhcckPIPfsumYkpjnDa+/dvktUPSsLcZjXN01+zpjZN7+6Z?=
 =?us-ascii?Q?KM/LNmrki2P5G2qSRnnVIA8vJy97cPWP8u/qSt5mHD46ejTRyX5GL82+YrEs?=
 =?us-ascii?Q?6Ra9fNpag0VzwaJ2UZ+0EQoUafr8xpszz19UeWLIpEwwy/U96LtBQn2IwhBi?=
 =?us-ascii?Q?bzP0vNUhRQbs08pIrrJu277xyCiLTAfz7hYaqBFEtn/pEwggi9yWUps9o3LY?=
 =?us-ascii?Q?PAP5KFZAX6Y6GWEEjEBAwow3JpuBy1t/PAkcOMGBW0aOQWCUBxX+d2S9pemU?=
 =?us-ascii?Q?fgYaI9UL4ncmTlEDdmcTd7745whhOLjHVCvahXR7bml9Xst4t/eZHS8V9Zrj?=
 =?us-ascii?Q?9fgmBYHy0AX3xPGoXN6tbSpfBwoReONqeL4BtIzqKxxMLp1nfUGljX1gbhaN?=
 =?us-ascii?Q?gLGWg04kR/jYAL0pUY90Qs6H9bSa7QsmqnrcEie3G9aFmU7onuCETmgVJf8w?=
 =?us-ascii?Q?pGOSvZiBW5wDUVW0+hrJMdttxns8dYGf4cbyy103?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b7292f-8b0c-4bae-c0a1-08db1afbc749
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 08:54:48.7232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daAIkp+BiKmJhsFsDAbCVXdUdpuX8P73QbwgVHN8wKShPK++bPmKxSgr8LDVCFAHCzWJ6wKUd9E2wmM/MZEzag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 04:45:46PM +0800, Robert Hoo wrote:
>Emulate HW LAM masking when doing data access under 64-bit mode.
>
>kvm_lam_untag_addr() implements this: per CR4/CR3 LAM bits configuration,
>firstly check the linear addr conforms LAM canonical, i.e. the highest
>address bit matches bit 63. Then mask out meta data per LAM configuration.
>If failed in above process, emulate #GP to guest.
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/emulate.c | 13 ++++++++
> arch/x86/kvm/x86.h     | 70 ++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 83 insertions(+)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index 5cc3efa0e21c..77bd13f40711 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -700,6 +700,19 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 	*max_size = 0;
> 	switch (mode) {
> 	case X86EMUL_MODE_PROT64:
>+		/* LAM applies only on data access */
>+		if (!fetch && guest_cpuid_has(ctxt->vcpu, X86_FEATURE_LAM)) {
>+			enum lam_type type;
>+
>+			type = kvm_vcpu_lam_type(la, ctxt->vcpu);
>+			if (type == LAM_ILLEGAL) {
>+				*linear = la;
>+				goto bad;
>+			} else {
>+				la = kvm_lam_untag_addr(la, type);
>+			}
>+		}
>+
> 		*linear = la;
> 		va_bits = ctxt_virt_addr_bits(ctxt);
> 		if (!__is_canonical_address(la, va_bits))

...

>+static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
>+{
>+	switch (type) {
>+	case LAM_U57:
>+	case LAM_S57:
>+		addr = __canonical_address(addr, 57);
>+		break;
>+	case LAM_U48:
>+	case LAM_S48:
>+		addr = __canonical_address(addr, 48);
>+		break;
>+	case LAM_NONE:
>+	default:
>+		break;
>+	}
>+
>+	return addr;
>+}

LAM's change to canonicality check is:
before performing the check, software metadata in pointers is masked by
sign-extending the value of bit 56/47.

so, to emulate this behavior, in kvm_lam_untag_addr(), we can simply:
1. determine which LAM configuration is enabled, LAM57 or LAM48.
2. mask software metadata by sign-extending the bit56/47, i.e.,

	addr = (sign_extern64(addr, X) & ~BIT_ULL(63)) |
	       (addr & BIT_ULL(63));

	where X=56 for LAM57 and X=47 for LAM48.

Note that this doesn't ensure the resulting @addr is canonical. It
isn't a problem because the original canonicality check
(__is_canonical_address() above) can identify non-canonical addresses
and raise #GP/#SS to the guest.
