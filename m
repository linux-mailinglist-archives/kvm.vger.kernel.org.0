Return-Path: <kvm+bounces-63210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5BCC5DD8A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6E9FF383AD2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3493326947;
	Fri, 14 Nov 2025 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="H6PK8PJt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JOdQ8GfN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB855338F54
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763131941; cv=fail; b=R79yxwoTwoO2hiR/6vKNhinsvQmHejRO96ueNuZL4vnhIPGy4dxW68BAoaJzytlXUpkp8UxULPPeQzB8KumLxgWidh2/D8N0FFgAsgoDcoTEYonyZnDAZnFPbCrkZbG8bYXi2cJGjg5f7XnzzW5Sq3XmFhep8OqSHKoTPlbe5HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763131941; c=relaxed/simple;
	bh=i3X65JV6wOZOjWvKL3Z5/QXvod5HKky8Ziew+Um50Qo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cALFCB45F6UmKC24FRagz9LeAOqfcGM8TQHgqvf78dPaNEwu2ivSkk19KAGSn227/URhlUasoSs7lL/Q6cy3trAxb2tsBv6Shxz3IQVdyZIlJMAL1RiUKi+48F6rM+aC1Zqtz4nAhN34GTOGoiYY56xqJqO7/ZAg1nZ1c9X/fSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=H6PK8PJt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JOdQ8GfN; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AE8TWt8067997;
	Fri, 14 Nov 2025 06:52:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=i3X65JV6wOZOjWvKL3Z5/QXvod5HKky8Ziew+Um50
	Qo=; b=H6PK8PJt22DSJ0mH+bEFoVhwFwLBjq1SF7q/NQxB3TcUOe65sZv8pv8RZ
	vD+Zs166Yjr5sQ2fBNJPdBC5q/Xr7V22n9VBs6B7OnPZCyoVxCQV9UcImFRqA+2X
	hbr92xrGVmbQ87Qd1rtLgv/cmmxAK49D4FtsRdb/MGHO9yUb9P9S7rZOfIVCuz5V
	Oix6dvqQnru5wLbyTpxAT9yvJ+tDNsOAaHG+c40FFNtsQipmnR4BZ0lctJHE5TIt
	hi3tezXkRYECmiJse90Vdzy+rULcfubuNhjDsZSdD4leZNdU/fOgjb6layH9IEfi
	yfk1xe70PWs/8lCQX9hhK4ZnESN3g==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023101.outbound.protection.outlook.com [40.93.196.101])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4adq50swmt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 06:52:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvwKy8AyvihpQSa3A4nsctAUgpztlAFwm+tzZOMK+eJ13Zgu8eSiRLUs9rYfLxQZ6lNXtRKOPP7R0pf1FZ8BFc5rcX9NBM8D8qkJ2yanNOg9JM9mZVf+nGbfhFgGthrKhi4sTcvEfZQHHue56/NYACcU+dile5GI0OtWSVwgKtPvnVUr1taKZXCMAZEng5yLM2dHz0wU8Qumcki+/GF6QkHPjZKz8Fa8FPsfTXNdzFdAchVzkXfMAT9Egfd2Rr2hvwsm44HIanqnnDljWWPI4F0TxfsZT05IYWW3BT2zqxuFSxtIb/kjpiXVM4flvT3H9d+oPKktNm2IYJNAlO72zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3X65JV6wOZOjWvKL3Z5/QXvod5HKky8Ziew+Um50Qo=;
 b=kgfqKOfkNC5Dgfh0uZyVrnC3zTWBSyNVgn0AWCIHr1EDXiN14sIRtWLS3fKEv8D2TyjdjMbA31TGg/Z0u3bUwFEkWHieTjiyRM7CozLwj8EVeB7YXX4DV1p/Ia8TxqPGX7OD5ougKqQCN3jRscUZRk8Erk0X3PjuVlwHAb0Lq4aQKWUbvQxRjlxgFn0vqgd+SYz4jdJnfyCEHxpEL7qyVhAdpP6GkSeqrIbHT3FlRVWVXz3vrOqURC5BbH8mVsX/UttEsEbT/9SY9cJPn7rZrjdRif+5qZI8Pr/9wj0yJR2BpiRCEirNSvUwpXwXmBWX/SRmtif0XHmAk0NevDIcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3X65JV6wOZOjWvKL3Z5/QXvod5HKky8Ziew+Um50Qo=;
 b=JOdQ8GfN9ct0sA2mlOiJsjESsd2bp16DsGBb1waGbCisEqk02QGXyXJwor0UtS5c0fvFwPYVSHLJg4wyPixCE98ljT8RAlg+dE6qcyK4iwYMSZoyIAUrHRFdF8C9YhvvUTTanIIxlnFSNjKkX0RegsyiY9s2Tb7L0L6UuM+bDwT6xEtNXICOT4Gj6JMlYxXtk/m6WGSZfuhuBCcJ/x73GzSQ+cUDrFZHXV2NYaemPljZIeBwXFzlLCm0IhoOBBd+Twhl3/MYVRPB5IucHRrBB5InKwXuJpWrrcBJ69QBOwi3CsNL0lpUajozY6/Eryyy8tRa8pnXAcTn00PeO2bq7g==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by DM8PR02MB8172.namprd02.prod.outlook.com
 (2603:10b6:8:1d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 14:52:07 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 14:52:07 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 00/17] x86/vmx: align with Linux kernel VMX
 definitions
