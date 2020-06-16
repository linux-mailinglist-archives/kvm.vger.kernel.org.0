Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3801D1FA674
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 04:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgFPC0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 22:26:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:27552 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFPC0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 22:26:42 -0400
IronPort-SDR: dnIuTTJ7G+ODmFuyf8E9mAIxWANoR0g+/koiE/e4w0fIsKL0IA2i0KfGkw+YBKF+3Ok0PznmDj
 qWbnCJwBr2CA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 19:26:41 -0700
IronPort-SDR: 7M8M7EHr9WDY/o/foIcO5dILHybHLAM6qLNbWhjr8RJ3J9MZqDQeSqkAz2F78bZ9n4dBSOahVi
 8E1psLJ288vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,517,1583222400"; 
   d="scan'208";a="351562597"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga001.jf.intel.com with ESMTP; 15 Jun 2020 19:26:41 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 19:26:40 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX111.amr.corp.intel.com (10.22.240.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 19:26:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 19:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InOccZFOT56mAdmP13vldED6miqstA3mtqJrTcDz662vot4S29rDs2z6VKNTIGaCW5AR/8oZaDHofavzd1BNbaIHeDZFAmLYOWTb4mq11CjJm9rcolR2SSaO74LM0EvYsOXsUZixBNO2eoKVaDVuz0bA4XPFpmK0pOPDkJlF9Pk0/E4ub+hRYt+rVGuVPo31d2mqMblNIX53ab4ed8kcxTR4EgPa4rk6okeqCGwtz2uuwUfB8ZT6xKBT6P6CswE+8DjdCdr4DxgDjGmTp+8tU+ajPuL8hqX/cObptXgmkCvju2UGwN9Mf9EEAtQ6FXTWeIU3ytIIAd/WCsBS2uHVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vESeAyEW/Fs0N2oBG3px1jDvrxLAg5JzJNAFcObB+eA=;
 b=e8UC/0Gff/LEsBA0WPiSDwi3u552sQBazZrzhVqPwrLvpZSgybE8VJnCxnr48FqYetRhztrSknhvX3cT1ExT6nawGNxk7tgSoUoomLjsnhZ7veCy/CW1kM4CPFchBdsODpwsAuXoe05bZb386/jc/njU1lcd0XDw4A2hQPukwxUJOiqgV/0XBECDh2Ca8HEkov6/xlkev/lU1muTVYrCqWwRHEAxXJ1s8YWgY3rSsV7BQzcHhxxYCleOowVLXg1wUUwKgNT1j8MKP1mIoO3Cqt6CP7/ChHKyjoLRHKrMDyiKWs4imadYfn/HVWVYBMgwvEn3otK5qNhpPNcqF/ByJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vESeAyEW/Fs0N2oBG3px1jDvrxLAg5JzJNAFcObB+eA=;
 b=J7knB6UI9QSfTMDwvdWBKPVVUrwGac0HiE3XRRQzFUsvzGzTWPlQ6CTKnI1TSt2uvvtASc3auB5HTnx0H3ceU5WdBdwX0Cc7/n2edK/Pi2s97eWuuuCwaw/tTRu5KRm1WcuvqChzt2OhuW322OCgm3TnM5XvAbdAZkv9sbFpoV8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Tue, 16 Jun
 2020 02:26:38 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 02:26:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Index: AQHWP+kp+vidQ4e11EycqaBDltzgcqjZeEMAgAEQddA=
Date:   Tue, 16 Jun 2020 02:26:38 +0000
Message-ID: <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
In-Reply-To: <20200615100214.GC1491454@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8625d5f4-a2de-4722-b8c3-08d8119cb2da
x-ms-traffictypediagnostic: MWHPR11MB1808:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1808D1376D3C1A87E6AF0BCC8C9D0@MWHPR11MB1808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TzZrP5BhHWiTUv/kuvfGmc+TkLguR9vkAUkSw7wfcLwrbUJ1I1jeNQW4bh+iCt4JodAEZ8lrhD9eeUl5UqPG6hX59eGPOa6MvsYGKXUg3ASHJ9b/KLBsdbDzxxsCH5Jth07ml7Z2fB/AmYUljdShxJMhWNrdh3RJulw4P+8HAwdwfx+Jd9cqG16mdd/G4tX4venKxb0mVV0gCmIfvEVqWYQg2cBUlEhjzbkqbro2d5dhgS1gkFY8hvIHWMkn7EVr6M8uJDLXcyxZ5Zf6HHUrXMHVGDSA4+D9DdyiXopjtfgOAg1aIHqzjEH06t1nvMC2odHvEYjNqAuPmeBA5hVYIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(136003)(376002)(346002)(83380400001)(186003)(6506007)(7696005)(478600001)(26005)(55016002)(66476007)(66556008)(64756008)(6636002)(33656002)(2906002)(9686003)(86362001)(66446008)(76116006)(66946007)(4326008)(110136005)(71200400001)(7416002)(8936002)(316002)(8676002)(54906003)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Tv8Q/e7YumzuHcY6wLreVIWDSPMjP8wnacWK5CqESqDxSQ9WK3EAa00gPQrWl9syuifuckBwDKlEr2eywyjJbfyWcyQY9Zqp+90zdXWOvLVCJ5Rr7UOvZ2naIbG7+7iOkZm1dt2CdrM5mbP181Ebcm98RR+TTW61K50UERUqTF/84d1XSOlNacdRII+PRIH64zFe5KLMBS6BZV+KDQk2OCg4wsIAAskZFdJ/qSDwgdXMvqJkHzAmzI02Ig4+ClAhGDmFn/hYqncwlSGxCXbQOkJS+iZVkdMl+V4cA/Ljq2hMegVlm3/xCbmsj19bhMvnM9/FbwwDpaeQiKev9Do8KT5eyXJFxQ4LNWbRo8XO4VesT25Ml+afkj9f0i4AdyrMz2DrJiz5h39pvJU0DRB5sYnVISHVvgdeHjVRQJnvpYnrXH10UywZmvOm7knOxZcoZEZBJn47T0pZarwfak9NLL49cCaBMNgbD9EFd9xYs2c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8625d5f4-a2de-4722-b8c3-08d8119cb2da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 02:26:38.4444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WKnASd4EsN4s3++oINBGQn8+5vl/0O1Iux34s94C32mEn5+iFG/gq68TL4kp9DVwbTHOCIvj5wz8OgG7g7ejlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 15, 2020 6:02 PM
>=20
> On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> > Intel platforms allows address space sharing between device DMA and
> > applications. SVA can reduce programming complexity and enhance
> security.
> >
> > This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> > guest application address space with passthru devices. This is called
> > vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> > changes. For IOMMU and QEMU changes, they are in separate series (liste=
d
> > in the "Related series").
> >
> > The high-level architecture for SVA virtualization is as below, the key
> > design of vSVA support is to utilize the dual-stage IOMMU translation (
> > also known as IOMMU nesting translation) capability in host IOMMU.
> >
> >
> >     .-------------.  .---------------------------.
> >     |   vIOMMU    |  | Guest process CR3, FL only|
> >     |             |  '---------------------------'
> >     .----------------/
> >     | PASID Entry |--- PASID cache flush -
> >     '-------------'                       |
> >     |             |                       V
> >     |             |                CR3 in GPA
> >     '-------------'
> > Guest
> > ------| Shadow |--------------------------|--------
> >       v        v                          v
> > Host
> >     .-------------.  .----------------------.
> >     |   pIOMMU    |  | Bind FL for GVA-GPA  |
> >     |             |  '----------------------'
> >     .----------------/  |
> >     | PASID Entry |     V (Nested xlate)
> >     '----------------\.------------------------------.
> >     |             |   |SL for GPA-HPA, default domain|
> >     |             |   '------------------------------'
> >     '-------------'
> > Where:
> >  - FL =3D First level/stage one page tables
> >  - SL =3D Second level/stage two page tables
>=20
> Hi,
> Looks like an interesting feature!
>=20
> To check I understand this feature: can applications now pass virtual
> addresses to devices instead of translating to IOVAs?
>=20
> If yes, can guest applications restrict the vSVA address space so the
> device only has access to certain regions?
>=20
> On one hand replacing IOVA translation with virtual addresses simplifies
> the application programming model, but does it give up isolation if the
> device can now access all application memory?
>=20

with SVA each application is allocated with a unique PASID to tag its
virtual address space. The device that claims SVA support must guarantee=20
that one application can only program the device to access its own virtual
address space (i.e. all DMAs triggered by this application are tagged with
the application's PASID, and are translated by IOMMU's PASID-granular
page table). So, isolation is not sacrificed in SVA.

Thanks
Kevin
