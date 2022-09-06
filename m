Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0838D5AE404
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiIFJVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 05:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiIFJVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 05:21:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218F0606A7
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 02:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662456099; x=1693992099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gdtdk0mP8srkuBPcgTJ3m7Ppb0DlTFKW2txB/cDyE9U=;
  b=OxL7oQ0dG9WrgSx680/JABbROmzb6fle6U/tpRRUsab7+1Z37nMlJs//
   t3Z/gM9gpYQPJi+q7VeTnXT0mLAq4C5KzqK1wm4pKaA9C5yBKqlrrEF/X
   CchDS+peEutHX7Znb4r8V+hH1LbtGaq1RXvr8UWO0V/dc5aBIygh22anI
   s4X5vqEAY92HOK95Jf4J+Szw2cwanG4P+A8CuzMk3LMZOEQzPF5Fds++h
   4tLJbO2PkD3LBTmKFn0cPUECjSDHeoDzyuz0j6X637DmezuNmxJ0y6bKY
   L+ydJK6eyas84/neq0T/NbicmOZhXOovzQIiIgI2TkMy72RgUjcZPPbeg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="276285933"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="276285933"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 02:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="703147926"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Sep 2022 02:21:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 02:21:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 02:21:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 02:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KU9VsNJFd0XpwL6oknwc8Wac78LlXsRcq13IojjOnxXtKi4n7ieeO95ukuhd9UigIBOmsuMJKorzNxOgtV/pPJ1uFAje4JxTm7GSbddxP2Awfn1OyoNPd9CO+IGy8olxpoVYDhe6sD1+abXsUgw7e2dmJTzr5jhIt/AuMXTOKXco2j90AQ7dG2JSUjD91i8+TCngzLai9ql3AoHb71sx+Ndf1o319DktH/rNL695q9HjtVDSe25JgaWRAqP0vB+TD5RCpB6Z5Xjmh99ugjuQiOX4WkAJFlQhm+0QFwSFZ4+QdBrIA3dXxhmRLA3i+WfcSWieas/v6ldrhziGaXXfTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdtdk0mP8srkuBPcgTJ3m7Ppb0DlTFKW2txB/cDyE9U=;
 b=Zz+YUoOdlXc2BSPUr5PN/dlkKEhv0cQ30fpFGUADOJRCqTqW1dvxb1EKKP9kpDzXLGxr2myNgTfdUWdObkNRBXBsc8IsyHwH2kVAo6mjvli1rNIZQ1OV/f/Za1iIjxOKVaSW3Gpo6zC8u0V1WPFBNh8Rw8a43nv5uzXL5lWiNtQpsX02k8XnZupsXsV3/vYwxbi+ZrgTdjDVSIoolGQSAl0I6fYD6IaICiABoh0ev32Ge45aLNt+7Hh5uX4Z4lS1LdXGlbT6Muo49NXvLG877n80/HtgMnaqrA3X6l51CvV0iawhLpIceuL5oyHgWqqpeuza/0kUXsIFHgCHsWjW2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3106.namprd11.prod.outlook.com (2603:10b6:208:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 09:21:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 09:21:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsaRGGwFgE99eLU+zfxszxAHdM626W62AgADs9gCAAG4C4IABiaIAgAFmtoCAAC0xAIATXoqQ
Date:   Tue, 6 Sep 2022 09:21:35 +0000
Message-ID: <BN9PR11MB527619A0314F21B4FD21182D8C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
 <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220824003808.GE4090@nvidia.com>
 <20220824160201.1902d6c4.alex.williamson@redhat.com>
 <20220825004346.GB4068@nvidia.com>
In-Reply-To: <20220825004346.GB4068@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 226ef278-a7ad-4f92-8781-08da8fe93249
x-ms-traffictypediagnostic: BL0PR11MB3106:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LU/8R3/pZBAIX8nbleuVWnhw3wzkW0ucwXrHiqrioeSzJiQff2bCshEWK981Ebjn/+oVrHk2o8KT9TtEAn9ZNB4+dNF7xn9CZeMKzTjaMIHtDSDlAFoF5mtGsVNtTQYEIDMry5X9d4e9dYJHudos959iPwEg8dJ43o1PiMDBmuqjYnlpzP8ZFuiiRRiXBx69/NCkpKkHjtjH0KBzReivdnpLwOKjUF6o+a6Nru05aftL60CaTiPrlr8gzDDfqFAzNdP5OSckG9pQSyYbB+5st2zHiC3DSgvPXqgeyKNcaOcjPf31p2bLM6INLJWF2/6DHyiljX2t6rTyklXoRuG0h+eIC958Y0SOPh1CEwn1s1VdHWVDc+2CjLOeq4nRjbajK4hduSpidLto5aU+uDZn3lmzj8pLQSaI6bZDyvUQzBvs4fVoKqbbiagFE5azLlwd0spFJjAtqg6XjHKA1/1lY7r/fWKwk5fPpi9+5eB43DZSyqvJA7/cyBicy5EryVxiUnXR9hnKCOS/grMgAgXAMD3c4nW+/YOo8hc8wtAyWaK/qzFww+1A6KtJU4/v/Tk6JHsmhsQUbGXvha+G+uiEk7preRFC1BAxMId1O6raKSxKsND+35/zn5TLhFcME0yBeFk0QVRdZmjEJXscsHxKWscD/fklks9et4zK4t3SyBHIYvpC5P+nvwvF9RBxBR5BiohXLwDe2IhcQbKzcYkHtrbFJpFyvJJskHCeasaH3d7RmF1TqVBO17dPuQbirtGX9qMXPGGUQEWpcnQSeexIAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(346002)(136003)(376002)(38070700005)(186003)(86362001)(83380400001)(82960400001)(38100700002)(122000001)(52536014)(8936002)(66946007)(66476007)(64756008)(2906002)(8676002)(76116006)(4326008)(66446008)(66556008)(5660300002)(55016003)(9686003)(7696005)(6506007)(26005)(71200400001)(54906003)(316002)(478600001)(41300700001)(33656002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8GkJb0KsMQRII7WNetOF4eqvUuvZLwr1dYtYPpx7jKh9Dkby1xrzeYjdxLoR?=
 =?us-ascii?Q?EVvEj2Ai781mJ5hJnmxIXs0QyQRHBPddR8TzzeNWCv3zbxFxQ/NahWc3L8Cy?=
 =?us-ascii?Q?4dG+s2/r/5APfftWEURER14Zn8UtsqSlE0jlj9AioTdq4q6eATxZlgrBBH+4?=
 =?us-ascii?Q?lto3vxy5R4rO4aa5w2eUrXRxvMkOrWo3ZktMxnNWCKNIsHbOAjiWj5sTPnq8?=
 =?us-ascii?Q?znaMvycT7H6w5fSspBiCUKfJaC5U/mGSHBDfYbaPTgLBGT9dasj9+q3d7keA?=
 =?us-ascii?Q?2B2+AwWS/QgjoZ+aZ0NWSOKncRrrGjN021m0NdGgYw5EZf77HlDpKO+r2KJg?=
 =?us-ascii?Q?Cpy/BNR8a9ppe94mtXW2PA/wqVwVi3sSfgzxpXJhWdqRog/xTIzDgsepTmz1?=
 =?us-ascii?Q?d1ajqSqsja6bqWVans3BWL2hnlLM9SyxzS7EaQ47MJUA0IMxuH1Ds6LncPoW?=
 =?us-ascii?Q?5tRyBbSJQo1/+dclWDNVwOtWo+a7cLO/4X5PNQIfCde9KqemjsnPFFjgfGvy?=
 =?us-ascii?Q?yWruvYepzKB5GjlU7JPNoDWrrQQnDXbh46wgS7fFmuB04blcOmxiIJqHbYx3?=
 =?us-ascii?Q?HSBNdKI4bpnyvVPJ28ObxIREx+tELNd9UyuIbDFDrVyvQWiP/tPKQ21IOX9b?=
 =?us-ascii?Q?5rc+wNph9Up8pU3vaMaA9zmtuAm6CYMEb8Vxv7BPDuek1m8I4Oj7HpXkJzEN?=
 =?us-ascii?Q?SriuiSg29EfzebvP6Cb+k2zM7wLWAgZIHV2hRsRsJ1zHyiDJCJ69FpiauMkK?=
 =?us-ascii?Q?XhFNtkUlbH7nmYeG7KfPTawGftenFkEccynRXwlJh/O6aqNalUUX2dTanxLi?=
 =?us-ascii?Q?GuGXN54DKHt+bVTrtmlw71l4+v09DPvZfrqplyiPAV1OfWRQ93hCYpISsw7P?=
 =?us-ascii?Q?v8yn1IqiVOc0uyWhUGdBbsfg8ZpWXQH/FyuSozVfbtQ2krKRUw1Qctiq6o64?=
 =?us-ascii?Q?gNlwZsYgHiY6ZY+U16ELXpYr4kCwrGtQ4x4fXVAUju7V17bSZEK2Zt45HV6g?=
 =?us-ascii?Q?JFVC00OqBxV/neS7fRMBJ0UvAOP3CmZt8gLEwugphjD22bfEJa5Gti2NAozx?=
 =?us-ascii?Q?REPpvH3UZAgJ9Vp0TkAicCmysQQF14mz7VqvPp8bNuxpkany4JojjNaKomCI?=
 =?us-ascii?Q?VW1Cz/UAUm2mVbBQUCDwDzzBK1Nj760MJ/pkhmfrT8Ovab6WMIUWCENEm3rl?=
 =?us-ascii?Q?gkBBoUNluYY4hvRTIXsiFnjlTPSisBKUBo4U2CHPnx7WSp00XKjLqw7js3Bs?=
 =?us-ascii?Q?8p5MMwTi6Vkp9zf/EaLXexMQA+UrhgHLVO/Ov51N8MMYHRK/MlFt3FkKU8O8?=
 =?us-ascii?Q?0Ov5Z7y+GwCzrE9HfgnKYPwNcGKh9mG7nAQuo6rFWvhKSJUSsXgDMoIuY8sf?=
 =?us-ascii?Q?nLhQuyV7NYS3jThzM6dWunv2YcnS87tlbqTY3VjTN48MwUY/dOpBjoQVYK+0?=
 =?us-ascii?Q?61nigAGsNx/m6oCESZZZXpThdhJ3hy6WqLcubETwwYDvxwmbIzQyjfkgg7V4?=
 =?us-ascii?Q?7uTGzHDYMYOYwRKCaneHp77yzOSgkXjKacqn/yEzT3QaOOkQgLg2y0+X3235?=
 =?us-ascii?Q?zTEOawpgBqhsOIds0mveaH9wVQ5mDBR9sIDjwYpz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226ef278-a7ad-4f92-8781-08da8fe93249
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 09:21:35.9709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IyOk2J7dLDssjLhJqW7B/845qv4lM8ykI1j9gb2Kv0uiG+OAMIGPNVLTI7WGcxdz+byNHJlDFtqrybC8B/xDiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3106
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 25, 2022 8:44 AM
>=20
> On Wed, Aug 24, 2022 at 04:02:01PM -0600, Alex Williamson wrote:
>=20
> > Do we expect mdev drivers supporting migration to track their dirty
> > iovas locally and implement this feature?
>=20
> Assuming we ever get a SW only device that can do migration..
>=20
> I would expect there to be a library to manage the dirty bitmap
> datastructure and the instance of that datastructure to be linked to
> the IOAS the device is attached to. Ie one IOAS one datastructure.
>=20
> The additional code in the mdev driver would be a handful of lines.
>=20
> If we want it to report out through the vfio or through a iommufd API
> is an interesting question I don't have a solid answer to right
> now. Either will work - iommufd has a nice hole to put a "sw page
> table" object parallel to the "hw page table" object that the draft
> series put the API on. The appeal is it makes the sharing of the
> datastructure clearer to userpsace.
>=20
> The trouble with mlx5 is there isn't a nice iommufd spot to put a
> device tracker. The closest is on the device id, but using the device
> id in APIs intended for "page table" id's is wonky. And there is no
> datatructure sharing here, obviously. Not such a nice fit.
>=20

A bit more thinking on this.

Although mlx5 internal tracking is not generic, the uAPI proposed
in Yishai's series is pretty generic. I wonder whether it can be extended
as a formal interface in iommufd with iommu dirty tracking also being
a dirty tracker implementation.

Currently the concept between Yishai's and Joao's series is actually
similar, both having a capability interface and a command to read/clear
the bitmap of a tracked range except that Yishai's series allows
userspace to do range-based tracking while Joao's series currently
have the tracking enabled per the entire page table.

But in concept iommu dirty tracking can support range-based interfaces
too. For global dirty bit control (e.g. Intel and AMD) the iommu driver
can just turn it on globally upon any enabled range. For per-PTE
dirty bit control (e.g. ARM) it's actually a nice fit for range-based
tracking.

This pays the complexity of introducing a new object (dirty tracker)
in iommufd object hierarchy, with the gain of providing a single
dirty tracking interface to userspace.

Kind of like an page table can have a list of dirty trackers and each
tracker is used by a list of devices.

If iommu dirty tracker is available it is preferred to and used by all
devices (except mdev) attached to the page table.

Otherwise mlx5 etc. picks a vendor specific dirty tracker if available.

mdev's just share a generic software dirty tracker, not affected by=20
the presence of iommu dirty tracker.

Multiple trackers might be used for a page table at the same time.

Is above all worth it?

Thanks
Kevin


