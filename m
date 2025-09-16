Return-Path: <kvm+bounces-57743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4C4B59E05
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1078A328449
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFDF2F260E;
	Tue, 16 Sep 2025 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="U/oNZsxo";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="R8Z48w6y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10AF31E8B9
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041097; cv=fail; b=rSgCnWtxwfoQRyI8XGNt0RZkkKn7clyzBgjOyOw4mymSPt+7OliQRZeO1tIcei2cSQXKcM58FojmJZXuTbXkcaf1JD1n43pJsdIoZ6qSvOQybwuQRpppm7vdWGIp4+hg+twSDVptijebbEEUGtc8SdbQBZu5f/f2E9jdD0haX0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041097; c=relaxed/simple;
	bh=Q9qB5ehwi3NfG/CSKMIHgyJ4HdofEqGNj9tY271ZrM8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FgrFBp6URgudr1xTGiHxLC8eVaf0RDLlgoHhPcjQ/hxpkUBdrqL2Nbbs4ocl4S7hlv+wsNOOab7hnl2fDIQ0zovqh5eNLIBo890DvLtfao/GKTWHg8t1ktEdy/VCDAJsBXDvQ7wB2d5sL5xZAK5ybTLhj2D03OVbya1hjOO1jWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=U/oNZsxo; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=R8Z48w6y; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G8mwEG3768189;
	Tue, 16 Sep 2025 09:44:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=wiPj0rcOYac947gIuElTLTC1uBgTH5fZmjtfIGVts
	TA=; b=U/oNZsxoBJtGdQQ//SSyskT7UU3EtRo/p7EvKWhkEb5cDaNPYwBZusiuH
	Y3dPUFYsEKuKWp4STNkzxHP/ugCZ1XAd0yZB788NK6GRnjB7zMaKylPE5krKamhs
	g9je1KtI2K42OdqeEqGNhV/KO5HuiqiuXZMh4Lm/YsFqEqANnBTxayK+5Jrgd+xS
	sAPEXQvkdGh/VnJ7etHbf3a0HjreIzrXc8YxdVME8N/LjfLh+cqks9EYJuNidni8
	UZSnDwn1LZHrl5rytWQiMl9zOVnf1QGrzM1wUziJN+DTBQElLY/iQBy5Jch3jzvC
	OuifEfPoW076n5CDBxnKfYZus96nw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023143.outbound.protection.outlook.com [40.93.201.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 496uaq287s-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EdKKrh2tG156PQpRId2g3vkRvp+lt3GyNBMX8GduSSepQvLhD6cq5wUxbys+NGPKKytAdbzxb+f1PdFcZHsuOK/G03iIdh/3ByjEnH9q60w/McoK4RL4K1OgiCLP3IcVbD2lsK4ZC3rXk2iL+fnHcpyZAy4XG/P3LePlvZVzkJVOPDt9dvPWEK33+Z/0rzlushSVjy7sxl3EhK8XcpvouKXWhNNW4Qk0bV3WKttCe06drZJ/gxxbLKaBM+7lH9L3cCcR6SBS/2nHck53eYWVTDDfsoweR/Avl0obkbm34GckBxS5bbXuX9QuFyQHcZM8HNVL6xsbM+0S/msxHbHtww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiPj0rcOYac947gIuElTLTC1uBgTH5fZmjtfIGVtsTA=;
 b=X9NDnRotOBR3Uyplu7/mcv4NkpSHQ67CyQ4KRUdN55hGDxEQIrCtVM6qrFhUns8WXDMKjZ2pvY93nYH81ePNRlUTyK+IznjUSQCHeNe1hky4uaU4ggdC+GViTkJroeIQc/srHA5YI8j9ZeNyqbmaprGiik+zhzI7XpNXhLeRtX/R6wDObPsB6bfl8+cU8lwyFMvBMxd/n0hS1cKJsOiXFxtu1wk6GwOE9CdymL5ljrDZtxO2rp4h0UmwC0fWPSR+b1ijt9GHRP9KOhfjIt/44VXU+CWuMt2yeF0nT7inQEKXDxtHXO5Z0e8v2/yDU0GMGq0kEpFAYFfXbwX4KQ0bgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiPj0rcOYac947gIuElTLTC1uBgTH5fZmjtfIGVtsTA=;
 b=R8Z48w6yD7YOcbaNh+AaV0mYhDM8svAVCmOAZtt9tQ5NrlwUlTGERW2LySDjzTwIr5yjXXTvBxo4ZkRH6xMO5xHyEPv/3fD6XQSWYUud9EwLuL/IZUAsb3KB25KwdpHt5y3RHFAgiIwsy2KBcI9cxy4K/GyhIC66tu2tjxOtrObUS72EMmlg5Ji6kKeEwY+TtZG6CKnZeEtDW6Pc9hgkYivMy5TSG2s54CiUfVixCvjnH1pQ3rUE+KhGT8mGaL6o7gcVut949bh/ZHpjHlYdww8qOv4Ab7UDuFLpmSLpSwm8T7WgmWPKEnto1h5c/x5zsi4JPR81CyVLUgrqsF2kQQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:41 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:41 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 01/17] lib: add linux vmx.h clone from 6.16
