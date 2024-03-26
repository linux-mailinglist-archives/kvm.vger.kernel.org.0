Return-Path: <kvm+bounces-12707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8436988C9B9
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 397382E6580
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E631C6AE;
	Tue, 26 Mar 2024 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dkn/pKsU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="buHbDgPh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5595E84D3D;
	Tue, 26 Mar 2024 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471649; cv=fail; b=PSgtvd+kTbs/sQF3ifv8zDVAdKQWXY1sxBh4BEDlWQ8JH+6ysnRAIv3mzaS9CK56e28Ud1HRlELhLbcoKv8gRXQJLXub2QuL+rKd3Dqc/v8KjlLo55AJcm1lYd/LAki7AueDM2AojNMgWSWX2d6NG7UlQGlbMUrI9UIy7/SnZAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471649; c=relaxed/simple;
	bh=U3EWsbP2gNipdkCQmG/38Q5SSESCM238Ttn7J8enlaQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N45QcEnCpYEBqjdDnapeCYGN0qgAgY6mhJs3cG+Ae0K1y6rxjfcfRNVliWo+AqIFkmmJi6I2XTIoV+aPCIJ41D9/7lIv8KUbh+6Zvfhjq2Xua7Dp70VAnQo5WsmhL+KDoW1s/3kYQFw731gh60qiSvFt+RgUi4Xyeb5daYgIDts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dkn/pKsU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=buHbDgPh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QF4BWG029757;
	Tue, 26 Mar 2024 16:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=NzPJwtDr6TUiGAJv9sgfESEoq2nltWBO/t4DdPvocHQ=;
 b=Dkn/pKsUSbhCMT6/KA3hmlRl+bj0GGPj6cDQRdLbuWrcib2a7wXBzfFA1otyO0Yl4PfS
 ujiuuVdQo9QSL59wxmc2C3AZtkCUaHvG6lJ9deZq8dvp11XOaoPjf+QlvciSKKDA8npm
 Jq8P5byvlyp6dDy2eygUVIuJMv05lvwYyWbvTFHPh12y5oEA3FcpkDqE4pTgZYjDrNuu
 1XGZNp2iP9z2lo+UAwuoBK22gpU6x9O5cA2ac1g6EUsnxlkWav+5U3NQFTBSC8L7EDRE
 rtogAYIJgxLGlLRje+PLhEV98OzUZ3YhG76/Udau8B+SYcBP8MlsorfGObZkHAhx6ZO+ Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h4fyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:47:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QGYTW5013152;
	Tue, 26 Mar 2024 16:47:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhdhwqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:47:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvdU3nnd9WHNnA0S/BrhD7z0TTE/U1ZZP5ef+MVpAlsZrc8tmm0tmowO5K5zyS3t+suw7/JA0LghJzjHqqQNFZ/Dlls1sHHAbwH+b9q8+QjlAMyYZnyDK0ASg3MWhmOsxrB26PN42oWheNL+NKfUhAXvCG2ElZOqIOHy8K3JiAUeAzYf0HtkS/AjSjDD8SG2UCy0wKKoe/yX6QkFuAwsg1eDXQfNGR3ZZiqHqcl8LgWx3GOOcHKtNPTqxkFWgfdhEoIhvsewgjhwogQPdRignoDcSITxoEEla0oAr3VKRzwh9yjBPec9PjO04DSQpzlbHjYiQ9XBkHlaVlc5O+1Geg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzPJwtDr6TUiGAJv9sgfESEoq2nltWBO/t4DdPvocHQ=;
 b=G4ZW7rhpNxzYFR1eIZ0TIgxWeJfVfkPv0djYFib94hIEsRtPXf2aOZ9EL2iF/2KRe3tAcugyYbjjlyYk8L7l602+cCvigfUEXaubmIEEZW5xeCQ9fgQQ3OOb4MOVO/mQ8si8Wn9s53tDvw1TVz9fhNos5fNit11qzuLCYxveBHHNtQoIFg3vFRqNasG2Z/lsvz+zcSw4xHz9aUrLN/UXaYjtqiTyrLIBxHmiCGf0QSlHqkvsqbBJZUTbrqZNPOVWsP70i5Cfj6rDwMLwoD1teAAEjqZTxOiXRmyFZemsKZgozSqzCus/mfH6SZlr3YnarKoDLS55TjT0VkciVvZKjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzPJwtDr6TUiGAJv9sgfESEoq2nltWBO/t4DdPvocHQ=;
 b=buHbDgPh3bvpLRFz4B/ZW67w3h5K+QWjliKg4APxMXTRl40OiOxab7BVEy2wZJMTrmbgnBEBzIgvmvSbm37lQcvqKlzgB7qaCYHXzGJVBQnVe5OqZ7Kbsk4whyfgaJtD9FvMRShQzimuvdSXYUwNyGivZ/whiuTFRVgpg+r2zUo=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 MW4PR10MB6461.namprd10.prod.outlook.com (2603:10b6:303:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 16:47:19 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 16:47:19 +0000
Message-ID: <6555a4d8-7825-4078-b15b-4bd4b1a9d3f8@oracle.com>
Date: Tue, 26 Mar 2024 12:47:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: x86: Print names of apicv inhibit reasons in
 traces
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
 <44f53dce-1299-4fb0-9c4e-dbf0f5b3a351@oracle.com>
Content-Language: en-US
In-Reply-To: <44f53dce-1299-4fb0-9c4e-dbf0f5b3a351@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:91::13) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|MW4PR10MB6461:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xU6C84metHzX2SbBk8piPGCCQA/Kzce5rfF0LuA9gI9iRzZermRYP+rDdzLWWQ9177f9Djs/Lxr+HvN+JMc0cc64cEl8dMjVlOpsIuXUcK+NmxGES8lGk15I0FJwAVAnSSuTvTFUs7XQh26kcMHhjuCtQjO80UGdO9tEsq7QnsLZrJ8F2JhM+iAJXaNqBGD/rrN4PTD4/JB06rzJB8BABf2CpsOB/Hxow5uutS4lAAAsvUyQFuw2g0xdk451FomHaBdPvIc8JW7Ahv1vLCCsVE5IuugKY8NolFjwNH6EXlT6P+7fpqJnHXhLTdWcnRAqKOBnOxDEnXoNWrlB5OdmP9s2aQ2XfIBrDnniLfWhy1AzpKEsVaOvHLYPxNqoj0thiMcNX4zKQF36mv+8/lNRyiRVm9BAQ7/48lkKTxRpb8X5mJsJoBdo2D1N5ar4zNJytg6oGQoUSgPkdx83LBLxkhANwTJhQwEP1vanCzeoGaqd6QqrRKWFcoOF9N+97a27dKGvYdoRXqmlcJnKggo5UN3ea3C8gSYCQ8Bh3e8QPmPJ2r2ssnuh/DcJOpWkbHyBnKobUEcaPrX/Kt7V/1BvPKIwt5Jafa6Tid1L1Zi1z1CrjS2efe1mqdZhbAvk+Jb4cL/23pcuGiGKXpMuHnR/qWAszXjqgRb515NAOiyPmrU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MnJUdmErK1Zpa2ZqT1ZCSnR6aGVuZzhkeFRwWGFsRW5FWDkyQmpHaHcvWFQ5?=
 =?utf-8?B?TWVhaTJQLzRPU0tBekIrTnBTZ1ZHTHV4bVd5Z0Rjd0R2amZ2c280MWx6UVJt?=
 =?utf-8?B?bm5sb0dFcHhzUmcwN1JodjJMd3l4TUVpOWRMKzN0TDZydjhISGxjQ05DeERp?=
 =?utf-8?B?cHZvM0srL01JTk4yckd2Y041b0pWRDJnR0VoeEtYMTUxc0o3eDVrNXlqMFZD?=
 =?utf-8?B?ejNTb2ZlNUFXRVNSWDZDNlJXOEtGSnp4b2JsNVQrNnFwaXl5L2dNN29keTFt?=
 =?utf-8?B?TDk5R0d3ZHNVRmpqMXlnU3lMc0krZ1l3TlZsT1p2STdMc2d6eWx2amptemZK?=
 =?utf-8?B?SzRDeWZOSWVxb3k5Z09JbDd5WDR2VVN1NVlQaGVWeHJCemxNZGJxM2xBYUNl?=
 =?utf-8?B?L2lFYjZGYlFiVS90ZHlEclI4a1dsR2JPbUc5WTJQQlNaOEdWR0wwUVg2dU84?=
 =?utf-8?B?eGtrVDk0ODFBSStJVDhjUGYvcm9jTGhzWHp3bU5mOHlSd0dYRS9OSStKQUtB?=
 =?utf-8?B?K0VwZ1dsaDBuSU96NnBudVArUXFzUWl2a293NDNLWms3aG52L01pQ3h4OVJq?=
 =?utf-8?B?TE94YkVyTVNkaGFJMUowTmZKZXhoNjZldHNOeS9KTkNqZStoMEZ0YlVIbStC?=
 =?utf-8?B?TGVjQWxyM2NvOUJyQmw5cTkzUEVqVUpFdkxxTFZjZkE3RXR6eEk4Y2pROTNl?=
 =?utf-8?B?YzQraVhVUXNLNDJHRnl3aWZvRGUyZkFVMnpNK3BXZk82S2VaL1h3VXNXNkQ5?=
 =?utf-8?B?ekhoRG5KSGM1bWtQcGVmdE9CNFFKdTM0TXphS0Y4QzZpRDN0eDRTaUpOOEdr?=
 =?utf-8?B?V0NLV2k0UW9sU0pYK1AvUkZGN1VqQTI5M09FN1YrQTk0aU5wdUljRXRWM254?=
 =?utf-8?B?d0pPOHFmMi9RdDhXOElXb21NS3Q5NHFxSDdYT0tyWDliWXYzOW5nVE9Nenor?=
 =?utf-8?B?Mk0zRFZNanpPK0lNY0t6Zi9iWFZabWhHNnJrY2pZS0xTbjBTbFJjRS9URGhl?=
 =?utf-8?B?cFU1ZkJvOUdrZmlvZnBQV0w3d2xVYlhpNDV0Y2l1S0lERThUaEVsK2xSZXdF?=
 =?utf-8?B?QUR6R01lYzROc2dlUStRZHIvQWJvbk9Uc0MvdEFOWDRmQ1d2QjAzcG9BT3JS?=
 =?utf-8?B?NUZiMGpBZlpuMzhzeVMvWXlpMnhtZGpjUEVSRFFJQ0sxRVBSVkh4UnczSldu?=
 =?utf-8?B?TnlKelZBeThFaEhWSjVwd0FXaGVCaFZEaWMxdDdGNllqY2ozSklXeEUvc1Vm?=
 =?utf-8?B?VWtjdmt3cE1XRFEvaktFdGFjd28za2dENXdkR1V0K0pnK2VJYjNoWHhRaitN?=
 =?utf-8?B?bit6bzcwY1FRd0NxL0tWVk1xbEtDcmVhblhnNlVwbGpLSkhxd0gwZGpIUWhn?=
 =?utf-8?B?TExPQTcvS24xOTRCVXZLSm8vM2RCRW9RM3lkN240cEhKUnZtbnppRlpWODZ3?=
 =?utf-8?B?dFdyeUpwTGRqUTROT1J1bEMybXh1Z0NlRVkrTjlEQ0xuSWduVzk4SWFPVGVk?=
 =?utf-8?B?djZJRjV1NmtOdkJ4VmZCZzMxcVdUMjZGVjJ2dFVSUlJZM3R4VG1lZ1hVN1lM?=
 =?utf-8?B?cHZpSnM1bEhzVEo1RU1PVmpnUm5ZcXRkTEc0dXVKRVV0QjRNaEw1bkxzQ0RT?=
 =?utf-8?B?VjZSUkRJdGFwemxFWkJkRGxBUkQxZTNuUWdhbmhrNnJvZFdHcW4wSGJ0aUQy?=
 =?utf-8?B?Qm43czVWT1VLSFZVM1hXT2dKZ2tra01LMmVkbjIrd3I1S1V5RlVXc1NqREFr?=
 =?utf-8?B?eFpEK3RyYzZMbnZNVmFpMlJxYnowY1BTbVpFa3Q2RFZmaXBIQkQyS1NTenN2?=
 =?utf-8?B?dEJhK1BMUFQ5SWxQTDRVQnhWa2NOdnZmUVRCWTVoQW45ZGpwMjMzb1VUdVU2?=
 =?utf-8?B?eGpsTUtOQ21lUXF4bHd0eEhjTWFoTVZ5UlJocXhFdkI2QmsvUHFLaUJvb09w?=
 =?utf-8?B?cSsxZVVUQ3AzRkxFeTFGV3NlMVdaSUx6aWV2Z0VGM1ZKMmJ4bU9zbURiU1l1?=
 =?utf-8?B?SC8raDNwVVFYMVZJYWU5WDZZNVpiL0M3L2J6d0pQNnphWFd5emxGbU9ncUxG?=
 =?utf-8?B?ZHZ5UEtsQXRqZzJLQWNCa0Qzalp5VE9iN24rTVhsUVJ5cG9yWVphMHl0UkUv?=
 =?utf-8?B?c05uZS9mQzlYb3RXNHZNeVUxcHpFcGR6TVNIRU85Zkp5ejBsS240UWpXN0JL?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kyZ+jybLvT631KWUqQNIOT+LtSgISAAuwEzuM6GWhribbvvo0WXdyGI5TviIJQgt1oabvJWF8bKtTXXHgCiWDFmbJ+LJ8sb47AfxG/KsGFLJPI1qXIWdelrQD9R8Dshb0Ed07rWpSKyCOaqE2CXMKmK5Hfu3FnTz54qD0Ct96BpuO4E3nerbbB8ZGVsb+9UqXPM+1SIU6Z/t2XKnkS+T19+53qYovvN7eq16PGx30B2rj4V2KmcoIeSsitndFUB2newKTpIyNrkWpvHmO11mIdlRjB9ykIrkEZyWy07fqX6L0SbwEIuuxZqGuH7H9r4qU6oWHASvi9V1+EqLjOytXuDioVb4yGhX4+U8UjEnynnRzOZpV0Gc5wIS29g13A6sWXwbOAsspNnY1ezHjW2SlChab6BmRN5uOktjJjO7O87e5Mbcoo7PY41ofh11tbV9xxmgsEOX2lceXL3wvE5mcwpt82Re6v/AvRPrbcAWYI4cmajuVsnae84zcdNtZFuuzRn5Y9BO7YR9vBToO3XkGHiyvA0vDu0weavWYx6eKBWP9bq65tU6tpDO8TEz6A/2DFQ2epKYtDgFNz5ZUNcAtKks1/IVOVcXGSXIF8TPByY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab1e986-eeae-421e-d7e6-08dc4db4666d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 16:47:18.9979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8l57Fo1zp4O97qUuiC1nu7+jqjmtThry/DuUwOFfjuztQapw6NdEijtz5DgAuOa5ocHAczou2MW/3H5EUWtde+mV1gxSQhkZsKlY3fkeZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260119
