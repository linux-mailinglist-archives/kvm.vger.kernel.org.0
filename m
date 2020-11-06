Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6432A934E
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgKFJsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:48:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:7976 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFJsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:48:45 -0500
IronPort-SDR: IHWW0Qzqxe+cQmeydEJqkBxblkf5lqLkzhVsZBUbRfbsM1AiJlEqE6rNu+4eU/lt+QTdFknTeo
 HDvJ4gJAiE7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169674158"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169674158"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:48:43 -0800
IronPort-SDR: +ws9RF1FZeovOGxanyn4fblHVnv8MesXjf86OBz/OBpCh28Ff0qCTzwRE7rE1VbplnpmhxzYOg
 0XTjAyHeDUqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="364650154"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Nov 2020 01:48:43 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Nov 2020 01:48:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Nov 2020 01:48:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 6 Nov 2020 01:48:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7+0iTSRoUc2TjD6xAUOn32RaGh+KY6w2jiT5Q2omuzPLuqtJHRmsRXqGqk1XrRYsTRTNdTbmkBvvcgsZQdp4K3ZxdkafPK8oe02sLMNaxkIsir7QfrL4O157oBKS+nz6KC/kryPWRdpeerw4/Wy9QUHposaMTD9DxluCnHwlLxySRS3x2ujDYN1x6QYHPuTql53/+SGTYRSWgk8F8NW8GMSoYKplS6AGl6a/Zwb3HpeL6T4VFJ6N9QCMD+Xg58zoVhh9N9RKEKxNGHvo5RjzXIXdFFOyHtD+6czg4hjijvzoaojOivPebyvbB//3OYcNU7zIrNwY2sqsM6f2VpVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ww2YQ7g+w07aZ8yrss8v+5sZNsZsMnfmIKNMBQvIi4g=;
 b=E/BLoDtHoqDZF98xFhT5X5gT9Ne2f+jc0AcsySUhNuLTo14PHTrezmROxqu3wlOCE7Nq5k9/nKof7DoIco00qnPEjXnbazQwDV06sAS/bsg71ggPrcmQnXoFfBhxyURhdnSdn8B+qYfQEm/tDJQ+ezWlUASeQrnGEkQU9WXnhiBYt3RmeRV7lrevxnPFFqu9VwoA5WERzBZi0it2mzoKADqtIXgjazgjBKTY14DpDgJaMgiFHwkRAQSp225AZBG/Q27OOgUceSpSgAKzCooluAaCUbcgY+eEYfQKmiwOuCVhhuEoPoYf+CUJ2zCFJ0FpzVFZgPLL2jSkRY2ImM63MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ww2YQ7g+w07aZ8yrss8v+5sZNsZsMnfmIKNMBQvIi4g=;
 b=UBa5/Y1ATrfm4P1AJyV3HLgjeQwxm/g8XTlicfWjCoq5DzwiC2NvvpuF6yO5zCOu/KzNBBWPx+eU9bfY69ZULQMKvt1Id2NBmtO2aFail/OIryyGKu22ZdmbUfYCqZCBTDPQrByC3/5ictCX/zeutI1vZeSq6KQbCL93CaRIHww=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1967.namprd11.prod.outlook.com (2603:10b6:300:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 6 Nov
 2020 09:48:35 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5%8]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 09:48:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cA==
