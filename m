Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947EA49AB0A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 05:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S249166AbiAYEGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 23:06:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:25673 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357252AbiAYD5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 22:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643083034; x=1674619034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C0aVKsgkDqA/epjHfrCzUeOCSLYoIvNUQnCyEI+7Vqk=;
  b=REfowZu1NF8wn9HkLZY5uGl4oe2no+ci13DM7Xv0ksnxWXlC2U46MLgd
   +z6pcm4wbfxD+IuW/nxyUYUTTh1WaWn4OJQUrIGN9893T8nh9uzkdRUw+
   HP/+whVPDQ8aElgi2J295S5gcwcLoRNaVlPyFyI6YVKslwLqHYp/1zRUs
   Ly9LY8bRXjiojzCU9ZeN1rW5lEu5UKq5Yd59c4Jk4lRdaW9xaY7I7C/Lg
   Bb56gFG0Wq90HKPjwkQls7xsdSy7Ah96kTY4KUcJK0J/nbcPLHtRkZmYe
   Vam8t3AuXar3uoUEvpZ5g7dusoZ17UCV02kpkq6Bu6i0W+y9bh4mIsGOS
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226189382"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226189382"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 19:55:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="597000703"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2022 19:55:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 19:55:34 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 19:55:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 19:55:34 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 19:55:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WegTMgnUF07N2QId5uZt60O2Gbc8xxbSRXkC+mnIu/1Te/5QL54Q9pC3pC6qPLnwLKJxCH/pfI2xnNKvVhau7Jcns8cEAABaOUvPxRm6S2JMYZwuGWGpxgBIepfbWmZkHNd+mVxrEtpg9dh/CQ7YOkhq4oGm9tAEfNHoD7yKAOrnA83juNau1AlrH2TDEZwawbOl1swkHvQQodYGwuuawQMpLqM38jzf+bsris+34G0I1jgZQPmgT6R5GtPiGllarxTFV/gKCdv5wOZh/UqiqvW3+iVBPlAfL6qokrwZT7jEF0uWVzCwidjQbTVL2dTrJBJ+05iWwV8FxFZtCwiFmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxJ0LDov2K9zQlTac7l86vGzmcSvhs1pVcmbQnfVgeA=;
 b=Abn2nePSnhWIjFvXV14UxwLvLfgmiLEhutXD4+vYT1qW8B/mzOdtItOOqPSx6EBV2mwQEN1ExntheK/cGSQBv6i0yhHFtJj9QSdHU6GVirRwz82UZ+bvHLNzNkEc3C+iYbAxXYf95O2Z63bWWw2UT+Ak7VnVQhOO1HGsXo6DOHEfkQYNobx82x3XDky8qk5oIpnBXwCLtXEs664hTk4QYSFca76AcR7AfZmpKTShfVpoYlAvoUvPCfIuD3/e83ktCdrvPwWjZvilrhFIUwRGm7r+sXg8GiUhjzrQqRYJ64j7BXOY1E/MzX0f+SH4iPz5Pjwj8oO3gLn4b6nLoRQuug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5860.namprd11.prod.outlook.com (2603:10b6:303:19f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Tue, 25 Jan
 2022 03:55:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%5]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 03:55:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRg
