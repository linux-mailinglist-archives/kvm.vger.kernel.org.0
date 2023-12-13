Return-Path: <kvm+bounces-4299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C66810B79
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 391651F21A34
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3BB199B8;
	Wed, 13 Dec 2023 07:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQUrbaEm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I394bie1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFFABD;
	Tue, 12 Dec 2023 23:28:33 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BD7EQrV018645;
	Wed, 13 Dec 2023 07:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=i+XeEz9zyPH79jNPD6LH/uHo/idMzyBG+XclEJEBz5k=;
 b=SQUrbaEm+hL2Qe63K5ZACLRczd8smpeJfR2Fbub0lkbPuVLgwEJiqi9EfyAPzzHWLBln
 KY+SSVl9tS/K7XPkST+0rQmoipiX+UHSxuMLKz2i+96VS6CJs09SzIus69c/1J5SeI/7
 x9HG+VSca+hgIUyP/aXz3KHunJnq0GvQYiiUwpshGSaxfgX1LeHJfZgHGdlNC9ev/E/y
 /lh/xwXKmwrVySyAw88Hm68OPxi2AqCmQc2VJsXiTxfbuSkr933vSjm25CkeiJcheCcL
 t8PxH/m/OE9B1zTph05ws/MkjRpSbmJVAf6OPSj7WWxaKcEAVO9UU+XL0x+AaQO9nzT2 /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvfuu7hfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 07:28:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BD76pKk012828;
	Wed, 13 Dec 2023 07:28:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep7ttt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 07:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYYxFUXw09ZSnldPpN1mnPWwYnAV76NbA+OtOvV2FC3N1SZAdLwRIBH+CtK76sLBN3AqpJWzIIelNM4N2DV6zqTWju8Ij2fge1xH/ifrrGn3XEqGKeQgJVpMP5Iss5UvtTGljL1sYRL0omcCPzdHG9ADSuEBtfeQUUKElX49tI5BT8p/9PUDSacDGihpyq3Ir9jCSLP9BJIpQESbaTI+WREn91z5gutyxgdfyNTiKhbpf+xkhvIrpzobcboT2luLgQL1jeWQWVjrPUSZPRsKv1y3ur6W+9cMU4UINPmIKN5s4Uw7/aDDjxYPKIG2jY09EdJd32Z/0Kq9KV7GDg9Oag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+XeEz9zyPH79jNPD6LH/uHo/idMzyBG+XclEJEBz5k=;
 b=ZyUO4V5rSz47D2iWzs/ttTmsabdSUCcrSyy0zyQX96QUqVGzGNV4Vm775J+VHyAQqvHZSLlbLV2QUe5MIWCdCdeVD4BGc2lwzQcxjqB0QSSSANErVZRd8VXoCcl+fS6kZLem5nB6KGMKfkP/F7Hsx0oxfYqBjFca2y9cNZHkW+iUuKTbFNeGDrxP9jTwOftjdl89HI60XUPERFX6eJUcZYGQfiGrd+B9oQUzk9yZky6kP2PdtmAkhkAKStazHOqLrWuRXzLqs19HNiZH1hAaKihCCE9IcxjyUAn5neSbYZcOoURVbC5UkM3u4RQBQacrPmZIs55SZdfPSetuU458BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+XeEz9zyPH79jNPD6LH/uHo/idMzyBG+XclEJEBz5k=;
 b=I394bie1DdfssjSFnwjnora6ccM3xqazDqoejoqDRZPISGvKt1ZdqT/XWVSxKEJ//KpmiNzGjgURYb68RZyhcd4JL8SxhACtbvirP+cMp761Bdn0ZDoNWp09KL8t3SMtlFwsjka/FW0AmeaOLc4h1SB53qQdYN8pgx/LDnAtUWI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6659.namprd10.prod.outlook.com (2603:10b6:930:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Wed, 13 Dec
 2023 07:28:15 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 07:28:15 +0000
Message-ID: <6d3417f7-062e-9934-01ab-20e3a46656a7@oracle.com>
Date: Tue, 12 Dec 2023 23:28:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20231206032054.55070-1-likexu@tencent.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20231206032054.55070-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR15CA0140.namprd15.prod.outlook.com
 (2603:10b6:930:67::10) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6659:EE_
