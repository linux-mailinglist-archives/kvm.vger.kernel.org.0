Return-Path: <kvm+bounces-72363-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPjSKXmEpWkeDAYAu9opvQ
	(envelope-from <kvm+bounces-72363-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:37:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D881D8B31
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BA2DB301BFB6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6C336F41A;
	Mon,  2 Mar 2026 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A/Y+0o4g";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QPETcwc1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E67836E469
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454906; cv=fail; b=Xn6AAigeuE8Y8OMTueXmj1ffHqquT21gwNr7CEXM7yOa4tVvowi9yahFuAR8rSoul2Sel/4iFo2rRLlTvG9LFNpMi9vqx4gJgSg5bCZVLInR+HeStNJBbRPzAKzF5YJ+mjxbSXk6ZauwagV9cnd8aDRDm8JIxhpao5vLRsQLad0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454906; c=relaxed/simple;
	bh=wvzhU+ncWUp6lGm+ZVjL22+rWq3A5bp+/DiAV8n4Ne0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CK8LAZtZMatKqvT/g315Tu0SU3GOJy8DtYKN+CwstAheYFUZnweK2drQJ2gCkqvq9lTpxvFVtx5eDtGQx4mOiMfECBEfwu7bPhqXjcN7if4o5TWnphJpXWTvDNdz1iEnHqQjfnF3U5eGZEqb8xFZLlrJGBb0D8aX7SiAVn+wcZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A/Y+0o4g; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QPETcwc1; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62299ajb2537987;
	Mon, 2 Mar 2026 04:28:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=eCbMfGHi+6Tx6BD5fIqyM7EaHQhe9lDzSVXOTmzaM
	ec=; b=A/Y+0o4gMuO666oUxrFRj7lu6bt+ezupHv8tQwBb+Q7XxL0nuMPuf741y
	5mi7pTuvKcVffrDKNw89R0EH/wOW6mv/ai7vqhm45c/cIuNRnHGjblihnoNVv5pg
	O/jiGXEWQmY5xXmKM6gNkD6hiS1hA/oqNHWPQ277dnuSSyNmrrSQBxPAcnE28ICp
	7tJb0Q7oCzBO6aVpA+D1javRnEpv31a0E+divxvBMlpfxCnjAPyxb91hjOWm6qsF
	sX8McknlDCGnzrx68wHt3SxsTOieaLrAQ8kmr0pegq93evRgtJCyF4N+lbWTgkTp
	E7zK5q6Emul/xTtagt/pvhWBf5+1Q==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020087.outbound.protection.outlook.com [52.101.61.87])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4cmww31p5d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 04:28:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=INR/Ar2w9EW/kUD/V40DLuH/HluB6KAYtQwUIb+aI1pH9XMbEBKsBC7OMm2ddiBmbNIRPxhRNgUacZyiPnXsxACJnyhTZPQDHd/+1hyTF1JbMzp0sVPH4CTBSEBrtF/wbSI1bdUg+A82GUlEHjiM4JvLP4psLDgyf6joPmYYhHliSWVT97GMvdELPbur4RCwmGHVx6sXdCaN1x6eg6VN9TC1+UMzIXXgYnCoiopVsOQglbNGDDAbbcJBgL9CE7aiW960uMnxOHGs5pASKFmxm6o3SUmL1oAnJnL+kO14VVXYfBwRqzOE364rm95paA4lUFjkK3WTCihiXRTL1XZ8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCbMfGHi+6Tx6BD5fIqyM7EaHQhe9lDzSVXOTmzaMec=;
 b=YbF7YxDsiBnJJRdpQzoirMLhRsR1WUsMseSoOZhTXaIjPFswyIPgBAvJH2hTjwtW8x0So9MJTk43Bqy4cs2kk1mKsp/bATfjCCFDV1dpjpkzXXt98OxuescY9bqF7bneSLI3eKL5hOMbn7nle7gdHbyForzR37upmpBdaDxzlHDqhNBlCD2dgN+tFdOokYpiYpr6mXdxhou7mIL4mwL/3GoBwbsARkpxdixPCsGFgYWc93GakyY608zU2i+7nZMPRXkqHza76WBJ+f0A5YN50gHo5WPSuEeFLRcqIewuHgt59f0SJKZHxMP7cZo44NDQC7rLbQPosEHBPwRgmT+d3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCbMfGHi+6Tx6BD5fIqyM7EaHQhe9lDzSVXOTmzaMec=;
 b=QPETcwc16/JasngtcUKjirWPIFKg+BEdwjLPP/8v0QPsSWHbJoPM1IbUTYCzfHVx4hSYFDDQIZr7eI2xsm+lfj024snnAjfdsIWNnuPpWXPHErzwCI7ft+nJUbfzwTamcl1s62hy3WG16dfGoKC9VdnQjal+7R4axHumvTeQgLkX5Pm8E4nWmqW0T7pUQnn9POuiftXAcMwhkuqPJikMYErhEymsAz/Lv0MTDENG8hqSErZc6c+qodXtVlvwYtXD8UBa7ylMU7hU8SnF3N+QetdWM19YkdC7uAwKO43KOwLnx4ohsqvr/3OQvGZ7jgiyafYioTT+7+KtNO996H6MqQ==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by BY5PR02MB6470.namprd02.prod.outlook.com (2603:10b6:a03:1dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 12:28:36 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%6]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 12:28:36 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        John Levon
	<john.levon@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thanos
 Makatos <thanos.makatos@nutanix.com>
