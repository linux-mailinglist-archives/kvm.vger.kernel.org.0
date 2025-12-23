Return-Path: <kvm+bounces-66599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22371CD81AB
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9AB13044875
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B666307AE3;
	Tue, 23 Dec 2025 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="u2wQ319p";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mwG3Hg0W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2C2F290E
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466311; cv=fail; b=lESF/GltjUfNXsuUkSnnfM3bKhgEmmsVVGMq06M5s288ShekYZfUeOFP0yy8Q+b1uXqOJD9LZaNh2Ktz7zsxChFVIRxkTIaTpZ7F5EsvC6r7mt63sT2rR+Mp1u2rvdMnsRCf3aY641PIffLo8iSCxAVdDqT2L9iy5S1QicBOBCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466311; c=relaxed/simple;
	bh=HQozrPEhS8Zf5tlU8J6jO9JVYX1RNS7mTemyeWcS9Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NIyFkWl6luS1yyulynEoiYyewksTLH5exPEq7b4CyYL32wDa8IJH0k3z2sLgIVxdKEvBvUKDT04OfM5ruTHWP6IPLgdq7dJy5qOC/Yg/N3UYCS9Bz5j0nUN2zigTZVF9wQUPSzkbpiinNnDsNkRhE0NW4M/Fio/HZylnIF6fSIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=u2wQ319p; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mwG3Hg0W; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Loac733160;
	Mon, 22 Dec 2025 21:05:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=++b2c9Cg3fyWLno5GUfH6vT/W/k8XffWY8ANbQjvn
	4E=; b=u2wQ319pXivvoQxBwLXNohVqPzTUOwmw9kEpqZWEPYZ6EAaGoaLNwkxAL
	L45QvuQjuxZ97vd+C4tCUR969ciyzkzXTdkmhNfV9ZzT8OK1sm7GRrrsvJkov9Ni
	bWWEVzYrae+RAO6z97UIa9g2QPPRR/Ne3mFQtKbuP5+hb+xR/rZeXmX+c0JgjpTg
	Th+FQrwrRZ/vznA1zt4Bb5qWYCYuNzfp4ZwiuOUjZ9dhy0RsHba5CiaGEIO7zUka
	kO7b0uOml1Aw7TJkQU2Z6HDvIPs2xMWJZEm/UX4VsEfnnmo5mk/X8v6SMeE1500x
	UteISQKJTi5oqWIIC7nSr1gU6/4Iw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=suDsyaWAEdoIE508bD3UDc9QLyGztKLAy06F/J8yJKEogOKvD5WY47lMVxf/YnKWIVUooG1GRWwKBxZ7iozsaOZA2vxGqE1OinHtu6Sq+2gV0ZVcnCoLwkqbgcOJBEARYjzBCHZwyfNpEATedC6N+M3mZNIkigr9TqdPR3PXanwGi9iOCCK8nWZh5uWpybvR9pYjZBkWBqA85heAGwIpmApNWMPXyr8RnAjW9ikyzcIfoNJxqDIFbuyfZ4jcLz9v3cQcyf1EAfDeouWMPcwvp/aGijgyjf89IZ9jYwDFeNoYE8mGfaKr9e2svEY2ggcML6tjsFAgVr1JGK3h1+hyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++b2c9Cg3fyWLno5GUfH6vT/W/k8XffWY8ANbQjvn4E=;
 b=ZD9phrShcDO7nDM2imO5nvzVkjM8hn8g293hmQC9RxF0r0Sa8StFAKjHnpgaVl3Eo+69zNajaZJskNARU7pVKVGOl7B4DrjljuRsooceOSRahVDh1mRevfZegURTp+LRdUEN3hBlpFOoQVYUgR2b6nkA1gHDjS2ML7bE0oOY1/ia742/koc3zoYWhUlGHgWfDBwiND+qiN4n7B33KEls6l2oHIOw/zF8d3hZOBoSLyUIz8ySv5REKACXFW0FSNYz8xI1Vm12eoE07d3lFSLHynm/1FkIQAXJQ5apt26KThcTXyDsZWbL7rmRt3UcprSntFFyFAkthVJZS46uehRYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++b2c9Cg3fyWLno5GUfH6vT/W/k8XffWY8ANbQjvn4E=;
 b=mwG3Hg0WDjSemoHuPnBJ0b9RyYgm8Vxip1RnXuXUCNLvChkW5kRURUO+dA/g5wHUlI1MHyvYZO1+9ROFFSuvxMLKiW8/SBzVP5QFBuoAUfyNLxEqUvj6l0zO7VzNSQ8YGhU8IKVzG10Q76Mxv3gNa84Mz7TawSso7nXZG3zjpVStcQB5x1auvLJWYSp6NumrRHgblghUnb1iG1cksxWxv7wvS4IP+zVxFV1luEANPLmuLb4q3XrMDA5dHLtgCpTuAsicC5d0TkB/wMiDVDraRvv3xWzq4kirXrOcfXoKnvCL+6dJDrvwZjLM34PZegwyi4wRasidOftjIF8aVJA2sA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:01 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:01 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 07/10] x86/vmx: update EPT access tests for MBEC support (needs help)
