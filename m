Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7A791037
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 04:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349275AbjIDC66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 22:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjIDC65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 22:58:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD15410A
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 19:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693796334; x=1725332334;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JWT7bLFklHHgPnZibtjx+W1jgaYH+hFIG997pWLPZIc=;
  b=a+CLAf5IQwZs9PN6lkm0obRbj0LUl4ePI7ujYMtErkfEbSFPFjjdadUo
   7lzdeg23iHjXCjZ7/2rNLHSzm6/ldEfmwhCC8jI6Qh5LRkdte+DySLVvk
   we1fYgBPZE9OI4WKbq2vB7tQbX5a0aUS9KmbMLsFGZaAT9FePP7bbIVu4
   eRIhvKq7i+6VCar4Sad3sCQXSl8voHzC8JrgcQkHiZjXwKPOZy3k50ymi
   j+7RzQOz6bXfw7wQQoyQmV6cZiMWn0fF0sYK9KUI+/yeyHStR2EOVuc8R
   x9meGJ/y2zi+ze/gUa+dQe+uApmeGlBIQtCB/f24voB3Vo8QSRcGcJxxC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="366727565"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="366727565"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 19:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="734167007"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="734167007"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2023 19:58:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 3 Sep 2023 19:58:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 3 Sep 2023 19:58:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 3 Sep 2023 19:58:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ma5OcuKLBrvcxDXiDfcJklXUH8GQIODIYPeJI6AmD79qrmAYeHI56TAqZJ1reFfhjkiaWEZ6nTWG1kkTok8AZs/0y0iroWOPc0KFoif8AjmTrJXW7IRgCUefmfs5LL3SL5szuCotbw/43MFfGKZXOmJfdHhZTUZvT52pTzakIRdLuBas0xMYY8EBLcNVt8D8pYI93rubaine1mdRr49mnI+SIpB+Tpc4RRHl6jXK6ybQZtzIEDMy15a2IeddS/lU4WE2JgvrRJRuXjPaGe7u8/NDTWDIuSYfyd9xEUJD5OPRMUQlYT9OS+w9npuniuKgj+jg/gDFf5NCX6gc/BOfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dL8fYYRs1xYW0V/aimVnNPLMmAsvPsm17g7HXDQAfKk=;
 b=ndCjSVS+YJjT/iAoxshXa0C2t57u+f6GnDiZGgsO65FBHFpVLLTZvCAUoSzbksyHj0KnZVhipK1n+OOxJIv8j2yZE48/iOl/Io0oqaieqouLoa8N2CIFlowfAUlMRA8OuteCcrGfmt0I5jjRUubQa22nShN3SDh0k1M332Dnzq6KKmu6VDTzJ0eq8VtfFvO3nL2d9xglfHkEGyaT+vfUoNTno7UO9/8qNgXxC4HOX+BokNkH1G8xYgacatJTTKf6TPAKKvG5JT9JiHHTcqD/U0QboJSAHalZtUN1BKUsDCShNbU/xTNh8a+RV/Z4C5xlOXtXsQxFICFMJzeUrjINIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 02:58:41 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 02:58:41 +0000
Date:   Mon, 4 Sep 2023 10:58:32 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Tao Su <tao1.su@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <guang.zeng@intel.com>, <yi1.lai@intel.com>
Subject: Re: [PATCH 1/2] x86/apic: Introduce X2APIC_ICR_UNUSED_12 for x2APIC
 mode
