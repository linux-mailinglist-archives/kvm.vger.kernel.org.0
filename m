Return-Path: <kvm+bounces-11651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F7F879150
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 10:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A5DFB22DE6
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FD27A71F;
	Tue, 12 Mar 2024 09:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1MP4b0Fy";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1MP4b0Fy"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2068.outbound.protection.outlook.com [40.107.6.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF83D30B;
	Tue, 12 Mar 2024 09:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710236783; cv=fail; b=mquwnaVVrhtte6q//SxfWyEUBuX9Ba2XtzeM2SkzUk/SMRTywo3pYS1vjvX6Hf/QiC4RB/ppOMVJ6WwRo/dV08U98UHtWwJ9mCIV8LoyitszrC7DjC20rXRekyVMZn/vN0IkwbyiaBTp1cPWr89NVFLz+3LdkloCx2C+t+oo99E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710236783; c=relaxed/simple;
	bh=ROaYGzG7qXODKOC9T78z2j8KHmiFuS43MVLknuXbwdw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AbgHq/rUOr0z45DnYdIJinma3yGCIqDQQHXb3AvzDFYw+vTVPN+dE+X9HX2hnQGwDxJcT5cKZRxje1ijxEqUs15kfZt6f92DmODjXlnzQXw9rU1/bYaH1ceLPASKnuW7jIP6ipPJ3f/mdSx2hLmX4jOyGoYlf0mU+ZE1qeo05Tg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=1MP4b0Fy; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=1MP4b0Fy; arc=fail smtp.client-ip=40.107.6.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=iLNE50rZJx2pqxXLnuIebsqoIWtSeV5hKYFduI+87x7WUtusvpjNrY4nUL34wmbL3RvNT5xVV5utEYhqdf4losfuVoGOWb5/plFzUXy6XjKxwTwe2aaQaWEzBSrMFAruvHsxdNNjf+o8AP4hkn2VYUrs6luioJ2LBO1jmZmO/kd6Yic46HYYLebO6WB9b01/1gMJmp74tiLTtx6Wdoh7025d1zPGjxbaGNCijC94+emFWYMC7v3Fb8f7sWJ7SySql2xKn1pToIkKbzm90+zR23HcTbxnZCPlw8FAOQHCzSGOakOExjbQ7ES54+k33cslA2FNRMAMccLpm19mP/572A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOZOEMBbfhIll16JVp4hL3E155Tn8lUB9nsRtiiagdU=;
 b=JkToz2ITKmLmklHv2Pzcbhu+ffCupLu2PRBPhzSWOeNTrNxRaLHgRyWNEyvKZ3FsSx7MzaMluKHCH8peuA4y8oLDFpBJQCHVfaZEnz535N1yW8ZDlfFmaTM9Mugh1CWs5iI6VpfVv9k6XDeKFtZJcl6k95SJymeYKmMBfHxBW0cmRHk6VkOe/V0nQSs7AX2tWEhnTtbGGlXX2cD9MpIABUk7PPblquLTqdCDB6hnnsZ15kxDSz8etkYg6gaf8QbjbVKNN/R26/FNIF7Un9VOXvGcMa0fnS3NrbsYLy8Yexl7yjQf/cvGgod6A5XMHI5Wj2qJHdH/Q9/XT99A/FdkDw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOZOEMBbfhIll16JVp4hL3E155Tn8lUB9nsRtiiagdU=;
 b=1MP4b0Fyuf6F5XZWMn64qEgzmuCNg/0GFHoFQmlvQensEVo3ZXe0Iu9nDOERfwPNKRcVcSzJN0bCW3Po6A1rdKTI49evF4L12L6BLL3lGErwhpWUAB12TrcPM0u/iHJbgt9c4Y2eQP+K7oA7bP2O/I5tALuL6tbLVkkbbAVhfZk=
Received: from AS4P250CA0029.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::19)
 by PAWPR08MB9471.eurprd08.prod.outlook.com (2603:10a6:102:2e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 09:46:14 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::34) by AS4P250CA0029.outlook.office365.com
 (2603:10a6:20b:5e3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36 via Frontend
 Transport; Tue, 12 Mar 2024 09:46:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Tue, 12 Mar 2024 09:46:13 +0000
Received: ("Tessian outbound 598157ceef91:v276"); Tue, 12 Mar 2024 09:46:13 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 14f10f8ef0686210
X-CR-MTA-TID: 64aa7808
Received: from 17a47b054d21.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id F30F8C0D-CEB0-4DF5-812F-A58AC3CBD00C.1;
	Tue, 12 Mar 2024 09:46:06 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 17a47b054d21.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 12 Mar 2024 09:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9r8nhYR7VyJ9tVJIuYgn/iqfd0p2OFliNqWB9+GDPe7SRxZaSb3pTzzoD/2EGcjJf9Fq/ooMi7xicvzLweg2L3Clb37VwaNA5pqXH3BeEAVKYM0O9xtRm58RZr2sr2H7/gn5OCH0JjyEaYvS8i40YfNhfmIeER+SU7fzgvfas28ZjUtRFa2P/HAZjj9b/8Vp4wPkwa0aiG7OQ6De7M6Exp5oV9bvZYuUyDMO7u704ZbjP09ccuQIj1zYQabNguQbW0eE5nx2C977zbdwy4EydsKvPOVm98f6cJ0fpOYZ2q/g+xQpUOx0yBsy7J7hvX10QFgjXCqFKq6lJgApA8umQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOZOEMBbfhIll16JVp4hL3E155Tn8lUB9nsRtiiagdU=;
 b=Y3e3BZ3qu+8zsJbj1kQvIaRrT5u+Nnj5dUJzUa4Mwn1xvEMBjkfgiTGe0XuJyRkW6ca33KXcw5ZjJtnkTeoCT9OiMobsOdaHrGBKYQTd3ZLbXoxc1DiL3YsiWF5Kx2749G9hHT2yawcVxKnshXzHDynaTPmBRAr47RjcEm2Z8Uc4j4ZLWtnQmgQoUqE/kQL/OFj+2wVf7q8RuShiqYEMT57i3XEfmTFln8kNfENMQ2myORhuV129gW+4w6dIIIxF70Rs1RpHcu0h+D/W1tL80l4xiyNyw6wm6QR9Nka/sydlZQpc+IqYTlPKT/7nX1JPY17Rq7fKje7PBCuCrkg0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOZOEMBbfhIll16JVp4hL3E155Tn8lUB9nsRtiiagdU=;
 b=1MP4b0Fyuf6F5XZWMn64qEgzmuCNg/0GFHoFQmlvQensEVo3ZXe0Iu9nDOERfwPNKRcVcSzJN0bCW3Po6A1rdKTI49evF4L12L6BLL3lGErwhpWUAB12TrcPM0u/iHJbgt9c4Y2eQP+K7oA7bP2O/I5tALuL6tbLVkkbbAVhfZk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com (2603:10a6:803:c4::31)
 by DU2PR08MB10204.eurprd08.prod.outlook.com (2603:10a6:10:49b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 09:46:03 +0000
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::363f:3fc8:fc36:58ed]) by VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::363f:3fc8:fc36:58ed%5]) with mapi id 15.20.7362.031; Tue, 12 Mar 2024
 09:46:03 +0000
