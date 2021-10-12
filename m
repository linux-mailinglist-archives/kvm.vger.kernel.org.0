Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302FD429FFD
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhJLIgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:36:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:54588 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235175AbhJLIf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:35:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="224502435"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="224502435"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 01:33:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="716768428"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 12 Oct 2021 01:33:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:33:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 01:33:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 01:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNym5Yh+nSaeriRW5sEPCnbncMqK3XqIPnXk1bKa45unZGcvgdnBucrFv9hZOqaCIs3ot9DaVRyqKsMzWwz0dTlyM5NFwKyDx56oewWrSdmy1M6Ly6sQV06jGoNFNkNERO3IGwbwE5694Ymsrfa61ftYVyjnHnkXq5VWHc8nOZvF8skx/ssVR8MZlES2WUBVuK940gPX96BMVY7Olw7WdrCSPYajz6l3PogAGKbsx0ngL0Cj0MB3rMDvklv7VU7svJ4K8PxuBVPYIhtiWkP8QrZVKriJzBzX7oDCsdnuvOvBEhTQ48eYYcljp33TQZpUz0JU1NsWxFWjATQQtltDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgKQU5QfAQGN3TbkVlZVduPtO5H3SRza4JdJk0hVc9k=;
 b=lu8QG6biNnoVKlwZ8TbumjaZLatYO31nVfCajH0wdzbkgYWhsGSHti0CVYOs2xA8MAwxv/3cNVMvnLuOVvzOnb66Vh+zvPGgMYufLujysEaFfRhzsB7Vrb+eLaFgrSF2/bcO1tYEodJkevZh8nNH8pD1vQT4QW80yKW/H0eW9aD+zbJZ03aKxjuOw1F115o3NKMHKzi/xgNyLgiNhR9ZmGU3GYzUEmSZ83OePP4lc6chAAmLrfGhWEf96h/kvzKrgwdUJ0j2ARAMx0VclwkxV1O2A/MqHlbLfo82Thy5ILuMhO4vnfKyVdI6chYeBjcVmGpsdFcj6ww3tJA0LcZXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgKQU5QfAQGN3TbkVlZVduPtO5H3SRza4JdJk0hVc9k=;
 b=PdozCGxY7Mr0oEEXVsaWyaNU+FrSMzbyq09/Z+UAftg7uXxBihXotleAm3Iq/pp+H/DTR7+OEsB6IBSPo+PsmtIMqJZFbk+VAFMB9Rsns0qtiyK4f5k1vhOLtUS9s2LM18tKZKrpxS5XM8VOWJ/PiSYh1RWKVbx+cVwnC8cIikw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB3891.namprd11.prod.outlook.com (2603:10b6:405:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 08:33:49 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:33:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Topic: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Index: AQHXtxtagArROLssOEyJXJeP9bkSmKvPF1aQ
Date:   Tue, 12 Oct 2021 08:33:49 +0000
Message-ID: <BN9PR11MB5433538884DA4EB3B5BF89628CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53b61e5f-ff9d-40a6-3f99-08d98d5b03cb
x-ms-traffictypediagnostic: BN6PR11MB3891:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB389195D66F76ECE1FE2CAF688CB69@BN6PR11MB3891.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: euaxHaBruZmg0g1lcOOXo4flUGeohOmOpJszgW3jbI26iXjxhYbjGXlqkABzRE6oh0DpLqQ1Zk2CvHZLu9CzcqHqSyuy758N14FrIe8+QUNLXVKQKpzZ3T52sIALwTGgj8Ut/EXJRfvJcouO36hDGaaBarwL6pAk6/p/Ncu1m10gSvJ1zMqRww68kkll6hHTmpk8ID0UGsYIm8KolBPG8RV7MMRQpILEpr5qGZCDqyttc0OlYJqZodfyBQ62D4T29QNsR/mwyzWFFGMOIpR6fMUMx58xncMycEUS6PAxZ31FC2WafiUMllreCWCUK6L/1temOi83Shx9SC//UgLNNsea//31CpBFn0ANV3vKYWCQVK2vSPIbUlelJtxxnkl5aippEUqYM1r2eKN/jo7GQ2JaN6XGNTqfPP7FHL2y3XwbiKDrdZistFAnLu0CcCo2ULkZ1ZFymiwbJ2LRkvlP/3Bv13NA461fxuRcWGDElJ9EtpvWTcXwsz9x2ezBgZBud1MVF7Gzfya0CDP/L55BepEMFwYHVPMoUpjvsBoOzlxMIIPEg847XiP37sbsUVGHCHeWexj+kXto7p+jnH42KovB5AejlYNTOv4Y1LimMeJAB/fPpupb+3VOXQZaHMuYj4Vaeet9Lvho8Hpntx71TlW99p7q2FOJqPQ8IRuY33FxcRij73eAniM22k3lFsjAbI8BTrdvoLw3AXbondR/mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55016002)(54906003)(110136005)(508600001)(122000001)(5660300002)(26005)(33656002)(4326008)(52536014)(7696005)(6506007)(38070700005)(86362001)(316002)(9686003)(66446008)(8936002)(66476007)(66556008)(66946007)(71200400001)(186003)(64756008)(8676002)(107886003)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OR6fPQST1J0iNfII1X/gFUl5NfHhGKTylrmpbuZ9rozYn498yB7wGGaZewnI?=
 =?us-ascii?Q?6h73c3dhJ8UEHn9sWa52gFPK6GZuCEdH043vMxJOoo7DStK9Na9OsHD7gaWH?=
 =?us-ascii?Q?bB6GveX7GaAvEzNbTavswvM1LRBJGgYWb9gjqUAykqSqiJVFOLS0RtGnotLZ?=
 =?us-ascii?Q?3U7nVYTZ42vKJ9lI1o/comfLFtktgvNTMJtIBqvPS3dCqEIa8YgkFxWZ7+z4?=
 =?us-ascii?Q?DEtEcKm0nCjmt+j74bn8Km7EnsnR0KV9qGgk6O2oHtM9tQsMfCtMu7aQ6h3V?=
 =?us-ascii?Q?Gi1es2eh2n8OmG3WrvlMyYPc47G4mePNMQCyOSDJGt4E+ub9SRmAeZw7BQF/?=
 =?us-ascii?Q?aoBSALyvHg8uXsUiibbt3G599RW9yfS2VnpRn791rGajeKs0kgR7ugvgy9vV?=
 =?us-ascii?Q?NVZLcHQuqPCdQEH7Piw/us/a71I6TUdtR0T2VJMKM/GjRdadIB7JCV/Flo0Z?=
 =?us-ascii?Q?/gjVOAR3ucxRctMIzJ7KeV9IQe+Vu5rW3l0VcpLZI4N2MRIrLq95wCWyNTex?=
 =?us-ascii?Q?OXjKPuJFIv2YWu21ZG1oVREIYZsl1DhzyjCvAtoDMfJzZjHFeuVAvePAh589?=
 =?us-ascii?Q?m7NSaXFDrrYgN6H1AbkqRFFhe1LUzoTtd8WTPzVXn5endWMzJQSDytKGfW+K?=
 =?us-ascii?Q?CnPRXn7XIts8Cycmi0jPz2eoSq8hn+ATV+OiBzPdaFA/3BvEMLw0mtOJYja6?=
 =?us-ascii?Q?Uscriun7fnPAIn1sYUZheneGQWOM5fyPT405Zl9sZWt8ixZP2+xf4nKLNVNf?=
 =?us-ascii?Q?yfMP8c8SOvoP+HmhixXwy3l3PaR1o3NmSJFsET74JOHHxpYGVgR1aR8o71Ws?=
 =?us-ascii?Q?d4xORXtnBb8pJrcSjNEGZbAhk5ZXdwY5xZml5SYG8BNWROWYRUHAiWRCYfHT?=
 =?us-ascii?Q?ea8cUNpcsXwQ+hT/X7DEqKacyZmK3daKEAYHNGXkVsGsKOE9LggQzLbSHbG2?=
 =?us-ascii?Q?MqmZs36tLwJKa462GjpCTPmUNS29vBp/dF2seVM8UDniHuA61SMWq1dgup9b?=
 =?us-ascii?Q?pWth6TW9TdECk0mXuZjzQQ0c8iWIacYdlsZqbbvaCn9NkxfjcNyCEjAl/JSb?=
 =?us-ascii?Q?RJw0M4Le/PAWHquOz5qX+fNvLar3nuYto0ZFFWnAQUPVvuVadjDC3gMSLDcF?=
 =?us-ascii?Q?gKU+6OiQNmKbL3nign3YHVh4vgSpI5041qz+iC4jMGvAN4GvwbdGcbkPXOfS?=
 =?us-ascii?Q?2MZK4IAonQN9hrWfXIwhO6wcXOMN9tMV+uBwASF5+tUAjvo2wGDS4o2zF8sQ?=
 =?us-ascii?Q?mbNe6HrtrEuRDBDl9MueGXzxarRSzf8IPJe8FR0LEdAMrFUzDzvUD3tNz/Br?=
 =?us-ascii?Q?rYD/JPgaogXvd0bg67ELhg+4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b61e5f-ff9d-40a6-3f99-08d98d5b03cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:33:49.3643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8RPJTAEstrAuXxvPyL5kkQM3+8NHb59AirAABYgRjAsXXcia1DC2bFa1yV00wMZs3YJhl0RH6Z/wPKiX1sSPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3891
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>
[...]
=20
> +static void vfio_group_release(struct device *dev)
>  {
> -	struct vfio_group *group, *existing_group;
> -	struct device *dev;
> -	int ret, minor;
> +	struct vfio_group *group =3D container_of(dev, struct vfio_group, dev);
> +	struct vfio_unbound_dev *unbound, *tmp;
> +
> +	list_for_each_entry_safe(unbound, tmp,
> +				 &group->unbound_list, unbound_next) {
> +		list_del(&unbound->unbound_next);
> +		kfree(unbound);
> +	}

move to vfio_group_put()? this is not paired with vfio_group_alloc()...

[...]
>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  {
> -	struct vfio_group *group;
> +	struct vfio_group *group =3D
> +		container_of(inode->i_cdev, struct vfio_group, cdev);
>  	int opened;

A curiosity question. According to cdev_device_del() any cdev already
open will remain with their fops callable. What prevents vfio_group
from being released after cdev_device_del() has been called? Is it
because cdev open will hold a reference to device thus put_device()
will not hit zero in vfio_group_put()?

Thanks
Kevin
