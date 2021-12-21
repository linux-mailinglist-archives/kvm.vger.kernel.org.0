Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8FB47BA08
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 07:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhLUG3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 01:29:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:58488 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230245AbhLUG3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 01:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640068154; x=1671604154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jdVBf/PEDb/6Gl2phrUMZEh8gwq+pBALqH1KMx9pNK8=;
  b=I/gEafnmNWblaHs4o5FlUFL48ip3hr5FyrbuZdzrMaNq2lamNW8Fvc7B
   rAgghJ2kaFYO22EWmsNMp/PifgxLwMPHRuev2COTt+jDre1QrKvKpeEHY
   r6H2Sh2akumFPU+tVbNoSkmB425Rwfw9dDZMgbL0ocE3E0V44YJJs0abv
   Ttn7x3LOsNM2/vrBRFJI5n1iekFPSq20Nhf3A/Yg5WJ7Fhoa6ty311UVP
   gtAPQrHu2vlHB836DPJia50LVcccLz9lEZyRq8CVAmuke9t+tX3z3p2fc
   Sig5Mj5VM5lxAOuAkzSVG3WurlbEIlwJK2wdBy2MtMm1UuBAMikabC4EZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="220347921"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="220347921"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="466193170"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 20 Dec 2021 22:29:13 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 22:29:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 20 Dec 2021 22:29:13 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 20 Dec 2021 22:29:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPy6k57D2BvJ0lpWN9bZktkboqM4JxVu9AGHtGyCLYPC4qPRY2IzhPfoG0yjL0ZQN+m1csQW/v+pAyXsKMHYmok0M2w4yhCbZCSqVSwxuv6vv4fqd2t8pKw6pGxVhfljCT+SCoJXj1bBfE7AR42Wk+9iA5lQXcdXQTWRboZoKq1d7jtHIb15wIKX+o1t12i9O1y3dC+NSaDroL0xhVESss7M6VJZ1DqTyZDGhVNODIFvs7duZOAKgaVFupkNULQ6o1UJ5iErkuO3ChsyrkhTI/kXr/7cQohTVGjUzNu3js42URJjKukycE7OFS3OEQwOkl/fJ0ujrlTaaPJceZ+BGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdVBf/PEDb/6Gl2phrUMZEh8gwq+pBALqH1KMx9pNK8=;
 b=RlHiDvXaXX5T/Q2Tb/NhmIEnFY+IJKwxvHykU3MAPyypnO9FJwntwURVcQ0zPA9EkJCzGSTwYviaVAhLIWu9TOEbLpmWNitslCiWzKu5tQXCIBI04xmZ5XOjQpeLrWr+/brUy8sPe1g24GmoIKNmlTmBTSlNT7fUisyHu+mtGHqUPjdE8pk5ha2m/UinRrqXRgUvb4g9nX5PqvYjCZvhOUGtEM36AR5uLTWk8Mgsd0LbuZIglw7wo1awaMyoiI5JvSHODdnk1XpfwFTQYhkkmK0zu/vz/yp/NwLKl3wnYFsiKSSrWqIzW75o0sJj2MOtk+AOP5xvX7Q/UeipeZg9GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MWHPR11MB1760.namprd11.prod.outlook.com (2603:10b6:300:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.19; Tue, 21 Dec
 2021 06:29:06 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059%12]) with mapi id 15.20.4801.020; Tue, 21 Dec
 2021 06:29:06 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Thread-Topic: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Thread-Index: AQHX81sJtssEIr/APEmXmcVUJc1dj6w7G7CAgAFWU4A=
Date:   Tue, 21 Dec 2021 06:29:06 +0000
Message-ID: <MWHPR11MB12451924FE9189E4B69E78A4A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-24-jing2.liu@intel.com>
 <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