Date: Mon, 22 Dec 2025 22:48:47 -0700
Message-ID: <20251223054850.1611618-8-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: d86ce47b-2fb0-4fdb-3ef2-08de41e0d3af
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ws6zB0QpW8AD4HB7SiYk1ye/SSIMShh9nxx2CZSc/QSa+d9cFB/KjcaRLIxX?=
 =?us-ascii?Q?efe3HX8IT0HhrNdI3TB6ZNFm/VFtfOQ7KzyyTWT5g956oFkGsk5UEW80QIS7?=
 =?us-ascii?Q?2lNJQuhnev3UXixuUxrN4kifpSO0NbgqSj6scWIDm/fcBsy+NIrtFrG9E7Xb?=
 =?us-ascii?Q?MlWDjTIa3VDQI+AsysHauF5PXgORUKoS0BgrXA+pKWwxAF6XhV7L3qYmd9tI?=
 =?us-ascii?Q?IUptGIWE7liBXIk8KxbI3+Ve9N9fcJGlRyzT2yT1PNixwKlC67UqqaiQJl5C?=
 =?us-ascii?Q?sZnl/HhtjUBb7Mypbs1lMQu/Fotm5n8eioxzUOF0LxrR92HiLldR73IAqwBM?=
 =?us-ascii?Q?uEDxwwYsYJzO+P6ZgBsiATRrE4s1yGcnJ/oXFMjsRntKLfqxNAMtPaaQOZsE?=
 =?us-ascii?Q?Uj5YVcLkUmKD+Ub/zslcA3rCKhX8Qhivz39IfcbS/AjtJ9PWbVXOG+Qj2iAn?=
 =?us-ascii?Q?DUV9Qi+DMLo6jG95rl90K6n3Q2ZuCtlbXKQ9VMcZtkwZn1nivHMNweU367Ko?=
 =?us-ascii?Q?/dpQS/aoge4Y7CUD+lO52ujj3qeZOkZTNnOb9WXnVv+0Th6BftFg372i4ITO?=
 =?us-ascii?Q?20tUOmG467lJWcX+cu/SXUjFik1yVrSxsOhU6/xAJ/bRJUsXTzMsj3rM0r4H?=
 =?us-ascii?Q?arh+pq5gypht6RIStYTG2tXynoLh5da9xpyh4Cl98/9o+G0SqVmAO+3LYtZt?=
 =?us-ascii?Q?wRGJW6f3iz/VGGZ+mVtG3oHtplkaZhk4nZ/aP1ZrSqp86xRE3UAOWXI7jLK9?=
 =?us-ascii?Q?hIdt3k4IsUX2W7bVvoiOdVhObWBZax1Sa0VJ8tiyUKizFHFWolQNsAhevfQ6?=
 =?us-ascii?Q?cKQpRfiXAu+zzAN3T7UDp4uFLaPwUyOXWTE9d9lSdb1FW5IBlF/upMpdnRyA?=
 =?us-ascii?Q?btczRK7mFjyqrZqVZ+iwTi7EJ/zPM+5OqtH1I5l5obKk0wJ63bksCUI3bjlz?=
 =?us-ascii?Q?ab5FjGq3Eb+mER4C67bqAef6L3irjkUpoJqYo4DzusFlHr+DyF/7hdIUZItl?=
 =?us-ascii?Q?1CtD82T/LXPmjOsN+T6UPQXsnUbceOdQRm57ElHzyE79o2p4hq0C5WdDW5YY?=
 =?us-ascii?Q?gTTyMpaKnFFMNxpUrqE4jPR6KYm8t9j0KQz4X2DEsbH/g6ZBH0d3N87g2sDv?=
 =?us-ascii?Q?4JCLyhk9t7BY7JvT98I1mzCeKbEUhfpQRukoXQDokp7UG7rHq64Bgl3UeLgo?=
 =?us-ascii?Q?QoTAMAObK70OMoW8pTYaHm9x+9VVm5n2lsvb1qXO693mgErjZbkS4Vdwz8gv?=
 =?us-ascii?Q?Qpmfzwj4ryNVvFrR+PzNa7I37yInaHTOXw7GfyCARgXNn8vHYi88QoUjc0X4?=
 =?us-ascii?Q?HM9PhHm1filyTqRghJOZZAuXqSDByozTZVHp9M33+Jt9WG1/CEKB7f4qFfBC?=
 =?us-ascii?Q?vxk79KPWQ2oTYwdRJwqagEKheqnoS0EA6H3QEALZQLcbdJuBUc2PTZBZ6sKI?=
 =?us-ascii?Q?nK3XMttawOEoTz+OxF7fPIv9sNFcs1IUBrmlLweMMphsVzjR2gJCKsqTexHq?=
 =?us-ascii?Q?20TLQ/oht0bjs8hnDxvbKMeOqc/qPFlGx9ns?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JLKEuyf7jGFBvTos7mErxVT7iRm1SbWopdLW2QBov3/pLhYcH+2HQpvWCoG2?=
 =?us-ascii?Q?KOWuKTXHRh6ftyyjVEvSt/ne21ITjjwSqXO79wxJPs9qU4Vm0GULawE5zWzt?=
 =?us-ascii?Q?dLvl992f+FqEmnrJ7rPcObHkycsBhoYIoyYOPL7UL3gVaB8dN7drNYBMto7f?=
 =?us-ascii?Q?9W7oMwkBJYN2lVr0UFQFJdoLkKz6cTa/PyAvhd2G3EmHf4dHyORgusVJNXkZ?=
 =?us-ascii?Q?AgPkylL3VUfVzrd9PNsVMANtmiYdKNXDIbJ6uIaKFL8yIbUKUL/UZm3jA5ZJ?=
 =?us-ascii?Q?i7U0gL8+NAMt6ohyGkH1sjRsOwhB/vhBdFX07AuYcn1QHiRKc7kj0Q6rZ5qf?=
 =?us-ascii?Q?j944Y5w/FN0kpU2jeoyTIz8lwSTqAGojwWrtKEyeY7NRWx6oiM1w+svq0AX+?=
 =?us-ascii?Q?rbo1RE0jEPZQOScZmZqs+e/HLl/A1/+7hXaofXaTOpNecMquvp+nrpJjds78?=
 =?us-ascii?Q?rhFmk394C8u27ddcNtFzfjbAAShQ0U/18ioHaHWnSi9Y/NGQpnXRR6gV8XH0?=
 =?us-ascii?Q?Tx7uljRT0OtScKT1+jXjSfm0Y06RMsYPCE+2B9FhWDUr7RLg9PRCSCs4/ur2?=
 =?us-ascii?Q?RbAVVBgitwgNv/2Zt6Ca3hOw1eADfEPiHB0ipxr0omQs2yzLu5g68Gqh2vVV?=
 =?us-ascii?Q?JLJHppVWxIaSfOzdv8lrGN/LG3nLU+u+mfj/5XhQCvrwN/NiLXGTuuXfXHO/?=
 =?us-ascii?Q?EtmETLAKNun2PHJFwJvgbpF6lI9zj0dloQdorYr4DjPrfktJjZFs/D6fHYar?=
 =?us-ascii?Q?KQeqrOt7ILUnD07VhdYQXFhXVpNz2N+Ak2nM+i7xyTa63f7CTg8jmEInu2+a?=
 =?us-ascii?Q?yez2uiSOmra4k5ABsRXujpGGyvyDf+IUXWeDQEaV64DK64FKNl5yC3n6A7Bu?=
 =?us-ascii?Q?2B28OUNI8rsaXFppSTcfkIvVumL/cw5KaCErG6PebPhtywVRuz1oR/jQ1BG2?=
 =?us-ascii?Q?P4z/C95z8mZP36R9G2ZO3mBM6gyEYbm/Qcd9OaTLKFxnD1nEkqYYLR89qgaW?=
 =?us-ascii?Q?Ely62TzkRGZW8TDWknRbYhBvcSMb6OaL7MgF0F7fCaywtSGbYqhxp77Oqhz1?=
 =?us-ascii?Q?fgjTsxc1K43ZTZ1qJq6HLNzeIg9T9BsCI/0EPeBHQx9ybKMqkygsurZfd9GX?=
 =?us-ascii?Q?BdZT28f5QtQGC/abMWC77tE+VAhcTknI9NDbkPUXrkiGQ2Eqv3LkomtIY4D3?=
 =?us-ascii?Q?ebQOwFAUaKgzIaNLTsGenEEHhOImbCMQLiR0wzuee4aXtKTcGVu486pwPZHE?=
 =?us-ascii?Q?JYr/oeIPwbXqC6CKZAuOxk3Ofm9064ApaFlLwvCw72WNXPR/X+agzKQPz4Vo?=
 =?us-ascii?Q?ABqqBc6wQ9+MfgmWRL4CpGy3KiH68sxRRcECOIDr2F/7VP5ft5k5L0dskg73?=
 =?us-ascii?Q?svdSJ40bvcr62BQc9a6U07HG3bQ08XDYVD2Z5tBxs8tkp8cXTZtSZyH91IPf?=
 =?us-ascii?Q?bnt2IlDJvqxqQGCwUCAdGvOs4iv/IIOZab88AqVLtquEl8Rz6jiRukAseWAT?=
 =?us-ascii?Q?cbR2eqGljp++y5/OlqK3kxRUc+HCZlWeJsamLDsVgWxNfUx7xd/9zlOzYXTN?=
 =?us-ascii?Q?SjWIy99coJStoIAhD2Yu1+YJXyiUWoaYtIxR2847PK465LHE6LqcDzRxMisu?=
 =?us-ascii?Q?xA1KodvZ1clkfuV+d2iNM4D3nf1YTLAB/vXQSbmKvOywQKuvAoBy51uee3lk?=
 =?us-ascii?Q?ia8zCKwHrtfesmHWL8vImqi3jc+f17l6X+HIwL4hmROSPbAPup8zOAhCrSM7?=
 =?us-ascii?Q?QezFj36Aw1DbeH2astf62zPvoZDoV18=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86ce47b-2fb0-4fdb-3ef2-08de41e0d3af
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:01.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRKi3GOtyUIsoeIUXzPbo6KrfobchVop8UkHUBBa7ldKreCqmTYmPjk4w8RJWNdzm14YzQ1wVk+JHw7BCgzDYusqspz00M+ILbf+1zMS7N4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: KyiUb5nSSZNjCxCIDdpipXPoY4qw5y_u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX+eXG+0zA342j
 t6ZDTRaT+pgO9fBdnpd9vVNGa7z3ze55IwR5F+6TXeVMMBnySxb7sNLEKzuvKnwJ9VuZC4mxpIf
 i0zeKP58AhmDNMe9/ZPZ6pULG03HXF2l/ETylhDdy9QlvGObhN85LtP2zQLt30s6cVD0+Xn1UGr
 gH5dVQk6GueiHTHoWl2fIjR4bp6x3eZ2TQ2R76PvILJKHFAmSXv9y+MXXk8eUaFzWAyCGm+lr/i
 RBhXDbpai8OmDpZ8bYUL+AzNvSurouFbEPxyaenj/FpN5fkzxiof8+d3iRCuqHIYi2U8qjTRJcs
 hdJh3ZkRg5zTIfMeY3h+XfdswNnguvkQA9TBZLABTqC2MMQEHkWoYEpiKK12SpBmWrrK9QFg841
 WD2wr9ZktJq1+LRr1jNcu14wNBMjwE/Moaw+hFULq47PAX4OK1OUfd9HeXa+IBrjvmXVl52me2p
 D9mLWVbmYqIOMYwQjmA==
