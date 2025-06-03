Return-Path: <kvm+bounces-48251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4281ACBF70
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A52BE7A7E37
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4821F3BA4;
	Tue,  3 Jun 2025 05:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QgktPxZi";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A0YsEbz8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB168821
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 05:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748927173; cv=fail; b=kuYXsQanRKiWfMQRIq5QAejX4mUo+/cRtJ3OcWDTDcZ5+NsaPTa9LbDcBe2NBrYPyhA33z3hXjY3Ba2gcLY4ziBSYQcdwB8fzGOEerdWCbteTBwqxzF51VbqXqr9dCs9q9i85jWqii+U+4xTQyZujhn3GroYAjq5cleXZsh0U3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748927173; c=relaxed/simple;
	bh=8W/hWJ6hdKrgF4WJ+9DcjzPvwCS6WmU/kjWAgiEDa+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jWK1knYViM+rEGO90lRw72F742oV3XaAJiDH4KbrAufmoIrjgGKdwaeXAF5R5YqBa0KTwdGv5Dr9rdsaIFGo8AbV4iMszUor0mvp36j8BDLENt1JJfOLE38/mwnoT6fMP3+JAl2RpGRw2J8e8VlxIygf2yZUAk95fGkX30f18+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QgktPxZi; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A0YsEbz8; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HI3i9027702
	for <kvm@vger.kernel.org>; Mon, 2 Jun 2025 21:48:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NMRe8+rNXWMa5roDY6vNpnqWNHeRdKb5QLWM+yivd
	5Q=; b=QgktPxZiznRB7Rb+dD/JujzIgLpWUDerIe7HcF+h13TKBsjL+ltp7LNuE
	0nVLedxtt1Hcq8Wzdb/BiTrnGCkvgGk5I53paqwVSd2vzeKbXkW8JVLiL2B9RhYI
	ayARlCScayUP0UtoL4zDaWWcGccyCGceiDlzjwv4fa6MbRHRd9yK2T+SuIW/OoCE
	eSPfU8sA0kg35m6bBr8yAIFhit8GBsIw2s9F6Z7kefYCYkUf5D9N5oa69zLCb2IZ
	qzBRbNLM6ZIH745AdkmuCxbdXzXYFbcDU+VDq9JuOW0mS1Ntd3dQMpg6V2EHvE6O
	ZhHadmSYmX37KPYtzYtiVv9t8pysQ==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2096.outbound.protection.outlook.com [40.107.95.96])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 471g80s7rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 21:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUNvjhbawlxz6c6wbS8jPVLFHhyrIFYNttwXbOtRH8nL7KR++Fn2vRMRsk3BJemXNdv1ZlMcKHrE+z0dWIpNVlFlCr3MNBp3I6KER9E2TMbi+3aWKUk38ngJO78LQLHCxvh4tGZZAmW7WMoTZrMlFb2zQpsnRyddCJ/9vTPvHhYDWUZQFr8/u9r3u76m+wHXSSr7gQvXBRaI++mCmXJiH+kUcAWwhKNJfqXmDcLtcbDoCiCvnel1VQuNTDY6JvSCCxbWuOKRXwGnTDcdE/qv65C82ZaI21k1Oe0CVZ80YlvwGeRfwQHthcE8vVxYjHHQG7XW3wKZlZyvk0vqizgiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMRe8+rNXWMa5roDY6vNpnqWNHeRdKb5QLWM+yivd5Q=;
 b=mgWeNSu6xdpkMoXkQRlVJZmao4XhtpfQtsJFkhc0DTskEotPHsZ3eARFCWAPr62MTK63j1rY/+U7PhXtETSEYCXpKQAvMKoON91xBKUNzfOWlFo4zv/v4ZE0tbj+BkPvxzLh4Tqfui0ytGIys3RyqDVzowlg/IxxumtTikaWwBkuUL9XDTe6Tthi75JNJLyFWbbk66y7Q1piHQ0nqN1cc3zL5g5jVyAKNmkmJeWaOzX5nUllk+xL9mMaNSrESS5BxvWXQ9jSWTuJC8w7UYbDZg+/6te/VxNLq0mnJmhDjmsxWEgFHn6nP3fYoeTxtUuKR94HHUMe3ZkTLiCiX4Yi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMRe8+rNXWMa5roDY6vNpnqWNHeRdKb5QLWM+yivd5Q=;
 b=A0YsEbz8xiUuLyBoMdqecYlbemLRayt3iqkXfCOSHxT/phkxer3IcDTMeeSFb0e/hv+Xvf0RHeGPLh0GEQmitzPWnaeVmVKmAwZ2Hbd3Zi08yAGro88ERVrCuCjvlneAwsspZHIvn9YRVZjlBqlDqG3LVRbHgZGwIxpqW0SClyAbq3T+FCzGP/xgyn7BlukA0JNxP+FsVXJwHtjB8w9Wx9PVIlfY7bI1gS3ctGln7YZY3+8PSwfZKgclZnQoEkj+AWztBqSnhjoYuPkTDlsAynHsCFSqjYkNNVrs+Z6wn5LmZjhLWBX6wJOMQl4Qpq5GEh+V2afDd3UT3hYY+oEQEQ==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by DM6PR02MB6604.namprd02.prod.outlook.com (2603:10b6:5:21b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Tue, 3 Jun
 2025 04:48:13 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78%5]) with mapi id 15.20.8813.016; Tue, 3 Jun 2025
 04:48:12 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: kvm@vger.kernel.org
