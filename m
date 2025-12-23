Return-Path: <kvm+bounces-66585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3412ECD8172
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57538302A128
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE872F3601;
	Tue, 23 Dec 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uEQQVPoz";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Fskwcgfw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F92206AC;
	Tue, 23 Dec 2025 05:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466300; cv=fail; b=oqL2x42jchUHdiVY8KSNSIbEZDrF1gpJH+RamXvbO1093R44wGPwNhPVXTCim4oiO4fA7aw0poce/UxLQrKBRpx8H6o9CWLCye7gmkTR+S2CJWenXk9CONGoSGzGPavOyhTTTWKgr0lvBbIWsuqVqtAhE3A97NMN3va/m93USRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466300; c=relaxed/simple;
	bh=Q8vq5vkSkgaRSbFlWGACd5g35vtGs7fg9zkdnOqJnEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z89cVANOjQCp8LykjSF4kA0l79qxU+597bEgcdggDe+ZcCBmzR8fK+mr5igDYi0EtRVStWbvOMjNnBIbBT7B9Z9qdD2Nkzj5wfVRDDePFZfoEXTTwsrrMS2UiddRcUMnlqbpn0UHwg5GJtrgzti6R7Pm36GZkJ639aHSCdAKfBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uEQQVPoz; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Fskwcgfw; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLwsLp3941971;
	Mon, 22 Dec 2025 21:04:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=n72t6s7hpOpQpKUkPTaZ66PVCqT50XYy9oTIviXjF
	dA=; b=uEQQVPoz2z9PH0fLbJQVJ7H4l2YO/jpCzroDSAYPtWqtqFeRLxo1FlZUM
	WyR8hgyhA1GhR3sgTiZKQhvGQWxe2DZUVkQZ/v7M5UpYHgLOPM0m2vFXV7W90tnu
	s3iuF4AQ5jjaZ5w3gtz2ngT6pRWXlW22d2LT2JemKZOto+9b1zQhvKCp+gcreDnc
	8bg68JCFusXXhLjuDf3PM8wSW10PiI8Ti4oScmespu4mGlM7MfbJrRf9pFn7zslA
	RV+0gm8g9iT2ymHnAgshjxP9ctrXUsFMvB2NxdcP5lnj5lcE/WVXaXzsCcPQXRQx
	mdWaeDa26EZKC+JH6NphN7wHJRbug==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020134.outbound.protection.outlook.com [52.101.61.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7ecgrr1n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQqIZl2dk1eRpOkbexLW+oVf9w55aVCefjaoaVJfRcA4fre2/YrJ7NC1etrMAwTNLHRYQ6Rx4hDmmqlwRdw+5qprTdr333BBilfuP+7cq8u4rm2W4lq+OsK4ZGjqMvopEJbBokBMi99LQMEdsxZRTXGNITr7QKqJwT14+XUrv72PRqtM55ZIu7tD9U3CJPNdBNiW3vJ2BEkYBOYn73570NPIyicECJrw8SSbFDeBi/fA9QuvQLek5at69YB6DojcSYAuNvBpDFJSHitVkNEIrNkSUEBLDsrYwgepsZ3+2DsuZoCu42PBK8zqitgRhHkpxaZ5uZH+kKUgMiHqxNsbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n72t6s7hpOpQpKUkPTaZ66PVCqT50XYy9oTIviXjFdA=;
 b=Zu/dGpjOzd2U+fr37MdGz4SZ0PenuOyCOYrL4r2NiIn4Er6Bffvm5H143W4tr3EOlCsdlZp9/K5LFI2SyE7h1Tjg/8YCXlnGCTsXxi4gkvycohZvIfYU8fSicULCx1dCm6yG36Jc7TJdc1Z4MjUtQuVBJfmy+az7nvxG+Rk9TSWLqywtY4Zlq0N2dGf7A3KQtiV+n/K38LjC+Fc6fpEHlDqppioKpRr4R1K4emeXxzMKQ/goVuDFVRjL/Fv4Inl28s/TPpU0YViNgWmsMxTAvqx4IcDDYeLvKH6eJ+SaZJSVu5bLJxXKZBsaPT+m1hElesyoTFerV87Vs6k9B/yxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n72t6s7hpOpQpKUkPTaZ66PVCqT50XYy9oTIviXjFdA=;
 b=FskwcgfwxW0s7SQoH9eliY/4hupqjKK80MkrTxrA6ugRpDHLpd6afIROG+B3ZheMVH+qODmPtJdGBkagKBCs2ETC8GmGmjK8IQYsoDaNVB5+XbYxIuoBI0JrIMLDf5EGN94E8OY36r+inRc/5TgbHoI1ih3+osOxkBgAfb9bu+HSQp8KJunPKX7lT3BLFDCKkySVp0CES7G5L0y4cQG+5AZ3nttzHCVemrxb1DZb77fifTpr4gWieGkrZLtr/5gdIxrXlLoaYH+GWbUB/Hwf4qC5iQymQ6Gpj52qB03Bs4KlAiBnoLZN0iYxcnNkjFC78WrngkSCUvkARRDejPOjBg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:29 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:28 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 4/8] KVM: x86/mmu: update access permissions from ACC_ALL to ACC_RWX
