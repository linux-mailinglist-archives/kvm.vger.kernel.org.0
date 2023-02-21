Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2269DA46
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 06:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjBUFHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 00:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjBUFHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 00:07:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E711517162
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 21:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676956061; x=1708492061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+8JF4uf+Z4Bl995z7EpwJY9tfkW1pJ3/PzxLBq9/rgM=;
  b=YCkWLGOu8PkushzbAHOVmNX+Yg47Z3S761/EQI6KfbtpQOzWb29zCTZB
   Du28ZoEfUbhuSYufzk4IaB8+SL8cUpppBOrE1EjR+RFuFLQBUSY9q3VOc
   Edjae8ScXOxFobmVxISVOhPWhEfeLEGK/8YdIVj6lQ4dLD0E0Hz+BbVQ9
   3IDhCa3xs50zR11W1EOV1wwCOUI3gteriu8o8QbGlSzfUqZwz84nyGacu
   gBL5D7sB4RPkxH6fLODvZYi9V/1VMV4/m4Gg+9FjpTLvlRn0qicxt4de4
   EvThAXJCUmdhOMPhAS6iKKPVv2m04m+77VoXPmjSrt+U63mlG56t22Hgs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="331211083"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="331211083"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 21:07:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="780859550"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="780859550"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 20 Feb 2023 21:07:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 21:07:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 21:07:39 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 20 Feb 2023 21:07:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN4pgUWB0BksezT5nJRkuGjUsf5r+mOtI91kDRW87a2gD4bvhRu9BjauUr5IwOdjsanoVpJAOrzlWqKl7BLkQW3zPPyAKh2Pc5oibfMIKJF1JWXaLwUfpFMDQSSjgJ5EroakVgjiqY2quURz+YjYBdoBjpdRvaRxCNljfmDgL/8A7OqXUNn/9SWnsB8fPhZkgIUKd8hE+1AO013ckHLNPHm/M7OYHRE6oaFSBY0Cf7fgHzOk+0BDGbmNxyunqIJ3XsW84e7GlFade3+aLSESRtsBdpOMdLNdvEEDyjw5VXex1dpEWQ7S6J9BY2Rq0Igva9vfSr9b3Sd1NW2zMNQ/lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ew41RlcQDRWIl5SsoJ0VbKohyPKVQn2DueCaG6hkoRI=;
 b=cnFfKL4MCz0xaq1CCGmC4eBKwakDno01vtetBs1KdbShXt/PuePiU+kI5DAtivXXl0AcyNwusGF1HctmC+jMsUci83HgJVkHjamRWDj1xR43be11j4J8il38HQ4nlRXBdqhE/RbS9ixmZIDAx/i7Vj5OwTadb6a+DxVfc6+zwxrLr2Z9ra2pF40E0MV+Y4wkVc+hV40ILj4xT21zJpUr/IZZ7CYXpzxFVUZnVYGaVzinJqYbNLVjVEffQVzLaFQHrSsLyCslyjOf/Mb9+g0MBVyTyeB1R7+eL0HF09CCZEIfJXzRKo+z63U/VEwmzRqnMjZJZLYzGYzaG4QhfyZvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 05:07:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 05:07:36 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [PATCH] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Topic: [PATCH] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Index: AQHZRaZijXLqFOf/dEyjHxTuYiCJjK7Y0ZsAgAAFNPA=
Date:   Tue, 21 Feb 2023 05:07:36 +0000
Message-ID: <DS0PR11MB7529D25552603AAE0A557034C3A59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034114.135386-1-yi.l.liu@intel.com>
 <20230220213916.212e03a4.alex.williamson@redhat.com>