Cc: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: nSVM: Use PFERR_* macro for NPT tests
Date: Tue,  3 Jun 2025 04:47:45 +0000
Message-ID: <20250603044745.1387718-2-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250603044745.1387718-1-eiichi.tsukata@nutanix.com>
References: <20250603044745.1387718-1-eiichi.tsukata@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:510:325::22) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR02MB8041:EE_|DM6PR02MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: fad7a2e7-6a3e-40f7-e474-08dda259d83f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XxvrH5CEv0LVLiU5upT6dw/laPCRZKVqFTqGwFyjbloGNX4nZ/N2NUW0t5SW?=
 =?us-ascii?Q?iYcbDdACg/fBTJT+0A1MmXjvsEfa8bksx7L8vy9vcUyNSnjJsslJ3dLOfpwu?=
 =?us-ascii?Q?7xm3aGwvSkFcIJCBbVIB1snaKPHJBYAU6grZM4ccVsz3pRvYDmgqdT7qc2LW?=
 =?us-ascii?Q?3NE7pcJWqOXXVOIt+tfmLTnloNliI0o0CFzZjE1TdBdu6EEBE55DOfrjfUgr?=
 =?us-ascii?Q?JjVhiFa4QXpHsI3HWKbiVkXXDF5SLQ9WquA+eBq2z5LJEOh7hgjlFH7qxZKe?=
 =?us-ascii?Q?GbWJxAnjpihdV1nrdWIfNPFYrpwWnN3HUwxZRsO5Vczg0FnDXO7IPDeQQVc3?=
 =?us-ascii?Q?y1BH3EK5GgSy/95uAiwb+tkf+gU6NwmPiZP5pluOl7pMvl6jQFo143b0FzEu?=
 =?us-ascii?Q?3nZ38F91Gr50lynvLETyJRckPwY1b3af9hpjLO76rKroOAmzTDrHPC8QjMdt?=
 =?us-ascii?Q?IQ+e8+Uup0Mb9GxwOorlIilNwDcDaQRALRIppH0tw5dwClJlzMLp0j6k6YJ6?=
 =?us-ascii?Q?D7uB47C3vLogxvnOteHhdlubj2TlAOA9ApqzSuY2AGwJAYWcIlXp078UavDe?=
 =?us-ascii?Q?ktidPMQR79rP7BsN4eZSIjeM9x+5fQ7eXOBISybBgjj7w5a2Gfu6lzuY3hnZ?=
 =?us-ascii?Q?QxQU3Nh1y/JQ0m1SZOXAHe5x3nI0AASGPDJbHhB7SlK3J/2VJ+VadXARMHty?=
 =?us-ascii?Q?z1IS0Gw+grlyJl2PXu24aBI2cqBwZfp6u6epYe1lH7daOA+3aN6wFWOIl1MN?=
 =?us-ascii?Q?pIqR8MbnSGeDmRsb1LczWAT6zl9bA/BKlqcdz30dqOry1knMDBAZz284CQXh?=
 =?us-ascii?Q?E34MQPPol2K1ZuinqMORuuj48rNRXbYmfPFwI/tcq9aRx9ugXW/DYQlYfzWD?=
 =?us-ascii?Q?bPFBfy+OTvTGW5HDw+LP9/obAG+Vi24/zF/mBq4Wx5lU5SSbogA9sZVRQkKB?=
 =?us-ascii?Q?lzxEv6kfoRivEh+jmPYHS/aBvoY/1utkOQ6BSm0UBOdvFdhpo/FdkfkWeTWo?=
 =?us-ascii?Q?2+Ojzno/vY5j1JhQLn0vz3BnEj2m7TrxQUE9O5EZERRKIj4KLJrsV3gnA6LW?=
 =?us-ascii?Q?Gh7sX0U2qjY6tEyg13VNjWv6qFUN00HbLuZQ2oKwZljpGHpX/OPs3zEfPPrF?=
 =?us-ascii?Q?neltg5hY95hpxwJxD/ZMY30rBPPGQE2ehClKPAkaEvctxjAa1InT13pB3Z+V?=
 =?us-ascii?Q?rxFJZxUqhNNCkP+EB3bes4LamFayOa27zUUY0PddqO8uJJVqmxoTWyDdLvJ5?=
 =?us-ascii?Q?enhbf8KzBoDNOiIdnvATPz2hm5IAjF73RgH7Cn6r/8TUDaBcDtihKEBwSSd6?=
 =?us-ascii?Q?2MV2K/DBX2a5vXuXizlIBP/N7tifGJAvOlcP0DEfsXfCTwrfP+v9aSM7we0p?=
 =?us-ascii?Q?zIh1sG/FXJCToBP/3F6stX2OFbM5FKMXqz9+ZxmQ2wZtjZPrdWrIIF0EFoZ+?=
 =?us-ascii?Q?2BUzQOcBX1Lf53HCa395izCZyrk9v82glQtp7Md2vG/NWnKg8NrNiknpzea3?=
 =?us-ascii?Q?JGREwns7mixVGlU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nmjhE2/lATOvWhUq/9cg5wzC06aE04LA8DUR90iDj6h2CjMDuC24aUGIMIPc?=
 =?us-ascii?Q?Zh/tpZmaGmIllKw5RAxavvQyz06cxEiX87jZfEoNXhkj5AJ+Ny3Ni0mA9kui?=
 =?us-ascii?Q?CS7HhWmy1/AfiR08MyqjWd2uXEDd3JTiK33Os/sz6ZKqotosCiTxkyOi7GmU?=
 =?us-ascii?Q?WkizHw0tgwS1DmLoixD/wjPlQTItsMZUUTkjVX3bEezwmIFFEl4iXbBPbo7b?=
 =?us-ascii?Q?sy2pNpHzyR3xiGr2rLpqth1vBL/5kx7KTSVCPV0rQWTcOPovX3BxbrWiUh0W?=
 =?us-ascii?Q?8SKAC34/QiUhKBBnsjEMtG10XhSDcN2bWdGZW23nl7e6Wgqggq3OxcnkCsnK?=
 =?us-ascii?Q?4N9axfldoR0aTEff9k0D8fPkQ7qhH5se6NcUtK15k1tgA7ecRhg6w3iJNWAO?=
 =?us-ascii?Q?Uc2x+26fgFWLtoTp0NJ4D7MR6Kt6F4sz7DZbuT+w3xTurK2+Hsszso2G7Jlw?=
 =?us-ascii?Q?Oq5CNnO+n/MdDNVNmnQ4BMygQRVWb4QT9f6AjvC2MKwYM+OE+vA4EhJeXBcX?=
 =?us-ascii?Q?tG95lnaZrrtIRkjUNltq22pVngekk/DzLI14T/sFgn8AkVsOi5+xrR4R3Q8z?=
 =?us-ascii?Q?nlLO9+oAD91Jftj205Jr7eHmh7NPwrK/M0VT6IX0oqu11efFMPtj3F5H4Vri?=
 =?us-ascii?Q?5lAS1If1S1RHGVUKk6EzR+IH/X29vQFoFJ5EMTGnf8DPA1+yqjQfPggLQCce?=
 =?us-ascii?Q?LYnd0ezwtmjEc3Sek/kVoAw1omwy3/+I/BHGv+2D8OeoTnnZ+4oQVsrbIPcf?=
 =?us-ascii?Q?mIROPqZ7M5YEqYqD44E6+jxcTZLx8elbcUqll6/mZG+lPAhCUDwhhIhmCVyt?=
 =?us-ascii?Q?e4ujon0dNy85MWFbpSqtaVnd7sfvJi5cGhgtU32mj9trH2BmfhGegEeqCztW?=
 =?us-ascii?Q?xR5auldpZHR7UuZgAJecj1wgLMj0wIyskyT97Ec4jptOfiLYdF2cMCjeD/v/?=
 =?us-ascii?Q?V6DCOLq1MTvcDsTfSpTD0+JhiKbgtcI/RSCg+r6CrEWCzOoflhNLtTpvD5TC?=
 =?us-ascii?Q?Zt22W2s15w2VsHh3t9N9aqO+zF79X4Pet7AtAomWVvVYnY1wbs5oLsapFeAs?=
 =?us-ascii?Q?QbvE5LtODRyQhDBbkCqLqC/hQhE4gBAP8a0qrCo7oFk/MRyhiwqiGFM0hBUl?=
 =?us-ascii?Q?gu4hYc6TlcayRzSh9lPfqI0EXy9WZCnx4D+igA2H/C9AJpUFgp0O64iyf38u?=
 =?us-ascii?Q?drp8df74rukQSH/3CpCUZZEvChPupxXgcWJGninLz1TV0aJ0oWJbuxiaeC1n?=
 =?us-ascii?Q?ANOE80UGeeKNiGienmEZDXk5BRenyux3hlRAoJf8ndT3IQPzxSqpfTyf4fLa?=
 =?us-ascii?Q?2yZZofYZbPrtNhJoa0X8tihMlJf+skiAzp4nj1xn/OqMGkMDiH6/jLrsqTbU?=
 =?us-ascii?Q?kkJDqbgCV7OeUHBWGdzOg4AhE03Wr+uTv5yLZWWzYpTiBxZgL138YOI60Ybm?=
 =?us-ascii?Q?Fh6AXol24yn3hEG/02CIkmNGC5iG56d+u8vnvSBp3/x9tDYb+aUnghS1Qn6e?=
 =?us-ascii?Q?pvhS4QKWrh/94U4VfM1jQWJYqdsOX+r9wZP9lWJsE8XwjMd9ZxIg9CwGZZyH?=
 =?us-ascii?Q?+az0xXRLZTEq4tmdr+aXiTflsAYDimTuh1glqAfx7IVpf+Ugd7s6XwB6oE7f?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad7a2e7-6a3e-40f7-e474-08dda259d83f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 04:48:12.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FmNLhcLbbsUpKRI/4IKPlnFRJrfDMcMApPWypfWMQTE+5n17XrcJRnoPzkd5EXoJ/hItDo1/AahJgDOyjiJLux0HzcdAQM590N5K/U0cVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6604
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDAzOSBTYWx0ZWRfX5iJNvpu2OwUL voifXTa8L2X3UI14FDU8IF1AjqIhNgjvi/+C5R0uY1z3ARWMN6DmOizspgxcHLK/gih1wq6p/jH 2AdLXRhBhXyNBIHJ8mR7Loa2E1XDuionXsSC/tTTRsDWs8e5RePH5hfH2N4CSxciT/PUCu4rDix
 IucJH0QADSVv2t/5k3oWQfeQoXiwii2TNytipGOB7NR4KvGAuVRylW9znt5qTkA0OFBPLbwVGWp fIvY72dKv2EiQKZA01zGxMvkhebsvgWH6CcGJVXNPsmx2ppSbsHZhBBYoD38Bn7/NSkd0ug2R9N GF2rbXnSvZJ1KvRLAXHybAHHOBdv5eNVT9HP5Fa91OAJu3f5w5cji/ngLQS9j452i9hNSwVQnUj
 9gGW3PtFmS3UZM35OglYKne5DKLtUL24cw3SKOczhs8Rr5vfI9NXO7h7GSLqz5+SmMPqiwjE
