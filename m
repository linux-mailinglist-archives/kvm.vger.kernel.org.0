Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165BF7D09AF
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376407AbjJTHqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjJTHp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:45:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8FBE8;
        Fri, 20 Oct 2023 00:45:56 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39K6mm87012803;
        Fri, 20 Oct 2023 07:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=k8qJvbzpBYtBkzvFJSaC2lFz6t6HLF04RqwUfTE7XG8=;
 b=Dox3yd1ZqD4muHQr3SPIr0NboWEHy7dQQyiVS1SB0irVNulc2tgmM3hfuShEvQXxL4Jf
 XgHyWTad+J/sZVvJguZd8/v+6Yvt5Dk3pfyZ+qoTx0BEMI4MfM9VwEReAasC2/DZFgf7
 U5DIw7LN3Duu+FbzmU1cVq6dDDZqDSpx//87dlTuh91t1wcCqLZ70WLto1mB5P1s4bxA
 Z/9JE+eIUpVWk9w5OGXNP8xIvu+3xt6iDIwxc+QWEqKk/nww2yH3G7ZfI7Qb6V3E7BoK
 2ZZOL7N7pprE81WaB4dcks5usRtYiJfSXD/tUEv6Z9PhgR7biAt1TQ2HzXJUQ8Os9ZXw HA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwd8wcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 07:45:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39K5jIam038704;
        Fri, 20 Oct 2023 07:45:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw4g99d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 07:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMTu9iEOOA+7ReYQhSYOKnhPgIQcaIvRjaUp8YkLzusUQ/KFk0FUupUjIZLl+N/u8KPWjdvN1IJOLnXc5E28/HfbqCtP6sYrwiwg4+w4roSAxeGAgHKuoR+e3G8/uD1TI9/RrkLLAcwj7ABlP+BQcBQ4QSCJnFiMvuSay92nbHu79jSTkqH9WNzIg9npBNtHHhMC7zKu29rpe6ifbfJHglyphRZER30b0IHOu3BYaiKuFlZXD1X5uC5exil6vqWHWoebBtf0wt8w/Tic8yP4kyLgLEW/T4St1oiji/RG2ZDGHQioCV0jmTKCPFMtyIT/vIQu7WgQleM1pR/XjOBW9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8qJvbzpBYtBkzvFJSaC2lFz6t6HLF04RqwUfTE7XG8=;
 b=adRGM9239Q7z6F8vqY4OdK7wmS+VPhpnE9WTYxKGQeNq995gyef76iJxj1IbEMqcw363atluHbbv4ttVyTvLyeq9NaQY6rnwW1IDmJSszfqb4XOvUowEnVuxtRlE7OkanODxkz4keXL2aUffSNM/HWcsI4H8A4saHjEzxwKVu2NMkvdb7IvapSKp9DgQXWt9sOyo+K9wOMfqKqmFFT8u3zSG5emJDFMFCMEN20MZ8OQ8B++OD5iYFyZ7o174HbvY65vx++qcsLOuhvkdh72tzbi7ZW6SWJ4Pr6pY/NV6tSm6Nin6iOdtWw/dQZHBOrSabMm86cWpdElfM/Nd2eu4TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8qJvbzpBYtBkzvFJSaC2lFz6t6HLF04RqwUfTE7XG8=;
 b=YxZ1wskLQM6CGzsVk6JMhmygEP7OzD7pFvMngvGplL3RFIf+lMVpsNJBm9OpSLSwU+RdjzrAuO5X6eKzGZLZRiAC4WMG8mujFc3ChYR/ewcv9W5HimtyBDWkb1snGexJN75jBdRpWEPXVIcBE3WnXk8PqvSdwl/l5smwEjZ2PWM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA1PR10MB6543.namprd10.prod.outlook.com (2603:10b6:806:2bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 07:45:42 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6907.022; Fri, 20 Oct 2023
 07:45:41 +0000
Message-ID: <e8002e94-33c5-617c-e951-42cd76666fad@oracle.com>
Date:   Fri, 20 Oct 2023 00:45:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: Don't unnecessarily force masterclock update on
 vCPU hotplug
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
References: <20231018195638.1898375-1-seanjc@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20231018195638.1898375-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:208:23a::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA1PR10MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 206d9516-9f04-4acc-316b-08dbd1408f40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPKLvvKEL9StgmtttfHQo2OeMGEwQWFnJ3lcrAE2e24jW3Lr71um/zTZdfH7NJ4+oQgOo97Np1X4CaMZ2xDmKHdRfB//JdTGXguvi/sJdjNZZ2b/Hej10waVMpyHB61ZT/eWCALd0llfxlhmPRH2esAvTSe9EXUE31hxVFPbNvbTIW/i0fkEEZyaNzL2IdxHo2fzW5rvzy+kzV5ftgXF324/1nWF6KfcTOJKubeLEveS4W0yNdSDqOW5CeK111pN4PD3Ca/n970YhSz4dzOXbTFOHxrV7kZVKXDRyBbmSp0TeHD1sH7OvVbicM4MknldjgzZztRKrXxQ9XkbIYXjtpvOB6f0GtLKWh5tdSc8o912+EwM5m87Y5nEPXuDLuCVfFpRVXjmApvBKHnKnr4iz9V28VKzlHK4nXqhLROCk2OYlq6CGIB8L+QnTGvSdHDnKyuiacaZ6aOJYqxBrvrVPBNxOZsVZmAmiboKW0bF1lL2AZ2nh9h7Od8576+cdCizLpewXAnL7632ytRC4+djG+nSaACoNB88XUEM8iejx45CPDQa6hBbZDrDjrlyi8KzmY8BJ5hXJL3Gw/BHA+cfVi8+0b08iKYFlGiUWS5yGBie5mb7MBJaIMaxcKfUEI9bRDBL0sFLxq4rjxdYOWLDwcZfa1lSLZOSH2Vlk/Ma/dc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(136003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38100700002)(31696002)(86362001)(66476007)(66556008)(110136005)(66946007)(6486002)(966005)(6506007)(26005)(478600001)(6512007)(2616005)(83380400001)(6666004)(53546011)(5660300002)(36756003)(44832011)(41300700001)(316002)(8936002)(8676002)(4326008)(2906002)(30864003)(31686004)(15650500001)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVFlekI1NHBTUmlCM2NITTM2U0NlY1pyVXpjeDU5ZTE0bVdYUldHZy9BWFhz?=
 =?utf-8?B?cEt1MGx2RWZzMDkxOTRON3ZTVGcwVWVmT0pQVmFqa1lWSVVncHh5U0JOVmhB?=
 =?utf-8?B?aW1zWmhDSHpLMFdJSUtSOHNBZmFVOVZBc09GOHJqb3duNUdwbHNOYkRzTXN3?=
 =?utf-8?B?Y2pnendDQkhzZ0p5U3ByUjJJZlpaeGNLVHhDN2Z0ZnBNVkpVam05eTllZWla?=
 =?utf-8?B?T09CUjdWelVsQUFqTFZoeHBNcW5sK1g4dTBkYjJpZ3VDd3VSZnNCYzEwMFF0?=
 =?utf-8?B?ZlV4eTlTeUc2S3pWOHdCb3BGSC9XZ1FhOHU0STkwUGdJM0NMZTM2STdNdkl4?=
 =?utf-8?B?djFDTElBc1BoUCtod3N6TmtPckJtbG5TVkdFUy9WWSt3UWVrUHNESjBKeW54?=
 =?utf-8?B?WFh4eUlqTzN0cEl4ay9GR3pKSHJUQkZZWTlSc1I2b3JxZWZGenRQYncyU1JP?=
 =?utf-8?B?UHRPU3Z0ZG5uYmQrdTJtWVBDZWR3eHcyVHUyOGNsNUk5QVBDU2JYSTNuanR3?=
 =?utf-8?B?aUxTTE9BbnFLWG5qbUc3MWVubDRjMmtWYVFTeUUvRjNFNWUzUVpqUkdNYjRm?=
 =?utf-8?B?bXZOV2JPTkRwWEswTVppT2FBelpwZDVVbm1zMHh0ZERmU20wVmpzdlVhQU16?=
 =?utf-8?B?L1VkMDQ0WFhYOENkbUJGM0tqYXB3RFJSNEx0YThheWFSbWNCclE0bFhhK0Vu?=
 =?utf-8?B?N2RmY2xML29FNXQ1RzEzVklqNkZqOVM1M1ZBTG9YNXlPeWtxUkdQOUNyb1Iw?=
 =?utf-8?B?RngzR1dKWlErRWF6aGlaOW4vb0cxZEdjY25NK0tsRURLZE4rKzFSWHo4WjhD?=
 =?utf-8?B?VHZlRVNEeHdURTUwK05uekJ6S2NsRGx5TkM1bkFaOVJrTjN4VGRSdEVIK0xj?=
 =?utf-8?B?RjMwWk9zSDJxWno4aEZKL3JrS01JY0hrcU1vYkhDMGhGVVk1ek5ITVRmYS9Q?=
 =?utf-8?B?Wi9IWVA4WE1ocjB4NHZyYTIzaHhZcHpCR3VsS2JFcXNHNTZmZ2ZnUExjUEtt?=
 =?utf-8?B?R0lDTjlDYXIvUHFOOUhhYkpYZjc1SnNuTE14YmlYa0kzSHF1bzRYUGRHOHJM?=
 =?utf-8?B?Y0hNajlnVEFVUzJzdFRwYUkvYWRCQ2FhNWFFTnFqa3hXY2NyZXNSeWtYK2tP?=
 =?utf-8?B?YXdwTlcxMG9aRXRTVG9uV1ZIMVRLcmlQWVNPYTFkSmFVZU1VOWxkRW40M0RR?=
 =?utf-8?B?K3dKeFIzdTVnZjhTNHgydk03ODlJSjE4dUI5L1BtMXpNdWZPdjcvQXdkRWNw?=
 =?utf-8?B?dUZYRmRpVWdYUUVrU0NKMVVSY1UzRVBPTEFiUmM1SW5vOEk5MXA4b0VobzBa?=
 =?utf-8?B?NGN6RUJ3Y2JTVVFYZVRNSFMvMVhhekgvYWE5QmJMRnVNalVBdnMzeTVpUTFF?=
 =?utf-8?B?WlA2WTk1L01BM2wxS3hTaGFMS0YyYnYycHJOQmdSZXp0cmpkVy9CWFh1c0x4?=
 =?utf-8?B?elhaSURqajl3dGhkZXdjMVJPcnIzWUM1WE5UelhvL0tSNnRnMnlzaGdIcmI0?=
 =?utf-8?B?ai9tMENlVEZwZzZJWGFTdEphUkxqM2JXOE42YXg5blBxR3FMY25QYnlZRnMy?=
 =?utf-8?B?R29LV2ZjTG9pL2FuYjdvUGg1YzRZTFBXK2o5RldUSGNrVlZFeUNsY1hIQUdU?=
 =?utf-8?B?RHBwODFwTmdRZEdDdC9wSXBGank3ZUZ5OVVBZzdKcTV4ZU8wdUVFbkZqZmdZ?=
 =?utf-8?B?bzhEaTUzWDRhcnpFczlJcDI3OVZYaHd3TzcxOTdGa0JvdFNGN0lacTBIczhr?=
 =?utf-8?B?a2lYNUM1YXJ3bzA2ei9YZ3hlM2xWZXNwc1dSVS85blJyWUsyZi9MZFUrKzBL?=
 =?utf-8?B?dWJ4QzdNMEY0OEdSQVo0VzJaanZKdDgyQnAwMGpZVzF2YTRJYVlkQ21Vek9G?=
 =?utf-8?B?SWtUZVp2UGJGVTYwMVlPaTFwNU9hWTRvRUZhNEpFQzlKR2djZlFJWHBDSHhp?=
 =?utf-8?B?M3N0YnV2aU1wUTNhcXBObFl1SlAzMEtJOEU3UXhsVGtuakNoL3NJRDNUUXRo?=
 =?utf-8?B?bUVVOG5WWHI0dGlXNVVjdjJQRHdTczlzNytYYlhLaHRTZjgyN2FlQ2lZc05E?=
 =?utf-8?B?N0lQRk1HZEF6b1ZkYnZ6UXU3ZWpXZm1UenJOa0NMUjkrd0ppRHpLcURrVWZ0?=
 =?utf-8?Q?40smT+sdOMQDJUQke77gp2qgK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D7ej4aDseTWf5M8z8bichj+VyfqtEyonojP8WTh0ikdFlL6b5rkzLjCGeV616lHgGxP/lIBhM1vTWi2D7Ee6tW+5pwf5vq8wC2S6a1SsGWGq2aZZvy3aeXeQDp54VB1gHBOcs5sW9XRdoj8ZFVuVyaLx+WYkXnHJoHh4uaEKaeRgk2nQxOJBdIpjCaH0dNR1MTNb9+p8ftc1MOcv2gnZk3DE8V1KJG4Edj4V2gsFRMfrsOq/qHdT5hWBQoPNXx5Fw0Ed5OtCYf5mqbdlZX5NQotd8BCH4lez2hKkq4u6OKnORM7raQzFxpautsYKSHQ//JUz1VXjZVg+PctvbIPAVkFFRkCeDtgTXl6sZKk2jxzyXdoWrgUM0XBCAYuqsMtntcxRnm9OwU/2ghtpK2i0FXYfd6fl/r+fD6SlpyuF/jDHq6fXeb1YQCQePHalplgzDAiZclnI0KmiGsOL6TCZxM6JYUDwb9vozbJFMzjArfBIcCZSFsGYnNj5SvnmUvxh2AZkRTH7FlnplsuvUT1XmodVKyewgK28S1qHC59IDle+SVPYsokqe4SD2dLjJtvzg4umMVBDFgt1x3KOH+hPlU2pufWmt21vtSyaNWy77dw1AgdPfc2R2SWu9A0/olRxXOAS3ogQ+8dCHs9YaSbXJQ4liIHMIZGRZyabXiVws6FkMORIiBhHgQDtMLasE24jB86m8ulZ9GkNwSW28gn6cMCM9I8wufe8yoTWyOd0qBu6imjqw7DdHGE29afL8H4pofDvkZXQeLQCmGadDjY2+jwtS+CProyvZJZzuM2lTJcJUO9dMXPaoSd8/qmFFFGNLlVVMCVVnW1/nGt/GuTEDiWTrvoSLWmayM2TTp/8f0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206d9516-9f04-4acc-316b-08dbd1408f40
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 07:45:41.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5Pv7m7vptJbIRqsQ1b0bGl9zbI8DDNnNLDlYZN0aRs6/Y7f+AJu+a+QeE6h+C84gBcqiKm2R4hgP2BnG3sfnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_06,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200064
X-Proofpoint-ORIG-GUID: G46T9CGCsfwU9I_ca8xgKrDi-En7jeLP
X-Proofpoint-GUID: G46T9CGCsfwU9I_ca8xgKrDi-En7jeLP
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Dongli Zhang <dongli.zhang@oracle.com>


I did the test with below KVM patch, to calculate the kvmclock at the hypervisor
side.

---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c47b4..9ddc437 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3068,6 +3068,11 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u64 tsc_timestamp, host_tsc;
 	u8 pvclock_flags;
 	bool use_master_clock;
+	struct pvclock_vcpu_time_info old_hv_clock;
+	u64 tsc, old_ns, new_ns, diff;
+	bool backward;
+
+	memcpy(&old_hv_clock, &vcpu->hv_clock, sizeof(old_hv_clock));

 	kernel_ns = 0;
 	host_tsc = 0;
@@ -3144,6 +3149,25 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)

 	vcpu->hv_clock.flags = pvclock_flags;

