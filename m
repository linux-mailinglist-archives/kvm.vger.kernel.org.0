Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC7334A04C
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 04:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCZDf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 23:35:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:57126 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231234AbhCZDfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 23:35:37 -0400
IronPort-SDR: bAscTNx3vidFDnuJQOXn8bLLfQKMFTi9nnkxH44lfiTro4OM4NfICXYwn2/gClYhoP2uL2HFiG
 KZaYqEntc+RA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="187775009"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="187775009"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 20:35:35 -0700
IronPort-SDR: 3c+ebWTBNnUDyezfNqPb2Ny4bz33WFFSVnF5/aSmLTT9p5fdQLUIL7VItqLebrhG0dPOG6hrLi
 lbS/D4/Xox4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="392050720"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 25 Mar 2021 20:35:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:35:34 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:35:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 20:35:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 20:35:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azk2UZmRorva8HeTquoTk+hLh1HQ9YHCSiPG9enjt2H/T7SQxvyIUUys0dkY7ybeL4CzhJBoktzMI9zHN5t0s2tlk72zOsudMqemZDqA5cmshv6yseLIg++D2zWjKNU1TU4ZPh145VZDpWTLkMcYPHo+UkknwyDKUM1RBwdOC3MYmajis1HX2ujSFU1xBOr8KJzwgrtjxR7bTQpThCtJ1Ef0L569JhzCP522phUaGaT2feGOEsBcIERtY+XO6TmWFunK2urAxeAIoahpsC0Pr5McAqab2HmJnbdp1Of9QlZCuzT9KvFtqiXyV9jZAOUR1ywLHbfR4ARfH2fHryZLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqcKdmURhjQVwf+ZovD98J2QoQPJ0jO/C+bZoHe4kJ8=;
 b=GsJTtBhqUEbIKuneZ3ds3utENDbD6LreuthQEpN1qrh4GQBd7HefA7hUzQw8OD6LSroO8sQ+MqBGKYi3OwkZcekdFBnLRQwQ70lUVZ6I6LZoqdxvZu2d72Ynf24O5U5G/8wGD/VD0J8Vk1J8LtJwMM7hnLxjZOGHbq8dl8wLXXz+YncZuvuFnswpLF+MFu9Ap7aRyXF1dW85Aogpec60Gzyt1rv+7wL/mijzcrezv15j5yAGop+/Tmyv6BvN83bgME+ZGvlUa0CBc6xxqSZtIknJPzFnfVwujm4kwadJoYIXChckmmf7KVBUvmvejrAWvWcfddDZOlHHhKCwVWFHVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqcKdmURhjQVwf+ZovD98J2QoQPJ0jO/C+bZoHe4kJ8=;
 b=w93ZD69oaTfFoJ1iwr+WAkHJQzpU6sG4M0VUquH+DLiFv7Gl1alsN05zomaY2cEN67paq3Sw5Q04taB+ABf+j7dzGyXaARBvBOsTBrfLi2GMkFE+359wYQiw82a90t3RCI2eo5TxEjtcSdRau1HDfhM2JgYjfzor+4UDz5sM3cc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1518.namprd11.prod.outlook.com (2603:10b6:301:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 03:35:31 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 03:35:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Christoph Hellwig" <hch@lst.de>, Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 09/18] vfio/mdev: Add missing error handling to
 dev_set_name()
Thread-Topic: [PATCH 09/18] vfio/mdev: Add missing error handling to
 dev_set_name()
Thread-Index: AQHXIA3p3dDcTIRY50Ciz643EesteqqVoeow
Date:   Fri, 26 Mar 2021 03:35:31 +0000
Message-ID: <MWHPR11MB1886AC80AABA6A2C5EE430B58C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 739aeb83-b54e-4c3d-ea83-08d8f008352e
x-ms-traffictypediagnostic: MWHPR11MB1518:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB15186B2A9A723C8EE51449568C619@MWHPR11MB1518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bspGt9ZQ10IA5VlV/4PhffwMb6kYqHZ6RZP32Y25jmcwSlN4n0BlSMwu7tYKaya9A5gRmwRUQxElvkJO4Asy4KYMT+1F9RnbQpvCGGujI1BY4pK1BmdJNT445LsbYBNyYPk+R50R5lk0p+WN4c1QNP+7rn2z3Ym7DyocmEOaMT6PIU7MlSq4Scj6pTwwm0/ueZNRYrSdxC13lgIe8w4+4Sc3YyZsbSxq/lfPQYQ9dIU063jGeABGlvsh817+XP7fhtnpg/umqrMe1Pg8L00fJv7N8y9R8LY1sRL9FuomWczetfJoB4MssowJnytuvz1dVOtjiwkQYvicwUtr4YhyBCejOwIMQPMMMSXdyCkJWSyqDd2up0PCd8NVjTUPYGSCklJq9ffMLG3HxNOPIJO0iRJhyRBd4ZCv1wdgqfv4LtB3EfkPSO3XNzpRmPXOV1gzj90/D4KqFS7xNTlB+PATunhoKplOiEftYQ1rMyLz6M9lJ5U2M86y3F3+W6M0XXmETf/PxGK10ntAJqIqXsZyo/XVd1aBFSUr7foeqNOOThqWikOSN6jZqrZjC4i6ROrAEZFmnZnBo0LY9ZlxTXLebxYnoh8LTTx3sz4y4hoB8yN9fKd3yw4SLXvbDURqzqQRuR5vOd+JjEdZOToSApg0OwF/UkrWHaJc0W4IP3j2yhQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(478600001)(66476007)(9686003)(66446008)(7696005)(64756008)(66556008)(76116006)(55016002)(83380400001)(7416002)(66946007)(54906003)(4326008)(86362001)(316002)(110136005)(33656002)(8936002)(71200400001)(8676002)(26005)(6506007)(2906002)(186003)(38100700001)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RuQpVxH7UhrK9gtHaAAh8e7xEGYWB7hTfRLiit5ZjADjMr8d6i1UDQt17W/M?=
 =?us-ascii?Q?lPHv/K97+WnCU8g8HI/g1fIy8SqLz6WQjr3D92n53ibOTWwL2IVbuxo1hHJU?=
 =?us-ascii?Q?sgzNVCjiDqYjwru/Oppcy+3uPyXbnw0hepmMau/d0lE9YD4TGzjinyh3zXQz?=
 =?us-ascii?Q?NHeujWhKN+lZbasGhdnxRMB69g1BxwiCEImAulsEPYaRPPmN4i9ueG5B3fqN?=
 =?us-ascii?Q?dspqnZRMiX841brEYUscmE6xVn/LRO1WVlkRjwZvkbUpRS9DBiORqYuGL8Fo?=
 =?us-ascii?Q?9EKTXhNqEXZCCZNXlhLgkmdR5Tm4LVqNeE2OTfkdKVKr9T27Ok+7K7G12hfK?=
 =?us-ascii?Q?sAl42a8yUl/2YJ2+UviGh/SEPamHgd0zLPyjJZWxO6b6DjlFa6/Z5LVXlR1A?=
 =?us-ascii?Q?nTTVIno4twGh9oaChjJRFcMrUNpZOIkF+sHPd5aGKeob0p5bZEh5sVnU2rIs?=
 =?us-ascii?Q?DhcBe7bmUG1V7Quc3M5ylh24Zt8z8hgQJOdtMmcEsDWInJHQ00odUcsUp+Wu?=
 =?us-ascii?Q?3EtpvIQDnTAFGgdLO3Q9SQy1gG1feB4kjzWXRYf5SwpyEW6OvNY4kP9Oab59?=
 =?us-ascii?Q?dTh13xT9r8RdbPwkfwdUI+Jmwp/BPvWzEXhOUEcNqyYoo5fvTXanFgEcWNjR?=
 =?us-ascii?Q?DxkibTZjh04oCVHnqJHcyXMJrv8RymQ+VI/8ZOQjGJNCNb1+z8xqf/k9XtjV?=
 =?us-ascii?Q?U/dDJTzbr9qTThLyzEMs2qNOKFzN/2+hgqh4eV5bhPAerGtwgu94Jcwpujed?=
 =?us-ascii?Q?q/UuAvOXFCZTy/mILLyA7CfnhUMfmLA2sxJdYYorCJcdwEflqeBqd2pANfK9?=
 =?us-ascii?Q?QBXu3x4Dgolb+PMMDdE6xslswiwTzgSV+g751qv5rOwFlNKunerQJpPd9xv/?=
 =?us-ascii?Q?WDZpGp2Aa+M/8otvPxm4Booc313NI5VgvO5+IeHO0ctpNTYyJU5VxEWS6Me3?=
 =?us-ascii?Q?mQEN1RX94m1LqdOYRih8uLS+XppIj3IjdVlDXai1n4j+66pVCnzeZu+w1Xef?=
 =?us-ascii?Q?DP9eodhccaQgz/WdPQ81Chdc2SfU4XNgzwDjMkT2FxZHoymMfT1hWi3baDfY?=
 =?us-ascii?Q?yOg3lGxZFycEcV4hynCGCS5CzE90XeQNmRLd/k6GYBu9fFVuSIGmRqcCOay0?=
 =?us-ascii?Q?VNYg2vheuZcNVpVAN685WrqYgGcSPQC8+94nHoVnbz7lRH1hQx4HagzIeDwW?=
 =?us-ascii?Q?/6WoRSsJhVbLTz0FAaYZwkf2OXa463BbEj7TyG1f+8nYV9sT4Ury0ndNFEZa?=
 =?us-ascii?Q?pN9yuoQe6tn2t+1s8PpGwtdlBPBBSxZzSkenqM4zO2lRxSgXtOex0G38oPN1?=
 =?us-ascii?Q?FYWhdIOgw10e3Ueu8maF2KXl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739aeb83-b54e-4c3d-ea83-08d8f008352e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 03:35:31.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yw7O2+mJyZoe3ncXK9VW3AR40ZZZKtJ2PViH5lhIPJl41QRVusKswzCDqNLQWF4rz8wTA5UIyt2Qv5EtjCMdbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1518
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> This can fail, and seems to be a popular target for syzkaller error
> injection. Check the error return and unwind with put_device().
>=20
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 517b6fd351b63a..4b5e372ed58f26 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -258,7 +258,9 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  	list_add(&mdev->next, &mdev_list);
>  	mutex_unlock(&mdev_list_lock);
>=20
> -	dev_set_name(&mdev->dev, "%pUl", uuid);
> +	ret =3D dev_set_name(&mdev->dev, "%pUl", uuid);
> +	if (ret)
> +		goto mdev_fail;
>=20
>  	/* Check if parent unregistration has started */
>  	if (!down_read_trylock(&parent->unreg_sem)) {
> --
> 2.31.0