X-Authority-Analysis: v=2.4 cv=SY33duRu c=1 sm=1 tr=0 ts=683e7e8e cx=c_pps a=FT8VXlYT0qnbeNKhTmbtbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=PaXinXc69mJHykgCGuQA:9
X-Proofpoint-ORIG-GUID: l9ERfR0afVrEkNG-k9Q9xPq04r7xhP41
X-Proofpoint-GUID: l9ERfR0afVrEkNG-k9Q9xPq04r7xhP41
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

No functional change intended.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 lib/x86/vm.h  |  9 +++++++++
 x86/access.c  |  7 -------
 x86/svm_npt.c | 23 +++++++++++++++--------
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index cf39787a..49c0a557 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -7,6 +7,15 @@
 #include "asm/io.h"
 #include "asm/bitops.h"
 
+#define PFERR_PRESENT_MASK      BIT(0)
+#define PFERR_WRITE_MASK        BIT(1)
+#define PFERR_USER_MASK         BIT(2)
+#define PFERR_RESERVED_MASK     BIT(3)
+#define PFERR_FETCH_MASK        BIT(4)
+#define PFERR_PK_MASK           BIT(5)
+#define PFERR_GUEST_FINAL_MASK  BIT_ULL(32)
+#define PFERR_GUEST_PAGE_MASK   BIT_ULL(33)
+
 void setup_5level_page_table(void);
 
 struct pte_search {
diff --git a/x86/access.c b/x86/access.c
index f90a72d6..842be4d0 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -17,13 +17,6 @@ static int invalid_mask;
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
 
-#define PFERR_PRESENT_MASK (1U << 0)
-#define PFERR_WRITE_MASK (1U << 1)
-#define PFERR_USER_MASK (1U << 2)
-#define PFERR_RESERVED_MASK (1U << 3)
-#define PFERR_FETCH_MASK (1U << 4)
-#define PFERR_PK_MASK (1U << 5)
-
 #define MSR_EFER 0xc0000080
 #define EFER_NX_MASK            (1ull << 11)
 
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 09c33783..53494107 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -31,7 +31,7 @@ static bool npt_np_check(struct svm_test *test)
 	*pte |= PT_PRESENT_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
+	    && (vmcb->control.exit_info_1 == (PFERR_USER_MASK | PFERR_GUEST_FINAL_MASK));
 }
 
 static void npt_nx_prepare(struct svm_test *test)
