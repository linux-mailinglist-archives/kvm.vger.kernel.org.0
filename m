Return-Path: <kvm+bounces-40999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E96EFA60231
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24925178E87
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E781FE454;
	Thu, 13 Mar 2025 20:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zGly9/tx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Uu2+aB8r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73871FDA94;
	Thu, 13 Mar 2025 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896659; cv=fail; b=WjXlLKXKQbBSR21rqrdqQdy3pDhrGBe0RQN5aRWtwolNLw/asFsOxFnIxn+QCnLX1Ziy1Iv/OqO+J3i5ebwXY8Tlh9GAZDgVydNejswdP001RbgM6XrTEDaW/16WTBpAaLSDvA3HmDiUIoTukNNiMAIO8MzV6RBcUZjFbm5IS2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896659; c=relaxed/simple;
	bh=LbMldjcIPLDE/PZZerR8HoZSZS1QZSF40WISAquDiwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BQZtzV3nhwmh9gUyW7t1veDT9e4s0EjvvGzO/WsyfU2uUQIBKwH+E20DqvSv8gzbxUCVX1LWIBf6+NmalCFUE9jG8s3W4WAQf/9HXmbolvg+FtO58o8OaqT6JFMNDUQDWF/28HfxXT4eLlbYKj3Dhop4ceLONTJTuAmWAWK/sRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zGly9/tx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Uu2+aB8r; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGRKvv016613;
	Thu, 13 Mar 2025 13:10:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=KxBn2M+/lg4XVZjQzHxk25BYqORtM025d7S/MwhSw
	Ew=; b=zGly9/txi9SFapUdIMHMDtfDieErvpwLIQ7+4Fa/Hqw0a6NOYhTohOqLH
	MMjGHo73E/2I+qic00DNgCoYfQnTj4ov/mtutv0JrAcQqB8Enz1FUgxzPRdf36+l
	CIO/eBexKk1WNNqpRfEfd8dP8X7rST5cb2CPhRLFqZGagNa9T14o1jkXb3A2J75w
	W7nzuY1pCl8mlFoZVZZwf5s8sqBjwDlEreCXgOo7eof50EoNYnFDjSmMF8M2KQKr
	3GMYKfqLhKTSh6pBjdRvzrYpr7S/+9EkCTkSym706gFcBtKqMe/qLIZ7bOtbAzlE
	5sXRcd0lBLUeqmwF79bp/B0TvansQ==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dy6jIoEGPzQnyZz4BFJiu4y5EDda8o8M7uuRYo0ZrocIhq8gHUhM3HQZUVp8uZ37FHJbludnN4+1Yta4XnqTcwu+JEolNc/Pc2rhDS4vxPBrBDYwEcakD/LLSHd51TfjTlo+Vw530gdL3WzCp86m7xYE8ShJmHxmEzVeT+CpD3H23T8dgWGSln+DCxBsolKcU5859i+mfm3lFDisIbJkgaSRDhpW7v36sYFL8OU77IvRLDftMB/PVELcqvRbtf4Xpfeb2nx2F7lcpPinCWw9wmOd+Jn8qPdasXLUG/Zl37rCltzXocyU2KwL0U73QKAvNObV6tegeU85rMoisWy0bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxBn2M+/lg4XVZjQzHxk25BYqORtM025d7S/MwhSwEw=;
 b=WiYPxdEhJZLNq2dtNXmjoZ3ZZvKTMcjqi1l8dI/bvUYxw/0nO6ODYwmaLE6YN5RdNUdgO/E0y7ijSLCxRSre/WMXiVBP8dsErFMDCvMdzuaLGgb5x67mbndjP8w67zK8LeH9buDb3ZKjmwjUw6subO7b2aDMBsPEMvKKCQZeKXn7HBHsiMcPF3fsF6o29MoXWVk/u1z+iCtj7IdcakACr3ZvQPrZxEeeb/bU46zOBsEnPkTGGUjiWO/HNow1cy6/o/HrKQSeTtxBOQUcaMytQ8dwsAtbrrlHwQ8WmJy3vkKBst4eyFL+poehOZ2CjyqrC1+1tTCoDVY+EaukKpCW8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxBn2M+/lg4XVZjQzHxk25BYqORtM025d7S/MwhSwEw=;
 b=Uu2+aB8r5pGX1h0GWyzMLqA92oNZScmYQCGzgO+YnvpoeiOtv4VMjHpB41f5z+IeGk+3pPErLF6Tq2LkWSsnyYpFm4qlzW9s17+guX+DwS0xDdEKPlXsNC/uO+x/3ZnqHXzrrxiQgFZXYBphF8gmANVflNeFNVbldJFWC9kAnERfEbXYYGo7wVMBgypyD0Ysdzfn5P+eWSdCJpmb2Tln2+FAWYPojO3aUeLn+MHnCGBB+oX2+yV3YoEYtNfon23rbAT4qSXyjUrcPRC8oR6ZwTToGtpyLkL6D5SK3Gju8ATdPKNA1x5c7DXniQYd29xVipHqnfr2opSmzLHL69C4DA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:38 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:38 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand MBEC
