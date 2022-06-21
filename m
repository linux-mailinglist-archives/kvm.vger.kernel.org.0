Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD75529B6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 05:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345090AbiFUD03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 23:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242106AbiFUD00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 23:26:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BCF2018C
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 20:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655781983; x=1687317983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7sjRR6+xKr2uXktS0bb2nop5p9QDydovHsvi9akuQx8=;
  b=Dk74IhFINrx9dGk/fGtaALjJcmWJ/znTJtQQpcyA01fjWi6Ty+2/gLG6
   wc7ZdoFmMKWrUwb3vvia831LiGoL9NexY6b7ICGo6/lhOEnWTpHmMrqFP
   6LG15yRDcauNucb3FeGATU8ZnFCoS64S+edqo1XNIq3tITHr6unHac/eZ
   AAwW4cV/jjHMYz2RZnSIl8TllPABKqZVXJg2MU5ojlGNz9frsgEOD+al3
   YTUjfPUsY0xiEORFylEoe9epSgRE2Dbw17p1xVegxJxIG84nB2dU7aW+y
   o4WrmkZkVaqQ8OdmitYSBCwlg3I6HR7DsA80QHFtfXT9kWTYVljZdtLjP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259837566"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="259837566"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="833376913"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2022 20:26:22 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:26:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 20:26:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 20:26:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXFWY/qKFSjqVa7T6BHskzkEU1841O/xDY1/Ax5GTIKswfpZsF4JXz5sd+Zk2GC9fdCtdQGV1rIm91v3FL0GeUFmns0syjn85Wy1IgShQJ+MY2jwKT0qvNlQgwGyjmZ5ekZ7YXIq2C7kF1jew+4TGyAlDQyVS280CFl+wYK/qI2YBk7X1S6cOHx/Jl292PVjjeEmPySyYZcLTyU9CfpsOVJdiqfeJISPh7N4VRYCbIWpkSZyXBotSRPTBAkUpWY5UzXuSIhYH1Iam+h1fce996wYOlDWMQP753hA24RbRTq9Roee6luYTmRoVSqKHVZprWRHbKK7yxTKGY5rKVHI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sjRR6+xKr2uXktS0bb2nop5p9QDydovHsvi9akuQx8=;
 b=Ey7Ly0GLV2OXhYIetNsemawYpOe36Zd0Oc3EtWeYUr8CRwgvE1v3QAhJNYHS0Blkya2KN1VWQePnsesdDTxGRQ+A3hYs3WeNe6RSVdyNFQayeCmy+2h3eaS0FrZWAMEm+b1SlpmcwDJmJwlhvRM4ViKfN2tmpUZy/5rZaBWRsw1dsOB50wQ2rQ1S+nNufB9RwovOkFTo+bvxwD+V12PBIoWIj2+FE99E3UDgMUG2LZp5axmMwxqTPgOEgV5KjFKoZ0oeXfvGTnmx7OgeY6gY6sN1DtKVzNNBD5jsv67SXeqcf2GyPKRHoE29b6tWbG94F98TEYvymEaAphmVk1x4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 03:26:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 03:26:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Topic: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Index: AQHYhIOAV8ljw0oTzEiBb5r9QaTmKq1Yu02AgABZBICAABT3oIAAA3MAgAAFqnA=
Date:   Tue, 21 Jun 2022 03:26:18 +0000
Message-ID: <BN9PR11MB5276887FCA896E53829300F38CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
 <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
 <BN9PR11MB52767FD0F8287BE29E0C660D8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <e0ee6ed6-51ee-8a6b-5bc6-307b0df503e7@intel.com>
