Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA86B399B
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjCJJGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjCJJGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:06:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3817DF9A;
        Fri, 10 Mar 2023 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678438920; x=1709974920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2E/XGg/Rby6TnDFKoD+A1IUd4RK06/GHaHl6s38O7pY=;
  b=GiAPfjHGEMLbH/Ja2AqFjT4LeAeR384tC1JIN20b5lTdOr950VDVjWtZ
   LbR0N+Lc9MC+bgmzBd7VaKhtpXBEHX8FfrsIo7RGso4DdWl6tEe4pX9UZ
   AbDBqDNODYgN9j0IjHl8+eonKdnAjC+fy8yhsLMQW/3jwODE3rGxzMOFZ
   SzqJ1X9cKKijya5HpAmloaVlyTB+F4JqZegPj/imx5LUKiJVXPmTchDDC
   ateFIkBnI0+HCwWWjwEBaEA22GkCKoxg9I1X0/FR64YKl+DP+mXW3Xqcq
   hXB+T732/EYZ4cQVkg8MrkwebuEay8oavRZvlyiMIIFOy0+iLa3kNkOby
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="317076160"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="317076160"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 01:01:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="787945035"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="787945035"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 10 Mar 2023 01:01:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:01:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 01:01:58 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 01:01:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPvGDN1FVojVIekawfjPg8c1HbwD/RZ5tbiVPvSZscYqnpA64fzw/XpmV6+t+cCDSvdV254f02iQiHhbkaiuybSAMFZfkwhDhxT8XMw+0+g64qekYuArkUvxMYNyTpdXpimlFQS+f86BP3lT2wRXdubSxEAJ3kZU4NbuwZAOo2W5svbDNZjf9JpFOQJCfW4PwCMXgCNaBt7vRNNMwlXpumAD8dG66Awqd1gAs25jnd7NPqPIUE3hlxOC9hi5CeYkOph6jj+lqghqOuZ6h6//8o+nYLjJbSyAsPLx7AUMgbeBLwpEU8j5qAq6A15EETU3pbcBpv/0bfuOK12+G8IfyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+awHarxFCzCLwEwg/C41XvvNwLtbni3RuH08/7jTvu0=;
 b=HjgqgRaAnxd8skB4ZnQH7ZVfTW1aOkaSWj5Yi/u/4px/AvL+G+XvMAfzrrivxY7MkPsTBEQaNmxnfmoKVlrIBTBBAQDqmo67odq2rxnFSkWqfnIFIIRrCKMw8JkzR0+fOTO1MxsGesJd0zdUBWkxwe/KL4aymnkdqL0K2PoPqnf/EtjrTcAqAtcDrHCIntjsBI5ZzQLJNI0H4O8mNx6paskLD7s6HxN6zMlIBn5UaDNZ7am4kxagAruoxnptXH8lwTHYSGksgc4j0fXKQ3QmjmLgE2NI49f71Gn7EvzdrqBGYXxLnMZ2sWjYrqWajo2XrRpkvmOkKr0mrX3TTUCUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6480.namprd11.prod.outlook.com (2603:10b6:8:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 09:01:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 09:01:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIPMa9EffDOZkWyiNA29dWGmq7zuaqg
Date:   Fri, 10 Mar 2023 09:01:55 +0000
Message-ID: <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-22-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6480:EE_
x-ms-office365-filtering-correlation-id: 0ca8e96d-2dce-43e4-cdab-08db21461955
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oqRJL3idfpJsGNPvt/GBLUf2pGIxgAEHtrWWMqLJ3NcDBdYPsnvFtc4WuTrZXGfNwZnFm60KqxRfDcprzPwkYkgRtcDfo8hKHgCHBOQOLX303GUVBo9whJY5Ykf//OoetFon044wx9mzFZZsuMFF0SWM5WjEhSshor8F1yXHEkr0PpjoGyfbXdk73+ViWOiAV8YCiy3pK5f87bm2BSPhlq7wVxeIfBXtNAD+oLIzAayjRR16H2m7kd0UizEE/nQiCInTar0r/Jv3lyFgbngrGNnzhJ7P0lWpPDuvOmp1SeR65QLfztQCk0JnaP+bKXTA3F6jwkNqCoQyriaWcOdwu7TrBKtcnpW8squdjFhPd3whqPSz4fu9qcYDtxypqXz9zVo8CUGXOK5GsoFGRVWz8mnUMke3uzLyT/p/aJYp57vw5g7aZRWkiPr7hSUUYQAKG9zvLjg0dlk1/NllUDTAXKM5T2/hvM0F48qrDa2ADFIN8dqSCYnhaNOUDW09Q63yj4GcfU18sE91+B7FvogbmvqL+RzF1NbeIJ80uq78TJZ918Qzuao/NlF42wPwPkqRbUV99OdMZTglmt/Bj1PuaP5Mhpg+Fn2s3GoceL2ZKmUkq+VRw5HY8nAitLBDAASaD3uLhpMm2+aFqVrJ7IRmvBk/InIbW8BLnp9yo8R1VFtZFh8gT8GPSpbqXBdqDw0OOiqhGPDpiGTHLs2aYIDYdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199018)(82960400001)(38070700005)(122000001)(38100700002)(86362001)(41300700001)(4326008)(66946007)(5660300002)(7416002)(2906002)(33656002)(7696005)(4744005)(66556008)(76116006)(64756008)(8676002)(66446008)(66476007)(8936002)(71200400001)(52536014)(186003)(9686003)(6506007)(316002)(54906003)(55016003)(110136005)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zw8eOu6mzG3ATqKMsI1xifnlnZqIwTKV7cH9WlmOdzFLfOd2X1Y7xljQ4xG8?=
 =?us-ascii?Q?jD5KXylDenpb2BKHvyzwAxyNf743s3Xy9MIc0sWw4KzLbBT4lNtpAt1RqmNB?=
 =?us-ascii?Q?iX2b/pLA139VDvgPi19hzNXJDSc6NktWinkTHQYgQcb8BwheA2Np64LuHlyr?=
 =?us-ascii?Q?qhYHprTILsXJwExmWjCZw6DiVbkgrJSs8frxqAe7ycajvbz4Wja7HszUVLlA?=
 =?us-ascii?Q?pS6gLcMj+zi7GlDtuGe+f6cmUZzA3UTbwV+oEgjNk/mgbFDUinnSC+IiqVRK?=
 =?us-ascii?Q?QiesCBFxVr/F5gn3sEon1Xp6vpHR6/4U+9Jk2aExWnj/FHt9TYLFIoB/zsRG?=
 =?us-ascii?Q?KsZSNON8EFNjb4lN4uNMTtOBWhACUS0Pp5A+udezDPaiF+R73qmOgvfpKLrD?=
 =?us-ascii?Q?RCBZZDHgxZFKpXsaYIEDxlVV4M31ul5+lUa/mJ641VkuYd842N9h/pn6hoRt?=
 =?us-ascii?Q?+6f5UKqoxwd4kLU/N/SETeemDFYgkGtMGabbM68G/y0KDY0vMLLcgsvKgWT9?=
 =?us-ascii?Q?ZVywGj0pSu0QSgZHfS76gjpbH5WrqyVVG9Bmowzqvgb5LTESo+6REeuKEM8h?=
 =?us-ascii?Q?2O/qux5WvXeuB7Rli6EvH3wY946+46PfWc9JElem00vxWm88WJfYOv0+qV0b?=
 =?us-ascii?Q?hiTgRA1Beio2tNoN6QK6ARPEXzOk3K67Vj2fTGQDjdAdzf144hIyQ+s+4rw6?=
 =?us-ascii?Q?RhtokULQ3FxdLZIo1SxTbfJC+cEFXPmBX46w//cEldg7NU2pqSp+IZy8qi49?=
 =?us-ascii?Q?wcoP1KSRgbzd2QDwJgBRWGDLZVfTGE8VrJz0yDB6JY9Xj8/jFNCTlSilM0dN?=
 =?us-ascii?Q?xwLjM65x3z9QH2Rgle3OXfUfEJPXm+JNubdEKgtNJfuyoshZk4LnFoGads1o?=
 =?us-ascii?Q?CPs/qmrR4t5LKwXlRBl+7IP8EzslMYEcjcm6/TLD/7Xqs9VDuGdeoA0pFQay?=
 =?us-ascii?Q?FCgLuFSKQWPiCG2e+Rt1OOLpsdTy9w9kyJzu9qtisRp5oGQSYJ+cba/E0T+B?=
 =?us-ascii?Q?OKHqhSXPvUUDvFKpIvzR6Ij1M2CI2wJRCVN0ptAif7zsemxHBqPa9PROaRY+?=
 =?us-ascii?Q?FlREyGPNYxf7Ty2i3UZa9c39suo7YDbH2S8Bqdt/Ty9jHYJREK/mnrc/PuGW?=
 =?us-ascii?Q?0oEeE4ptUdCvWk9pbiL40B4NM9b0nF3mzmGRPWrAoqG68O4DXLfWYGdbnbIL?=
 =?us-ascii?Q?FDM/SPfVx+dPM/iSOrzUM7zWrnLFTbxR2E9qH/OA6uIsdYB5ORDIj7T8SrXN?=
 =?us-ascii?Q?MHY3sVA2vA3Scp9wPy2B9zOtOh5zKYCJdLSJyetV9m9h+nMqKn7JZH6XG+0W?=
 =?us-ascii?Q?w1ltOD6uwfVG28EMuQ3tldF+S5wIiEtadRpFARt1QmBDxzZR/IwC26M0Nx+j?=
 =?us-ascii?Q?HX2VBPXzce+86Xepro0EmPb5UizqDRJPTJJ8/KdRws1Lofx75kmIyQnsycY/?=
 =?us-ascii?Q?uh6VGtbqgt60pDwdNSLqeH9Q0RNbic+nex2L0YyyG8fESGMevYliCDvB0e7G?=
 =?us-ascii?Q?qncXOrDwuF6e8MArfZuH/EXkPLhduxUpgdDr/G2eONXlGVh/3pz7c9fI6G1U?=
 =?us-ascii?Q?F4zTg3PJFiiexFe4NtOLnjqgwQRH+AOdYEs5CB0E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca8e96d-2dce-43e4-cdab-08db21461955
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 09:01:55.8913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dg0EnUz1e8HELG0b4Zi32SSJ6kVJuETjD/ZKyebiJ7igWo2+ralM+kHI5G0GFbBVpAPP/fZ2vmySEPMvAO1K8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
> +
> +static int vfio_device_cdev_probe_noiommu(struct vfio_device *device)
> +{
> +	struct iommu_group *iommu_group;
> +	int ret =3D 0;
> +
> +	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	iommu_group =3D iommu_group_get(device->dev);
> +	if (!iommu_group)
> +		return 0;
> +
> +	/*
> +	 * We cannot support noiommu mode for devices that are protected
> +	 * by IOMMU.  So check the iommu_group, if it is a no-iommu group
> +	 * created by VFIO, we support. If not, we refuse.
> +	 */
> +	if (!vfio_group_find_noiommu_group_from_iommu(iommu_group))
> +		ret =3D -EINVAL;
> +	iommu_group_put(iommu_group);
> +	return ret;

can check whether group->name =3D=3D "vfio-noiommu"?
