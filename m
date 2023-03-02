Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7806B6A7B38
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 07:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCBGHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 01:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCBGHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 01:07:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D12C1E283;
        Wed,  1 Mar 2023 22:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677737231; x=1709273231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uoNTErxqyxr5Lq9Z3o2wiOd1zARl408Nb9HYaU6XZsY=;
  b=BfPza4Q+OMOckqnjh1Lf9iAX6TIOWBWKNCY932auPoCFYC1p2DeqPUag
   B/bKqPHjiPpE3hXrbSTF+a1wSVVFIWZbJr7ncHqUSCB6msAkinYVFbRTS
   852YUzZ6it69Nwt1lg6Rifv7/bJUBYCSV7oszADJp0VheM8wKKr6IrhHG
   fNB17gYesweH0bJKK/t2A6GpsZ5jFM7kYasREabvycwiQZ7dQZSstg9FF
   eCylA3AIMuGaN9fjAoAV/aMTzspOhhgRevUnY/kXGI2dmHMiE9vCZxGWI
   NQ1Thw0HNbT6T3/n01CjlEYnMmM3+VRsUDAwjRLcBWsaAaIOPnH2LnrTM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420891189"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420891189"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 22:07:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674828908"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="674828908"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2023 22:07:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 22:07:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 22:07:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 1 Mar 2023 22:07:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUQt0/s85XWb0Bs96V89IvEJZ5anarb8SEK6mS7B1aIM8pqF31c6zR6MoiI1B3fZ5IEikXog+wz15122iAvrBjXDhC5paUHb2TmTJBRMNwaLvqlPNfWbC9jgX1oDnpN91Zfy3OvLQN6u6pN5bmjAzwyrUTqK5+vb+Z0X4qubognFldQ71xUqcY5Q/B38tYisff8B4I7MDv3B2exIp0PCnXsmKtUvN+jZG5ug2I9ZEhSEbLDl2mKJOzlBvP0g5S9XORAsG7Uke5fm4uElNg+Kla5xDzBl6ZVtGVsTDP9m7KCfQ4U1MWkM1ctx1QghR5NgU2gHHYJYcEfj4HHNxhGYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayDgqcEySs8/eAqAJL2Zl2FjsHMmBHM70JQyU7r6nWI=;
 b=U333hUwCcfyvyH7hGXMH4kej1zfCvijrNsD123zk6qr6zvDxzjCeN/wy7bMeV8Em0gVG7/HUeYZ8tjbepU87wa505pGfAdx7rYIkf2uRSYlA9xEPegRJqBvdXymKEpzvHpl5CZZxn6ivB8OEprmdE+w8JQVLmngDnmoeJIOqVE4GzbhBt1cHy8mRyzGWlEny1z6/N0jtuTx1AOFBGzPqjc4i9HrRFDwUUFybDuUtHwkI3ZUIK51ZZA3ZWjXnH/ytW5nA+FR3VlqIgNlj3M2cHqaZt53dDxevFiNzAWofvRIhlqcEWoKr2zFiWbwz7PhXRdAdTQpSa5yd/jJKRtIeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5206.namprd11.prod.outlook.com (2603:10b6:510:3f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 06:07:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Thu, 2 Mar 2023
 06:07:05 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jg
Date:   Thu, 2 Mar 2023 06:07:04 +0000
Message-ID: <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
In-Reply-To: <20230227111135.61728-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5206:EE_
x-ms-office365-filtering-correlation-id: 2e732251-e2ce-46a4-bb3e-08db1ae458de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hiroOkNwnHPa9zL3ha4L0FSnioi7ondCPSp1zRkgrRa5qMaOzC3FuUM4g6pTiHyvUoLFEMV9rf4ve0SgVUhNU7Z8qJzhEB7+duA+2x8RgRhs/asgjfvy8HW4yGIf0h1udtySHKZs5O9nOk9cQxayImfn4rY4DUu13YALMuHQZSnWAw8u1Iqdaz/BpzAcfoVNqyJQBUqr5q3lAnZ2gj2al69tMge5DvV5FROyrAuDd3DASXY0ie7Icp1EkNWb0paIu9LhwMOH0AEwxz/THosp2xlF/XBZqOKTgSKT0/nV+1tPmNOFRHlNkamiop3xJ0Io0rMWkNfsOSZgwULQNdRkxlZcSCXfVHGlgdmMdQcs+MwY4eDNm0Pe+DxLspTt2ilNqGrXma+laLsnlWn7e7fSGWu6ooWA/31ASgJhTxU0Cj98Z5Qj3LRCwwqoB5vZ4h1473nr4bQ9GgdAYO46jdl0W6axtDit7IY6e+23mbzO8ciXtZyq5WIs2HubuRGy30JuHP5Q0w7Z9fJxtcxhbWFdpoGnao4MQNR+BMgK6S7uZx/vQUs4Is5fMFXGR6aIKCY2dkpDz6auB6V7Am00GSpjW3KLOMYvOObqUg1Vf8Ky7pXTFF9BDwTr3fGVsGSCGbWNy3VzHa+DKuH8Xm+iF3q9/bFVraZBWG00awiFH/J1sGvzWaA8onImH6cCmwK23U8ihz3ZaVElfGF/lmxOMVVSxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199018)(83380400001)(66946007)(38100700002)(122000001)(5660300002)(478600001)(8936002)(71200400001)(82960400001)(7416002)(33656002)(86362001)(55016003)(38070700005)(26005)(186003)(9686003)(6506007)(8676002)(64756008)(66446008)(66476007)(66556008)(7696005)(2906002)(76116006)(52536014)(316002)(4326008)(41300700001)(6636002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XVRnvfVHwmAO2j5ViO6B9mesoELsYmCdRXtVvqcsJNlfLsXp1FyIymIhKxym?=
 =?us-ascii?Q?dcNt5Xyc7q0azdm0LR+egazdFwGrgqtAkkE+Gx4ewaVBYg7JTXCZKoRyxnyS?=
 =?us-ascii?Q?I9QT2dNEmKZomsu4HXknknrjhNSPHw0VEonuXWR0oFFzag5hKPUxFvYlcyiY?=
 =?us-ascii?Q?fvr3/xv3RIgFLiL/mP6qVwSjqeQwaDr90YswWpmOq2mIFQbZluMZf8VVRs4W?=
 =?us-ascii?Q?tvugg3Vzgrspqnl/BOYGvzMwrOHvWqTsqMhH/wbl72xR23Fx4w6y6+9TQK5E?=
 =?us-ascii?Q?W5BolC4fS2vhVVZpYH/Foki5PTcXyH/nFIVwK04bj6Q+mbuqN/NosdOH466+?=
 =?us-ascii?Q?mz88z2Kg7xRyQxdgDN5JaUCnnIfGbKi2RAAAhxdoT55RVdL1MVLecmJ0VPsS?=
 =?us-ascii?Q?ASTpaJfkRXvFPt7pwm+XmBpZLk1OtrkOyLd20Sd9w2Dhda5/dM/7T+NIsqD4?=
 =?us-ascii?Q?3bvHpe8HLgqDabRvFx0ywN67E4kIvyoWeU+/lFWn54eCYOBalAKglqDxKZKn?=
 =?us-ascii?Q?NztG6VGtg+w21c9Oiba8ix5h88Pdr9gineBL+Sn9xsPCo+RvRuN3DchHP1cL?=
 =?us-ascii?Q?dfuUbBSQoRtCfZeD77kvPcSuPg8ZDEnl/Zu+CJR+ZuV779D7qnktuV8WXY/i?=
 =?us-ascii?Q?ZqXpRIl8FxmA64ac4sl2ZC7khXdABHWv6uau12JCCzkogWn+ZtjRoKYvzB/P?=
 =?us-ascii?Q?41hdb/fHHwHLlhdwRdJWLbHaeGvrexLNb32qwN6vxxm+DZqRW19aO+OlE1cn?=
 =?us-ascii?Q?x/1DGTAOjRNvim5q7dYzejs84OiZttUJhR6Cy0ZPsnh5sos+j9YB+6Rsy14a?=
 =?us-ascii?Q?JGAjbra4kx4edg81J54yehJZQAbIGDUGaGEa6PMzDm9mGRMJlcjsR1lT8XW2?=
 =?us-ascii?Q?AOneo2oSAqbmdeLmBhv3Tq+usSmttRo1koo6kPx6287kyFNc4W/RjXU8bAyx?=
 =?us-ascii?Q?BKQ6Y20vNW5uXcV+qFxT13EMm+/EEcUOEOGcVGHZCg2+pGeNQxBGSSgKkEii?=
 =?us-ascii?Q?9yTs+r6ZmXyLl94Cq09WxAzu8yIcJUJ4CyxbE8VuUnjQyyIe/Qb3Oaj1A8cR?=
 =?us-ascii?Q?zwn8tr2Nr/lajbZpOl2Ub8d5IRzreFrDl24LxnTSxidBN8oZia1Zwl0HK9y4?=
 =?us-ascii?Q?HtbjvlNjeTMN1HV2nr6ayMf6iM3Vv9gowUaVuRPfRg7YFYfrTwvGqvqWY+xE?=
 =?us-ascii?Q?UQUst6FaQ1xQLd8dP3dlzU18wkL7A4xE1hEZ/MbgS1dSeotCAQKyZcOCOnjH?=
 =?us-ascii?Q?jPrnmvjbIpLWTJQz1t0FEhXgZz8ehHAHWt1C7nViBCOegSL4UNmLSnFToDqE?=
 =?us-ascii?Q?xJmR/c4nHDdsfZmFia7ibtGRX1zXVEkpw8ia0/QneTTUyYbLuEFyfZETKrW9?=
 =?us-ascii?Q?GWnHelTOXNUFoBi77MprAa2d/hiSQJy1ZdShtwmuqzsUCRq+Gwyab62Cc+G1?=
 =?us-ascii?Q?RIPZUbgSv5Y7+A+8o1KDhrPEUbwZrox7G4A55XRdl7CKIL3QMPKz2tDZ1pdy?=
 =?us-ascii?Q?ukb4Vs776mbFkv/Oweq+izoX8r3/d7jE+3sRLhC6+j9/MsLgZsOlHxgFp6up?=
 =?us-ascii?Q?L6sylNoPKoZ69gu/ObwPu+NO4GyuhIQkfqpKqeDD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e732251-e2ce-46a4-bb3e-08db1ae458de
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 06:07:04.8445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdNh1Hi0owZXBpZesgde5fqJ7XtSjj6pyjfrAs4K7uZ/kAbcNuAXIV0JkPxFnJs424eV+3fEAbXMXHWMf9sSKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5206
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 27, 2023 7:11 PM
[...]
> @@ -2392,13 +2416,25 @@ static int
> vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>  	return ret;
>  }
>=20
> +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
> +				    struct iommufd_ctx *iommufd_ctx)
> +{
> +	struct iommufd_ctx *iommufd =3D vfio_device_iommufd(&vdev-
> >vdev);
> +
> +	if (!iommufd)
> +		return false;
> +
> +	return iommufd =3D=3D iommufd_ctx;
> +}
> +
>  /*
>   * We need to get memory_lock for each device, but devices can share
> mmap_lock,
>   * therefore we need to zap and hold the vma_lock for each device, and
> only then
>   * get each memory_lock.
>   */
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups)
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *cur_mem;
>  	struct vfio_pci_core_device *cur_vma;
> @@ -2429,10 +2465,27 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
>=20
>  	list_for_each_entry(cur_vma, &dev_set->device_list,
> vdev.dev_set_list) {
>  		/*
> -		 * Test whether all the affected devices are contained by
> the
> -		 * set of groups provided by the user.
> +		 * Test whether all the affected devices can be reset by the
> +		 * user.  The affected devices may already been opened or
> not
> +		 * yet.
> +		 *
> +		 * For the devices not opened yet, user can reset them. The
> +		 * reason is that the hot reset is done under the protection
> +		 * of the dev_set->lock, and device open is also under this
> +		 * lock.  During the hot reset, such devices can not be
> opened
> +		 * by other users.
> +		 *
> +		 * For the devices that have been opened, needs to check
> the
> +		 * ownership.  If the user provides a set of group fds, the
> +		 * ownership check is done by checking if all the opened
> +		 * devices are contained by the groups.  If the user provides
> +		 * a zero-length fd array, the ownerhsip check is done by
> +		 * checking if all the opened devices are bound to the same
> +		 * iommufd_ctx.
>  		 */
> -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> +		if (cur_vma->vdev.open_count &&
> +		    !vfio_dev_in_groups(cur_vma, groups) &&
> +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {

Hi Alex, Jason,

There is one concern on this approach which is related to the
cdev noiommu mode. As patch 16 of this series, cdev path
supports noiommu mode by passing a negative iommufd to
kernel. In such case, the vfio_device is not bound to a valid
iommufd. Then the check in vfio_dev_in_iommufd_ctx() is
to be broken.

An idea is to add a cdev_noiommu flag in vfio_device, when
checking the iommufd_ictx, also check this flag. If all the opened
devices in the dev_set have vfio_device->cdev_noiommu=3D=3Dtrue,
then the reset is considered to be doable. But there is a special
case. If devices in this dev_set are opened by two applications
that operates in cdev noiommu mode, then this logic is not able
to differentiate them. In that case, should we allow the reset?
It seems to ok to allow reset since noiommu mode itself means
no security between the applications that use it. thoughts?

>  			ret =3D -EINVAL;
>  			goto err_undo;
>  		}
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 2e3cb284711d..64e862a02dad 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -225,6 +225,11 @@ static inline void vfio_container_cleanup(void)
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx
> *ictx);
>  void vfio_iommufd_unbind(struct vfio_device *device);
> +static inline struct iommufd_ctx *
> +vfio_device_iommufd(struct vfio_device *device)
> +{
> +	return device->iommufd_ictx;
> +}
>  #else

Regards,
Yi Liu
