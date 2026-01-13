Return-Path: <kvm+bounces-67912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D53D16CDD
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A32B6301AB49
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337EB36AB63;
	Tue, 13 Jan 2026 06:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="CsxZI6Cb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4036AB4B;
	Tue, 13 Jan 2026 06:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768285207; cv=fail; b=JlAloRiZ9CgZKAEIFAzQMqPPIWQQAySbuuu/LeI8vvYi2WGTSJRP48hMTXGhrO2WgvOHx6pRdbvlucDwnBeaGLRdbZI+l8GJHbxLPnTc9GeWn362/oSuSBQHLlrCrW1KBNxd2W87iaUAip9spw21jSWj9X1O6pLyB5JbjBxvq/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768285207; c=relaxed/simple;
	bh=F4JYDbYuDtJ1E1W7oxTgdisg0ofaI39rn4/vdLvHQ0I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VTNA5OQQguPLY1+d8C50hJ4XCJd3kGtPUuWSuhHX+hEo1x6Xc8ozlvsI6lmdoorS2bRgDJ+QcP9BD53dmEz+OKQkC7E7RriBV0LwBYlhb0Tj5VLRCMcAW0Joj8obIgpgRUIEGvtT0sQCZh70tnTKBw1UCH2w+IzPDuNWaJGntx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=CsxZI6Cb; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D6INKY325821;
	Mon, 12 Jan 2026 22:19:54 -0800
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022107.outbound.protection.outlook.com [52.101.43.107])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4bngnq802j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 22:19:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJyOqd7roKL4bB8swO41jyBE0VbX/OfL18DhGNDs4gGRh/cGSinTwRnH+WXQRvYGkkAZTun+AphftRM+eoAReTwdpsC5yzG/2UPvCCjMJIE3XmxocyAQ7gIn2lCqbpoKVuvbIf0BjBaNoZwnyZ6KJejmhISIFKF1CRhxZvJ3CzSCJ6QX7yjgrB6nLbP3uE5ls3HxOgkp+zajYmoEUhodF2lv2rKNnrcQsh1kYFpycrqwwk57oxtmKG4dTr5mF2VBPNCGoFgook/1lUjtaQ8J21AFWGUnX+vX9TQRYk/WaHcZ3C3Su/uoTIiw02SrIcgUoWxqlA8B2BUD2Ox94FuVFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4JYDbYuDtJ1E1W7oxTgdisg0ofaI39rn4/vdLvHQ0I=;
 b=qVaOVfdsHJ4zcPJw8ypCDz0DRNTQit12WNPCqUVSXTUsMTIEOIz/rGrdQ+amlgZ7UPWKy+Fl3FpcVdWvTuk6l6ePqjwJC60PwuOiEnrqOtRQpucF5QmsKwBFidugF848SRew1gCO3JFpSkpNcB2kL1FtDeFBgb61X+whifF8hC0PGp+lvOce5w8fTg6Waid1m9lJlr2cVXB3ueumb9pTbvX6zSwuG7H6IvbPhJCgnjdfr/kFd3QzaNIde/a1RiJxfWx4Evp8cj/rm+DuNkMTzN9cyigABI31zWOjFKRWWx2mTmMo0KA1o5ZDi6XIxwR3R12p8pCUvP2djDSfbJeOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4JYDbYuDtJ1E1W7oxTgdisg0ofaI39rn4/vdLvHQ0I=;
 b=CsxZI6CbfaY6HE24qGo6iWngiIMon/Bf/5JLXXJ0W3t3HwIyTIZlxI0pZ/jgIppKZCmauYRabX2QhsWDgKvVEp7uWdAJwSAmkPU3f+JvAZEqP2Gcycq/VRtbHJAWFYBuMHHD8GeA6MrplRvtbfYzM7qgcqtpuwdevrVWJsymFVU=
