Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD576F6B1
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjHDA50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjHDA5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:57:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA83A89;
        Thu,  3 Aug 2023 17:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691110642; x=1722646642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R3HIFTYZsxauMz2BThSm663otIq8nCy1mYE28+ifJNY=;
  b=KwGKO7phz/WCvHDeZku8JNhrzOs3TufUkVV5GGdxzHiwgQ4d00vb8g4i
   ogICDdTNtsQTVcZswkFWVVMRzWqoGMWLZ+3CvNMORLmUBAj/squjUj/eW
   AAkTxuX5tWL1phW35BSqsoT5HOyMr/JYXZ+iPnRMKYl9pgE8XgxlagpAJ
   1yg1vv5Y984FGSB06hfWRiQsPuLQrVUzyB/+mtdIdZQ1ZB9Aw/apAtPua
   022lqcWSGBuTrUT5eRHH1zcOcvSbDHzj1Qa5vwT5Y2D411Vk5WJu8YAV+
   0MHuxuDJQMNt9WwZVgANeehVWljTRtXmCFjJdJfjGPcAAHQeHn/7SQ+c1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="368933488"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="368933488"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 17:57:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="903658817"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="903658817"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2023 17:57:21 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 17:57:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 17:57:21 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 17:57:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MV44PcdBWv9J/JFnhL0NSWV705q7kZzl4LQU8XDbj+7Dxjlb5nO6KOtUuR9wPoZpkfXKwetIiJaF8/lZjBPCUqZKXAWC7hEwoG11QeSZPLTPWyy811/fNs5MGJr+uXeVOcy9jLZz19Nyv3l6ZjFopAo9y0Z9hFAXpDO2ryLUswNTHxSI4nvlUOaQ1562U7cVU9rGLrggmzKWn4OdxmWUO4mgcmu3Uz7po4yvtFwxxmarckuzcSZ1HWUPK7lCxzoYiLZNfELXmxpauFJU0wg3qWfkOduVKA9zXC9YFDmh2FNd/F3GbqKvGXn0J+p5ZlJpk/CWekAvmovepAnS8T7IVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKXdFSQN7+bcbZVmySW18EIKvGo4rzs4AqWx353CIEg=;
 b=idl3E9bM28Tlm2kd9XoQ109h1iA0EtKSHGeLPM0AJCdKRzSXQN0NS3IhccYhlHn5u3uVHQOGpXu8zw7RTcAZxjaV3uq1bYXiFPmuBT67GgVv8Yje5PCeOGgj9tcSA8gTtz+u9Dlu3XIxHbtHrUMrzFzR1m2YOCG+aqJuhzaGEzVJLCrfKMJo/WfDY9JbSdFIYaL7fpBQkOxlDJLRVbre4gs1EkErShWjo5OZ+TLx2/icS9y05Mw3/ZYs9T34cRI9pAzeMSDkS/RgeFez7UHTB/6Rzj0ZR0L7g6QZZKPI52A+Mznglf6bqeoaaZfnvZQpOJYnfcPia/w+P2xqo1ppsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 00:57:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 00:57:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] iommu: Make pasid array per device
Thread-Topic: [PATCH 0/2] iommu: Make pasid array per device
Thread-Index: AQHZxEIikFkwfZS1EkGjLQBwv0SKWq/XDxSAgACuMQCAAPW8gIAAn4OA
Date:   Fri, 4 Aug 2023 00:57:14 +0000
Message-ID: <BN9PR11MB5276FCBC0F9F21971E797AB08C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <ZMplBfgSb8Hh9jLt@ziepe.ca>
 <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZMvFR52o86upAVrp@ziepe.ca>
