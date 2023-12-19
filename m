Return-Path: <kvm+bounces-4799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A139818620
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 12:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D72481F22C5A
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 11:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED92C154AE;
	Tue, 19 Dec 2023 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vv5x63Jh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A714F79;
	Tue, 19 Dec 2023 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9YIdkENfhO84iOHpcovSqqnaEKHucN+TaY6w6/i2771f/EBS0ckEZBFpS0rjR0bedUYgImwyIIaIBCNIgnPYRfZkAbQPxLhR95kXncMXSs6aO4JnEIAc9GYNwNvekEbj3EDTGrQPMSdB3uYZW0nG/vUieLf3WkEohkdotDXenX/LOm2yENwGhVhir9HzsO99ogLMO+jL7mLORKjCAvYfX6tU0U1VvXcEBqWJ7SPPnsp/4rc2WLVMZi6yS2q+a90eEFvI6gCHl9XNn2LMUMPNTcONCSrDAPuh037DBE89RPXx49JvvpLMVxxtMxweCY+meqTm2dWf3mlnFgf40MFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQ6beHdrztSHOx8U8afA0NsvP5SysHiURsBlEdwHUxU=;
 b=b/8pttc6W16k5L3zWIMUpggDOFQCuVBojJ3kEi2ZQwe11D5lhvoagwYDXOc+f5gkkzLIezVNm9giDYMtzWqQMgVU703j4z4IWhNQWxudnpPdm6kaPilsH871ZeaadN+dExaj2Ast1cUsCAs5pE9TJyQpMLY/rvMUy14mOWctxaBq2GwsP0syFKN3qHu9hROmVLlsyHyqN/GKxhCB89W5KvL9fOeI1uNo6+U6x3XtskP3O2IFECwvSCZJfnXGjMRr8uGR+RldXt5uC77S3NM+AR6I2tihkOgFJIkEuOJ1tNDlb5UZDPXTbC6r9NuqfKLM6GzKbty88rcEluyIuL7UZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ6beHdrztSHOx8U8afA0NsvP5SysHiURsBlEdwHUxU=;
 b=Vv5x63JhwlQ925O+1JvqpRVTLYTV0Qcho99cO8EScVNJsaxmvFxkWHY/1SFyD4/AhJX0lh2NkfYn8rS+Bg27IHh2lkRRi6xqeHI5nGLD99shLru8JE1DDBjjpAYRYGVURbnlSoxu4HfAFzhQVINYX1MFvCkkl1sZpy//EKdXl5cjSvC9Wa4wq4Fhofk9+9LIqDHeW2XWAc4M+kQszM/Rebjt4hEZ8HgQGAoCGOiBcAb0GL1W6nwqxs1Dmtu+88+dm1LEMnNXFhS9u67EQpu4/ZdfbRP6w9cPVfUIuIViZUakxOdcdDcsFiz5U8P+E8bHPEc/bbOIodgzERAuARmRFQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 11:16:06 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 11:16:06 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "mst@redhat.com" <mst@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index:
 AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAIAAAZuAgAAjJQCAACyCAIABLv6AgAAbWwCAAD6HgIABHtoAgAMXogCAAAnpAIAAFKuAgAAfSYCAASRLgIAAQLOA
Date: Tue, 19 Dec 2023 11:16:06 +0000
Message-ID: <60ed697361d5a366a3a9a7ce6c8d3602cba40491.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
	 <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
	 <20231214084526-mutt-send-email-mst@kernel.org>
	 <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
	 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
	 <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
	 <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
	 <CAJaqyWdv5xAXp2jiAj=z+3+Bu+6=sXiE0HtOZrMSSZmvVsHeJw@mail.gmail.com>
	 <161c7e63d9c7f64afc959b1ea4a068ee2ddafa6c.camel@nvidia.com>
	 <CAJaqyWf=ZtoSDGdhYrJdXMQuFvahzF5FtWkdShBmTGaewvQLrw@mail.gmail.com>
	 <7c267819eb52f933251c118ba2d1ceb75043c5b2.camel@nvidia.com>
	 <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com>
	 <8fc4e1f156b075ec3f4c65acc1e10439f767bf81.camel@nvidia.com>
	 <CAJaqyWe-nfb4F2PxTKz3R=fKf6EZzSbKSPm_SwdXjxQCybVmdQ@mail.gmail.com>
