Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1B26787F
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 09:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgILHRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 03:17:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:29145 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgILHRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 03:17:47 -0400
IronPort-SDR: 4K/g/9zgcunecPfF9roorm3Hsz9Ddx1W7R9DXfb26jgCPVpIkmFi9TLz1uHv53aREBcQsSoO+1
 w953fiFjgf/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="176958166"
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="176958166"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2020 00:17:35 -0700
IronPort-SDR: 7moUXU4ikPVV/iSIElD21lAlxkVcSICFulFQhL5ZQDNolr5F1y5Qi+ehrxTg3iD+pIaQ7oZbAb
 a3b3qRrYobYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="344852781"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2020 00:17:32 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 12 Sep 2020 00:17:31 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 12 Sep 2020 00:17:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 12 Sep 2020 00:17:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sat, 12 Sep 2020 00:17:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXXTz/Rl0FWRB5wjg6pZWwfKazgQ3o1glRXavyVzwqH2M/eAj8zDLVs61Abdf0ae8Twf2+KbbisIN9HKtw2QX5Por/6CSdl6QgkvucbfwJPhMbB3WfOFy5bgKXOESh+MiAPs1m3DIB9oLo7rZg6/kJIvauuyUOPeC21PeIL0il7FKNImYQR8bjeBZu8a0/PDP8fCKY43WBaM8AZf1bf8WvKFDTgw/kTgsy6PkN1Igd8DWx6n5Db2Hx0fjqckexURz9HgfRzxanZLvk91rDnkVuBTnRg5OrkqrwREgiDR3myFDNDhcF9skrZsbU2RXWj43YZeosNbOmxOKtu6fXrWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWqLgjOgFyRluOPLcTVvzpnCgIObryxpS69QZCI81D8=;
 b=LyP5iJuPVMp15/6TspumVbza5HzK9KyBtU/1HeRjgBK65fyTK8eZCrGnxKY009QvtKVqd337687jjTT+wawMrPIq+1M/wfkrzZKjvX7+iflp3noAJ9DZLzqC98NpXFYz6D546qAOX4uMEksuVdkW6ZKY+8Q1Ue/174AQtnQi0KgaULiPtqaDEO3pHLwOlx7ANG1g4/X9wydl0VGwLfUB0FZm58P8hQGJBEQR5Ph+SZwzZQP2DA79cU7zRwLuITbewdS8IAUGs5HxzlTDS2ZUjvDzwemDJE8jxIahdQpUMl/30LHhca1xtg9J+L9BgqKbgexRba7dfFkECYYKnhbAVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWqLgjOgFyRluOPLcTVvzpnCgIObryxpS69QZCI81D8=;
 b=x4tMLA6YPBfXSNa10HzBZnY+WIi3X25nXvaXx57BdHidIOI+Pf03rLLR3+1/DE89OnfQWkXQSdxHlJaUaJkotz96g3bngF1pr7uUP3nN+6zmBC4B8hj7JGcySCZPUlnttVhNo+GwgOQNBmph3ljzkxH020eb2FS7PWHRc9z/hQk=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1692.namprd11.prod.outlook.com (2603:10b6:3:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Sat, 12 Sep 2020 07:17:28 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54%9]) with mapi id 15.20.3370.017; Sat, 12 Sep 2020
 07:17:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v7 13/16] vfio/pci: Expose PCIe PASID capability to guest
Thread-Topic: [PATCH v7 13/16] vfio/pci: Expose PCIe PASID capability to guest
Thread-Index: AQHWh19BL/4KVSMUYUyyxt1419EQD6lkArqAgACXU1A=
Date:   Sat, 12 Sep 2020 07:17:28 +0000
Message-ID: <DM5PR11MB14355B145856AB30D3F938D6C3250@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-14-git-send-email-yi.l.liu@intel.com>
 <20200911161311.13999a57@w520.home>
