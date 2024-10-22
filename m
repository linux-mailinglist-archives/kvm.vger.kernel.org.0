Return-Path: <kvm+bounces-29445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8D29AB8E2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 23:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2EFA1C2358F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A5A202F6F;
	Tue, 22 Oct 2024 21:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ShBp1awp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bDbqwP9t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F89F200CB0
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729632933; cv=fail; b=RLqMQuZlQ9njRCLY8cwLCnXvTA8AkBvlHT8Gax3xn3pe5K7MKO+1tOGKvBQ+Kh9rPGVz5Zj3MjUM92XSj5hlmagn00oFb4JWPnwlKY9yFrwAtCRsetLFPe1fGElr4j6JnPVKZizSwB0xo41WjyXmQiFYp3rL1OiCOxteniez2nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729632933; c=relaxed/simple;
	bh=o0X81NanqCDv8nnUf8I0vliIAUg3GHfOfys8/Qvxs7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QJNltxjyYSqyDmDuqqa4zzVITDELQJyX911r6psntP9dioAPIAZVydZNDm2LfJeTLe3qJovwdZFl98QDFTdjrjwA/wTBKmhCHaLp2e0qQVZIXSB3A6f+CldR7lqNpYUtck5k46Cp0ce4X9COG01GHgnmuFUBbWimO23+b1VYS34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ShBp1awp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bDbqwP9t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLQZl8022739;
	Tue, 22 Oct 2024 21:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OIWqMKgNsqbitTcUMMAADhcXdRRq01tyynWWoGYh2v8=; b=
	ShBp1awpCJzldOyoSwb8nsKQ7cvoNbnbRLWMJaMYq3uo906g6ImK3h6LHqpBhX0m
	Lj9JYgkcB+uRBtf0fbgWEvIS/7m+0njLcfXkGrI1EamA0xym4wHFXn5qS5LwSpKI
	cxu4FZq8h9mYgGQ6etVPxd5h4YrOYvhtb8CSrd8zpG8aKAZinFRvrs4aS3HGRhPt
	+SLVfa0meLtdkRca9euf1BSjpsZPQVd+namdHVeMsd8feUGDEqGlwxkZsfuyvt95
	qEKdGSye3nNZ6j81PdpQJN3iqLigu/uO1jYHBwLNO7L+OK2Rrgsv71n5DMHzmmxI
	R2uHXB7/Mo7bLNDpghuyBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5aserar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49MKeALH026254;
	Tue, 22 Oct 2024 21:35:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c3788nvy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCXPdnLy793bMqKPnktF0sx5IBToqtv/2Z5CAG8Ulrg9LSI7nqdPiS/xElupEb5OMAlOKGDJnulSsDVBVBScod9SWBRGoubh+DKYcXXTNXzxNuaokedsW9SD85cMw0gyQEQFFqqeB7bDrRdWhGtxVDA5psAj1yahqr8Rnh7BxI+wK4N1pNAQPOd+3+F4NAm44OzK+btPES9dl+wKCAuzCzUsZbW0AfPE3TqkiOeTzt8WiwUla3Em0h2vczRPezDtNowMQcvd5hOjdQnQgx+ThlN/pSvzBjoAJZ4z/BW342xyoeoYKA/HtM3H8Er4gUi+fIxu9+Ae6TPQOwiFzeLrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIWqMKgNsqbitTcUMMAADhcXdRRq01tyynWWoGYh2v8=;
 b=SjkwpT2FRXdfN8NWEGgzrV4nBKm34ndY2k5Ln3aGiP3EurkjyczC/hFOscyLdhtO6ZP3Jt8nE4UmDDLfxawtQVyquTRqzBSNIWpKfaq9DQnaQvJ9kRPFFwu7Fw7A286rXHyiUb/aOT/Q3QymB1fgDBMSBeqGfb7xDdIpyBx1NgUFoYb0bc3W4KEiypOQskjPwCM35IVMS/0UHBUd1l+wwHI24uGSkYNi8/ssUQ4KDud6lgTJ0m9BZPffPNP9q1A2U5WhS3hjVSEhXsx3FEoFfIrvNvONfLGqQg7rhHO0VwZKvgEGumfsMNEGGnuiyKevrD6wogSdzjququ/5B5KoPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIWqMKgNsqbitTcUMMAADhcXdRRq01tyynWWoGYh2v8=;
 b=bDbqwP9tnA96d59z2/qhzEilnamY50F89Sim3JpFDk0rKYm2OGC6zZH5rAdWVLMep16CNMD0xS3WKxR/QZ6UqGgbVBHKm/SuY0JAX5YOIC2lqV2qg5kmg7ZdyNw0EQ84hKYYGA6dCm/39zwNdnSYD5AIgG29shuGCmTKPxFRcy0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 21:35:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 21:35:13 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: peterx@redhat.com, david@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: william.roche@oracle.com, joao.m.martins@oracle.com
