Return-Path: <kvm+bounces-64534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3E5C86729
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 191304E9B28
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C95E318152;
	Tue, 25 Nov 2025 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MQaPQ6za";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TzA9drHt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E376A279918;
	Tue, 25 Nov 2025 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094004; cv=fail; b=RqMtG9j5DPR43GQKa5ol1Xo3fN4xlZDIUxSGB6Gg1jOYD9oOSvI7Ad4uZoq+m0DRi4nFEdiBj88E+KnVcntsywm7lPiKqXYG6qLPB8jpal98E6UgeFafH16urCPNfYQYkxDKFRuwqMZj7yOYbPH732F9jVZXobPSUCqpGZWXw60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094004; c=relaxed/simple;
	bh=Iyb+TK6zk41b9GQ9BSHTHJxFtDI5dP8D9ieRRvzTPII=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SnrwfMTJprYcaPau6a0NBQu2OpYfms7sM05I5bFV/AjC0DEebUGt9bzdRe3W1KmlwvWNGF43ufGOJF4A0MFZVEEEuikxs+5XzOKwU+gvvu6bK0iJapBqKJfnEzZYCGUdOiLKkWOh8kFvqLPSLmflWVGlQtOR03SFo4AUfI5bSZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MQaPQ6za; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TzA9drHt; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APGR3V84001981;
	Tue, 25 Nov 2025 10:06:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=zGASaX09Phw8W
	mb/Kyeyl0kxODpzmjngSBcVobY/kus=; b=MQaPQ6zaNZ5Q1JpmqSfUQuivUbCFi
	fhDNvX1rd312LnQevDX2liw7QnqkAx21ZaxZdKO+4W52cDdCtM8vnU2YN4/GnCjA
	nHz5BRrBrd4YOvd6goAkfJ5b0JUT/quqW/qBrqWuGdA8S0WjgBeQhaPOHYZhbOsa
	0tGpIS7EI12nDLy+Y3AVzz5gyWGeKJOcRRYmA4DfJ+WWnajxuViZbqSZvZURA665
	Zf/79eBfz9mbYGAzleHtk5l23z+l1YDGIZ/SB2aiyuv7PGQ0O/elTam5IZrPB9wr
	2yaGW6R22fZO5TjMsw0J0KFmZTDQ2f+daahKzxrqkR/HlECYebx3BIR6g==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021073.outbound.protection.outlook.com [52.101.62.73])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4amvetan5u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 10:06:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPiKWUNC1lwTEmfKV7kW4kAXwHrRiy6BO4p8AT/Ha/tLAH4o+2XJLboDp0g4LLZGON5UdZc2MUCeM89MpY9nMqAAuMGe1FNsFJr0LtDxtxxj9TOr/lDnB3hakpCcBNQytQ7xHGEtomnKdT/VRSmY/+2kDDY2uqyrWlA80xNnTfqEMD+xloIxTXs6Qt3ieQrGCsldTJ08O9Pwnc4K4ZDkwTcR1iynM8SGooQOaPut4qblZM1ZEqXxF8WOBqeJ5EXEw2vm7FkEuiVLuuVdKwKY2TwjYA9I+LVQyzjVVaK9vJaPXWauxDJiWSxEcFoVORynBCdUzBAGeut2B/aZkQu4EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGASaX09Phw8Wmb/Kyeyl0kxODpzmjngSBcVobY/kus=;
 b=zUePsOTAVqkrRyBatkJUgtrL+SOxrafl/b4U4G0ZQeM+dmnDqhs9p4hBuoBRvAa+nvN5bWF944zzoT4rY9z9dg5vZ0HIAmqurRjIuyPUh8oWFs0IHIvz20xc2a+e8zqSEHsboz2JEAOivVNxCrNEROFgfCtxfJwsM2l7eS/5ggxKB5ldEkcJxr1GVxFwPsOKul9wU3axj3LW+54J5QCydd1Yw93JNUyfwrcul2VwvtE6V/9h7Lzw6bd5vzUehKur/S3ywEBj4LcMJh5nHk4ybwAFY0RrmsoJxXjTu+30XsBSh7d9acqi8qKiZH+9C0bYT2hte0MtY9SU1JsM5y2a+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGASaX09Phw8Wmb/Kyeyl0kxODpzmjngSBcVobY/kus=;
 b=TzA9drHtnsbkvKqZDQycdmSEz7ynrt33S7toPR+IrD9LVbDVitUj34tHBITTdHzwvwrOgN0mK235IA9I9vDu55Bx2B0vxKc3GVPZQJJarEVsp0Y6IQuYNZSqA+mo5ke5jp7KelpeY0qS4GOfognteb3OGExgKrPV5RXUmlReWNgv4NTfZ6asUtoKY2if6KZd3x2syll4MzJ/FT5v59VYhTDl66+cWpynE9WEa2ZeTEAKVM5iVNvzqXUnFyJN20xyulIJNmZBb80Ggnqnx9EdnLsaO60rpxiiXUBapGQrXRkivMYu5WX6tepF3Zc4xu+5qKQHHKuKudsSYcPPI4PU1Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA3PR02MB10084.namprd02.prod.outlook.com (2603:10b6:806:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 18:06:02 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 18:06:02 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
Date: Tue, 25 Nov 2025 18:05:42 +0000
Message-ID: <20251125180557.2022311-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::32) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SA3PR02MB10084:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ff7888-b839-405f-65b8-08de2c4d4b57
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h9QqU06FFL6VUafS8IVYdw/PLxRFIkmuUvj/pb8xlZukeLi0NagkHKBPt8Si?=
 =?us-ascii?Q?g/hd2Gj0dazH5b7PdT+QWxo326IK1fdNpfkObFbWdpof5kldsnmBBRZGfBGK?=
 =?us-ascii?Q?ydQAb5HXHPpeZBRtNnbYeNTvdgZnVJPdmGD6/8982dZfc4ci4KjEFQmnq91g?=
 =?us-ascii?Q?BWYQX75FwcCIt3RFTPlGI56yo40Zy3QBaQ9eUqEBGBeEzynForLSR93iz0e5?=
 =?us-ascii?Q?YpY5xzW2MVV+r8F/yLzL8QANdZZNadwarivMkVTvXIjqkoYYrCAbthtsmLH3?=
 =?us-ascii?Q?3QGFbLVBoZf2HObqW4mEnDZWFN8wBsKocyeORNNVOpJjKtxNVTmIkzUEEcwR?=
 =?us-ascii?Q?g79utKoYnKYEbrlfKSRQUg8YjrK0CXKXag/s9NTEQ6oMZ+PTHiHF0dHKEAha?=
 =?us-ascii?Q?R90HO1rpa16wr6FuW/WYgy6OqLE2UBvTmO/TThNSh1XN3jsb1fKO6qc6H+OA?=
 =?us-ascii?Q?62EvEU36MMcG/ZyVuqg/wTFcuC+AKUgksI+oD0tvzEpgoLyBQlFV2b5uAmug?=
 =?us-ascii?Q?WMkmgKcTYQ/4QiTg+6qqH2jFWJxQyUW7ecH2ux/CEqldytaPL7MeBbdRnXc2?=
 =?us-ascii?Q?Iq0h/YxonL9EhLsqG7/t+5CkQR4gfqP/yNoOeE+ddnfScx7Yi4sKnUneD5Ct?=
 =?us-ascii?Q?s/nEAjnQRIpJmywH4zje1AQmK7vTCMyHSJcEaXW+EihfpzA97UdkFu3E3xR/?=
 =?us-ascii?Q?g9FXmJyga3OiUV46Ywvg4NrarnNfM/EoYbj2ZgYFLxq7qbP4bignOcT273lC?=
 =?us-ascii?Q?AT4KYAN3TwB7wgcpelwhnwXYzQhVmN/RWfjNgx7lzFhks03cUT6gIXJc0mBU?=
 =?us-ascii?Q?6YywuCfkOgWp/l+EvEFdLHR0sUD69YniDNDJT5Q1Rd6SMoG7qYqta/I9Q4oU?=
 =?us-ascii?Q?h8uG7mtWgm9i8rVL02+3OKFkwlcG6Z2dNNAzhB4atGjKguyGWopAVEMeAcXq?=
 =?us-ascii?Q?d/TW4sc5o/i212NLsIjhn9MVyERAXKb3wTx2KN1FMJkmYr6FvfGAV+EPiCwv?=
 =?us-ascii?Q?K1dYWcC9j44IHxAQ0EE3Qw2efyg2dlPsHT0TAZo91AE/J0N/DeEOecBcU4CE?=
 =?us-ascii?Q?7PG/hHqhafqvbNLksMGAFAdoqvlZlfzR7kcpRI8ka0IZi9CG5wvBK3kgl1Zh?=
 =?us-ascii?Q?XXUO14infU7U+K2RoEfpzkSrQA9LPFbKbLch9c52CzDuzmSXQbrYv523og0F?=
 =?us-ascii?Q?5wFxJLH3R17I5hB4PozMjflWA23gBNe3oB5ABEqrfhqv+ywb/IKyoLyr3TcL?=
 =?us-ascii?Q?7+u8C7IsJQdUCEiMeF3VmgkCt+AEhT04xEip7+EepXhsljmaQ0vmwhNNYGpM?=
 =?us-ascii?Q?VbcBuFD3VCkuPXTm6jT6fEV180gus7bV+iTMLGPlKvrQr9TlBL6OhWPSMFpY?=
 =?us-ascii?Q?ZYKGue2GESbph3GfRaa+UqOIUv3o//g2tKYuxs8q9XWi28xlqA2OewjzAYAS?=
 =?us-ascii?Q?AEU3TQKqS3PVHXxoX3UWmkuBlIlmufMePWX9dTUBjlib8GYcgDpKug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EIAIiEys+10ZVaBbZvv7BhncHuMCO7WYi+1T3Mz3Mf0VUVbYtm1FWgrgsK37?=
 =?us-ascii?Q?CFtJRDw60DUEKo2yhKWnr8p8YNPQdfGN1I6qeZIAe47k2GXT7kJGNe48sfZo?=
 =?us-ascii?Q?Igk035onqEZOAzBFKGIBuwSljwvMuJWEd6Rc7H74iu4LmkHTQze5cVQ9oAr0?=
 =?us-ascii?Q?Y+p1sd/plvP19c1E3ho6O/JyKCD0omXc3wkrPwqASbzETVdrvNmzsrBg9TzG?=
 =?us-ascii?Q?v3HHDnXf4el+B7pak5mQPA8I5tLZOhbzQF/nF0xv3s3rPAzZvyTYf5LDCGsH?=
 =?us-ascii?Q?Z9IUXnIpgWfEeHi/QuR/BKBClOAFrn7/aKEzsLqJBnYtdyh0df2UEPDx6lXP?=
 =?us-ascii?Q?HraAYiC7EinMU6wXsVk4E/vKE+CRTJ2Uhnh1pH5IQ9M9uU1+Tmp7TjizjYWD?=
 =?us-ascii?Q?u2GS7TZjO+YrBWFUWwqgf5Pn4fWWB6K3DHBGNLSPXhqQF0Cng1Q9HbDe6yM/?=
 =?us-ascii?Q?502cvTRtDtOmZyeyD90ccEtoMuJAk7KI9mbeAHQCjoVPcr8+oWVqskjHYT0o?=
 =?us-ascii?Q?QAH3SCQWHetACV7lDAVhlgnOXoc5PfkXAT3euxeGiy+fH3nVJjjcf1KTGb01?=
 =?us-ascii?Q?CrrztKu0c06c3kcCYFp1FJyVEkNpGW3wxVLtG6cJdYOa0rVCdGYf6r/6JdRv?=
 =?us-ascii?Q?m2M5D56wj2/bnF2jucN5TzHgH20K8yAufbxF9KKXzaBFp1CfuJTwTOBHWbPr?=
 =?us-ascii?Q?0BurP1o+HjYfvRLBNXQDrPrqFhpRoZdu4rFJSOoIg/KsVOX9r0PmKtc07Ed6?=
 =?us-ascii?Q?IaK7j6pY7b+JeWMcJCUrOBwwWMXuO3yR2PIt0OyXS8uoFP6Goq+3ow78MxxJ?=
 =?us-ascii?Q?FU0frAmsfxjb+481GKTqf3hnf8pA8OSb7yWU96OdQjkp9uurMs51yxHzq83P?=
 =?us-ascii?Q?3f3ylTkD0AtqwbR8+qs3pggdcIW/+QCnrQwewGlYHPi3pQQn4Tkz5VYNA6Nr?=
 =?us-ascii?Q?KVnqWQkvi+pL6x7OaU3gPFYCUyw1oot0J8BkC/oNzk7biYgGl52Fn2dASZEh?=
 =?us-ascii?Q?HXRvk4yg+Q2vlsmLTmrcPoE8JDjSY5xpGqPN3NtVnJtWc2rScAw/djMd/bY9?=
 =?us-ascii?Q?VGp4GgvPhb6E6RIqxyFkb+FgP0MfJu22p4WRF1s4CmVXMxueciUzp9zH6C3/?=
 =?us-ascii?Q?wnyA7G1udibwz7NGj+wqQKO8sfVE8XfBHL1s8hoJdJjLIMmAsrENNknoWOsQ?=
 =?us-ascii?Q?yeEx3+PsfZZS+mMXMb4CiDiav6zMmjBkFZIATF/p1Qjw8FOasxgc4oeFkHeE?=
 =?us-ascii?Q?VcW0sJEEAE9nClS5r37IFrAJKjxzaXI57djpuH/viK+77LbGpArpjEb41io3?=
 =?us-ascii?Q?Ueq76zT/W8rLLEBCyxOMvtGtUxTIPznbfEZqY9ihZe8rHQaSln9GOy1jSOaQ?=
 =?us-ascii?Q?80ijw36vzxylCaxMHnAtfbcWvcWwDBvI3I9lmXbzLxY8oAopXp3La7HF6B9L?=
 =?us-ascii?Q?Z+C44q1zTBq1RcJ0+09EparEYj+kdE/JYWwlf8JMWuuee8DXEmtXzfqxr/Zj?=
 =?us-ascii?Q?h8GJ6MnW2WFyMonAGxmV9Tzi1qAMg/z4HBXwqQzAfmJY+5CIz5vyNe4TkhIj?=
 =?us-ascii?Q?Gctvuec5nUILP+Z5hFacZL32oQCbeEwbZyJ8ZpwpKi7fujRvBxOSJXfitRTf?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ff7888-b839-405f-65b8-08de2c4d4b57
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 18:06:02.4151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2ttcRNSWPy61N5SJZcqXyeEO5oq31+zjTsov9HG1XjOgXDfdk5cGnE5Usn/UtCtjPFX7/BJxqR3MUGF0VLmSylrfRtgpTe7zp1JSEC51yE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB10084
X-Authority-Analysis: v=2.4 cv=OamVzxTY c=1 sm=1 tr=0 ts=6925f00c cx=c_pps
 a=A7BUKRKBnQHIc+bwMO6jVA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8
 a=9rnDWOd_n04SSkEilkoA:9
