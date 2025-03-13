Return-Path: <kvm+bounces-40996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36115A60220
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:14:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8542D19C1DDC
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCCA1FCCEB;
	Thu, 13 Mar 2025 20:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bmeVJZ9x";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Kl+cuoao"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A3E1FC11A;
	Thu, 13 Mar 2025 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896650; cv=fail; b=k4Hz4WgVp5oF8KpY6lky3o+6N+jFmmo/U2F1OBq+U3oEA5iASBtJolRPyOGcQZgXZm76JDD+iN1D1FZmGAGHu4ooBFgRI/SFNCGVWBE2oHRH8xSKfwLzyIROumALUm/iaLOZpMPsN91myDKM4ZAl6Iw7X2PnUL/cVg2ezBEPi5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896650; c=relaxed/simple;
	bh=W50WHMLTRvx500GgCKilVtJqTyB41VsBY23UsV5JH8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O8uFj4Jd0COc53UotyYqIieE/KgOY9aTgP6GP6Tc1U4+iHprBIlRdCSXUO45mImpwdfXUyGnCmYz/Sues1SRqXRSAqSHwkKC3RalZkTFSOS2Y1Hth6nylsXVHdCVuC+i4JSIRtSDguOGHuNgp7oK0+ziYV+b1NfKK1CdERn8Kxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bmeVJZ9x; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Kl+cuoao; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFSGj4009058;
	Thu, 13 Mar 2025 13:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+O+jXVltgYdj4A6eFxFrWPTE0N+w1ZTbN3qpKdv97
	gs=; b=bmeVJZ9xpVpjGGsE4QC4jFMM0aDmrHbcZEMkl92/LEtC87wAGZ5jBZyRR
	eNAQeJCMVIApoG6NzYaYlR/lAD+ylpT9X0+q3d8b7T/dTGO6lGDfEh4O7oqpGiJ2
	vua0GzXLSvzSiVnLgagVziuRPN4rI/zvvq1O/aB/VtFtVcZgo+0KFcOldeJ99qTK
	T8TROW8wkhsUilqkNk4VWL4no8r5qAhakeZO8vG/86qDE20wTk54hLx3bJpvx3YK
	io7OiOpFbLNeZ/QXC0slYG6rjl34598DsUhvsCts7AHtqt2md7UfdEK8/x8ek4me
	epzqjz4oSlOqhzzvO9+Z4NWMtubzA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9g67ja-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9Ln/SQfaM59QkuRkflUd02kHQy7SkzH1UoO/m4kDAmx48S1xEi/MFbdv0WoQuJbYQ2y/lHxBP8/xHH5cSEkoObzRzEa4A02Uq9MTLXhVI1D3b97HihXVlaCoFLXzceUjrepPml2HMc1AY11c2XAnWDl/939F7ARaQfZ0Jg6vKMb4fpPAfwC4lOrpojmzAlV4X7e+F01JYlLhbTZIvnTaSz7MmDAIHxpKUIER4QzNd7giIlCQDTQsXsfejNFvUSG90jDEbjvJmgcGpfPJkkHgd+Wrfp1XLVGggzMmf8L/6AIJ8M0y0zoszjZicw9y7sllLlJz+h6vyPLM92krN5BOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+O+jXVltgYdj4A6eFxFrWPTE0N+w1ZTbN3qpKdv97gs=;
 b=PVPrLgp3+Q7okcs9cuhreT7hEnNb1JM2ep79O6uhTQzEM7DB59qLnXfBHSGNoEDnZMmdNh9qlXguoXmBh+VXZ48PhZbcXVoIMA2kAJIew7BqcSN2+JZNbwCi1rpFCISQoyci7t1aCS7Sa/2V5BeI0jR1ElXnCSs4lJcEQDm3ixqzLe2kznclxctnkXPfYfiF+/s2W3oUg8Yt+izumgFWKo9ZvGq5SGR43bi54SsbhylsB5GtrgJnGbuRXTQ5YKM/0hJgT3tOpmO3KDSKsH7VLYEmiasoQoP10ARALxl8VEs9fLs2d8nDB63MG+N3ZMZYT+BhgbM7xuPkaUn4fYv5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+O+jXVltgYdj4A6eFxFrWPTE0N+w1ZTbN3qpKdv97gs=;
 b=Kl+cuoaoxlcIvF/ybVgscNGt8d6qjHTONwFLJ15eAClTWHdYgl4N+Lu/5OLpP1KxKpgGl6dAO6gOMYKzNMb/4ULiU77M9iT9ua0yZS5QFzijrwpclgXc/TgzRB5V9idhhwS0Qd14RupBcISl8GaqaWmGa8kG6NKFsVBHVQLZoPsnAOLXHyRQBBjXHm37/YmMLdHhN0PsZmwsc5M2H/o2QK6KBFvoNQ7MkDGNIZ92MYa+9bZICMwd+CLcX4MDaHFMb5EEC30TVrQbdsVwzKEUqL8ALp8Qzc3QuqMJ7/Z0YnbtB1X4tji2VQyLrE3xaT/yQ/g1bL1lBzlOod7qvokS1w==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:28 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:28 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 11/18] KVM: VMX: Enhance EPT violation handler for PROT_USER_EXEC
