Return-Path: <kvm+bounces-35250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C25A0AB90
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 19:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51C0B1887339
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EAA1C1AB6;
	Sun, 12 Jan 2025 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aGttjXK3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tFw0zWrk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF511BFE00;
	Sun, 12 Jan 2025 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736707845; cv=fail; b=PhMCgi3h1/kQBpVbZiMsNjxz37x3feGGjXklXaOxwUG4hd7X5AUSZrvlkqKVhq5BK+MTx9IrkuyM3UXMDlagfyyI1xTyPGeUJnm8VhapzxSusaEQ7/2rnZJnb+KbidtIxNuP+WyS2ZfbbCjy09v1G3mV6EY5BoqTlEC9BEHyLE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736707845; c=relaxed/simple;
	bh=xaLOuxAE9w21l7abIdfJXoV8Kfw3D6lehJMuzHPnUaE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ph3NI0l+ntaraaebSfKjrB0TSf3wQ7NMcRfu6fYBfhoUm8o6ygMHrjEjia0uGctWmCxwerZeYoDahmM14no0YrH7gIaoN5rid+ddsT+xRpGbWyLwfQtmaxyzz/RS2cF20HO3xUXU0sehbhkB18BwKLfbsaNXNuZ9ckCQ4Gy0xjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aGttjXK3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tFw0zWrk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50CHPp8Z022502;
	Sun, 12 Jan 2025 17:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8jdlBCkwLSwzXh5O6l9tNZqG0N+Npai3l9n5j41FYNA=; b=
	aGttjXK31o5355kCLHpJe8h/dM9/rRtDxy51qZ8+vvJYyGTiwanNHHxkRtBnYe5E
	Ir/GQv0/d0ceMQxhM8W8N3DPeJtTd6rV5EixdMy7KRdEjRgag2UD/yS0iUaRklk+
	KRW/9zTtDZ/U0dkn+UMgY6JHTjWW+JkCqJOLhLdzeQ02N3QbT2AG8ppV0OilPaRy
	UwLBQeStexGlm+Wjv/jHRDyILNC07b8ZohDn9/m3RFRR+t0tAofGNLOK2fYwZtb4
	MP8z0TpHqPkPPivKSq3LqP0/qCdb3SAgb7KdzUeM5zEPiM3Q4kGNbG33oF/lFiiP
	gf9tt3jYFWDwkb0knrXxMQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gh8td4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jan 2025 17:35:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50CEPJEO033214;
	Sun, 12 Jan 2025 17:35:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f368gqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jan 2025 17:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nq48/AB7Fky6hzjo/9mmzuO2DlSyNL6FZZhBzoZYGCXoBuX46RYi47DWp9qMA3IH+gOWmjlvkBngIb5KKwS1oGroUGoIHnuQgyXw0PIYQdZ/89ZjJxGCHsK6Mz640BRhSliBUZXg8dU0D3BGqudhVyJReUkVZ9CbHmyMs+esp80UZA/3AYGY8VdHYvV5kozYEZktfaxyUGvD3ZpuIV/zXFVXclFpphQpcD0+3o6+OLqxxDt8IGgMmTucGJUZTZ1RPMsf696ggeBNtOLB9SzcYrPdsDL0vTQpHtTNIg/mmaLSjs3k0YtnIprvIEZUMId9WON5OceVPKNygPWl5/nnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jdlBCkwLSwzXh5O6l9tNZqG0N+Npai3l9n5j41FYNA=;
 b=P+Qmq1QI0uVziOBrndhD58lKhXWusA4ORUbbErM6k9tShuC1oRiMrYtNaqLAGon4JnskOfkGyBCFs8bA+eKycm+wVjlQtQvZPH0vISB/8ly6DSEBtaKFLJScjsj4/6luGD9Esk9+bFnNn8NfZN724qA5RZcTkEubr8HAqlDqT1qn/RGyaCEH4aeS1uJnccRrHEaXLBxPNcgKCJ5bcQFzqRzZsM5nPSsuUR4apXp6f9C+HnGuzoo/KQ+RfzjKLiTPw15HxaBqWMbOrt+RgZm1qk43i2LqM/PlFzLgy9TYoaXjbEM9p12SzQT3IUzLb+hPv1EtxwiJER+FdNmrVdb+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jdlBCkwLSwzXh5O6l9tNZqG0N+Npai3l9n5j41FYNA=;
 b=tFw0zWrkUD6WwjqVKBPKzvy0gkYlj32BsQLEmeG4TDW18boRVJNEAD7FKuY9DYVZHdakXwrV+MASHony4BWpTGh89zUMXpmvdWnn1R8tvNdqtfp/fSjBdznAbGhuBu6M/5mIPv/wjCMPuG3SlGetzB5y87DwFUqiH5htJQbaJ94=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Sun, 12 Jan
 2025 17:35:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8335.015; Sun, 12 Jan 2025
 17:35:22 +0000