Received: from DM4PR18MB4269.namprd18.prod.outlook.com (2603:10b6:5:394::18)
 by SJ0PR18MB5213.namprd18.prod.outlook.com (2603:10b6:a03:381::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 06:19:51 +0000
Received: from DM4PR18MB4269.namprd18.prod.outlook.com
 ([fe80::9796:166:30d:454a]) by DM4PR18MB4269.namprd18.prod.outlook.com
 ([fe80::9796:166:30d:454a%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 06:19:51 +0000
From: Shiva Shankar Kommula <kshankar@marvell.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jerin Jacob <jerinj@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: Re: [EXTERNAL] [PATCH] vhost: fix caching attributes of MMIO regions
 by setting them explicitly
Thread-Topic: [EXTERNAL] [PATCH] vhost: fix caching attributes of MMIO regions
 by setting them explicitly
Thread-Index: AQHce7UIItncUIS6dU6cL1NVseOYirVPsZCA
Date: Tue, 13 Jan 2026 06:19:51 +0000
Message-ID: <ECE065A9-1556-4525-A478-62343C6FB477@marvell.com>
References: <20260102065703.656255-1-kshankar@marvell.com>
In-Reply-To: <20260102065703.656255-1-kshankar@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.600.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR18MB4269:EE_|SJ0PR18MB5213:EE_
x-ms-office365-filtering-correlation-id: b0c71b2e-014e-4064-20db-08de526bc2a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?UqFzpz0uCHscW1U0YXX/TThUiCKc9LyTYXb/yPcezuyPoYZuzou+Umz6S4qY?=
 =?us-ascii?Q?Ht+7gnoHFWoAq0eMV6U2bv9JFwghxH/WDvR64l0Lr/tORXz7zAI6jYDA+eaQ?=
 =?us-ascii?Q?Ce9bm3L0E4Vv8mMpGXRlK5rchM5ftSltGIm1U6t6Ydr3JOcXzBtgEdYrA/mw?=
 =?us-ascii?Q?SJLIhOJaAEB/DID/Kb28ylUPwrBisXNpRZHV0URjPjVYBHVQ8USkXJCOW/4e?=
 =?us-ascii?Q?9E0yVS5hnebHJvCtlGyYlhcO/SSj85ZnLtdG0O5gG3sqzfbIld6qOqDkM+H/?=
 =?us-ascii?Q?pf15rnJP00AQGk9FtxqRYindTcCboNhc9uCJrvhOewL+cywMsGuIOEvMqCcc?=
 =?us-ascii?Q?1VohoH4PEQhoQx35UMlXscJBEj2bRAQ0wdb323DSQd0rcUmCdNy4vSoKca7W?=
 =?us-ascii?Q?su1zVZhGNbspVszdeCYu75135ouMfcKC/sdqJAOXteh7LMK1mfqnQnSvRqF3?=
 =?us-ascii?Q?9ZqGclheOYvO8Us9KwKtedlvUEWCLpnGO4Xohyf7GSeGnSlz2t2Y/fXoJBYe?=
 =?us-ascii?Q?5Lle8v0s3KmjXvGbNOK9R2hdgOkCixaD3I+N0P7lms8756dydXnesbYBbawu?=
 =?us-ascii?Q?IvVEAdx/CuiXjPpQFvaqiGpGeQQocoFwHVGxRPGwjmvhGkpAGOPg1l50L9ew?=
 =?us-ascii?Q?vP1GMNFw5LGbWNrWC+7fi5hIsPxrQQx4FqpeMiiOX39v6KzvIy2h+r6aSTDB?=
 =?us-ascii?Q?Ozo1l+S+58SgE4Bk4HmhP4PYWZsD3i8IxqGAoa2Y1/SLtCK/LeU7m5TmJZRg?=
 =?us-ascii?Q?QjvaiLu+cHQ52FsD8pFQPX8Djhcj4p7adcZuszZCUz/iKT99T+4w/8eELiuH?=
 =?us-ascii?Q?Qq+6zejHjHU//yxRwC+TYfEpB/NGi0OUPUzUWft9BbYS4Fyy97mzbdc2goN0?=
 =?us-ascii?Q?eSSE9gRE3NTp7MLKKv8kvMlCxvQLAeg9SBV+0kpELRLNNhs5Zp/0c13Wbmi/?=
 =?us-ascii?Q?i8zIoVszbrI7j4hsRGUdyPqhkKLVbQDntJnQgmNkRUS7oeeA+mVRxvVJcVao?=
 =?us-ascii?Q?2b1WqOniKy9jKBAgOTcHf4m4RVJbKYXdCFUogyK87hXmpyqH8FiCYE91y7Ar?=
 =?us-ascii?Q?Ux602fECBbNMVADgh/hQPdXeqvSg80JqoAjgcga1xfYMm2tX5bfjxdLVHlAN?=
 =?us-ascii?Q?9Uf9VSFVuW5n5tNVfn9zyYvUQd9TdbxfAhfFWNYHi9sDMPMCp975Zt32rwlB?=
 =?us-ascii?Q?GSASjqnS9LT8bpYJ1lgInwkGIitz9R3kHc5hf7jFyAnADuWCzGN9V4PSFRnN?=
 =?us-ascii?Q?WoQSdcZZhKzqtoKPTp1KqHvNezfqQU+efRICrbQQ9OJju29Fhu2y/Ddy9oiQ?=
 =?us-ascii?Q?OyayhTcUXNL1xZwdZXLXSMfvf/lUqY5c3MoNUmE2NW6jpmWJNAeUOIQ3y+/F?=
 =?us-ascii?Q?Oc/+Zpp5kenSCgve6ngaUSm+C3Fh9L862rTIjugUdQg0v4JZagOHm8jiadnb?=
 =?us-ascii?Q?EKrI4gpzXOIIhnNf5DewPYCFO63kiAQe+62zyLcVWScCfm6yswwU7+fjXT63?=
 =?us-ascii?Q?i2WZces4RSarazgydFnuQboKXQTog2HLVosL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB4269.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TOVPVgcPv0L+uGYoEb1ETwPGtHjJdYdFVb+H0ZehQsl6otIF4TmxoGI0HS5R?=
 =?us-ascii?Q?32xoeDTEUZSwrTAxNSLqoM4BIwn2aAZH5c3ZaF252pj02e8c8FVTTxLoyVMG?=
 =?us-ascii?Q?DQ1HOUfAzgfoJf6fm7bNAdhc45LOrL+Ikv1S5RDm5vqJpC9IPY/XLCFy39Na?=
 =?us-ascii?Q?bmEI5JmF7m//ABWCeZ/9FxVJInTEZLlg7xDRW+OgZbUGWJzvX9omqLMyU9MY?=
 =?us-ascii?Q?yuvI00Y/m6VaPpAxyBu9MvVVGN7NWyqM2Ve8o23/VH2p0I5dhe/cvvkNzYCK?=
 =?us-ascii?Q?6wMIFPOw4YEEsRLAlN4aT842J1XaXOb/gTxux3G6uXmgQDOz6WzDFOgATdUp?=
 =?us-ascii?Q?h127owBza3MXb4dhpwo9TpVrJXIlvfq4+lKo4/ghPRgdqM1/exVdW6svJih8?=
 =?us-ascii?Q?YR3KlCnfwf9XkHndTVZe/dhH7a7MZdKavZJ2ycMI+B8tQotnHvVrGnQXw/1f?=
 =?us-ascii?Q?UwTTos5sO6EtualxGy/BunL1ps+Lut8kbKuQcyFSZXI8pNd1lSgI57SR/wn+?=
 =?us-ascii?Q?al6YnjiQpEqVbdCOjgNdKzh6fOkpjhvTrinrFLn6wSwKXqy/3QLIsm1QmKPd?=
 =?us-ascii?Q?Pe2j1RB+9eLqR9uhcyOvQHpHmD28sGDqN+yg5cFXFx8P4wMuULl1hHs4OyMc?=
 =?us-ascii?Q?CU9vHzMOyKx2qiGttHsDhqE/xIulEXtj9NeNl1SVyoKCzZaIiIxBJtPv0sL7?=
 =?us-ascii?Q?ACuKdZMnCt9pLx7qVmoEnhJ3yAJ8YXcxj1IElukFMOYb2pVqDHNwBbZ+GmcG?=
 =?us-ascii?Q?7U7U7LO7inHarPXUq0p3ao3QfRXkI50xvbEdV9VKUMydICKkc3Na2IP1yZLe?=
 =?us-ascii?Q?p6/Ni/1Ev2ZZPj05F0Yo6esWQ6HP0i2n1L8UrCZqblvbTssHHkRjuc3XML+P?=
 =?us-ascii?Q?EzWKl4nU/ay5s76CYrU+QfJaDBx3KahlqXJJSj3Gn18Ro1BTH383maEe/Zbx?=
 =?us-ascii?Q?C8bjq5Avn4xlDim0Wu4T2BghjUo6LypUMRQgFjU2g9pYpRPfmO5iak6swJ1q?=
 =?us-ascii?Q?rFLxgYtaP23VcLz/fh74tMNBxniqgazCgDshaatRsc90N2REChmYV6jpmHXs?=
 =?us-ascii?Q?b3TYPiyLQiCKLbkig9LEeSM1/XWSE5HY3e60aao64j3XUsnZY/mI2XeDMdaA?=
 =?us-ascii?Q?IRQ8EjxnkuJMRmeqqZ0vfItJApeVVXD6fpc9+Glbac/eIRckh3FGTtdPA9pS?=
 =?us-ascii?Q?hZ1RdEec8KDiPahTOzyKzl595NMHmg6oV1umD6X1fby8cUDe6yRCNhOKRzsk?=
 =?us-ascii?Q?tIbEApikCrXENkyx1M0XZ3StMGrQ8XsC5AVsWuq7KXdulT2sXdW0xB04i9G5?=
 =?us-ascii?Q?4e06IGV/gcetsfvizL/vEMXW5Z9qOoD3v6oSug1uK4TgZ+WWE3ttiOdBihyc?=
 =?us-ascii?Q?Vk3BJaXlZJGNLp8rQMCdD1qJudNyMqBUX7oqz5jDx8aW7T71Y1TU8GSQFn1i?=
 =?us-ascii?Q?bS9ACPDuszPB09nqFnyrx/K73KgXqsfYB5QJagAPoEntsRVE9wZWtnTzmjEc?=
 =?us-ascii?Q?z1EVhY7nke3lQPFpsWDKdtgllpmd4M+jSmgdjFxKhzWjLOEM5v0R3gxFkDyk?=
 =?us-ascii?Q?x6ZbH2SGNGn+jwss9qigVXOUKr79j0UtGtI1CJfpfKj4GKctdk3fpJZZatd5?=
 =?us-ascii?Q?y3J9C7nbbCaaezbOO/FedpYYd3s+XV9n2DoocfqosGb4EYJaNnD1cJaYMz5Q?=
 =?us-ascii?Q?4B7XlepuayZ2JVW7sNrCETgWNdJUgev+aJknNPgAkKnfWz0YLdCOtAhghpmB?=
 =?us-ascii?Q?2HrxLird2Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DACC71CC02521498F00DF9729FFF151@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB4269.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c71b2e-014e-4064-20db-08de526bc2a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 06:19:51.3429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OHylkZ4cNx/+oa0ml9ABXAkj9VvEo9UjamBqCwGlZrV1O7jzkO50wj/ny5TnuMeqD8TcAoNskY30Lb3/FoAiHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB5213
X-Authority-Analysis: v=2.4 cv=DLeCIiNb c=1 sm=1 tr=0 ts=6965e40a cx=c_pps
 a=sUbwXUxkMQNSWKNRO95rnw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=20KFwNOVAAAA:8 a=-EP0ZEmctIjLeFn3QbIA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 6KcMf4VJVleEfBZy_LxSdixmxdOd_xP2
X-Proofpoint-ORIG-GUID: 6KcMf4VJVleEfBZy_LxSdixmxdOd_xP2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA1MCBTYWx0ZWRfXzhvDcatB9ioh
 7oAtAhLWkn1YpXGAin2qsWzYCL9qg6iCRJNLftanyHkZ3gCuI0eiq+C8XC64A38t9egSObnEbpM
 gFuiPVfEz8XZXzpyvpezQa3w3HM0Dt78Ceowzh7KttQG1ppzKwrAoY+bpXM6YPY0JIrDHcZCwji
 N6T1Bkr7/zYsE0u4LwUruSg0NrvH7E7vaV5MFULuLx8wXRuAiTPw3qtPE4GV2IxHxf/xWgXJAKE
 CTfTu6uNiGZg7lZpNkLV2Tw0vyZiQlUtMbXA8+sho3A/FiCPE+wyMFxXSfVfdp20oi/I/HSIQv6
 wxy7HIh7Yc8U8R9CLK9RRo6wvYK886gy/gMBv2Tpx1zOIMcS+/d8nN78IKXIsVCgq5zDuq6/24P
 aex8L9iPPUXa1AJZcKT/6hcrau8SCOS9t1hrh0kEC0auC6o/cT2370miiUFHyI8B9KdYsaPCcW2
 hCV93zofqntZjWEjWYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01

Hi Michael,=20
Just a ping on this patch. Would appreciate your review when you get a chan=
ce.

Thanks


> On 2 Jan 2026, at 12:27, Kommula Shiva Shankar <kshankar@marvell.com> wro=
te:
>=20
> Prioritize security for external emails:
> Confirm sender and content safety before clicking links or opening attach=
ments
> Report Suspicious
> Explicitly set non-cached caching attributes for MMIO regions.
> Default write-back mode can cause CPU to cache device memory,
> causing invalid reads and unpredictable behavior.
>=20
> Invalid read and write issues were observed on ARM64 when mapping the
> notification area to userspace via mmap.
>=20
> Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> Originally sent to net-next, now redirected to vhost tree
> per Jason Wang's suggestion.=20
>=20
> drivers/vhost/vdpa.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 05a481e4c385..b0179e8567ab 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struc=
t vm_area_struct *vma)
> if (vma->vm_end - vma->vm_start !=3D notify.size)
> return -ENOTSUPP;
>=20
> + vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> vma->vm_ops =3D &vhost_vdpa_vm_ops;
> return 0;
> --=20
> 2.48.1
>=20
>=20
>=20
>=20


