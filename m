Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07DA380A45
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhENNSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 09:18:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:45637 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhENNSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 09:18:40 -0400
IronPort-SDR: Tv+Kmf7tC2tQyqb62PQJnuWsQ5lDbTDeqE+MSyH8z3AviX2P4YfICJ9nDOYaveXIFye4IQcJxP
 YJTyXxj+4GaA==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="179773675"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="179773675"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 06:17:26 -0700
IronPort-SDR: AKfzOtEMRZYsHcJ4cnbmmZLDJ4FKFpxTI+HzW9Io0k/EQxm9UkpsiuwRfHLjupoABVWS153wpU
 5db2EhzjpUog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="627138761"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 14 May 2021 06:17:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 14 May 2021 06:17:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 14 May 2021 06:17:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 14 May 2021 06:17:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWG//m3DtnwXUUTxIlHgFmTUpfpVO8tH0UlPF7fhqow3WoTRkudn24tfNJ7gOSHbb67jckLvUfAMZszpTDFleCYqUgNy/COAgtafPnT5Jb+wDA24YaYnmVKuHxsRY/jqLEffAtoL28bp2WVGrMPLVaMVVmsocmPeYZa0Kn/W4AKToepcMeeuuliEuSaU6jslqBAgcEIFtpmBKbHptv43ADR2Xpl3zcO0qXi5Dxa9sXuSc+kPbG1cqksJSWGw6kzGgYMAiMK4wDo7PyXDdZ3xaLjOlZr3qoDlurhx/dw57simYkz1aZW4Mufnv1aSmR3IbSBFqV6xuNjdj+AgO73eKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cZ+HTX11Wp6QLI+bPJWjhE8fANYug0jHui8IY9++dM=;
 b=S39n0CjSBTyXt1fgam5/FRmtsC/6SMncY16fy+BvHGoAqCT62d3MOv5ubg01JogC3BP7dSrU18cXms2q9ETP70P+V0m9yEGMzK/hgwtycTsmNLuV0fS7wfivovqfuoGrivkTDrMwj3aBbmNIkVDCbwZKXy/1NoJ2vMw4LIiZuYFe9+Fm+Ifzk7OoZF6rqSNmshF26eUYR+qX/kkH8xiEFyk6nwWM/bE4uxPoUhCiCdQee5ORBYOPpzYoTd+/9AChKJfyGuV002N7yjRn1t2pfC3VLAQhKttTQQhdN3v5uu9EHJOcUFDvq7KYGQfZfUMth4KjUv2OzGKsj1WKTjz/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cZ+HTX11Wp6QLI+bPJWjhE8fANYug0jHui8IY9++dM=;
 b=i/0B5p+YFJd2YqM79dH3Rry+47Z1tsVcxkj3Gg+u8/AMaGsicPKI19inAhV0rJbndRYVeaot2XGjCAp2Jq/wNMZPnU/IIAdgzgAHuHSI+BPaBQAnEUf6CVqHCZYiEoDK8WfyUmZ/n46LMUI5OgdELz9W4kXWOlbhX9Aeh4Ve7ig=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 14 May
 2021 13:17:24 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4129.028; Fri, 14 May
 2021 13:17:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABpYyw
Date:   Fri, 14 May 2021 13:17:23 +0000
Message-ID: <MWHPR11MB18863613CEBE3CDEEB86F4FC8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de> <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
In-Reply-To: <20210513120058.GG1096940@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ad29ca8-82b5-4647-1d0c-08d916da9cdd
x-ms-traffictypediagnostic: CO1PR11MB5041:
x-microsoft-antispam-prvs: <CO1PR11MB50417AE3AE56D78746397FAA8C509@CO1PR11MB5041.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ryZBUqHCAA4F4duAyR1BCFxL5Vu+AB3y5pulUv8gzEyNuFI8pYRZXWbgots4A4nV23fiVvuCqdHKpOLFTV0graWEI03J8b7ENRa1rvolHlYEo79/pCZ7fMJwPeX4rsG+/2sWcsCe9YvDCr4ScBBo8Hh/luLtkzuijV3LRkHwoqEaGjLl9Eucv18/a8Eg5caY3NspL5CnoC7Bg5dosgNKA3rjRbLDFsthYGwQ0vQ3xC2eOdT+FjUsARYVyEDcHsMb+uwKncFA2/JB8Zo1l1Jqfkkw1AZo7LGR0DJ+jHU8b/KtdbfrtdzikJK7ws4CK9uWe4Zuz16BkECkv06Q8ChFLKT5jdwbiqio8Mouu3486gpQ0LUHgQJm0+T8MkQlzJCJEDG8XWA44cUb60450rBI3hiLE1rJgj7Tc0YgBp2z1uEoEmaNj3mDQhgFBjTbJzS99l4G3SDk7Y50R2YZaGezVTrb+yBvxGGBlIIMpW4GnoamtCFdDtJbGow0PgLQbsJ5xq0tIL8hLlW1vZBaOP56XmVhBkB8VzKv1EPayzKu0l2iB3yYoPT17Oi2AG1vAiOiHOV5Pga+irgWyg/L6y9Z72IiDzndQhPNP13UVaf92cQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(4326008)(33656002)(316002)(2906002)(52536014)(6506007)(38100700002)(54906003)(7696005)(6916009)(478600001)(86362001)(5660300002)(186003)(7416002)(76116006)(66446008)(66476007)(64756008)(66556008)(55016002)(26005)(8936002)(9686003)(122000001)(71200400001)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JKeiy0sMc31X2jvXKPG52y8zq9laSB30GUM7Yahww8HzJEN20p+VMONBXyOe?=
 =?us-ascii?Q?PF8ALbMzJhmoAsPOj5GhA5FA+8YsG18YL25o/M07SxyXCX6nzEfuGZ9ACN4E?=
 =?us-ascii?Q?pw61eDqSYGUuU7T1qiYR0j2dwgwryK2atQeyE9PvageZ9PgnpsYZsRS4vwSY?=
 =?us-ascii?Q?1F37dj8hyg0x3nVLORBxDtvi7pEqnFyd+VLAMkMDYm1LZTW39f2F/gdPwQlC?=
 =?us-ascii?Q?U3Pbe6K/8aBhOd4cS8kmZxDisfMch4yRYGMA5wYomKDK07fSM8l9D+Qbnx+p?=
 =?us-ascii?Q?P2tZaxt6xISKzJdHvuWcczgN1wU4uMz2F+ysUcikq+lmrgQK9RPh+uOuDwHv?=
 =?us-ascii?Q?ABRHTfRG57zPceHfb8CSFxSo14wRO1c+dG0pYYHMqgcZcMvShLqWbVj4jIg8?=
 =?us-ascii?Q?FTQYrQgb8BNLRIwtmS7tZO8OpnWf4YQeDFNqCX2iDMcKU6Yia776P7a56vyE?=
 =?us-ascii?Q?GtDJvfeVFzzeghywu49vXeORLSQZpnP1KxpkexAoqNgxqlhEGOGA8ojwuHw2?=
 =?us-ascii?Q?Ebtm5UrlLMFplJxZ+Brk1dtx1xqMMMCWD8wP4qogQRY7EAd6eDQAJIauJVrj?=
 =?us-ascii?Q?HSi+gGfPWlNy7mv1pZvhdNZjzh9w2ebttgvmYXpQxsLWo7jBRbdG384Ar+Ih?=
 =?us-ascii?Q?PIvF0QnQYid6xAft+fa0OQCiPVMOA9t2Rk7QKwWRfD/z4awYjjPxzv/eskBp?=
 =?us-ascii?Q?cv8rbKr6nN+TnLKUfsyhnNPUOiTNJTif5UstxEf9eTKAOoC7Hy08f7V6rHey?=
 =?us-ascii?Q?StusSYAh6ulFi9pv2I8NCTgV90B9MD1l2NULLvub50mQ9CsZI/OuiU4MLeOE?=
 =?us-ascii?Q?OHAWxSHNzyZO78pEzdGXFz3+X2tpSLvBQVzzSQv2Qlg8QJ0pyKRSoKROmJ1E?=
 =?us-ascii?Q?n4h3BIFRiWDmypRH7fsaaeatyCw6+dhTq7i9v2wjcyE7YCy7sT8paLEPUEXW?=
 =?us-ascii?Q?/kY6iVGXYbPYMWA0jCVmcXj/B8fdDdBi5LoWZR7Ex0dxL+LsO9GvNX40yOGL?=
 =?us-ascii?Q?DLRYAdOol1U/KsRlBS0xG5RzMaFudnaiLF2qxOLFxMdM+8Tu91PxqyplbNEY?=
 =?us-ascii?Q?tUrH1GQXaaq42XJ5L8HzGZBuLLdkd7KtChWqQwYsw5Ce5WcfJpgARBYFIZjx?=
 =?us-ascii?Q?1R3kReWPrglSSpQ2TxwzIvVLXIzrZhveieY8ApPg5t2i8/PVdk18b50IkWJM?=
 =?us-ascii?Q?zPneMMu+DOv4fPJekW6qTb/Kce8EUKpqTb0MZCLpwhGgzuU7jcYu0S3lWtM1?=
 =?us-ascii?Q?S2uJGDyBkKYusLHTczCR1i2Xlcdf7NS57cvHhr9QqpsV6fkFI+dMJuAHy7l6?=
 =?us-ascii?Q?SyF6JlUyzpX5m7gIbL7xyJMg?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad29ca8-82b5-4647-1d0c-08d916da9cdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 13:17:23.8724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXoAQ/RajSaLPwd/8fiTKbH3+XiObyACEU8/VRBp0kUBMXGzJoO4GPYEyDd5OsubkpnJ9QPzljQ6iLG2mLL07g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, May 13, 2021 8:01 PM
>=20
> On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:
>=20
> > Are you specially concerned about this iommu_device hack which
> > directly connects mdev_device to iommu layer or the entire removed
> > logic including the aux domain concept? For the former we are now
> > following up the referred thread to find a clean way. But for the latte=
r
> > we feel it's still necessary regardless of how iommu interface is redes=
igned
> > to support device connection from the upper level driver. The reason is
> > that with mdev or subdevice one physical device could be attached to
> > multiple domains now. there could be a primary domain with DOMAIN_
> > DMA type for DMA_API use by parent driver itself, and multiple auxiliar=
y
> > domains with DOMAIN_UNMANAGED types for subdevices assigned to
> > different VMs.
>=20
> Why do we need more domains than just the physical domain for the
> parent? How does auxdomain appear in /dev/ioasid?
>=20

Another simple reason. Say you have 4 mdevs each from a different=20
parent are attached to an ioasid. If only using physical domain of the=20
parent + PASID it means there are 4 domains (thus 4 page tables) under=20
this IOASID thus every dma map operation must be replicated in all
4 domains which is really unnecessary. Having the domain created
with ioasid and allow a device attaching to multiple domains is much
cleaner for the upper-layer drivers to work with iommu interface.

Thanks
Kevin