Date:   Tue, 25 Jan 2022 03:55:31 +0000
Message-ID: <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
In-Reply-To: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1db2bb9c-7b33-4a3e-62d6-08d9dfb6889b
x-ms-traffictypediagnostic: MW5PR11MB5860:EE_
x-microsoft-antispam-prvs: <MW5PR11MB5860113D3F627736098A7CA18C5F9@MW5PR11MB5860.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZGDP+uAfV8vx1HAihG9zULUtsE649yXHGbjoWuvfP7ZDntbhRFvxZyKSa/1E+xudpOrgijSAnF3j8qRctf4zb6wzWHVXUh8zxK2H8ZIECvw6J70X8b/8sWjEOy9u1eydrkIWpRm6ZvnQwyO7LUYbCeOcF6oi0ePRDay5v9LVVSLozAjKZG1C8RYTy/4+L/1V1vJO7XxfKbiFA1Ns/NR/1/ND/8wUosFljyi9IHiIpTrc5aToHMzpw+5j/WpvDhKTUUB/rMLLgShBIv9vxlp9EKchRExvuPTnxVWToGTh1Ngc8WXASIOOd5MCiEl6NQRqI8zZr/ifCVMqOPij4XvWuAhUGtU4rT5NMlhB6ljn09QGmIQ0E7jzKdnyaIqRbapFQTuVr9BAOKJnbjLIn0ss5u6uU6i8fpyIBK4WiKwbDo+haW6Fd2FV4kwwH8MIwDgE89d0hSqhaf9YLunHer1mQ5lzJB8puY0iEoLO0eZVfSddj2Z12riYF3DpODEc+YH9TTXhV94Qtc7S1OfjaHS+xcZ2b8MTrGSChk799S/fLKToBBqrrJ/tu37c0ZN8a2ZMybREqHITFj6wlOZqyY6Zr2IiipZj6iuhpk6WVK9poCOOS2XmsNgd23t7EZJwcHfpmf9IHV0Y0mDLDfnJVJiJpZhWikPFyNA+K3bdoEqJZP8xL62XBVJEW3dlfm+4Zx2sUCP9wmIBt6BTwHRYlUug/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(122000001)(9686003)(8936002)(64756008)(66946007)(66446008)(7696005)(54906003)(38100700002)(6506007)(71200400001)(38070700005)(66476007)(55016003)(33656002)(186003)(8676002)(66556008)(82960400001)(4326008)(5660300002)(26005)(86362001)(52536014)(508600001)(76116006)(2906002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9JiZK+19YcP44xZhzK2nhK5Xz1KdBcJtpGC8gxJ/t5u5UXRfAOvYaCoR3DCl?=
 =?us-ascii?Q?oFgTm+MmgcgsHw77aibgztwMoxY/WTl5mKmRgsQPlJxI2FDPkfRak5izVcIz?=
 =?us-ascii?Q?Rxk6gIScLXfThc86PFCY2Saaq5icWUeCIJfcwLLFR949nmJcDpyJtX+GfQ90?=
 =?us-ascii?Q?McKUGM/GJ9o7W3ERGUVqiN0uDAApD6/xMGla4IfFakm48e9qlEFuNpS+jRmW?=
 =?us-ascii?Q?T//mcKQVDJI/R+7Wz7jgR/uPqngL8Xjt2WQJ+7F6BbzaefuygEMUyqDoMVSA?=
 =?us-ascii?Q?tkYHLsZGqLZ0CXTdZUKcLWyFs85/sSd+i7s3OL6IqYHb+MKtpfZAwNEfdd9D?=
 =?us-ascii?Q?dkB/sQ6FjxIlggLx2KV/FKOppLM9uaLXkmkEgbl5r3D86FdklbBtuvHu4sgJ?=
 =?us-ascii?Q?dHXQ1w22kgI3FyHmYXkycZX3dfmYngGNuRRhMNhpjKKfr1gGX73656IeOQVV?=
 =?us-ascii?Q?+iX+YyRjfaQ4xEXUqvtG5GbvupppQGamFUx+sTAjkhBYzmmyO+GvS/3yA/K+?=
 =?us-ascii?Q?hWKXwRihgXbfYw+F/lfOoQy06T8bkEhyrgvy0xzr2uQLPilbcoCvk10R7KAS?=
 =?us-ascii?Q?Vgd8A+aACcuAGcLrYr4Le7C4skGrUhgEZNTCq+N/SF2JtfICva/BrRNhmAQw?=
 =?us-ascii?Q?u0TVqPuhyBzEn5kXQdvVFdgW/oqtD4pNpTqUnz8Ulu51XhRoUmCHv+gmh3Iy?=
 =?us-ascii?Q?ZJ08PHT+lS45NJYuFr1Q4PHbmNB8Zm0fdMZXPkUjBw7q1GDsKwzzkdykO9nf?=
 =?us-ascii?Q?OQ8yhPN+ZydcvGYpbb4lkz3BAWqgQ5TmFd53koQR7H681Af+EAqa6y8fVyIU?=
 =?us-ascii?Q?injQrZBGw2MZOUfOLNDAJI5wvF7MQ8iUMbYsvDPa3cy5dOdCYyPmJrSbczqC?=
 =?us-ascii?Q?8dq8kPndmCE3EAnOFRaPOTOHzYB4WFAUjCxgY4ok7opOxt3bAa6cztNkDCDz?=
 =?us-ascii?Q?T84TSAceZ2zae4pby78z3gq9jMZkw3e1PE5Hl709S+oxYgW2UyU88l7GIB56?=
 =?us-ascii?Q?ezlM6k9K72A/6z/3NbTOZcaW50v9HJDspfQqx/bknPaAFOkss7ZzuCTpfBFb?=
 =?us-ascii?Q?7iRJU9KxHWIKKcTsluybk7tP9oKLapIkkRGG9QnDYl4Upqll8Kq8qhxr81nl?=
 =?us-ascii?Q?HPZBGP5uxFKqtgbNOXeRdXefM6BM39VqId2z+utqr+ilh4eZMzTqLdTY4t4k?=
 =?us-ascii?Q?yp0XP1PlI6D8TNuR1iYabhUI5NAPXFtEY7spSNpum/Z/F7fUbpLAmtQvYNpe?=
 =?us-ascii?Q?+eOWNeqzDD2UgXZDup9HaVM4iexnAegSbZ+ivshwjxC6tCIDakFsoeepjIoX?=
 =?us-ascii?Q?2hdIxOuamS0UD+QQeIBXtV1g5YebMNusfgyR7fZU4OMNLaYjChSAdncvuCiG?=
 =?us-ascii?Q?XODQQ+EpENT88ObGtdUyvvuv82y9SU0EB6F57GuK1TChjIztvHuHHBkY2pwF?=
 =?us-ascii?Q?82pwDbzadWhe8imbPvGpQuaQBqP3SCI/M4JoYfnXmtyeo6KOI/nyfeXo2YAp?=
 =?us-ascii?Q?5yt0BlqysUlL6/j2th523jaEs7rWHNJUH07EZRkypi4KtQNHu2jQV+7XE1Cq?=
 =?us-ascii?Q?unb6cvyyx3OJo9daLOpz1wgvzbZXYgvGNN/Yx1QSWP97xcVwCf+/eXSunuEL?=
 =?us-ascii?Q?0cE4ZGACJw/ZO6xUeMRJ98A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db2bb9c-7b33-4a3e-62d6-08d9dfb6889b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 03:55:31.7469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +N/CEgtiny7PqKsk7zNmg1ak5YKgzVchYX5s1r3hqNwceQWlI0idVbR1pOkArsM8blve3cV2IzdUuhguJp6OZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5860
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, January 15, 2022 3:35 AM
> + *
> + *   The peer to peer (P2P) quiescent state is intended to be a quiescen=
t
> + *   state for the device for the purposes of managing multiple devices
> within
> + *   a user context where peer-to-peer DMA between devices may be active=
.
> The
> + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device from
> + *   initiating any new P2P DMA transactions. If the device can identify=
 P2P
> + *   transactions then it can stop only P2P DMA, otherwise it must stop =
all
> + *   DMA.  The migration driver must complete any such outstanding
> operations
> + *   prior to completing the FSM arc into either P2P state.
> + *

Now NDMA is renamed to P2P... but we did discuss the potential
usage of using this state on devices which cannot stop DMA quickly=20
thus needs to drain pending page requests which further requires=20
running vCPUs if the fault is on guest I/O page table.

If you didn't change the mind isn't NDMA a more general name
giving multiple usages around it? Or do you intend the vPRI case
to introduce another new state now?

Thanks
Kevin