@@ -58,7 +58,8 @@ static bool npt_nx_check(struct svm_test *test)
 	*pte &= ~PT64_NX_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000015ULL);
+	    && (vmcb->control.exit_info_1 ==
+		(PFERR_PRESENT_MASK | PFERR_USER_MASK | PFERR_FETCH_MASK | PFERR_GUEST_FINAL_MASK));
 }
 
 static void npt_us_prepare(struct svm_test *test)
@@ -83,7 +84,8 @@ static bool npt_us_check(struct svm_test *test)
 	*pte |= PT_USER_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
+	    && (vmcb->control.exit_info_1 ==
+		(PFERR_PRESENT_MASK | PFERR_USER_MASK | PFERR_GUEST_FINAL_MASK));
 }
 
 static void npt_rw_prepare(struct svm_test *test)
@@ -110,7 +112,8 @@ static bool npt_rw_check(struct svm_test *test)
 	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+	    && (vmcb->control.exit_info_1 ==
+		(PFERR_PRESENT_MASK | PFERR_WRITE_MASK | PFERR_USER_MASK | PFERR_GUEST_FINAL_MASK));
 }
 
 static void npt_rw_pfwalk_prepare(struct svm_test *test)
@@ -130,7 +133,8 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
+	    && (vmcb->control.exit_info_1 ==
+		(PFERR_PRESENT_MASK | PFERR_WRITE_MASK | PFERR_USER_MASK | PFERR_GUEST_PAGE_MASK))
 	    && (vmcb->control.exit_info_2 == read_cr3());
 }
 
@@ -181,7 +185,8 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+	    && (vmcb->control.exit_info_1 ==
+		(PFERR_PRESENT_MASK | PFERR_WRITE_MASK | PFERR_USER_MASK | PFERR_GUEST_FINAL_MASK));
 }
 
 static void basic_guest_main(struct svm_test *test)
@@ -214,10 +219,12 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
 		 * The guest's page tables will blow up on a bad PDPE/PML4E,
 		 * before starting the final walk of the guest page.
 		 */
-		pfec = 0x20000000full;
+		pfec = (PFERR_PRESENT_MASK | PFERR_WRITE_MASK | PFERR_USER_MASK |
+			PFERR_RESERVED_MASK | PFERR_GUEST_PAGE_MASK);
 	} else {
 		/* RSVD #NPF on final walk of guest page. */
-		pfec = 0x10000000dULL;
+		pfec = (PFERR_PRESENT_MASK | PFERR_USER_MASK |
+			PFERR_RESERVED_MASK | PFERR_GUEST_FINAL_MASK);
 
 		/* PFEC.FETCH=1 if NX=1 *or* SMEP=1. */
 		if ((cr4 & X86_CR4_SMEP) || (efer & EFER_NX))
-- 
2.49.0


