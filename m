Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC5D706F8D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 19:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjEQRgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 13:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjEQRgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 13:36:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A44730FD
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 10:36:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HE4x6m029154;
        Wed, 17 May 2023 17:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SEbrc508FARcE6QlJR4c/4LFnDu1ZWQbw9pkgs9GHEs=;
 b=SBLFM0PT+TDA8w/Oonc81t+ZHDuGWfgZaOER5zOTJt/CQhlfX0XF1+QHZUmcOJVemM7e
 IVaSFREjHHODfcu5Tv2rKyZH1f4Ak31peDjY675fozhoNTrmlJHAU1hyeEuNfJfm/nTC
 7Xs1X38AGRiIDi87dIwVTZuyy4CkGicMbL8BJE4YFfCrD+uXpeG6BNb7tc0PS1uYdbfm
 +kKqfBRY9Mh2ZFDghHwTANrUL2b8sPKnrDX9UwcFAHAqCa458lHwotvE/lKH0i3qTnUn
 zdb3B7Z+L8ck1MISvmlACMDkJMccD2y+QhQGPcPdfGQxJ4q5uho6vPoJuWlQOMFj1XvK 3w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxfc0ua0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 17:36:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HHIucv025048;
        Wed, 17 May 2023 17:36:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj105qpve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 17:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjI1ZMhUKuspDkOHz/A11MV22xcJx7aDqEP0X7Rp0OHOPEj8PL9aipaqC4pGWB/i2vBGR7fp1c4Bk8nWPglaj+FjFpxW404/pJxOrjD9rXhCWnBk6+dPhx0s383P+hhsxsNoUT0+cljWud5Cf0P+l7cygP5qKtvIqwGhCSY4TkVXI0YtUkDeV6LJJUYziNCn8ZMpKEKeDI3UWaRWG04l4/TG1Jc012a73qP4rSEjIx4mJx2QipMCgJhY+o80jNzSDcqlaRhNUDkj8wGGo+5mR7ulZOxfHMEme9xXNFEC+HaZd7YtKHHyGwmAIPAtRMKFDfEwk1HiART3oW8nn52Sgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEbrc508FARcE6QlJR4c/4LFnDu1ZWQbw9pkgs9GHEs=;
 b=doXC1HEIN7mQN1NlKmptBP//j7ZBKdmZIIlRB8XswzWmXz1mCZms34ptz1l8SXGfknS9THm69JAshptoYCOOUHuld2SRSD13aevkzliGA1vKjgmdRRdXAIVOh21vqp5J4jhwq8CFehGFmCnpFfTa6JbAxvBMlAB3v9vPMlV0Kct6CbG2AdJ6DwgoeIRrx4Zy8Gohhqyv4/fKdTgF2RutRkuutPydUzERiMl9vOcyrwT9T2afsENSDh3RDMz/mm35AX+8+pbmJOBYnHzhwe47lkXZeWvK4S7pWrfr5dDiXACjQFq1pcVSy0dabPb0aBBHNXw5UMep8cMduC+W8v0MsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEbrc508FARcE6QlJR4c/4LFnDu1ZWQbw9pkgs9GHEs=;
 b=tgstCydMT8l6qnLCeQPv9z8GAs2lcUhruWWzqoXuFkd1+PQ2G/GP+Ta0Qu2y9MhjejB5bJMCbeLbQmNwuBE2W83ptrSKDdZorTPMEXLlO+wFUanFYEg6ejMEzHAWaNGcpKlUCKDjT0T0a0ASaz3K3cJBRjPznDMTSsMyWPT4C20=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DS7PR10MB5215.namprd10.prod.outlook.com (2603:10b6:5:3a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 17:36:07 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::7361:8416:8d4c:7733]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::7361:8416:8d4c:7733%3]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 17:36:07 +0000
Message-ID: <d6e8cb86-b96f-14b7-8fa1-76b73573423f@oracle.com>
Date:   Wed, 17 May 2023 13:35:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
 <20221206165232.2a822e52.alex.williamson@redhat.com>
 <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
 <ZGT80dRx6D8e4IlW@nvidia.com>
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZGT80dRx6D8e4IlW@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR1PR80CA0203.lamprd80.prod.outlook.com
 (2603:10d6:202:2d::23) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DS7PR10MB5215:EE_
