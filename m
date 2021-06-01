Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2129C396D2F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 08:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhFAGR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 02:17:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:19829 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAGR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 02:17:58 -0400
IronPort-SDR: w8+rJIMiyT6y97C/GyvcSEl3Pz/Oq05hLhVajT6h/lMKH4MNUC8vVEOF8s0TslqltgBVII+b6l
 8RTIOnvCJjoA==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="224754352"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="224754352"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 23:16:17 -0700
IronPort-SDR: 1UhZLJt6++71zMlZL3Ln9eOloZggA0dz8PmTSdqgh0cqd+4+yShqMLeL4ySp02XF+Se8RzeYn+
 NJtpFPgYjqKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="411128973"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2021 23:16:17 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 31 May 2021 23:16:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 31 May 2021 23:16:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 31 May 2021 23:16:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiGmjmTPLA17sSoZ9JcfCxSZCgfMxHNRPGbfWXDtIZ4CUne9PNLxeGkfmPj61C8JI3tlyG44N3cRNkNjU+uVPvjXPmWLdaN9eyRkbh94z5dIFdsPFpePB/QYj/xZPRdCIbKIOBFsvYQQFx6HP03Wc30bR2+DXDWd/OBfREvkMg5clK242p6NiEVlNDykSj1fkHOy1m5ekDrhPSJUzGu2428c5Czy1C5anSQl4S4Sl9mrQXPfbQMLM+T3it7Uu4sbQ7QJr3XLPp9ggNSBQv7TnXdTSJLrusQmSefTQRpa+vl0BEEvnlGbyZUpOuQk1D2NYcEGRR0PVyqodoe+46wimw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToQIp2XTMZrXOXYi/pf1C0DXkmIYZHOi10YWp+tgJuY=;
 b=Tkxw2bjt07vHmKs8Kcg+7MRH2GOaCt6bs/jDZxctNWhosHjJgeQmnSwAhkm8plNurvooTTYp27UGZzBAQwXj52iv0gbwX6XKYeSDoJxb6DpCfWZfzVq4OlOVSnfIlXsk2PiN4Q0ichZj7ipJh2BevpVQb2lw6kVHwGy3R2qX9e48cOaHhdIEofvtvoy0lbHDBCyCM3sflQYB7lfnz4XWpNjb9NPrDMtvIG+kH3JnfLdsc5CZ2r3bUO8Wo1Bb7h3ebQSmDFZx5YTmEtccJEuo8gV4YWblzyvJjC7B4qG97e9aBk4YAUHHE6Cdltt3k9YBmPWs7T4nO8Q7vn3X/hJrSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToQIp2XTMZrXOXYi/pf1C0DXkmIYZHOi10YWp+tgJuY=;
 b=c/pTlZCPlhmHrEkp5yau5kylhdzzKnqhj7vdtgHG6EVuPJkQ5K/Wf2MJMClO40cDwk1DXfwjHaq48PUryKnMnj1pzJh5ipkvu8E26Nj/T9kIRf8ByED/T3NGNUZfBucee7VyXxt8EYfw/Z22RP1eSFIQKYUElLF1dUH2dwWrksQ=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1406.namprd11.prod.outlook.com (2603:10b6:300:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 06:16:11 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 06:16:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwAm5asAAKQEygAAJY3uAAAB7iAAAANf0oAAAILVgAAAOmmAAABkvmAAAOnwgAAAHfPQ
Date:   Tue, 1 Jun 2021 06:16:10 +0000
Message-ID: <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
In-Reply-To: <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 883d8073-f554-45ac-4bee-08d924c4c05b
x-ms-traffictypediagnostic: MWHPR11MB1406:
x-microsoft-antispam-prvs: <MWHPR11MB1406BFFE16AD5A5EAAC534388C3E9@MWHPR11MB1406.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4L9uMqfcLCqtMPmQUEyGzlDfbiPoZvH/IYFKS/vZUgScLi2V2sXOmERQULB89mAESD1OowAaMTbZkW5k9578pe6tkFUnPx4KcZBZKwDP07zVhg4UCcPjHGlrWw9kAc9QtBDyVrf1FEj4hWeL6b0nRdKYBYt1zgG5nmfV7ACTfzrMBDWsXGw0QyeHKsoqeVylOIDWT4q6CChxmL8k3alrv7lE0ZpFELw48lJit5ohWo7EQE4HrEwHPyMAASDonhHITXRKYR9ETec18AwbF9uE6zCttcER8S7XfdbjndyLG67EsG9P7iC5ufa199OpWWhdh3eTkCzYNYjjUiQsxl0T7lJbkRe9pgA0QN36hQXsmsXFOm46g2rF36HKhnl6mTd6QcGl7oCGpS5f5oWysQ2XPqCFFROTR0cmWBFKNcI9RZg5+HV/yBckHGMWkua1bErpM6oO1Kmo1kKgXRCu3mrRkl4qD9OhbTTKXm/NF/Ak2meRs/FozEqnrXgh4hawPzLJxordhg5OFjf9fPHZ5+JUpKrWXM3Ltu8c2/q6VpSyP3oUySwel8671AfTT5lFlPBXJi6B1nvRqCdIxf22ZzY3nkTXj0/20vJGTa9s8AjAONQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(55016002)(5660300002)(9686003)(53546011)(66476007)(52536014)(66556008)(38100700002)(64756008)(6506007)(76116006)(110136005)(316002)(54906003)(66946007)(66446008)(83380400001)(4326008)(2906002)(33656002)(8936002)(186003)(7416002)(71200400001)(478600001)(7696005)(8676002)(26005)(122000001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NzdxcXNQb2JMRDUwNUhMWHR1cCt1TTlyTmE4VWN2RXl4QVdIc2R3VVFMTFgw?=
 =?utf-8?B?NVJVdmo4TW10N2dZeEp4Qi8zKzcweS9ZT0k5VmNlZC90dDF4Qk9QYTByVHFk?=
 =?utf-8?B?NHMwUkFXMkNCaGI0dTZxK0FGYllYZDc4c01kL1lYTWFHVU9qT2twY2E4VW92?=
 =?utf-8?B?emdPVWVnVjBYWnNCMVhKaG1FdkJKWDY5dlg2RHBJUWYrM2Z5MmFTcGJCMGFv?=
 =?utf-8?B?M3U0dG1uWjRnYWZ0ME5YbFJ5RkFwV0R5Rit0SkQ3RGhYK0FRWG1yZi9nNUZJ?=
 =?utf-8?B?R2oydHlGelhTeEZmSkRkaXNQZDZsUW14WXR3bm1MbzJUaUVUNlZGRi91TEpC?=
 =?utf-8?B?d2ZwcmMvK2dOZEswbDZiNnY2aVk2QnFvRkxDUFdiWi9tU2l4SlM1ckFRVk1m?=
 =?utf-8?B?aHhzZm0vRXFTOTZFUWFIQXcra1daTUNKUVp4Y1VGVjJoTXdiVHhZZXd5OERP?=
 =?utf-8?B?cEMvSHZPV1FxR3RDSjFPZ3hVK1QyeFNrVzhUWmo3VmtvMi9NYUVlRVlxZWFK?=
 =?utf-8?B?TlVyVDI2cnBTcVV6NmJodFVEUk91U2JmQXBubldWWHdGUzdyTXUvNStMYTJ0?=
 =?utf-8?B?ZlU3M1lkTm5IVUFaLzBPWmlWUW41ZEtoV0I3Zkt0cG1KR0lwWlg4aDhlUWlN?=
 =?utf-8?B?bFJVVExYK2hnRjhZNDJOdTZhcDB1eXVLclF3QUdrL2E1UmVaYXVzTHZ3Y29O?=
 =?utf-8?B?UW1uNTZjKzFSSnZJSGpNK3QxdTZscmkrT1VXaWRNaWFud3RlbDVCeHFIRHFU?=
 =?utf-8?B?ZWk4eGlid3orbEUzSmU0bE56aUE5dUFUeTg1TWlFNm9XUk9RekxyUDFQY09Q?=
 =?utf-8?B?RFhJdW5RcVh6U0FrT1lGeVhxOGlINlhrZCt0OXp2aC9tM3ozZEV5VW9rTEY2?=
 =?utf-8?B?b0NpM2ZaTFdKZ21ITWtVZm03ZmhrdHFaNW9mN2hoRnBkUjNnb0dEQmdXeXBa?=
 =?utf-8?B?NW9QeERRbGF2dEt3M3U1cjk5bXordTFUWmhJR0lDNmNaMU43amNZd0xXTm93?=
 =?utf-8?B?KzEvdHcybmRZUXVPVHpVMVlBUkZWTFpHdktuTkx6alU5NjU5UE1QU2NtWnlx?=
 =?utf-8?B?VjhuWlJDUmVERUVrbGRWR21YdVc5ZzA2RXpOdE9yUThZTW1aK0ZtMFhZd2Yy?=
 =?utf-8?B?Q1F0WGQ2SmtzTFdEbjJmMHhhY09PNkxiZkxZWGplNXV0M25EblcvU0xoMXQ0?=
 =?utf-8?B?VEVWcjNCM1FTYkM0M3RzUjkyblRlbG9SdU41SUJrUnNReVJtc0czWXRDQWpa?=
 =?utf-8?B?L0ZhdHRIbUkweG1MZGN2TDQ0OWZKNTA1QUgzdjNBdnZYZG5PNjhkUG9oN0F2?=
 =?utf-8?B?ZHJyU3J0MVY1L2kwYTBUbUF4U05SYWRDUEVIYUhyZ1ArMTM5VkZTeXE0YlUw?=
 =?utf-8?B?bWVkSUtrSkdTbGd6SnErbXJRdHZmNTVTYU9PbzdCUkZDMmpHd1FORDdQRXVI?=
 =?utf-8?B?TDZITzU0RUxJb3FIMmJDbHl4OUQ3UGxLT003SUwvR0lXVDdMdmVkRFJUNDRB?=
 =?utf-8?B?SFMxQ01tZTZCVGQ3aXM3a3B0S0luY3hpa1pwQndyZ1IzKzJJM2UvWDAzc2Uw?=
 =?utf-8?B?aWRUTmdIa3lDVE91THVuOXZJS1Z6UytDVjhubTBueWg5bitRN3RibHlWR2Uz?=
 =?utf-8?B?VHNrZkZUQ3p4VHVsMnR6OW9GK05VeDNOc2h1T0htQUNGNUFnaUdqdUhUWGxw?=
 =?utf-8?B?eERGZS9lVzBkTmtTemtsYlozRUEyV21UaThiVUJsenlRbHMwQTlHMTJkNG92?=
 =?utf-8?Q?bPW9sMR64Z/E4bwnVwoyGq6X67A8h/pLJiXnq0u?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883d8073-f554-45ac-4bee-08d924c4c05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 06:16:10.8274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x0QlU+jSwNMmGA2Ep507vhFIpAiY67iCLLIqka10ZcCeIvgBRo2E2nbWWLj/x4+SLXDjCvGofCqxU5I/TmHmyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1406
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nDQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMSwgMjAyMSAyOjA3IFBN
DQo+IA0KPiDlnKggMjAyMS82LzEg5LiL5Y2IMTo0MiwgVGlhbiwgS2V2aW4g5YaZ6YGTOg0KPiA+
PiBGcm9tOiBKYXNvbiBXYW5nDQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMSwgMjAyMSAxOjMw
IFBNDQo+ID4+DQo+ID4+IOWcqCAyMDIxLzYvMSDkuIvljYgxOjIzLCBMdSBCYW9sdSDlhpnpgZM6
DQo+ID4+PiBIaSBKYXNvbiBXLA0KPiA+Pj4NCj4gPj4+IE9uIDYvMS8yMSAxOjA4IFBNLCBKYXNv
biBXYW5nIHdyb3RlOg0KPiA+Pj4+Pj4gMikgSWYgeWVzLCB3aGF0J3MgdGhlIHJlYXNvbiBmb3Ig
bm90IHNpbXBseSB1c2UgdGhlIGZkIG9wZW5lZCBmcm9tDQo+ID4+Pj4+PiAvZGV2L2lvYXMuIChU
aGlzIGlzIHRoZSBxdWVzdGlvbiB0aGF0IGlzIG5vdCBhbnN3ZXJlZCkgYW5kIHdoYXQNCj4gPj4+
Pj4+IGhhcHBlbnMNCj4gPj4+Pj4+IGlmIHdlIGNhbGwgR0VUX0lORk8gZm9yIHRoZSBpb2FzaWRf
ZmQ/DQo+ID4+Pj4+PiAzKSBJZiBub3QsIGhvdyBHRVRfSU5GTyB3b3JrPw0KPiA+Pj4+PiBvaCwg
bWlzc2VkIHRoaXMgcXVlc3Rpb24gaW4gcHJpb3IgcmVwbHkuIFBlcnNvbmFsbHksIG5vIHNwZWNp
YWwgcmVhc29uDQo+ID4+Pj4+IHlldC4gQnV0IHVzaW5nIElEIG1heSBnaXZlIHVzIG9wcG9ydHVu
aXR5IHRvIGN1c3RvbWl6ZSB0aGUNCj4gbWFuYWdlbWVudA0KPiA+Pj4+PiBvZiB0aGUgaGFuZGxl
LiBGb3Igb25lLCBiZXR0ZXIgbG9va3VwIGVmZmljaWVuY3kgYnkgdXNpbmcgeGFycmF5IHRvDQo+
ID4+Pj4+IHN0b3JlIHRoZSBhbGxvY2F0ZWQgSURzLiBGb3IgdHdvLCBjb3VsZCBjYXRlZ29yaXpl
IHRoZSBhbGxvY2F0ZWQgSURzDQo+ID4+Pj4+IChwYXJlbnQgb3IgbmVzdGVkKS4gR0VUX0lORk8g
anVzdCB3b3JrcyB3aXRoIGFuIGlucHV0IEZEIGFuZCBhbiBJRC4NCj4gPj4+Pg0KPiA+Pj4+IEkn
bSBub3Qgc3VyZSBJIGdldCB0aGlzLCBmb3IgbmVzdGluZyBjYXNlcyB5b3UgY2FuIHN0aWxsIG1h
a2UgdGhlDQo+ID4+Pj4gY2hpbGQgYW4gZmQuDQo+ID4+Pj4NCj4gPj4+PiBBbmQgYSBxdWVzdGlv
biBzdGlsbCwgdW5kZXIgd2hhdCBjYXNlIHdlIG5lZWQgdG8gY3JlYXRlIG11bHRpcGxlDQo+ID4+
Pj4gaW9hc2lkcyBvbiBhIHNpbmdsZSBpb2FzaWQgZmQ/DQo+ID4+PiBPbmUgcG9zc2libGUgc2l0
dWF0aW9uIHdoZXJlIG11bHRpcGxlIElPQVNJRHMgcGVyIEZEIGNvdWxkIGJlIHVzZWQgaXMNCj4g
Pj4+IHRoYXQgZGV2aWNlcyB3aXRoIGRpZmZlcmVudCB1bmRlcmx5aW5nIElPTU1VIGNhcGFiaWxp
dGllcyBhcmUgc2hhcmluZyBhDQo+ID4+PiBzaW5nbGUgRkQuIEluIHRoaXMgY2FzZSwgb25seSBk
ZXZpY2VzIHdpdGggY29uc2lzdGVudCB1bmRlcmx5aW5nIElPTU1VDQo+ID4+PiBjYXBhYmlsaXRp
ZXMgY291bGQgYmUgcHV0IGluIGFuIElPQVNJRCBhbmQgbXVsdGlwbGUgSU9BU0lEcyBwZXIgRkQg
Y291bGQNCj4gPj4+IGJlIGFwcGxpZWQuDQo+ID4+Pg0KPiA+Pj4gVGhvdWdoLCBJIHN0aWxsIG5v
dCBzdXJlIGFib3V0ICJtdWx0aXBsZSBJT0FTSUQgcGVyLUZEIiB2cyAibXVsdGlwbGUNCj4gPj4+
IElPQVNJRCBGRHMiIGZvciBzdWNoIGNhc2UuDQo+ID4+DQo+ID4+IFJpZ2h0LCB0aGF0J3MgZXhh
Y3RseSBteSBxdWVzdGlvbi4gVGhlIGxhdHRlciBzZWVtcyBtdWNoIG1vcmUgZWFzaWVyIHRvDQo+
ID4+IGJlIHVuZGVyc3Rvb2QgYW5kIGltcGxlbWVudGVkLg0KPiA+Pg0KPiA+IEEgc2ltcGxlIHJl
YXNvbiBkaXNjdXNzZWQgaW4gcHJldmlvdXMgdGhyZWFkIC0gdGhlcmUgY291bGQgYmUgMU0ncw0K
PiA+IEkvTyBhZGRyZXNzIHNwYWNlcyBwZXIgZGV2aWNlIHdoaWxlICNGRCdzIGFyZSBwcmVjaW91
cyByZXNvdXJjZS4NCj4gDQo+IA0KPiBJcyB0aGUgY29uY2VybiBmb3IgdWxpbWl0IG9yIHBlcmZv
cm1hbmNlPyBOb3RlIHRoYXQgd2UgaGFkDQo+IA0KPiAjZGVmaW5lIE5SX09QRU5fTUFYIH4wVQ0K
PiANCj4gQW5kIHdpdGggdGhlIGZkIHNlbWFudGljLCB5b3UgY2FuIGRvIGEgbG90IG9mIG90aGVy
IHN0dWZmczogY2xvc2Ugb24NCj4gZXhlYywgcGFzc2luZyB2aWEgU0NNX1JJR0hUUy4NCg0KeWVz
LCBmZCBoYXMgaXRzIG1lcml0cy4NCg0KPiANCj4gRm9yIHRoZSBjYXNlIG9mIDFNLCBJIHdvdWxk
IGxpa2UgdG8ga25vdyB3aGF0J3MgdGhlIHVzZSBjYXNlIGZvciBhDQo+IHNpbmdsZSBwcm9jZXNz
IHRvIGhhbmRsZSAxTSsgYWRkcmVzcyBzcGFjZXM/DQoNClRoaXMgc2luZ2xlIHByb2Nlc3MgaXMg
UWVtdSB3aXRoIGFuIGFzc2lnbmVkIGRldmljZS4gV2l0aGluIHRoZSBndWVzdCANCnRoZXJlIGNv
dWxkIGJlIG1hbnkgZ3Vlc3QgcHJvY2Vzc2VzLiBUaG91Z2ggaW4gcmVhbGl0eSBJIGRpZG4ndCBz
ZWUNCnN1Y2ggMU0gcHJvY2Vzc2VzIG9uIGEgc2luZ2xlIGRldmljZSwgYmV0dGVyIG5vdCByZXN0
cmljdCBpdCBpbiB1QVBJPw0KDQo+IA0KPiANCj4gPiBTbyB0aGlzIFJGQyB0cmVhdHMgZmQgYXMg
YSBjb250YWluZXIgb2YgYWRkcmVzcyBzcGFjZXMgd2hpY2ggaXMgZWFjaA0KPiA+IHRhZ2dlZCBi
eSBhbiBJT0FTSUQuDQo+IA0KPiANCj4gSWYgdGhlIGNvbnRhaW5lciBhbmQgYWRkcmVzcyBzcGFj
ZSBpcyAxOjEgdGhlbiB0aGUgY29udGFpbmVyIHNlZW1zIHVzZWxlc3MuDQo+IA0KDQp5ZXMsIDE6
MSB0aGVuIGNvbnRhaW5lciBpcyB1c2VsZXNzLiBCdXQgaGVyZSBpdCdzIGFzc3VtZWQgMTpNIHRo
ZW4gDQpldmVuIGEgc2luZ2xlIGZkIGlzIHN1ZmZpY2llbnQgZm9yIGFsbCBpbnRlbmRlZCB1c2Fn
ZXMuIA0KDQpUaGFua3MNCktldmluDQo=
