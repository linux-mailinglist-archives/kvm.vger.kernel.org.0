Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99087645C84
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLGO1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 09:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiLGO0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 09:26:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF73E5FB90
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 06:26:40 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7ENfnr000515;
        Wed, 7 Dec 2022 14:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=L18IiDI+3BG+Wd68lIoRAd32xlz3nOPXYFfMdU6XnTQ=;
 b=a7pMh1xPXCIz+WhadsZEvIMDZOwCQ38hRhuagBqxka1pQMibAVSzctmY+/Zg8QQplg3n
 bRTjeZtqX6u0mW9KPw1x7+KzMaMD5rZ35AyU8F+EvZTZc84MvwrpvLziUimCpWB2O8HI
 81xysFK9a6viXgcWx3VqceGrQ1sk4d05yJY196WlayU025/YD/S/cloV/7Q4sR0aztnh
 48i064yQCV116Ooi47LlaNZjFS89YsK45u0PFq0+Kn+xlPdUL0BiaBFi3bRL5nV+zJIC
 d/P0CuH6FEl9Kj4JVPCh3stsyO+18aosVkcwyktbe7ZvOJkg2/quCAlqfHUUEC10wPQO +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudur6w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 14:26:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B7Co8S7022256;
        Wed, 7 Dec 2022 14:26:37 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa5xr08k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 14:26:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmTq656IEhbwSNnrRf3yD+f4jc6f3M+TcSTsscgUhtrvehg6f945tKJcjDLFk5jX+L7hmb86Ih7FmtqisrGgLlMF1HHLDMW6RLHgytfcqglOE8wODRYK9BtUIuKhrPlkp4984KMb96xNssx3Sq0HdKoLlmq0bEWGq1xEKtdwiATKHFAOu9y7OqkpbKNaQBvvzlqDB81VMpYx75XusJuV2QbsFSLdkKn9+kL6ClpoKmiRG9MDTygGUE29aQUXK3pDVkQ+FRZaOLQVdPwTQcnTaHAymBkNHMYd/lALLrysASsNdP6ktuUzn1Cv6n4uIDuSR30aECGl5s77No1GrIlGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L18IiDI+3BG+Wd68lIoRAd32xlz3nOPXYFfMdU6XnTQ=;
 b=S0HC1j9JEzQ6tDIb3jYIKmi/oybRDQZdAWy9scVc2UFOHrACTDd7tB4XHw0Y+luxD1r3uN1hb6X9R8I+Jz02rsybIV6D0bPsQXDMrJbap65Cf1P5JjUBHRDKFfdcFe+PK8J3iUdiKzV6N5WV0/GFaDb7kJqy085poYZ+K3Umu8tA4zehqy80hmlxv9VxwYVleltVIT3l1Cpf4XBY4yXwG6KMr5aznx4l/6xbU89hZKYd4a7lh90Zizljjccgk2gdgTE4IBTiYVpPe40lifn/w2SFgnyY1lwykmkiYl/IU1TxiECY+AEmRPV5MOexAkNy4nPGNTqusIxr12kLJ3CQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L18IiDI+3BG+Wd68lIoRAd32xlz3nOPXYFfMdU6XnTQ=;
 b=ET0mHfRWjUez6RFvOnRc3fnFYGSI1Uh5j/3SXJet72Htj0bU3OvjZ9PMIJg33V5bKpHCgECEZawpfVSmT0nL6d4EY0ZWCjXctx732xvBdRjtuvklRImJAGFItTIN3uILxmxEE0GW6lVv7DJQOlWWvp712TosllwU0TBRHFYSTQM=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH7PR10MB5721.namprd10.prod.outlook.com (2603:10b6:510:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:26:35 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%5]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 14:26:35 +0000
