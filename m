Return-Path: <kvm+bounces-5069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A9681B621
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D9C1C23B3B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 12:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C324D73167;
	Thu, 21 Dec 2023 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e45/QJbB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CA6E2D2;
	Thu, 21 Dec 2023 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gS77CFBmEtpB8+yAGtSECy58GD2B8aSvOLAekQydNnS6aXn/LwCpPaualFzeKpiDQnFsxU5z4OBAflLWrIL4qnFtIHgzhAWlf5hrKXn+2xos8qQHgriXPOpyUDrf/BrgEh1SUDf5bu5phu4ckqWFLV8fGDhUTnTawIZeD3Zc3ChbTJunwIIxhWooL3jH7tGIDCg5grDuxBqYHTnY8Rp+hMh+ESClRosK82hOy5JKm50Ec8+9h4W1CsemX6ShAo30vflSlYJd/lhSs+0st/rZki6S60YTk3qxXWL6dYDLN/Mao+A0cJM36JEHN9ycowHHSFVwSCzatdPwU0fx+3JY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+A61rf0AlCfWu8VmOHACXOLpAkLuGQsNBSCJJ5qj/c=;
 b=EzE1sbExloeCLJGj6Yrkkye95x3yfMGvqNONIvhz4bG096aVXxQgyjLmsKpDrX/HY0ltzwRaSnGx3EaI3mNbeYpLxwBh9fmNYtk30YnOzROw/KqrlqoRMG4fQ/S0MBpzKwV2+2ls/U+obJBiWRuQ/AzfHi5KSNJFcJQLLkDGh1ptwRP9faZPUW/VBD8x6VHzz4z7zCx5wG1MX+Y6l5/CTKfYk9Ly+7wdl0XiBbix0RcfSITDtih53IZBS2Dau9fygRBsGzQhbuMct52RqHg3MJaP6aJoTSr2/JHavOGrO7UGXYitd/rNuVCiy0RnQCAMXzAknWCqgaymyF/pkbK9aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+A61rf0AlCfWu8VmOHACXOLpAkLuGQsNBSCJJ5qj/c=;
 b=e45/QJbBHIlzY6FEwH3JZzS9NUVbfWC7Jb5SYtIzoqUhUfYZUkIwwIc5GsEEcig9meiVepDe7ofnF5Jkyty+V9hyKLSPL5gLhO5/uy2gOseJ4xpa+iwJU058oFzNQ0KXndRWSN1dx+Okvj6GKjIQmCLVVofnOgvPuv8yzgCWpkP1Ak44gT3/w5yOKjiIACbHYaNKfHcd2uu8olMxJ0tOSnesD+5gI6CTUv8gweH0k2a+2IaUco7YNdJJQeSdhR0Pg26ZWRUJIdAjOaVWW0O9WvfM9Xc3Q7CSL3Ppdd1qBwx6f+q1XD2hKX7iFE/YfJCEc3HLONdtv1yRrK49tzfR1g==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Thu, 21 Dec
 2023 12:43:28 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 12:43:28 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
	<horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaMRy7X+OP5n0180qPNLjY5sy83LCvnbKAgAQDaPc=
Date: Thu, 21 Dec 2023 12:43:28 +0000
Message-ID:
 <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
 <20231218151717.169f80aa.alex.williamson@redhat.com>
