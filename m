Return-Path: <kvm+bounces-65213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C083AC9F486
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731183A6402
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362EC2FB990;
	Wed,  3 Dec 2025 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Q7FDFab7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="az++VPcY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92EC2F3C35
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764771962; cv=fail; b=mfgCn3YzFWos2JysBlcAIURvUeuEF9TqTZwPdXMvGYXUEuJ6eT04ECfvazDvjdUxvjmwTVgvvwI2BskEpwQdrg1m9U5mKyFLqrcsd1oH/u1H4JcrnJG6lesoQwFx0yvoFL27a0Xv3fKrPr3QPSaxVjfd9pq0TfHV7RKE7LodYRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764771962; c=relaxed/simple;
	bh=5ch4BJQCnPFIVEys4Kl+MqCi3RP6YzmcNxMKmjpH+Ms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ToFVkTDPbVWJhJ4149Tw1hRGulG5XLpST1XPrHEEK8aJ7FbID+Cv7Fneu4UN1vSd1errVunlAvBPCnjE9wHOlhkQt/ENEoQnXFqkKRgdp5ulypY+nRn7BskGRK14+EgrZ3xshAeFEBQEntfWrpPp05aWFG6Rj1WQe5YuDlFG/QM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Q7FDFab7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=az++VPcY; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3AmdGF2332658;
	Wed, 3 Dec 2025 06:25:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=csxY+wOwO3tDQRpXlF1rYT4Xhtwvy+zojD/T9v8HY
	jE=; b=Q7FDFab7tm65AzpujoxEoaag/mlUkLi5fMHTg4clsq2bZ90HfiGYPZnWs
	C581DBZpZmG70IAA/FLJs+Ra7j1W9ZQtTva3c2DSojEKA6JpDri4f/nSnr5JVviU
	otr3QzOqKloRCLSMcOe/wfZyNmIVbb0goCF+e1yVjC8bHhbQbXj1oBYvM8xS9LhB
	Hds1AgFis7EkEfI82/akkjpRDWt48Buzxc79oLvGW1K/JyfyPK/8ryDUmWa4P+2U
	zH7ZMWvFXHiKgv5VufiH9HIj+iLf7Hx/jsArddB2beSUU/bFwYCeMWoyLZ6ivWtc
	h/VAx6N5ijefZX6On+EqPX9SMie5w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021085.outbound.protection.outlook.com [52.101.62.85])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4atksb8dg3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 03 Dec 2025 06:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqdSp5iQ64DmDb6rphgN8otBbt3XJGsVcPWPf0PGP8gVl429X5Luy2I0f5Y02jZu8MFikf6EBKHzMc+xrUlrrvCKYLhfAa8J8ewo+A5Uc48+8w+kl7xU2COM8jTMzGkPbWXpBrmHOAixS02iBanS9FMHdwzk0MSVsTUAFeX8ySZXQz0NmmZqKiYhk/dqQEAACvelS08c/uKxJPqDX0p1D8bob5fS30Y4xXHo1J8G8PFG2wKoG1hny0nZJiq/Aly3tt22KY9Y8sHPgT7wbssWZA25GXBTsc8aIX/Z0STwFsBoKeWxVfL/q7zXPiGSn/L/9x1yUoL4Rw1BEcHGdroA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csxY+wOwO3tDQRpXlF1rYT4Xhtwvy+zojD/T9v8HYjE=;
 b=SsNsvcIvewODD7tsl9ns2nShZpY7HMJLz9UnUryPi/wLS/Bg83nAcPpYgd+HPbuNizqBJla9dO2AoB21+e0pe8tFHLg1T/2POn/CGRhmAPT0oI+bcsY9eWvUZYbOPWKni+n6/hbY55n2Ebc1ua+q3AQ6hQl87S41ikjCMMucdKQjckm2/yZQsXWifDbTP5wfwndI9cBlg4UYbrJEpVByx7PwkphN//xkku9X4miRkay2bRDADb67tN5P03hnOCGrHhI0/cA1qItfsuLum3lVKYLDXb8GwnFhlJmuHvTIlOFlv6y1FmW11xG2hJ8uQGr67SQuMSQkvDLtU/XnXsrauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csxY+wOwO3tDQRpXlF1rYT4Xhtwvy+zojD/T9v8HYjE=;
 b=az++VPcYp2s7GhT4IQRo8RjCAFB9jeSf5P4OOu+7MGlN9MUOU+v4UVIxZm+yGawq10tWOSrjqGk5a1LnkyPSuhPGlaN9Wy28XEF0XZ6vETlrizO6TXL6YbcjNzEKCXr5aQz+8oXU/La8d7EMp8xZe4R8rzhI+Odw/yim8IDzamx5G/5AOj6YzvTpS2L3X/oc+Yl3WepR4pxC2HrLm3Q6g4wERkdqYPbBPYmYpzHAHcxNmCpJ2naJuk6px5AMWVNTuH9c8He2dQZ1pA+ZN4/vTXEEUqxxfjBnfjPjRqj0ltx2Kx66tpLeJ23Nqny5y+7bgFK8+kEW0DLGEOq1YuyTOw==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by DM4PR02MB9144.namprd02.prod.outlook.com (2603:10b6:8:10c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 14:25:46 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%3]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 14:25:46 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        John Levon
	<john.levon@nutanix.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jag.raman@oracle.com"
	<jag.raman@oracle.com>,
        "eafanasova@gmail.com" <eafanasova@gmail.com>,
        "elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>
