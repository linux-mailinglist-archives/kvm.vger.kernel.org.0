Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A381B39D3A4
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 05:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhFGDwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 23:52:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:11120 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhFGDwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 23:52:55 -0400
IronPort-SDR: tGz1TawEHOHwP++fkK/QZdT8NU8CkkVag/TTiRvRXKauqeTXMVwvswoFFfcrxDLCIdD0EtQ1Z0
 laPO9PzV6wjA==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="184237423"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="184237423"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 20:50:58 -0700
IronPort-SDR: vihYOprQ0xPonVf/MqttbddJoucKykUrf+9zqaL7+K8B0tZG1HRFNN1KaxYfy7ggFdi/JgY+1g
 AEYA7bHWNT+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="468949988"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2021 20:50:58 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 20:50:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 20:50:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 6 Jun 2021 20:50:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 6 Jun 2021 20:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhSWIDznk61QT9FbU4HHVLOow/mB+PL53/SsxTJSYRWQTR5cEJfPwNvX0eiyDBN0G/LHWnFrVhFtlwpn4WgGUEcDZWZHRTRdOE+3o0KOmAACIIKmw2J2n5NdwjM4Wnrja5QxIHyONuorlaaDLU3ixwWNbl/hBigAOV144ISVfLvmBPSRk3+T/haq+dq+be0WzAH3TXA/Km7jM0txmMvF04fI//gujQGQE0lpI8o+qDoSAV4uVND1u0huIRccItRfcVkvzKyOmiE2GdMvm71HPeW2YeEfvebLkJPaJWnhKxDUCFUHDU1xCnsNxMAE7oKyNsWOHzBx3sTrEvTPIb5Ffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWs6WICC/G6I9jJx7wmbUk4UcsQolsp3jHtYBFeeHYQ=;
 b=CxyJROGy6/bIfyu/p9/eEtj7GufW44rY1kPwWSTEWBOoCthDYAl9DoSCvVZ/tPa20jUgeqSP//vhvpP9x5Ep16YzVneF+SwB6LxOCCUkNTgsK9Z+nd0uWmpDkwgUnmI5XapvZ5Q5fEcJM2udO9vdj5j8KTMVQTcV8lflb4Ot/4bZ1WWldynCIVFizLnsxLanGF0EvShbWf3UyWeexPCIJptnFlJAAO3B4wipXsgOdnL/C25LFr9MC7pdxnZ+B+djaqRQFrhJJYjJ7n+XXkCwP8Vyneo2s4uw6/cC+jBTHDK9iCX8L+xWq4gtjvnZEYnYfaJ/h+qiaI1vAjwa7r0Kfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWs6WICC/G6I9jJx7wmbUk4UcsQolsp3jHtYBFeeHYQ=;
 b=I2ePOrI9RAxR1O/x/kmQRMTC4gohkK45IpzejKHfZrbdYYCgtoT4SoQj1ZTzpNctxVPhboFDJP5sOsR7nAsgFEvqS9hK81EoIMp4oi4vmL8I5/q65ZnO6+cF6kBBqerVPmdpk/TzuT5ZqDCxup+Vby8odUfwaIfuFGoOqPtKsAU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:95::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 03:50:54 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 03:50:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAFF14gAAPozMAAABMSwAAA0bJgAAVeTBAAAlp0QAABjX0AAAAf0IAAABWuQAAAD8IgAAAOC4AAABA0oAAAn0sgAAbQLqAAF5vapA=
