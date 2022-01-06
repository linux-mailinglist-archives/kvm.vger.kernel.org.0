Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8248B4860A6
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 07:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiAFGdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 01:33:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:11400 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbiAFGdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 01:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641450787; x=1672986787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v8Zs7izQtUR2baSwCNwzaXYQ//isYbycTBTGOWs9T88=;
  b=b3w7D+ygZh+xwR3svruRAVK76qIezrnq2pGcVLmdL8ce2V6xJX7fruoO
   oIBoTHL7Fz11Jj4IuQj2ULRHoSF1IB9jUxulPR8gw2JCmneoICDoP2TCc
   ZSzP6ALf2hIVOiEts8t+x6ZJjd2yx3/jownPPx5JhO2ePc2/wKdkonYJc
   muEbOlp3zSJT0flCHBBQMNUz+LnA0NAVzb6283kYtDkpkJQECF/z+C+F9
   StJdFGnT85yQv0xGnrBMvtYawd93CfMR4xx2yftcSqpB5Sn3QWs2uzqa+
   RzbB2TvEfXAeVBoWXz5OYga51Jba20qioe/8owiWuzNr0bA47O71TKxgD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="328950078"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="328950078"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 22:33:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="472780849"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 05 Jan 2022 22:33:06 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:33:05 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:33:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 22:33:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 5 Jan 2022 22:33:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ee4RpcpO1FGnxYE8oOEVoD/BX2iZTG2wUJAD7SIra8RSYB9N2md8QMOSS04RtrjVN3QGtDpyzR53CXNuOxt5KdrpCqnWuI4w9MBxdl8t0miuWB2RMDJw4VqsJVq1xPTsULYVVzWGX+j82ZNQzw5B/6zTSYiiiFMyPn5N6psbV49bqkTDcXzLZ4ei06kU8DI/9g48AW2YgTkK4HRCWYT7mFS37Or6RsgD4qDDYtUbkkEPpFi4dC/PqH+9MGr0MYAk7ziBl/3EQeTg1Jkzii/MoP5cCG5PhxDbAg0qR4yt1uNHoqJn7h7Zd5Mp65QRLt0eu1UHD17SCkMWBbZodpHQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8Zs7izQtUR2baSwCNwzaXYQ//isYbycTBTGOWs9T88=;
 b=RHXCZlnahyn4nWWpQrIeoKGuNJDhGNLfQiQagRAPjGy3jaDthNtq+BooIXX5J6Drr1etz1MO7+PZ7X7ChH1jsHWDeAaQWbGPbaXZtjLOe1M81dwhDA+aK8U1FmOQi/3mwSApqfmzSW1FgGjLMp/bQwl4QHVcjvpjIJ2V/eLbzDQvX/ngr+5Un8xx8q8LQRdFfzKiVtB1e+WsvmX9udU/TtXkk+xfr/qt6dXjTXG4xSoEp8R4GelIvACHuAEUNJyIlLtMwRZ18XJKPH+GDwkBRq9+sFO7i2hYIOuBi5QP6FrPh84dncH8ZNidCIGiBIFFGNJgX7ZPRWoHO1AkltwxAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1571.namprd11.prod.outlook.com (2603:10b6:405:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 06:32:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 06:32:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAwDmAgAES3TA=
Date:   Thu, 6 Jan 2022 06:32:57 +0000
Message-ID: <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
In-Reply-To: <20220105124533.GP2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6d7ad1b-7d41-4299-73a4-08d9d0de6125
x-ms-traffictypediagnostic: BN6PR11MB1571:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1571712C8F7E55CA7B80FBBF8C4C9@BN6PR11MB1571.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RcjS6GZ5kMMpcXOwyqyAdzTTE7GtsPRKTv5FFQtoY7Kw/42XZP3nTpNJ4lf4qXNKCuicX16CMpvAX7FbxAr2zWng6+MaWjFUn6qbB94UndWo/EJD8Y/6VuASroqC+2Wpj9kAnr2dHKVvJvevK4NTkL6jjBF03jYVlRxAPwGdcxc4xHMaCOgIgsZ5Ij6j+jvWcqERMj6xuexwoAkiwiM0yvhfWSM/Lf70Agw9A37BcjcfBHWVE1h4JoUcTfaH1EsMZ6cl6DD9otdUOZADw6Y0F6PpxRHq8l6EZN05f30J9LPOtNMXqJkRNUTTLQv0mx4oYNJ4iLrZv5yyorpLBHo7a4k8QowzqHpzW4mpXnJyuoAOtO2RrQtvgE6J5wiRZtDBeIDvl+0xL7CkguqysbwuLC9Ty3ee3dnw0wjMZt2gr97ru4x/dAhY6HsFIlFcAQVCUpErBpILpj34HogsYMIMciULvLWHwcZ6t4baeHquPeLemxKvcgPnjAMpYRpVzxDlz2RC1LU7PmJe0TIr2lOIZ4LsxlKZvlEVkbNCp59nUQGHZTGlLAQn3oqYGgQxXGEtbLEjwwq4WNEYa2NsM+opnKGdgIeFdX9LpJ7hcZFe1e3t9fZLARO7ZFxH3qh6CWOvesds1AGchkj8v+okfsFilw6caXl1d76qhlSwdq1u+IkYzWtHIAD/5BFtWr5bmSf7xbWemo7YCBanLRnHVO+sYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(82960400001)(66476007)(6506007)(33656002)(76116006)(54906003)(5660300002)(6916009)(7696005)(107886003)(508600001)(66946007)(52536014)(71200400001)(66446008)(9686003)(26005)(316002)(122000001)(64756008)(2906002)(38100700002)(8676002)(4326008)(186003)(8936002)(55016003)(83380400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1JCZGpqaXFWdkduNlZ1NjVTMUlZQlNmMy9PU0dNb3hsVWxWRHRDTHRkdVJR?=
 =?utf-8?B?VHdmS0FVR1ppdXdESDJJenNmSVFDb0lPZUluQ0k1UjExOWc0TUVKWTJ4cE1V?=
 =?utf-8?B?RjJqbUJRbUxCL0YwdlRVVHpNc2xlWFJGclh1YjZPdzVVczgrQkhWQVV3QXBs?=
 =?utf-8?B?WVpiRG52TmZqSFNjZ3dTaDFsaHBPMFBBK0crVy9LSjFYSGZDWlJyRHNCdFd6?=
 =?utf-8?B?ZXBTam4vZkhwUEptUmxUK3pPTnFLUFc4MXQySDNteHJsSk5haFNYVkoyN2ND?=
 =?utf-8?B?cnN3N2NIYVAwbXpQdktjS2ZWZTA1Wkxlb2xxU2dGWHdYQnBaYzgxVUNwYldD?=
 =?utf-8?B?dkpnNW5IV3p2cHM1VmhKZEMvRVVqSjlJa2ZlN0V5aUp0TDVkWVdJRHFlU2hn?=
 =?utf-8?B?YzJzQXJ1ZzFOTmIxNHowTzdQUlo0R25tbW8vSEFkajZjbUtxOEhNeitEVFdH?=
 =?utf-8?B?ZVB0NFMxT0x2V0duNjFqejhYb2tBaGZjZi9oMlRtczFWWlhXQWNFbDU5Znlr?=
 =?utf-8?B?aCtpUHBaeU5pVE9JTkRiZGVYelp3ODdyTW5kL3NRSnpOSWY4MEk0ZlFCYU9u?=
 =?utf-8?B?WUlrcTVuQmQxa1ZFdjlUZWY3MUZQa3hVamppbDF5ZERGQWhyQ1hkY1NNWDVh?=
 =?utf-8?B?Y1hSOGk1VlBSS3FyV0VTQmdlNlBsOFZvUFpxMERqMGU2Z3Y2a0VZKzArZnhH?=
 =?utf-8?B?YlFROXRDdXJ0aUtubERWR3hRWHFiWWlERXRkeEI5aVJ3RU9VWTZIK1lDdUZo?=
 =?utf-8?B?QkRESXlBd3VaeU9xZHFTNWNNd1B0OHRad2Z5ZGdkN1luQTdYY3oxTVVQTitZ?=
 =?utf-8?B?SnBLTTcxZEhqc3dvTXpkRU1jbk1VZW1tTDd3QjYxa05sN0w5c3cvRGpUZXg0?=
 =?utf-8?B?OEVCcVNueGp1eGpvZm1qMjUvbFRPSFg0ZnF5ejZ2WHVRSFdpdG9pLzJaMktz?=
 =?utf-8?B?ZXZWa051VExpdWxuclVOZTB0UXNiZ1JaWEJBYm9ORHZzSitRaWdCeU5nem1a?=
 =?utf-8?B?blFoeXdEWTBpcnJDczg1R012SFhDTWFmRGNzblQrTzBES3FlV25xWm9TN3ps?=
 =?utf-8?B?b2xkdHk1N2ZSM2d0cm04NFJJSjAzRHYvNHRueS9aUEI0QUs1L2E4cm1jNy9M?=
 =?utf-8?B?ekQvS1pqZ0tGNmYwZUYyN0NZb0FOZ3dPa1lBdkZnSWs1U2hkQklUZ01rMEVs?=
 =?utf-8?B?NlRZY0liV1ZxWlNVa0JqVXQ1clU5SE43ZGZkWlVlbnRhUnpzSE81RS8rN2hY?=
 =?utf-8?B?YWJ4cXV6a1F4cHVseitmeGpoMmxaNXY2eGdaV3BCZmRsaUlid3RrSEdpaHlS?=
 =?utf-8?B?Kzc2WDQ5V3VtcSthc2NrWFMzT3doNlhIaEFqZ1VUUnpsRGVIUlJqMmU0aGJx?=
 =?utf-8?B?RURjNS9yZm5pNW5wOEtuakk0NFdiTlJ6Y3p2U0ZlL3ZXQk5kK1hXT0tSdG5s?=
 =?utf-8?B?NEtjaUkybmxVNDRINnJuendvT2N1Yyt5Q0pBTDM1Q1BMaFFYOHdtZTYvS2FW?=
 =?utf-8?B?VzBnRkwwRitsS2YvYjZQUjNoalV3WDgzQnZ6cDY5NDcybnJsMzlRYjhucWJW?=
 =?utf-8?B?WHkzUC9lNjYwTytyc1YycnVWNnhiTEhGSHNveHFGUnM1UHowb3NWZ0haTlR1?=
 =?utf-8?B?MDBTSzNwRzBuRFVQS3pjUmVLa1JTWVFrVmxIRHM5K0dOenhXdklBemNRdmND?=
 =?utf-8?B?Umd0cmtsNWtTMklHUjZXVmhVajRQbzZrRkQ3b3A2NzdoOVlmakVTY04wa2Vu?=
 =?utf-8?B?TjZ4bG91WlFncnkzd0RydEc2UkRuOFNlRW16cmhNWDRQS3R2RXFpRE9tWGEy?=
 =?utf-8?B?QW9jOXNiWmltempxWWVMMGNmUjg4cTFkclZDL09Jdlo0UWQxWldEanl3dFBR?=
 =?utf-8?B?YnBINjI0VllhU1E1L2JHb2orUEpRbFpmbHdyZXNMcnFpcWJZL0NwdFp4Q1li?=
 =?utf-8?B?Yjhhb2pPdEVwT0l0bzVOWkd1b3IwTXJqZ0VqRE9VUjZiaDBIZlpRYStlNk5Z?=
 =?utf-8?B?UEVSNVlDN25adGI4K0U2MnVMTDhsc2JNaGt6cWh3L25yYlloTGpGdTYzKzNI?=
 =?utf-8?B?ejRhNTRQU2gzSlVWckxDMkcwVlQ5VFNXSDJOYXRoczJVQStrOTZLODFkZzdB?=
 =?utf-8?B?UkZYbGw4VDE4N2NrYzdUV3ptUGw5WUczR3EyaktHR2pOY0lLQmdPTzA0eWpK?=
 =?utf-8?Q?BcNNFfBwqnXcwelI6ve3o70=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d7ad1b-7d41-4299-73a4-08d9d0de6125
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 06:32:58.0180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gSBg6zZyolLafwuuf3fFOG7P1im2KDmbKsj9nlfCBLp6y6EaSraP+HPquL/krhI7CR3BA4d4UweXucKCCE8hDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1571
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEphbnVhcnkgNSwgMjAyMiA4OjQ2IFBNDQo+IA0KPiBPbiBXZWQsIEphbiAwNSwgMjAyMiBh
dCAwMTo1OTozMUFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gDQo+ID4gPiBUaGlzIHdp
bGwgYmxvY2sgdGhlIGh5cGVydmlzb3IgZnJvbSBldmVyIG1pZ3JhdGluZyB0aGUgVk0gaW4gYSB2
ZXJ5DQo+ID4gPiBwb29yIHdheSAtIGl0IHdpbGwganVzdCBoYW5nIGluIHRoZSBtaWRkbGUgb2Yg
YSBtaWdyYXRpb24gcmVxdWVzdC4NCj4gPg0KPiA+IGl0J3MgcG9vciBidXQgJ2hhbmcnIHdvbid0
IGhhcHBlbi4gUENJIHNwZWMgZGVmaW5lcyBjb21wbGV0aW9uIHRpbWVvdXQNCj4gPiBmb3IgQVRT
IHRyYW5zbGF0aW9uIHJlcXVlc3QuIElmIHRpbWVvdXQgdGhlIGRldmljZSB3aWxsIGFib3J0IHRo
ZSBpbi1mbHkNCj4gPiByZXF1ZXN0IGFuZCByZXBvcnQgZXJyb3IgYmFjayB0byBzb2Z0d2FyZS4N
Cj4gDQo+IFRoZSBQUkkgdGltZSBvdXRzIGhhdmUgdG8gYmUgbG9uZyBlbm91Z2ggdG8gaGFuZGxl
IHN3YXAgYmFjayBmcm9tDQo+IGRpc2ssIHNvICdoYW5nJyB3aWxsIGJlIGEgZmFpciBhbW91bnQg
b2YgdGltZS4uDQoNClRoaXMgcmVtaW5kcyBtZSBvbmUgaW50ZXJlc3RpbmcgcG9pbnQuDQoNClB1
dHRpbmcgUFJJIGFzaWRlIHRoZSB0aW1lIHRvIGRyYWluIGluLWZseSByZXF1ZXN0cyBpcyB1bmRl
ZmluZWQuIEl0IGRlcGVuZHMNCm9uIGhvdyBtYW55IHBlbmRpbmcgcmVxdWVzdHMgdG8gYmUgd2Fp
dGVkIGZvciBiZWZvcmUgY29tcGxldGluZyB0aGUNCmRyYWluaW5nIGNvbW1hbmQgb24gdGhlIGRl
dmljZS4gVGhpcyBpcyBJUCBzcGVjaWZpYyAoZS5nLiB3aGV0aGVyIHN1cHBvcnRzDQpwcmVlbXB0
aW9uKSBhbmQgYWxzbyBndWVzdCBzcGVjaWZpYyAoZS5nLiB3aGV0aGVyIGl0J3MgYWN0aXZlbHkg
c3VibWl0dGluZw0Kd29ya2xvYWQpLg0KDQpTbyBldmVuIHdpdGhvdXQgaG9zdGlsZSBhdHRlbXB0
cyB0aGUgZHJhaW5pbmcgdGltZSBtYXkgZXhjZWVkIHdoYXQgYW4NCnVzZXIgdG9sZXJhdGVzIGlu
IGxpdmUgbWlncmF0aW9uLg0KDQpUaGlzIHN1Z2dlc3RzIGNlcnRhaW4gc29mdHdhcmUgdGltZW91
dCBtZWNoYW5pc20gbWlnaHQgYmUgbmVjZXNzYXJ5IA0Kd2hlbiB0cmFuc2l0aW9uaW5nIHRvIE5E
TUEgc3RhdGUsIHdpdGggdGhlIHRpbWVvdXQgdmFsdWUgb3B0aW9uYWxseQ0KY29uZmlndXJhYmxl
IGJ5IHRoZSB1c2VyLiBJZiB0aW1lb3V0LCB0aGVuIGZhaWwgdGhlIHN0YXRlIHRyYW5zaXRpb24N
CnJlcXVlc3QuDQoNCkFuZCBvbmNlIHN1Y2ggbWVjaGFuaXNtIGlzIGluIHBsYWNlLCBQUkkgaXMg
YXV0b21hdGljYWxseSBjb3ZlcmVkIGFzIGl0DQppcyBqdXN0IG9uZSBpbXBsaWNpdCByZWFzb24g
d2hpY2ggbWF5IGluY3JlYXNlIHRoZSBkcmFpbmluZyB0aW1lLg0KDQo+IA0KPiA+ID4gUmVnYXJk
bGVzcyBvZiB0aGUgY29tcGxhaW50cyBvZiB0aGUgSVAgZGVzaWduZXJzLCB0aGlzIGlzIGEgdmVy
eSBwb29yDQo+ID4gPiBkaXJlY3Rpb24uDQo+ID4gPg0KPiA+ID4gUHJvZ3Jlc3MgaW4gdGhlIGh5
cGVydmlzb3Igc2hvdWxkIG5ldmVyIGJlIGNvbnRpbmdlbnQgb24gYSBndWVzdCBWTS4NCj4gPiA+
DQo+ID4NCj4gPiBXaGV0aGVyIHRoZSBzYWlkIERPUyBpcyBhIHJlYWwgY29uY2VybiBhbmQgaG93
IHNldmVyZSBpdCBpcyBhcmUgdXNhZ2UNCj4gPiBzcGVjaWZpYyB0aGluZ3MuIFdoeSB3b3VsZCB3
ZSB3YW50IHRvIGhhcmRjb2RlIHN1Y2ggcmVzdHJpY3Rpb24gb24NCj4gPiBhbiB1QVBJPyBKdXN0
IGdpdmUgdGhlIGNob2ljZSB0byB0aGUgYWRtaW4gKGFzIGxvbmcgYXMgdGhpcyByZXN0cmljdGlv
biBpcw0KPiA+IGNsZWFybHkgY29tbXVuaWNhdGVkIHRvIHVzZXJzcGFjZSBjbGVhcmx5KS4uLg0K
PiANCj4gSU1ITyBpdCBpcyBub3QganVzdCBET1MsIFBSSSBjYW4gYmVjb21lIGRlcGVuZGVudCBv
biBJTyB3aGljaCByZXF1aXJlcw0KPiBETUEgdG8gY29tcGxldGUuDQo+IA0KPiBZb3UgY291bGQg
cXVpY2tseSBnZXQgeW91cnNlbGYgaW50byBhIGRlYWRsb2NrIHNpdHVhdGlvbiB3aGVyZSB0aGUN
Cj4gaHlwZXJ2aXNvciBoYXMgZGlzYWJsZWQgRE1BIGFjdGl2aXRpZXMgb2Ygb3RoZXIgZGV2aWNl
cyBhbmQgdGhlIHZQUkkNCj4gc2ltcGx5IGNhbm5vdCBiZSBjb21wbGV0ZWQuDQoNCkhvdyBpcyBp
dCByZWxhdGVkIHRvIFBSSSB3aGljaCBpcyBvbmx5IGFib3V0IGFkZHJlc3MgdHJhbnNsYXRpb24/
DQoNCkluc3RlYWQsIGFib3ZlIGlzIGEgZ2VuZXJhbCBwMnAgcHJvYmxlbSBmb3IgYW55IGRyYWlu
aW5nIG9wZXJhdGlvbi4gSG93IA0KdG8gc29sdmUgaXQgbmVlZHMgdG8gYmUgZGVmaW5lZCBjbGVh
cmx5IGZvciB0aGlzIE5ETUEgc3RhdGUgKHdoaWNoIEkgc3VwcG9zZQ0KaXMgYmVpbmcgZGlzY3Vz
c2VkIGJldHdlZW4geW91IGFuZCBBbGV4IGFuZCBJIHN0aWxsIG5lZWQgdGltZSB0byBjYXRjaA0K
dXApLg0KDQo+IA0KPiBJIGp1c3QgZG9uJ3Qgc2VlIGhvdyB0aGlzIHNjaGVtZSBpcyBnZW5lcmFs
bHkgd29ya2FibGUgd2l0aG91dCBhIGxvdA0KPiBvZiBsaW1pdGF0aW9ucy4NCj4gDQo+IFdoaWxl
IEkgZG8gYWdyZWUgd2Ugc2hvdWxkIHN1cHBvcnQgdGhlIEhXIHRoYXQgZXhpc3RzLCB3ZSBzaG91
bGQNCj4gcmVjb2duaXplIHRoaXMgaXMgbm90IGEgbG9uZyB0ZXJtIHdvcmthYmxlIGRlc2lnbiBh
bmQgdHJlYXQgaXQgYXMNCj4gc3VjaC4NCj4gDQoNCkRlZmluaXRlbHkgYWdyZWUgd2l0aCB0aGlz
IHBvaW50LiBXZSBzb2Z0d2FyZSBwZW9wbGUgc2hvdWxkIGNvbnRpbnVlDQppbmZsdWVuY2luZyBJ
UCBkZXNpZ25lcnMgdG93YXJkIGEgbG9uZy10ZXJtIHNvZnR3YXJlIGZyaWVuZGx5IGRlc2lnbi4N
CmFuZCBhbHNvIGJlYXIgdGhlIGZhY3QgdGhhdCBpdCB0YWtlcyB0aW1lLi4uIPCfmIoNCg0KVGhh
bmtzDQpLZXZpbiANCg==
