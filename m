Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6CA7BBC7A
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjJFQIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjJFQIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:08:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9D5B6;
        Fri,  6 Oct 2023 09:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696608484; x=1728144484;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=75bnDpHB1P6CVkGZ5JO5om66CcTmP0Th0MgOjcd1M3A=;
  b=OPoJCN0VXKstd8gJny1Ny2QlTKFthh9007Vx5rxSQlXz7UiltNSJ3wYu
   F0kAIh1SSfOQJF4p48/wQ+6OuFUhpz7R+RPUd2/A7JWn7RfHlZiXlC4ZU
   s4hNNTQxXhNt+WshAAqhRxJCg8dwnxQX8ra16Z78dJbTuVIFVMfFr06eX
   1RGy+Ubq2Avg3YGuwWhBDrEfMRuChv7Vc4STDhdEYtAUSrJMtdrx/Zx+P
   ZTvOfgtP9psGq7cM+2Y1HGTApCEeDeYQRURV43KGmgigb9DxGPZ3NC9FY
   y5W7NqWnuCEEFLbVdw6/0/uKQtqj18KusTeemQK5/KKZzbJg5ZJi372V1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="368853815"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="368853815"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="895939976"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="895939976"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 09:04:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 09:06:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 09:06:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 09:06:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUt/jlhannskvehxCLMrSTsHM7e2LeQtTFvSo/+OBvsnFizvuE403ugMG99IsI/yElbeAg8Nfpf+OlGCDwmwvq4DRkFagbhh772TIXu/qqHKBBhxnJ+KcTVIPbjFg57Bi+2nGUMS7WBx7lO2IlUUkPAGnYc6kRhF2vY4VaUp5NbSkOqQyPC2JuK0RUCfL9JBaNuAneCxVggOwEw7CI4l5q17ONOARedc8duIVeSCGKReb7Z7FBidhZ3HeeUtP3CCwG5vF6C/4K4z13ZKeV+cSCrcZIRFTDCjV8qloAknnZXfSW73kiSiBu8tT+6vqsrAfYM5W46nW42kxE5zDtDTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hyFpocWSDdhKBCwhlBJkRaD58U/F0qQUO/MsIgygkhY=;
 b=jZT4RbDwOhU7oka99znFsIMkeKgKAqshri1P0Oi+jI0C2TNXOk4PnEyZ4AXcyZVcx/FF2VCxIf1vsUoxY6xji44LwmdfP9G01vax1ojtGN4VTjD8Zlu5TgUR85NakQEeyl/CSS249GVELVTgB05hy1ugYrstDfrzhg4/tppXUqZfRkiSU5SUyZ4vUpKUi/PWWpcb2pBCYy7rK4nBPumfkywmsJTUABKXnj/B17SsewEcNFuWv+6SXF24HZCEug+kG7LgZdS1B+ExZHFHhGnvkw3oVQRehjyuBoqPvVKTcZvAZK4ZMZaX0WaXJJAC6YYi6y8mKet0Ew7YxTVNHfbKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB7541.namprd11.prod.outlook.com (2603:10b6:510:26d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Fri, 6 Oct
 2023 16:06:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 16:06:17 +0000
Date:   Fri, 6 Oct 2023 09:06:13 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas <helgaas@kernel.org>,
        "David Howells" <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Wilfred Mallawa" <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: RE: [PATCH 00/12] PCI device authentication
Message-ID: <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
X-ClientProxiedBy: MW4PR04CA0361.namprd04.prod.outlook.com
 (2603:10b6:303:81::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB7541:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc741d7-84d4-497e-5c25-08dbc6862c19
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDAiDAMAv1mhetfphhyHee+ePYwnrtJhBkTMmtS/gbT+m4+9DYUp1U4vI/1TJ9ae9B3kPuFsHbeG7XsYPovsBFpoZ8QAMT19PenLKO6wNvar3n5Ex7kCxgZFDz/iAAMe2RoA2T4f18x8+7AffaafuKOtU90kIl2T4Ie+VTbeHgcZm6TGGyd73jBdmnT5j6xxRiI0f4fJhV1Ts5g7pkbBwm355iH0d7QtpYfcxIDMr0UWH5SOYc0Xl5I1U3M3yxR4rE1/cOJh72Dqy6vkex3c2iG8LviFm8oPQQQGQzzxRE2YC5ORvBmKPmfxpG7qgBJTRcC8/21B4jjWr1AE4y18KoWtFXJK9FgiV4JbvOVvJzst85+gD0mnUx41k61Hb9zsvkrP3xJjooWQzLNrURK20sZmJkjNkdF1tQ7yERNk3JC/SBvc0Od22Ah0s/q3Qkd3Xv0D6hMXFA3llfLVyPjV47itWUe8xLEcr7RCrXBUQ9YmNyXRDWvloMO1iyEG3KwftHohGNZA3cTMhkkC6gkeI9pV3x425tExEgQQrhCpRBFl1YKLt1LYgr++c8b634Z8iYAK++9gFd597ZiXyWr/qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(39860400002)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(26005)(9686003)(6512007)(83380400001)(921005)(82960400001)(86362001)(38100700002)(66556008)(66476007)(478600001)(7416002)(5660300002)(66946007)(54906003)(966005)(6486002)(316002)(41300700001)(110136005)(4326008)(8936002)(6506007)(6666004)(8676002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uH4Yto7NDt9Qr9wFIHmUQJm4JNpXDgtRVOo9izLE0bGYHihXP+40ij1VQQ7v?=
 =?us-ascii?Q?AV9sJdqtmf4HQ3Mee0ZKS/e1aCFwVq0fdSksX/KJnflcxLRgjgyLfZ8KV6/p?=
 =?us-ascii?Q?/GVdEO0WgzToYlEQ/VjTMWZwXiDpQ036jtWw6EkXqLlxiIL3KbuBvPM8q5kg?=
 =?us-ascii?Q?Q51ir8zT2rmPjBvQTu3n77M0kDDPg5Nhn2lsIMbTzmpeDagSjah1nYcidh+r?=
 =?us-ascii?Q?L3/1X84eJS6S4RvG2gZ30xMoZdvn3oYRYLFY9X44GBixwcPpZZz5F6UlY9La?=
 =?us-ascii?Q?K1zMOYtubk68ikRu2damnS+hOw50D6fl9X4XxfvGgyrsGC7bBclnmsgj8pVx?=
 =?us-ascii?Q?11BjnK0mmfsNSXmUuvz14U1skBt+M2iiR71PvBrNc7/RSoAEa05es1zN1OfE?=
 =?us-ascii?Q?PcfS3Gkku/ziItP7QKMpQ1vHgvFml+rQKgctbCwA6G2SiKf7T/Ws4hwi4cns?=
 =?us-ascii?Q?D+AJjYfoeQUujO91/NW5lAIwgVoIYdfsmOJkvavqkQm+nXsCtTTdUwGRFyvg?=
 =?us-ascii?Q?0/dOSZAvP2epTdyBICQ95mIvHFzZbmDVx+GTBSkN7xT1yTzC+YGmW8u1nFY0?=
 =?us-ascii?Q?r+xDZJN786JfuER0gdDygt3xKECvmYSrHiZ32WA86TN8NYtc/r6cugBztjMn?=
 =?us-ascii?Q?bBXpiGgbBwtG4NP14E7PllCVBQhd49HnOjr1cjXPfruvFzbLJppWntjkGFgI?=
 =?us-ascii?Q?S8cSIPKgcqCDY5W79AONW+URLzmF5me+d9LyF2RcN0++z2AZnOZvkQcN5Zvf?=
 =?us-ascii?Q?mFMpO368qM55Q/qx/y3LmpiAF2HBKrN8EVHEsypMJcCy7gNsVqwhJnBKsBI6?=
 =?us-ascii?Q?5qMBkUZZIwcFm2+ZdcKzd3dhyaq+43hicFkmXmKBo09a6IJ4zFATKZMf0Q3A?=
 =?us-ascii?Q?Zmy913hDffb2pom4gDJNMQiH3T54mEGM9c0FroS7Jbep9f8JinccHEPlDWTN?=
 =?us-ascii?Q?KGimkJ/vK2+z9LjKJ4A20RNtZ8oB5hq9P853NeGlfG+wS2Ya1IRKnQXr2WXL?=
 =?us-ascii?Q?ydyH7WheqUTxqcTvT2UHOIXBxXG+/5clcX/MyPW8DKvcQ7N/xA1G9jnuwIUL?=
 =?us-ascii?Q?3OY6+gxp1nGOiubc1fhVvGiMj3cgTkzVMLYNFuMu1nHxH1Ps5s6YXt+0aAQ8?=
 =?us-ascii?Q?fUEuqm+o8Xv5yBYkkoHEcVjgdmYyYrEuEdmxwdsXU4K+CtmL4Bj5yXqb4gP4?=
 =?us-ascii?Q?Unx7Pcl7MCyKXchblPQU8l+lckjL/dHIXU3Hhn8c/in2lBvWdY7/9lkF436q?=
 =?us-ascii?Q?blCxiFbjY+ewzazRhZ5ibZS2MBKKPvBufSUANW9EqTfw9N536RWoF+D6RThx?=
 =?us-ascii?Q?MOeLlAYEiJblA54RsnfYMc2RlARl/rFtlTCtM0ySfs19DflOArfs+CZHXj40?=
 =?us-ascii?Q?dc2MgCkfX1g8AZxXBGqFsNVxczGac6XUQEzrtgYwoxMMMLTUkz/A4FPWiRg6?=
 =?us-ascii?Q?YE2jeU0dgX1pqrJEsyyAPOpDxn4PUXbbolmsUJIwq2jt/BbeZRa3eShE6B2P?=
 =?us-ascii?Q?CE4rENqvlckff9hP7v7jewn4/ykUbAbhXdWXQZiXmfgW/OhMQDCpgKDYl3M7?=
 =?us-ascii?Q?pJVZezH1FKFJRwSit1lBLzJV2MJDAL0Bh0fZmD6BOQ6CPYdK7IT0ELCI+tLU?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc741d7-84d4-497e-5c25-08dbc6862c19
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 16:06:17.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Etm5y+aLlnAC/GrJQTGrP4xZ3+EzT6qkhuse7Rq4Zo4UcIJTYcxgUoQ/81CwrY6RUHUu2CN4sXMhXrYRgIkXzDGu2pGNzkatmvmJIsuO4sE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7541
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This looks great Lukas, some forward looking review comments below.

Lukas Wunner wrote:
> Authenticate PCI devices with CMA-SPDM (PCIe r6.1 sec 6.31) and
> expose the result in sysfs.  This enables user-defined policies
> such as forbidding driver binding to devices which failed
> authentication.
> 
> CMA-SPDM forms the basis for PCI encryption (PCIe r6.1 sec 6.33),
> which will be submitted later.
> 
> The meat of the series is in patches [07/12] and [08/12], which contain
> the SPDM library and the CMA glue code (the PCI-adaption of SPDM).
> 
> The reason why SPDM is done in-kernel is provided in patch [10/12]:
> Briefly, when devices are reauthenticated on resume from system sleep,
> user space is not yet available.  Same when reauthenticating after
> recovery from reset.
> 
> One use case for CMA-SPDM and PCI encryption is confidential access
> to passed-through devices:  Neither the host nor other guests are
> able to eavesdrop on device accesses, in particular if guest memory
> is encrypted as well.

Note, only for traffic over the SPDM session. In order for private MMIO and
T=1 traffic to private memory, coordination with the platform TSM is
mandated by all the known TSM (CPU/Platform security modules). This has
implications for policy decisions later in this series.

> Further use cases for the SPDM library are appearing on the horizon:
> Alistair Francis and Wilfred Mallawa from WDC are interested in using
> it for SCSI/SATA.  David Box from Intel has implemented measurement
> retrieval over SPDM.
> 
> The root of trust is initially an in-kernel key ring of certificates.
> We can discuss linking the system key ring into it, thereby allowing
> EFI to pass trusted certificates to the kernel for CMA.  Alternatively,
> a bundle of trusted certificates could be loaded from the initrd.
> I envision that we'll add TPMs or remote attestation services such as
> https://keylime.dev/ to create an ecosystem of various trust sources.

Linux also has an interest in accommodating opt-in to using platform
managed keys, so the design requires that key management and session
ownership is a system owner policy choice.

> If you wish to play with PCI device authentication but lack capable
> hardware, Wilfred has written a guide how to test with qemu:
> https://github.com/twilfredo/spdm-emulation-guide-b
> 
