Return-Path: <kvm+bounces-3895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 055EF8099E7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52C291F213E6
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F334C6D;
	Fri,  8 Dec 2023 02:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niPgV1xy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7321991;
	Thu,  7 Dec 2023 18:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702004030; x=1733540030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ti6/hj+FFFEnp57nQsmG5vThrO4ZHgMylMpbJIr8FoA=;
  b=niPgV1xyNdemL4yp53igHAC36rm6kENcRV6IpkKMCtCVxLyytAq7aVQa
   JHVy8n/b0OgaPE2HyOVMd5DBQhavPfni/kO112s0vswomHmy0+FTSv5mf
   pOUxP5NDXpabnMS8gDjkEJV+igJoN3ildyxvlVY5BDoB64CvPXZWJbY5p
   DN/9fLsNFD/MOtctAjZcc2guFZktthm0Qqiyq1qf2JeSORLGKXPtAxZIF
   fbUl2c+Pcec85RdfzQlmkMBo+lAfXThyD2DlHbiCSzmgEOrWl5MuSpXT0
   ENDaax20blwfjQt2OsN7ozqy9CF/DNLSQte61e1D04WocBGyFeI8Vam5F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="7710089"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="7710089"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 18:53:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="842446071"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="842446071"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 18:53:49 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 18:53:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 18:53:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 18:53:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQ5IauT4IKKSzY86B+X4wEY90W+/z4ffUqi+DlNiXjboljB5zTUw7B7gbsAtH8Cnjyon2XFXVrn/1F2hEvrSJaxEWmT7o3ADXa0iMGnOZ/J8Z36fIVBS2POn7NHkqUZnHC7RTBozxEfN1j1wYvb8lF23T5exhLHZ4eYMAuWklNXQK46QWRrIcsO850q3XbSJ7EP38eS4PCHzLIGGnIzUIVgWZh87y9UKBWJ+iAQhOma0U7+9GhDcwNB3jZbyy24/TSmDs0vescceNAh47tmnxks2wpBejAO7/sg9267jjFByiIiDRjt3U6DxVsICb0t+y30WjrnR9lYdKsYhLyxVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMMdb1PpIOBQ4fIzx1FOtGFm4xzhdVVgPxyaIItmXWI=;
 b=HvRikDw7IOl8KPU0ddZgJ1sMC1nnMf0na4YIQTIQOHEmm+cHvsdHsu6AZz3VyTCRzp+vDJycJQvzDfhk6OjXF0Nfp8/P0ddc5Rhjp7IetoUapdM3r9jXXKKRewa4RywW+s9jKGThPEGL3ZJum0+Xat1h+Id7CI+jEIAZAuBmBDWar4b5UyK2tPbKefhMyW4i9M4pgemH/mHbhcX/KsO6vcXIlvmyUjUU/k4jmoN4il8WPm1V40dw5H6flNnd8CKCnSQwC1Qyh1qlRr1PH1byUcGWxMDu4+N2UmAXWHm++MlxnnvrHgBhCN1ltWbZaKpA1XX/0qKu98rH/zaIDeyeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 02:53:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Fri, 8 Dec 2023
 02:53:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Cao, Yahui" <yahui.cao@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim, Madhu"
	<madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 08/12] ice: Save and load RX Queue head
Thread-Topic: [PATCH iwl-next v4 08/12] ice: Save and load RX Queue head
Thread-Index: AQHaHCV/OCOKlQEK7EeTKXfnKkai+7CdigMggAB184CAAMp8UA==
Date: Fri, 8 Dec 2023 02:53:44 +0000
Message-ID: <BN9PR11MB5276771D5FB2D3CDAC3A70348C8AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-9-yahui.cao@intel.com>
 <BN9PR11MB5276DFED75FE8F9372B7A3CE8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231207144615.GK2692119@nvidia.com>
