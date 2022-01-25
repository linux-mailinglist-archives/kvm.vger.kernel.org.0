Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7880149A670
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 03:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346285AbiAYB6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 20:58:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:36505 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3415616AbiAYBtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 20:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643075345; x=1674611345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AynMk7vOz3EEc19XywzIML+Z14wf9zTKFNMvT50IVjc=;
  b=N4g361o1zUpfX8NIL3unHeCAr0POnmccrmDgRIWH7R6V9iLTjsPlUDFE
   RookXTeIrTTqCoFsoBc1XVDilbxP4tl5RoqITT6/K9M132hvQ/p8q5zlh
   /M7bDlrMtHoEbhbzCOnAxGPYtC8ITGxSTgh2FV8rjX97MBJOEuFNnWHRH
   VUek1hv9NVodVw9c3rHJ2c0eI9bKk9aAWe+kGyENL1sK6Q6ekG3CplHSx
   tfs49xanYQNhPogTolktr0dUGn8FwDuNJOrQsbsyt03eg0Sqfjw5tD7FI
   4dnQLMpapZ488IVSsY5hlB9sNRqzWkBny79Fe/Fff4cYfSWEpLUlptS+Q
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="246409449"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="246409449"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 17:26:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="768862818"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2022 17:26:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 17:26:58 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 17:26:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 17:26:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 17:26:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MenmcigItYvd09xvZ2bvPf6rU1OlvZ3YvoWXNP+CXYxJKaZsHPKD8tfX/GtYjFzWGHXOee/X5zUrvJmAeefTDU2Eewhn4q3sphAOB3p1EFIdOyC8w+hLM2Qpa7HGn9yO/cxZi1VAJ1UjCgD++DwyGpzp2/Yg0trO5x0tBvsJUgHXj0VFUWFtaduM8VZjMS1gje+wR27c+LUm46PZYDQQ/JnxE/ASXftL6C3kUfBwMPv1CjlCmJRCgjOEJFQPX5JclpeQEY8uK096Kxg8Nqtl9tRWOkHDDAsvjplx/QR7MV8SvZVy0HsrWAAzMoRibyiZejN1JBNbVZD6PZaoXm69WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AynMk7vOz3EEc19XywzIML+Z14wf9zTKFNMvT50IVjc=;
 b=AdrvT5wZav8xh/C9EIavHoiREFZ0V38YIHDpEvwbeOZHzTMPITgAf8js8t37358xbSwP1BJqiTIb/aLOSwFFGs/gc2l+6845sRrzzJI5Lk+AfU4A/Zemy3Dkyc2BCWGiEUEMwqwH3pUdmz6VRr58tysDVIBnREyhGUqekckWHJX5Gq0FzRqsqUQduiHpEVS7J0a9G7INfupekyLdak189AxM0ilNay+hcOsLOa0de2j8TbQQGGk3Hpy3NDOoc6DTO/oDipG8pOM31bGSpzQhS7v6x0LykSibXd2u3wyGfMxZFfqM+llzud+S1D4kQaQb5+600VxzyGJzTEkxdTRVdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1356.namprd11.prod.outlook.com (2603:10b6:3:14::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 01:26:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%5]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 01:26:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
CC:     Jim Mattson <jmattson@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHYEPjaob4MhC2bc0uzoJiMSdCI2qxyM26AgAC+5rA=
Date:   Tue, 25 Jan 2022 01:26:56 +0000
Message-ID: <BN9PR11MB527634C540FD1BC6083E396B8C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220124080251.60558-1-likexu@tencent.com>
 <f4ddcedc-4a81-4f4e-f3f4-8388120a0776@redhat.com>