Message-ID: <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
Date: Sun, 12 Jan 2025 11:35:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
To: Haoran Zhang <wh1sper@zju.edu.cn>, mst@redhat.com
Cc: jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250111033454.26596-1-wh1sper@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: 662d7904-9456-4a92-2aed-08dd332f7df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UW9BSkRRWnNBT2ZVWG1pRXhEZGNWMy9LNkVxRys1QUFrZmFodVdTRmdUVk1x?=
 =?utf-8?B?QTAzQlJKL0N1dkdzZytyWGxJWDdsZEJaWXdNUlNPSmpZdlE3K3VCZmdoS0w1?=
 =?utf-8?B?UFRkcEladkpQdzliZFR2QkQ3T1NqZnM2YXBGc3VrenZnaEZUbHVqYXJYRGh0?=
 =?utf-8?B?RzlEcG9FTVF3bTNhblU4dzJDRGgzeGtuWXZpYlZqRWdrSVJSYVhYWjBtQVYr?=
 =?utf-8?B?bk1ISFUwbFlYeXo0eWx3UlNlMDJyeHlPVitIRUN6Q3ozM3VqZ1NRbVlCUlZS?=
 =?utf-8?B?dks1MnFtSzRENVNpSVd2ZG96TGxQZVNBT1UxcGFPZldEUzJpZkxFVFVrSnd2?=
 =?utf-8?B?dDFtSUk1ayt0U1BIT24zRGZBOWpCaTltUnNTN0JzNTNJMVhyYTFqaTVnSzZ1?=
 =?utf-8?B?cUkxekRVTmdlMUU3Uk92UFp0N0RXYXorNFBJRjJEMmo4anRRa084QkZjU29z?=
 =?utf-8?B?TXhTMGo1YXo3OWp4V0lRVXVQUUZTSk1hUWYwKzVkaHBrU0xOVHNsNjNHeUdL?=
 =?utf-8?B?OXlzYnd3cW0raUNUWmw2aE84WFNEUDBWcFoxdTE4Tko0TkJmQ3NndVIvWHJE?=
 =?utf-8?B?OWtiMHZwTVlkMFRRbVBVY3c3c0pxaUVQcWV0YTJCZU5TSk5uc2xuTmdmRmhQ?=
 =?utf-8?B?V2ZGZFRaTW1JUndqSkEwaEt4WDJ5YmRQZnhGa3BTMUZienVGckkxbGpoSENH?=
 =?utf-8?B?VHM5SWNscHJGYWNXOTVLbEFaQlJJcVFvdXhaNWxiMUU0aUlYNHlVSkVpWXdY?=
 =?utf-8?B?WmRibXRUaWpVU2VMRWcxdFJId3ZHRitldnVlU3BqQWtKaUFNZTVjTWxOWDRH?=
 =?utf-8?B?Z1ZqcmR6bldCemZzUzdHcXlza2RacU9OaEg5ZjRMdnVYZXljRlR6YWhVd0t4?=
 =?utf-8?B?WGFQQ2xyRHBMZDRNalQyN0JvaWt5WUFqNEJpajVuaVJnR01NeEd5bVVvbFBv?=
 =?utf-8?B?eHhwM3ZPMHpVeEptWFd6SGVScGtKMUYvZFE5dTV0TEhYNlNFSzdMNW5CVUtp?=
 =?utf-8?B?VXRtalZENGVjTko0RU04bEt4UStjYmNuKzhpTEhlb2lsbEVaT1R0VXJUWVVm?=
 =?utf-8?B?MHgxV2k4V25jcDFteHA0cVZRTUdrbkdoUkJ4VGRkS2xDa1lyZE5YeGF1eGJt?=
 =?utf-8?B?b2lKUEdYd21XeGpNUDZCR2pIZkJRWDd4eFBPaHZrWmtyWGYyV2NueXh4R3la?=
 =?utf-8?B?MEFKclNyeEhXNmVZNlZCQXVuWmZGdWZ6b1FmM1d0NGxOdEduOWJISHRsTk1u?=
 =?utf-8?B?bWpVb1BZUUdYV0lzN0NyU0krNVNyMFlFVEx0WTExR3lzbXIvVDFHenAxWGp0?=
 =?utf-8?B?Z0o0dzljQmQ1eTNPd0V0dk9PREIxUmlpVEl6VnIyQmpSMjNxMGRobWptMzgw?=
 =?utf-8?B?bVcwOVd6d3dvT1pYUjdpMUh2Z3Y5QnNFWWE5Qy9QVzhkbHZzMUxLUWJjNEFi?=
 =?utf-8?B?bWlQSkh5WDEvdm5oeTl2ZjRBMVBrVGhaQ2M1NDhaeE5zbE1rWlBCRnpZK3JJ?=
 =?utf-8?B?RDdYWVJ1b1hKZzl2eXRlVWV0Q3BvYUVtN2JyUXdFMm4wOWxuLzkzdXFhMmpw?=
 =?utf-8?B?c0FzME45QVovUlZESG4xeHUrRnE0U05KRFBrWkh2TWtSR3kwajlPWnhMU2Fy?=
 =?utf-8?B?ZUpQK0ZpeVZCY3VGMy9ybUNXZVRQbXliQVdhcUV2bklMZkVZVzViZHFzV0Iy?=
 =?utf-8?B?Skw3UkNkRjBSNFZSc1pTbXNnNzVPRWRZNmhra3VZWEkrbFZIS2kxcDRHZWpL?=
 =?utf-8?B?ci82cVBCc05sc0JLdXZ5QXRObWRycHdFNW02Q3hZWVkvTFBEN256blVralJi?=
 =?utf-8?B?ZDY2clR4SFFCMU1wWHRlN2FYMk9uVEluMHJJK0x6SS96ZSs2dnZlS3BwdWFV?=
 =?utf-8?Q?Y5UMrBiNCHvqw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGp6b2dyZ0hsNDh4RktTVXdiUHF1MGY4SnpQYVhaRHZBL3JiYmxxS2lIWG5M?=
 =?utf-8?B?MldjNVFWRHRJaUtWNS9aNmVFR2ltL2U4U2NTS0pnZ1lhUzlEVHQ4QWtsVXpr?=
 =?utf-8?B?S3Fkd05RWFp2SEgvcm5sWHl4dERBeWo0SldCNVVkN2J6UTZoUWVOK28ySjRS?=
 =?utf-8?B?UURLOEdCRkg5dlFoMDZSbStkTXo2WGdIczBBYzVDQ25GOWQ1S1Ixa1dFU21B?=
 =?utf-8?B?OHBwRmdpRXBlOFBVTlpsdlZ5MVlFQnBUbXl0MWx1WFk3aFl6ZWZkMmRjWnJD?=
 =?utf-8?B?STJnUzJ0MlJJOGlXVmFDdjUrK1N0VTYzNzU5Q0hqdzFqMXpPY3Qzb0FGR1hT?=
 =?utf-8?B?ckw3NEVKK3F2ZnJRWmFJcE9UZEFqaVgrSmNUTVlGUVZodzI5c3FrZGttMFNR?=
 =?utf-8?B?ajlPK1RhZlFIdXNJR1h2MXltbVAyM1lRMGZrYmk0enJKQVBZNGUwVnFKRmlq?=
 =?utf-8?B?TVU5aEY2aTlxTVFDRHpUeWFqUVc2a3Y5bUt1ZDMrSzNCZ0hvd25xZDYvNGdE?=
 =?utf-8?B?VFVQV3ZVRElHVVYxV2QvTkltZEptSUo0MVlEc3dUTVRScGY0azk3d0kwMnNF?=
 =?utf-8?B?dVpjZzJPL05kRllneTd4VGwxZVdIUlliT2pGd2UwclYyTUpUcVJpc2hmTlJP?=
 =?utf-8?B?RlZoaDJRRll3MWtpZVp0OW9xL2pZa09FSk5ZU1B5RlcranBpdzBHTXNzTFZP?=
 =?utf-8?B?b1hIa25BdjRYZFo1c3hZM21qdmFSYnZnWngzMmxGUHpYRjgvSlRWNFFSWTd1?=
 =?utf-8?B?Y0tVTHg2aU1VM2o3MGxmTi9qbWYwK2ZqTEE3MWVlWWhDTkdaajRvcXJjSmhk?=
 =?utf-8?B?ZTRmeVdRQjlneXhvTnR5ZFJiblYxRjhONitDYTd6dU9YdWpFYnJBKy82RWhs?=
 =?utf-8?B?L2xMbGptbGl0K3NpRnJvajNtK3l4R2NjRXc4Yjh3cXlYaklnekJyMWhTYklS?=
 =?utf-8?B?Wm1ndmJwL0hMU25jbEZTczhSam5OT0xCVU5WU01qOEQzSnFPSlR2RzliLzZI?=
 =?utf-8?B?RCtGa2ExbVlWOUFHTXpWLzY1ZW4zNjJheC9MNHpFdldrWTdUclAvWHhlUlZ3?=
 =?utf-8?B?VzJWbi9jVE83V3NGbGF1OHdoUVY2Z0F6WHhFKzBVc3ZzQXlHMUhNL2c1bEU3?=
 =?utf-8?B?dXJ5d25iNTkxT3JmNkdUM1MrMmtWMlFKeW1jdXFUTE5ubXFoczUwZFJTWWc3?=
 =?utf-8?B?T1FDeEtGVUxkSTVOU0plUlA0V2hDRiszazBLTnZMdlk5NFJlNC9zdWdpcWxr?=
 =?utf-8?B?NU81WUpuZWQzNHpvZ0t1NDBmbW1oOGd5d2ozaCtFNCtYaVJwcDhHRmJsRERn?=
 =?utf-8?B?Y3lyd2I0QVpIajQ0WFpOWU1GRXN5a3ZTWHZ3TFNmMUQvSDhDbW5wS3hZbmN6?=
 =?utf-8?B?bEdCNkxUeklLcXgrWkltZ3d6UjVKSy9OUkNDSUtmdXV4V2ZMdkZEUEtIeTNN?=
 =?utf-8?B?VWp6K0JybGhDSG4wVmpnWGFHSTlqeVVzeS9qZzI0R3F0ZHZtd0hnS2ZlRUxy?=
 =?utf-8?B?UDQxV3UyVEd1ODJkdk5KdEZQQ3hxa1I4ODlqSklpcWJNVnZlUlIvVHJicVJD?=
 =?utf-8?B?djhBU3kzZzNwalhoMDFFWVBvN1ZJWUZkNEpVYXpaQ2M2OWw0OUdpTjEyL3Qx?=
 =?utf-8?B?UjYyLzMwa3lYMmFxYjJabVJqWGl1R2F2UXZrUFRYcituWlJOV1I5a2lTbTVn?=
 =?utf-8?B?TnlsMkpBb0VWWnloOUZyMDFSN0o2MG8vaWdyZGkxcnZJdHlPUzBBd0ZiTmRW?=
 =?utf-8?B?NjUwT2Y3cUNOK2lVMm5UOFRUa29vUkpzcjk3cmNyVzdmMm5Iak5WZEdaVDRL?=
 =?utf-8?B?OUNzclM0ajc2TGE0czhNdHBtbm1rNWpOaU5DNUZOY3ZHWDJLekhKdis2VmpD?=
 =?utf-8?B?d3ZCQlBXc3pRcGtoeHZqVWhHdFhNZlhiUzdPNW9NVVdEbm9QRzROai9vL0JT?=
 =?utf-8?B?Wnl6R2NTWERsczBuNy91Ujh3KzBLRUpiR2xCREtIVTVkNWFUQUZOMmhzTnNk?=
 =?utf-8?B?RGpZdGphVWVvaGpWYmV4emdNWkNXSkRzdVl3RHV6SW1zQkZWMFNwd3dRODgx?=
 =?utf-8?B?ekNMbzhvL3IyQXBSbGhYM01uNkNTTjRUUVdMejUwaUxEMzBuckFLYkZkcnM0?=
 =?utf-8?B?aVE2TXBiTkxJL1BLMGRndXJKS2JKcVNiZ1ArMktjKzBmd2dHQVBCQ0U5UitI?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RGAuHQujXH0XiMTbHhoBs7FmqX4wxJQIWb6fd2Al1tatKypB6/Ungfh319X9e7A7RKVJWfRFgysWNuqyBohZWuF6luhvu+3k/ekK39eWHULxPihxluiuwhtkgsNjOByZGzOit7V5y7Tx+kXx9DGJWcPg8yroLjGe+ziiKSD2MKXq3u5PDnirT/J6S5RXk7H1Mvf35OjlmAQXZpVZTtI3NMSqKZokdZv18BCxFV8hOnT0xfExPrUS9QTlhz3BVdEtWOXwhG9BGdz6zmVffcoopp3ebYW25PM2JYV0zxeHZpsypXqhU08SkF4HUviajnw0JsWFKd2BgCavlB5h5wYvdShN7Fz4TTPCl1dLfLWUiMHpEE27ZkQKtV4nYNDPsI7d0pXdOpWC2QSCaZ5BR3lZ03B0BybL0TBSOp1w/1d3/bcBghItrp/LPmsZCF2LcJBIjAH7dlSerm2djPgY0n4pu8dFm+OM8AOKfpgERNbXT4kpxXNfPfmJ919AQ4+GejhKqzNYkeTWTEO+ZY0k6L/Vf9t0fDT009Mg0n4JnoFjlVCAlZ5Yo8pfADdJW/zHZ3yVYeZsyjlNjJWQpvxhgOhtXxyU6kV/Dt4lx9NMo3tkxuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662d7904-9456-4a92-2aed-08dd332f7df9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2025 17:35:22.7781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9OJ3YkrP6fab8ZmxjbqiYWt68fRbNVRFGvoUirntoVfzseV0YqksCj1Pd/Qxz041jzTS6fmvnNnLV+Zle2ETxYHmTJ/KZv0JeVg336vgv5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-12_08,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501120156
