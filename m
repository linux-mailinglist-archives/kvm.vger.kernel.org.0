Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D92433E38D
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 01:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhCQA5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 20:57:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:13365 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhCQA43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:29 -0400
IronPort-SDR: LAKhnmOZePPsc/6sQeA/5TdyUsRSFrOhpvdp8m1fVVK12N5goIbWrGWeoCWNUV9wH2B0nWI2a7
 fguAyvfBUTpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="188720896"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="188720896"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 17:56:28 -0700
IronPort-SDR: 3p6WURlod2+REnNV+MSw+uSTve4aHx4oZ+hLCqLLG8nowFN8efJTuKHHcljDKnlYZ9UaMCImQX
 ZzMPTApUBdVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="388649435"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2021 17:56:28 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 17:56:27 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 17:56:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 17:56:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 17:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyEvsikjQBMEsxTW9lUXoEB8uQbrs/+0NgWDrFUlxt3etbc63QDJlzPRhe7WRnS8Vm0eIvlc1WYTd+Ls37tmdPE+UZ8WxFQHMVU2vol2KMw9rgiVpC8/UG3Wj8UwskvcGcH/FtrcF6NvLJ4vgCKSQZO5u7NY+tX6hLbf4DMhQEiCGqcr94q+ned8sEF3An0YQQyLJN8iJ1WO+xKvc7WtfYZrPeyFAQQCeM6mS0THF2mYo0xhm/spq20mQUcc56Egh0jgKlhsF8VHd40k4KU1hG0M6AJye7N7vIlmdW2xvzwNBP9JGSIqiNamQ7gh1oeOOT8Xb3fXA+Vq4cCB9xcmkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTUYqUVmkGXiSSR7BzxU+efZ5avZlXGc4+8vKW/7H/8=;
 b=ef8i6nX0lBUWH1MdsnQYUMIsuB7VGOFR4KTsrFNffVsy4ij/w6UtuqgUDz4k2A/3TPb0gf6zC/eBD0HnbBMbJlmVChfXxvB/xEJOYaKuzopJSSFODFUOhXXpYEMUtyj+x9q4GMKxuMIkSHViAps2BeJsaSwAP75FtICacXpUbidZx7VoD8TW1bAY6Bezu85PIHgvm0QTZ747pC+lTTeUj43l3tS3pUIz6v04R5mv4k0me8LB2nOrfQNhp/0gj2jmOCBVn8Htk26+yz1K4O+Adgwb2BmiG4IsnmhaPk7ZSsnRhDlG6mcJgjXo2es5eQXrcu821ewa0JfXJ73L5Ag4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTUYqUVmkGXiSSR7BzxU+efZ5avZlXGc4+8vKW/7H/8=;
 b=R7rvjl4wAIm8Dtx+TVg3xSLTYD2R4yIgdeys/HcbbI//ChGR3gSNvz78jkXPNnLp/QzewMslkmodfa1Uw50o09c64AMgxkPjwwoL40lleztcAaxdduwTaDQ1+N88tdxzl0WDwdieek/0lX7Nn/IAT3aSyXdoxTlRlhB6kZadAOI=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4652.namprd11.prod.outlook.com (2603:10b6:303:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 00:56:23 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.033; Wed, 17 Mar 2021
 00:56:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Thread-Topic: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Thread-Index: AQHXF6OyKRGb0hKB6UOc45JJMJQlBKqGRKjQgABadwCAAJifgIAAKWzA
Date:   Wed, 17 Mar 2021 00:56:23 +0000
Message-ID: <MWHPR11MB18860061F19705D310D5E8D98C6A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <MWHPR11MB1886D4C304FD9C599FD7A8848C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210316132058.GK2356281@nvidia.com>
 <20210316162713.6dff86bf@omen.home.shazbot.org>