X-MS-Office365-Filtering-Correlation-Id: f42fb6c6-3753-4530-598f-08dbfbad1210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dnX3stR+fhsMeRmydElrtXRweYM1dVS3Muj/RGN7WGi8K3XgM0HmZ+kY/X34tId7auCWlnDMy/WSYE3TTFPfeh9uR/BPoAS2bkJCXu8zhS9Wxv4P4N2hEN8GtjJaL5oioIDXR2RFi6RrED0yQjtCdZTpAkxFqD31YMYGs+77TqWRuvG7LRa0f6g3So9802lpDp7sv60/jJmcX5PaCkCBZ5dXhx+3qeXS3V2qvj1ruqwQnG1nLoXiEIhNR8kXPNqMtwWg+gwTkm96hlg9EJlYfaN4qPi+y9KD2x890UZhW4gqi5XGIG1m4hdEfvz6IILQNTcGJzilbZ5SmuJ1gSJ/an/aZsqdu7cf309I+ZnAQ+w8hwlj4tbGrGUiyiVaAogeFabdbW0rpAzRRvWE3YTZ4H7tUS+2JEYKNUy3eBX7nTdCHtNoU38exRGiUVid2KE1syVOcqOUiqQ3Er0QTagtrH7BJDXY9Ilua1olX9b2/hse45Z9dGxfAZbaHQaMbfU0i6SWck9ghirKc9xV6dFHzm+7+SLxESNWjjwBTFS2ODEZKGiidDVjufFxhQ5xmsKs62ZDjRQ+/1Rwyuw6KSI/wJ/lw8VUJwlFC4Lo+BkMqaYnMt+tkqMx9MUerO2KZOd8hHlgi9WFYXFCUhTM8HbRnDlWo5X8Zjk26lm7kiFKdvk4I0piTsaozkslPhRyBaih
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(346002)(366004)(230922051799003)(230273577357003)(230173577357003)(186009)(1800799012)(451199024)(64100799003)(53546011)(6486002)(478600001)(2616005)(26005)(6512007)(6506007)(966005)(4326008)(83380400001)(44832011)(5660300002)(2906002)(8676002)(54906003)(66556008)(6916009)(66476007)(66946007)(41300700001)(316002)(8936002)(38100700002)(31696002)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bllEc252eU16RXhCUlRpckVodW84MXErU2RHVmRYS1FVeTBNQjV1eHFhVXY0?=
 =?utf-8?B?ZW12QnZKZ0ZIdkRDdyszdHorN3JhdUI3ZU5XU3NaSTBGeUxMNU9iMXdHd1BW?=
 =?utf-8?B?dDU5MzJxRXArVnp0SjZNTngrNlhkT3Z0TlZabFJwTzFmQTN0VXZhSVFKbk5m?=
 =?utf-8?B?ZWRIK1ErNE1CUVNEN2NJcEloRG1TQXIycUNxUmFZenpxYlFDRXhURzczVFZI?=
 =?utf-8?B?N0xoVTZJWU0xQmViNlFWYnhISUJqY29xRzdnVDBCZFVhMVpJTER5RGVFVDdG?=
 =?utf-8?B?akpWUmRLYmpTV2hraXhKSnF6alI5dkNZQU54NE1iaUNRN2w2RzdISFZGTWpK?=
 =?utf-8?B?WkNLb0h2c2puT0hpd094UFJxTXpWUncyZDY2OUhxcnJZR3ROUmZvRE50MVRi?=
 =?utf-8?B?SU9MaHhWWFlDbVh3cTNGQmpnQXFSOFdET3Vmd2VpWDhNR0lLV2ExUHc0Vlpk?=
 =?utf-8?B?WFlQZGFuRGZ2SmNnTEdjTjJBRDNlamF1SGF1YUFFTVdSajBjQ2Evd1h0SWl0?=
 =?utf-8?B?NSs4alZKejlaNXp3aXBQQ2syUk5XV0FyNnJXcmgwaVdjejdhZlVkdnhZSjNv?=
 =?utf-8?B?SGt1Sk5nWjA1V3pEazI2cEI2Q1JEWnpwNlpOZk5DdUJia2szcVQ2NUcvQnBj?=
 =?utf-8?B?alNwUzZTWmpDcEpkc3FoSVh3UXdHYUV0U3BXRW9KeEJBNzZ3c25ZcXl1eEVh?=
 =?utf-8?B?R1BUR2NWSGtzMlBlWmVFTjhQVGZwajkybXFucEd3TU8zZmVDZkc5dTdEV3RZ?=
 =?utf-8?B?TmMxSHg5VFBTTXNjQVFCem5GL1Q2aUpUZzl2MXV3bTJDSjZBZmJWaWMxS1or?=
 =?utf-8?B?RUxDZHFGcS90eDVneE1USDNJNml4M2pHOE1yeXdtSitieThLa2dBZGYybTZR?=
 =?utf-8?B?MWtwUEcrZ0xCZXFmL2h5L3lyWUU0MTR6R25oeGhKMUpMOUE0UmdrVHQ5ZzF2?=
 =?utf-8?B?bGJiVGZndXpieUxmWEE5ZUxXdmcwUUswOVR4b083RS9uNkNjelV4NFp0WGVX?=
 =?utf-8?B?YVFqWG9aQ1ZicU9VSVhhUmd5ZnU0aDhUMkpKQllWS2o0S0lSTk9LaEdnUVlO?=
 =?utf-8?B?dHE5cWx6cm1QNWo4TUpKYU1lOG8xNHZSZ21LaUxtaS90VzJQOWNONm9Qang3?=
 =?utf-8?B?Wm1pb0c4MFd0SWdoekZDWXZTZkc4RFU1a0NDUmY2TlN4a0Myb0FMZ2k1aVJH?=
 =?utf-8?B?Yy9PaDZvanRGaWZKWFBBdGs4VXMvQW5ydzFNeE0zMHNxUUV2VU82dnpRbS9I?=
 =?utf-8?B?SUQvZGgyWjMvZzhFT2NSankrd1dBcG9PNWdTMm9YSEpKVkYra0Y3TGZqZmpi?=
 =?utf-8?B?eS9SclR6NG9GZ1BFekJEQXAwWVBpMmFxS3FyQ2thUU4wSzJSWEpZd3FZNHBX?=
 =?utf-8?B?WklpZ2lMNXFZRGhzZlA5NWhwd3lzQysvdVJURTgrY3REc3dsZUdPdzArMHdL?=
 =?utf-8?B?QzhPbzI3K1lxNkR6UmRrdzJFUk9SeWEwcUJtNGFLcTloTlZxS1pPWVZ4eWFx?=
 =?utf-8?B?ZW0vSUdBekhtNDdBU3lya2ZlTzdsaWorL01tSGhsaUV2emJ2eVlUVkZWdnB1?=
 =?utf-8?B?QkRKMGJHQnBTR0Z5M3ptaTIwS2ZldTBNSWsxS1dZMGFqWDdOeHpzN3hPemRa?=
 =?utf-8?B?QUxCZGUrWkdWSWErWERGeGQyVlQybEQ1dnlLcVgwd3JOaklUQVdjYXJTaUk1?=
 =?utf-8?B?cGZjRCtEU3ZJYlV3TFZQT0x4Vk50dHBvelZpSEpRZERzVkFWcFBsVEhSTldy?=
 =?utf-8?B?dTAvalZSVUg2cE9MRWJvb2FZR3RjMlM1ZElHZ0NRMlEwN3k3RUo2SjhUblNP?=
 =?utf-8?B?TkgvU2x3SEc1dzloTG1LVkpkdHo3bUxLQy80MitvcVBzSkNTYmJKZFdtRlFZ?=
 =?utf-8?B?WDAwckl1NlN4cVBJQmpLVVZsd2l2NGF5cGZFSzgrSEI0czgrUkJMaUdKWkZG?=
 =?utf-8?B?a0xRbk9Yanl6RTRHOFFwUEZsVDlHY2k4Z1ZkSE15M3VGWXUwMU1vdnRmVzlx?=
 =?utf-8?B?QUNERVNsUzBncTFDekRya2ZtRjhMYTlWenFZRjJUZy9RYWFJMWFwaGRpcStu?=
 =?utf-8?B?bGhvclVlbmZjNTAxK1pvMGpSandmWDAxc1poWGtEdXpra0thWUkwWVQxZmow?=
 =?utf-8?Q?o2akB0Cx1dWHGOqW3BclN31CE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	E5FjyI2td2Uw1kz+gcYcp6TN8/iysiDQz+zXlW5Yncl+hfa79mDMYkxasl+3DXQjza4JIB0S+utLvmloGsU6JNmO2EndwY0vyk3PS8LNgl8Ods/iP94B1uVgcZRdS2axSaawf3I2cWxJmVsp8TYWDLeXSBRyF4Po5Jo2cDnCSNcS+E6Wm4PS5MwS1IzAdNpnwWd1lp5Lkkppsgx6l2MNShvIjZYq3utvcK8q1Qv9mVLe/tCO04EgCh1ntq2nRZy+90N3QoL7wH2besxunrFJ/wWOSt5UfC1zKMJb6JUFFGYWj5Yc4ozX0gLAxkW/RmQ10rtYX6nlFlWpF36cKoSUzgNfiCPyoj5FT7/9MNXkhtUVMO8DC12OVagx7yYOzkLkN6oeg4X1dTGhr50nKLQkSc/vqSgB+OCmAxJEicWubDbyr+0ry3ab2YAtmPmqwwaQ/+ZGfnUtUnXeI+brFXgBLCG10q83iMd1vVCqFfm4KaFdF5+cXBDOITAhjCPRy7dxO/8sI5WZY/Z4PFeZduww7qIe/HeqNB2SuhJPjf2H5YB6tjt3CDoJAtjOGvTv2hIp13oq24LfNLVQzLpBmBferukdjM0DfBJkdFqlCAXmWEf0tME2ZLkCksSH9rQaJaFasb4fnK2hOpxkNz+7JUOIpQnE2Z5Ksw6ZmohKAZXqDYgjBy11uV+LTQ2VXwzuRufoS0Z/bGfqBmcbhScZ8mJnEnKWlbLTQLA/gowR2GB/V+ZEuak+K7TnI63DDSgK2vjnwyC6xC5S0eilMu1irfnTq5vENgR04ZxHztUSB8rnRYxCf6uN9lFszz76R3xzakKLXxJMmuOIioNqUTpA/sybcC1U9NYMzgC2o/eyi1kZyNcVfaKFONzoo8abib7pqU05yJpAWfWe5yBTGNy3JZOZnw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42fb6c6-3753-4530-598f-08dbfbad1210
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 07:28:15.5888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oa3iDH1E/1x1sj9cTXjF3t9W3fZqkFEDWJpnivw1gOBBjAmd5dLlUwDpzsAcxeTbBnzcHpwm4XWLqa6alWm3Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-12_14,2023-12-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312130053
X-Proofpoint-GUID: qQQwBZLMfvpZbP5A-40cgio3LmMY_j9S
X-Proofpoint-ORIG-GUID: qQQwBZLMfvpZbP5A-40cgio3LmMY_j9S

