Return-Path: <kvm+bounces-40997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F91A60223
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 894A37AF15F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0831F4297;
	Thu, 13 Mar 2025 20:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ekv+SRGJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pqQRgUwe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D021FC7E3;
	Thu, 13 Mar 2025 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896651; cv=fail; b=DTqqdx2Pk2ZpOS16yg5gQopRafD+9ZucEBTU4h7DNbPIHUjP1bm26ipfydt/dPoEc+9NCyY6iaq5shDvL8NN30XDeNg4WqJqeAnQIsQw8dyA3uJQGimYGDnEln5mLxTDy2FJQJKi2zlJSPC++XUoXuO+JAMQJmzZdvAXGQkTPfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896651; c=relaxed/simple;
	bh=RzTRW//xaqZiADtxuFGyP0llT7yWXLLas08daaVMdgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AHeFmK/GpOyVMmNx5NZRriX+iVoOG6vHOnrH0cElZNzEuo7/EXBUX1pZGFqP7BaohuwqZxEWeRpW6ChOsa0T5+2+e4uBuZeNN8mOVDlMrw9tLHg4AgHs48+v7RJPv4GcDJJ7MSXdQHxxgvDAFbQeaPTVjR+cMmfuvtJzYKcMrlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ekv+SRGJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pqQRgUwe; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEsNcd016578;
	Thu, 13 Mar 2025 13:10:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=I86e5Uucm/Q6TM2A1Ol2oS/LkxrtOS9Y5NR+b5s9P
	A0=; b=ekv+SRGJ3GX8YWlvjMSy8v+aKBqgXn4WWQJWwqGi1blHGpV8W7M+vmTES
	TY+Hpw9HmUkMZyBgCv0rqvHuSnVK//rr9BSQqHnU18V9wjZ+runYJlLeZ2D34UuT
	BDv2vCGxHUkeV/HQiKJqZHIuKl3WLmCPaD1uBnjtTyr7Uui1IyxMP8OQEdP5TV9S
	Tyo1NpLbIzUdbFqfMzLlnOmIdRPaEM06p0dE5vBQQKJN6/xvp2sMFWjNmyy+wmpT
	CDbUFYpH7yTwfCNvqvdZZExzy7Iqi6vdzoSCdqamq8E8+AJwRzgUdM5ogPj8fZNb
	SgOEJyvtFn8irdNa38xanNmnRNIdQ==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3oTU71K0bWtvRRUmLgQpdbRkegYAF/aG8v/DpqNKYWkCmIYPi6m3Mkj5omxlUI8aqNtQutSs/kTUBiJ9huJ98vmvP0ZUvTyVf4MnQYSxkx4t8lnRP9T4MnXLnSI2r6RDls9i3p+IHbtEQGnpcsJhwqU0Rfyx2W0Doilf71sJhdNtHF/22Ald9WVZn4A55+Vo+6oG9qLBaESzAeHLgbzrQrccgTXD54JQ6OKkqXNW6hNMv+MK7QlRX0ntAdYKrqBzverLZmYz64w1xcgP8GuRuaLVDgs7MIUZb+cV7dr6LoJF7oqpNzSN4HyikfF4erWxDHmJjLeNsHeylS+GiAQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I86e5Uucm/Q6TM2A1Ol2oS/LkxrtOS9Y5NR+b5s9PA0=;
 b=BkMxh297eLLvjslqLDZWcX5wymCjh1aTnF/7iglmBllKyyffN4ZPocEehoAhN8nCxhnY41grhCzd9aDaWww1nG/Rkdcp1OnWtoJnsgBePcSeOtuceacrkXZXZgD76NddNTjXs8PIKXn8yvj+Uw3etcLUwVorI1sSNvxqeOsIPRhCLKeoUepWPsmICxjBVo6pS7bzj/VCTR8tJGq0XqeDcHCS1xScM3dAcqQlLxVl5+2rsX+1xg9Fqnz3EdpKc1D+4YCbqUr2jL7lOJf18gRzeqiFlZ2s68dLf4Lp1aBEmjjkBloaBTi9CF190DjI+YAo+MnEnVDpsfyFEr0Eb5nHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I86e5Uucm/Q6TM2A1Ol2oS/LkxrtOS9Y5NR+b5s9PA0=;
 b=pqQRgUwege7Fe3NuudYkKfQi1qgcKHkBMYyiP018CekxgEer17djdKK8Kg7hdg533jWv8FU76uPYe4GvpHFVsn0D+I2JsnGxVRZj0yOdYJtZgFIYCpRBtqRqo/UjstsJVSpgbUWsAwnevN+vskrkXJC90HDvqD6lvimdp7oZxs8a5wkBi+KPXGWLpkMe0xPgtVJQUNjC6OZg1hvPFHc2BIhSl9BPhqxZ3/ZWK/xziOBdvVeViIa+L3r8Aqcm8eYGlHrkL1Jozg5I6nVTMzWO2uIMnqbYB4TtnD1LqLcO150JMYwNDxnK9hLC13fXt/GWjz7hlQfzRfAiyXb3zMP63g==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:31 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: [RFC PATCH 12/18] KVM: x86/mmu: Introduce shadow_ux_mask
