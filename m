Return-Path: <kvm+bounces-73025-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILqSODa3qml9VgEAu9opvQ
	(envelope-from <kvm+bounces-73025-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:15:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 494F321F810
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10270304B4C4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9B5382386;
	Fri,  6 Mar 2026 11:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SUZF9hcd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mjP/3ma5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A343803F6
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795695; cv=fail; b=ENvWpZZZxH4I/JjobcSIWjvt55Zx76knEnMJk/WH+YOvdaD7eaNtAI4jlWps622liftBmlD/brNxyI3L1Iqwc4Fs4lLX7y1eXufcP+INAUCHqKOfSkW/FNbl2As4mrLsf8+MPEpjItAYj5C5Bq/nVUvIcoEj4RBVJyrogconmeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795695; c=relaxed/simple;
	bh=TqH1vPtznFxHJNVmIfv9tuGNimop6woa8uGUCnbloUw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qxzufKA274C+fC02lGRu3c0Qb/MrEZmTwy0VSF7t7JaE0O1hAF5Z2digdUYBZIGZuZ0Ghd4SZud9Cop3cT0uOFPbCJ60NwwUTiJjJtvlvO7x6BXbrcDzATGnwXZKmlQwEy5taxHyoVJFMmmUTdyixaLL26U6DYCWBTp5y1MQcvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SUZF9hcd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mjP/3ma5; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6261u8aF3458457;
	Fri, 6 Mar 2026 03:14:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=58A7gVSBDoIXI865LwS0siM43Qnvj4CldYPnKK3Py
	7o=; b=SUZF9hcdXSV70qS0GF5QouuREa73iX8FPl67/ExU1gUCgtySURp0ISZdv
	d1SwgqzDX0hb29YvtE16F+5kXdDsCtNwW/4+J35Zf/i1v+rnwFtCjOpva+TpIJSk
	5bLs4Swcz7LvBu/BCEPRpf6SXY8l6W5nNjvtn7HEF0lqsp7cFFW0v3a8sCB2kots
	t4+MFwijxiNLHRfe1pCq2hYSy/VuIZfAxpRKJ1QjXZ/2/HOpD8wE1rxhlWeW5V4X
	qFyOtwp9MybN+FR2ffefJ1RRXOh0OFSFPMR6FM1eA372ppKnQalKWIuE7f4F0VpC
	Q52Wk72BSNjZ1KjjGwDJX4WRCjFJg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022080.outbound.protection.outlook.com [52.101.48.80])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4cq5nybydn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 03:14:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlFrbIYUaR1sd4/XdWxublwFGr7vYc3PJxHe5A0FizRaDnGM5GZOMMp2QEiabfw/Z58eWVbL4JZCDkJF1fCI+SkT9IQZT2wOdpvZuSA+Xtqv1avR5GrxpRUrY5jO/d+OJ4h0syoD9ajA2i0Oq5byPbjXlDrFBlHo8Pe1z/b6urgMhzcZopaHoFCavzar/30VPsgyAvNnmJW08WbdjnftaiFSU7w+wKVgN17w59EQBiXoT+ukhokr9p6etWi1t1dS3p4F1u69AU5Jy+C7iEwgncuLlfAdebAWsa3A1ZeM1Mv1MPTF2K9l0OIOmtheX4ND3BI5T8AwSYKCRVcgJR+tlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58A7gVSBDoIXI865LwS0siM43Qnvj4CldYPnKK3Py7o=;
 b=GYJ/Hmo35JKRISLo3DyxVjkAsGvn09yvsQ4MKiV+452hj0WEQYXt1ICwM2m3C165AXJY3ht+glozae9/KYpSZ6SC3UhDGFJ7jliYrQy/Odr4B1COUpjnBga2qJNhJHiuCwvU+3ftYv4rgn1ohk+smWY8nLY0VahCRKKzyeIXIor0qgvqtvXlfNoqQlXPhcSKi12gPQSetnot+7MBEit6pGMcolWzIxF45iEB0FE7wS/0WNuRVqGTyrrKM+C04/BUNQZJYE/vhn3TS9/g4Nc4t8OfDtCu5Zp+FnRiXgu98qGSF1jvhawpFZZe63a3d+/DyGwJx7C8EwmYatV9XbU3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58A7gVSBDoIXI865LwS0siM43Qnvj4CldYPnKK3Py7o=;
 b=mjP/3ma59YOMnFX/8Xd3+ey0YyGUZw/VuWXciUjazKRVtBvvVCqjKIMhmbTSe65R9OVDswhrcpDKWW6jWkhceSk0XmFoCBAzTOUDmCs60sLlFC0IQJ+QfKNtcms9hKhqcE5Qnaro18JGss9gpYt7gBo5/DnB0XfexUg3l7QJ9jPO9vHEr36nIrbP3Xut1gL3DiG27Ho8uvjcNFwhPL+4Csnvkg0eX9VSHgGWvafMNKp6nXdyUXfE5cyjlcdns+B5lMota2rHCv6V1Rtgwo65ejWAYjPGdd9aSuqFaa46iQt0Scw0YBZfOR7+QieeSYbueZZEe7BuSSC/GSRFsVkrhw==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by IA1PR02MB11080.namprd02.prod.outlook.com (2603:10b6:208:5d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 11:14:42 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%6]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 11:14:41 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        John Levon
	<john.levon@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] KVM: optionally post write on ioeventfd write