Subject: RE: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Topic: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Index: AQHcHm7Hwacz3qdkkEq6uKZSQzLqQrT47UsggBaS7oCAAOx5cA==
Date: Wed, 3 Dec 2025 14:25:46 +0000
Message-ID:
 <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com>
 <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com>
In-Reply-To: <aS9uBw_w7NM_Vnw1@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|DM4PR02MB9144:EE_
x-ms-office365-filtering-correlation-id: 8bd994cb-3813-43d7-2cce-08de3277d979
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?V1DfJQQbCpjEHltJg4iypXChQQvlcKrilTi5GmQbd1aO9ISbkmQQNZU47Q+X?=
 =?us-ascii?Q?wFElPqGoppue10/w0zhqoxbL81Kbaq8KOxb6lqiP/bv6EsFyZFkDqk4ccx+U?=
 =?us-ascii?Q?lZoqd6Q7Oj3OlbEGzIlGDmU2tFLuhVbKoGgAx830HX0ttW+BmcNhB5VUP+sb?=
 =?us-ascii?Q?8Q/zzN+dWefX2fVsx8B0WbR6hHxNiN5vW9lPZRsm74w9ZFwz9ZC+bHdSfVKC?=
 =?us-ascii?Q?Sri3q9hYEHh2SH0FTo1P8Xa3idAB7LxDTrO6QotGEO7URkwFqZkYQjFdtkW7?=
 =?us-ascii?Q?4hGrnq6OPMuHIFZ8lNwX9ewQm9b2ACE4gLvKqZYl611Q+ET2MtZY+8IGIDv6?=
 =?us-ascii?Q?zYY9+yNfstKNIO5pD/16a88h2VzPzDY8ZRnj32c8U2zoyLClf2uHons/r0US?=
 =?us-ascii?Q?Y1WeJHXzLExN9VADrQU7mnvk+JYwMWVVtJOnyYW58aFAdRFK9PEputbYaHcs?=
 =?us-ascii?Q?ZwnwrvKFeydDYwsACD8lkULMtzSYu+fT6GC9Gj3tx2WJQ4HXJZHTTFEJkaLN?=
 =?us-ascii?Q?NTIo5ObM9wyxvDjExPptbWL7Yu3/9fxM4XGB/OLUW7tEaB4kQhuAqubnw3Vm?=
 =?us-ascii?Q?VYB3i5fU1BjlxcZWeB70zhnB1aPLzLWBL8hLAuuKtnUngqfrlIkXu2/s3fhB?=
 =?us-ascii?Q?rYd7Domapcacp2zc6wZ1JSdmAuOiKbkxc1Rw6LWDUt5tlHAZs6UdY4CjnHLo?=
 =?us-ascii?Q?+g5zBKQM46thUb0DgyKtme2egjID2stT6IqX3Qb7Hfgc//CYexo/Cu4A6MxC?=
 =?us-ascii?Q?H0DPu7ckwOqK6HlVcDABWT58SbQ0qe/TKQkGNjhDYQYUFOnzJsEA9qru6gmz?=
 =?us-ascii?Q?hBjR5L8yOmmYloviVb+1T4hxCptgGsOkfs81q0ni6ZhBluFNacK5NDSUO8RJ?=
 =?us-ascii?Q?4K1FPmUeNiCbwMf3dZqucxLMNl9uaWE6oEPBTtUDtOzrMSwjAv8WcAvu08A5?=
 =?us-ascii?Q?HtEgMdDpQSvP4Ib781vNB+/1GhsnenXhnY54tvTHceVBgRMqDaV9Kp92ij2c?=
 =?us-ascii?Q?+MIYO/vNb+PLCK5nQ/ma2gqqqy8aYqG+YbaGBmd7AeksECumBff3rwOckx6I?=
 =?us-ascii?Q?bejtIsAgjiLhL5T9ohOwugUNW6eyyfMaJku831yOCya4f7x1uGFVMKHBhLNz?=
 =?us-ascii?Q?AFkaGS1gzPUWqkWwJbPWw6oox7W76oass6/j9puvmZ8VQD8n94vk8aczYLnE?=
 =?us-ascii?Q?lGZa+7QURbuFJLMp5sFHB5oml23UIjea2nehjSfHFlsd2774k8iEcz5IKxU8?=
 =?us-ascii?Q?C+MFVrLfFZO9dzOiNkzRwRo14SBP1eoU+qA3umdGyTu/fDIIltJm0v2pHDie?=
 =?us-ascii?Q?z77uhfdS3BW0T+s3k3e4PY7TYsdZpii06arZtdCGzOAJPo+V5G+j9tugGtfE?=
 =?us-ascii?Q?fXEvnseKOg2Vnq4y8F5WkNjm9qfRVi8kZA4M56vTMTFa9k80jC53PWdjMXrB?=
 =?us-ascii?Q?6leuV80QMa3YBUuBSoBmN7eZc2FnMgouoa9YC9cyfxXcdQBob9uiOEcsvT4I?=
 =?us-ascii?Q?0/V9v4qLOH5KZdQWp2QW2ukKKyxfltheZ2kw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qZN3LdG3WhNpLGaZTYXiFj3sBJUX2tTKGy7BPwe40DI6C6scV6ZZ/1DvH300?=
 =?us-ascii?Q?DFrKeIsv3tIY0VvVb7LLDQpUOBwS80W8kr7lPDi9Gk1FoVA8021GduSnSujI?=
 =?us-ascii?Q?SBpx7dvJ4/d69Rf2m3OiP1fpVz149u6FYIaKalrjMmwbuamErsEiR/VEFPxB?=
 =?us-ascii?Q?jSOH1suN421I68EFvmGwrOP7cHfZAl7gBG1DrUg/Gus2zRt5nnStfhNwuQ8z?=
 =?us-ascii?Q?OAreMV8LLvgxvIE0iByzNDAN4j9hwowECwKtysS70Vb+w+7kl2ipmeUFlcGv?=
 =?us-ascii?Q?QT+AQax5iQTUOchTvqUXUMqRy4JNs7bqlPdV3N1UXkyLb/ZJ5iHsRc509lIt?=
 =?us-ascii?Q?FMsU6OrbyflIBG4pFcbcXm200qMYeaJ9BXXycw3D7JapAlJ1CLUb3OQPqRcb?=
 =?us-ascii?Q?p20IlEb+i7Vt7g5Py2WR2R3x4CtLP6IlTBs4srOIRWBOhR9g7uJyuqEq+Z9k?=
 =?us-ascii?Q?/QPW4rKzyzYoAdkE9OaQDQIg1+LrZa/rWIqGHSpSrLMbEpnXSodVwGpMxUiT?=
 =?us-ascii?Q?rYLdJx3lNGdMy8vtvYKIGwn0H5we9Fy+BuCu7oZD276phxM3UZ5VrAaiuwtE?=
 =?us-ascii?Q?PCBomk0m5Rbgym0hjGvO1FTkNVGbv+lNBn5A+HBTsrAOOqGZ1j32/yDIefhY?=
 =?us-ascii?Q?IP1BypPJqjYPSP5TMDaDT/5ktLAHKlTSESV3cWj5klhwe2ebJuwjkViUyfVi?=
 =?us-ascii?Q?a7LQoa7S9UTVZ2DPP+dZqR5nABO7WP4cEVtnlpINEntbpvwvZL256gbQ2XfW?=
 =?us-ascii?Q?szc81nmrm7He6QbzLyOuRwM0bJlP04WwdR9L9LvZolJ5ZKsIZKzudvKiUSk5?=
 =?us-ascii?Q?sA5u9KDs1YGzAHUElneMSxYYpnZ3073LGfeu/lGmxyhR4PPYPzNPbNxtHBxl?=
 =?us-ascii?Q?bFs7Dp9Nl/e+W2aHFgMiPjKlfHpqcuQ6b3bp869coFF02/K5tC5AzAJtwpEX?=
 =?us-ascii?Q?isYp72BFJVKe3zt6RqnLui0H3+JOc+wRlm26E1G8uad/A1aiHQEmMzWLBnTh?=
 =?us-ascii?Q?+JBw5Ax8lbLbcpZ0okef2zoCdehFMUBZlwzvPvV+myUMKOmlGwpHvuIYTeAM?=
 =?us-ascii?Q?AC5M1ZzKbuEzBx6tH3CcTkw/vFQrcPwg8qCtrhmx4MLAJo1uKVm3kvYcjidU?=
 =?us-ascii?Q?+5P+MHrhua9C6dQZ+4vSlw+nDVEWWHMdeBXCAyf2dHQ7rVBUIy4lTcJ5zi39?=
 =?us-ascii?Q?jJUMQLaGp24BrpZMvlNNDmDZ8FykeC0A4azJdUudYBBjDPsd5eEdZen9GiW9?=
 =?us-ascii?Q?m/Vu3hPvctQuyUiLucN9VnJAA+2x37K+NlybMVuYLqV0yw+ZtjdwT35jc0OV?=
 =?us-ascii?Q?xhsV35Me9P4O8rQMV6tEkyigOLgNHJWWT/RT6jGp445aV73XSEGDLeOzwY6O?=
 =?us-ascii?Q?p/Dx2hOUdtdkVSTG6SW54UjC9EeVL3Ef409ww5mRxT79oThbvbhc88ka6pc1?=
 =?us-ascii?Q?aUJ8sbXDZwcp+9SxrRH0J9KKgzn1GmJLUWjmvmAYfiY2FgZQlodJheiOFzmc?=
 =?us-ascii?Q?F3s6Incvyz8qDY/IW01s3ev9skGjT9D6eLJb/8IU8mx4BsrkI3dJRlpMuQI0?=
 =?us-ascii?Q?gQmNKglE5pp52RkCSvD+gcROMiK0wCfbF/EgbfqK?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd994cb-3813-43d7-2cce-08de3277d979
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 14:25:46.3832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SOhwgPzDuqNJzsNmyA27rIDHv97QhBemUQ9MrDEIIOtM73iYZH/lcR20Bv+xTS5EGPx6TuMp5oTLvw3bWDD+AZh+tzv8cfZ9U1WvYuRBhII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR02MB9144
X-Authority-Analysis: v=2.4 cv=XIQ9iAhE c=1 sm=1 tr=0 ts=6930486d cx=c_pps
 a=1gZ91TOCrEl79GUrRCoc9w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=0JSxTUwMTiyOaRHtL_oA:9
 a=CjuIK1q_8ugA:10 a=jySUje4VR5YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDExNSBTYWx0ZWRfXyUZeH+v95rll
 tm7x+WFpkvsaJdyeXHSvNasylqcet6hkorrraVdeVbWHDUGfXzliovLXHfbTzWIU8Ba3H/OKWqP
 LldqdMHmtYDcVzJw9g4ddikBMPEI+aJYZcG8prYXh9Z2T4MJ5c04OeJ8Z0LkxHemSTzEJTr5Efi
 GBaT2LdYHLx6mS2MjBKfmN4eWENhaSZc7+Up1WRvrNGAX7IT+rTead5qX1Ux2hwuO/eUpMHhsMy
 18eYda75Pa6mhFayGkcBeeOD9JiCkTU2CW8EZuP26dFP5YpRiLTan7uOapCN/D9trKMBl9fW2yj
 vrjWKzChpmF/22VIouev+zOWJ5Y3GRDhKF5ozzthGFK84L4jb6ZaqItQlLVMz1EZpMDYfkW3PQ8
 R6qyPYdx87te6Co9wsYZyrS/8Mu4cA==