X-Proofpoint-GUID: QGSGGXTzlMMH_qAjdNQj1uxSbZuyb1Ev
X-Proofpoint-ORIG-GUID: QGSGGXTzlMMH_qAjdNQj1uxSbZuyb1Ev

On 1/10/25 9:34 PM, Haoran Zhang wrote:
> Since commit 3f8ca2e115e55 ("vhost scsi: alloc cmds per vq instead of session"), a bug can be triggered when the host sends a duplicate VHOST_SCSI_SET_ENDPOINT ioctl command.

I don't think that git commit is correct. It should be:

25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")


> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 718fa4e0b31e..b994138837f2 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1726,7 +1726,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
>  				mutex_unlock(&tpg->tv_tpg_mutex);
>  				mutex_unlock(&vhost_scsi_mutex);
>  				ret = -EEXIST;
> -				goto undepend;
> +				goto free_vs_tpg;

I agree you found a bug, but I'm not sure how you hit it from here. A
couple lines before this, we do:

if (tpg->tv_tpg_vhost_count != 0) {
	mutex_unlock(&tpg->tv_tpg_mutex);
	continue;
}

If the tpg was already in the vs_tpg, then tv_tpg_vhost_count would be
non-zero and we would hit the check above.

Could you describe the target and tpg mapping for how you hit this?