Date: Mon, 22 Dec 2025 22:47:57 -0700
Message-ID: <20251223054806.1611168-5-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: fd067395-5fa8-4851-aebd-08de41e0c051
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|7053199007|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?41RefKC1oxYO0QOJR0bdOC4+y2ICHN0DHJG5F8FI7bLUK7MIU3NgaoeaXLvG?=
 =?us-ascii?Q?iMTEp+c+iXgvtXYwtbqTp93dqQU7+voH/bkYInKdMFn6rV8tf7Bv5sk14nM2?=
 =?us-ascii?Q?Gkkz/TMjS93vsYmQJx5yg/5BtBqqWunA1i4YkOpOTcjCatHjVBuUN7vKHrhT?=
 =?us-ascii?Q?Qfid7zQsXEFLBPPVc9yuEdKks89RzzOfxnpOGAfrFhjN9SNX3ZlnPJuRPVow?=
 =?us-ascii?Q?tCxnqK325zfeuAFgtT7UFfxBnJQLXk+U14kfaleAWkCnuHHMr/mcaOfw0LHu?=
 =?us-ascii?Q?wYga9REVraYTI/aejbDjFKWD+YEt13I0aMuEZs2BrRRrLGkZGRPpmTv86lgy?=
 =?us-ascii?Q?JLH4U6031xMfzMUBUKzNL+P1z9jS5nkcgNLGcdk0r+jAKTaQm0/LaJ662fiY?=
 =?us-ascii?Q?skohl9KbBg5j1TnYaAk5PNlZJm/Z1EuukJrwkiwRSzfkVYDltZw9y8wvsP2a?=
 =?us-ascii?Q?j1L15+XRKV0O1R9KkDm05il09yywn12UzzhcQdO1jIaecCU7wNi1z73X0cyJ?=
 =?us-ascii?Q?gyhO6zkS/UAFJjGiD5qf7SifFgFiRxqmi9rulzGbeLjRCb+IME7vR6dm1pDV?=
 =?us-ascii?Q?X0o5CVIbkH0lEIXZcrqiqROirO5j0kmHHWnLj6DX2AR5Jlz2JLAHvFbd6ptW?=
 =?us-ascii?Q?nhbfSuyG7OwfhBb+nnqdvOxnsTBA3ltbr/z1WepiAzH1QT94MM6tievvevu8?=
 =?us-ascii?Q?4IruuQcH4M/DE1KXYxOx6uLWHZ5Km025PyFIfin+EM78UDu8J36t7zWAzOfB?=
 =?us-ascii?Q?FRMTmagMJWrRfAeLGniAMsSerBzfnyOiO9UzFYByQMSPmwAhP/154J1b2BA+?=
 =?us-ascii?Q?f4qC3IRriW3d65n0U1+ChJFLzUA+3tPnezDMVRL5WN05qDyRwpizb7mjcX+x?=
 =?us-ascii?Q?YRtYCKMBV57E4LcT7Y9IU07dv9WHWew52G16PHJ0i8ucPJbhAw94nOB+oKh1?=
 =?us-ascii?Q?TeMEMF5yUptNgvA1QrHo25EbfMiyrjhs41N00UBivV6XzRDJsdRXZVIvRsiu?=
 =?us-ascii?Q?T4SanMogLqepN/RQu2dbHio2m7NkvSKYf0jCuddqo8s7wnM3SRrSIlTB3RC4?=
 =?us-ascii?Q?nRO8lYrs2UmT2mU50PZLDpbnItDTatLr07ZzOPYafNHjTctax1I1S/qslp3c?=
 =?us-ascii?Q?3mTBpiTjPXzNXnB5s5z8KUHeZJOHeilJaT2+DLrnnDNGQH8uhDssi7SxBS7s?=
 =?us-ascii?Q?TNnkyUlTnwb4TGLwjdrxREmfz3gez8axPojlC8ykGX7OeEEiHzyOmeM9M82E?=
 =?us-ascii?Q?3ZNpWWtYWtK8yd6OWt5lVO/HdodNg5O8ilDULRBxWVso0eQkLq/aUl/zo6nw?=
 =?us-ascii?Q?6gBxtpcZRf2Bb1Xo4ZpOKSfXgAD1pnZJiXojFY1X4qS5yMjcvn4WgMANuhhQ?=
 =?us-ascii?Q?svbS1ZQ8Te8BpQ96zFJAVCkXJuMYjUinVufvZuowm0+L+tpVuyw4BM/NjaFP?=
 =?us-ascii?Q?vanaQ8W1cSWtojWwi5cjU5W349/WtT4ulVgq0HAnLXm824OSRi0q69Pwa+YJ?=
 =?us-ascii?Q?2z9TCx/Y9tTVLeYaw/7ag/90gIs+ZxDV9ELSTieHcHiGdU1BCOD70M97eg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(7053199007)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ImcAeHVdDWRLnRqbqwzHFSaKnyFU+phsXDIFaxxWCb46bUdFAlUAMOH/9Bn?=
 =?us-ascii?Q?piEbaiqfe1Djf2G/R9W0S6HIrf5Ex0bIOc4LK7zUe6n7wWeIhJSYxlZfEXPY?=
 =?us-ascii?Q?2TFAdq9j303BE8Trr/lsabCvV0EeRwoUIhSIwSqaHA8L1eqK9WVdc+JwB6ZQ?=
 =?us-ascii?Q?uF0OlwJb8Jmv3o6uNt0uiRXgB/ey09ssBIUm4ltNaagCJnA5ARJtmEryTL7k?=
 =?us-ascii?Q?jI89PRzAUeOYZxIGEQjePqQIEZ82gmTl/u7mWiG9yrZ9ScXT5WyzrGdDux6M?=
 =?us-ascii?Q?p6rGiEdhCBWlJKR7Vc9S2b6HfeXeofZuRHChwNX4FrDjenOZa9FavQf9xMiX?=
 =?us-ascii?Q?nkyrrONfFifI6/cNXX7URpiuXRhiLrUjbgLZZZp2MwOOC8yzuY5BT0NDSehN?=
 =?us-ascii?Q?iBWgEZn/+0aQg2xruve6x15ILK5Nz8HOkqRIDFmYGkYBcJ86Uwa+7kWJP4Fp?=
 =?us-ascii?Q?t8HA7r+pNBm8VGSNXdji9bxM7Uq0E57ok89ARbjaaXifKoR3mWvj0DG1Irpx?=
 =?us-ascii?Q?fHHqc+QJ5ISXnHGG9qv/HpdLclffXrwha1CAAD9u73v2/zGY21hEw+kAjXFJ?=
 =?us-ascii?Q?MuJqnJQIEfW18ONcpHXWr8VenTQkF3Nqrj4Z3FY5/4CdKtm+0nB5HTz1cl6a?=
 =?us-ascii?Q?LIWK/R0mqcJsjEDBFc2E40rUf+o4ZxCLkiL8upSpCyThRP7Gry3EmsaoZYnG?=
 =?us-ascii?Q?XDj8Unjz8uZo1ECxfKogXpNPVMO/N8XC8iQDT1Yb9XsdHF/r3NJrJthEpe+r?=
 =?us-ascii?Q?aIZX1Y3yYw51aMg4WdcpGqkOnp+zE4s4/H6CgE8RUL/jyRLcNcIGE4NO4jDJ?=
 =?us-ascii?Q?iG6aCcHb3GEMAsaz2sI4Ttw4YaweN2lPsB9jq2uoPwgV5n+3U8Cg3jz8CGPC?=
 =?us-ascii?Q?Ha1UtddupjiFthPoTxu0YDUC4RHs/slnq9ThJqC09tq6VlcWBG1JS57MFFer?=
 =?us-ascii?Q?j6EVgAGdKmQBZ3D5jaJrgbn0f/FtF/A8dHQH5hdUQnJoOonYX0AuEdu1ykHD?=
 =?us-ascii?Q?1YVwaUJ8jKcUswuKethSdMzmJBUvoJrAaufUSAIg23fVTE39XaiUAXDLG7p/?=
 =?us-ascii?Q?qtE/+P0xdGQ0wGbVNQxVCjPwUN0ZVFXsxuezFM5AFXcewFTO2ZR9vB8Z13Mw?=
 =?us-ascii?Q?T1r2pmmVnFNSexDRtSO8iDLgUvRLXQ8tQW4OSEBQBb21mg5JdHm6+PZ6LhCm?=
 =?us-ascii?Q?DJ84BUYkODXIK95CaHMgexdlVnZo75PyEIpXmmojQV3dJLOQPXeJsrSxY/LL?=
 =?us-ascii?Q?KFXQrE9A3ujH7f/czlc/u+r4+ebX8T98Ctjmjly74R0xsm45UvMwRwLMHTFM?=
 =?us-ascii?Q?T3GHS2gz2rmiAj8A93HyXWdI8btqg5v9k/brppBQCep/twRPB22dxox0ee/x?=
 =?us-ascii?Q?pbu2DVuX542BbrPfZ4vW4/VkC+6LjgxNm0NphI7vYFKQ+LQAF8SmJ57ne0BZ?=
 =?us-ascii?Q?MCseGZ+vWz85aXEzt7CmR4So5IpxjuzlTHuJqnOEqcBoElnX9I1NsCF724ED?=
 =?us-ascii?Q?J0Vyz38COQ7eFAnVc544nxsBr2oxmsu/VrqBrE0n22J8LZpPNRMOzoWBYrsj?=
 =?us-ascii?Q?t24N/vuufFZln3eTrppA1T+nqGHlOTFUQkwk3kEyMGOivXzJCswM52NR5Egi?=
 =?us-ascii?Q?yqFZpNfbCG7KBfAjOyQuc/DbLxXOIME5MCmNbm2e0+19+ZkoPkzlJWT9TmzI?=
 =?us-ascii?Q?DiE+SPrCCcLtmjm5u92hih02YoQ/6jibINEZC4mxPU5bPkqENrey8V9P43x9?=
 =?us-ascii?Q?exDxI8LXc2ahS2/nqQQRnXY+4k56tFc=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd067395-5fa8-4851-aebd-08de41e0c051
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:28.9376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VO+3u0aQu3Zsaj4HqIPFbMhUDSF/TuDE5inZYeLBXMn+gbU2kdhtsm2JEEhwegI1tI0W5lIinQOuASAUE/vZrFF4DMFiqKa6TNiyUjmd3+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX2vHDZxGntSwr
 O47800kctdO01bhGjSR83PTolMDq2depdytfPi5GnDofLjsvfk8gKqLkN91zy4IVnyOO1OnSDlL
 MCz69Mx9+//ALk+OX8gMqz/zplb7Z5XdytOdLVSfscP1sGOMOlyNx47zTcyn9/teri8rPIrEbVg
 tTPoKeRFV35Lh4yFveYRLDHDkKqaEg/k9zwzV7TST+3prW53xDXMPAjZnhFD786d3EnQHzIgytT
 VOcP4vv/4VGcaAAtZlVndXH2K9Y407laLkCJ91zN80QcB1qsJqYs8UB441fa7PqyfwEwFin0PpV
 AjVBIpe/mxXwk2fs0CxNm8LP8M/eruqNpy1+H4Ng3z2LqacNfZg8KQ3s7kBXFCwNvbChij6zK36
 U1v1WRyp1lcj7PBLSa36E1TnuL7C+16kPmFK2QN/WArD4sxpZaHUt2oFyog9pRHKdt1AXkkCHl4
 YOwcmBYbiKH9QBwZHfA==
