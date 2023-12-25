Return-Path: <kvm+bounces-5228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E9481E141
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3B21F21D52
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF9152F62;
	Mon, 25 Dec 2023 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MjraoYCp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A815103F;
	Mon, 25 Dec 2023 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TebvQBDY20dlpreKvi25swg6Uq+maMnMUuHlxMI2C55XPmVfAN+bB7CgZQPIJfXAZfaOWn2KCx4B8aEbcQuB6JElH2vvPr+ex4zHNWIcbp21cb/GUg+nidCYi/rHJkYp3v44tkkC2fsxfLHNIzxdDbE8WYYC3oFTsxONv87M7BygluN//Eor07/3nCFADb8Nw6omORhRPH1PQ0RfzykzxdXIpEricQjH1jsdrtRsmsi//ZkKT3WtRkbk/iJelMaQIMVRReJ/EPGqszcozo7aw3XbP6Qbn1zDBQHjEq0w7bJuvUgo3+fIXec73ooT8dWIHdH3tNu8lWwV+mv8cSPkWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HpG8+A85gPQklA9yf7Xn/5iGDzlya9N9Jxsy8ipzFI=;
 b=NYM8k7SJm/pJkDET0sgAlkwhC5Chi6/R+pC0b/Mit8KaCdEXkaUsMXpwLeMz+vPTRmnMpCFWSumQpI0avfHjZAF+OzUe00v94/3jN8pMgpNWrH0C5rlNQqwxuSuM0zuyMc8wUCiQnAw7BN+7tsoxmFy2zXva2XVVAfZj1HJVrv3EQmWEfLLORgY7C4ClXewc4bJ8ekrcyXD06wPLIfpGZ03mGWDkCM347qZgc3k/Dj6M+EzILJ7aoh9ki6ObdYjZe7/09zuztuSPej7XL2758tSEKCTN7L0naD1yp1PAlxVHksMQQURQuhQd8lggYU/GJQ0RyiQ0l/ZuIoH13yJrng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HpG8+A85gPQklA9yf7Xn/5iGDzlya9N9Jxsy8ipzFI=;
 b=MjraoYCpsNlLgxJFJ7EDdPZCyOXKg/0AWaAVCZd/rYarS6h4zeFOpXzbrsl5giD0JonAU3IQUDfv8EK202DO0bAHnMD+O4kP7wopBr/sJP2eJTujRoHmJC9Cf7V/PbwfTdmtakWs1gYU3lRDVk5W29St4N1904HlzGc9ai4cdFvfwGOdMw1cJqTeGdwWwF0oCDyxUjuXYKmwdSMQDZiSQw/MaOEkeUpUpad/hRNSV/F2loPQoRLQNBvH+VdMaZwT9PgM030cydE0G+puiMBcg2KY1u+AuXJMC5bbzrxu++iE8/fR7MciLXJb86KedXPjIi9bjO0RK62kO1tpdVNDMA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH8PR12MB6700.namprd12.prod.outlook.com (2603:10b6:510:1cf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:09:23 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.026; Mon, 25 Dec 2023
 15:09:23 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/2] vdpa: Block vq property change in DRIVER_OK
Thread-Topic: [PATCH 0/2] vdpa: Block vq property change in DRIVER_OK
Thread-Index: AQHaNzg1RvmJ6ZT7YkSwTjp16iw3eLC6Eh2AgAAIIAA=
Date: Mon, 25 Dec 2023 15:09:22 +0000
Message-ID: <5c638566b18c211a2788ca7ce4937a4c727f4e2f.camel@nvidia.com>
References: <20231225134210.151540-1-dtatulea@nvidia.com>
	 <20231225093850-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231225093850-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH8PR12MB6700:EE_
