Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCD6647D89
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIGBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLIGBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:01:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B6A7D087;
        Thu,  8 Dec 2022 22:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670565680; x=1702101680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a8UeOeUAdHY4JHwWOA/dhzvoOG2Cd5Z8Oeqx5AlFy3M=;
  b=Wws8hNFzLeV0Y7oTYjhBpaNA91xnwByKB7JGqX2Zr2LssWVA/xvxAzOV
   Ae/AzVYFgpAyBrY/Fdz5gHpoaajd1dE5oZrUnkA7v4VwJ8Ix62ajDG8Kx
   g14KktRd1rN2htbc4murXz89Ulwjlorq6320K/Y9pBZmC0NrTDqegLLUx
   nETACiKDHpyOxEcdPh4Q07CEYWKYKUUnZOiU5d2IurHuMeyQ1NPi/3lRY
   u+1QXI21kIJ5rNzN2TO2gFihlqw9qx6T4nOAXpp3zf+ynJkooNbDgkM6i
   cJs7LCxk2021Bq3a3JG7oxEad8LLtQAr423X/gkp+GEsz2nEX2A+lD1tV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="305030209"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="305030209"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:01:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892543111"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892543111"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 22:01:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 22:01:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 22:01:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 22:01:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONe/9L9qER61+hIJDPcAyuow2UPsY0tofsADxAjxyhf0bNF8OnubHAdsvwfYMIgNhYkKW70amU4u+d285SQqWTQB0t3b73Zq+17H8YaeSL4d2R1FpsVnL4zPoe3FFPIREaU1WGav31U18JFi2AAY7tHhWg8ZjQwlI4GSLy9lCb8HRVnYNv5qWPIZWNvGoCVXV/oZCxoucbnsBUSqHE0sNJppeqCyWu9p2FOb+hB/srspYVW56gChE2ZDuea8gb3CE+nJvmHPvM2Lw58wL0ag+jpKwvyZ5PvSNpngCEWWRJFyVWbZocOHFg/vlTIywT+xSE8RgNNbaYZQCyQXYg1SGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Rc0iFPaix923aSJAIvjspDjXnhPo2q6FfOItbWQkkg=;
 b=X9/udtk+X7Vq8CVUNBx1dbBJwpqYd+iJhbFsO80H+CZQ7RsQ0yty0egX47uUc+O0NWR3q92trnDF99u0FeazVIJSt7INh114CwfLCbNGn2XuOXWJ21p5bCGYC1wuLflHuDMT4kJHmBwHOWdgB1tqnl5L3q9yccDsuTgPgNfh55jqyjH4bin6aSt7mMxwCdoUdROB2VsQE/rPKzSNsf5b/XPWnLXioGHfsParbEhgtMOvYFJ5HiSGssdm4k6soIl01RAdj24dAYLw9/TiLknAZehqDOBa0pUNd2yy7K1UQ3d/MkSTHdoanposwoXpdgMxntHREp32UOut5mW2MdwPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 06:01:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:01:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
