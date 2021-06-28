Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7C3B567B
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhF1BLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Jun 2021 21:11:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:17068 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhF1BLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Jun 2021 21:11:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="207689850"
X-IronPort-AV: E=Sophos;i="5.83,304,1616482800"; 
   d="scan'208";a="207689850"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2021 18:09:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,304,1616482800"; 
   d="scan'208";a="558218221"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jun 2021 18:09:22 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 27 Jun 2021 18:09:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 27 Jun 2021 18:09:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 27 Jun 2021 18:09:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrjvSnPu4ha1IRXAOVM5rk9z1yR7uIi5r22UyBcUkGwXTwUENkREdMDrNoiTHm3a92e3R0qNFY3cMEQR/1m7CEe+nFK3N8FP0SEq9uGa8N/AA9VMrlyGlqO3fDyUEDhMQNrTtnlQA1Y3KQHWkvLwA9arTl6BZE6cTVWcu8I80w9zUyoKOC5pSZvLqst1O4nTd8cxxBOdL5osLH1M4e1lNLIdcqRBbepZQMIzkX0dS/76Qi2J4DbawQE8BAJsyj+RKUmMLgixTmaE/TFduHhcCWkVZz6xZm5kcnRn85GZjQB/JEnR4bTDYHJO8ZkppT0kQj4G4e+uycF0p57KTs11dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OW9RxNHvrCHsg7/9ecME3YJO92+2Y2cSoEWIAAbrkw=;
 b=DXRdYS4LlKfKR4AhNrZxnNNcvepG5xQtUuIMepyydz+88exzeZcpSswfV4lcZdO6Y1FwSoQtF0TySB3PWELqgu85KvusDZdNE0gAndXVEE05cChi555V6lX+gg1nDhiwuJV6v7bIzQhv5tSXRJUANJvNQJMpeCJhfl9jm/LJM9f/hYiXV21LYevOMBHKm2Y+5REhbfGxlg/xY3ERzfOCYRazDO7aQKDc6O7Lqivu3+zozrWuyQOKbBMPSeC0yxtNhCZVgDXQ74Xx9RwgLta/P9XnrKz2EqUBGbbiRcGew9Nb1hiLvA8AtR2fUAHhKIJB6thfjjbk63DSzxKZGvZESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OW9RxNHvrCHsg7/9ecME3YJO92+2Y2cSoEWIAAbrkw=;
 b=U4YMjqR1OlevrtNHu5nHq+Xbk3zKSD9iIllFq6xnnD4YdNplxRi0D596RZ4zWfEwJQxCYQVfKNaGfIna5gU7rZ3a/0lI5hta+eGnyPiyiRIc1CxABDgtVI3OYLDR8H3isovzNmcQo/GED2tw7HGw9hm954GcpjF2sh2gHoevDtw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1762.namprd11.prod.outlook.com (2603:10b6:404:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 01:09:18 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 01:09:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVAAA3a7AAEa314AAD0+zwAAeWnuUA==
Date:   Mon, 28 Jun 2021 01:09:18 +0000
Message-ID: <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
In-Reply-To: <20210625143616.GT2371267@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce13e175-73c0-4a70-b8eb-08d939d15aff
x-ms-traffictypediagnostic: BN6PR11MB1762:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1762A59798463086EA2ADF428C039@BN6PR11MB1762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AlIV/DYaQ9ZyNwYsNNnJhzooIM+/BY8JDlF+8kN1n73l0vLo3usVFN8TOteS5B+nqQG6yVL5tEcZCbreb2+5hiCHur/EGXLLMs8T8tEFNrIhfd8bju8MaQeZybbq/82PpGLMD8znp68eTBAK644vR3li5Pm/5PIMASUOsThos8C4FBmB4kgMuHPM+5/lbpwuupXSlhsCPb+dILcfyylezTnFyvLvzsKs7XWiMBkvcFmWHNDZdAINU+D08v21k/z8MTJlgl9AD6q4jIt4b5YnRY+l+ZK5/8sDXl+HEGKskObgzDa2WlX35L2CgIr1Yi7/LAwF4tbrgzlb2A1eYmMy8DXkBO5lrkymHtsMOqPrsgTYf/gV7YG55hS6dz5g29EL48BdaIwcXzYrgj+reCUvVVbYxqioS3OhM5zSR9tuG+dQe1yDA30ZVGS5Uxx5ZqHRffcPMiEmEHn+OKWXi9LKfIK29gPi4TULZpB7mOmTgWLLTwKruw+6JBcBwRaXSxoMhk6ddQqZI/jS88fEAzy9fjgUwcD4xCbIbI11OvwK+u/5PtPJ6G+vtxwRNeaAZ1ll7WDhrg0tbJlpBLpZU6MWUHGcGyqSnvKxbd0xTK5zpaDE7Vyl6xQm7D8y7pJHLre+8JuIIxKmBuOv5rxERWXNcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(478600001)(66446008)(64756008)(76116006)(52536014)(8936002)(66556008)(8676002)(7696005)(54906003)(26005)(316002)(38100700002)(4326008)(66476007)(66946007)(122000001)(6506007)(86362001)(5660300002)(186003)(71200400001)(83380400001)(6916009)(2906002)(55016002)(9686003)(7416002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFZoWmp3cHlhSURhWjVZMllKK2NrclNmRXhLZHloWk9WNHhIVWd5WWlHbWgz?=
 =?utf-8?B?Q1cxVGQ3SmNWeDBBdXpNejJUb3k3bG8vRWtjR3ZqS0tUdU1yMXp6bjJBVS9J?=
 =?utf-8?B?YngrWldYQTNZTDlxSDVDbXVFNFFpYjA3UHBVenNxN09yNndEcFU0TmN5S2ND?=
 =?utf-8?B?Y3NZRWh5cWtoNHR6dVA0bEpYNjFSSDJxV2NkNnFVeXg1WWVYQlhWSHp4ZzZ1?=
 =?utf-8?B?bW1sVmZ6akRYdGJMeGJlUUh2aFdkNWpJR2pXQkNaU1NCNU1oWDVWbWRlbWZE?=
 =?utf-8?B?TGxjS0RzQnlDU2hjWlBlQkpSMnQ5eG0zeFY0Tzh5VDgwK3JvMyt6MmdPT0ZD?=
 =?utf-8?B?QlE1RzEvTnEzRWgyYXg3cXVIai9Ka2RCOGY2ZkhhZEhLbTJUNW4xWFN5dDFY?=
 =?utf-8?B?ZGFGY0wwUGJVSjdTUkpQZHVYbkM0c1FtcHZ0UDVEZ2ZPL21aKzRmV0Rab2Yy?=
 =?utf-8?B?SnNrK01ZcmVwS25ENzZjOFZhd3g5Q2hNNnErN0diSE5hZ3Rsa081MncwYUVy?=
 =?utf-8?B?YTRwVkVrclhKRU4zTm5Lbmdvdk9QYzFiTE9CT3FXUFJlUWI4eDhKYjJGT0Jn?=
 =?utf-8?B?bTVPMUlEbjVpZm9XaXdYOVRhRyt4Z2NrdFZiaTFMLzJQZ3d3S1JZOElDbHFt?=
 =?utf-8?B?WWhLVUExRXhwUHBXWVI5dlo5clQ1aGlXeDNJTTJkbGMwMEoxemZ2NDErSGZH?=
 =?utf-8?B?ZktWcjltVGJUcjZXblpzOGRqQzVjcWhTQnRLeGhTOGhsYk5UV2M1cDlrSUhS?=
 =?utf-8?B?UFVNdWwvZjkvb3VPcnl3bVB2NEF2SkRkQjlDci8wQkl3Ynp5WEw4Nzg4S0tJ?=
 =?utf-8?B?NWo4SE92WnpnVjJRcGhYNHZ5aGdqTnltWktPNG1QMC9SeG9TRG5HUXozSzVa?=
 =?utf-8?B?dmgzVEdQYnAzYmVBb1F6OUNYZXBsaGRmUUszQjhYZmpVeUhySnhrM1ZodW5L?=
 =?utf-8?B?SzBkdWZMNFB5M0dYTHFuM082UUFLWXM4QkhlZVFTM0RRTXJqZzk1NE84c21o?=
 =?utf-8?B?QUNJblRSMGtRNWxxa2hNdXJrcHpRUnJmTHdEc05WelNwRXRGU2xOTDdQKzY3?=
 =?utf-8?B?bHY0YmFnVS9IQmlNRVRqOENVTmdVZWp3VUpQMit4TWpQeVVxNG5vMmdzelNL?=
 =?utf-8?B?ZHhDU0xGNStGOThVWENTamRpc1QxZHkweis1b1E3UU1NTk5xZmFKNGYxSGlx?=
 =?utf-8?B?N3BTcFlRckloejk1eWJ1YkhzTTVWRjRkdktIZVlBRnU2K0tWclFyS0JVaXNq?=
 =?utf-8?B?Yk5nbENDU3prcFpncjQ2ZkthaGlwT3MxRnVlRXdhU0dyWG43YjdZTWg1MHFs?=
 =?utf-8?B?S2ZRRXZKR3dXWVdHQXlaWUJjWW5pMG1iRkQxOGFlQW9yc0ZzUEhtODBuT3Bu?=
 =?utf-8?B?bzgwVjJ4ekx5ZnZhUmEyY2ZVc2Y1bHE1dS9iNHZsaHZ1a3R5RDNaUXp3L01B?=
 =?utf-8?B?bDBEeU5raTZPWEpaWGdhKzhtelE2em1WVmorRDEvK0l4MzFNeUtTVkhSYUFI?=
 =?utf-8?B?UGNUREZxYTQ2MmNTdnhWdko2QWQ3SDdvYlpVY2lhclpWZ2F2SXZ0WGlVMjRR?=
 =?utf-8?B?WFdScXI1ZVdMOUhWbit0eUFXV1dSSjZibVhabjFTV0NWY1VoVWlWamdIUUFo?=
 =?utf-8?B?ME5JY1V1ZElkcjgycWVvSmdxZ0ZtaDlyRWQ0L2J4WVJTZ3pNMTd6T2JMZ3l4?=
 =?utf-8?B?a09TNEI2Y0t4NmhzOENES1kzZVVTUGx3ZEFnV09CMzR4NjVZZFlEYjBhTXc5?=
 =?utf-8?Q?QyZmpOSBynQU/XhI5GhxEl7fFHhP23PuKHmC+5R?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce13e175-73c0-4a70-b8eb-08d939d15aff
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 01:09:18.5988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HODKmvhGot2pUpYucJNugW1bBMf3ctEOkdfgLr6eB9H4RgNz6UEWZkPTvp/+ZS14u31P+EWOp+O9Sk04t5fSDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEp1bmUgMjUsIDIwMjEgMTA6MzYgUE0NCj4gDQo+IE9uIEZyaSwgSnVuIDI1LCAyMDIxIGF0IDEw
OjI3OjE4QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiANCj4gPiAtICAgV2hlbiByZWNl
aXZpbmcgdGhlIGJpbmRpbmcgY2FsbCBmb3IgdGhlIDFzdCBkZXZpY2UgaW4gYSBncm91cCwgaW9t
bXVfZmQNCj4gPiAgICAgY2FsbHMgaW9tbXVfZ3JvdXBfc2V0X2Jsb2NrX2RtYShncm91cCwgZGV2
LT5kcml2ZXIpIHdoaWNoIGRvZXMNCj4gPiAgICAgc2V2ZXJhbCB0aGluZ3M6DQo+IA0KPiBUaGUg
d2hvbGUgcHJvYmxlbSBoZXJlIGlzIHRyeWluZyB0byBtYXRjaCB0aGlzIG5ldyB3b3JsZCB3aGVy
ZSB3ZSB3YW50DQo+IGRldmljZXMgdG8gYmUgaW4gY2hhcmdlIG9mIHRoZWlyIG93biBJT01NVSBj
b25maWd1cmF0aW9uIGFuZCB0aGUgb2xkDQo+IHdvcmxkIHdoZXJlIGdyb3VwcyBhcmUgaW4gY2hh
cmdlLg0KPiANCj4gSW5zZXJ0aW5nIHRoZSBncm91cCBmZCBhbmQgdGhlbiBjYWxsaW5nIGEgZGV2
aWNlLWNlbnRyaWMNCj4gVkZJT19HUk9VUF9HRVRfREVWSUNFX0ZEX05FVyBkb2Vzbid0IHNvbHZl
IHRoaXMgY29uZmxpY3QsIGFuZCBpc24ndA0KPiBuZWNlc3NhcnkuIA0KDQpObywgdGhpcyB3YXMg
bm90IHdoYXQgSSBtZWFudC4gVGhlcmUgaXMgbm8gZ3JvdXAgZmQgcmVxdWlyZWQgd2hlbg0KY2Fs
bGluZyB0aGlzIGRldmljZS1jZW50cmljIGludGVyZmFjZS4gSSB3YXMgYWN0dWFsbHkgdGFsa2lu
ZyBhYm91dDoNCg0KCWlvbW11X2dyb3VwX3NldF9ibG9ja19kbWEoZGV2LT5ncm91cCwgZGV2LT5k
cml2ZXIpDQoNCmp1c3QgYmVjYXVzZSBjdXJyZW50IGlvbW11IGxheWVyIEFQSSBpcyBncm91cC1j
ZW50cmljLiBXaGV0aGVyIHRoaXMNCnNob3VsZCBiZSBpbXByb3ZlZCBjb3VsZCBiZSBuZXh0LWxl
dmVsIHRoaW5nLiBTb3JyeSBmb3Igbm90IG1ha2luZw0KaXQgY2xlYXIgaW4gdGhlIGZpcnN0IHBs
YWNlLg0KDQo+IFdlIGNhbiBhbHdheXMgZ2V0IHRoZSBncm91cCBiYWNrIGZyb20gdGhlIGRldmlj
ZSBhdCBhbnkNCj4gcG9pbnQgaW4gdGhlIHNlcXVlbmNlIGRvIHRvIGEgZ3JvdXAgd2lkZSBvcGVy
YXRpb24uDQoNCnllcy4NCg0KPiANCj4gV2hhdCBJIHNhdyBhcyB0aGUgYXBwZWFsIG9mIHRoZSBz
b3J0IG9mIGlkZWEgd2FzIHRvIGp1c3QgY29tcGxldGVseQ0KPiBsZWF2ZSBhbGwgdGhlIGRpZmZp
Y3VsdCBtdWx0aS1kZXZpY2UtZ3JvdXAgc2NlbmFyaW9zIGJlaGluZCBvbiB0aGUgb2xkDQo+IGdy
b3VwIGNlbnRyaWMgQVBJIGFuZCB0aGVuIHdlIGRvbid0IGhhdmUgdG8gZGVhbCB3aXRoIHRoZW0g
YXQgYWxsLCBvcg0KPiBsZWFzdCBub3QgcmlnaHQgYXdheS4NCg0KeWVzLCB0aGlzIGlzIHRoZSBz
dGFnZWQgYXBwcm9hY2ggdGhhdCB3ZSBkaXNjdXNzZWQgZWFybGllci4gYW5kDQp0aGUgcmVhc29u
IHdoeSBJIHJlZmluZWQgdGhpcyBwcm9wb3NhbCBhYm91dCBtdWx0aS1kZXZpY2VzIGdyb3VwIA0K
aGVyZSBpcyBiZWNhdXNlIHlvdSB3YW50IHRvIHNlZSBzb21lIGNvbmZpZGVuY2UgYWxvbmcgdGhp
cw0KZGlyZWN0aW9uLiBUaHVzIEkgZXhwYW5kZWQgeW91ciBpZGVhIGFuZCBob3BlIHRvIGFjaGll
dmUgY29uc2Vuc3VzDQp3aXRoIEFsZXgvSm9lcmcgd2hvIG9idmlvdXNseSBoYXZlIG5vdCBiZWVu
IGNvbnZpbmNlZCB5ZXQuDQoNCj4gDQo+IEknZCBzZWUgc29tZSBwcm9ncmVzc2lvbiB3aGVyZSBp
b21tdV9mZCBvbmx5IHdvcmtzIHdpdGggMToxIGdyb3VwcyBhdA0KPiB0aGUgc3RhcnQuIE90aGVy
IHNjZW5hcmlvcyBjb250aW51ZSB3aXRoIHRoZSBvbGQgQVBJLg0KDQpPbmUgdUFQSSBvcGVuIGFm
dGVyIGNvbXBsZXRpbmcgdGhpcyBuZXcgc2tldGNoLiB2MSBwcm9wb3NlZCB0bw0KY29uZHVjdCBi
aW5kaW5nIChWRklPX0JJTkRfSU9NTVVfRkQpIGFmdGVyIGRldmljZV9mZCBpcyBhY3F1aXJlZC4N
CldpdGggdGhpcyBza2V0Y2ggd2UgbmVlZCBhIG5ldyBWRklPX0dST1VQX0dFVF9ERVZJQ0VfRkRf
TkVXDQp0byBjb21wbGV0ZSBib3RoIGluIG9uZSBzdGVwLiBJIHdhbnQgdG8gZ2V0IEFsZXgncyBj
b25maXJtYXRpb24gd2hldGhlcg0KaXQgc291bmRzIGdvb2QgdG8gaGltLCBzaW5jZSBpdCdzIGJl
dHRlciB0byB1bmlmeSB0aGUgdUFQSSBiZXR3ZWVuIDE6MSANCmdyb3VwIGFuZCAxOk4gZ3JvdXAg
ZXZlbiBpZiB3ZSBkb24ndCBzdXBwb3J0IDE6TiBpbiB0aGUgc3RhcnQuIA0KDQo+IA0KPiBUaGVu
IG1heWJlIGdyb3VwcyB3aGVyZSBhbGwgZGV2aWNlcyB1c2UgdGhlIHNhbWUgSU9BU0lELg0KPiAN
Cj4gVGhlbiAxOk4gZ3JvdXBzIGlmIHRoZSBzb3VyY2UgZGV2aWNlIGlzIHJlbGlhYmx5IGlkZW50
aWZpYWJsZSwgdGhpcw0KPiByZXF1aXJlcyBpb21tdSBzdWJ5c3RlbSB3b3JrIHRvIGF0dGFjaCBk
b21haW5zIHRvIHN1Yi1ncm91cCBvYmplY3RzIC0NCj4gbm90IHN1cmUgaXQgaXMgd29ydGh3aGls
ZS4NCj4gDQo+IEJ1dCBhdCBsZWFzdCB3ZSBjYW4gdGFsayBhYm91dCBlYWNoIHN0ZXAgd2l0aCB3
ZWxsIHRob3VnaHQgb3V0IHBhdGNoZXMNCj4gDQo+IFRoZSBvbmx5IHRoaW5nIHRoYXQgbmVlZHMg
dG8gYmUgZG9uZSB0byBnZXQgdGhlIDE6MSBzdGVwIGlzIHRvIGJyb2FkbHkNCj4gZGVmaW5lIGhv
dyB0aGUgb3RoZXIgdHdvIGNhc2VzIHdpbGwgd29yayBzbyB3ZSBkb24ndCBnZXQgaW50byB0cm91
YmxlDQo+IGFuZCBzZXQgc29tZSB3YXkgdG8gZXhjbHVkZSB0aGUgcHJvYmxlbWF0aWMgY2FzZXMg
ZnJvbSBldmVuIGdldHRpbmcgdG8NCj4gaW9tbXVfZmQgaW4gdGhlIGZpcnN0IHBsYWNlLg0KPiAN
Cj4gRm9yIGluc3RhbmNlIGlmIHdlIGdvIGFoZWFkIGFuZCBjcmVhdGUgL2Rldi92ZmlvL2Rldmlj
ZSBub2RlcyB3ZSBjb3VsZA0KPiBkbyB0aGlzIG9ubHkgaWYgdGhlIGdyb3VwIHdhcyAxOjEsIG90
aGVyd2lzZSB0aGUgZ3JvdXAgY2RldiBoYXMgdG8gYmUNCj4gdXNlZCwgYWxvbmcgd2l0aCBpdHMg
QVBJLg0KDQpJIGZlZWwgZm9yIFZGSU8gcG9zc2libHkgd2UgZG9uJ3QgbmVlZCBzaWduaWZpY2Fu
dCBjaGFuZ2UgdG8gaXRzIHVBUEkgDQpzZXF1ZW5jZSwgc2luY2UgaXQgYW55d2F5IG5lZWRzIHRv
IHN1cHBvcnQgZXhpc3Rpbmcgc2VtYW50aWNzIGZvciANCmJhY2t3YXJkIGNvbXBhdGliaWxpdHku
IFdpdGggdGhpcyBza2V0Y2ggd2UgY2FuIGtlZXAgdmZpbyBjb250YWluZXIvDQpncm91cCBieSBp
bnRyb2R1Y2luZyBhbiBleHRlcm5hbCBpb21tdSB0eXBlIHdoaWNoIGltcGxpZXMgYSBkaWZmZXJl
bnQNCkdFVF9ERVZJQ0VfRkQgc2VtYW50aWNzLiAvZGV2L2lvbW11IGNhbiByZXBvcnQgYSBmZC13
aWRlIGNhcGFiaWxpdHkNCmZvciB3aGV0aGVyIDE6TiBncm91cCBpcyBzdXBwb3J0ZWQgdG8gdmZp
byB1c2VyLg0KDQpGb3IgbmV3IHN1YnN5c3RlbXMgdGhleSBjYW4gZGlyZWN0bHkgY3JlYXRlIGRl
dmljZSBub2RlcyBhbmQgcmVseSBvbg0KaW9tbXUgZmQgdG8gbWFuYWdlIGdyb3VwIGlzb2xhdGlv
biwgd2l0aG91dCBpbnRyb2R1Y2luZyBhbnkgZ3JvdXAgDQpzZW1hbnRpY3MgaW4gaXRzIHVBUEku
DQoNCj4gDQo+ID4gICAgICAgICBhKSBDaGVjayBncm91cCB2aWFiaWxpdHkuIEEgZ3JvdXAgaXMg
dmlhYmxlIG9ubHkgd2hlbiBhbGwgZGV2aWNlcyBpbg0KPiA+ICAgICAgICAgICAgIHRoZSBncm91
cCBhcmUgaW4gb25lIG9mIGJlbG93IHN0YXRlczoNCj4gPg0KPiA+ICAgICAgICAgICAgICAgICAq
IGRyaXZlci1sZXNzDQo+ID4gICAgICAgICAgICAgICAgICogYm91bmQgdG8gYSBkcml2ZXIgd2hp
Y2ggaXMgc2FtZSBhcyBkZXYtPmRyaXZlciAodmZpbyBpbiB0aGlzIGNhc2UpDQo+ID4gICAgICAg
ICAgICAgICAgICogYm91bmQgdG8gYW4gb3RoZXJ3aXNlIGFsbG93ZWQgZHJpdmVyIChzYW1lIGxp
c3QgYXMgaW4gdmZpbykNCj4gDQo+IFRoaXMgcmVhbGx5IHNob3VsZG4ndCB1c2UgaGFyZHdpcmVk
IGRyaXZlciBjaGVja3MuIEF0dGFjaGVkIGRyaXZlcnMNCj4gc2hvdWxkIGdlbmVyaWNhbGx5IGlu
ZGljYXRlIHRvIHRoZSBpb21tdSBsYXllciB0aGF0IHRoZXkgYXJlIHNhZmUgZm9yDQo+IGlvbW11
X2ZkIHVzYWdlIGJ5IGNhbGxpbmcgc29tZSBmdW5jdGlvbiBhcm91bmQgcHJvYmUoKQ0KDQpnb29k
IGlkZWEuDQoNCj4gDQo+IFRodXMgYSBncm91cCBtdXN0IGNvbnRhaW4gb25seSBpb21tdV9mZCBz
YWZlIGRyaXZlcnMsIG9yIGRyaXZlcnMtbGVzcw0KPiBkZXZpY2VzIGJlZm9yZSBhbnkgb2YgaXQg
Y2FuIGJlIHVzZWQuIEl0IGlzIHRoZSBtb3JlIGdlbmVyYWwNCj4gcmVmYWN0b3Jpbmcgb2Ygd2hh
dCBWRklPIGlzIGRvaW5nLg0KPiANCj4gPiAgICAgICAgIGMpIFRoZSBpb21tdSBsYXllciBhbHNv
IHZlcmlmaWVzIGdyb3VwIHZpYWJpbGl0eSBvbiBCVVNfTk9USUZZXw0KPiA+ICAgICAgICAgICAg
IEJPVU5EX0RSSVZFUiBldmVudC4gQlVHX09OIGlmIHZpYWJpbGl0eSBpcyBicm9rZW4gd2hpbGUN
Cj4gYmxvY2tfZG1hDQo+ID4gICAgICAgICAgICAgaXMgc2V0Lg0KPiANCj4gQW5kIHdpdGggdGhp
cyBjb25jZXB0IG9mIGlvbW11X2ZkIHNhZmV0eSBiZWluZyBmaXJzdC1jbGFzcyBtYXliZSB3ZQ0K
PiBjYW4gc29tZWhvdyBlbGltaW5hdGUgdGhpcyBncm9zcyBCVUdfT04gKGFuZCB0aGUgMTAwJ3Mg
b2YgbGluZXMgb2YNCj4gY29kZSB0aGF0IGFyZSB1c2VkIHRvIGNyZWF0ZSBpdCkgYnkgZGVueWlu
ZyBwcm9iZSB0byBub24taW9tbXUtc2FmZQ0KPiBkcml2ZXJzLCBzb21laG93Lg0KDQp5ZXMuDQoN
Cj4gDQo+ID4gLSAgIEJpbmRpbmcgb3RoZXIgZGV2aWNlcyBpbiB0aGUgZ3JvdXAgdG8gaW9tbXVf
ZmQganVzdCBzdWNjZWVkcyBzaW5jZQ0KPiA+ICAgICB0aGUgZ3JvdXAgaXMgYWxyZWFkeSBpbiBi
bG9ja19kbWEuDQo+IA0KPiBJIHRoaW5rIHRoZSByZXN0IG9mIHRoaXMgbW9yZSBvciBsZXNzIGRl
c2NyaWJlcyB0aGUgZGV2aWNlIGNlbnRyaWMNCj4gbG9naWMgZm9yIG11bHRpLWRldmljZSBncm91
cHMgd2UndmUgYWxyZWFkeSB0YWxrZWQgYWJvdXQuIEkgZG9uJ3QNCj4gdGhpbmsgaXQgYmVuaWZp
dHMgZnJvbSBoYXZpbmcgdGhlIGdyb3VwIGZkDQo+IA0KDQpzdXJlLiBBbGwgb2YgdGhpcyBuZXcg
c2tldGNoIGRvZXNuJ3QgaGF2ZSBncm91cCBmZCBpbiBhbnkgaW9tbXUgZmQNCkFQSS4gSnVzdCB0
cnkgdG8gZWxhYm9yYXRlIGEgZnVsbCBza2V0Y2ggdG8gc3luYyB0aGUgYmFzZS4NCg0KQWxleC9K
b2VyZywgbG9vayBmb3J3YXJkIHRvIHlvdXIgdGhvdWdodHMgbm93LiDwn5iKDQoNClRoYW5rcw0K
S2V2aW4NCg==
