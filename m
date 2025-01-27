Return-Path: <kvm+bounces-36700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC3FA1FFD2
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B63A93A4045
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF9A1D86FB;
	Mon, 27 Jan 2025 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ajYOtAIy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oZru6MoH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD41A76D4
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013510; cv=fail; b=rKn3y/ID9oCuUihStNz1gG8T8U9ufxYQ91G0uKfFrgNYL4kxE35+k0l85Z3sJmTq90LbQIJQDvcwv8A9AitXPVeog2RJ001BfXaqnN6nZ3OT8pSnpkz720UROrz0jnKc25VCInZib6F+Dw+Y0rdifTHPOnN7rHV9buvTbmDbOb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013510; c=relaxed/simple;
	bh=20Tc5UauRILAEb791eaLbNg/icLORwZCVsyQwEa3xe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BUFMqH/eKwuC/noFjTLyGe9AWs7oy6XiWbfwsvi7PtdbE375X+3TUUPRIxzyYKF3MWe1MG7gNwmmq9BSKBE/WddbISQx4V5jbZqbaBKAoAzRitfS2k61xtmMduGKlLhDZprddeEVi+ZnZYFW8NYGGs7jy6DmJWSV68qcZSbrYuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ajYOtAIy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oZru6MoH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL13Te025087;
	Mon, 27 Jan 2025 21:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5XDCXlkgBm/NGnAQC6dIDVKtaeoq+xZCnX0nulNyL/Y=; b=
	ajYOtAIynxuIhPT8m0EKquQS36D4ijOkH0JSeU+2fh8ieStkBCv6g6Zqw3rUtnLK
	4gOWJjTrI1i5dBicn3oVJHDOjwChiZm9tz1EM0U1K5WvV26xMdK+SYOaC0O+LTR6
	C1oRt/KYN9ESJzxU2AWrXaO9h7Te/21PftLIM4vyjkFqa0uChZlHUXfUZgt5+twj
	eVNy0CTXVtGWfgNiA891TMS1wvmRzqRhy6YPeWgEzVGM9UtYeWgb3+nSzivyufC9
	DlayR8skjBrevy7KyaLcJoGN/8qsGVHvVcuD7Cjcb65J3iY+W211ytsHHhsBsOVu
	H/FFBc5rWU889Gm/MheMnQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ehpc826f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RJta23005676;
	Mon, 27 Jan 2025 21:31:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7k1fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vch0KDJk/yfPjBqztHMDXROsvyg5qv9BmJiWVQfoKsb94uCovOO94jOqvmTmBWz9WV5BcCHU6Hm/WITOhqCrjGnCP0KK2jkQtxpsZQ40+gsZsn5F0R87877XyQ7mWpUR+i3GWq34s1jSdV15MR45fAtBVVBHbZCm1lq0CZsPxR7s3/o2jh5wxVtoZz4VhfiKwXeGv3MnSpnMJ/ZZZyIcHf3xZAbdo/NsNxgz51DkonyJsM7QgUs1QuT0TYe3aAYO+PQmXD281Igw/YlfJb5/ueJQ4T+3Iig+a9i5NzKzo68PLr+e9pbv1gcgJdPW9AUWkpLKM/OpejyxUXheirqjzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XDCXlkgBm/NGnAQC6dIDVKtaeoq+xZCnX0nulNyL/Y=;
 b=X6K5iil20GX0iVDE3eJpJhpOjrwr2fl3mTIMi02lifmDu+FWN3zSsdrVkjuFmVI55fcpsfcWVZvs/tVIyesXOzutFooK8wzOs+WkkJQMzgtCY6uMBScXgd836gETzyflKIb51dIXBJ/NKy+XW+X+NR1+zzB8RzYhNlIomH4EOvpGAnUbe8TLmsYaitkph4ZR/L9dSN95WWTunsyIlI2LYsVy5TQCmDvYk+geKhozotA4kaF6oNbHOyq5jriqPohzNnxYN9ZFzdI2lqcB7+dXkQt2iEZa1FHV6OLSPZz4r3egI5n4FAHYjiL6j7TmMFUjWwApPD1mB8fVNyzh0BtfCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XDCXlkgBm/NGnAQC6dIDVKtaeoq+xZCnX0nulNyL/Y=;
 b=oZru6MoHCQ0sPlloC77TAMHP5x/wQclCyVdECIBA1MU1mddEKAJuMYHgKnrtYzMUCWmqzBePPm8o+gp7sT/IFXFkG09fMo5I3Ka6BuerzEcl0YdnI3RIQP2nC0CI30Dz89lX7mKUDbpsdQ1Omi5XlEXp/Ehj1u2Wrnyd3YBd5kk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:32 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 4/6] numa: Introduce and use ram_block_notify_remap()