Subject: [PATCH] KVM: optionally post write on ioeventfd write
Thread-Topic: [PATCH] KVM: optionally post write on ioeventfd write
Thread-Index: AQHcqkAXe3rjUQIbRkmgogOxullAQA==
Date: Mon, 2 Mar 2026 12:28:36 +0000
Message-ID: <20260302122826.2572-1-thanos.makatos@nutanix.com>
References: <aWakWRrEUeaIeVna@google.com>
In-Reply-To: <aWakWRrEUeaIeVna@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|BY5PR02MB6470:EE_
x-ms-office365-filtering-correlation-id: 08f8bf80-f852-4a13-4dd4-08de785739e6
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 xdc7HX1R4Gcg/ucK2YGxlfYkGKN3gL6VDwlk2MzfI0sNsm8wQREcqzEzsXhdkmYdA04TG58txgzxzSTkAS5TMM7RWgO6LJnzMRzi2zCdkR/VnkPl6WifkxCFcICtsM28T7gTxpP7snj0QdN4MkRHulneYHitKJ0zKxic4iBAYsZKCCZg6bOU1zEcCDoutP1GZi6GvWNe9ne01BoiFV+ZgkVeg7c7s79U5lMQlnVe7M//kGVv9By/rKlQdcqNjO9MG3bZExzyjanDprBoRM9A5ovnM5SnOLuYye148nKk/lGNhKWiv3Lg4CFtkgPBI/xzTIrclRrW6wJSISNbCheUR2dw6GaLmqRf82lODlMhHjMHAeHFDF8cUoLGXfr4idMFobpI1gXnh6BtU5fqAtdpqQMhtJoRWXRogHeH6RQ5yPjEHmPITmjfD7zC7ZJvXIozr8t6zeEQnz+9CftJkr3wdc10arQfi0lySPlDCxmdO/6Imc6oYYTBvItfMx161Ev06Mxyib2HpMmUuFoN4M53Q/57hnjLcbayxulVvyfo9oOKWsvyNmoy+C+E1nGuAzyJeQAkIrawDzHAlBqV5BQmPN3/7Sq0jU57tWLcyfAl3Rua7spAgtpCVg19l6njk8HqX0VG7aUNNAS7GTd7f7HC7qaSleMdVcK3wImOjuNumQbMokw6EswxEJCy/OuRRz/GLDI91vg6v3Fm4ecrT3AXXX0e27Z/UIkxzte+8YH5K34/3e+Korarw0fWt/0zvpLBkKjrBcggXhjeYWyih1fgC8AaEGS/qLi4bv+8KDeZ5R8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?tebIfsUTrWXB2wkgQXZ/PCQR5CicwMqnPo0oKisAda0HefqKYH7/w1Mba1?=
 =?iso-8859-1?Q?teHeGH4fFek1T2KBSzO/WGjxz80IW1tp0cvjyZDzH4Mx/S1OeXxxZt6M7a?=
 =?iso-8859-1?Q?+IKMLIxarUHZPGstIXpiEt/R4dh/9gMdLhzYUJO4MN3+tIGZZFgtR2KyZ6?=
 =?iso-8859-1?Q?E0l+XBM4YPP2X1QUDdaNiuCxDcomxIUZ6IVeW3C22UWNlz0K5+V7dB07hI?=
 =?iso-8859-1?Q?33j2KgkcnalxmJ3LbyLPYTjLJmbCnUTeJQerowC5Htxo3Q1SWvBwhmUnfy?=
 =?iso-8859-1?Q?w7Vd72TNzxaCHTDF3X2Vqp6vvUHqELxxN41pmClia/mar2AOyNRj+050qp?=
 =?iso-8859-1?Q?w6BtSigklJe390DVTUFP//56qtFfjeP/t1WXcugDuixwC3TU/XUEuahJNO?=
 =?iso-8859-1?Q?OEADbZsZbB+hRoXHsXfKyiLifPejlkKI7ThAutkp7+VZyPwRKjbdyiI1+k?=
 =?iso-8859-1?Q?ykDg3AjyKTm4XGsuxZkoH8Rmk6LyP1gF3/lAYHOmZqD//zWE3pYK9T4F3h?=
 =?iso-8859-1?Q?CJe7gRY1GUknJOKxsnu8FcW6dSLxdml7IRSVG/KKxAK3JNoi/XJDYjzy/K?=
 =?iso-8859-1?Q?zmzyjHSNRtfG4hk2O4qXYNGWnqqUHgu/Wtfe1LXa1+bu89/W1w2GYIVkCH?=
 =?iso-8859-1?Q?NYy0Zv52EytpqiP4BsG8alJgIT0NlJ5Q8c/ewyhOp9iRsyXlfZkeG7A1CI?=
 =?iso-8859-1?Q?k/TJRj26YWIXPuW8GJAhSn9vzg7qJzLcVNTIN5U5/twndMaQoQe7U34V+f?=
 =?iso-8859-1?Q?t67Oa3mPsHovYYvRBivHBDBRlnVaU/PKAR/HPNFhYEUoK02UlovB6qNukM?=
 =?iso-8859-1?Q?t7vvk9+QkZ5woZ9pu4fiPL19+oERy7n2MqO14tTvWMslCu6GU7BgfclVoy?=
 =?iso-8859-1?Q?KVwre0wSmxml5jmSOEmpeSou1M2zv/2pQs6DAgWNmrY92TCE3abv4o4LCh?=
 =?iso-8859-1?Q?JvzQIpWWzAqxktPNA7y1VcXFbjpxDZtuLFW943iwlsTaYEYE3Nn3kCoz3q?=
 =?iso-8859-1?Q?2JUVtFF0eBqq3fV4me6OuXjm/OFRvNGs9x1Vea6sAAPDiTCBO6dWEAD1fU?=
 =?iso-8859-1?Q?kDlpsrQpquEr7FJ69wFz6T9A2a36tkKnOH40CSDY/rlnFh0ra7tW9/0eiS?=
 =?iso-8859-1?Q?60Er5PD8FF+/U9ZLWIjvHOEsqkFgCSe2v5o4jZdpQYNxKzqtUBbgooNY+2?=
 =?iso-8859-1?Q?XvkHmC43btVra3HLUuvvw/Nm/s4wgoudB/PlCNsOI5exTupA5toN968ITS?=
 =?iso-8859-1?Q?nRU6wjGKasIXy5kMlywYZ996FVc8+gWyXdJtNX8c+Ni0id3BL21dP5V9TG?=
 =?iso-8859-1?Q?hM+JtX/h5DVKUHN2BlHkHpAw7zPOujyELG5upzL5nV/nIlK2RwmnMuew4d?=
 =?iso-8859-1?Q?P0Chs2fzRlJDAovnP/Ydi971PrrdCNkd/YDCUnj6qSoYEkLudeT38docZr?=
 =?iso-8859-1?Q?B6yfPm9qqoe9Wq5fiClQaUM1mfj8KrT0VjcmuPXpybL4w7wBYoB4UxcorM?=
 =?iso-8859-1?Q?CDdH2qvwXbDQ17f8tJ3pYj+hERsW/53Pf5IkVhxvllKUgp6pllrc4mkt2w?=
 =?iso-8859-1?Q?osmT3K0BRRqwZrCcoCRIX6HZgPu7/UUwBv272GCjMIG0aOJehOU6JrZCsv?=
 =?iso-8859-1?Q?0SRJfp1UG2zh7sC0K6znrPPeRbd3qly4vmTxFkc/yvToCp0C9aL/7HMzdE?=
 =?iso-8859-1?Q?svOIgAhMoowSnMZrs8RK344RDO2mIr5pHnVqLL4yZDBfkX+vOZd54+v71s?=
 =?iso-8859-1?Q?DVn36Dh3Wha/uOqgTsFxgd92t/GS3XQBsAz5IESTXoQSkDyl7c+p8t9laG?=
 =?iso-8859-1?Q?HwFKuYGKzvJaSqfZNgEcgtFIlJaApTE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB9321.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f8bf80-f852-4a13-4dd4-08de785739e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2026 12:28:36.1980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v3SCBR/BMl74h8dkhiDFnZAStj1DHj7r4pvjW++kwYy97mJYssY5xacq5izwfL0W/zFylUVjUJWjqxER1OG2crJhEpt47qQwdQmL9sFimNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6470
