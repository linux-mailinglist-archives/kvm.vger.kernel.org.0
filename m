Return-Path: <kvm+bounces-15742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 519C88AFD72
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9FD51F23C08
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFA24C81;
	Wed, 24 Apr 2024 00:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GD0BBPhl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OYR84XU+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C6846AF;
	Wed, 24 Apr 2024 00:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713919866; cv=fail; b=FJRTSUbmuXN92gOnkFGqN3JkmYGaDcAJcL0KMou4fPqUO/2MJQMCB0eCT8Z0pThYXl6Q7DBA+quyVb19fcD2ErbcasVXQTS1zqI62a8Z08PSRRqKeXiKMhimjf9MnFxU+CUVS7IGBf1ZVfmmyw/1QEk6RyjXva4qFRy7priabis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713919866; c=relaxed/simple;
	bh=mdGhMqSiQZerBk++Xe0KVYge4UF2kLAzEkKmT9z6O8c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R+2w5+NnW9m5A/QRGsFDVgIUrk3Q5tfCegQsIBJDt+WlRUfAsdOPr8z0m3qAR38mfNbN/8ZnOYOQkpZYttHbgIkJV0zgNkaDxIKkJbVHsRId9BRJIsWuyrZkLdDvIN7eu2uXG1CwRUXc+SfJ48vXsE5LXN+WAPMkcfWx32njFJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GD0BBPhl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OYR84XU+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NJdB9s017202;
	Wed, 24 Apr 2024 00:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=mNTF1WGh2/KLRAMsF1z3mxFgoTJye32M8erqePALIvo=;
 b=GD0BBPhlGDWTDpGATq2C5ejdDWmc/ywwL28PYrF2ehGuMnUB0OJZ9HKYvl8xW1DC7Y7F
 nmqDyw290FPtDd8p61OmZZ0B4z3F+O5Thh573v+04tcfZFMS4h7AHphLZ/tyHxzkmI6h
 lQ8K6bj7PJl4TgsNiqGcopGedtDMh1aiQl9/ZWAYJiNSMxcx2hZJcJGdXiXa/um2/WMJ
 aoYZ508c/rY7hA/YioNvOFfS+xahFfq7Ry39s5wdcOtghBhSQvs2v5dH8pJGVRFFXfrI
 2t5A7qc0oxZZPdZZ3RIplXr72UYCNwHckXA8IPlwqipXI4FRT1wps0p6Ez6VixaniBGo MA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4g4epf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 00:50:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43NMWvh0001710;
	Wed, 24 Apr 2024 00:50:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm458kbg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 00:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCNmHV92NaxEqmwAsS+T/FR1hxT9lLnyfIGfSE6bnUAf7t5D6ruxA7rGouxCByA8e/zVKfCHt5yaQ0LHoz+j54b0MIqi2OtiPJV3L+IynM9o7NfzqgrAt2JqYPvh9qxODZG6Eq55pBieLeXtARPX4w774JvQgxf5kQYCTKF4I3R1S/CojM++E2exMreY08Y9PHwiOVgIwwyRSKH8DoVvEMYNO90vgWKrBRmxF4ka5v+L9aBEs0BRBLRbY98VUcdIe5co13c+Pxt/aOrVq0US5BRpEe0OVar2ZtBjq90zxxy+9r2xCIzd5WRN87wm7jIuZ/cdlzqSWc1LdpI5mRrfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNTF1WGh2/KLRAMsF1z3mxFgoTJye32M8erqePALIvo=;
 b=VuOD5l90u+EVF9+sTGeG96RG6OFvYK07/yT0mjrSJW4/phqRXCEQyt6OjsD2auoxo0V/HS5NOhvpSNGyHtLqWuc5/K2Y97cYgxpBV5xy3qXRSOIPfGp1jK7KpPcwbLBB3Fhrd81FYMVoLpd9ebmT24pt8gy0G8A8ly0obVzaSD5T6tUnBPQX+hjAR58nFUyk6qeiqnhLjp4uvAA6r/B3XYdD5Wqn7WuUW4PEYQOlBfRJ3tWvEdAkY+wxanprPF4kD546nRXqreISToIL59YcfU652My3vmx7eiAdG72PjzLo/100JRlMQFg3Tq64tPhHDgA9WqZcWhjk2emtX81MCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNTF1WGh2/KLRAMsF1z3mxFgoTJye32M8erqePALIvo=;
 b=OYR84XU+FQQwvbVWsR29/YBlYouKNveorMJqqA+JB1Uxr4mysFq9dcKmoBu+H+Qsj8hJGwHvUyupaOKhAKnJIogV9B7YS61YtV8uAbdgQQjzbkacVvIK3lFebSKrXWCZjwtey90ap+yndGxb9goAmwVXtI0rUrRjErQS+fs8ik0=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CH3PR10MB6689.namprd10.prod.outlook.com (2603:10b6:610:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 00:50:52 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7472.045; Wed, 24 Apr 2024
 00:50:52 +0000
Message-ID: <de2fa68c-e815-4b21-9b8c-f1893fe49b47@oracle.com>
Date: Tue, 23 Apr 2024 20:50:45 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
 <ZhTj8kdChoqSLpi8@chao-email>
 <98493056-4a75-46ad-be79-eb6784034394@oracle.com>
 <ZhkQsqRjy1ba+mRm@chao-email> <Zh7E3yIYHYGTGGoB@google.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <Zh7E3yIYHYGTGGoB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0242.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::13) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CH3PR10MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 75f8a8fa-b012-49fe-8bcc-08dc63f89769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?alVHamJjZVg5Z2pySVpPR1lycExzRnorVWkzUGp0bmhDNG9OT3lZR3FkblVs?=
 =?utf-8?B?dUNtejVDNnRvdnNIQUx3RHYvQ1BkR2V1U2dyNkxyUGVtNGVyYVZ6KzNiWXFK?=
 =?utf-8?B?T0JnTWRsRzI2emdFZ1RVQXdtS3UvQnRDSzh2bjhWc29ZTHZXL3crZFNoUHBh?=
 =?utf-8?B?ZEQ0cThWRTRlMURkVXYzRHlqR3F6ajQ3ZDZGWC90c3orN2VIZUNkbkJhQll2?=
 =?utf-8?B?emw0QWdwS2d5cStjbldrQ0tMdXRHU3VJbWVLNVRVcE5HaU56Q21MbGlVeGFa?=
 =?utf-8?B?ckNLbTlrRkdKUXJ0RE9sOUlUbFFEcUZNdjRweXJGalVuZ3NQdlZkOTNhZWVZ?=
 =?utf-8?B?N2FkVWdKV1UrOEVJS1NnS0dsdHF4OGlyL1lSZE00ZEVlWWFSa29lSkdVemEx?=
 =?utf-8?B?Mm9lbG1tU0VnYmlOTnBpNnFiMkRYbDJteUR3VWNjaFRDd1NqdnEwVnVHaFJS?=
 =?utf-8?B?QktjY2czNmY3dHdLWU5peEpsNFRZM2Q2a3JhQzRNQTA5ZGZuMkNRejk3bGpD?=
 =?utf-8?B?QTdyeDVwUGwrb3BwMjdlTTBuNkY1dmN4WE9oYTVJM0t2ZTJXR0tHcjRUUGQz?=
 =?utf-8?B?aTBkYUlsbFNtcDkxaStMeDUybTlnRHFxL2psS0pwZ3M3dHpHRlplaysvcmxQ?=
 =?utf-8?B?ckVoM05HR3BaVVZ3UFFjMkZWZEtRTnhpdGJiejZ1d1QxblRJYWNvQUtnZk8y?=
 =?utf-8?B?a2lMa25DMk9TNjVReDA0Y0FFc1R3SHp3d2VQaHB3SDlQQTI4bU8wTm9ETnYy?=
 =?utf-8?B?R0IrNHNSc0M1QzMyTUpCRzdhMVF1RHB1MDh5QXJWRWRibG1FN0pUY2VNM1lY?=
 =?utf-8?B?MXhBOExLTHpkS3Q5ZDM1NEtDcUpkU0RYMldYSTN3S2YyZDl1VjFnUWdHOTQr?=
 =?utf-8?B?TWhnclJQaVlBWTVweE1HV3pBc0VZR0NhN2hIYVo5Y0NuYnlmalNSemx4dmZx?=
 =?utf-8?B?S0RuUlJSVVF4cEdjNENZUnNPSkIvT0ZSaHhHNU9HbkVFeFFIcG5rZmtKdElG?=
 =?utf-8?B?U0tJZG1PbFJsZUxMbENBZkV0c25JejhtTklkbHlrajljSW9QbTRhd2tXeHc1?=
 =?utf-8?B?TERtMXRvU2lvOUxuRVBRRDVmNkQyUEYxWHZ1cEpUdGk4NHQxWFFhMkFoVFJR?=
 =?utf-8?B?MXVLRlp6RWR4Mk1mN2UwYmJtNnRPNytHY0QySlhZdmp0TEFsUWFGTXBrTFFX?=
 =?utf-8?B?UUlmSUhiRy9SdHRKSGxnOUZVNkJRNTdBTXNQWEVxRlhtZy9SS2o2L29TN2Jh?=
 =?utf-8?B?d1ZLMk0vVGhaVmZEYWVvcnpDM0t6TTl4R0VOQnhYNjc5OVYyeENRdUF1cm4r?=
 =?utf-8?B?ak16ZGl3ai91YnB3blcxQTdTeEJ6c1hjVldKY3FvczA5dlR6UFAyaVZVOHNQ?=
 =?utf-8?B?cDVzMGttb1pmYkJVd29EQ0xVSFpEMlZCalV0ZWpqTStDYmxYSzBIUG9zendB?=
 =?utf-8?B?TUdzZDE4UTJyTDFjUVJWWGM2MWFRVFRDdjlDZDhRNlZLdWQyTzl0WFBxOThq?=
 =?utf-8?B?bFYreVJ2TmNrelVDVnhZcUJaRlErTU9udkNRZGxLL0FZT0lROWk2ZG5mZmJz?=
 =?utf-8?B?Zzh5Y2FWQ1UrTFhGSjByS2doM2J2UUZXR1daZ2drZGF5NHJTK1A2YXhRSnRL?=
 =?utf-8?B?ZkZJUFRRdjFNcS9tTDhGbjhlSEVQYXhFclc1b05MWGlIRGJ0RjIxS1hmR2Nn?=
 =?utf-8?B?aWRmUGR2L2U2dTFtOWQ2cWFuc2hsY0V4aVhpS2ZRVEVjamRsRmlmYXBBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TmVXOHcvakQ1c2lLVnVCUXB0bWxxMkRHSXRDUytQOHViYS9vYXJQeDgrdENY?=
 =?utf-8?B?eDRBeXBndnkvbXVINVh0VE5kM3RMKytPU3FFeklWTzkwMFA5SDVKM2hSVko5?=
 =?utf-8?B?aVFxTmdoQlZ5ckdRL0dwZ3ZsYWtjNXJONjVNUlpUVnNXMTFENVlCSjF1bTRW?=
 =?utf-8?B?cG9JTFFXaFBVeEdYOHlLWDFhNXJtL2lLUWlYWmFxVEduWlltTDVkZXpXdElo?=
 =?utf-8?B?dFBlamtLbG5HeWZsbHhWUVh0QWp5OFFFVVovTEhzSnlTaktaUTE1cmtOOG5F?=
 =?utf-8?B?L0FNbWphRUVqTG5GVlIvZ29taU9QR0t5K3cyMDRhTS9oSVB1T0oreCtzQmph?=
 =?utf-8?B?K2lFZWYzMXVqSlpSeWhnR2VDUllsZGNKdDdpMCtRampjTnh3VXZmVW1nN0VD?=
 =?utf-8?B?K2NqRWtpakw4V0h5TmtGb2JGa04rOXJmR1FPY0FZY2ZwdHZWNVFwcDFNY0F0?=
 =?utf-8?B?b3lFSWpiVG5IeGdEWFVMb3RVL0hJaW1ZVldqejdQbC9PY2VqRG4yTm5DaERt?=
 =?utf-8?B?SFJwR2NoeEZEaVFSYUlBTDR1d1NIdlRpZDROTDdlditlQ0NRR2pteThEb1Zj?=
 =?utf-8?B?ZEE2ei82VDBtNVhTWEsxWlA2clRGWWZNb2oyT3QvRWo5dzVvNENqb0RwdlZE?=
 =?utf-8?B?VlFnRVY0OXBUWlMyNUdrZHE1aXJFMHA3Y1VuYzI1bk94MU1RdmZpREtlSi9u?=
 =?utf-8?B?RDBjSmJITGVkYWhKWnQ3b0FnRkN6d2lIRzMrb2xiOVZIcVdNSWJuZGhqcm1U?=
 =?utf-8?B?eTJENEpRSVlQYU1JM1ViL3ZKOHR0c0E0YlBEa1Fwb3R3dEtiODMvSlVlaktS?=
 =?utf-8?B?ZGZhYmFGQ3grZlgzcG9jeU8rK3A2UUFVZHpXN3lKcUNWNkZQcG95OERVTjRh?=
 =?utf-8?B?R2NhbUo5Rk5YajZoWW1wNW1xVHpFV0RrNjhsWDM2UVk1WnQrQXB4NXBFMmlN?=
 =?utf-8?B?Sk1rTHpJWVpLOXg5QW9NVjB2VERjaDJGUnQvNHg0UjJkeFZWRnpseFY1YWUy?=
 =?utf-8?B?bDZUYmRNZ2dreFl4OVBJcys4MXlQSm4wVGFRYy9jUnQ0dWtkdklhbW1tNDBp?=
 =?utf-8?B?bHhFWVV6SXMzNitzSTRWMEdGczBoV1pIRkNGYy9SYk5VR09jRytUdjhyTCtZ?=
 =?utf-8?B?aDdEM2dKSUJ4V1BGZGhTd201NSs0WTV2YWU1NFpZTFpVZFRIV1d6WlVseVEv?=
 =?utf-8?B?VEdkK1lNODJEaFl4aGJpV2VyRFNvb3AvOTR5emVic1NjNU8rcVFyaloyQ0ln?=
 =?utf-8?B?dE96d3Nuc3NQNkpNMEtCVkZ2RCtqL09QY2N1NHY3YlBNN0Z3WThzS3lkQ3Fr?=
 =?utf-8?B?VEhVc2dFQm9adlJJZzFRNFBOcm8ySXJvUVU3OUE4aG9zQXp2UnlxYjI2MGpu?=
 =?utf-8?B?OEIyaDJjYnJVZjZyeW1ybjl6QWF5R1RxTmFVRmxJSHhSRjluWHQyVHRWQ1Fi?=
 =?utf-8?B?Q3NmVllLRCtJVmJhWlord0N4NVlRZDVsbWZoVlEyZTd1VGljNzlZRm5Xb0Fw?=
 =?utf-8?B?ZzdkTEV0Ymh0aDFvRmVpUGF1SEI2eGJQeGNUTTdyalBFR2kzakJQeGJoTC84?=
 =?utf-8?B?WCs4TFhzWGNneUxKMGV3L0JlQkZXTk50MHlnbDB0bnp3bU5NdUk5MTFsR3JZ?=
 =?utf-8?B?L3U2WVg5QmxDbUxRM09BMHdtL3RiTGN2UGtodkI2VHdiWEJQeXRRbmRtSXFF?=
 =?utf-8?B?TnU5Zk13MVdJK3BkbHMxN2dZSlo2Y2JlMHNod3Nsa2p5Z0hDeUJscGE1OUIz?=
 =?utf-8?B?R1dUcGp5QXVjRFlKUUxrRE5qT2JFZDJ0YXVPbWkyUXlmSHNoR0pycGVWWDRT?=
 =?utf-8?B?S2xyU0NUYWIyeU84ZHhSQ0F0UXpqWFVEVWtTR3lQUndkTkQrdkdLRlNIU2Zh?=
 =?utf-8?B?SGZmdEw0OXhoRkQ0ZUVicWxuRlJiOHdYSDV6SVJjNThoTkpjTTVuSVRXZWMz?=
 =?utf-8?B?bjU1UDk1VjM1b3Z5bUJjTGpqTmtGSVFzTHQvU0k5NUZzbkIraDhtVWVGSW56?=
 =?utf-8?B?QjFCZlhxOU4rY1dMUVlvTnRub2k5QWIxQ2wzUlpJWER0dDlTMXNrTDEzY0lW?=
 =?utf-8?B?OU1oVU9BTVdMNGFXRzVTdnJtMUlhOHpTVEZmTURoaXUybjJmTEl5NENDUThx?=
 =?utf-8?B?YmVaMXlOUEpudVZrVG1rV0dybjJtVEJYSnl6d01nd3pnQjR6MCtoeXVZdzk2?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+2FP0NwZ3AXhDlcXIPCrH7RSrFTIWmXXvYzMq7YqaRFJzi1/9hHR5kiqtmxpzfSdhcGkNfcV5Aow3xSm5h9dvJO7GEJ3P6nemKQxXyoXZ1/05bmOZqwvpUv4KKqdYbSLojipGhpTdJwdMPea0Tc84jOviZgvcIMtpxyHDFKX8YydXn2X2DgfHpgfr2ixr2ro0lqx3jY8wbTQmBkmYsupHSilH4O0BUSGfa8ml4GTh+iF+5xsWdcil+lkYpOcb40PT5EdCjagNiX0c45OSBf7apLb/ZZOr/MdY/p0uiweUZe/57VYoW8nCK2VPJOXaM55qLe68bZhhrA99OaCmZcTqAuBmjc4GzmHH/i+rfv0Ii57qyj/kMWV+i39aBOH4nkJohs0Je6SIpG5U+/6nLqG2RV2dLtzrFPp2jt30WY9WnY8iSyxl/Dbwjo+HHlcMEgacMARHjWsjYdOhaJy0gJRUbiX5llzUPCpyogft4osUKjebh4djUJVdiK/mkANCQYsbp5fhXe8QL0DGISTfa2Mg8QdcLFuQIhLvQacEi0nQqpzPHexpX2hK9hQBlRcwttnNS9vGr6u8YvOGHV2qgD8qqFS0p3FhnDtD6CrxThAcV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f8a8fa-b012-49fe-8bcc-08dc63f89769
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 00:50:52.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke7ROWxSc7dDyXH6MuoqJnkE4hqecxvL7B2jJdTD2PfzSQDJ6bLtZ5HrKmw/ctafYee5d1EvNBRBJI3mKJ8BX9BBUVKHCGOwXinNenrNBag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-23_20,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240003
X-Proofpoint-GUID: UwCIkDyjfBbj8Nasfd7YZgN5nuCAXu8_
X-Proofpoint-ORIG-GUID: UwCIkDyjfBbj8Nasfd7YZgN5nuCAXu8_



