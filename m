Return-Path: <kvm+bounces-18543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DC18D670D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 18:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18ACE288797
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6024C15D5AA;
	Fri, 31 May 2024 16:42:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5E158D85
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717173734; cv=fail; b=lP4ARPau20rXR6AQU31NhY6xWoHpirO2GNP6LF1nNyTAc2R4d0e0jphubpwM4tsyoCuTz6+3mV1FNG69OzxOVkxugaSyUnfYFfV3gJvKHNxoPEPbQh3PLh/fopeBpp0zkLRc1DYPf+87aWg9siev0RzmR4K1FG/XRZ1YBjr2n48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717173734; c=relaxed/simple;
	bh=rGPEzIp3GZ1wy2edZu+y0mc2Vk1qReDUPXbqi5lINqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=grtkCZklV/O4h1pqJwg0R87e7luy9JbZYmBoqHlAyD/ilLg6d99P/ve0LFMiLkkzIyVLfAV4Bk7GiE92HPgS19f2/Q6/m+odh52Zm0OuLyi9GAFWq85BR3RFTdQmR6BVLBAUIrWIwiWRAx8XY20YdAz2xnkOehwCTQ++gfqCmuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9T2GV019200;
	Fri, 31 May 2024 16:42:01 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DrGPEzIp3GZ1wy2edZu+y0mc2Vk1qReDUPXbqi5?=
 =?UTF-8?Q?lINqw=3D;_b=3DcHC1D0QBYflztZHAi1lDVovQeyXIfgLPNPnh4ChZ7jA++lZKK?=
 =?UTF-8?Q?hc1q+orMofQCGBuv4PC_IOio+CzN3hNsRXCz0nnTPx17vY6mgXMTgGvvdsJWMkm?=
 =?UTF-8?Q?TUplfETu/mpDR7mEJFPxumwRh_NhHrNOqKhrtSy5LYIqWdcNuVLvc7aTZRQo+kH?=
 =?UTF-8?Q?T2Xaaw4yigLc4Ugvy+x5svEcKkfBmEt_VAXZiKPyx9rcCndQDSUJsUPY/cpSJ/G?=
 =?UTF-8?Q?J0r2LBwqAGFKPeW64ngELn4lop0WQdUS/GekI_CI8g6wKI3F1qSVn7FVzRtFmF0?=
 =?UTF-8?Q?qFPmuZ1oJxYrmtL/ah0VfQF+OILFMvXakWMbFjzsxMq_Yg=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8fckku7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 16:42:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VFBavf026646;
	Fri, 31 May 2024 16:41:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50a3kcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 16:41:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl8CTXl9qtB0tzdy049P2Pg/CQ4J38HlM9KNdoSsm5JlbT0iU6+bzO2grrSPceOLdloxdUEoLfWBkSvm/9EKWGbR2WB+TnOo8eU4UufK2ln70LfbhW4R5Fvaav7KTM0ShfR+qINxHknng13n7NlCjumRbGy6AP61McDYrMapcCqmg3ng+5e7n1i9vK2pT8dYdr1yuJ7t6zfnEHJU1f7u5bv7drtsHTsYT2/rEYtpOc4XXvKoOu7UYaLCEeLeLCdkTtpDic5jpltNP8HI8aunCrkph5SxI1hUhP3azKcko1aHKKFWPhfl6jj6OaP6ruoEz+LLJDI77wri6681BuUYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGPEzIp3GZ1wy2edZu+y0mc2Vk1qReDUPXbqi5lINqw=;
 b=EnQ5zDBWe7GsOOaiLsjOtJ2EtIqzQpG+daligp9QzknEDoR33NCMT4sr8gXs4d0bgGx88Jx9KUc7qCnGYl7ys7D0aEfvnGR9YIgdA6fqzePFe/aSBpAr9DbWdpQz3t8uH69di6LWnOXEm7Y+zZQ6B3GitD3pAIQGzDeAZEyJ9GxeQMFM6ioCf6vqRzcdV6rsQql7RbbbhUvkgqluOpBrb2ykjAIbrgrVobIhok/0RvZCAyK3fbDU0sqO+4nMU4pU9azB9iFBTrYELbXYW1JDtS7+jR5NMlq250Lk0k22ajGxHEcC1ZOpXDuXUfMZnRIFTLZ9rBfx3YG6d3JqfsyHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGPEzIp3GZ1wy2edZu+y0mc2Vk1qReDUPXbqi5lINqw=;
 b=zwWn0mbCuqaOsYvSpTgaM8CClUyiVD05Ip9P35TotC+GyuoFHxyAq4fjv7Vc4Sh986Ba/Sf785WAc0N24q62QfJaW8s8CntkMDUxqw/94yh2vODMq31X5ZNjMkF5GBfBeZBIrlzB0oQfXvgz8YEHeS8CTMPlc5y7jiEMaAUhrwI=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DS0PR10MB6200.namprd10.prod.outlook.com (2603:10b6:8:c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 16:41:56 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 16:41:56 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Pankaj Gupta <pankaj.gupta@amd.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>,
        "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "anisinha@redhat.com"
	<anisinha@redhat.com>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
Thread-Topic: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
Thread-Index: AQHasoMyQ2Ldv26sZE+HkIhGzAbDT7GxhUOA///3xICAACBAgA==
Date: Fri, 31 May 2024 16:41:56 +0000
Message-ID: <ca90dbb2-7b88-4aba-a6a1-2a81ccc855c8@oracle.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-19-pankaj.gupta@amd.com>
 <792b99d5-9d18-42f4-a9f4-5621e2ae6a70@oracle.com>
 <CABgObfbHvj_GiX-+E3zhLfrrw7S02-VcE0sEmj_nfuXWnwmrhQ@mail.gmail.com>
In-Reply-To: 
 <CABgObfbHvj_GiX-+E3zhLfrrw7S02-VcE0sEmj_nfuXWnwmrhQ@mail.gmail.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7633.017)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|DS0PR10MB6200:EE_