+	tsc = rdtsc();
+	tsc = kvm_read_l1_tsc(v, tsc);
+	old_ns = __pvclock_read_cycles(&old_hv_clock, tsc);
+	new_ns = __pvclock_read_cycles(&vcpu->hv_clock, tsc);
+	if (old_ns > new_ns) {
+		backward = true;
+		diff = old_ns - new_ns;
+	} else {
+		backward = false;
+		diff = new_ns - old_ns;
+	}
+	pr_alert("orabug: kvm_guest_time_update() vcpu=%d, tsc=%llu, backward=%d,
diff=%llu, old_ns=%llu, new_ns=%llu\n"
+		 "old (%u, %llu, %llu, %u, %d, %u), new (%u, %llu, %llu, %u, %d, %u)",
+		 v->vcpu_id, tsc, backward, diff, old_ns, new_ns,
+		 old_hv_clock.version, old_hv_clock.tsc_timestamp, old_hv_clock.system_time,
+		 old_hv_clock.tsc_to_system_mul, old_hv_clock.tsc_shift, old_hv_clock.flags,
+		 vcpu->hv_clock.version, vcpu->hv_clock.tsc_timestamp,
vcpu->hv_clock.system_time,
+		 vcpu->hv_clock.tsc_to_system_mul, vcpu->hv_clock.tsc_shift,
vcpu->hv_clock.flags);
+
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
 	if (vcpu->xen.vcpu_info_cache.active)