Date:   Fri, 6 Nov 2020 09:48:34 +0000
Message-ID: <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
In-Reply-To: <20201104135415.GX2620339@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68eaf2e7-f04a-47ba-9bc5-08d882392102
x-ms-traffictypediagnostic: MWHPR11MB1967:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1967624FDA94882F6CAE823C8CED0@MWHPR11MB1967.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MdOHlUZsSeA28GP+dt4gmxykE1EPh7kZRNR41u49bJLqtosjq+Xi0YJ7AUwCi6Ef4sc2k4t9XmCyZEEBIR180c7oyt63yj+qxG6pTYH54neptqSdvDkbwGHOepWp3OkO0sOZaNhqQQn3Epf6Hz1PrRkZR5Vy/jD0DN/mVBUBz0nxpjuVa9zLX+TMBFll6bnxsO5yajoncyYYiWE7e64qdxkaS07oGGF9+zyoZksrFyxT276lHM312fFVMGMBrNMOvToqDC0Z7pOxcg9MzvQKL8Tnbd+KsC6qouhbzpMN2zxBlF2TRaUBOHBn4cSDUKaWnhGbBQPyQLgM3mR5dzxFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(9686003)(64756008)(66446008)(76116006)(55016002)(66556008)(66476007)(66946007)(2906002)(7416002)(83380400001)(186003)(26005)(6916009)(7696005)(478600001)(8676002)(8936002)(54906003)(52536014)(316002)(5660300002)(33656002)(71200400001)(86362001)(6506007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RKWRLZnmDpU6p7ZpZvCCzigLo2UMgJBe270clRTRGF5PoDbFM21E90DqPmXVDmdHK9ktXeghcPOLVaUdl0dsMAclYZKqCwkyKeDYTtZSLkuBUo9bnMpK0JZe2WcMmq2YQYkQ7Pgc3dMYHGYyJ81N1XNxWoAMTFHvhNHPjBNjvXhRxDXS5BQhCmxFxDvReTYB98II2HVgrKS0YU/d/AANuZI6teUpS44q9e5fwJR095Cjrd1/75H0+3rohbsFgZVNSRImvcYZ6T0PKHL2sIvmgA2dc8AN0zlsi3ATqw+vljby4RAZD5811aWyVglQGFyMKEaar/6rovwtC0SuWPD2kr+rSxRfEdM1e5/wFz7vQTdGqr4oorfzougt7Ki8dY9Q9+O4PBVJGZVNBeXyzsd8GZrvJlDnWDHEuKlRbc7DtBB9VlllqorScTw26yxO1074MnYTVAKvoUpTWmm9qhpGWYbZGH8UidwXeivVrAuKNpl+o+YzljFtuhw282k46qCnqeKMvz7AdTGyFtyxjdJKGxlQ9scAdQgHbQLB1x57Lc9DffRJZAn6bpBE0cCFK40PwqyU6AQNHj8srOQBq6xt0WWhMyrXu+A0oYBDx0q7TlmCyCYyqVRj34YdF2hbsv8x+YjFZtIx+4nM/3cSH7KU+A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68eaf2e7-f04a-47ba-9bc5-08d882392102
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 09:48:34.9931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REOe29pigqSMl/+M/+pMM5AZhlubu0JOcAyQo+Uy1Q87ZrCsaq7M2vzFaFsgaTf7N8DR0W2rvusGFpxTkHij/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1967
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE5vdmVtYmVyIDQsIDIwMjAgOTo1NCBQTQ0KPiANCj4gT24gV2VkLCBOb3YgMDQsIDIwMjAg
YXQgMDE6MzQ6MDhQTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBKYXNv
biBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBOb3Zl
bWJlciA0LCAyMDIwIDg6NDAgUE0NCj4gPiA+DQo+ID4gPiBPbiBXZWQsIE5vdiAwNCwgMjAyMCBh
dCAwMzo0MTozM0FNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+ID4gPiBGcm9tOiBK
YXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gPiA+IFNlbnQ6IFR1ZXNkYXks
IE5vdmVtYmVyIDMsIDIwMjAgODo0NCBQTQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24gVHVlLCBO
b3YgMDMsIDIwMjAgYXQgMDI6NDk6MjdBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+ID4gVGhlcmUgaXMgYSBtaXNzaW5nIGh5cGVyY2FsbCB0byBhbGxv
dyB0aGUgZ3Vlc3QgdG8gZG8gdGhpcyBvbiBpdHMgb3duLA0KPiA+ID4gPiA+ID4gPiBwcmVzdW1h
Ymx5IGl0IHdpbGwgc29tZWRheSBiZSBmaXhlZCBzbyBJTVMgY2FuIHdvcmsgaW4gZ3Vlc3RzLg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEh5cGVyY2FsbCBpcyBWTU0gc3BlY2lmaWMsIHdoaWxl
IElNUyBjYXAgcHJvdmlkZXMgYSBWTU0tYWdub3N0aWMNCj4gPiA+ID4gPiA+IGludGVyZmFjZSBz
byBhbnkgZ3Vlc3QgZHJpdmVyIChpZiBmb2xsb3dpbmcgdGhlIHNwZWMpIGNhbiBzZWFtbGVzc2x5
DQo+ID4gPiA+ID4gPiB3b3JrIG9uIGFsbCBoeXBlcnZpc29ycy4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IEl0IGlzIGEgKlZNTSogaXNzdWUsIG5vdCBQQ0kuIEFkZGluZyBhIFBDSSBjYXAgdG8gZGVz
Y3JpYmUgYSBWTU0NCj4gaXNzdWUNCj4gPiA+ID4gPiBpcyBhcmNoaXRlY3R1cmFsbHkgd3Jvbmcu
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJTVMgKmNhbiBub3Qgd29yayogaW4gYW55IGh5cGVydnNp
b3Igd2l0aG91dCBzb21lIHNwZWNpYWwNCj4gPiA+ID4gPiBoeXBlcmNhbGwuIEp1c3QgYmxvY2sg
aXQgaW4gdGhlIHBsYXRmb3JtIGNvZGUgYW5kIGZvcmdldCBhYm91dCB0aGUgUENJDQo+ID4gPiA+
ID4gY2FwLg0KPiA+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+IEl0J3MgcGVyLWRldmljZSB0aGlu
ZyBpbnN0ZWFkIG9mIHBsYXRmb3JtIHRoaW5nLiBJZiB0aGUgVk1NIHVuZGVyc3RhbmRzDQo+ID4g
PiA+IHRoZSBJTVMgZm9ybWF0IG9mIGEgc3BlY2lmaWMgZGV2aWNlIGFuZCB2aXJ0dWFsaXplIGl0
IHRvIHRoZSBndWVzdCwNCj4gPiA+DQo+ID4gPiBQbGVhc2Ugbm8hIEFkZGluZyBkZXZpY2Ugc3Bl
Y2lmaWMgZW11bGF0aW9uIGlzIGp1c3QgZ29pbmcgZG93biBkZWVwZXINCj4gPiA+IGludG8gdGhp
cyBiYWQgYXJjaGl0ZWN0dXJlLg0KPiA+ID4NCj4gPiA+IEludGVycnVwdHMgaXMgYSBwbGF0Zm9y
bSBpc3N1ZS4gVXNpbmcgZW11bGF0aW9uIG9mIE1TSSB0byBkeW5hbWljYWxseQ0KPiA+DQo+ID4g
SW50ZXJydXB0IGNvbnRyb2xsZXIgaXMgYSBwbGF0Zm9ybSBpc3N1ZS4gSW50ZXJydXB0IHNvdXJj
ZSBpcyBhYm91dCBkZXZpY2UuDQo+IA0KPiBUaGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgaXMgcmVz
cG9uc2libGUgdG8gY3JlYXRlIGFuIGFkZHIvZGF0YSBwYWlyDQo+IGZvciBhbiBpbnRlcnJ1cHQg
bWVzc2FnZS4gSXQgc2V0cyB0aGUgbWVzc2FnZSBmb3JtYXQgYW5kIGVuc3VyZXMgaXQNCj4gcm91
dGVzIHRvIHRoZSBwcm9wZXIgQ1BVIGludGVycnVwdCBoYW5kbGVyLiBFdmVyeXRoaW5nIGFib3V0
IHRoZQ0KPiBhZGRyL2RhdGEgcGFpciBpcyBvd25lZCBieSB0aGUgcGxhdGZvcm0gaW50ZXJydXB0
IGNvbnRyb2xsZXIuDQo+IA0KPiBEZXZpY2VzIGRvIG5vdCBjcmVhdGUgaW50ZXJydXB0cy4gVGhl
eSBvbmx5IHRyaWdnZXIgdGhlIGFkZHIvZGF0YSBwYWlyDQo+IHRoZSBwbGF0Zm9ybSBnaXZlcyB0
aGVtLg0KDQpJIGd1ZXNzIHRoYXQgd2UgbWF5IGp1c3QgdmlldyBpdCBmcm9tIGRpZmZlcmVudCBh
bmdsZXMuIE9uIHg4NiBwbGF0Zm9ybSwNCmEgTVNJL0lNUyBjYXBhYmxlIGRldmljZSBkaXJlY3Rs
eSBjb21wb3NlcyBpbnRlcnJ1cHQgbWVzc2FnZXMsIHdpdGggDQphZGRyL2RhdGEgcGFpciBmaWxs
ZWQgYnkgT1MuIElmIHRoZXJlIGlzIG5vIElPTU1VIHJlbWFwcGluZyBlbmFibGVkIGluIA0KdGhl
IG1pZGRsZSwgdGhlIG1lc3NhZ2UganVzdCBoaXRzIHRoZSBDUFUuIFlvdXIgZGVzY3JpcHRpb24g
cG9zc2libHkNCmlzIGZyb20gc29mdHdhcmUgc2lkZSwgZS5nLiBkZXNjcmliaW5nIHRoZSBoaWVy
YXJjaGljYWwgSVJRIGRvbWFpbg0KY29uY2VwdD8NCg0KPiANCj4gPiA+IGluc2VydCB2ZWN0b3Jz
IHRvIGEgVk0gd2FzIGEgcmVhc29uYWJsZSwgYnV0IGhhY2t5IHRoaW5nLiBOb3cgaXQgbmVlZHMN
Cj4gPiA+IHByb3BlciBwbGF0Zm9ybSBzdXBwb3J0Lg0KPiA+DQo+ID4gd2h5IGlzIE1TSSBlbXVs
YXRpb24gYSBoYWNreSB0aGluZz8gaXNuJ3QgaXQgZGVmaW5lZCBieSBQQ0lTSUc/IEkgZ3Vlc3MN
Cj4gPiB0aGF0IEkgbXVzdCBtaXN1bmRlcnN0YW5kIHlvdXIgcmVhbCBwb2ludCBoZXJlLi4uDQo+
IA0KPiBJdCBtZWFucyB0aGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgaW4gdGhlIFZNJ3MgcGxhdGZv
cm0gaXMgYSBmaWN0aW9uLA0KPiB0aGUgYWRkci9kYXRhIHBhaXJzIGl0IGNyZWF0ZXMgYXJlIG5v
dCByZWFsLg0KPiANCj4gQSBQQ0kgZGV2aWNlIGFzc2lnbmVkIHRvIGEgVk0gaXMgc3VwcG9zZWQg
dG8gYmUgZnVsbHkgY29udGFpbmVkIGJ5IHRoZQ0KPiBJT01NVSwgaW50ZXJydXB0cyBpbmNsdWRl
ZCwgc28gdGhlcmUgaXMgbm8gcmVhc29uIHRvIGRvIE1TSSBlbXVsYXRpb24NCj4gaWYgdGhlIFZN
J3MgaW50ZXJydXB0IGNvbnRyb2xsZXIgaXMgYXdhcmUgb2Ygd2hhdCBhZGRyL2RhdGEgcGFpcnMg
aXQNCj4gY2FuIHVzZSB3aXRoIHRoZSBkZXZpY2UgLSBlZyBieSBnZXR0aW5nIHRoZW0gdGhyb3Vn
aCBhIGh5cGVyY2FsbC4gVGhpcw0KPiBpcyBtdWNoIGNsZWFuZXIgYW5kIHN1cHBvcnRzIHRoaW5n
cyBsaWtlIElNUw0KDQpJIGFncmVlIHdpdGggdGhpcyBwb2ludCwganVzdCBhcyBob3cgcGNpLWh5
cGVydi5jIHdvcmtzLiBJbiBjb25jZXB0IExpbnV4DQpndWVzdCBkcml2ZXIgc2hvdWxkIGJlIGFi
bGUgdG8gdXNlIElNUyB3aGVuIHJ1bm5pbmcgb24gSHlwZXItdi4gVGhlcmUNCmlzIG5vIHN1Y2gg
dGhpbmcgZm9yIEtWTSwgYnV0IHBvc3NpYmx5IG9uZSBkYXkgd2Ugd2lsbCBuZWVkIHNpbWlsYXIg
c3R1ZmYuDQpCZWZvcmUgdGhhdCBoYXBwZW5zIHRoZSBndWVzdCBjb3VsZCBjaG9vc2UgdG8gc2lt
cGx5IGRpc2FsbG93IGRldm1zaSANCmJ5IGRlZmF1bHQgaW4gdGhlIHBsYXRmb3JtIGNvZGUgKGlu
dmVudGluZyBhIGh5cGVyY2FsbCBqdXN0IGZvciAnZGlzYWJsZScgDQpkb2Vzbid0IG1ha2Ugc2Vu
c2UpIGFuZCBpZ25vcmUgdGhlIElNUyBjYXAuIE9uZSBzbWFsbCBvcGVuIGlzIHdoZXRoZXINCnRo
aXMgY2FuIGJlIGRvbmUgaW4gb25lIGNlbnRyYWwtcGxhY2UuIFRoZSBkZXRlY3Rpb24gb2YgcnVu
bmluZyBhcyBndWVzdA0KaXMgZG9uZSBpbiBhcmNoLXNwZWNpZmljIGNvZGUuIERvIHdlIG5lZWQg
ZGlzYWJsaW5nIGRldm1zaSBmb3IgZXZlcnkgYXJjaD8NCg0KQnV0IHdoZW4gdGFsa2luZyBhYm91
dCB2aXJ0dWFsaXphdGlvbiBpdCdzIG5vdCBnb29kIHRvIGFzc3VtZSB0aGUgZ3Vlc3QNCmJlaGF2
aW9yLiBJdCdzIHBlcmZlY3RseSBzYW5lIHRvIHJ1biBhIGd1ZXN0IE9TIHdoaWNoIGRvZXNuJ3Qg
aW1wbGVtZW50IA0KYW55IFBWIHN0dWZmICh0aHVzIGRvbid0IGtub3cgcnVubmluZyBpbiBhIFZN
KSBidXQgZG8gc3VwcG9ydCBJTVMuIEluIA0Kc3VjaCBzY2VuYXJpbyB0aGUgSU1TIGNhcCBhbGxv
d3MgdGhlIGh5cGVydmlzb3IgdG8gZWR1Y2F0ZSB0aGUgZ3Vlc3QgDQpkcml2ZXIgdG8gdXNlIE1T
SSBpbnN0ZWFkIG9mIElNUywgYXMgbG9uZyBhcyB0aGUgZHJpdmVyIGZvbGxvd3MgdGhlIGRldmlj
ZSANCnNwZWMuIEluIHRoaXMgcmVnYXJkIEkgZG9uJ3QgdGhpbmsgdGhhdCB0aGUgSU1TIGNhcCB3
aWxsIGJlIGEgc2hvcnQtdGVybSANCnRoaW5nLCBhbHRob3VnaCBMaW51eCBtYXkgY2hvb3NlIHRv
IG5vdCB1c2UgaXQuDQoNCj4gDQo+IFRyeWluZyB0byBkbyBJTVMgZW11bGF0aW9uIGlzIG51dHos
IHRoZSBlbnRpcmUgcG9pbnQgb2YgSU1TIGlzIHRoZQ0KPiBkZXZpY2UgY2FuIGRvIHdoYXQgaXQg
bGlrZXMsIGFuZCBlbXVsYXRpbmcgdGhhdCBpcyBub3QgZ29pbmcgdG8NCj4gZmVhc2libGUuIEZv
ciBpbnN0YW5jZSBnbyByZWFkIHRoZSBkaXNjdXNzaW9uIEkgaGFkIHdpdGggVGhvbWFzIGhvdyBh
DQo+IG9iamVjdC1jZW50cmljIGRldmljZSB3b3VsZCBtYW5hZ2UgaW50ZXJydXB0cy4NCj4gDQoN
CkRvIHlvdSBtaW5kIHByb3ZpZGluZyB0aGUgbGluaz8gVGhlcmUgd2VyZSBsb3RzIG9mIGRpc2N1
c3Npb25zIGJldHdlZW4NCnlvdSBhbmQgVGhvbWFzLiBJIGZhaWxlZCB0byBsb2NhdGUgdGhlIGV4
YWN0IG1haWwgd2hlbiBzZWFyY2hpbmcgYWJvdmUNCmtleXdvcmRzLiANCg0KVGhhbmtzDQpLZXZp
bg0K
