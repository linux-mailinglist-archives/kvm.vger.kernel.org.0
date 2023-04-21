Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59B66EA52A
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjDUHrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDUHra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:47:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CF62D56;
        Fri, 21 Apr 2023 00:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682063248; x=1713599248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kfa1X2AilJzH3nkXp93xcs6EORh48FHsC2OSvCIAQBc=;
  b=ghXqR+om1fjPrvv1VXkqMlQU6KG0ECn9tWgsyiHAQohMBKPqb9r92gB2
   K7EjpwgkNe6Ywt9pNxHZzxmpX5Y4zVqVSe9cnOVLftRHmjurAPQTpt8TY
   YNQ3LlAVOA5HiO43uxEC4KbxO7pteIrBOfZL8UjpSaQ4aQMrtfHM7voYT
   5AaSIUJjRx0ww4uaszFpCc2Q9luLL3AtjbmPcEpKz+wEaSF+JQkH4hNkK
   ZvmsLQDz/YHUzVB1E5Q2qMnB6vE9w59IrcDZGodEIQU9KAigz4dLJLy9x
   N/dD2W853P1J5FvVxBwz+tu342tK1XSH2ocfXKgxecJSu77nZbUvV+RBm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="411206075"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="411206075"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="694892014"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="694892014"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2023 00:47:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:47:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 00:47:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 00:47:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+KfVskgwrRwfDZ4nirfoI7VU9q0aStjCOwf2rMdu4VkQ4AwDGwXVwf8jZ4TTm7exliS+D2yj3TX3I4ZMpWuxtcL1fAxX5Y6MV/hlocqUUV/ThZZib9i0vzkjHXnoBfyzeTbd6gWN/cncTCrz+Dufea5df1NGe8kxxdlTKFfaeDam8tnJ66kfKx84VPonJiMy/1he1Ab68LJFtHmiP/LzS1IgBAjPN5unDXccE2vbtTJY7h60T1jbc9fco8Lmo9o44nneI9k651l+BAYeEsb/ZDBp7bvkUN0EK5fGwRMqETYf6v1SpYip5cv0kjTLMIeefshmyUpYXdXZ5jJCK6OLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPLXtFb39rsxb5ABtRjnp54XA5SXQX4is1/NJ80Je4o=;
 b=NPH34BOTQWyMamGivNikFzAHWOnsPI5XNREy+d9bLQcZOraUXjrHJIWIvYt/RPjFWAyOWiqoG80t1kVNz2fZBkx655PlNKPJFu7GThdiLHe+sd4lp//EWZbGirTHDzy7HQt0racFDtlRY9emdKKC+76JOIpemRzXsVqyI/PSgx+zsmtDNgH6IFDmAkh0aG5gkN0bFUrPeQYChOvReu7Z7FRJk2vfpt+K/3ifqi3HOnVS8R+H2vFloQlQ+co++Mo+xoHBo24bg3BebiSn6pscbMYUgUgpXwU9LD+/ea0YEhVgThUTY/NQ7tGFjHzqVBjRO+MRu478F7bU0YVCvito/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7978.namprd11.prod.outlook.com (2603:10b6:806:2fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 07:47:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 07:47:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Thread-Topic: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Thread-Index: AQHZc1yE16W9aY59DEuzMbzD2OIpT681YFcwgAACUQCAAADWIA==