Hi Like,

On 12/5/23 19:20, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Explicitly checking the source of external interrupt is indeed NMI and not
> other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
> positive samples generated in perf/core NMI mode after vm-exit but before
> kvm_before_interrupt() from being incorrectly labelled as guest samples:

About the before kvm_before_interrupt() ...

> 
> # test: perf-record + cpu-cycles:HP (which collects host-only precise samples)
> # Symbol                                   Overhead       sys       usr  guest sys  guest usr
> # .......................................  ........  ........  ........  .........  .........
> #
> # Before:
>   [g] entry_SYSCALL_64                       24.63%     0.00%     0.00%     24.63%      0.00%
>   [g] syscall_return_via_sysret              23.23%     0.00%     0.00%     23.23%      0.00%
>   [g] files_lookup_fd_raw                     6.35%     0.00%     0.00%      6.35%      0.00%
> # After:
>   [k] perf_adjust_freq_unthr_context         57.23%    57.23%     0.00%      0.00%      0.00%
>   [k] __vmx_vcpu_run                          4.09%     4.09%     0.00%      0.00%      0.00%
>   [k] vmx_update_host_rsp                     3.17%     3.17%     0.00%      0.00%      0.00%
> 
> In the above case, perf records the samples labelled '[g]', the RIPs behind
> the weird samples are actually being queried by perf_instruction_pointer()
> after determining whether it's in GUEST state or not, and here's the issue:
> 
> If vm-exit is caused by a non-NMI interrupt (such as hrtimer_interrupt) and
> at least one PMU counter is enabled on host, the kvm_arch_pmi_in_guest()
> will remain true (KVM_HANDLING_IRQ is set) until kvm_before_interrupt().

