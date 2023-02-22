Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2469EF46
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjBVH00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjBVH0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:26:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858A836686;
        Tue, 21 Feb 2023 23:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677050784; x=1708586784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TcpN/iL/ZovBD1OD2QXfeZNcMtJJShbMvr1iC1/MBV4=;
  b=Q/7glxVjpDg8ybrcmWEHxo0czyGMDvr6gbRDT4a5yQbMpORUByALZGpi
   Co8I+ZQ9ZvODKI5etG252WtUB1U8urtowNv9hkklMcbeUXUJ11SsKb7fT
   +iC4oOl07MQIzuZkUWtwkGBKdaJhZw+N/tbcM/3CemhJ4pbHhTkMEvdag
   cf00rFQDcn0bHq8f1iz2G3nLQ6Q25XF13+IWcSGH/13v4F1pDERR3upCG
   X5Pg8EOCnzZZ0PvnAvIhICcGSeY2UvsqvFV081FxK6qQW7uFnFfNQ6nc4
   TE7vowiuwC4KLsxkCK7i1FQxN9EqvxJJrJnvF7L6h1sk971E2p2ZWLSaL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="316580594"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="316580594"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:26:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="740704287"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="740704287"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 21 Feb 2023 23:26:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:26:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:26:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:26:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnTypduuDa9vlRSwdiMMUtaXEJoElO8p/1Aqu9yojA2Qzy6QBmI74SfCLrV16CkfzMZY+ZlDkkcNtR/uUSrl5G9N5LAY7FvMKVzXlHJQn3jWdNsbG7YuOs78tuzjayHumpkTxlQSQ3gVrStjiZI8GoLEElLSgF+MQ/qMBMVXvFlrAM4rZEA6x16X+ax2Y5umcCaYwgzl7NdKe2BirT1mM4lUrP5rRegkNWXQpfC0EUz54gHPYAucKZ1Y9z8mQRVWuTrp57kTRjH0OUjHaJ5+Uxt4D8po8MEuHLa/L8FC56wtL6uwqT2iOD/rgWL8kF7yFVqdoh8Nci2CZ9fY8szV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdYuQ0pIti8bMS8DS0MrAw7df4oaK3Ysxx/YEmK04p0=;
 b=QXphuQEvtDJsHSZdvb4tOVIGpphwf008ZuqHZA/5TG5MgWR32W56WVPYDdoLhO6ABL+NhhccH/7aHC+RZ+HLQwtcNxSvW+JnicU9kYhQdbdsI9Pq3BbFenE/scanfGTI2SOIiiO87mQuOT8S4gC9/c22hJke2EFwjO9ShFAvTW+Tnsj2iYM8zuq4RRO8SsdyhnJqaNZY7hZijoCKfQS3v2GbRFvVNcMtLu0AJKC96FNBZxfALrzKkFaWr9ytU95E1+NovEZ8y015KDkbjFI84yR1d7+Dzvg6QeoRJoSmjJF0cMCV7rYcoCJD0GLqD1AMVnS9qh5V7KzJWok9xSE2YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:26:16 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:26:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRade4YzkLtsVl0WRYDgmHuz0/q7akQpA
