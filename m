Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93798245AB8
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 04:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgHQCYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 22:24:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:26007 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgHQCYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 22:24:32 -0400
IronPort-SDR: Afu1rlUpY99etL0/MuOVl9GWxzsHd4k7cPE/Veii2km91fQeU4SqHaZAJypA3VYdGcKo5Co85v
 tyGfXIhijZyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="153876489"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="153876489"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 19:24:31 -0700
IronPort-SDR: 2ZM+ec8OF35mYLPByaotEQdRGWCV+gohOMq3p30JorY9pdU2qO4rK+nCJduwYQOlNZC+azjnAM
 WSWo40l62oQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="309959101"
Received: from unknown (HELO fmsmsx606.amr.corp.intel.com) ([10.18.84.216])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2020 19:24:31 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 16 Aug 2020 19:24:30 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 16 Aug 2020 19:24:30 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 16 Aug 2020 19:24:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sun, 16 Aug 2020 19:24:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+TOk+weUYPhja2mMK1seMPDcb+W8ppkj/6tiqCTMMZ4cv9f4tW+KWVCWuK+kBR0NyCmTGQqDMEoUmirAhkldV+zQ3Sq+cM3qFtRP/t0/j8YLn15X/aQg8wHPAWu4ryboluPk9RXfyY+rGVQHJRCSxj5Z23/ZDctegS7sJ1k7iCZv3Z+0jRhAAZl4jOrwZ4P300Dg0GHqUY98gQpW/6Lca6J/gXrC6bu/tstcfnE4zR8Edy1bmQ8KtdtJFMjsbtNx6xsOT4WGjXgOLViabKPYrmXsG/cXcWSoPCxhWhDfF3G5hC4+cq2/DcPQRLSwY/QRLltAY08htjzN1oKYVBUEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oj0UVxCWsDji6NxQs4koyOLFyXPWPCpQqbVATheON0Y=;
 b=AP1+l8Hyr7hCuiT3XoswFpfbuARqppK8x3X4euRLMMU4fUtJ3YzDBipLHt4pLQxZE3lFF7qZr4jw2aB+AiSUbjTdgdnmUAjGd/bRJM9JTFgC/r/k9qIzcPSGb/rFoPKr1fkjpW9fup2+6gmp2B43eN/6ldFjuU7xqR1WtMF1RzIg+eYXG4V2A9/X+9NRhjXmutd8evNHirY8t36xV2fQ0b4GThKWMNTOGeHQ0GJDuMkgP9ezd3SwdbQVFQqmzVFZ/8B+U1asdbq8xl750s7TBIX/26ldEIQIqathpemRTUSnNOvydrfKvLkLDhteqxOHzx488A3pKcmWthHOusWwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oj0UVxCWsDji6NxQs4koyOLFyXPWPCpQqbVATheON0Y=;
 b=s3RpnuwzTMTSnuVg0JdXxoZkkwy01pToSon2J2CnTKPzPzhIa0oAUA/GBsOjn2SchuZt6/V2UHuECA0QJdmBM6/yCK5LJ/DnwXskznuK6jQLPCfS1FFcuwRy5Rusmj94htzFN1n2wHS1NQLKvmJwMFUhkQ+uDtWSEnxONJMBOEs=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Mon, 17 Aug
 2020 02:24:29 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 02:24:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jason Wang <jasowang@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIADE1sAgAACHkCAAaKQAIAACXXAgAAPKACAAg3MAIAD/AHg
Date:   Mon, 17 Aug 2020 02:24:28 +0000
Message-ID: <MWHPR11MB1645EF668732BFA7A1219CC58C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
 <MWHPR11MB1645DDC2C87D533B2A09A2D58C420@MWHPR11MB1645.namprd11.prod.outlook.com>
 <ecc76dfb-7047-c1ab-e244-d73f05688f20@redhat.com>
 <MWHPR11MB1645F911EFB993C9067B58DD8C430@MWHPR11MB1645.namprd11.prod.outlook.com>
 <e3f45862-c3a5-8bac-e04d-7be0e76908a9@redhat.com>
 <20200814132352.GD1152540@nvidia.com>