Thread-Topic: [kvm-unit-tests PATCH 00/17] x86/vmx: align with Linux kernel
 VMX definitions
Thread-Index: AQHcJyky5iovVgHRcEitmAXrveuKQLTvv5gAgALeiIA=
Date: Fri, 14 Nov 2025 14:52:07 +0000
Message-ID: <E413E048-EA97-4386-8A88-B9552A823AE3@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
 <aRTZ4oqqIqDlMS6d@google.com>
In-Reply-To: <aRTZ4oqqIqDlMS6d@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|DM8PR02MB8172:EE_
x-ms-office365-filtering-correlation-id: 8a4c865d-c4e9-434c-dd95-08de238d61f3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MVA5UStycDdzeDlrT2t5V2k3TjlZc0FPS0xrOW9LM0UzSUVtMTYxYUZ1UkJn?=
 =?utf-8?B?V29aeE9tb0plUWw4Q0M3czlJMHdXZUdCN0dyL2R1TlVTZ05FTjI0RFBCdFMr?=
 =?utf-8?B?OXdFRXg3bnBjaGFCWVRsZ1JOWlRIVkVoRE9yV1BheG80RnBWSitObHJzODly?=
 =?utf-8?B?K1RwbUJNRTFpSTVwMGFxK2F2NG50ZGQ2V0FtTDhKS2VDRmIvVi9nRCtqVWRk?=
 =?utf-8?B?bHdlK2pxOGI0eVhQMHBPVko3WjNpWU1VVFVVWElabUI3WjlyV082MWRIOVBq?=
 =?utf-8?B?bXNGaDZ4bHFVdjVlV1FpdHIxV3dKNnd0dk9aVm1mbkNhYjd2Z2ducFF4UWtu?=
 =?utf-8?B?OEozQjd2SUIvNDFibmdHdHVGRUczRGlPakFaRW9RWWs5T1dUTk9DTlJ4VCs0?=
 =?utf-8?B?VnpWR0Vaa3BYRVpJZkFQbFFjVm4zK1Q1bllMNDhDQXBhbWkzOUMyaVI3TGtG?=
 =?utf-8?B?RVcyK1ptTFAwb3ZZbk5GU01qMUplcFpOU2dRMFZqTEVESTl3UXdoQ1AyRGIy?=
 =?utf-8?B?QjNoZndFdmV1Q2Q4bHVTS3VkWDdTRlp6VVNJTlM3Rng0QzJING5wZTczUUpR?=
 =?utf-8?B?eGkyWjR4U0xhS0NMYTFtRXZjc3Q2MGJ0bkJVS2M2WmE4bHU0WlAxWWtDaEp5?=
 =?utf-8?B?Znl4cWxVRVhleEdQZno1WEJmNktMUjRTYTUzRjRNWWFTL3V0UUJXUk5lMVRU?=
 =?utf-8?B?TTRad3RRdnYrcU1sVUZZbTJxVHJwdWJYR0ZjMUVpSjJZREZOMndCelF6eXJa?=
 =?utf-8?B?OUhYdTF1REs5VGFkd1l6R3FBUnBQYWJYMWFzK0Vyd21YZTJWVnNqQlpPaUoz?=
 =?utf-8?B?YVR6UlNuMUNsMmdsZGkyeDNIWlJYaENNY0lnb3d2L0Ywa0NqLzR0bjlrMTdD?=
 =?utf-8?B?K1N2Y05MSUllZVJvMjBsem9MVS9LNjlaVTNrdEdpZ3drMlNKU0VMZ05MMEdT?=
 =?utf-8?B?YmpLaVlaODZsZlRmRnQ1Z0FVRkk4ZU40dHIvYjFlY0lvOHBMY2tiazRTWllm?=
 =?utf-8?B?Qi9TeWpCTElVeWtmNUNFcFhZL0loVGJocHRLWFY0d0tMTFM1b1FwaFJ6VCtO?=
 =?utf-8?B?bEhTbnNVUjlMMU1STXZ5QnJVUjc1MjFxMFZhSEp3c3BybVM5dDhkak41WGgr?=
 =?utf-8?B?NnNtNEkxSmJwcERUQjJPRjl6dHh5WjFjdjFEVG8rdUdJbWFseHQrbkxOZk01?=
 =?utf-8?B?Y01aUnJ2dkgza3FPM3FjSVJRTGdWR1FUZm80MEMxU1p4OFIyVStJeThBWHNK?=
 =?utf-8?B?VG1XK2lqSkhQNlkvaHNoeENHMlNXMEdycWNkdmdQbUpnUmJkcGc2VjZYYjdO?=
 =?utf-8?B?SkV1WUM2ODZpWmFnS2QyQUhLUFVRVXN5Sk5LTDJHbnRodkhRQzFnVnNHRmwv?=
 =?utf-8?B?cDRxTEpKZDZITzEwaGpqODA1dDUzN1M0Z0N1MFNMcmtBK0E1VHdtek5iZ3B0?=
 =?utf-8?B?VXNtQ0I2Wk5Ya3k2YWRROUZXZFZjQWdVQzNuWVhwRERKODFXVmxsc2pTRzRT?=
 =?utf-8?B?TU9TN21nMkpORm1HMTBrUnZyOWlMdFVaRzZLN0hGTWdBTlQwT0ZidmFBQlFM?=
 =?utf-8?B?STZwTGJJZ3g2akM5cTVCbUpoK3BqY0RBclZiZDZGUTc3K2lBSE13bGxOUENt?=
 =?utf-8?B?N2Nvbk5GYXpncFBXd3dwTi9hUFBTdkRiK1B5anVoWTFNeTZKSzJ0QVZrT1Nu?=
 =?utf-8?B?ejVPMzZlMDZCZmVseVAvOEJBcDdIVHBqMjlXOVFRVVNib25KcHMvallFY051?=
 =?utf-8?B?NC9CMkd3eGJUZXR4anUyQ0kyT3dPTVZQMDVHaWhLK2VsVlV1eTUvVWFCUnU2?=
 =?utf-8?B?MHNvakk3OUNLWkt4elRRM0dFUW9OaWhHWHRVU0NBNEhncXhWdUZSaGRIL1VS?=
 =?utf-8?B?TDR6cllxUGp4ZlM4ZkNVYTJ1Mkc5Q01JTFN4YlJCZG5TbW5qZ0JSRmwvb1Ry?=
 =?utf-8?B?VUt6aFl2dU1raW1TUklPWU4rRFJwbDViZ0VxZ05uZkc5S1ZkVWZBY1QvN3M0?=
 =?utf-8?B?RUwzL1RPcWxQUnFPYWFDOVNFQmIwZVQ1OXFhVGhDeDQ2Y0JXNlVQb2ZZaDNr?=
 =?utf-8?Q?cAGovK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d2Nadmw2Z0tnd0NKdlh0WEQ5L0VrcURkbDRIVUhwTXlDYnhVWk1XLzJMMFlX?=
 =?utf-8?B?VXJiQ0VxYXJKRkgvUW5KRjYvbjhIa2RRVi80WktiTU9tSGlTcFdxNDEwblNp?=
 =?utf-8?B?ZktDUTZxZHZzWDZ5UTROcmpjblJrZldGZUNIclpXVSsxNGhLSGxzNFZlS29t?=
 =?utf-8?B?d24rOFhGY3RrKzFYMUhlbUNTOUl1N1l3ZnJiUkh0d0oyVGtwRW1rNVFaRUIv?=
 =?utf-8?B?dmJHUGtEUEw5QmcvUHJVcWJRQWlqb3M2RzlrRW1KTWY2UEU2UU5ML1RCYSto?=
 =?utf-8?B?NGdaRExlUFFaOGxtdGdEY1dBVkIwQVhHUDNRNjBPUlVWVk9IYkdObjJpbmZx?=
 =?utf-8?B?UFZUTU8rdjBiYnRUa2hQdFlLY2tpbWRFY2pvaWV1UDdRRG5rOW5nTVEwZU84?=
 =?utf-8?B?OHBSeTRvMlo1blF2MzFjN0Q1VjNFTHU1aDJUNHJkYWxwRmRmMG1aM3IzWG1z?=
 =?utf-8?B?enVxakxXeUh5aHVLa2MrMVJPeXB3cE52Vkd2RVI5akxnYlJYZXJNcDZDcUc3?=
 =?utf-8?B?RjV0V0R3K0xLQVhoSWtBSVgvSStwcXI0OXpCbGNmWUgxREZKSlVreEJSTzhM?=
 =?utf-8?B?SDJIMld0ZWxGeU5XUWw4YXBYbzVySXFuYzIxLzZuNHQ2TS9yRXZCZ0lleWdH?=
 =?utf-8?B?VXZMYXpSbmIyd3lNVXFDWkVLMHFycmRYZFAxWm1oZUdIRW9UU2UrQkI3a25s?=
 =?utf-8?B?SmxObCt5ODVuYzVZTlFMSnNMZUIwZnhqOVZpbkhoMkVUNWUvR1NuN3ZZMWNh?=
 =?utf-8?B?SVlSL045UE5OaUNOeStkcW1xUmg2NndEYWdvNnd3b0RtQlROTHVkZHZxcnM3?=
 =?utf-8?B?UHNYYlg3dkp6c0ZrdEFVVjlSTVdWZ3U3bnNRNTdwaS9ES25IMTg1TmdZbGl6?=
 =?utf-8?B?U0FjWFJHaTBseVZsWm5GZ3ljM2pUK1hpZUs2SnV2b1BqMjVqUjlSbmhJOUlm?=
 =?utf-8?B?ZDQybEY1WEt4eEJWbGhFT0NYeGo1L3VFcnlrUS9VL1hTTytPVnJyeEVpbzJi?=
 =?utf-8?B?WHhUZmh1UStuSmxabnM4aU40TVRlY2FuaXhnUzQ1STFRRXdReTBGKys2dkNo?=
 =?utf-8?B?ZjdzQXNDU2w3OEVZUmY3Skx0emdpaFJVV1o5Sm5LOFZYbjBhbnlaZ3hHdG01?=
 =?utf-8?B?UGNVbGNtRE45dTFjbWkrdzZIc2s1Si9zOFIreXhjTnVJMlR4MENtTDd6a3BX?=
 =?utf-8?B?c2FPUkRoY2FtWkI0VG9CekVYalRmYnNReUZNb1llSXhGZDY3bjJhektDbXZV?=
 =?utf-8?B?ZXFaL1lSU0ZKM3RvMHZEb2JBY3hXYWVBOEMzUVlOZ0ZOSTArUUlqWTY5N1RK?=
 =?utf-8?B?bFpkTUVvUmMvcUVJcHREbGowdGw0VDJjNnhVWWNJaG9ndHhSaFpRV0ExMVhq?=
 =?utf-8?B?SGUyRDBwdWhUUDl6VjdlQlRKd3l0LzFiTXlLbm9DQ0VhZko3V2J4MmkzZ2Mx?=
 =?utf-8?B?QXlpd0tPOUk2Rmp0NUcvUEFPVFZILzU2YW1qU0xyYTBjMEp3T08wTG14NTZt?=
 =?utf-8?B?UE1NbUlDTENhNG9QV25jbE95ZHZibjNBRSs4VStRbVB0VHcyRy9pVVBaSEg3?=
 =?utf-8?B?QVZVVXJXbVhIMGxCQStyTXlMcjkreEdUcC81Mk85SkxhNkoxcUFnWEJIRDlz?=
 =?utf-8?B?RmpyUjh4Z0VuV1puTy9zNDU2aENza1JxWXdRYVF4cCtUMG5wZ09OUFp0eHBn?=
 =?utf-8?B?OXk5UWRsaGZDd1cxZlBkcVJlcWpsWTMvMEhjU2ZWNzg2Y0FMejFGVlR4UkF6?=
 =?utf-8?B?ODZ2NTBOVUx6THZuWkRKa1RRRHpxbXpXaWtUZy9UUUVKWHprUmF6NzgxUHNS?=
 =?utf-8?B?Wjg0M1V1QmxsejBNVDJ6V0o5Qk81dmptYmVqVzlMSXQwcGZ0N2V1bHZzek9I?=
 =?utf-8?B?R2dlNkQrYm1LZExBbmdHNkV2b0pzVUh1RHZQRko5U3pmT3BtWTBXYTZlVHFx?=
 =?utf-8?B?VzV0ck54NTNKemYzRk1XbmR1YVJDVWRPRm5WcXdtRnJzWnZ6WjlnUzErLzlF?=
 =?utf-8?B?UUxYZ2luUC8xWVlWMWk5M2hvVnU4QjIwdG5KZHVvdGIzTmNjMmdxYnZYVVBo?=
 =?utf-8?B?ZWxGZzQ2SGREWThoTGorYlRvMnNybGQ4NTUrWXZqdTE5R1NHNVdwcFZLUXF0?=
 =?utf-8?B?WWwrNG9MaHgxUXpZZ2pYdXZGeXJ2MlF0b1VManpGT3V4akltWFN0MmFkMTFh?=
 =?utf-8?B?RXU2dkF2N3BUdVVoc3JBQ0R0ZDRTdzlDZWcyZGRXOXlUcVRiVDk0THZpb3l2?=
 =?utf-8?B?eEdjZVI5QjhyZFhlVE9QWjR1N1dnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73F8B6EED3E3EF46A1796978A3E3DF44@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4c865d-c4e9-434c-dd95-08de238d61f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 14:52:07.3648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffzNZVTBfHoSOf2EduQLRsmfe+7qVtmTK6Ty4eoB3kOgXoN8mq29Y5MUtjNsO4HA51OV766wCccvN/9RLP0pp7aabg63GGNrwxzpO6H1bZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8172