x-ms-office365-filtering-correlation-id: 3c4763a4-2a65-4719-015c-08dc819095d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|376005|366007|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?WUJOUDZpd3dRR2VTaTIyVld1TDZaaW9mZW1rWmpDVXc2UHdXN3lIUktZcWZo?=
 =?utf-8?B?QU1icnZWRFB4OTlmbHg0L2E0NG5sQmVsbUNRUlo4YVdwejA1Q052dkpwUHpU?=
 =?utf-8?B?MVZGd3MyUnluYkFlM0ZTd3FCaFR6dTFEU2VhZzZMMGhzZWdnZ0dyaUVrbkdi?=
 =?utf-8?B?M3VjUXdUejlTeEk4d3YvTjFQN0tBcGRSZ2ppeEZxRnFMTW41L2JZNFI2OHJm?=
 =?utf-8?B?SFgxSEV6Vmc4amdDa0tJVEV5Lzc3K1ZoV2djUHNsd0tESGNZbHNBZ3ZWc1FC?=
 =?utf-8?B?bEVJRjdPUm9kaFl3NGRPbnA3cFJVQWVwQUlHS1NYaFc0OE1TdmZPS29sY3I3?=
 =?utf-8?B?QVJlQk9iei9kamhRZ1d2anFnWXlBNEdNRkFhVnMrL09QRDNqOFV1YVNOMzVX?=
 =?utf-8?B?L0VxU3VmSWRyNHB5UzFNYTc1NmVuWU5sdEZhOTRtbHZoeEhzbmtnTGtUc2gz?=
 =?utf-8?B?enBOOW45eVg1QTdwUFFFSVFjQzE1MzNCVEZ1V1VOQjBoeXZQYzJHU1pMMUhh?=
 =?utf-8?B?YmJPWk41eE1EajlWbkErL1hlRlNXWkorK0F4b1RHUTJTN0N1Nm9lQllQRXpS?=
 =?utf-8?B?ZW51WE5tODhlUzMwL1FRQkxDRFdYb1E1aUdTendwOWhpY1B2SHloLzVhdU84?=
 =?utf-8?B?bWJlemdqUTlMU1JYODFGeExnZzVNSzkrNWIyTytZRzg0VHNMMnJLSUlZeXZ5?=
 =?utf-8?B?WS82NTk2UWNrZWtzbi9NM2JNaDYxWlB0L3RIY01SQnVkTmg1S1V3TTB5UGp4?=
 =?utf-8?B?S1NzY2w5VDdkaWU5Tnp4NThYNVlLWTBXVFVrTmtMNzE4UCtlZFpkZ3lBc1Vs?=
 =?utf-8?B?enduZHBZQ1JQTjF2cUZGbFZpUlUyVXJjbG5yd0l2VTlwcUtRUVMybmxJaWli?=
 =?utf-8?B?VkZVbWdNTHNka2luR2tvamZDb0VmUHkxa0JiN0poQlM3REZaV281bUVaRTJ5?=
 =?utf-8?B?TWNHQVZkT0ZPeHV1bnNWaXVmK2pFZVozczVKT0FvNytFMVpoeWNreDBXeC8w?=
 =?utf-8?B?dlJ4OTFqRDhTZEpIWWxKUW5VMkVrZDEvZHBjL0YwUE1xMkdXMU5BNThlZkxa?=
 =?utf-8?B?WVlWRlVXV1RyYktEVm1CRit3SGJuVmxRN2d5bDA2VVU4aUNmNmtXWWlKalVp?=
 =?utf-8?B?NFp1dzh3R3AyYnE3anE0bFN5MnFGLzZPc3ZRVCs4WE9XdlEwSjBrSkc0MzFn?=
 =?utf-8?B?cy9uVFRodUNUMUs5a05kM0pPWDA4akd5b21QdWt5WDZlV213cWNVak0rdWpR?=
 =?utf-8?B?Mmp0OWNHN2t3ZFY2UlBDa1JXb3lPTkpJa3J0SjkwbzkyTGpBN3hKT2NaTVc4?=
 =?utf-8?B?bGRPbndsWFZhbEcrTldzL1h2dmZ4R0NiUnhGTE0vaEVOWTQ0ZmtsQTJaVUQy?=
 =?utf-8?B?Y3Zla2VBL3YycC9HSEc1TTlmSGRzSmxkZ1MrTEtUbWhoQis2TlJOT0lLSDZS?=
 =?utf-8?B?MVlJRFJaaytpdUo2UmM2cEdnb0N4TVRWVmFvUDY2MkR0dXRIODRWMGVmOU82?=
 =?utf-8?B?Sk5zMHJkVDc4WWxYOTgvTWJhYkZmamplNkwza3hDM012KzVxTHVuUjlrUnZ4?=
 =?utf-8?B?MS91UFRXejl5RlNKVzdQK1RmcnBIMWoydURXdXJBMTlQSjlFSm9lNkhzaEYw?=
 =?utf-8?B?bFNXa2ZtOVBveS93aENUanljWkZlR21jUFg0aDVVTFdNNjRyWXM5bFFSNklM?=
 =?utf-8?B?QnBTN0h5REd4NnJhS0xsWm9RNGpOeW10OEgwOUhMSnl3Z214bTBXUHpzMUN1?=
 =?utf-8?B?eFgzVy9xRnAxejRrajI2cHlDbTdKa0ljSzlSYytwckcwVEJFVEdkb2NrR2x5?=
 =?utf-8?B?NWkvT0ZwRDR4WDJsOVB2QT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UVFNdzB4cW9uaFduSU5EYlIrcVExMm5Hem8yQmpmSitVSzQwSjZmYVBUeHJp?=
 =?utf-8?B?eVVxUFhOQmpCS0NBeTNaZ2VVV0p1UXlWWlB0VHNmd1pNY21QbWU3dHYzZXVv?=
 =?utf-8?B?cWJ1ZU9ISVhFQjhQWTQvekV0WXlKUzBQckI1QklvaFpESTRkN2FRc1ZpR0RS?=
 =?utf-8?B?bldsU0hSOGcvVlU4UXB0VTQ0TVVhS0U1UkMwVWhFcU95T0lPaXprNWVqcmF1?=
 =?utf-8?B?OFFJNUR0Y05JUWZ6RlgxVVY5MlBmaVYxaDhoanhTQ1FPUFlEbFo5c3JxaXlv?=
 =?utf-8?B?TUxxOGVGcEw4YmJkVmFwbVZROU9QbEcyc24vbnd5Ykt0NGJvTCtVdDQ1KzJQ?=
 =?utf-8?B?Szd3VW8vNW5uaGxtQ1J0WXJ1cHBoTWw4WFB5SWZHZXdZTFl5cmhlTUNhOFdI?=
 =?utf-8?B?MTdSTWpmQkZsOTBBNjF4ZjUwellEOTlFdjhEYW1xQU9YUWxGNHA5VTdTaFU4?=
 =?utf-8?B?QWtqQzZPQzMxcE42cUpucm41S3lnc1VaNlpjZHdhM3hTY3hJVTk4SWZYQUNG?=
 =?utf-8?B?cDRlbGRvTER4eWVWc09PQnA4R2RybnJVUG5GNUN1SFVIazAwZlliSnF2eG8z?=
 =?utf-8?B?dUk0VVc4ckYvRkFyblY2dVR5U01sS3lialcvZTVjYmJQYS80WWpXRldGUTVQ?=
 =?utf-8?B?SmcrRnBESVE4NGNnNWNZZ3ZNbjF4aC9LRnVyekFlQXZLcW1NNWhuaVJhNEJ6?=
 =?utf-8?B?SEZJZ1p2Yk13WjVubjcyR0VwWWR0aEFvZ2t4cnRMVlN3M3poRnFzZ1RNTlpE?=
 =?utf-8?B?RGtDNGtlcUVYandyamV0WkhiVVBlRmRLVW9hb1paS0xlb1l3WXZMNXRsTElH?=
 =?utf-8?B?dEpGVG1STjM5RjMyeWRqL3FrN2l4MFhLUS9QUDBjbk1WUFN4MjBETW96cnh2?=
 =?utf-8?B?Y215eHpCT1cyWmhvcnFMZ3BqVHBleUdvNVVUY1M5dURtU0J1Y01wVmRPL2sy?=
 =?utf-8?B?WXhJZm9kTmlWT21tQmlLQWJNZS9Pb3RxRElnOS9FSHpWaEtXanhoNTlkRnhh?=
 =?utf-8?B?VG1NRy9KRWd2NklOL25BTnp4M0JFbHBzZlZxWHM1Vlo4NHFxNGMzd0hVcFY2?=
 =?utf-8?B?NFlma1hzQ284OXd5c3ByUjV6SURkYm0vYVdkdFRRekdBLzZrRjRlTkdmTGs2?=
 =?utf-8?B?T0dEbGl1SWlpZ3dFUlUvSThBYUpld1BzUmV2SEtDVlV0dmNuenBMUktqSmFK?=
 =?utf-8?B?U0paYTlwcnhrTEpnOGFxb0FVMVZMZFNUQStpOEJJcVRnemFxdWU0UUhRU2JJ?=
 =?utf-8?B?ZUpvQkZneVpOMGp1eW1SMmY5U2hMeGo2bTZESUloanFqaUdGcTJqdDlLaU9B?=
 =?utf-8?B?K1dsa2c2L0tUODJGOVRJbVBuNWFFcjAxSmh2MForajdpL3NWVmYxbkl0WHV3?=
 =?utf-8?B?VU9xRzc5N2tTMGxmRjBMTVk5WGpoUlZ1aDBISVBmRkwxeENKelBub2NwSTdy?=
 =?utf-8?B?b2F1bS9SYThkZUdCQ0Z2elJLZVB5cTNldlNYd1pTL2ozWkJJU1piV3BleFFz?=
 =?utf-8?B?eElLQ3ZEL2RRWjZmdzZGc0dYRUsydXlrZzZOZDZ3L3RWOGZYTU5VWFhnSk5m?=
 =?utf-8?B?M0FEaXlaVHBSMjdzTFFKUjFvdEFqR29EYjdIQ0pmbk1xTUhPZVdZT0orS0NT?=
 =?utf-8?B?ZWR6U1pEV3BQdG1FY0ZCQ0VRNTR1Rmp0K0Q4eXd2YmFwcUhncVUxaENVUUhr?=
 =?utf-8?B?SnJvdEdNcVFBY0dORVRmK2ZTVWwyeXpMMXpMSTlFRzV0VFBFbDBtOGl6d2V1?=
 =?utf-8?B?NlJRMElUNnZTOVIvV2RNZTJ2MnZvanFRWUdINU9ua0JvSmk3NnBmYnduaEN2?=
 =?utf-8?B?NmZaYjZzai9LRC9odm1vQ1U1TllhMVp5T05YaTJPa2g4cUExcmlUTGxGeTRZ?=
 =?utf-8?B?enh4dnlGUHFLQkVvVDJ3T2Q5OXpwWVJNcWRMUmJENi9DK1RUbjk0WUViRzgr?=
 =?utf-8?B?NWN3STRFVlg1NWUzYkh1VTVML1h5K2V5T1pGYTFIK0tObjJWcld5MlkydTdB?=
 =?utf-8?B?YmZISnNRMFlpeTVsRmRUV0ZSZTFMeHVPVURwU3U2UDR3bVh1MW8wRXNKczR3?=
 =?utf-8?B?R3JpNEVSMThsUkVlb1JIcVdnZ1NuOGJ6ZW9vS0x5VXNnckJrc3lCclVsK3ZF?=
 =?utf-8?B?SFZscVk1ZTQrMEVaNDQvR3dHdEExYk1ucUZsdUdhRGxDUmovdUc0TnJuL0Mr?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DAD48FEF1B2CC4388EE7B7DF1EAAD45@oracle.onmicrosoft.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qRmU61j7v9r7fhUNOZejeAoPzY8g1VwppaoSUPgLaxqjU2+JRz6tKFcTJcCgYPLmwYNpnaRBTcNJLXnHTdIHbVoHvrncynNqXgGRzIsmOpL8dvYu4K2XqNSXJdtFOicx0u5TgLww4GikbbKhHmYnyEjukB4CyrIw9Hl/DG0NCOZK1BvBYT1djl/Sg1ke6bwK2rGuH5EbIDZAfLUc6zMepkhXHCuC5k74xeMKnnMKGWwnnf4NvmpenGVGxqtD8RyatsJCTh38FtIr/FsxA3MgcjgR7SIU/Mo0jDOKXQGKeHu0rDce+atVVljAMM/JqpfrNHUXstLrcJ1Hb11XZ9c7c487AqpvbLsqXFYGM6XH7y0j/yS59RchYCvfvQO/bN022iHexXTu7SJmegIx8R0mi1RNRj5Ky7FUm4WJSYGAenZdrEjh0odzRMxcNrKDUL3iDmRnoym0AltLBnWjpZ+6dY/T5T65gv4AwenpcZK9g7HOYdBCd8pyCSgNzThLN0MUYPg1fTEPqPxcHtt6k0e5CW27el9BYJxzQa42F56H3QYDn4LKKx6pduse6+DxosmbWOGOmRbgy1g9VTnr00lmRKia5hqjYmds7yxtd3RUUVQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4763a4-2a65-4719-015c-08dc819095d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 16:41:56.8542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S8EI+TDsIPECGMlaJBGX3WZBuNi0PtkX99nSXH2JZekkCcGkT7KwAmcZkhKAKkaKIQUraFgHe24302XFJpgTOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310126
