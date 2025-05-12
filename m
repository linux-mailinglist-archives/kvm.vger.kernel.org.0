Return-Path: <kvm+bounces-46182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F572AB3B4E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D96164FBB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D665322A4D2;
	Mon, 12 May 2025 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QgIS7Mlv";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VbJWuykP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E66C21A420
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061387; cv=fail; b=hinOvdiqcuTwTD2BKOVxdWZalhCoPJYGqvMLFjI2Sr6hkP26yKj+NUt/4l2M6aIEyeAY4Z0LFKL2p2Dnaf9yqZX1TX4f4oqpHRHA8LyJ8dwP7ieSqe5QKY5Xp0x/tkWEhfc+kp0d4xzn0jrCuIbVvC+RQhVX2u+ue8TPiM1Dkhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061387; c=relaxed/simple;
	bh=yL0weC7x/hrAf/LPwVtUi/5eR7hdSP8bZzZR8PGQWTE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OQqIoRF7awhY6+EOGUSSNTXgbRfWNaqTwK61Sx7MNEVUomklA4U+5shf5x134ixleBkOzinxfCJPKHx04qoRFK8nR/uCUjC4SnY3ocEGfGpLHeEyDA0Ok0CtOU9lVWFC3H9LNBbV0tFo18m377KNH39TDFeo3qCT3207uULi/mA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QgIS7Mlv; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VbJWuykP; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CAj7Xl014637;
	Mon, 12 May 2025 07:48:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=W4MWYK1txdvJ/vmja/muCN+/ufEyOGXGVMj9ddSVx
	8k=; b=QgIS7MlvcFK3MuAWHGpnSUwe+NNzmzWdRP7gTujcPdkv8Ppo5wGfw7Nub
	T7vNl3HjMpzstEKwhH4C92jsKCYldCGwFlyXAZiPnJb111OQYoL9AnuHLTPkwZgz
	EK061pomujXsifP+aKyCypVr7rkBI68Ji7Fwt7SpyQ9zDys9CP9bBT3Ia3waYm/+
	MiJwOfbYjDt9IkRIhlexiuTW20cbsNCCfbbRrE/V8n3AmjxEHq8Yg5JyFbsgkYfT
	hIgb0q3hU4fYbNE7OP4kreZLtlYUQbidNnsG7LHi3xQ7BC4TfUfLdofIg2t3Q/df
	jpvW4GoF82czU6OSsGJC2FyI68pMA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010007.outbound.protection.outlook.com [40.93.11.7])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j4bb3gcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 07:48:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYeDqsNeBloh8c8qozjqa+mmpPK2QQdBneBva5AiI76iyknrzIZ+IZmFZ3PcEZsFCIimERgDWXa3Vmn07RUklF0Y6iynYkCq/vPY5IxzOyYskLu1b6yOSiDG/maC8JNyG+JYK+kL4ZfNLh41J+g6YpFiEEQim9ZVOpHqjqzIJVwpk/zEAAgcYseHjRnmpK6Sw06s+d+4gjAlWnazz5lXf7a3k7hOBY+dJHSnJT53RogFSIlheCWeagYLfXu0FgVq6ldWp/IUJnfgvV8AawbZOuTc1CSZ62KA+H/7Lis+pWxynuv5XHzDiGXiFK4tmpxtXNGLcam6T2fvlsOsC/41PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4MWYK1txdvJ/vmja/muCN+/ufEyOGXGVMj9ddSVx8k=;
 b=EzbMqxE2l9splL85QAxj5A/D1vxlkijNpNC8YkS0xi8CDHcXIyIlxDwXGBjmUuAFCPgp+tWGPZ/Z69JN5HazEazVBsJ1ediAcO8MIS8yo8d52ArDSbKKrlZle5omrOAG+B8CKGx0/12WWBLQ1UHXUpLqp9WPagP7HqBVD6LMarr5G8chEeIEgfRMLxk6wtZEIBvDfX4DvDD9ZtYoRzR4nqk2Jtv1j1udfmAUSqW3myjvLyHe50MMlfKsXz2oSmDR7a8J+OKgZjz5Xm3jUOAlaLru6WZUxeIT8cu5Ga4nbOzUNssirXih+Gz6TBnlSRwbT/99ehQnaWiS/nJDy3b1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4MWYK1txdvJ/vmja/muCN+/ufEyOGXGVMj9ddSVx8k=;
 b=VbJWuykPZhtWRfuCf6WD6bm8Fc2bMfaMfAeE+F4+05cn7ysRMl1Wer03vNez7CEKXi/qtThr+Yqr+Jy1gPEJAJMyqVvNJCaciLqqhWOO/X1w6Aysn4BV1ENWuE7HRRiQ+rPch+mEHbPTihsvF1nqCGc4K+xkkqPvKGXpE4uPibH/T38FI20pJb2/TlNODIvJnu/WCaBHRM3D2fGLceCojmussNPZFbTN2ms9xN8OCAp6Y5/tffPoGnWMEiYE/qke8O/JeBeyPxCEBaTRcDdZDG6rJmLc82gCqSECBETua/PUJbyWcGE1eu49fp8yS/ktUtyoh/6QBDAqeg2tNFNdrg==
