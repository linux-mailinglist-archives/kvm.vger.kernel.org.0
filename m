Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E513698C0
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243402AbhDWR7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:59:08 -0400
Received: from mail-eopbgr760050.outbound.protection.outlook.com ([40.107.76.50]:4737
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231735AbhDWR7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 13:59:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmuU2kiubABk2tq3cuZ5umGbizUhcScIlGCyf/Ohr/r3Lpg/u0ZJwUajAyykEKLwaQNN8FLWtJsM8DigS6pYz+fwLW7BEN7Qtd/1Twq0wwXTPdoUFQsyJBTvusEkUshaQki6goqYUeSjYrW8vUXKvwrjyJKg4P/tq8SkCeP8sv4DcP4pF06XfbgRb3jih2SXJUUu8WhhHIuSmhEZl3YI4Lu8/EeZdwVh58PUIRx1Mt/Z9eOQz9AQHVBQtDf+4vEzsgmhCPeIdUpreKpTN9tQLL7ck9GJUJQd7YCRNOe+pudhXkZ1VlzyS9FDzzJdMKMSV9nv3+pHf653yCKuIkkkbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ETihwrnD2hkjOyt1L6VBmHvDfneQw3gu3rq/Ra9h2A=;
 b=bC2uIDAHUGvmFpC2b0qmF7jLiRcY86/eb5I9593FuefHUCIER6CEWlv0gJnApwvsARCUQQMjxfOutHa9ug3w4Pf+I3ehAPqOxIzC4mSSNYCdVWq6Q2T9bDU2NBGs1XSrP96Dz1NOyAVP450hDTr84BoylpA97aaDrWXtQYsvtTfyD6JZvSwnShS2lsQtBBAPYfOQlFkN+u1+vVpL1ZrN6B4hJW5eGwJflu3czr+XYapsjXWISyYM4R7lUIcQKQ3wh2135n9UBegpEDl0/BoS89mKCpmIa4RnGbJJrfIKj9e3aEGRDicy4FSH0PTsi9mjzay8U7kus16wVdw786t9/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ETihwrnD2hkjOyt1L6VBmHvDfneQw3gu3rq/Ra9h2A=;
 b=jh999Ba05ksUYBYX1tFlznW3iTqknzlDMbdIjmGa8cHWYDXCfcrgPQ2yj4CCq3HjOiKnm/1+7ASS7+Kblb37XCfANvBEKVe4SQ0m/EuxJC6Cii5PmOkpCa1EbCVpvPqFr2C0LjFm2pgygDeW8w0f1e7JdlHEyxh1SZ0y+rv6YxqrQss6+YDCnCv5P7Ys5Gg7INrZKX38LJRU625QRqbpT21cbZoEDelpNDNrbnja/kmAeTrKuUbk+DzwwC+RmxFZs/DizFr3URIqXrXqFUVCK0jCUNWksG8AdpSo7z7cd6OU7tzkBuv4jGAepwrJsWpxxbZRBsI7A2paS3OUp+Cx7Q==
Received: from BY5PR12MB3764.namprd12.prod.outlook.com (2603:10b6:a03:1ac::17)
 by BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 17:58:23 +0000
Received: from BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af]) by BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af%7]) with mapi id 15.20.4042.024; Fri, 23 Apr 2021
 17:58:23 +0000
From:   Krishna Reddy <vdumpa@nvidia.com>
To:     Sumit Gupta <sumitg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "will@kernel.org" <will@kernel.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>,
        Sachin Nikam <Snikam@nvidia.com>,
        Bibek Basu <bbasu@nvidia.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>
Subject: RE: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHXCiaNb89RqsuC2kys/alJ4AtXCKppDBUAgFfxPgCAAW+8AIAAR1QAgAAFwgA=
Date:   Fri, 23 Apr 2021 17:58:23 +0000
Message-ID: <BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com>
References: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
 <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
 <YILFAJ50aqvkQaT/@myrica> <5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com>