Date:   Fri, 21 Apr 2023 07:47:13 +0000
Message-ID: <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
In-Reply-To: <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7978:EE_
x-ms-office365-filtering-correlation-id: 2f89c434-eb1e-43f8-9d4b-08db423c9f0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vkFB5mudpEOECx6fAmMzMJ+GqlZh72XJj1A16G12TRQW5gUqz5mQZUXJu6mU44y5iuPHR+91Ra3mB6cxBFJ4JlH6b2D4zqOUm/80pEeX4mMCBERrLOqRym1fA91V+qaBEQKArt7Z1Gzf5faotlz9anP3C7CXqH19+EtW5yH9gS7+SwLnHwyTvaGeKV1aevNyX02eAgvu/eEoLM0AhlqTge4QQxmH3fVOIbSaYBVaCQpZvkO65MdzngafVLSXyTuTpzfA3Ecw7QBynztCw1AMQ8q943MMkUGj8L8frD1oKDhXfIyhSs4uLiytJcIhb376ZEWskZQg9LFT3FopKRxijrucfrTzjIZwnkbZ7Fa+7L6o80/CPPr5esAo8Hi96gp3Z7icDqp/kVOlKUShevw8kjcj8HVgg6bpB/iIL0Gt7ga/u21YicUFq2LnAlAwRCAxvg7TtGF/6vXwGsaoBjyZ3ljEegADLv7fgBhKiPm9DWITZ09Rjxg2p8f79K5DYvHFF2t5SGCAZLOoZN7faN6sc0cwGsKNPRlpjCqb87t3vLnF2sM8+W1yqB1AYR06d44w00wwzjAENvTxBeKt4sD2nP5QQHXewEhRQ4YjmO/UuS4Ay0fb92PfR2E31Q1PRR3M2A6onl+Eox2Dhcf/rJEF6FjzRObTSgzQvMAasK5M7B4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199021)(966005)(7696005)(38070700005)(86362001)(478600001)(38100700002)(26005)(83380400001)(33656002)(55016003)(71200400001)(186003)(82960400001)(9686003)(6506007)(122000001)(6916009)(64756008)(4326008)(316002)(66476007)(66946007)(66446008)(76116006)(66556008)(2906002)(5660300002)(7416002)(8676002)(8936002)(52536014)(41300700001)(54906003)(341764005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Dd6lV+7AlE+tRcLikVa5vvgDErF6ldktgUnTusa/dRh/IcJWwSIpafVPOKKG?=
 =?us-ascii?Q?8nIlAEqyajFRRHIV3sjUMPOVRlxbeSRDQyit/HLz/+ESgjeXtL1U4syjK7xN?=
 =?us-ascii?Q?W24H/eEK4NY+XkrVXQZFFQw2OEWkbjGiXtrkCHqgiO5mAZj6H0r6WPuUgV0T?=
 =?us-ascii?Q?yiMbB7LtZP9Vxtg6w0T0FwqANyo0cYzSY/z2CRvqrFABsbGjpsz8QQegg51I?=
 =?us-ascii?Q?xbo9TUgfXJxcqYnyvCfPwPNG1Uyr5lhknGi2FCZ44Q1WGq6Q3qG155t8ERVo?=
 =?us-ascii?Q?DIOZl48qtNppjHV5tqt3jNy4qTxo2KUMUKcahy9g0R4oQRilUwEx5c94otI4?=
 =?us-ascii?Q?vav5ImpYBS7niIlihuvS3RHFN2FZUe4iw8gNJjxPxi1UE9I5OOmYLVUnw2fc?=
 =?us-ascii?Q?0O6QE/R0MArxnq7VmwpkABsJwaTtvteDri1KPKCU8KR/qnlFBiFeB4auVq2S?=
 =?us-ascii?Q?PAH+vAY4iS+cNianthReUsvIchEwtNdssdlA19+XVky8Ml8XBKvZx8frTGdf?=
 =?us-ascii?Q?wZNWteE2mvT11GixMpW6jy+oywN+K56b+1EVetZ+AkEGi7LVeEAB7jnXQUlc?=
 =?us-ascii?Q?Ziafei/D3BuMn8f3+2jdNueWMbJO0UITbvN5K6DlXx3mkD+UmYN9Pz/cH4QC?=
 =?us-ascii?Q?95iO2H3KbTwuNT7PXb+IAERdl14nzE0YCEIc3oCYnGtK6E3X8mP5CI+EIaXz?=
 =?us-ascii?Q?hotLy2JenFNpCluNmIfnQ2isRl5vsh2OE1NgSuUEwlvG6iylI60hRUblGNl+?=
 =?us-ascii?Q?gOAQF0e/eAJP/JD1WaJdJrCZyWI5jPmvcZMwI97u7P7GISK9KxmZQmtePTAS?=
 =?us-ascii?Q?yikk1jDhqHI0Ns0DMLQoqN0BpJySu+DoPFFlOf8XcD7CF0BRBQ71HyqW71Fb?=
 =?us-ascii?Q?SGdJuqIpmJPn0rQOovVqFaADJjQESFtLcVk9kbW+Jim53GP/w/RcUerZZuWa?=
 =?us-ascii?Q?y2RYaMlbRzeQTt6H1ig85Q6zB7etlbCgNRNzSWQc5e8O1zJd+UgCov5lGQte?=
 =?us-ascii?Q?vyVXOo0X47EsZmfNrh4S7hyijrdNTsszyVR3Q7mQvRSJircai62RTXRqhHQN?=
 =?us-ascii?Q?5LsefW/s8hZOwmyNYiCWztth+vguTkqHJVrU9iADjhh1TvI4KxPU9ved6p7+?=
 =?us-ascii?Q?KRxi0m/bSTCXDevgXTUbnfiFLVJGSwTiqQgvf01wIzXhcucWpXvw6moUka5B?=
 =?us-ascii?Q?uluB6VCA4ZswL57Rm2kdpUbCbDYYMSsDe2UyvPg69fsP5BGKjTdcOJJFDMl4?=
 =?us-ascii?Q?3TfIP9+j2fKNjVXWLUVbLlaUIP3heHUPfhdn+FKqsKkuqYCO3K4XSepp/TGb?=
 =?us-ascii?Q?f6W6GbuxOLwsS8hfHpmyhwqpT5ylSBBY6XItJ5uXGwzT1DTf7UawqIeWYeGs?=
 =?us-ascii?Q?O91uJEXyUGpjBfztMyXv8OZz3ALBdGRgdOv1HfxcIai9KGMZ51WQGuiachvq?=
 =?us-ascii?Q?azEG1pi35M6MCUWtGA4CIhbndcTJDZqDEfykFVuDw0Wox8kYOU4Dr45wdiJ0?=
 =?us-ascii?Q?bPHfjTahJQ6ZKC636xj8WcrTJmmlALSkTGUd9XWmy2jtyrIMjpbVb4j6mMhL?=
 =?us-ascii?Q?4UjxLEd3VoYxQTMlCFafWvjeRgvnHfkVjj/VmJ0j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f89c434-eb1e-43f8-9d4b-08db423c9f0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 07:47:13.6649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/rSx/kQwf9JAE7s7NMRHXwFsVqRrNxQf1WjaIMGDrHZApguKbA9jXDDru5uafu2bQF+zreSrYZ/9KyIkVN8lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7978
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, April 21, 2023 3:42 PM
>=20
> On Fri, Apr 21, 2023 at 07:35:52AM +0000, Tian, Kevin wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Thursday, April 20, 2023 3:48 PM
> > >
> > > This is a pair of new uAPI/ops for user space to set an iommu specifi=
c
> > > device data for a passthrough device. This is primarily used by SMMUv=
3
> > > driver for now, to link the vSID and the pSID of a device that's behi=
nd
> > > the SMMU. The link (lookup table) will be used to verify any ATC_INV
> > > command from the user space for that device, and then replace the SID
> > > field (virtual SID) with the corresponding physical SID.
> > >
> > > This series is available on Github:
> > > https://github.com/nicolinc/iommufd/commits/set_dev_data-rfc-v2
> > >
> > > Thanks!
> > > Nicolin
> > >
> >
> > there is no changelog compared to v1.
>=20
> Weird! How could it be missed during copy-n-paste..
> I recalled that I had it but seemingly lost it after an update.
>=20
> It is in the commit message of the cover-letter though:
> https://github.com/nicolinc/iommufd/commit/5e17d270bfca2a5e3e7401d4b
> f58ae53eb7a8a55
> --------------------------------------------------------
> Changelog
> v2:
>  * Integrated the uAPI into VFIO_DEVICE_BIND_IOMMUFD call
>  * Renamed the previous set_rid_user to set_dev_data, to decouple from
>    the PCI regime.
> v1:
>  https://lore.kernel.org/all/cover.1680762112.git.nicolinc@nvidia.com/
> --------------------------------------------------------
>=20
> > Could you add some words why changing from passing the information
> > in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
> > the latter option...
>=20
> Yea. Jason told me to decouple it from PCI. And merge it into
> a general uAPI. So I picked the BIND ioctl.
>=20

'decouple it from PCI' is kind of covered by renaming set_rid
to set_data. but I didn't get why this has to be merged with another
uAPI. Once iommufd_device is created we could have separate
ioctls to poke its attributes individually. What'd be broken if this
is not done at BIND time?
