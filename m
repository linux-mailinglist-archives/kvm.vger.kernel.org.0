Return-Path: <kvm+bounces-72810-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PTUEdpnqWlN6wAAu9opvQ
	(envelope-from <kvm+bounces-72810-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:24:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A91121089D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92DF43045018
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 11:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C909384226;
	Thu,  5 Mar 2026 11:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fY5t5129";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fY5t5129"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010004.outbound.protection.outlook.com [52.101.84.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCFA347FEE
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 11:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772709841; cv=fail; b=VZ+w+sqGECQpWIOL0zZPoWqgw7r7rBmQgZk5HAYwob/tVTy6Fyulnk8mClBHNyriot0dp4a8phmPkDzYkzwgpyvDgllcAKueg1366ybYJ0/QJ6zx1vuQcNEnShVY1vLHjRPfSXNajMn0JlCpM9djmQY4Bh1+DACzziZAYnLaFmU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772709841; c=relaxed/simple;
	bh=iWGil4/PZSJgQu4nh6UKsbQPYE77Gx9Cz2zs96/AKwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cS9MNPoT8escxaeNbJfSHDbgiHi53MKcLMl29xoUIjfo5B/BM6pT3ALJHJidHuQYCblrUvUFA3Ax97APoh+waVokmLKnAJlZDruRP+ACB9S1WmS7ZUT6TTPDpZkMZitI0iCvBsYCMKZ3+aBnTsc7pnFDFZlcvMgxuKok1uLj3rI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fY5t5129; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fY5t5129; arc=fail smtp.client-ip=52.101.84.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hlYTpL6IT5JDv9bTg6CTJVQ+UZXle+VJbiq05gE67FMYgB6d3Xf5oiKxDCI8MXPH9KYAcMKnNH+XbSKNLiWqvm4pAEntpgWv5K4iWQJ1lFqG9IEO6AT6dF7HU04kFggwZR30XTDPJO7moMORx78+R7SN/Cm8FYR7nGtdZ1GDxQ+1QozU/ltaV5N8xGN5Q2FdqgjOIzScxWAz8Xu7IRwxfsYv1IYw0tcqv7Y9LfTvjjvM8T+5TJ1cKkgVJRuNWvyISSwqrJ16um+W/Vt1ZVVmoDYnXhT5qh1tS0pli8KqONxeQd05mLogaaXTTKXaehUr0OQ9QJ1wMc+NWYM4TNN0VA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWGil4/PZSJgQu4nh6UKsbQPYE77Gx9Cz2zs96/AKwg=;
 b=I7YF7QuqnWR6tNuZNFt2oNO414QUxPb8JWurtZ6Udg9KH41rqDU3U8O9Rqg1WNsbG9pdWYQzE5i8N9HQM2ubdye0NAq+LlFsHNXsiJeEyhjYOlP7vmf8Y+Ad4KkD2p5I0Wt6tzVbYmm/KKU3gk335xw/G/0/Ta67dCjLpHLg+i6/TxKltEIQV/PFA5P2L1eTGv6AmAP/8v9epHpqx4fgDRAww2VtdIZ5mkz0rTJyy0BuncEuaVyEC0LYMhN3fl9I+5MN2IuEN5X38ljwgX3JhOBvGxXz9H7c/BabBH1YfjlJiVrMk9NE19PM+BzYEXjXZhJQmfytIbMbgnMeOPzWMQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWGil4/PZSJgQu4nh6UKsbQPYE77Gx9Cz2zs96/AKwg=;
 b=fY5t5129Wqs33tdRHFPQshFkmao9Rv6hlnBojVhbSHBGd1k9Rw41h+wRI13HxVFQ1PK6dITZNHg4iLZ0J3SQ7+OS1QTnzK0bi4tE5FLtNK+crCh70n8OvdnUwIWWLlTBrQFKiHAlZjnt+70CXY1tOJdiORnGV6G0oflkKxjWJYQ=
Received: from AS4P191CA0039.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::24)
 by AS8PR08MB7864.eurprd08.prod.outlook.com (2603:10a6:20b:52f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 11:23:51 +0000
Received: from AMS0EPF000001AC.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::71) by AS4P191CA0039.outlook.office365.com
 (2603:10a6:20b:657::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.23 via Frontend Transport; Thu,
 5 Mar 2026 11:23:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AC.mail.protection.outlook.com (10.167.16.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Thu, 5 Mar 2026 11:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVks48TmclfCgI1Xuqvgnjn/qfEEKUY6msHqSX5HEJUzJJlexEppb+ZtY0Ba0wIWrc5lWZ+cDuh99xkl5H1Bx/HTaP4KWX2hDYA8zAquAs7hYVeg8q14hDG4aDWanH3ht4DpYee3Zg7lmQ3wBA7JN+/DwX+MYsl16U/WddFesHnXU5JfWIZnE/Db6/1X5XjJIcnczGaN+AoLts0elGkXXFHRhTnsIwk+IyGydAIKqZMUfB5ZUnqoDRzSq4tIwWgmIjpsD0djVH91X6b3+fBgoWfqWNcbV/iuCQ7C49N6V3lUGoZFwEUcmSx7/C11f8YqhcPcvU/m+i2+mvOV9gLX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWGil4/PZSJgQu4nh6UKsbQPYE77Gx9Cz2zs96/AKwg=;
 b=g4hGlWxFLoFy55axdFTONAaINpNbkPZeGxyuUcZ1aj5/pBCa9IXsu0PCcSLjpEb62290pokr6z15sQFPRx4QX+Ah9ZmikHUXs87R4bIuyccBzjCjwz0fjWXvUUPyjQbrmsXF6zbNLmlh3Na6Bnocf+TsSdw3rFkHreYRHTer2mvIX0DDRyFsNVLkk2dScGrEeIaHtblUWQoNwE6MabWkF9aZ7+1qW2tdPyFijUvv/g20CrtDBcGvj6TG6K0K6Ews577XEMtn06fcrKm/rpx76S4NIjk3Nq6TVLEd6i0f3X0LewcbHXGIecx6fWCBa0ehwydDSEKPqx2Ytbx+eIWALw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWGil4/PZSJgQu4nh6UKsbQPYE77Gx9Cz2zs96/AKwg=;
 b=fY5t5129Wqs33tdRHFPQshFkmao9Rv6hlnBojVhbSHBGd1k9Rw41h+wRI13HxVFQ1PK6dITZNHg4iLZ0J3SQ7+OS1QTnzK0bi4tE5FLtNK+crCh70n8OvdnUwIWWLlTBrQFKiHAlZjnt+70CXY1tOJdiORnGV6G0oflkKxjWJYQ=
Received: from VE1PR08MB5694.eurprd08.prod.outlook.com (2603:10a6:800:1a3::7)
 by DU0PR08MB9297.eurprd08.prod.outlook.com (2603:10a6:10:41c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 11:22:47 +0000
Received: from VE1PR08MB5694.eurprd08.prod.outlook.com
 ([fe80::b739:1366:c5a6:5e10]) by VE1PR08MB5694.eurprd08.prod.outlook.com
 ([fe80::b739:1366:c5a6:5e10%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 11:22:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v5 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Topic: [PATCH v5 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHcpzjmKN6J/v3Y/U6WLY4TGQmKm7WeJgkAgAGwTIA=
Date: Thu, 5 Mar 2026 11:22:45 +0000
Message-ID: <706fd4f98d269a03ab334f80ad54641abec567d9.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-17-sascha.bischoff@arm.com>
	 <864imw7x99.wl-maz@kernel.org>
In-Reply-To: <864imw7x99.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VE1PR08MB5694:EE_|DU0PR08MB9297:EE_|AMS0EPF000001AC:EE_|AS8PR08MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: f8843cbb-bb77-441f-28e0-08de7aa9ad86
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 wRVlDebTm/SNzpmlJHFjuxtjI26i8mDVMwJilHqPex5kWt0qOK38H72wu1WKqP8l9bbPs8kMerOZwOTTt58u/qNiGjB9Q8EOO2szIX2iCcRDX/nO4LaXdpjmWpQCDkhmyy28RnzgSkIydJFMnalX32ICidruLnwb8CphPs7BN0ndAjwWYnmoIgTUsQmyDEtiVnpIaXYQIEhaxCO5iNPs6r8sIk13WZnUdH/x1uG0UaOYoQKSj9sVTZ2GrEpUbi8N5kKhLMB0r/hyZgVz15U5lk/09CFryHMuHNDeXx24K9C2OwK/g/GnEnhsfG29i6/iN/Vzsk5nOGjwD6p1Ycbr/neLIliL4IEupTLBEav/rBArtixL/TMBs/GAMbs/1LGjmlMr9HfQRD4d4P99X/L9toOfsDgLRsF7IRD6FK/SukfZllP2DeNCErnv5k7Bc88jY7BqOnTlzIdhW306dG++i1JuTmHJoSzflvnxYho22DVMISqPn8caqPkkUjc0GysHD6Seuqmwil9gv6N8Xj37YJvL3X2gJFKD2leCaPQUBd/N6We64utkwYSWIHPi5QopQD02I+cKCwF2596LzkmB5oCXuopl1gL6iYJGRXJHq0oa+SagU2weBllJr/rAPV6xGyqXol9s0o62eH8WEPrYs8CMW4c4++vcMirVptESVky3fnQUVEHvPwsb2JyqfhNLaYjCM3BUqJJ0giX7SAfyRvuMt9E3Ukge0PNneh21N1TZ0AMEWhcZS6o7LtSFqCWVnoQYVBlRK3zZ4KFRlUsmSVHXqyj7VbbewgOxREND9DY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5694.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F11513CB898104C9C722567CB29AD70@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Vn64r+KNNepGMnj9r+2Rpn6FCHlB9jxHUiKtkkJSz3oUzlRwSmiutVhhoWtU3i10XBz6OczNdJKSGjm1H5EQRK6SS3Z8xtqlhcEkaptL7wsrPbGrEO4IN6XTmamImTiZ75m+BsZAHUdNvA5VymEKonJcvid4EfKYM1i+Bp5MSD6c0QMJjzBYImChf1uCeAdpS6JBmndA3lXNR2Bze+M+Bf6p9/Aj3kaFaTJLGpcJFaJosbl/gidXnb1rLS6RHH0n02dZfl6uR8yhSq5uYyebtSGpzFkj2sm7/UhUIkrZOaule4aX2p+iz+k2xl9yssYh30kYR6xVyQVUfYbzKeQEhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9297
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	afa753ce-18dc-4987-8229-08de7aa9869e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|376014|36860700016|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	Mwbe9LluN/DFRjD7flP+I4jFpEO4GcOB61UsC9Q+d12OefJnDSyX8EYW6u3iReeGqjZVLDPQH0Z0aDe1ZbwSm6K0PIcALOdkwuwnseI5yqNtEIwo+b1J0F4zPkMwkJGXFx2n6O/doFayH+UZm9eU6MVKaNF2GIFOx83P/6fOutYJAgGuqwy+fJeHs8zF++l6afqAQo6KgQ04KgzskVHda6yI1H9/1JW4FH46mzDzBODXZ5+OMRk3VTlrGQNHm4dnWOiZypgH7IlSOKZ9mSetEOj9K8ZQrHjxNEK5VLDNaaal6GVTqSZ/i04151bGHm7PHjsUsgnxB8K6qm5tacYscTp8O9XFDncFCk3ZP+xWpGSnok1ogu3+Dcah2zQ4v7rSnOSyDwFekHM4VdxlyrLW6XaFCDsyze3wIVAQA6T1xKB4qpKRCkbUAdabC4/g/uJaVHNVNB+IBAaIiheoAoolXMmI4Ip4RRFeeAaHnC3XjfFBv/mRSkmaPUsCWFQ6EpUV0+dtxoZIv5O/1yRtdpSc5Svp4NhdY7P1JufK0dl4kH8m2SFYSWbXFYEWYFx+XGhZe0oFBCjPSfbpWtrWPbFSDJLhbQEn8MqyE9N6lmtd55ygqXdvaJzJDqrPFCYnwQD9dA7m6CDOF7RJzHVC1ifxR2kfCzRfdMr5JsfvsRda3P++EOMq+Zv9pKa/B6DdHYCk0ZaYz4TWBQIQ/OfUrw+45cfMcDOoUrfiNEegoSNXwreBtIezxDHAZCb4Df9F6l6TV1znpMjavl0KzHCrtDOYDg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(376014)(36860700016)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jPFF2DijohnysNt0uuNB0mXGnJffQdqrj6Qivb/Z5zqLOgiKW99BbMlBQAvcPTy8cpRat+OKFAQdlubnkTTzp4D2fKH5F5JGF9nNNWpJjjEh6NDL0u6Nm3VtDjP/dM/E1CjxYMrE4n8+Zr/I8eOmSqUFyX5w8CyfSQjsfZ5E+HRD/6zr/cWe+HK8YyXPStO3q5xiMD61DzOEZcQjzA4cAWUGd3WdSV3iJxDaXCV66KWhkz8ebRGdcdc4r/CoiTqWHTwvBqxWyI5NvUrf7yWELWNyaKwiCq3NzCjxRW4VcDJGocKAMe05w30sXfIiI/W531wmDKgG/UAZUumwsN2D36xfNjy7ck+fxznJ5Zze+jWwzXj8xIV1QWOWBgIJay6okwx4j2Fq42qL//38KuGw2gI0MLSmbNt4ALeCgeN0bvCYGMBy11RqZT8qHuj1kuz3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 11:23:51.1424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8843cbb-bb77-441f-28e0-08de7aa9ad86
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7864
X-Rspamd-Queue-Id: 8A91121089D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72810-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,huawei.com:email,arm.com:dkim,arm.com:email,arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDA5OjM1ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTU6NTk6MzMgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IGlzIGFibGUg
dG8gZGlyZWN0bHkgaW5qZWN0IFBQSSBwZW5kaW5nIHN0YXRlIGludG8gYSBndWVzdA0KPiA+IHVz
aW5nDQo+ID4gYSBtZWNoYW5pc20gY2FsbGVkIERWSSB3aGVyZWJ5IHRoZSBwZW5kaW5nIGJpdCBm
b3IgYSBwYXRpY3VsYXIgUFBJDQo+ID4gaXMNCj4gPiBkcml2ZW4gZGlyZWN0bHkgYnkgdGhlIHBo
eXNpY2FsbHktY29ubmVjdGVkIGhhcmR3YXJlLiBUaGlzDQo+ID4gbWVjaGFuaXNtDQo+ID4gaXRz
ZWxmIGRvZXNuJ3QgYWxsb3cgZm9yIGFueSBJRCB0cmFuc2xhdGlvbiwgc28gdGhlIGhvc3QgaW50
ZXJydXB0DQo+ID4gaXMNCj4gPiBkaXJlY3RseSBtYXBwZWQgaW50byBhIGd1ZXN0IHdpdGggdGhl
IHNhbWUgaW50ZXJydXB0IElELg0KPiA+IA0KPiA+IFdoZW4gbWFwcGluZyBhIHZpcnR1YWwgaW50
ZXJydXB0IHRvIGEgcGh5c2ljYWwgaW50ZXJydXB0IHZpYQ0KPiA+IGt2bV92Z2ljX21hcF9pcnEg
Zm9yIGEgR0lDdjUgZ3Vlc3QsIGNoZWNrIGlmIHRoZSBpbnRlcnJ1cHQgaXRzZWxmDQo+ID4gaXMg
YQ0KPiA+IFBQSSBvciBub3QuIElmIGl0IGlzLCBhbmQgdGhlIGhvc3QncyBpbnRlcnJ1cHQgSUQg
bWF0Y2hlcyB0aGF0IHVzZWQNCj4gPiBmb3IgdGhlIGd1ZXN0IERWSSBpcyBlbmFibGVkLCBhbmQg
dGhlIGludGVycnVwdCBpdHNlbGYgaXMgbWFya2VkIGFzDQo+ID4gZGlyZWN0bHlfaW5qZWN0ZWQu
DQo+ID4gDQo+ID4gV2hlbiB0aGUgaW50ZXJydXB0IGlzIHVubWFwcGVkIGFnYWluLCB0aGlzIHBy
b2Nlc3MgaXMgcmV2ZXJzZWQsIGFuZA0KPiA+IERWSSBpcyBkaXNhYmxlZCBmb3IgdGhlIGludGVy
cnVwdCBhZ2Fpbi4NCj4gPiANCj4gPiBOb3RlOiB0aGUgZXhwZWN0YXRpb24gaXMgdGhhdCBhIGRp
cmVjdGx5IGluamVjdGVkIFBQSSBpcyBkaXNhYmxlZA0KPiA+IG9uDQo+ID4gdGhlIGhvc3Qgd2hp
bGUgdGhlIGd1ZXN0IHN0YXRlIGlzIGxvYWRlZC4gVGhlIHJlYXNvbiBpcyB0aGF0DQo+ID4gYWx0
aG91Z2gNCj4gPiBEVkkgaXMgZW5hYmxlZCB0byBkcml2ZSB0aGUgZ3Vlc3QncyBwZW5kaW5nIHN0
YXRlIGRpcmVjdGx5LCB0aGUNCj4gPiBob3N0DQo+ID4gcGVuZGluZyBzdGF0ZSBhbHNvIHJlbWFp
bnMgZHJpdmVuLiBJbiBvcmRlciB0byBhdm9pZCB0aGUgc2FtZSBQUEkNCj4gPiBmaXJpbmcgb24g
Ym90aCB0aGUgaG9zdCBhbmQgdGhlIGd1ZXN0LCB0aGUgaG9zdCdzIGludGVycnVwdCBtdXN0IGJl
DQo+ID4gZGlzYWJsZWQgKG1hc2tlZCkuIFRoaXMgaXMgbGVmdCB1cCB0byB0aGUgY29kZSB0aGF0
IG93bnMgdGhlIGRldmljZQ0KPiA+IGdlbmVyYXRpbmcgdGhlIFBQSSBhcyB0aGlzIG5lZWRzIHRv
IGJlIGhhbmRsZWQgb24gYSBwZXItVk0gYmFzaXMuDQo+ID4gT25lDQo+ID4gVk0gbWlnaHQgdXNl
IERWSSwgd2hpbGUgYW5vdGhlciBtaWdodCBub3QsIGluIHdoaWNoIGNhc2UgdGhlDQo+ID4gcGh5
c2ljYWwNCj4gPiBQUEkgc2hvdWxkIGJlIGVuYWJsZWQgZm9yIHRoZSBsYXR0ZXIuDQo+ID4gDQo+
ID4gQ28tYXV0aG9yZWQtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW1vdGh5IEhheWVzIDx0aW1vdGh5LmhheWVzQGFybS5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJt
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSm9uYXRoYW4gQ2FtZXJvbiA8am9uYXRoYW4uY2FtZXJv
bkBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1
LmMgfCAxNSArKysrKysrKysrKysrKysNCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5j
wqDCoMKgIHwgMTAgKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmjC
oMKgwqAgfMKgIDEgKw0KPiA+IMKgaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaMKgwqDCoMKgwqDCoMKg
IHzCoCAxICsNCj4gPiDCoDQgZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKQ0KPiA+IA0K
PiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCA1YjM1Yzc1Njg4N2E5Li5mNWNk
OWRlY2ZjMjZlIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5j
DQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtODYsNiAr
ODYsMjEgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0IGdpY19rdm1faW5mbw0KPiA+
ICppbmZvKQ0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gKy8qDQo+ID4g
KyAqIFNldHMvY2xlYXJzIHRoZSBjb3JyZXNwb25kaW5nIGJpdCBpbiB0aGUgSUNIX1BQSV9EVklS
IHJlZ2lzdGVyLg0KPiA+ICsgKi8NCj4gPiAraW50IHZnaWNfdjVfc2V0X3BwaV9kdmkoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1MzIgaXJxLCBib29sIGR2aSkNCj4gPiArew0KPiA+ICsJc3RydWN0
IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYgPSAmdmNwdS0NCj4gPiA+YXJjaC52Z2ljX2NwdS52Z2lj
X3Y1Ow0KPiA+ICsJdTMyIHBwaSA9IEZJRUxEX0dFVChHSUNWNV9IV0lSUV9JRCwgaXJxKTsNCj4g
PiArCXVuc2lnbmVkIGxvbmcgKnA7DQo+ID4gKw0KPiA+ICsJcCA9ICh1bnNpZ25lZCBsb25nICop
JmNwdV9pZi0+dmdpY19wcGlfZHZpcltwcGkgLyA2NF07DQo+ID4gKwlfX2Fzc2lnbl9iaXQocHBp
ICUgNjQsIHAsIGR2aSk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+
ID4gwqB2b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqB7DQo+
ID4gwqAJc3RydWN0IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYgPSAmdmNwdS0NCj4gPiA+YXJjaC52
Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBpbmRleCAxMDA1ZmY1
ZjM2MjM1Li42MmU1OGZkZjYxMWQzIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBAQCAt
NTc3LDEyICs1NzcsMjIgQEAgc3RhdGljIGludCBrdm1fdmdpY19tYXBfaXJxKHN0cnVjdCBrdm1f
dmNwdQ0KPiA+ICp2Y3B1LCBzdHJ1Y3QgdmdpY19pcnEgKmlycSwNCj4gPiDCoAlpcnEtPmhvc3Rf
aXJxID0gaG9zdF9pcnE7DQo+ID4gwqAJaXJxLT5od2ludGlkID0gZGF0YS0+aHdpcnE7DQo+ID4g
wqAJaXJxLT5vcHMgPSBvcHM7DQo+ID4gKw0KPiA+ICsJaWYgKHZnaWNfaXNfdjUodmNwdS0+a3Zt
KSAmJg0KPiA+ICsJwqDCoMKgIF9faXJxX2lzX3BwaShLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUs
IGlycS0+aW50aWQpKQ0KPiA+ICsJCWlycS0+ZGlyZWN0bHlfaW5qZWN0ZWQgPQ0KPiA+ICF2Z2lj
X3Y1X3NldF9wcGlfZHZpKHZjcHUsIGlycS0+aHdpbnRpZCwNCj4gPiArCQkJCQkJCcKgwqDCoMKg
wqANCj4gPiB0cnVlKTsNCj4gPiArDQo+IA0KPiBIdWguIEEgY291cGxlIG9mIHRoaW5ncyBoZXJl
Og0KPiANCj4gLSB1bmRlciB3aGF0IGNvbmRpdGlvbnMgd291bGQgaXJxLT5kaXJlY3RseV9pbmpl
Y3RlZCBub3QgYmUgc2V0IHRvDQo+IMKgIHRydWUgZm9yIGEgUFBJPyBUaGF0IGNhbiBuZXZlciBo
YXBwZW4gaGVyZSBBRkFJQ1QuDQoNCklmIHdlJ3JlIG1hcHBpbmcgYSBQUEkgZm9yIGEgR0lDdjUg
Z3Vlc3QsIHRoZW4gd2UgYWx3YXlzIHdhbnQgdG8NCmRpcmVjdGx5IGluamVjdCBpdCAoY2F2ZWF0
OiB0aGlzIG1pZ2h0IGNoYW5nZSBhIGJpdCB3aGVuIHdlIGdldCB0byBOViwNCmJ1dCBmb3Igbm93
IHRoaXMgaG9sZHMpLiBPdGhlcndpc2UsIHdlIGRvbid0IHdhbnQgdG8gc2V0IHVwIERWSSBhdCBh
bGwNCmFzIHRoZSBQUEkgaXMgc29mdHdhcmUgZHJpdmVuLg0KDQpUaGUgZGlyZWN0bHlfaW5qZWN0
ZWQgZmxhZyBjYW4gYmUgZHJvcHBlZCBhbHRvZ3RoZXIgYXQgdGhpcyBwb2ludC4gSXQNCmRvZXNu
J3QgZG8gYW55dGhpbmcgdXNlZnVsLCBzbyBJJ3ZlIGRvbmUgdGhhdCB0b28uDQoNCj4gDQo+IC0g
d2UgaGF2ZSBwZXItSVJRIG9wZXJhdGlvbnMsIGFuZCBQUElzIGRvIGhhdmUgc3VjaCBvcHMgYXR0
YWNoZWQgdG8NCj4gwqAgdGhlbS4gV2h5IGNhbid0IHRoaXMgYmUgbW92ZWQgdG8gc3VjaCBhIGNh
bGxiYWNrPw0KDQpXZSBjYW4sIGFuZCBJJ3ZlIHJlLXdvcmtlZCB0aGlzIGNoYW5nZSB0byBkbyB0
aGF0IGluc3RlYWQuDQoNCj4gDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqB9DQo+ID4gwqANCj4g
PiDCoC8qIEBpcnEtPmlycV9sb2NrIG11c3QgYmUgaGVsZCAqLw0KPiA+IMKgc3RhdGljIGlubGlu
ZSB2b2lkIGt2bV92Z2ljX3VubWFwX2lycShzdHJ1Y3QgdmdpY19pcnEgKmlycSkNCj4gPiDCoHsN
Cj4gPiArCWlmIChpcnEtPmRpcmVjdGx5X2luamVjdGVkICYmIHZnaWNfaXNfdjUoaXJxLT50YXJn
ZXRfdmNwdS0NCj4gPiA+a3ZtKSkNCj4gPiArCQlXQVJOX09OKHZnaWNfdjVfc2V0X3BwaV9kdmko
aXJxLT50YXJnZXRfdmNwdSwgaXJxLQ0KPiA+ID5od2ludGlkLCBmYWxzZSkpOw0KPiA+ICsNCj4g
PiArCWlycS0+ZGlyZWN0bHlfaW5qZWN0ZWQgPSBmYWxzZTsNCj4gPiDCoAlpcnEtPmh3ID0gZmFs
c2U7DQo+ID4gwqAJaXJxLT5od2ludGlkID0gMDsNCj4gPiDCoAlpcnEtPm9wcyA9IE5VTEw7DQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMuaA0KPiA+IGluZGV4IDgxZDQ2NGQyNjUzNGYuLmQ3ZmU4NjdhMjdi
NjQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gPiArKysg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaA0KPiA+IEBAIC0zNjQsNiArMzY0LDcgQEAgdm9p
ZCB2Z2ljX2RlYnVnX2luaXQoc3RydWN0IGt2bSAqa3ZtKTsNCj4gPiDCoHZvaWQgdmdpY19kZWJ1
Z19kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSk7DQo+ID4gwqANCj4gPiDCoGludCB2Z2ljX3Y1X3By
b2JlKGNvbnN0IHN0cnVjdCBnaWNfa3ZtX2luZm8gKmluZm8pOw0KPiA+ICtpbnQgdmdpY192NV9z
ZXRfcHBpX2R2aShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBpcnEsIGJvb2wgZHZpKTsNCj4g
DQo+IERvaW5nIHRoZSBhYm92ZSB3b3VsZCBrZWVwIHRoZXNlIHRoaW5ncyBwcml2YXRlIHRvIHRo
ZSB2Z2ljLXY1DQo+IGltcGxlbWVudGF0aW9uLg0KDQpBZ3JlZWQuIFdlbGwsIG1vc3RseS4NCg0K
VGhlIGFyY2ggdGltZXIgd2FzIGEgYml0IG1vcmUgYXdrd2FyZCBhcyBpdCBhZGRzIGFuIGlycV9v
cCBpdHNlbGYsIHNvDQpJJ3ZlIGhhZCB0byBhZGQgc29tZSBjb2RlIHRoZXJlIGFscmVhZHkgdG8g
bWFrZSBzdXJlIHRoYXQgdGhlDQppcnFfcXVldWVfdW5sb2NrIGRvZXNuJ3QgZ2V0IGRyb3BwZWQg
d2hlbiB0aGUgYXJjaCB0aW1lciBkb2VzIHRoYXQuIFRoZQ0Kc2FtZSBhcHBsaWVzIGZvciBEVkkg
aWYgZG9pbmcgaXQgd2l0aCBhbiBpcnFfb3AuDQoNCnN0YXRpYyBzdHJ1Y3QgaXJxX29wcyBhcmNo
X3RpbWVyX2lycV9vcHNfdmdpY192NSA9IHsNCiAgICAgICAgLmdldF9pbnB1dF9sZXZlbCA9IGt2
bV9hcmNoX3RpbWVyX2dldF9pbnB1dF9sZXZlbCwNCiAgICAgICAgLnF1ZXVlX2lycV91bmxvY2sg
PSB2Z2ljX3Y1X3BwaV9xdWV1ZV9pcnFfdW5sb2NrLA0KICAgICAgICAuc2V0X2RpcmVjdF9pbmpl
Y3Rpb24gPSB2Z2ljX3Y1X3NldF9wcGlfZHZpLA0KfTsNCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4g
DQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANCg0K