Date: Thu, 13 Mar 2025 13:36:50 -0700
Message-ID: <20250313203702.575156-12-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
X-MS-Office365-Filtering-Correlation-Id: 497a17d9-83df-4057-d586-08dd626b1910
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnVyalUyc3ZuK3VnY0ZJREZYdHZCb1QxbDVidVlCSEhlbHAwM2lpSk5XQi9n?=
 =?utf-8?B?OHUxRDd3QzA3WVVXUmZkSlZhOVVZb01QNXhwRmc4Y2hDbmZta0gyMFlsQk96?=
 =?utf-8?B?cHdOYU5iaXVBMFkyeUV4WmZQZUw0WE5aYTc5ZFJyQzhvTHAxYklCN0lWeW03?=
 =?utf-8?B?N2JHNnU5OGlvZ29Bc3c4eEFRVC9FWXhyTlk1Y3h3d05ORTJtckx1Vk1MYWFy?=
 =?utf-8?B?RmhRRHZCcU45KytrdU91MFFSc0Nlb0VWaUFka05meGdxenpuZE5kempYVEJW?=
 =?utf-8?B?T3RQQjVkRDk0clBkRncrSzhJc1RpczNvU3l0blRRSkpDNW1Nbkl3TEZKZFJE?=
 =?utf-8?B?Tlc2dC9XdlJsb25DTER4SFprZ2Rma0FBYy9UOUp1RGE2Qk9PQXp4WkxINEZE?=
 =?utf-8?B?TWovWjR3L2loU2RJcEtDekxLMzlQYVl3MHExVGJtVDZlUTNXUGtLYlZiU2do?=
 =?utf-8?B?S1FpSitTbE9ETW5FYnI5aXM2YkFLSFRSRGtMMmxVUnJuay91QlNrMWtMYlRD?=
 =?utf-8?B?RDkraUJua0FObk93c1ZPQUdjTmY0ZC9WRWlTdXZoejEyYWtUWGRPWUJkcWJU?=
 =?utf-8?B?d09zUUVGZkxTajMvdjhraTZUQko2R0Z2T3ptSXRvK2dhY2UvMzl5Zzg0cFR2?=
 =?utf-8?B?bHlaOXM3ZG81Q1MyQmZhamt6bkhkL1FoRU9OQzQrZ3JTY0NzbjZpdSttMUdM?=
 =?utf-8?B?TUJySFpxT3NEdWZ6WXZ4dEg0S3VRUzI3WG5BOTBSbGtYcWtYdkZPK0FvRkFa?=
 =?utf-8?B?ODJveHd2VkhiMldtSzlpVEY2QW1reWJiZHlNQXdEQ2gwK2dONkJzRjhRVXBh?=
 =?utf-8?B?Nnp1Y0tkNm9yb3RUOWNGcVA1dzFXSjFBMk9rMlZCU0JIamNkMlBJTjJUb0J2?=
 =?utf-8?B?MmkvOFFUeTRGRkFZQURlZkZCMWJkcTFKc1EyYTVTWURxWHYxaWNPa1BiOHdG?=
 =?utf-8?B?THhFTTZFMVFmN1JTTnZNaWo5dlFtbjc3WlBQQU1nd3ZFczBpV29VaEgyOWRl?=
 =?utf-8?B?K2dkbnMrTU5reFQ2TFhQZVpvTndGWm9IdHhKd0xuOUtIVENLOVVCL3dhdmZK?=
 =?utf-8?B?dkludmNRRm9JbXZLL0R1U3I0a3JnV21YRzA2ZGg3Mm5EVy9vQmtkWGVjYmQr?=
 =?utf-8?B?cVRhUGFteksxaDhXSkx1dGZ5ZXBWb0FDUS9zdjUwNGd4YW56VlpLMDVodnBZ?=
 =?utf-8?B?Nzdwa283S25CNDVqQlN4QlJ2dDMyYVNWS1V3TzY1eldJT2MyYitGMG54MERN?=
 =?utf-8?B?YTZlYlZQSExGd1kvYStXOW0zWXRIQ2pZRUtXc3VTbjdZa0NjNzVpRjl2RzlN?=
 =?utf-8?B?VHdzb1VjNWlON1FseU1qWEZhSTM0b0I4MFN5Sm9EUHB4Nkc5bkp0WS9YblZO?=
 =?utf-8?B?Z0hLQWhNT2Frd2FjK0lWdDBEZjRQQ3J0clJueEw2N3lhZE9keHA3R2ZRdWJz?=
 =?utf-8?B?WEJtR1ZkdUw4NjE5cWJ6NENTMHJsdFZ5elVtNFVybHgxZmF5SVFzd3phNEp0?=
 =?utf-8?B?eHUyeEc1bDZFdzRsN3hMWE1yRXVXK3FQQ3hLeXNJTUcvNHhCVldQOUQzWEJH?=
 =?utf-8?B?MFRoQWh6MDQrak1PdVBBOUtaNitZbllSUWRBc1N3UDhRUHRIOXQrVlc0VmVW?=
 =?utf-8?B?MklESjBJM1ZjN2l2N0xSR3lBemx5eGJtTjBNMWJ0T2dHTVc5dSsvdHpKUWF0?=
 =?utf-8?B?RHZ3LzdhcXVSUWx4bmRmMGlKejhEQ0d0UHlQWUpUL2hxcHlBa2VxalNjU01E?=
 =?utf-8?B?M1hCT0ppSkpJMGdqT0hrNElHN3VGekVGN2ZMRHRXRGY1cjFGTmJWQjBvRHdo?=
 =?utf-8?B?bFZyT1Nick80TXpaYzk3QXI5cHVmN2syNTdxZUFhc0ZXdnBBVkQxK0RVSTBR?=
 =?utf-8?B?M2wxaUNRNDdQYkVPZ2NFQVZqRlIzVEFZS0FZb2Z3bSthUEczY1d3bXN2SVpG?=
 =?utf-8?Q?zNBGhYR4FSx2ey6WChejiU5oEJZ3PsMA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGRrNitXWVBBRDB0YnU1bmpaUkJHbWRXV0xQYmRlQUlXNzVYYmFmOURlN2NE?=
 =?utf-8?B?SldtdmVFNlNkRW5ueU5rN3dvQ2hHdllYdEFiamkvbXJjaENQWm9ZTy9TSzZx?=
 =?utf-8?B?aWhnYzBMZ0IxREVIdm9iUEY2eitUUlhCbGo2VGsyMStseEFLanEvdGlJZ20y?=
 =?utf-8?B?TlF0MzFkaFI1NWJYMlVzaWhrTTMrdWI5T2FmSE91TWthaW4vOWZQY1JPRENC?=
 =?utf-8?B?MnlEaFJwazZXMUlZa1FNbzRFWGNFeHRHMnFvUTV1NThLWTdQSUlrNzJoTzBr?=
 =?utf-8?B?MXhPY0xpeVE3ZUhPdlRqT0FxWHpYakppd2NzWjBpd0c4K1VZcE1WWXcyc3dV?=
 =?utf-8?B?K093c2V2SWdRMmdVanlCYUhPczlkVEkvYnJGQmM0NnplcWVzWExiMmZRZ1Zx?=
 =?utf-8?B?bzdHVzRWZkRnTEo4cU9oN2Yxb3lDWHg4R1F0MU95MGlqeWVJZlk4OVZUSlY0?=
 =?utf-8?B?cnR5endtcU5rWUFPcFNLSnJ6cW5XZXBmYWpFSE11SXpYaklzVFlvdFltRVZF?=
 =?utf-8?B?UVZEdzZVNjhNNWprYnRZamlRN3JsUUZDOVUwdFA1dUdDWGNPMGJkd21neitu?=
 =?utf-8?B?YjViSWFvaSs5SnJoZ05vWEtFZTFDLzNvNWZhYjdkZUYvL3lHTVdtOGN3dEkx?=
 =?utf-8?B?akw3aHh1S3FlZWlxQm9ldEc0WDJUTUdyOU4wbE9OWmJMMzk2K0J2VlZ6VnhX?=
 =?utf-8?B?aUJCYVhkNFFUYWNFSTlZRUltd0dWTzdBbktDL3JlMzlWSmk0bmxlcGZQVm5J?=
 =?utf-8?B?VmJHQ1g5eGVaZkxYb1VPZmdWb2cxTmVFRWpDMVhUZk5ZWTQ3SVpWa1NGdksx?=
 =?utf-8?B?UVJJSmtTWkFrWDJWTmFrSEdmeUw1ZXpjZ2E3UlpLRENrVzR0TzR3ZEJicmw0?=
 =?utf-8?B?U3ZGbDFsMWhjOW9kcnFwNkZYdHJINEEzRndLRHpFZjExdUVCeC84czQ2ZkhJ?=
 =?utf-8?B?TVI4eFd3dEFpdlpCckRhRUIzYjNUWEM3cldPK2w5cGszcjVmSzJkVHJPaXJv?=
 =?utf-8?B?T25kKzU0aVphdko3RlhaVFJvL1VqaEJrVmZWU3lIeDR4ek9BRmY3MlovUHVv?=
 =?utf-8?B?bmZQUXF2WnRjUWpSeVM2VEZBekNMalYrd29TTDZ4dUJHV1FUZnhFYVBseWJi?=
 =?utf-8?B?TzQ2UlgvdXNlMWxLeG5FUHV2eHN4RFJPdTdDMGxDaGlzQVZpajdQV3hBM3hK?=
 =?utf-8?B?aWJSZ0s3d3RGMDVUTU5ieGN3VXBPcTN6YjArVXlHckFneUVlMm04ckoya1lN?=
 =?utf-8?B?Z3ZNMGRqVW1oSVpIK1hKUWJudnpKVU90TENud0srbjIzZmkwcGd2N3NoOElM?=
 =?utf-8?B?UEhtODR1THNNSlNrY1V1NUllUmpuVGFjd3RRcThEUStLNXJBY3c3Vm5hNzRR?=
 =?utf-8?B?bERiN2dqVm9RQ1J2Zm9xd2pZTHF4cWpZelJpUU8zNGQzUHI0NEpPQ0h5Zlor?=
 =?utf-8?B?SXpHSVVqVEZ3Uk5adlZyc2ZZNkpNSVhoSUVUYkdPTFRyREx4UlkzTVpHZi82?=
 =?utf-8?B?T1dkMWdFaGV6cG5MZi92QzE0L2ZwamRNOCtlZzZDQzltZVlsNG9QcytMUy92?=
 =?utf-8?B?Y3VZN3A3TkxuM2UyblNmRnA1YmdJaU5PMzNvTzZ0SG1vZXFMS0IrOTd4M055?=
 =?utf-8?B?OFJHTDYxU0lVS2hLMXU3MVdlMnFDMXYvdjl6eGRBK0ZHcEhoWFB1enFXclAr?=
 =?utf-8?B?MFl6MUkwM2k1SXM0SFpyaEtSRi9LVDdrVXpBTEk5R2YvbEtKTXE3bkxtYW96?=
 =?utf-8?B?U09YZFZWUVVGK09TOU9ibGNNbnYwZXBUMTNJczFScTdXRkt1TWN5YmdyS2ZF?=
 =?utf-8?B?VlNTdWkxWUwxNTE3Ui9OSC9iU3ZhZ2FORDl6aWZzMDc3TElLOW1LNHc5SklX?=
 =?utf-8?B?WjkvNkJKOTZ6Q2NaQytiVk1GMmtlbWplemRyRHV5UXlYdkNWOXd3cDFuOWMw?=
 =?utf-8?B?MWFwZjhqdkp5NjJLdjI5RHI3cjdQQXZUUnphelR2dlMyQUs2SXZhd3ZCV3pp?=
 =?utf-8?B?UlZudERRMWMzZ0ZaU2NucTBNQzVsbjRLdFdHb1BYQ3ZqZ25KbURhRjlUYVhv?=
 =?utf-8?B?aHRFOVQvNlBmM1lPS0M2SVJObmVsbWJFWE5OMTZNS1dYUXNpWWV3d04yLy9T?=
 =?utf-8?B?ZVNQWi85bDhyb3dma2NvakgxUU1ZZXcrRHhtUkU4Zmlwb1JYNFl3aWlpZjZ5?=
 =?utf-8?B?MXc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497a17d9-83df-4057-d586-08dd626b1910
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:27.9570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fsIjnS+i7prQ06Xox4eMWSTHkGO1rftQTt5vCANKsIW8F/JXEDV3kJYICmknsfnchJ1+yZKFsdKJrCeg/TfPtfofny+sP2K3N/nOhLpe/ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: yMO-8Q4y3iE0UnRNDN3HToI3TSx0vJLy
X-Proofpoint-ORIG-GUID: yMO-8Q4y3iE0UnRNDN3HToI3TSx0vJLy
X-Authority-Analysis: v=2.4 cv=c4erQQ9l c=1 sm=1 tr=0 ts=67d33bb6 cx=c_pps a=oQ/SuO94mqEoePT5f2hFBg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=w3Wncs-oLU83PDkzuqUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Mickaël Salaün <mic@digikod.net>

