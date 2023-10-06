Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9C7BBEEC
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 20:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjJFSrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 14:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjJFSrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 14:47:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D1EED;
        Fri,  6 Oct 2023 11:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696618050; x=1728154050;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AwihL76GIj+fmytdDU/wZh/Vy5GYSWiREuB1hcNUR6Y=;
  b=gwag2ccUsHk/OZrYIMCnRPDRVCHGEF/MdXB37j3HLphAtAlITnZB8Ub1
   jDxe4exSgkxnoAqcv7nazaBCjv5f9mNLr/joyGzGfro8N3qNYD5712qmo
   nqAOBy22jIYGWzpcLS54rZOtK5U6BYhD//FuTrR98aNNJbBx+pw0RWH/6
   9+QcF2t3xHfD/dhKBTd68K/QVI16yHG32z1rruzrUSsbtdYml8F//Ib3O
   gltCTYWVgfJU4I2XoPeuEghKMMW+TttlujEweqTpM+3aRmRRyZ6fQ/Exg
   GS4tbKh7kL9fnVEKHwFpj+yYkkYSJVmkKcWUxsCEA5FJIw1OnWnm7m1iU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="386638398"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="386638398"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 11:47:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="876037750"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="876037750"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 11:47:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 11:47:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 11:47:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 11:47:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpMF+VMCvPka7x2Rlv98breXaaxaCHlW8MulGrR+wyTi/j7kES/RZt/ngOkc3dCYTEr68zSNPhKeYz5Bjt9bM6P6d7NgBBnL4cnxsEcTmjwvhTJLiYXr429QaY+BPmJxveyWb5GuOEknHkbLRhA7cHU8M7V0HDuGFcSdNupkbyI3Eo6B23t57IXOOYAVVAfzvUcuuJAsodj5xe/x4aU3E1dBvgr1xSCZJnRo6VXi1g3cMImnFuBFDZqtpdB+spMwlrJtS5PtF96yMqQfSVYZkaZmDIsx1eT8USzbWXs2ux2pZ+7IgGQ/qNJg4gZbaosZUZ9UPg848ah4J7edZeZgbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wE1E42UqKpSzWYYReszqavI5Q/Nzmd6D3MkxQol1UkY=;
 b=BIBnptzK1EJHrLLC1R9RwUCwc4hl7z1EWjJ4yGPulMVj17svRYoBQ3BM1oMhznEI7hE4nxin/syH8DXKhGYAXtsuGgHWYmNkNBLt1gwqbIseHUnoCLIrv6f7gLkT9JRHNZSZArRO8PLb1EicylR4kJ7z/t+PR6x+7mNsGWL1elrlVV5O+lBVXJbEo22MQ0y1Gq9O/4GZb3TwgLg3dDoSLCJ/KU0ucP83yTl4C+nRyUC+0XBs0G7TYcFd73xDipDhIkelP9qEO75CDbVASERGQZP/Cy27FAvX8XjkLyCB50lofPvoIG9Pfo+hipKwjg1353OjqbpsqqqOs2c28Blj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Fri, 6 Oct
 2023 18:47:26 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 18:47:26 +0000