On 4/16/24 14:35, Sean Christopherson wrote:
> On Fri, Apr 12, 2024, Chao Gao wrote:
>> On Tue, Apr 09, 2024 at 09:31:45PM -0400, Alejandro Jimenez wrote:
>>>
>>> On 4/9/24 02:45, Chao Gao wrote:
>>>>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>>>>> index 4b74ea91f4e6..853cafe4a9af 100644
>>>>> --- a/arch/x86/kvm/svm/avic.c
>>>>> +++ b/arch/x86/kvm/svm/avic.c
>>>>> @@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
>>>>> 	 * bit in the vAPIC backing page. So, we just need to schedule
>>>>> 	 * in the vcpu.
>>>>> 	 */
>>>>> -	if (vcpu)
>>>>> +	if (vcpu) {
>>>>> 		kvm_vcpu_wake_up(vcpu);
>>>>> +		++vcpu->stat.ga_log_event;
>>>>> +	}
>>>>>
>>>>
>>>> I am not sure why this is added for SVM only.
>>>
>>> I am mostly familiar with AVIC, and much less so with VMX's PI, so this is
>>> why I am likely missing potential stats that could be useful to expose from
>>> the VMX  side. I'll be glad to implement any other suggestions you have.
>>>
>>>
>>> it looks to me GALog events are
>>>> similar to Intel IOMMU's wakeup events. Can we have a general name? maybe
>>>> iommu_wakeup_event
>>>
>>> I believe that after:
>>> d588bb9be1da ("KVM: VMX: enable IPI virtualization")
>>>
>>> both the VT-d PI and the virtualized IPIs code paths will use POSTED_INTR_WAKEUP_VECTOR
>>> for interrupts targeting a blocked vCPU. So on Intel hosts enabling IPI virtualization,
>>> a counter incremented in pi_wakeup_handler() would record interrupts from both virtualized
>>> IPIs and VT-d sources.
>>>
>>> I don't think it is correct to generalize this counter since AMD's implementation is
>>> different; when a blocked vCPU is targeted:
>>>
>>> - by device interrupts, it uses the GA Log mechanism
>>> - by an IPI, it generates an AVIC_INCOMPLETE_IPI #VMEXIT
>>>
>>> If the reasoning above is correct, we can add a VMX specific counter (vmx_pi_wakeup_event?)
>>> that is increased in pi_wakeup_handler() as you suggest, and document the difference
>>> in behavior so that is not confused as equivalent with the ga_log_event counter.
>>
>> Correct. If we cannot generalize the counter, I think it is ok to
>> add the counter for SVM only. Thank you for the clarification.
> 
> There's already a generic stat, halt_wakeup, that more or less covers this case.