In-Reply-To:
 <CAJaqyWe-nfb4F2PxTKz3R=fKf6EZzSbKSPm_SwdXjxQCybVmdQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM4PR12MB5183:EE_
x-ms-office365-filtering-correlation-id: 05c6eb13-ce50-4d57-b0c1-08dc0083e512
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 HOuPBHE8Yg0CHzWS/lsqu3PNjjm/1R7lvjwdpXmP1Ygxlg2dfae4S/eHsMZNioNOsv+gxvAZIpsE+s6LliILR8PWXndjvgFT9hNTKRmwNjXLGtETMDUI8X1JX4wO512laOgnW85eNK7oQPO6LTphT4h3NjRKPvDIWyZP8kYa422fcrsD5E41L4Wwrn1LpbA1v/J0Z9Qk/9buAfCjukJIi7ugtTrUGy3Rne4uqeu7L0ldvG24RHJZaevd1ECynyZ8A41xEeRXFkovyLdHb/9kR5q8P+P+cS3h1TDT0GKJWLsbycE0jTiNGWm8mstflsP6S6iru0eoAR8pvw7/WmhQLsqbOJN0w+Ke/0mmWOjzjLmT0ukoxm6zOccALTZvDc36ULG/zJ+/8AeOnzWNOB/937kVwhKgDssNUkU0Zgyat89WNXsWYT0dtjdslbQQZuaNvuUF1mrTRtCAZscssPH7WZ7Fw0rqrKZuTZTy1sUyoR/XEGBFKDrqBYwMxLwLvBVkWnGD76kPHX7KVlxpE0hSN1LZBKn0PgIs2xtD6E+LKEnDVmftEl7rye3uV0mW4lOatWDDhLTTArlGZZKdwLDvoR1f5x/nBlD8B7ZGb3BObtnRATvFWMjdkFHHh8JXVjLMEaPeKfGSH/6kFlQgUqzBvLHkKVIqBT4amMOl0k+NMNA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(366004)(396003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(38070700009)(76116006)(86362001)(91956017)(36756003)(122000001)(38100700002)(83380400001)(2616005)(53546011)(71200400001)(66574015)(6486002)(8676002)(966005)(66446008)(66476007)(2906002)(478600001)(66556008)(4001150100001)(64756008)(54906003)(6916009)(316002)(66946007)(41300700001)(6512007)(6506007)(8936002)(5660300002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVhNd3pjS25WMDYxYTR6RTRjbGZGa3JSTktHVi8wNG4xaXE2K0EwUUJhKzZh?=
 =?utf-8?B?U1k0cFpIcEpxQ2hMV1g3b0RHd3BGRGtqcUtMZFVUK0pQTE5WMndTak9vQzNQ?=
 =?utf-8?B?SG03bWI0WWJUaDBSblI0bzA0Uzk2VlVqQ29hazhGWEJ6eWFTR3o5S09ZL3Bi?=
 =?utf-8?B?ZGRrTzdza1pjcFpyblhNOXJNbkljZkRVVXBYdE5TeHdwNDVGQ09Tc2N0Z0Rq?=
 =?utf-8?B?allkQStjWm5SVitVL01abEhmNU43T3hFZDh2b2JxZmc1UkNNcEdPNm5xRXFk?=
 =?utf-8?B?dk43V0c1cnVtQysxN3k2TmpQdkpvREJPa3ZPTzJRZmdYZmhvRzFJUHdhRkg2?=
 =?utf-8?B?MzhrZ1g5Q1ZtWGs5VWlHbzdtN2IxM25wYUI0cXVMeWxRTWJOVlhyM1J0OGRy?=
 =?utf-8?B?VnMvYnBlU3FGb3ltc2U3OENyMEVZa3BxdkdqSHR6NW1SSkhlMWxRd0cxYUx1?=
 =?utf-8?B?bTlpRWYvcmdLTndzaFNMK1B2ckc5eVYyN1hXYkFuVVBOVVc5enpGMG5uTnlq?=
 =?utf-8?B?YXRZYllpM2dzYzQ1QUVTZCtHL3JkYUJ3QWFQSmhZZXRRTHhMd2xreUJlK0hO?=
 =?utf-8?B?RDM4SXJRSDdLeFJBcXZLVUVSRWROYWpUejI0R0g3eDBoSUxaUi9rakZ4N25m?=
 =?utf-8?B?RG1ISEcxbjEwV1hubVIybmp4SVpTMHJCbmpUd2c2Z1ZYaHhCUnZHcG9OTlFa?=
 =?utf-8?B?V2FaeUxWdC8xNXpsQkIybEYyaTU3azdXd1VETkx3S2U0Z01hby82VWhQd0FZ?=
 =?utf-8?B?RWJ5K1ZSWXhiNHVPZGJoa2FSejg2MkFZUmlGLzFsNnc4OFpVay83dm40cUIv?=
 =?utf-8?B?anExRkh3ODNoVWRsb29UbVhDb1NwSUU5WGwySjI3TngxSmhCVzNsNFNrZW9t?=
 =?utf-8?B?UVRpb1BHS2lEYU82OEFnRzlaL1BUaEcyL3NjOHhWSHFIWWdxc1YrOFUzNTdu?=
 =?utf-8?B?VHM2VldMS1d5UDR3UEFNWjRWTVVJT1YzOTdxb0pZczU3Nk5Xd1h1SEhLUDdP?=
 =?utf-8?B?TWt2SkFzT0ZZNDVOblQyODJET2F6Y1orK2lLTDVTMlY5elVmTmVGbVlkelRE?=
 =?utf-8?B?NWJxYVVmbnhETFBBNmxDTW9rODY0eFI3eXhocGx1K3BmOC9VRFF3U29neDN4?=
 =?utf-8?B?V1JHdTJDMmxMSWw2c2FuM29tejN3VWtEd0IyWHA5TVdSdzNEaXVxNDZZcVhj?=
 =?utf-8?B?Z1liTUFUNjRWc1B3ckVRY3RyYWVxVndGQ3BkMUhubndvaU9DSXBJbklLTGF2?=
 =?utf-8?B?Zm9xRENtSUtMdmIxaTlmNFl5M1dac1JDL2JPRW9EZnhyTjBzZ2EzZzJDN3dW?=
 =?utf-8?B?SGdzSFZOVVZueTRvazEwVzB4QzVsK0ZMOXVYNnVRRmhRbkNLeC8wbWZBcVJY?=
 =?utf-8?B?c3VYUXFlUUoydFRVdjlmbmRPZVM0NXl2Q3pVeUdlb3oyRHRCOUdsbGtZVjl6?=
 =?utf-8?B?Y3RvMHR1NndkYU9oeFd2UlZ0SUxhN28rWDFYS2JIQnRRVFhKcndpNFMrcjZB?=
 =?utf-8?B?QTBLeU1tVXVCbDZiSXhtUk5qcmNULzI0WkpJSlNNdFRjUmlHK3k0OEZ3QTkr?=
 =?utf-8?B?cGZvMURqempjSFhqVm1RbHZ6RS8xL0x3N3YxREVVRzEyYW5PMHJFRk0rQU51?=
 =?utf-8?B?WWV3YmNGU29ydHhRT3FzQ3B0OStpZEVMUlVoS2g3TWVSbkFyVTYzU0w5eTZU?=
 =?utf-8?B?dnRCT1hZeTFKbzBkMEcwaThFNEIvaXQ3bEhVVkdiTXFoODdEcm8rMm5UR0I4?=
 =?utf-8?B?K1ptTkVmak9vSGZWNFd5bkx3WG9pWU5IVEI5bm9Mak4vSHJjU2FDT05iWG16?=
 =?utf-8?B?bzlCYUd4YXp2c2FGNEpiWWo4YWNlOUQwaHpvTXJ2RFBxdkNZNW1tUTlGSloy?=
 =?utf-8?B?emRyTUgxMURyVjgvL2paWUFQN2xzSHN0RmNTYklDTEdqNmE3dEZiL05XbXRS?=
 =?utf-8?B?RlY0bnBmazE4Z2NUc0RVNDJKcUt6amgycmpsWmcrbFZnakRCMm5QYmxXZUJK?=
 =?utf-8?B?R3lydCt4K3V1eksrRVBjR1dqNlJhWmxiek95bE9wRDYyKzZnUWw3cDRzR05T?=
 =?utf-8?B?eTVTNk5SVG84U04reWFCcmtUWHIwTWgxWUVwVUdaWU5pUmk1TXlhcGhldGY3?=
 =?utf-8?B?TnFrNTY3RzZwbDBHRGxnR2V4VnVRN2kxbkVsYkMrTzI1SllxUkNHUWpWdGIr?=
 =?utf-8?Q?PWSMWClb0m1BvzqPlZTvqeEV6ggp4TQK8IDnDSosgCgi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F30B148E5D081E45AAF6602A251F1580@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c6eb13-ce50-4d57-b0c1-08dc0083e512
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 11:16:06.3331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: slXfpgvh2UhaoBpZ9Z/UGoTZV2WX4Tf3aeb0xHZuxoX4mC6recb68M9kHa8gWbEQqr2xCcuspAb+yTk6i9lp3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183

T24gVHVlLCAyMDIzLTEyLTE5IGF0IDA4OjI0ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gTW9uLCBEZWMgMTgsIDIwMjMgYXQgMjo1OOKAr1BNIERyYWdvcyBUYXR1bGVh
IDxkdGF0dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIDIwMjMtMTIt
MTggYXQgMTM6MDYgKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+ID4gT24g
TW9uLCBEZWMgMTgsIDIwMjMgYXQgMTE6NTLigK9BTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFA
bnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBNb24sIDIwMjMtMTItMTgg
YXQgMTE6MTYgKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+ID4gPiA+IE9u
IFNhdCwgRGVjIDE2LCAyMDIzIGF0IDEyOjAz4oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbiBGcmksIDIw
MjMtMTItMTUgYXQgMTg6NTYgKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBPbiBGcmksIERlYyAxNSwgMjAyMyBhdCAzOjEz4oCvUE0gRHJhZ29zIFRhdHVs
ZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gPiA+IE9uIEZyaSwgMjAyMy0xMi0xNSBhdCAxMjozNSArMDAwMCwgRHJhZ29zIFRhdHVs
ZWEgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gPiBPbiBUaHUsIDIwMjMtMTItMTQgYXQgMTk6MzAg
KzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiBP
biBUaHUsIERlYyAxNCwgMjAyMyBhdCA0OjUx4oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
PiA+ID4gPiA+IE9uIFRodSwgMjAyMy0xMi0xNCBhdCAwODo0NSAtMDUwMCwgTWljaGFlbCBTLiBU
c2lya2luIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gT24gVGh1LCBEZWMgMTQsIDIw
MjMgYXQgMDE6Mzk6NTVQTSArMDAwMCwgRHJhZ29zIFRhdHVsZWEgd3JvdGU6DQo+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiA+IE9uIFR1ZSwgMjAyMy0xMi0xMiBhdCAxNTo0NCAtMDgwMCwgU2ktV2Vp
IExpdSB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiBPbiAxMi8xMi8yMDIzIDExOjIxIEFNLCBFdWdlbmlvIFBlcmV6IE1hcnRp
biB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IE9uIFR1ZSwgRGVjIDUsIDIw
MjMgYXQgMTE6NDbigK9BTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3Jv
dGU6DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IEFkZHJlc3NlcyBnZXQgc2V0IGJ5
IC5zZXRfdnFfYWRkcmVzcy4gaHcgdnEgYWRkcmVzc2VzIHdpbGwgYmUgdXBkYXRlZCBvbg0KPiA+
ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBuZXh0IG1vZGlmeV92aXJ0cXVldWUuDQo+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4N
Cj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gUmV2aWV3ZWQtYnk6IEdhbCBQcmVzc21h
biA8Z2FsQG52aWRpYS5jb20+DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IEFja2Vk
LWJ5OiBFdWdlbmlvIFDDqXJleiA8ZXBlcmV6bWFAcmVkaGF0LmNvbT4NCj4gPiA+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiA+IEknbSBraW5kIG9mIG9rIHdpdGggdGhpcyBwYXRjaCBhbmQgdGhlIG5l
eHQgb25lIGFib3V0IHN0YXRlLCBidXQgSQ0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
ZGlkbid0IGFjayB0aGVtIGluIHRoZSBwcmV2aW91cyBzZXJpZXMuDQo+ID4gPiA+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IE15IG1haW4gY29u
Y2VybiBpcyB0aGF0IGl0IGlzIG5vdCB2YWxpZCB0byBjaGFuZ2UgdGhlIHZxIGFkZHJlc3MgYWZ0
ZXINCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IERSSVZFUl9PSyBpbiBWaXJ0SU8sIHdo
aWNoIHZEUEEgZm9sbG93cy4gT25seSBtZW1vcnkgbWFwcyBhcmUgb2sgdG8NCj4gPiA+ID4gPiA+
ID4gPiA+ID4gPiA+ID4gPiA+IGNoYW5nZSBhdCB0aGlzIG1vbWVudC4gSSdtIG5vdCBzdXJlIGFi
b3V0IHZxIHN0YXRlIGluIHZEUEEsIGJ1dCB2aG9zdA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiA+ID4gZm9yYmlkcyBjaGFuZ2luZyBpdCB3aXRoIGFuIGFjdGl2ZSBiYWNrZW5kLg0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBT
dXNwZW5kIGlzIG5vdCBkZWZpbmVkIGluIFZpcnRJTyBhdCB0aGlzIG1vbWVudCB0aG91Z2gsIHNv
IG1heWJlIGl0IGlzDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBvayB0byBkZWNpZGUg
dGhhdCBhbGwgb2YgdGhlc2UgcGFyYW1ldGVycyBtYXkgY2hhbmdlIGR1cmluZyBzdXNwZW5kLg0K
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gTWF5YmUgdGhlIGJlc3QgdGhpbmcgaXMgdG8g
cHJvdGVjdCB0aGlzIHdpdGggYSB2RFBBIGZlYXR1cmUgZmxhZy4NCj4gPiA+ID4gPiA+ID4gPiA+
ID4gPiA+ID4gPiBJIHRoaW5rIHByb3RlY3Qgd2l0aCB2RFBBIGZlYXR1cmUgZmxhZyBjb3VsZCB3
b3JrLCB3aGlsZSBvbiB0aGUgb3RoZXINCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBoYW5k
IHZEUEEgbWVhbnMgdmVuZG9yIHNwZWNpZmljIG9wdGltaXphdGlvbiBpcyBwb3NzaWJsZSBhcm91
bmQgc3VzcGVuZA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IGFuZCByZXN1bWUgKGluIGNh
c2UgaXQgaGVscHMgcGVyZm9ybWFuY2UpLCB3aGljaCBkb2Vzbid0IGhhdmUgdG8gYmUNCj4gPiA+
ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBiYWNrZWQgYnkgdmlydGlvIHNwZWMuIFNhbWUgYXBwbGll
cyB0byB2aG9zdCB1c2VyIGJhY2tlbmQgZmVhdHVyZXMsDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiA+ID4gdmFyaWF0aW9ucyB0aGVyZSB3ZXJlIG5vdCBiYWNrZWQgYnkgc3BlYyBlaXRoZXIuIE9m
IGNvdXJzZSwgd2Ugc2hvdWxkDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gdHJ5IGJlc3Qg
dG8gbWFrZSB0aGUgZGVmYXVsdCBiZWhhdmlvciBiYWNrd2FyZCBjb21wYXRpYmxlIHdpdGgNCj4g
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiB2aXJ0aW8tYmFzZWQgYmFja2VuZCwgYnV0IHRoYXQg
Y2lyY2xlcyBiYWNrIHRvIG5vIHN1c3BlbmQgZGVmaW5pdGlvbiBpbg0KPiA+ID4gPiA+ID4gPiA+
ID4gPiA+ID4gPiA+IHRoZSBjdXJyZW50IHZpcnRpbyBzcGVjLCBmb3Igd2hpY2ggSSBob3BlIHdl
IGRvbid0IGNlYXNlIGRldmVsb3BtZW50IG9uDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
dkRQQSBpbmRlZmluaXRlbHkuIEFmdGVyIGFsbCwgdGhlIHZpcnRpbyBiYXNlZCB2ZGFwIGJhY2tl
bmQgY2FuIHdlbGwNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBkZWZpbmUgaXRzIG93biBm
ZWF0dXJlIGZsYWcgdG8gZGVzY3JpYmUgKG1pbm9yIGRpZmZlcmVuY2UgaW4pIHRoZQ0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gPiA+IHN1c3BlbmQgYmVoYXZpb3IgYmFzZWQgb24gdGhlIGxhdGVy
IHNwZWMgb25jZSBpdCBpcyBmb3JtZWQgaW4gZnV0dXJlLg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBTbyB3aGF0IGlzIHRoZSB3YXkgZm9y
d2FyZCBoZXJlPyBGcm9tIHdoYXQgSSB1bmRlcnN0YW5kIHRoZSBvcHRpb25zIGFyZToNCj4gPiA+
ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IDEpIEFkZCBh
IHZkcGEgZmVhdHVyZSBmbGFnIGZvciBjaGFuZ2luZyBkZXZpY2UgcHJvcGVydGllcyB3aGlsZSBz
dXNwZW5kZWQuDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ID4g
PiA+ID4gPiAyKSBEcm9wIHRoZXNlIDIgcGF0Y2hlcyBmcm9tIHRoZSBzZXJpZXMgZm9yIG5vdy4g
Tm90IHN1cmUgaWYgdGhpcyBtYWtlcyBzZW5zZSBhcw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiB0aGlzLiBCdXQgdGhlbiBTaS1XZWkncyBxZW11IGRldmljZSBzdXNwZW5kL3Jlc3VtZSBwb2Mg
WzBdIHRoYXQgZXhlcmNpc2VzIHRoaXMNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gY29kZSB3
b24ndCB3b3JrIGFueW1vcmUuIFRoaXMgbWVhbnMgdGhlIHNlcmllcyB3b3VsZCBiZSBsZXNzIHdl
bGwgdGVzdGVkLg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+
ID4gPiA+ID4gQXJlIHRoZXJlIG90aGVyIHBvc3NpYmxlIG9wdGlvbnM/IFdoYXQgZG8geW91IHRo
aW5rPw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+
ID4gWzBdIGh0dHBzOi8vZ2l0aHViLmNvbS9zaXdsaXUta2VybmVsL3FlbXUvdHJlZS9zdnEtcmVz
dW1lLXdpcA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiBJIGFtIGZpbmUgd2l0aCBlaXRoZXIgb2YgdGhlc2UuDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiBIb3cgYWJvdXQgYWxsb3dpbmcgdGhlIGNoYW5nZSBv
bmx5IHVuZGVyIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoNCj4gPiA+ID4gPiA+ID4gPiA+ID4g
PiAgIHZob3N0X3ZkcGFfY2FuX3N1c3BlbmQgJiYgdmhvc3RfdmRwYV9jYW5fcmVzdW1lICYmDQo+
ID4gPiA+ID4gPiA+ID4gPiA+ID4gVkhPU1RfQkFDS0VORF9GX0VOQUJMRV9BRlRFUl9EUklWRVJf
T0sgaXMgc2V0DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
Pw0KPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gSSB0aGluayB0aGUg
YmVzdCBvcHRpb24gYnkgZmFyIGlzIDEsIGFzIHRoZXJlIGlzIG5vIGhpbnQgaW4gdGhlDQo+ID4g
PiA+ID4gPiA+ID4gPiA+IGNvbWJpbmF0aW9uIG9mIHRoZXNlIDMgaW5kaWNhdGluZyB0aGF0IHlv
dSBjYW4gY2hhbmdlIGRldmljZQ0KPiA+ID4gPiA+ID4gPiA+ID4gPiBwcm9wZXJ0aWVzIGluIHRo
ZSBzdXNwZW5kZWQgc3RhdGUuDQo+ID4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+
ID4gU3VyZS4gV2lsbCByZXNwaW4gYSB2MyB3aXRob3V0IHRoZXNlIHR3byBwYXRjaGVzLg0KPiA+
ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiBBbm90aGVyIHNlcmllcyBjYW4gaW1w
bGVtZW50IG9wdGlvbiAyIGFuZCBhZGQgdGhlc2UgMiBwYXRjaGVzIG9uIHRvcC4NCj4gPiA+ID4g
PiA+ID4gPiBIbW0uLi5JIG1pc3VuZGVyc3Rvb2QgeW91ciBzdGF0ZW1lbnQgYW5kIHNlbnQgYSBl
cnJvbmV1cyB2My4gWW91IHNhaWQgdGhhdA0KPiA+ID4gPiA+ID4gPiA+IGhhdmluZyBhIGZlYXR1
cmUgZmxhZyBpcyB0aGUgYmVzdCBvcHRpb24uDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+ID4gV2lsbCBhZGQgYSBmZWF0dXJlIGZsYWcgaW4gdjQ6IGlzIHRoaXMgc2ltaWxhciB0byB0
aGUNCj4gPiA+ID4gPiA+ID4gPiBWSE9TVF9CQUNLRU5EX0ZfRU5BQkxFX0FGVEVSX0RSSVZFUl9P
SyBmbGFnPw0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4g
UmlnaHQsIGl0IHNob3VsZCBiZSBlYXN5IHRvIHJldHVybiBpdCBmcm9tIC5nZXRfYmFja2VuZF9m
ZWF0dXJlcyBvcCBpZg0KPiA+ID4gPiA+ID4gPiB0aGUgRlcgcmV0dXJucyB0aGF0IGNhcGFiaWxp
dHksIGlzbid0IGl0Pw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFllcywgdGhhdCdzIGVh
c3kuIEJ1dCBJIHdvbmRlciBpZiB3ZSBuZWVkIG9uZSBmZWF0dXJlIGJpdCBmb3IgZWFjaCB0eXBl
IG9mDQo+ID4gPiA+ID4gPiBjaGFuZ2U6DQo+ID4gPiA+ID4gPiAtIFZIT1NUX0JBQ0tFTkRfRl9D
SEFOR0VBQkxFX1ZRX0FERFJfSU5fU1VTUEVORA0KPiA+ID4gPiA+ID4gLSBWSE9TVF9CQUNLRU5E
X0ZfQ0hBTkdFQUJMRV9WUV9TVEFURV9JTl9TVVNQRU5EDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBJJ2Qgc2F5IHllcy4gQWx0aG91Z2ggd2UgY291bGQgY29uZmlndXJlIFNW
USBpbml0aWFsIHN0YXRlIGluIHVzZXJsYW5kDQo+ID4gPiA+ID4gYXMgZGlmZmVyZW50IHRoYW4g
MCBmb3IgdGhpcyBmaXJzdCBzdGVwLCBpdCB3b3VsZCBiZSBuZWVkZWQgaW4gdGhlDQo+ID4gPiA+
ID4gbG9uZyB0ZXJtLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gT3Igd291bGQgYSBiaWcgb25l
IFZIT1NUX0JBQ0tFTkRfRl9DQU5fUkVDT05GSUdfVlFfSU5fU1VTUEVORCBzdWZmaWNlPw0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSdkIHNheSAicmVjb25maWcgdnEiIGlz
IG5vdCB2YWxpZCBhcyBtbHggZHJpdmVyIGRvZXNuJ3QgYWxsb3cNCj4gPiA+ID4gPiBjaGFuZ2lu
ZyBxdWV1ZSBzaXplcywgZm9yIGV4YW1wbGUsIGlzbid0IGl0Pw0KPiA+ID4gPiA+IA0KPiA+ID4g
PiBNb2RpZnlpbmcgdGhlIHF1ZXVlIHNpemUgZm9yIGEgdnEgaXMgaW5kZWVkIG5vdCBzdXBwb3J0
ZWQgYnkgdGhlIG1seCBkZXZpY2UuDQo+ID4gPiA+IA0KPiA+ID4gPiA+IFRvIGRlZmluZSB0aGF0
IGl0IGlzDQo+ID4gPiA+ID4gdmFsaWQgdG8gY2hhbmdlICJhbGwgcGFyYW1ldGVycyIgc2VlbXMg
dmVyeSBjb25maWRlbnQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IEFjaw0KPiA+ID4gPiANCj4gPiA+
ID4gPiA+IFRvIG1lIGhhdmluZyBpbmRpdmlkdWFsIGZlYXR1cmUgYml0cyBtYWtlcyBzZW5zZS4g
QnV0IGl0IGNvdWxkIGFsc28gdGFrZXMgdG9vDQo+ID4gPiA+ID4gPiBtYW55IGJpdHMgaWYgbW9y
ZSBjaGFuZ2VzIGFyZSByZXF1aXJlZC4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+IFllcywgdGhhdCdzIGEgZ29vZCBwb2ludC4gTWF5YmUgaXQgaXMgdmFsaWQgdG8gZGVmaW5l
IGEgc3Vic2V0IG9mDQo+ID4gPiA+ID4gZmVhdHVyZXMgdGhhdCBjYW4gYmUgY2hhbmdlZC4sIGJ1
dCBJIHRoaW5rIGl0IGlzIHdheSBjbGVhcmVyIHRvIGp1c3QNCj4gPiA+ID4gPiBjaGVjayBmb3Ig
aW5kaXZpZHVhbCBmZWF0dXJlIGJpdHMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IEkgd2lsbCBwcmVw
YXJlIGV4dHJhIHBhdGNoZXMgd2l0aCB0aGUgMiBmZWF0dXJlIGJpdHMgYXBwcm9hY2guDQo+ID4g
PiA+IA0KPiA+ID4gPiBJcyBpdCBuZWNlc3NhcnkgdG8gYWRkIGNoZWNrcyBpbiB0aGUgdmRwYSBj
b3JlIHRoYXQgYmxvY2sgY2hhbmdpbmcgdGhlc2UNCj4gPiA+ID4gcHJvcGVydGllcyBpZiB0aGUg
c3RhdGUgaXMgZHJpdmVyIG9rIGFuZCB0aGUgZGV2aWNlIGRvZXNuJ3Qgc3VwcG9ydCB0aGUgZmVh
dHVyZT8NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IFllcywgSSB0aGluayBpdCBpcyBiZXR0ZXIg
dG8gcHJvdGVjdCBmb3IgY2hhbmdlcyBpbiB2ZHBhIGNvcmUuDQo+ID4gPiANCj4gPiBIbW1tLi4u
IHRoZXJlIGlzIG5vIHN1c3BlbmRlZCBzdGF0ZSBhdmFpbGFibGUuIEkgd291bGQgb25seSBhZGQg
Y2hlY2tzIGZvciB0aGUNCj4gPiBEUklWRVJfT0sgc3RhdGUgb2YgdGhlIGRldmljZSBiZWNhdXNl
IGFkZGluZyBhIGlzX3N1c3BlbmRlZCBzdGF0ZS9vcCBzZWVtcyBvdXQNCj4gPiBvZiBzY29wZSBm
b3IgdGhpcyBzZXJpZXMuIEFueSB0aG91Z2h0cz8NCj4gPiANCj4gDQo+IEkgY2FuIGRldmVsb3Ag
aXQgc28geW91IGNhbiBpbmNsdWRlIGl0IGluIHlvdXIgc2VyaWVzIGZvciBzdXJlLCBJIHdpbGwN
Cj4gc2VuZCBpdCBBU0FQLg0KPiANCklmIGl0J3MgYSBtYXR0ZXIgb2Y6DQotIEFkZGluZyBhIHN1
c3BlbmRlZCBzdGF0ZSB0byBzdHJ1Y3Qgdmhvc3RfdmRwYS4NCi0gU2V0dGluZyBpdCB0byB0cnVl
IG9uIHN1Y2Nlc3NmdWwgZGV2aWNlIHN1c3BlbmQuDQotIENsZWFyaW5nIGl0IG9uIHN1Y2Nlc3Nm
dWwgZGV2aWNlIHJlc3VtZSBhbmQgZGV2aWNlIHJlc2V0Lg0KDQpJIGNhbiBhZGQgdGhpcyBwYXRj
aC4gSSdtIGp1c3Qgbm90IHN1cmUgYWJvdXQgdGhlIGxvY2tpbmcgcGFydC4gQnV0IG1heWJlIEkg
Y2FuDQpzZW5kIGl0IGFuZCB3ZSBjYW4gZGViYXRlIG9uIHRoZSBjb2RlLg0KDQpUaGFua3MsDQpE
cmFnb3MNCg==