X-Proofpoint-ORIG-GUID: KZgtT8eFD7ybZuXDklzlP5riDqYIgjMZ
X-Proofpoint-GUID: KZgtT8eFD7ybZuXDklzlP5riDqYIgjMZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-03_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 02 December 2025 22:54
> To: Thanos Makatos <thanos.makatos@nutanix.com>
> Cc: kvm@vger.kernel.org; John Levon <john.levon@nutanix.com>;
> mst@redhat.com; john.g.johnson@oracle.com; dinechin@redhat.com;
> cohuck@redhat.com; jasowang@redhat.com; stefanha@redhat.com;
> jag.raman@oracle.com; eafanasova@gmail.com;
> elena.ufimtseva@oracle.com; changpeng.liu@intel.com;
> james.r.harris@intel.com; benjamin.walker@intel.com
> Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
>=20
> !-------------------------------------------------------------------|
>   CAUTION: External Email
>=20
> |-------------------------------------------------------------------!
>=20
> On Tue, Dec 02, 2025, Thanos Makatos wrote:
> > > -----Original Message-----
> > > I think it's also worth hoisting the validity
> > > checks into kvm_assign_ioeventfd_idx() so that this can use the sligh=
tly
> more
> > > optimal __copy_to_user().
> > >
> > > E.g.
> > >
> > > 	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
> > > 		if (!args->len || !args->post_addr ||
> > > 		    !=3D untagged_addr(args->post_addr) ||
> > > 		    !access_ok((void __user *)(unsigned long)args->post_addr,
> args->len)) {
> > > 			ret =3D -EINVAL;
> > > 			goto fail;
> > > 		}
> > >
> > > 		p->post_addr =3D (void __user *)(unsigned long)args-
> > > >post_addr;
> > > 	}
> > >
> > > And then the usage here can be
> > >
> > > 	if (p->post_addr && __copy_to_user(p->post_addr, val, len))
> > > 		return -EFAULT;
> > >
> >
> > Did you mean to write __copy_to_user(p->redirect, val, len) here?
>=20
> I don't think so?  Ah, it's KVM_IOEVENTFD_FLAG_REDIRECT that's stale.  Th=
at
> should have been something like KVM_IOEVENTFD_FLAG_POST_WRITES.