Date: Mon, 27 Jan 2025 21:31:05 +0000
Message-ID: <20250127213107.3454680-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0233.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: 06d26ade-78e0-4783-59a2-08dd3f19f81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pFCNRE0neXEdoHq9PelYNlbdIvIezXeNw7B/imHe3I0rI0inojkSJDHwS0sS?=
 =?us-ascii?Q?8zYqS3/4+VSIYVymaFNo8IEvT1kcPpJVye8pSmh9S+nNZjqTQv34SMszFtqt?=
 =?us-ascii?Q?3aP+Ml6sMiPQwaXf0mUD/1PVwyFGtleudYsa5QsA5EyK/TsL1A0Vq6p63rzy?=
 =?us-ascii?Q?Uu963Bs8CDiTPRvPMgN9GC4e97OB2+iDRYUMa/jPI6AFIpWp3ldoZV1P5/Nf?=
 =?us-ascii?Q?4FB0JvZ7P9QqloL8reEuNfFw8T7T3775Fa5tksEs8K+Zj2oR+k0qOCmjuQ2w?=
 =?us-ascii?Q?QdI3lN3dhzGG+tzdvFdK7rmtJa8TFFp1Isiz/S/xDDksNXp0wm5s5wJvO1ec?=
 =?us-ascii?Q?ZNqB+tudjil31SQlYCX1zW2Kf1bHHpi9L6Ejy6Wz5gAaeo8PnZOP1HqBM5re?=
 =?us-ascii?Q?JllDHwuc806cCGEk3B+jpTChV5eBcFvjVzTFW/AX9L6TbbN9IXd6Ng3FHmW0?=
 =?us-ascii?Q?LvLFEWsutAYwJJlXdfhUoViaZX+z7X6k9K6YI26FnD4/v8H0jOYMXtXuRL8U?=
 =?us-ascii?Q?88IrhkKKtBlU/xD7roqF15VcubZAO5Qv5xbenu/qdIxhL3eg+eoa6JJJlOsU?=
 =?us-ascii?Q?ocHBxRocM4Jzhe0JjEgm4hGH7IYL/iCASHSPDPagICK6/Ty+biRhEk6q8uD/?=
 =?us-ascii?Q?rmSqbMgLcycpX9JrhnnsQRwEa/TMMcRvUfw+tOT/g0YLttc/8tX+hT8VPk4L?=
 =?us-ascii?Q?w+ZPbJcZmTekHZtYiwpxGqZusZYSfpOtCU4MUxj3HKph+6bOBzFpdswMcTPj?=
 =?us-ascii?Q?TTx3rqCgdl5iXeOdbKLNMkHHyzEHXYUUFrrPZuHdhIIIuQif8hwrX2A7wz9f?=
 =?us-ascii?Q?oNpLl9RPYInNe9e+ZWdbY237oKvQ9mFE8I7xfpbmEWKXo23+urpzTFTlNUYi?=
 =?us-ascii?Q?nvvDlKlua7dAUGy00Lg3/a1kseKf3CquOK9yxwK6ebR4MJYzZFipBtXANKaH?=
 =?us-ascii?Q?QviqatHGpQVUvxVbO6SouQZGxPhRpCcpmisgtIEflgXlTVT4UYwexK+nzMJe?=
 =?us-ascii?Q?0pohU3LIragwS8JJZXTd7e6C4utxLidaDnLCFNP3Fd7nt6ztqI1nhJtgrkik?=
 =?us-ascii?Q?ldX+7MOO0GGEwTeWNOejs3QfiWEo68tvlAMMmCk136V/arSJ9q9+liC/SSIm?=
 =?us-ascii?Q?3lC/NMyzpZEcUfokAoPx2sWx99C7iuiL70VGe/4S2xfdNXGEGlmGYGgMOCJ7?=
 =?us-ascii?Q?Fgy0vTILiriKO1VrlVwo0w3N7uqV2JuQIuof4IyJW3Ce3C3EVPz377UnTANU?=
 =?us-ascii?Q?0TTv1AW6mCjQzRvSBDmt3oGRipuMMVxQL/o6RUBgwLHbr7qNxmZQ+THrzScG?=
 =?us-ascii?Q?/0L72u2Y6yt/8v8AE6PHtJkjRE04t+HsQmU0WKtgF976+f/lAdYC6haqrSdv?=
 =?us-ascii?Q?DjsPcPdLhk4n4cBIPRbRlV+dKfx7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cvcy1Gjtr3gYbIRGwssv0q5JhZ6V4QZDHxl6i1Q/0hl00SeMbJeYG144gqYG?=
 =?us-ascii?Q?MLntC/S7iVvnUAHjWQEG72sTmvd+WnMmAPHYyOPbqNP5CU1XANRoOVOkLfgc?=
 =?us-ascii?Q?PkGXVdu9Rc1LnkdeF2b+TPBnFZ2013MA4Hel5N1kdxX86447jS9tMB387jsw?=
 =?us-ascii?Q?zeA33qBxF6ne3HfXRhXlO6SZWGCrVAIHAKtfJEwhfnlzN9ZyqNcoZE3J63bt?=
 =?us-ascii?Q?hRUlZz8JeoMMKZexohJEdliw6EvfWeC1Nf386p3I48WTXSaKCs9pf/YwCr6B?=
 =?us-ascii?Q?OD1EJOt0H4obdrN20pY0X9QoXouN0Qja4Icf792F0xVkxlT1LEW8ere2ufXZ?=
 =?us-ascii?Q?EhmmdJYyAmiE/GLDx+y4gyOLkonMINhY712CW/2AL2AXMPp+svY1cjohzmoT?=
 =?us-ascii?Q?5SOk3Ge6fhUnKX+bcjWynf8KDSSPA1FMO6KqP6XZ4MDCVqV07stz309sfazL?=
 =?us-ascii?Q?lXahDG/GEdFA2NwRzIpVYtJ1wKexnAr7DIf/EnsvKU9deIxFmLy7XFOKzbhx?=
 =?us-ascii?Q?x9GIYx06Ce3NpqfUYJKWN90YaEfPXAn3nTnN/1i5jm5q+8DTZuoETcvlOSYA?=
 =?us-ascii?Q?QUtPt8m0EL43T/GGZl6kPo9USBDcYMRGj7Dc4I16bPV6xGP5lcFXkeKXHHxZ?=
 =?us-ascii?Q?k+STLKf7YsU9JQajIl0rqvRcDEX3N6wWJSjU5uGD8J6XPYO6Yw47HMaECAdu?=
 =?us-ascii?Q?He8FViFY+C/nxTinsgNCB24SPvSSfu2JYBpDq/ZCSy2kOGTEGfYM16WdQwrA?=
 =?us-ascii?Q?opv2gO3pyLxS/0GLmVldCwjdO1/6udhVAuzYMhauaa1YesTogf+mtcQettOX?=
 =?us-ascii?Q?CBewo4LK73lcPIc2XIA9Luky39M3Q/A/3MTHYcPkMAxaOnT256b+iJutB1zX?=
 =?us-ascii?Q?Fp5Afsxx+giNY3/NMw+Aq66FMQnv5S4TVN+dG1Qq30slTtqYukTLkevBe3TQ?=
 =?us-ascii?Q?ulGy6dAK2GH67W3u4iMSV3Ajy0rMSAk7VX+EyOO0pQW81dAmgI01FUabxK03?=
 =?us-ascii?Q?leng2S/mFue+8TfCqQ3JLdQVTkxdkuZ6g6y1a+3bQ5TKORrfTZfvHk5gR6lD?=
 =?us-ascii?Q?iFAADvtQKsNZRwErolKAzFFTIWjaJOJN1tan96di/VPDj+WqYGG30Pxl8uyS?=
 =?us-ascii?Q?UPj4RcUkzLhAkbbQ/iNpgfGnfddo7hvvusHRH/RiLrUUThHocYY7ejQerQSe?=
 =?us-ascii?Q?VwtCgpi4qyb31xmaTGAFOQmfY8UVRjzTL1fnBOJacMQg8zpL2BX/n63vrWwk?=
 =?us-ascii?Q?/j8aKVRCw6io2zgKmGKPk9gXmCsvRrn2ZzlIiMij51Vt2l53KdNReOd3DNMF?=
 =?us-ascii?Q?Hi94/GsLZ35jhXJyjbTe69JYzHBAddDZbqWLB1TaXHtHwE3i4n7IMNlN085O?=
 =?us-ascii?Q?KSaYQMemYr3TsWGmMIdJQ4bNlEuCRXdsX+iWvq6EtjcmbFVpvrIv96dXu1KC?=
 =?us-ascii?Q?nErWcGaNkVl6AUufOlGGj74jr1xiaAFYhvSPu4y71THjBy2xiHzU3FSp6noe?=
 =?us-ascii?Q?jL1wdmMsBl69TJCKo5Zf+MQru2iP+yIo+KkU0w3b0SSZ7Xfl4LNbrAgCwdFL?=
 =?us-ascii?Q?E+ixbgzE6Y01B63A7UH1FEjcfMsljThnbfree9QVl4AhX6z9agRC6WN83QtE?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bUsNrRjExdD58hjXUjLAYW+zOXhmn/3aSVDRr/I9UEgfvS1HNqSMuWEygTdGyIpTe+Jdxe7SzoHqCjFN0qOka+tBH3tAOTgfyA5fjNh43yVBEFkq5ZMuV5i3ALMhnfYFhhnAwXHrcRuMoClMQ3lSyvtajxVDknQsHHSvskpzD+nMvQG+0OEyCaidSvHYKSqE27JILqv7Llaai6kr6tdcdHsrOB0dZJ/TlKRYFkRGP3iTikPy9OePYt6CKgeksLyNAc/ISdT0MPTdwKzb8cz53rpn6wQ1gcFqLUnh39NZIZ4sTLJI4jPqcnh40zJI1tLO37z9PVm/ZZx9HpwzfYH5OaJ3cIJpp+qhCKt/QS0Fn6Sztr5gHnHMeDO+2NjZUuuVp62bL+4+KlcPoVbChWiLdb1gTBA0u9RcUmg5SgKElvEUgVNa8p3ZuW9+gzLDnK+tssN2UVO2vLru0SDvhz29LzgGkb1UiWQEU/9eb2HnHFjwGM0wVYd1eFIkjG1WKdjisSyAWCWsh0WCzg2eINph7Z3Wu/zlqv0WnLfxERpXqHjWBp0LF3RXZ4dlKM10O9+VKC3T/8kJ84uO7B73reoWZkzbfljrdKZXJDxcYIkAE+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d26ade-78e0-4783-59a2-08dd3f19f81d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:32.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4hTh4X9I4XX99SMRU6WyLwfuE9e5ifsIQTLmS14JV3wrk+Rqtq/5QKEMwM/qvaAkK7pG9QTftA1c0mW7t4/4PDZ080SvVTrw/921UonTU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270169
