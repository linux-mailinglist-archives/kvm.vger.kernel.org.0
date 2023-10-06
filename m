Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ADD7BBFAF
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 21:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjJFTT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 15:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjJFTTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 15:19:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6BAC;
        Fri,  6 Oct 2023 12:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696619991; x=1728155991;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rCUy2Yso9LGT5zZkYO0F5OqqrxKZh0tok3Fr3PnogE0=;
  b=KPaV3DsrbofMk47KoOucpVQu6bLINJVA6NoXGtVRqICvSc12NIutAGTo
   6p7FBGyjdA5Fwh/mUKN030j4rWFb5KxgvxPnB5kdPEnnMaemwdqBCAd6a
   UBGorBShSIdS6ZfWxOVzlRFI5KxitsuLI/33skujC5dAMfg4LdiOdxZ6D
   wCCWqmplv0WA6a23bEo5hV07MEbNfC4nU04EPIWlwEmqrF6nPKEQ1a4hk
   47VwpBpgBb6cS23RVUTd4xPW9/VbgJcjC/YbUjxnHi+1CMX4twRa2hftU
   zquei6FfkLHlJ7++f+b9hXzagMEPLPW7XKOjwrYY7zC6/9g2hIX5wdtHK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="381096398"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="381096398"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 12:19:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="787482975"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="787482975"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 12:19:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:19:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 12:19:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 12:19:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWPfibU6xbnnWUSf7j61kKgI6UDoo6UVTj3krKylKtvCTHAyexIU3mQxUrxhq9qMByfabclaNddbMyWMB8vl6w0f1EocTYHnSZoKoHQ3jtC3dVl9jgAxFtgKTF+bkZgpP08l7dNhT2FndrZR1WU0UtrW2UW0kyiwH6zdrP4QqJcK9syLdt5tfm7l26dgvpDvJGiY46UN68yxGpjasWjGg97fM+ztxKVLDb70S6++F7HQuWTzhrJAXPXDnKYqULG5bGu3PFAg9WL0hLqKUWP/Urmshov8noRrUSzjNXpdi+NH74yaC2bygQPIJE0fKRgxwqQH4TmwQBv/MnPzq1W6Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPK9G/nrNuSjm5cesTleuvhRpd2+hOKgMYD0R+OQyoU=;
 b=bqH+ttwcLowMg6ovt7ykg7maMyz/Z4kOgS3ZcPsJdyXKjbJ3k+Nz4NJlJm3whP+2MtiOB4aFW2+T6+Qc4XWq9vz23WjhWdrsIEI7BOTsUwdqGxA0NvsCOoUcZUnmB8B0CUJA1A2YdkPtaQvx667C57cbRXy1DkE/iVaz/FNc1VRLhQn5gXCs/Og9s9/345U18PgogGJOiwiUT7rfkgLFF203Yf3L1fqOEAOrbAn+SpvHvfstJvi3jkuaOZQdzD7PrIrh5u9i4O4CkI0Sh++4BadtwXhAhncGd7sVQWMbETSQLla5Q47B7Gc1ww8CaCL7WqbOCkCkcF/043xT//SyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5341.namprd11.prod.outlook.com (2603:10b6:5:390::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.39; Fri, 6 Oct
 2023 19:19:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 19:19:41 +0000