X-Proofpoint-GUID: QdT5n8GqMaYdRRuy8zYJQfmuPByVo3ao
X-Authority-Analysis: v=2.4 cv=XJA9iAhE c=1 sm=1 tr=0 ts=69a58277 cx=c_pps
 a=uUOONCeAppmmVOxUvBiRog==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=64Cc0HZtAAAA:8 a=hM3JnqHpDNmL83oqJAoA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-ORIG-GUID: QdT5n8GqMaYdRRuy8zYJQfmuPByVo3ao
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNSBTYWx0ZWRfX/saD8UfQhupu
 5ytK5baC4UlL4v8PHz/KXPud0GR5yw8zI+wtN9PsQBPyVFPmI2ijz9YbcrnuZVVFqnvwylQQ8qS
 UbHY8ME4ySsZorfGO599lpCF3a3evtfXBQ2p5OhaarMzP+QdkDn5Am+ak9zjZhryUzS94mk4+u2
 NQpIqTj4hsJHagwLif+R1MHpy5THxdo5swiR5X+M0hgk6KoY+/qgpkw4Mm8qy4rdkHr9ATJM3m1
 2tf7RHs/RTyzMUIgRCEql96thSLvvUZpFIT6bhqEqnJ8XncJ+vtAANSJqH+5rtHu76Qw328Ye3i
 YQjHtKMuBY8qXvKSCw5CMWPNx6mTPfUEM3j123nFXKyy5g5EKkBdAt+r/4R9HpRPpqUdZ6BgKEn
 Mx6rSZuo75uQ/JrXp5Oq1GcygfH+W1NFn0nLu8WGcGKk7xr0NPws93zabx9cCU+u4fUHh4yxbE7
 pd4ADHKOuLX407CCmEA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72363-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nutanix.com:mid,nutanix.com:dkim,nutanix.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thanos.makatos@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B0D881D8B31