X-Proofpoint-GUID: NGYsoCr31AVAhYDZ41BzQYfZGARFYya-
X-Proofpoint-ORIG-GUID: NGYsoCr31AVAhYDZ41BzQYfZGARFYya-

From: David Hildenbrand <david@redhat.com>

Notify registered listeners about the remap at the end of
qemu_ram_remap() so e.g., a memory backend can re-apply its
settings correctly.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 hw/core/numa.c         | 11 +++++++++++
 include/exec/ramlist.h |  3 +++
 system/physmem.c       |  1 +
 3 files changed, 15 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 218576f745..003bcd8a66 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -895,3 +895,14 @@ void ram_block_notify_resize(void *host, size_t old_size, size_t new_size)
         }
     }
 }
+
+void ram_block_notify_remap(void *host, size_t offset, size_t size)
+{
+    RAMBlockNotifier *notifier;
+
+    QLIST_FOREACH(notifier, &ram_list.ramblock_notifiers, next) {
+        if (notifier->ram_block_remapped) {
+            notifier->ram_block_remapped(notifier, host, offset, size);
+        }
+    }
+}
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index d9cfe530be..c1dc785a57 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -72,6 +72,8 @@ struct RAMBlockNotifier {
                               size_t max_size);
     void (*ram_block_resized)(RAMBlockNotifier *n, void *host, size_t old_size,
                               size_t new_size);
+    void (*ram_block_remapped)(RAMBlockNotifier *n, void *host, size_t offset,
+                               size_t size);
     QLIST_ENTRY(RAMBlockNotifier) next;
 };
 
@@ -80,6 +82,7 @@ void ram_block_notifier_remove(RAMBlockNotifier *n);
 void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
+void ram_block_notify_remap(void *host, size_t offset, size_t size);
 
 GString *ram_block_format(void);
 
diff --git a/system/physmem.c b/system/physmem.c
index c835fef26b..146a78cce7 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2254,6 +2254,7 @@ void qemu_ram_remap(ram_addr_t addr)
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
+                ram_block_notify_remap(block->host, offset, page_size);
             }
 
             break;
-- 
2.43.5


