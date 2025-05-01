Return-Path: <kvm+bounces-45010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63736AA596A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8ECA1B65CF8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 01:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B045B1F12F4;
	Thu,  1 May 2025 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dahn0+c+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tFkKJIbz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D6E158A09;
	Thu,  1 May 2025 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746063297; cv=fail; b=B297TL5lmS2g7fb516/X8rMTUFFqTsEK7BgunrqhE/zdUuvpRyGm3G5O3rP3kq8obaU/ggE2bUGQ5qYxxf0s3zPmWP+iVgz6JvNgXsIlrI8MoWuvte2Wk/jJeohmKkxvAQQf6rKft+r7KOV1ed8aU0qwvBomq0N3EVwPrvo1z9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746063297; c=relaxed/simple;
	bh=UGCRPEAT7BENgTGLULR0YmT6qhIfmzSA1CjU3rvj6Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ToFoXvqi3JdPBsJ+phqfS0aub8Z10Zu7Os6n94PNF9Zs/dsvCYNfHHuK6DZl71/Wstn7sr2O5Ho7vE/0e59/WBq1G7fMCrQrZtgDZbGnpJXxdPh6ZXgzsOspmFPECuhaXNJ6LbIwxqB0g+eZBcK6JH7vng0rcCs1/WwNP0LJXN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dahn0+c+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tFkKJIbz; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5411CKg1002229;
	Wed, 30 Apr 2025 18:34:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=t6lAQghpkT9Vf
	c23SNqRafw+J+SrG87Kqs566IT2MOQ=; b=dahn0+c+oQMP7vjqa0s4waBt98yOg
	90z54SlclS4pwxfPbjQh3DnYPJCyNIHM7F64V52POKXkBOFjRAjVYzc1uB8n5jzQ
	f6lvv0IRJeAcNbZag8JrZXZSv+nFnsmGtKKwEZqtyLnGPq3CW/GTOAnqr0NYPF0q
	vYxq0Gy504IhPef/fW0zaJBo3x1HLdym1HVsxdK0/R1nU8JU+grNLRTMYZyyqEDx
	+K0VKgAhPARLAR8FLlmY6+6Ae6IkMqrpY1upmbsuIkfgA8ChFRakT+w0phC72wDp
	6dro9dLl4fuC/E0k+Jp58Jfy2BA0kRRpyN2DAfvMF2UvUAfI9sBzAubsQ==
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazlp17011031.outbound.protection.outlook.com [40.93.6.31])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 468xtbjqar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 18:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTM4GrT8jFTxic+iJgkOwz9c8ZMWPinh3Kob/A4h2O9NDQSw2D1bBVvuEXVUGxG8HdIMA2TXTlpu1VE+nYIImSqfwah1hgPgq9NKg4lTUxfaUbqDrkhJzlBmN9WFNbbNtzEwcXU3ORLw2C+mGOHTZUT3xIs09n+Z7bWDoKLXX7WPld5tmcWX3IMgZyCAKOf1ojiZDlDA+9LqRd3n+/BgCTbfCQs8gPAcp8+p4LFlqzuCpaYMPRUOxxpDEZcoZG3Bg2TMq6cYYFq/F7QOxhtvxZIXZ4cl0DQPB2RfVlDRtvXag43bOtTaaJ1zyX323Hkrnzp6lZ7T6/Z/CpJH+sxNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6lAQghpkT9Vfc23SNqRafw+J+SrG87Kqs566IT2MOQ=;
 b=xUAvNPsjxWYrPE6IlDLl2xvjeLAta4IJDVyJ7SXtaXP1vDg0FR1kaK+Mi0w6Fuu71+PDXZqfvajKHa9hyqo48XdRXY8nTOzK+gK9vKPxOiXkgwS2AtCJebe6cVeruiDs4vvg40hc0wES4gQxzTUa5vKBQC6huKv2s3/FZWGw5WxysgpPF6v+m8ulhnoTAi47bAawEqa2VfCPD/X6UMf8hPVnLech4s7/DQGxGHVUDZMrd0haap23MIJolA9J9G8+jQzR0Iw47X404EL1XtfhI94N2/7xU9/Ql/zkwXbkKlCmrtPi6k4aXqgAgqMeuJnWyAj7g5fU1v+p8elKC/EZsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6lAQghpkT9Vfc23SNqRafw+J+SrG87Kqs566IT2MOQ=;
 b=tFkKJIbzZrNLF7E5ja1KtzOVWHG91z98H2rade6qXH38NxHxMEufSCuuPfv9nrSWzOQVrtq4pFJCfiHv3mAvyC6bKcwUKb7kpLvxcrnFFX/5+05qRG2e4KmNknYriWa75fd2NYmJvsMvQoYrzNdb7F8RJ4g28vGsuO42mbkq1echyBaPBF9jQQXjpjMdn9S0WOtRvw7jr2ohUHYg5cskgy88R6i7WHqt7740k+zTzHjwcoZ0uYvCl1ryM5VML9sE4hOFC0RfJgV96YdS7AzZyK/3dEMnS3YeQKuXs2xxcN5BCasvdWr/i8ayQvDiqKKzNZqJTRYTRQMxKMkWgjSXeQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SN7PR02MB10177.namprd02.prod.outlook.com
 (2603:10b6:806:2a5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 1 May
 2025 01:34:46 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 01:34:46 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH net-next v3] vhost/net: Defer TX queue re-enable until after sendmsg
