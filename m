Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BAB64D0D1
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiLNUMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLNULy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:11:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AB72D1FE
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:03:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHFXHp026519;
        Wed, 14 Dec 2022 20:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LLXD16+tkljAVdh0L5CBH7JWW62EVTiPG2suqGbwV3E=;
 b=kt2w9noSz27sG4i1ChI8ADlUdRteeF1Xn1AXHfcLNI7Y3yeRJG+DvgrGGS8+OEWqy2Bv
 D0oQC8GwxV9oHz/ofh+AHI6nEuZLu8jv/hjQOafEtNFSxoyiOH+z846YvceVaJr5vi3D
 aRjzpV1NzE1JcUFRCZMVCJuSbr1g6ud+nPFIdybKaptjOo3VlXK7ofyRtjvyzHPPlyWS
 91jPZfAC1EK/a+lJXLCtftZkQ4Y7An68RlwVEIETgqWNICi3KPHBIzZhTGec7VX3IMet
 ngXZc9dgfFC7D8U+ETyivitxLw+AUoto+f/IbtsyQz1LoP41jrUMsFUzCs/X01ciYe7T BQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewb83j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:03:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEJ6a6r018805;
        Wed, 14 Dec 2022 20:03:31 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqk2ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQWBHrbYM3t02g+5Av3AI7xc7MrJfOnK32Ms8U6MjtBJWH7bA/BOVJZ8a5BE7CCnZQZHyvQXa60JoS24Nlmv/SoCMcdZfVf2wQRGuiVllTk+0ymVRqhAH8hkpm9o8yYUJXHphjmIVmnJ8HFlzXpQul3SNAH56fvtrnxEYjYL7wuvAy3GpJ990Y2J/Jkeql9MpmILL93TNAhd0Tmi9BjuBVZwUcB/VSj3Q17jNTFJFi0xoM3zVpY0JgUwiwCFj/Sj6cli7qPrF9sAed63mrDfXZmng1CqIQpZPS2xN+LTsUf/ZBNJDS6GmrZHIGNHPpUhQW2z4/aSutVsQmyM+MswTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLXD16+tkljAVdh0L5CBH7JWW62EVTiPG2suqGbwV3E=;
 b=WdQKXmeZcdlWb/k1oRpvXT3ZNjHcBR78lcho0g/mFK0zcbQk7I9HXUhC1u2JEfclJ9XzhDX2jIeeg8KEGGaBs4IKSbL098kkYwbMesL1Ugkvfnbor4F7i9iV8C8TrxGcX90guKnPlP85EU80/DI+YNeycKFYUww5z9s/a8Oz4dCEe1togVtETGxayspdz/b11m58BRwixNWb4baArLbAkvsXkwLYp4JO78sraDEVl42xF8ZEsajaoTQTOn8lubyDTgq49Rq9q6JrhH8nklsxjOxiV9tS2uyDX9WapfTBfzuvOjR8mRds9WV7mnxTF36a2UJJWOulDzM0IJ5k4o0Ykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLXD16+tkljAVdh0L5CBH7JWW62EVTiPG2suqGbwV3E=;
 b=NUPpu2kB9qc7xoMtlT9bFfzdewX1yr7/gPlwCMMn6swaHWk9Z8fuqaGQzOdyLSyUz/5yvtNCCbuK7g4wr54GhJzbjDU+gwpwuBFRtLsn4ugy+8tjjpB/MRCyHc/MwMsV0oj337HWNc54y1hV+4e2u+Ph7nQpB5+P3+J0PXLXC3U=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by IA1PR10MB7333.namprd10.prod.outlook.com (2603:10b6:208:3fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:03:29 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%5]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 20:03:29 +0000