In-Reply-To: <20231207144615.GK2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7471:EE_
x-ms-office365-filtering-correlation-id: 53c30e7f-3f15-4d64-7d36-08dbf798e4b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXC7F5dEaYcleAqpE3Jc8HPl+5l3/ttShFLC+sbuPDc0tilsOdJNIdMmxTZOcm+iArf5jdaQEK2kD8hT5LCNZtL8pdVPhSiPf5r8RFc2RaK9EQdBm/r1kPzuNwsD1kqBGea6pmkD35v25l8SmMkshhtRx6DSEcMlbZ1glixc50FdKLl+bmdThhwl+y0jnMFmVigq0jl+h0LGzlc9eZa2ulOUoJGj5a8bZrm25lKt77zq3v/wLE55xyTSWbzmGRKx1U6bLSoNKz1JCY9zjpWY7P7IHF7+WWdJhhT0cUmI+bqKg0dHek7nCEpDafdioLT+Gvx3RVvWQMnilWDLKAXXAQ3ymeTXLw5hvIsedurA6QymAFXdLQc3F1S86IOGaMprkRj9ipRyUTQo5rFEseUtn4bP9waZVzYH9sjNXQRQBYIFbIFi6vgxTbVZ8O2TUrhbVZdHCFvraMq0P5Hmh9tDnWC1YBY0kyY77lO1anIbD2p3L+oYfmA/rX2XBTZxEnvmheTUAX4c3tZBQuoEVSFh3v7KUwaVu1Yd7v0eSZsOs5jAISBTaw0YsLaNNWOEZkeYxGOLLlm4ve5zXYE4Zdn+YptoesuOG7+lw+KIhhdX2afiY1uOuWMPBVmt8Pvc3mWm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(136003)(346002)(39860400002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(478600001)(66556008)(66476007)(66446008)(64756008)(54906003)(76116006)(66946007)(38100700002)(6916009)(55016003)(9686003)(26005)(83380400001)(316002)(71200400001)(7696005)(6506007)(82960400001)(38070700009)(2906002)(8936002)(86362001)(4326008)(8676002)(52536014)(5660300002)(33656002)(7416002)(41300700001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?omfidNdVO84O/NiTMnkxMWk4eTEOtpj4RrBjvXWTO7kc/olkJ9EdIpxeCkkJ?=
 =?us-ascii?Q?hx13js8YVQ9V4EyTFYFxoDCSaL4ICur9fEBNDrBCbZVzEsAS+lNJaXKwyrIS?=
 =?us-ascii?Q?rpchQ7BjeCyOqr8o5U1bB+ZCH39i+ywhoCppqfasQZyg0NarFzBhoTF4Gx9Q?=
 =?us-ascii?Q?Ve0aDz8Swm0B9tTc1LKPN6By958SNCyX9ZFP2IvOkn0lnDdchKJXzvkrQyuk?=
 =?us-ascii?Q?Q56rqKTkoFmgsAtoZzbY32usQ5534TuQQJ+ivMbdeFq7sxPzXXjPrgX2wQtt?=
 =?us-ascii?Q?urtZWvRzFuRBopsYjf6h0Ri1sjdPDpelPvA+kZEZUefI4x5xPAADMJD4UxVQ?=
 =?us-ascii?Q?aYtZ6YyWURDNkrxmQQjui1mBQz6vpEZS5Bs8g3z7KC0c8h3bRTHUnPzNFXHw?=
 =?us-ascii?Q?JikngkIgx8sgPro6bhkGEHaodbwog/wGf7MhyMi+ZJWO27g5iZHKVSWfHqm8?=
 =?us-ascii?Q?dhYswlMyISOvGugEnYDNhfJoBItnxaCa/gsxkaGPf7PTwRdp2TZc9DHQ2kbe?=
 =?us-ascii?Q?B7m66tcs+aJvo1MDkiGhxJ2EKSC85yNpfH4yq1GFT61PfCJ9oauuhVDuKB04?=
 =?us-ascii?Q?twasxCe1b0kNgl4+kp1sD0oNNo3GtiQSU6BPFPTpNr0Np9gDbsl02tVIR8GG?=
 =?us-ascii?Q?J93Lz1Ty4BnviYCmPkqmsXNIzXdW58NCS1KExc8wohHmLYPrjx6v+4KroFkp?=
 =?us-ascii?Q?QW7D5YL1cs4tcjvAnHw3MDF4qt+mMYarfQgrbiBEpfRICdYDcdTGNI3gFRaP?=
 =?us-ascii?Q?BVv+q4jcOuuoIbHURDrpvadf9DiWl/7yz8gDiXGuvWFWS1cefbqfU0EYlUBA?=
 =?us-ascii?Q?ibnlwiYh6IfCmC/q/N6ck5G3yAQZEcZveiLOUbALAiUdeHe24QW+Wo+/UBbh?=
 =?us-ascii?Q?EpJlJZFCYD8sL5Uv2adugKe6lNhel+rIsOKcKIndTin6csbR1sshFC01AW6L?=
 =?us-ascii?Q?V/lQNUb0FGGn+/JHVKTPXtAMHhZSorbd4bRqg4SsKpk5tQgDZtGEL63WKS69?=
 =?us-ascii?Q?mYXdgzqKmHp5u9ear5vWJDPqwa8817Up6NItqKWKsdbv565imUP1fbXDOmyH?=
 =?us-ascii?Q?IUaxJOCKf0ApGFJHm9dROVHdl/vGPogemckR77XtkxjNbVyazrMYFdLj7VmS?=
 =?us-ascii?Q?1bQSeJVeUznmpzYAT7Y2duUIpoyHoYttOhm+2OQVWRasqy7PrESfxnntJGCY?=
 =?us-ascii?Q?iUCApSRWfNvmdkoaXDa88zoHzpBq9RPexWAepM72RQ8fZwqRUcDIQSzAf1do?=
 =?us-ascii?Q?eKPqkP1grw5Gch2aTaXNN/hODjICUQ7cRszx/k+gX0MWtECJ9j1qm8uia1nX?=
 =?us-ascii?Q?F6YC/6N5pUu9O2fZ2SLhi2I4m7TDsuaplu7H7yDPcBFsjckfEikJqzjYX0/J?=
 =?us-ascii?Q?VY7FxyDuI71cT3D1f51RHsdVOELhcMmRlYc2Kzvflv2xtYb9ACNh5H2X3wpC?=
 =?us-ascii?Q?cBcsoVFaOF46IsbcJSP1w6ywQuDB8xWSmjDym8U8hZa8bs7DXtcFjx1+Hsvl?=
 =?us-ascii?Q?XcSrQfhkVZWZg3lRTMqPBdIAUXmGp+AMPXH3baiuoQ2g+ZnWBlQ5+goo/4z/?=
 =?us-ascii?Q?XshAPPA7NQDBjDMcZGOv8eNNSS2pEjT5R7hBreMc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c30e7f-3f15-4d64-7d36-08dbf798e4b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2023 02:53:44.7185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3mkE5qAU8OAkj0/p0jiLdtqgnhPdMgIKoE3C8Lj9aPlWS6zVBv3iM+8HJMWcHnO7qR0KQBmBO6JfmZa23fPq6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7471
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, December 7, 2023 10:46 PM
>=20
> On Thu, Dec 07, 2023 at 07:55:17AM +0000, Tian, Kevin wrote:
> > > From: Cao, Yahui <yahui.cao@intel.com>
> > > Sent: Tuesday, November 21, 2023 10:51 AM
> > >
> > > +
> > > +		/* Once RX Queue is enabled, network traffic may come in at
> > > any
> > > +		 * time. As a result, RX Queue head needs to be loaded
> > > before
> > > +		 * RX Queue is enabled.
> > > +		 * For simplicity and integration, overwrite RX head just after
> > > +		 * RX ring context is configured.
> > > +		 */
> > > +		if (msg_slot->opcode =3D=3D VIRTCHNL_OP_CONFIG_VSI_QUEUES)
> > > {
> > > +			ret =3D ice_migration_load_rx_head(vf, devstate);
> > > +			if (ret) {
> > > +				dev_err(dev, "VF %d failed to load rx head\n",
> > > +					vf->vf_id);
> > > +				goto out_clear_replay;
> > > +			}
> > > +		}
> > > +
> >
> > Don't we have the same problem here as for TX head restore that the
> > vfio migration protocol doesn't carry a way to tell whether the IOAS
> > associated with the device has been restored then allowing RX DMA
> > at this point might cause device error?
>=20
> Does this trigger a DMA?

looks yes from the comment

>=20
> > @Jason, is it a common gap applying to all devices which include a
> > receiving path from link? How is it handled in mlx migration
> > driver?
>=20
> There should be no DMA until the device is placed in RUNNING. All
> devices may instantly trigger DMA once placed in RUNNING.
>=20
> The VMM must ensure the entire environment is ready to go before
> putting anything in RUNNING, including having setup the IOMMU.
>=20

ah, yes. that is the right behavior.

so if there is no other way to block DMA before RUNNING is reached,
here the RX queue should be left disabled until when transitioning=20
to RUNNING.

Yahui, can you double check?