X-Proofpoint-GUID: KyiUb5nSSZNjCxCIDdpipXPoY4qw5y_u
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a2300 cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=eDCt9oOlNWnZb2Eq10gA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend ept_access_test_read_execute to cover MBEC EPT r-x case, with
the caveat that two of the cases do not currently work and are now
commented out.

Need a hand with sanity checking this, as both of the commented out
test cases produce a tight EPT violation loop on the kernel side, and
I'm unsure as of yet if its a test side issue (setup?) or what.

Tests pass with both -vmx-mbec and +vmx-mbec (for the case that isn't
commented out)

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 465bcf72..e869d702 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2867,8 +2867,17 @@ static void ept_access_test_read_execute(void)
 	/* r-x */
 	ept_access_allowed(EPT_RA | EPT_EA, OP_READ);
 	ept_access_violation(EPT_RA | EPT_EA, OP_WRITE,
-			   EPT_VLT_WR | EPT_VLT_PERM_RD | EPT_VLT_PERM_EX);
+			     EPT_VLT_WR | EPT_VLT_PERM_RD | EPT_VLT_PERM_EX);
 	ept_access_allowed(EPT_RA | EPT_EA, OP_EXEC);
+	if (is_mbec_supported()) {
+		ept_access_allowed(EPT_RA | EPT_EA_USER, OP_READ);
+		// FIXME: this one produces EPT_VIOLATION LOOP (doesn't work, should it?)
+		// ept_access_violation(EPT_RA | EPT_EA_USER, OP_WRITE,
+		//		     EPT_VLT_WR | EPT_VLT_PERM_RD |
+		//		     EPT_VLT_PERM_EX);
+		// FIXME: this one produces EPT_VIOLATION LOOP (doesn't work, should it?)
+		//ept_access_allowed(EPT_RA | EPT_EA_USER, OP_EXEC_USER);
+	}
 }
 
 static void ept_access_test_write_execute(void)
-- 
2.43.0