Message-ID: <5a06aaea-cd53-01cb-bb4e-08a3a543fa6f@oracle.com>
Date:   Wed, 14 Dec 2022 15:03:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V3 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
 <1671045771-59788-2-git-send-email-steven.sistare@oracle.com>
 <20221214124015.36c1fd52.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221214124015.36c1fd52.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:5:333::12) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|IA1PR10MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 38682a9e-b3f1-4081-bcb2-08dade0e44e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ide2pIfjiGRh9cWGxXNch4/QLtpSddbhmeLuXv2qNsiV5PiNnZ/j4AEjW0uTyXilCwsBJzpxR69NYr7GJFFPTWM/MJAJVVNr60tATvudlpoFWK8I2XckTCJgK7TPf/PypomGtCYcYw3Doi1CVaI3jA5K5ywA+v4G/DDNRLs5q83JEcTKX3AYu+L6p40cUsTqm0GMleQW4ntuRQAASEkyQkm81PwTXytXkqINbH8fVTLOLmlOCdgpIm6zdq7mGm0Htp3VuhcKigR17cD8GYwgNv87v4F4krNULMSTHao1gafWY3oPTo0+UUf0GpJE6WonGGR2sMEP1ua8O5WVQtAEKtrMcYZOtiazG09CRehViDb94fs4fFtHn+wcpFkaoYhEwcqViqfpF6QWh6zGixWUoV0T5/4u9pS32OueobfpBZGtzk0avZQ2sqXvb6ioXpxdaFcZ7WNbely5wF8t1AMUlvPloV3bYI9X14cIHcClI2/X72BhrUgp3vkXlDvR2lnuudxZRTpgOD5YFc2Iz+4FPGWfm7rFDqCSDf6SERWwT8/v/A5OufmQLyAYdcftGpd0y762WItVeOfadncTplL0NwDQknzDAhYjfPfdvgxCxR1P/HS2/jgPpXH85VYyMTLUb4gFQGH6iQ3bdBbKFnHI4dt1WZjPekxbdbUPeYYEK9Q9swBNzWqj5VpNvYFypm0aDx9J5jarNqaffBFEmFemYW6JxMO6OQD+M8AxDQ+BmZw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(36756003)(41300700001)(8936002)(6666004)(478600001)(86362001)(36916002)(38100700002)(6486002)(31696002)(2616005)(53546011)(5660300002)(44832011)(66946007)(31686004)(186003)(6916009)(8676002)(4326008)(316002)(66556008)(6512007)(83380400001)(26005)(66476007)(6506007)(2906002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzY4RGZwT1JYenFjWE9DTjZMNll2R0NoSHNTb0dBUEpqTmVlK3M0dm94Zmht?=
 =?utf-8?B?M24wQWpOTHNPZFd6YXh0cm5iUnE4RU1RRmYyNHRCZS9qc2tXL1RzMHF2MWR6?=
 =?utf-8?B?UTdrZWJReXp5OUR6dXU3bFVwMWVuTzJlNFJqalpONSs0V1NPRkpNUGpud3Vw?=
 =?utf-8?B?b1lDRTQ1d2Zkd1A4U1g4R0ZuUmJtQk1UNmlWNElxTUs3YTZuZFNvbDlhemVO?=
 =?utf-8?B?Wk84NTYyczFwQ2t3OVdrNVJuVWFiTXJxUzM4THM2d1ZCdzJ3dXBXZ1FOQ0Zl?=
 =?utf-8?B?RG95NDY1blM5S0NDQlQ4QVlOYW9uenRHS1pZODlqR3hYUURheTg5czRFR1ky?=
 =?utf-8?B?NDFhNTBrQUVkaFRacjNxa1RzU3ROS1huMklwbzlwV3FKd2VNSXh0cE1NY29F?=
 =?utf-8?B?MjdOMUh1SXhVVFdXMVBFc1liLzRDT0pMRitZMENqejVQWExleUt4MmJmamxy?=
 =?utf-8?B?amxZOFNsMHVKUjlydkUvZi92NWxnZXJGOG8xSFVPTE01U2t4c1dJSFU3VUNS?=
 =?utf-8?B?cVNIS25YRkJuT1BBKzRnTmNhejlqYXdUWEM3UEx1aDk5Zm9ZNGFrNDNtZlk3?=
 =?utf-8?B?c2QxeUVzVGE0dnhtMlJzTndQUGgvTXVvaGdwK2pON1cyR0tCeWhWWW1rYTJ0?=
 =?utf-8?B?WjRTTE5IeGYwUzVIMWcvT1N3MzZFZytkZitVbThIZkgvUll2NGRnOFV6NVow?=
 =?utf-8?B?cGxhaHJoRGRBdngwa1RhYlB4SWFGYTIwcTIxNlRaYTdiaEtHUmdPUXRyeFFM?=
 =?utf-8?B?RkVKRCtlbWk5bmRHbGozeElUbWlVcW0xSGU1UFluTmR2dEpKYkJCdVFRWDBa?=
 =?utf-8?B?SjRrZXcrblZVQmVoczB6cytkS0VjSEpISExmZ0IvYnhicEFPbnk5SVdEZWFn?=
 =?utf-8?B?QzFXYXlwQkV3b3lpU3VJamtxbUdKbVllcnpjeXpvaVRCTUY4WkM3dFZXMGR4?=
 =?utf-8?B?QWNrd2lKMDhpajdjUDJZdi9CcWdRcmpkTjFZYVAzRUU3SVVMN0lCbmNIK0VF?=
 =?utf-8?B?OU5acytBbjY1bjRYamMvWUxtRG5XYzE1RFoxTFB1M0lqaU5GQTBsRzdKZW1B?=
 =?utf-8?B?UTk0ZHljR2E2dzZFRlZPVC82SmxJbmQ2MEM2T1ZXdlRhUkFsbENOLytOSVV2?=
 =?utf-8?B?MjkrRjBHUzB6TVE1YStEWDZvM3crR2hDRXFiQ1JMR1lDN1J4STVPakI0dVIr?=
 =?utf-8?B?cVEyTzRtbzlERmZBLy91alpVS0Z1SUJYTi9wUjE1VGFsVVVWWkZJUWljZC82?=
 =?utf-8?B?Qk5lQkZVelRIVWllSlJXK2tyUGttSHNmNjhseWVRcnVFTyt6OWdWSks4c2lZ?=
 =?utf-8?B?YTdtWDdCYS9yM3lYeWN0eVlpamVRbDZ2TDFxeU85cjV4SGZmWkR4UDA0M1Z0?=
 =?utf-8?B?WnQwaVdxa2djTStsai8vTjlBUGkzb25JTTNhdW5JVzdzWk9ObElFRVloVWFY?=
 =?utf-8?B?ZkxabXNIZk1tcHNxOEdrSkdhNm1kSFBvaEZWV092UHlvbEY3S2FPcCtBTXB2?=
 =?utf-8?B?YnhYb2IzNXFIbWluVXpJSE9UOTUxci9BYVpNV1RHWGFGeWVnaU5seGcxU1lT?=
 =?utf-8?B?eDhNQWVXM2JnNzQyRE9RTHpKSnBNQ0FvVXRqdkQ4NFpwYVZhRUc4MzVvaXRQ?=
 =?utf-8?B?L3dQOHBKRTkzRlczZE9UQXpGMWRCRFJ0T0V2UHZ3L0JEbDkxcXpldnJISWZr?=
 =?utf-8?B?c0o1Ym1jNzhzZVZuSTRGWDZTeTl5YTdFQUZ0N0FaRlQ3eVE3ZEszVUNjZ3NG?=
 =?utf-8?B?NlltaVF3eWRMVlNINy9nWDREQ0o0c2lQbml6RXVlbXVZTldSb3ZZNnREUjZ1?=
 =?utf-8?B?UURReDJxaVBjZmZoeVRLNHEvSHIvVmxSbnlQalh5clNjUW1LL1JRdzdtZ01w?=
 =?utf-8?B?dFJRdllESWZZTjBWbHJYUHJta3l3ZFVKQ1ZubG9lM0hxTWZXbkxmTTRnTnpD?=
 =?utf-8?B?UEJxdjVKMjdvWkY4a1U1VjI5MzhBak9JLzVwRE1UeUJrY2s3ZFFmdnFkSFhz?=
 =?utf-8?B?MkZEL1hZaEhnVnlaTWxFNHhqL2RhZG44a1FmSnBvOHQ1VlZOVG9wRklMV0hX?=
 =?utf-8?B?a3V5aVlmczZQZU5Ld0JNWTFURjdhNVNRQTVZZmRMYkxIVitLOVFKSis2R1dB?=
 =?utf-8?B?SmZrMEdGbVNLcndaT0k4SGx3bytoQmZMOW4ya1pZeUJtZFZHc29XQXNmVnB2?=
 =?utf-8?B?ZXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38682a9e-b3f1-4081-bcb2-08dade0e44e2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:03:29.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cn/qe5LY7V8Tx26GHpoTGQR0P8bDYWQs/J7bTL/N/4aW/Mm4OYjOaTg+jMOU05EsiZ6aCuwDyD59VsjAgu5Pog8dWw+8CsGEfO3Zyz/8dVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7333
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140163
X-Proofpoint-GUID: UKyVlRCd0giXDnrzEMPXf2HAv1m1iZPK
X-Proofpoint-ORIG-GUID: UKyVlRCd0giXDnrzEMPXf2HAv1m1iZPK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/2022 2:40 PM, Alex Williamson wrote:
> On Wed, 14 Dec 2022 11:22:47 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>> Their kernel threads could be blocked indefinitely by a misbehaving
>> userland while trying to pin/unpin pages while vaddrs are being updated.
>>
>> Do not allow groups to be added to the container while vaddr's are invalid,
>> so we never need to block user threads from pinning, and can delete the
>> vaddr-waiting code in a subsequent patch.
>>
>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 41 +++++++++++++++++++++++++++++++++++++++--
>>  include/uapi/linux/vfio.h       | 15 +++++++++------
>>  2 files changed, 48 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 23c24fe..b04f485 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	if (iommu->vaddr_invalid_count) {
>> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
>> +		ret = -EIO;
>> +		goto pin_done;
>> +	}
>> +
> 
> This simplifies to:
> 
> 	if (WARN_ONCE(iommu->vaddr_invalid_count,
> 		      "mdev not allowed	with VFIO_UPDATE_VADDR\n")) {
> 		ret = -EIO;
> 		goto pin_done;
> 	}

Will do, thanks.  It's a new idiom for me.

> I was sort of figuring this would be a -EPERM or -EBUSY, maybe even
> -EAGAIN, though perhaps it's academic which errno to return if we
> should never get here.

Not EAGAIN.  That implies they should retry, but we don't want them to keep
retrying until userland (never) remaps the vaddr.

EPERM is returned for other reasons, particularly in vfio_iommu_type1_dma_rw_chunk,
where we would like to return something unique for this condition. 

EBUSY sounds good, here and in the other locations.
 
>>  	/*
>>  	 * Wait for all necessary vaddr's to be valid so they can be used in
>>  	 * the main loop without dropping the lock, to avoid racing vs unmap.
>> @@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Cannot update vaddr if mdev is present. */
>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
>> +		ret = -EIO;
>> +		goto unlock;
>> +	}
>> +
> 
> On the other hand, this errno is reachable by the user, and I'm not
> sure -EIO is the best choice for a condition that's blocked due to use
> configuration.
>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>  	pgsize = (size_t)1 << pgshift;
>>  
>> @@ -2185,11 +2197,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  	struct iommu_domain_geometry *geo;
>>  	LIST_HEAD(iova_copy);
>>  	LIST_HEAD(group_resv_regions);
>> -	int ret = -EINVAL;
>> +	int ret = -EIO;
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
>> +	if (iommu->vaddr_invalid_count)
>> +		goto out_unlock;
>> +
> 
> Also user reachable, so should track if we pick another errno.
> 
>>  	/* Check for duplicates */
>> +	ret = -EINVAL;
>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>  		goto out_unlock;
>>  
>> @@ -2660,6 +2677,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>  	return ret;
>>  }
>>  
>> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
>> +{
>> +	int ret;
>> +
>> +	mutex_lock(&iommu->lock);
>> +	ret = !list_empty(&iommu->emulated_iommu_groups);
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
> 
> Nit, this could return bool.  

OK.

> I suppose it doesn't because the below
> returns int, but it seems we're already in the realm of creating a
> boolean value there.
> 
>> +
>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  					    unsigned long arg)
>>  {
>> @@ -2668,8 +2695,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>  	case VFIO_UNMAP_ALL:
>> -	case VFIO_UPDATE_VADDR:
>>  		return 1;
>> +	case VFIO_UPDATE_VADDR:
>> +		/*
>> +		 * Disable this feature if mdevs are present.  They cannot
>> +		 * safely pin/unpin while vaddrs are being updated.
>> +		 */
>> +		return iommu && !vfio_iommu_has_emulated(iommu);
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>>  			return 0;
>> @@ -3080,6 +3112,11 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>  	size_t offset;
>>  	int ret;
>>  
>> +	if (iommu->vaddr_invalid_count) {
>> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
>> +		return -EIO;
>> +	}
> 
> Same optimization above, but why are we letting the code iterate this
> multiple times in the _chunk function rather than testing once in the
> caller?  Thanks,

An oversight, I'll hoist it.

- Steve

>> +
>>  	*copied = 0;
>>  
>>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d7d8e09..4e8d344 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -49,7 +49,11 @@
>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>  #define VFIO_UNMAP_ALL			9
>>  
>> -/* Supports the vaddr flag for DMA map and unmap */
>> +/*
>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>> + * devices, so this capability is subject to change as groups are added or
>> + * removed.
>> + */
>>  #define VFIO_UPDATE_VADDR		10
>>  
>>  /*
>> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
>>   * Map process virtual addresses to IO virtual addresses using the
>>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
>>   *
>> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
>> - * unblock translation of host virtual addresses in the iova range.  The vaddr
>> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
>>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
>>   * maintain memory consistency within the user application, the updated vaddr
>>   * must address the same memory object as originally mapped.  Failure to do so
>> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>>   *
>>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>> - * cannot be combined with the get-dirty-bitmap flag.
>> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
>> + * Groups may not be added to the container while any addresses are invalid.
>> + * This cannot be combined with the get-dirty-bitmap flag.
>>   */
>>  struct vfio_iommu_type1_dma_unmap {
>>  	__u32	argsz;
> 