X-Rspamd-Action: no action

This patch is a slightly different take on the ioregionfd mechanism=0A=
previously described here:=0A=
https://lore.kernel.org/all/88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@=
gmail.com/=0A=
=0A=
The goal of this new mechanism is to speed up doorbell writes on NVMe=0A=
controllers emulated outside of the VMM. Currently, a doorbell write to=0A=
an NVMe SQ tail doorbell requires returning from ioctl(KVM_RUN) and the=0A=
VMM communicating the event, along with the doorbell value, to the NVMe=0A=
controller emulation task.  With the shadow ioeventfd, the NVMe=0A=
emulation task is directly notified of the doorbell write and can find=0A=
the doorbell value in a known location, without the interference of the=0A=
VMM.=0A=
=0A=
Signed-off-by: Thanos Makatos <thanos.makatos@nutanix.com>=0A=
---=0A=
 include/uapi/linux/kvm.h       | 11 ++++++++++-=0A=
 tools/include/uapi/linux/kvm.h |  2 ++=0A=
 virt/kvm/eventfd.c             | 32 ++++++++++++++++++++++++++++++--=0A=
 3 files changed, 42 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h=0A=
index 65500f5db379..f3ff559de60d 100644=0A=
--- a/include/uapi/linux/kvm.h=0A=
+++ b/include/uapi/linux/kvm.h=0A=
@@ -639,6 +639,7 @@ enum {=0A=
 	kvm_ioeventfd_flag_nr_deassign,=0A=
 	kvm_ioeventfd_flag_nr_virtio_ccw_notify,=0A=
 	kvm_ioeventfd_flag_nr_fast_mmio,=0A=
+	kvm_ioevetnfd_flag_nr_post_write,=0A=
 	kvm_ioeventfd_flag_nr_max,=0A=
 };=0A=
 =0A=