Date: Tue, 16 Sep 2025 10:22:30 -0700
Message-ID: <20250916172247.610021-2-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: fb498d84-3485-4f65-0594-08ddf54054fc
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVdGkvULZP9K7Y8bhlOLXEiFmduY6IKqX9A2QAWCJybakPT9GcjvKv6c7IOl?=
 =?us-ascii?Q?ZTRt46QowF975CYgC/X69U+pT8HefMNU7/J90rpKa0NI9TamU9fVRRNg+Cjx?=
 =?us-ascii?Q?tYzQRrgnpcPIhziqSkHGpXpfmwss37x1DhcgBwjiPIiMn+J5wciHd29LeRFk?=
 =?us-ascii?Q?PBxedMzbCNyMwaQeEBG9QgCKYEhwS6d2xD3k8OagPJ05a11j8he6UG0dqpxn?=
 =?us-ascii?Q?Zs+ix7Dz7WnMAD1i+SF7N10mVFxdDxKgIPnEu+hsSwbJQKkrI9FkWxgchh0V?=
 =?us-ascii?Q?sy9i3HF0fshLTjc2A9pZMraHA6ngt7AcYutrgiD6on8TAjzjCUkx5T4NYVJe?=
 =?us-ascii?Q?t5vcZadtgq2gWK4w8+MVPhd86tKtecz1IB0jUK5UigLTaedIgQv+KVIjkUnf?=
 =?us-ascii?Q?ODjxS6V6kLzsMQZ5cNDfsL4Y0gVaIBc5Nqt4FaUlOieL4w1c9/+8UHSszjFi?=
 =?us-ascii?Q?tbyVO0DpOWxgXq+07Qg0C4duBdpsEKUPunuVhD/j1V27VHrwTKY/+2H2sFwf?=
 =?us-ascii?Q?mbGnTMyOHfrqtbLJyA/zw8NrLvopyO7XlHpnpXvm5ujb6Akkf/VuDi2TKK7E?=
 =?us-ascii?Q?TA0K0hnQzbvyERKQ/Hef/BcnhdSsaJqY7n+b/+w2FvmB++IVfOdvSozCvmDG?=
 =?us-ascii?Q?yLumKWmz08VlvMDKqH9lICDiu5FyVvSB7YkmjQp5+1yt0jvHexGfWDG9d02Z?=
 =?us-ascii?Q?7ep62heWTOrJCkT2P4SoqasBtNlSxD7nEnld7zqD5Jpc3+BnzRRMnkFu/+H1?=
 =?us-ascii?Q?YgIuTcAqneafuM5Jmo8JST9ZE744QIZXXxotxp72+7EQJxbBZPzCY7n65ezg?=
 =?us-ascii?Q?/JfmJiwIR458qoWVkL6y2zHRhSZCFmdUJfEgsJbAX3oW5jh0NpeXFP20lxfv?=
 =?us-ascii?Q?we3Q2QGxpT/zsXehxvcJKpCakYYIFAoRw2/w7zpYBauVksZO+P6uTF0CX7qU?=
 =?us-ascii?Q?kcxxAd9M2p2MYEvaEpbX99ycQh2iiOex9wX4z7NMeqPmjkJOZ38xLX0S+f1I?=
 =?us-ascii?Q?wLwhGOTff2pE7vly47Z/q0r66ZCPpdvOc0Tw9izRcX9ENC7HGo9KDhviboDA?=
 =?us-ascii?Q?Jy1rJ226dxtjvOLnGEyJvlClmMpGKgPdwRzpjiQ7uChlmjVkDKE+hfpGHlnV?=
 =?us-ascii?Q?CzED80AGRf3vLYXR2HmKE98zqmadToofnKTKD9n2CwHkVcxRg0wAE7KF0y36?=
 =?us-ascii?Q?1rowvaAcBGl8CzJGIZ8L54VlPJuDTlbn4qx5oIjlzdTWEuaLdIDIqYcj+c7H?=
 =?us-ascii?Q?GsQMZOEJKcRrgAicfdWbQwegrPj/wuszT7cEpE6dOjleQPrUgXeJ2FP+Bo/c?=
 =?us-ascii?Q?ZTna1Z/pNMtotJBqHKNUOdFQLXAYut6tUlhGvP7CaXyM0ZdPB6r446f7qVWs?=
 =?us-ascii?Q?X3QX0QQNwIYr5xqrxK2dbnxuRcITwyNrpAu22FgoCOVnnu/JB1WrENxOp1+C?=
 =?us-ascii?Q?XxJ/8FQLz9+JpjdFyPkyXuwotnQ5ErajgZRs23ApNDYURm5iBbP65w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CnY+18/xNKIfqWDM0m/vEEr2lMBHQvzcC/JKDZ29QLaYHO/fu61lSp7vntHO?=
 =?us-ascii?Q?eEC+gMCXq8dMjkbeRLHe7U9Eh67fD7IiUjSij9PPbAHXYu7f6FrLVvyDUAOz?=
 =?us-ascii?Q?5jsWF+KNgPkeWCByslcHpI5ObEKZwysi8f3SJVF9SIbo9/qCWLLXQ0ngo9LV?=
 =?us-ascii?Q?kpfzL1QIRHfQXBvG7T5IwFLURdPZDtdRf+1P42amrknNnx6w1hs/WbJu7F5R?=
 =?us-ascii?Q?XUJZLxVt90Ry6VR7jUF35tqf4p1RrVjFzditK6gGTXQnL4LPj8KdQ5RMpynU?=
 =?us-ascii?Q?5OszgmpnqDgbSWd7JgH2KHFg+J6SCOUbn5Eome3PgonpLUNpD3YW06tc8Nz2?=
 =?us-ascii?Q?cCfPaOybKGNHXgPYABAmfRRAJvQ7uWPuoF3C7nIWvAWiguK2LbZaVfbXfsk+?=
 =?us-ascii?Q?+zdmFO2mNOr2PCRbjR0ZoHw4Y7LcDsuNfVTvgpzfytHNlVAN35X/ecPPwuQO?=
 =?us-ascii?Q?JnwJiH9jUPJWdJTtG8qhXGdMhwuWRCvkKlQOrmwDrbMDmHG4pvXZb3XqlDIW?=
 =?us-ascii?Q?P7RvPbPG/n2uhrGg6JXubm+gj3JTlXsqKXzrYCgui9BlwaBfsFG8hzmVPpfs?=
 =?us-ascii?Q?Y+Fk/yNaSO9pWuy69dc/QQsMO9oIc1ofmBbPOMUT1XMHW/iCwNrX+5KO0V1A?=
 =?us-ascii?Q?OrAyIfJc0ss++DSCphA9bEnW2sASJtomX0e6ImJ2Aj3Wmd+Nr1bXLGaTYAyM?=
 =?us-ascii?Q?dA6F6lt8v9xOnNDFIY66E/EFHmGRMpa35c//zOufig9pttXRMI1c1n6+Bwox?=
 =?us-ascii?Q?RJkpD0GJidgkYwiD89ukSimkLJy0uOlk53hDl6NWokjlRS2avFwXqUaoWV9U?=
 =?us-ascii?Q?thn2HaXpE8odEDAIbKxeie/AQBntGKlsR2I54HjGXqm3OWGX6oYToDY0cFqT?=
 =?us-ascii?Q?JuogA1tRRy7jgnL7xku7iSnwADaIHyx46HEeF3qDR4qUQCRI/C6ewkgLhHsa?=
 =?us-ascii?Q?yAUtelYnDclx9mQvCqO6kYwbdZaZF1LPB7AOa8eOz8Os4Iq4i/wagISfRPsG?=
 =?us-ascii?Q?2zGG0z9GCF8FOEIySOiGOEBS2a2+/PNUOa+fSKdFO0cu1930Ydm/RzW37rdA?=
 =?us-ascii?Q?8tvQEN73j4o/41lRQj+MnyLeCTyyKpYe5cnkTMU46AWmwe9ut2ThF/QARLOJ?=
 =?us-ascii?Q?yDCP1GmumRRPBZL9SygCczjoX7Hmn4WiWnRAfmD2fSuuMFb8nLGF5a4qSg/D?=
 =?us-ascii?Q?mEG3nyZBohpJ+tpeEq/Nt5kS7MCgRqtPowy4MsdYLxx3Yoxz2LCuBayQgpKM?=
 =?us-ascii?Q?VsarbCbNJpRVSILJF0FQRD3bUw2qY1ChoeyfS1Fn25gcJwVCdV0ExkjdNHYd?=
 =?us-ascii?Q?R7nF46pkNhECs+fobr6nSvjFJyoO5JW2kTYLzOMh34UYyDlF0KJ6ZwtpNg6N?=
 =?us-ascii?Q?eEezQ82VTtRBWHrkVzA+q8IjjtCvLzNGYvg20F3eQ1fKr3XjXvFl+rqjXUsh?=
 =?us-ascii?Q?+p+jtJWt+x+5upcfJYCPnaqclJnZvePe398XVen89K+90iFnfMJ5FjDlodNb?=
 =?us-ascii?Q?cmhH1mRXVnrKjqnE8waKWDbqH3zyYy2lgXtLpKlhls4gnQ7r7ZdMh55axada?=
 =?us-ascii?Q?PawqQzwq55hovQQAixB9UAYQLTDHgS1D7CuywsctoI6ugCIE+azSJj6Ru1yD?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb498d84-3485-4f65-0594-08ddf54054fc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:41.1448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCE/EuUqXV+8GCGfv20UXWqaEY0BPoOBFbsB626LG65/QIYtEc7PM1Sl/cpWzE2EFLuPZfKr19/xaPF0cHu+Jkq58YqM9w36xud+ssBGm9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX+TAWAvN1TdHh
 k1i7QMZMelaMhQMtbfPxidp4i2Y32n9SVSqvZTnpx24Mu+fLadx1yRzm6oBoOhIMObAw626PTBn
 mVgz+IEC/+4KtAA+HBf8UCH4UycoJdMX1xuQxcvoZ4ZMB3XO72qWKS7qtoyoXMYEuK7AokrqqEv
 nMKRZObvVWf+4czT/H6coGe5/5aZ/en9WzTfz+0Gbe/cORdOxhgNf3ayS2Gi9tRYF+kHgSkuiTR
 twLgulhLM/MmkfFJLs3xA7V0JaQVhUVhNsdXffVAG/DbGVPduUml1KvuqE15cMeZfSBFGJD58md
 eVpv7QVbzvyj6Kgt986vY/h1k9KWCGohJXuTE2+TSGOZdL4fPxSeIZonjN7luA=