Subject: [PATCH v1 1/4] accel/kvm: SIGBUS handler should also deal with si_addr_lsb
Date: Tue, 22 Oct 2024 21:35:00 +0000
Message-ID: <20241022213503.1189954-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241022213503.1189954-1-william.roche@oracle.com>
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:408:80::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: 02df668f-5a21-4e31-bddb-08dcf2e16948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eWhUDAVhJCRw5cgbwbFWBfrADfLAVk6IotB3nvdUMOBxrr7NTkEyr75Vxd+C?=
 =?us-ascii?Q?bWiEjB1wcEQPKe7J4LBhGbaMxgfysXVURyltwD9MuZ8SGa5lZ8x4ViRlnVcN?=
 =?us-ascii?Q?MuZ41XH77tpxSWlgh7Z87ObbcxnPHrotPZMdiZszLSD7GoGPa2Kx4U6Q+CoH?=
 =?us-ascii?Q?+so45JTlXF26xlBThYKnh0AUODWGiarCfXAMIPaDIoHtQy+yoGZz0TpMeetm?=
 =?us-ascii?Q?Y5wAJ7Txbe3tvlTV0FPRzHSFIVnk4iGoF66TA5OHRzqKvQgUc028jaqH6Dqz?=
 =?us-ascii?Q?pkd2HyQs2n5vb4tBDu+6rdznY2OElHJJXlln9SVApH7iNV8DXxijVIaomAEU?=
 =?us-ascii?Q?Tjdw0AHnKdI4Fc4GBPWlTZzuJaeNfkVe0N7Umg2g/qiVeovjbTeRuRg8g4eC?=
 =?us-ascii?Q?ZD3hSJQKHCDIwWTzUYMPUEcE3DVhZ8xjuBt4w9zpOJCZVJ+d77cDU8/UGXn1?=
 =?us-ascii?Q?vRjwTreixBo0BZrBdb2qcE+BO4SWkIM7jY9Wrs82Q7FPWW7hzgqxVHhOByzB?=
 =?us-ascii?Q?Lo74Q8AS0XzIls0ZA49ww8yH+dLTMY5uUVKHI8QSyZ/2LU0L/y+FRz5e7n/e?=
 =?us-ascii?Q?p4XV2oR3hovI9be2QN57OQmHGfEN9tZRVto1PBI8uD5sg/FnLr9cBHDcLZwP?=
 =?us-ascii?Q?DT/EWm287tyB5eTEBxx85amLYBa0hNfR18FFrZtYo2YaFTAeUdBpYvDY6OzQ?=
 =?us-ascii?Q?YAtR6xnai4zRJC7WDM5+99Us4LLktdeLQhCFRspnV9ix+862tDvtrjvVPZok?=
 =?us-ascii?Q?ACjYH5jryrH5xjqH836zgbl+1pVGYmc82S2mFzvOwzs7iiGfDEroqGvg50si?=
 =?us-ascii?Q?QV1VoDb+0MC9Nm66253zRyqLirV4W58l/2/GexkGyVXQFyammfp79GLbTe0t?=
 =?us-ascii?Q?2bpfitIhs+xXsNRooEoFgdFadeQYmsXWpKnJISWs97tZ/eVvkTp2Wo5/zdlb?=
 =?us-ascii?Q?aIzZdiaAjPX9k5nHzayC9CRxvGEwWCCeIvMHkW/KH6DkFM6wlBLIPpjcaE5q?=
 =?us-ascii?Q?CK7JGCgoOElex6IIUyT+Ham3BQCbKdl/x1brzDXyOuG+PHdEEZDYo77BXzOn?=
 =?us-ascii?Q?yzzTXqYxX2xuojYkoA3BvJPmyHLF/6md6kebJFPtJqu9y68h1KEr6yxRKHuS?=
 =?us-ascii?Q?BKEoi3bWY6WbkBIvUaTCs3tYiQehV+wNY3Cn/1dN/GX1Bw7nmaCkpp0yYyOc?=
 =?us-ascii?Q?0XZI442fk9t/Q/irk6APgXIFkT+7XSnMXqnOleuz8/F03ZrP3oG34LHOG1Pb?=
 =?us-ascii?Q?mhZ6n2qsqz/egNuEkY8TfyRsCGrvR4l1tgA3JosEXjFJDyj7Ul6lCLEJtSP1?=
 =?us-ascii?Q?gL+9tXETxB+ORhaKJwvXHPt7nOU9EyEALsqy37hSfVWwA4bQtHp6bV5XrpHB?=
 =?us-ascii?Q?g9mKJVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yUmMuu/9UPY31nN7DwE/0DRgAPP+aKaw2baBG2gJf1COwnAY81Im1iUdxvvf?=
 =?us-ascii?Q?b2WNUpGOWbS5BBTMXNPiIngzL4HAzZnk5fFexVRbgmKEFuoVCXqf/KWJ3e92?=
 =?us-ascii?Q?iDkfhJtpUbKZ57/N5piAnT5rz7zhpS/CuB1cdbNYIsHhYMrikYr5iLp94Dhk?=
 =?us-ascii?Q?ZJ47E0ZeQgvEyNgrxqpIpOUMQtToGc/LI5IPOQAiEcTOF9S2SNMJ29Pgbtmo?=
 =?us-ascii?Q?VOGdXOlwjrDIY6InU2qrah3HXA/2cETV809GcyqdU4Dj6eC/KzYkLGXYLDAa?=
 =?us-ascii?Q?Oo6Aj7krDKTxqOO+5sFEdj//kzXleqfSC97jaMLpklGiE8XEJFOvwLNr9cPw?=
 =?us-ascii?Q?fO+kNvkNgnIS+rweFgu5vCUIgBfllRyKwdzUxQWW+LC6JA8yz2IuJSdaqtcP?=
 =?us-ascii?Q?3dO1JanIgdXaka3ydOI8szqNQX4ZGv75H/VL0kpK6Ls9DVXU6e537JLrC40g?=
 =?us-ascii?Q?cfy7qthz832lEvMYFJh+dresb4GaQiKN7IAyma6N6YqpyQVg8RePO+vjB9YF?=
 =?us-ascii?Q?UTY1qBSfl3XHh4tl7rMkN00QM2oXlavPA6OdmcozUZLwItCK4CIY8PwaMoUs?=
 =?us-ascii?Q?uwX9zqJ9dulF6xAIWUwXO1kYqJY9Fb+h6h/xZT1ZdWQbv7uv3zTAxOgFLx/n?=
 =?us-ascii?Q?/6ZPIzbQD88lJWgFQiKHCXt7PWoYmtxlen+N/l0nfwP0TTzRoXNgRb+7kTBn?=
 =?us-ascii?Q?u+Rx1yosa8QE8vdM22C7gl2O4sXhHDIDSHgrfRSujeUKLRrF7qncLSzpBZO/?=
 =?us-ascii?Q?o3bladZEaiUJgQWaTb+ZRBJRaB6intBV6t7Lc2xTlyU/uKvQJ3OvkfGQJV3Q?=
 =?us-ascii?Q?YKJmnTW1gSSfCMuz/lmjzngwwbNI4Xf6RpnSdQtbf/tRHW7n9Ci8LPucUu1L?=
 =?us-ascii?Q?7WtmK5uDuUSH+JxgFSgCDg8/ldnlQbzl3zzmj3NgNYe9IhPfLLtCEx1MVcYO?=
 =?us-ascii?Q?m4mSV+WQPjDCEZQCVkw87Etj8RoqydV6Dx9Jj8PvWVFlCyrXEQvToO4r3yzK?=
 =?us-ascii?Q?RD7BMorLJqnY+5bZ/7renpPGu1wC1oSy3d/DAFZgUBXNdUa4eygUG0DB32b1?=
 =?us-ascii?Q?n0RwcA4OajvC5OX32+Oz49FpwdXzEeiC21XQ2UZc0nahCBTUdnkI33SX4Hjr?=
 =?us-ascii?Q?dKxN98tfyE1RYR9NUyhHRohHdFOdT6XqUQrG/HYkUSXrAMM2nVVtcAKdZ1k/?=
 =?us-ascii?Q?3rBafGX5j88wGrun4AyTgXxKjRh2IuSqAVmn9kCAv5pxSFQcU39mooD57B3r?=
 =?us-ascii?Q?M9saSyDTp7sARycDODswQPoUqHIWpQ9PHpsAZlUtBnsvW7RvEsN/XEp6Op7F?=
 =?us-ascii?Q?UmiCGNx7ylJZMh3u/gnxuwiLYXT2gA2DAd2Q4YvthxRc0G3KnrzYHfrKPLm6?=
 =?us-ascii?Q?LAnOuDB7XtkstXPtdxmsLlD9Xq0dTHpiJ7XbOEdrERWRkdkzfeIs5TyX9qjN?=
 =?us-ascii?Q?3BXzFxgJdr1oBgfL2yS+988saPSgakSXgYqKIkfPvRgF0WHUPypmYcvrOsyH?=
 =?us-ascii?Q?DwriPgONmKG/dpDwVXXF6V4WH/C4vRmrJCucKlPv5Rfg/FD4b/njNLfBN2wr?=
 =?us-ascii?Q?9GRz9Z0CFdg9W0Vhrz2iPDnRRsR1JKNNZIQtafcBEeQHZmt/tIGy/hRy3V9U?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3iZxWKtpBEbIBH3YwxfDUt1aegBIcIjb6i4PCwwRVByUxxvgTvPlw9J5Z3WSRVEC80F6/t9RffJfflODKV3LHGDas3KvGWcgOxdScwp90O6Q0+cD5jsK1/We2cQph3R8gSQxkuLGze/ZdIqunQk+pO22S7c1e8sFpj1X9AUz6x3a0Z/RTdpIDMg6XFOSTZymTwu/ri5oZAesm5GbHkMDL0IFzzsDjbNyNrYGMAUYFFJNaKEPaLdLcHHEKM9ZQzLRvefZsn42ahRCiyGGa0XXbiuh60j2Y8vcHbGD3HJW7CeqAtsIEwBF+iavz3ittDMz4FvKR8vundjgUR9C9ygNVK/ZPXxKfdPzQz/FD2tLp4uvrAaNk29w/Nh1bPMIz/S99/aTdpkIskFraHduUh0PeCDRoxkfvSutpawS+pnvKA1WkfrPbnwcmn4UASa+BYkDYjqGi7PDcav0VlOGINqlGQtVjXGqL3/Z6cur9+w4HZo7l6mZNvFf29QIny0P6QHvi+eAzwvyRmT501dK+dswtqjh9b3c+zGr7VbRT8oEZGcj6My+pp1/iiklvbownO+RmRcq3SH5/oRadwHq7ip/uc+wmqRmCeQzOELtIotdBMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02df668f-5a21-4e31-bddb-08dcf2e16948
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 21:35:13.0088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cXMivO1lnMr6Qp6dWYZx34aJhi/VWmwnWXXb31OXsSG0skMQg0v2MsnJKCAviuKtd3iyK/B8FfqHie7N6dRPI4N4FyWZT56BKBD6/qnkug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-22_23,2024-10-22_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410220140
X-Proofpoint-GUID: 4Yq_wQtCSWgoGHr-HJTZhe5GhHCrlNvJ
X-Proofpoint-ORIG-GUID: 4Yq_wQtCSWgoGHr-HJTZhe5GhHCrlNvJ