Date: Thu, 13 Mar 2025 13:36:51 -0700
Message-ID: <20250313203702.575156-13-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 3212e01a-3f70-4f26-4433-08dd626b1ad3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/5lQBZ9MQLX3BBiim4TjGpg7vfPnxA31su61AORJqJ1DOcwnZfNjQXhoXLni?=
 =?us-ascii?Q?5Cq8dYo09KrujHBS4dBbktYVuPLloxAtpz0APJ/srwuShH/skrHQuxIBoBCB?=
 =?us-ascii?Q?rWdrAKL4PDKETqxOqzVtmCWskTR3BazmhnK7BQ2qKe0WuEhmoq3qthGBJA90?=
 =?us-ascii?Q?dMcyuv6kHz4+nvqd9okHe2jPWFuc7kcmyNuv4K5E7aaCRoop4wgnUnGEpCz8?=
 =?us-ascii?Q?6CzFXG64B76c+w/PEvNYIZI3CqVpjbYNDYJH+6WLcY3hGIQEEMPbRzsvVI5M?=
 =?us-ascii?Q?gQKx3EkhT1He3TQ/eIAWbyiSWv8ZVmIMQvUkvbyMYEyvZ9xAMvbjVD4zWcx2?=
 =?us-ascii?Q?/H65BTMHA8MPemALyOhA+9Tgb5YjIgWjnZDwe5vmxXz4POjQXPyBfHiQM9ZY?=
 =?us-ascii?Q?/ZEs2KAZYk0IJdSDdRyyrvlX5ci2/HWA4cb235zVgp+XDtSk+e03Qkz9DAY7?=
 =?us-ascii?Q?IFm1222SFYlMvWkPWK/6ApVnm8To3Bt8fhvcmI712DlMZOL3bR/nn9+7WSOp?=
 =?us-ascii?Q?0x5bOayK7BO4L0mr4jcbdN2h0jh6V+qhdQJo2vYbTjM3x6uDcqEujQRjuTwD?=
 =?us-ascii?Q?1MdwpFr8xftNcPk029P4OT09mHvPJMb2YPHutrE/dSVaCKuxRnYMhMgkHfk3?=
 =?us-ascii?Q?mkaJX/FY57rA7pMvAY9VNtgqOTN1KpGUlAEMDCX6zsyOanHz6SZamKhV6iii?=
 =?us-ascii?Q?lrLXG3f9Oi7Rzuss7ToWnGIfY1JADsUuTGd5zRHXuQ+xlHlFadmfwl6cbD+P?=
 =?us-ascii?Q?zujpYQGnzJoVvibKTDQLnaGIwfhjDpP4VTCCEU0c2WARrBEwKNo80SSJ3NJ/?=
 =?us-ascii?Q?zdY7Ryv81Z4zqpvmFFH9qX2KcFk6F35lev3NN8/3CH11GFTh3MPQCVT83i61?=
 =?us-ascii?Q?TuKld2HXiQOKuR56PDwsph5aOQbtTA33Z6LxX/6bBoddfd69sXzqhJzxuXnE?=
 =?us-ascii?Q?f4SttijFLXJca5cxODp9PEedjJKQwzOCfNyuPUDmviehf7vydxW2r1Dtt48Y?=
 =?us-ascii?Q?FQ3cPOE9B0+PoacD1aEornlHEUw5VaDQGPgbZ6CMb2ye9F8o60nVozMdrj2X?=
 =?us-ascii?Q?Eo6k37c4rmwOfz1VHCcHJENl8uEvcsIDRv2EtRnmDLsfZgCXDQL0xFp90sN6?=
 =?us-ascii?Q?INMkQF6yHWxUpMQTOgTZjtl+1M2UinM6ua1CQJzaBQ2C8yv4Gicw7M9D0TC2?=
 =?us-ascii?Q?pP9rP6DqpwIzZ9VWgq17pYVtenT6yQQ94SUmk8AZZvZWIu74die2DGfZw1NJ?=
 =?us-ascii?Q?+N8jfXUlPUY1XDnWPlTPNJ5kL3U+BogzSPxTRhWzOoPztu3WA/hZbgjR2MlL?=
 =?us-ascii?Q?eO2/Rq4dy0+PJQyfCt/TKReth4utOoKUiMXrI/TeWnvE1+ZUTlUEj+fua/m/?=
 =?us-ascii?Q?ebWha9FmKvcaAJEyqK98cjd86DejhgPg4aNNnkaHKGP1QJUoeB5ki5YjPRHL?=
 =?us-ascii?Q?HYeSO6f3tamm6ohmEfGuh1tCxpm4j6On?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I7gBXapdAWap65Hqxe1gR8917s2BuRWGKLEOxb6gQ24jGP8AT+PN4tiZC8mp?=
 =?us-ascii?Q?O8nGRRYwG4eNFER2HOajn6BDNKsNh/X4sleemfTqlA+VTRJuatN7yA637oHi?=
 =?us-ascii?Q?F1hAZhmjUNxfXgYth39zHdBIJig2ONclppoTWM3u4DyhkJIrpn9+2o9Jkxa3?=
 =?us-ascii?Q?pqteJMTqnE1hI0BJToKcoNSdFO9ydUuxrT3I3reF5DcucvQ5Ku+YTvrWhZay?=
 =?us-ascii?Q?CfHojYIZ6J0wL/wYmObQBqs+g/Qbx5AvBu2ZAJjn+0nYT+jPuzOb4jZB1ryT?=
 =?us-ascii?Q?KeVM9rC7iUiQFSr/8JWJaX92aOFaRb+5TD3RNYEkbYyWLtrfSe1GTK6VugDi?=
 =?us-ascii?Q?gKNwtP8hJ240jQYix5Tj03JIznDlCQ4UnwBQg86/nA43Mg8KL4nEzba1Ao+j?=
 =?us-ascii?Q?+hBGndxl42sIDMOTz0OsLevm9o0lPKJmGKMpgQkT6W1zMZWvxKs2/bQ2issN?=
 =?us-ascii?Q?b+O/ewfMduxKtHqNgX6Pi7p4zdNS0ip0gAJMS9Di3EAvM7PkBtuncTklIxXv?=
 =?us-ascii?Q?CtYxQWjUqK6n3C3WbGkJj5+gqDn0YWNE98yTz95UWWnvZubBu7JHfpmjvRGE?=
 =?us-ascii?Q?78KAka3iwsRguV5gqjUE2Suk2YR7OKkQ/meK8uiEXnEPrz3aZE8A0lK2jdjs?=
 =?us-ascii?Q?iqlzGB0Kjg5QLBHa6XNESqTLUGtf39G2D8ZvqdnrXGSGfx/ILAjVqVOd42Ul?=
 =?us-ascii?Q?34EARdJUbJvro9s+6oKq9t73tYWcgQ8e8nVyKQfPW4j83n3pRtkY0kLTkZoz?=
 =?us-ascii?Q?Dwr5/uetNMOhZH2mlJHmx729BPpkkykaGGL8SU7KlJTzJhKkBxMI1GrLUpoH?=
 =?us-ascii?Q?fRceVjHAGuDujtJtixlQSlnttSfWBO0JpYPf0T+WXGb5KutV7y0syhL2a/vp?=
 =?us-ascii?Q?bmUrMHp5VY/xrCzpunDKw+j0cPyNh4giYyU1w3zPRmFoS+kVHON0+AVFVqhk?=
 =?us-ascii?Q?m0kdrmBSSKcWshcMENvjSQL3liXUdS/biAdlc0iqVUS6sG541pa4aAjJftg7?=
 =?us-ascii?Q?bwITRrFuWsFw58L3Iz5N9RdCC4GYZLUqiZypnFc9sJMTpojmkij88x7JFXeo?=
 =?us-ascii?Q?NY19snuztbHeWKiyPwaypOZXTjSEXqwUPYabBc2iIAMhqswKqH2TuSW3SCLi?=
 =?us-ascii?Q?JKsAf0lU0ucXBnAZ/lYuVz9mC3NsLcNiun25plTH1ChmYmi03E6uMf2LSQcG?=
 =?us-ascii?Q?n4Ff4K6BMFLM2w3YRish2C0QfSJrf8JFxTLluo1xnTeLkERukd97rebuZl0e?=
 =?us-ascii?Q?iiAzHzK3wqSRHExS8fksLz0M1sOSyXWuBKUepMzzleVJaYjFGXhajjdFX+f6?=
 =?us-ascii?Q?OpX0QN0JPmO2V2rysfYv0xWNyMgITHKBGLVeJ0ckHFxdle7v8EUPm8+SYv8n?=
 =?us-ascii?Q?CmCnxLG/kF5ZdLcZahsjw/iZet1DhxZgQfCXuaEEaRN3WxsxIYaLEBrImEH0?=
 =?us-ascii?Q?1GeObYSjUpRPURd2b8JVHVENiG/W0lHKisiLLsa+xyPIpsMXA7rjUt/q3waB?=
 =?us-ascii?Q?5HVM8GF9rg/BVPXGQ9xzPsssGz1gx5wZM1+tguPdKGrAiC7Y2zKXdNrfoTWf?=
 =?us-ascii?Q?OEM/7/GzYYQLpeCOX1CKZhh6I/gD1+iqCS2gmhs0C+n/m03PFCtounT4ojXY?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3212e01a-3f70-4f26-4433-08dd626b1ad3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:30.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFqRBmTDpiM53SB1b6q3o9x/DB+OWEQkP07epGIYeHfzCtaKMM+FUYAdbnfkapVjW9Y4iYKH8ut7G8wSy0bEQ70L9lzEvfSV6L5fnqeeQHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33bb8 cx=c_pps a=pa2+2WWV+ihErLhOOf7pAQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=pMcot3f0SDDGOCOdwIYA:9