In-Reply-To: <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b33227f-f089-4452-b809-08d9c44b30ac
x-ms-traffictypediagnostic: MWHPR11MB1760:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB17609DCA0C59A7756427E349A97C9@MWHPR11MB1760.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtXu1e0qb1aNkRIHaXiYft/CX2kMvYJKRVJDetkAuW2tJh1lp1gW+lw7z5ox0MOXqPbnsNGcR59HaKKeTPelx5FtQ7+sPy/3VMScb8S7GJHprphUweSpHmPaazY0h1id+Ynn1/mTPgiMF4a5si6d6SsLbXdqkwkel4C7DsRaD7EKndveVhKzZ/KAVkytE6EKE6psKkz6kT79DblWoixzT1KDM3C1HmT9TeERhzvms5da4poeLN0+ulP1pANN0lRpQBYDB/S6UMCqWYnUekUGmfj3ic1wq6oZyizmL4RVSOBTK7LX5oVdTay0mmemNtaX8EI3L4yH+L3zNuZSkfjjEaf8Q5mcVvzASSLrBJl3se7XH4ji6YAbgElvR3EABz/MMOcb4XbrNMfd1yvAyaG6SvfoPkEvTLf0XJddZAdbnv147fNQnf6IvXWzhqXPLavkRu8sEluhPxuCDVftLKNh2Q5DglD2C6wOAbJh8p/9RPZ8lgGLVW7HWj6zqWPkihMPDWrZMUR+JvmzkvwRLUqm/HiruvLZfE7/z+CnLpDiVv7PLEADXFutDNkTIsVjzplcncf7FcolD/wambpFIqzO+PKTSZU3NO3B0g315zUd8urDOydP7gTfYfjftqeBji+g2d+ZUGtehBSJcoq4s+DczTA43Z3es+UZ6bYJKN9f1TT/NyZjCHeHcHCdsqWAcTdpV8q/wG1yfiIWPlAOs09r8/va/bgbMTLLThfT3HRDVYU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(186003)(110136005)(7696005)(26005)(82960400001)(9686003)(38100700002)(54906003)(7416002)(83380400001)(86362001)(5660300002)(122000001)(66556008)(38070700005)(8936002)(6506007)(71200400001)(64756008)(66476007)(66946007)(4326008)(52536014)(53546011)(33656002)(316002)(76116006)(508600001)(55016003)(2906002)(66446008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXcrVHZTT3NESGk5cE9TRkJFZE9abHhlUHh0Qy94RndtUkt3M1FURWg1WGZx?=
 =?utf-8?B?Qno3YjN6UURhSW04YXE5cWVnUlAzSkM3aDFOMVRmQ2VkMm4wZkRFSlF5NjZS?=
 =?utf-8?B?YWl2YllYMGdOVStNYmNlREpvZDgvMDYzV1Uyc284R1h2RTM1aFdzdGpTRTV1?=
 =?utf-8?B?SVJ6Nnp1Z3hMMTBjbnowV3pVMEM1c2V6Tk1XMkYrd0VFTFpxcjN0NWZGcXBh?=
 =?utf-8?B?VEdPTUNCOG04Q0R6TVdGbzhjcHplWTNsVUdkTUphSTNjcmZzblMvdGNYL05H?=
 =?utf-8?B?aWVZUnJIeEJBbDZXTzM0U1ZMMHVvaUthYzFURFYvM3R2WG9lblZyZ1U2ZHhl?=
 =?utf-8?B?Sy9RK1J2am42S29HcVNZbUltY3NYak9pYUxlT0o3aTZVSGlmNEVUSVIwejBu?=
 =?utf-8?B?MkF0Ni9BVVB2YzNHUWxFRkdIYnBPSVd2eDc3WU5uMEJoeVlpWW1YZy9FTldt?=
 =?utf-8?B?SVhDQXFseFNabU81enVRdWY3OWxvYmM1QVN4Z2d1VzhzSm1yUk5Sc1JiQ2Ew?=
 =?utf-8?B?V1FpakJ6b2FqUVN3cXM3UER0a21VdGtRMHY2RnhuRUZEOVhYMGlETWhOcVcr?=
 =?utf-8?B?TEl5QXFTTEtOZjQrMktaQnFZSm1nS0J0OC9YU3p5bW1JWTF3eTUzQytDcXM2?=
 =?utf-8?B?ZEtObkhnOU5IcnZHY2FJZm1IVFFtRmtlRGhnYXJSVCtjYW1FcE93bUNSNm9a?=
 =?utf-8?B?NlFUUVlnakVubUprUXIyMFF3S0VxRG1iN3JLaWpFTGdndEhrbFE3YTM5T2d1?=
 =?utf-8?B?aktiQUFBK3d5TUlMV2k5Y2VSUmxES0ZlcDQyTnUzeUZOcjlCSzN6VjhHd09m?=
 =?utf-8?B?QUJLZU9Jc3ZOSnBscWpjYkltaVZ2SmVrNFM3WGdaT2UweFNPVFdNTkFUem9o?=
 =?utf-8?B?Yng3UlNPdU9xOFFWaU9XdTRTYVVPcEkzWjJOdUZVMTJVTzRsUlFPa2dLSHY1?=
 =?utf-8?B?dlFHSWVCTi83aXJzSTRNc0xzMmY1dmZmV29FK0NUdTA5OXIrZGRmcXpuQnl5?=
 =?utf-8?B?aHFESzBWTDgzYlFXM1lhVlZNZ3dnU3dQTFVUdWRWNjkzRDRPSSttdkh3NW1W?=
 =?utf-8?B?T2RTVXU2OWJyRjJHd2tJdnVnODhjdEpkMDB3Y2ZOcFp4ang2NjFPY1M2Mk1x?=
 =?utf-8?B?YU13elZDVWcvMnplQncxbzZOWjhaeTBXeXdsYmtpSzFvT0h0N0NiU0duWU1h?=
 =?utf-8?B?QUFxZ1d3Y2x2amo1RnFpQ3lGNDhUVUliYllkNVM0M1ZDRDRvcE82RVpMcE1t?=
 =?utf-8?B?dStNYXRSTXlUcVhZVS9JcUh2MUQ5ak1oV1BQZkFEWlh2ODdXYnVHaTB3OXQ1?=
 =?utf-8?B?QnM3UUg3OHplU2p3M21yckVacU5nanVrOHFEZWJEb1JudUV0NjVBL3REbHg4?=
 =?utf-8?B?RWhVSUVBeEx0aVJqblY3aFIwdVBxd2ZwK1lrNzhpWmpnMFZiV3BzWjlZdVhN?=
 =?utf-8?B?UW4yM3VadmtSZ2N5dWFkazlCS21xN3MyUFNCMjZBNVBTYm9SVTVZdWs3bTlM?=
 =?utf-8?B?MlRRUWJYaTZJMmRIN3h3S25JbG03SWNsbXU2bmZLVUxOWm5HVVBwem9qV3g3?=
 =?utf-8?B?NEVGSU5sSUcwbGY2aExmTTBubXp5WWhDYnJEdDNZQXl0bGRTRTFHbVdTSjdT?=
 =?utf-8?B?c0dneVB5UXJ6TGJtejJpNWN2VlFKV3ZUVVR2M0Y1WkZ3OVZtTGtuc2NUMTdl?=
 =?utf-8?B?SFR6ZUNhUGVaMFd1Vi9RdlRPb1BZVEJpNTV4MWYwT0tpTTdvSlBYTUJvS0x4?=
 =?utf-8?B?aVFsZTFmTVlRSC9rbnJNYnFUQXFJdTFGTFBsNm1TY2FieHIvSTZmZXB1S2tp?=
 =?utf-8?B?bjEydnkrWXdoOWR6U2pHU0lBMHNVZWZ2TitxalNzSVBSaStwTWZWVUFzR0Vm?=
 =?utf-8?B?ZXMzTmIrenJGT0xDQWNKREMwYlpmdDF3QkdUd1B0eXJ6Q05kNXNBTTZaMWhv?=
 =?utf-8?B?ci9SUThweE5xVyt1aksyYU1Sc1JvQ25lY3dDRDFyelJQMnIzcVgwZlQ4UEs4?=
 =?utf-8?B?N2ZCaTBrVXBMdlliT21ydCtMb1lTcHdEbEppbXNkTVFlekV5R0Y4UTlreHRm?=
 =?utf-8?B?eEpaQytleWVkblFyR2JSZlNYNEdabFNmLzIrUm4rZnRMRTdoZ0x6eWpCWThF?=
 =?utf-8?B?R0FIN3ErOXZDN0l2MjlpOFFXNFR6d2dwSEZxN3hHdkZZRHdYZE43a0c2Z0Y2?=
 =?utf-8?Q?r7rV2OjbzbHzXpdnUNrWnac=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b33227f-f089-4452-b809-08d9c44b30ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 06:29:06.5040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uqobqh0Q51TRX3mmdIH3T0ZixKM3YCPfjfLee3K6EMy68ABgI5RDxKzRR5jCkoufGgDkYrXVHkE41lLDKYhX+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1760
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQpPbiAxMi8yMC8yMDIxIDU6MDggUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+
IA0KPiBPbiAxMi8xNy8yMSAxNjozMCwgSmluZyBMaXUgd3JvdGU6DQo+ID4gQWxzbyBkaXNhYmxl
IHJlYWQgZW11bGF0aW9uIG9mIElBMzJfWEZEX0VSUiBNU1IgYXQgdGhlIHNhbWUgcG9pbnQNCj4g
PiB3aGVyZSByL3cgZW11bGF0aW9uIG9mIElBMzJfWEZEIE1TUiBpcyBkaXNhYmxlZC4gVGhpcyBz
YXZlcyBvbmUNCj4gPiB1bm5lY2Vzc2FyeSBWTS1leGl0IGluIGd1ZXN0ICNOTSBoYW5kbGVyLCBn
aXZlbiB0aGF0IHRoZSBNU1IgaXMNCj4gPiBhbHJlYWR5IHJlc3RvcmVkIHdpdGggdGhlIGd1ZXN0
IHZhbHVlIGJlZm9yZSB0aGUgZ3Vlc3QgaXMgcmVzdW1lZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiANCj4gV2h5IG5vdCBkbyB0aGlz
IHVuY29uZGl0aW9uYWxseSAoaS5lLiBpbiBwYXRjaCAxMywgd2l0aCB0aGUgY2FsbCB0bw0KPiB2
bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21zciBpbiBmdW5jdGlvbiB2bXhfY3JlYXRlX3ZjcHUp
Pw0KPiANClRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoZSBwYXRjaGVzLiANCg0KSWYgZGlzYWJsZSB1
bmNvbmRpdGlvbmFsbHkgaW4gdm14X2NyZWF0ZV92Y3B1LCBpdCBtZWFucyBldmVuIGd1ZXN0IGhh
cw0Kbm8gY3B1aWQsIHRoZSBtc3IgcmVhZCBpcyBwYXNzdGhyb3VnaCB0byBndWVzdCBhbmQgaXQg
Y2FuIHJlYWQgYSB2YWx1ZSwgd2hpY2ggDQpzZWVtcyBzdHJhbmdlLCB0aG91Z2ggc3BlYyBkb2Vz
bid0IG1lbnRpb24gdGhlIHJlYWQgYmVoYXZpb3VyIHcvbyBjcHVpZC4NCg0KSG93IGFib3V0IGRp
c2FibGluZyByZWFkIGludGVyY2VwdGlvbiBhdCB2bXhfdmNwdV9hZnRlcl9zZXRfY3B1aWQ/DQoN
CmlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfWEZEKSAmJiBndWVzdF9jcHVpZF9oYXModmNw
dSwgWDg2X0ZFQVRVUkVfWEZEKSkNCiAgICAgICAgdm14X3NldF9pbnRlcmNlcHRfZm9yX21zcih2
Y3B1LCBNU1JfSUEzMl9YRkRfRVJSLCBNU1JfVFlQRV9SLCBmYWxzZSk7DQoNClRoYW5rcywNCkpp
bmcNCg0KPiBUaGFua3MsDQo+IA0KPiBQYW9sbw0KPiANCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2
L2t2bS92bXgvdm14LmMgfCAyICsrDQo+ID4gICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5oIHwgMiAr
LQ0KPiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYv
a3ZtL3ZteC92bXguYyBpbmRleA0KPiA+IDk3YTgyM2EzZjIzZi4uYjY2YTAwNWYwNzZiIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9r
dm0vdm14L3ZteC5jDQo+ID4gQEAgLTE2Myw2ICsxNjMsNyBAQCBzdGF0aWMgdTMyDQo+IHZteF9w
b3NzaWJsZV9wYXNzdGhyb3VnaF9tc3JzW01BWF9QT1NTSUJMRV9QQVNTVEhST1VHSF9NU1JTXSA9
IHsNCj4gPiAgIAlNU1JfR1NfQkFTRSwNCj4gPiAgIAlNU1JfS0VSTkVMX0dTX0JBU0UsDQo+ID4g
ICAJTVNSX0lBMzJfWEZELA0KPiA+ICsJTVNSX0lBMzJfWEZEX0VSUiwNCj4gPiAgICNlbmRpZg0K
PiA+ICAgCU1TUl9JQTMyX1NZU0VOVEVSX0NTLA0KPiA+ICAgCU1TUl9JQTMyX1NZU0VOVEVSX0VT
UCwNCj4gPiBAQCAtMTkzNCw2ICsxOTM1LDcgQEAgc3RhdGljIHU2NCB2Y3B1X3N1cHBvcnRlZF9k
ZWJ1Z2N0bChzdHJ1Y3QNCj4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICBzdGF0aWMgdm9pZCB2bXhf
c2V0X3hmZF9wYXNzdGhyb3VnaChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICB7DQo+ID4g
ICAJdm14X2Rpc2FibGVfaW50ZXJjZXB0X2Zvcl9tc3IodmNwdSwgTVNSX0lBMzJfWEZELA0KPiBN
U1JfVFlQRV9SVyk7DQo+ID4gKwl2bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21zcih2Y3B1LCBN
U1JfSUEzMl9YRkRfRVJSLA0KPiBNU1JfVFlQRV9SKTsNCj4gPiAgIAl2Y3B1LT5hcmNoLnhmZF9v
dXRfb2Zfc3luYyA9IHRydWU7DQo+ID4gICB9DQo+ID4gICAjZW5kaWYNCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3ZteC92bXguaCBiL2FyY2gveDg2L2t2bS92bXgvdm14LmggaW5kZXgN
Cj4gPiBiZjlkMzA1MWNkNmMuLjBhMDAyNDJhOTFlNyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5oDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguaA0KPiA+IEBA
IC0zNDAsNyArMzQwLDcgQEAgc3RydWN0IHZjcHVfdm14IHsNCj4gPiAgIAlzdHJ1Y3QgbGJyX2Rl
c2MgbGJyX2Rlc2M7DQo+ID4NCj4gPiAgIAkvKiBTYXZlIGRlc2lyZWQgTVNSIGludGVyY2VwdCAo
cmVhZDogcGFzcy10aHJvdWdoKSBzdGF0ZSAqLw0KPiA+IC0jZGVmaW5lIE1BWF9QT1NTSUJMRV9Q
QVNTVEhST1VHSF9NU1JTCTE0DQo+ID4gKyNkZWZpbmUgTUFYX1BPU1NJQkxFX1BBU1NUSFJPVUdI
X01TUlMJMTUNCj4gPiAgIAlzdHJ1Y3Qgew0KPiA+ICAgCQlERUNMQVJFX0JJVE1BUChyZWFkLA0K
PiBNQVhfUE9TU0lCTEVfUEFTU1RIUk9VR0hfTVNSUyk7DQo+ID4gICAJCURFQ0xBUkVfQklUTUFQ
KHdyaXRlLA0KPiBNQVhfUE9TU0lCTEVfUEFTU1RIUk9VR0hfTVNSUyk7DQo+ID4NCg0K
