Return-Path: <kvm+bounces-68960-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJ7BHA1yc2lNvwAAu9opvQ
	(envelope-from <kvm+bounces-68960-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:05:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 09834761E0
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F866302F7E6
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 13:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03312F39BE;
	Fri, 23 Jan 2026 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uNcUsTbr";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xcVknuvL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB921D5B0;
	Fri, 23 Jan 2026 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769173507; cv=fail; b=dwWSKwscmKiPlvWJ0opFiEvkTSe6tpk9AwDE+hR4IUXTj7lZtz+cPo9/aqhP4RApJQYGyEG8zxJzQhOPufv2zmJiIVC6UNPS3yjOdRQMtDyHUdzHg2UEzwVqbyCRvLmitdo/u+P16/6971ZlGbEefaEKvrjsBxVLOIQXg6Y16TI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769173507; c=relaxed/simple;
	bh=VE2RzK2rF3FVbyi8nAu53Kt+t4bEVRVsf8ZCdgvZfcU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q8dglZmeA/o4VuzRo+pC1fYl/rtAVIG5aNYpUb9mRksDYD9AEuw3zjLoc4r63ICDQgbC5NKSbhsHxMFcV7IHdZCRPDn1RzyumYHJyiB2n6JS1zR7KUsmBcp/cwvMoWfKcfMd4s/uh0RBOebqgXKL1ew/DUCHv5McIr4/Uq1DZ3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uNcUsTbr; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xcVknuvL; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N9V808937669;
	Fri, 23 Jan 2026 05:04:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=VE2RzK2rF3FVbyi8nAu53Kt+t4bEVRVsf8ZCdgvZf
	cU=; b=uNcUsTbrPOsbQx2ZmtjNN1k2iydFKtZ/1vrOXtqQy3AlwnZyacPVM5yLJ
	qEyxFQPjJrmaD2ZqAWi/dSpLMGI0NM2J1ujcMiPywhs4uDn/eo6nR7j+8JqA2tmb
	5aVj5pNLoeQchj6/uQQja0ZMHLFaEbvBOuGcqCn/C9VDLJm/z3b/5xUFqXWWFnTi
	IWvSzXBH7l3xUQimfe8QOnaD9nyLrXrN/EVWCx9uTKmA5onWDnurxtUVA5WcE6ei
	sYxM+f0ZUDsIO+Bin5z+FQP/aWapBD0lsl+iS0gyMp+wDA05B+Ix2+yR1z+pyRhD
	CvcxH3eGHEdP9yAyYF/MT4S+ZM9eg==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020119.outbound.protection.outlook.com [52.101.85.119])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bu9k8vre1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 05:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHnmokB7M9JcRcp/l+Ya3rwt99Z7f1hx5jgPuFuWIa6BU+MXqcdOBTyJmt4ErBvO1hZItV1ABwH/+6pfA8yljg2IngXwofgzWvNsv8yFAARhwrdP2w3IOsTC09OuwRnO24wBiZVaFbybYu3cdtXuR7HrrWcGInjCi5PAS/tvXgGP9kvCwPvT3uY4ZBsM3hOCE8mOaRwEC79EX0a9s76/lf4JgDPWTQ8Kml9tq5ntiWllvlXkPeEfhefXipsHb3bCj81IerC/JAejHu2+8HASTkh6iLffcWVeBIbpUvp3xiKG6jwhwiGCWQF2U16mo1/MgIInnmnE1lkJIPOHsuS7yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VE2RzK2rF3FVbyi8nAu53Kt+t4bEVRVsf8ZCdgvZfcU=;
 b=t3DjV3VPAgm3DBYWQRxl1tbGJ5udnBm19SE7zxuoH3mYHzPNWnepa/zPnZKyak1Ub5UUSugdqQRgE6G1gzKvqlSJhnen7Xwu2QHHGEXY54sKkraFl592jXto7xwNfeWNj/YVlb04DJYDv124MaO0P360aGtQ/qdLC+poljoQUZAZn5c6Up9HFd+QehTbaYLpVi6vtqgQ0LJlMvl9oFQWLSPHzfrZsPru4R/vU7lhSb5qYhcJxf6o4D2iPcwOZ/KBUgkWYVbapzDhBl1znkDTUOhE17d5muzJeoYHbNEuTVU9Ru0VY6b9s0ml1WfuMtFfIFpL6n/xsUeBjhUbHueKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VE2RzK2rF3FVbyi8nAu53Kt+t4bEVRVsf8ZCdgvZfcU=;
 b=xcVknuvLODn5f/SJfTzIQWrHyoBbLY76TSblLcF9qCPIL8RC6o0ZJ+xzn9CM3IywrQjuL8Mpu6w8VCdWfcY1OYWtJS33IOd9ttolFCGR+cLTOLpumzJEer91/TjZxPOFTnX9kiYh61lSxc3KnzaPndCFDnjYN5JiheFFWXiWAAmNzPQiB0fM38i3noLQLAQ1x33nt2rlRIJmF3v573pyk8hvSNRaaATOr8tbJPXMXBRuSZol78QAktKZ0RGu6dlQpZJR8enZcR61JsEcGDbqlVKQrtaayyPQpIV+4q9lLB0Vj8+hYPXEG6zDNX7ga96QQKzx5gSTIFMiK9OnfX6A9w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH0PR02MB8073.namprd02.prod.outlook.com (2603:10b6:610:106::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 13:04:28 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 13:04:28 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Topic: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Index:
 AQHceLTCGUfuM4IR+kesh1yecA5IOrU/Ft+AgA7r6QCAAuAqAIADuPAAgAAQ+YCAAH5gAIAKtOwA
Date: Fri, 23 Jan 2026 13:04:28 +0000
Message-ID: <407789CC-EA8B-4365-B6B7-AAD62138324D@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-2-khushit.shah@nutanix.com>
 <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
 <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
 <aWbe8Iut90J0tI1Q@google.com>
 <cda9df77baa12272da735e739e132b2ac272cf9d.camel@infradead.org>
 <E19BAC02-F4E4-4F66-A85D-A0D12D355E23@nutanix.com>
 <aWp2kjvTFAw1wPt6@google.com>
In-Reply-To: <aWp2kjvTFAw1wPt6@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH0PR02MB8073:EE_
x-ms-office365-filtering-correlation-id: db306216-84e7-44fd-99a6-08de5a7ff143
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?N6uCBAIjwSrjcBZg/75lTfIIA+v8dV1DJhQf+y9hYTJvdSC4o81EfAAqzpWV?=
 =?us-ascii?Q?4cwJy0xoMarMuiohGODwbK6ZY5svHN/W8pJBMbJA5cuh3w1vwY9EIIAjK2hM?=
 =?us-ascii?Q?OPobaxWuYpRPkJYhgczFieUtOGnXKsPXyptEJH1OFYb6WuDRIge0BQjHVJro?=
 =?us-ascii?Q?WpVRUKdK4DkT4oiElcdq3p4RhkYUfpb81BmylNOphddLW1NAFdeTYYT/Dcuv?=
 =?us-ascii?Q?oKuIrb/cemBogT/e5QsL09Uv39k15J8Ss1WSAfeBJ7mkyJ1O6tmBk5M4XF3q?=
 =?us-ascii?Q?+TROmZHfa+pKb4ibURLKERc8sjvfOo3N4v+cHpbwisnuqGZFPd5Ih5N/fes9?=
 =?us-ascii?Q?Kz31S95+oEonaCPceb9XZsdqMwsSwb9G34SQ9tHpvVsjRH9dT0GdXLrmL94Y?=
 =?us-ascii?Q?sd1Rj7AeeXY9Ro+5gh6YA4Refff+XzbXMbsItbInkJnhDnAF+xI6fGVzgF1d?=
 =?us-ascii?Q?HGmpE/kDET9hM4/G7B+W4yEF88mbNWMd9nUVKs+EKI/wxnodFdyHmh6OBrPQ?=
 =?us-ascii?Q?alaHtIFjHLYbzOAh1K3vvn+4KJAyOdCGAAmoy4yDjImorrtY1RwG/X27kJ0f?=
 =?us-ascii?Q?JiGjviQCqWwjxHxFdZEc1baKb1/yCuXj9jYu4qbDsfdTAthOBwoQ8Z/TRoEB?=
 =?us-ascii?Q?HQcdcnxoA+zEU70LpWlhDMAcsJR4eY7Zz1rV1AWxvYK2Ao1pFGRs7X4uGGpb?=
 =?us-ascii?Q?AN2FswK1y3zYpN9oUvXQ52/gc52vkYHiQChjWeK0+raJfBPXUTyaXh31NWmW?=
 =?us-ascii?Q?HPqumCLkrdCkkU6mMS/V/tRgq3VwS/6na/1mErm0KVysvCS23PAXwKdYq+xR?=
 =?us-ascii?Q?tgx16n9jvQwL+B5V+3GNsqqqQfYjxLOgCTh1MjPmI8G3PpNSjU2TAwNeScMS?=
 =?us-ascii?Q?H6QlVE4hd5UKOU8w9aabWhj4Lh/gGkl/NFi1FkNkpIqXUb6Zpk2jHlh0q2YZ?=
 =?us-ascii?Q?qsrBYpWGNWGU+SBbcB61yXYNl9PK3r6O+ctjXwyVNTFCwGLkOHGRjg1vJY6w?=
 =?us-ascii?Q?kVvZRj4YWsnH6oNCXXjeiyHGjm5MImAMZ8ngBOQ8rhMxa4eyP4ISaomrG+So?=
 =?us-ascii?Q?LCPgqdoG1ppXaAA0YEDEwnb+T7vcmdnZplsBWwi40/iaF2S2R4vyCWUelY8n?=
 =?us-ascii?Q?bobsQRW/ipxcKtSXA3sp3cNVvfq5xBKaU5Fpj/EZwNVDM00hiQE+0iNardMB?=
 =?us-ascii?Q?02vdrHOx5+jvwEw7uSohBOEpwnuaQPXWlQiY1fAcZFD49uYLOAvRDsByqbZt?=
 =?us-ascii?Q?skEZ9z8u0pmMIZ2WWaR0mPuZ9feMzW425ke3dYhuwUy+jxH0buR01zx7U5Ar?=
 =?us-ascii?Q?l4EnzaMvfmKWepQi2wYqsY2HrAgQcXXB9AB7wxApOiOjwU1zWpYgX4mTElsE?=
 =?us-ascii?Q?BKHuc+eDDkR4qzmIu2Kg6koB0iPCJEhajWADWmzRu8s3gf4EFQb3NzynIXDi?=
 =?us-ascii?Q?fls9SomvdvfGK5CiSIuh4rqEIiGlu+GqACOR4PMw3gK8wLtTPDzEBZQLfCqD?=
 =?us-ascii?Q?NbF5lCnAYVXerTv+9x66mljReLqBEHDcRlimG1wijoHfN8q8l1xzRzzdjXFF?=
 =?us-ascii?Q?KK1EPut9OsiWJ7THSo5Cqx5mmFf3HAAmvJjGrlb5SYjcTNjlU5Kf94mG6N0i?=
 =?us-ascii?Q?HnlR9DIZAVLf91sE0aHIiEE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4DFzI39bzbrVtoZtnhrk1avu4tvvzrmzXQ5Qfqh9rd6Nwg05iNjYWXI6HUWi?=
 =?us-ascii?Q?2hRmSCt/iBXojrZxtTZ3VW8PFmIYnxGDb2cKHTpmHwiUHTsbmpDWfgaQrnaq?=
 =?us-ascii?Q?LZ0ZCiAk4OoLK7D/SjLCV849u4RboPtaudRfxwcXvtPLumSKMu4VOuQuzf72?=
 =?us-ascii?Q?bXxXrtRKnMQfuFcByUg4Bgc/t5abTRq6exxQzamaQcLAzT2xT7wvTyBFQIRQ?=
 =?us-ascii?Q?TuJsb4BqPz0eAvf9rESZLF8Tzds7Ep2wd2l0/dRU50D+YPtzDM7uW5DlNf64?=
 =?us-ascii?Q?LGBOOYHIeew1r67NXQvTTEpoiS5ynEblmLcnROY4FNS2CQG4B8nyPWabDehg?=
 =?us-ascii?Q?w+xe7HgZWUWvd1Bb0wW+BiqEhYVE85+SFsja9dYnaZxkK0vcC4rkOdqzj5ne?=
 =?us-ascii?Q?fgpuE9oVrLG3ktQlRG/gGZVI6DDG+eaBE05kRPpcAVfzQUR5BYgPhxMj/oP9?=
 =?us-ascii?Q?xxPXwsczRgahOk35FpINR8oIBT1vkkNxah/34eYJihNYRjc9E0gnrVwlIaja?=
 =?us-ascii?Q?9bsrvB5wpCeQ16rWnMzUJ8vyLQ0JLLvul1Xj+5j3tT/83d6oEkJeiPC2N2Pz?=
 =?us-ascii?Q?4lsrpyvVWeEqw1fwijrMcdS6l57OPq/x8Uicy2/y0hHytlYESDA/ksL35AEF?=
 =?us-ascii?Q?hZccGDBtqZ7ZZ4eO6gQtF+DDadiPjYr4Rj56j8Jicmt552PE2bHsK+cMfwIc?=
 =?us-ascii?Q?jWSBjkcIiMqs7PYLiaLTHbpfdTsVzbwODWtBPPf5RtJQ7xigm8XBt9i5mWWD?=
 =?us-ascii?Q?c0BGYedti6rGDBfhgZL8Aq3abQ88SWPm03IxDxl96iqggkm2wQkIC/PksU7n?=
 =?us-ascii?Q?WxkWDfJVV/gkoxQFemUChiUp/54Z2BStSBXmM6cIx3PGhiyiSgKOSDqUUIXZ?=
 =?us-ascii?Q?H2IMOfF/4MuqzCWmeEdjxJB5O4SR1Ba0nsPkyZvbCNaO0MDJ8gECmjOZKwRJ?=
 =?us-ascii?Q?YMtCeXtUYZCLhaMscZGNeVSWAF5EgUh5sCOz17s1c/AMf7PRfR5IzcmXs3/n?=
 =?us-ascii?Q?+x0sS6bkrHVcefp7A3C4HBrOYYmeF9dxvZyjV0uUwOLOi/1Xu76kpYPmaSpx?=
 =?us-ascii?Q?7+71t8GifVA8L9zWhYZ7WBQp4LTPkjwRwJ+2LuZhWafDMkJTgp2gqWBMICK6?=
 =?us-ascii?Q?Ej47F2YGNey7DNRoFxbKirNpp22LnrBhS3dbyB/k+IPCspQylEGPb+LJPP42?=
 =?us-ascii?Q?oIl6fkHpQRVrqKjs+gQFKKBfOjp0P09f135AHgw0dcfiwFfyGjEqdKXn71os?=
 =?us-ascii?Q?HRXWW/S568RoYv9XAdtLG1NPvgwItSiN+V1kmm4T17PMmP/FIRIZRWjSeKMb?=
 =?us-ascii?Q?P0qKQZKK7XLH2D14i4SqUjO4zxAfjE3N9L0BkIFeG+hk3GovA4Fe8HzTaR7S?=
 =?us-ascii?Q?mgHO2PWCBcSXQX1RquMo5whawW70NLebuylUMwnJrh5CVdidoZVJhVLfwaIj?=
 =?us-ascii?Q?B+2adeyL89fmXimKeKcT8KhTGTyv1lqFG4ktW0iajXR7BIR0jTCaggmdeWlT?=
 =?us-ascii?Q?jpZGV/z/s0wwe+FkLNemtcipfqNW825PD9tNkTGpax0KFkqNQNV7OdMWqBUY?=
 =?us-ascii?Q?NvZDMq3XAdHM1RRiETfvYZEfK2RD9346IJmbmjUo2Xp23fqGJxAeO/f4O3Fu?=
 =?us-ascii?Q?Ps+e91xOpynk3SyXS2LWEn/hNjU/oXbXPP3EK6jAWRuIjWvbaWCHPGfkgRR/?=
 =?us-ascii?Q?awsBulAhp120wnVvLn/ZT97SrwzNtmVGYQZEO6BgXwzKA6FMu4jC5CBJCj83?=
 =?us-ascii?Q?xRc5gtvfaxkbd/8bnke9gPd+7W293uU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF48ED3906183C439FFC282405A07F7F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db306216-84e7-44fd-99a6-08de5a7ff143
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2026 13:04:28.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mnOKcEJUYXapwTRbKBWyRWPwXQAcY5hSGTmnwhSymuA+BQz5VjoZfPrs39zP4U1OAC3ERVDYqKTwXFjYJtCzRKxuqXVoFo8qS3xfajS1z0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8073
X-Proofpoint-ORIG-GUID: WtfcckD2aljgUZF1qPGX8eaOUaIOBP4s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwNyBTYWx0ZWRfX7SyMSZ8stfWq
 2lN6zJEOYf0B8a5MyobNoccddLosrTHGWqCvtMoblk+6CM+umOs7EuhAuW3vtkPFadBJa+agGJF
 LRcm5Qj+k6i/pz/IhnBobbf04aW4YhnbwOD7zqzeM/a1wWScj7h7kkG9GusP/KgC/7D1oJd0J6B
 nPG03J3GgzxU6dwBZU9Qhx5+b8wbw2jZ3aPKbVjCefWPjOOkkE+kZpYiIqb/1oXcmHKKJuMrlqh
 Bvr0Fgp5Ri88m8BCKuzqdvXNVCBUuhN/pWwx2JUyGy3aA5o3VsMrEnLZIZ0rq6OPg6uSmrY3jbT
 AyqO2Z3+W+HtCe7tz2ekY2xFlNlAv7g6Cf1M3yd7uRE86U8eqJNHv7j/UV6+QyuMYSURwJs2NbC
 O3C1ngQa7FkRfP/2HaESF36gGx1WtEFKlg6bjBVxMmxEnePdu4aBDz3jSTzp3vzfNxk9xPKbgXo
 ajfeLOzIzT0eop8t0BA==
X-Authority-Analysis: v=2.4 cv=fOA0HJae c=1 sm=1 tr=0 ts=697371df cx=c_pps
 a=S/VVeZWp6p+cRv86h7uDVQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=x1NHfmnI_Lj0fn9DdbwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: WtfcckD2aljgUZF1qPGX8eaOUaIOBP4s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68960-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nutanix.com:mid,nutanix.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 09834761E0
X-Rspamd-Action: no action

Tested the patch and works as expected. Sent v6.