x-ms-office365-filtering-correlation-id: 4115f1f8-a4eb-422c-1b5e-08dc055b7a2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 K1mSW7iAW5zQWadY7BVkX6i3ZJLBUcVDSjDKO/1CErpsUzomz4dEL/Rdxji/jOAOtU8BbXWKprewCzErNeEkUYTnr5PSUx0ui0JQrwuDp/5u0B6wYPl37QVtu3uVGdCu6JJoX4n6w6cprFTqS8C5wCYDY+zr05aJ98YlnfglowgMd4D3+TlE3Poao5t3VblCIz7CZBX/3JQd3IfF54Jk0lySiMAmVNZXUjR7/751O1CQ7jdThuuIXAnHxyibn0dle7GqkMPVg5yyJkSA7CYuTYJzw0Y0xQZOAti3iGCU0rFqEReA5MPXA6c9o6fKGBXCeAjrZIGjx+PSG6A8b69JZJqo/tcpBXryVfkPW+E6FCefc3mCsowOaGep5gqf5FRsaXpyZ5nGuUqbmlDMg0JcSKffEKdCGEbKA7b1unq1ns3N7lmtbhrcuQvkVyFXg5dRdPxQ+joGRkw6juFLXXuGC5KBM08GRV+FrQaGDcSsPwqhN8cVpW7n/mA5+m/iSabd66Ykbal5stnIV9ddrCq8RGtVefVEYLNkOpfbO+eG5CWSi6qR7eSVXo/hxFZu7kNd/h3Wdhq8wVxu8tYQqWdso4gfuAObm/HrXCIm4vEbOWfGy85hl3MSZOJze6+8uNtpNheDt9H5pevUiywWJGelE4PFKSGh+D6EG1GwqSaX58U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(6506007)(4001150100001)(6512007)(86362001)(2906002)(966005)(71200400001)(478600001)(122000001)(83380400001)(38100700002)(41300700001)(2616005)(4326008)(54906003)(316002)(36756003)(66946007)(76116006)(66556008)(6916009)(64756008)(66446008)(66476007)(91956017)(8936002)(6486002)(38070700009)(8676002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L3d3QVhiTWgrb1hBdEFzbEJkVU16eEdqOW8wRStUZ3JYaHBVMkszdnF1bHlU?=
 =?utf-8?B?YU05Tm1hWXRGYXhQbHdjdTZmdzEzRGpraENmcmVSTXo1MkI1bDhGRjJrTjVD?=
 =?utf-8?B?V011aUdWQVM0cTNvRis1dmszUGx0T2R1M2MwYkhYN0llc2M1ekllbWZiM3lR?=
 =?utf-8?B?WWZEbVV1WmJRdm1PVERlTGRYTjdVQmc3Y25kUS9nREdJdEJkODl0N2Mrdk5v?=
 =?utf-8?B?VllGclQ4WW1QZC9odTllTHhXdE50YzRxNU8velRKcTB6K2ZSRTZCdld5WXBG?=
 =?utf-8?B?NzRUeW5RWnRnN2dVUVAzaFNTN2hoOStRbFRvWlFmTEpJbDljQ0RyeXJpTFJi?=
 =?utf-8?B?dFY2Vmo0ZEZzMERHOGFNYlRHSGZLTjBRTzlmdlQrUEhTU3FuOFN3U0tXRzVN?=
 =?utf-8?B?d2tIby8vZjhrRE13SVFXdDh1ZkFhOERZZDVQTHc1L2hkZ2c0bVo3ZzJrNWFG?=
 =?utf-8?B?QjNCQlVhUjI3ZFIra3laSFk0WjVydEhPdjBxNzd5WDU0U0kzbEdFSWU5ZXdP?=
 =?utf-8?B?UXFMNjZwVUpVU3QzUElwZCtwWmw0T1RYZWZBaldKY1g1aTBrL2V3dkF6SDg2?=
 =?utf-8?B?YmhYdnBZM1FubjEvWkxjZ1dRNXAxTHM0aHQ0Q2wyODVQcW5JYkl6cFVLME5q?=
 =?utf-8?B?YUdxbSt2S05iMk9GUEp2aE91YmtwQWp2Y0dFdFJDQldjQzRoNjhsR3RzTFBW?=
 =?utf-8?B?UllFQmlNMGVnRmEyU0RQUmdWVGxmRjE4WkxLNGRqOXhobVd5cUpYeXVROTdj?=
 =?utf-8?B?UENPUFJoZjFMUHBDU2N3bm9zSjY1LzF2RnJPR1VIWGoyNzFOS0pKYnRkK0tM?=
 =?utf-8?B?NVRhRkM5aHFOOFU0VHNVMW1nbWU4RmpaS3VmSXd0Z2RKRkFyQndrUVZFb1R1?=
 =?utf-8?B?UCtRVm0rREVpdm40RlVJK2VUR1VDVEFsSDkxK2Zpa2ViUDRMdVJHOHZNekxw?=
 =?utf-8?B?WC9rYmFlamdLYUVLeGt3M3VaY3J3YVMxK0pENHprQTF6SkY5UENLRitjN2M2?=
 =?utf-8?B?UExwdExGcXFkTWl6THpoNVN2TnNXOUxESmtpTnJXSEtsc1lydDVEVlI2djdI?=
 =?utf-8?B?V1BwWEU1UWFnZUhZRngxdnM2ZXVKNHFTZUVaKzRLN2NhSlV3WGsxNk1MZEN0?=
 =?utf-8?B?U3B0elplanRzU0VJaFY3cW9VVXZIVytWeHpaWnhjMGt2ZEQ3N0xEb0Y4R1ZS?=
 =?utf-8?B?RmxVajZCL0ZMWkRwb2U2UC9UTmlWZWRaN0l5eXNtRzc5Uk56VFZxVTNHeVRt?=
 =?utf-8?B?cHZJVVYwVDc1UGJzZ3VCcUJPNWhJeUNkS3krSUI2d2luU2dKSmdPQ2o4RHd4?=
 =?utf-8?B?aks0ekh5VzR2Ni9Ebk14YWxzYUk2Q1d2VlcrU1VUL1VCTmVrMUMvTVRSZVh5?=
 =?utf-8?B?WUtYcHFVNkNIVWpsajFyVzF0QlpJWENMWUxMbm5GVW1WL2VpVnZwTUdYcEo2?=
 =?utf-8?B?V3dxdURUNVpFRkNBUmRkVjFhdzBUdzd1V2M5d0NzakpaZ1NyK2k0QmM5UDJF?=
 =?utf-8?B?eG13bmRSelRkQjFpaEtpMjlIMWp1Rzh0T3ZOUjhqY0JtdzlwQ3dHS2ZEWCtN?=
 =?utf-8?B?OGtLaTFDdUkwUW02YzlzSUU0eFRUT2NoOUZNT3YwQkg4VXc3b3loc3dRVFRa?=
 =?utf-8?B?QjcwN0Q1NGxyZ21uWllLOVRlN0d2Q1FRMXRYaGZRY2N6MHk0NmowS3JzTXk3?=
 =?utf-8?B?N1pHeXIyelI4OHlPdFIzQ1QveUVwc2R0enlScFdZS0VxR0VLYUZ1OStuTi9F?=
 =?utf-8?B?Q2Y1T3N0ZmswQnVpTlJFWFY1M1NhbXNJMVhTSjhlcXhwbW9Ib2QvYzhLZjFD?=
 =?utf-8?B?OFBTM0p1UGZHV0xpbGsxdWlXVnljOUNjYkN6S1czQzJGb2hTNG41cWFFWStm?=
 =?utf-8?B?Yk1sVjFyME02QTBOS0RjdGFSbURSWnVYb2JnTTlLSTBsR1BBNUtYdnBST2dW?=
 =?utf-8?B?UHdORUQ4NklPdStjUGVsQUpPQi91TU9rdWkwZ3B0eFJNVThsMHVqWjlRdkh6?=
 =?utf-8?B?aUhXamVhYnJFRWRoc3NkMlpKSEdDRWNXRXZPQXNJSG5qOGU0bmQvYXd3NGkx?=
 =?utf-8?B?REk2OURTaWNyS3U1OFR2Z2pVQ3ZzenZqSmZIT1N2eDMrb0QvV3AyRGd0Zk5M?=
 =?utf-8?B?L3MrbWpJNmJXd2ZLNEgzK1ovL3lpbi9pTnJFdnFlZGdSYklIRzhjRmZJZ1dO?=
 =?utf-8?Q?Ih3vIuBojW2Ob+DOkkCiBCNfp8r0ycr/xYmjLdN7VQt4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FF84A895E80E04ABA3A32EABDE1C833@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4115f1f8-a4eb-422c-1b5e-08dc055b7a2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 15:09:22.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: is3Ca0U/wnSsflYoKc7Hx68ONJBJD6iwNXd934AaEJYgJU1O7TDdlcuR0iC11uDg5MYUt4UgeGyx+NjHkrpEPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6700

T24gTW9uLCAyMDIzLTEyLTI1IGF0IDA5OjQwIC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIE1vbiwgRGVjIDI1LCAyMDIzIGF0IDAzOjQyOjA4UE0gKzAyMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IFRoaXMgc2VyaWVzIHByZXZlbnRzIHRoZSBjaGFuZ2Ugb2Ygdmly
dHF1ZXVlIGFkZHJlc3Mgb3Igc3RhdGUgd2hlbiBhDQo+ID4gZGV2aWNlIGlzIGluIERSSVZFUl9P
SyBhbmQgbm90IHN1c3BlbmRlZC4gVGhlIHZpcnRpbyBzcGVjIGRvZXNuJ3QNCj4gPiBhbGxvdyBj
aGFuZ2luZyB2aXJ0cXVldWUgYWRkcmVzc2VzIGFuZCBzdGF0ZSBpbiBEUklWRVJfT0ssIGJ1dCBz
b21lIGRldmljZXMNCj4gPiBkbyBzdXBwb3J0IHRoaXMgb3BlcmF0aW9uIHdoZW4gdGhlIGRldmlj
ZSBpcyBzdXNwZW5kZWQuIFRoZSBzZXJpZXMNCj4gPiBsZWF2ZXMgdGhlIGRvb3Igb3BlbiBmb3Ig
dGhlc2UgZGV2aWNlcy4NCj4gPiANCj4gPiBUaGUgc2VyaWVzIHdhcyBzdWdnZXN0ZWQgd2hpbGUg
ZGlzY3Vzc2luZyB0aGUgYWRkaXRpb24gb2YgcmVzdW1hYmxlDQo+ID4gdmlydHVxdWUgc3VwcG9y
dCBpbiB0aGUgbWx4NV92ZHBhIGRyaXZlciBbMF0uDQo+IA0KPiANCj4gSSBhbSBjb25mdXNlZC4g
SXNuJ3QgdGhpcyBhbHNvIGluY2x1ZGVkIGluDQo+ICB2ZHBhL21seDU6IEFkZCBzdXBwb3J0IGZv
ciByZXN1bWFibGUgdnFzDQo+IA0KPiBkbyB5b3Ugbm93IHdhbnQgdGhpcyBtZXJnZWQgc2VwYXJh
dGVseT8NClRoZSBkaXNjdXNzaW9uIGluIHRoZSBsaW5rZWQgdGhyZWFkIGxlYWQgdG8gaGF2aW5n
IDIgc2VyaWVzIHRoYXQgYXJlDQppbmRlcGVuZGVudDogdGhpcyBzZXJpZXMgYW5kIHRoZSBvcmln
aW5hbCB2MiBvZiBvZiB0aGUgInZkcGEvbWx4NTogQWRkIHN1cHBvcnQNCmZvciByZXN1bWFibGUg
dnFzIiBzZXJpZXMgKGZvciB3aGljaCBJIHdpbGwgc2VuZCBhIHY1IG5vdyB0aGF0IGlzIHNhbWUg
YXMgdjIgKw0KQWNrZWQtYnkgdGFncykuDQoNCj4gDQo+ID4gWzBdIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3ZpcnR1YWxpemF0aW9uLzIwMjMxMjE5MTgwODU4LjEyMDg5OC0xLWR0YXR1bGVhQG52
aWRpYS5jb20vVC8jbTA0NGRkZjU0MGQ5OGE2YjAyNWY4MWJmZmEwNThjYTY0N2EzZDAxM2UNCj4g
PiANCj4gPiBEcmFnb3MgVGF0dWxlYSAoMik6DQo+ID4gICB2ZHBhOiBUcmFjayBkZXZpY2Ugc3Vz
cGVuZGVkIHN0YXRlDQo+ID4gICB2ZHBhOiBCbG9jayB2cSBwcm9wZXJ0eSBjaGFuZ2VzIGluIERS
SVZFUl9PSw0KPiA+IA0KPiA+ICBkcml2ZXJzL3Zob3N0L3ZkcGEuYyB8IDIzICsrKysrKysrKysr
KysrKysrKysrKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiA+IA0KPiA+IC0tIA0KPiA+IDIuNDMuMA0KPiANCg0K