My quoting somehow removed a line, here's what you wrote initially:

	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
		if (!args->len || !args->post_addr ||
		    args->redirect !=3D untagged_addr(args->post_addr) ||
		    !access_ok((void __user *)(unsigned long)args->post_addr, args->len))=
 {
			ret =3D -EINVAL;
			goto fail;
		}

		p->post_addr =3D (void __user *)(unsigned long)args->post_addr;
	}

It's the "args->redirect !=3D untagged_addr(args->post_addr)" part that's c=
onfused me,
should this be the address we copy the value to?

>=20
> > > I assume the spinlock in eventfd_signal() provides ordering even on
> weakly
> > > ordered architectures, but we should double check that, i.e. that we =
don't
> > > need an explicitly barrier of some kind.
> >
> > Are you talking about the possibility of whoever polls the eventfd not
> > observing the value being written?
>=20
> Ya, KVM needs to ensure the write is visible before the wakeup occurs.

According to https://docs.kernel.org/dev-tools/lkmm/docs/locking.html the s=
pinlock is enough:
"Locking is well-known and the common use cases are straightforward: Any
CPU holding a given lock sees any changes previously seen or made by any
CPU before it previously released that same lock."

>=20
> Side topic, Paolo had an off-the-cuff idea of adding uAPI to support
> notifications
> on memslot ranges, as opposed to posting writes via ioeventfd.  E.g. add =
a
> memslot
> flag, or maybe a memory attribute, that causes KVM to write-protect a reg=
ion,
> emulate in response to writes, and then notify an eventfd after emulating=
 the
> write.  It'd be a lot like KVM_MEM_READONLY, except that KVM would commit
> the
> write to memory and notify, as opposed to exiting to userspace.

Are you thinking for reusing/adapting the mechanism in this patch for that?

