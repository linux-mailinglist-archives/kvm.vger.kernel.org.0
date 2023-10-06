Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9748A7BC06B
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjJFUec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 16:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjJFUeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 16:34:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF68BE;
        Fri,  6 Oct 2023 13:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696624469; x=1728160469;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iJytUC0utTJTMUR9fX2HEvRZjHviiFTVfW5ca79Z34U=;
  b=hz0wAxK5viqqZoPWklgyoV2zs9KCrcuz2Dy6mOvoarHYRrP4wgesVqFI
   SC3n3VhMFSr9Sns5406iGrRmxDzGF9D+awNwV79XJYMv7aevehNU4CinD
   m6T0fHRL2jT7y9jqPIq5umN49GOpw41TU1EWa5SRvCPc1aGnPEsLd9gbP
   KtTCBFuaeYd9BGaKmIdtj0LpDPrfs+EJCGHcSOjuE/es9rJqrgKH+2DIL
   TTDyxC4/oy58ONACgIVyyYW0ff0VuJH9lo4z9w9NFErvvlXVaJoAqzX1o
   UMMQfAEj05ic55r+6IAZur2+8hjIaua21NU/uqftlBpaNlo10jkJuu/oL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="386658436"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="386658436"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 13:34:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="896014069"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="896014069"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 13:32:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 13:34:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 13:34:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 13:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEB4qw954p7fIox5/kT1rXEMt9ZWSpQdWNIomfPPV70fWqwwugnsLWWJtwkg9vA6d9mw/yI4ShwQqcfGMp78BX3Ecm4cGVU0stQJkr1IzrEVTJIvqMC4TTvp9yZP+VrZ9NpeRfZtzjmkUIrlVrcebTHoQRH25KwucmYU0VXrA/2Ocm/OMV6LclM/d91CI7/NCIhFAmClMcwPSqQojsVISGuV+vNwCBcVAw1iUfEYPU/3eF4SiRcD1kDR9vkxZejXmuV9zwS52/FAP9yzTjYx9h96aeAu/Qd8bYjDKerLLL9b3YZMDt3NTH8PzzbgnjyOHQ1eFQ0V6DyHxlW6HrA0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZ98nqlhH5sHTTLJxDRrv33NK4kjh/RHm1GkcIKes5o=;
 b=mU0aRQiYL3aUjx889e4DTJWJWY7RakVku+kdW2m/b/KGTqHftr8GRu69Z5Z7VFeRAosbyD53JxAUDFZc/YZ8HXi9emrm9Rg0Y85n1cTdabFqsfzS2u98Wx9Iu3xIiNZep67UpQsZudiWcC2xtrRNWegZ9Vc7ZZlDH/m3oQiNBxbgMzdLz3aLsaQUzvplDs9pXhS1TUJP6sa/lW+jIwKqBRzuguzLHqe+LhSQkG8De5MjMn7KE3XxGpZW+HawNXxigw6ZW/Tpoth/jKO/9Ho2Yg09CMuGgGqNz1Ty+YP8G5rBg/Bq9qOZVK5NX/jZfUNSMdQZyMmI7TmtkZ8dFCdOYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7288.namprd11.prod.outlook.com (2603:10b6:8:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.37; Fri, 6 Oct
 2023 20:34:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 20:34:24 +0000
Date:   Fri, 6 Oct 2023 13:34:20 -0700
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
Subject: RE: [PATCH 07/12] spdm: Introduce library to authenticate devices
Message-ID: <65206f4c7f0ae_ae7e729444@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: MW4PR04CA0235.namprd04.prod.outlook.com
 (2603:10b6:303:87::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: d573b79b-3110-4d96-d12d-08dbc6aba06d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZi0R5C4Yln6rnFcV/tL4Hwjc3W3SM9yoAIe1hPyeiZnS8ZBrwoKlk4Ujkv86sCqU+zwudvAZFqn2cMiHbPk+O0Ra2v5wPb5l1pfxMuIH263k+o/VUflwuhTmZ0lYq7crvN7Ky12Opanyai4/lf/sioeeoCsGkaRhX+lQKVl1LMWl87xGZay9cTVCiL025CC830XBoVkQGjpusQZhZbFH+h3+tz3jXnopdqF9YMiJHlfgBiY/64uDcoMYXFxBPFTSdaarwYDWBlLnfKq1wCrqn80HPbxVbg0ueaFS5d0+LMVAjIdWjaFzqukViZz8ZrmqkjQNNo+738WbS5Hd7qt1OVgS50M/a/JeJHu5Ii8c2e7ox4obnkjfmfiuZh8taExZgivmCtG+cTQNvUyW1KlW4BPlpp0sJcZ0kqrVXtvYNeWr3XwwWp0XAPr0MGd6oshq2gl6yhampZypZkUOYZU4uLLmwTDb/89HHXH3bE0hokxw0mv5ie9e+bcKNQolgmk0Il0R5UBEglYF3VaISM0YQ/BNXPJlL+h3yWV5boS9IF2jDi9nqhwlKM/A4HqlIP8ta0WeCZnTNSHu7CF12iU52OpWmaOelIPXy6AnLWBXIrQ+NH38JV3f4Yr0e3gegn7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(39860400002)(396003)(376002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(7416002)(5660300002)(8676002)(30864003)(2906002)(4326008)(8936002)(41300700001)(66899024)(316002)(66946007)(66476007)(54906003)(66556008)(110136005)(6666004)(6506007)(26005)(6512007)(9686003)(478600001)(82960400001)(38100700002)(921005)(83380400001)(86362001)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ek58uPlQtUyCqC+YvdOn8l0saWGG2uBjs+gqvA74GazcpXL2sJIFN4abkA1j?=
 =?us-ascii?Q?2nZ2/xT5jdGJqHrAFF73OTp69VEwU8Cl/CsWsAyrMnyBWHgrG1tMNvjKR/kh?=
 =?us-ascii?Q?4wqombC6zxWLkAYi6CcrPccRDggSi1K3LOGg1D0uSeBae7I8q/Nhwa6N8Am/?=
 =?us-ascii?Q?6sRWqIbMdkGkUVqdL0u2UKrt9vh1xcK9vQEW/CctWaDEU8Dgz/U8G9rO5kMG?=
 =?us-ascii?Q?x2njp51MfY6t47+/T9CL5OCE/r882QyLgxgcOtP6xGxrXQQA+r/0Al+yCFRY?=
 =?us-ascii?Q?ntiwGJcRC7NYnfM1iV+gu2G3ZrqbcbLZInySwUXhD1L29FkZFGIX3TWWxCjx?=
 =?us-ascii?Q?04FL1KNLgutK+0p6vBzWmooKYUW+2mxLXH8EvLJ2rbEOz2d7d570GxlbGKDY?=
 =?us-ascii?Q?XLH95NTT0mYmG07H6rTITMwxNoiFNzYAvIIo+gvBWPRPdrHjQKglz1yF1CqD?=
 =?us-ascii?Q?p6tCeA7JARQTa804dU7ZMuDxaHfD+tyG6+HMZh6QHWWFg77WeUOlSjGha1x2?=
 =?us-ascii?Q?tX9fzKig9DqTsU8usWKlprwt6PGProUlzfUkH7LNICl6JAhIHL4CtE1Gx2Jc?=
 =?us-ascii?Q?7zN8e/BWjYZdKBTuIRiVp2MX+DTeXMlByX/ZRpQZyUHJgNDAx7kW33l9HPcM?=
 =?us-ascii?Q?TERIVp92nGY4vSsQTOCO9MxV0ZJsZXSi6WCQCpiVQqZmh6SWnwVcMZkGv3AT?=
 =?us-ascii?Q?ZfE7bLlCjjAsLCrQm2PtP8rC8ZNr1esKxVPHAuICXvgqw5JmUFD1v1OsmwLy?=
 =?us-ascii?Q?KEjjU90Cy1PNbfX4dUxScLKrcQh0PddWgm7/xFUCPbxdQxCmy/iJTrr9AzHd?=
 =?us-ascii?Q?tQ4jHxOWj3tlFIvoGwuoaYWc6i/qlUpFK8166chpZFQIoqWg+Qvkt349tEmb?=
 =?us-ascii?Q?yZzefpIQh2+lGYqZ649i97QAUkayRNsuE3vOvXsIFIbNsajaqpCgaWIhcbkB?=
 =?us-ascii?Q?6uBpDYGlIoAq7vux28FYG7CZB+NDhBtFLqfAoOMgWYPh0ZRrEynQ1U4ann+P?=
 =?us-ascii?Q?u/l/5gLnUpV/pnCewTqOurna4gOr7LJLiP8Z+usMonie0RJ+SMolVvgLTgK4?=
 =?us-ascii?Q?RPN3ikqluj2pERLgk9pxGbe3NbSDTeBvBBOJV9sG41eycM5e3Z4GlXiUboaD?=
 =?us-ascii?Q?tgn/8dfky8vD9guo3hK9VZVQO845DUQQrFh7rykIiuqWV6LvM18tj+9hNvjz?=
 =?us-ascii?Q?J9XOiVyrlZ4hh/7l/w7etd2ZpY1D6jjjlzjsnz1WxaxaLQZVujjC29bmpDmU?=
 =?us-ascii?Q?wcryQvQg6KzjvHUmkPyjdz6MTFlircAg/nO0EDI+j30T0yDClq6KZu7VZJAp?=
 =?us-ascii?Q?6eN2ZFQ1B7RjI5Ue/+uEd3vYbIOTnxR9iq+9OQSgy9pcw3OyBIt4yWXQQoZk?=
 =?us-ascii?Q?SwuZKp2HG1tu0kjE3IZCBBpkC/CNlwhqrFRohp4hRm+7TUbuT1kpvsKgCs5b?=
 =?us-ascii?Q?0Ghsr5cI5fDGZtGp5HG24T8+kL9KZMLUO9iR+5AbLA8FIm3gTgkVQYKFDCLi?=
 =?us-ascii?Q?A3TIN0CTDU4G7/7TSqMLp8C0Wo0P5mIrhQJxPYITHEz21cbb41LRciPIaigH?=
 =?us-ascii?Q?1VBFzDI7s2thhZKlAIZ7fpv2rlEw31JkslyNZuZpdYIduhQMsFs6WsDs7Wi5?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d573b79b-3110-4d96-d12d-08dbc6aba06d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 20:34:23.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/EC0jn5fJddtP0mPjvnKzw34YwE6XopvuAyNjPnbEmtAZvx81wbLbjmCEe7L3b3DBAVjgXNiC+IPMENpdiulBPJ/Jfn4VFXwCRhV+K1uaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7288
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
> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> The Security Protocol and Data Model (SPDM) allows for authentication,
> measurement, key exchange and encrypted sessions with devices.
> 
> A commonly used term for authentication and measurement is attestation.
> 
> SPDM was conceived by the Distributed Management Task Force (DMTF).
> Its specification defines a request/response protocol spoken between
> host and attached devices over a variety of transports:
> 
>   https://www.dmtf.org/dsp/DSP0274
> 
> This implementation supports SPDM 1.0 through 1.3 (the latest version).
> It is designed to be transport-agnostic as the kernel already supports
> two different SPDM-capable transports:
> 
> * PCIe Data Object Exchange (PCIe r6.1 sec 6.30, drivers/pci/doe.c)
> * Management Component Transport Protocol (MCTP,
>   Documentation/networking/mctp.rst)
> 
> Use cases for SPDM include, but are not limited to:
> 
> * PCIe Component Measurement and Authentication (PCIe r6.1 sec 6.31)
> * Compute Express Link (CXL r3.0 sec 14.11.6)
> * Open Compute Project (Attestation of System Components r1.0)
>   https://www.opencompute.org/documents/attestation-v1-0-20201104-pdf
> 
> The initial focus of this implementation is enabling PCIe CMA device
> authentication.  As such, only a subset of the SPDM specification is
> contained herein, namely the request/response sequence GET_VERSION,
> GET_CAPABILITIES, NEGOTIATE_ALGORITHMS, GET_DIGESTS, GET_CERTIFICATE
> and CHALLENGE.
> 
> A simple API is provided for subsystems wishing to authenticate devices:
> spdm_create(), spdm_authenticate() (can be called repeatedly for
> reauthentication) and spdm_destroy().  Certificates presented by devices
> are validated against an in-kernel keyring of trusted root certificates.
> A pointer to the keyring is passed to spdm_create().
> 
> The set of supported cryptographic algorithms is limited to those
> declared mandatory in PCIe r6.1 sec 6.31.3.  Adding more algorithms
> is straightforward as long as the crypto subsystem supports them.
> 
> Future commits will extend this implementation with support for
> measurement, key exchange and encrypted sessions.
> 
> So far, only the SPDM requester role is implemented.  Care was taken to
> allow for effortless addition of the responder role at a later stage.
> This could be needed for a PCIe host bridge operating in endpoint mode.
> The responder role will be able to reuse struct definitions and helpers
> such as spdm_create_combined_prefix().  Those can be moved to
> spdm_common.{h,c} files upon introduction of the responder role.
> For now, all is kept in a single source file to avoid polluting the
> global namespace with unnecessary symbols.

Since you are raising design considerations for the future reuse of this
code in the responder role, I will raise some considerations for future
reuse of this code with platform security modules (the TDISP specification
calls them TSMs).

> 
> Credits:  Jonathan wrote a proof-of-concept of this SPDM implementation.
> Lukas reworked it for upstream.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  MAINTAINERS          |    9 +
>  include/linux/spdm.h |   35 +
>  lib/Kconfig          |   15 +
>  lib/Makefile         |    2 +
>  lib/spdm_requester.c | 1487 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1548 insertions(+)
>  create mode 100644 include/linux/spdm.h
>  create mode 100644 lib/spdm_requester.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90f13281d297..2591d2217d65 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19299,6 +19299,15 @@ M:	Security Officers <security@kernel.org>
>  S:	Supported
>  F:	Documentation/process/security-bugs.rst
>  
> +SECURITY PROTOCOL AND DATA MODEL (SPDM)
> +M:	Jonathan Cameron <jic23@kernel.org>
> +M:	Lukas Wunner <lukas@wunner.de>
> +L:	linux-cxl@vger.kernel.org
> +L:	linux-pci@vger.kernel.org
> +S:	Maintained
> +F:	include/linux/spdm.h
> +F:	lib/spdm*
> +
>  SECURITY SUBSYSTEM
>  M:	Paul Moore <paul@paul-moore.com>
>  M:	James Morris <jmorris@namei.org>
> diff --git a/include/linux/spdm.h b/include/linux/spdm.h
> new file mode 100644
> index 000000000000..e824063793a7
> --- /dev/null
> +++ b/include/linux/spdm.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * DMTF Security Protocol and Data Model (SPDM)
> + * https://www.dmtf.org/dsp/DSP0274
> + *
> + * Copyright (C) 2021-22 Huawei
> + *     Jonathan Cameron <Jonathan.Cameron@huawei.com>
> + *
> + * Copyright (C) 2022-23 Intel Corporation
> + */
> +
> +#ifndef _SPDM_H_
> +#define _SPDM_H_
> +
> +#include <linux/types.h>
> +
> +struct key;
> +struct device;
> +struct spdm_state;
> +
> +typedef int (spdm_transport)(void *priv, struct device *dev,
> +			     const void *request, size_t request_sz,
> +			     void *response, size_t response_sz);

TIL that even though "typedef <type> (*<name>)" is the predominant kernel
style of declaring function pointer types, significant parts of the kernel
use this "typedef <type> (<name>)" and declare it a pointer at the usage
site.

> +
> +struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
> +			       void *transport_priv, u32 transport_sz,
> +			       struct key *keyring);
> +
> +int spdm_authenticate(struct spdm_state *spdm_state);
> +
> +bool spdm_authenticated(struct spdm_state *spdm_state);
> +
> +void spdm_destroy(struct spdm_state *spdm_state);
> +
> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index c686f4adc124..3516cf1dad16 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -764,3 +764,18 @@ config ASN1_ENCODER
>  
>  config POLYNOMIAL
>         tristate
> +
> +config SPDM_REQUESTER
> +	tristate
> +	select KEYS
> +	select ASYMMETRIC_KEY_TYPE
> +	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> +	select X509_CERTIFICATE_PARSER
> +	help
> +	 The Security Protocol and Data Model (SPDM) allows for authentication,
> +	 measurement, key exchange and encrypted sessions with devices.  This
> +	 option enables support for the SPDM requester role.
> +
> +	 Crypto algorithms offered to SPDM responders are limited to those
> +	 enabled in .config.  Drivers selecting SPDM_REQUESTER need to also
> +	 select any algorithms they deem mandatory.
> diff --git a/lib/Makefile b/lib/Makefile
> index 740109b6e2c8..d9ae58a9ca83 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -315,6 +315,8 @@ obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
>  obj-$(CONFIG_ASN1) += asn1_decoder.o
>  obj-$(CONFIG_ASN1_ENCODER) += asn1_encoder.o
>  
> +obj-$(CONFIG_SPDM_REQUESTER) += spdm_requester.o
> +
>  obj-$(CONFIG_FONT_SUPPORT) += fonts/
>  
>  hostprogs	:= gen_crc32table
> diff --git a/lib/spdm_requester.c b/lib/spdm_requester.c
> new file mode 100644
> index 000000000000..407041036599
> --- /dev/null
> +++ b/lib/spdm_requester.c
[..]
> +struct spdm_error_rsp {
> +	u8 version;
> +	u8 code;
> +	enum spdm_error_code error_code:8;
> +	u8 error_data;
> +
> +	u8 extended_error_data[];
> +} __packed;
> +
> +static int spdm_err(struct device *dev, struct spdm_error_rsp *rsp)
> +{

Why not an error_code_to_string() helper and then use dev_err() directly at
the call site? rsp->error_data could be conveyed uncoditionally, but maybe
that belies that I do not understand the need for filtering ->error_data.

> +	switch (rsp->error_code) {
> +	case spdm_invalid_request:
> +		dev_err(dev, "Invalid request\n");

Setting the above comment aside, do you suspect these need to be
dev_err_ratelimited() if only because it is unclear whether a user of this
library will trigger screaming error messages?


> +		return -EINVAL;
> +	case spdm_invalid_session:
> +		if (rsp->version == 0x11) {
> +			dev_err(dev, "Invalid session %#x\n", rsp->error_data);
> +			return -EINVAL;
> +		}
> +		break;
> +	case spdm_busy:
> +		dev_err(dev, "Busy\n");
> +		return -EBUSY;
> +	case spdm_unexpected_request:
> +		dev_err(dev, "Unexpected request\n");
> +		return -EINVAL;
> +	case spdm_unspecified:
> +		dev_err(dev, "Unspecified error\n");
> +		return -EINVAL;
> +	case spdm_decrypt_error:
> +		dev_err(dev, "Decrypt error\n");
> +		return -EIO;
> +	case spdm_unsupported_request:
> +		dev_err(dev, "Unsupported request %#x\n", rsp->error_data);
> +		return -EINVAL;
> +	case spdm_request_in_flight:
> +		dev_err(dev, "Request in flight\n");
> +		return -EINVAL;
> +	case spdm_invalid_response_code:
> +		dev_err(dev, "Invalid response code\n");
> +		return -EINVAL;
> +	case spdm_session_limit_exceeded:
> +		dev_err(dev, "Session limit exceeded\n");
> +		return -EBUSY;
> +	case spdm_session_required:
> +		dev_err(dev, "Session required\n");
> +		return -EINVAL;
> +	case spdm_reset_required:
> +		dev_err(dev, "Reset required\n");
> +		return -ERESTART;
> +	case spdm_response_too_large:
> +		dev_err(dev, "Response too large\n");
> +		return -EINVAL;
> +	case spdm_request_too_large:
> +		dev_err(dev, "Request too large\n");
> +		return -EINVAL;
> +	case spdm_large_response:
> +		dev_err(dev, "Large response\n");
> +		return -EMSGSIZE;
> +	case spdm_message_lost:
> +		dev_err(dev, "Message lost\n");
> +		return -EIO;
> +	case spdm_invalid_policy:
> +		dev_err(dev, "Invalid policy\n");
> +		return -EINVAL;
> +	case spdm_version_mismatch:
> +		dev_err(dev, "Version mismatch\n");
> +		return -EINVAL;
> +	case spdm_response_not_ready:
> +		dev_err(dev, "Response not ready\n");
> +		return -EINPROGRESS;
> +	case spdm_request_resynch:
> +		dev_err(dev, "Request resynchronization\n");
> +		return -ERESTART;
> +	case spdm_operation_failed:
> +		dev_err(dev, "Operation failed\n");
> +		return -EINVAL;
> +	case spdm_no_pending_requests:
> +		return -ENOENT;
> +	case spdm_vendor_defined_error:
> +		dev_err(dev, "Vendor defined error\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_err(dev, "Undefined error %#x\n", rsp->error_code);
> +	return -EINVAL;
> +}
> +
[..]
> +/**
> + * spdm_authenticate() - Authenticate device
> + *
> + * @spdm_state: SPDM session state
> + *
> + * Authenticate a device through a sequence of GET_VERSION, GET_CAPABILITIES,
> + * NEGOTIATE_ALGORITHMS, GET_DIGESTS, GET_CERTIFICATE and CHALLENGE exchanges.
> + *
> + * Perform internal locking to serialize multiple concurrent invocations.
> + * Can be called repeatedly for reauthentication.
> + *
> + * Return 0 on success or a negative errno.  In particular, -EPROTONOSUPPORT
> + * indicates that authentication is not supported by the device.
> + */
> +int spdm_authenticate(struct spdm_state *spdm_state)
> +{
> +	size_t transcript_sz;
> +	void *transcript;
> +	int rc = -ENOMEM;
> +	u8 slot;
> +
> +	mutex_lock(&spdm_state->lock);
> +	spdm_reset(spdm_state);
> +
> +	/*
> +	 * For CHALLENGE_AUTH signature verification, a hash is computed over
> +	 * all exchanged messages to detect modification by a man-in-the-middle
> +	 * or media error.  However the hash algorithm is not known until the
> +	 * NEGOTIATE_ALGORITHMS response has been received.  The preceding
> +	 * GET_VERSION and GET_CAPABILITIES exchanges are therefore stashed
> +	 * in a transcript buffer and consumed once the algorithm is known.
> +	 * The buffer size is sufficient for the largest possible messages with
> +	 * 255 version entries and the capability fields added by SPDM 1.2.
> +	 */
> +	transcript = kzalloc(struct_size_t(struct spdm_get_version_rsp,
> +					   version_number_entries, 255) +
> +			     sizeof(struct spdm_get_capabilities_reqrsp) * 2,
> +			     GFP_KERNEL);
> +	if (!transcript)
> +		goto unlock;
> +
> +	rc = spdm_get_version(spdm_state, transcript, &transcript_sz);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = spdm_get_capabilities(spdm_state, transcript + transcript_sz,
> +				   &transcript_sz);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = spdm_negotiate_algs(spdm_state, transcript, transcript_sz);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = spdm_get_digests(spdm_state);
> +	if (rc)
> +		goto unlock;
> +
> +	for_each_set_bit(slot, &spdm_state->slot_mask, SPDM_SLOTS) {
> +		rc = spdm_get_certificate(spdm_state, slot);

A forward looking comment here, how to structure this code for reuse when
end users opt their kernel into coordinating with a platform TSM? Since the
DOE mailbox can only be owned by 1 entity, I expect sdpdm_state could grow
additional operations beyond the raw transport. These operations would be
for higher-order flows, like "get certificates", where that operation may
be forwarded from guest-to-VMM-to-TSM, and where VMM and TSM manage the raw
transport to return the result to the guest.

Otherwise no other implementation comments from me, my eyes are not well
trained to spot misuse of the crypto apis.