X-Proofpoint-GUID: XGkqgWiTe_ih25dvhBOP7SEI4PxfN1Dy
X-Proofpoint-ORIG-GUID: XGkqgWiTe_ih25dvhBOP7SEI4PxfN1Dy
X-Authority-Analysis: v=2.4 cv=LLJrgZW9 c=1 sm=1 tr=0 ts=69174219 cx=c_pps
 a=8P4KAFraM2L8FVmDPFuExA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=2Gz2WoAFcKEPWR6CPvcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE0MDExOSBTYWx0ZWRfX4Zy0u7QkwpFD
 5NlY19N0NNPeqmoYKZm4v0pynkiB70+XhENTfAJ5SMUQFq3Lg8hUNYFECfBsPALqFyX6RSvMTyR
 x515qVHR9ItZ90YarPU7lZfp10ap3cx9QzZ+g+71yajY2G7L+6pNi8uh4Wg09Xdvgr5MGVUVfdG
 E+L7nmLQa1jvyzbCTysONprbw47/dfMXlITDDNyTqqzJVjpCju29cxUabYuaVs8AIbEXJCERioZ
 OmoEDYO5E4+JKdc3aHfEjNMmnmC2c3a4FRNELZEADzuS1wGdjGXJ5GGhmakqx9bLK/NjDTte0/e
 R2K62uvo1zRWpo8I2XuDwRtLMSEEcKd8tNxxD+oyO8YSDuZ0V2I1ohwTtCiC8bpo0wCb+Z3YQcx
 NipDuzCM8VLrwxtb98Vjw9Fjm/icfg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDEyLCAyMDI1LCBhdCAyOjAy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVHVlLCBTZXAg
MTYsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBUaGlzIHNlcmllcyBtb2Rlcm5pemVzIFZN
WCBkZWZpbml0aW9ucyB0byBhbGlnbiB3aXRoIHRoZSBjYW5vbmljYWwgb25lcw0KPj4gd2l0aGlu
IExpbnV4IGtlcm5lbCBzb3VyY2UuIEN1cnJlbnRseSwga3ZtLXVuaXQtdGVzdHMgdXNlcyBjdXN0
b20gVk1YDQo+PiBjb25zdGFudCBkZWZpbml0aW9ucyB0aGF0IGhhdmUgZ3Jvd24gb3JnYW5pY2Fs
bHkgYW5kIGhhdmUgZGl2ZXJnZWQgZnJvbQ0KPj4gdGhlIGtlcm5lbCwgaW5jcmVhc2luZyB0aGUg
b3ZlcmhlYWQgdG8gZ3JvayBmcm9tIG9uZSBjb2RlIGJhc2UgdG8NCj4+IGFub3RoZXIuDQo+PiAN
Cj4+IFRoaXMgYWxpZ25tZW50IHByb3ZpZGVzIHNldmVyYWwgYmVuZWZpdHM6DQo+PiAtIFJlZHVj
ZXMgbWFpbnRlbmFuY2Ugb3ZlcmhlYWQgYnkgdXNpbmcgYXV0aG9yaXRhdGl2ZSBkZWZpbml0aW9u
cw0KPj4gLSBFbGltaW5hdGVzIHBvdGVudGlhbCBidWdzIGZyb20gZGVmaW5pdGlvbiBtaXNtYXRj
aGVzDQo+PiAtIE1ha2VzIHRoZSB0ZXN0IHN1aXRlIG1vcmUgY29uc2lzdGVudCB3aXRoIGtlcm5l
bCBjb2RlDQo+PiAtIFNpbXBsaWZpZXMgZnV0dXJlIHVwZGF0ZXMgd2hlbiBuZXcgVk1YIGZlYXR1
cmVzIGFyZSBhZGRlZA0KPj4gDQo+PiBHaXZlbiB0aGUgbGluZXMgdG91Y2hlZCwgSSd2ZSBicm9r
ZW4gdGhpcyB1cCBpbnRvIHR3byBncm91cHMgd2l0aGluIHRoZQ0KPj4gc2VyaWVzOg0KPj4gDQo+
PiBHcm91cCAxOiBJbXBvcnQgdmFyaW91cyBoZWFkZXJzIGZyb20gTGludXgga2VybmVsIDYuMTYg
KFAwMS0wNCkNCj4gDQo+IEhybS4gIEknbSBkZWZpbml0ZWx5IGluIGZhdm9yIG9mIGFsaWduaW5n
IG5hbWVzLCBhbmQgbm90IG9wcG9zZWQgdG8gcHVsbGluZw0KPiBpbmZvcm1hdGlvbiBmcm9tIHRo
ZSBrZXJuZWwsIGJ1dCBJIGRvbid0IHRoaW5rIEkgbGlrZSB0aGUgaWRlYSBvZiBkb2luZyBhIHN0
cmFpZ2h0DQo+IGNvcHkrcGFzdGUuICBUaGUgYXJjaC94ODYvaW5jbHVkZS9hc20vdm14ZmVhdHVy
ZXMuaCBpbnNhbml0eSBpbiBwYXJ0aWN1bGFyIGlzIHB1cmUNCj4gb3ZlcmhlYWQvbm9pc2UgaW4g
S1VULiAgRS5nLiB0aGUgbGF5ZXIgb2YgaW5kaXJlY3Rpb24gdG8gZmluZCBvdXQgdGhlIGJpdCBu
dW1iZXIgaXMNCj4gX3JlYWxseV8gYW5ub3lpbmcsIGFuZCB0aGUgc2hpZnRpbmcgZG9uZSBmb3Ig
Vk1GVU5DIGlzIGRvd25yaWdodCBncm9zcywgYnV0IGF0DQo+IGxlYXN0IGluIHRoZSBrZXJuZWwg
d2UgZ2V0IHByZXR0eSBwcmludGluZyBpbiAvcHJvYy9jcHVpbmZvLg0KPiANCj4gU2ltaWxhcmx5
LCBJIGRvbid0IHdhbnQgdG8gcHVsbCBpbiB0cmFwbnIuaCB2ZXJiYXRpbSwgYmVjYXVzZSBLVk0g
YWxyZWFkeSBwcm92aWRlcw0KPiA8bnI+X1ZFQ1RPUiBpbiBhIHVhcGkgaGVhZGVyLCBhbmQgSSBz
dHJvbmdseSBwcmVmZXIgdGhlIDxucj5fVkVDVE9SIG1hY3Jvcw0KPiAoInRyYXAiIGlzIHZlcnkg
bWlzbGVhZGluZyB3aGVuIGNvbnNpZGVyaW5nIGZhdWx0LWxpa2UgdnMuIHRyYXAtbGlrZSBleGNl
cHRpb25zKS4NCj4gDQo+IFRoaXMgaXMgYWxzbyBhIGdvb2Qgb3Bwb3J0dW5pdHkgdG8gYWxpZ24g
dGhlIHRoaXJkIHBsYXllcjogS1ZNIHNlbGZ0ZXN0cy4gIFdoaWNoDQo+IGtpbmRhIHNvcnRhIGNv
cHkgdGhlIGtlcm5lbCBoZWFkZXJzLCBidXQgd2l0aCBzdGFsZSBhbmQgYW5ub3lpbmcgZGlmZmVy
ZW5jZXMuDQo+IA0KPiBMYXN0bHksIGlmIHdlJ3JlIGdvaW5nIHRvIHB1bGwgZnJvbSB0aGUga2Vy
bmVsLCBpZGVhbGx5IHdlIHdvdWxkIGhhdmUgYSBzY3JpcHQgdG8NCj4gc2VtaS1hdXRvbWF0ZSB1
cGRhdGluZyB0aGUgS1VUIHNpZGUgb2YgdGhpbmdzLg0KPiANCj4gU28sIEkgdGhpbmsvaG9wZSB3
ZSBjYW4ga2lsbCBhIGJ1bmNoIG9mIGJpcmRzIGF0IG9uY2UgYnkgY3JlYXRpbmcgYSBzY3JpcHQg
dG8NCj4gcGFyc2UgdGhlIGtlcm5lbCdzIHZteGZlYXR1cmVzLmgsIHZteC5oLCB0cmFwbnIuaCwg
bXNyLWluZGV4LmggKHRvIHJlcGxhY2UgbGliL3g4Ni9tc3IuaCksDQo+IGFuZCBnZW5lcmF0ZSB0
aGUgcGllY2VzIHdlIHdhbnQuICBBbmQgaWYgd2UgZG8gdGhhdCBmb3IgS1ZNIHNlbGZ0ZXN0cywg
dGhlbiB3ZQ0KPiBjYW4gY29tbWl0IHRoZSBzY3JpcHQgdG8gdGhlIGtlcm5lbCByZXBvLCBpLmUu
IHdlIGNhbiBtYWtlIGl0IHRoZSBrZXJuZWwncw0KPiByZXNwb25zaWJpbGl0eSB0byBrZWVwIHRo
ZSBzY3JpcHQgdXAtdG8tZGF0ZSwgZS5nLiBpZiB0aGVyZSdzIGEgYmlnIHJlbmFtZSBvcg0KPiBz
b21ldGhpbmcuDQoNClRoYW5rcywgU2VhbiAtIEhhcHB5IHRvIHRha2UgYSBzd2luZyBhdCBpZiB5
b3UgZG9u4oCZdCBhbHJlYWR5IGhhdmUgc29tZXRoaW5nDQpjb29rZWQgdXAgdG8gbWFnaWMgdGhh
dCBpbnRvIGV4aXN0ZW5jZS4gQW55IGNoYW5jZSBhbnkgb3RoZXIgc3Vic3lzdGVtcyBkbw0Kc29t
ZXRoaW5nIHNpbWlsYXI/IFdhbnQgdG8gbWFrZSBzdXJlIHdlIGRvbuKAmXQgcmUtaW52ZW50IHRo
ZSB3aGVlbCBpZiBzby4NCg0KT3RoZXJ3aXNlLCBoYXBweSB0byBzdGFydCBmcm9tIHNjcmF0Y2gs
IHRoYXRzIGZpbmUgdG9vLg0KDQpKb24NCg0KPiANCj4+IEhlYWRlcnMgd2VyZSBicm91Z2h0IGlu
IHdpdGggbWluaW1hbCBhZGFwdGF0aW9uIG91dHNpZGUgb2YgbWlub3IgdHdlYWtzDQo+PiBmb3Ig
aW5jbHVkZXMsIGV0Yy4NCj4+IA0KPj4gR3JvdXAgMjogTWVjaGFuaWNhbGx5IHJlcGxhY2UgZXhp
c3RpbmcgY29uc3RhbnRzIHdpdGggZXF1aXZhbGVudHMgKFAwNS0xNykNCj4+IA0KPj4gUmVwbGFj
ZSBjdXN0b20gVk1YIGNvbnN0YW50IGRlZmluaXRpb25zIGluIHg4Ni92bXguaCB3aXRoIExpbnV4
IGtlcm5lbA0KPj4gZXF1aXZhbGVudHMgZnJvbSBsaWIvbGludXgvdm14LmguIFRoaXMgc3lzdGVt
YXRpYyByZXBsYWNlbWVudCBjb3ZlcnM6DQo+PiANCj4+IC0gUGluLWJhc2VkIFZNLWV4ZWN1dGlv
biBjb250cm9scyAoUElOXyogLT4gUElOX0JBU0VEXyopDQo+PiAtIENQVS1iYXNlZCBWTS1leGVj
dXRpb24gY29udHJvbHMgKENQVV8qIC0+IENQVV9CQVNFRF8qLCBTRUNPTkRBUllfRVhFQ18qKQ0K
Pj4gLSBWTS1leGl0IGNvbnRyb2xzIChFWElfKiAtPiBWTV9FWElUXyopDQo+PiAtIFZNLWVudHJ5
IGNvbnRyb2xzIChFTlRfKiAtPiBWTV9FTlRSWV8qKQ0KPj4gLSBWTUNTIGZpZWxkIG5hbWVzIChj
dXN0b20gZW51bSAtPiBzdGFuZGFyZCBMaW51eCBlbnVtKQ0KPj4gLSBWTVggZXhpdCByZWFzb25z
IChWTVhfKiAtPiBFWElUX1JFQVNPTl8qKQ0KPj4gLSBJbnRlcnJ1cHQvZXhjZXB0aW9uIHR5cGUg
ZGVmaW5pdGlvbnMNCj4+IA0KPj4gQWxsIGZ1bmN0aW9uYWwgYmVoYXZpb3IgaXMgcHJlc2VydmVk
IC0gb25seSB0aGUgY29uc3RhbnQgbmFtZXMgYW5kDQo+PiB2YWx1ZXMgY2hhbmdlIHRvIG1hdGNo
IExpbnV4IGtlcm5lbCBkZWZpbml0aW9ucy4gQWxsIGV4aXN0aW5nIFZNWCB0ZXN0cw0KPj4gcGFz
cyB3aXRoIG5vIGZ1bmN0aW9uYWwgY2hhbmdlcy4NCj4+IA0KPj4gVGhlcmUgaXMgc3RpbGwgYSBi
aXQgb2YgYnVsayBpbiB4ODYvdm14LmgsIHdoaWNoIGNhbiBiZSBhZGRyZXNzZWQgaW4NCj4+IGZ1
dHVyZSBwYXRjaGVzIGFzIG5lZWRlZC4NCj4+IA0KPj4gSm9uIEtvaGxlciAoMTcpOg0KPj4gIGxp
YjogYWRkIGxpbnV4IHZteC5oIGNsb25lIGZyb20gNi4xNg0KPj4gIGxpYjogYWRkIGxpbnV4IHRy
YXBuci5oIGNsb25lIGZyb20gNi4xNg0KPj4gIGxpYjogYWRkIHZteGZlYXR1cmVzLmggY2xvbmUg
ZnJvbSA2LjE2DQo+PiAgbGliOiBkZWZpbmUgX19hbGlnbmVkKCkgaW4gY29tcGlsZXIuaA0KPj4g
IHg4Ni92bXg6IGJhc2ljIGludGVncmF0aW9uIGZvciBuZXcgdm14LmgNCj4+ICB4ODYvdm14OiBz
d2l0Y2ggdG8gbmV3IHZteC5oIEVQVCB2aW9sYXRpb24gZGVmcw0KPj4gIHg4Ni92bXg6IHN3aXRj
aCB0byBuZXcgdm14LmggRVBUIFJXWCBkZWZzDQo+PiAgeDg2L3ZteDogc3dpdGNoIHRvIG5ldyB2
bXguaCBFUFQgYWNjZXNzIGFuZCBkaXJ0eSBkZWZzDQo+PiAgeDg2L3ZteDogc3dpdGNoIHRvIG5l
dyB2bXguaCBFUFQgY2FwYWJpbGl0eSBhbmQgbWVtb3J5IHR5cGUgZGVmcw0KPj4gIHg4Ni92bXg6
IHN3aXRjaCB0byBuZXcgdm14LmggcHJpbWFyeSBwcm9jZXNzb3ItYmFzZWQgVk0tZXhlY3V0aW9u
DQo+PiAgICBjb250cm9scw0KPj4gIHg4Ni92bXg6IHN3aXRjaCB0byBuZXcgdm14Lmggc2Vjb25k
YXJ5IGV4ZWN1dGlvbiBjb250cm9sIGJpdA0KPj4gIHg4Ni92bXg6IHN3aXRjaCB0byBuZXcgdm14
Lmggc2Vjb25kYXJ5IGV4ZWN1dGlvbiBjb250cm9scw0KPj4gIHg4Ni92bXg6IHN3aXRjaCB0byBu
ZXcgdm14LmggcGluIGJhc2VkIFZNLWV4ZWN1dGlvbiBjb250cm9scw0KPj4gIHg4Ni92bXg6IHN3
aXRjaCB0byBuZXcgdm14LmggZXhpdCBjb250cm9scw0KPj4gIHg4Ni92bXg6IHN3aXRjaCB0byBu
ZXcgdm14LmggZW50cnkgY29udHJvbHMNCj4+ICB4ODYvdm14OiBzd2l0Y2ggdG8gbmV3IHZteC5o
IGludGVycnVwdCBkZWZzDQo+PiAgeDg2L3ZteDogYWxpZ24gZXhpdCByZWFzb25zIHdpdGggTGlu
dXggdWFwaQ0KPj4gDQo+PiBsaWIvbGludXgvY29tcGlsZXIuaCAgICB8ICAgIDEgKw0KPj4gbGli
L2xpbnV4L3RyYXBuci5oICAgICAgfCAgIDQ0ICsrDQo+PiBsaWIvbGludXgvdm14LmggICAgICAg
ICB8ICA2NzIgKysrKysrKysrKysrKysrKysrDQo+PiBsaWIvbGludXgvdm14ZmVhdHVyZXMuaCB8
ICAgOTMgKysrDQo+PiBsaWIveDg2L21zci5oICAgICAgICAgICB8ICAgMTQgKw0KPj4geDg2L3Zt
eC5jICAgICAgICAgICAgICAgfCAgMjMwICsrKy0tLQ0KPj4geDg2L3ZteC5oICAgICAgICAgICAg
ICAgfCAgMzU2ICsrLS0tLS0tLS0NCj4+IHg4Ni92bXhfdGVzdHMuYyAgICAgICAgIHwgMTQ4OSAr
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCj4+IDggZmlsZXMgY2hhbmdl
ZCwgMTg3NiBpbnNlcnRpb25zKCspLCAxMDIzIGRlbGV0aW9ucygtKQ0KPj4gY3JlYXRlIG1vZGUg
MTAwNjQ0IGxpYi9saW51eC90cmFwbnIuaA0KPj4gY3JlYXRlIG1vZGUgMTAwNjQ0IGxpYi9saW51
eC92bXguaA0KPj4gY3JlYXRlIG1vZGUgMTAwNjQ0IGxpYi9saW51eC92bXhmZWF0dXJlcy5oDQo+
PiANCj4+IGJhc2UtY29tbWl0OiA4OTA0OThkODM0YjY4MTA0ZTc5YjU3YTgwMWZhMTFmYzZjZTgy
ODQ2DQo+PiANCj4+IC0tIA0KPj4gMi40My4wDQoNCg0K