Thread-Topic: [PATCH] KVM: optionally post write on ioeventfd write
Thread-Index: AQHcqkAXe3rjUQIbRkmgogOxullAQLWfKcIAgAI2XNA=
Date: Fri, 6 Mar 2026 11:14:41 +0000
Message-ID:
 <DS0PR02MB9321E14799F20B9EEA1B1DB68B7AA@DS0PR02MB9321.namprd02.prod.outlook.com>
References: <aWakWRrEUeaIeVna@google.com>
 <20260302122826.2572-1-thanos.makatos@nutanix.com>
 <aajb1r7Al7mxK5Zf@google.com>
In-Reply-To: <aajb1r7Al7mxK5Zf@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|IA1PR02MB11080:EE_
x-ms-office365-filtering-correlation-id: b5140249-eb33-44b9-e2cc-08de7b71907a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 E1qGmc7ZmFUtFK4R5cCC04ISK2O5HRXhBTnCfgmuVpvhqSmwONIFgRVIdsyoLL+++zMB8gk+GXBQXxPkAms6OEHQGHitu9kMfFMIn70mduB0czFaFcK4JDbi3ppaCRkMVuh6mVa8d4TNcA2d/RHnAuQ0Jg4QktFYV7mcny7Dg0qZLGS9YfDn4pVpABWzJVDoCzq7LnXTWBYV1pS1XaVtym/mftSpLMC4BdP5GhLSDljgmH47v5D7HtQGiAMYHq5W1RNEe/vgJJ//ODrEH8Jk66270NOxCLB3tAnOZgN4rq7cQtr81SgPr+DQucmcN0CqGv6xeLYYTAMnWl/sVGkb10Vtrojkbhk/3Zd0Dl7SeC1xszdF7DdhCS4AvyBqYirFgJfrwJh8ZMcILlb7yn0PY/VB1PnYltihZMuNJnsMOpgQfjIJOVRYb79WYOt6qFlQihidOymf+LG8i+icPYKz6y0Kn+RNuMA+a3k1vmM/qdA9DoBe+nHh5IxDIHDPKiQX4yDhEjxPRFpNx4RArB/ZpLk0BozDGI2CeuiY+IBFxDWMGnTYCwfjF2JpLzDLJKaINReIlwYM9DzCdfsC+IWhQ7GhICg2WNI3Q/6gLCl1cRUtPNIFS+fnWmwbZnklnv2sqJI8Cqp1ST2Qi2hU9GXqtX/56IzObrX2jX8F/adTZbm0ZNa8Kyt7zuBbqGkW4tRmKv6bW+NEuo7q6YFv3I+BiE+5I6ZuXSlJ+7sHmSUngXN8nE5jbO5YIyKlJ1yte3YX7cGRXKsX0EL0zLDge8kV0v5v118x+aiX/zAuHQ7xc1A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?kaNjqEfFv9fy71iYwtAtxtJMAHPtl428tWN4Vsy1s5I697cuD/+MgyMRSmu4?=
 =?us-ascii?Q?ptFlG1sgX9iY+LrTjUF3keTFXQK/RNRVyC5GRuNIeoDA0arn8+RMfyFT5BzA?=
 =?us-ascii?Q?4TXhLSQYEL6E/Plbif65S3zBsT9RRQ7fwq7TqPJNwCRq321/doZtC94qTFnQ?=
 =?us-ascii?Q?w+Pi0RpmT/RR5JGYe32iUp/ki441rpTz/r+Q0u3gkG6OBWnZrZuFnhnnBW8u?=
 =?us-ascii?Q?fJ4FLCHrZ+ukXUFpPxOnanlTKPE/vDqB7ku2/3jxGBjxlmOpE1aqGmB71LtT?=
 =?us-ascii?Q?5mapMnl8dWJp/oq4uB2VYPh2fpX1VFDkzmtOC9MJwheEcGrAQVPi6OEeNF2c?=
 =?us-ascii?Q?lonNPpX3Nyl7/nOQWvXqK9qGiEJ5ozoeax9LS8C6VRTWYtBTUF/PxtLJl+rZ?=
 =?us-ascii?Q?+/VQeMQCsvNo6CL9lod9tmRuGZrWNYZRatCu1pyN9W2ucENMWicY/NxFAEhL?=
 =?us-ascii?Q?i9jjPuiHlS+TbTkPow6HE1rneo+PKwbtT+g8vUiWWtzDI9VTdMVETnAanUAS?=
 =?us-ascii?Q?zlo7WfpdL3YJl0bynEOKH/FWmHnoccaXKSoncnhLkadt7rqAT0hJzG/BMpJC?=
 =?us-ascii?Q?MbXxpQvdiVF8teBFMJDqDtv6LCLHH3LHZIInGVKwiqnS7ntFTtJe2gLxWq+i?=
 =?us-ascii?Q?0DL0VnGp39U8dVlb16JhqRrLoNiwmkckvPAepYpSq4pwIdYMFcyEFwZ+VZ+t?=
 =?us-ascii?Q?wsYf5SjBypDVUNKEFsb4z8qup3jB2zkCiUlK+pJQW6iQaFtDwo+t4zOKZAM8?=
 =?us-ascii?Q?HBJS6yluuPjLg+pDoHOs1LZJ/OrgnWz/auczKlGQ8xicziui+LQRpa7Bd66T?=
 =?us-ascii?Q?s66RdnHPviG3zgWxVbhNT7kuvKEzBjkOKdkdDrrjbtupgamxlX5NwXJI0+NF?=
 =?us-ascii?Q?aJCZ7MqcLTQIGfyArNFGHPpZBdYv83MYA12kOvNixw3aYZvHdz9Qi9yj2m85?=
 =?us-ascii?Q?1m7PSYTENSx156o+P7e23kTbmsTg6wxRnOTR3ikZjuGoYaPbvJu2RZ6zAYXu?=
 =?us-ascii?Q?6vd5FOiwKNo7fyL758RlnIzicu/xn5rs0Tx/iPJsGYfOxEGiuIvY9MuWcI5J?=
 =?us-ascii?Q?AH0ILnOliFASfJbBB3l+s0VfFk6TTwKt3ap6kTNnw69Dndg0i02E/9VaX8eT?=
 =?us-ascii?Q?5bbJ/cRzinD/Ks9G8ch4+MH6xSIeYVPRg1q9eJw6/g3eGCqsrPJs97dBluds?=
 =?us-ascii?Q?0n94m60gJEy+rI8r4VVYpWwIgav8gEgzZX+/X5PtrxLIQ4N/mLsWJl3syCG8?=
 =?us-ascii?Q?mK+YHsRCleoHQML+afgzu635iR2OhPbdAMLyLFmfLphyF6Pe2wQh9vvSmt87?=
 =?us-ascii?Q?g+z1RAHqZtYSD3NgjxSNYvy556uJUng43PzOC7TVcAy9zSFIObz1i2ydGkVy?=
 =?us-ascii?Q?+GXREoUnWDFiAi3zH5J070an6uZvBVGdjJcCcdEyG/OVlq3hLNAyann/itc0?=
 =?us-ascii?Q?Pq6AOKazO7CvOfFVX0/CXs40vi8CXXPBvxhC0I0beuXMKN2Q4nj30MEpO9ka?=
 =?us-ascii?Q?bG7LWM5sGP7FPTxJfINlCLcCObTgVXDCy5pPmXuOSx+oFIzi/kQfQ+lIg9zE?=
 =?us-ascii?Q?H0K20ULTorIgNN6OKRBBOLEZJ7hgT3fOOHgeCKy6M3hUx4vG6q1KgVaKA7gw?=
 =?us-ascii?Q?FI1ycCRuxrket5V6+g95S2I9JFaOiIxNLyNzcYBpRZfFhJpnqanvO4qMrxQG?=
 =?us-ascii?Q?R40OQbgft8OnffuzU21SzyTIp8pbUL1QqPjRdv2MTrC/1TC1gHc+6VRQqObZ?=
 =?us-ascii?Q?XAfJ58kFQA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB9321.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5140249-eb33-44b9-e2cc-08de7b71907a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 11:14:41.8487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJG/B86Nm8Qi99o3LxewanctTpxFBvceHVs+RF+a/VgJu6omqCq944E3aB7YMOAQ/eUzur+44nXL2taPY0XH5sARZFIYpmYWpVAzTGLZ1TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB11080