Date: Thu, 13 Mar 2025 13:36:54 -0700
Message-ID: <20250313203702.575156-16-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3cfd85de-b0e2-4495-414d-08dd626b1f62
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LTXWoQ/y5yx0TUiOun5r74fUTK7WltBoEzh6KStRnYZJMsRmROgFE7dWWj2I?=
 =?us-ascii?Q?uayebJ3Cr2XrR27bL1Gx1UT+CqUS4rsWX+MPjTqvUH8sebjnuPaflXnngtPq?=
 =?us-ascii?Q?ttomBzAbb5+lHCWxSz8bwWqo+TYy55xWvJNieUNr5RlPJOfAyqYoGJG7TKix?=
 =?us-ascii?Q?ZcOCmR4lUi6norHFO1HqdipZgEMS8Ac91m6T/gECAbREKP7cuLoVMXdNCjnb?=
 =?us-ascii?Q?mBI/4N+dKKYKSkP5JfA0/NkSZwia/b9p3wUXoEWCTi305MowG0JLRrtOJ5/8?=
 =?us-ascii?Q?2uQ7WqVibm+dpOPmmM8rxOMyOzdN4HTiQH3sNc/z/QBdN35MYT3+FRH1A/Nu?=
 =?us-ascii?Q?1gZjguzp2T3fs0WvfLnd/hfnn2ZG2rDsTWy9pOhe5/c4TeU+TxqUHvqroNGl?=
 =?us-ascii?Q?6N1FVpsA1/eZzKgpXts3d+//G9B3sGH2gUBI8P5qXMxYQ4N0F55UQy5h4Qh7?=
 =?us-ascii?Q?sRj5luAX8jMzNkRHqSAZIY+ONRrJrxaOFcqYfbLjMNPEkhAu2re2udS3SDCT?=
 =?us-ascii?Q?Dvd1fF1sHFk7LJbQyanY721jS/ur3CYyQ2IYKlbUzTmukIQFBPA32Q3wdkjn?=
 =?us-ascii?Q?2+m3tvVLVmZnCGV67XLIEKfJNYZ4heqi6x/X1aFwt7YmeL+q3RKGI/HL8GwI?=
 =?us-ascii?Q?thDhN2M1mVT6iFvXFfqIVS+Bncvu3NzFJZWcrbh13nsTZ0Ind0aKHSJFKuEB?=
 =?us-ascii?Q?ixqmjEsR9pEmg1RO132lIsbNKQvBhvSKSlblfq9HNFdYmxMtPojyTcOANqVj?=
 =?us-ascii?Q?S700nKGEzYIrlwls65xKzn5OEDAUdakdGSAHkOTJg5vLSm9+1mU/i/2Plz3m?=
 =?us-ascii?Q?7r9btm/8vr2GvmLEx3kcDNj+nM1Tupse99L6Twl8Wiw5TgItIVAWS6Pdvxaw?=
 =?us-ascii?Q?2mwDXA5QFS7HUE32eFE9hePLhPJS6A6HIXSXHByfQlNB05pe+Pg/JCFQO4Tq?=
 =?us-ascii?Q?La5dF3yfJPuXtCnda4SSZp+G7lJwrSOrgYFbSXBeMPBzsb8CXxm7Fh8IQ2Eq?=
 =?us-ascii?Q?oRKII0mWngghXyfI20O1lB3EzYXhk20QuX2wVKannXqo47hpUbwpuVgBj/Ao?=
 =?us-ascii?Q?Clsxf+YfzNIr38Us2fxueVv0YSCj9vObYGHjZCqQ6zVAMe4z1CN5lBrM4Sxr?=
 =?us-ascii?Q?4N4s67alcUyCXfb2eEZeKOa21iSuWH00fo4/eqMOJ+yFIa4TepVq83fJgTsA?=
 =?us-ascii?Q?NSnWOTm1R/94jNiRVuR9mmIadHMIVZORs0oYpyZ95phML+NwCUa7eHzW+aeu?=
 =?us-ascii?Q?4RVIxTG0gFshUmfmI/CeC/gH7Qg5dEAG0THYzD27CjpTmaiHP0J+54Ero4pf?=
 =?us-ascii?Q?SKkkrOU/Ng+gkkYAsdZy5xyPrXWPy2mWWG0GOPudPWXyFUHO9JKv/0gnpfhS?=
 =?us-ascii?Q?coo/qnC67Sw2It2QD9TgLZsLWqhpAndSrgdJ5HHINBetuIEPe8QkE16qgsFZ?=
 =?us-ascii?Q?QZyRAzNESrtobHiIFpXIY1ffnnFeJA5S9hfL6L/tZK0DsK77s1raVQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gjXwWSR848k+Pfhy9DhR8Ow0/HjgDeJKdSkRHg4wr7y7FhdqCYyngWR1vMzW?=
 =?us-ascii?Q?xgwflvYIRjW4I+xomcXHnyOaPmRnmPcNaIjIBpjWxwUAvkMBl9PbVuDuABAB?=
 =?us-ascii?Q?pEkwYz2cLr9c5rNlMRIBHzc4AsqtC7dBc9Uie7t/o3Ypcp7ffT9UybTelH7P?=
 =?us-ascii?Q?d1FZDQCTI6aS6aoUHNZ3Qgowxr8yz5LyNgI2P7XAS0TTYf3uvIfrQ66KH7b0?=
 =?us-ascii?Q?44NyL9TGdzWSz5XR/0UOMtoLxHIt+9j4mFaVsV70ms/x04zZ8ya+UzdMvUf0?=
 =?us-ascii?Q?2N5a7KztwFtMsABdewUKvO9VxoGNpAGxi8IDdRmtRbdOriE0lIa3fqN7hqqn?=
 =?us-ascii?Q?UfzXkazXRiIbC3PWnK0aEX+vJFIo5cOTockictiAmcrkJtJcZF0RRlpx3qhW?=
 =?us-ascii?Q?F3BTeHhj3yIPaqfUa0iSSRp0EPr2Ez9QXf/O2MlMfzWb1E2BBJ0snsnxZAJB?=
 =?us-ascii?Q?vJpCVMTnTvf8hS1fFzDcOa1QS468d7j+FwxdfV358GqkI7niL7B4MYR7R0lD?=
 =?us-ascii?Q?m96HDAcK+6Eg40wd9IzXJAmByepbo84JgJiHy+XYky4Q275VBmV2dmcaPbX9?=
 =?us-ascii?Q?UlY2O22r6dMeRYjsKV3XYjIo5cescEMdHqMQNZEbJd+6BlOAUB1ISphGjktF?=
 =?us-ascii?Q?aoXK/NnRL/BZD4YlvT1Co+OyLiesQ7XxPi/8fxnTF+Sy+JlRQX75ptHo5C+x?=
 =?us-ascii?Q?gphkT4RYUpCOE0LNc9qOYu5203Q3+GnPw74CxQYdi/9MUp68ZdTAC/SaHqja?=
 =?us-ascii?Q?r1vF6kYgV9CYadlAI4zvE1TB6w4765L+sYMuFK3NceXLujtQahj8gZSUr9/U?=
 =?us-ascii?Q?PZCP/qOvvUaD64HWzNVdPJpEPFe2XyzN9z287p3Tg+jGmvbLM5KxT5juiKyC?=
 =?us-ascii?Q?RFW8eOACHLZc9xbcYWwOepTKKvfecwjJ26EqxygwbeVQgNK7yCUxZpoNaFy0?=
 =?us-ascii?Q?qCZSQTQ2jflwpd5LF7IB89/64UJwAAFJ7rXmKwU6gIFCeRuVmlfJS0Yoe8rf?=
 =?us-ascii?Q?foGzy7izPBisUuVgsqxAGqg/zWM4Wyc+z6NrGbQKvyAn0PnsRHPcPNlYKMIA?=
 =?us-ascii?Q?i77nOGZgtOhFABXw186nxPrFhssKC/VsDa2kLMfBC+bzo4BcA/ZHCTleK9nN?=
 =?us-ascii?Q?sCH5H9Y7XXT5T+ZOsSGc09K8EsKPp0uLRoaTsWuuH014xmF2SpW/NanySN/S?=
 =?us-ascii?Q?btI8bOxp0VGi9bN3ahyOKesf9Jhk8mujwTmrisPmRTv4stBCfWedGRzEM3zH?=
 =?us-ascii?Q?xk1TN9w0txHWAm4jJRcOy38TdyQ2zCg/0dBw9zlRWkZOapd2h26r1tWD7cKf?=
 =?us-ascii?Q?FMgM2Kc3jti8liPIfSASx4uuLAfnJrYZnahBGKluPCV720G6KGisO0LKaSa5?=
 =?us-ascii?Q?X0fVM/vrXuwtSLwC9QrY8NouRbkMFwpZ0eZZxFFuD3rYupjKhVxvKQ3NFVW1?=
 =?us-ascii?Q?eUyvyBSUONJm+no8GC9mNvyg9gtTCkvkcgL73qMFQZI/RfVrJjKuuwccwNX9?=
 =?us-ascii?Q?5GwPy0quHbi8yeyOEGZpk2dcjcNqtmW2CLrdVNqyQNiy5Ey3BSofS1r2fVJC?=
 =?us-ascii?Q?9tVXMUigfZBeZbGzADEc1XXr+KHOIxekmw+4GQU/Ud5Y3UA496ON1x2jRKoi?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfd85de-b0e2-4495-414d-08dd626b1f62
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:38.5552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzTQURJ63vu+XNBTRgo41KPsnQeFoPk/cmKtE/epvlFPTBoCwhA+IN3yZqWfkk1rQj9UI8tmq/aeTmqvsd0HVr8DONNFnXe5lTXd3XzRmDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33bc0 cx=c_pps a=LxkDbUgDkQmSfly3BTNqMw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=xgkDhTgtFcFo7_nozIcA:9
X-Proofpoint-GUID: sU2rX9OtlsaMC7LqQ-6lAS9iWaWJrPDA
X-Proofpoint-ORIG-GUID: sU2rX9OtlsaMC7LqQ-6lAS9iWaWJrPDA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Extend make_spte to mask in and out bits depending on MBEC enablement.

