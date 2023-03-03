Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A857C6A9133
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 07:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCCGq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 01:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCCGq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 01:46:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC030D339
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 22:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677825983; x=1709361983;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HJl3atwb8HrhRIDm9jGajrCFc1fG92V1ZWGK+NzbA4o=;
  b=efeKfE+nvWQSYnBtlqv7N4hDmrLvrArlV2SiCtM5MDjlsocjeCUlrxT+
   iNZxykoS8ctRF1L7hmrhFLLP/jLvpfBBA3hGiLWyfCOMkrCtpgmy61su4
   8USNbnYx39d9aRqXC/qOlAO7GSgKIKjEx3C7ytqRV9Nz5tbJy+eGWePZi
   +wQFhf2gGg02fYaFz9MYLVuw+p/d1pmgpt4d4fDqdzzpmTaW4c+JEsKGL
   VUAn2VR3d1zIh4CTdz4tXOo5Drird4ZjVkc/A4ItXl8YJumAQr+tZ7KLW
   RSI+sg9Hzt1mybcH3y95pBW+Wm5yfWTcsSN5abLik602vgMStFZiYUjf+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="362565970"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="362565970"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 22:46:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="785164022"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="785164022"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2023 22:46:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 22:46:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 22:46:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 22:46:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVWGBcH65gw7ihX1BAhVsEnBIHK1veaOAsvUkhfA6iTqUjmmsVx7cq4DENJ7+1bi2qaT1VKuliham2LBEJ8aiI0C87sgJHGQzaXySzARvreJ1ZR/xHsFxd3JEYYCNDgZSLa0P06QBTYB80pFPGD3lYKkc7TXceRnU1SbARXKMh+WIDXe9zmsdQ7/5Ux8+JTHAD2K7s/+xWpMXTauIThgdZrndOaOicpxIGxWPXkR1LJusSQQRYDY6Ob182xxrSoZu4RieoSu7bnWZ/obSa1a60biVrnH1+OzibArJkTPRTBckEO0C3lNxJlaYSqOWpCsu8/5hWQ1o90xCxjuHxo4iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bmyd1HfJ2keTVLGZVqMuoodlI5auzXnYIj652DkvSuM=;
 b=cTxdR2k46q7ufHba2B5iZLBqP90zeR36XwHE2xEbE1+1+HWQjx9h79enSj51qF4W+Jhuhav14ljNY7ycajJn4WoqdVzXhvbIt1wohIY3heJ1Yx7/XlDFjG9qkNEOJNhDmr1NY0Utf3CXpyBIx9883cTaRAJZ9S9+3pS5it3M6qSjT3qXZeUkqhW06U0DaNC2FNSiUQkomOmM3R95YbEWrMjygapB2jGlLgmR+jJaKVway2BJjPfyHBxawWixzKqLyZvwRHbYNlZtjT8m0Ymq+lf4N/7DZ53bonkzfd0sNTRdVtENCBRaI3Bht4p0dGZYOkRnId/dV/1IYLfKG5V+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN6PR11MB8194.namprd11.prod.outlook.com (2603:10b6:208:477::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 06:46:17 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6134.034; Fri, 3 Mar 2023
 06:46:17 +0000
Date:   Fri, 3 Mar 2023 14:46:38 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 5/5] KVM: x86: LAM: Expose LAM CPUID to user space VMM
Message-ID: <ZAGXzoI8oZgw20Zv@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-6-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230227084547.404871-6-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN6PR11MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5899ac-1cce-4065-9edc-08db1bb2fce3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWjoSkgTJyYYX3Nr39RnEtbpaFs6s0VNRhwTzQLRhvaYfueofkPkioguDsK1SAslV9eZltbI+jWcBRs/hQoDPSpHfS9n6FDtWSE638nPuWyIwTgo1wkwcTU17t4CHf3omldCisw4mADH6t++1VhXpQuJLTJWpW1lyGqjygYJsgKgFE+4yuzG9/NkOeseeG26Uqz4tl0wdQIIAl2CroryEtXFhpjLRYYHJnP3bqnDEqyOAcV1BQxqmyUDdIom0PiNlRvMPKmlKQsjEXg0Tl4OVerLai+k3n7aJ56RuouQBW4v/SQCER2IGRxnsb15UMRlVK0sSZMKGiFfUODn3qhhaEWQAwHTIpsHFK6yYQJPamq+VSh56GecrrGcaWM1ky+V4kB0nxtk1VfCgdzPb779/wq7tpTmx/MeRBhHymsWyam+inurXvelKPXLHMtMHRfbmk120O78O0BwggzQlw7dVWruG/h1kvLkpxh8xg+dKyPlwNcIOpv8nVCtUC+crwL66iYT2RtmoMcVLW6obGBnoqifxYXOxyOeDnwGnPMWHP2+49LZgP4Qb3jJHv3nhOw5CxKwZlJiKgq7zL184qgJUqtIAK248Pfq6byj+PJavM2/hJz4KVvz+HtfCurLfqxl5WHU9IhFepKFao7flekKHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199018)(6512007)(6666004)(33716001)(82960400001)(6506007)(6486002)(66946007)(66476007)(66556008)(4326008)(8676002)(6916009)(478600001)(186003)(316002)(83380400001)(2906002)(86362001)(9686003)(44832011)(5660300002)(4744005)(26005)(41300700001)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fmL5cCmywavxkCp+qAPQPWTj4pvue0v/mRIUpwnD+ZuTV2U2kR+6QOO+zRYo?=
 =?us-ascii?Q?46J+rZY+80p3hBmEJVjrA2dmdkmi6QbmuYQ8wn1MBael+kZOKhkZVTov4g1W?=
 =?us-ascii?Q?tVARxLIQZ5LQG/qpOzbbMbk38P+seQQDP/yPElgJHnYIpD+qF/Vm4UnjjDFa?=
 =?us-ascii?Q?Ude104kwpwPiIf0LzEgmjaZInRudrYVSWhaJH58Wkca+6Wrjsr2bY5uVOD7g?=
 =?us-ascii?Q?MU7HXmd/a19Q+M5QHZLKjWgKDb84NYSdF4U4zMMuTh1s9HQusQWMy6vPOD2E?=
 =?us-ascii?Q?sD4CBdieI5EaLQgaXk3u9678zlbUVopes+ivMB6xPShAQocOSpAwAiFVQLMq?=
 =?us-ascii?Q?gvk2pmFmKT6aEgD3B3ILGtE7GDMpWxkPokceWoF3rw3qBJW2y7AQJtqNmxIY?=
 =?us-ascii?Q?viRvK35Y1+N3QFpd+9Tqs4SomhWZMMTeICim1MB5fZn40Zzxm0Vp2sVMBms3?=
 =?us-ascii?Q?WhJ98u5bhxtQl3PfJhXLYvOf6RURHw7tQs3bWSFwfKt2dX1Lq2ETuxDxXzlo?=
 =?us-ascii?Q?T6SLgDAuxyYpgQlQO7dECbXlBVeLLuYY0mKgfahBm5pb6fwhO86I5su1Kkg3?=
 =?us-ascii?Q?Kzud6JBu/kAHQRFhCknUSZWajV1lBS1JxB+C2lKO0umfkUi5Ey4iJJS64eCJ?=
 =?us-ascii?Q?+orBmxw69O7b8IRJEDRubXdTUr18WvD7VNNbPCqKJARi0erm6djybE71RJb5?=
 =?us-ascii?Q?0eQtclLGNzGkdIWGBy/A8Hr6V2s4O5R1YtEoKnLoBf94yKOJICtbtPbl8Nc3?=
 =?us-ascii?Q?9aGNh5i1LY/7nblSxHnZvD+/J6MQR+XiRk1g4KZlHKrvXzdGQQmv+qaFz03S?=
 =?us-ascii?Q?BvuTRfEvJh95Hy+h73eifhIH1qkcUPdJ+ffORNSOq56ck3UvTXNOKLfYismg?=
 =?us-ascii?Q?rECjgvhqaKOXSBrfmO2fSxM/zReKuO8U17h/sP1blQZM+wJ0qbtQcLU8kC1S?=
 =?us-ascii?Q?O+3wY/Wq/RxO2Jv7GsKkuEKpR3An1yuSujTCdgWllBt+Z+IGxrOtPdz2L9q7?=
 =?us-ascii?Q?KD6R5mVmSuaVzlMEAKES5u4k9IrSNEaQZggUzxmZ6OsOz9psJiJv1LdkfVIg?=
 =?us-ascii?Q?Yzn37bhx/wXiWcYZICY8g/yv3/RaoE1V5Jis/LT5gasMMJrhgVqcALdjpF48?=
 =?us-ascii?Q?PTAZ2eXCTnpEXFJzOqHSEnTU0owVxh63FPDqCzFHcbsfPxvSFqZ2Zj2InwIx?=
 =?us-ascii?Q?dO4CM4ltP2fBCT12kY+UMOMlvSFt2fNmsK1+da03DJBQybOj6MfaQRN9tC4W?=
 =?us-ascii?Q?fPp2Rix1hF90TPwo8lMg0EOO4NacDs4XENpapbqbujHH1D290uZyKB/xx4D9?=
 =?us-ascii?Q?HuqAVTf9Sc3VceA6nkzeD3lMyYF+pKd/zrE+tYqEREfAJU3hEv3KZpln/++5?=
 =?us-ascii?Q?exktcPQq5HTOrcBWLWZdPVOOdLyeSgVnfkEmJJyidz2XtFfNdA67TP0QTHa5?=
 =?us-ascii?Q?34CqI56elOVo0FT1bxKUkuNTnvw2qmidOnRa6s7x/nKO8/Q/MmIYLBU14/fF?=
 =?us-ascii?Q?o54gtbEdyWGAQuMtMklX2qawHsjuKvrwSgbSLrXjiwKRHxeY0qzaiz+Fau8c?=
 =?us-ascii?Q?osLHw9qgzZwXr7KCbknqmuo/9R5SmaZwrlS8wgui?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5899ac-1cce-4065-9edc-08db1bb2fce3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 06:46:16.5523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PF1IjwaPC1rH09q9jTIy1XlTzeCt7I+p+H4rmYH3V54AhhFTXPazoPfEL1AWps9rdqSOJ791EUA5aeYrLPmGaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 04:45:47PM +0800, Robert Hoo wrote:
>LAM feature is enumerated by (EAX=07H, ECX=01H):EAX.LAM[bit26].

Please add some high-level introduction about LAM.

Maybe also call out that LAM's CR3 bits, CR4 bit and the modified
canonicality check are virtualized already. As the last step,
advertise LAM support to user space.

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>---
> arch/x86/kvm/cpuid.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index b14653b61470..79f45cbe587e 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
> 
> 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
>-		F(AVX_IFMA)
>+		F(AVX_IFMA) | F(LAM)
> 	);
> 
> 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>-- 
>2.31.1
>