... and here.

Would you mind helping why kvm_arch_pmi_in_guest() remains true before
*kvm_before_interrupt()*.

According to the source code, the vcpu->arch.handling_intr_from_guest
is set to non-zero only at kvm_before_interrupt(), and cleared at
kvm_after_interrupt().

Or would you mean kvm_after_interrupt()?

Thank you very much!

Dongli Zhang

> 
> During this window, if a PMI occurs on host (since the KVM instructions on
> host are being executed), the control flow, with the help of the host NMI
> context, will be transferred to perf/core to generate performance samples,
> thus perf_instruction_pointer() and perf_guest_get_ip() is called.
> 
> Since kvm_arch_pmi_in_guest() only checks if there is an interrupt, it may
> cause perf/core to mistakenly assume that the source RIP of the host NMI
> belongs to the guest world and use perf_guest_get_ip() to get the RIP of
> a vCPU that has already exited by a non-NMI interrupt.
> 
> Error samples are recorded and presented to the end-user via perf-report.
> Such false positive samples could be eliminated by explicitly determining
> if the exit reason is KVM_HANDLING_NMI.
> 
> Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
> is cleared, it's also still possible that another PMI is generated on host.
> Also for perf/core timer mode, the false positives are still possible since
> that non-NMI sources of interrupts are not always being used by perf/core.
> In both cases above, perf/core should correctly distinguish between real
> RIP sources or even need to generate two samples, belonging to host and
> guest separately, but that's perf/core's story for interested warriors.
> 
> Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> V1 -> V2 Changelog:
> - Refine commit message to cover both perf/core timer and NMI modes;
> - Use in_nmi() to distinguish whether it's NMI mode or not; (Sean)
> V1: https://urldefense.com/v3/__https://lore.kernel.org/kvm/20231204074535.9567-1-likexu@tencent.com/__;!!ACWV5N9M2RV99hQ!MQ8FetD27SVKN34CS_P-K3qrhspFnpf_Mqb0McFN9y5vSUeScc5b0TlZ3ZMDvt4Cn4b3g0h9ci6EO9k3PBEQXpePrg$ 
>  arch/x86/include/asm/kvm_host.h | 10 +++++++++-
>  arch/x86/kvm/x86.h              |  6 ------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c8c7e2475a18..167d592e08d0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1868,8 +1868,16 @@ static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
>  }
>  #endif /* CONFIG_HYPERV */
>  
> +enum kvm_intr_type {
> +	/* Values are arbitrary, but must be non-zero. */
> +	KVM_HANDLING_IRQ = 1,
> +	KVM_HANDLING_NMI,
> +};
> +
> +/* Enable perf NMI and timer modes to work, and minimise false positives. */
>  #define kvm_arch_pmi_in_guest(vcpu) \
> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
> +	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>  
>  void __init kvm_mmu_x86_module_init(void);
>  int kvm_mmu_vendor_module_init(void);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..4dc38092d599 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>  	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
>  }
>  
> -enum kvm_intr_type {
> -	/* Values are arbitrary, but must be non-zero. */
> -	KVM_HANDLING_IRQ = 1,
> -	KVM_HANDLING_NMI,
> -};
> -
>  static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>  						 enum kvm_intr_type intr)
>  {
> 
> base-commit: 1ab097653e4dd8d23272d028a61352c23486fd4a