X-Proofpoint-GUID: -0yDM6cav7DqkdzswiCZiJTrYLyQawlh
X-Proofpoint-ORIG-GUID: -0yDM6cav7DqkdzswiCZiJTrYLyQawlh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Add shadow_ux_mask to spte, to keep track of user executable pages
used by Intel MBEC.

Since masks are setup outside of vcpu creation, plumb in general
system level enablement from vmx code into kvm_mmu_set_ept_masks().

Signed-off-by: Jon Kohler <jon@nutanix.com>
Co-developed-by: Sergey Dyasli <sergey.dyasli@nutanix.com>
Signed-off-by: Sergey Dyasli <sergey.dyasli@nutanix.com>

---
 arch/x86/kvm/mmu.h      |  3 ++-
 arch/x86/kvm/mmu/spte.c | 21 ++++++++++++++++++---
 arch/x86/kvm/mmu/spte.h |  1 +
 arch/x86/kvm/vmx/vmx.c  |  3 ++-
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9dc5dd43ae7f..d10c37db7653 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -79,7 +79,8 @@ u8 kvm_mmu_get_max_tdp_level(void);
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
+			   bool has_guest_exec_ctrl);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8f7eb3ad88fc..6f4994b3e6d0 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -28,6 +28,7 @@ u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
 u64 __read_mostly shadow_nx_mask;
 u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