In-Reply-To: <20210316162713.6dff86bf@omen.home.shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 823c1952-f532-48c5-a8ca-08d8e8df7c39
x-ms-traffictypediagnostic: MW3PR11MB4652:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46528B8D9E3A2AEB101286FE8C6A9@MW3PR11MB4652.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pwJbEKyfmKZT24imYiUYRidzfs/avssIzt4N3nM+vbg6dXW5ZO2BlL/ti/O0DMpEg6MV0Y5Qe1gxboikuSp/WJDWaywe1UcxIPdds9PT5s5nHeJ65z+blsHF+6DUuxHj7pWHYaGbz/i3YMCinmAoDJ+KYtdZwJHUIn8vgIX2qElEM/YH7m9jSkXIsD/vGAjm6IzLuQOw/LS4IyWPlYhms6o8k/IL808RY1RC/4d3+GshfXnXBshOusjCDc83zFDEl79pwP80pXCDMoZAEKZkUPeuSJ4vs8lC3U2kUJW1q2v4Wltpjx+C59389T/CR4qarMwXTZba15MKL+ZwpjdnAc3V1MsGXMLs44wvrq4QzAGIzBMfNwOYDL2n2le3y425EA9NrzsN6WfQdYwL6p/DTgv04vrwHu+OB6d1cniFOAtAGduAodnXJ1bLrtDzjmfs11QtPdocq/fIxwmQOF7/qwhE+Nf+ODC6bP1Yml/pq5O8mDDpmPGXgU0ILjqzgavByp7IFB9Y3RRaNBaejhO8ZobehToOLivw1AehLqUm7HV3g/EbxI2FNR2mM7JHV3TF5ptRFhqIr3ikJFyFWsEQFGNvmVwdS39m+z5bY1No1WI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(66556008)(7416002)(76116006)(66446008)(7696005)(55016002)(83380400001)(26005)(66476007)(9686003)(33656002)(71200400001)(64756008)(4326008)(110136005)(6506007)(8676002)(316002)(5660300002)(478600001)(86362001)(2906002)(186003)(66946007)(8936002)(52536014)(54906003)(169823001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5ItedA4temlI5bc0P50go5u5mKTnbm0JZUMdQfRgamvW/fEzkzaeda34mWB9?=
 =?us-ascii?Q?89/+TVw+otDijJPAdtNkLJ0vEjGuzps0VuZ+mjAOkSDK2Mk3y4pxcp/u8LK+?=
 =?us-ascii?Q?oi8IGK1xidYuRKS94nUX2IHTQvcT4q7jKRN1rWj5c22ZyA+r+tz0LviITkvt?=
 =?us-ascii?Q?3lDpLGvJnsmB6UVOXrNVWO/2atJH+FP26tgRXxWU8TUnGcR9iQunOWo3zkno?=
 =?us-ascii?Q?qG2/05xjHV8qs9dXOYqzRgzuTPgsWw6q4Sss7QWPzdDjZDBxh/cjjgcR40/A?=
 =?us-ascii?Q?Xij8odlTJELwHWqPmtvKp3NQyNXJkiB/2rx70PXSTjdnyzHPa10KufC2z1Vr?=
 =?us-ascii?Q?ZZ8BfdKXRGtd7ax25V77OjtbDzmJhcUef14fvQ4AppfjqgZibUSNW2FHt2l4?=
 =?us-ascii?Q?SKWwF36GIrVJyaKyXty/yHMLWN4PUiyRNxXm39RcZGuZgUsgBcInMIdHeuPw?=
 =?us-ascii?Q?DbnNhpE1BkGreBoj51kpVUkMWAMXCa2snoOff56U9i3F4m6Y+c7MadzoPpqo?=
 =?us-ascii?Q?BizQ3ojox5OewrQ5kftyf91vYlrH6jdTGw+Z8w4chm+HZgN5SuuQWv4ImXI3?=
 =?us-ascii?Q?C3i7xye4qWwIGKLYZ737oa25Jz6ywwEC2DWM6DuOgmTzxDhxZI+TsjF0UET9?=
 =?us-ascii?Q?EFSJ7QHb6i3VRcK8B2uHfrVVJ/D+a2kqHrpPCfVZZF00ZlwuCNoJde+WlY7e?=
 =?us-ascii?Q?IHE2srC3/m417p5rVD+rawfQJJGaxHADHA6y0yV/57RFf/DkBjIN1oYNew7g?=
 =?us-ascii?Q?T+sP83UkSvxB1ON0ZIJtrsscm9rU9pKfUKht8M3xwaPyTnyiLdinJ1cne0AU?=
 =?us-ascii?Q?irVVIqBhvqM3Ea633XWxOF3w80nZWT57nYnpQKv2wdnSXulMuTldap7xvgX6?=
 =?us-ascii?Q?E6GcIEy1QnVTotU/TUyaUQqq5MkPJKF66QhP6uoKT7rKG4G+1zoMEnIpVimA?=
 =?us-ascii?Q?GeOjwmXHN/KPrJvPZvyKN7BMIIyOLWVaiCJgVqVATfmCuG5VBnpNVq2C4qwq?=
 =?us-ascii?Q?M7oSjI+RgNTgOYsJ4heRGCg0HGCnhZB7NG5JnVg0xlHWLPqp7CPt86iBPS7G?=
 =?us-ascii?Q?YVjaTzzW9zmhcrlbjemaOjA8hRTt2+fUpN8TTPO0B5h230jo9H/8PRUwSpq0?=
 =?us-ascii?Q?ZcgOMq0ls+HZ8uhg5Eyl9ya8ooy2W2Ti6EJlNIHThpfb34DHojAbcOOIuPem?=
 =?us-ascii?Q?UuFCnwTnKgKtjpuTqFFytgalXSPBYw9P+XsFU/2kBVrF8jA5TYp+bGspeR0Q?=
 =?us-ascii?Q?mS9geMRAGzdfIUIOwASIQ4SbALfbBRsSlQPuWROXk660RktIiNnJPO+4VcH7?=
 =?us-ascii?Q?1IlME5dYlEkV7n4f1V3id8mY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823c1952-f532-48c5-a8ca-08d8e8df7c39
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 00:56:23.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XJDvXIAXibQkipKSyYkeBgJaB2AOaZSAcvUD8aZvz6aWO0ln9jASoNp846mWIQV5aYubohcpvMVN/QMXxUDhVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4652
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 17, 2021 6:27 AM
>=20
> On Tue, 16 Mar 2021 10:20:58 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Tue, Mar 16, 2021 at 08:04:55AM +0000, Tian, Kevin wrote:
> > > > @@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev
> *pdev,
> > > > const struct pci_device_id *id)
> > > >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> > > >  	}
> > > >
> > > > -	return ret;
> > > > +	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> > > > +	if (ret)
> > > > +		goto out_power;
> > > > +	return 0;
> > > >
> > > > +out_power:
> > > > +	if (!disable_idle_d3)
> > > > +		vfio_pci_set_power_state(vdev, PCI_D0);
> > >
> > > Just curious whether the power state must be recovered upon failure
> here.
> > > From the comment several lines above, the power state is set to an
> unknown
> > > state before doing D3 transaction. From this point it looks fine if l=
eaving
> the
> > > device in D3 since there is no expected state to be recovered?
> >
> > I don't know, this is what the remove function does, so I can't see a
> > reason why remove should do it but not here.
>=20
> I'm not sure it matters in either case, we're just trying to be most
> similar to expected driver behavior.  pci_enable_device() puts the
> device in D0 but pci_disable_device() doesn't touch the power state, so
> the device would typically be released from a PCI driver in D0 afaict.
> Thanks,
>=20

OK. Then,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