X-Proofpoint-GUID: xhkr9rHb5bAd6J0idHCEX-UGFEkioGr6
X-Proofpoint-ORIG-GUID: xhkr9rHb5bAd6J0idHCEX-UGFEkioGr6



On 3/8/24 11:06, Alejandro Jimenez wrote:
> 
> 
> On 2/14/24 17:35, Alejandro Jimenez wrote:
>> Use the tracing infrastructure helper __print_flags() for printing flag
>> bitfields, to enhance the trace output by displaying a string describing
>> each of the inhibit reasons set.
>>
>> The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
>> value, requiring the user to consult the source file where the inhbit
>> reasons are defined to decode the trace output.
>>
>> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>>
>> ---
>> checkpatch reports an error:
>> ERROR: Macros with complex values should be enclosed in parentheses
>>
>> but that seems common for other patches that also use a macro to define an array
>> of struct trace_print_flags used by __print_flags().
>>
>> I did not include an example of the new traces in the commit message since they
>> are longer than 80 columns, but perhaps that is desirable. e.g.:
>>
>> qemu-system-x86-6961    [055] .....  1779.344065: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4 ABSENT
>> qemu-system-x86-6961    [055] .....  1779.356710: kvm_apicv_inhibit_changed: cleared reason=2, inhibits=0x0
>>
>> qemu-system-x86-9912    [137] ..... 57106.196107: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x300 IRQWIN|PIT_REINJ
>> qemu-system-x86-9912    [137] ..... 57106.196115: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x200 PIT_REINJ
>> ---
>>   arch/x86/kvm/trace.h | 28 ++++++++++++++++++++++++++--
>>   1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
>> index b82e6ed4f024..8469e59dfce2 100644
>> --- a/arch/x86/kvm/trace.h
>> +++ b/arch/x86/kvm/trace.h
>> @@ -1372,6 +1372,27 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
>>             __entry->vcpu_id, __entry->timer_index)
>>   );
>> +/*
>> + * The inhibit flags in this flag array must be kept in sync with the
>> + * kvm_apicv_inhibit enum members in <asm/kvm_host.h>.
>> + */
>> +#define APICV_INHIBIT_FLAGS \
>> +    { BIT(APICV_INHIBIT_REASON_DISABLE),         "DISABLED" }, \
>> +    { BIT(APICV_INHIBIT_REASON_HYPERV),         "HYPERV" }, \
>> +    { BIT(APICV_INHIBIT_REASON_ABSENT),         "ABSENT" }, \
>> +    { BIT(APICV_INHIBIT_REASON_BLOCKIRQ),         "BLOCKIRQ" }, \
>> +    { BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED), "PHYS_ID_ALIASED" }, \
>> +    { BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED),     "APIC_ID_MOD" }, \
>> +    { BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED),     "APIC_BASE_MOD" }, \
>> +    { BIT(APICV_INHIBIT_REASON_NESTED),         "NESTED" }, \
>> +    { BIT(APICV_INHIBIT_REASON_IRQWIN),         "IRQWIN" }, \
>> +    { BIT(APICV_INHIBIT_REASON_PIT_REINJ),         "PIT_REINJ" }, \
>> +    { BIT(APICV_INHIBIT_REASON_SEV),         "SEV" }, \
>> +    { BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED),     "LOG_ID_ALIASED" } \
>> +
>> +#define show_inhibit_reasons(inhibits) \
>> +    __print_flags(inhibits, "|", APICV_INHIBIT_FLAGS)
>> +
>>   TRACE_EVENT(kvm_apicv_inhibit_changed,
>>           TP_PROTO(int reason, bool set, unsigned long inhibits),
>>           TP_ARGS(reason, set, inhibits),
>> @@ -1388,9 +1409,12 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
>>           __entry->inhibits = inhibits;
>>       ),
>> -    TP_printk("%s reason=%u, inhibits=0x%lx",
>> +    TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
>>             __entry->set ? "set" : "cleared",
>> -          __entry->reason, __entry->inhibits)
>> +          __entry->reason, __entry->inhibits,
>> +          __entry->inhibits ? " " : "",
>> +          __entry->inhibits ?
>> +          show_inhibit_reasons(__entry->inhibits) : "")
>>   );
>>   TRACE_EVENT(kvm_apicv_accept_irq,
>>
>> base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
> ping..
> 

ping...

This is a trivial but useful usability improvement, and I don't expect it to be controversial (other than perhaps formatting of the string), but I'd appreciate any comments.

Alejandro

