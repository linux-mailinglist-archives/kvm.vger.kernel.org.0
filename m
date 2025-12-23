Return-Path: <kvm+bounces-66576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F77CCD80B4
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BEFBA301CD17
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77E82E1730;
	Tue, 23 Dec 2025 04:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jj9pF4z7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vsdMj3Sv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC9086337;
	Tue, 23 Dec 2025 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463781; cv=fail; b=YV6Z4E+6UzVXcCnX1NkRXUCN7VXFBpwzE1ZxPHW2FS6EyLo65b/sKxaHAScsQA+ffvlrBOFr0L89OkgA/Rod6HrQ06O9SBZgt7ytp6NMVikiRBkTeER8xDbXPO1L9/SesDvwfCYieLUFHk6mtpJFhqE0qWSyww85mMHFFPZ0CuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463781; c=relaxed/simple;
	bh=Rjtkg40lQFt6+LSULvGcKs6teiVxi/roYE8iTVijCC8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n6wv2mvP+0FiTLe3wfEQyJi3odipOli4T9kC3M5a/qXAERzt9vbZQC12gkSxgpbiWPLVqRRFv+5475u0vTNHf8bhIrmUpyvYgtleWtPvZpD19VxDJ8QvpzC7xqlFL74DcIuP7PEuVQPIBDICsDK6622Vy01RvupLHNev0sNM5/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jj9pF4z7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vsdMj3Sv; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMI873O2865855;
	Mon, 22 Dec 2025 20:15:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Rjtkg40lQFt6+LSULvGcKs6teiVxi/roYE8iTVijC
	C8=; b=jj9pF4z7Sz8uKhh8k8A1wyZmE/Q6WlfUNaUxHY5KGsCbNzf9Fl1CdZGrH
	s7AaGkDqm0c3d7iMld56/o1oK3haK6wScVmUxufl3M1vgN+Nryks8rMhmWFwYJHh
	Nqp1GI4voGy1CuGr/zrWVZp+eEkClZaRiMDH4muYpXJxx6nHUIB3GKB0KdkwLUP7
	cPFnGyE1T0owzbWmCtk47dNOiJ7LY0Wcxyrt5t1evA/8hmrtjQUyMIBVFhDhmXCZ
	5hB65yO4ZnNr54+VCdL5Q9Shwl/LqE1HS1Lca0VhUrQXHB73TGPRMY7DC8hpVQVl
	5hwwU5Ppgv84siR/aMUmyq0pIVgYw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023101.outbound.protection.outlook.com [40.107.201.101])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7b0hs30s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4SAFDiHEIe7LW5/LVhw/EVJpQYWCKbGeVNeUuNH2fH4Hl/r/qg1Dc2+onETvwm6kAEZKmeM/txdGgznw+GsAbrloV9YPILEpF7tRxKrXftZ1evlriF0hmaPPlrBnzTlAl0iXPzccN7t/buFXq1zABJ/X1+0J1BfVYbjf9R2/bgjfxQqs3wqDvKrv9HMLvK/cfmXu8VAy5WP/5e6JPWxyWsz/BZwQSok9WXLgFTyB0KeS8uElNJ9j13/mKJVJgMgY33IRJJav5rMQWl8zl+RZG9+uWXzUdSyoFtfBa9sk1Y12T9f52ccwOP7fv0k/sexiq3KxcvXuNtYR90t8tEB1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rjtkg40lQFt6+LSULvGcKs6teiVxi/roYE8iTVijCC8=;
 b=K9fmDtQZKVcRp15D7eqeKpYdp74o5yE1UgUx0Cu9dui8E9hOFK2Xuu4GUgh7Q32ZgeJ0PMr733RSDV+e+bIc0vqYun3vKR8F0Wsht1IT65ER6c6vFZvDOpIKQMfDxnwo4Gb70OnhF+5kfMtpraL/rIjUFH4JpyYLaRHCp78eMpJaS7KV+8HblNIQf3RJclYQYZTgn6Rlk6/uQosBOXjiXuoAmhp9u+5ee9F97i/NCmkR0USfqQN1UP+UrIOnzKpNmjWEg1h6VH35aDQKaV5FcuFA09745N8x70XyGRdPy8V0Ue3P/pN+HDfNePGWUjQyhSlYo4NX7oTepWEvm3S/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjtkg40lQFt6+LSULvGcKs6teiVxi/roYE8iTVijCC8=;
 b=vsdMj3SvCpbBejRRDkHn/S1FXCEbV0219sRXftLhh6mk9Oq585JSI+SriZxcXNW25uP9UzwJMdwCM/bpef5USiudMhucBLlr7UjcbJgSTyImZDOSmZUen7JbdvB07gqhBeVArj8JpdFp4PlOnvMyi5fzVRwGxYvqQZKqaGq64cO0Ah2Yuh7Klb7GNhIvwTP0Ig0O/mt0Q993aDQLWu3tmGz1CVlj2usehpLAUbL/0WrBIIxNYU0iiHmk12jd6Oi65zAZZ/LznKoHudOzwaVesv3adfKiq048r8Aj7gjEcQnoEa35M0muOIJednpL6MEeUsNWYBj+bZTCvkZpRPpHqw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:48 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:48 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 12/18] KVM: x86/mmu: Introduce shadow_ux_mask
