Return-Path: <kvm+bounces-44807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE1DAA118F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 297AA4A3E6C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D62B145FE0;
	Tue, 29 Apr 2025 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWwQWLeM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tOyliKpV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69751DF99C;
	Tue, 29 Apr 2025 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745944323; cv=fail; b=g65Fc7bQnounA2FvuG9Za9KxAsMWDB1mYl1uE2AnpD60fTs+dFh0lSuFEoST0GmrbcwzR5inVETHr2qUkDEOV0jzUM8pVC5lNMqlkcPdXzA/xhc/xtUbr4aJJO1yGKfsON+uPp9CyFpyVJPwB53bo9f9wOloyleoURPd6wHiv1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745944323; c=relaxed/simple;
	bh=iCeK+/c4w93xnpHU8QrCSpbUMByM1IqFiuAUhfa+AR8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gTUn4vplzKycLfrf1zuoJrtscCFmPCodQ9I0G7HKR+GSCKFCTIrzvRXdfxpzxuRkfZaODp4YDjIMOI1EQUTsEZsbRqYYpZK0IpaRGxnUgZ73yJIEkPP0SWIcvxqK9ZcQ8Vuf2ah+ZRey+XdcCITEfuB5o/3P+oqFc8KLWnTcuPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QWwQWLeM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tOyliKpV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53TE0Ctp021688;
	Tue, 29 Apr 2025 16:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Sh8BOPWxMWfE6m1brpjv5qAf9YvkqaFbybXNOXgmoCc=; b=
	QWwQWLeM35L18oIR9iMZ4WWf4ufY8v8KPOvzlITXOEN5x05AwU4Q0ilP6QeM0xdp
	wyYcVyVSiiJA4CWEbqMm9kFzneCwOiYPgy2kIBfPtSvZNE9gfpl+PJ6oq/gkrK3Z
	RnOnH5+6fta0B3hbWbzmHCL+cvpXMC/cwvNb+qvE+DxDAcfDhVwtCCCFNfnQfwvM
	yBakD7gMjLiimUL10pJJLkxzMhPLgbBv6iaXaUBg3RjuaE14ku6Jf9Yz+tSn7t3H
	JQiauYUZOg2TTI3bfGr6pRUyqIrRxntXJ+wwlPypwW/K00dduERcgxxO+dvFP6pn
	pi7uoHslogqB815W3ED/Dw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ayvmrgec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 16:31:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53TGAlWW001270;
	Tue, 29 Apr 2025 16:31:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxa4eej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 16:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FjBt5EJbkRYF3wueaYtm+9uAoof1kIJJhfDSaQbgM12sXRlE/h9uZ3bnqtg+n+LlP0XX9v9crnWEb0vyGx5SHUr7cE5RYf3FWqHz5JCGoTL8ETWQ+X02F8n0AL6rUm5a8MwH8qvAU37sJqOL4BnUwRxysh+UXDsUFgDxgiaBvC8TyeMJsy8BrI+vsBrgpMHk13tagAkALo2tE27iCrEy1S7Xan7PLPo0D7DQJmcv5atcP1wN5phC8qoC65lSb4ncfAcECZ3MhcwErXiBVUk5RVvfESrWeoWdfGvShgSobDQ8rODQT22rrY2wMPJaKW9Ac6a9eXG7xzDytWxV446jWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sh8BOPWxMWfE6m1brpjv5qAf9YvkqaFbybXNOXgmoCc=;
 b=XNfTK2Zd7ooKa69HvIXKlLUgrI3s7d5vFOY5jD5DFc7LuqVviPOYhp3+Y49cYwvyIq+RQ4j5EsDhvxGGepwqNfwwJ4TaXo10Q6ZJCTX5pFsb6ov9d6n6vLeAC5wPhTuIqL1M3dqlBUNqQ8lwEMSbGxRco22++7cRq15+uzXbKySlODfVrLBPXQWwCOeUV8T/bWgQaVKI2oNd+2nnp3S3XcEbgWyP0yYRlsjKwIjDB5QoDzgaBA9hZrYYz4/rcqKHjutOn/dKufQ7n9232GghO6QZ/nm6G7WP4XKJSfVeVidhSKITimuAZmRqrnEljXQAWk2fngSuTahs0a//uK9veA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh8BOPWxMWfE6m1brpjv5qAf9YvkqaFbybXNOXgmoCc=;
 b=tOyliKpVKYPdCDkkVXH2pUq7qIG6Tv0e/Nd1JMhhMy7zcRavO+H6b7DgvzrQMtltxb6vF7tFjEbLuYVNY5AGkAR2JjOH4F2QQmkV0XPoVu0PbPyMXSRSx2Io8gaH8T5b1UkVSJSvo7dnVzhBKtLHllLHE0i9zTdKRLOqguyV+qs=