Date: Wed, 30 Apr 2025 19:04:28 -0700
Message-ID: <20250501020428.1889162-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0099.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::40) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SN7PR02MB10177:EE_
X-MS-Office365-Filtering-Correlation-Id: ae36c420-59eb-44d2-cff0-08dd88505aea
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?la3E7FLUtAgxtRAPh0s90iQcWOjCW0dawTpVnB3c036FUch3dqEp4psSAqOL?=
 =?us-ascii?Q?SBKa6MekT8PexyJdt/NwT8g4B6EVndB0aE8HBU9wVCetkWDcH1uj+JCvdCEm?=
 =?us-ascii?Q?3QpGVrHuTZRdIsNYLAH0vNs0SRnJ1Fn3Z19LkmB+XfkLlKDwHM49R+h5SVUk?=
 =?us-ascii?Q?hshJfn3WjvpW1lEjLOV6LuCE3MxzVcOGExg+x8AOHu4XM1fmYN/j9XMoDGCt?=
 =?us-ascii?Q?Kgj8uwjdI5GQyBCwVCcqIuj5XP5dH9UENS6HEAsUjzNTjZVtDP7s8MVVj+YU?=
 =?us-ascii?Q?TyFxCZK1duBm5O+F5x1DqtUM1fLd32QLo68SnooCLke6yzBkykW3NsV2Y1EQ?=
 =?us-ascii?Q?yVVzyhxNIc8XzHR8TCjWR6kqIOF8MGFlZszoINkmDYnybGRYboVd1hQXNhYC?=
 =?us-ascii?Q?vAYU2T2E6MlT81UUoT7CphEGvB7SAgqz6Kk3UBwUXRaV/IJ741DZBW+gIpNM?=
 =?us-ascii?Q?rNUCGWgHHGPqX8vrLjvadLCq4iODr2sUIbOf20jMDB8wLY9VEHNqtMh42+Z0?=
 =?us-ascii?Q?lNrohDucwiUBIXEGS0+K0X5GtHAwjVaaN3BQFaWRrccontDCCkDloVrH0Oms?=
 =?us-ascii?Q?iPo66HTnqRsgS0BWdsjJqIOfK3LaIpa75vSTGPcHfcUd1pIb6gC/XLstgrws?=
 =?us-ascii?Q?K+yC8w+wnApFueI7v+zb8AqnXUuDYr6e3XQHnIp+IL+x80C9ApDgwpPWVgJ1?=
 =?us-ascii?Q?CU9fqZ0K78zVo0QkyGRAqBDoUSjE2zwAgKoM37A8mrJGUuLMYJD4kf7fZLxE?=
 =?us-ascii?Q?ChJ5MwdDEtbvi/w5AwH4aiwdI7QxhLFiIZe0QWZZ3X7rRvV8QRpskG5N5VwF?=
 =?us-ascii?Q?zJBw3AUW9rBREwoE9+ppbKBLUD8R8d3/W05PFkHK9Wtqv/He8M7q1ujbaOw9?=
 =?us-ascii?Q?+sCCYr1EqfdITg+8tlsrQSkFu0lYXM66xMpr6sxNfs6I19LyUK0+FIAT2LDf?=
 =?us-ascii?Q?7uz0MQA2DWhfpVVu1y6DEo6EMedg7zmmfmgAb8pdACINqlPw3g0OMChXEd5V?=
 =?us-ascii?Q?VkwkD0Paah65NGnUJQOVQpRb0L/3ztrlzHA2R5VBAWIdQ4vfP8BG5Lw1gFvN?=
 =?us-ascii?Q?YE0vbgEJPuQTWgLZYGjoQmxsa0DaVPbrZ5v6WKTWs1d2lobFThvPFB1DONEo?=
 =?us-ascii?Q?2MPpKcZe370J0EEV/wT+94iRaAUEZSWy1mUgzR17bL+2nZ92Tqqn8eBh5l+t?=
 =?us-ascii?Q?HrUdYMpkXC6WthuUG0MWjxUzvxceVQGJl/dle0Ov+Kg886QZuVQ73AS5/T+F?=
 =?us-ascii?Q?JuZt47FSFk/dL2gCizO8Lw89yYgek619YgANFbpCoPdM6Ib29w686fy1YnBp?=
 =?us-ascii?Q?oRDHPOx3iXwZB+wI6pgJFiaWgfR6g1yUlt452Kg5bF358QZg8AAb1BASn/o/?=
 =?us-ascii?Q?NmZ49I8CItiC6lYD4ikBaMEy5A/ZcoLOgXkq+syzHMXtsh57EZeasUD9f+XD?=
 =?us-ascii?Q?pOBBsCZTi5CUP3SvIj/QPw79JNFz/8KZtzpG7AAg9JrJTDF86Hrxvf6pEk5l?=
 =?us-ascii?Q?GsJN3hkokg6Tg0Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UhY5vQzyBamc08s+TZxuR86LQNLoJdLLHo/hHa/SAJYX0WF0ml8VdpyZ/idu?=
 =?us-ascii?Q?044ejNxN/MTaEi2ahQ6kM2s9MtNGclrLF+UKEBqfySJIrWcaHodnk4S8H1C3?=
 =?us-ascii?Q?/uhsNc5xYQjA7BVsTKZmbsZP/Fx+irg9S6QspRnbmWcB0Uestdzdz7G1M5RT?=
 =?us-ascii?Q?l6sbyB4cztJtd/xJC82eEQr1Hr9cMANnd0+YF79YGF+OqbvaAbGxBzXBgFb1?=
 =?us-ascii?Q?k+kHa8iD+Q96jydW5oyGlnDHT2EJ7N0+nEd9EyoBybS7mf6bHUspvXUIDuI8?=
 =?us-ascii?Q?25oNdk1XuEer5IPLoXtZhUDt7mD18KvJJJY3ZTeqH5HAQxMjXmJAYizo7R0p?=
 =?us-ascii?Q?M0mvubWhG/bieTbVM/ABa2TPxW5YNtnnJNBGvMGYptBvO1EYKvpF2vDM5MG7?=
 =?us-ascii?Q?H420EK/Y6RKB5lsqHRcxHhvcXrNnbUhUEMhWtKwIZEgUWjjukyw0y1FBo7m4?=
 =?us-ascii?Q?6223uzhK52QTIVvqCOCe5NE4qkxufLe3RQMA+1fCQtM+zBL0UvumEv+5CI1M?=
 =?us-ascii?Q?gt+w/1gt1Iy5tU/Zp71T+QoGHzQMZ6LlxxlBpYM3n8HBBfCEv5sGMIlK74Iz?=
 =?us-ascii?Q?dsfvVFFNTdEMBHdsZIHDFJaWGyfAWhOgdbKBkLuhM7Z25FyDm6XvHFn1mnxg?=
 =?us-ascii?Q?uvoBf1oQ857pTnUezdBK3ne288QB7D/TAlzLIDVXbnaFzM5AZJn3Vyr9FJ2/?=
 =?us-ascii?Q?1Dre38Qr9DtDdr+vVTN2FT5C7KUmH8c1P8BpnpSmFFgIxLV7r+DzKAef68x8?=
 =?us-ascii?Q?kxh5CbcA3qw00ppLn8Y8AN/AE103dcMZ/Py0dUmYpT+5FRYmTPibnNApKUi5?=
 =?us-ascii?Q?xD8sLZCBbJs35tsIrWS6lnwJJXdDg3PpahbdKN1mu31CtXAR7ibwmllZB25S?=
 =?us-ascii?Q?mcQUL57rdi6gAYGzLdoSMZZ7ukhmr1LqTO19/QkwZdhheo8sTTkx/W0NkXIu?=
 =?us-ascii?Q?jYWuV1rGBpX1Zxm1gHzO8xp+HWxMsZ/xfC/iJKpSTCHL7zwC+vZoxzMSTfZn?=
 =?us-ascii?Q?n7TGC7ZWQKrxwtx4jYsdh90XXy4bMXccw1zlk0XbygHP1MnlxqBSx52/+TRr?=
 =?us-ascii?Q?vkvKOLZK/6iNlxKAOQoFkMvy1+nRejn2i+MUsZS9IhpYOc39N1uhiJFXJYqz?=
 =?us-ascii?Q?TRE9FuWNny45X9M0OhITHjzYOpA0L8uyN32vNfJTEHV38U2UR26hKDp69eEl?=
 =?us-ascii?Q?egM/NY3IAGiZqVpXpAUO8UggJZWK+aV5AvxFndGRxF2leqS4SFuBrHlhML64?=
 =?us-ascii?Q?wGwvAJ+OYVsfjWQ0TW7a80nIpbJ37yS9FVboO++xgt4ADIeX08DqupcLb80b?=
 =?us-ascii?Q?WIVvZyjrRKxwVkZ2TZ/KcyWsdoMvC6eTjOF6JSsPP4pCilK+3dXMk7UGdJny?=
 =?us-ascii?Q?tNqYXYtfrQFCAqDfOGhrXBHauJ525JHRHOXy66AYXASvoYfNGkti3NsVH/FX?=
 =?us-ascii?Q?lnElsaxxNcEvfBS3wbJkp+IP/yMTB10ZyTclwa9Hjt0z6z5wdGJPna4sOdXa?=
 =?us-ascii?Q?DD9PLm/J6MeFiVofUMxUrSIT3E3mFAL1BPPgusHk+8UpWN90aA3iixeduIij?=
 =?us-ascii?Q?vFtJSw53P/gmDs6ufnGk+mZmndSraDfBTytqq62EnsAotC+yLbyu1d7P91T/?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae36c420-59eb-44d2-cff0-08dd88505aea
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 01:34:46.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nh6hfIKDrDoVM8W7CCWRquX2THyGinn8wEghSEKdV0KPL1yhp5TmzBZXZnISkA5sMWQCaiAWN3lGVytjsC/1qanJejisRkzO3bOUPbq4WXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR02MB10177
X-Authority-Analysis: v=2.4 cv=QLBoRhLL c=1 sm=1 tr=0 ts=6812cfb9 cx=c_pps a=BzboTkwgGU/iU5aMRKiaVQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=HhlKS6Ypksj65T2L5G8A:9
X-Proofpoint-GUID: gXOPbPjJknFVpuqVEX2uDUUVUBHZ-N-j
X-Proofpoint-ORIG-GUID: gXOPbPjJknFVpuqVEX2uDUUVUBHZ-N-j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAxMDAxMSBTYWx0ZWRfX/QwKjs/F8Ohk 68Yf62Jd0l7U7JibzQtM0vMWsLtfVBxrGfR5l4fT82KUn5osLezTwefv0mvkvT20dkf2xqM2bz8 Jlj/SNgzJ2KoEVy7I5uigxpy0IRfxwrC5bBj4Lg5lEMB1K1doCTQowqpLVrnNNEs4VJOsPq8HYk
 mhsM/shTp86yoCJIpYPhPXqofkemdRkG+BrJhpiyBoWj5cJc6pDDd+tNeeVpOgt3FyWe+ju0gsl pGLUApZpHZJ6wIExdKpx9+PraFYuf9K/98h2HiH/aepdh2QJCOMUo+u4fNG5vY1UDvvkNMzyEFZ 06Vg/fPOgBsvAPE8A4cXkbVP/T5OdHFy01rga27wtijUHVSLgFhkia4habWfBS1wluyS77MJgId
 MpaxLsdKBzdtEM0eY0U6vieh86YQ4I/WFMeTKMCaQ+yGfY4pI8bMEGX/62wvmymwCWiYEMlh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-01_01,2025-04-24_02,2025-02-21_01
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
v2->v3: Address MST's comments regarding busyloop_intr
	https://patchwork.kernel.org/project/netdevbpf/patch/20250420010518.2842335-1-jon@nutanix.com/
