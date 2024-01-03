Return-Path: <kvm+bounces-5528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1B1822E2A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 14:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C38311F23BDD
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 13:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECE9199BD;
	Wed,  3 Jan 2024 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XO6tONyR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF826199A4;
	Wed,  3 Jan 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X++CiSAcI6lyzCpNX0ZS7E06iApnMwlj0+swU6Bs8geVuVALbAvZOarQd/MBfX3hH78xQ+GSNZS2GjBhfCjO4idulap6EJ/wwCxGrA5wsQEPsJeOVsqD2kmnINOCzH3RvqJamDVuiIWbYpSrx9N2lkcBq57CJ/pAj4PutEuLAJEKtVGhD63n+n3btKfZl45a77QEqw8lb7Ay7Wxo5H1hTmBUC38W8XF2sEsiuCMjYoyt2gSh56eNWNURdoxY4eE4wZSmj6SlgdUrLev5Fx2Qp56sANnA26WO32zJNdVKtAEBtRCuZ2gOTvVbUiS1YlKm31DwL5kqrRoHrWcDnVx9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XtNm69wVfGXhvrm0YidMRUvCGaTTcQLBUPyjMWSlwM=;
 b=SCaw693ECytl2bnVUboKq2WiXppDjdrWHFjoMbAIz/ISG5yfhHPyAfW4zfjPQueLGbQmhWW8x7q6n6s/xAHkUCoIkXO/QHNac0HMmOmuQTvnXZNc2GVpBsTks0nVGZw6m7eKg1hf03GYp8W6egzS5DES0MgbD2BbZ88QVr4eKuIb9AleasSQuUJo2s9JoNWydnphIb5pGxYEkiE7e1vCqocAc/hgMp6rF9fpLBiMU8tIw6r1EqGTSWTB7ge5Z+WrMNq0BZMovfMPXm9msWLPALDlScTTvRe3R1ylD2c4j7cKKLGdtyAISPFefNL3Yp32O5qQKtGcbMzo3QUxcKeC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XtNm69wVfGXhvrm0YidMRUvCGaTTcQLBUPyjMWSlwM=;
 b=XO6tONyRfZ7W4X5TXQRppTQO8lbBGynj5rpchX28L6dvszdMopZSWCu+Hd7AF6nEAoZwLNvMNuK9v1EVik+gcwUxw/9O+A1g44kMuDR7DYIsjzi9mPQ0dT5oVNKjrhQb83peK1pW1Pkga1RZSgKENm7r41400YRHtkWCPnQi/FGDt6XY+k4nTxveO1J3HHO5n6ZWqFkFgFXyZuc7rdxx2cmdNV892Sj1okxnkgK8Hot9Jn1UPV+nhqHMrAeedr7p8Rk/ZmC3NmEpBFVy21rQIeGlvqWbzYrCE1zsrVRq56mTpPdz2h5fs3cT7PRtyCVqiZ3VGKwpfyaE1NeRHHWjjg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by LV3PR12MB9259.namprd12.prod.outlook.com (2603:10b6:408:1b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 13:25:06 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 13:25:05 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Topic: [PATCH v3 1/2] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Index: AQHaKfZGSSuFcVD48E+1FMY2y579NLDIICcAgAAb1pM=
Date: Wed, 3 Jan 2024 13:25:05 +0000
Message-ID:
 <SA1PR12MB71994AC1346383F0D92E4B61B060A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-2-ankita@nvidia.com>
 <70c8336b-1244-45bd-b078-bb07f771741c@arm.com>
In-Reply-To: <70c8336b-1244-45bd-b078-bb07f771741c@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|LV3PR12MB9259:EE_
x-ms-office365-filtering-correlation-id: a5fc1469-e884-4fa2-d9e4-08dc0c5f664f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Ufk7z4Rz/eHCot6GWQtZ1E9NO7Lkgw/QwhDIv2Y+auNAuWeSmTA5kbW51Ze9317lQKzRMzlMCsoos14dayWLNp1YEPGsOQ02gdiJUE72o25N/Xehpm4NdDdqdiZYM+dVF7eiU9xjILgSHv1mreGAP7NjS6RpEEHs9ZpDh+ikdrF3TN/Oc4e7B3bmgqq5zPvBWwFnQqWjIAiqXsZA5LcsVC6kfpd5rQppzHCCRQo5Nn2pWRZbgijDOMCYqntdLLRO0gm+qzjb7UUJzzIghlsBxhVGrQ8gY4jUUpyW4YqEjEJ+t8n3tjgOY17XO1GPDIj75OKjXUybBxwE5yuIWyAIw+B21QYw+EfPZfpELwTz5fAdqAMCTGLXwVoBjYdnhwEFRW47+4dMHjfoRzmVkQ9q98vlnch+KoCeDNChG2qe9tT3lssUWJGKsSNGrXAQkaQRVnSC6xY6RgEeH0nTpfEQU24gu9e1m+F+dcBpZ6dpzGnev/1as4QZIkzJ9rBERaxfLYbMHYgN9u3ENLqGGwB/7fyiAmn0VB/XRgryN+g3JvKhm2sxSQlmcCTairNdd/NDLYzfNdlkEXB4ft/VhxLYiiWJ1WIaEX+ocSxVdFbDKe4vrlt2EAVNf731ZMf70NBrLiYFav0cD52t/zk78n1JjZfku4dMftoch8r41cB5EOMmacZmPgfKTbnw9GlRK2Lg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(2906002)(4744005)(7416002)(8676002)(8936002)(4326008)(33656002)(5660300002)(52536014)(54906003)(66446008)(66556008)(316002)(64756008)(66476007)(86362001)(966005)(55016003)(478600001)(6506007)(41300700001)(9686003)(7696005)(38070700009)(71200400001)(26005)(921011)(38100700002)(91956017)(66946007)(76116006)(110136005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?oPGn0RtcGinKSps2gi46zKCflkdoSpZTB1ryHT6SkKuOMHMeBEO+G6Ix6W?=
 =?iso-8859-1?Q?UV+zbfCRyWhCYB9Li/UIGbC+KIM/Gt2oURKnogmBCznlu+DQhW40AXQ1zf?=
 =?iso-8859-1?Q?h7zR+rEBEO5SeBUglBVP2GBOVqwaJZbPZazuxFG54izN5P4ibLNaWucrU6?=
 =?iso-8859-1?Q?RxME7yL7ZY9HRPrcoDF0sCdRTLGphoBTF2RsNBo1vi7WwcpaJxBjuDT+3B?=
 =?iso-8859-1?Q?DZXsJ040TziuXSZEUdb90E0L7jFOXtTcwKTj51dBdpfiZR5/dXKEMk8Pkk?=
 =?iso-8859-1?Q?/N7zn+goxSJbU3uZmnc2pPxVoGebwfNRfn96MQyv2SokcGxO5kMxWxCjQ8?=
 =?iso-8859-1?Q?5wX6COVnkIIULFdcNi+F+ASgOKsqQrWXppjx1zQ1QHg0nTV9e+TfxRT0yt?=
 =?iso-8859-1?Q?s9lMuwWzZV7XLuFnEWnCCpdUcd3xLnJw7kWUbJ1/+s+3AUSTvnjcRKfDZa?=
 =?iso-8859-1?Q?l8dVxg6h7c7irAwNG+XL0X+bTrD1lsUsge0UN6+HU0/88EcQ9LvGJzBbkK?=
 =?iso-8859-1?Q?g4cZyeoBGuRYm0wDxfvCTa7eEgDT/nWmIj7pAr3qgO/9THLxSymUdZ50qb?=
 =?iso-8859-1?Q?10yWJkUOZueNyoipJX1WMFCELyw+OqluALq2ooM9XU0R0MfpyW9nFPTmeU?=
 =?iso-8859-1?Q?XfnzDkUVPYkpQ2z1dnokEiUwrqb/653ctOR5IdBv42TPsgDb092EOP9ZcX?=
 =?iso-8859-1?Q?vVe7yct00lr3GKywg6u8wkv4acOcLAN3bBV8R2Se9+TEKpe9mOAv4fMegH?=
 =?iso-8859-1?Q?NDi0qFIqEhtjnTYgdMPVMuWnV+sHdGle7ol2IooVimv4UmW7qjVIz4OWvp?=
 =?iso-8859-1?Q?i6GDp3J22Q2Z637p+u6gx2QeHbcXjg4NEKfgUjaHAJuzKIPjrw1OfWJMDw?=
 =?iso-8859-1?Q?jalJqqWNtIKX3Z1amDOsAlOYvB2D5W6YafnoLm3wX8zFV7H4Q+AZuAmUDk?=
 =?iso-8859-1?Q?ozhm3PdH+lZBE9ZoNSOu6awRwR3vRclY+jNGcdzoHNMP/SiBHOk1c2GAzt?=
 =?iso-8859-1?Q?ixugORYFFjPmEqzkrAibkVGZHKQhRp8ThAZ6Szt2mWqChGRR2UaoPa1kIP?=
 =?iso-8859-1?Q?nyrBSpoejCRLmIH3QWw/sY4FYgzFAcgLm8g/gdudMPbIXlMAR7kTpCRlt4?=
 =?iso-8859-1?Q?YCddya85d2jKe99fAghpNj82T0hJgqYJQPS+dnW1KInzKs+KxK7caEVVZK?=
 =?iso-8859-1?Q?oH8WuYgsfzL3iyc2plEPzfd7As0Mmqo1UBXZjzml7F1LGBP9BRzVind3vF?=
 =?iso-8859-1?Q?Jc3//VeEiBqrYb9RPLq0Nd9boPDTGwU72sIkaZe9UvRFkvg0egGXGSr83N?=
 =?iso-8859-1?Q?XFBb7+w4ig8/vDvEzXJ+Um7P/J1YZa2f06wJ9qFLfwzYNOx1euIFQlrYJd?=
 =?iso-8859-1?Q?8uLqbg9zRGYu7Rpt9BVNLsPkbVCjJuyQ137NCX+rsk0wOxAaxvG46NRprF?=
 =?iso-8859-1?Q?MWjo+FkE1N38Go6J2KHdtJt0gDhyn7V7kE5SjEHz9+lQiBHmy4WsHOUpNh?=
 =?iso-8859-1?Q?hA8GK0YnJE/eO4dBCvRXAtb3IwfQnXpUL8H+SHa8/7I7LFjN6fT6qYFV4A?=
 =?iso-8859-1?Q?6RaX6njNQW2YucD6bNu1FPZb4VQR0ZZoazx8Ly4i7qYSJ0Gqbu1D6viJGE?=
 =?iso-8859-1?Q?xlTNVD/zUQ8GQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fc1469-e884-4fa2-d9e4-08dc0c5f664f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2024 13:25:05.7084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpJpFOWevh9ihbLMnMHXkkUjcCB0KoOaLXLu4xrk/PoUQ1AP/mw90hC7MS8yP1lpthUindv9puv79hnEYrZSkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9259

>> From: Ankit Agrawal <ankita@nvidia.com>=0A=
>>=0A=
>> For various reasons described in the cover letter, and primarily to=0A=
>=0A=
> Cover letter is not part of the git history. It doesn't hurt to repeat=0A=
> the same here for the sake of referring, given how important that is.=0A=
=0A=
Hi Suzuki, this is addressed in the latest version: =0A=
https://lore.kernel.org/all/20231221154002.32622-1-ankita@nvidia.com/=0A=

