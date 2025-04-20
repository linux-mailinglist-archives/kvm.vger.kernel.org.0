Return-Path: <kvm+bounces-43694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E51A94619
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 02:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E174E18976D0
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 00:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298CCF9E8;
	Sun, 20 Apr 2025 00:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="E3+94SnH";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mI+pabRf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FAD63B9;
	Sun, 20 Apr 2025 00:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745109361; cv=fail; b=N6K1IsL5UVKnRzzIGwRZlToKVqM4bQE2UxM9ikO6JO8txyQwbPvJbz1tjHvm8Ii+svXJA2Osc9ByBsY/8UkEnXWd4NcaZ3ferxaA+I2o2Q26j8Ls0Dv9h6gtG81c5E48fxGyCpIrT62xjFu2AuH+0LLDvCg94K+NjnHmVXV6NoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745109361; c=relaxed/simple;
	bh=XbyOvmwIxEkFyFJ5iiYMJHluf6TrmZ591fAUtNMUKKs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=USAHElExrc3c6b/4g9XNhLwtw5FcW9IDsHjU4CWa67OiHWN/ccbn2R6GOVi7FEYcIcLtbVZj1Ny912KC8Qvf6Kk1MRjw1CfJgpWfDBtx5M+VlY7uaiCpOzTVtKZW2IMclyG2heSLm5X8NN0PP4MMUb2cOyLQYyzkk/zSaj81KjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=E3+94SnH; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mI+pabRf; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53K0GIM6015040;
	Sat, 19 Apr 2025 17:35:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=fSK49UBXD4FFH
	ZAUe5p/QD5p1+AyGHtBizisykvYwd4=; b=E3+94SnHsgU6TBbBFfX/4Mx5sxQID
	UUDlpj0TfWYsEJqKBO+e0OUKcBTKyFbWJNg/PWUeMZ8tg0JeisxZiAKTdVz63fIR
	BmB0fVgsBMkz1FsvlyjiA34la51gsh6U5rk2tA8rJENq/KEFA4PCjSUmoe8V38SN
	SKvJ8zBF+nv37TvdSmfQkQ6j+3G7Gg57Z8vbrjdv+kjv+ZNMRManM98Y69QJpuTX
	vfAfApKwGVrkRgC91aaiIDMHCIALjAFngTYnrwPBm/TsxOeVWSlQe9sv+WwCD2xY
	SuIvt3+gJH/dDwgkxbFmjT5Kewcbq2JugS8HiDRC22iUlA7RUfnDOvxqw==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 464bcyrm6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Apr 2025 17:35:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjBQtdur0MxqeerAXU1ivw4z9jcJ7vzFn4BectqKTEd7fuE8Ic3KSeo11wMyLpKyRd7Z4DRhMx/+SH89wxKY1A8BOaCXc4au0ogNauWUszVfC43xfREBbpw5D1AetHp7TDKG4PlVCzg52x9/7zKJmtHLDYSNn5jAIDablWvBKBNhZQ+ea8xoG1ExcKaEW5E0ogU+VNqVJcb4Fmi8HzV5Z25mhYjy30GDHeABliBdEr4xueX7fL7NoY61T81ojItRD34xXSzBAezBbaltK3DU47cbIETlmKAaECu+Tkhf+/fBhV+L2skdHLqURHoISIDYBDd28PdTA6sRnHSKUuS2xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSK49UBXD4FFHZAUe5p/QD5p1+AyGHtBizisykvYwd4=;
 b=FQewwisdjlqGgl7RUHL1Dk25vQdmf1PqSaSGa2CmSo9OxVYlKKmQHmPovHOxTvwZ2NitTp8TTLm9S1DCI72p4EhP/chn2S8hVQDXDkDiIrJOXHpz8lQJGr2dxL1uSb7lkcmMXVsJI6Y6mdWahwl995+k1N8zGmtV8SlFjB1jyACGECCcngsITkLDCxBPT+TQR5IZB8DxnRq94oNTzkcAJbN19ok3Oev2YO30yTmuxBL1EtrmPEio9FavinRMBgeIDgqEHgOw9J8sWKtL2nFxu7LxjFHdbAjDuTHSAfpdjs2pBC2tc02XUT/r+oo16QG3FGP4EBI3yMQUHCaJ0tbSlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSK49UBXD4FFHZAUe5p/QD5p1+AyGHtBizisykvYwd4=;
 b=mI+pabRfapnw+7KDIZ7/M2jywdOlqW1XzlCJEbC6BxqxsmPIN0TZoW/Th5J7yURU+hW2n4kg3QJhd/0TxkD5mfnzgu/vPXIXqntQcDY35eLxFgAERirnX2RhRSlRMqpk1wvzR1sB4P/MCk4+AKBh/sBtHzT84HlM+FsLacnpOpwjvh9E5KWOh3eoXlKK1+Ewa1XUb1FPLUuHFL2V5sFWG92RYEOfL76BXwxsS8kYp4GgOW48PZw3Du+MRW//xAEYP9sLcTVcyKxt7kCKarQkIgi8vNOGcMkMcBuP0pn85B7xPv1LXIsCv1xqv78R+jWUlSNGpvFHz6i+VVh7DUxAGQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BL3PR02MB7954.namprd02.prod.outlook.com
 (2603:10b6:208:355::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.14; Sun, 20 Apr
 2025 00:35:43 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8678.015; Sun, 20 Apr 2025
 00:35:43 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until after sendmsg
Date: Sat, 19 Apr 2025 18:05:18 -0700
Message-ID: <20250420010518.2842335-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|BL3PR02MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: c809fb8c-15a7-4862-f17b-08dd7fa348a7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+v94134SR5deqtshEY8HKVLsqc+DgEe7XzoF0fBqT2JIXXLGjMdGAH5NIGmK?=
 =?us-ascii?Q?XLku556E/uXy2PTaHejpGe6YJoEOs558v9SmMZ9yKZPlYmNw1sF2vzG4z6Ke?=
 =?us-ascii?Q?NfvAYPOzM5gx4HCJKQhOraCZFgaXH3pZw4zhJMR4pJ9eWl5a3m1R28Og/lSH?=
 =?us-ascii?Q?YR0fQVe14Q3nlRuBMad22UTca8KlcKk8gVUbTyxHY4K2BwdYpq+7DJPuvtxC?=
 =?us-ascii?Q?4k56j4Oa4Lq7SRG0NvrxyZaQJmoyk4D++/azJzRK3JVKbovcNvQrE3UCRpgl?=
 =?us-ascii?Q?BVAO0Uud4uGKF+Fjudu4DIRnJq4T3tjQgC6vg7QLhav4vOCdq1RdQubti7p/?=
 =?us-ascii?Q?Gmx6nzoWv4JQYOngN1OcxJoJD0g+3XmR8RpTXRx4j5eEE8lqRVVbvxgYf23w?=
 =?us-ascii?Q?q9GeDL7gPu21iwXlRPOFcoSewjBXcvKy2W3T4UcUYRlSzUUkEUDJfkwVTARO?=
 =?us-ascii?Q?s5n7WOgdO062UNCL0PruTdEa+0cAeNC2qI/mR453ah5k6AA3/Oz0qsf5Zqpm?=
 =?us-ascii?Q?GxyhtIF/ZxYdKNy1LbB0Jmvl1USBvCTqnkl8T7veafTuKREVBTD5JZ5+Z4x2?=
 =?us-ascii?Q?x6kljrKZVlb/gCYRzzoE416Aai3fB0tzlClJ2sBPFFh/FqASFjTLcrcffkG0?=
 =?us-ascii?Q?EmjWMg1W58HjiPPWr6gAaSlDktTQMeGIdsfoLVwV2I0hK0Xse+muGmCmEiMM?=
 =?us-ascii?Q?4p1lj4k7Y4AP+435G6MJ2XOaHSOZP7vvf+mCEMyG818XGqbGz/T37nJ4OcX0?=
 =?us-ascii?Q?iXfS27AnrlT5XbefVJttszVaJ7Q6imis0mKvequEQTfet08+PnRG1p+oQ3Ee?=
 =?us-ascii?Q?3UDwpqN4Ph3KruXrYnsIDakJGCOcQ+y01u/9+lwjsfJ04cEs6ku0weG1XQaI?=
 =?us-ascii?Q?Gb/cTh49clcGj9/Rltj5tsnpXXikOfOdVIoP+z86ibuXHu3q59+IpSLi6+cI?=
 =?us-ascii?Q?JnWBoxtUhJ08g/N7GgsE5IPOVpKgw9EVqngS235v3Gnr4I/Bwg+i8sPxWqip?=
 =?us-ascii?Q?BZMXKyILY9LqO3iF8zpEJBqm7xGwyCLpCKbJ3QncK9RJqSxZLx9ARz5zmVVb?=
 =?us-ascii?Q?lp7N4nBskUyJtGarCPh6TmS9i+MUQTu1KwOAoa/cnssd2bTLr+Sz/nsS5iR8?=
 =?us-ascii?Q?VemHB3ZN5sRR9J/Si1JHK9Mtl32KUFh6bsXMCkS/bPuOjL3VW2auUtz4Ch8r?=
 =?us-ascii?Q?Osc2B7z1nbiYEm6kqevC+HfqbnqbE7t1M79stGXChkueXRgWNIlsaOrYAl0U?=
 =?us-ascii?Q?znf3LSXmVxOm4SAA58fHDyRizs8tY+jCv+S9zpAaONL9x+NwkTE8SQngUsO5?=
 =?us-ascii?Q?yk52WtX/soqR3kHlq6cxiUPm+3mNjv1rRvM8nstKhZe/v1UozEIWjm80N3jo?=
 =?us-ascii?Q?k1JdJ6y4ATn226xBHumnPymqA8bhgoMKYZVWLShllsHz/mIWWeAP60x20o5l?=
 =?us-ascii?Q?Q3SR/bhvqyj2JhG+jBwifNGpdi9jT4bfCrIp9rUIAR+R5xbFJ7Og7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B3WqycAo6YN1kH31g90sqU/3MPgHqdqskaM0yWb0G8aPtgO0Hll3IBM6/K3F?=
 =?us-ascii?Q?TKUiATo4ZGCSy7gfvdJyuyep9R6bWKa941JDqM0NEFc123L2XH3d2nkjZs5K?=
 =?us-ascii?Q?n7G+YDjXYvwcxOxRbStSajH6PrUQPMz8y2XqJK24ue9GmXHkNQ9s1i9zmAzO?=
 =?us-ascii?Q?sDlVYWVTKNaZbgOB0tID/lhqAk6qtxbXB2FeG7yjCOpjVWmH5UPGgJdvZG/7?=
 =?us-ascii?Q?Y5mk6rt04LcZPqhd2G+S0/fQK97UBWElVuzbkZnM3SV53SZ4q9tPgbI83Ifh?=
 =?us-ascii?Q?O3DWEUve5m/rE1picsknBxeET6aLbSvGPG71iMyTbf9Rn/GpRS8mMz35lMfX?=
 =?us-ascii?Q?YXBXO29aSrP1ecz+LNUft9yRgjKPvns1HJ3bfd8X4Smk/5zxwRV6N6qSwJke?=
 =?us-ascii?Q?8fad3zHSqcusk+XrzOnlSkd3drBES4wN7LC8hP8b7HPU/ImOQaghzClwtBpj?=
 =?us-ascii?Q?pWvsU5qcLKJRX8HiXns8LNiRMJSlUYJRtRpO6f8/0GE0g+9ZEUxxNKIBtiD6?=
 =?us-ascii?Q?AZk1MWuLty/Ljf24f7eYDMV4v0Q7y04H5CRszFtaGWkYUOiMzLptitsxRpaz?=
 =?us-ascii?Q?6UkdL1gtZOtt8+XJy10BggIMM2IkifDbwIpm4ZW1HoXCuShZwjKdLHw4yZy0?=
 =?us-ascii?Q?OWgpnxTnDSwDLxdvTgUsXzFkLB7fQdPM7gTHhnCKwgLnA2uH8Rbka8xyqF4v?=
 =?us-ascii?Q?wO+C078TpA+wAYgkYu/znKKjJxFNoWA7HOrlo7dSeaX89sDB7Vo4GSHPepq7?=
 =?us-ascii?Q?79lHBSbNACxsTXe38sDgSomF8oD/2UwWds+RgeB6KI2++Jz2D+TwYh95cfpF?=
 =?us-ascii?Q?Fxsd+2Qmi6d7PmgYyaHyilUpoMj+9cm0rQa2cgEQIvW6cqAWm2iXfX3DbeLI?=
 =?us-ascii?Q?i5fHtddBOoAceHtnb/kL2PNoqaeOlI1+hmSEGFHuiQXgmIVLZx7hyYATuhQk?=
 =?us-ascii?Q?RfF6gpcYLYR8jG5C22zGTW5Cx/ZvLZOP5mqEgG0PnQCuBI0aIZdrfnB6i/hS?=
 =?us-ascii?Q?L08JynWI5uUBnCvfnYEW2UueCTxD/VbFlu7VY2Io+1PHa+zpKkrby9kSVKBj?=
 =?us-ascii?Q?MtLwp13UejpefRcXx2ZrYYvJO1+07st8C8p4ePfMurdV4HtiLFArZXe/p7Gh?=
 =?us-ascii?Q?RAlyXouEXtb70xWaxPGfk/JcJF5ps/E/NxaJAZJcaKim9bg/SbijK7JFmE02?=
 =?us-ascii?Q?yJrdDhC2bqtAnQDnXEt3/NVv3+ha4wBk2lUb4FbX6u+706AjeasOVViHHXpX?=
 =?us-ascii?Q?DLVRKOpmNT3jb+uI2ezc9YAAfonykI0dl6qfoMmCS5i9p4wQK+SXo/IS3qjL?=
 =?us-ascii?Q?hNbROLbyKzEsvLYYBrpfQf5p3tu2qcYwQ7m1OHcneo6FVSo5cyJPGbGJk57n?=
 =?us-ascii?Q?8m4x0KODI+dhULggxGPF+gDwlUtrRBsvn5v0XU94J+uaPxpjdZ2pl1JMCeBr?=
 =?us-ascii?Q?/x8Xwrns/WGiF3p//exJt21pVChofKFW2OjvlKPRGHENzAX+pBVtofIhai75?=
 =?us-ascii?Q?AltjhILa7RmhyTu78zxxck0rHfBe68FUaU79S2H31HOb5sLDYOJzR4j+NWPF?=
 =?us-ascii?Q?+mXof/Mx9g8rsnWP6Hw6zG3Lwhl83MWKhD3ilU338OAIfWCRxL4icA6jQRZd?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c809fb8c-15a7-4862-f17b-08dd7fa348a7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2025 00:35:43.3546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWqEm17W197em8sFcTFo3MiK6+0HtCH/TSFZ9HAThUE7ahu6mKNRORdQdCO37iTwrVneBSlra1eWnP81uSUWAeZHwju0Gmkd9Wl2KFbIs3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7954
X-Proofpoint-GUID: SfVx4MqAGz6ra57sfa-e05rvto7Cwvu9
X-Proofpoint-ORIG-GUID: SfVx4MqAGz6ra57sfa-e05rvto7Cwvu9
X-Authority-Analysis: v=2.4 cv=PvSTbxM3 c=1 sm=1 tr=0 ts=68044162 cx=c_pps a=F7QtyTBSWJEVkVFduP+sHw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=Ngy3d7EZHYTq51gLL0IA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-19_10,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE and
batches up to 64 messages before calling sock->sendmsg.

Currently, when there are no more messages on the ring to dequeue,
handle_tx_copy re-enables kicks on the ring *before* firing off the
batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
especially if it needs to wake up a thread (e.g., another vhost worker).

If the guest submits additional messages immediately after the last ring
check and disablement, it triggers an EPT_MISCONFIG vmexit to attempt to
kick the vhost worker. This may happen while the worker is still
processing the sendmsg, leading to wasteful exit(s).

This is particularly problematic for single-threaded guest submission
threads, as they must exit, wait for the exit to be processed
(potentially involving a TTWU), and then resume.

In scenarios like a constant stream of UDP messages, this results in a
sawtooth pattern where the submitter frequently vmexits, and the
vhost-net worker alternates between sleeping and waking.

A common solution is to configure vhost-net busy polling via userspace
(e.g., qemu poll-us). However, treating the sendmsg as the "busy"
period by keeping kicks disabled during the final sendmsg and
performing one additional ring check afterward provides a significant
performance improvement without any excess busy poll cycles.

If messages are found in the ring after the final sendmsg, requeue the
TX handler. This ensures fairness for the RX handler and allows
vhost_run_work_list to cond_resched() as needed.

Test Case
    TX VM: taskset -c 2 iperf3  -c rx-ip-here -t 60 -p 5200 -b 0 -u -i 5
    RX VM: taskset -c 2 iperf3 -s -p 5200 -D
    6.12.0, each worker backed by tun interface with IFF_NAPI setup.
    Note: TCP side is largely unchanged as that was copy bound

6.12.0 unpatched
    EPT_MISCONFIG/second: 5411
    Datagrams/second: ~382k
    Interval         Transfer     Bitrate         Lost/Total Datagrams
    0.00-30.00  sec  15.5 GBytes  4.43 Gbits/sec  0/11481630 (0%)  sender

6.12.0 patched
    EPT_MISCONFIG/second: 58 (~93x reduction)
    Datagrams/second: ~650k  (~1.7x increase)
    Interval         Transfer     Bitrate         Lost/Total Datagrams
    0.00-30.00  sec  26.4 GBytes  7.55 Gbits/sec  0/19554720 (0%)  sender

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..9b04025eea66 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -769,13 +769,17 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
+			/* If interrupted while doing busy polling, requeue
+			 * the handler to be fair handle_rx as well as other
+			 * tasks waiting on cpu
+			 */
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev,
-								vq))) {
-				vhost_disable_notify(&net->dev, vq);
-				continue;
 			}
+			/* Kicks are disabled at this point, break loop and
+			 * process any remaining batched packets. Queue will
+			 * be re-enabled afterwards.
+			 */
 			break;
 		}
 
@@ -825,7 +829,14 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
+	/* Kicks are still disabled, dispatch any remaining batched msgs. */
 	vhost_tx_batch(net, nvq, sock, &msg);
+
+	/* All of our work has been completed; however, before leaving the
+	 * TX handler, do one last check for work, and requeue handler if
+	 * necessary. If there is no work, queue will be reenabled.
+	 */
+	vhost_net_busy_poll_try_queue(net, vq);
 }
 
 static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
-- 
2.43.0