v1->v2: Move from net to net-next (no changes)
	https://patchwork.kernel.org/project/netdevbpf/patch/20250401043230.790419-1-jon@nutanix.com/
---
 drivers/vhost/net.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..7cbfc7d718b3 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -755,10 +755,10 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int err;
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
+	bool busyloop_intr;
 
 	do {
-		bool busyloop_intr = false;
-
+		busyloop_intr = false;
 		if (nvq->done_idx == VHOST_NET_BATCH)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
@@ -769,13 +769,10 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
-			if (unlikely(busyloop_intr)) {
-				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev,
-								vq))) {
-				vhost_disable_notify(&net->dev, vq);
-				continue;
-			}
+			/* Kicks are disabled at this point, break loop and
+			 * process any remaining batched packets. Queue will
+			 * be re-enabled afterwards.
+			 */
 			break;
 		}
 
@@ -825,7 +822,22 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
+	/* Kicks are still disabled, dispatch any remaining batched msgs. */
 	vhost_tx_batch(net, nvq, sock, &msg);
+
+	if (unlikely(busyloop_intr))
+		/* If interrupted while doing busy polling, requeue the
+		 * handler to be fair handle_rx as well as other tasks
+		 * waiting on cpu.
+		 */
+		vhost_poll_queue(&vq->poll);
+	else
+		/* All of our work has been completed; however, before
+		 * leaving the TX handler, do one last check for work,
+		 * and requeue handler if necessary. If there is no work,
+		 * queue will be reenabled.
+		 */
+		vhost_net_busy_poll_try_queue(net, vq);
 }
 
 static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
-- 
2.43.0