CC:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Thread-Topic: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Thread-Index: AQHZC0NrusaNOCpuL0i34U+ryXeZF65lD9ww
Date:   Fri, 9 Dec 2022 06:01:14 +0000
Message-ID: <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7788:EE_
x-ms-office365-filtering-correlation-id: 1c977d45-397c-48a9-262f-08dad9aac7bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u8ess2cFRWstqaPfWSF4ZcHmedJREyu4r+LUpOTZ8QGGjUHEz2QkBcJqvnA4+1nnAFBh3oFwn0EePs+cKb7WNF3ZLf6DIpUmaddOQGR1mtIDdaK/fSC6KVjdvhhqouygGHYk6o2i4lYgCoVE7DNOffs+wL8NXOJKNyv6DbqYrXwytcdl5AYemHB7/vxFJGC3Mtwfy7xIhR26G6Otqfb2kCw3DiDvbWx0+3eBgz0JftQHMSZEwfZ6XPtAYAt3anFCJpEx3vGYFd4eABKQ7KsOKDZOvWATTc/BDvYAmw9ubXvQ+L2MeiYESGnkt41oS9WS2QNZ9rq/nINZGHof1Ir2qn/LddeX50MejN8idyquQ35u4aMOw1zmMDJ/HT8JEJ+Nh1rgTChXwB60rpeUyDaxF6RPBGw70Lq/xHVMljKEn3lBsDX+Ap0tJ0DT3mmgcUTI/Uq1BbrqCgKaQaIeymxGnnF6X1EdxrqFr5jdKNxKxwSJz2MqhFsIeoXvphmY83VZUXIlmZaPs8oMIR/2llesj+Nmc+OHxgIQuVoTOHitl+n+FAdb0XyI96L7yAWYJ/Zni5ynqtXejsiYMXS3+ACb6zl+tTxyWZzF+r0/qqtYMEE0qbnAE0+UAci7tI6PPQuWFx1FOjS2StLOyp2yr/x+B7YOO7v5IG5YE+hjIv83tgay+Mv0Jx3gozjodTAHUU5F+Z+mAYmW7sBR7y3INx3c6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(110136005)(33656002)(26005)(7696005)(6506007)(9686003)(38100700002)(122000001)(41300700001)(54906003)(82960400001)(4744005)(5660300002)(8936002)(55016003)(38070700005)(921005)(52536014)(2906002)(7416002)(316002)(66446008)(86362001)(64756008)(76116006)(66946007)(66556008)(186003)(66476007)(8676002)(4326008)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f3F9oSQI2JcLwqe86wixJjE2oGLhyHcuArzJG583qykslXOrx9emaDGuyECq?=
 =?us-ascii?Q?F5Y2ppKnR5ERtXb/anvVF0EeLYAiQm16TmVdWbRFGugXRqx/GE/liS8tvoi4?=
 =?us-ascii?Q?f+IGJvF2ZTkCDvQ/sPy8BvRfQgyK6UQXUr5t3QSSxrZiPqPw3VKzzHQ4ve1m?=
 =?us-ascii?Q?k2GpfAg3+mkDeyjQsD+/sS0B4WeeDbIzy0LnqU6iagfAETv7HB0fH9Bogcyd?=
 =?us-ascii?Q?KBKzmmzw05Ix/OPP8Exjr1ay2ePiAsook/sbpNYOYxjlJYa4u0uD/tjkRy/8?=
 =?us-ascii?Q?VOg+rsWSZxhAJvDtB5P5CXSZjca/qu6mf2fsA3Da/ZugvYG0ErpW0ZdP20G5?=
 =?us-ascii?Q?8RW0RJkZDkQojBC6mmP8pfixnGJ5Wbh7h8Z2BQoaKbCj/M0gaLPtaV+217B6?=
 =?us-ascii?Q?7wsng/p0ww6uovHuSIck0ZxWIFfqu3Ke62qctHHE363lxGGJvHObPFt85t4n?=
 =?us-ascii?Q?Ck5cQaYnME/JdYCeZT32J3hmyl3gJVEquRL4JXVqU4pVlI6Xrc0z6fzJR8sy?=
 =?us-ascii?Q?wxo1Alz5KsXIVqsFAB48QSCaD73v4QVNN12CcAXV0WDf+v1SQkb9nxnwgxxJ?=
 =?us-ascii?Q?O4bU1SOfljbJDBy91q8s5NnE5fyZgjZg0BfJ8IdbQj13yiBVzAMvmtQ/J0k9?=
 =?us-ascii?Q?sv8Ka+r2VxBpqX5ThT+4lRvmYT5LFFdQ7e0UhI55Dvdb0qm1SMKAcpKH55rE?=
 =?us-ascii?Q?30EefiS7hy+o4JVSd+vY+ZtTXUpNca3/9MrBMKCPmfXyhlGCRdigXgWLrAQS?=
 =?us-ascii?Q?fzY1Il3JB7i9B64cLgJttERBYpVdDZMNT5sMRbccOrZ+mWbwFMAWjVt1TRD+?=
 =?us-ascii?Q?j1RHWCBoDdbnDgIO+mMsORStK5A5MAJz+PSLhfesiLARxjqy6YwOVcXRm8SN?=
 =?us-ascii?Q?tNrlqHlvnhmv6e9QFMcafEhUrU3jz53h6P2c4FtJsZvYltNx1BQCjlCMzIK2?=
 =?us-ascii?Q?7Y0UAICxwfqHDRSNkklhqWp+vToJf944rt5+B2174/MZ8T2VLmnXf/G260eR?=
 =?us-ascii?Q?gxUrI3ohrw6YX6mMfkJCZs+oJAqz9GWAEuFOC2zC1bQvZ0hVNIFpIxhmPKsy?=
 =?us-ascii?Q?8AW0jG4cY1CjEhi+JRND9MJsAhFa/F403Tt5YzKmWe3O8PhRGfRsevc63EYK?=
 =?us-ascii?Q?JG/Ba3rvjcM/qpiYsRrOh4Y7SE3pzGE74PLJfaYryShNuD/+XkFVzFkpf9+F?=
 =?us-ascii?Q?jsC632y9122C93GSF+ayYNcmnHJBSl2NJEnddlW8MWxI9CZpTDwDdEckE8/c?=
 =?us-ascii?Q?7aisfSjSFaDk1gPqd/6vuG2hmk16U4gE/efSojb+ziK6NAthcbngLKynIVr6?=
 =?us-ascii?Q?0GQi0t6PJyGdJErd6yBYlbACwlGziOspRyP+bZsfQDOxnuvOLZLFC9J9FHTa?=
 =?us-ascii?Q?lhJMK/LyNvUz6MxOQrG2cCKLgIg0YJOzN4fBYqS1/X/YYc/eC1erA7KNPlwI?=
 =?us-ascii?Q?CSPEyr9gxHihyBkBXRluAfyZIVbG0a9grHgXMY/LUhd2sfF6bQmWBeGqltWj?=
 =?us-ascii?Q?7HX8/L2/ZclXhM5Q47ko4GzUUJijZS+V1JQNi5f+8PLYUYQP8SPb9ZGowZCj?=
 =?us-ascii?Q?yZ+H8jA/74sqCAV2ecai3UShEjM78K+s9FNPpvRP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c977d45-397c-48a9-262f-08dad9aac7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 06:01:14.4607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fM2G3KhTHSAs6/oxDZHJO70T4ktg4PNh9DTWL8gx6o2v5iThLxMwzZCj5NgiVWdOyrrKX31oZyIFGMW/F/RKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, December 9, 2022 4:27 AM
>
> @@ -170,7 +170,7 @@ static int iommufd_device_setup_msi(struct
> iommufd_device *idev,
>  	 * interrupt outside this iommufd context.
>  	 */
>  	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP)
> &&
> -	    !irq_domain_check_msi_remap()) {
> +	    !msi_device_has_secure_msi(idev->dev)) {
>  		if (!allow_unsafe_interrupts)
>  			return -EPERM;
>=20

this is where iommufd and vfio diverge.

vfio has a check to ensure all devices in the group has secure_msi.

but iommufd only imposes the check per device.