--

Dongli Zhang

On 10/18/23 12:56, Sean Christopherson wrote:
> Don't force a masterclock update when a vCPU synchronizes to the current
> TSC generation, e.g. when userspace hotplugs a pre-created vCPU into the
> VM.  Unnecessarily updating the masterclock is undesirable as it can cause
> kvmclock's time to jump, which is particularly painful on systems with a
> stable TSC as kvmclock _should_ be fully reliable on such systems.
> 
> The unexpected time jumps are due to differences in the TSC=>nanoseconds
> conversion algorithms between kvmclock and the host's CLOCK_MONOTONIC_RAW
> (the pvclock algorithm is inherently lossy).  When updating the
> masterclock, KVM refreshes the "base", i.e. moves the elapsed time since
> the last update from the kvmclock/pvclock algorithm to the
> CLOCK_MONOTONIC_RAW algorithm.  Synchronizing kvmclock with
> CLOCK_MONOTONIC_RAW is the lesser of evils when the TSC is unstable, but
> adds no real value when the TSC is stable.
> 
> Prior to commit 7f187922ddf6 ("KVM: x86: update masterclock values on TSC
> writes"), KVM did NOT force an update when synchronizing a vCPU to the
> current generation.
> 
>   commit 7f187922ddf6b67f2999a76dcb71663097b75497
>   Author: Marcelo Tosatti <mtosatti@redhat.com>
>   Date:   Tue Nov 4 21:30:44 2014 -0200
> 
>     KVM: x86: update masterclock values on TSC writes
> 
>     When the guest writes to the TSC, the masterclock TSC copy must be
>     updated as well along with the TSC_OFFSET update, otherwise a negative
>     tsc_timestamp is calculated at kvm_guest_time_update.
> 
>     Once "if (!vcpus_matched && ka->use_master_clock)" is simplified to
>     "if (ka->use_master_clock)", the corresponding "if (!ka->use_master_clock)"
>     becomes redundant, so remove the do_request boolean and collapse
>     everything into a single condition.
> 
> Before that, KVM only re-synced the masterclock if the masterclock was
> enabled or disabled  Note, at the time of the above commit, VMX
> synchronized TSC on *guest* writes to MSR_IA32_TSC:
> 
>         case MSR_IA32_TSC:
>                 kvm_write_tsc(vcpu, msr_info);
>                 break;
> 
> which is why the changelog specifically says "guest writes", but the bug
> that was being fixed wasn't unique to guest write, i.e. a TSC write from
> the host would suffer the same problem.
> 
> So even though KVM stopped synchronizing on guest writes as of commit
> 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on guest
> writes"), simply reverting commit 7f187922ddf6 is not an option.  Figuring
> out how a negative tsc_timestamp could be computed requires a bit more
> sleuthing.
> 
> In kvm_write_tsc() (at the time), except for KVM's "less than 1 second"
> hack, KVM snapshotted the vCPU's current TSC *and* the current time in
> nanoseconds, where kvm->arch.cur_tsc_nsec is the current host kernel time
> in nanoseconds:
> 
>         ns = get_kernel_ns();
> 
>         ...
> 
>         if (usdiff < USEC_PER_SEC &&
>             vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
>                 ...
>         } else {
>                 /*
>                  * We split periods of matched TSC writes into generations.
>                  * For each generation, we track the original measured
>                  * nanosecond time, offset, and write, so if TSCs are in
>                  * sync, we can match exact offset, and if not, we can match
>                  * exact software computation in compute_guest_tsc()
>                  *
>                  * These values are tracked in kvm->arch.cur_xxx variables.
>                  */
>                 kvm->arch.cur_tsc_generation++;
>                 kvm->arch.cur_tsc_nsec = ns;
>                 kvm->arch.cur_tsc_write = data;
>                 kvm->arch.cur_tsc_offset = offset;
>                 matched = false;
>                 pr_debug("kvm: new tsc generation %llu, clock %llu\n",
>                          kvm->arch.cur_tsc_generation, data);
>         }
> 
>         ...
> 
>         /* Keep track of which generation this VCPU has synchronized to */
>         vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
>         vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>         vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
> 
> Note that the above creates a new generation and sets "matched" to false!
> But because kvm_track_tsc_matching() looks for matched+1, i.e. doesn't
> require the vCPU that creates the new generation to match itself, KVM
> would immediately compute vcpus_matched as true for VMs with a single vCPU.
> As a result, KVM would skip the masterlock update, even though a new TSC
> generation was created:
> 
>         vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
>                          atomic_read(&vcpu->kvm->online_vcpus));
> 
>         if (vcpus_matched && gtod->clock.vclock_mode == VCLOCK_TSC)
>                 if (!ka->use_master_clock)
>                         do_request = 1;
> 
>         if (!vcpus_matched && ka->use_master_clock)
>                         do_request = 1;
> 
>         if (do_request)
>                 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> 
> On hardware without TSC scaling support, vcpu->tsc_catchup is set to true
> if the guest TSC frequency is faster than the host TSC frequency, even if
> the TSC is otherwise stable.  And for that mode, kvm_guest_time_update(),
> by way of compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the
> kernel time at the last TSC write, to compute the guest TSC relative to
> kernel time:
> 
>   static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
>   {
>         u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
>                                       vcpu->arch.virtual_tsc_mult,
>                                       vcpu->arch.virtual_tsc_shift);
>         tsc += vcpu->arch.this_tsc_write;
>         return tsc;
>   }
> 
> Except the "kernel_ns" passed to compute_guest_tsc() isn't the current
> kernel time, it's the masterclock snapshot!
> 
>         spin_lock(&ka->pvclock_gtod_sync_lock);
>         use_master_clock = ka->use_master_clock;
>         if (use_master_clock) {
>                 host_tsc = ka->master_cycle_now;
>                 kernel_ns = ka->master_kernel_ns;
>         }
>         spin_unlock(&ka->pvclock_gtod_sync_lock);
> 
>         if (vcpu->tsc_catchup) {
>                 u64 tsc = compute_guest_tsc(v, kernel_ns);
>                 if (tsc > tsc_timestamp) {
>                         adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
>                         tsc_timestamp = tsc;
>                 }
>         }
> 
> And so when KVM skips the masterclock update after a TSC write, i.e. after
> a new TSC generation is started, the "kernel_ns-vcpu->arch.this_tsc_nsec"
> is *guaranteed* to generate a negative value, because this_tsc_nsec was
> captured after ka->master_kernel_ns.
> 
> Forcing a masterclock update essentially fudged around that problem, but
> in a heavy handed way that introduced undesirable side effects, i.e.
> unnecessarily forces a masterclock update when a new vCPU joins the party
> via hotplug.
> 
> Note, KVM forces masterclock updates in other weird ways that are also
> likely unnecessary, e.g. when establishing a new Xen shared info page and
> when userspace creates a brand new vCPU.  But the Xen thing is firmly a
> separate mess, and there are no known userspace VMMs that utilize kvmclock
> *and* create new vCPUs after the VM is up and running.  I.e. the other
> issues are future problems.
> 
> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> Closes: https://urldefense.com/v3/__https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com__;!!ACWV5N9M2RV99hQ!N3CdrL7gBde6tjlPxmd0cuqYCaVI4VGrvIqGX5I5pNx-cL_srMa6VuXUwrFXAA7nMgPXRvzndIOCkz-r1w$ 
> Fixes: 7f187922ddf6 ("KVM: x86: update masterclock values on TSC writes")
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 530d4bc2259b..61bdb6c1d000 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
>  }
>  #endif
>  
> -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
> +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
>  {
>  #ifdef CONFIG_X86_64
> -	bool vcpus_matched;
>  	struct kvm_arch *ka = &vcpu->kvm->arch;
>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>  
> -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
> -			 atomic_read(&vcpu->kvm->online_vcpus));
> +	/*
> +	 * To use the masterclock, the host clocksource must be based on TSC
> +	 * and all vCPUs must have matching TSCs.  Note, the count for matching
> +	 * vCPUs doesn't include the reference vCPU, hence "+1".
> +	 */
> +	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
> +				 atomic_read(&vcpu->kvm->online_vcpus)) &&
> +				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
>  
>  	/*
> -	 * Once the masterclock is enabled, always perform request in
> -	 * order to update it.
> -	 *
> -	 * In order to enable masterclock, the host clocksource must be TSC
> -	 * and the vcpus need to have matched TSCs.  When that happens,
> -	 * perform request to enable masterclock.
> +	 * Request a masterclock update if the masterclock needs to be toggled
> +	 * on/off, or when starting a new generation and the masterclock is
> +	 * enabled (compute_guest_tsc() requires the masterclock snapshot to be
> +	 * taken _after_ the new generation is created).
>  	 */
> -	if (ka->use_master_clock ||
> -	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
> +	if ((ka->use_master_clock && new_generation) ||
> +	    (ka->use_master_clock != use_master_clock))
>  		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>  
>  	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
> @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>  
> -	kvm_track_tsc_matching(vcpu);
> +	kvm_track_tsc_matching(vcpu, !matched);
>  }
>  
>  static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
> 
> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