Note: For the RFC/v1 series, I've added several 'For Review' items that
may require a bit deeper inspection, as well as some long winded
comments/annotations. These will be cleaned up for the next iteration
of the series after initial review.

Signed-off-by: Jon Kohler <jon@nutanix.com>
Co-developed-by: Sergey Dyasli <sergey.dyasli@nutanix.com>
Signed-off-by: Sergey Dyasli <sergey.dyasli@nutanix.com>

---
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +++
 arch/x86/kvm/mmu/spte.c        | 30 ++++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a3a5cacda614..7675239f2dd1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -840,6 +840,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		 * then we should prevent the kernel from executing it
 		 * if SMEP is enabled.
 		 */
+		// FOR REVIEW:
+		// ACC_USER_EXEC_MASK seems not necessary to add here since
+		// SMEP is for kernel-only.
 		if (is_cr4_smep(vcpu->arch.mmu))
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 6f4994b3e6d0..89bdae3f9ada 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -178,6 +178,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
+	// For LKML Review:
+	// In MBEC case, you can have exec only and also bit 10
+	// set for user exec only. Do we need to cater for that here?
 	spte |= shadow_present_mask;
 	if (!prefetch)
 		spte |= spte_shadow_accessed_mask(spte);
@@ -197,12 +200,31 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
 	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