X-Proofpoint-GUID: gER15pPQyYApdQh18xTvFS8XOm7V7kZK
X-Proofpoint-ORIG-GUID: gER15pPQyYApdQh18xTvFS8XOm7V7kZK

T24gMzEvMDUvMjAyNCAxNjo0MSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiBGcmksIE1heSAz
MSwgMjAyNCBhdCA1OjIw4oCvUE0gTGlhbSBNZXJ3aWNrIDxsaWFtLm1lcndpY2tAb3JhY2xlLmNv
bT4gd3JvdGU6Cj4+PiArICAgIG1ldGFkYXRhID0gKE92bWZTZXZNZXRhZGF0YSAqKShmbGFzaF9w
dHIgKyBmbGFzaF9zaXplIC0gZGF0YS0+b2Zmc2V0KTsKPj4+ICsgICAgaWYgKG1lbWNtcChtZXRh
ZGF0YS0+c2lnbmF0dXJlLCAiQVNFViIsIDQpICE9IDApIHsKPj4+ICsgICAgICAgIHJldHVybjsK
Pj4+ICsgICAgfQo+Pj4gKwo+Pj4gKyAgICBvdm1mX3Nldl9tZXRhZGF0YV90YWJsZSA9IGdfbWFs
bG9jKG1ldGFkYXRhLT5sZW4pOwo+Pgo+PiBUaGVyZSBzaG91bGQgYmUgYSBib3VuZHMgY2hlY2sg
b24gbWV0YWRhdGEtPmxlbiBiZWZvcmUgdXNpbmcgaXQuCj4gCj4gWW91IG1lYW4gbGlrZToKPiAK
PiAgICAgIGlmIChtZXRhZGF0YS0+bGVuIDw9IGZsYXNoX3NpemUgLSBkYXRhLT5vZmZzZXQpIHsK
PiAgICAgICAgICBvdm1mX3Nldl9tZXRhZGF0YV90YWJsZSA9IGdfbWVtZHVwMihtZXRhZGF0YSwg
bWV0YWRhdGEtPmxlbik7Cj4gICAgICB9Cj4gCgpZZWFoLCBhbmQgbWF5YmUgYmVmb3JlIHRoYXQK
CmlmIChtZXRhZGF0YS0+bGVuIDwgc2l6ZW9mKE92bWZTZXZNZXRhZGF0YSkpCiAgICAgIHJldHVy
bgoKQnV0IHRoZSBtYWluIHRoaW5nIHdvdWxkIGJlIGNoZWNraW5nIHRoZSB1cHBlciBib3VuZCB0
byBhdm9pZAphbGxvY2F0aW5nIGEgaHVnZSBhbW91bnQgb2YgbWVtb3J5IAoKUmVnYXJkcywKTGlh
bQoK