In-Reply-To: <ZMvFR52o86upAVrp@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5368:EE_
x-ms-office365-filtering-correlation-id: ee2afe37-178e-4314-e788-08db9485bded
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hc0MtHqtm/1jUHODtv4Kv42XrXsAQowAYOpj3bqIgZUPQgQOsfLs+nE3hgRQ+Mn+s4hnwZH0M/AxyCapEfiGplN3RkvcgvKng0uQIJcCTKt1f9heAz31SqW6NlUpXUjtsAlXha23xhlQQUeOq4B74upiLh+4Fz4DiaPfAKZLLsXlCfpYv0tF84aeROJ3tWImNRnMMTdBGYiJ3ENbUAN/wjs5LCBKzcounOVcKvfA8h64RItiVmbCBJeR4XxVKIsA8ZdD1Qgt5M7nk3oa1koPgiKvpuBwHf418u7JYPSO5H7CJxksSY+rt0IDHEmCQGx7FYg7t48bBJEKzkFR5xEutYf6zZd7Ff6yHWkx3qPJHVjGywaDhm7ZqWyYg3JAiD9vMBs0B7aTZzxWZ/PFE3zSUCbdyT1Uhgi8GCVzDRG2Btc4bmq6VS2ZBQvBnMR8jN+Ho4aSAldiDSpwMKDa5nL1e+S9LdqomGDJ0gBfW2Rd/8ce2rRfuj0ilS7EEcLu5F6oN01v4tVy79STOZcvoi/CAtJssBRMFx66xeuEWGQCOPIBzOSrmI3BlNIVPXJ8Wj89yTs6FaCyIoDTEyPS+GO2M1byO+YEByLa1D+rYk4OL0o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(1800799003)(186006)(38070700005)(33656002)(86362001)(54906003)(478600001)(55016003)(38100700002)(82960400001)(122000001)(6506007)(26005)(41300700001)(8936002)(8676002)(9686003)(7696005)(966005)(52536014)(6916009)(4326008)(71200400001)(66476007)(66556008)(66446008)(316002)(64756008)(7416002)(5660300002)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6auO0RN5fy6/9sF3mdlTeUqxNGPOH5ip6Cl6ec0uIM2cp3d71YU5L8kOGRjt?=
 =?us-ascii?Q?rjsXJT4Gj5tuNknY16/kxdt/yH7d1yYgbt9CCPGHPn0KjSA641qhLKPqhOuY?=
 =?us-ascii?Q?a3uKK3b3r8UwFlEHyo3dh2FK9WkPcGAlgCefKd1PUQC8x3smWxy7gl8cpmK1?=
 =?us-ascii?Q?PvQ+u/WzJzgYabMlPpqZqvVasJjHxVfQOPN3dnRqKWtzhOFzcjh66rBeZNFr?=
 =?us-ascii?Q?yFyK+Zny7jZdhQl+oJepx5qlBcCcuU7lufCSamGkqC85HCVTPjUiMqoDCMwL?=
 =?us-ascii?Q?fTpDS3jHLZWZEUw/w8UyhY1vwE8/N7agiC0WwWfnJzC7THOOn3e4TK/DN8CY?=
 =?us-ascii?Q?pIpk3He9engkFCaYW+CcJ8S1N5P+xFl9adIf27ovHMkWdomTrijlv6nksoPe?=
 =?us-ascii?Q?T7o9TUvsNZ/rG1d3TV7l8GDJT9xUwztAZqrxfwzhK47R2jhMsKLSZZFU28e5?=
 =?us-ascii?Q?9ZKYuMrLVvTYo+5Dba2hUp9mRv4CtmEou2Lw0uTU2UHBD08iFQp37wGAhHaT?=
 =?us-ascii?Q?dzbxDw6laYURr7kxqWKJZ85mmc6nYC5BRrOAX+Vr4L7DJHDUfL8R64F2xSjk?=
 =?us-ascii?Q?qaYxSEDON8eTs0DIMlxdEAEAr5fCpZy8Yt2+TZuFaFcnzzm4ll7ZmlUruM5N?=
 =?us-ascii?Q?wbPCjJ7FMcTmaDdqTFaA4VHR+1/PkT8OQpNZxfHzSqcQjD9HOxvAoDcUZbao?=
 =?us-ascii?Q?ZBEMjtVyAtMllojsUOFEoUToXKuI5Jh565PgTIEOBPqVGepnoHCFCOxyw6Xs?=
 =?us-ascii?Q?Gqb4h9bzkWTocCIzWCnFiYV1B3uQw2Zr5be2IBn0lTauBN8kjjt9A1HphngX?=
 =?us-ascii?Q?7zVUJ+EofmhxBaaO/uTmktXHdeSresmNpR8ooHJubsxYLyNemDWMdDsAdpyc?=
 =?us-ascii?Q?TF4qVVMwehhFF1JxVSErHNrzsnFW1JAv/+4Hthg1NsBF9Tu5AqE5htNr9M4W?=
 =?us-ascii?Q?5NPxgNN2YVGLhM2/IPYYOnxhdTN8OdT3tVd5j4m+riiztfyPhkfe2ZraIc+5?=
 =?us-ascii?Q?lAoPoFbLKrGef22v79ddIZvm1Fe/sY5148TYDIEj3yXV5SQ57WQiT2Ka/ZVh?=
 =?us-ascii?Q?RKs4yYIXbMyfHtOx0VjilKTjLbpqUq/NLM8B5r0Dy81kJk5aDPXxOUfAfmqM?=
 =?us-ascii?Q?Y4lV4GWdmAsfibMR3YdE0lJ0CuzDBF8CTOtzNuKmn9gi80g1xq3yfjANAo4g?=
 =?us-ascii?Q?fnhWvytiyOoM4MNdjFoLtvsKn+KaQKWY5wWnUarGEhvPkfbMT6s7Z5KTZE1E?=
 =?us-ascii?Q?WaPiCC45tO7/ruG6MgQqaQDX3cu5ZE3vBPPpxz+fKqQnb5Ad+eGsp4OzySxe?=
 =?us-ascii?Q?aD1akZMBgMc7SjWd5r60SWMsFEzjDqFuTAMlc2Zfc5SDUJzvxk3G8SCdsoho?=
 =?us-ascii?Q?z7H6h607ju6Zb3Dbv0o6VN68Ea3hKMae1E4czixKNrMFuhP+lY2Sc5ZRIUqA?=
 =?us-ascii?Q?XGHBMCcQfmQNS1DQ0LShCikDAFVSRYvbn8fi4Z3kqE0UBdinuihM9FHTV4i9?=
 =?us-ascii?Q?OpjU+jN0K5IMS+otRw9mkBDG+pKclTrdUbCJ4IU0yrbW5mUmm5LGQBL5TbNL?=
 =?us-ascii?Q?JiIXhX34qH4qx5GDs5shOFt+dPUa9qujThBVwDae?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2afe37-178e-4314-e788-08db9485bded
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 00:57:14.0964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWHwH2AZBt/zlhyAKP3KHxzQMf9jAmrNLDqz8M4Nt9e7IEWg61i5b9+IUZguEENKrDDYmoGzUD2+EmQmK5H3ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, August 3, 2023 11:19 PM
>=20
> On Thu, Aug 03, 2023 at 12:44:03AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Wednesday, August 2, 2023 10:16 PM
> > >
> > > On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
> > > > The PCI PASID enabling interface guarantees that the address space
> used
> > > > by each PASID is unique. This is achieved by checking that the PCI =
ACS
> > > > path is enabled for the device. If the path is not enabled, then th=
e
> > > > PASID feature cannot be used.
> > > >
> > > >     if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> > > >             return -EINVAL;
> > > >
> > > > The PASID array is not an attribute of the IOMMU group. It is more
> > > > natural to store the PASID array in the per-device IOMMU data. This
> > > > makes the code clearer and easier to understand. No functional
> changes
> > > > are intended.
> > >
> > > Is there a reason to do this?
> > >
> > > *PCI* requires the ACS/etc because PCI kind of messed up how switches
> > > handled PASID so PASID doesn't work otherwise.
> > >
> > > But there is nothing that says other bus type can't have working
> > > (non-PCI) PASID and still have device isolation issues.
> > >
> > > So unless there is a really strong reason to do this we should keep
> > > the PASID list in the group just like the domain.
> > >
> >
> > this comes from the consensus in [1].
> >
> > [1] https://lore.kernel.org/linux-iommu/ZAcyEzN4102gPsWC@nvidia.com/
>=20
> That consensus was that we don't have PASID support if there is
> multi-device groups, at least in iommufd.. That makes sense. If we
> want to change the core code to enforce this that also makes sense
>=20
> But this series is just moving the array?
>=20

This is a preparation series for supporting PASID in iommufd (will be
sent out probably after next version of the nesting series).

It only moves the array by taking only PCI into consideration. We could
add an explicit enforcement in iommu core for all types of devices.