Message-ID: <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
Date: Tue, 12 Mar 2024 09:45:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
To: "Michael S. Tsirkin" <mst@redhat.com>,
 Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, nd <nd@arm.com>
References: <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Luis Machado <luis.machado@arm.com>
In-Reply-To: <20240311130446-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::15) To VI1PR08MB3919.eurprd08.prod.outlook.com
 (2603:10a6:803:c4::31)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3919:EE_|DU2PR08MB10204:EE_|AM4PEPF00027A68:EE_|PAWPR08MB9471:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ccb1211-5ea4-4122-5db0-08dc42794142
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 F+mmDfTvH9FvVrcvJV3jWt6Zm67T4AFdXlDoWfjI7X3rZuJE3F/DjaXonnxzGrIM4NdFhQ7HCf535rZBO224nRtiK/V0DBaWVpeCAaf1OBWi7C487cq7NoUaEz3cIuVbQ1WJ3W7phETwZz6CdEq4LIxFGIT+mPgIENceKmxGy2cvJC44D4E+UoTWW4nOGtYsEWz850k/V4tKPT2nwW8FDJbM1srtzJnh5kAVePglJGob1xU3DkKZnk2Bmzvrt+fDL8A9BNILR1Png1J7v1uSGwvsLaMrvUeSIvECBuEqnErzkeiEujxd3nGMFx+6PnChfw/B795lmtMnG5xnQjq6E8pYmNT5J2ywxRwp591JZj/r6aT+YZtZw2XZpNUoorOyZOve5JIkfyeJEVJz8RQvDnqOQiURrzUWf6h4IOB/d6CdXKNsBOYOs3s73EaQ49ddsTggTZyDxfeYjv3qYyVK+FeLMIyC3gy/W7znzY+kLUOqLSbLrQhifypicItvYAzYTbI4/Xb1gWF2qDOZWTeC4k1M7P4SbmLGjkTI/jCOSvT+uInbLqlVNeyJDydwryaR1NoFxwSGwzrrGyFL28e3N7Yao7rnP31pc2ayXhamS4feT0ZjXv7khOZzEQ374J55
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3919.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10204
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a7e6c97-7969-42c6-1517-08dc42793b26
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yqlid8dSjJg4WpqPj7iqbMe39HPh4O0pyiPMr7KjDblPRLzGnulfvTsaS0S4SMjOGaWPQ5ZbhBQGOFoahen5iCtXcrv7mqEIh4zBZuDTZlOZZxBLaQRQhjBnCmLBBlpNEf2X2wTlIcbG3a113/F5ab4dLB0gu29CyNCIfaC6IrVnOlxTe2sopTa+GkMppjJx9+simg0oVABqA8JCJvS7/T64XDRsxm+7fQ38sgMx+cvWBAeypzLL9Nuk9SUQxWYkZRoeGftSiLm1puCOHmguDiPDKKkjfq4x09DwBqvkCz+SeMERCgfXS0RfQrUkE8qy4K0OBV/Dn9aMyY2K/5Fxb7Rud1EDqUboqoDOVBPxwgk7GD523UdNBpAY4HO9TEX6/SGUYCXgP7nIRZIf/44Nl3kSCLaVmi62ajDVi6FCsN/e4peJ7c1J/cYU89zh0qtL9aSLamSo6ofwsOMZTauHjsSUrFVqFk8VBgvK+HJoe3ssbACrLE02DS/NicoODSErbkz9nd6P9cKk3LEWCF8DI/oRSOhBqeHROJJM3AhgwEEq70tjXrS+rm8e5h0U/gkIskH+7dtzjLgDhYLH0bXorpYe07LEfEU5dZkuYURujU+SLmWCaoA+H3/ypGTZx4nl0qyXkVWC+fmCdbhXz3pWheSGge+PV0qAhxPrfbGBEeWVatSOc6yUnA45WnicjfpuUvISsWcNov9j89tTZkts4g==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 09:46:13.2174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccb1211-5ea4-4122-5db0-08dc42794142
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9471