+u64 __read_mostly shadow_ux_mask;
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 u64 __read_mostly shadow_dirty_mask;
@@ -313,8 +314,14 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		 * the page executable as the NX hugepage mitigation no longer
 		 * applies.
 		 */
-		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm)) {
 			child_spte = make_spte_executable(child_spte);
+			// TODO: For LKML: switch to vcpu->arch.pt_guest_exec_control? up
+			// for suggestions on how best to toggle this.
+			if (enable_pt_guest_exec_control &&
+			    role.access & ACC_USER_EXEC_MASK)
+				child_spte |= shadow_ux_mask;
+		}
 	}
 
 	return child_spte;
@@ -326,7 +333,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 
 	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
-		shadow_user_mask | shadow_x_mask | shadow_me_value;
+		shadow_user_mask | shadow_x_mask | shadow_ux_mask | shadow_me_value;
 
 	if (ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED;
@@ -420,7 +427,8 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
 
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
+			   bool has_guest_exec_ctrl)
 {
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
@@ -428,8 +436,14 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
 	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
+	// For LKML Review:
+	// Do we need to modify shadow_present_mask in the MBEC case?
 	shadow_present_mask	=
 		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
+
+	shadow_ux_mask		=
+		has_guest_exec_ctrl ? VMX_EPT_USER_EXECUTABLE_MASK : 0ull;
+
 	/*
 	 * EPT overrides the host MTRRs, and so KVM must program the desired
 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
@@ -484,6 +498,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_dirty_mask	= PT_DIRTY_MASK;
 	shadow_nx_mask		= PT64_NX_MASK;
 	shadow_x_mask		= 0;
+	shadow_ux_mask		= 0;
 	shadow_present_mask	= PT_PRESENT_MASK;
 
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index d9e22133b6d0..dc2f0dc9c46e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -171,6 +171,7 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
+extern u64 __read_mostly shadow_ux_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
 extern u64 __read_mostly shadow_mmio_value;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0aadfa924045..d16e3f170258 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8544,7 +8544,8 @@ __init int vmx_hardware_setup(void)
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(),
+				      enable_pt_guest_exec_control);
 
 	/*
 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
-- 
2.43.0