X-Proofpoint-GUID: AT8nFwtmHkRET5tSbUCxVW5R1BR9wbhO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEwNyBTYWx0ZWRfX9Jd0lxL6/51w
 pok6UwcStC2Cye25Vqyrcmn+9z3BO+/58LeDE8SCL9vASs+1L/9Qfa1nbGVbsOAb8vTnU0Kg3o8
 w/hSygwQUX4UmjPpuKmlzvXfL0rAOAahQgrUkhwHypFk/5kBKMEiXxpCsnoPTUuJi5YuSCEPnOm
 6nPg3FVBGc5DV0QxpIhVVadcTSFwjNVy/pgNY87Smv63YgA2M4YMoA2VCLB0WfP1SPB72Qq+4H+
 egcUs0ivAm31/RqejXMAVJZN57MsSMwwRuAIwCw3PmdbJoIq80bfkTRW0XMoAS8lLBmOXzaLRY2
 BP7Tn3krFujadMX2ZCo0kF88n+0PxbL763zo9agwn34AmstsFS0Du/41ZIVdWMsYvafs0Qn7Rv8
 3EbZ5/5yUvMET/YvTEky3loAU6wzm5WHDAwd1p9ZWrKwnnID04Ctncmjr8tepoPlsS1aN9nzHZy
 lli3sFLux0YcYsnJT0Q==