From: William Roche <william.roche@oracle.com>

The SIGBUS signal siginfo reporting a HW memory error
provides a si_addr_lsb field with an indication of the
impacted memory page size.
This information should be used to track the hwpoisoned
page sizes.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c    | 6 ++++--
 accel/stubs/kvm-stub.c | 4 ++--
 include/qemu/osdep.h   | 5 +++--
 include/sysemu/kvm.h   | 4 ++--
 system/cpus.c          | 6 ++++--
 util/oslib-posix.c     | 3 +++
 6 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5..2adc4d9c24 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2940,6 +2940,7 @@ void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu)
 #ifdef KVM_HAVE_MCE_INJECTION
 static __thread void *pending_sigbus_addr;
 static __thread int pending_sigbus_code;
+static __thread short pending_sigbus_addr_lsb;
 static __thread bool have_sigbus_pending;
 #endif
 
@@ -3651,7 +3652,7 @@ void kvm_init_cpu_signals(CPUState *cpu)
 }
 
 /* Called asynchronously in VCPU thread.  */
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb)
 {
 #ifdef KVM_HAVE_MCE_INJECTION
     if (have_sigbus_pending) {
@@ -3660,6 +3661,7 @@ int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
     have_sigbus_pending = true;
     pending_sigbus_addr = addr;
     pending_sigbus_code = code;
+    pending_sigbus_addr_lsb = addr_lsb;
     qatomic_set(&cpu->exit_request, 1);
     return 0;
 #else
@@ -3668,7 +3670,7 @@ int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
 }
 
 /* Called synchronously (via signalfd) in main thread.  */
-int kvm_on_sigbus(int code, void *addr)
+int kvm_on_sigbus(int code, void *addr, short addr_lsb)
 {
 #ifdef KVM_HAVE_MCE_INJECTION
     /* Action required MCE kills the process if SIGBUS is blocked.  Because
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 8e0eb22e61..80780433d8 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -38,12 +38,12 @@ bool kvm_has_sync_mmu(void)
     return false;
 }
 
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb)
 {
     return 1;
 }
 
-int kvm_on_sigbus(int code, void *addr)
+int kvm_on_sigbus(int code, void *addr, short addr_lsb)
 {
     return 1;
 }
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index fe7c3c5f67..838271c4b8 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -585,8 +585,9 @@ struct qemu_signalfd_siginfo {
     uint64_t ssi_stime;   /* System CPU time consumed (SIGCHLD) */
     uint64_t ssi_addr;    /* Address that generated signal
                              (for hardware-generated signals) */
-    uint8_t  pad[48];     /* Pad size to 128 bytes (allow for
-                             additional fields in the future) */
+    uint16_t ssi_addr_lsb;/* Least significant bit of address (SIGBUS) */
+    uint8_t  pad[46];     /* Pad size to 128 bytes (allow for */
+                          /* additional fields in the future) */
 };
 
 int qemu_signalfd(const sigset_t *mask);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c3a60b2890..1bde598404 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -207,8 +207,8 @@ int kvm_has_gsi_routing(void);
 bool kvm_arm_supports_user_irq(void);
 
 
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
-int kvm_on_sigbus(int code, void *addr);
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb);
+int kvm_on_sigbus(int code, void *addr, short addr_lsb);
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
diff --git a/system/cpus.c b/system/cpus.c
index 1c818ff682..12e630f760 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -376,12 +376,14 @@ static void sigbus_handler(int n, siginfo_t *siginfo, void *ctx)
 
     if (current_cpu) {
         /* Called asynchronously in VCPU thread.  */
-        if (kvm_on_sigbus_vcpu(current_cpu, siginfo->si_code, siginfo->si_addr)) {
+        if (kvm_on_sigbus_vcpu(current_cpu, siginfo->si_code,
+                               siginfo->si_addr, siginfo->si_addr_lsb)) {
             sigbus_reraise();
         }
     } else {
         /* Called synchronously (via signalfd) in main thread.  */
-        if (kvm_on_sigbus(siginfo->si_code, siginfo->si_addr)) {
+        if (kvm_on_sigbus(siginfo->si_code,
+                          siginfo->si_addr, siginfo->si_addr_lsb)) {
             sigbus_reraise();
         }
     }
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index 11b35e48fb..64517d1e40 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -767,6 +767,9 @@ void sigaction_invoke(struct sigaction *action,
     } else if (info->ssi_signo == SIGILL || info->ssi_signo == SIGFPE ||
                info->ssi_signo == SIGSEGV || info->ssi_signo == SIGBUS) {
         si.si_addr = (void *)(uintptr_t)info->ssi_addr;
+        if (info->ssi_signo == SIGBUS) {
+            si.si_addr_lsb = (short int)info->ssi_addr_lsb;
+        }
     } else if (info->ssi_signo == SIGCHLD) {
         si.si_pid = info->ssi_pid;
         si.si_status = info->ssi_status;
-- 
2.43.5