In-Reply-To: <20200814132352.GD1152540@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c05c217-c36a-402a-350f-08d84254ab2e
x-ms-traffictypediagnostic: MWHPR11MB1392:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1392DFC6BB5A4411941D04168C5F0@MWHPR11MB1392.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tsuzdat/YNUhBorwXeUkBGJDFiD5iIjl7P3btPQWsLJt9gkSmaEW725n9Vo3IZhalgWgzEgv+xA6/4ZyoNP7AgjWS5H/DXl/298ZOn0svaR/+6x6h3S6flhFJnyTWKsSdKP9kByEoiguZYv0vQsSD1HmamvGyB5J7f9VYJUej0GOhz0cVlG5qYv/f/YQ8uYbJhlqvq8QObJdEbbW6E+CKtPIV5Fq4QQ8uxV48kqjgiBmI4aAK1BA8X9Zbzas3XD5rvZ6SUje6rww4xPrE6dhJABMUUorGVFD5pBhLgLRM0hRGpKcYDNkiR08IfegZGALTFYCOWnUwi2wX1wrSMR/kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(66446008)(64756008)(55016002)(26005)(66556008)(8936002)(4744005)(4326008)(66476007)(478600001)(7696005)(86362001)(9686003)(7416002)(76116006)(5660300002)(316002)(110136005)(54906003)(66946007)(33656002)(186003)(2906002)(8676002)(71200400001)(6506007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L9CTMIRLPXqIUJMIIi9t0l+v640egj4pFh+5w5lcnAgBoalBVV/i5gFNHmc6MV/2o2ldgNV2xuvsGMZrKMl3gKjg6YHJNS0XDtTCrl75CM8RzGDoDDAkuTIO+92C8OU/h3yZkUiEjdZ5TI3Gb4xvb3V8qJVLr8ex9sY0KmfhQXkK6bHUXiM5r61hxOeN9KeEDZv17MsCr04HCn2iCHZUDljWfYMo60Lmog8fNOdIug+tHyZGY3tVDuVPBHLmfehg+J8IQFIMtg40UaYqEvYvCfghYmljSLqb1w2duKUG116+RJt5U6XhxXo0vf0B2wOStw76huC0K29MSIMcCjd+AFdD6YueERjbobWRl4CXphJD3SX6y78pMYxm5LquO40HFPsMB2htMC43ng2fOPe8GFs2RwmMlgrg93LMjuZ5DSAf316CpXlQec8hM8f5Zl0UbHNOLGYt8ALzgM8mCc7RkcOEH6m/Qa/tmSjxfaDb4wkxGMjWN4PDBRRP7s+p3qhiiL1kjJ1FfJod1juWGjT6aIePt84rV+XpKVUai4/oGSUQRfCM+hE4AiuKXXmtyC//qoeA9cpUZ9Q80zuhOtWIfG+F9JrMgx5zZ/Voz+PgzephUplHxVtORstrTCBDE3eOtVU5/TI5hvHAX4sF7PcsBg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c05c217-c36a-402a-350f-08d84254ab2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 02:24:28.7444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WzZrlkcny0EtTPXFXAhunR3GiF1n5kgG7ERm9KHTdu83SHscdnLzddwp49QglqqqiS0GtwEVy5dgnweRlZ53fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1392
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEF1Z3VzdCAxNCwgMjAyMCA5OjI0IFBNDQo+IA0KPiBUaGUgc2FtZSBiYXNpYyBhcmd1bWVudCBn
b2VzIGZvciBhbGwgdGhlIHBvaW50cyAtIHRoZSBpc3N1ZSBpcyByZWFsbHkNCj4gdGhlIG9ubHkg
dUFQSSB3ZSBoYXZlIGZvciB0aGlzIHN0dWZmIGlzIHVuZGVyIFZGSU8sIGFuZCB0aGUgYmV0dGVy
DQo+IHNvbHV0aW9uIGlzIHRvIGRpc2FncmVnYXRlIHRoYXQgdUFQSSwgbm90IHRvIHRyeSBhbmQg
bWFrZSBldmVyeXRoaW5nDQo+IHByZXRlbmQgdG8gYmUgYSBWRklPIGRldmljZS4NCj4gDQoNCk5v
Ym9keSBpcyBwcm9wb3NpbmcgdG8gbWFrZSBldmVyeXRoaW5nIFZGSU8uIHRoZXJlIG11c3QgYmUg
c29tZQ0KY3JpdGVyaWEgd2hpY2ggY2FuIGJlIGJyYWluc3Rvcm1lZCBpbiBMUEMuIEJ1dCB0aGUg
b3Bwb3NpdGUgYWxzbyBob2xkcyAtIA0KdGhlIGZhY3QgdGhhdCB3ZSBzaG91bGQgbm90IG1ha2Ug
ZXZlcnl0aGluZyBWRklPIGRvZXNuJ3QgaW1wbHkNCnByb2hpYml0aW9uIG9uIGFueW9uZSBmcm9t
IHVzaW5nIGl0LiBUaGVyZSBpcyBhIGNsZWFyIGRpZmZlcmVuY2UgYmV0d2VlbiANCnBhc3N0aHJv
dWdoIGFuZCB1c2Vyc3BhY2UgRE1BIHJlcXVpcmVtZW50cyBpbiBpZHhkIGNvbnRleHQsIGFuZCB3
ZQ0Kc2VlIGdvb2QgcmVhc29ucyB0byB1c2UgVkZJTyBmb3Igb3VyIHBhc3N0aHJvdWdoIHJlcXVp
cmVtZW50cy4NCg0KDQpUaGFua3MNCktldmluDQo=