Date:   Mon, 7 Jun 2021 03:50:54 +0000
Message-ID: <MWHPR11MB1886503741ED16CDFB2CDE258C389@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
In-Reply-To: <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf0c5a33-a244-470a-7880-08d929677383
x-ms-traffictypediagnostic: CO1PR11MB5140:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB51404E6EC3D87281B2B124E68C389@CO1PR11MB5140.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eBUJHM+fy/+dDIdfOlUEjDsouY7TVE9b1H+wlD+GmsPwUBMI1nYq6gpoKYvSgYt9wGyjj5DpdsG+s0P1oute01I5zM3yg2gBRrVrlj/RU5xHJliq2LrM7Ix601wPhGgNBFy0GZv7gGnbvPQNdW16JWlP2Lv0Dz6BHTi8A/Q0yzzeoB5RhXWcqR/UE3Sfa7IVw2H548qrJPAXgNdB19Dl5k/F27BLXauUnDFcwxOlUDzmmnG2v5/N4Sv4OyGhHbzGou2EDVwL3tugAAEI5UmCC4MiN5/6AsBA5rJHC6PkLGKD9ViX34I+g7hmPn16+yM93jWyIkg8Q9n3uUhk90ppdIRfANGjZDFOfDzxOc1i3pD9ciNwWK6nTF7mhBhdSERAp1pE0fZ5kJX5uslFnGNxqVPkaYrdKxgMrgdPEo9nHxmDJyqGegmFafrL3wV66t0tgKQh0YQTc/BsJEsm9dDl/VHN9D/xnq54Jp0G3ZRo+ENUWC/6nYqa1iDYtKb04eVAHjeGJd4P7XSEoG5WcV81HfrLCDMXQmdH8seRyGDFcHfn39Oy4ay/h8CHNdtpKUW79SVFzPoSGwEUFTlLaOCKI/U7SoU4GEeNxgIz54Z6tF8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(346002)(136003)(7696005)(316002)(64756008)(66476007)(7416002)(26005)(186003)(66556008)(66446008)(86362001)(4326008)(52536014)(5660300002)(71200400001)(66946007)(110136005)(54906003)(6506007)(33656002)(53546011)(76116006)(478600001)(55016002)(9686003)(83380400001)(8936002)(8676002)(122000001)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bzhvRElSVHg3cHUxMEZjNlJ2dnh2NjNJOG1PWkwrOTZkV21Ld2hxYzd6Sm5H?=
 =?utf-8?B?WWpTcFQ4QUVEOXVzS21MUngzK3d1eWRpUVV4bzBLRUN6ZjBNWDBMOExsemZ4?=
 =?utf-8?B?OFVTS1pGbUIvQWcrTC9ES1ZLV1NOWGVmRmM2N1dKblhTQzNDRVhET1NtSHRq?=
 =?utf-8?B?ZHQvTS82Z1BiaFFXb0NXNEF5RlNGSS9Ub2czNGVLT243WnpPWjdHQkNRYWk0?=
 =?utf-8?B?ZUVLbldudkUwRFNGTGM4UmllRVd0ajgrNFpXQkJEV0d3TTZSSVRrY1BSTk4y?=
 =?utf-8?B?NW5vaXVFWHpOdkkvU0V5bFlDM2dUVDJ3dGNQU2d0bTdjT2hMNlZTN0xSWnJp?=
 =?utf-8?B?dU1Ma3JObUZnTkhmSEpMa0tKS1YyM0pZWkJmR3lDS2J0VEppMW1qSXYvU0JU?=
 =?utf-8?B?MEl0RXk1TVQzY2oweVI4UWlzS2dhYW1lZVIyUXhNOUZmN1J2Q2QxQjd3TVBP?=
 =?utf-8?B?aDVlazZFSmlzSDZyY0ljUWxLeXVUMThrbXUyZ0gyOTVqcVZxU1UxV3VqQUd5?=
 =?utf-8?B?WGhVMVhTVzhIV3pLWlkwNVJqd01teEtQZ2ZveHJWRTcvOGQ2QWJTVkVCK1hH?=
 =?utf-8?B?Qk1BV1RsdEtlVTlVdG1rZ2V0cnJwYXQybVBDTWJMQ1JFbWczSVRLVVhvVFh5?=
 =?utf-8?B?cUM1ZHU5dHE1TWd1TmFOWnZhRVlOaEhkOFZXcFBEQjhqUS9NcTlPa2ZQUnJO?=
 =?utf-8?B?bTh1MS84ZEVYbk1NWCtoMzliNXB4b09YU0crQ0YvVWZQZG54bXZCNG81aFdN?=
 =?utf-8?B?UFJZSnBNTUdRTkYzR0wxNDhmOG1KMEh1VWpHRWdVZERPQ1lWbUxLOUoxZWJ4?=
 =?utf-8?B?S2lDNm50d0JaZG9OcXhrTkVLWjVGMCtvajcxa0N0T0hiMjRxQWZHUS83Z0ly?=
 =?utf-8?B?a2xqM2xCMFFXdzlRME5tY3podzQ4aG14YkxhTGttZW9LSXd3Tjg5RCtPemFs?=
 =?utf-8?B?VWc2dEJBN2JRRFpvTmJSWllFRStsUHk2aGxKTFlnL3h5bFU5MDlpQVF6MlVj?=
 =?utf-8?B?SDdpcmp6dGtmWXRiMTdQVWI1UWVTclloM2pZT0VVZ1BEUjRQN0tUTU9kaGQ4?=
 =?utf-8?B?dmpPYkZhRkpmVXBpaW9xc3FhWXZrL0hFVmllQVRoL3V5b2VPMnJ6WUxid3gx?=
 =?utf-8?B?VU1CVnBPRDVuUnlqalVacW1nblQzbDRHTm9QQkV5aGVhRjNPenQ5NmQrRG1Z?=
 =?utf-8?B?SWR5d0MxdlYrSXMweFcvYlJaTEdXY21rdk9UZXh1UnhkTTFyWlRZODduS1RD?=
 =?utf-8?B?Q0EvRVZKcERKWUxteDduTHlLSDBFSzErbVlOV2VDM1JKblQxZ0h0Q1RLWmRZ?=
 =?utf-8?B?NW5ZUEQwdG93MkZBTUpPb1pPcENORVV4bUEzbFphYlNma2RoWkZqUmJkbUFS?=
 =?utf-8?B?MG9yVTNXNWdjQ1RQUFY0NEs2bUE1QlluRGN4Z2ZWMmVpRWxYcGVDSG5PcHB6?=
 =?utf-8?B?S2hRaHB6alVVK0s5Q3NMcW1kUmxlaFNSU1ZGUm02R3FJSVJhTVliYlBmUzcy?=
 =?utf-8?B?NjBHR2w3djV5eHZnZnZFRVhrVllaQnN0ZUUwVVRBNW5rYmtzY1dtbStBa2o1?=
 =?utf-8?B?SldpM3ZLU280NnR6SWIwcEFDOWZ6akJSMDJmSXp5dUpCR1p0QUJVVFQ3WG1L?=
 =?utf-8?B?RVg4bFJLU3Nwb1F0YVBQNjZqZ3RMSjhKUWp5YWZLQnBJSG9XZzdXOUtBOUpW?=
 =?utf-8?B?YU90WU9lSU5RS2NlbjdVdGE4L1hLWTZDWkp3VXlSdEFlZHhDR1BrNVdIdVJB?=
 =?utf-8?Q?WjAS0Mq51mxa6jOpUM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0c5a33-a244-470a-7880-08d929677383
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 03:50:54.2473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Q7aT4vfo892hUtOJjtToD37HR+NMBxUhYc4pP9TkcwnEeZ6OqeDuNPjhe0NYm8AvYDS6aL7DqIBjZgf+qttPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5140
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgSnVuZSA1LCAyMDIxIDI6MjIgUE0NCj4gDQo+IE9uIDA0LzA2LzIxIDE5OjIyLCBKYXNv
biBHdW50aG9ycGUgd3JvdGU6DQo+ID4gICA0KSBUaGUgS1ZNIGludGVyZmFjZSBpcyB0aGUgdmVy
eSBzaW1wbGUgZW5hYmxlL2Rpc2FibGUgV0JJTlZELg0KPiA+ICAgICAgUG9zc2Vzc2luZyBhIEZE
IHRoYXQgY2FuIGRvIElPTU1VX0VYRUNVVEVfV0JJTlZEIGlzIHJlcXVpcmVkDQo+ID4gICAgICB0
byBlbmFibGUgV0JJTlZEIGF0IEtWTS4NCj4gDQo+IFRoZSBLVk0gaW50ZXJmYWNlIGlzIHRoZSBz
YW1lIGt2bS12ZmlvIGRldmljZSB0aGF0IGV4aXN0cyBhbHJlYWR5LiAgVGhlDQo+IHVzZXJzcGFj
ZSBBUEkgZG9lcyBub3QgbmVlZCB0byBjaGFuZ2UgYXQgYWxsOiBhZGRpbmcgb25lIFZGSU8gZmls
ZQ0KPiBkZXNjcmlwdG9yIHdpdGggV0JJTlZEIGVuYWJsZWQgdG8gdGhlIGt2bS12ZmlvIGRldmlj
ZSBsZXRzIHRoZSBWTSB1c2UNCj4gV0JJTlZEIGZ1bmN0aW9uYWxpdHkgKHNlZSBrdm1fdmZpb191
cGRhdGVfY29oZXJlbmN5KS4NCj4gDQo+IEFsdGVybmF0aXZlbHkgeW91IGNhbiBhZGQgYSBLVk1f
REVWX0lPQVNJRF97QURELERFTH0gcGFpciBvZiBpb2N0bHMuDQo+IEJ1dCBpdCBzZWVtcyB1c2Vs
ZXNzIGNvbXBsaWNhdGlvbiBjb21wYXJlZCB0byBqdXN0IHVzaW5nIHdoYXQgd2UgaGF2ZQ0KPiBu
b3csIGF0IGxlYXN0IHdoaWxlIFZNcyBvbmx5IHVzZSBJT0FTSURzIHZpYSBWRklPLg0KPiANCg0K
QSBuZXcgSU9BU0lEIHZhcmlhdGlvbiBtYXkgbWFrZSBtb3JlIHNlbnNlIGluIGNhc2Ugbm9uLXZm
aW8gc3Vic3lzdGVtcw0Kd2FudCB0byBoYW5kbGUgc2ltaWxhciBjb2hlcmVuY3kgcHJvYmxlbS4g
UGVyIG90aGVyIGRpc2N1c3Npb25zIGxvb2tzIA0KaXQncyBzdGlsbCBhbiBvcGVuIHdoZXRoZXIg
dkRQQSB3YW50cyBpdCBvciBub3QuIGFuZCB0aGVyZSBjb3VsZCBiZSBvdGhlcg0KcGFzc3Rocm91
Z2ggZnJhbWV3b3JrcyBpbiB0aGUgZnV0dXJlLiBIYXZpbmcgdGhlbSBhbGwgdXNlIHZmaW8tbmFt
aW5nDQpzb3VuZHMgbm90IHZlcnkgY2xlYW4uIEFueXdheSB0aGUgY29oZXJlbmN5IGF0dHJpYnV0
ZSBtdXN0IGJlIGNvbmZpZ3VyZWQNCm9uIElPQVNJRCBpbiB0aGUgZW5kLCB0aGVuIGl0IGxvb2tz
IHJlYXNvbmFibGUgZm9yIEtWTSB0byBsZWFybiB0aGUgaW5mbw0KZnJvbSBhbiB1bmlmaWVkIHBs
YWNlLg0KDQpKdXN0IEZZSSB3ZSBhcmUgYWxzbyBwbGFubmluZyBuZXcgSU9BU0lELXNwZWNpZmlj
IGlvY3RsIGluIEtWTSBmb3Igb3RoZXINCnVzYWdlcy4gRnV0dXJlIEludGVsIHBsYXRmb3JtcyBz
dXBwb3J0IGEgbmV3IEVOUUNNRCBpbnN0cnVjdGlvbiBmb3INCnNjYWxhYmxlIHdvcmsgc3VibWlz
c2lvbiB0byB0aGUgZGV2aWNlLiBUaGlzIGluc3RydWN0aW9uIGluY2x1ZGVzIGEgNjQtDQpieXRl
cyBwYXlsb2FkIHBsdXMgYSBQQVNJRCByZXRyaWV2ZWQgZnJvbSBhIENQVSBNU1IgcmVnaXN0ZXIg
KGNvdmVyZWQNCmJ5IHhzYXZlKS4gV2hlbiBzdXBwb3J0aW5nIHRoaXMgaW5zdHJ1Y3Rpb24gaW4g
dGhlIGd1ZXN0LCB0aGUgdmFsdWUgaW4NCnRoZSBNU1IgaXMgYSBndWVzdCBQQVNJRCB3aGljaCBt
dXN0IGJlIHRyYW5zbGF0ZWQgdG8gYSBob3N0IFBBU0lELiANCkEgbmV3IFZNQ1Mgc3RydWN0dXJl
IChQQVNJRCB0cmFuc2xhdGlvbiB0YWJsZSkgaXMgaW50cm9kdWNlZCBmb3IgdGhpcw0KcHVycG9z
ZS4gSW4gdGhpcyAvZGV2L2lvYXNpZCBwcm9wb3NhbCwgd2UgcHJvcG9zZSBWRklPX3tVTn1NQVBf
DQpJT0FTSUQgZm9yIHVzZXIgdG8gdXBkYXRlIHRoZSBWTUNTIHN0cnVjdHVyZSBwcm9wZXJseS4g
VGhlIHVzZXIgaXMNCmV4cGVjdGVkIHRvIHByb3ZpZGUge2lvYXNpZF9mZCwgaW9hc2lkLCB2UEFT
SUR9IHRvIEtWTSB3aGljaCB0aGVuDQpjYWxscyBpb2FzaWQgaGVscGVyIGZ1bmN0aW9uIHRvIGZp
Z3VyZSBvdXQgdGhlIGNvcnJlc3BvbmRpbmcgaFBBU0lEDQp0byB1cGRhdGUgdGhlIHNwZWNpZmll
ZCBlbnRyeS4NCg0KVGhhbmtzDQpLZXZpbg0K