X-Proofpoint-GUID: N7mid3df713aLoCm7_IXrTYyECDBN98-
X-Proofpoint-ORIG-GUID: N7mid3df713aLoCm7_IXrTYyECDBN98-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE1MCBTYWx0ZWRfX4WghHI3Vn+CT
 7Fbv8D9MrkLyrUK+4/WhdKC7Db4X5zJ0SVnb48hhd65m7OmaxSsX+m8amgyg3TQmiU5v5JmoZ24
 d4BKLr/RgTX9V+iwgStL7U64j9oGWi77JxfyyXYUY5ibdOHpMe4gFk8s81HPVv4SCKN1amiB66/
 Ck2HLGALuCTpepjo417WPze0LynbzNHA4UIM4g5OQByIXsY+Jj9jgo3lb6MWsLXN1dBlz8uvSn5
 oKK9fwNKMPTr/BfHz7QWY24xP0TEaO5593CCvpG2oDtyL/D6vgIdS9m1V9Zwap50MBcDrFlV4BA
 F5DiLnonP7CyRG+goqxRtMzpxOrZUthxhk1HAyGTFsGofQJ4FKN8jp9SvAjOJEBi0007qst3rKi
 vB3c7rSqgsaSvhPrvN8XGfL9rIMLOQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts, which KVM completely mishandles.  When x2APIC