In-Reply-To: <e0ee6ed6-51ee-8a6b-5bc6-307b0df503e7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db8f3782-1eef-49df-f04c-08da5335ce4e
x-ms-traffictypediagnostic: MW4PR11MB5800:EE_
x-microsoft-antispam-prvs: <MW4PR11MB5800DE0827D910E156758AF58CB39@MW4PR11MB5800.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yaoS29VvBUESpkxdE6aOA55u5kK5wD496FnRbmqm3qt79mbE9iBT/pu1TpBmrmf6YcvVtLa4CVAgkLagD5PXwumwRbKltscB4UTCG1+0YE4wfZQFUPtPXgroDnTcYcuHghOuI8hisuFC4R7TSH6boaUZcOnoZxxiVQTgZP1pgDDWSrVI3JZgNl/JNGo487BLsatycVscXqKMCIu92oSFgLcV7M5RNAnSSjvUSmP3L79sRoC+QBsyvBr9TKwIbgXNa3FaWMFTXzIiMbbLpPYqB55tlVzP2lskNSXxVFUPf9jKEVaMaoLTO/uA/mMcYAjshRO32lsjVKOtSVlMJITkTWhskxn3/LO9F2SA4Jxx7pFV1hdsHksHdRWK9raUY3v34J8SZRRrNipVQp3jTYUJDKNzJo+hTMWs6siv/ZgV/DJwjBNvq4LSiKkn2OpTNp+ct82Skd0VT0doRVPf3Bws3aexIsWF5nqIcluNXS6uhkoeVOLfO4jdQk+YwBdVT2qoXxAuAqYY7VZMwzj4Al08hgYgdL2JIaHpCKrfcL4sgACGFrPzo7tRy/7lLvBMPeKM+WAAR6gvFGuq27UoAfaeR3II4Vo1K0Z4s6Eh1ffS2CgklxmPk9kDgLHrIAhFPLD06ioyt8pm9Ieb+V5dOfvC9AC+RmXATU9nVCCAUIy8CiGjLGuLJRUqKygKYM3Sz2zzqo+ny1Mcy0UQRPdzeIfsrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(39860400002)(396003)(346002)(478600001)(110136005)(4326008)(54906003)(33656002)(41300700001)(2906002)(52536014)(7696005)(9686003)(8936002)(316002)(55016003)(38100700002)(83380400001)(122000001)(66446008)(82960400001)(26005)(8676002)(64756008)(38070700005)(5660300002)(186003)(66476007)(6506007)(66946007)(66556008)(71200400001)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTNneXpRQUZYbDByUWpYR1E3Wk4rVHg0eHppUURqTE1uZER0MmkrT25CUVRo?=
 =?utf-8?B?WG96QUFYb3Q4YUtDNlhVUmFZSUxrV0lGMmd1a1lxQVBGYmE0YVZ0Uk0rWkhO?=
 =?utf-8?B?NVhGdWVtMjRlT3RtWVhkbktUSjg3UlBjbFB5cGdLNit6YW5XTVE0TzdYQkUy?=
 =?utf-8?B?eUUwTlVwUDZoRG8rSnpTc0Q1VzRkU3VRQVlONFAxY0dsYUZvRkNpS2d0OXNZ?=
 =?utf-8?B?K3JzcW1yNjlNL0lwZzdMdzJsd0xIVW81RnJFZWE3RVo5c0pmeE9BaVJkckZ4?=
 =?utf-8?B?anAwSXpoTHlYM29LNDk5MEdlMStsa2I0d2tvdTQwNXdQbXN1Sm5ubzZ4SFVr?=
 =?utf-8?B?KzQ5N3g2dzhNVkg0aVUrSWNuMnRwWU5IRWg1Q1paQlgxbmJYM09RRGdBdmYv?=
 =?utf-8?B?akJQODRFSEVBdEVRTXFONllMMEloL0w4NzU0ZmM0a2x3ZXdwd2hzQkoyaWJn?=
 =?utf-8?B?eHkwSnhBT2NFdzVxTDJsSHFqOHk4cThXYVpaTEVKeFZGbW1iVTFCaVc4QWlC?=
 =?utf-8?B?ZFJWR1JXc2w4bVFOT3hOWHdwaDVuTm1wTEZCVm93N1NyN1AvMGN1MkRTUGda?=
 =?utf-8?B?aFA2cXFOT3UwQU5Ba2VKaHZ5VUVsaVh5SWZTMzlldi9FQ2pIYXdiVVRuS1lF?=
 =?utf-8?B?aHhpK25NVUp2Z051QjE0bmNxNkg0NEJuUEdMZE1kWVZVZnJSc0dxbUdjVXdL?=
 =?utf-8?B?VU9yUkJOTTVleHBCSUU0YkdtZGN4SGpjVGdQRXJORmdyYkk5Zk5tYnlweG1o?=
 =?utf-8?B?Q1pqVUVzYW1ZUTNkWWJ1UWRJTEU2b0kvYlo1eklQWTJZcGtCemdHRDNITnVx?=
 =?utf-8?B?dHVISVEyMDR1dk5MZG94UklzNjNqN1ovbXl3aEplS1BhVlRVVzM1NnIwV2Nv?=
 =?utf-8?B?dUxIbS94cWk4dXBMSjlGeXBTQ1BhMDZIYnlPVU9IcFJJYlh5MmJ0cFVMUjVY?=
 =?utf-8?B?WEpNL2ZiZFM3V0YyVFA4enpXZHhIUUZ3cHFqZDgrd3FOdi85US9ibW5QQzdY?=
 =?utf-8?B?QU01VGZWRkE2eHpYM2I1UmlFR1ZheVhCeXhmdEhCUnJFRUU0NjF1MXFyNmtP?=
 =?utf-8?B?M055SU9mYU1uaUNTNlpjbEJ6L2dpYnp4UHQxZHFWTERmUmxNcEVGdFJTQ3cx?=
 =?utf-8?B?OG50VnltVmxmc3UxZXh6Z2hicWlkV1FqMklzUmxvRkpRTERJVnBncVc0QUM2?=
 =?utf-8?B?RmhiajN5M3F0REZnZ0hJSXNyd3AzcVpscXozWXNyVk5JUi9VUm1qcVJ6YXBa?=
 =?utf-8?B?R21lYlVCSVVGRG41cjZjc25FaXdLMzVyZHJzRVNQTnVDaWJ2bzM0dm5mODZG?=
 =?utf-8?B?OGVEZDBwRERZeENCU1hKejdUNktoZktSMXJ0N3BaUUoxbmpvbHlROUpxSFN3?=
 =?utf-8?B?YVp1NndFb2R5WkdmUXRVbWJ2MjVKS3MyTzAvOUd0WE50ZGwwbDVjTmh2WWFp?=
 =?utf-8?B?Rmdad1RWRHlELzdrOHpZSFA3ZWpYOS9TOXI2akR6SXFqZHE2S3p2QTJWbnBG?=
 =?utf-8?B?MFVYZFJ5RzJqckVVNGtpR3NRWk5qRVYrUnpMbllNVEdoalByYWRSMXBNZjFW?=
 =?utf-8?B?eFErOSt0ZnQyY1Jtc2kzV1Bnc012K2dxSHhiWlhodmh3N25JQWtyVmVna3o1?=
 =?utf-8?B?VTZrdW9OMXZhdlRRSU85K3ZvcXFwZkNVZFE2dm04S1JYTG5JWlIyREtpelR5?=
 =?utf-8?B?VmtMZjBaWnh0a1R0N3QxZlV5K0NaeDZCSGZpb25xY3lBNDJvZVdvU29HUHhY?=
 =?utf-8?B?RnNHOXdXOCtaU0k3ZndkaFV2c0YyRmNJN3FNOXJ0cXlNNXJkMkt2eU1vbDRh?=
 =?utf-8?B?eE9OUS9PWm5USFRoRmFJVzJrdlVBdEd4WFpYYnZQakxDQ1AyT1FEbmdXb1FM?=
 =?utf-8?B?eHUzOENLblA0RkkzRmFxMFptbnh5YksvUFR1MnJ3RGtOOEhrVW4rcGcxUHBU?=
 =?utf-8?B?RDBNVTNZTVJwOFFqNm9XUzd4Syt0cG9LTHdmSXptbVltZUFEdFNaUTlYOWd5?=
 =?utf-8?B?VmsrbVlVdmZWSUxSellUdmRuNkNmajVKS2RSOHREZmFwQUh6aEp0Vm1Pbldh?=
 =?utf-8?B?clRJS3EzQ1pYcFk4Z2JFOENjTS9sTmY2Qk9uY0ZlMUNWdU95THB4RHN5OHYr?=
 =?utf-8?B?RUtyZ2p6bWsvcDNpczZPNERvTWRXU2tSVlBBd1UxUTdKVTI0K0x2enVvajZ1?=
 =?utf-8?B?eXVnNDl5WDNPaDI4QTZjNmtSN0hQZnUrNnZ2OGNtWW9WZS9GZGZ3ZHlEeGtl?=
 =?utf-8?B?QXc1TUxPRGsxZlRldEdCMVFVOXBONXpNSEJwU21TTDMyNzF4T0hOSVh5SlM1?=
 =?utf-8?B?NjhLbFc0VFZEb1oxZDB0YzlaSGN2bVQ4SEFNeU92bk1LMXZiR3kyQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8f3782-1eef-49df-f04c-08da5335ce4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 03:26:18.5529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhcUdJTrBztRv8/0vNa5PdTor3eyDDhCBSAUD3wqbbyF+9TwyVWvF0moTDozGYVlkAbN8i3sRyTvBLUwDaSJuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5800
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
SnVuZSAyMSwgMjAyMiAxMDo1OSBBTQ0KPiA+Pg0KPiA+Pj4gRldJVywgdGhpcyBjaGFuZ2Ugbm93
IGFsc28gZHJvcHMgZ3JvdXBfcnN3ZW0gYmVmb3JlIHNldHRpbmcgZGV2aWNlLQ0KPiA+Pj4ga3Zt
ID0NCj4gPj4+IE5VTEwsIGJ1dCB0aGF0J3MgYWxzbyBPSyAoYWdhaW4sIGp1c3QgbGlrZSB2Zmlv
X2RldmljZV9mb3BzX3JlbGVhc2UpIC0tDQo+ID4+PiBXaGlsZSB0aGUgc2V0dGluZyBvZiBkZXZp
Y2UtPmt2bSBiZWZvcmUgb3Blbl9kZXZpY2UgaXMgdGVjaG5pY2FsbHkgZG9uZQ0KPiA+Pj4gd2hp
bGUgaG9sZGluZyB0aGUgZ3JvdXBfcndzZW0sIHRoaXMgaXMgZG9uZSB0byBwcm90ZWN0IHRoZSBn
cm91cCBrdm0NCj4gPj4gdmFsdWUNCj4gPj4+IHdlIGFyZSBjb3B5aW5nIGZyb20sIGFuZCB3ZSBz
aG91bGQgbm90IGJlIHJlbHlpbmcgb24gdGhhdCB0byBwcm90ZWN0IHRoZQ0KPiA+Pj4gY29udGVu
dHMgb2YgZGV2aWNlLT5rdm07IGluc3RlYWQgd2UgYXNzdW1lIHRoaXMgdmFsdWUgd2lsbCBub3Qg
Y2hhbmdlDQo+IHVudGlsDQo+ID4+PiBhZnRlciB0aGUgZGV2aWNlIGlzIGNsb3NlZCBhbmQgd2hp
bGUgdW5kZXIgdGhlIGRldl9zZXQtPmxvY2suDQo+ID4+DQo+ID4+IHllcy4gc2V0IGRldmljZS0+
a3ZtIHRvIGJlIE5VTEwgaGFzIG5vIG5lZWQgdG8gaG9sZCBncm91cF9yd3NlbS4gQlRXLg0KPiBJ
DQo+ID4+IGFsc28gZG91YnQgd2hldGhlciB0aGUgZGV2aWNlLT5vcHMtPm9wZW5fZGV2aWNlKGRl
dmljZSkgYW5kDQo+ID4+IGRldmljZS0+b3BzLT5jbG9zZV9kZXZpY2UoZGV2aWNlKSBzaG91bGQg
YmUgcHJvdGVjdGVkIGJ5IGdyb3VwX3J3c2VtDQo+IG9yDQo+ID4+IG5vdC4gc2VlbXMgbm90LCBy
aWdodD8gZ3JvdXBfcndzZW0gcHJvdGVjdHMgdGhlIGZpZWxkcyB1bmRlciB2ZmlvX2dyb3VwLg0K
PiA+PiBGb3IgdGhlIG9wZW5fZGV2aWNlL2Nsb3NlX2RldmljZSgpIGRldmljZS0+ZGV2X3NldC0+
bG9jayBpcyBlbm91Z2guDQo+IE1heWJlDQo+ID4+IGFub3RoZXIgbml0IGZpeC4NCj4gPj4NCj4g
Pg0KPiA+IGdyb3VwLT5yd3NlbSBpcyB0byBwcm90ZWN0IGRldmljZS0+Z3JvdXAtPmt2bSBmcm9t
IGJlaW5nIGNoYW5nZWQNCj4gPiBieSB2ZmlvX2ZpbGVfc2V0X2t2bSgpIGJlZm9yZSBpdCBpcyBj
b3BpZWQgdG8gZGV2aWNlLT5rdm0uDQo+IA0KPiB5ZXMuIHRoaXMgaXMgd2h5IHZmaW9fZGV2aWNl
X29wZW4oKSBob2xkcyB0aGUgcmVhZCBsb2NrIG9mIGdyb3VwX3J3c2VtDQo+IGFyb3VuZCB0aGUg
ZGV2aWNlLT5ncm91cC0+a3ZtIGNvcHkuIEhvd2V2ZXIsIGZvciB0aGUgb3Blbl9kZXZpY2UoKSwN
Cj4gY2FsbGJhY2ssIEkgZG9uJ3QgdGhpbmsgaXQgaXMgbmVjZXNzYXJ5IHRvIGJlIHByb3RlY3Rl
ZCBieSB0aGUgZ3JvdXBfcndzZW0NCj4gbG9jay4NCj4gDQoNClRoZSBrdm0gb2JqZWN0IGNvdWxk
IGJlIGZyZWVkIGFmdGVyIGRldmljZS0+a3ZtIGlzIHNldCwgaWYNCmdyb3VwX3J3c2VtIGlzIG5v
dCBoZWxkIHdoZW4gY2FsbGluZyBvcGVuX2RldmljZSgpLiBUaGVuIHlvdSdsbA0KaGl0IGFub3Ro
ZXIgdXNlLWFmdGVyLWZyZWUgYnVnIHdoZW4gbWRldiBkcml2ZXIgdHJpZXMgdG8gb2J0YWluDQph
IHJlZmVyZW5jZSBvbiBrdm0uDQo=