In-Reply-To: <20230220213916.212e03a4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6683:EE_
x-ms-office365-filtering-correlation-id: c68cad3e-64bc-4f4e-3b00-08db13c98c44
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9bNH2u33iqyoidBAmIsV2KcRWC5BP3ibKJc94D1hsIywtwO+YT63fTlgk0KiHnBGlNoEIU/JbhnTkNRcDGSNwnB9WDQPwIYpWcyTaAHAZtmjLSVzCAoKE6YqPWmzkVn3+6r+cv04hF+/V4tRQigxHndImq8xMQ6s7zRA4FrpkYiuqFb+murU6zJ+AIk7bDIUIsDxtDYo0PhDU0cfQbVvNurRpLCOT3Ss+BIvuRMaC6QcLhjAGNw2FXTI1JO5BayaJtmebFnk1zieERx/Tr7jY/H+tmq8N/aFGEmgnbTYfPvo5jOd/AytTjei4bdEtCxOA7Y42qEPIxQPCHCL84o26pn9P6F1+cL/lQYHB1b22e83nRSSfJGCQO0aC4Ci0KCvDXB+j/H1D3oo+vyCq+maq5fCM992cYm+VlEPRk1NLKk8JWA8/UvUACXOFfUKgSOBdYKJNEO+w61Ppmk4ECEezwzJRQaz4RBrwbY+7CECxdJid+mBHGYepDQiaE2O0xprUztI1p4ld+j86C+7nSJzKBGQfJLgfvUNPRo5+Dajx9zp+AAClRnuEvibAzEUYx32cH8fWOmtxAl3GjrOBV0XY1eu3LytqogzWzal6HMc1pUxdi9uwoFPoPH8DNR9k+qbJAGAj3kgIP4TtdB/Uqn+yT4sIg6P3IdufiLnsIzxn2zIkLau5DcYx+sB7WKT70RXwc7RrsEHeV2BqucuqCurtzY42SCuNYdGz9/c+hJmsec=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199018)(122000001)(82960400001)(38100700002)(86362001)(316002)(54906003)(66556008)(8936002)(64756008)(6916009)(4326008)(5660300002)(8676002)(7696005)(55016003)(7416002)(478600001)(71200400001)(38070700005)(33656002)(66946007)(41300700001)(76116006)(52536014)(66476007)(66446008)(6506007)(186003)(9686003)(2906002)(26005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QDuUjRo3aBhstFYqmjYotoIRBE3HHQ5skWbiG/7XyvoUjdpYr2ulNSA3j2pD?=
 =?us-ascii?Q?OoIouQ+cNZkmEfwTIt72CvSgz3Xf5pz1fy0twlbVB5DDY2ZH/o+O8Vygx7bd?=
 =?us-ascii?Q?iUlulSDI8Q1CKh3vEbAXic47SEnxCbX2ReQwCaoinF3nCm+H++HzkIGVfRyu?=
 =?us-ascii?Q?HT1KIvQCWLrc3u5T0WYiMaRKvJUdeKexvpn5dKGTHyd3boLv8DOhNwN6xrnQ?=
 =?us-ascii?Q?Zdogvw1NYhZQ0FLbnEfQ/ZhMfpxR7WvpAyy29sSgB3jGNGwwkf9ZEdSi2VbK?=
 =?us-ascii?Q?7g3dUINx3Fr78D4q7BlHx117hI90ToCqdc85o4n24aYF0AwtQrYkF7roU7YO?=
 =?us-ascii?Q?9QEyVmv/ptV+S4DxxoZUkV9ZeQxWKSEFKBNAL+J+lLkvYYEHCAFme9tkcVVT?=
 =?us-ascii?Q?qMFgd2j46d0//7IEl6RD/rwQk/fI1553SWbK83O72jIi1DtWnHIZmyw/PgjW?=
 =?us-ascii?Q?4MKYlVU2c6R7y2hgnq/CAbdMAu0P/1LhbvbUMQdPSguZ0Bs8hIrw+/AaIcMW?=
 =?us-ascii?Q?np//d983ZqW8SmhZUCIt+cfkJ4kEIHIwlGWauSsaGEOa4830Ee7npZctZta6?=
 =?us-ascii?Q?afCmgNWfTl/A+6Z7HMGUTo3Xr3sVmu3kPc//18zTmY7Ok0z0f8Qc/C0bNbip?=
 =?us-ascii?Q?UBD4s+9vgvTm6dLFIH0Bzvg1qf+JyOxyG3iPItf3u9K5IPdwV61LE5CVt8QP?=
 =?us-ascii?Q?/N89KNZ8n1VkjA/CWA7UUqeTrIf2SJOLnaqht9cQvWPFRpoq99chkF4ATO2X?=
 =?us-ascii?Q?ituFo8QMkjPmH2wITr25RzQKMkgCptS9nEtlSvsLkeLIxG4vDQ83M3s69ou+?=
 =?us-ascii?Q?idwBitWgtsFvtRz1GtP1vYQbwdW8t83lQQBYWHSOtFgjxBHEe1EUHmy7Vj9R?=
 =?us-ascii?Q?fPwF4i9avymIkQ3DF8Qi8bldJvbmKh7PcSW9Fs+9/3VumYJpPZbv9QH47vwp?=
 =?us-ascii?Q?DcyeHq8qAl2nxXYrOaXoaQ4KHNMBeloZiFiTLy27kHJJbArcM7j/1jvRX8ph?=
 =?us-ascii?Q?+IreLbmwFv3B1j5f7XWXNMrgBg+lUuS2hjtPAh6Yj7R1ulEYSfYcPadfXOTP?=
 =?us-ascii?Q?WYb+7nAWaFBeIDsPUpk6Ru6llqrotIYp5hW8LHpQdG3EiHvXhF4DQ4c0JDqj?=
 =?us-ascii?Q?+H2OjlZ5SDUhxamxz2LxB5CSsmRypzAcFVZeqj7kmTtIO1xuaSlEMgnFnWyW?=
 =?us-ascii?Q?JnkamGNajAjI0muGImsDl91tIfIgtfmZQAFOVE5f8woKqku+N7HRMfMPcm10?=
 =?us-ascii?Q?qCRuSmSuwiNanBabfYifjx5xBF/RCOj+zieuzg3Kyx016HFLa1l8wEZpGCRZ?=
 =?us-ascii?Q?U0EuuE5SD4Y11o+hkQUQffFUZFNdqeVo/JNeQ4TmgmMzm/70U9MVk/Ixuv4Q?=
 =?us-ascii?Q?IEi2amSSWwfu1MxfhWfs3ZO/Du9cUwOoMGXawIbxzalAQ0bGQBtDH3+MB/Xi?=
 =?us-ascii?Q?dEWbzg60cCeTiDcb5MplDo1TrpihVKXdEsmJ5TXGL0PSQwiPI9KyJOwdu69g?=
 =?us-ascii?Q?7E7+Ywaxi6j32qbgYQpw1VHZUE6QTVw8L8PCVXYKioeApaHVLkbCyTBPbCyU?=
 =?us-ascii?Q?hzrZBRhO0fo1bGUzAyP1q1hsqFeFXgSP8fIh6W8R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68cad3e-64bc-4f4e-3b00-08db13c98c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 05:07:36.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y2WqVYuLxTILUeGXY0+fBvcHE7LdnJFPZjnPQ8jy7NHin2gHHZBQzgGC21FFwGSAE/umwyhTe9rq98jEvFE5FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, February 21, 2023 12:39 PM
>=20
> On Mon, 20 Feb 2023 19:41:14 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > as some vfio_device's open_device op requires kvm pointer and kvm
> pointer
> > set is part of GROUP_ADD.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  Documentation/virt/kvm/devices/vfio.rst | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/devices/vfio.rst
> b/Documentation/virt/kvm/devices/vfio.rst
> > index 2d20dc561069..5722e283f1b5 100644
> > --- a/Documentation/virt/kvm/devices/vfio.rst
> > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > @@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
> >  	- @groupfd is a file descriptor for a VFIO group;
> >  	- @tablefd is a file descriptor for a TCE table allocated via
> >  	  KVM_CREATE_SPAPR_TCE.
> > +
> > +::
> > +
> > +The GROUP_ADD operation above should be invoked before
> vfio_device's
> > +open_device op which is called in the ioctl
> VFIO_GROUP_GET_DEVICE_FD.
>=20
> Why only include the reasoning in the commit log and not the docs?

Oops, sure. How about below?

KVM_DEV_VFIO_GROUP_ADD has a duty to set the kvm pointer to VFIO as some
vfio_devices require kvm pointer to open_device. Like gvt-g, vfio-ap and et=
c.
Meanwhile, open_device is part of VFIO_GROUP_GET_DEVICE_FD. Hence user shou=
ld
invoke KVM_DEV_VFIO_GROUP_ADD before VFIO_GROUP_GET_DEVICE_FD.

Regards,
Yi Liu

