Return-Path: <kvm+bounces-42788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D741A7D0C1
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 23:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A38E3ADE62
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 21:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F150221D583;
	Sun,  6 Apr 2025 21:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ccbxR3Si";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TX78VC9/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8DB2192F4;
	Sun,  6 Apr 2025 21:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743975801; cv=fail; b=K0KTZ47JgzOAlbm6tRJGLiYq3rKS8Nf3zNlENO2u5jwJHAxclydkzMefFbxgaf8g/If/Ox4nSkOEmHrDliLTKW9/uGeLnsfIHWlUaQgrWskbIxbXWkNkTRQ0DT3iaKRj6uaRGbyCMM9edmFw9o04ROcQA/kIMSf5KfL3Qq6cjMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743975801; c=relaxed/simple;
	bh=C05dvUGk8Wjj+kul7UnQsAG6yt7LZbH8KKo/glEx6jc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U7GWctjJQOXqui0IzLtdW1T28cY3rvZ2Arldk2QVT1KzlwEAMFSikzJvuxOh2gJry814IKzPhES6mYyIf57D1526AY4yJJxRw03pkf8hizA4OTophdSsvAO6BXSExTGpQg2z37O5hRSZfC3fk+C22S79FaHy4CmeU9CXUfSWBsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ccbxR3Si; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TX78VC9/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 536LMlPt029406;
	Sun, 6 Apr 2025 21:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=UrJp0p38TZ0w4DM8ekkuAt9rhMeGQtxoNOfyyLJMvkg=; b=
	ccbxR3SiimK8c7ajl4elorERssUAkRlPH6QiT4OeaG58wy5ixp4wahW95QUICEdW
	CE4ZlP8iaK/vEPOusxYV3/yewUAE656rL71ocAxROUnNZOKa/Jw/CDXyx3JjfTzW
	pdJk3n7iXvHXLlxXdP/1UB1+vcN0+qhpCgCxmHaIo2d+cSt9mLo7ee9qNwbK+B24
	IBAinjG13PsiEN9EoQu9jPBh2HTJf82hrrnHpOw3b6g39qpWfrL2p1jthdaWpgVJ
	2H04gpAyZkiwWb5Fu7LCO4Dxusr/TQC4i3ss+O3X7E2TldoemYjRXmN4tRYOu8yw
	iZ35MxBWhj259dvQ1Q9oyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tuebhgh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Apr 2025 21:43:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 536L5cGB020901;
	Sun, 6 Apr 2025 21:43:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyd98ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Apr 2025 21:43:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSHVJ5uBYlZmDfRMjg0gTSMbpK9a5LLSKLaOHQU0Ue9HspE4ezNcnnt6YYQbP0O5sjTAa+NQJ4A9gwdAnBHTeF8YPk3VtBGo//UWKErKb922SppxywflsNvCfr27tqAa5cnJZ1YqO91k3rrjv7kjaV1hVmlVCnvNJT5hKF9mJoEHfBZ6R4GW3OYbP3JcE1Tz9yk+IVb00wFr/DYCaZSW6CEs6CB9MHK4Glx124xJBrHedR1gu+gTuT3en0Rro5Y44gGyVVihLlgNFwnutk4682FcxxRt5gOFuSCODXhoiyT1Y0s0HNqbXYpmqoUZ6VRMD6xGAEbeLm6RqsvDbR5piA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrJp0p38TZ0w4DM8ekkuAt9rhMeGQtxoNOfyyLJMvkg=;
 b=nTkAHyL1eXYkqRkQf1qC9A1oJKQudMs+RmoM/uQOUTYSg+ZQ+EQmuTKtTinopN5aI0ukSfZslTVEJrMyYAS64jrFJrTjRZTN8XeNRVoCBiFaIZ/vVzyooGSrL16aUKskevKuZYiNPrtebD6cotMVqYmlMyol32nHZi/BtlaQyemO1A8Be8+HacQxWdVi0M9oUUEO0Gkii3S0sSrxwQoyBsPeVvuADe/2ASzSayo5nlbSvq+xO5y7B/oTFa0bFfhmoAPJiAQDk1J8rAD2s2sLE5jouSM3ayPIoOIXSOu0r9BbnreKfmBC0XHHab3E97ub+VyTFJMIWap8oASsASzC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrJp0p38TZ0w4DM8ekkuAt9rhMeGQtxoNOfyyLJMvkg=;
 b=TX78VC9/YqC/09Z0FvQQcX7riMF0QESenr1n+do/fd45jbKWdEFUwUDA+x+7BIYhgHfuhNLP6HBjvYTqVQlpWwrybSVewJkutEHhGbiRQRXP8DQyYiW0tsqH+lyo6TpVXzo03arOL0fBJy85PN0Pu+4rjRVau33G6AZKnpVbuq0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5664.namprd10.prod.outlook.com (2603:10b6:a03:3e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Sun, 6 Apr
 2025 21:43:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8606.029; Sun, 6 Apr 2025
 21:43:09 +0000
Message-ID: <1ef6c049-7ff5-47dd-a3cf-5bb2f03de111@oracle.com>
Date: Sun, 6 Apr 2025 16:43:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/9] vhost-scsi: log control queue write descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-8-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250403063028.16045-8-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: ddea72e1-d653-4a26-0ba4-08dd75540625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OC9TWVJzeWI5Y2NSdHFEdVlLSGFON1hFekhFTmZ1eW9iRHFsbWRkWjVkTUFI?=
 =?utf-8?B?bVJNT0JkS3pJRWhpZ2pIN1RjR3lHeGpIQ2tJaFBBWDlOZjN5YXZEalhqSXZz?=
 =?utf-8?B?cVg1c3lMYmtjdVJNaXFCL0pSSFdtMFRXbDNrMk9hbExxNmZQWEY0V2lpYjlk?=
 =?utf-8?B?OXRaTXk4enFoS0R4a0R3b0kyaHB3d20xR0o2WUl6SHFSTGlBK0tTZWhsdExx?=
 =?utf-8?B?S3UzR0RlcHVLQzZoVVVDWTlmS09Ld0lkd0gxQWdKeUhqRDJsaVRwdFBNL2pR?=
 =?utf-8?B?TDhvK2h5dlNPQnJzYUlkNGxTb0twN3RsQUd2NHpMMGtGeG1aUEVMZkhxZG9x?=
 =?utf-8?B?MzZBZjNnNm5hUlBWRk9SdDNXMHE5aElMVnpGYWNlNmJqaVJXQ0VCNjhxQ2Y0?=
 =?utf-8?B?eEFXL3NSNERac21aS29GTGN1SStzWGVZRFUraGxVV20yUzFUQmVRZjFlOEFx?=
 =?utf-8?B?cUp3bDhoZ0pTaXA3bURHMitTdVZCUklUMURTRytqSEJoVVA4enFrb3BUUFBj?=
 =?utf-8?B?Q3BzSDRKYmovdjBPTk1JSnh1UGVINnNReEYvR0dJQjNUNXp6SElwMVByZDdx?=
 =?utf-8?B?OWUvTS9ZdVpVSjVTTWxvZnczM3VTTXlDK0Q2ZmVyZUxtdUozYzJVT08xOE8w?=
 =?utf-8?B?WXp0RzNoMUJrRzNSWTh1VktwNWIyVjNXV3A1dGJtd2NVRzM0eVMxSTMwZVY5?=
 =?utf-8?B?UEJBRGk0VEZXSXlzT3RIWk01ZUhXdVhOVC9zdUE0OVVoTUJtSUc1amFEZE1O?=
 =?utf-8?B?R2xUQmZKdXYvRHlDOGh1RGFqbWRyR2wxdDlacWJPTDlIVENpRGFEd3pyYXdo?=
 =?utf-8?B?WHBVZ0ZJdGhvYlQ0SDZlVU8zRFAxTjk3RXRVeXE1cDZ0NzVRUEpYbFpPS2tm?=
 =?utf-8?B?L3ZnYWRNTklzS2hlNzRHMmhJMkk1Q0J1S0NlNEVUc3R0bVFlMWFrWDVBQUJQ?=
 =?utf-8?B?SU51ZTlYVmFaRm9KazRJZWdhS0NGbSs4OVBoMTNDeWZjc2M3bW5GU3VHUXlz?=
 =?utf-8?B?cFhuR1hNSlJVdmk5am9VQ2hnb2lPRnFUcjA0ODZSaEhqaC9BbTh4YkdUaVh4?=
 =?utf-8?B?RDdoV3BiL1hHS3NkbFNQREp3eTRFSHRXaVExVENJdE1CaEZDdG9hQTRyd3lw?=
 =?utf-8?B?My8zOEdsZEh3WGsrVUhoZUxab2VxK2pSb2RMck54Z3QycGdka3Ftc1hUQTBk?=
 =?utf-8?B?T290enk0ek81VXVic3BqQ0NkMzBwRXBiU1JOeXlZL2FLQzBmVld6eFlmMXox?=
 =?utf-8?B?SFR4ZzRYTmx1cjJicitJa2NvZjhURHhjVGVzZ3lkOUNDTkNUd3NSQkhJd1ZW?=
 =?utf-8?B?d2tiNmNTeTNhOWlWTjdqWWN1c2tDRWx2RVBBK2RDNmNiVzRqRGVGd2J3enl5?=
 =?utf-8?B?b2lXeHBjR0J2VTlOcUdSNDlEZnJvNTVocFJNQkFwRnJqRlhsTHVVNHNwOWJE?=
 =?utf-8?B?c3g3Zm1mbTFqZVRWTUZoVTI0eE0vMlpQOEJRaTQwVklEajRMZzRWVkpjem42?=
 =?utf-8?B?b09xVmtVa1FmRjFXVmM3RXZtWEphV3F4SVRCTVNTRjRuVGRQbmNaQjdaWG9N?=
 =?utf-8?B?Zzg5ZjRVdlQwY1lDQ3g4dTFWUW56NXRJc2llV3AzTkpCdjFXR2hZbnBGbWZu?=
 =?utf-8?B?RzJHK3lNdDJpakYwM2JEUkYvbzA2bElYTUNXRzdhTHM4eTFlQ0pORWE3cS9B?=
 =?utf-8?B?ZGp6ZzhVY1RxU3hlbUxpTkNTcGQ5ckNiZGd4L0V3TzlvY2d0bzRySGloOTF0?=
 =?utf-8?B?TnBtTVFNa3NuZUlLNmNQTXc4RzJQeUEyQStwdTdhUkltTGNxbXB2bGRad0tk?=
 =?utf-8?B?bWN3TUlhRDhKTnNnZ05KbXJJVzhpSzhUOUVJZ25HWnZoNW5wRVc5R2lXSzlw?=
 =?utf-8?B?bzRRcmRKQi9ZZVBXYzFDakRDVXh2UCs2QTZZUURWbWtmbmdtTUJEY0hrNE1o?=
 =?utf-8?Q?V4Q6omhWyok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VW1hanVheUtobDdWYkwzS2dwWk13T2l0Z01RcVJ4RkFJTTgweFIvZzhkMVFK?=
 =?utf-8?B?WEdaMXdqTGNVWnR5SzdBeGNrT1pXNkRUeThpUUZVZzVlbElEQ0hORlZiZ3ZL?=
 =?utf-8?B?bENLU0dzblVVRlJCSWllT1prYXJidTF0UndGTjlzRnYvTmNIeUU0ajJSR3Ey?=
 =?utf-8?B?MXp3R1ZhUVdqR0t3TkdzSlNqODJmWkVDek5oSGt4MTYzek5JWlppSkZ5bFlY?=
 =?utf-8?B?QzZBZFpJdkV5ZC9rOW1aTWEzQnBoNWxkeVVRc0l5UDBKZlJpOFFVNFNPakRG?=
 =?utf-8?B?dHBNbVA4K0haL1lxaFBhdlZvK2hldTJmc3RKSTRUUEFpa0lTbmR5aUZ5ckQz?=
 =?utf-8?B?Q0I5MWxyQi9VT0RibkVkWHhLUFh0blViMjQvVmhXWkcrakl0UXJhZW9wNFF1?=
 =?utf-8?B?dlB4TmJ6MjFZakZPbW4xeTlXR1RLcHRYdmZScmNLWUd6QUlvOHF2Wlh5TG9a?=
 =?utf-8?B?MFRRWEtueC9JWklUVlNjSVZaWW9Jek9vYnUwQXI3SlBjbnI2ZmVyUzVRZjB0?=
 =?utf-8?B?Mk53Q3NHQ2lhRVpmU0xJanBPYTdScEh6b05TT09idkV5TndGMWtPcDZRKzB6?=
 =?utf-8?B?VnA3b2F3Ti8yZkRWTmdZZjVCQmZMR21WdC9Mb3lQNkdCUDdJWWpFZWdyS21v?=
 =?utf-8?B?Q2FSb0V5NEVnS3d4M0JkYWdId3pqNS9HT1k3eGNscEVsQ1JTOGtsa2FDY2x1?=
 =?utf-8?B?cGgxclYycE16Smw3TEpIWHRWSTJYTjNBUytJcUlIT2FKSWIrK3lRNHl0V1RB?=
 =?utf-8?B?SFB6Si9XajlrNENqTGx4b2lkM0hNNXdDZnVlbjdxWnhvd2VVS2dNMXh5SVFU?=
 =?utf-8?B?NFY1enJhS2x1dXJUUHJsbXg2Q016ZU5zaENMRm1xQW8yQWlrdWVJVkRnODA3?=
 =?utf-8?B?MkgzTmZMRkhqRTlTbXZ3aklTbGo4cmYxbyt5a0xJVHpFbHlnUEJNUlFCS29m?=
 =?utf-8?B?eVRzZDQ1WjdRMU1YSnZkQ2psRnNZbW5oeDRBWEFrTytUd3A3MGs1emhkRHJm?=
 =?utf-8?B?Nm9kRzdiNEZaSktLNXpqa1NiTXZCQXNFQVNVczlhN1lWS2V2a205MXhlNE5y?=
 =?utf-8?B?Z1JpdEhtMGFsVVhySVpST0cveUh2OHJDbW1WYm11cDZjbzdnWjVUOXpuY3pl?=
 =?utf-8?B?M0EvYTAvM2hnVkFIRjBwYjJzcjBSMExXK0o2cGI0RTBZU2JBK1piZ1B6VGRx?=
 =?utf-8?B?Y29NOU45bHRxU1NpRkhnNTNwOStGUjNYNEh2bnEvOGwxL2VoQTZiMDRCVU4w?=
 =?utf-8?B?aDFzbG01UXljN3VPTEpBSi9oT2w2MTN1RkNjbWJtUGRRTStISHAwbi95TW5y?=
 =?utf-8?B?SlVKR1ZzOWhqQ2t5eExDWGtrbGswTDVoMWFnb29wMnE3N3VPdVdpTUdkVVdB?=
 =?utf-8?B?Rk1KQjlsNDV2eWlVU1B6MWpkYmxxdWNMWHVQSUhWTWVXdDVHVFM2K3ptT1dV?=
 =?utf-8?B?RCtHZ0dMVHN6Qng2aUJaR1ladllQa1lOZHIrZjNENkFyQkNIMkhMWVZLQ0dv?=
 =?utf-8?B?Kzk2WGxVblVGWVo3RlZuY05hWDgwTlg5cjAyOFh0SEhkNGRSeHhrRVpxRHFh?=
 =?utf-8?B?NjBpekpmazJZdDZqa0h1Z0psY3RORnlmL2UxUVlXSlprTnV2bkZrWGJpYk5u?=
 =?utf-8?B?NkhrZ3h5TnhJdE9GYlc5OXpqTUkrcyt5NnZ6aEttUXdMQ014N1c0S0pBN1Na?=
 =?utf-8?B?SFRlakcrNTFxVEQwOTRSU2h6OEg0UStaQlFmSktYc1ZIMitPeW9rb3VYeTFU?=
 =?utf-8?B?VEVDQk41WVdKQVNXWkxpVEwyRSs5UGJzUlNrVzM5WXRLQUwyYjdtUzRPU3ll?=
 =?utf-8?B?L3ZBeFJ0RVo5UVJMTXJET09ZRjcvVEs5ai9MNlR3MWQxTnQwWVU3Q1AxTnJS?=
 =?utf-8?B?eDcwTFNTUDg2cS9MOFExRDllNFRtQk00VS9STS9iN0dlalBhY2pVWWViOXBO?=
 =?utf-8?B?Vkd0eDUvY0JJZUFKbmo0ckpFREc1cWJWZitiK0Y5SjRIVlFxRDk4WXV6ZXhi?=
 =?utf-8?B?N0I5ODZjdThZOW53bnQyaVVoUmtleSsyRkFDT2YrT0pUTktkVXdsQjlwNk1l?=
 =?utf-8?B?a1JXYW00SDV4RGhGeElRWlZLWXVaUFl4aWJLT2llWW9OZW11eDdZa2xOd2Fx?=
 =?utf-8?B?WVY1NTJIOTg5V0pKRVJISU5XWmVSeXBOYjhWNDlJdUtCY0s2Zi9BbVVLWlhY?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jniMQrXqd9DXs3CFc7t48Pv3GNlgnpImM5zmSBE6NvIzcd3TXQl1/U/ZufuF2YuQAfqYMVqM1uFIO/i2KDOzatozfxAGV8XGEv8pts5H2A32q4/7tUBrCBZLn2Zvhcy4CiLqrQdykNyURlJs3fdjCBXfxoYxsq9rYtm4P62S+wiSW0BIvsAybJEupvw14SdA6jYMGRT05XgE2IkeqgqlXXqRUB+TvqZG0cMq8A70OI6bCGBH9ZD8KcEG+ZPdrONXlD7mzN2nNNtmabGiGmDJwQw/6fNJwzotgwabBmueDigJ2mhBYIeP7C2+kjx2iPsEYRpGuHgWcNYjLxdyXu4fdhBtz9v4wceG1Hn8IdImGKOSjFRxipcK36nmerntL1ckeZv3caqWOXdADmzHjOdjOfkukYGMW9hnILs+DyakgWQd1L33O+chBUde3LE/kVmZO9Vo3PNfU836YBY9ELp3+Sh8Vi26v3DS57bWqcmgEtddw3vHX/nTh5w81mxMrjpwG+rCW05jIpKEU5cAsNj7kqE7PhB+SjLD7KLZ6z/oyf5J4ijfJwoXDKzG0sh4J5mJLR9K/P3BYHUmW1cRc1Yrr17uE7opZhAnhxFuBGBbtVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddea72e1-d653-4a26-0ba4-08dd75540625
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2025 21:43:09.8791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SiBWE/J/bw/Q/tLfi2JD7XRS30irFyd/SZ9RkAvUs0tGXleaOoqLK0p4jZEORoH0RoloxJcUIW50U/h6u6OQuz/biZubP1NZvsqtRncWvlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-06_07,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504060159
X-Proofpoint-GUID: 6fywodSi3qE2QOdmJJKQW6HHPPVNF7To
X-Proofpoint-ORIG-GUID: 6fywodSi3qE2QOdmJJKQW6HHPPVNF7To

On 4/3/25 1:29 AM, Dongli Zhang wrote:
> Log write descriptors for the control queue, leveraging
> vhost_scsi_get_desc() and vhost_get_vq_desc() to retrieve the array of
> write descriptors to obtain the log buffer.
> 
> For Task Management Requests, similar to the I/O queue, store the log
> buffer during the submission path and log it in the completion or error
> handling path.
> 
> For Asynchronous Notifications, only the submission path is involved.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

