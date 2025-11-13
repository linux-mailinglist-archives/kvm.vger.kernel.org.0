Return-Path: <kvm+bounces-62957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BAAC54E64
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 01:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47AAA3B42DA
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 00:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CEF1419A9;
	Thu, 13 Nov 2025 00:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="shPrp9UV";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="v58xGNcK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED318B0A;
	Thu, 13 Nov 2025 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762993825; cv=fail; b=iW8bwzHA3oZJHKbcvxVdYmUOGOU7zt7atACpPRmQYIsKx/273cWm5oYYYw1VYw72R+Sfs3O4QngynUYgFMWP/IBpAocv4GU/lXpDGzWRvnUm50MFuOL6AQ5jGaVnySKJv84PtKCpcND8AkCsy7yXfgjccBTJWhzjsV4Cmibr80M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762993825; c=relaxed/simple;
	bh=KW2oZedn+fdJLQ7sXsepS7C9CUlNCiv/sjgzn6zA5XA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eJOPXevjtXVCqIZxMR+iFLoPHN0UiNlJhtx/gzdKTydQVe1taKyMwKQo6N8HsA74m7/wu1pRXb0fNSRLnA7gf2lQ1+UMQVvZz3HkWAmj6rCj7oul6YSJlI29AbPX4QkHIfcws0TwnLI8xCkAX/1TeVF5wj3RSjQbmCv/rP7HPas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=shPrp9UV; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=v58xGNcK; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ACGepBE575649;
	Wed, 12 Nov 2025 16:14:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=DaKhqGLe+dMmB
	Nzzpa98Y6AgKc229H3yg8VsnJBOuiE=; b=shPrp9UVtlqCpihH0VLgG1j1zqOJl
	U+itmBmx9PZJxJKEXt0rrm8O4e1L9DzpVfucgVUwMkZ6oFrfDO13vwSLFcOBjn/t
	vKIVTF9ejwqUyg2LodZYupzGUmxO7s+eYSXK4fAG0mOsvq+6qn5gnzmkyeEFlJac
	MRb5y+GFFrB47VNjepPi8mn9X7csKbuC4fd/uwsYXCMLel2qq/JuTHbLqTExdgOK
	Z6BeyEo9bPKuVOcKMkdYX4RfU/7qjB3QNEkc/DaZogfR6Uxg26UuOaW/UUwO7+XH
	W0DxsxMA3Y/1/BkjU9kxPgbwm6PsJwRdPTbAfr4iEsGtEmm5pRI6JVrYw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023141.outbound.protection.outlook.com [40.93.196.141])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4acwyhh2wj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 16:14:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+a4DG+vUAY/rT3hCG+zaVkA85qEXwkqrV/KHCVyQlCdN/L80avovCnkJDhDxKtQ7rXTkdiUZufW+JEA2Tvv4pbIgNres9lgpgjd9jK1QMzuP0C3rZezEna9USnMIyeIgfkORtACXQboXMBzvMFoi47lYJB/WB//q4R1UonLBGs7lqw/NGH643omfqUiUClMEy2V0gG5+TPdGv0QDBWldPmx0Wrty543LpgyEnWxsBlsSyAnoPa714E57IggA9qGc+lavH8MGYRpSflea7UXAR47sw+c+bp5tk6ruNvRMLLVu/ywpVYhMm5VIKGYSYQUhnvPxv28iMRx0Dkr40p0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaKhqGLe+dMmBNzzpa98Y6AgKc229H3yg8VsnJBOuiE=;
 b=JttynwPYT5p2m/XfgFxYR1ZnEl4SG6i3yLglHxS9BVOXeW2G6Bb9BeGhG0mABUM61UXvu6NW64SbBUtUHmBCSlcVXYLXhrW70EmdYk/JLSDCWoeLm+5GHS0aezXvfE2rrokjLWTRozGGzR8ZqJo8PTu/50JSqcjenuRgFSYpsr3Q+BHbFO8OkBBEqakEPn79M8TO2IfzS0GoKVrW+dw8lFtJJsjVWuP7fI1yjBNB9TdfqLqB+MILqWs5F3rHKE6uFLCaULxBnCaq2adIht6v1YImaNi46717qOBUNZ0c0z8q7ecnoagF77lCSLbhUm0RD9UHExoVw1UD32ecZD9Kxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaKhqGLe+dMmBNzzpa98Y6AgKc229H3yg8VsnJBOuiE=;
 b=v58xGNcKFEGtGkSDaWRjmWzx/a43IAkIVYr1KecLs9GpeYHiUIVLDEU+I8APmktpwthshv+44w/y3D4RMn0+u1fR8fb5olg0SUwIn5LoV0PLaZewLP/XUafvb/buij9niCYOq+GZ6WfOX1Ymwc85bhPB0J5rCSSBTIj/oceqNRvtch6l4x6SE7mL70mO8j1OkXH5s0YbSvQEAWDnnuodO0dmIGOQNAzGx5wWcDIRFHU+4JUz+eLAx9/2DyYYhX44RXTSov8uz91oJ+BXd+OxPVRJuqIOwYTi+aURpGnHCDOwvDZJGZEiT4DAOdPTublzKqC3EwdnhdChCiGW9ZyNUg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by IA0PR02MB9098.namprd02.prod.outlook.com
 (2603:10b6:208:441::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 00:14:04 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 00:14:03 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
Date: Wed, 12 Nov 2025 17:55:28 -0700
Message-ID: <20251113005529.2494066-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0113.namprd07.prod.outlook.com
 (2603:10b6:510:4::28) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|IA0PR02MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d2ec4a-b2d5-4497-98b0-08de22498d92
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fGvHvnE4N2biT1lmJLzFXrH2QfJeszwiXIp7X5R0F4eEwQMrud5Ge4M3+vqG?=
 =?us-ascii?Q?xbbyAlk87j8ZeJervhsb3drv4EA4vh+ro3tIDwFi4wHtw+1WAUpY3+XaCqlk?=
 =?us-ascii?Q?frBO6YhtOahiXMCJepCZw4F+iIxVdXEgSSoU2Jt5sYtt0DLwxw0X7vDQ/a1I?=
 =?us-ascii?Q?vi7AFXfpuACupLgAYD91R0TQv8L1pg6uab3WDDKc8Phb6CZT+QYnOmUj0b0q?=
 =?us-ascii?Q?9xAKmmE2YkEZd0AUnxsfaSU8Ix0LtPAvveO1XbmYIdFd8/y84A4hYlEE4h1D?=
 =?us-ascii?Q?bRC74z8ZPQTbstZCyCQyMwG15ppuzLjEt8cNaz35KykXbLWnmX26jJBdJfxm?=
 =?us-ascii?Q?Oowu5QiaUduyTewiz0q1si+elBU3a6QXyok745hAW7lh39aNqVVcmbS8OVki?=
 =?us-ascii?Q?iq1wFuXmpbs0Jti5TISt8FRlUT4YJXlWfR8gpeWpw0GLwJ03JXe7qxj5H57I?=
 =?us-ascii?Q?Hy6CUOdMRDZSVWLnx/uaNnoctz1vZtpjMUcuaur4Ud7+yYyPhYvcw5WRbZkW?=
 =?us-ascii?Q?V3DcB9cRN4lhB54wlHFEEa03QKe6K81R7ej95rwrzbbO88W0ZFYaW/7fvJ2C?=
 =?us-ascii?Q?KGvz7UeFqJs40iJbnsx+WQ7g+Bl78jQ5N/I3nhnTx8Wp4u9nSM9DBS87Uofa?=
 =?us-ascii?Q?8wVL30FQaLykyzmnT0YnqItlNgH/Ung3BsajzNcnZCIKbcMo4b7rv1YBTqLN?=
 =?us-ascii?Q?PHRpn8GDZN9vpzVE0M5Cc7vn1wnwNn9NqO8TfY/1vnQojzjkPOlR1Rk/SA5A?=
 =?us-ascii?Q?l+P+99RhJXlQ5G165x94n7AeYmDAPw7DFq7UlAt9nKPYDqDQR93u9kRwQoJD?=
 =?us-ascii?Q?eaDWdleFZy0CEiBiuffUF0i60izN/IoHoJUAtkMGmeN3HDHYcFIMloPF3K08?=
 =?us-ascii?Q?FGS3m8WSDsviARL/izupZlTk1smDtHO4wqpbuyqr5aFskoXmLX6uGiT4+0ia?=
 =?us-ascii?Q?PodQSAeE/suz3bHlTQpjdKWNZlDWqpF28P6DcwTPJmlBrTu1w+ksFOKDSMYa?=
 =?us-ascii?Q?TNMqqG4OhPxCLTTAU76k6fmZcaEkXKI2bl5OSOIo9WSj9MdQjc6zsQ7eM0Xw?=
 =?us-ascii?Q?zbKsKUVh7P/bGHX8tpnjfVs/tHl0oGiJdpMGBQCciv+1T3QG9vDwJlUd/smv?=
 =?us-ascii?Q?vVAeqnnWhge3VCn3Ml/3UzctLDPPiXX5phIJBtLzTRKJJjoGv07gxO8oS5jx?=
 =?us-ascii?Q?m+Xwl7r3mxP/p6VnaU4K/m7xOEV2N6QnGdJPxJA2kno++y63kk+7lc6QXl0N?=
 =?us-ascii?Q?KRdIKP/nJ9I17UNczsksYP8Fs2BqWQHqvJ5BCfx4Jy4Lt2ZO2Wni2ehttT8H?=
 =?us-ascii?Q?VF5RSVJ2KNDYune8afMzohawYpUfPRwP8Qrf2X7UwU8GWGs7/mHjC/IR5AEF?=
 =?us-ascii?Q?biylM0dP3qRpUMYcpeTF/i0lv+dJ+63CD+N+maOz9Yu31tmYPnBWCI8ovU31?=
 =?us-ascii?Q?clCZvDBhT03v+JLEMemburN8tbgpIahU28pkDuHTBcPhJRccf8o50aQ+mXAn?=
 =?us-ascii?Q?XDLQjf2d9/phQ++M6ZSfcSg5C5CeoY+6lMjZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wCmTPU1Jc4n0KCHuS2c2H+uNcgI/17S6NdamBV9AOdGE7YvjsR2Gwx6EIgmV?=
 =?us-ascii?Q?nJleKo1vb9WAJ4hm6z52SRsku8rZz7pwPI3eQUrQW0QXOaogM9r1OPAVFDOh?=
 =?us-ascii?Q?lqvngY4lkHz+pK+HQE54ouMiiEIWnzG+UmpXege9cXhZ6YzAFQuThXyQpb7T?=
 =?us-ascii?Q?6vRiRODMdIdaDLmZqxVKtfU6mmZ3/HUDqGiedNcqf0qbE2bW0z7UQvETomtw?=
 =?us-ascii?Q?b9TF1yErYav5wYJsyqww1MgPbnVIi/L8otLF0GMB5gARm7ruwV9y0zCI56of?=
 =?us-ascii?Q?fFjpSE4HMJeceeTk+Lo96E3TbtmEWNQJbpLe4imstup4GtDp+Ose5Ap7vOzR?=
 =?us-ascii?Q?I7cBe0ibfRZgmc0FDkgRXbQbrEbGPAlmwr33KeuTk5NSfFRoKKf2S0FFy3GP?=
 =?us-ascii?Q?zPstkF1bR7qeQXtnXMU/JBjqWFWT5uQDeYgLB6xrDbirfKH53HVVXITsKlGR?=
 =?us-ascii?Q?hlpSZj3oKHnNPfj7dsScFbAjLIRFCrL3BCXJWiEJCiCzncV3gO83oVoEy3rt?=
 =?us-ascii?Q?msMzKHZODJfIFEE5d3wBghqVzBQWbD2nFBqebgRxVKDDvZeczNr7Ml3N8cQi?=
 =?us-ascii?Q?GOGbHmAP4RdpYxJRVRyNImHTCSZK3Ov0XBQ0ROmQgo+L9CWvmyKsmqDv8zaG?=
 =?us-ascii?Q?Lw6vvj5wmktIon3ciHz2TFYxM4+7tzRLWTrL9eIS8MnYogc1ABATpaCAW/IL?=
 =?us-ascii?Q?Xadv8Z33CtHecdyBsP2l+9ACjeycnpmYUwEyBPEFq65aKSmombhdrX685vHP?=
 =?us-ascii?Q?34xAMQIP6vU3MNa9DsNtwiApPad6llIibXGDyH/O2fIL1c9rEr8HBTV6AXWW?=
 =?us-ascii?Q?S0S3Mz5Yrq9cNCF31J6Cnl98TFDZi9cGBnov/EcS//r1pmaxPsRPhdRbyMqy?=
 =?us-ascii?Q?Ny4AG/YxwAE2UgDeQQp03ugwIVjlaCWLdXNNG7rLnNpdIwCrmQ9/gxpTGNsF?=
 =?us-ascii?Q?C+Z9rkX6nUVM6PJGpyS6sDAKWmAnry4A52roaJQqGdLQCvA+gETmtjcLkxH+?=
 =?us-ascii?Q?K7pHyrX/ZpTL2B4vjB1LiWSew1N8aaC8LiJIrs8ybF1W/H1GYOHIPk3fgVry?=
 =?us-ascii?Q?OHZzRuYyXWqApmeyBY0v1fl6GbLUihl8Pg4mvCVMMgPg/yq/kcDbxaTa8KhF?=
 =?us-ascii?Q?dM2E9lCuQZe4BzdxBg4PXdhAx5HlTuOXQ8cI6Ep1FonguomOQc+g6o+kBV33?=
 =?us-ascii?Q?4XMcW64gTOkxuvHNwAOTEzsKrBT50yVkJmejSFqOz0NIIc3KsXeonLVX4Rm9?=
 =?us-ascii?Q?QgoY/AaWuD18k/yccMyvPf+dn7eVFVATYYylOvFcWfYGw+3XPgf9hdNBoige?=
 =?us-ascii?Q?N4MVzCRM9tPFwslhaeCAPeABLkZhlbqwKdG5vZ7qOZqZKAaJlMhdYZfeC3cR?=
 =?us-ascii?Q?fovIBVylPagaTVP6YNvFHBmXFm6C7YsRMd3hXg+/DM1IiqjwWuEcZqtFvnW5?=
 =?us-ascii?Q?kpqvSNceLMWlZWjcP8SQOmH1vF87+s0enFG737ODp1jires5Pc66LSWsbm5A?=
 =?us-ascii?Q?m3q5VwyNZbnltLDLqjG7uynq4nZtvUdY960jTpK7HY7Rp/Zr1f6PDnXYoh/9?=
 =?us-ascii?Q?hkgdLcVRA9V0GHbsXCyX8rk91jOPGsKhAd7/v9vgs1ZONc/7SVIKMblIEZBc?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d2ec4a-b2d5-4497-98b0-08de22498d92
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 00:14:03.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ap8ysaqa1w6WOgAvo9Nu8NPfj7Uf7Imrzq1sBAXtws1OmLmfXb4TIoIS7QsQgi4SWEAyZkvhgxUf9kMoBjCme/7CZ3/EWz2OgtSakuYEehQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9098
X-Proofpoint-GUID: d7fMJnEKKYRWgGSL_YnfovaibPeyUWDl
X-Authority-Analysis: v=2.4 cv=K4sv3iWI c=1 sm=1 tr=0 ts=691522cf cx=c_pps
 a=EFv6KP2OcB+WNypt7onMaw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8
 a=Z4Rwk6OoAAAA:8 a=64Cc0HZtAAAA:8 a=yMYK6okjFAkeqJQ4RMgA:9
 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: d7fMJnEKKYRWgGSL_YnfovaibPeyUWDl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDAwMCBTYWx0ZWRfX3GvsYJlC/eqP
 ANnQhzADZzswYU66S/5NUnS4ZpJ8p2euEbN2w8KyzcB/aOFbbqnPyPGtkS6wTXUv78Bg7etAY78
 1InIa6T8SRZrt3ald342/t+M536k4xLw0YBRrkQa1mcc7pxlDI1oTUCoegvswuO98cpuw0J86Qv
 ncWwGUc3DNrRISSEyf8XPPJGo27hskMF6eGvL3ij88/Ir+fEiGbgG95PUsMHVnpUZcSQjGsnrlw
 KtnX9C15BBHQtkT3WzU7Ymj0U3a9txCkpFUSNuwLkeV2uCvTnqwjb0k0UO15co7AMSBwhrQvxJg
 34UkK2aQR/tE8/rxfBxmkgjxhSisOCVu0Wk+2qjBFR0XHB4RHpCewepMrzels8WFwYdtq1GpJjo
 XFRwN8zAWpzxUR0DWE79Mi5mzuWxIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

vhost_get_user and vhost_put_user leverage __get_user and __put_user,
respectively, which were both added in 2016 by commit 6b1e6cc7855b
("vhost: new device IOTLB API"). In a heavy UDP transmit workload on a
vhost-net backed tap device, these functions showed up as ~11.6% of
samples in a flamegraph of the underlying vhost worker thread.

Quoting Linus from [1]:
    Anyway, every single __get_user() call I looked at looked like
    historical garbage. [...] End result: I get the feeling that we
    should just do a global search-and-replace of the __get_user/
    __put_user users, replace them with plain get_user/put_user instead,
    and then fix up any fallout (eg the coco code).

Switch to plain get_user/put_user in vhost, which results in a slight
throughput speedup. get_user now about ~8.4% of samples in flamegraph.

Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
RX: taskset -c 2 iperf3 -s -p 5200 -D
Before: 6.08 Gbits/sec
After:  6.32 Gbits/sec

As to what drives the speedup, Sean's patch [2] explains:
	Use the normal, checked versions for get_user() and put_user() instead of
	the double-underscore versions that omit range checks, as the checked
	versions are actually measurably faster on modern CPUs (12%+ on Intel,
	25%+ on AMD).

	The performance hit on the unchecked versions is almost entirely due to
	the added LFENCE on CPUs where LFENCE is serializing (which is effectively
	all modern CPUs), which was added by commit 304ec1b05031 ("x86/uaccess:
	Use __uaccess_begin_nospec() and uaccess_try_nospec").  The small
	optimizations done by commit b19b74bc99b1 ("x86/mm: Rework address range
	check in get_user() and put_user()") likely shave a few cycles off, but
	the bulk of the extra latency comes from the LFENCE.

[1] https://lore.kernel.org/all/CAHk-=wiJiDSPZJTV7z3Q-u4DfLgQTNWqUqqrwSBHp0+Dh016FA@mail.gmail.com/
[2] https://lore.kernel.org/all/20251106210206.221558-1-seanjc@google.com/

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/vhost.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..ffbd0a9a7a03 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1442,13 +1442,13 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 ({ \
 	int ret; \
 	if (!vq->iotlb) { \
-		ret = __put_user(x, ptr); \
+		ret = put_user(x, ptr); \
 	} else { \
 		__typeof__(ptr) to = \
 			(__typeof__(ptr)) __vhost_get_user(vq, ptr,	\
 					  sizeof(*ptr), VHOST_ADDR_USED); \
 		if (to != NULL) \
-			ret = __put_user(x, to); \
+			ret = put_user(x, to); \
 		else \
 			ret = -EFAULT;	\
 	} \
@@ -1487,14 +1487,14 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 ({ \
 	int ret; \
 	if (!vq->iotlb) { \
-		ret = __get_user(x, ptr); \
+		ret = get_user(x, ptr); \
 	} else { \
 		__typeof__(ptr) from = \
 			(__typeof__(ptr)) __vhost_get_user(vq, ptr, \
 							   sizeof(*ptr), \
 							   type); \
 		if (from != NULL) \
-			ret = __get_user(x, from); \
+			ret = get_user(x, from); \
 		else \
 			ret = -EFAULT; \
 	} \
-- 
2.43.0