Received: from BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 29 Apr
 2025 16:31:24 +0000
Received: from BN0PR10MB5031.namprd10.prod.outlook.com
 ([fe80::3ef4:e022:4513:751a]) by BN0PR10MB5031.namprd10.prod.outlook.com
 ([fe80::3ef4:e022:4513:751a%7]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 16:31:23 +0000
Message-ID: <db704530-e4ae-43af-8de4-bcc431f325a2@oracle.com>
Date: Tue, 29 Apr 2025 17:31:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot
 fields
To: Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Roth <michael.roth@amd.com>, liam.merwick@oracle.com
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
 <aBDumDW9kWEotu0A@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <aBDumDW9kWEotu0A@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::12) To BN0PR10MB5031.namprd10.prod.outlook.com
 (2603:10b6:408:117::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5031:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: a2f3dba0-4fe4-480e-6425-08dd873b4726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWwyUzQvTzEwbFhKMWpPZmVtbUlZQ0FZWE9Lc3k0dFN0SFR5OHNld21XTVUz?=
 =?utf-8?B?ZFJIbVlQZTkzVzIzUi9iYkoyWE9Qbmt4L0wyS2JRUkFVUk9iMVMxT3ZPN2R0?=
 =?utf-8?B?M3FncGFGOTVsTEt6VHdCN25OYUNoZGVYSW1qU0psaitmLzZ5QnRERGlFWTJk?=
 =?utf-8?B?cGs2NVJwaWdxaGdrOElSMXNkWXBuWnU4ZE8rbzgyRlE4b0ZxbVN4SnFlVFZF?=
 =?utf-8?B?blRPcTZxcW5DcnZ0S2l1cnJQVm05dHAyMGQ1cFhiRWF5MDFLSEVTdkZaKzl1?=
 =?utf-8?B?Z0w1N1Fmb1RxVjg3c0k4OEE2blZEcUpXK1luVGppWUpQVFJCRTBMVVdKa0lp?=
 =?utf-8?B?UVZxWjdZNy9SWnhFaHY0eTJPYmFyZnMrVTlRVEZxWDVQK2ErRUQ1VnEyNzNJ?=
 =?utf-8?B?ZWxHaU0xZlJodnczdzhTTnROa3IxYzRhUm80Qy81cGFGR3BOY1VncWZZUGtD?=
 =?utf-8?B?NS9xQlhwSkwxMlllS3lCajZHUlN6YytqN3Rvbi9UQkh1SmU0dHIyKzVNNEFl?=
 =?utf-8?B?eFVFRzhYbzlaYVBzTWZxZ2pPR0xOQlpFRTlNaEtGckQyQjRLZ2Frd2dYTXJY?=
 =?utf-8?B?MXlrbHYvcnhQQThSLzBCUVJEdHhiSmpiTFZoZ0prenh5UFpGL2NWVDlqZjRX?=
 =?utf-8?B?NU1Ibjd5ei9nM0QvNGhIVDU4WktXOE9CMmdPeVBvbTJJSlF5WVhjZ2FvZ1RV?=
 =?utf-8?B?dzVOalV2bXFsbERjamZhc090T21RUmFmV1NtYWhZRFlGT0EvczZsKzNyNzdU?=
 =?utf-8?B?VEU2QU5sZnZVR2psR0ZmVHkzWDRsbmVET2k2bnVrdVRGWVMxZittRyt1ajZH?=
 =?utf-8?B?RWJLOFFrYnNKUnEzQTZ2UWx1emhmY0VrRkhhMkZBeUhaeG1lRlVLUjlOVUdZ?=
 =?utf-8?B?Z1gxV1dNT2xzYmJVcVZVc1BmSDlNS3A2Y2syMkVpVm5mTXpPSTN6ZUZDYUUy?=
 =?utf-8?B?WGRlOHhMandndDhFMUF5TTVjbTRiNXptYllZcUZiaHUydTdVem5ReE5YYkE1?=
 =?utf-8?B?SHR4ZnlITmkwTk5WeU9vV3JCWTJhRVQ0NlJVN2x3WURKMldIQkR3TFkydE40?=
 =?utf-8?B?RVVBdy9yRXFPdjJaWXp1aTJ2ZWZ0aHN3QWR2bGhTOFVLeUhQaVhDRGJnNEdK?=
 =?utf-8?B?UFVmVWQ5d0JPRmlReU16QjhydU5OL05KNzhHMUNRZmVMVk9yaS8xM0tMbUU0?=
 =?utf-8?B?R2l6NEFlcmNRbG1leVlha3JkYk15TjdzdmlubjdTNWhYWk9MYURVNE5jVmMw?=
 =?utf-8?B?UDhpVXgrYm5waXFzaVpxcVJwdmhsNTRWU0hoQlBYTkh6Y093VWxBdDA3ZjEy?=
 =?utf-8?B?QngxUEVEeldRUVBGQ0xJQk1xZWRGL2I2SFhDcE5RdDh1UkV2K0JMMHdtNmg0?=
 =?utf-8?B?MnBpOGFkY1VRSm5yQWhZMUJlMnRlZ2pZSVd6MzdSci9vSjA2cmRaY0w2YSs5?=
 =?utf-8?B?R1FjSWxENGxzM3dQOEJjdk1BWHFJUmlmZ28zb2FwV29MRStoVHFHaExSUXhP?=
 =?utf-8?B?Y1lQcEw0SzA1ZFRkajBRL2NKMkdHMXA5QUFNTDBmMzhaM0NoTFlSOWxtRWgz?=
 =?utf-8?B?bXNtSTR1RGlYWTByWENsSVJLOHZOeSsrM1BxN0pueVY1OUNQNkUyR0FhcHJn?=
 =?utf-8?B?M003VnVQQlhVYUU2cVNlSDBWSzlUeTVYOTNmK2tkNHRtQjFST2hsZzREdlJ3?=
 =?utf-8?B?eHVYSXJ6SHRXMXJqa3doZTVXbVVjN09SR0hrWW9HdUtSM0NCSlZQME80NE1o?=
 =?utf-8?B?d3JCUlc3Ukgvd2xQL0ZOQTg5VzkxTndvdzc1TTBsVlltQmN6SmNEMEw1ZFRx?=
 =?utf-8?B?NnF4c0F3NWhRV1RtQm9nZWtLdFd5SXI3VDliZzBBdnZyRHFydzliY2JMSUtY?=
 =?utf-8?B?M1lucDZpVHA2SXhYc25nMzNiT1k4emJaT0pjQ0V5blZjSGppclR3eWFaTklJ?=
 =?utf-8?Q?xd4qQtNTZPE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5031.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tm5zZTFVK0VseDZUeit3Z1pZbXRMNFc4bnhMa2IyTFI0ZjIrVzdmdnpYTW81?=
 =?utf-8?B?SWw2RjM0OXNoRVBrcDZ0cGlyUmRtQThRMFpTOHV3Ky9uT2svS1Q1SWR2TmhH?=
 =?utf-8?B?R2FlckNodVBMUTBOSmVielBKMk1UWkxieloxNUhYa0piejJZY3hsazhUd1pI?=
 =?utf-8?B?N1BOZDhISnVza1oxRmFmK3hHbzlDaEpja1JjMnBTcUhRSStrWVpoYTFYZnNJ?=
 =?utf-8?B?dCs5TG0zS093TlFYc000RFVaaFlrTjFicVJYMGVOeWFVRDQ1NEdxcFJKeTVt?=
 =?utf-8?B?NlM1Zzg4aXg4MnVtOFl5RG5OM29oaE82L1drV1VCR1pZKzdzVzA2Qk1adi8v?=
 =?utf-8?B?RGg0ajg3NTAzWGc2Q1I4cktEYkhyTW9LMTY4WGxZM011eU5kWXBQYXZjZHJI?=
 =?utf-8?B?SFVabTllUTF2bFJOL0hpYUVxcGxMT2Faa3RZRGxJMWlLbGVmSGl6NFZaY2wy?=
 =?utf-8?B?dFdCNS9Sbms2K1orNkFFSWRRRDhTK241Y055TlZiTTVMYVVjQ0k5LzhkV0wv?=
 =?utf-8?B?NUM1eW1pRFB2dlFpbW5hTFVraXNCOGh2ckpTOU02bFl3WEdRL2IzemN3M2RK?=
 =?utf-8?B?VlJkVE93dTNJZFR5SHVNaWVqNExKc2xDWmsrY0U3STJ5WUE2UVkxYlBKZUk5?=
 =?utf-8?B?TUYzN1Vta1dtR0l3VnlaLzBPSEJ1NG80Y1ZkQ0FpRkp4Wlducm5XZnU3VGdK?=
 =?utf-8?B?Q0lacEc2UTFyaVMzZC9DNmVyd1RrelZFZHpFU0Rid1lsQmlJZWp5TzB3ZTM4?=
 =?utf-8?B?MTREUDUxbUIrcnEwRkZZTkpkcmM0TU81M1JtVjVwVEh6eUZVOGlDL3pyV1JP?=
 =?utf-8?B?MHFFcWdiOXI1RDhNakJ1VGhFbGUvMk1PcHdFcW9sazVIMGxEYUV1eTBuZUV4?=
 =?utf-8?B?YXBIOG5nSWFvL05WZG9seU5rZXFjalVKaGxXdnJUakZxcWJTajFrQVJkczZt?=
 =?utf-8?B?cWZoVnFEaXBEbXFyblVkck5VL1drRWpwTzBnU2NadkllRzFnZG04TFRBUFlJ?=
 =?utf-8?B?SGZ3WHAwcUNxL3lKVWNncjVzOE45Sng0UG1YVm0wL2g2OFNOS1daZlBCV05a?=
 =?utf-8?B?TnZQTjkvMCt6aXZGa1h4eStDSEtqS3p4M3RhdVFwNkMyWTlraG9KVU1nYWpM?=
 =?utf-8?B?T1JSQitTbGtON0c5NGViYlpFM2Q4NkNpVGprQ1hhcnA1RDNnYjdWS1lpeitC?=
 =?utf-8?B?bFFmeXZmOW1QanM5U0FuMEdOekZEL05mOWIyQ2tYZnd6dE9mN1lmNjRJRjd5?=
 =?utf-8?B?RVdyLzlQRHBtbWUzMG11bG4vekhvM1FaOWRTcklrYzRiWXVsb0VWdHlKREVo?=
 =?utf-8?B?a3dSLzRRWEdDSmUzbm5OZWY5R2J5OC9jZFBtbVlKWE5IYkRtc3pxNUZxRHBN?=
 =?utf-8?B?c3JuV0krcWU2Z3pxSHdqcmo3bTdpWVdzN2VaM2syaDlSeEtoZmRiRlhwQWlL?=
 =?utf-8?B?cDBhM1B2cjVFOFk5TzBPYmNvTkkrYnRZQTA3U3lGd1FQbllLWGZaYUhWTE9h?=
 =?utf-8?B?ckE1NkNFOTBBTU5yc0dncEM0NFVDRGREeWdiZmF3N1hJOG9xU09OaXFLUVUx?=
 =?utf-8?B?N0J5RVErNm40bXlkWUFRMG1sKzV2TFZuZlNrb3VZdXVUUjJTWVpWelorZ21s?=
 =?utf-8?B?Qlp1UFlxdUFMZHo2ZHdsUk1BQjQvQksxc2NzdllPWGsxRlQ0YnlYSGRGb2JX?=
 =?utf-8?B?RXdWbWlUMVllUnNCdmtyKytvREtCZVVwdUI1aEFpSUFhNm11RmRXeVh2VVVr?=
 =?utf-8?B?bHhnRDB3bTQrNVh4VmFyVW4zVTh4TXpXL2VlZlhHYWJhenk1eDV0cmZmekVp?=
 =?utf-8?B?QUpVcjRRd1krOUVCb1BvdXZrZ05KZlg5MzkvSVJWSVVlT1hvZGhqNTNtOVRO?=
 =?utf-8?B?aXhUTEF1dnJlaFNaclBwK25sa0cvaEhqSklpZDFyUzJHRmE2dE85U3UxdkV0?=
 =?utf-8?B?ZUxKMmRkYlJWMDM1NXZ4NE1jL09RdWp2cWY0UkhDNWNKY3kxd0FEdGgyMzBq?=
 =?utf-8?B?SVRNUkNQMFRhOGw0bkdqT0dSWGxrVmdJamF5YTcwKzgySWNvcEEzVXovTi94?=
 =?utf-8?B?MjNEdng1VWxaUjJzQmc0SXdsRWxhK0Q1aE1NNTFadWthOFNIdTYyeUE0RXBu?=
 =?utf-8?Q?Dp6k5naBsVpL7lXGJeZC3x8Ox?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V1vATUCY3RVBx5rSi4pRKDTEsSNckswskSWYKk8iBQ/1y4T0YImcQO93Yx8GIw/1Q/64CLO9nfc00xLqGFf2Q/rlC49QekR1HZyubcLV26RtV0scutMOTkp8IJFqitAl23rjA0ldIb6hIxxitKZpltLK0TqvVkrkna6geqtcL2MHlyHNG2OqvF7U1YgtpnMO/DYsuUmAP3X9JgaYERzO68fuGnabH0RKyROaJwbePulIJCDefTS9r2IHkLpo090AyNdtFMYFyVDEL1rtn19SBC4xFTN3LveXoIMHCgxTo+/qjFAWPqLbzdPeCQfOIV+wBc/HH9IA5zgQwb+lQnPnPf/+lVlY6d33HWVrbGGz4YD3oO2oTwJP+sEuS6wxN1vybNhXY9EPrHMrt80VKDtfyYQpS08SD9rRtFR98IKXB9GZjQeVY3HH3HvGO9Y8uSuBFTU8oNIhh4FaBQ+kk1MSU5eH2AQ7b6XfwVg/zd9bcVD8HfnaPT+hJ130OerMOaxyK/SYczhrDPGtL0UV8gxol3WLvW1POyIkGFj5c1iB8BSvGGyPiIkKuCk+f/S3MWvKTNPepOKrRR8Cw4kHgSn3LgLR6u8UhP5ub8Ri6aDx0Qo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f3dba0-4fe4-480e-6425-08dd873b4726
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5031.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 16:31:23.8985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2eiGugy5PmWFOcD1AnaIAf4lTCZ8e3mBBiiB7hIPuxLZ2pJh1cPEgkmhhxRkblRZlgYBRJmkKKD9Z2M1QSIXuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_06,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDEyMiBTYWx0ZWRfX4AT6PPEWQIhf GY3i/PRtvYqrJQ5nF/lSlHmPKXPlHh03v7J103sL8jc/d2ItAC89arY0rzcaQCAI/skA5upRRV5 K4MWuXhSvljf3hicNwJZ8xcpAPCZJj42Bjiq9AVl/lVm72gy3DyyfhIw6poDAaOgBo3uN3ljgap
 lfu6M5L1R52BWOnvxL7SA3yeOkeHji0OEHffj943O0sPSVu33ON5dSWplERLSkV0un/BpijtMeu 1IRWVphWf3D9pzpa5m7Xi//vW4V2lGEbnEG1N+nZ5Zk51YzDCYlgiisYwT8BgxJG0RbDa8nLs6O LYKoqzs2l8WLszaA6L8eWbYZWBg9CcrYZP+no+Zh8L6Wv3CrW6VGXxDVmzzl4CniKG50LrWAg41 UjfNZeZJ
X-Proofpoint-GUID: 1oxiBZTPbvN9bpMageHl8mbbXmcEnE_i
X-Authority-Analysis: v=2.4 cv=adhhnQot c=1 sm=1 tr=0 ts=6810fee1 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20jgnnYh7FodaUo0ghQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129
X-Proofpoint-ORIG-GUID: 1oxiBZTPbvN9bpMageHl8mbbXmcEnE_i



On 29/04/2025 16:22, Sean Christopherson wrote:
> On Mon, Apr 28, 2025, Tom Lendacky wrote:
>> @@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
>>   		return;
>>   	}
>>   
>> -	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
>> +	nbits = sizeof(svm->sev_es.valid_bitmap) * 8;
> 
> I'm planning on adding this comment to explain the use of KVM's snapshot.  Please
> holler if it's wrong/misleading in any way.
> 
> 	/*
> 	 * Print KVM's snapshot of the GHCB that was (unsuccessfully) used to
> 	 * handle the exit.  If the guest has since modified the GHCB itself,
> 	 * dumping the raw GHCB won't help debug why KVM was unable to handle
> 	 * the VMGEXIT that KVM observed.
> 	 */
> 
>>   	pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);

Would printing "GHCB snapshot (GPA= ...." here instead of just "GHCB 
(GPA= ..."
help gently remind people just looking at the debug output of this too?

Either way, for patch:
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


>>   	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
>> -	       ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
>> +	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
>>   	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
>> -	       ghcb->save.sw_exit_info_1, ghcb_sw_exit_info_1_is_valid(ghcb));
>> +	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>>   	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
>> -	       ghcb->save.sw_exit_info_2, ghcb_sw_exit_info_2_is_valid(ghcb));
>> +	       control->exit_info_2, kvm_ghcb_sw_exit_info_2_is_valid(svm));
>>   	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
>> -	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
>> -	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
>> +	       svm->sev_es.sw_scratch, kvm_ghcb_sw_scratch_is_valid(svm));
>> +	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, svm->sev_es.valid_bitmap);
>>   }
> 


