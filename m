Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C8662A9A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjAIP5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjAIP5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:57:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7479C36317
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:57:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309FQeCR016133;
        Mon, 9 Jan 2023 15:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uGfQSa7IJk1Qp8nBai8AaVfWhIOrRSCE4f41BwAuwLg=;
 b=CTpNZnomT1wDQPogo9axnJYSzDlcLRWPwcTXdtOOQKGBCvgLJW2rlli06AtYVTe2QM5B
 B2RmedbuTPIh7p2bW+QsnOLdC+psUaqKfQ/p7Mt9xkMI4edbJDUcwhqhE/7bqYecJL/0
 VQYvXq89YF1++uSay6EOI7GEPMGbolEyMs7LOGXp8eaVZnm53KpkbZ3xurvpx7vwN9GE
 5qwBulpdoJJ917azPkGQaOJAFl+PYsPdFU6eLqiZBrlECa3mDyJeU179H7a2NWePWjNW
 UDXFcXGk95rKchmzCxlB97orpyFyLTP81DFxFF7rg27huF1Bs40i+ybY/JlvbtIODuql 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n0ef9rxgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 15:56:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309FReJM004424;
        Mon, 9 Jan 2023 15:56:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6a5ux4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 15:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSVcOvot77VaY8nd7r4oDqBSYD0RA6s0gIAVjmrdCxpiexqtGxxwxEG/ftkhLkx0iRAp8o+m4FJj7njIls0JA+GhY4rHofygDlsQ93o1TsGVBW5bx8h1Nw0u5ot8DtrTUKLNL++pGj+VL/9dXZXeRBHGVQ2mD15TZU3UsWevEnWCUmAH4vYQuVEhD+3pSAtFfL8pw2MRdGKtAZIVFVrzOJZPFudT/bKJ3e4OVHCDzC/xRhtxwM5ikaKzv2qvHtzZI88Hsk99rvrSUdvRUXjHYDhP3uobS52jT56aCmL70vBFBKD/MICZf1XA2/RqLJkbae5dXdc2O/m36ZkrzHZdCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGfQSa7IJk1Qp8nBai8AaVfWhIOrRSCE4f41BwAuwLg=;
 b=m7ZREaFZqaYFIksHwW1KIM3s927Y/3C19ZLLMOA2TrKxTJL4XTdm8zIS2x2hKqaAYrwRvCrVAjQy+a54bANlH9+0H+O293HbrWWjVB4sRcPGa0sSv+gm2w+iYo0EBZyMZFIsBrp/ZBcyoDR177mLFO435z3ITj7Fn2MIU2aZCcmoHp/uzEUPqjtiAhA00IWfCmzv4uuwSwIJvF90G/UUVwtAv/UQqTAsLAsiGVYAsMgK/TCIiMbmuL/TzVZ1a94ycLOLZ3wPrlZAqjDmyINC6MJvsL7dmzIoSdaFahB4oys2zeu83ndyP92+BLQUwwIMvTlnxa2bXJNKVf1m8T4Auw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGfQSa7IJk1Qp8nBai8AaVfWhIOrRSCE4f41BwAuwLg=;
 b=nmvFXKNG3esU7m1DKyp/1K73o4kTpmwRkjgDWyJrwVq+Ax1/mcsYZf6Fgki9s5jWcaZUO3fwG1oqSY7Djqu0tQUPNQyruQeqOWrjsspfZ27eEotoRN6WTTY0eZbXGkeQITnHQWFs9MLplHoKxaAFUpwCx9Z4C22KOJarRCxCgUQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY5PR10MB6215.namprd10.prod.outlook.com (2603:10b6:930:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 15:56:53 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b6bd:f4a8:b96f:cf5]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b6bd:f4a8:b96f:cf5%7]) with mapi id 15.20.6002.011; Mon, 9 Jan 2023
 15:56:53 +0000
Message-ID: <c413089e-d7b9-8a56-6fe9-73e5b2ef4aa0@oracle.com>
Date:   Mon, 9 Jan 2023 15:56:46 +0000
Subject: Re: [PATCH V1 vfio 3/6] vfio: Use GFP_KERNEL_ACCOUNT for userspace
 persistent allocations
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com
Cc:     kvm@vger.kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        diana.craciun@oss.nxp.com, eric.auger@redhat.com, maorg@nvidia.com,
        cohuck@redhat.com, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com
