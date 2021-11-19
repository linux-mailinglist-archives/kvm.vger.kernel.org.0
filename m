Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715A84571DA
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 16:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhKSPpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 10:45:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:32591 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235415AbhKSPpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 10:45:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="221311857"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221311857"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 07:42:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="455816750"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 19 Nov 2021 07:41:59 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 07:41:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 07:41:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 19 Nov 2021 07:41:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 19 Nov 2021 07:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncfX0NvSaEPfgb9mmrvHIMG3WpuIDmORF4MmihTtzlwrdXK2PZYZXoIwu5qTg30cZEduaVOFCw8fvBbGTuCpBLswngmOKtjli2o+va+JkOnPMenJpvJbhNvuv9Gg8mUFUXFFLGoLm73vK0Y7+wHlstk00cZ3kjDOpzbkq0XX4V7liBaDHj+dEWjox24PMLomy2JTD94M1jUxJ5TnCGwvr5AUSt0WfmXunKSoAfmdifpuP46+mGUx1aDOnP0KHAKaNvmLS6f0rxMVq7ue0psfp57zDaSEtkjKcFtioC2iCFeqTUwkfHC8lV5EYdEt/mBTL6Tv5WSwyunIZtTi8bEfLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7Qt6QElCcpKwtZMMQ4VcmRH+bmPyHPikP9MKeeP1nM=;
 b=QnJf4MvgQGIJyJeCmxeSyUWiO8rgSjen71Cde10b7OqLOIFDVa3rZJMWm2YQME1aeCF9FM5DRS0ipnPnkzOr+zavAcAaXkQn0SFzwX/9EswDLyt8doZdeYuGTV7IpcqoCq2Y6eQjttrKbs6IPhFaoTKnv76XVBBRjNMsCr6KKiUoShmagvor57eC45lEh4s9D6s20g2T6eMxZOWhzHUZJ6TeI+f11TWSFJdedq0sQDN8NW+s1uCVG2YEyyPLmwUM8yUdL+uAQIVkMUY0lY+YIIZ6aEArdELn7F4GaWZySLao5BvFTaoGUWGH8oXGyxQZKx+Rq7/PYA4zfBYPCMYZQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7Qt6QElCcpKwtZMMQ4VcmRH+bmPyHPikP9MKeeP1nM=;
 b=qfaNMpJLg48xBOdTUpfkVNI129omMWIF4W/7OCSR1zKUTbpsNb9iCJ8tK5k1erans3yDKxE84xFLOvwwrCOgXT7yhWzRBnQt2akpemyXL5vgav6ScbqnVPyJLD5oXTeTyVzsH9wFHdR0VEPhYn6voM8SV6G5K/DLCYPX3vHN9xQ=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by SJ0PR11MB5005.namprd11.prod.outlook.com (2603:10b6:a03:2d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 19 Nov
 2021 15:41:55 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993%5]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 15:41:55 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nwE7nDEAABP7RQAABYsJgAAE2utwAAZntwAASBWZAAAW45WAAAt8AIA=
Date:   Fri, 19 Nov 2021 15:41:55 +0000
Message-ID: <5ABC728C-9FD3-4BEB-BD02-61E910D69847@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
 <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com> <87sfvslaha.ffs@tglx>