Thread-Topic: [RFC PATCH 12/18] KVM: x86/mmu: Introduce shadow_ux_mask
Thread-Index: AQHblFP4+Tt+tqpkhkWFIrmhm9FQwLPPu0oAgWChowA=
Date: Tue, 23 Dec 2025 04:15:48 +0000
Message-ID: <1BE3A8DD-A276-4FC5-A2E3-9B2BB5115704@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-13-jon@nutanix.com> <aCJIZgHi67_lze_v@google.com>
In-Reply-To: <aCJIZgHi67_lze_v@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: ae8e0a07-7c34-4aaf-6221-08de41d9f3ce
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YjdMYzlWK0l4R2piUG95VFlrQVR4RnRIMTZTTG5mUVROM2J1cnpNdzBndC92?=
 =?utf-8?B?bHFFL0oyR0JTOVRJK1NCOWg0NS81dkNrMEFKb1pRSHJPNVhVNGlDMVkzK0Fh?=
 =?utf-8?B?YTNQenpvWkkxYXhia1paTGdRQUtNMHJDeGw1SUNyWG1wbm1xa3d6bXliL3VD?=
 =?utf-8?B?dE0zb2ZtUVhqbWI5eGphMTlnbmhjUjJWekdaWi9KT2hEVSsvYWc1Nmo4VzB4?=
 =?utf-8?B?LzAvdTFYaXIrT1FDRG15V3hRbXU1a1RPaFFWc1daWnZqUHA4SXNqM21CTWF6?=
 =?utf-8?B?bkl6bDFqWjBGWCtSQ2tEZ0R4bFVXc3U3S0NWOHpKMElPcHVIazhjOHhNTlVZ?=
 =?utf-8?B?Y3VmV2pIaUZLYzJWK1JSaU1yMWYvRGhaK1RHRUQ1aitJb00wK0E5RDZxbWo1?=
 =?utf-8?B?RkVuYnlIRkdzYStJMEVQN0t5bjB5YlF5WDU4NzJaMGlCZ0QyVlMxNnJLNmtW?=
 =?utf-8?B?TnBFN1BDbDFWSnk5N0JVdEpQcVc5K2JGWU1HMVNLK3NYckU0UWFyQ3Z6WW1O?=
 =?utf-8?B?MjBXS2E0TjNzVTZnTG43dldybnBKaVNsSTJ6cjhTMTN2NVUvNTFSTkN0MGZS?=
 =?utf-8?B?RHd4ZE95NHRydVpKUzR6czZsZnJDcEJXaFl6ZnE3U2NKSzE5TFp3L0poeWRU?=
 =?utf-8?B?NzBUSlRqNnFURmVleEszSkZVUEYyaTRCY2dPbVNkQlBiUm0zZGllcUMxNi8r?=
 =?utf-8?B?Y0lnZStlRm9aVXJEMFJjbTFQSDlvaWdYMi8xOVdVWWlBcHNTalZPeUhqV0E1?=
 =?utf-8?B?WlRPSTV1NDYxWXF1ZTdnb2RQZ0hER0VCU3FKYlA0amhPb3ZIQ1VNZHNPRHRq?=
 =?utf-8?B?b3BrTE1zMGVnR2NqWnk3NU5EbkVxeGxCaDlaZm1SdjA5Q2ZSY1l2ZEN5RExo?=
 =?utf-8?B?eWllS1VLb001WE4vSG40TmhiWHNUV3pCem9RM0s0UUdad1hYQUp6Qnh3bEt6?=
 =?utf-8?B?dDhjWlhJdnRoTy85WlJLTFJCdFFmaWEweVpISUxSYVlMSWZkTDB1akxmR0VS?=
 =?utf-8?B?TlpPaDRpWnJVKzZ2TVdranA3d0dwUE9aQzVEeldONFRUQjVlbGNPdFhBZG5K?=
 =?utf-8?B?ZEZPQU5UNHMwR3BCejFNWHRNbVBrcFp1SEQwREJPeFdvblZZOVEranV4b1lv?=
 =?utf-8?B?N0pkM3FtUXB2cUU0aE82NDkyYWpzNUNYempWOXlNaDFIMVZGdVB3QWxicklE?=
 =?utf-8?B?VHd3ZVN1UmNwamJqZnMzODgwRDV5MG5mRXAzTEtJMUJDSUJpcXRQYVhseURL?=
 =?utf-8?B?b2hhTmZPYlcyWDhZMnA1Q1Ara3NLc2pDL0JFenRyd2sycCtRNmVWWlVLUERC?=
 =?utf-8?B?bXkrTUYzcVpNYXBVdWhVU2lnSnl3MFRoQ1BGclo0SEo5cHF5V1Fsc2Q2YUhL?=
 =?utf-8?B?MUpqd0FNcE1iK29jQWpwa2ZvZkZnMGsvT1p1a2FNeVBxbktSdExHQXp6STdR?=
 =?utf-8?B?V2pHSjVKUEZEUGN2czNnSzR4eklCcjdOSTROYS94QldENTIxMzRFeHQyNExm?=
 =?utf-8?B?Tmd1eURtbHBJUHlDOEQxVU9RMjVIVVAvc0I0dUUyYW0ybzRTWjB4WnNNdUNy?=
 =?utf-8?B?NklMSzFaM0ZsaDJJSTNRM0RoQ3ZhNUNndTE2NGt4ekc1Qy9XbHE1Snl0ODlh?=
 =?utf-8?B?b04zQ1pyR2VsUzhrMVN4VTJjSXFxQzRXQmZyaG1ZeEoxV2tNN21tS1JJVXl4?=
 =?utf-8?B?czlrMWlQdDNKMVBmV0h0RENaQ0FlbkhtNytRdWZUTVd6T0hySng1b0ZqNDhD?=
 =?utf-8?B?Z3ltYjZvVWV2eFVDMzRmTjZ6WFljS0hNODQ3STJuSXRQVm1SY0JvcGxtcDl6?=
 =?utf-8?B?WHhpVmNjYWE1WFp5eWJzdmo3enpRcGhZVW4zT3BodHpYT2htMHFmU0pueHV2?=
 =?utf-8?B?V0Y4eVYvd1d0dVM4cTRsVEpNVHJXYUNHVWlOQ3JFZ3RjcUVWQVl2MzN1N3Rh?=
 =?utf-8?B?Ym95WVBRWjNOTkJjNU1YelBUNjlTMmxzWWxkMEh6RWR4ajNBaW83RzRvM0x1?=
 =?utf-8?B?OWVhUDRMb2hINDROVHM0cFhBZE9kOEMxK3dCem0rckY4Tm9Fd3AvLzZLREpx?=
 =?utf-8?Q?+DcWyZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZjI1SWs1dTVPN29WalBPQWx3RnU1ZWE0QWVJUGxqNFFJUGNBNlZ0QktnSnJB?=
 =?utf-8?B?K0xDQmlrbDVxSXlObERNZXRYdHpjTVlzUFFQQjJYQzVDTFY1WFpsbENaVmxS?=
 =?utf-8?B?OElUQ2NhRmVOYmcxQndSdCtYbVNUOUpFSkFEN1hCQmM1RnZiSEF3dDJ3clZ3?=
 =?utf-8?B?dzhqR01GM0cyQzZKeEZPMm44emZFbUVOaWRWTTFQMExyeVVXdnM5V0FnUks5?=
 =?utf-8?B?d0tlSC9WckxELzc4NTVHUGZxV05iWml6akhoMExTTWllSTJHenIwMWNxL2NH?=
 =?utf-8?B?UUx6aXBjNG9Fbkt6WUJLN1E0NGtmdXkvNnpVVkFSVkp5V0NsUWE0Vm9lNUVa?=
 =?utf-8?B?cXdybnZSUVJWODI3M25BbWhqRmxLQk0vc0lWcVRZenpoQzVyNHMyVnNTK3FN?=
 =?utf-8?B?STZNVDNCRy9zSkxKcGVxeEVPYTJVOXh5am9iL0h1blVGS05ZT2kwUU11U25Z?=
 =?utf-8?B?SGlpUDlBbDlvcWtNY04wVk90N1JBblJkSGNNZTlLRzFyMEFKL0x0QWtTQ1E1?=
 =?utf-8?B?SWRrQVVSaU1vTlQ5ang3QStEVmpWdmNRQklBaGlFRFpubmttVFpHWFFmWTNl?=
 =?utf-8?B?SjRoZVdlODdtTER6QkR4bU9vcGc1ajdBT213REtYVUNNK0JSbjFnbVdqVmU3?=
 =?utf-8?B?dVUzN3FWaWJ4bndjT2NqL01QQWZoczNKYUg5MEN0Y1QyRVQ5eDl2M3UrYXlm?=
 =?utf-8?B?MWhZNjl3aTc4ZDArNXhRWnhlVjM5WmxDaytLa3h1UkhudERRd1Yyc3hGWXNt?=
 =?utf-8?B?WlZFbGkxTFdSZEQ1cllIOG1GSmpjOUh6NHJLOXNDZE56aGcyQWs4UW84UjV6?=
 =?utf-8?B?WUhTSzFpcERWLzM5aGRrV3V3aGpEUDhlZHdCV2VtazFzMFBpSmsvcjY5eVp5?=
 =?utf-8?B?WHY1VFN5dmNPVmRVcGVheFR4SDFyTUJ3NjA3SmVRREVCV1BWWmo3b1pTNVhk?=
 =?utf-8?B?dnp2T1FXM2F6VEpSbkNyYVRtUDdQSDhhVkF4cGphUkZkMStoa3Z0NjhybEYy?=
 =?utf-8?B?ckUwZ2RocWd0U1ErTzRmTWtYZ0lWeHBhbjd1TDZPVlNkSDZYa2lxVHl4OUNy?=
 =?utf-8?B?d3gvZzZtLzNaZ0ZiY0RXTVBWVTYyZm9JNHRBbDlRWEpRWE5UZG9jcDQxc2RU?=
 =?utf-8?B?S3B1Wmx5WGRHMTZKNEVPNEczN3FSNVBtSjhIZG1STlEreTM3MVMvYnRIbmUx?=
 =?utf-8?B?VHZ3ZHJYbnBUVXpDNDdnTzRieDh0M3MrNE1QRjZjQklZYTRpay9RaGRhbEVj?=
 =?utf-8?B?NXBUL3JyQ1M4WDhHV3FFdS95THVqdGRKL2IxdHlEZHZvUS9LRUU3Si9oSVdM?=
 =?utf-8?B?M09YNjcrOTRlQ1dlNmFmMENadENidzQxTFFoZDBzVEZDcHc4RG5kRXNEM25F?=
 =?utf-8?B?SUVLK3Zna05McmhwQTd0VHNwcGhTd3JheU5wTmRJUHVHbnJQRUM1QWdmQ05N?=
 =?utf-8?B?TVJ5bjF6MlFSckRUSmU0aGNWQzJoVkhERUJveGdPVGdqaGUzYXdtRkRQU2cv?=
 =?utf-8?B?cU1KZUZ4SXBZMXFRamNsYW5zbHNMMFJwU1Urdi9FMjIrdmFUSHdveVpxTmhL?=
 =?utf-8?B?RHk4ZmlBZGJVR1oxT3hBQ3AvcFVkYk9pQkxaUUU3YlNCd3NYaWpPZk8rcmU3?=
 =?utf-8?B?MlJxaVUxVkxVQ3B5VHRXR2lzVERVdCtONnlmMlU1dDZZRlNhNXVJK0daY3BV?=
 =?utf-8?B?eFFoODVNTFU0UmhSMlI1UjJJdFlMRUpTWW43UGZaTW45ZmJ6eGFGeTBSU3R6?=
 =?utf-8?B?WGl6cHZScm1CSCt6cUFuNkt5WCtTMnVnaERXQkRGM3piY1NaQm9udVpkZmVF?=
 =?utf-8?B?Q2tjaXZZaEpwYnlRN2JIRXdMMDRYa2M0V2h6cUx6SFdsZEZ2K1NHdTNlYkIy?=
 =?utf-8?B?TUU2UWN0eUt6Vi95elJOM1RVS0NJcjl6MytieElpd1hTeDdnRDFkVjBZZ3FW?=
 =?utf-8?B?NUp0V1JncFI3eDRlRTZveWNkM3pNdFFRWlZvQ0dFRGY5QVAwWWxsdjdTUHd3?=
 =?utf-8?B?aHF3UEZtQUhvL29yZmFFbkJYdWo3cnY2a2JJSUFEYk1SQUowNVBRbFdKMHkz?=
 =?utf-8?B?bS9Qa1FCVnJrWWNOU0V0S3pwOWE3WE9hZmtmQkc4VlBQNHg0OVhDOWZ6dldE?=
 =?utf-8?B?dEtublgyTUpkNUVuSjgvZ2hnL3E1K0wvV2Fhb2xRTHk2b0dZRnVQWmhoSG93?=
 =?utf-8?B?Q2NYZElWdHQvc2VxWHlkaGlSZ2cxWExYbWxBRnFxQzhqSmlNVXp2dmlSdlNi?=
 =?utf-8?B?VVJUeDJyZ05VRWxkU0dHNjJucjhQWkNQRFIrazlvKzhpUVg3RkpMak45bEJQ?=
 =?utf-8?B?eDQ4ZkhFam9XWFZsaGNzZVQ5RmNlVXFWVXB3M0M3V2ZDbWFjN2U2OVY4TnZq?=
 =?utf-8?Q?PJkf/WubTXC6WWuLBKBdzrO5ScGgDNZFIVwLG+F8zY42i?=