Message-ID: <ZPVH2HlIt1K3c0Bz@chao-email>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-2-tao1.su@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904013555.725413-2-tao1.su@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW4PR11MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: ee2fe526-9c15-414e-be07-08dbacf2d7f5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZ4DFIFfQWJ/N6QqPoR/K81DXN+kks52itvg+4TH+a6mtcpraTh/I8eJnL3LgodnKf5goVKhI3s37RlFbgHP5gAKk/kGEVpBA4DqJR/WucufswbB28Cd5K/NW3QWe07asrbD8alb01GvuN0GVA9GLbtcIeiomJfpBHe1L10o/VnDtchX86bGijinEho9YMl/DeoCllDxjDlB3sU5zzJ9h6KC6c060VDOyMDEVhyC7ZLiyukHrK7BzWvBb1hutrEVaUKdq96sSObVHveWPy/zr7KewadDpx23BlN1XffZaFJTSGfI/kZAaX5zZl8on4q9xuyWmzQe5W5O+F1pqrKAVc2fiVO0qE+VXxrdnt1oM4LGoIlN0t+X0x56hxRGrm/aHpHgrcqWXGHEGRyY5AVVUc7L9gv5BsJxEjRRRn4DBA+ibZDU5x7f0P3ifQLHEFsSvD9MXn/3rRGfMWilizjSjHRWTHsnoNv0N4MJ2bg4N3Sri5bLIc/hi9cFvMchmI7oQU9hOUWE4zVENVpFhdrXDX4fWNQH+6GZx0zIdL6DNYXOWJTT3Ue/Ivdr1W6U1Tk0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(136003)(396003)(346002)(39860400002)(366004)(1800799009)(451199024)(186009)(6486002)(6506007)(6666004)(8936002)(4326008)(8676002)(66946007)(478600001)(44832011)(26005)(5660300002)(66476007)(66556008)(316002)(6916009)(9686003)(41300700001)(6512007)(2906002)(33716001)(86362001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qrLeS6jS9nxkDzhnCD4JspHYwfKa7LKb/SZrXs1QoRMARNsKJUHA5Y1emSmB?=
 =?us-ascii?Q?/2CGb1j5DDV6M6oY5331xorjB0lB9nfOyfpmCqknlPPzjCJ27Vtg0g6+eJBU?=
 =?us-ascii?Q?J1Ayv2OY+l/3IYJi03czrS+JWoZ7xWPnNs3JRK3o16+NrpcsV/X1WAnUW3GK?=
 =?us-ascii?Q?e+16AZuG9YUjmEBTye0T1xjxfHMf3lpqE3CWdJyuS6UD/b5TCYCXN6xMn5cx?=
 =?us-ascii?Q?zutoofvHbQY4sfpsb6lbRigmCa8ZJsorXiOdtuArJKgxZT/VOaYb7h5AieLN?=
 =?us-ascii?Q?lZ8WZ9onlaxpcWZyKJ3TXghPU3KHT4WcAp42IekOFQUOlRQ2WuBy82D/TOC6?=
 =?us-ascii?Q?N+NHl4AobL1DQam8Sf9EWAjGBDSY6SK7IoRltM+Ub9OO56bZa9wuS19XVq6F?=
 =?us-ascii?Q?2qNypKf6aAYPxK4wDUz/l8YVfCBZmjc/3+mpr9GZqTWrSsPHfAbvdeVx40YD?=
 =?us-ascii?Q?pILfK8IrIJoFt0Brxz2f7QltsIOUO/z3Z0MXD3zxo/cgDvLRmHdvOF/4pmuN?=
 =?us-ascii?Q?C4pA3g331yfxFN8IEwrZZ+FCwFOk4nxM+mZBCKentsXPR0wx7jZkZBhB6l3M?=
 =?us-ascii?Q?7Or2GtKSCzJqrqH35GB/Ls0sBDIzjtj/d1YhBTot1e1lgyMd9qZeJ0dESTfw?=
 =?us-ascii?Q?m20pAwqbsJs/okT6HmImQRAmzD4EuhTn7VWDt4rTjkOE4ocsvDkQzimrTubm?=
 =?us-ascii?Q?KkupopucsBBrKjpzlugh/nLxKtGqyQl9XGq6yjGQgSNrFrfvlexsoc4gA6eI?=
 =?us-ascii?Q?OiGCeiOE9pOWL9067UyaaY70fkY7knUeK9M+RVbKOZWSyoVKnpQE6YCXPSrg?=
 =?us-ascii?Q?lKX8lhILiIwPiLjcIMwLk8z5xyL0d6PrhaXGby1N8WKXO3iimvwSeub0EFo+?=
 =?us-ascii?Q?PS4twaPMj6VzkiBwjw5sjRuFQL+xEFShNRCRYPdwpcZsD/24E2ac26TNIkCu?=
 =?us-ascii?Q?doakGMDrs5ThS9uvMrpJW3m1ywJFNU7wMvD/jJoIf0JZ/3Yw8NH5r7hxProC?=
 =?us-ascii?Q?Kqkgzx4kq0Y1I/Xlbh67FUkuqOeN7v5ju6ZM9/JQWSNosah1WsBUKi4v3A0m?=
 =?us-ascii?Q?goX7k3oObjXlADUuvMZSYmI9heFGKGdzdEw7c4qvsXo9RsWhrCUb45dycMaB?=
 =?us-ascii?Q?nIe+SjdF+cZllEImGO/OA3QxxURJX4ngR51NpBaZ7dFEy8Blm0rbKLH48Ggi?=
 =?us-ascii?Q?ppd2uAHnfzryjHHwKGEia0VWu3JKSut5cKP5ep5eeHOilHakh9WqSlKnIS+q?=
 =?us-ascii?Q?x1SpC+KEIacKcF2eDKGiWxvQnbxCgWwKGZjXXvmys/9JPEydokycAF+FPqPK?=
 =?us-ascii?Q?E+m02YNOyMJXaY8ckms8u31LMy/TmlzzpwFycafkjAqW7ArZzUiV/VGU7pwu?=
 =?us-ascii?Q?ypIeZ3bOBmEV/BIRuSXdo2RPCwKEquhQPbDvv/AbzGtbyO4+zfizUANDBGJB?=
 =?us-ascii?Q?TwGXXnOVz71P3IfPSk8fsRYhKW40GUxxMv73dkVtC68QR7zpBX2QfzQm4gL2?=
 =?us-ascii?Q?IlFDSEvqjqZ73mwq90/ZnUulerAPupVVwHnuUJ+YK/A/VJdtXLpdEpjihox9?=
 =?us-ascii?Q?+bcpm3KsuZKy+f670BOKeGCWRDIsg+UBgd39sZ+x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2fe526-9c15-414e-be07-08dbacf2d7f5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 02:58:40.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+CCQJ7y8+EsrjFX7xTF42RA4CVPBePLqLlicjspxVsUpKQ+mYVlX4kamF33/VmTJErlOVxXK5d+6yMWG/wz9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:35:54AM +0800, Tao Su wrote:
>According to SDM, bit12 of ICR is no longer BUSY bit but UNUSED bit in
>x2APIC mode, which is the only difference of lower ICR between xAPIC and
>x2APIC mode. To avoid ambiguity, introduce X2APIC_ICR_UNUSED_12 for
>x2APIC mode.
>
>Signed-off-by: Tao Su <tao1.su@linux.intel.com>

Please use scripts/get_maintainer.pl to help create the Cc/To lists.
I believe x86 maintainers should be copied for this patch.

>---
> arch/x86/include/asm/apicdef.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
>index 4b125e5b3187..ea2725738b81 100644
>--- a/arch/x86/include/asm/apicdef.h
>+++ b/arch/x86/include/asm/apicdef.h
>@@ -78,6 +78,7 @@
> #define		APIC_INT_LEVELTRIG	0x08000
> #define		APIC_INT_ASSERT		0x04000
> #define		APIC_ICR_BUSY		0x01000
>+#define		X2APIC_ICR_UNUSED_12	0x01000
> #define		APIC_DEST_LOGICAL	0x00800
> #define		APIC_DEST_PHYSICAL	0x00000
> #define		APIC_DM_FIXED		0x00000
>-- 
>2.34.1
>