Add EPT_VIOLATION_PROT_USER_EXEC (6) to reflect the user executable
permissions of a given address when Intel MBEC is enabled.

Refactor usage of EPT_VIOLATION_RWX_TO_PROT to understand all of the
specific bits that are now possible with MBEC.

Intel SDM 'Exit Qualification for EPT Violations' states the following
for Bit 6.
  If the “mode-based execute control” VM-execution control is 0, the
  value of this bit is undefined. If that control is 1, this bit is
  the logical-AND of bit 10 in the EPT paging-structure entries used
  to translate the guest-physical address of the access causing the
  EPT violation. In this case, it indicates whether the guest-physical
  address was executable for user-mode linear addresses.

  Bit 6 is cleared to 0 if (1) the “mode-based execute control”
  VM-execution control is 1; and (2) either (a) any of EPT
  paging-structure entries used to translate the guest-physical address
  of the access causing the EPT violation is not present; or
  (b) 4-level EPT is in use and the guest-physical address sets any
  bits in the range 51:48.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/vmx.h     |  7 ++++---
 arch/x86/kvm/mmu/paging_tmpl.h | 15 ++++++++++++---
 arch/x86/kvm/vmx/vmx.c         |  7 +++++--
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index ffc90d672b5d..84c5be416f5c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -587,6 +587,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_PROT_READ		BIT(3)
 #define EPT_VIOLATION_PROT_WRITE	BIT(4)
 #define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_PROT_USER_EXEC	BIT(6)
 #define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
 					 EPT_VIOLATION_PROT_WRITE | \
 					 EPT_VIOLATION_PROT_EXEC)