X-Authority-Analysis: v=2.4 cv=a8s9NESF c=1 sm=1 tr=0 ts=69aab724 cx=c_pps
 a=l7AlRFJyJD7ZaDWTaO3eeA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=RpNjiQI2AAAA:8
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=MrOsFUZ9AAAA:8 a=XC6rBx1SaeGTrriVeW0A:9 a=CjuIK1q_8ugA:10
 a=4xI4MK0b8u9MfzoJa_Je:22
X-Proofpoint-ORIG-GUID: AT8nFwtmHkRET5tSbUCxVW5R1BR9wbhO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Queue-Id: 494F321F810
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73025-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thanos.makatos@nutanix.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[nutanix.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REDIRECTOR_URL(0.00)[proofpoint.com];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 05 March 2026 01:27
> To: Thanos Makatos <thanos.makatos@nutanix.com>
> Cc: pbonzini@redhat.com; John Levon <john.levon@nutanix.com>;
> kvm@vger.kernel.org
> Subject: Re: [PATCH] KVM: optionally post write on ioeventfd write
>=20
> !-------------------------------------------------------------------|
>   CAUTION: External Email
>=20
> |-------------------------------------------------------------------!
>=20
> Please don't send patches in-reply to the previous version(s), it tends t=
o mess
> up b4.
>=20
> On Mon, Mar 02, 2026, Thanos Makatos wrote:
> > This patch is a slightly different take on the ioregionfd mechanism
> > previously described here:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_all_88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.ca
> mel-
> 40gmail.com_&d=3DDwIBAg&c=3Ds883GpUCOChKOHiocYtGcg&r=3DXTpYsh5Ps2zJvt
> w6ogtti46atk736SI4vgsJiUKIyDE&m=3DXKZUVVKO9SGqV_txMzP2_tgrfJrgB2lU
> 50rbshSY1i91mYQgU2LKO23a_If0S6GB&s=3Dkp06dnwO7ESRSZ1iL_VQw0yKD
> OOED0L4jHbNjj4FqgI&e=3D
> >
> > The goal of this new mechanism is to speed up doorbell writes on NVMe
> > controllers emulated outside of the VMM. Currently, a doorbell write to
> > an NVMe SQ tail doorbell requires returning from ioctl(KVM_RUN) and the
> > VMM communicating the event, along with the doorbell value, to the NVMe
> > controller emulation task.  With the shadow ioeventfd, the NVMe
> > emulation task is directly notified of the doorbell write and can find
> > the doorbell value in a known location, without the interference of the
> > VMM.
>=20
> Please add a KVM selftest to verify this works, and to verify that KVM re=
jects
> bad configurations.

Ack

>=20
> > Signed-off-by: Thanos Makatos <thanos.makatos@nutanix.com>
> > ---
> >  include/uapi/linux/kvm.h       | 11 ++++++++++-
> >  tools/include/uapi/linux/kvm.h |  2 ++
> >  virt/kvm/eventfd.c             | 32 ++++++++++++++++++++++++++++++--
> >  3 files changed, 42 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 65500f5db379..f3ff559de60d 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -639,6 +639,7 @@ enum {
> >  	kvm_ioeventfd_flag_nr_deassign,
> >  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
> >  	kvm_ioeventfd_flag_nr_fast_mmio,
> > +	kvm_ioevetnfd_flag_nr_post_write,
> >  	kvm_ioeventfd_flag_nr_max,
> >  };
> >
> > @@ -648,6 +649,12 @@ enum {
> >  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
> >  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> >
> > +/*
> > + * KVM does not provide any guarantees regarding read-after-write
> ordering for
> > + * such updates.
>=20
> Please document this (and more) in Documentation/virt/kvm/api.rst, not
> here.

Ack

>=20
> > + */
> > +#define KVM_IOEVENTFD_FLAG_POST_WRITE (1 <<
> kvm_ioevetnfd_flag_nr_post_write)
> > +
> >  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 <<
> kvm_ioeventfd_flag_nr_max) - 1)
> >
> >  struct kvm_ioeventfd {
> > @@ -656,8 +663,10 @@ struct kvm_ioeventfd {
> >  	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
> >  	__s32 fd;
> >  	__u32 flags;
> > -	__u8  pad[36];
> > +	void __user *post_addr; /* address to write to if POST_WRITE is set *=
/
> > +	__u8  pad[24];
> >  };
> > +_Static_assert(sizeof(struct kvm_ioeventfd) =3D=3D 1 << 6, "bad size")=
;
> >
> >  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
> >  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> > diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/=
kvm.h
> > index dddb781b0507..1fb481c90b57 100644
> > --- a/tools/include/uapi/linux/kvm.h
> > +++ b/tools/include/uapi/linux/kvm.h
>=20
> Don't bother updating tools, the copy of uapi headers in tools is maintai=
ned by
> the perf folks (perf-the-tool needs all of the headers, nothing else does=
).
>=20
> > @@ -629,6 +629,7 @@ enum {
> >  	kvm_ioeventfd_flag_nr_deassign,
> >  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
> >  	kvm_ioeventfd_flag_nr_fast_mmio,
> > +	kvm_ioevetnfd_flag_nr_commit_write,
>=20
> Then you won't have amusing mistakes like this :-)

Ack

>=20
> >  	kvm_ioeventfd_flag_nr_max,
> >  };
> >
> > @@ -637,6 +638,7 @@ enum {
> >  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 <<
> kvm_ioeventfd_flag_nr_deassign)
> >  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
> >  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> > +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 <<
> kvm_ioevetnfd_flag_nr_commit_write)
> >
> >  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 <<
> kvm_ioeventfd_flag_nr_max) - 1)
> >
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index 0e8b8a2c5b79..019cf3606aef 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -741,6 +741,7 @@ struct _ioeventfd {
> >  	struct kvm_io_device dev;
> >  	u8                   bus_idx;
> >  	bool                 wildcard;
> > +	void         __user *post_addr;
> >  };
> >
> >  static inline struct _ioeventfd *
> > @@ -812,6 +813,9 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct
> kvm_io_device *this, gpa_t addr,
> >  	if (!ioeventfd_in_range(p, addr, len, val))
> >  		return -EOPNOTSUPP;
> >
> > +	if (p->post_addr && len > 0 && __copy_to_user(p->post_addr, val,
> len))
> > +		return -EFAULT;
> > +
> >  	eventfd_signal(p->eventfd);
> >  	return 0;
> >  }
> > @@ -879,6 +883,27 @@ static int kvm_assign_ioeventfd_idx(struct kvm
> *kvm,
> >  		goto fail;
> >  	}
> >
> > +	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE) {
> > +		/*
> > +		 * Although a NULL pointer it technically valid for userspace,
> it's
> > +		 * unlikely that any use case actually cares.
>=20
> This is fine for a changelog, but for a code comment, simply state that K=
VM's
> ABI
> is that NULL is disallowed.

Ack

>=20
> > +		 */
> > +		if (!args->len || !args->post_addr ||
> > +			args->post_addr !=3D untagged_addr(args->post_addr)
> ||
> > +			!access_ok((void __user *)(unsigned long)args-
> >post_addr, args->len)) {
>=20
> Align indentation.  And use u64_to_user_ptr().
>=20
> > +			ret =3D -EINVAL;
> > +			goto free_fail;
>=20
> This is rather silly.  Put the checks before allocating.  Then the post-a=
lloc
> code can simply be:
>=20
> 	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE)
> 		p->post_addr =3D args->post_addr;
>=20
> I.e. your burning more code to try and save code.  E.g.
>=20
> 	if ((args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE) &&
> 	    (!args->len || !args->post_addr ||
> 	     args->post_addr !=3D untagged_addr(args->post_addr) ||
> 	     !access_ok(u64_to_user_ptr(args->post_addr), args->len)))
> 		return -EINVAL;
>=20
> 	p =3D kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
> 	if (!p) {
> 		ret =3D -ENOMEM;
> 		goto fail;
> 	}
>=20
> 	INIT_LIST_HEAD(&p->list);
> 	p->addr    =3D args->addr;
> 	p->bus_idx =3D bus_idx;
> 	p->length  =3D args->len;
> 	p->eventfd =3D eventfd;
>=20
> 	/* The datamatch feature is optional, otherwise this is a wildcard */
> 	if (args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH)
> 		p->datamatch =3D args->datamatch;
> 	else
> 		p->wildcard =3D true;
>=20
> 	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE)
> 		p->post_addr =3D args->post_addr;

Ack

>=20
>=20
> > +		}
> > +		p->post_addr =3D args->post_addr;
> > +	} else if (!args->post_addr) {
>=20
> This isn't a valid check.  KVM didn't/doesn't require args->pad to be zer=
o, so
> it would be entirely legal for existing userspace to pass in a non-zero v=
alue and
> expect success.   If this added truly meaningful value, then maybe it wou=
ld be
> worth risking breakage, but in this case trying to help userspace is more=
 likely
> to do harm than good.

Ack

>=20
> > +		/*
> > +		 * Ensure that post_addr isn't set without POST_WRITE to
> avoid accidental
>=20
> Wrap at 80 since the comment carries over to a new line anyways.  But as
> above,
> it's moot.