X-MS-Office365-Filtering-Correlation-Id: 772be3f7-1f3b-4179-686a-08db56fd323b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3C/HQOG9b/16NPPFKNTQrmKONwZyzht24iL2TR3VEvLOTuKilIOpCShTQNOfp3XmjsAr6yrX05d0UnwOS21wcUldFFVLacHIbRz+M2q02oe4fze10OfH2oBKv+Q4yGqNCr+QIvwIhtivIaDEfoL4n9OJokWL5kicY24INNUS7BbWMLtR28Da61IqWJLIFZ33fFQ6sTTtcpX8LRqPqikN9Hwt2UhXjk/AF3G2aGrVei4oDApXUkRTAUvrpsEVu9W+g7gC/wsLjJE4IsblxHU5DGhGnuGoGzuYKkamLIsSQ5jmnroIhCDOemau6BDqx5q+qxZyKQw7x4R5Z2xYVe2WYeGyAB6zFGrGbEhdKFyjx70sMsmfWMFWHK5E5KFhyiZ87kR57UwraGBrgBWeC5OpgPgkQqRInXFMK0AKjO9iVe7wsRITE6EJBxyYVAOw+qUAFam8WLRT96NDqUASQjLGhBGwtuiIdfJex9hKvxc/GNvE3t3eTsQOfSBo9vH2tGOnLM+E2F6sSQzMQLIOYj6p+7oMBkv1byQvosFnu6G+mcSjzAfHBpvjwjm3lD//7C22chjxk8lK2BfowBI1csIcDlwA8gk+dNjYYSucGXGgMrD141MJxH6uVKPMbKc5RJ7iLqDKzJSfqGywhxnCL428w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(5660300002)(66899021)(41300700001)(2906002)(36756003)(2616005)(83380400001)(86362001)(31696002)(38100700002)(26005)(186003)(6512007)(6506007)(44832011)(8676002)(8936002)(53546011)(66556008)(66476007)(66946007)(31686004)(478600001)(6666004)(36916002)(6486002)(54906003)(316002)(6916009)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2VzYWI4YzIzT1psa3g1VGp6ejhBZVlyNWd5R0ZtQjlMVTZ4TmdMVndBNFpU?=
 =?utf-8?B?VHZaMmxmeEh0aklzUkhYT1BQV0UxZ29PMFBlYTdsd0RWbFd2czRBVWU3akpu?=
 =?utf-8?B?NjA4UllRVjZhSXduQ0J0WS9LNlY1ZWxia3dqQXRMTU9qMkcvMmVyWlU0NVRp?=
 =?utf-8?B?REVwM1ZSSW9odzA2VDBoWlVibzZqNlJZQlNvZ2lyUXpMTlhXeWRidGVjaTE5?=
 =?utf-8?B?cUZQa0gwL29VZVkycDJsYW5taWg0c0IzMVRUeXNQN1VDWnBXZnBQaGx5dE8x?=
 =?utf-8?B?M2lzYTFZNnBjYm51VkkwZndWUHRqaDhuR3FsdUQ1Z09aNDZvNlFGcWh0UjRR?=
 =?utf-8?B?UUQwU2N0T2tPNDhYNStibGRnSTN0bzk1Z3BLbGowN2Jhb0E1Z1o5RHpmQ0ZP?=
 =?utf-8?B?ZjdLQi81dWhsODNIcW5uQTZBU29MRytFQk5jZitaNjl2WjJvTnB0ZEI5bmJy?=
 =?utf-8?B?cklpanc3K0gzOWtqaGZGMGJlTjk1YlcrSlVIcUJzQ0hHd0Z6dXF5aisvMGVh?=
 =?utf-8?B?MnNETWxsYi9MVzVPbTd5Nit6b3RYdC9INjRLVldRSUhuU00rb0IxWUdKb01q?=
 =?utf-8?B?clJuRkhSYTZwdE5QQzBJZ3RiQjVjTG1zK2V0Z2VqMXlkNGpEcHZ0dGNiU1dz?=
 =?utf-8?B?MUl1a01uaDlaMXMyTXB2RFBDd3ZIR3BsUXBvdVNCWmlNa3p0aEt3WjVueVJN?=
 =?utf-8?B?U29HWlZMS3dJTUx4TjFnZXM2MkVpY1dOV00xU2hlcUNjRFZyeEswcVRtT0RF?=
 =?utf-8?B?Vi9lTnNXSWtVSDlWbGoweUN5NW5qSmhyVkVnaXVBMjd4NFJVakJlOEh2UE9s?=
 =?utf-8?B?SjBDTWxmSDgybk4yZ2JYQ0NHeGV6Mk5jdVV2aDZmMzFqeHJZUEpCKy96eStT?=
 =?utf-8?B?OFUxRDBER3Q0WUFqK0diU25CYjk5STJucHI4Y1FRaUZLNFdjc3pFTDJRa2Ez?=
 =?utf-8?B?VTR0d1l2RSttVDRTc09TYXRvcU80ck5IS3VIbWcxRzFMUHFNaWdMcy9GdlBy?=
 =?utf-8?B?cTlnK01JbWtKbFRWaURxV1F5Qloya0dRRkRPR3dyZGw4S2tmMkxGUEpWdkcw?=
 =?utf-8?B?TGVhK25MVFVoK2FYRC8rRXlVQ25HY29nWTJhVUUyOS9QeGlkQURldk5LUjdH?=
 =?utf-8?B?MDVPeWVpblpCOFlFWjZBVkVUbzZPQzE3SUllcnFJYkFvRHdIU3RpZm5Lcm5y?=
 =?utf-8?B?QVl4TS9CWEFJSW1rUytVUENpVzZhV0x4cnpQbllOL1ozcXdxK2FEVWF0Z08x?=
 =?utf-8?B?cmsrOFZqSUVhQmJCS2Zabm9VaDEvWE1YaGhNR2VSUjN4Z2xCbFhQSkIrcTZk?=
 =?utf-8?B?cUw3YkVwTW1JelVKZUp6SGtYVGFwUUwwUjFTTG1Jd0NxL0E5aksrZlJ2ekN6?=
 =?utf-8?B?bDBEaEVCOC95eTFpVmQydWRJLzBodzhubmRnb21GK3lPbVBXeE92RFRiQUpF?=
 =?utf-8?B?Q1RzVFBsdEUyc3NJc1dKM0UxTnlVVU41b0VTYTJjYkxDeUJmOGtjNWc3ODky?=
 =?utf-8?B?bUFtMmdERUJqdjNua2tzSG5Md3pQVGJnbEpkY3N2dzVOZzl0NUxmak5Mb01a?=
 =?utf-8?B?K2UvV0hyQVRDY3dFbnU3QjFEVUZKMmpKQXl1Yzh3aXZrSXJLT2Y2ck15MzBI?=
 =?utf-8?B?MGUrK2c0Q08xZHYzRHVvYUJKSk5HaS82QkEvY1R6eVphbDhBaWNPc3BzaHNP?=
 =?utf-8?B?ZXlYMlRiVEtVZGpNNHkwZktrUUp4dS9wQUpzTy9hQTZHTHppajVXUnFleFA4?=
 =?utf-8?B?MVRSNHBRdUhWRXNWRm9KaURCQUdOQmo1T0gwZUY5MFlVVTh2YWJKRlJyb2N5?=
 =?utf-8?B?UCtiYzkwK0phUmhPTUoxdXhaOWJqbEx4UEJVQ3ZMTmwwKzFJRVppRUNXWkEx?=
 =?utf-8?B?Wi9neVA1YjRFaVVEdUxoTkZRSXZXSVFKWVp0NXI2VUEyK2FiM3R0U3VXWSti?=
 =?utf-8?B?ci9hRDJNZGpEbFVLeU9JT2hkcjZsUkIzblUzZERNaWttckVteUVvRzdjZVFs?=
 =?utf-8?B?ZXRQVitpaTFteXhqQkFWNUw5L0ZMbndCQS85bGVaQjIwWlhDbWdQQXFhZ0NZ?=
 =?utf-8?B?dnFaRG1aT09OSzdON2s4MW1FUWJGWWZxemVaTGhEbVRiNUtBM0tiYjY4NHJv?=
 =?utf-8?B?SHpJTmpRcW9SdEpibFdYOVpmVzBpWHRqNS82UmdJSWZETEJoNVpYelZYU1NC?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nZQPWz2Uf3N7fJuFXWCmyIuT7d/Rn/Y6jfhUrqWN/9fo/v8B3O6HEHmp2g56VmdvlZ+bGcIpfXxypoL04OSZyiZqTfhakVme9038eQWqxL0rECXo719ZifsYnIx/RSegZsw6jqJonCH16gr4PXevN1JiIl4r8s8/K4s9NE02YldyESuz19YNNTOeEwgVNLsNYztA8g0lvAQcpeETGptKM8ZPiA5tfkv5jZvRBDC7V13HfJc6IFjaMUF6sZCZY8chpW62hijxZ7cUF+H35iJ520kekisj4NeQE3xzqLN81IdF76QwfcnRpiYzpe15mefttyQIYaCkE3GwHAPet8gEtYo/3bvjJafU6YWjmWHvMU4yK7lUmIAB5pUcrjpilDPQGG6nigHTqXXtpIL0nLJpsw9EytXXBt5epaneSoaaXSFH0DnvLpGwBSS75IaZeYZ92Nq92rjuR3NJXJ84Xalq6INU/X9qA7914saXjYTCVmyxKqpn/fWJ20Wcih65LWyMYw7Gp1krfVPSV+alfBNv1hpGxh+IFZPvYG10dCUw/LKeMYCfmP5GAkax9uTlKIGiaQPsXjbEYl8MlBaQvwy8c6NKetGMRHDLfzvnXD/qn9umd5oBabpYjvKHE0bti9+Lpu9z21QtcNMg151EaVGf7fn+kz01PlkhT2a9Zw5kgHyEeWaYXwJZGPVlsNQ0P1lx6ojEdKVp7XpLRFm8WFe6uv3aC+ryX/v4vaR80O5ABw8E4cTVXslZs7MbhQ1CjjFQDBq6yn2/Mu4JS4s1iaNEGNJjQo7PhqAZY8fQ/0N3JINSq901Y7Aiwo68Pg8ylvJH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772be3f7-1f3b-4179-686a-08db56fd323b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 17:36:07.4981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bg8LN7TRMkQZ2bysOqY0TENoPlP3atftq7NQdyPdByIONw7n4LVMxxQ72Oa6UfgYZ9FzhhwyXAF0Sfg0WqDiUrL8H8zfQGDqeY3Nj3QzVko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170144