Date:   Wed, 22 Feb 2023 07:26:16 +0000
Message-ID: <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY8PR11MB6818:EE_
x-ms-office365-filtering-correlation-id: 091028d9-695b-42ff-f1d2-08db14a6158c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kzf5SoRsPQG2IwlCXJocnOUyThFB0oM7cjKfBVeQBGQs+VZeydlx5Kq3bR+UfZq5tcunCBhY6RF1QM/0t1Bn2ELVlqNGZVDTVRDn/69YSbJvuFOI51mBAmz5JeS3k9nZwZ2CqwhH0BlWAwwfCSw8Lo61/GoTbXrG492MA+H3lyhdfBrVAnhNYiMFonfBWyTrUuK4Nz6gbO3P2E2qXKpL9kTHNGC9BVQA3FKV2mylbmAmjXBIgRObVTHaa78k4OP1wovp5X8iaiJrlShQHJz/2btM2+8+bj82oB4ZdakTRAdGpKK4oLrG6fVDE1LNvtvZChm1b5qX+UGjQewz0vIttmPNzNHX8CsxiBEUa2KYJyG42I5GfVJ/tK03EfoSDuN+i0qtx6IuxPJwnhXuPCZky4PBWc8SjgzqTGlmtOaISmUiv7ElcYsM66BUc4/Mm2lYf4OD+Nv0iVoRtIFTHgaVv3YRL9UH0gpQC362wBzFlVnwW6Sp+vU1y046xg2bRYTGgl3V0XLBW4qm2KLmK+Hv4KIkjkKE3N2HRo1faBV/4ovUfi6g/nITPO7IHitYCOTXbDiSn0+Tnyslxxc+RggFA+gA0hW3MugSPI7y6x/hcf95NiCg17w57w0zFJTL7y9MsmdAtZvL2BqatpQNj+kNQA77AkIUOdiBWbNLP+vQ0p6uQNcYl+OntP4LSZCcxNhl6jVieUMMd/9Phag6FriMkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199018)(83380400001)(76116006)(66946007)(66476007)(66556008)(66446008)(2906002)(71200400001)(33656002)(54906003)(110136005)(316002)(86362001)(38070700005)(55016003)(478600001)(8676002)(82960400001)(41300700001)(7696005)(122000001)(64756008)(38100700002)(8936002)(52536014)(26005)(186003)(9686003)(5660300002)(7416002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YNlulmRIaXFaxbWoL/XQT3eWPm6Q9VHq36lkLqvToWl+Y2fGyiEVFQdpLU2V?=
 =?us-ascii?Q?JRBAhxG+S5HVIHecDrjfjKe5uY3im7Ve9OIKZyxOrQsndLBiWK8HdlFv5lAg?=
 =?us-ascii?Q?BxOh05AwCK2f/5LXkK3c1z4D2IJH5kkqg2GVFlATWtSvfmVoS7JX1NyR9HxE?=
 =?us-ascii?Q?9G2dlAa2u4vuWiFINYd8iQQcl+1FdrZn4wYEyayow+tZGzLamyevgvU0+2Ju?=
 =?us-ascii?Q?uUxSAvydpaO/rKjobDR/lZmLEWFCLIYAJZrZHgyJ+SdvQjCD92Dq43csUo3H?=
 =?us-ascii?Q?3WUNQwsnEsilxUM8t0CFKWz+bhVZ/snsAsp11IRLz20jIwsBu4SJAyGqlY1H?=
 =?us-ascii?Q?+B/No5ZBOyjssTDhSGkvIdEMyZuAoulzAwJ6hLj1J0X52vEKtl+u2VXA3OTF?=
 =?us-ascii?Q?exxYvfyTvbSUNq6YcAbE4LBPEQdUT6rUqTymyLreCctBuQZQtmHxxg4gR6kT?=
 =?us-ascii?Q?rpHQvXM0M/ziK6NDsaXw2WDdyJQafITJ5baKt80dvfZNv1XUrAKMyyWStc4V?=
 =?us-ascii?Q?zIBDjzJsyEG1uDGoIckADyXLv/wUMarsUg9so75wc3QYA2m5bobotVp01V58?=
 =?us-ascii?Q?DA/hP5WgowVm4H9e0laLR2CkfPfDHpnVrkBpVvuX+1DxdJvEMcGkTQRuZNJn?=
 =?us-ascii?Q?oJcEb84llCkPZCsCWWjBjKqKaVYtKjMCCWD2scWok9lcTj9d2QBM/OpuDxt5?=
 =?us-ascii?Q?T55OJecBzObxb4MmotZc+DS3hrkBQ1ZesF8fdFNH+PTyUnZbH1fISChw8dLx?=
 =?us-ascii?Q?Y/6BPuFYOf/BQ1d4ltsMsBXp29lDtaToLbk1fAjx7JzFbH5VGSuiaCQPD+ss?=
 =?us-ascii?Q?4Rgg6FbAmkyqe8h1o0UP9sfWpsz5/VPj9T0etTKvJQeV4e+6mO02pQuBxDY0?=
 =?us-ascii?Q?xtjs4LwdGKZU3N58kU0DDIUcnhlws8l23iI6n8G2I/6t21jJaRvZJVb0TxJV?=
 =?us-ascii?Q?jNjViJQlRaA8eK383oh4HXlR4hOkzqW4ZWUWNB1cLPuEh9JxPmqnl0Tp8b/l?=
 =?us-ascii?Q?HCu45AduMqUwUAZwlGw9XzQWfvSAyXiTXbEYiN0zP1NAoy9T4b2rjflQLBgy?=
 =?us-ascii?Q?3MGBhnc5GOWp/bvB2ur+PwAhwsPeXFRbUhZWHySpGhvOV8KByST0Ke7/uRuU?=
 =?us-ascii?Q?sFfVlW7vUIkLERvhWZSSablVTPquEB+dLy1CHRedhKh/b/f7mkwFtSAtWae7?=
 =?us-ascii?Q?VDPTuCPDFxAJ/2xOGRQm+nHw39+1/gIzc3k3jg7izbWW3F/aJ3BNOs1uKtXp?=
 =?us-ascii?Q?liEsBnZgO7agTXh1IBNFljaKtkk6HrCZkkbr8s7N/QIJ9d2BXCHL3W2VRZ/5?=
 =?us-ascii?Q?Rf/G8/b0p9/rD1B/u1cxRAQ9TVPfp9JEDX6LeCjyCvSfu+604GEzvuI5dnfe?=
 =?us-ascii?Q?9tgrtzQQTtnDgNXW7v4XnAhAEZ4ku/fVTpTm4K05hd33bJKlDaWVercU2Rxz?=
 =?us-ascii?Q?RJG2A0+KtcYl5mrd41R0WiUwA5IWHWeHW5Y/Hy/lBrSFcEDK4S3itKe5dwFC?=
 =?us-ascii?Q?p8TR43d7sQrdR0fqB8dvASq/4BwxqvdBUFcefH9UCIFp7NSK4HKh4QWlYXgy?=
 =?us-ascii?Q?aohXxLY1yhZXIN7VXg3wDkKWt9ooSHAViH/FALf3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091028d9-695b-42ff-f1d2-08db14a6158c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:26:16.1586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a3eIORRNViqRMDRTPKMvHSHR2bzMDH7qOJye8yTi5C3qIVVvXEHGHkbv/F4aCKep8XJsGiatoQD3mvlnEk53VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
>  	/*
>  	 * We can't let userspace give us an arbitrarily large buffer to copy,
> -	 * so verify how many we think there could be.  Note groups can have
> -	 * multiple devices so one group per device is the max.
> +	 * so verify how many we think there could be.  Note user may
> provide
> +	 * a set of groups, group can have multiple devices so one group per
> +	 * device is the max.

well this change doesn't include cdev

> @@ -1320,7 +1321,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
>  		}
>=20
>  		/* Ensure the FD is a vfio FD.*/
> -		if (!vfio_file_is_valid(file)) {
> +		if (!vfio_file_is_device_opened(file)) {
>  			fput(file);
>  			ret =3D -EINVAL;
>  			break;

that function is not just for checking device.

Probably rename it to vfio_file_is_reset_valid().

btw this patch is insufficient to handle device fd. The current logic
requires every device in the dev_set covered by provided fd's:

static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
                               struct vfio_pci_group_info *groups)
{
 	unsigned int i;

	for (i =3D 0; i < groups->count; i++)
		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
			return true;
	return false;
}

Presumably when cdev fd is provided above should compare iommu
group of the fd and that of the vdev. Otherwise it expects the user
to have full access to every device in the set which is impractical.