In-Reply-To: <20200911161311.13999a57@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [114.244.141.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f3c6d31-f72b-4a3c-d6a7-08d856ebe836
x-ms-traffictypediagnostic: DM5PR11MB1692:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB169250F6FC61197B70603B1BC3250@DM5PR11MB1692.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jymuxbhEyJcBuLP8/qtN9CSdCHNVWk7oIDDbbx94O8WXywtSD43WtYoX1HkGNCJG4jRO7Cyak8UBiNHYLuufV60Ig3PpuXhkivL4ZrSadBnrnjOhcu879zULuSz1VZetmH2dAv/UqTBa4plbOowUAnX0UG05f0Lvlw8zkbc0ai+ejl9bffEMJHGPxJYmz1j+5dl/8N9BRpN9Y//CdUcfYRTVtwtTr9FfYSxmdkOhuhSEB4Ipv0Gk2qjMufMUCxDX8Ch86HKSrOHEIuIsREluzwADGiMkClRc4lzxvevCfPLNUXQL4RHVKqtQl/I7kr1HlnVwP5nCo86MLeche3ncMQr8RkVwV2DaIl9SFIO+m4HVAY0wBCGDURByAm8yRzJv+K1UQjGT8onEGvDanRl3Bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(186003)(7416002)(9686003)(71200400001)(316002)(33656002)(8676002)(55016002)(52536014)(478600001)(26005)(6506007)(54906003)(4326008)(7696005)(6916009)(8936002)(966005)(83380400001)(66446008)(66946007)(66556008)(64756008)(2906002)(66476007)(5660300002)(86362001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: e+YxQHPlJi4Z+F3kWWDMmLcTJQIDgPlUe8yzSal9XnE/uzDsZUWLPkuJsfo39aUs4W5+99gkpTIqTrhO+j+kTg/PuuMvWGRAcTeJ3v3uK9fCf1aT1KO4OIuIjWe/4VxBUUMLqgeDbKRDDOAqqSU1bZJ5JKCfBbYentuNpLQJaRkc5QRPB9g91KdsoJuZy67Tatikii33t5uU9TMKF3DWxbJ2173M71aap5y7JU3CXPM7bUcKaU3sJKu2VsDY1zrYc+oem4dD5AwVyRI3ije4geQqg0i/aImGRzCtCNav+GZS5axkmoZpGJy00pvTt+kpoh8y9uap926Akk9npW7pPKeQVBAn3MvB9DdzZiM084ijplIXKbyaRZ4yVMDTCMB90YyCRjWcAAAG8tamgNbZ/wIVhtX7ZGejYEPpvVjqXaA39tor6+se7eNKWkwmqv8uLyqcy/iUcu06SFbIld3daQp82y7IIcIM1iNV8wG68RVqx67Li81G10CacPtwbpn2pHMKnLZ0lHMxscapnFeyS3NWoSkrCpWxmn3xaYiN1YMRPnCM6gyD3qrRhMzP2PyGydH2e591Xbw9JcuxAmgxjFm7QJtyEZrZrfe7ZFwWSvYNN9Gs2SNnoN+SfS6ChdkROBfC/S2gYFk7tfcWNvGz1g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3c6d31-f72b-4a3c-d6a7-08d856ebe836
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 07:17:28.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KOWfrx0MCRug1LwyFlAj2fY9av8fUgZ7eh05cAkRFami790Ja29s4uJdvBDCpdRy1WITB88WvkP1vzr2kq8iBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1692
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, September 12, 2020 6:13 AM
>=20
> On Thu, 10 Sep 2020 03:45:30 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch exposes PCIe PASID capability to guest for assigned devices.
> > Existing vfio_pci driver hides it from guest by setting the capability
> > length as 0 in pci_ext_cap_length[].
>=20
> This exposes the PASID capability, but it's still read-only, so this larg=
ely just helps
> userspace know where to emulate the capability, right?  Thanks,

oh, yes. This path only makes it visible to userspace. perhaps, I should
refine the commit message and the patch name. right?

Regards,
Yi Liu

> Alex
>=20
> > And this patch only exposes PASID capability for devices which has
> > PCIe PASID extended struture in its configuration space. VFs will not
> > expose the PASID capability as they do not implement the PASID
> > extended structure in their config space. It is a TODO in future.
> > Related discussion can be found in below link:
> >
> > https://lore.kernel.org/kvm/20200407095801.648b1371@w520.home/
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > ---
> > v5 -> v6:
> > *) add review-by from Eric Auger.
> >
> > v1 -> v2:
> > *) added in v2, but it was sent in a separate patchseries before
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c
> > b/drivers/vfio/pci/vfio_pci_config.c
> > index d98843f..07ff2e6 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -95,7 +95,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MA=
X +
> 1] =3D {
> >  	[PCI_EXT_CAP_ID_LTR]	=3D	PCI_EXT_CAP_LTR_SIZEOF,
> >  	[PCI_EXT_CAP_ID_SECPCI]	=3D	0,	/* not yet */
> >  	[PCI_EXT_CAP_ID_PMUX]	=3D	0,	/* not yet */
> > -	[PCI_EXT_CAP_ID_PASID]	=3D	0,	/* not yet */
> > +	[PCI_EXT_CAP_ID_PASID]	=3D	PCI_EXT_CAP_PASID_SIZEOF,
> >  };
> >
> >  /*