>  			}
>  			/*
>  			 * In order to ensure individual vhost-scsi configfs


However, I was able to replicate the bug by hitting the chunk below this
comment where we do:

ret = target_depend_item(&se_tpg->tpg_group.cg_item);
if (ret) {
	pr_warn("target_depend_item() failed: %d\n", ret);
	mutex_unlock(&tpg->tv_tpg_mutex);
	mutex_unlock(&vhost_scsi_mutex);
	goto undepend;


> @@ -1802,6 +1802,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
>  			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
>  		}
>  	}
> +free_vs_tpg:
>  	kfree(vs_tpg);

To fix the bug, I don't think we can just free the vs_tpg. There's 2
cases we can hit the error path:

1. First time calling vhost_scsi_set_endpoint.

If we have a target with 2 tpgs, and for tpg1 we did a successful
target_depend_item call, but then we looped and for tpg2
target_depend_item failed, if we just did a kfree then we would leave a
refcount on tpg1.

So for this case, we need to do the "goto undepend".

2. N > 1 time calling vhost_scsi_set_endpoint.

This one is more complicated because let's say we started with 1 tpg and
on the first call to vhost_scsi_set_endpoint we successfully did
target_depend_item on it. Before the 2nd call to vhost_scsi_set_endpoint
we added tpg2 and tpg3. We then do vhost_scsi_set_endpoint for the 2nd
time, we successfully do target_depend_item on tpg2, but it fails for tpg3.

In this case, we want to unwind what we did on this 2nd call, so we want
to do target_undepend_item on tpg2. And, we don't want to call it for
tpg1 or we will hit the bug you found.

So I think to fix the issue, we would want to:

1. move the

memcpy(vs_tpg, vs->vs_tpg, len);

to the end of the function after we do the vhost_scsi_flush. This will
be more complicated than the current memcpy though. We will want to
merge the local vs_tpg and the vs->vs_tpg like:

for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
	if (vs_tpg[i])
		vs->vs_tpg[i] = vs_tpg[i])
}

2. We want to leave the "goto undepend" calls as is. For the the
undepend goto handling we also want to leave the code as is. We want to
continue to loop over the local vs_tpg because after we moved the memcpy
for #1 it now only contains the tpgs we updated on the current
vhost_scsi_set_endpoint call.