X-Authority-Analysis: v=2.4 cv=Qppe3Uyd c=1 sm=1 tr=0 ts=68c993fb cx=c_pps
 a=ZOsnctmsBCw54sLOPzIoIA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=mNtOeJMeAAAA:8 a=y8IqmFJ0AMDB3gufPlcA:9 a=_FGNsZxrd-dVGcz-3RuP:22
X-Proofpoint-GUID: lCD5QMKt8C1MS0huyD7287eBL48oH2oG
X-Proofpoint-ORIG-GUID: lCD5QMKt8C1MS0huyD7287eBL48oH2oG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Add Linux's arch/x86/include/asm/vmx.h from [1] into lib/linux/vmx.h.

This copy will replace most (if not all) of the existing vmx.h in follow
up commits, and will allow kvm-unit-tests to be directly aligned with
how Linux defines vmx.h.

[1] e6a8578 ("KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs")

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/vmx.h | 672 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 672 insertions(+)
 create mode 100644 lib/linux/vmx.h

diff --git a/lib/linux/vmx.h b/lib/linux/vmx.h
new file mode 100644
index 00000000..cca7d664
--- /dev/null
+++ b/lib/linux/vmx.h
@@ -0,0 +1,672 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * vmx.h: VMX Architecture related definitions
+ * Copyright (c) 2004, Intel Corporation.
+ *
+ * A few random additions are:
+ * Copyright (C) 2006 Qumranet
+ *    Avi Kivity <avi@qumranet.com>
+ *    Yaniv Kamay <yaniv@qumranet.com>
+ */
+#ifndef VMX_H
+#define VMX_H
+
+
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/types.h>
+
+#include <uapi/asm/vmx.h>
+#include <asm/trapnr.h>
+#include <asm/vmxfeatures.h>
+
+#define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
+
+/*
+ * Definitions of Primary Processor-Based VM-Execution Controls.
+ */
+#define CPU_BASED_INTR_WINDOW_EXITING           VMCS_CONTROL_BIT(INTR_WINDOW_EXITING)
+#define CPU_BASED_USE_TSC_OFFSETTING            VMCS_CONTROL_BIT(USE_TSC_OFFSETTING)
+#define CPU_BASED_HLT_EXITING                   VMCS_CONTROL_BIT(HLT_EXITING)
+#define CPU_BASED_INVLPG_EXITING                VMCS_CONTROL_BIT(INVLPG_EXITING)
+#define CPU_BASED_MWAIT_EXITING                 VMCS_CONTROL_BIT(MWAIT_EXITING)
+#define CPU_BASED_RDPMC_EXITING                 VMCS_CONTROL_BIT(RDPMC_EXITING)
+#define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EXITING)
+#define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
+#define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
+#define CPU_BASED_ACTIVATE_TERTIARY_CONTROLS	VMCS_CONTROL_BIT(TERTIARY_CONTROLS)
+#define CPU_BASED_CR8_LOAD_EXITING              VMCS_CONTROL_BIT(CR8_LOAD_EXITING)
+#define CPU_BASED_CR8_STORE_EXITING             VMCS_CONTROL_BIT(CR8_STORE_EXITING)
+#define CPU_BASED_TPR_SHADOW                    VMCS_CONTROL_BIT(VIRTUAL_TPR)
+#define CPU_BASED_NMI_WINDOW_EXITING		VMCS_CONTROL_BIT(NMI_WINDOW_EXITING)
+#define CPU_BASED_MOV_DR_EXITING                VMCS_CONTROL_BIT(MOV_DR_EXITING)
+#define CPU_BASED_UNCOND_IO_EXITING             VMCS_CONTROL_BIT(UNCOND_IO_EXITING)
+#define CPU_BASED_USE_IO_BITMAPS                VMCS_CONTROL_BIT(USE_IO_BITMAPS)
+#define CPU_BASED_MONITOR_TRAP_FLAG             VMCS_CONTROL_BIT(MONITOR_TRAP_FLAG)
+#define CPU_BASED_USE_MSR_BITMAPS               VMCS_CONTROL_BIT(USE_MSR_BITMAPS)
+#define CPU_BASED_MONITOR_EXITING               VMCS_CONTROL_BIT(MONITOR_EXITING)
+#define CPU_BASED_PAUSE_EXITING                 VMCS_CONTROL_BIT(PAUSE_EXITING)
+#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   VMCS_CONTROL_BIT(SEC_CONTROLS)
+
+#define CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x0401e172
+
+/*
+ * Definitions of Secondary Processor-Based VM-Execution Controls.
+ */
+#define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES VMCS_CONTROL_BIT(VIRT_APIC_ACCESSES)
+#define SECONDARY_EXEC_ENABLE_EPT               VMCS_CONTROL_BIT(EPT)
+#define SECONDARY_EXEC_DESC			VMCS_CONTROL_BIT(DESC_EXITING)
+#define SECONDARY_EXEC_ENABLE_RDTSCP		VMCS_CONTROL_BIT(RDTSCP)
+#define SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE   VMCS_CONTROL_BIT(VIRTUAL_X2APIC)
+#define SECONDARY_EXEC_ENABLE_VPID              VMCS_CONTROL_BIT(VPID)
+#define SECONDARY_EXEC_WBINVD_EXITING		VMCS_CONTROL_BIT(WBINVD_EXITING)
+#define SECONDARY_EXEC_UNRESTRICTED_GUEST	VMCS_CONTROL_BIT(UNRESTRICTED_GUEST)
+#define SECONDARY_EXEC_APIC_REGISTER_VIRT       VMCS_CONTROL_BIT(APIC_REGISTER_VIRT)
+#define SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY    VMCS_CONTROL_BIT(VIRT_INTR_DELIVERY)
+#define SECONDARY_EXEC_PAUSE_LOOP_EXITING	VMCS_CONTROL_BIT(PAUSE_LOOP_EXITING)
+#define SECONDARY_EXEC_RDRAND_EXITING		VMCS_CONTROL_BIT(RDRAND_EXITING)
+#define SECONDARY_EXEC_ENABLE_INVPCID		VMCS_CONTROL_BIT(INVPCID)
+#define SECONDARY_EXEC_ENABLE_VMFUNC            VMCS_CONTROL_BIT(VMFUNC)
+#define SECONDARY_EXEC_SHADOW_VMCS              VMCS_CONTROL_BIT(SHADOW_VMCS)
+#define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
+#define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
+#define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
+#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
+#define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
+#define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
+#define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
+#define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
+#define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
+#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
+#define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
+#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
+
+/*
+ * Definitions of Tertiary Processor-Based VM-Execution Controls.
+ */
+#define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+
+#define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
+#define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
+#define PIN_BASED_VIRTUAL_NMIS                  VMCS_CONTROL_BIT(VIRTUAL_NMIS)
+#define PIN_BASED_VMX_PREEMPTION_TIMER          VMCS_CONTROL_BIT(PREEMPTION_TIMER)
+#define PIN_BASED_POSTED_INTR                   VMCS_CONTROL_BIT(POSTED_INTR)
+
+#define PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x00000016
+
+#define VM_EXIT_SAVE_DEBUG_CONTROLS             0x00000004
+#define VM_EXIT_HOST_ADDR_SPACE_SIZE            0x00000200
+#define VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL      0x00001000
+#define VM_EXIT_ACK_INTR_ON_EXIT                0x00008000
+#define VM_EXIT_SAVE_IA32_PAT			0x00040000
+#define VM_EXIT_LOAD_IA32_PAT			0x00080000
+#define VM_EXIT_SAVE_IA32_EFER                  0x00100000
+#define VM_EXIT_LOAD_IA32_EFER                  0x00200000
+#define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER       0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
+#define VM_EXIT_PT_CONCEAL_PIP			0x01000000
+#define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+
+#define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
+
+#define VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
+#define VM_ENTRY_IA32E_MODE                     0x00000200
+#define VM_ENTRY_SMM                            0x00000400
+#define VM_ENTRY_DEACT_DUAL_MONITOR             0x00000800
+#define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL     0x00002000
+#define VM_ENTRY_LOAD_IA32_PAT			0x00004000
+#define VM_ENTRY_LOAD_IA32_EFER                 0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
+#define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
+#define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+
+#define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
+
+/* VMFUNC functions */
+#define VMFUNC_CONTROL_BIT(x)	BIT((VMX_FEATURE_##x & 0x1f) - 28)
+
+#define VMX_VMFUNC_EPTP_SWITCHING               VMFUNC_CONTROL_BIT(EPTP_SWITCHING)
+#define VMFUNC_EPTP_ENTRIES  512
+
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
+#define VMX_BASIC_INOUT				BIT_ULL(54)
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+
+static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
+{
+	return vmx_basic & GENMASK_ULL(30, 0);
+}
+
+static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
+}
+
+static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
+}
+
+static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
+{
+	return revision | ((u64)size << 32) | ((u64)memtype << 50);
+}
+
+#define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
+#define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
+#define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
+#define VMX_MISC_ACTIVITY_WAIT_SIPI		BIT_ULL(8)
+#define VMX_MISC_INTEL_PT			BIT_ULL(14)
+#define VMX_MISC_RDMSR_IN_SMM			BIT_ULL(15)
+#define VMX_MISC_VMXOFF_BLOCK_SMI		BIT_ULL(28)
+#define VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	BIT_ULL(29)
+#define VMX_MISC_ZERO_LEN_INS			BIT_ULL(30)
+#define VMX_MISC_MSR_LIST_MULTIPLIER		512
+
+static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
+{
+	return vmx_misc & GENMASK_ULL(4, 0);
+}
+
+static inline int vmx_misc_cr3_count(u64 vmx_misc)
+{
+	return (vmx_misc & GENMASK_ULL(24, 16)) >> 16;
+}
+
+static inline int vmx_misc_max_msr(u64 vmx_misc)
+{
+	return (vmx_misc & GENMASK_ULL(27, 25)) >> 25;
+}
+
+static inline int vmx_misc_mseg_revid(u64 vmx_misc)
+{
+	return (vmx_misc & GENMASK_ULL(63, 32)) >> 32;
+}
+
+/* VMCS Encodings */
+enum vmcs_field {
+	VIRTUAL_PROCESSOR_ID            = 0x00000000,
+	POSTED_INTR_NV                  = 0x00000002,
+	LAST_PID_POINTER_INDEX		= 0x00000008,
+	GUEST_ES_SELECTOR               = 0x00000800,
+	GUEST_CS_SELECTOR               = 0x00000802,
+	GUEST_SS_SELECTOR               = 0x00000804,
+	GUEST_DS_SELECTOR               = 0x00000806,
+	GUEST_FS_SELECTOR               = 0x00000808,
+	GUEST_GS_SELECTOR               = 0x0000080a,
+	GUEST_LDTR_SELECTOR             = 0x0000080c,
+	GUEST_TR_SELECTOR               = 0x0000080e,
+	GUEST_INTR_STATUS               = 0x00000810,
+	GUEST_PML_INDEX			= 0x00000812,
+	HOST_ES_SELECTOR                = 0x00000c00,
+	HOST_CS_SELECTOR                = 0x00000c02,
+	HOST_SS_SELECTOR                = 0x00000c04,
+	HOST_DS_SELECTOR                = 0x00000c06,
+	HOST_FS_SELECTOR                = 0x00000c08,
+	HOST_GS_SELECTOR                = 0x00000c0a,
+	HOST_TR_SELECTOR                = 0x00000c0c,
+	IO_BITMAP_A                     = 0x00002000,
+	IO_BITMAP_A_HIGH                = 0x00002001,
+	IO_BITMAP_B                     = 0x00002002,
+	IO_BITMAP_B_HIGH                = 0x00002003,
+	MSR_BITMAP                      = 0x00002004,
+	MSR_BITMAP_HIGH                 = 0x00002005,
+	VM_EXIT_MSR_STORE_ADDR          = 0x00002006,
+	VM_EXIT_MSR_STORE_ADDR_HIGH     = 0x00002007,
+	VM_EXIT_MSR_LOAD_ADDR           = 0x00002008,
+	VM_EXIT_MSR_LOAD_ADDR_HIGH      = 0x00002009,
+	VM_ENTRY_MSR_LOAD_ADDR          = 0x0000200a,
+	VM_ENTRY_MSR_LOAD_ADDR_HIGH     = 0x0000200b,
+	PML_ADDRESS			= 0x0000200e,
+	PML_ADDRESS_HIGH		= 0x0000200f,
+	TSC_OFFSET                      = 0x00002010,
+	TSC_OFFSET_HIGH                 = 0x00002011,
+	VIRTUAL_APIC_PAGE_ADDR          = 0x00002012,
+	VIRTUAL_APIC_PAGE_ADDR_HIGH     = 0x00002013,
+	APIC_ACCESS_ADDR		= 0x00002014,
+	APIC_ACCESS_ADDR_HIGH		= 0x00002015,
+	POSTED_INTR_DESC_ADDR           = 0x00002016,
+	POSTED_INTR_DESC_ADDR_HIGH      = 0x00002017,
+	VM_FUNCTION_CONTROL             = 0x00002018,
+	VM_FUNCTION_CONTROL_HIGH        = 0x00002019,
+	EPT_POINTER                     = 0x0000201a,
+	EPT_POINTER_HIGH                = 0x0000201b,
+	EOI_EXIT_BITMAP0                = 0x0000201c,
+	EOI_EXIT_BITMAP0_HIGH           = 0x0000201d,
+	EOI_EXIT_BITMAP1                = 0x0000201e,
+	EOI_EXIT_BITMAP1_HIGH           = 0x0000201f,
+	EOI_EXIT_BITMAP2                = 0x00002020,
+	EOI_EXIT_BITMAP2_HIGH           = 0x00002021,
+	EOI_EXIT_BITMAP3                = 0x00002022,
+	EOI_EXIT_BITMAP3_HIGH           = 0x00002023,
+	EPTP_LIST_ADDRESS               = 0x00002024,
+	EPTP_LIST_ADDRESS_HIGH          = 0x00002025,
+	VMREAD_BITMAP                   = 0x00002026,
+	VMREAD_BITMAP_HIGH              = 0x00002027,
+	VMWRITE_BITMAP                  = 0x00002028,
+	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFORMATION_ADDRESS		= 0x0000202A,
+	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
+	XSS_EXIT_BITMAP                 = 0x0000202C,
+	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
+	ENCLS_EXITING_BITMAP		= 0x0000202E,
+	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	TSC_MULTIPLIER                  = 0x00002032,
+	TSC_MULTIPLIER_HIGH             = 0x00002033,
+	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
+	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
+	PID_POINTER_TABLE		= 0x00002042,
+	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
+	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	VMCS_LINK_POINTER               = 0x00002800,
+	VMCS_LINK_POINTER_HIGH          = 0x00002801,
+	GUEST_IA32_DEBUGCTL             = 0x00002802,
+	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
+	GUEST_IA32_PAT			= 0x00002804,
+	GUEST_IA32_PAT_HIGH		= 0x00002805,
+	GUEST_IA32_EFER			= 0x00002806,
+	GUEST_IA32_EFER_HIGH		= 0x00002807,
+	GUEST_IA32_PERF_GLOBAL_CTRL	= 0x00002808,
+	GUEST_IA32_PERF_GLOBAL_CTRL_HIGH= 0x00002809,
+	GUEST_PDPTR0                    = 0x0000280a,
+	GUEST_PDPTR0_HIGH               = 0x0000280b,
+	GUEST_PDPTR1                    = 0x0000280c,
+	GUEST_PDPTR1_HIGH               = 0x0000280d,
+	GUEST_PDPTR2                    = 0x0000280e,
+	GUEST_PDPTR2_HIGH               = 0x0000280f,
+	GUEST_PDPTR3                    = 0x00002810,
+	GUEST_PDPTR3_HIGH               = 0x00002811,
+	GUEST_BNDCFGS                   = 0x00002812,
+	GUEST_BNDCFGS_HIGH              = 0x00002813,
+	GUEST_IA32_RTIT_CTL		= 0x00002814,
+	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	HOST_IA32_PAT			= 0x00002c00,
+	HOST_IA32_PAT_HIGH		= 0x00002c01,
+	HOST_IA32_EFER			= 0x00002c02,
+	HOST_IA32_EFER_HIGH		= 0x00002c03,
+	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
+	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
+	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
+	EXCEPTION_BITMAP                = 0x00004004,
+	PAGE_FAULT_ERROR_CODE_MASK      = 0x00004006,
+	PAGE_FAULT_ERROR_CODE_MATCH     = 0x00004008,
+	CR3_TARGET_COUNT                = 0x0000400a,
+	VM_EXIT_CONTROLS                = 0x0000400c,
+	VM_EXIT_MSR_STORE_COUNT         = 0x0000400e,
+	VM_EXIT_MSR_LOAD_COUNT          = 0x00004010,
+	VM_ENTRY_CONTROLS               = 0x00004012,
+	VM_ENTRY_MSR_LOAD_COUNT         = 0x00004014,
+	VM_ENTRY_INTR_INFO_FIELD        = 0x00004016,
+	VM_ENTRY_EXCEPTION_ERROR_CODE   = 0x00004018,
+	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
+	TPR_THRESHOLD                   = 0x0000401c,
+	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
+	PLE_GAP                         = 0x00004020,
+	PLE_WINDOW                      = 0x00004022,
+	NOTIFY_WINDOW                   = 0x00004024,
+	VM_INSTRUCTION_ERROR            = 0x00004400,
+	VM_EXIT_REASON                  = 0x00004402,
+	VM_EXIT_INTR_INFO               = 0x00004404,
+	VM_EXIT_INTR_ERROR_CODE         = 0x00004406,
+	IDT_VECTORING_INFO_FIELD        = 0x00004408,
+	IDT_VECTORING_ERROR_CODE        = 0x0000440a,
+	VM_EXIT_INSTRUCTION_LEN         = 0x0000440c,
+	VMX_INSTRUCTION_INFO            = 0x0000440e,
+	GUEST_ES_LIMIT                  = 0x00004800,
+	GUEST_CS_LIMIT                  = 0x00004802,
+	GUEST_SS_LIMIT                  = 0x00004804,
+	GUEST_DS_LIMIT                  = 0x00004806,
+	GUEST_FS_LIMIT                  = 0x00004808,
+	GUEST_GS_LIMIT                  = 0x0000480a,
+	GUEST_LDTR_LIMIT                = 0x0000480c,
+	GUEST_TR_LIMIT                  = 0x0000480e,
+	GUEST_GDTR_LIMIT                = 0x00004810,
+	GUEST_IDTR_LIMIT                = 0x00004812,
+	GUEST_ES_AR_BYTES               = 0x00004814,
+	GUEST_CS_AR_BYTES               = 0x00004816,
+	GUEST_SS_AR_BYTES               = 0x00004818,
+	GUEST_DS_AR_BYTES               = 0x0000481a,
+	GUEST_FS_AR_BYTES               = 0x0000481c,
+	GUEST_GS_AR_BYTES               = 0x0000481e,
+	GUEST_LDTR_AR_BYTES             = 0x00004820,
+	GUEST_TR_AR_BYTES               = 0x00004822,
+	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
+	GUEST_ACTIVITY_STATE            = 0x00004826,
+	GUEST_SYSENTER_CS               = 0x0000482A,
+	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
+	HOST_IA32_SYSENTER_CS           = 0x00004c00,
+	CR0_GUEST_HOST_MASK             = 0x00006000,
+	CR4_GUEST_HOST_MASK             = 0x00006002,
+	CR0_READ_SHADOW                 = 0x00006004,
+	CR4_READ_SHADOW                 = 0x00006006,
+	CR3_TARGET_VALUE0               = 0x00006008,
+	CR3_TARGET_VALUE1               = 0x0000600a,
+	CR3_TARGET_VALUE2               = 0x0000600c,
+	CR3_TARGET_VALUE3               = 0x0000600e,
+	EXIT_QUALIFICATION              = 0x00006400,
+	GUEST_LINEAR_ADDRESS            = 0x0000640a,
+	GUEST_CR0                       = 0x00006800,
+	GUEST_CR3                       = 0x00006802,
+	GUEST_CR4                       = 0x00006804,
+	GUEST_ES_BASE                   = 0x00006806,
+	GUEST_CS_BASE                   = 0x00006808,
+	GUEST_SS_BASE                   = 0x0000680a,
+	GUEST_DS_BASE                   = 0x0000680c,
+	GUEST_FS_BASE                   = 0x0000680e,
+	GUEST_GS_BASE                   = 0x00006810,
+	GUEST_LDTR_BASE                 = 0x00006812,
+	GUEST_TR_BASE                   = 0x00006814,
+	GUEST_GDTR_BASE                 = 0x00006816,
+	GUEST_IDTR_BASE                 = 0x00006818,
+	GUEST_DR7                       = 0x0000681a,
+	GUEST_RSP                       = 0x0000681c,
+	GUEST_RIP                       = 0x0000681e,
+	GUEST_RFLAGS                    = 0x00006820,
+	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
+	GUEST_SYSENTER_ESP              = 0x00006824,
+	GUEST_SYSENTER_EIP              = 0x00006826,
+	HOST_CR0                        = 0x00006c00,
+	HOST_CR3                        = 0x00006c02,
+	HOST_CR4                        = 0x00006c04,
+	HOST_FS_BASE                    = 0x00006c06,
+	HOST_GS_BASE                    = 0x00006c08,
+	HOST_TR_BASE                    = 0x00006c0a,
+	HOST_GDTR_BASE                  = 0x00006c0c,
+	HOST_IDTR_BASE                  = 0x00006c0e,
+	HOST_IA32_SYSENTER_ESP          = 0x00006c10,
+	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
+	HOST_RSP                        = 0x00006c14,
+	HOST_RIP                        = 0x00006c16,
+};
+
+/*
+ * Interruption-information format
+ */
+#define INTR_INFO_VECTOR_MASK           0xff            /* 7:0 */
+#define INTR_INFO_INTR_TYPE_MASK        0x700           /* 10:8 */
+#define INTR_INFO_DELIVER_CODE_MASK     0x800           /* 11 */
+#define INTR_INFO_UNBLOCK_NMI		0x1000		/* 12 */
+#define INTR_INFO_VALID_MASK            0x80000000      /* 31 */
+#define INTR_INFO_RESVD_BITS_MASK       0x7ffff000
+
+#define VECTORING_INFO_VECTOR_MASK           	INTR_INFO_VECTOR_MASK
+#define VECTORING_INFO_TYPE_MASK        	INTR_INFO_INTR_TYPE_MASK
+#define VECTORING_INFO_DELIVER_CODE_MASK    	INTR_INFO_DELIVER_CODE_MASK
+#define VECTORING_INFO_VALID_MASK       	INTR_INFO_VALID_MASK
+
+#define INTR_TYPE_EXT_INTR		(EVENT_TYPE_EXTINT << 8)	/* external interrupt */
+#define INTR_TYPE_RESERVED		(EVENT_TYPE_RESERVED << 8)	/* reserved */
+#define INTR_TYPE_NMI_INTR		(EVENT_TYPE_NMI << 8)		/* NMI */
+#define INTR_TYPE_HARD_EXCEPTION	(EVENT_TYPE_HWEXC << 8)		/* processor exception */
+#define INTR_TYPE_SOFT_INTR		(EVENT_TYPE_SWINT << 8)		/* software interrupt */
+#define INTR_TYPE_PRIV_SW_EXCEPTION	(EVENT_TYPE_PRIV_SWEXC << 8)	/* ICE breakpoint */
+#define INTR_TYPE_SOFT_EXCEPTION	(EVENT_TYPE_SWEXC << 8)		/* software exception */
+#define INTR_TYPE_OTHER_EVENT		(EVENT_TYPE_OTHER << 8)		/* other event */
+
+/* GUEST_INTERRUPTIBILITY_INFO flags. */
+#define GUEST_INTR_STATE_STI		0x00000001
+#define GUEST_INTR_STATE_MOV_SS		0x00000002
+#define GUEST_INTR_STATE_SMI		0x00000004
+#define GUEST_INTR_STATE_NMI		0x00000008
+#define GUEST_INTR_STATE_ENCLAVE_INTR	0x00000010
+
+/* GUEST_ACTIVITY_STATE flags */
+#define GUEST_ACTIVITY_ACTIVE		0
+#define GUEST_ACTIVITY_HLT		1
+#define GUEST_ACTIVITY_SHUTDOWN		2
+#define GUEST_ACTIVITY_WAIT_SIPI	3
+
+/*
+ * Exit Qualifications for MOV for Control Register Access
+ */
+#define CONTROL_REG_ACCESS_NUM          0x7     /* 2:0, number of control reg.*/
+#define CONTROL_REG_ACCESS_TYPE         0x30    /* 5:4, access type */
+#define CONTROL_REG_ACCESS_REG          0xf00   /* 10:8, general purpose reg. */
+#define LMSW_SOURCE_DATA_SHIFT 16
+#define LMSW_SOURCE_DATA  (0xFFFF << LMSW_SOURCE_DATA_SHIFT) /* 16:31 lmsw source */
+#define REG_EAX                         (0 << 8)
+#define REG_ECX                         (1 << 8)
+#define REG_EDX                         (2 << 8)
+#define REG_EBX                         (3 << 8)
+#define REG_ESP                         (4 << 8)
+#define REG_EBP                         (5 << 8)
+#define REG_ESI                         (6 << 8)
+#define REG_EDI                         (7 << 8)
+#define REG_R8                         (8 << 8)
+#define REG_R9                         (9 << 8)
+#define REG_R10                        (10 << 8)
+#define REG_R11                        (11 << 8)
+#define REG_R12                        (12 << 8)
+#define REG_R13                        (13 << 8)
+#define REG_R14                        (14 << 8)
+#define REG_R15                        (15 << 8)
+
+/*
+ * Exit Qualifications for MOV for Debug Register Access
+ */
+#define DEBUG_REG_ACCESS_NUM            0x7     /* 2:0, number of debug reg. */
+#define DEBUG_REG_ACCESS_TYPE           0x10    /* 4, direction of access */
+#define TYPE_MOV_TO_DR                  (0 << 4)
+#define TYPE_MOV_FROM_DR                (1 << 4)
+#define DEBUG_REG_ACCESS_REG(eq)        (((eq) >> 8) & 0xf) /* 11:8, general purpose reg. */
+
+
+/*
+ * Exit Qualifications for APIC-Access
+ */
+#define APIC_ACCESS_OFFSET              0xfff   /* 11:0, offset within the APIC page */
+#define APIC_ACCESS_TYPE                0xf000  /* 15:12, access type */
+#define TYPE_LINEAR_APIC_INST_READ      (0 << 12)
+#define TYPE_LINEAR_APIC_INST_WRITE     (1 << 12)
+#define TYPE_LINEAR_APIC_INST_FETCH     (2 << 12)
+#define TYPE_LINEAR_APIC_EVENT          (3 << 12)
+#define TYPE_PHYSICAL_APIC_EVENT        (10 << 12)
+#define TYPE_PHYSICAL_APIC_INST         (15 << 12)
+
+/* segment AR in VMCS -- these are different from what LAR reports */
+#define VMX_SEGMENT_AR_L_MASK (1 << 13)
+
+#define VMX_AR_TYPE_ACCESSES_MASK 1
+#define VMX_AR_TYPE_READABLE_MASK (1 << 1)
+#define VMX_AR_TYPE_WRITEABLE_MASK (1 << 2)
+#define VMX_AR_TYPE_CODE_MASK (1 << 3)
+#define VMX_AR_TYPE_MASK 0x0f
+#define VMX_AR_TYPE_BUSY_64_TSS 11
+#define VMX_AR_TYPE_BUSY_32_TSS 11
+#define VMX_AR_TYPE_BUSY_16_TSS 3
+#define VMX_AR_TYPE_LDT 2
+
+#define VMX_AR_UNUSABLE_MASK (1 << 16)
+#define VMX_AR_S_MASK (1 << 4)
+#define VMX_AR_P_MASK (1 << 7)
+#define VMX_AR_L_MASK (1 << 13)
+#define VMX_AR_DB_MASK (1 << 14)
+#define VMX_AR_G_MASK (1 << 15)
+#define VMX_AR_DPL_SHIFT 5
+#define VMX_AR_DPL(ar) (((ar) >> VMX_AR_DPL_SHIFT) & 3)
+
+#define VMX_AR_RESERVD_MASK 0xfffe0f00
+
+#define TSS_PRIVATE_MEMSLOT			(KVM_USER_MEM_SLOTS + 0)
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 1)
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 2)
+
+#define VMX_NR_VPIDS				(1 << 16)
+#define VMX_VPID_EXTENT_INDIVIDUAL_ADDR		0
+#define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
+#define VMX_VPID_EXTENT_ALL_CONTEXT		2
+#define VMX_VPID_EXTENT_SINGLE_NON_GLOBAL	3
+
+#define VMX_EPT_EXTENT_CONTEXT			1
+#define VMX_EPT_EXTENT_GLOBAL			2
+#define VMX_EPT_EXTENT_SHIFT			24
+
+#define VMX_EPT_EXECUTE_ONLY_BIT		(1ull)
+#define VMX_EPT_PAGE_WALK_4_BIT			(1ull << 6)
+#define VMX_EPT_PAGE_WALK_5_BIT			(1ull << 7)
+#define VMX_EPTP_UC_BIT				(1ull << 8)
+#define VMX_EPTP_WB_BIT				(1ull << 14)
+#define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
+#define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
+#define VMX_EPT_INVEPT_BIT			(1ull << 20)
+#define VMX_EPT_AD_BIT				    (1ull << 21)
+#define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
+#define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
+
+#define VMX_VPID_INVVPID_BIT                    (1ull << 0) /* (32 - 32) */
+#define VMX_VPID_EXTENT_INDIVIDUAL_ADDR_BIT     (1ull << 8) /* (40 - 32) */
+#define VMX_VPID_EXTENT_SINGLE_CONTEXT_BIT      (1ull << 9) /* (41 - 32) */
+#define VMX_VPID_EXTENT_GLOBAL_CONTEXT_BIT      (1ull << 10) /* (42 - 32) */
+#define VMX_VPID_EXTENT_SINGLE_NON_GLOBAL_BIT   (1ull << 11) /* (43 - 32) */
+
+#define VMX_EPT_MT_EPTE_SHIFT			3
+#define VMX_EPTP_PWL_MASK			0x38ull
+#define VMX_EPTP_PWL_4				0x18ull
+#define VMX_EPTP_PWL_5				0x20ull
+#define VMX_EPTP_AD_ENABLE_BIT			(1ull << 6)
+/* The EPTP memtype is encoded in bits 2:0, i.e. doesn't need to be shifted. */
+#define VMX_EPTP_MT_MASK			0x7ull
+#define VMX_EPTP_MT_WB				X86_MEMTYPE_WB
+#define VMX_EPTP_MT_UC				X86_MEMTYPE_UC
+#define VMX_EPT_READABLE_MASK			0x1ull
+#define VMX_EPT_WRITABLE_MASK			0x2ull
+#define VMX_EPT_EXECUTABLE_MASK			0x4ull
+#define VMX_EPT_IPAT_BIT    			(1ull << 6)
+#define VMX_EPT_ACCESS_BIT			(1ull << 8)
+#define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
+#define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
+						 VMX_EPT_WRITABLE_MASK |       \
+						 VMX_EPT_EXECUTABLE_MASK)
+#define VMX_EPT_MT_MASK				(7ull << VMX_EPT_MT_EPTE_SHIFT)
+
+static inline u8 vmx_eptp_page_walk_level(u64 eptp)
+{
+	u64 encoded_level = eptp & VMX_EPTP_PWL_MASK;
+
+	if (encoded_level == VMX_EPTP_PWL_5)
+		return 5;
+
+	/* @eptp must be pre-validated by the caller. */
+	WARN_ON_ONCE(encoded_level != VMX_EPTP_PWL_4);
+	return 4;
+}
+
+/* The mask to use to trigger an EPT Misconfiguration in order to track MMIO */
+#define VMX_EPT_MISCONFIG_WX_VALUE		(VMX_EPT_WRITABLE_MASK |       \
+						 VMX_EPT_EXECUTABLE_MASK)
+
+#define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
+
+struct vmx_msr_entry {
+	u32 index;
+	u32 reserved;
+	u64 value;
+} __aligned(16);
+
+/*
+ * Exit Qualifications for entry failure during or after loading guest state
+ */
+enum vm_entry_failure_code {
+	ENTRY_FAIL_DEFAULT		= 0,
+	ENTRY_FAIL_PDPTE		= 2,
+	ENTRY_FAIL_NMI			= 3,
+	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
+};
+
+/*
+ * Exit Qualifications for EPT Violations
+ */
+#define EPT_VIOLATION_ACC_READ		BIT(0)
+#define EPT_VIOLATION_ACC_WRITE		BIT(1)
+#define EPT_VIOLATION_ACC_INSTR		BIT(2)
+#define EPT_VIOLATION_PROT_READ		BIT(3)
+#define EPT_VIOLATION_PROT_WRITE	BIT(4)
+#define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_EXEC_FOR_RING3_LIN BIT(6)
+#define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
+					 EPT_VIOLATION_PROT_WRITE | \
+					 EPT_VIOLATION_PROT_EXEC)
+#define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
+#define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
+
+#define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
+
+static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
+	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
+
+/*
+ * Exit Qualifications for NOTIFY VM EXIT
+ */
+#define NOTIFY_VM_CONTEXT_INVALID     BIT(0)
+
+/*
+ * VM-instruction error numbers
+ */
+enum vm_instruction_error_number {
+	VMXERR_VMCALL_IN_VMX_ROOT_OPERATION = 1,
+	VMXERR_VMCLEAR_INVALID_ADDRESS = 2,
+	VMXERR_VMCLEAR_VMXON_POINTER = 3,
+	VMXERR_VMLAUNCH_NONCLEAR_VMCS = 4,
+	VMXERR_VMRESUME_NONLAUNCHED_VMCS = 5,
+	VMXERR_VMRESUME_AFTER_VMXOFF = 6,
+	VMXERR_ENTRY_INVALID_CONTROL_FIELD = 7,
+	VMXERR_ENTRY_INVALID_HOST_STATE_FIELD = 8,
+	VMXERR_VMPTRLD_INVALID_ADDRESS = 9,
+	VMXERR_VMPTRLD_VMXON_POINTER = 10,
+	VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID = 11,
+	VMXERR_UNSUPPORTED_VMCS_COMPONENT = 12,
+	VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT = 13,
+	VMXERR_VMXON_IN_VMX_ROOT_OPERATION = 15,
+	VMXERR_ENTRY_INVALID_EXECUTIVE_VMCS_POINTER = 16,
+	VMXERR_ENTRY_NONLAUNCHED_EXECUTIVE_VMCS = 17,
+	VMXERR_ENTRY_EXECUTIVE_VMCS_POINTER_NOT_VMXON_POINTER = 18,
+	VMXERR_VMCALL_NONCLEAR_VMCS = 19,
+	VMXERR_VMCALL_INVALID_VM_EXIT_CONTROL_FIELDS = 20,
+	VMXERR_VMCALL_INCORRECT_MSEG_REVISION_ID = 22,
+	VMXERR_VMXOFF_UNDER_DUAL_MONITOR_TREATMENT_OF_SMIS_AND_SMM = 23,
+	VMXERR_VMCALL_INVALID_SMM_MONITOR_FEATURES = 24,
+	VMXERR_ENTRY_INVALID_VM_EXECUTION_CONTROL_FIELDS_IN_EXECUTIVE_VMCS = 25,
+	VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS = 26,
+	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
+};
+
+/*
+ * VM-instruction errors that can be encountered on VM-Enter, used to trace
+ * nested VM-Enter failures reported by hardware.  Errors unique to VM-Enter
+ * from a SMI Transfer Monitor are not included as things have gone seriously
+ * sideways if we get one of those...
+ */
+#define VMX_VMENTER_INSTRUCTION_ERRORS \
+	{ VMXERR_VMLAUNCH_NONCLEAR_VMCS,		"VMLAUNCH_NONCLEAR_VMCS" }, \
+	{ VMXERR_VMRESUME_NONLAUNCHED_VMCS,		"VMRESUME_NONLAUNCHED_VMCS" }, \
+	{ VMXERR_VMRESUME_AFTER_VMXOFF,			"VMRESUME_AFTER_VMXOFF" }, \
+	{ VMXERR_ENTRY_INVALID_CONTROL_FIELD,		"VMENTRY_INVALID_CONTROL_FIELD" }, \
+	{ VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,	"VMENTRY_INVALID_HOST_STATE_FIELD" }, \
+	{ VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS,	"VMENTRY_EVENTS_BLOCKED_BY_MOV_SS" }
+
+enum vmx_l1d_flush_state {
+	VMENTER_L1D_FLUSH_AUTO,
+	VMENTER_L1D_FLUSH_NEVER,
+	VMENTER_L1D_FLUSH_COND,
+	VMENTER_L1D_FLUSH_ALWAYS,
+	VMENTER_L1D_FLUSH_EPT_DISABLED,
+	VMENTER_L1D_FLUSH_NOT_REQUIRED,
+};
+
+extern enum vmx_l1d_flush_state l1tf_vmx_mitigation;
+
+struct vmx_ve_information {
+	u32 exit_reason;
+	u32 delivery;
+	u64 exit_qualification;
+	u64 guest_linear_address;
+	u64 guest_physical_address;
+	u16 eptp_index;
+};
+
+#endif
-- 
2.43.0


