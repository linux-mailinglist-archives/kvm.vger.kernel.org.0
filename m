Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4306809BD
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbjA3Jjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbjA3Jjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:39:32 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0A52E83A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 01:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675071544; x=1706607544;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ogBnkaOND8EA/blXO2Dh+1dtquY4hD0Vf9vawt+AfjY=;
  b=Gado9hlOim9S5g2t9ugxQRCpwF0bRiuYn6LHHeubDGrTUea73M6F4Wjw
   gQkCWPnHglTnWEEIOpy1FpPMuH5oBjPI7dlBaB+1wVzaMvlF9mRl/8Fn3
   NK2+I/x0EF9Ww+tzTnNK8AaZJDo99uai/phz6veGrwkMU6RHSTzOjPhSE
   22htu1RBYxpC0k4BFk9sA4DwXtz+oLLvpMz9CqkA1Jo06SZWQab8zME6a
   ukcwNxhxWhOOeE+LKDeUCT5kZIAWXg4wtGYYdQPrIE9zCQT/UXmfGdFJn
   rCL5XmtFhyCFg3GmguVBi/Yyed3i0vnJnGej+0i7B95L5DV4kQ6R+58NG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307860941"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307860941"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 01:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="806606572"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="806606572"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jan 2023 01:38:40 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:38:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 01:38:39 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 01:38:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG2lSCNVcA1CIol36a8CPkn9Kxfd9oyw9XvyJh31H+2kyf9UKd9V8Lj92cHMae6Q5aUAvyxy+EjcwV2bNZN2ehUQXBtA+8ID3wbBUOHn55w21S+speFbHhl2lXQ2bKC9luxibxg3DHQSN2ANVdVbHVHlzkpn9+ZmqKrHQyy6+9kEz1xQFH3E8efy1bioXD1gXqrkUNWTViiF/i+NFqLq8yOAJU6QLNY0DYLJp3/eJzx8jjZGcQJ9ypvg/502LwVbdqCqtDPLILVePfq5PD5hjN17O+p6JVVX95UFAvxbK/LR3ZbPWum3kfikfbrenyJKElQy9dwCc6QSm05umZuo8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/RAdlG2qkaJm5mdfthLx/RAl/wdcCJICLctxNpFGp4=;
 b=RVl0F2dnNgBBDN9aGRaRD6IJ4JCOhG0HxiAh3Z4ZHtd7Tdmlh1h/wM0MGf/E4xrToi3BhHFp4FztOYVN2eg3FI9nnio+0qjXdG6XerclpQ7jao1r0e9hC5+FUkZgSYFx8O5tzHkA4YvJ+8clS+grMAdPhEZ9imgkrEml/LJjR607PZkdeVk07pJPuqBhwuh8gYeRINh4YXbOADsPNilxm5zaCjS/rU5m5xn9QBTz/jlYWsVrDKUKx8jZGSoa5ddCElGD0x/vYsXeqfcTaNniBqQmJ1bgyUoddAoEWdZD3b7Mu87xj7d7EJooCSTk2CQDgkNfNruL/ldCb5zOqJ7rsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7244.namprd11.prod.outlook.com (2603:10b6:930:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 09:38:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 09:38:37 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZKnqZS+8POWOjeU6G9NbMGjMjsK6llfGAgACgWgCAEJDigA==
Date:   Mon, 30 Jan 2023 09:38:37 +0000
Message-ID: <DS0PR11MB7529B2A6DFED388621911879C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-8-yi.l.liu@intel.com>
        <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
 <20230119133554.26691320.alex.williamson@redhat.com>
In-Reply-To: <20230119133554.26691320.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB7244:EE_
x-ms-office365-filtering-correlation-id: ed21d4aa-88d8-49f4-a9d5-08db02a5c338
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kZz7RzYz3QuAbwHVelghNdDniWSl/1nA2FIrO8r57OT4aBvfBTtrdHdPIIAEWn1I9fVr1upoJcRbUxpJuepJZd/X2ScfKQkJ06qAsfd/Pgg5kdMQVGlp9gxxvHqoJm0OHF41O89y7oewrIdjEUGIHM/xlVGg2QqFhROYecDVb1tUleq/bBeXTWU0o9fv+3uZuJPEK50nE7xdbWf48GTmXsuyiH5ye+C/QF5uZWKbWLkJrlTaBXdxKY/du39zqzEdQRntUBlyTOQFQTC1GMMFwFOEvdKmkV0ENiBaMXu29+Xttl2vUKpOK7LyuHgijM4AgOXsxjWKV9rydyWy2g+iPJ/6ww0Vfmb3WuNUHMtfcs8/hZVYMoVJ3uQR8XQWCntIlU4gkw16rYBu2hcMJ4W95TII5YmjzU+iNUxxT03mK9lXoZ0K4Zn3EePvA63Cbl/G6666HC6Zbo9MbpqOR74j8jsj/YGTdWtijr03y8JGKHBzlLud9/rddzn/OJa/a9gPjfJgsNGly0YBafm45ZU67ymXqmeNx3xDq9fK6lxqU633C5T4sZdgiYg8SSznKDPPt6h/2Ngb1tlYlD6ze0kikVJ0Z31L/Nxwmt3s/oMfPD6H3ALobgwzKlTiuUh8gqdcJCCfMNbKqL4ZaFLT4AAljuskWikWHrHZ45aFapf4CBoCVxuPf6qJg1S8fpXnXLKMrUKJ+rgpnAqfrTDNo9a4YO7xgOoSbRjFW40adxeFEp4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(2906002)(82960400001)(33656002)(9686003)(26005)(186003)(478600001)(316002)(54906003)(110136005)(38070700005)(55016003)(86362001)(122000001)(38100700002)(41300700001)(8936002)(76116006)(4326008)(66446008)(66556008)(66476007)(64756008)(66946007)(8676002)(7696005)(52536014)(6506007)(71200400001)(5660300002)(7416002)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S0VZ0seLJ83CVBg2HxlfoSGPQdY7QW5aMIZ6xqMGFf9ARd7EHNUJUYHxXvK+?=
 =?us-ascii?Q?F2ZZfboO8ziDkDPXfvIw6DCZq4MFA5cJssDQ975MoaCAIae76Na+GxeFtet7?=
 =?us-ascii?Q?wEF984lFo7n43Gg4LPd3Q4VvEi+jUkXuLU7klS4iEsUXtIJMaLFTgCcA73hG?=
 =?us-ascii?Q?lNfkwPbAVPRmbqfr9W4BXpE9BXe66sS2+qm6BEQ3Ihxw8DumfUQ8tBnhsrF9?=
 =?us-ascii?Q?q3m+1FIdcy2G/4WRXohsk8h2CGORYDrbeqzLuvihW3PPBAl/LCPTsyiCeaL5?=
 =?us-ascii?Q?j4lXEAvnCPgwugw07NpLCBRPnD3MMzYgtTJOAXbXZT/CsxzpywOPZmOANwN3?=
 =?us-ascii?Q?0DPcYQ/xHhN6+aIEOZfYnNxhucFcRgo+/YWRfZcx/AAyypqQAOA5Wv2bDNqR?=
 =?us-ascii?Q?6ijnXVZVasXbXWL19Of7uXp9ZsfG4GWOkWtQkgJIopz4jtWbwqHI/cOY+FSu?=
 =?us-ascii?Q?W68WSL0PY5xuvsGMsQYQQlNmQEBng7BeoIWgdLUoQpwzyYQ6f5pvpiklVoH+?=
 =?us-ascii?Q?KCplDAO11xdWau4mIBsOAJkZtxP+PMCRsHez3Q6JWR3Z3FDHIdClKuP2iOsD?=
 =?us-ascii?Q?y7DLwWvQCiPABg+1r1xVIYPJ7fTsstk05UXZDUIxcYd1zW3fI3lGDZTpxsbo?=
 =?us-ascii?Q?9QiuDlYNyEVMxKK9M/Fpg8nKgIHDwKCqShEQR5G5o8aRAZ7GTfDsvVAmEjgZ?=
 =?us-ascii?Q?PMA2LPRC5XCme4XuUZ9k6xrOpDMHMmgYX9XSWBX03Z/iEsHvIEuIcNlT1bPy?=
 =?us-ascii?Q?cDyugQkP22eRKGoWL8JBLjHnoYwnG4k8eZCOAe/ZH5AXTUYByoxuGzKvYyz1?=
 =?us-ascii?Q?SZBPrsANmDlFUcZhR5v8beWy+2O6OiHjpKoIx7NFvd/wf+7qB41CshWgiL4J?=
 =?us-ascii?Q?dIL/W5z4sB47t47GYnmAMYX2YpL3yH3W9z4+FNN5QH/Blo2LXp58I2Y9e3ZN?=
 =?us-ascii?Q?ALmsI944tPEn05HFNag8Cj2gyOC/AuYLpKBPNyrOAvLGeqpxNCSPnFYGz1o3?=
 =?us-ascii?Q?8l1/jcFUNcYWiTH+zUU+KALBalPB6epnAUKDjskDKJPCzt6SCWnnw5I6jeZI?=
 =?us-ascii?Q?3YFzJbg7XJ9IP2l5O0CQAjgVQrzFzYwn2jKTZmI0cXJalcqkLN4mKujU8juG?=
 =?us-ascii?Q?WPZyml/wa14OKZIQiE0MuBKgag+YEWreRlYPftrXcksuyiUpZHfLy6ERiiDT?=
 =?us-ascii?Q?r3r3tIKUILQ5CatlYQ7vG7XRCiEPsAMH9F2sL6Nvr8vOrB817kudEIwsAki6?=
 =?us-ascii?Q?78rpcc8iBsLB/HXOBjEEbOUqPEWrJZE4YvAIVFvUnL1bs4D+/NuLwKmz09Dn?=
 =?us-ascii?Q?BnFfE/ZtbrCQH4s91Buhwam2zLsR8gRGK8FjShtvQYz4Sj846sZRL397Kk7X?=
 =?us-ascii?Q?k6A3qUpz1DadbFjgkkFkbXkv2z93KozI+jJfeffHF8occWK0HqvJm6fdjaMC?=
 =?us-ascii?Q?i0PifbHtmob+iCojTvPQxpy1GBORWTl++3LBoP7STk/y7hu0jjDYEAAWNOLg?=
 =?us-ascii?Q?8dgdsyGVkXxeFzKQBVJ4p1oXI4RUcdnLBOfeBdNJ0HqDUNQdEdpVrvDU2JDT?=
 =?us-ascii?Q?lr1wNuMane3n15cl8DBl8mBHyl4zymAGJPI9a1mV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed21d4aa-88d8-49f4-a9d5-08db02a5c338
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 09:38:37.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNEM4SZe9jYOvx3oy4b0/u3NBeen2EYEP8cELk96Qj9yCaEX9w+yfnuuooNx8+DmdHnMAkZM7kVUYpS/TSIZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, January 20, 2023 4:36 AM
>=20
> On Thu, 19 Jan 2023 12:01:59 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
>=20
> > >
> > > -void vfio_device_close(struct vfio_device *device,
> > > -		       struct iommufd_ctx *iommufd)
> > > +void vfio_device_close(struct vfio_device_file *df)
> > >  {
> > > +	struct vfio_device *device =3D df->device;
> > > +
> > >  	mutex_lock(&device->dev_set->lock);
> > >  	vfio_assert_device_open(device);
> > >  	if (device->open_count =3D=3D 1)
> > > -		vfio_device_last_close(device, iommufd);
> > > +		vfio_device_last_close(df);
> > >  	device->open_count--;
> > >  	mutex_unlock(&device->dev_set->lock);
> > >  }
>=20
> I find it strange that the dev_set->lock has been moved to the caller
> for open, but not for close.=20

There is dev_set->lock for close. Is it? just as the above code snippet.
dev_set->lock is held before calling vfio_device_last_close.

> Like Eric suggests, this seems to be
> because vfio_device_file is usurping dev_set->lock to protect its own
> fields, but then those fields are set on open, cleared on the open
> error path, but not on close??  Thanks,

Yeah. The on close, the vfio_device_file will be freed. So there is
no clear on the vfio_device_file fields.

Regards,
Yi Liu