@@ -648,6 +649,12 @@ enum {=0A=
 #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \=0A=
 	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)=0A=
 =0A=
+/*=0A=
+ * KVM does not provide any guarantees regarding read-after-write ordering=
 for=0A=
+ * such updates.=0A=
+ */=0A=
+#define KVM_IOEVENTFD_FLAG_POST_WRITE (1 << kvm_ioevetnfd_flag_nr_post_wri=
te)=0A=
+=0A=
 #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) -=
 1)=0A=
 =0A=
 struct kvm_ioeventfd {=0A=
@@ -656,8 +663,10 @@ struct kvm_ioeventfd {=0A=
 	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */=0A=
 	__s32 fd;=0A=
 	__u32 flags;=0A=
-	__u8  pad[36];=0A=
+	void __user *post_addr; /* address to write to if POST_WRITE is set */=0A=
+	__u8  pad[24];=0A=
 };=0A=
+_Static_assert(sizeof(struct kvm_ioeventfd) =3D=3D 1 << 6, "bad size");=0A=
 =0A=
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)=0A=
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)=0A=
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h=0A=
index dddb781b0507..1fb481c90b57 100644=0A=
--- a/tools/include/uapi/linux/kvm.h=0A=
+++ b/tools/include/uapi/linux/kvm.h=0A=
@@ -629,6 +629,7 @@ enum {=0A=
 	kvm_ioeventfd_flag_nr_deassign,=0A=
 	kvm_ioeventfd_flag_nr_virtio_ccw_notify,=0A=
 	kvm_ioeventfd_flag_nr_fast_mmio,=0A=
+	kvm_ioevetnfd_flag_nr_commit_write,=0A=
 	kvm_ioeventfd_flag_nr_max,=0A=
 };=0A=
 =0A=
@@ -637,6 +638,7 @@ enum {=0A=
 #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)=
=0A=
 #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \=0A=
 	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)=0A=