In-Reply-To: <20231218151717.169f80aa.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|MW3PR12MB4395:EE_
x-ms-office365-filtering-correlation-id: 274b5b26-2c6a-46e1-dd80-08dc02226e62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 kYrVW9kMO0zTWJsilUks94Vql3uKz/TkHS8Cj/06HbNxWZ1nrOgf1H3Qw9ClJ7hT5n6b+uoy4VDY36fovRHwcukghGaYLlqvqJGdZbLFD4U/lXcP2QvD9oZxk542zd7Q3pf3a4cCfDTDdftU8z4NaYO0mr1hFlg48bc38XiA/c76glstjtU7H3F2m6sQXWLg+g8gZNQaD8aTQGd0OyQDcBmuH4aeR9iFnF4O9DvRkh7Bif9ywDAF4sBU4h0L+cL7/nx+j/5FZND6GAzNSgXNBaVGqFJZwq2QPvlNQ2w5+chl05waCACBXZLiqp17UY6QX+9btoL3hnKQ02H+tfqI3cep/ztjFfsY+rm4azYJMgdcTNWQliVNYBnODf3KdH1nONBgDhPRXb2yPs81/EoQCvBH9/dNB35HFdWM7EuVn6RYHocN6yAsU/9acd26QYk63+sxPSVDJlP6i4KFA93vM+MRj0NqyyjQweQonOlfX7AB9pI90qWMrPgQwbAoh0ENOxJHd9LFzIrI38eCzXGeWP63VbsNe2RczhGTO77gMA9cxbWfoQjdXAkwOKw4hkGBBuHdSY6+lMptE0cbwO1lmFQEH8YG17NVMMx+36JSAs/P70hhAI4HaFBoQTAe4Jte
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(376002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(26005)(9686003)(71200400001)(6506007)(7696005)(122000001)(5660300002)(83380400001)(52536014)(8676002)(8936002)(4326008)(41300700001)(66556008)(2906002)(478600001)(316002)(6916009)(76116006)(91956017)(66946007)(54906003)(64756008)(66446008)(66476007)(33656002)(86362001)(38100700002)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?1FTGIk2HzrEefL4jtodvRY1KAVzENcERxKFV7DG1y1BEi1CvAamrBB6Z+l?=
 =?iso-8859-1?Q?ol7bGKmcWugjkFJwQkUzCiDKy2i0uDP+7EwAsJjXIHSNHjBkmYYMvccpP1?=
 =?iso-8859-1?Q?DC3zhOn//iza+qgZCVZJOY6z8zIPDeidfv63xCe9VcaDzxNKeyTv5kRrcd?=
 =?iso-8859-1?Q?a40gtYbLpjMq/Z4yTlTqBxZL9AmtIWriiW86zANOHY2UJr/0qZb2IA6+oF?=
 =?iso-8859-1?Q?5fkIygkCi1fqxCMlIANPf8z5Gnt1nRzPnk+DynUDLnyLGDx533+Q1En+oM?=
 =?iso-8859-1?Q?SLc/0QJah3YtRzcUcU+FIaejf5oaKsbs0vdbNFseIMW4U7esbBnnNlLPFL?=
 =?iso-8859-1?Q?5eJkN0tqVYG2WLb3CYtbo6y5CLH6mAe+iNGWujtLYxIcCzdYRyl1CzV0mK?=
 =?iso-8859-1?Q?6sQ0edNAbkeKLLrxChnEmOdNmiRrE6PbEHuhFXMs/YX9Z/6SaJzqPoyjbc?=
 =?iso-8859-1?Q?62yhpShuV19N+SBNR2ENrjmTMcqlcsmgW6AANoKo8WUwCSZCevJDVVU7nH?=
 =?iso-8859-1?Q?BtpV81nxzfXF4m+8mVQRwN9mMnHjUIWhjhQwFGm6BjhJFoYX3+BJvPgwnL?=
 =?iso-8859-1?Q?idANUfTmFaE/OaRiZcLkCGxSVRBp2HkEI/qpCIy4KP2gjhrxqA0tJd2d/I?=
 =?iso-8859-1?Q?v7bR4GlGneEpZj7RTznsyNyGgeoDR9TbCdGx69vunv5kIuOxBE1az4z08X?=
 =?iso-8859-1?Q?fLj8ZaHllN1FsNCULCM5/Wya/7y5cdOUbr6FBsysSWGsH80EEC72Rbh/ZP?=
 =?iso-8859-1?Q?M9l9cXHkt5ImAcnQrWwAxAh9JYxhJpX0itKcKDYXxrwnSCpvmUlcwKlDyI?=
 =?iso-8859-1?Q?1XFiLIBki2yA7blvaL+GxtFfGb3gtQBzSAHiO1+g5YikNXN4iTTr1j/baj?=
 =?iso-8859-1?Q?k4B/e4rIM65BNE9L9nCYAMOsf33NSpp7keqSO0xbJhDzuzQoj+lFOTaJLL?=
 =?iso-8859-1?Q?wSvYdZdNZnnPR6+w9nALCq/VHaEI59tr1UucE9DTAM3a+yADHPbNaAbkEF?=
 =?iso-8859-1?Q?QbnwZ2yH5PHKvpM3Hno9V6jjyu/FCXHnvdU1slys+FaVnHX3Cec7lsmPIs?=
 =?iso-8859-1?Q?ICBga1tNxUoAta7ksN4FW6CZnrmqDZZnEsGH9WSRUJYvBOJcf6pN6hJUe4?=
 =?iso-8859-1?Q?VN+2eP/ykfFyUYORc0++LWaZZnpwb3kCVL2LhEVu5i3dmjqbHFnJx6MegQ?=
 =?iso-8859-1?Q?aTthBGavro99mYeVQdq48dWm2pL2EUXla3kCqoEtv9XnEleQGpcFKZZX6I?=
 =?iso-8859-1?Q?rkawFcppbgiWdttKO76ph40z4gzGiC8T2dsUdxjrM5Qpfw2gxCUReGLMhu?=
 =?iso-8859-1?Q?C5ZaWQvXot21XWwdgqHL+H0C9XmfbPUBA72EgpPmfsJnka/e4gFHP3Bo8O?=
 =?iso-8859-1?Q?y2KppItbBMYpGIkTiyE3o3TygYC8MpgJV1RdjXMUvPnkkrs4CVzBIcMOJX?=
 =?iso-8859-1?Q?uFutf4H8tGT4CQq7dSvVKPQM5we7dBZtxmdq74IaYVsCXx3XrVtRL1iYZ5?=
 =?iso-8859-1?Q?Awrk+/HF3d47bVaYaX+Q5w2Lrtj2Yzt9KWw3ruOzvciPPzE8W7+qPCmFcf?=
 =?iso-8859-1?Q?CG4Q0rweDHqM5odUZhSGwUeEk3VWpVaYCmJOpFQ9X6L+OtTMbTskE2YDGY?=
 =?iso-8859-1?Q?mL0VPEyWlw5Og=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274b5b26-2c6a-46e1-dd80-08dc02226e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 12:43:28.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92htGTQRoSMN/Dmg7Tii6pFZ323+JNjeIGMig6A5Hft8faOTyuVWa2/f4+YgGm8QsrvZGL2bXS8tg3cBY+1J3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

Thanks Alex and Cedric for the review.=0A=
=0A=
>> +/*=0A=
>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights rese=
rved=0A=
>> + */=0A=
>> +=0A=
>> +#include "nvgrace_gpu_vfio_pci.h"=0A=
>=0A=
> drivers/vfio/pci/nvgrace-gpu/main.c:6:10: fatal error: nvgrace_gpu_vfio_p=
ci.h: No such file or directory=0A=
>=A0=A0=A0 6 | #include "nvgrace_gpu_vfio_pci.h"=0A=
=0A=
Yeah, managed to miss the file. Will fix that in the next version.=0A=
=0A=
>> +=0A=
>> +static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 return (index =3D=3D RESMEM_REGION_INDEX ||=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0 index =3D=3D USEMEM_REGION_INDEX);=0A=
>> +}=0A=
>=0A=
> Presumably these macros are defined in the missing header, though we=0A=
> don't really need a header file just for that.=A0 This doesn't need to be=
=0A=
> line wrapped, it's short enough with the macros as is.=0A=
=0A=
Yeah that and the structures are moved to the header file.=0A=
=0A=
>> +=A0=A0=A0=A0 info.flags =3D VFIO_REGION_INFO_FLAG_READ |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VFIO_REGION_INFO_FLAG_WRITE |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VFIO_REGION_INFO_FLAG_MMAP;=0A=
>=0A=
> Align these all:=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 info.flags =3D VFIO_REGION_INFO_FLAG_READ |=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VFIO_REGION_INFO=
_FLAG_WRITE |=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VFIO_REGION_I=
NFO_FLAG_MMAP;=0A=
=0A=
Ack.=0A=
=0A=
>> +=0A=
>> +static bool range_intersect_range(loff_t range1_start, size_t count1,=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 loff_t range2_start, size_t count2,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 loff_t *start_offset,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 size_t *intersect_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 size_t *register_offset)=0A=
>=0A=
> We should put this somewhere shared with virtio-vfio-pci.=0A=
=0A=
Yeah, will move to vfio_pci_core.c=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, =
sizeof(val64),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count, &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bar_size =3D roundup_pow_of_two(nv=
dev->resmem.memlength);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->resmem.u64_reg &=3D ~(bar_s=
ize - 1);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->resmem.u64_reg |=3D PCI_BAS=
E_ADDRESS_MEM_TYPE_64 |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_BASE_ADDRESS_MEM_PREFETCH;=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val64 =3D cpu_to_le64(nvdev->resme=
m.u64_reg);=0A=
>=0A=
> As suggested and implemented in virtio-vfio-pci, store the value as=0A=
> little endian, then the write function simply becomes a=0A=
> copy_from_user(), we only need a cpu native representation of the value=
=0A=
> on read.=0A=
=0A=
Ack.=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(=
val16),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count, &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user((void *)&val16,=
 buf + copy_offset, copy_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EF=
AULT;=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (le16_to_cpu(val16) & PCI_COMMA=
ND_MEMORY)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->bar=
s_disabled =3D false;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->bar=
s_disabled =3D true;=0A=
>=0A=
> nvdev->bars_disabled =3D !(le16_to_cpu(val16) & PCI_COMMAND_MEMORY);=0A=
>=0A=
> But you're only tracking COMMAND_MEM relative to user writes, memory=0A=
> will be disabled on reset and should not initially be enabled.=0A=
=0A=
I suppose you are suggesting we disable during reset and not enable until=
=0A=
VM driver does so through PCI_COMMAND?=0A=
=0A=
> But then also, isn't this really just an empty token of pretending this=
=0A=
> is a PCI BAR if only the read/write and not mmap path honor the device=0A=
> memory enable bit?=A0 We'd need to zap and restore vmas mapping these=0A=
> BARs if this was truly behaving as a PCI memory region.=0A=
=0A=
I can do that change, but for my information, is this a requirement to be=
=0A=
PCI compliant? =0A=
=0A=
> We discussed previously that access through the coherent memory is=0A=
> unaffected by device reset, is that also true of this non-cached BAR as=
=0A=
> well?=0A=
=0A=
Actually, the coherent memory is not entirely unaffected during device rese=
t.=0A=
It becomes unavailable (and read access returns ~0) for a brief time during=
=0A=
the reset. The non-cached BAR behaves in the same way as they are just=0A=
as it is just a carved out part of device memory. =0A=
=0A=
> TBH, I'm still struggling with the justification to expose these memory=
=0A=
> ranges as BAR space versus attaching them as a device specific region=0A=
> where QEMU would map them into the VM address space and create ACPI=0A=
> tables to describe them to reflect the same mechanism in the VM as used=
=0A=
> on bare metal.=A0 AFAICT the justification boils down to avoiding work in=
=0A=
> QEMU and we're sacrificing basic PCI semantics and creating a more=0A=
> complicated kernel driver to get there.=A0 Let's have an on-list=0A=
> discussion why this is the correct approach.=0A=
=0A=
Sorry it isn't clear to me how we are sacrificing PCI semantics here. What=
=0A=
features are we compromising (after we fix the ones you pointed out above)?=
=0A=
=0A=
And if we managed to make these fake BARs PCI compliant, I suppose the=0A=
primary objection is the additional code that we added to make it compliant=
?=0A=
=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_map_device_mem(nvdev, index);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto read_exit;=0A=
>=0A=
> We don't need a goto to simply return an error.=0A=
=0A=
Yes, will fix that.=0A=
=0A=
>> +=A0=A0=A0=A0 if (index =3D=3D USEMEM_REGION_INDEX) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user(buf, (u8 *)nvdev-=
>usemem.bar_remap.memaddr + offset, mem_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
FAULT;=0A=
>> +=A0=A0=A0=A0 } else {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return do_io_rw(&nvdev->core_devic=
e, false, nvdev->resmem.bar_remap.ioaddr,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 (char __user *) buf, offset, mem_count, 0, 0, false);=0A=
>=0A=
> The vfio_device_ops.read prototype defines buf as a char __user*, so=0A=
> maybe look at why it's being passed as a void __user* rather than=0A=
> casting.=0A=
=0A=
True, will fix that.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Check if the bars are disabled,=
 allow access otherwise */=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 down_read(&nvdev->core_device.memo=
ry_lock);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (nvdev->bars_disabled) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 up_read(&n=
vdev->core_device.memory_lock);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EI=
O;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=0A=
> Why do we need bars_disabled here, or at all?=A0 If we let do_io_rw()=0A=
> test memory it would read the command register from vconfig and all of=0A=
> this is redundant.=0A=
=0A=
Yes, and I will make use of the same flag to cover the=0A=
USEMEM_REGION_INDEX cacheable device memory accesses.=0A=
=0A=
>> -static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_me=
m,=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 void __iom=
em *io, char __user *buf,=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t off=
, size_t count, size_t x_start,=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t x_e=
nd, bool iswrite)=0A=
>> +ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 void __iomem *io, char __use=
r *buf,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t off, size_t count, si=
ze_t x_start,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t x_end, bool iswrite)=
=0A=
>=0A=
> This should be exported in a separate patch and renamed to be=0A=
> consistent with other vfio-pci-core functions.=0A=
=0A=
Sure, and will rename with vfio_pci_core prefix.=0A=
=0A=
>> @@ -199,6 +199,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device =
*vdev, bool test_mem,=0A=
>>=0A=
>>=A0=A0=A0=A0=A0=A0 return done;=0A=
>>=A0 }=0A=
>> +EXPORT_SYMBOL(do_io_rw);=0A=
>=0A=
> NAK, _GPL.=A0 Thanks,=0A=
=0A=
Yes, will make the change.=0A=
=0A=
>./scripts/checkpatch.pl --strict will give you some tips on how to=0A=
improve the changes furthermore.=0A=
=0A=
Yes, will do that.=

