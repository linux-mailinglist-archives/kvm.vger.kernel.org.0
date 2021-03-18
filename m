Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDBB340596
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCRMcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:32:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:36707 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhCRMcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 08:32:52 -0400
IronPort-SDR: sn6s8oq2pNtyzt3hDWY9Meempllgt+W7IJO3/K9eD7albrPLwZaEXEVAcL6+Xogdizc5BXWuAS
 VvfB7kYOFX3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="169587986"
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="169587986"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 05:32:52 -0700
IronPort-SDR: 0c0liHcCKKV1ZMx49b+IDLCiQuzWTCwkMnapqtw/+JV+HiBBLZ6Dmb2nl7ASXFN5+U2pGZA4H+
 wy8ms5AeV0TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="406344594"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2021 05:32:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 05:32:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Mar 2021 05:32:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Mar 2021 05:32:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYbBfBwpp0UMOV8gEZ02LAG/TrBP4Eo+1/yK6ikZwOJvenHoNbL5uFWvR/jbLuYVJ0pv1tG9SZjqwqGyKTCPMyp/HzGlANRVikjS50pg3YOrOQ5UtvWHfFA0FpeffQL0ynNjiA2z3si2FCk3D2pjmcEforivaKFXVnyMPInvC10FWK/gy5eCRyCr5WEdpAygJebK+1ie1vMADXyTDtxEumvovPMRGDUrO2LzUCWbD0e9S2I6rVOMmkKrVM4DbB0Gdakl+2ekiLAm3tS8SdblHTyBwDmdS5lT3liPK5z50+WEWj3SNLCcStGc+ypJM4yXvG4OMSyJFhQWzBu81BGI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd3mWyNY1ZrQCxcCiXD07ubaUVqXVJhv0kIpOjUYzWQ=;
 b=Acrj6BO1IxXUfZUjdFVY2ngtVTsmf1BlGR0MPDZTGUiLy/YjJTrxA+rpfLldcDO/Nr+liIJdmIiWMs9ItKVPHA7yU0LjXY904BqBUFFK4YPI6VcUD4Miu6VkMuVrR0P6DUzQ1qcIR0s3FCTBcLo82LqOx9QV8lqMF5XC/PQ/Aw7QojhIkr6m/NBJDh5phifTISJ5f8pJPkP8MEIViR9X5jtjTZZx13Q60UXA/zhDdsSculcGUvZuY4KgUYwCrhIFp9KLytDiRGzo7gNrZ8js8JYET48GoZWEiqC30PwNIWU7oyumr5dd2VwfsLnu9g2mmFX0NKUz92BTYAr7bJp+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd3mWyNY1ZrQCxcCiXD07ubaUVqXVJhv0kIpOjUYzWQ=;
 b=JjCxudDUWHEL1gMgVMd0M8i6/LielEVU7fL3Q226IudOeHkRbwguytWjKyiSUdz/GyeuLgT4CYdxwCjkv8tcfs71k90qG51qOAufeRtrltfj1Z0CTUnL6lL1CEwbUIp8jxYVcy0gNrS/rD86nnIsdAZO0gbshvOSKjkB6J/d6o8=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1694.namprd11.prod.outlook.com (2603:10b6:300:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 18 Mar
 2021 12:32:49 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 12:32:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW8vkytb+JKYXDyUeYG8HWtmg34ao/PksAgAOljRCAAZMegIADINTAgEIZxQCAABPukIAALzyAgAAHguA=
Date:   Thu, 18 Mar 2021 12:32:49 +0000
Message-ID: <MWHPR11MB1886498515951BCE98F9336A8C699@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
 <4f904b23-e434-d42b-15a9-a410f3b4edb9@huawei.com>
 <MWHPR11MB188656845973A662A7E96BDA8C699@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c152f419-acc4-ee33-dab1-ff0f9baf2f24@huawei.com>
In-Reply-To: <c152f419-acc4-ee33-dab1-ff0f9baf2f24@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0caeb8c-0356-4720-d707-08d8ea09f149
x-ms-traffictypediagnostic: MWHPR11MB1694:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB169493364A1995A1B76FBE078C699@MWHPR11MB1694.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cst7VOYRDL8+nqE6nHuKcpMBFdJdIFAivwCQr5wRmiSkDeZL5FtYqOS3+Kp6FB8sLogPmQBa6DgQznx4bvaX1497mkSleNMSRHDVFy4FqpDJ91+wIDQAXyc1XqHU8XQ6DfT56iWDtyXOzcsZNVgBa432sOUj6KqMBxE3hvUJhOfX9D9lywgyWDujQDs3HHLsqfMsWpGO/olWtKQjCWjhg8dGgcGQZYaS8QmHtdJTT4TvjI+NKas5c0YOnzhPlDMp0KkHuEBfch3CeW7OpWqZlDmhUBYCFv+WxY05FkFdWSx0dEh5cofMQunP7MHMSqBzhLfyqWpcyr7iSW7Vi9TRSmfVKC6Mfen8egoBSiL2Yw9vaB2MJ4pGrKqtNbDFMBax4XeTN5OxNmJDe8aNTDvwx+IkD29QoBT2ny3DlvdHloyIp6Gy1NDGk9hwLXmOkrlQ8IzL4irgthg7XgLIi4em40thYgykZIgD7/0oq0CciyqNeIL912NOGJeItmzC18Pc8creAGaz+64nznE1azKig+Jrh7sjNhErx6SZHoUKb3GhIRZnxe2NGDioBLzPCiQKYSGCdrJ1CI+L6kjI7ViY2nt/hbfXERuzyjvan86lPaPpPc1GjdXvKt4InLZZ/CkJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(478600001)(5660300002)(316002)(110136005)(54906003)(2906002)(9686003)(7416002)(186003)(4326008)(86362001)(6506007)(53546011)(8936002)(55016002)(66446008)(64756008)(7696005)(33656002)(66946007)(71200400001)(8676002)(83380400001)(66556008)(76116006)(26005)(38100700001)(66476007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?enBmVWx6WUI5Z1drWUpuWEttS1o0REVFV2cwVTI4cng0NnlLcitYVnNZODBI?=
 =?utf-8?B?ZWF5RSs4VUIzd2lPOG1tVEdiSzZqRGRqWHJGd0ZJcEM2Q1dLOWgraXFIdGdo?=
 =?utf-8?B?dDhsMjlxNUIyZmJBWEs3NVN6VmFUMW8wcDlRTlZoTTNhVkR6RWlmejNNVkpJ?=
 =?utf-8?B?dmZMczA0eWZzWHV5R2tnaUtHYnprQ3BZWCtDcHcwdHJxZllkekkwZFdCM2hx?=
 =?utf-8?B?Nk1IQ3NySzBNUFVUZUIrbjYrcHBiZnJGYXRYNTBZZkQzY1k0YWJuQm9Za1Fr?=
 =?utf-8?B?YXBWbTNPL3Y2blFJSHBwdE52aS9HVEU2NXJlYnZ5WHQ0azBpRVdNVC9OQTJs?=
 =?utf-8?B?dkNEb0gzOVdCRXZkK0IvdURkSkd6VEQwaWx1eG9sMy9naXR6eVlOeTlyeU9u?=
 =?utf-8?B?YTJUNXBiUCt3T1M4d3ZDOUpwbnRYdjVGZ3g3ZllnU1ZEdnRBWEhWTnBXSkc4?=
 =?utf-8?B?R2Ewa0ZPK2R4cjBPZS9KOWdFdFhqLzlWbDNaS216NXROZjRLZk9XTGFXWGtv?=
 =?utf-8?B?aFdTMWc2NjJaVDh1ZUhQV3VLRHFLengzNnk2Y1AwSFNYdHVVM05YZmxHb0JS?=
 =?utf-8?B?c2ZQNlpDc041Uk1vYitnUytScUVPWFh4bXMvRmNEOGpWTzFQWThoQ0RzMEk2?=
 =?utf-8?B?bVBYanEzWGFlMlRmVlNkei9uU0l0L09iaU1xdHhjUGpQbnZKYUplVWVPNTF1?=
 =?utf-8?B?WjduL1BoVkQvRFpXWmsxQ1RTT1E2dDB3dDlLOEl2eEFOTnNYbkJzRjZGTjcr?=
 =?utf-8?B?N3NqRjhjRWFMWGlrVGNKaGlYUUJjaTZMdWpKR1hlVy9HQ3IrQlNEdmNuT0J6?=
 =?utf-8?B?cWIxT0Y0NFFDSVc1M1pwaVlpM2I4RjBzRVA1S01DVk1FZ21kSkZ0eElweTdk?=
 =?utf-8?B?NXhUSEJINlI1Z01VTVFOd0tMT0JEZWZNRTEyLzdtdTMveGl6V3RMcHorWjFH?=
 =?utf-8?B?ck80RnR4cFMrUkFQM056WVlVbG1KTnlXODN4djNCL2VQd1gyNDQyWm9sOGdp?=
 =?utf-8?B?Q0tIMWFFZlNCOXFBYWVRMlZ1TjczTHlkS1AwcVQ0VDlmdlhwUFNYTjgvaCtT?=
 =?utf-8?B?L2ptWXhpdWhzNHUrNUhhWFZrQ0VGVzdBTGNsTG5PQ3c2aW5zQ1hWNzZESEww?=
 =?utf-8?B?TGxZQzBuRzdCaWVmemtCdVhPSDlvVWkzN2puYlFUQ0NuVmkwM1JhbThFdlg3?=
 =?utf-8?B?UkpLZUx3S3h1ZGEwVjg1NjV1TktlY0Fub0R2cGk5bGNnT05LdmUwZVVBOXdN?=
 =?utf-8?B?ejgzYnlVMkhmVitvbklxQ3VVa1lYcFQ0dHhWNDZzaTRneE1jRU5URnVrNHpO?=
 =?utf-8?B?RkdYRmZUS2R6UTZNbjlKQzh5TmUvL256TWpXLzdoSVNBd21aRmR3alVqYXdO?=
 =?utf-8?B?eXFkVDErYXF4dVB0NXdteGpkVGxmYUJOUGpoSjBXUFZpNHJheG01MURhTnJu?=
 =?utf-8?B?c3IrZE9mNkgrZzlDaWd2dFlFK1J4WHNzdUZtWk04SU04Qng1UWhFTXU5MzlO?=
 =?utf-8?B?Y21PL0o3bU9UNlNRSGd6b2Qvckg3MHVGYUF6dERKbGtpdk56NzIzM1UwWGtT?=
 =?utf-8?B?cnZvRkp2cUFob0JQWjZzK3cwRzR1dnVQcE8vYW5JYkRhc2FJVWtjZy9sYkh3?=
 =?utf-8?B?QWJrZnoxclJGbE9BSEloQlV0NXRjUy80Q2dLOEd2V25TVHhRTVpoVlg3M2h2?=
 =?utf-8?B?bCtzQ2FSdHFsdEJUNFR3V1ducjFlQk5ZS0Z3azFvcVg0RHpIVTNZLzNOSFdz?=
 =?utf-8?Q?71MnMz0QwNi+9sjAkuIkzE+0llnsHXyFz0n5wUW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0caeb8c-0356-4720-d707-08d8ea09f149
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 12:32:49.5639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjdlTOU8J73pi+1+JcyHX8I34IKD7bDRzExj2m7k31nI5J8HQ3xf0xmdh+x8DZnuXbT1S0AznvkdY3ifFVrdJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1694
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgTWFyY2ggMTgsIDIwMjEgNzo1NCBQTQ0KPiANCj4gT24gMjAyMS8zLzE4IDE3OjA3LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVh
d2VpLmNvbT4NCj4gPj4gU2VudDogVGh1cnNkYXksIE1hcmNoIDE4LCAyMDIxIDM6NTMgUE0NCj4g
Pj4NCj4gPj4gT24gMjAyMS8yLzQgMTQ6NTIsIFRpYW4sIEtldmluIHdyb3RlOj4+PiBJbiByZWFs
aXR5LCBtYW55DQo+ID4+Pj4+IGRldmljZXMgYWxsb3cgSS9PIGZhdWx0aW5nIG9ubHkgaW4gc2Vs
ZWN0aXZlIGNvbnRleHRzLiBIb3dldmVyLCB0aGVyZQ0KPiA+Pj4+PiBpcyBubyBzdGFuZGFyZCB3
YXkgKGUuZy4gUENJU0lHKSBmb3IgdGhlIGRldmljZSB0byByZXBvcnQgd2hldGhlcg0KPiA+Pj4+
PiBhcmJpdHJhcnkgSS9PIGZhdWx0IGlzIGFsbG93ZWQuIFRoZW4gd2UgbWF5IGhhdmUgdG8gbWFp
bnRhaW4gZGV2aWNlDQo+ID4+Pj4+IHNwZWNpZmljIGtub3dsZWRnZSBpbiBzb2Z0d2FyZSwgZS5n
LiBpbiBhbiBvcHQtaW4gdGFibGUgdG8gbGlzdCBkZXZpY2VzDQo+ID4+Pj4+IHdoaWNoIGFsbG93
cyBhcmJpdHJhcnkgZmF1bHRzLiBGb3IgZGV2aWNlcyB3aGljaCBvbmx5IHN1cHBvcnQgc2VsZWN0
aXZlDQo+ID4+Pj4+IGZhdWx0aW5nLCBhIG1lZGlhdG9yIChlaXRoZXIgdGhyb3VnaCB2ZW5kb3Ig
ZXh0ZW5zaW9ucyBvbiB2ZmlvLXBjaS1jb3JlDQo+ID4+Pj4+IG9yIGEgbWRldiB3cmFwcGVyKSBt
aWdodCBiZSBuZWNlc3NhcnkgdG8gaGVscCBsb2NrIGRvd24gbm9uLQ0KPiBmYXVsdGFibGUNCj4g
Pj4+Pj4gbWFwcGluZ3MgYW5kIHRoZW4gZW5hYmxlIGZhdWx0aW5nIG9uIHRoZSByZXN0IG1hcHBp
bmdzLg0KPiA+Pj4+DQo+ID4+Pj4gRm9yIGRldmljZXMgd2hpY2ggb25seSBzdXBwb3J0IHNlbGVj
dGl2ZSBmYXVsdGluZywgdGhleSBjb3VsZCB0ZWxsIGl0IHRvIHRoZQ0KPiA+Pj4+IElPTU1VIGRy
aXZlciBhbmQgbGV0IGl0IGZpbHRlciBvdXQgbm9uLWZhdWx0YWJsZSBmYXVsdHM/IERvIEkgZ2V0
IGl0IHdyb25nPw0KPiA+Pj4NCj4gPj4+IE5vdCBleGFjdGx5IHRvIElPTU1VIGRyaXZlci4gVGhl
cmUgaXMgYWxyZWFkeSBhIHZmaW9fcGluX3BhZ2VzKCkgZm9yDQo+ID4+PiBzZWxlY3RpdmVseSBw
YWdlLXBpbm5pbmcuIFRoZSBtYXR0ZXIgaXMgdGhhdCAndGhleScgaW1wbHkgc29tZSBkZXZpY2UN
Cj4gPj4+IHNwZWNpZmljIGxvZ2ljIHRvIGRlY2lkZSB3aGljaCBwYWdlcyBtdXN0IGJlIHBpbm5l
ZCBhbmQgc3VjaCBrbm93bGVkZ2UNCj4gPj4+IGlzIG91dHNpZGUgb2YgVkZJTy4NCj4gPj4+DQo+
ID4+PiBGcm9tIGVuYWJsaW5nIHAuby52IHdlIGNvdWxkIHBvc3NpYmx5IGRvIGl0IGluIHBoYXNl
ZCBhcHByb2FjaC4gRmlyc3QNCj4gPj4+IGhhbmRsZXMgZGV2aWNlcyB3aGljaCB0b2xlcmF0ZSBh
cmJpdHJhcnkgRE1BIGZhdWx0cywgYW5kIHRoZW4gZXh0ZW5kcw0KPiA+Pj4gdG8gZGV2aWNlcyB3
aXRoIHNlbGVjdGl2ZS1mYXVsdGluZy4gVGhlIGZvcm1lciBpcyBzaW1wbGVyLCBidXQgd2l0aCBv
bmUNCj4gPj4+IG1haW4gb3BlbiB3aGV0aGVyIHdlIHdhbnQgdG8gbWFpbnRhaW4gc3VjaCBkZXZp
Y2UgSURzIGluIGEgc3RhdGljDQo+ID4+PiB0YWJsZSBpbiBWRklPIG9yIHJlbHkgb24gc29tZSBo
aW50cyBmcm9tIG90aGVyIGNvbXBvbmVudHMgKGUuZy4gUEYNCj4gPj4+IGRyaXZlciBpbiBWRiBh
c3NpZ25tZW50IGNhc2UpLiBMZXQncyBzZWUgaG93IEFsZXggdGhpbmtzIGFib3V0IGl0Lg0KPiA+
Pg0KPiA+PiBIaSBLZXZpbiwNCj4gPj4NCj4gPj4gWW91IG1lbnRpb25lZCBzZWxlY3RpdmUtZmF1
bHRpbmcgc29tZSB0aW1lIGFnby4gSSBzdGlsbCBoYXZlIHNvbWUgZG91YnQNCj4gPj4gYWJvdXQg
aXQ6DQo+ID4+IFRoZXJlIGlzIGFscmVhZHkgYSB2ZmlvX3Bpbl9wYWdlcygpIHdoaWNoIGlzIHVz
ZWQgZm9yIGxpbWl0aW5nIHRoZSBJT01NVQ0KPiA+PiBncm91cCBkaXJ0eSBzY29wZSB0byBwaW5u
ZWQgcGFnZXMsIGNvdWxkIGl0IGFsc28gYmUgdXNlZCBmb3IgaW5kaWNhdGluZw0KPiA+PiB0aGUg
ZmF1bHRhYmxlIHNjb3BlIGlzIGxpbWl0ZWQgdG8gdGhlIHBpbm5lZCBwYWdlcyBhbmQgdGhlIHJl
c3QgbWFwcGluZ3MNCj4gPj4gaXMgbm9uLWZhdWx0YWJsZSB0aGF0IHNob3VsZCBiZSBwaW5uZWQg
YW5kIG1hcHBlZCBpbW1lZGlhdGVseT8gQnV0IGl0DQo+ID4+IHNlZW1zIHRvIGJlIGEgbGl0dGxl
IHdlaXJkIGFuZCBub3QgZXhhY3RseSB0byB3aGF0IHlvdSBtZWFudC4uLiBJIHdpbGwNCj4gPj4g
YmUgZ3JhdGVmdWwgaWYgeW91IGNhbiBoZWxwIHRvIGV4cGxhaW4gZnVydGhlci4gOi0pDQo+ID4+
DQo+ID4NCj4gPiBUaGUgb3Bwb3NpdGUsIGkuZS4gdGhlIHZlbmRvciBkcml2ZXIgdXNlcyB2Zmlv
X3Bpbl9wYWdlcyB0byBsb2NrIGRvd24NCj4gPiBwYWdlcyB0aGF0IGFyZSBub3QgZmF1bHRhYmxl
IChiYXNlZCBvbiBpdHMgc3BlY2lmaWMga25vd2xlZGdlKSBhbmQgdGhlbg0KPiA+IHRoZSByZXN0
IG1lbW9yeSBiZWNvbWVzIGZhdWx0YWJsZS4NCj4gDQo+IEFoaC4uLg0KPiBUaHVzLCBmcm9tIHRo
ZSBwZXJzcGVjdGl2ZSBvZiBWRklPIElPTU1VLCBpZiBJT1BGIGVuYWJsZWQgZm9yIHN1Y2ggZGV2
aWNlLA0KPiBvbmx5IHRoZSBwYWdlIGZhdWx0cyB3aXRoaW4gdGhlIHBpbm5lZCByYW5nZSBhcmUg
dmFsaWQgaW4gdGhlIHJlZ2lzdGVyZWQNCj4gaW9tbXUgZmF1bHQgaGFuZGxlci4uLg0KPiBJIGhh
dmUgYW5vdGhlciBxdWVzdGlvbiBoZXJlLCBmb3IgdGhlIElPTU1VIGJhY2tlZCBkZXZpY2VzLCB0
aGV5IGFyZQ0KPiBhbHJlYWR5DQo+IGFsbCBwaW5uZWQgYW5kIG1hcHBlZCB3aGVuIGF0dGFjaGlu
ZywgaXMgdGhlcmUgYSBuZWVkIHRvIGNhbGwNCj4gdmZpb19waW5fcGFnZXMoKQ0KPiB0byBsb2Nr
IGRvd24gcGFnZXMgZm9yIHRoZW0/IERpZCBJIG1pc3Mgc29tZXRoaW5nPy4uLg0KPiANCg0KSWYg
YSBkZXZpY2UgaXMgbWFya2VkIGFzIHN1cHBvcnRpbmcgSS9PIHBhZ2UgZmF1bHQgKGZ1bGx5IG9y
IHNlbGVjdGl2ZWx5KSwgDQp0aGVyZSBzaG91bGQgYmUgbm8gcGlubmluZyBhdCBhdHRhY2ggb3Ig
RE1BX01BUCB0aW1lIChzdXBwb3NlIGFzIA0KdGhpcyBzZXJpZXMgZG9lcykuIFRoZW4gZm9yIGRl
dmljZXMgd2l0aCBzZWxlY3RpdmUtZmF1bHRpbmcgaXRzIHZlbmRvciANCmRyaXZlciB3aWxsIGxv
Y2sgZG93biB0aGUgcGFnZXMgd2hpY2ggYXJlIG5vdCBmYXVsdGFibGUgYXQgcnVuLXRpbWUsIA0K
ZS5nLiB3aGVuIGludGVyY2VwdGluZyBndWVzdCByZWdpc3RyYXRpb24gb2YgYSByaW5nIGJ1ZmZl
ci4uLg0KDQpUaGFua3MNCktldmluDQo=