Message-ID: <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
Date:   Wed, 7 Dec 2022 09:26:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
 <20221206165232.2a822e52.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221206165232.2a822e52.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0045.namprd20.prod.outlook.com
 (2603:10b6:208:235::14) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH7PR10MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a30f94a-96c7-412f-7b45-08dad85f0bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nschbK/YiS/8RBTliRn9Qu6JUgKndFdvbCo6qUwZ/QM34mgfUhAOYTnnhcXlkofWmdV6DOLC6MR4QrINDAFRt4KG/gUy2Zy7+IkR5mtlA4l5S/CT2ScIhjkJjS5kB9iswPfThsa6Qu2b0wDbxa0wzqhRC/GlGhpXilVUs6uy8SJb2ho2FH5bIbR3Wkyep6YsIoHroO4Ryh7nK04O2glnZoOY6H0NT3j+Mq6xwvalb+2obrfrkgr4Sjz2nL00jNQQVWk9uze//C4A9Y5wlr8v9Y4r/RFlnqJQse68bg+ZmKvGHsEBx8Xw/TnGkY9ugCF4+4DRBXIrHGAELWvHEC3M0dBPyHVMwsktYh4aWJGa4PsGCMYK400bGE5MLWk6RnVDBi4v6YD0+YqHRQTKvfJnORLofdkZTa4czhM1igKTlShv34ofBavL1ZImVN9KS4lpoL1T8+E3EKFQZ8gaWZBEPwU5MzVGzYvSAuR7lv/O8SwBvBCSrxtba6xfwmFkEz4z/MfozGyE7BsSoTfcTokPXVYP6zHx8bPqr8lYHNjtLHqrjMv3aOSGWY4VJwTNneNwFOfpm7BiUeFLvsC86puEws1B0ri6ZSooRhQks0Q2K7cr5JbKuVQt1+EmNPZN6zop3EsEnPQ2OGa3BHDds8cUzzfXM4TrLKoXYUOp+BSyvnE8+EYW0q/cPggLMYX/C2NB/+dyZgT+Km4GLchMvrH4Josman/JJ0GcqzGXb4NAQwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(6916009)(86362001)(66556008)(41300700001)(316002)(8676002)(66476007)(4326008)(66946007)(44832011)(8936002)(5660300002)(83380400001)(186003)(2616005)(38100700002)(6486002)(53546011)(36916002)(31696002)(6512007)(36756003)(26005)(6506007)(478600001)(66899015)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkZDWTdsdDRWUm9iM3JCMEdNNVZYaUd3akZzb0lYZnlmUVJNMm1JQ0ZLY1RU?=
 =?utf-8?B?ZHpKTk1PdzhpbWNBMURveW5VQWl1ZjBMam84cmZqNVNGMTFtc3JkWlhNS1NY?=
 =?utf-8?B?dTNrNnZ5SWRsK25ub2NMeVEzTTl2NnppTkt1TFRhbXVsUmZKUGlIeVZxL0Ra?=
 =?utf-8?B?SU5mQzlkd21lZi9Ic2UwNjRLODdVYW9iR3ZpTUt1N3d3UEFtd0dwb1l4K0NQ?=
 =?utf-8?B?WERNZVBzUzY3elZqSHZIalhJb3k3OHVzQ3BCV0w3cldQN2pHdHMwa0J6UWhN?=
 =?utf-8?B?OVJSaGFWaE56emluaGVDWFNZTFVXczRHWW1PUzlWY2dQSGlHZ1kxNWhEUkYr?=
 =?utf-8?B?OGVicXIrajBlWHBRbXgyZUJBN1JteVlCZjdGWkhYaXA1MGdmRHNDdFBReFdw?=
 =?utf-8?B?U0xhUDFVdStXcTlsZFhDRkpHQmZhQnI4RUhuVUtQZWQvaEFDMXJpYlJiWk96?=
 =?utf-8?B?KzhOMm8vZ1krV0tKT3VvM2xJMlhyUUE3V0xROERrc3BUR3FJa21oK3o2bVlI?=
 =?utf-8?B?amw5WmM0bnh5WUpHKytocmh0T2ZWd2hzZDFiWThVa0k0SHh6OE5kWVBHblR4?=
 =?utf-8?B?VCtEenRzY28vU29Rb0t5TGV2dDE1dFFpUFFNMmpDYWFmVDU2ZEdaRlRWZ2w3?=
 =?utf-8?B?QWhaekw2UkQyK2xXV0s5cDk5UFMvVWdaNkdwOGlrYi9OdjdFRnUwUVV0c1hR?=
 =?utf-8?B?UW1CRlZOZE5XYlRDS0Z2VExOdWFybVpYbHd4ZE5uVXVCYk80a21NNkZHa3VY?=
 =?utf-8?B?QW5tZGRzK2tGRWlISElIaGM4UWUyQ1ZyNGZmK2p4anlwRlBhWEc4RG0wcFp1?=
 =?utf-8?B?TnNaMmtBSm5XRWlDQmlzVytGYlp3UVpMczB0K3hLakNPTU1yQmVPYmkzeEJW?=
 =?utf-8?B?NVB4dU9oeDZ6cHZzbnV0cXJ2VUZmT2FEdTE3bWs5NStiRWI1RDNmZE1KYWNI?=
 =?utf-8?B?d1R5Wm5nN0RGNDZBaHRTaEtaZnpzcVVRTmlYQ2FCaGlFK1JqL1F0bk9VUUh1?=
 =?utf-8?B?WUJEaW5HbnFBaG9JY2lrSnRWelRqRjNuOXN5UExyNkZMa2RyT0IwWmsweDFj?=
 =?utf-8?B?L1lmR2xWZWltRTJ0RW5wVHdrMzFpN1hSSkRBOWxaY0xPYnVlN3RrSkpIWWlQ?=
 =?utf-8?B?QUZoeUg5Sit1S0hBbDc0YnpoUjBDbUQ3RzhhaGRxdnFlQ1RSQkxjeWt5VnJy?=
 =?utf-8?B?cFhFNjZZYWZrb2loSnZHQ1pjU3RnSW1RNXNxdG9iZ09sZXZtNjBDVW91STdp?=
 =?utf-8?B?M2M2RkhvMzFzNHJzUXZEcnhGaTJQWU5wSDYwSE4yeEFCWjZwWDJPSkkrTDIx?=
 =?utf-8?B?TEM4bTFyNytodmdta21MZzRoRTdMbldDR0pYTXdYTXZ4R2ZmQ0g0akN3SmRK?=
 =?utf-8?B?NmlMbmloMkZBaVhrRm55Yk13ZHdvcWkwYmxyQm9CZXQvYlUyTm84djIvZ2o3?=
 =?utf-8?B?U0l4OVZDc01zREMyYTdCZmdpOGdLRkZHYlJvNDF6MWhxWDJTcjVVNENIRmZh?=
 =?utf-8?B?WFl6MU90WGJZSGhMNWZLdXIyQUJmMDNkYmk4UWRpZGJuc3JMRXIwSGIyc0xN?=
 =?utf-8?B?aHI0NUxST1RQd1hvVDE0SVVjYUtpQmRSeGhSU0FXVEZHL3BXZGhVNmc1b0Vk?=
 =?utf-8?B?TjNiWEl6WlEzdUEvWlhmYWE4NVRCaUZHMUh0U2hNQmtwYUtNVWN6K2E1cXFm?=
 =?utf-8?B?Tzgzelpaajh6KzhXSlJReG1LaEFSbVVkL0hNQzd3Vk8xQ0lQK1Y4OExEcjZh?=
 =?utf-8?B?Z3VRMkNxRG1QT3hnVGFCeWQ2aWNoM1FVbnNKaVZlRjdoR1BtR25GNzFGZXNV?=
 =?utf-8?B?YUlkRUZ4YWwrYzcyYjhtQXRFcFluNFJqRkRUb0h1ck51Q3BMQUV2NVc0Rzd2?=
 =?utf-8?B?b3IyNUxXZnpubjM5ZS9RYjdrVWtybG9DdTRqa2dmRm1rcEZVUlpuM3NTZDN4?=
 =?utf-8?B?ZGliL1lUL3lpcStRUEhCMFZxNEtQOXU5aklBMnlGMEVoZzRCSlRZOGFhN3pz?=
 =?utf-8?B?akNtUWJNdFpEYnMyOWp0ZG5nNk50M3hBa0hDY3ZrR0dkTlh5VzJMMzQ2ZUxU?=
 =?utf-8?B?MHhzYWJUTXBuYTdvVXQyWm5xRm92b1NVcGdQOTd5Ym91MXNNRW5WVUlJclRD?=
 =?utf-8?B?UVV5Rjd1MjJKSE5ld3RPeUlXeXBMdnlGSkV6N2FMWEt4ZUlZRy94RGVOQWhN?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5J+ycrjmtloakpJE5TQH0Xdud8nz/c+q6chghaHFLVecnAhf1haFgmFy3NdEvV5I7I6KVgR5fOeTdrtRiEQOuDV5p30l8+07PhCd862oTNkmhffCm1Q6FNm6bkYEfbnkBph2iNYGGBBU4Bo9/zCGK4DjMQkOZLQ/C561NAy4YlEYzle6VyAkR56K7ZTWCb0FAbJcFJ+iaHLzJmuDsnCXP+kgCh9P3cuh3bw7fjn93jXyABMd6JzHMmpt8DFybQ45hdESYcqFogCLsiF1b97cUjzhU3aWT4eKcD+SpOdkya9JTJasi22ZnGGoOd5s9JKOe/CQXaajh2wGVxFYDIXUIaKR+3lMixUXwgh3PGh86J+iGxW2XOiXd0LjfOLnydN/dvckGCfhjMz/NZHHuswCHo1S62phxpA27qod2Pda4ZfvQBtjPxdhraQ/dDR+NAMycCdPgWkx63/v6mgnSexkRKVnpz5SbWkjN+cRUxTblvcluMSntSb8xxcpW6QSgTMHLsqAb6qybuTD5Ax+2/974AFcW3mLz9mU4TmpWJUu/KrqBo2UKqEG98NSeq2OdbJpITjdNx+f0ixXhBbxzVYAX42HLhFN/+DxexoLfEv+DATmJe065K6BkMj18aDI/81dMxl5RNG2zA/0I0sdhD/Ox6UE84bouXSI99K2NUIyeWCRufADM9MynLs6VeSsECAi4Ct3NRXri3Dh/xcn/Ad6kXwflqG3kZYCyXS8ra8ViA9kZ1IlCnkI2d8NgI0ohUeVFzpHw8V/mV4o15nNjDQS3vSHM6d5SRa0NNH/I8AZDzpBtSeaV0Jxcehfxq8SZCgo
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a30f94a-96c7-412f-7b45-08dad85f0bb1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:26:35.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3znalBDaMrMN4lqTOqtPQFvNbnx/BIFIQHNDVRLIHhbAEsIEzfxFgjBX095+sjfkGjNDYfRtoMb12PvYuPYakUbvgReR0pV0P2j9S5zYCBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_06,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070124
X-Proofpoint-ORIG-GUID: sQYG8p2xt9LQGSGweo6hRZZFjmHM6rPb
X-Proofpoint-GUID: sQYG8p2xt9LQGSGweo6hRZZFjmHM6rPb
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/2022 6:52 PM, Alex Williamson wrote:
> On Tue,  6 Dec 2022 13:55:46 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d7d8e09..5c5cc7e 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
> ...
>> @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
>>   *
>>   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>> - *
>> - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>> - * cannot be combined with the get-dirty-bitmap flag.
>>   */
>>  struct vfio_iommu_type1_dma_unmap {
>>  	__u32	argsz;
>>  	__u32	flags;
>>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
>> -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
> 
> 
> This flag should probably be marked reserved.
> 
> Should we consider this separately for v6.2?

Ideally I would like all kernels to support either the old or new vaddr interface.
If iommufd + vfio compat does not make 6.2, then I prefer not to delete the old
interface separately.

> For the remainder, the long term plan is to move to iommufd, so any new
> feature of type1 would need equivalent support in iommufd.  Thanks,

Sure.  I will study iommufd and make a proposal.

Will you review these patches as is to give feedback on the approach?

If I show that iommufd and the vfio compat layer can support these interfaces,
are you open to accepting these in v6.2 if iommufd is still a ways off? I see 
iommufd in qemu-next, but not the compat layer.

- Steve