X-Proofpoint-GUID: 8SY3kzlxT7EIXG_FpWPy4IaeHiIvm1d2
X-Proofpoint-ORIG-GUID: 8SY3kzlxT7EIXG_FpWPy4IaeHiIvm1d2
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/2023 12:12 PM, Jason Gunthorpe wrote:
> On Wed, Dec 07, 2022 at 09:26:33AM -0500, Steven Sistare wrote:
>>> This flag should probably be marked reserved.
>>>
>>> Should we consider this separately for v6.2?
>>
>> Ideally I would like all kernels to support either the old or new vaddr interface.
>> If iommufd + vfio compat does not make 6.2, then I prefer not to delete the old
>> interface separately.
>>
>>> For the remainder, the long term plan is to move to iommufd, so any new
>>> feature of type1 would need equivalent support in iommufd.  Thanks,
>>
>> Sure.  I will study iommufd and make a proposal.
>>
>> Will you review these patches as is to give feedback on the approach?
>>
>> If I show that iommufd and the vfio compat layer can support these interfaces,
>> are you open to accepting these in v6.2 if iommufd is still a ways off? I see 
>> iommufd in qemu-next, but not the compat layer.
> 
> What happened to this? I still haven't seen iommufd support for this?

Hi Jason, other work has kept me busy, but it's on my todo list.
I will get to it soon. 

- Steve 