Date:   Fri, 6 Oct 2023 12:19:37 -0700
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
Subject: RE: [PATCH 04/12] certs: Create blacklist keyring earlier
Message-ID: <65205dc992c11_ae7e7294b9@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5341:EE_
X-MS-Office365-Filtering-Correlation-Id: b871740c-510e-4942-0d29-08dbc6a130e0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pw6P8ypVeo4YIyuzjTgh4HQnhWtBUUTaTBl4vCSKUWNsA/riC9GsOyzXG0wtdYKmRN+aI7QAxWAt5UGol4P0Q9+VRAiMrRYy92R9ubB4W9gdF2boN9D+IUc+DArrbW0ZJJNKKm6IHn5HB0bpEWo42y4SZVPWhjnZeOpcU8wKgUyANghZYNQC4ba2dJW3PGa7fPYdrvRGG8SnEIcbtnIEDZORnu4txNgYmyMAdeVCBEu3LgIoF4roXlXM9DsqkZuWWKahaSStDAxQLFiyGSqoGVNdc/2sEOjSDmV2pM0conQ/fhzvbPy4gxnHNdX0tRDcdNR6GsF9MM3QVrJA7f/3pnXBqzAwRwosUg5CxTkFVdZPNMJZEnPPo0n8mlH0UfvQh8F/meAPt95k30hjL5XRPBO5o4hs2opaDvPNBwg3gnlV159Lm5+SzKDdlon2FXUFdypfwjC5qDj9mdOkxCATJCt83gNMDZMumhLB40BQjz7liJxn4gWwNf7chL11lPneWvBB2yVxjqxfpkaQEKi4pWL2FkX7ASZ9ADVv09mI5jkXx4WaT1xU5G0AR+OReXi0D/AHfwZ5S7mmnYS3+qvQh3Q74YPtFsnLwIW/besCFkI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(376002)(396003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(83380400001)(6512007)(9686003)(6506007)(6666004)(478600001)(6486002)(86362001)(38100700002)(921005)(82960400001)(2906002)(7416002)(26005)(4744005)(66556008)(66476007)(54906003)(66946007)(5660300002)(110136005)(41300700001)(4326008)(316002)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/fYBtvhp8WsO4iH4iSF8Yqe9tZSTrEKEutfFc2HlH/3BXfJqo8aTkO+21Ec?=
 =?us-ascii?Q?j5u58YZfStgwcQFvnIiHTH08HJXXrcWMvBsvvO1KNfSsay0/kY6N2Zju7Pz3?=
 =?us-ascii?Q?Yy80BPnhCACuxMF2t4sdKn76a7oUQYanWED/h3YlN1ONIajGIq08d+EsNRkc?=
 =?us-ascii?Q?exubH4t4xmJFtQAJLO6lV//IZQRYSz930Z2/QqS935PpsadLIU99kv9fpAtU?=
 =?us-ascii?Q?XLv/KLITdQ5JyHuKmJa0ca/jkHorcuCJTOXXAp+84v1dg12IZ1704fMhOb02?=
 =?us-ascii?Q?AGbqbF1j4HsjCThB/H656yGavmSGG5tQ+yX/0kPvgpBvbgfzA93Uj3AO0RWN?=
 =?us-ascii?Q?D+lMZPrLWYLd2nX1LsZ93buDMqfkzHoyVOQeJQXWxH+aidpsDxSo7PTdvYGd?=
 =?us-ascii?Q?qklpbEULnUqidlkGnAFe/W/Dvc9WVzlY63Cp/vHiR6eldy4+ywP7yTgWz47y?=
 =?us-ascii?Q?JqAr1nfHxc+qEIGSgO3NpuWGgCXkAwIWVV0pur2QKzQowgethaIlGXcMS4DC?=
 =?us-ascii?Q?Kj0oxMx854k7roBu+jMPt1xAjyM5rLSapSBi2CGApYayBLNbXCU3XFNnsTwD?=
 =?us-ascii?Q?FOgg4dwg3RXlOhYpvAfagcY+TT2DrVNLJlZm+LmTqhmSfioxRS8ciVKvh5/v?=
 =?us-ascii?Q?Xrb0oU8fntQlTw1aV9YhzAEoE1Yofk/5O8G4M9FDGNtH2FjA/hu3FNXY0wMr?=
 =?us-ascii?Q?JsdrXqgaK9zXjCeFcMa13sptSGK8vg4bai1lfvWg+EMcG2UNRaSYpGq2Cg0Z?=
 =?us-ascii?Q?8QbFyFJJbSGMR460w0os8l54VeY2V71occzfWH2NOi++1ETMziztvm2QUNlN?=
 =?us-ascii?Q?R8TW6fGlPNqg+ANSWW/O2sWCV1G99iEV198QADN/xVdYQcU06+kAod1Jmzfr?=
 =?us-ascii?Q?U1LZR5ulW4HbEKES77VIOBL13QQNS5yXuQvYsD7bj6dzulU2VzDrdmOuh7w2?=
 =?us-ascii?Q?j0B74LEMG/zBXzlwpF5rX6FMMayXoCx+h44813tZir7SulNaBtSVUkDG+cbn?=
 =?us-ascii?Q?0Zc6G737ZQ3cmCPyM+DXfzhNT2gncSC9KdtBAP9wX+sbxrs+SzgWICow2k4+?=
 =?us-ascii?Q?91163OvHDlW+c6enUM/AXiyM4/v+/msfVpxALfdWZsUvQdkkcw99W4qEzyLK?=
 =?us-ascii?Q?gOgL8j2miO5sHLjs7dQC7vVzEd3sRINz0klAjf1HPHBhdQfAJKXhOTfc3B81?=
 =?us-ascii?Q?u69qA8rAqo2xvSKwzwdGcNjpSYma1djsjRvUV5cKkSVA/6Ty4ZmH9vy+YND7?=
 =?us-ascii?Q?7I3sv38YXDIpmK2A1el4oYy+gOy3Vq4DcNA3Tk1iuzz5iLFESeFhipBs88vE?=
 =?us-ascii?Q?4rqzHuuDz3XK7m600ux0E+RtSTE1NVPH19K9MuSzcZbmGjQ83INNIoJOTl1k?=
 =?us-ascii?Q?dUzQKlryGaj6oDToG5BHXt17BUlLC/sm/sIK+DwAve32z+AvIJ/oEeLoXOkC?=
 =?us-ascii?Q?H9zNMA2Z1swR86zGSyz0ZmBksUBXhp3f+0GxwFP9XIdP/MrNvLAjezMYROrj?=
 =?us-ascii?Q?Kbjv8b22owCniYLMrGe8VkqbfGcqlMK/w1UFrraVamMX5gHRkfO7xaEW8Sbq?=
 =?us-ascii?Q?r0MXakEkao4FvRD928fBHnzxiq+HPvmE6PYcS0uj3C+rD4yBmU9N6krUWu2l?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b871740c-510e-4942-0d29-08dbc6a130e0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 19:19:41.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lake6eBjk7GsYHsDiGP/xzHrH2g9YXrpP8mMUjj+PVMLD57JB8/1XNPAWTiYqH543wMYI6zsGJdWzmKEeqC5IjLYqS/HWpKqNqmTkFXFZKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5341
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

Lukas Wunner wrote:
> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires parsing X.509 certificates upon
> device enumeration, which happens in a subsys_initcall().
> 
> Parsing X.509 certificates accesses the blacklist keyring:
> x509_cert_parse()
>   x509_get_sig_params()
>     is_hash_blacklisted()
>       keyring_search()
> 
> So far the keyring is created much later in a device_initcall().  Avoid
> a NULL pointer dereference on access to the keyring by creating it one
> initcall level earlier than PCI device enumeration, i.e. in an
> arch_initcall().
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

I was going to comment on s/blacklist/blocklist/, but the coding-style
recommendation is relative to new usage.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