x-ms-exchange-antispam-messagedata-1: WEMI/Te8aVaCxpde0tiS2342p5zDMPowGdA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99D7BDC33E0FE64A95022253C005BD7E@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8e0a07-7c34-4aaf-6221-08de41d9f3ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:48.7152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLtPFiRfcXASjKOGqLIw1pHKLmRjXNE/e4qKcVBMCN5xuzZ6ahU2O3p37EZrdhVXRMYnoxmHj23C+DHZsQdcsEfBGSs8Xs1t9U7K60R9LFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Authority-Analysis: v=2.4 cv=KNNXzVFo c=1 sm=1 tr=0 ts=694a1776 cx=c_pps
 a=fEtlOdDQS7EBvc2olrXP4A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=Xz8RLfHsddehSHalq2wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX/agP/ca698Ly
 krxWa3vo6iQTtfP+d+/odUJmvs8Gd+/jtyWJUNMU6NdUi9lyj2AsuWHomzFDMBx+g4KetQXGCs5
 LYB4DMNI4yJKpQI/RMOjpnzY0tN9EA8cvIniWKPT2n8LiyorNUatheb3ugorOdlpnQKuM2Yrlbz
 rr30lhp0SoOvF1+J4mVvXJPSbYVN/2BlpwiJ0sSu/UZ71AMuQ2rTrZ3OZsZWd6uC5p+eDPNkCxC
 Zj+Vbp3PSW4wUJeUblbobdzGog4GLve3OfhCqCFU2YyUYT885y53stU3k7Iefj0HEStkGFyjVgg
 Ai/Sv7eGLZynUT6Eb6CtT8+92WY4wLGsJYRHVGosB2L2g9EczoZXEDWqPo3L7HDtt/OQjvaeQLB
 Hd6qj1XBZpq333mVhGcuEf0oadjZv6Zqpe9eogpmqG8204FbKQBZE1H1BLu2NkMqPoerMtgfgL9
 CQMRtcJ0POCMABe0hFw==