+#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit=
_write)=0A=
 =0A=
 #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) -=
 1)=0A=
 =0A=
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c=0A=
index 0e8b8a2c5b79..019cf3606aef 100644=0A=
--- a/virt/kvm/eventfd.c=0A=
+++ b/virt/kvm/eventfd.c=0A=
@@ -741,6 +741,7 @@ struct _ioeventfd {=0A=
 	struct kvm_io_device dev;=0A=
 	u8                   bus_idx;=0A=
 	bool                 wildcard;=0A=
+	void         __user *post_addr;=0A=
 };=0A=
 =0A=
 static inline struct _ioeventfd *=0A=
@@ -812,6 +813,9 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct kvm_io_de=
vice *this, gpa_t addr,=0A=
 	if (!ioeventfd_in_range(p, addr, len, val))=0A=
 		return -EOPNOTSUPP;=0A=
 =0A=
+	if (p->post_addr && len > 0 && __copy_to_user(p->post_addr, val, len))=0A=
+		return -EFAULT;=0A=
+=0A=
 	eventfd_signal(p->eventfd);=0A=
 	return 0;=0A=
 }=0A=
@@ -879,6 +883,27 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,=
=0A=
 		goto fail;=0A=
 	}=0A=
 =0A=
+	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE) {=0A=
+		/*=0A=
+		 * Although a NULL pointer it technically valid for userspace, it's=0A=
+		 * unlikely that any use case actually cares.=0A=
+		 */=0A=
+		if (!args->len || !args->post_addr ||=0A=
+			args->post_addr !=3D untagged_addr(args->post_addr) ||=0A=
+			!access_ok((void __user *)(unsigned long)args->post_addr, args->len)) {=
=0A=
+			ret =3D -EINVAL;=0A=
+			goto free_fail;=0A=
+		}=0A=
+		p->post_addr =3D args->post_addr;=0A=
+	} else if (!args->post_addr) {=0A=
+		/*=0A=
+		 * Ensure that post_addr isn't set without POST_WRITE to avoid accidenta=
l=0A=
+		 * userspace errors.=0A=
+		 */=0A=
+		ret =3D -EINVAL;=0A=
+		goto free_fail;=0A=
+	}=0A=
+=0A=
 	INIT_LIST_HEAD(&p->list);=0A=
 	p->addr    =3D args->addr;=0A=
 	p->bus_idx =3D bus_idx;=0A=
@@ -915,8 +940,8 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,=0A=
 =0A=
 unlock_fail:=0A=
 	mutex_unlock(&kvm->slots_lock);=0A=
+free_fail:=0A=
 	kfree(p);=0A=
-=0A=
 fail:=0A=
 	eventfd_ctx_put(eventfd);=0A=
 =0A=
@@ -932,12 +957,14 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_=
bus bus_idx,=0A=
 	struct kvm_io_bus	 *bus;=0A=
 	int                       ret =3D -ENOENT;=0A=
 	bool                      wildcard;=0A=
+	void              __user *post_addr;=0A=
 =0A=
 	eventfd =3D eventfd_ctx_fdget(args->fd);=0A=
 	if (IS_ERR(eventfd))=0A=
 		return PTR_ERR(eventfd);=0A=
 =0A=
 	wildcard =3D !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);=0A=
+	post_addr =3D args->post_addr;=0A=
 =0A=
 	mutex_lock(&kvm->slots_lock);=0A=
 =0A=
@@ -946,7 +973,8 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bu=
s bus_idx,=0A=
 		    p->eventfd !=3D eventfd  ||=0A=
 		    p->addr !=3D args->addr  ||=0A=
 		    p->length !=3D args->len ||=0A=
-		    p->wildcard !=3D wildcard)=0A=
+		    p->wildcard !=3D wildcard ||=0A=
+		    p->post_addr !=3D post_addr)=0A=
 			continue;=0A=
 =0A=
 		if (!p->wildcard && p->datamatch !=3D args->datamatch)=0A=
-- =0A=
2.47.3=0A=
=0A=