I don't think we can extrapolate PI-originated wake ups from halt_wakeup, since it
can/will also be triggered with APICv/AVIC disabled.

> And despite what the comment says, avic_ga_log_notifier() does NOT schedule in
> the task, kvm_vcpu_wake_up() only wakes up blocking vCPUs, no more, no less.

True, both the GA log and the PI wake up handler just call kvm_vcpu_wake_up().

> 
> I'm also not at all convinced that KVM needs to differentiate between IPIs and
> device interrupts that arrive when the vCPU isn't in the guest.  E.g. this can
> kinda sorta be used to confirm IRQ affinity, but if the vCPU is happily running
> in the guest, such a heuristic will get false negatives.
> 
> And for confirming that GA logging is working, that's more or less covered by the
> proposed APICv stat.  If AVIC is enabled, the VM has assigned devices, and GA logging
> *isn't* working, then you'll probably find out quite quickly because the VM will
> have a lot of missed interrupts, e.g. vCPUs will get stuck in HLT.

ACK, if the device interrupts are not being handled correctly there will be lots of
complaints during device initialization as we have seen before.
There is one scenario in which you can have APICv/AVIC enabled but only doing the
IPI acceleration, while device interrupts are still using the legacy path.
It requires booting the host kernel with 'amd_iommu_intr=legacy'(AMD) or with
'intremap=nopost'(Intel), so that is a special case since you must explicitly
request the behavior.

In short, I typically use the GA Log tracepoint to confirm IOMMU AVIC is working
as expected, so I wanted to provide the equivalent via the stats.
If we want to have a common stat, we could have a pi_wakeup stat that is incremented
both in ga_log and vmx_pi_wakeup_event, but I do understand that is not strictly
necessary, specially if we want to be conservative with the number of stats.

Thank you,
Alejandro