X-Proofpoint-GUID: SEevvElWVXoHUH5Ql2uyyeImw2XpYpW8
X-Proofpoint-ORIG-GUID: SEevvElWVXoHUH5Ql2uyyeImw2XpYpW8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAzOjEz4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gQEAgLTI4LDYgKzI4LDcgQEAgdTY0IF9fcmVhZF9tb3N0bHkg
c2hhZG93X2hvc3Rfd3JpdGFibGVfbWFzazsNCj4+IHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRvd19t
bXVfd3JpdGFibGVfbWFzazsNCj4+IHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRvd19ueF9tYXNrOw0K
Pj4gdTY0IF9fcmVhZF9tb3N0bHkgc2hhZG93X3hfbWFzazsgLyogbXV0dWFsIGV4Y2x1c2l2ZSB3
aXRoIG54X21hc2sgKi8NCj4+ICt1NjQgX19yZWFkX21vc3RseSBzaGFkb3dfdXhfbWFzazsNCj4+
IHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRvd191c2VyX21hc2s7DQo+PiB1NjQgX19yZWFkX21vc3Rs
eSBzaGFkb3dfYWNjZXNzZWRfbWFzazsNCj4+IHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRvd19kaXJ0
eV9tYXNrOw0KPj4gQEAgLTMxMyw4ICszMTQsMTQgQEAgdTY0IG1ha2VfaHVnZV9wYWdlX3NwbGl0
X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCB1NjQgaHVnZV9zcHRlLA0KPj4gKiB0aGUgcGFnZSBleGVj
dXRhYmxlIGFzIHRoZSBOWCBodWdlcGFnZSBtaXRpZ2F0aW9uIG5vIGxvbmdlcg0KPj4gKiBhcHBs
aWVzLg0KPj4gKi8NCj4+IC0gaWYgKChyb2xlLmFjY2VzcyAmIEFDQ19FWEVDX01BU0spICYmIGlz
X254X2h1Z2VfcGFnZV9lbmFibGVkKGt2bSkpDQo+PiArIGlmICgocm9sZS5hY2Nlc3MgJiBBQ0Nf
RVhFQ19NQVNLKSAmJiBpc19ueF9odWdlX3BhZ2VfZW5hYmxlZChrdm0pKSB7DQo+IA0KPiBUaGlz
IGlzIHdyb25nLCBhbmQgcHJvYmFibHkgc28gaXMgZXZlcnkgb3RoZXIgY2h1bmsgb2YgS1ZNIHRo
YXQgbG9va3MgYXQNCj4gQUNDX0VYRUNfTUFTSy4gIEUuZy4gaWYgYSBndWVzdCBodWdlcGFnZSBp
cyBleGVjdXRhYmxlIGZvciB1c2VyIGJ1dCBub3Qgc3VwZXJ2aXNvciwNCj4gS1ZNIHdpbGwgZmFp
bCB0byBtYWtlIHRoZSBzbWFsbCBjaGlsZCB1c2VyLWV4ZWN1dGFibGUuDQo+IA0KPiBUaGUgYnVn
IGluIG1ha2Vfc3B0ZSgpIGlzIGV2ZW4gd29yc2UsIGJlY2F1c2UgS1ZNIHdvdWxkIGxldCBhbiBN
QkVDLWF3YXJlIGd1ZXN0DQo+IHRyaWdnZXIgdGhlIGlUTEIgbXVsdGktaGl0ICNNQy4NCg0KQWNr
L2RvbmUgLSBJ4oCZdmUgdHVuZWQgdGhpcyB1cCBpbiB0aGUgdjEgc2VyaWVzLCB0aGFuayB5b3Ug
Zm9yIHRoZSBjYWxsIG91dC4gDQoNCj4+IGNoaWxkX3NwdGUgPSBtYWtlX3NwdGVfZXhlY3V0YWJs
ZShjaGlsZF9zcHRlKTsNCj4+ICsgLy8gVE9ETzogRm9yIExLTUw6IHN3aXRjaCB0byB2Y3B1LT5h
cmNoLnB0X2d1ZXN0X2V4ZWNfY29udHJvbD8gdXANCj4+ICsgLy8gZm9yIHN1Z2dlc3Rpb25zIG9u
IGhvdyBiZXN0IHRvIHRvZ2dsZSB0aGlzLg0KPiANCj4gTm8sIGl0IGJlbG9uZ3MgaW4gdGhlIHJv
bGUuDQoNClNvbGQhIEZpeGVkIGluIHYxDQoNCj4+ICsgaWYgKGVuYWJsZV9wdF9ndWVzdF9leGVj
X2NvbnRyb2wgJiYNCj4+ICsgICAgcm9sZS5hY2Nlc3MgJiBBQ0NfVVNFUl9FWEVDX01BU0spDQo+
PiArIGNoaWxkX3NwdGUgfD0gc2hhZG93X3V4X21hc2s7DQo+PiArIH0NCj4+IH0NCj4+IA0KPj4g
cmV0dXJuIGNoaWxkX3NwdGU7DQo+PiBAQCAtMzI2LDcgKzMzMyw3IEBAIHU2NCBtYWtlX25vbmxl
YWZfc3B0ZSh1NjQgKmNoaWxkX3B0LCBib29sIGFkX2Rpc2FibGVkKQ0KPj4gdTY0IHNwdGUgPSBT
UFRFX01NVV9QUkVTRU5UX01BU0s7DQo+PiANCj4+IHNwdGUgfD0gX19wYShjaGlsZF9wdCkgfCBz
aGFkb3dfcHJlc2VudF9tYXNrIHwgUFRfV1JJVEFCTEVfTUFTSyB8DQo+PiAtIHNoYWRvd191c2Vy
X21hc2sgfCBzaGFkb3dfeF9tYXNrIHwgc2hhZG93X21lX3ZhbHVlOw0KPj4gKyBzaGFkb3dfdXNl
cl9tYXNrIHwgc2hhZG93X3hfbWFzayB8IHNoYWRvd191eF9tYXNrIHwgc2hhZG93X21lX3ZhbHVl
Ow0KPj4gDQo+PiBpZiAoYWRfZGlzYWJsZWQpDQo+PiBzcHRlIHw9IFNQVEVfVERQX0FEX0RJU0FC
TEVEOw0KPj4gQEAgLTQyMCw3ICs0MjcsOCBAQCB2b2lkIGt2bV9tbXVfc2V0X21lX3NwdGVfbWFz
ayh1NjQgbWVfdmFsdWUsIHU2NCBtZV9tYXNrKQ0KPj4gfQ0KPj4gRVhQT1JUX1NZTUJPTF9HUEwo
a3ZtX21tdV9zZXRfbWVfc3B0ZV9tYXNrKTsNCj4+IA0KPj4gLXZvaWQga3ZtX21tdV9zZXRfZXB0
X21hc2tzKGJvb2wgaGFzX2FkX2JpdHMsIGJvb2wgaGFzX2V4ZWNfb25seSkNCj4+ICt2b2lkIGt2
bV9tbXVfc2V0X2VwdF9tYXNrcyhib29sIGhhc19hZF9iaXRzLCBib29sIGhhc19leGVjX29ubHks
DQo+PiArICAgYm9vbCBoYXNfZ3Vlc3RfZXhlY19jdHJsKQ0KPj4gew0KPj4gc2hhZG93X3VzZXJf
bWFzayA9IFZNWF9FUFRfUkVBREFCTEVfTUFTSzsNCj4+IHNoYWRvd19hY2Nlc3NlZF9tYXNrID0g
aGFzX2FkX2JpdHMgPyBWTVhfRVBUX0FDQ0VTU19CSVQgOiAwdWxsOw0KPj4gQEAgLTQyOCw4ICs0
MzYsMTQgQEAgdm9pZCBrdm1fbW11X3NldF9lcHRfbWFza3MoYm9vbCBoYXNfYWRfYml0cywgYm9v
bCBoYXNfZXhlY19vbmx5KQ0KPj4gc2hhZG93X254X21hc2sgPSAwdWxsOw0KPj4gc2hhZG93X3hf
bWFzayA9IFZNWF9FUFRfRVhFQ1VUQUJMRV9NQVNLOw0KPj4gLyogVk1YX0VQVF9TVVBQUkVTU19W
RV9CSVQgaXMgbmVlZGVkIGZvciBXIG9yIFggdmlvbGF0aW9uLiAqLw0KPj4gKyAvLyBGb3IgTEtN
TCBSZXZpZXc6DQo+PiArIC8vIERvIHdlIG5lZWQgdG8gbW9kaWZ5IHNoYWRvd19wcmVzZW50X21h
c2sgaW4gdGhlIE1CRUMgY2FzZT8NCj4gDQo+IE5vLCBiZWNhdXNlIE1CRUMgYmlmdXJjYXRlcyBY
LCBpdCBkb2Vzbid0IGNoYW5nZSB3aGV0aGVyIG9yIG5vdCBhbiBFUFRFIGNhbiBiZQ0KPiBYIHdp
dGhvdXQgYmVpbmcgUi4gIEZyb20gdGhlIFNETToNCj4gDQo+ICAxLiBJZiB0aGUg4oCcbW9kZS1i
YXNlZCBleGVjdXRlIGNvbnRyb2wgZm9yIEVQVOKAnSBWTS1leGVjdXRpb24gY29udHJvbCBpcyAx
LA0KPiAgICAgc2V0dGluZyBiaXQgMCBpbmRpY2F0ZXMgYWxzbyB0aGF0IHNvZnR3YXJlIG1heSBh
bHNvIGNvbmZpZ3VyZSBFUFQNCj4gICAgIHBhZ2luZy1zdHJ1Y3R1cmUgZW50cmllcyBpbiB3aGlj
aCBiaXRzIDE6MCBhcmUgYm90aCBjbGVhciBhbmQgaW4gd2hpY2ggYml0IDEwDQo+ICAgICBpcyBz
ZXQgKGluZGljYXRpbmcgYSB0cmFuc2xhdGlvbiB0aGF0IGNhbiBiZSB1c2VkIHRvIGZldGNoIGlu
c3RydWN0aW9ucyBmcm9tIGENCj4gICAgIHN1cGVydmlzb3ItbW9kZSBsaW5lYXIgYWRkcmVzcyBv
ciBhIHVzZXItbW9kZSBsaW5lYXIgYWRkcmVzcykuDQoNCkdvdGNoYSwgaW50ZWdyYXRlZCBpbiB2
MQ0KDQo+PiBzaGFkb3dfcHJlc2VudF9tYXNrID0NCj4+IChoYXNfZXhlY19vbmx5ID8gMHVsbCA6
IFZNWF9FUFRfUkVBREFCTEVfTUFTSykgfCBWTVhfRVBUX1NVUFBSRVNTX1ZFX0JJVDsNCj4+ICsN
Cj4+ICsgc2hhZG93X3V4X21hc2sgPQ0KPj4gKyBoYXNfZ3Vlc3RfZXhlY19jdHJsID8gVk1YX0VQ
VF9VU0VSX0VYRUNVVEFCTEVfTUFTSyA6IDB1bGw7DQo+IA0KPiBUaGlzIGlzIEVQVCBzcGVjaWZp
YyBjb2RlLCBqdXN0IGNhbGwgdGhpcyB3aGF0IGl0IGlzOg0KPiANCj4gc2hhZG93X3V4X21hc2sg
PSBoYXNfbWJlYyA/IFZNWF9FUFRfVVNFUl9FWEVDVVRBQkxFX01BU0sgOiAwdWxsOw0KDQpUaGFu
a3MgZm9yIHRoZSBjb2RlIHN1Z2dlc3Rpb24sIEnigJl2ZSB1c2VkIHRoaXMgaW4gdjEuDQoNCj4+
ICsNCj4+IC8qDQo+PiAqIEVQVCBvdmVycmlkZXMgdGhlIGhvc3QgTVRSUnMsIGFuZCBzbyBLVk0g
bXVzdCBwcm9ncmFtIHRoZSBkZXNpcmVkDQo+PiAqIG1lbXR5cGUgZGlyZWN0bHkgaW50byB0aGUg
U1BURXMuICBOb3RlLCB0aGlzIG1hc2sgaXMganVzdCB0aGUgbWFzaw0KPj4gQEAgLTQ4NCw2ICs0
OTgsNyBAQCB2b2lkIGt2bV9tbXVfcmVzZXRfYWxsX3B0ZV9tYXNrcyh2b2lkKQ0KPj4gc2hhZG93
X2RpcnR5X21hc2sgPSBQVF9ESVJUWV9NQVNLOw0KPj4gc2hhZG93X254X21hc2sgPSBQVDY0X05Y
X01BU0s7DQo+PiBzaGFkb3dfeF9tYXNrID0gMDsNCj4+ICsgc2hhZG93X3V4X21hc2sgPSAwOw0K
Pj4gc2hhZG93X3ByZXNlbnRfbWFzayA9IFBUX1BSRVNFTlRfTUFTSzsNCj4+IA0KPj4gLyoNCj4+
IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaCBiL2FyY2gveDg2L2t2bS9tbXUv
c3B0ZS5oDQo+PiBpbmRleCBkOWUyMjEzM2I2ZDAuLmRjMmYwZGM5YzQ2ZSAxMDA2NDQNCj4+IC0t
LSBhL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3Nw
dGUuaA0KPj4gQEAgLTE3MSw2ICsxNzEsNyBAQCBleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hh
ZG93X21tdV93cml0YWJsZV9tYXNrOw0KPj4gZXh0ZXJuIHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRv
d19ueF9tYXNrOw0KPj4gZXh0ZXJuIHU2NCBfX3JlYWRfbW9zdGx5IHNoYWRvd194X21hc2s7IC8q
IG11dHVhbCBleGNsdXNpdmUgd2l0aCBueF9tYXNrICovDQo+PiBleHRlcm4gdTY0IF9fcmVhZF9t
b3N0bHkgc2hhZG93X3VzZXJfbWFzazsNCj4+ICtleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hh
ZG93X3V4X21hc2s7DQo+PiBleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hhZG93X2FjY2Vzc2Vk
X21hc2s7DQo+PiBleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hhZG93X2RpcnR5X21hc2s7DQo+
PiBleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hhZG93X21taW9fdmFsdWU7DQo+PiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4+
IGluZGV4IDBhYWRmYTkyNDA0NS4uZDE2ZTNmMTcwMjU4IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94
ODYva3ZtL3ZteC92bXguYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gQEAg
LTg1NDQsNyArODU0NCw4IEBAIF9faW5pdCBpbnQgdm14X2hhcmR3YXJlX3NldHVwKHZvaWQpDQo+
PiANCj4+IGlmIChlbmFibGVfZXB0KQ0KPj4ga3ZtX21tdV9zZXRfZXB0X21hc2tzKGVuYWJsZV9l
cHRfYWRfYml0cywNCj4+IC0gICAgICBjcHVfaGFzX3ZteF9lcHRfZXhlY3V0ZV9vbmx5KCkpOw0K
Pj4gKyAgICAgIGNwdV9oYXNfdm14X2VwdF9leGVjdXRlX29ubHkoKSwNCj4+ICsgICAgICBlbmFi
bGVfcHRfZ3Vlc3RfZXhlY19jb250cm9sKTsNCj4gDQo+IFdpdGhvdXQgdGhlIG1vZHVsZSBwYXJh
bSwganVzdCBjcHVfaGFzX3ZteF9tYmVjKCkuDQoNClNvbGQhIFRob3VnaCwgSeKAmXZlIGNoYW5n
ZWQgdGhpcyB0byBjcHVfaGFzX3ZteF9tb2RlX2Jhc2VkX2VwdF9leGVjKCkgaW4gdjEuDQoNCg==