In-Reply-To: <5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ccd24c6-ff54-411f-aaaf-08d906816320
x-ms-traffictypediagnostic: BY5PR12MB4066:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4066AD24F00DC3A4E4BD44E6B3459@BY5PR12MB4066.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RmOefzP9ahVShSNknDUeyp2zBkLZI3OizmVuQs+CePStx0MgTnAidKu0o8sSgaT8YObGd7eTI4vj/rZueogAVh+Rii5Q5i2CsKb9kDko/bgCRvxcVHeFDfh7m76gssj4jDsJ53FWJD64iKArMvGQH9aj3Uz61ctAiULM2B2Pg6H2nd2osXL0G5S79pxIfuKnXugmGk875jzwBIBQGx7jrxBfCPJAPkg1YCbhEfgaMvNPzaVh2YNjwlh8LFLPKydhUjnqwujbMKsHxyzzx6ClydnHgHAn2GxO7Pwx8qIdnO77ulvE59TSOPJ5046VThOsIE2VzM89RRaQf4V264DZ4AJ+1KVWMu0fcdn+W5WptjL10d/3Zjv7FzQfR1qsI7WHgVRPtTYrLKbsik8RbsAAzwkq8yhn7aWSjCjiifO7NkVX1Unbcy9UiHoCtfJ0ys5BFobEd4IfSXY9TzX67f6QS4IwA/dDlS27EXBdFp5bQbl29N2a+L8SQMdFuqG0LwZnHYY4cSKrqoozXh2iNILEeEmuBuRjd6dggFJz2znul02BnMcg/lWVLSNhc01x/EVsOaH0yVgQhurDQwZ+L15Dc4hLXMcLHvshmiyTrfnPV6I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3764.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(26005)(7696005)(71200400001)(54906003)(66446008)(5660300002)(6506007)(86362001)(2906002)(186003)(8936002)(122000001)(66476007)(38100700002)(64756008)(52536014)(33656002)(9686003)(4326008)(7416002)(83380400001)(66556008)(8676002)(107886003)(66946007)(110136005)(76116006)(55016002)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RDc2blRYQWZvZzRyMjdQbHZDWEQ0ZzJqWG5sdlNZZGNDbTJiVnduSjRGd1Br?=
 =?utf-8?B?K01vdUJKTHZDU0g1QmE3VGJFOEV6UDJyNmNFSk8yVHcrVWRSN3JPZnRUU2JO?=
 =?utf-8?B?ZWdMTzYzeCtmeE9kU3k5ZWl4RlZncTZkMU9nRy9kVTlHUCtrK2greTBKSVAy?=
 =?utf-8?B?RTRSWjJ6cktCU0k0NUg5WEtWSGp6Wlg0Q0ZGcStuYjdKQ29hTTByNFVXdkJj?=
 =?utf-8?B?THFkcDYwL09FOWVBd0ltZURjUVI2eENRVU1Wb3RGcWFJNTNSdjd5ZGVKd08r?=
 =?utf-8?B?MTlXMXNneUpwL081QW02Sk0zZEpxMlh3SS9PVVJOSEg1OGYxWExsN3czVFZw?=
 =?utf-8?B?WHFPRG5zZnFHbDduRGVwTzU2R01OT2VOa1d5aktQSVNRM29ibmxzSkxVT08x?=
 =?utf-8?B?RzB1THN5YnlhNWxXQkpSZFlsZkF6ZUM2NGJxWWEzYVpZRjZtMXo2U1phbjc5?=
 =?utf-8?B?a2FYYnhLZ1RobndoMDI2eEg5eTlSR1ZBR1dYNGtqNmc4cWZXaTAwSmxUUE9F?=
 =?utf-8?B?V2w4M21GblMxeEU0VjBtZWVlVmprbW00MTY2OURxUkdyeFNJZkxzNHFSdHVY?=
 =?utf-8?B?MU1xVlE2ZnRmQjgrSUV6KzcvUE9vT3hlb3NDdDJ3NW5QSVg3eGlDdWJEeEFG?=
 =?utf-8?B?MmVQZ1EzNnhETHhsaXV2NHJIZG85QnVNUzZGaCt1YWJJZVdUamlTS2h2ZkVv?=
 =?utf-8?B?Mk5QRkUveGpNUGE4QjlrbW5QdVNkMEVVNGVjT2dZaks1YWZuRG14Y0kycVVw?=
 =?utf-8?B?UTNrU29jVjlzOFZ1dS9obU4xeXp4UjcyZ3ZIb0JhMU9mS2UwZjBXMjk5eW1Q?=
 =?utf-8?B?dmVRMS9NWGRwVUZvM0x6Zm9QL3FxM2t4OWZiWCtIUG5FSVlQQVJTdDBJNW9D?=
 =?utf-8?B?R1k1V3FoWTZMKzJhblpoelJzbzMyNVRVNVdVc2V6MkdkWU5UNlRrRkd2emlR?=
 =?utf-8?B?bmgyWnA3cmRiZnM0SjRBeEdHUEtTMTl5cTRQdXc4WS9mZVpYSzdCWjBjWUZE?=
 =?utf-8?B?WmNZS3ZoSVBnWnZGVUdoSWlhR0xId3JQaVBvYjliRUphZjZMUjhMMU40dlZH?=
 =?utf-8?B?dVlSNTVBbk54S25BTXhHK2MvMnpOeHF2UWxNZFQ4aTlIKzI5eThWeGk2UU81?=
 =?utf-8?B?SWNrbGdjL2JZZ0szK2xMb3g0Yng0SCtxNFpZd21yMjZMQUViRzNoZXZ2RjVZ?=
 =?utf-8?B?dlRaU0IwYXNWazlMY0RTTlJUd3lxYTFpRkpwQjFib0xmYWE4a2FCc05hU0RT?=
 =?utf-8?B?SFl1MFZTaTRheW9ZK1JseWhpYWNvalAvZkRMZURmYlNaK21SRXFRMjVNTWJs?=
 =?utf-8?B?VGNtMVNqZVU1dTRGTUVrTE0wSjhhVlo5cHdQeW41MnduVE96eGsydTU0WHpW?=
 =?utf-8?B?Sy9oSzJzMVZXN0VFYlRKNkdYQmN4Tjg3TmVVdHBhVU9iY0RibUdDZjVoYk4w?=
 =?utf-8?B?SlRqSmthV3JXVmJacHQyTy81b2o3b3lUcWpzYXh3RXB4S1lrSk81M2oxemlZ?=
 =?utf-8?B?L2gwODFPNHUwbEdkNEdydDZmR3lZSjdrYm00S3J6RnVjMi84ek0xUzJINFZv?=
 =?utf-8?B?SnRYYUVKWldzQkkycCtJcjZtUWZOYWR0NW16MEJ4TnBWcjNMb2xXOTRoRUZs?=
 =?utf-8?B?NmFoMzVlWXpSaFRha3VtV01OcXNOVXNwQ1pUSjgxZGtsYmYyTk1ZWjdNM0Vp?=
 =?utf-8?B?THpXQzl4VEJKWEVHdmpqOExVTDY1R0lidHQyeW1rSzYvTk4veEU0OXVYZ2R5?=
 =?utf-8?Q?wFBLADQOBqizlAMsviMqKegVZDDw27PvP6YnXi4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3764.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccd24c6-ff54-411f-aaaf-08d906816320
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 17:58:23.2149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQ7qomwuPNRWxgQWp9YB0j1lHgnRy3VwzBE7uw6gmreIGykbDpo+OY7mQW+e72WSqEOo/JoqULHl0+ZM2ATOyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pj4gRGlkIHRoYXQgcGF0Y2ggY2F1c2UgYW55IGlzc3VlLCBvciBpcyBpdCBqdXN0IG5vdCBuZWVk
ZWQgb24geW91ciBzeXN0ZW0/DQo+PiBJdCBmaXhlcyBhbiBoeXBvdGhldGljYWwgcHJvYmxlbSB3
aXRoIHRoZSB3YXkgQVRTIGlzIGltcGxlbWVudGVkLiANCj4+IE1heWJlIEkgYWN0dWFsbHkgb2Jz
ZXJ2ZWQgaXQgb24gYW4gb2xkIHNvZnR3YXJlIG1vZGVsLCBJIGRvbid0IA0KPj4gcmVtZW1iZXIu
IEVpdGhlciB3YXkgaXQncyB1bmxpa2VseSB0byBnbyB1cHN0cmVhbSBidXQgSSdkIGxpa2UgdG8g
a25vdyANCj4+IGlmIEkgc2hvdWxkIGRyb3AgaXQgZnJvbSBteSB0cmVlLg0KDQo+IEhhZCB0byBy
ZXZlcnQgc2FtZSBwYXRjaCAibW06IG5vdGlmeSByZW1vdGUgVExCcyB3aGVuIGRpcnR5aW5nIGEg
UFRFIiB0bw0KPiBhdm9pZCBiZWxvdyBjcmFzaFsxXS4gSSBhbSBub3Qgc3VyZSBhYm91dCB0aGUg
Y2F1c2UgeWV0Lg0KDQpJIGhhdmUgbm90aWNlZCB0aGlzIGlzc3VlIGVhcmxpZXIgd2l0aCBwYXRj
aCBwb2ludGVkIGhlcmUgYW5kIHJvb3QgY2F1c2VkIHRoZSBpc3N1ZSBhcyBiZWxvdy4NCkl0IGhh
cHBlbnMgYWZ0ZXIgdmZpb19tbWFwIHJlcXVlc3QgZnJvbSBRRU1VIGZvciB0aGUgUENJZSBkZXZp
Y2UgYW5kIGR1cmluZyB0aGUgYWNjZXNzIG9mIFZBIHdoZW4NClBURSBhY2Nlc3MgZmxhZ3MgYXJl
IHVwZGF0ZWQuIA0KDQprdm1fbW11X25vdGlmaWVyX2NoYW5nZV9wdGUoKSAtLT4ga3ZtX3NldF9z
cHRlX2h2ZSgpIC0tPiBrdm1fc2V0X3NwdGVfaHZhKCkgLS0+IGNsZWFuX2RjYWNoZV9ndWVzdF9w
YWdlKCkNCg0KVGhlIHZhbGlkYXRpb24gbW9kZWwgZG9lc24ndCBoYXZlIEZXQiBjYXBhYmlsaXR5
IHN1cHBvcnRlZC4NCl9fY2xlYW5fZGNhY2hlX2d1ZXN0X3BhZ2UoKSBhdHRlbXB0cyB0byBwZXJm
b3JtIGRjYWNoZSBmbHVzaCBvbiBwY2llIGJhciBhZGRyZXNzKG5vdCBhIHZhbGlkX3BmbigpKSB0
aHJvdWdoIHBhZ2VfYWRkcmVzcygpLA0Kd2hpY2ggZG9lc24ndCBoYXZlIHBhZ2UgdGFibGUgbWFw
cGluZyBhbmQgbGVhZHMgdG8gZXhjZXB0aW9uLg0KDQpJIGhhdmUgd29ya2VkIGFyb3VuZCB0aGUg
aXNzdWUgYnkgZmlsdGVyaW5nIG91dCB0aGUgcmVxdWVzdCBpZiB0aGUgcGZuIGlzIG5vdCB2YWxp
ZCBpbiAgX19jbGVhbl9kY2FjaGVfZ3Vlc3RfcGFnZSgpLiANCkFzIHRoZSBwYXRjaCB3YXNuJ3Qg
cG9zdGVkIGluIHRoZSBjb21tdW5pdHksIHJldmVydGVkIGl0IGFzIHdlbGwuDQoNCi1LUg0KDQo=