+		if (vcpu->arch.pt_guest_exec_control)
+			pte_access &= ~ACC_USER_EXEC_MASK;
 	}
 
-	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
-	else
-		spte |= shadow_nx_mask;
+	// For LKML Review:
+	// We could probably optimize the logic here, but typing it out
+	// long hand for now to make it clear how we're changing the control
+	// flow to support MBEC.
+	if (!vcpu->arch.pt_guest_exec_control) { // non-mbec logic
+		if (pte_access & ACC_EXEC_MASK)
+			spte |= shadow_x_mask;
+		else
+			spte |= shadow_nx_mask;
+	} else { // mbec logic
+		if (pte_access & ACC_EXEC_MASK) { /* mbec: kernel exec */
+			if (pte_access & ACC_USER_EXEC_MASK)
+				spte |= shadow_x_mask | shadow_ux_mask; // KMX = 1, UMX = 1
+			else
+				spte |= shadow_x_mask;  // KMX = 1, UMX = 0
+		} else if (pte_access & ACC_USER_EXEC_MASK) { /* mbec: user exec, no kernel exec */
+			spte |= shadow_ux_mask; // KMX = 0, UMX = 1
+		} else { /* mbec: nx */
+			spte |= shadow_nx_mask; // KMX = 0, UMX = 0
+		}
+	}
 
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
-- 
2.43.0