X-Proofpoint-ORIG-GUID: BwZLp1eQdAelA9IX-fKKHRqYM5xVgj9Y
X-Proofpoint-GUID: BwZLp1eQdAelA9IX-fKKHRqYM5xVgj9Y
X-Authority-Analysis: v=2.4 cv=R7YO2NRX c=1 sm=1 tr=0 ts=694a22df cx=c_pps
 a=TszpKlPPvK6rXl4+XYbYdQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8
 a=bsWHkKLqYCcK7wv1_R0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce ACC_RWX to capture traditional RWX access bits and modify the
various consumers of ACC_ALL to use ACC_RWX instead, to prepare for
Intel MBEC enablement, as suggested by Sean [1].

The only areas that really need ACC_ALL are kvm_mmu_page_get_access()
and trace_mark_mmio_spte().

No functional change intended.

[1] https://lore.kernel.org/all/aCI-z5vzzLwxOCfw@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++--------
 arch/x86/kvm/mmu/spte.h    |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c |  4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5..b1a7c7cc0c44 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3452,7 +3452,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (it.level == fault->goal_level)
 			break;
 
-		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_RWX);
 		if (sp == ERR_PTR(-EEXIST))
 			continue;
 
@@ -3465,7 +3465,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_RWX,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
@@ -3698,7 +3698,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * current CPU took the fault.
 		 *
 		 * Need not check the access of upper level table entries since
