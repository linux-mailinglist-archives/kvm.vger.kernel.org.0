Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC22293E49
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407907AbgJTOJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 10:09:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:18334 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407836AbgJTOJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 10:09:53 -0400
IronPort-SDR: kVQlPddun9BcOtJzhZodWb87xeHNn3OV7OcK9XdhW8mtpE1/fXhJ/TJpEeN845rDtTNjXZ//2w
 0uYBlCgjxgsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="231406755"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="231406755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 07:09:50 -0700
IronPort-SDR: MgaLEcgWtTC1aVz+NpFKV8fBZKasL152L8Y3ziDWiHyMwqRq0XCZj1Du9P3RTYHMoVUemSYnoU
 HBMInbHcybIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="358534923"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2020 07:09:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 07:09:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 07:09:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 07:09:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDZ+lnf6Eo1TXjjmNBgluVbXBROPM+IJU4tH8YNRq20RBxOvK8aEqTSN55T3UijLK6LX1DF4gsEehvnQyuzT9ju5MEjE2OmwzhDXtl19G3HRj3Xr+GVskYcu18HE9a3NtJkllrHbQuTB+OpFPCMx0q9cnhKV0ph6wc2yqWhxOPMGLXWRNR41I2eSyeAwUTvTHSdlfBBa27WG7pLc2hTaPjSQjI0idcjRDzr12oAWx7RpFFBAgSDbqySekIOiunIouCupwIFIjylHj8uUk56nZ5LNnSdcOTH/ypPxO2mMNDeGly13p3rhrxOM281G3EuH1pwdrntfBQYImSgwF4kdPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRkPx9xPfn3WA5INqB8JJrU67w2vpuDki0WUye5L7bs=;
 b=haNgcIarDx1zTTd7zepZqFpQG2uamdURwZSTgA+VpHoM+9PzGYtDAWPQkwiwYT3r4A58ReE2EYqy6BUn3xodMGFAjA5K2NyrCcr3N78XWikuvvdGQs4m4LmwXUePmIotcvvoSPz4n9aAQkE4N49t7MCl5oge32C0mNexwqmlr31cKvUKUs5bf9ZUVCtE/HnWk7f6XvzjULJugxFaHxH8PFDOth4qDeRGSUIRBFKa9JBS0K0aiOLwM27MkbkomS/yA7IbasY0CzQtiQVLFo3kdd4RLO/QnpgVEGr+JlLv5zfj7GycIl/TpevAlg2S0AKH/DsIhknFfjdo0mKiDupa5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRkPx9xPfn3WA5INqB8JJrU67w2vpuDki0WUye5L7bs=;
 b=c7dAx5gE9Prg+/vHc6hdawYQmanYmHltKYUo47WMCmdU+Pd3TLJDNcB+MUA2rDZ3FEC4QYKg6cReY6iuOixZxyT7lwmWbwQqIblbeaY0QbVH9vh33gz5AF4BpOvWZVA7GIwHaMjrEJJbOkXLablDauZCeDKY5txt8nuBfP9i+RA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3865.namprd11.prod.outlook.com (2603:10b6:5:19d::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.24; Tue, 20 Oct 2020 14:09:44 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3477.028; Tue, 20 Oct
 2020 14:09:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUAAt0sKAACmGxcAAPBsbAAAARpcAAAOFkAAAAwCSQADzeAMAAANpJxAAAu+FgAAAOEXwAAlgCoAAABHqwAAASzgAAAATKiA=
Date:   Tue, 20 Oct 2020 14:09:44 +0000
Message-ID: <DM5PR11MB1435D4CBA2817FA2C5F92539C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <9c10b681-dd7e-2e66-d501-7fcc3ff1207a@redhat.com>
 <MWHPR11MB164501E77BDB0D5AABA8487F8C020@MWHPR11MB1645.namprd11.prod.outlook.com>
 <21a66a96-4263-7df2-3bec-320e6f38a9de@redhat.com>
 <DM5PR11MB143531293E4D65028801FDA1C3020@DM5PR11MB1435.namprd11.prod.outlook.com>
 <a43d47f5-320b-ef60-e2be-a797942ea9f2@redhat.com>
 <DM5PR11MB1435D55CAE858CC8EC2AFA47C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6e478a9e-2051-c0cd-b6fd-624ff5ef0f53@redhat.com>
 <DM5PR11MB143545475500159AD958F006C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020135439.GH6219@nvidia.com>
 <DM5PR11MB143591B85490D675F0628890C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140504.GJ6219@nvidia.com>
In-Reply-To: <20201020140504.GJ6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [221.220.190.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1cd4281-6433-40ef-a2f6-08d87501cb99
x-ms-traffictypediagnostic: DM6PR11MB3865:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB38652329C974564D891FB8FBC31F0@DM6PR11MB3865.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5qbM8Rj5I/muQa3I6kUjt4nLxaxrWpZK/pSrEIxI83v2taX/mV/P+hwtMy4FWJaj1LQrFcfIOippBWl8jmD2to73shcSSnvGOPQAlYYLP4prg+ITv25yeICannsrIPhUC7WA+F9dbAxZkzn7Ew3DGaK2EwfnL+caanotFjbbuC/wJo4bO3vfT9zKTF9i8/JnHKKG47NLEbCOmKFJewHRonzD/AvkKN2hD+sURhtFf9OzoA4pn7QUvqoF7RIGsQy8g+vFTTu6YmZwRGeAY0xuQ6p20J0Ljn+RqAcH+0rntJoVxodFh8aSxcDzNGOBBMKG3sGuAhv0bDqGJs92KOrvFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(186003)(478600001)(8676002)(7696005)(9686003)(4326008)(6916009)(8936002)(26005)(33656002)(6506007)(66946007)(7416002)(86362001)(66556008)(2906002)(5660300002)(66476007)(66446008)(71200400001)(52536014)(64756008)(55016002)(316002)(53546011)(54906003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9Q7lWV47h8Xmt+0WUxP9diLxsPEuXBdq8ypivwCR27HuIOq8rqrrqP8hi5HwJq5wkgy7VOvfg3rSDCaghPzpUiNF9BXMyQr59gOCPyjxW/5MceW75vumdWxWXIxEjTLAyI6QVCoc0MA1vBmYhtTx2bCFxq95GEU1ypFFHPg59DMMZaOZ48WttNxaVV0OUR8H1qe/SUUe3+twuJlb/7Rq3z/kFW0wjRfkbEf+n/tnPnOlgImP86F6oSd+6p3tK7D4St8IqMJETKq5McxeOAykD0c1v3okVduSufRdF70DYj7Q0l9IJx+jscoagn9noyzGWKfi4p7xX0scrsCOsq/scNuujnruj1JdCrYzFxbVon5ZtxMhRd6JTIc8VeMyzPScf/5DW3eldrFdqRtldHoR0JJggo5rDGlFX0gIiQndH61RZ7FC5HmBhcrIyC9vc+XHvKtOD5kZQmkf1WEsOHG8b3ecqTzCJRAXo9NdS6908lZlR2+x/9THOLfuQoSst//yn2ED55eVV49eu/6Mu3IlQRPc6AYRp283ZViUl1IseltifMsBrSIjYNQ2ZyezaMkCZFaF4jpVwQc14/MlWxTaq6XOa3b3/p8ZKtYO9738MZTkadq3riezSdB+LXB2n+0mg+/j+hAyK6jiVLXvZhYBKQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1cd4281-6433-40ef-a2f6-08d87501cb99
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 14:09:44.2886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DSuTEzRHh1gUorWvx0w4JxB5sy8jDolPEy2XIgswC9pzVOyFd4Y9Oiq/FDjdede2KOi88HQMRwZB5qmH2BSUNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3865
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 20, 2020 10:05 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
>=20
> On Tue, Oct 20, 2020 at 02:00:31PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, October 20, 2020 9:55 PM
> > >
> > > On Tue, Oct 20, 2020 at 09:40:14AM +0000, Liu, Yi L wrote:
> > >
> > > > > See previous discussion with Kevin. If I understand correctly,
> > > > > you expect a
> > > shared
> > > > > L2 table if vDPA and VFIO device are using the same PASID.
> > > >
> > > > L2 table sharing is not mandatory. The mapping is the same, but no
> > > > need to assume L2 tables are shared. Especially for VFIO/vDPA
> > > > devices. Even within a passthru framework, like VFIO, if the
> > > > attributes of backend IOMMU are not the same, the L2 page table are=
 not
> shared, but the mapping is the same.
> > >
> > > I think not being able to share the PASID shows exactly why this
> > > VFIO centric approach is bad.
> >
> > no, I didn't say PASID is not sharable. My point is sharing L2 page
> > table is not mandatory.
>=20
> IMHO a PASID should be 1:1 with a page table, what does it even mean to s=
hare
> a PASID but have different page tables?

PASID is actually 1:1 with an address space. Not really needs to be 1:1 wit=
h
page table. :-)

Regards,
Yi Liu

> Jason