Received: from BN8PR02MB5745.namprd02.prod.outlook.com (2603:10b6:408:bb::31)
 by CYXPR02MB10227.namprd02.prod.outlook.com (2603:10b6:930:df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Mon, 12 May
 2025 14:48:41 +0000
Received: from BN8PR02MB5745.namprd02.prod.outlook.com
 ([fe80::13bb:c756:a495:74f1]) by BN8PR02MB5745.namprd02.prod.outlook.com
 ([fe80::13bb:c756:a495:74f1%5]) with mapi id 15.20.8722.024; Mon, 12 May 2025
 14:48:40 +0000
Message-ID: <eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com>
Date: Mon, 12 May 2025 15:48:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: How to mark internal properties
To: Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
        Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost
 <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
        Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
        Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com>
 <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
 <aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org>
Content-Language: en-US
From: Mark Cave-Ayland <mark.caveayland@nutanix.com>
In-Reply-To: <87jz6mqeu5.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To BN8PR02MB5745.namprd02.prod.outlook.com
 (2603:10b6:408:bb::31)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR02MB5745:EE_|CYXPR02MB10227:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f74e079-8a46-48f8-ee9b-08dd916415df
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkQxbWd3eWM1c2Vyemtkc3FIWHZQa1RJWm1iTG5EcEY2dWNyK2JxSWZXRERV?=
 =?utf-8?B?SlFXdU0xUzdBTHpCaDFIMFRqajdRSW5HVUR0K3dnZ0FsNmpWV3lza1NHRzdZ?=
 =?utf-8?B?MDRTZlZna2lSYTR6OHh5a3JSNk1IWDBqMHZqS1dYV2wwbUZQbExxSEQvM3RC?=
 =?utf-8?B?RWNqYjRQempkS3VmMGxxcUVZTFZjYVdiTUprSDZLZmpmVE5jSFpCWmtDVkU2?=
 =?utf-8?B?OFA5NGl5cHB4SUN5TlNjWEtWSTI2NmI3cTNxREJVMXg1elVzVnJhRFQzNG9l?=
 =?utf-8?B?UXRCOGdRQk8yNHl0dzQwZWJGWitCckhKQ3ZYZ0NMNDgrVStSVk5wUUFKS0Iv?=
 =?utf-8?B?eE4yUXcwaDF2V29PbnZCYmdvUm5vbnQ1TEVLUXRWbjhBTzBrRjVMZEttNUov?=
 =?utf-8?B?U1Jka2dweC9JY2JiaUlzd1pqalR5SERuZWFsWnMwMDc5UFFpelVlQlNSTzJz?=
 =?utf-8?B?NFZpbkV3a1U1Z09PZGNtVTVGMmI2SGEwbnNPOHBudVFxb09IdHFiSHp0UzZM?=
 =?utf-8?B?WE1jYWwxam5Hcm5kUHQweXdieTZZODhBZXVSaUovM0JXdlNtR0Fwc2ZrckJR?=
 =?utf-8?B?V2JzdFZwWDhpb1QwaUdUbDYxbndvNmNySmVJd2g5WDFVUm5TSUNPZ0RFOEk4?=
 =?utf-8?B?UDBnTHhDY21sZk56YWFCRXpFYnY3SEpPOWRoT25iclh1WTJQNHV5V2I3aFNv?=
 =?utf-8?B?OWJsaTFxbmlMeHVFOUcyMy9WamxjRTZUUnpxR3Rjek9IZDFFa0lHUUdYNWtT?=
 =?utf-8?B?Q2Fta3hLTVlMTGN3cWdZRjBKeWoxdGhjNmFwRWlveVhMVnA3WHVzZ1plK0tE?=
 =?utf-8?B?ZVUrU0tpRXRFUVFpanJodDV2L0k4UGp4VXBpNUt5ZmRyMlBiVnRYdXlVck0v?=
 =?utf-8?B?NFZSQnlhNTd3NnJ6Y2JRWGlnWk8vTjhSdGMzb3RFZUhMb2hOeVdNbGRjbENr?=
 =?utf-8?B?NVd2NE94NFp1MCt2eXEzNC9GOEtmeHVHRVhpbGd2UG1DWTlxMmUvaG1yU3lN?=
 =?utf-8?B?cllBNjU2U1lLclBrRVFZaDgxeFhxUHpMaWhZQW52M21XVE5wdVJmNlYxV1Br?=
 =?utf-8?B?R1RxRzJpTXM2c2VadXF6MmZMVXU5UksxNFZjWDV3Z1FJNGI4a2hmNXJGVVJv?=
 =?utf-8?B?Rno0RFlEZW5HS3ZoNkVLeWxaL21sRmFkQjZrMFFnWklZWEt5eWZSRXlobmFH?=
 =?utf-8?B?TXdCR3E2bTB1SUFaWkZaOHFQbCt2eStjd3pjOG5sSWxjRHd1RmZmNkJoWlFN?=
 =?utf-8?B?SERReTdVLy90WGhZRjZDQ3pEZGhzeUpKMFZ6WkZFZFZRMDRTUVROZDZsSUVq?=
 =?utf-8?B?WnVxTGdHbmVLWVZlYzZxcU5NUm15dXB3VHl4NFhzaXFtMlUzdlpHUVRCQWhC?=
 =?utf-8?B?MHpTa2doTWRlZDEzNmh0UDhMVC84U29PM25kOTRuT0NuR1ViWDZqSmRDd3Fv?=
 =?utf-8?B?cVB5eWsrMGcya2o4aFpZOUcrb1l3Q1BRNEZnbG5hRjJkbGFXVG8xVWVNQUpM?=
 =?utf-8?B?S0NQNHYxTndiSU9iWDAyNEt2Tk9USTNQQ0VNcW9VTjdybkM2Ky8xU0ZFd1Vv?=
 =?utf-8?B?bG5EREpyV0FOZERjRTJxL3hhcTNlSUVqT3pxTndKd1ZvbDUxNUo5YVZYMm82?=
 =?utf-8?B?WFJ3N0VycTJXQ3VVMUdncUhLUUpWR0M4aGZMSC9KTDRVNmgvN2hFRkI1UmFZ?=
 =?utf-8?B?MDJRZ1R4bDZPYlRrNkJxb2E0NmxLSEZQVXdCSXAxR3Uxa091cldqSnRvM3JS?=
 =?utf-8?B?cjFkbUxUQ1pDZ1RjUXhQQWl5MXdPYzZyb09uWmFxN005elFudUh0VWE5VEFp?=
 =?utf-8?B?c0VndnJZVktOOFV6SFhCWmhsNWdiRFVUTEQzcEcwNW0vNGZYWDYzaXhSenI5?=
 =?utf-8?B?aW00TXJpa1ZEdUh4YzRmTzdna3VUVVl0aEN6WVRib0laVUJlNm1OZzBEVDB2?=
 =?utf-8?Q?75xy1Sn+dko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR02MB5745.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUNJWUVEUk1TUWgxWUUrUE9iSGQyd3I4WmJLQXdXQ2w3Rm9zWTgzT2dhNDNp?=
 =?utf-8?B?UUNOL1I1QVlEZndKd21aVGphSkpoVnFTRElyOGE0aVJaSmwwNnUyM2YyRnVp?=
 =?utf-8?B?WVpKWUJQTmhYcE9YbHVhSzdWeWt0dUUzL212NlR2dXJZR0JYM01DU1k2dnA5?=
 =?utf-8?B?b2hSaklQKzRLWHNPMDk1Q2lWc1pOR2RUeXQxdXpFaTFhMEZDUTF1OEJPTDBQ?=
 =?utf-8?B?Z1J2K28xT1VWOHpOaVkzakVoTUttVVJTVHpNdTVGSEJ6SzlwV3J3bmFaZzZU?=
 =?utf-8?B?L1E0cGZ3WmVEL25hUVRuTWZVYVdBejdWUTk3cWtSZjJqK0E5TFM5cjVXMHkx?=
 =?utf-8?B?Z3hPUWcrRjNTc3loS3pONWpoUFZoYWxCaW13VGQ0MDlTOEd0elhYNjNhZW1v?=
 =?utf-8?B?V21vOVJ2TVVtNWtPRlQzZzNUbGkrczh2aXh2a2ZUZ0p4d2hqdFZvamtFRmdD?=
 =?utf-8?B?UWNsR1hXYWFKQmlmOU1RbzZRUjlRWjdWWnJTZk4zdXFDZzMvS2ZNUHVOR2I4?=
 =?utf-8?B?c0YraHl5aGVGYWlQZlBVYkdSZkgxMlJ4Z2xUR0RTQkVlNC9iV2hHenoxS0pt?=
 =?utf-8?B?bUJtODRuTEJxWCtGaE5kdlBhRjZBZXczY2tqQnV1NDl3REU5RHV2WUpMM2Vn?=
 =?utf-8?B?OTJ0Qm44dmlKOXU5UlFKQ2VROVJocTEzL0QyOURlVUlqSVFxdnRFN3BUNi85?=
 =?utf-8?B?VUdmWGh5N0JWR3lkQk1UMU4rbGl1Q1VweXRFTytwOWRUbVh0M2J6VElWQlA0?=
 =?utf-8?B?QTBnNXNreitoekNEa29UdEdkVWxzS0pjOVVHdjZUaDQycURZZEs5cFN0ZHRa?=
 =?utf-8?B?R1FvT2tnNkNsNEJ6eFpjVlZsS0RYdzR1UDFjbXZoNklmMk11cElucDIxc1pB?=
 =?utf-8?B?RFhycngydVBtaFFIRGpCemdnN0JPSnBySzZOaWNYdlQyem50TGUvVk9TL1JT?=
 =?utf-8?B?MnZ2bzNDZUdqT0VUcHM0cm1yUDFFR3Q1NlJXY2JLdm0xRHU5Z2pEZVY3KzZP?=
 =?utf-8?B?ci8wWVlaUStBbFBScFl0VEsrcHZlaGZURkhHTUR4MUxRaTFkWjZld2MydjJM?=
 =?utf-8?B?bzRJWW1NcGNXSVlhWitXUmtBZjRiKzYxWm1qYjNwY1JJRU83dmc1ZHJrYUJ6?=
 =?utf-8?B?REM2dlFVNjMvMExuYVRTQWxUTmdoN0UrQ0FVUzNBR0JZV0NKb0tpREwzeDlT?=
 =?utf-8?B?emg4OWN1QUZlZi9BcUVhMkp4V3ZJZjV2cnlLUTFYZGsyend1MDRNT1l6c1pt?=
 =?utf-8?B?Zzh3bTkzcDJoVUFxcUc4VzFpaGZRdGVUa29ncTV1dVZQYldYS2lYMGhxTFBs?=
 =?utf-8?B?U2NlamFRcDNCaDhDcEJIckFOeTJJVDNtaUpndWVZWGJLcGZDN0NtQXM0WkVY?=
 =?utf-8?B?T2M2ZWZSa2VMODdmUVByaGRTck1LUWZTUkFmemN2RzFpbGNaQTBYWVZoNzFq?=
 =?utf-8?B?Z1A0SXN2Z1Mzdk1hMHhrUmU4VldENXpaMGtFUm9MVHk3akoxMVdwUkY2cGRY?=
 =?utf-8?B?VklLL2ZNZTh1dXpPdlQwK2R3K1N0T2NIUmdPNDdMTnhqQVVkR3hOSURuT3Rq?=
 =?utf-8?B?eVdDVHFoZ0ltby9oc2VLN1Q4MS9FYlVMdGR4MXdYeFNVS3hGTVFKU0ZQVkNq?=
 =?utf-8?B?ZlNKWGh6QmlIL1RWeStQN3hLTmVsVURVWURYVE5ERkRiRWxvY1ZUOG0vVmtQ?=
 =?utf-8?B?MGYwcjE3RHJCNkRyVnRnakRvc2MrK0dzK3BxN1BKMTFBOXpDbDBMR1oyc2sy?=
 =?utf-8?B?UzVtOERjUXNIcExOaXk0a05jZGdXSjc0WTVkd3FtOU5iSllNdjV4b0lRYXNZ?=
 =?utf-8?B?bzFzZGIzOTBiOFNHVnQxVFhkY3ozdzFHc1FsNGRwMERDRHd6OE5aRFRCWHNw?=
 =?utf-8?B?R3JHY3YyRTZCK09ZWHBYdVdlQjVKbDFLVmlKTnRlbzhPOSt0RGpTTmRSd25u?=
 =?utf-8?B?Z3Vud1ZXUUR4ZkVjck51Sm8yTHNiakk5UWdYKzA1V1UxVWFKYjk3UnZMQzQ2?=
 =?utf-8?B?S3V5aHpsN1FtV0hXLzdzY0twRVcwSmlIUnlCbGhCZVZDRXFucFdxZkNPZlVG?=
 =?utf-8?B?Sk8yTXhzNEk4VmN0V0pOMW9sMndFQy90cDUxcjh1blZMQm93bXR4bDRYbGpw?=
 =?utf-8?B?Z01KOEdOdE5iTVMrQVJIWDJzMkhQVThqMkVZVjlCMTNIQkZXVlZGS3gyU3Nj?=
 =?utf-8?B?UzZDaml1amM0Y0V6bU9helJUV2RRQ2xoS1F0YWZuWjlOcGRJREl3UTl2bnFP?=
 =?utf-8?B?TmozQU9mWmRYRWVvaDFoMEJyTXNnPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f74e079-8a46-48f8-ee9b-08dd916415df
X-MS-Exchange-CrossTenant-AuthSource: BN8PR02MB5745.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 14:48:40.8225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeN/M993+2KwsIasaepmCneaslUSgK6nebJx+hzN0KlONGDSyjP8qmDlAwtRznEm+J+OHFaBO3ZnTs/yqnZFe5hIkiRB/1wUZ8ZaIxJboao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR02MB10227
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDE1NCBTYWx0ZWRfX4d6cbuHJPSyA 5OwgYwYns8yjf2qG9TNNVQsp8F2XO/quZjmOrdWeCRaMx8sEemP0ap/WPWSOUELnpMTggnuBkqH W5J65WxjJ7im2KvKOlwJeP7neghMQKqnNQx87XBpEk0YOATdd9uBfD6GDIr5U1AwG/uD0wP8W/G
 ZkvN4WCRhQJC35Vo7xy8VaVbVp2v3+PQWn+VIgYedQuO0Tdyh4gXcqpRJQLRRW/iBG0HYjGjPOW 4n8Cl3pxqfLtamNZaAbJhuhlDkS6LctSGggXDJgvvP/kbfWfTylS5CMSBWnE5W1E+8meK85Hooc NgER/YwWOSFNkz5opbaLs9dQ0sBireJTnMH8q+r6ZS7yzd3XiHPHL3QPoVT8nBFt2VJLZk6pHRD
 TjtYFTTaO4Bfaav9FmhAqG73gaXs/z8phkzlewJ0hC7OSiBAHAA3lU2a6KtW8CRUnnLvQFfF
X-Proofpoint-ORIG-GUID: GHZzg7vjrpMi0v00RAEiuFEQ3dpXhKYZ
X-Proofpoint-GUID: GHZzg7vjrpMi0v00RAEiuFEQ3dpXhKYZ
X-Authority-Analysis: v=2.4 cv=B6K50PtM c=1 sm=1 tr=0 ts=68220a4b cx=c_pps a=kylQlKNaLH8A8Uw3zR316Q==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=WfgW5GyQuDqSUKx2Bk0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_05,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

On 12/05/2025 11:54, Markus Armbruster wrote:

> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
>> On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:
>>> On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote:
>>>> Thanks for your clarifications, Zhao! But I think this shows again the
>>>> problem that we have hit a couple of times in the past already: Properties
>>>> are currently used for both, config knobs for the users and internal
>>>> switches for configuration of the machine. We lack a proper way to say "this
>>>> property is usable for the user" and "this property is meant for internal
>>>> configuration only".
>>>>
>>>> I wonder whether we could maybe come up with a naming scheme to better
>>>> distinguish the two sets, e.g. by using a prefix similar to the "x-" prefix
>>>> for experimental properties? We could e.g. say that all properties starting
>>>> with a "q-" are meant for QEMU-internal configuration only or something
>>>> similar (and maybe even hide those from the default help output when running
>>>> "-device xyz,help" ?)? Anybody any opinions or better ideas on this?
>>>
>>> I think a q-prefix is potentially a bit clunky unless we also have
>>> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
>>> and have it auto-add the prefix, and to have the C APIs for
>>> setting properties search for both "foo" and "q-foo" so you
>>> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).
> 
> If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
> intent in the name useful?
> 
>> I think it is also not obvious enough that a 'q-' prefix means private.
> 
> Concur.
> 
>> Perhaps borrow from the C world and declare that a leading underscore
>> indicates a private property. People are more likely to understand and
>> remember that, than 'q-'.
> 
> This is fine for device properties now.  It's not fine for properties of
> user-creatable objects, because these are defined in QAPI, and QAPI
> prohibits names starting with a single underscore.  I append relevant
> parts of docs/devel/qapi-code-gen.rst for your convenience.

On a related note this also brings us back to the discussion as to the 
relationship between qdev and QOM: at one point I was under the 
impression that qdev properties were simply QOM properties that were 
exposed externally, i.e on the commmand line for use with -device.

Can you provide an update on what the current thinking is in this area, 
in particular re: scoping of qdev vs QOM properties?


ATB,

Mark.