Date:   Fri, 6 Oct 2023 11:47:22 -0700
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
Subject: RE: [PATCH 01/12] X.509: Make certificate parser public
Message-ID: <6520563a5865f_ae7e729459@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e17d1e2-34d2-45ec-5dce-08dbc69caf89
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTsWjs7dlBgy0KuOXoQp8zwWZKfgE7zkfm+udJpN4t179AdMlFtN1TeSeMhp81RT0Kq848En5woK3D8+MlVylB68D8BBQtek28w8PimduJpLKsnPyo0+Lup+kCq1bh6Trp6zZhABETmGXemk7xyAPmgEP3V8SMY+kf3G5b1Qz0129ACCAnX28OQOxxQtl/ysiEqenQjCdu7/hXHAm0r0poWrkNuHhgGABt3ArmuP58nWEthsHC+TzlO2OWzb/Wlvb8ThbDi/kZVxqABVb1hOolofnvNncnMlo6cvRRGR/fqpb+70zXqqBbjmXvOlxRCodKEBCI3C3XH9OO/Qv9hRzzgnGxAIH/UYtAq0iCxnlcl5UFU8YtHQEmzjgleBasYcmo9f3lMr0Wlqa01lZTJ8f2TE4RND/hMNIFmnOhiedBUBQw8X3SZDKouC0yA43R8hT3cNCVwTkQfPoWGQfPQOFgW67j9SnQBIWk6edQh2+1+oKsXdv/4aqJdT/r6q1Sho0KV+HIHkj9iL3gnnExORcYIMmLk7acHyAWIPkMvy1lBCxYtDpuRMb0bp5DJhWkVKE43V5CWykAlXbE8w+hf0m1tiZFMPm6cyfRBDkJCNCxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(376002)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(110136005)(66476007)(54906003)(316002)(38100700002)(41300700001)(66946007)(9686003)(6506007)(6512007)(2906002)(7416002)(83380400001)(26005)(6666004)(8676002)(82960400001)(4326008)(5660300002)(8936002)(66556008)(921005)(6486002)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7xM1oNkjSoC7JcBCjXenNOiaHblaHIjJkFOrjYx2TmMdnGRIpksSIo4wIn2z?=
 =?us-ascii?Q?Wl/brdVeD5X03XfvmQTTS8RlmdEyD64JojBzA4dkVoS7RIUsfIYKSUBhRYCH?=
 =?us-ascii?Q?1LyXcB9L3TSvQ2sfaGGDAll/SV8s+RMXvaAlTYNnrFILKK0zQvVGr23olix5?=
 =?us-ascii?Q?/KwbCfnfjJfYMY02gVLN7csS3oHEzMETaNkYx8JGrkm7YvOLQc+wEFwoDvFV?=
 =?us-ascii?Q?0sWuJLm2yB8ZXfVk7qN5xCSYkG1Ih7Vyjh1HWCD0sLKGC0P6m6brUbg/Ag8w?=
 =?us-ascii?Q?M8/Y8071OVR+an4CrfiL42bKaXQACh6PfBFi5PUU4ULCJ/OZtjIehmYQ44HS?=
 =?us-ascii?Q?7/gUovy9r9aKY9h7z67I02+WeUwa+hAZolOmT4Qdu9ybtrRbtMYZuLlMBwMp?=
 =?us-ascii?Q?/CzZTv30wFg/OOUzpMCoBCpLAF0bIgnpj6bc+21UIfe8Iw7xsizDNx8TGrXe?=
 =?us-ascii?Q?vwQdL4FxTRBLe+KkcY5u15oAvZDdlj1nZf6g6rAR97q/K1Ek9v7TKWt30yLe?=
 =?us-ascii?Q?K1eSlENTQNiDu9QWiZuYq3Durk8h9bGMC67/7wwe41iXjyLssK7xdN8cl5sX?=
 =?us-ascii?Q?n5KWNaslrUG0PxJMVGtbHMYjlL8f2/tBwE7lU/rwuiIzryeZa7t/nyitMvUU?=
 =?us-ascii?Q?vT9/yEpyJuUjmwqXbdwf5QW4pNllKXBKmiCNdj06Bb94JBiav43w7VZICKvC?=
 =?us-ascii?Q?nbkvLjS6C6HhPDDhbE2RIGm9FNQifAbLZ3yYpDKItwDw3MNAzgplutmcOFqI?=
 =?us-ascii?Q?yAm5wWjV1sXgm5krwMp/Ks+vCOOnV22zJDAfVPxWhdzlAHIZuRAaTTByoxcp?=
 =?us-ascii?Q?cVNLib5OQvq0OlVA8o5VBqMQwaoCyGHfdXwgq6Z+IwmT+d6RydusAK/hI8lr?=
 =?us-ascii?Q?bw1g2Ft7GJBGii60Uc0CzljhbA304rkLPt6zOE3MPUpzrOZ+fj/oif+LxsrN?=
 =?us-ascii?Q?6P7yK6DKcnL2rsVVA73ZxOQda8fZvRt1d/PxYvnbLtNus3XnlST93TBZESjC?=
 =?us-ascii?Q?Un4DoGGCsGLBltrb8CqA7+TA0dY7xazdXnuAMTRrPUIqWKyV4sp3/HwWCrpu?=
 =?us-ascii?Q?/OzK5P5CJMr8u2PDsevTcm4W7zLrNhkF/Erk0H+Gx+GW8Cmbd6zaINS2XGwb?=
 =?us-ascii?Q?M4eP2InE4FbPu4xRPdFVGFvIt0tu+lWfDz3AYSUarePEliNtvo0aqhyRuUwT?=
 =?us-ascii?Q?hy908nLPDZ2W3AL/2su3f0eT/zC3BPyWWPKSk5bhe6ZxrK63ouR7KZWY7M06?=
 =?us-ascii?Q?op29LYX20v13sHiooV8FBFTjPxO2x5iFIic+Zxe0z7Vp1TEOn8nTf23dWKDI?=
 =?us-ascii?Q?z5WYBS/52s3jyHzBRnrf+NNmOlGX0BSXNwruN8Cey3bXakBZCbeSO5dRxVCi?=
 =?us-ascii?Q?mtjphPZSD7tavj53VDWDoxHW0YQza36Fy6x0dELWBVdF4OaU+uMXAwr0cE4D?=
 =?us-ascii?Q?Qa9OQ3MhPoeF9dXTmyMH8WAtA6ydT0kiAtRPoA7xFX4RKKCLAfEAnhRybv/k?=
 =?us-ascii?Q?IB1+1ovi3EihmUv4AgE4ZsR5EJRm1GP1JBfj5G/VKC30d4ZH9hwBunqFvxVL?=
 =?us-ascii?Q?LSc38O9/HAYf4feO1WnVAjJQRd409HnxI9E8npVBT78fhRH8IRzFVLcvCTl3?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e17d1e2-34d2-45ec-5dce-08dbc69caf89
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 18:47:26.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zaoqZkJ4WA9sjKYMx/e/VXdieZeYV9P5WAJ2UwlhQ2TX4xt6lHpoMhM9XBmrYqD1+MwtVzyvZmsip0mvsP8FfDwLag2zonePa3849lZCrs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
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

Lukas Wunner wrote:
> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
> in X.509 certificates.
> 
> High-level functions for X.509 parsing such as key_create_or_update()
> throw away the internal, low-level struct x509_certificate after
> extracting the struct public_key and public_key_signature from it.
> The Subject Alternative Name is thus inaccessible when using those
> functions.
> 
> Afford CMA-SPDM access to the Subject Alternative Name by making struct
> x509_certificate public, together with the functions for parsing an
> X.509 certificate into such a struct and freeing such a struct.
> 
> The private header file x509_parser.h previously included <linux/time.h>
> for the definition of time64_t.  That definition was since moved to
> <linux/time64.h> by commit 361a3bf00582 ("time64: Add time64.h header
> and define struct timespec64"), so adjust the #include directive as part
> of the move to the new public header file <keys/x509-parser.h>.
> 
> No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