On 3/11/24 17:05, Michael S. Tsirkin wrote:
> On Thu, Feb 01, 2024 at 12:47:39PM +0100, Tobias Huschle wrote:
>> On Thu, Feb 01, 2024 at 03:08:07AM -0500, Michael S. Tsirkin wrote:
>>> On Thu, Feb 01, 2024 at 08:38:43AM +0100, Tobias Huschle wrote:
>>>> On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
>>>>> On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
>>>>>> On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
>>>>
>>>> -------- Summary --------
>>>>
>>>> In my (non-vhost experience) opinion the way to go would be either
>>>> replacing the cond_resched with a hard schedule or setting the
>>>> need_resched flag within vhost if the a data transfer was successfully
>>>> initiated. It will be necessary to check if this causes problems with
>>>> other workloads/benchmarks.
>>>
>>> Yes but conceptually I am still in the dark on whether the fact that
>>> periodically invoking cond_resched is no longer sufficient to be nice to
>>> others is a bug, or intentional.  So you feel it is intentional?
>>
>> I would assume that cond_resched is still a valid concept.
>> But, in this particular scenario we have the following problem:
>>
>> So far (with CFS) we had:
>> 1. vhost initiates data transfer
>> 2. kworker is woken up
>> 3. CFS gives priority to woken up task and schedules it
>> 4. kworker runs
>>
>> Now (with EEVDF) we have:
>> 0. In some cases, kworker has accumulated negative lag 
>> 1. vhost initiates data transfer
>> 2. kworker is woken up
>> -3a. EEVDF does not schedule kworker if it has negative lag
>> -4a. vhost continues running, kworker on same CPU starves
>> --
>> -3b. EEVDF schedules kworker if it has positive or no lag
>> -4b. kworker runs
>>
>> In the 3a/4a case, the kworker is given no chance to set the
>> necessary flag. The flag can only be set by another CPU now.
>> The schedule of the kworker was not caused by cond_resched, but
>> rather by the wakeup path of the scheduler.
>>
>> cond_resched works successfully once the load balancer (I suppose) 
>> decides to migrate the vhost off to another CPU. In that case, the
>> load balancer on another CPU sets that flag and we are good.
>> That then eventually allows the scheduler to pick kworker, but very
>> late.
> 
> Are we going anywhere with this btw?
> 
>

I think Tobias had a couple other threads related to this, with other potential fixes:

https://lore.kernel.org/lkml/20240228161018.14253-1-huschle@linux.ibm.com/

https://lore.kernel.org/lkml/20240228161023.14310-1-huschle@linux.ibm.com/