support was first added, KVM incorrectly advertised and "enabled" Suppress
EOI Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs.  Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the guest
relies on interrupts being masked in the I/O APIC until well after the
initial local APIC EOI.  E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace.  And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add two flags to allow userspace to choose exactly how to solve the
immediate issue, and in the long term to allow userspace to control the
virtual CPU model that is exposed to the guest (KVM should never have
enabled support for Suppress EOI Broadcast without a userspace opt-in).

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM.  But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
v3:
  - Resend with correct patch contents; v2 mail formatting was broken.
    No functional changes beyond the naming and grammar feedback from v1.

Testing:
I ran the tests with QEMU 9.1 and a 6.12 kernel with the patch applied.
- With an unmodified QEMU build, KVM's LAPIC SEOIB behavior remains unchanged.
- Invoking the x2APIC API with KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK
  correctly suppresses LAPIC -> IOAPIC EOI broadcasts (verified via KVM tracepoints).
- Invoking the x2APIC API with KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST
  results in SEOIB not being advertised to the guest, as expected (confirmed by
  checking the LAPIC LVR value inside the guest).

I'll send the corresponding QEMU-side patch shortly.
---
 Documentation/virt/kvm/api.rst  | 14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 ++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..4141d2bd8156 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already been created.
 
 Valid feature flags in args[0] are::
 
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                               (1ULL << 0)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                     (1ULL << 1)
+  #define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK (1ULL << 2)
+  #define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST              (1ULL << 3)
 
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7814,6 +7816,14 @@ as a broadcast even in x2APIC mode in order to support physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
 