In-Reply-To: <f4ddcedc-4a81-4f4e-f3f4-8388120a0776@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8140aab-b2de-4c62-c07a-08d9dfa1c673
x-ms-traffictypediagnostic: DM5PR11MB1356:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB13566E8072D679E00D028B7F8C5F9@DM5PR11MB1356.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pQAmLg2ZPBEWfStmAoTS4Vk1dqzZDvZupkUKUfHfXcfw/GlOtDs4ajoDsaL7RwZpZLlMfw8AYclM73ATgGu9awLxTqsrpFevJy8kCCo8urhmaIH/g/AZ6p9zWV+zGMpQgCvkB0FiIic2cqvNEuKJ3ClVsccuPi8j09+alnUM6LheGI4c/0YLAwK8SHDG0MEqpaIL1y+1PD4YSwa095Vwo1gSjrpdL0j5zc27DjdsxCDJcsTRWNZxd634sMTk/wBl9Gke42h3p444FQMx22xnJbl9WqH8PySnZ82VGpvmbJ0sJtJxjYfZNpQt37Y7qqeNHkfLHa7zHEw9+F7E5YKmVKjC1eLeaAqDI8iy0R9QVwk7lflEjf5RRVAuBnLclscaRcPyNbMlnzayQxJq+kP6P0tJ4Q8QJ1QxO2XzbuZydQw2Cm+SDISBR8jm6WhV02ZOLcrFCz4dDuvtZPFh9TidwAkatpBpgpMk7ZLdbrbtbWj34Vj53/DYzJ+QnbnSi1V7Z83S/b+rl95LJnzJQTd+CrEhBH+9S7Ds3JTPo8LCrGWd7qAq88WUZkPUUMg2dMlGuUD+Q0J+W6p1OqGeBixTeprKPz5YNdmA5Q1R6ZbP1LwKCSnYmzt/l0BkDz1VxJRIMPuJ6BHUScdxXLkOlFSBjlBr99Ucb355M0royvmQZq06rVct+PYRS75yg2dXUPMOFE+OTmANzZ4j8hZH1yDq3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(64756008)(66946007)(508600001)(53546011)(52536014)(86362001)(8936002)(5660300002)(122000001)(186003)(76116006)(2906002)(66476007)(66446008)(71200400001)(54906003)(6506007)(7696005)(33656002)(26005)(9686003)(110136005)(38070700005)(82960400001)(38100700002)(8676002)(316002)(55016003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3ZIalRja0xWU3BJYlhONzJsL1FSZ2JCS2ZvUHdpcmJSNEJIUXRVYTlJVUdJ?=
 =?utf-8?B?TWk5bElzeTdoVndoMDMvbGlpeUhXTVhzLy9tOUxRdzJnWW1xdW9KV1J4ZVNR?=
 =?utf-8?B?OU1QNFJqRkgwOENJWFNpdUFiM0FQRVk1Q2o0bkhMb3hkWkgrWHJFNk84UjFq?=
 =?utf-8?B?aEFnclF1Sm96VDJkWTBxOFk1aTJPVFpRd3cxWU84NjZFN0xUOXEycVlWcU9K?=
 =?utf-8?B?TXFjeWd3K1lFU2s0elpXdnZMYXVKZGFqdXBNcHhEeXlkQnBqNWVWYmZWc3Nt?=
 =?utf-8?B?Ympqd3lsb2YvZWZhMXM4ZU0wb2dUd3NvaThmam9vL0JnZVkrR0R0dTJTbmRt?=
 =?utf-8?B?dVE0Q29PbDhCNlB6MGlueHQwUGp4M1I3TTJqRVBDQm1nNW5UUHV3QVJBSmw1?=
 =?utf-8?B?VVpTdGlwQzF6SUVmU1VYTEU3NXVaUUw3aGFPS3NSSjBlaWZBcXVxVElaL1hE?=
 =?utf-8?B?Snd5RU9aY2o4Wjd3Y3Z2b1VZazVYMm9nd0FIbGtuYTlRNC9iV09qTG1lalU2?=
 =?utf-8?B?RVd0dFhTdjdHMW5IL1NtZnhuVkJOOHVnbGdpaTVhMTBNZUplUmV2S3dCVnJJ?=
 =?utf-8?B?R1liaUQvSmhYWEVxSnJIajZGYWRaQjRucU8ySU1xM09lbjB5STJvV0xaMkkz?=
 =?utf-8?B?K1VEbHE4a1lHRkExZDNYRTQvbzMxQk9KUDl2VjE2SlF5MitMRHFZTFpEQ2xz?=
 =?utf-8?B?d1FDcU1QNXBuekY1d1N3TllzbURnekpId3hNd0ZYUXVDSUFFVGxGb2FTRTJa?=
 =?utf-8?B?b2dKdmR5S2ZoSzljTkpGSkhzZlpEOHpmYVB1QUozSVRrWER1dVBlQmNNVWlF?=
 =?utf-8?B?V0pjSzBiQkViRnVIMWdOUDByazdJL3o5Q0wzTnU1K25Ob3ZCeTdaMk9Rayt4?=
 =?utf-8?B?VjZmenFuZlpObFNjQWg5WWN0SlVPYm90Um00Zm5WZWN2ZjVSSTBOdWY2YTBu?=
 =?utf-8?B?dTZtUHV2M0RTcUJjNVVQVm5BZkpscVRYRHVhbThFdE5VZmtGRG5lOGpMbE9h?=
 =?utf-8?B?a2RNS1Q4NXB2TEhqQ0RHcEZteGpPVXU3UmhydUVaSUFKRXdiZDVEZWtnQ1N4?=
 =?utf-8?B?Q0czZXkwNWZCcXRuS28rWTJjQ0MzUml5NHV2R0h6V216OEpVdWEwNm85VHJk?=
 =?utf-8?B?bUhXMllVRVRoUzM0a1p3VUlzUitZekpHNEdadDVJNU5QUHlmU0xkOFhqN2Nr?=
 =?utf-8?B?ZVZaOGZBRlRqRTlWS3kzNVpsV0tnZ3pnRjUvZ0VIV3NHSXg2WWV0TVUvcEVV?=
 =?utf-8?B?ZnRiTUQ2bVF4bTAwUFFMUjJvVUhaRmhMdHE1THd6VXQ5Q1g1MUZsZS8yVFFM?=
 =?utf-8?B?V0ZuSkRia1VkcWVURkZnN3ZmZTNGN1QvSlVwTFhoNEFqS213eUc4M0QwZk1r?=
 =?utf-8?B?RVVEb3ArbTdnaFVRTTlZRWNqT3lyK1RNaEpyZzdJOGpoblNkUzlvbFNDU2N1?=
 =?utf-8?B?eVNBVGswOEdHZStiQ2FPNExJQ2p1Zk9zeVlsdmxOWVE2TUVmQWVFNzN6eFVm?=
 =?utf-8?B?YndIa2c0YS9qeDB6TUdVRXQrYzdoZkNQbFBaaWUySGxFc282V3gvaG4rdjlt?=
 =?utf-8?B?YkllTXNkRHV0Y3ovVEhmNTVmblM3RGhBTE9lYmZPSnJOUVdFVE1jQlZQWFJQ?=
 =?utf-8?B?bkM3QWFEams3dDN5V1FPL21CakJ2b1VPL2ZmeTg4NWxWbFdJQllNcHFFMEov?=
 =?utf-8?B?OWVKdG1Tb29MOTJKNEVrb2JFTGhIUkZrMXJneGlUcXQxUEw0MWo3TE5XQzNs?=
 =?utf-8?B?d0k3WUlwcFhEc1lmUC9NeUZ0KzNOT0svTDc5cmZEcVc0a09ZL1djU21IM2Ja?=
 =?utf-8?B?NWM5cHlaSkN4ZDBJVFJMQnFtNktPMzZDTGJMc28zYnN4Vis0YXBYaGlWZ3ZY?=
 =?utf-8?B?TDBncXZROTFkOC9NcDJ2ek1QaDBaOTdVUUZuSzB1WjBiUzNYZkFrdUhNbHlz?=
 =?utf-8?B?WXBQNUhCTDZLRThWMmZ2ZUoyUGllVHdKQlZvTVR1eWFJYWZqeFo2ZXdmWmN0?=
 =?utf-8?B?eWdVNjhZTEs1Q3YzbVlMSXFwQlVyOWhnRnNNY1p4OFgvTERudTNaVXhvWkFR?=
 =?utf-8?B?NndIbG03TmxTRFh0MHBLV3hPV2RQYkh1R0NxZXI2bVpSbi9zVzBkYW1SaDUr?=
 =?utf-8?B?ZERqcU9WUHBBd2tpMVNzV3dwRmVGQVo3RG05NTl1NFBSTVR5TGxRK2lKUW9X?=
 =?utf-8?Q?roN34kdx9rKoic8B4hQ8bOA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8140aab-b2de-4c62-c07a-08d9dfa1c673
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 01:26:56.1214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IoUUMYTSPQQDZ0ahcsNdZKgHTEAgdEJdbDvIuEF1PG1SnsyRAsuBCcWyJaSooKNkeFTKmlYzrzwh0IssieJS+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1356
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBNb25k
YXksIEphbnVhcnkgMjQsIDIwMjIgMTA6MDAgUE0NCj4gDQo+IE9uIDEvMjQvMjIgMDk6MDIsIExp
a2UgWHUgd3JvdGU6DQo+ID4gICAJY2FzZSAweGQ6IHsNCj4gPiAtCQl1NjQgZ3Vlc3RfcGVybSA9
IHhzdGF0ZV9nZXRfZ3Vlc3RfZ3JvdXBfcGVybSgpOw0KPiA+ICsJCXU2NCBzdXBwb3J0ZWRfeGNy
MCA9IHN1cHBvcnRlZF94Y3IwICYNCj4geHN0YXRlX2dldF9ndWVzdF9ncm91cF9wZXJtKCk7DQo+
ID4NCj4gPiAtCQllbnRyeS0+ZWF4ICY9IHN1cHBvcnRlZF94Y3IwICYgZ3Vlc3RfcGVybTsNCj4g
PiArCQllbnRyeS0+ZWF4ICY9IHN1cHBvcnRlZF94Y3IwOw0KPiA+ICAgCQllbnRyeS0+ZWJ4ID0g
eHN0YXRlX3JlcXVpcmVkX3NpemUoc3VwcG9ydGVkX3hjcjAsIGZhbHNlKTsNCj4gPiAgIAkJZW50
cnktPmVjeCA9IGVudHJ5LT5lYng7DQo+ID4gLQkJZW50cnktPmVkeCAmPSAoc3VwcG9ydGVkX3hj
cjAgJiBndWVzdF9wZXJtKSA+PiAzMjsNCj4gPiArCQllbnRyeS0+ZWR4ICY9IHN1cHBvcnRlZF94
Y3IwID4+IDMyOw0KPiA+ICAgCQlpZiAoIXN1cHBvcnRlZF94Y3IwKQ0KPiA+ICAgCQkJYnJlYWs7
DQo+ID4NCj4gDQo+IE5vLCBwbGVhc2UgZG9uJ3QgdXNlIHRoaXMga2luZCBvZiBzaGFkb3dpbmcu
ICBJJ20gbm90IGV2ZW4gc3VyZSBpdA0KPiB3b3JrcywgYW5kIG9uZSB3b3VsZCBoYXZlIHRvIHJl
YWQgdGhlIEMgc3RhbmRhcmQgb3IgbG9vayBhdCB0aGUNCj4gZGlzYXNzZW1ibHkgdG8gYmUgc3Vy
ZS4gIFBlcmhhcHMgdGhpcyBpbnN0ZWFkIGNvdWxkIGJlIGFuIGlkZWE6DQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPiBpbmRl
eCAzZGNkNThhMTM4YTkuLjAzZGViNTFkOGQxOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3Zt
L2NwdWlkLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gQEAgLTg4NywxMyArODg3
LDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fZG9fY3B1aWRfZnVuYyhzdHJ1Y3QNCj4ga3ZtX2Nw
dWlkX2FycmF5ICphcnJheSwgdTMyIGZ1bmN0aW9uKQ0KPiAgIAkJfQ0KPiAgIAkJYnJlYWs7DQo+
ICAgCWNhc2UgMHhkOiB7DQo+IC0JCXU2NCBzdXBwb3J0ZWRfeGNyMCA9IHN1cHBvcnRlZF94Y3Iw
ICYNCj4geHN0YXRlX2dldF9ndWVzdF9ncm91cF9wZXJtKCk7DQo+ICsJCXU2NCBwZXJtaXR0ZWRf
eGNyMCA9IHN1cHBvcnRlZF94Y3IwICYNCj4geHN0YXRlX2dldF9ndWVzdF9ncm91cF9wZXJtKCk7
DQo+IA0KPiAtCQllbnRyeS0+ZWF4ICY9IHN1cHBvcnRlZF94Y3IwOw0KPiAtCQllbnRyeS0+ZWJ4
ID0geHN0YXRlX3JlcXVpcmVkX3NpemUoc3VwcG9ydGVkX3hjcjAsIGZhbHNlKTsNCj4gKyNkZWZp
bmUgc3VwcG9ydGVkX3hjcjAgRE9fTk9UX1VTRV9NRQ0KPiArCQllbnRyeS0+ZWF4ICY9IHBlcm1p
dHRlZF94Y3IwOw0KPiArCQllbnRyeS0+ZWJ4ID0geHN0YXRlX3JlcXVpcmVkX3NpemUocGVybWl0
dGVkX3hjcjAsIGZhbHNlKTsNCj4gICAJCWVudHJ5LT5lY3ggPSBlbnRyeS0+ZWJ4Ow0KPiAtCQll
bnRyeS0+ZWR4ICY9IHN1cHBvcnRlZF94Y3IwID4+IDMyOw0KPiAtCQlpZiAoIXN1cHBvcnRlZF94
Y3IwKQ0KPiArCQllbnRyeS0+ZWR4ICY9IHBlcm1pdHRlZF94Y3IwID4+IDMyOw0KPiArCQlpZiAo
IXBlcm1pdHRlZF94Y3IwKQ0KPiAgIAkJCWJyZWFrOw0KPiANCj4gICAJCWVudHJ5ID0gZG9faG9z
dF9jcHVpZChhcnJheSwgZnVuY3Rpb24sIDEpOw0KPiBAQCAtOTAyLDcgKzkwMyw3IEBAIHN0YXRp
YyBpbmxpbmUgaW50IF9fZG9fY3B1aWRfZnVuYyhzdHJ1Y3QNCj4ga3ZtX2NwdWlkX2FycmF5ICph
cnJheSwgdTMyIGZ1bmN0aW9uKQ0KPiANCj4gICAJCWNwdWlkX2VudHJ5X292ZXJyaWRlKGVudHJ5
LCBDUFVJRF9EXzFfRUFYKTsNCj4gICAJCWlmIChlbnRyeS0+ZWF4ICYgKEYoWFNBVkVTKXxGKFhT
QVZFQykpKQ0KPiAtCQkJZW50cnktPmVieCA9IHhzdGF0ZV9yZXF1aXJlZF9zaXplKHN1cHBvcnRl
ZF94Y3IwIHwNCj4gc3VwcG9ydGVkX3hzcywNCj4gKwkJCWVudHJ5LT5lYnggPSB4c3RhdGVfcmVx
dWlyZWRfc2l6ZShwZXJtaXR0ZWRfeGNyMCB8DQo+IHN1cHBvcnRlZF94c3MsDQo+ICAgCQkJCQkJ
CSAgdHJ1ZSk7DQo+ICAgCQllbHNlIHsNCj4gICAJCQlXQVJOX09OX09OQ0Uoc3VwcG9ydGVkX3hz
cyAhPSAwKTsNCj4gQEAgLTkxMyw3ICs5MTQsNyBAQCBzdGF0aWMgaW5saW5lIGludCBfX2RvX2Nw
dWlkX2Z1bmMoc3RydWN0DQo+IGt2bV9jcHVpZF9hcnJheSAqYXJyYXksIHUzMiBmdW5jdGlvbikN
Cj4gDQo+ICAgCQlmb3IgKGkgPSAyOyBpIDwgNjQ7ICsraSkgew0KPiAgIAkJCWJvb2wgc19zdGF0
ZTsNCj4gLQkJCWlmIChzdXBwb3J0ZWRfeGNyMCAmIEJJVF9VTEwoaSkpDQo+ICsJCQlpZiAocGVy
bWl0dGVkX3hjcjAgJiBCSVRfVUxMKGkpKQ0KPiAgIAkJCQlzX3N0YXRlID0gZmFsc2U7DQo+ICAg
CQkJZWxzZSBpZiAoc3VwcG9ydGVkX3hzcyAmIEJJVF9VTEwoaSkpDQo+ICAgCQkJCXNfc3RhdGUg
PSB0cnVlOw0KPiBAQCAtOTQyLDYgKzk0Myw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fZG9fY3B1
aWRfZnVuYyhzdHJ1Y3QNCj4ga3ZtX2NwdWlkX2FycmF5ICphcnJheSwgdTMyIGZ1bmN0aW9uKQ0K
PiAgIAkJCWVudHJ5LT5lZHggPSAwOw0KPiAgIAkJfQ0KPiAgIAkJYnJlYWs7DQo+ICsjdW5kZWYg
c3VwcG9ydGVkX3hjcjANCj4gICAJfQ0KPiAgIAljYXNlIDB4MTI6DQo+ICAgCQkvKiBJbnRlbCBT
R1ggKi8NCj4gDQo+IG9yIGFsdGVybmF0aXZlbHkgYWRkDQo+IA0KPiAJdTY0IHBlcm1pdHRlZF94
c3MgPSBzdXBwb3J0ZWRfeHNzOw0KPiANCj4gc28gdGhhdCB5b3UgdXNlICJwZXJtaXR0ZWQiIGNv
bnNpc3RlbnRseS4gIEFueWJvZHkgY2FuIHZvdGUgb24gd2hhdCB0aGV5DQo+IHByZWZlciAoaW5j
bHVkaW5nICJwZXJtaXR0ZWRfeGNyMCIgYW5kIG5vICNkZWZpbmUvI3VuZGVmKS4NCj4gDQoNCkkg
cHJlZmVyIHRvIHBlcm1pdHRlZF94Y3IwIGFuZCBwZXJtaXR0ZWRfeHNzLiBubyAjZGVmaW5lLyN1
bmRlZi4NCg0KJ3Blcm1pdHRlZCcgaW1wbGllcyAnc3VwcG9ydGVkJyBwbHVzIGNlcnRhaW4gcGVy
bWlzc2lvbnMgZm9yIHRoaXMgdGFzay4gT25jZQ0KYm90aCB4Y3IwIGFuZCB4c3MgYXJlIGRlZmlu
ZWQgY29uc2lzdGVudGx5IGluIHRoaXMgd2F5LCBpdCdzIG5vdCBuZWNlc3NhcnkgdG8NCmZ1cnRo
ZXIgZ3VhcmQgc3VwcG9ydGVkX3hjcjAgd2l0aCAjZGVmaW5lLyN1bmRlZi4NCg0KVGhhbmtzDQpL
ZXZpbg0K