In-Reply-To: <87sfvslaha.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f615777-8361-4e8d-c65e-08d9ab731dc8
x-ms-traffictypediagnostic: SJ0PR11MB5005:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB5005056E1394EE54F47AD0389A9C9@SJ0PR11MB5005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D78jN82/tHl8eFpTOdh6g1u3enxcJDENacV9eiVMr+CyxIkrXYIkb/4OHLYiiWe3FeZ7t5yBc0w3G7SbBCiFmO5f/spGB7elMXnied6JMwexdL1qorbGUR3eBwNyjzAuiFq8gtgkeiFYjb834fMgkSTNGf3n36FdqtB9iPoNRE0XB52cFmjx7RiFpYXOk6SQNPJhnCwHgvqbR5y2E9qxsgQokDizoUfPplZ4OXPKB16z2N5O6qX+pR3T06JGJWrt71HK6eKnLYIOGIatiSG+pMptkGshdangJi0+r39EPn+bS+pS1Ta1A2DRk7dBHUH3GI2/738ORtbyYcdApQ9ir1OV4AfFMMjkyZ6HRZoOJdH768KqgrEceR07QmtoTQlTLGxok2Wg1Cre3VNkQeKYdCUYpebsSrVjRVDwIMP5O5O31I8hDfQSHnP/2AgjGBNqrmRPMl55mZJ+s3AZVX1/mi0N/64tz4u+4NLaGW/IunSPvbtAZLBmVgtHX571HdhETNMI2nCn5WJoVj338R1KOx9qIotTgtPdBwiT5crkbYfRcyJqVZi9QcH8iPypMwUISK9IcChPb2VzX9R5F2tQr5xeuEXNeBma+N0hk0vvUAmSpMISbOeetw0gQj530OxKllPvDwKF35OL+AzBQ5IKqB8jqBf/NnBwb8qVt3phBDET6Cl/E+Lm7d9ZOKSQDt/87+xdijwesJMie3IwzXIVBIm0YN2RKnUZEhlpyy6B1r43wfltMB4XDcsbMAp7qPyG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(6486002)(66946007)(316002)(8676002)(2616005)(82960400001)(508600001)(38070700005)(6512007)(33656002)(7416002)(6506007)(66476007)(6916009)(66556008)(64756008)(5660300002)(66446008)(4326008)(53546011)(86362001)(8936002)(54906003)(38100700002)(2906002)(71200400001)(186003)(26005)(122000001)(83380400001)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUw0R3E5Qmk1VlhYUVAvRnJ2cmZUMmhxQmVSaUdEQVlXdDlpNnBENURTaWcr?=
 =?utf-8?B?S3g0dE11d040TXdmazVoVFAwcGJUWFNVUExOTTVoMmpsTzFGRjVhMFltMFIw?=
 =?utf-8?B?d3FzNGdCazQ5MHNIclJsRXY4cWNmQ2dBQ056aTBKdmgyK3FhUkFKSktxKzhy?=
 =?utf-8?B?c0gvZm1NVlFQdGkyaURGLzFqSTJjTXR3elJ5a01kcjhXZEZEWUNYNHNPVFR2?=
 =?utf-8?B?VTRpMEpJK2Q0THFSd1hvUFZLYkRONCs4dnROVXBEYlVJbTVPam1tUWlnWGlv?=
 =?utf-8?B?NUVrTm5XS1d6cnFLb0o1eWNIUnRxK0orMUNIMERhL2pTZXdDZUNHS3R0cTVo?=
 =?utf-8?B?b084TTlCZHdHNnZDVjc2THFMaXRIVFFxWXJxenJpVDA1T243cmVlcGxxOVY1?=
 =?utf-8?B?NVZOcnZ2RzltLzVvS0hqalpvNDVrTnVWVDQyczhTME1TdHV2V3ovaHI3UkdD?=
 =?utf-8?B?TS9JbWNXTy9NQ0JvMGxDZFZ2Q2UvU1RGaENDQm5FcGhDYWJOaXRqclpMN1FK?=
 =?utf-8?B?cm1oOHlHVTJkcERYZDdYTUo0RjFaRzZ0NDVWSDJqSXdBdk95M2xCb3VMdjl3?=
 =?utf-8?B?WE04U0kwbVh5M3VIWUNCR1RlUTFQdWsvZ1BadUZFOSt5dXVyYkFKZUloWisy?=
 =?utf-8?B?RXQzc3llVmtyRFlXNjdRTnE4TTlSWjRBLzJOVHhPbkZHeDdNR3dab3Y0SmI5?=
 =?utf-8?B?MU1mN3NWZDJIYTltMFEyenNrcnRnODNpR0YxMWJhSnZGMnRxbmRtYXJKSE1O?=
 =?utf-8?B?Wi8zWHVTVW5pOUdSZ1l5KzhMZ0NjZWdBUWdNSjE3SExOcFRpaXlsRklTbUxT?=
 =?utf-8?B?dzhlWXZheTZFNjBLWEZWZFpHM1grRlBNa0ovQXJsQ1Bud1BwL0UrNXFvMWc2?=
 =?utf-8?B?ZHV1ZFphUTlQVDlUYU1vc2E1OWFQRjU2aXdwc1EybUk0cUtuWkxpUUdvSXFo?=
 =?utf-8?B?bjJzK051SFNEYnJpMFhwOGdRb05JZVJsUVVOTmJ3VTd2SkNDcDU3eGdSSmIx?=
 =?utf-8?B?OE1ERHlrVzB6VmhxaHNtMnlWYlJGK0pRUVE3Z0tOWGQ2SC92V2JWRytVUlN4?=
 =?utf-8?B?aFZRYjh2dHdJZXNpR2E3NHhOOURGT3BIdjZyN2lUTWlpU05PTkhkcXNXNW1a?=
 =?utf-8?B?bzdhK3VXa2poYzNyeE1aUnFNOWRES2UyZWJ6UnMwcng1TSt1UWJpU2djcC9W?=
 =?utf-8?B?MVVVTlBGU2ttbXJ1ZlI3MW1BYXhvdkI1S0N5ZEJlK0xKMnpWbXpXYytaaG4x?=
 =?utf-8?B?ekZDM3FXSkYxKzRUUzhOY2Y0TnIzVnEzQVhhRmJkUVdyVkdHdEZ6OGJyak5m?=
 =?utf-8?B?ZDMrMlRLRG9rZDQ0b1hkTlRiOGc1VmxRQUc0b0FJbFZEMUo2dDFHek1yNFJx?=
 =?utf-8?B?REhrRzhKdGoxT3piTVViN0s1R0dqYk5zRVFHZi9WZThNY0FvZXpuQUJsUHRw?=
 =?utf-8?B?eHZJZ0pkTndBNmh0ZmdrdWpxbVN1YU9BcW9wRTFlMFIrM3g0Q1k3eTJ5QWR6?=
 =?utf-8?B?dGpCY1haaS9nMUc3WUR2TUd1c3ozUDJkNmxHRDJBckxRMEpxSUMzSVpWOWY0?=
 =?utf-8?B?UFg5dEd4dkVGbi9rVDN6L0l0S0NTMmZxM3k4TWE4UGZwbkc4THR5UExOeHh3?=
 =?utf-8?B?bnVVQ0ZLdWZNbUpuM3RVdUFJUWxaaHA2V0tJbXd2aG1KcTVhK0R4MUpmUGho?=
 =?utf-8?B?bk9SOXNzcWx3ZG1QSFJVRFdHNlE5STVoM1pobXdaU0NSU2JxbHR6OGpJNXhi?=
 =?utf-8?B?d2VWU3RJbFRxcmdSekErTTJ0VVFtU3ZySXJLeWVSSU91VlhGWTR6S2NkQklr?=
 =?utf-8?B?MXBUVDVaRjV1S0w1YVUxMnpZK2FpU3VVUlRzbllCejVEbzVGYmpYL1JwVjRh?=
 =?utf-8?B?L3ZwcDZodUVHekVHdFFOMld5cnovVU51c09XREk3MGRMM3U3M2dFQzJraHZG?=
 =?utf-8?B?MmlmdEJLblNRMXk3cndqVEMxM050OEdrOVdzZFJSOWZ3MUxyS3ZBYjZwWE5t?=
 =?utf-8?B?OWxOUlJzL3d4WDFhOXpjWXU1VWc2YkJUNWJZbEhmK0c3bklBRjkvRXBjQnFi?=
 =?utf-8?B?aGx1ZzA2QVVMR0F0SVgrVUhoV2kxTUI2d29XL2xUMEZKd2MzOG5jbG52OE5E?=
 =?utf-8?B?cmpjeVllWlduYnBrQXppdHNuS0dPMW9LV2xhMStmdWlxR0JIVlBpSXh2cVBP?=
 =?utf-8?Q?lrtBJsQYOgoPgaRgPxH29Rw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B0A1C83EAA3B549A9CB7FC671886804@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f615777-8361-4e8d-c65e-08d9ab731dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 15:41:55.6793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YB8ztCVq5kD3NmZljuu2oB+JcAWGiJNcVBwefbLp7OZLNE3g0hT8XUojR/dnouTRyiturMpgRv4+NrhDpbARmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5005
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgVGhvbWFzLA0KDQo+IE9uIE5vdiAxOSwgMjAyMSwgYXQgMjoxMyBBTSwgVGhvbWFzIEdsZWl4
bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+IHdyb3RlOg0KPiANCj4gSnVuLA0KPiANCj4gT24gVGh1
LCBOb3YgMTggMjAyMSBhdCAyMzoxNywgSnVuIE5ha2FqaW1hIHdyb3RlOg0KPj4gT24gTm92IDE3
LCAyMDIxLCBhdCA0OjUzIEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3
cm90ZToNCj4+PiANCj4+PiBJdCBkb2Vzbid0IGhhdmUgdG8gaGFwcGVuIGluIGN1cnJlbnQgcHJv
Y2Vzc29ycywgYnV0IGl0IHNob3VsZCBiZQ0KPj4+IGFyY2hpdGVjdHVyYWxseSB2YWxpZCBiZWhh
dmlvciB0byBjbGVhciB0aGUgcHJvY2Vzc29yJ3Mgc3RhdGUgYXMgc29vbg0KPj4+IGFzIGEgYml0
IGluIFhGRCBpcyBzZXQgdG8gMS4NCj4+IA0KPj4gMy4zIFJFQ09NTUVOREFUSU9OUyBGT1IgU1lT
VEVNIFNPRlRXQVJFDQo+PiANCj4+IFN5c3RlbSBzb2Z0d2FyZSBtYXkgZGlzYWJsZSB1c2Ugb2Yg
SW50ZWwgQU1YIGJ5IGNsZWFyaW5nIFhDUjBbMTg6MTddLA0KPj4gYnkgY2xlYXJpbmcgQ1I0Lk9T
WFNBVkUsIG9yIGJ5IHNldHRpbmcgSUEzMl9YRkRbMThdLiBJdCBpcyByZWNvbW1lbmRlZA0KPj4g
dGhhdCBzeXN0ZW0gc29mdHdhcmUgaW5pdGlhbGl6ZSBBTVggc3RhdGUgKGUuZy4sIGJ5IGV4ZWN1
dGluZw0KPj4gVElMRVJFTEVBU0UpIGJlZm9yZSBkb2luZyBzby4gVGhpcyBpcyBiZWNhdXNlIG1h
aW50YWluaW5nIEFNWCBzdGF0ZSBpbg0KPj4gYSBub24taW5pdGlhbGl6ZWQgc3RhdGUgbWF5IGhh
dmUgbmVnYXRpdmUgcG93ZXIgYW5kIHBlcmZvcm1hbmNlDQo+PiBpbXBsaWNhdGlvbnMuDQo+PiAN
Cj4+IFN5c3RlbSBzb2Z0d2FyZSBzaG91bGQgbm90IHVzZSBYRkQgdG8gaW1wbGVtZW50IGEg4oCc
bGF6eSByZXN0b3Jl4oCdDQo+PiBhcHByb2FjaCB0byBtYW5hZ2VtZW50IG9mIHRoZSBYVElMRURB
VEEgc3RhdGUgY29tcG9uZW50LiBUaGlzIGFwcHJvYWNoDQo+PiB3aWxsIG5vdCBvcGVyYXRlIGNv
cnJlY3RseSBmb3IgYSB2YXJpZXR5IG9mIHJlYXNvbnMuIE9uZSBpcyB0aGF0IHRoZQ0KPj4gTERU
SUxFQ0ZHIGFuZCBUSUxFUkVMRUFTRSBpbnN0cnVjdGlvbnMgaW5pdGlhbGl6ZSBYVElMRURBVEEg
YW5kIGRvIG5vdA0KPj4gY2F1c2UgYW4gI05NIGV4Y2VwdGlvbi4gQW5vdGhlciBpcyB0aGF0IGFu
IGV4ZWN1dGlvbiBvZiBYU0FWRSBieSBhDQo+PiB1c2VyIHRocmVhZCB3aWxsIHNhdmUgWFRJTEVE
QVRBIGFzIGluaXRpYWxpemVkIGluc3RlYWQgb2YgdGhlIGRhdGENCj4+IGV4cGVjdGVkIGJ5IHRo
ZSB1c2VyIHRocmVhZC4NCj4gDQo+IENhbiB0aGlzIHByZXR0eSBwbGVhc2UgYmUgcmV3b3JkZWQg
c28gdGhhdCBpdCBzYXlzOg0KPiANCj4gIFdoZW4gc2V0dGluZyBJQTMyX1hGRFsxOF0gdGhlIEFN
WCByZWdpc3RlciBzdGF0ZSBpcyBub3QgZ3VhcmFudGVlZCB0bw0KPiAgYmUgcHJlc2VydmVkLiBU
aGUgcmVzdWx0aW5nIHJlZ2lzdGVyIHN0YXRlIGRlcGVuZHMgb24gdGhlDQo+ICBpbXBsZW1lbnRh
dGlvbi4NCj4gDQo+IEFsc28gaXQncyBhIHJlYWwgZGVzaWduIGRpc2FzdGVyIHRoYXQgY29tcG9u
ZW50IDE3IGNhbm5vdCBiZSBmZW5jZWQgb2ZmDQo+IHZpYSBYRkQuIFRoYXQncyByZWFsbHkgaW5j
b25zaXN0ZW50IGFuZCBsZWFkcyBleGFjdGx5IHRvIHRoaXMgaGFsZg0KPiBkZWZpbmVkIHN0YXRl
Lg0KPiANCg0KSeKAmWxsIHdvcmsgd2l0aCB0aGUgSC9XIHRlYW0gb24gdGhvc2UgKGkuZS4gcmV3
b3JkaW5nIGFuZCB0aGUgY29tcG9uZW50IDE3IGlzc3VlKS4NCg0KVGhhbmtzLA0KLS0tDQpKdW4N
Cg0KDQoNCg0KDQoNCg==