@@ -596,7 +597,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READ_TO_PROT(__epte) (((__epte) & VMX_EPT_READABLE_MASK) << 3)
 #define EPT_VIOLATION_WRITE_TO_PROT(__epte) (((__epte) & VMX_EPT_WRITABLE_MASK) << 3)
 #define EPT_VIOLATION_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_EXECUTABLE_MASK) << 3)
-#define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
+#define EPT_VIOLATION_USER_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_USER_EXECUTABLE_MASK) >> 4)
 
 static_assert(EPT_VIOLATION_READ_TO_PROT(VMX_EPT_READABLE_MASK) ==
 	      (EPT_VIOLATION_PROT_READ));
@@ -604,8 +605,8 @@ static_assert(EPT_VIOLATION_WRITE_TO_PROT(VMX_EPT_WRITABLE_MASK) ==
 	      (EPT_VIOLATION_PROT_WRITE));
 static_assert(EPT_VIOLATION_EXEC_TO_PROT(VMX_EPT_EXECUTABLE_MASK) ==
 	      (EPT_VIOLATION_PROT_EXEC));
-static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
-	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
+static_assert(EPT_VIOLATION_USER_EXEC_TO_PROT(VMX_EPT_USER_EXECUTABLE_MASK) ==
+	      (EPT_VIOLATION_PROT_USER_EXEC));
 
 /*
  * Exit Qualifications for NOTIFY VM EXIT
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9bc3fc4a238b..a3a5cacda614 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -181,8 +181,9 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 	unsigned access;
 #if PTTYPE == PTTYPE_EPT
 	access = ((gpte & VMX_EPT_WRITABLE_MASK) ? ACC_WRITE_MASK : 0) |
-		((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
-		((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
+		 ((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_USER_EXECUTABLE_MASK) ? ACC_USER_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
 #else
 	BUILD_BUG_ON(ACC_EXEC_MASK != PT_PRESENT_MASK);
 	BUILD_BUG_ON(ACC_EXEC_MASK != 1);
@@ -510,7 +511,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
 		 */
-		walker->fault.exit_qualification |= EPT_VIOLATION_RWX_TO_PROT(pte_access);
+		walker->fault.exit_qualification |=
+			EPT_VIOLATION_READ_TO_PROT(pte_access);
+		walker->fault.exit_qualification |=
+			EPT_VIOLATION_WRITE_TO_PROT(pte_access);
+		walker->fault.exit_qualification |=
+			EPT_VIOLATION_EXEC_TO_PROT(pte_access);
+		if (vcpu->arch.pt_guest_exec_control)
+			walker->fault.exit_qualification |=
+				EPT_VIOLATION_USER_EXEC_TO_PROT(pte_access);
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 116910159a3f..0aadfa924045 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5809,7 +5809,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification;
+	unsigned long exit_qualification, rwx_mask;
 	gpa_t gpa;
 	u64 error_code;
 
@@ -5839,7 +5839,10 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
+	rwx_mask = EPT_VIOLATION_PROT_MASK;
+	if (vcpu->arch.pt_guest_exec_control)
+		rwx_mask |= EPT_VIOLATION_PROT_USER_EXEC;
+	error_code |= (exit_qualification & rwx_mask)
 		      ? PFERR_PRESENT_MASK : 0;
 
 	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
-- 
2.43.0