-		 * they are always ACC_ALL.
+		 * they are always ACC_RWX.
 		 */
 		if (is_access_allowed(fault, spte)) {
 			ret = RET_PF_SPURIOUS;
@@ -4804,7 +4804,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_ALL);
+	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_RWX);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
@@ -4895,7 +4895,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_ALL);
+	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_RWX);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
@@ -5614,7 +5614,7 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 {
 	union kvm_cpu_role role = {0};
 
-	role.base.access = ACC_ALL;
+	role.base.access = ACC_RWX;
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 	role.ext.valid = 1;
@@ -5695,7 +5695,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role = {0};
 
-	role.access = ACC_ALL;
+	role.access = ACC_RWX;
 	role.cr0_wp = true;
 	role.efer_nx = true;
 	role.smm = cpu_role.base.smm;
@@ -5826,7 +5826,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.direct = false;
 	role.base.ad_disabled = !accessed_dirty;
 	role.base.guest_mode = true;
-	role.base.access = ACC_ALL;
+	role.base.access = ACC_RWX;
 
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b60666778f61..101a2f61ec96 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -45,7 +45,8 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
-#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+#define ACC_RWX          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+#define ACC_ALL          ACC_RWX
 
 /* The mask for the R/X bits in EPT PTEs */
 #define SPTE_EPT_READABLE_MASK			0x1ull
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5734ca5c17d..98221ed34c51 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1190,9 +1190,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_RWX);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
+		wrprot = make_spte(vcpu, sp, fault->slot, ACC_RWX, iter->gfn,
 				   fault->pfn, iter->old_spte, fault->prefetch,
 				   false, fault->map_writable, &new_spte);
 
-- 
2.43.0