+Setting KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK overrides
+KVM's quirky behavior of not actually suppressing EOI broadcasts for split IRQ
+chips when support for Suppress EOI Broadcasts is advertised to the guest.
+
+Setting KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise support
+to the guest and thus disallow enabling EOI broadcast suppression in SPIV.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..f6fdc0842c05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1480,6 +1480,8 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	bool disable_ignore_suppress_eoi_broadcast_quirk;
+	bool x2apic_disable_suppress_eoi_broadcast;
 
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..7255385b6d80 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -913,8 +913,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
 
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK (1ULL << 1)
+#define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK (1ULL << 2)
+#define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST (1ULL << 3)
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..cf8a2162872b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -562,6 +562,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	 * IOAPIC.
 	 */
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
+	    !vcpu->kvm->arch.x2apic_disable_suppress_eoi_broadcast &&
 	    !ioapic_in_kernel(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
@@ -1517,6 +1518,18 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/*
+		 * Don't exit to userspace if the guest has enabled Directed
+		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
+		 * APIC doesn't broadcast EOIs (the guest must EOI the target
+		 * I/O APIC(s) directly).  Ignore the suppression if userspace
+		 * has NOT disabled KVM's quirk (KVM advertised support for
+		 * Suppress EOI Broadcasts without actually suppressing EOIs).
+		 */
+		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+		    apic->vcpu->kvm->arch.disable_ignore_suppress_eoi_broadcast_quirk)
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..e1b6fe783615 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,11 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
+#define KVM_X2APIC_API_VALID_FLAGS	\
+	(KVM_X2APIC_API_USE_32BIT_IDS |	\
+	KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+	KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK |	\
+	KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -6782,7 +6785,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.x2apic_format = true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled = true;
-
+		if (cap->args[0] & KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK)
+			kvm->arch.disable_ignore_suppress_eoi_broadcast_quirk = true;
+		if (cap->args[0] & KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.x2apic_disable_suppress_eoi_broadcast = true;
 		r = 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-- 
2.39.3