References: <20230108154427.32609-1-yishaih@nvidia.com>
 <20230108154427.32609-4-yishaih@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230108154427.32609-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:208:1::39) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY5PR10MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: 927c8b38-ccc3-41f2-1613-08daf25a206f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMre5mrBDiOHjIUqM6drJjWFX+aCvBgYBPwKsXoQCGC02kg/u1aJ1pzZPBaeMpt9sLNirk3e5mNwnrSl1dHO7gMvxivZldPuIIoq57vJM89kz68YqeUO0oomgsutEJZGzrQ68xB9PplMKT0zCIfFMbP+CTAKP5WbT4p5lafTDgVCJqWwizlC6Ss59h7OGZZdJdptJkd4OWxA7Lpsnq0ohDGN6kofw6eof+jrwhFh4QZmKJH9k1lJfXVeuMj3PctDA9JyIhE50Q5u4F6p/SwFqxX5I1s/7AgGLU7Rl8xeN+yZh7H+j61OG4qBgQPoss2xZtrwdRoW2KpA0GaoaezkMJ13MZqtng63M3OH1GTMewFeY2jeJ5moOFKPv9b/ttLgm+Zkfuiv0I9CFUMLHbyUlP7SpHeMPeoUqDMbpe9Jt+MJ4b+4FlSJzgAltrGx2HhKYnbXu0VB4w0gLtgfFvQIJcIHECSb4bSjoKDpp6VMHU9hnI3CAPTS3wBDAy0qisRmg026qmRBT+qd08xROofkrDqvrVcwSjjoa9LuWGhF564nm8jsP3VbTsBQWxyv618Hj+O3drJ6LGDpswK/nc7kSPVZCJeeV2i9g06muA8DkNlAvA2Ttge6ggPFu4JFJr9mojl5Xwhw6PESjCgA6vSznpUOnCvL+3m1P2fGWiiaFgGCOPBgmDTJPBUUDCvTemZzxfvMDXaEim0VpTA3zgdQSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(36756003)(31686004)(86362001)(2906002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(5660300002)(7416002)(38100700002)(31696002)(83380400001)(478600001)(316002)(6486002)(41300700001)(53546011)(6512007)(2616005)(26005)(186003)(6506007)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzhJQytPNGxSMzA5MGZsazBybVcyUjcxR09MWXZieTMvbXNmK3QvMGlHRGdL?=
 =?utf-8?B?ZEgvZ1VMaFIwQlZMZ0c4U3lxbmtXdHkyVTJFRnNOUDAzU1haMkZBMHYrd0VC?=
 =?utf-8?B?QmIzK2hHUE5LSlBOdjlYSmFSRXpWTFFuaEYwZ3liUTl3bDRlMHg1a2dhVUNq?=
 =?utf-8?B?a0JIOURjTmIvN2VWb3lXTENTL2VJN3VzcCt2dlFxRDNnd0pOWHQ0RnpFd1c5?=
 =?utf-8?B?KzYrcDI5dGUzZ2ZMeDV6UUdLcWZvUG1FN2ZUZFhhUW9SYmdBU3BBdzdPbExz?=
 =?utf-8?B?YXRMb0hlbFBDR04wa2NLNFIxUkhmSFdDajF5VUV6SEhvY0c3VHozTzhyV1hk?=
 =?utf-8?B?MFZjSVdjVmZvUS9YbHduU1lrejhpbnNBTnpnQ2JNcUFaS2l2aDZSb2ljSXE5?=
 =?utf-8?B?by9WaXdUeWt3WjdXbUM1UnZRVEU1NVVIWklVUDcrcEhlcUpLSkJ4UUQrMXhJ?=
 =?utf-8?B?QmVERFdtVmdSRXpDN25BbTdYaFkyYm10ZExiNkxPSmYwQVlEenFQalkyTFhx?=
 =?utf-8?B?R3I0VDhmNnNiYkxzNXQra3FIaDBlZ1RmMDdhUEluZ0xlajdQcXhpcDRQVnpX?=
 =?utf-8?B?Q2o3Rlh1VkRCbU5wME14WWp2SHF1ZGtHaHlRMjRZSXFOM1FmTVZBMks0Wms1?=
 =?utf-8?B?QVNQVHZqcUFBNy9vekhVbVE4OEF4UkdNQmw3Tk5tRFZxamp5aENZMER3UUJ5?=
 =?utf-8?B?MmQ0YWp4Z2ozMXdjRDgycEdzYnMzVEJEeXdTbGl1Z0RkN2Z4UDZZMnFyQVlS?=
 =?utf-8?B?Q1ZodXNTRXFEbmVQRDhGa3dmemVIQnRVZzVPcE5oeFF5cEFtZjNzSDBKRWg0?=
 =?utf-8?B?eXVvV3ZzcVp4d2pzUzRBL0VHR1NWaXh4ZWpuQW1RZm1QY3lJRnRQMHRKSU5Y?=
 =?utf-8?B?Q29FQXZ2SjZmNDFRNEZPWVBNTkMyUkZZVnF0a0JXZ3JYbHNXakVOR3hpVzlU?=
 =?utf-8?B?d2ZtVFcvM2cwQXpQS1lyUmZtRk9PdVd3UDFSZWF6OWxOWTNhQjU2b1FxNllh?=
 =?utf-8?B?Y25DNURxbkJCY1czcGlMYkJiOFNGd3M3WXFHUVEyTHdwZks3VUtlRmhJSHFL?=
 =?utf-8?B?ek1EVzZVV0MrMWIraTdnbGtscU5QbHVNTTNzbmV2MW9KMWRwQld2ZnF6TGI2?=
 =?utf-8?B?UVppT25WSVRHN1VJVmVMSHkyNXJmOGFQNzZ5Z2FwNmdDdlBWdElZQkhhSUN5?=
 =?utf-8?B?TDJaVE1MMERQN0JXYXc5dXlDcUh6NmFJUDF6MENjUVYwdHo0WlRVQnprUFND?=
 =?utf-8?B?YmNUYUlGY3piU3gxN0VOd1hxSlBVNlFZYUI3SkJWL2FrajhTdjZGeU0ra2w0?=
 =?utf-8?B?N0wwVDQ1RytQRDNXZ1U1MGJXY0RBQzNFdDM2T2NWdWIzQlNvdzdveW5xcThG?=
 =?utf-8?B?eEZyMXhrOFo4VDY4L3NvRUVrODk0S01hdnptNTFncWJPQVU4UHBRbTYzVGN5?=
 =?utf-8?B?R1A4MzVWcDVnRnRPZnhRWlZFN1g2QzA3MWsvQ3daWHJkZE1qUlc5SDZPQXdr?=
 =?utf-8?B?Z2xUMDUrZGNTZ3FRaFdZUlE4Nm9zNkZSQndQSVVsZ3MrcEo5Z3gzSWVVL3Rt?=
 =?utf-8?B?YkMwVnF4QkpYdTFPaFVwOHpObTV5NkV6bWFacVJQZmdETWtLY29sdHlweXRK?=
 =?utf-8?B?VzJrMUhFSy8ySm1SWEJRTlcxakdWZDAzeTduUEx2V1lBNWdqTGQ1cUUyd0Va?=
 =?utf-8?B?TUJaT2FXVVJqZ3dwOGdrbnNPOVZHMktqMVVVeTB4aGI0TVRaNkd1NXN3a3V2?=
 =?utf-8?B?Q0Y0aFU5KzYyTUs2MG0yNzJ0c1dYdm4wREdYRS9YYnVNZ2V1S1dLL1R3NHRZ?=
 =?utf-8?B?K3ZQTW9acFUxR3hBcUxZdFlsNTVRWitPWmIwSnhxd0JJY3Z2VlZsWURjYmlX?=
 =?utf-8?B?UXpwUWorZDZ3UWhYZlJpeFRpb2g5d0hOZFR2OWZlOG9INjg1QXFsOXlUZngr?=
 =?utf-8?B?TEt4TzRHUEw5MjJvZCs0QVd4aVdHSEVTWmRtV0lGbWswRjczS3RyOE1oWGRv?=
 =?utf-8?B?WVp5ZzZpZGNPWStITy85cHhOY21EQWk0ajZFREQ1c3FoSTRsWmh4VG9XekIx?=
 =?utf-8?B?akFCcXJkR2E2aXBMNVVOSjNWQUpWUktLdS80MitsY1puUVVKMUFHajY4N01s?=
 =?utf-8?B?QzlWQXpic3gydEZsMUorTlV2YjdvS2d6UDg0WEVSZXU2aUFHZEQwRkROMzRV?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7sZMlzvdpso2Kv2n0QE/9wGH1LPAUkrDQfoK55a/F/DJzKCUkEig3Pvmc1WdU3FqnzW3Jqja8x3f7ugTvrSS6nJwq0tgOrys+yJ9A6m7AoVvqMdjbED/KvLm5zBUNoqAtCqnfQZTPk5JGPmyN4yVylED9jFbUyDWdhOWrHg8gDEOHySeVmEyuhpwBqtWHecKOZfAecL4qy8G4fl21CS+68h6XyHTPW/1AezGwo3jWEloRm1mfvmpBuds0Y4D6IjXvCKcgBKYJw57w6Lm3GE1GlodVe0VZfpr+Uh9kQIbwsdj2+AVfQs8PVFUc6LdWG06NThgmT6SBe3ZjXEYvpurWxmsn4/9S8fe2yV/x8HS7j0bmSuzY7DbBrqVhC+fntts5ySDq/WizOoCTz2HkKqU/J3RdavhjsbLZfcBlK7t3hQLTUqdXdTwXUg5/Zlu1H+fgMBKfwteqv7xprxkiY6Nqcd/3cfKThE3VHOsug9lRgOTLHGeZfI0T81l8CiR6G9CAlWaLCasF1v9sHb/TgVmxu8oYeG3d1AzHe/WfGXnK0Rqr4BtZ4f34Hy4y5zLG5gS85a2G4+l+ojDW97eIn9/Q0r5z48s6RZEqnhVQghUw+Q4zElCdz1rqngUgoV0pBY7YPKjc8j8h6S03xHrNJQuktys0YgP2eImqRS29eKj3so3zemHEilWrlfB+mHJFYYKA9OU01H9lpRVm4ETi8GMjhRanGYFmFPaDRe2YB6M6h3buuJ2C6YbcHNfYGjWnY93Q1lKP83j9hvjlJBJbxB2K3aXqFnDHc2mfHqRamTk/7lchDDLjM76HxcY2FTUR8nw5gin/DndsDkuNEBhCWyUFY9Hp+NPcLeNhYu2nJovFlt1HjWEflW6wHfntgAdkVj+clkxr6lVsdPc7d1k0bkfAA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927c8b38-ccc3-41f2-1613-08daf25a206f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 15:56:53.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wqu0iNC8nh0QlqU+yrmHcoWAnbp1my0nepXfHysEz2Z+SmOt4CGp6hlbuND6aSSDp0hy+8Ylvpluekzv4fnOvm/0D4/lOfBxOk7glshJ0eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_10,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090115
X-Proofpoint-ORIG-GUID: srHtELVV2YpZEn4KGzX9HrEigoApD_13
X-Proofpoint-GUID: srHtELVV2YpZEn4KGzX9HrEigoApD_13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/2023 15:44, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.
> 
> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
> is untrusted allocation triggered from userspace and should be a subject
> of kmem accountingis, and as such it is controlled by the cgroup
> mechanism.
> 
> The way to find the relevant allocations was for example to look at the
> close_device function and trace back all the kfrees to their
> allocations.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/container.c           |  2 +-
>  drivers/vfio/pci/vfio_pci_config.c |  6 +++---
>  drivers/vfio/pci/vfio_pci_core.c   |  7 ++++---
>  drivers/vfio/pci/vfio_pci_igd.c    |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c  | 10 ++++++----
>  drivers/vfio/pci/vfio_pci_rdwr.c   |  2 +-
>  drivers/vfio/virqfd.c              |  2 +-
>  7 files changed, 17 insertions(+), 14 deletions(-)
>

I am not sure, but should we add the call in the kzalloc done in
iova_bitmap_init() too ? It is called from DMA_LOGGING_REPORT | FEATURE_GET. It
is not persistent though, but userspace triggerable.

	Joao
