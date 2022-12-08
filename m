Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA06475FD
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLHTJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLHTJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:09:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E1B862D6
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:09:52 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8HhwTW014452;
        Thu, 8 Dec 2022 19:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vWNoA68juWSV1OO7Mzg0AxhqP2XEWo/7pYf5VpG/sMg=;
 b=daN1+WK1ADBmf65iMbYqfYr9mY+pmCbtbYj5DMXS7YD8xbspFmyI4DOIm/x2NE/r2R6z
 SfVgaO2YCwus1kZjPDUj17fjcu/IhA8ABiiMY5zfE4C9DvNcPg++VuT/st7gx4I9Yon4
 PCIU5sBiZe/Mr4dNvg8k1yceVgSEHJp2Hj85YNfxhGT11Y0tEs6ueId09rpjv+WcMijT
 Ba7FfNOay1E6s+YBlHhPSDYOdtTNXQ2MQPik1qwWOvxyLwwyeOO/K7xRjVrlKqkHuDVz
 l98S5cvUdlHIU0+jkvdTBz/z3fhbrzFRFM0otq64+SYZ8+hsStXET/XQ56jAbjWj+iJ8 hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduuh7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 19:09:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8IOlA1036583;
        Thu, 8 Dec 2022 19:09:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6ber7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 19:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsHTT2zAaV1qn/VZzfTiaqmPsg6rqRvR7tRvMyK7zWvz6+XVfPOXFJz0/Z/bJpwPNSWAYfV4K725CS2b5xmXiyt9BidYrP6AX+rGTU6K7wTxLQD6ejvauA3jEezV1djCxmC9Qx0KpZmLfN9bsjOd1rOGi/WPVgDZ/YiR4Y4wbaUD08o0XhDYfQdZ/V+qDc+KoNKLVaDl7eIsxK7MrC2QZ7LpkBmvlAsdF8Pj4jprVhRvrQDE26IO25d1dkucs2jkgCinFcxrDNR0YYfxeuppKBUuLIml9idtGwrTZDhIc8B5OYSdegOAis2fd01GzmVWms9b/7cpcNS+Y/6tfHJZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWNoA68juWSV1OO7Mzg0AxhqP2XEWo/7pYf5VpG/sMg=;
 b=UaR+1XKG37rGtZCnwP+p6NNHmtGqzD4ObqmnbAwnylJEmI/wsNjDE4MGC/gA5qXgieB0iKaRP6fMPxsj0YlxPYSNGuMz1VqW3JpcSA+qgI132bQYJGxbaKlsADfKMjlZp6OEvnxGMxrc7Q94VXklBp2xCXQA67/Nj/3iErGqrn8riUduJYSjkL80fZiC2SLb71dPQxu9JGXFf9k2vITbvQ7V9R/ejJDyZGv2jNeHz6BrGmkA4FfbjEh3XKm1Ay+P9LGvqFq1dJrNUEdCeeGrKI8cJNjU5uqKMS+W4b7jIdUee7bwKQV3eq8SwceN+2t973D98TD4k8Z35sG62cXZOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWNoA68juWSV1OO7Mzg0AxhqP2XEWo/7pYf5VpG/sMg=;
 b=NsFDb8Git6QNnjBInDYHp0QyTrrUDQWFZsQvuBuyoO/CNRDVZMNACP8hPOxg5dgSqxOc/pp6JnesDxzyohW1OpcDr4IHnLRy7osFD0chw+FjNOBIYUSEDp2zykv1fi+DiouGtNmcPbYGAu1/CHEMohNkhoZuaqlzqqfkmn3YwoY=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DS7PR10MB5342.namprd10.prod.outlook.com (2603:10b6:5:3a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 19:09:47 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 19:09:47 +0000
Message-ID: <d215f5df-6668-8cfe-1564-2636b3260b8e@oracle.com>
Date:   Thu, 8 Dec 2022 14:09:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
 <20221206165232.2a822e52.alex.williamson@redhat.com>
 <Y5CvBZCyfNS1q7rn@ziepe.ca>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5CvBZCyfNS1q7rn@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:f2::16) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DS7PR10MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f6b8d0-6fb6-4e10-7c7d-08dad94fc5cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5//lWGw3cTpmERkeEztZM7rIrRa//RxZjW+ecIV3r9kWvgK7yLauO5BrBVbjoF78f9ZvEPh5iC0g19hQopeY303U7Lbp8NAWlvcconJIOFE0OBlo8wyTOaTNHoHw12HYoFoIGaEZ7V7zxbaxROjaOftt9yRzKDioG5CteqVlavbotmHZn7Gq2Yh9Hw+/WRxCGB1ti16bb/OoQgDzO2+uZdQLDKYX/ctc+ndwddlSRtski32wogmew1tHMXg8xnSAlX4zhgLqd0+sb4ZnU/r2wRzNp8PIu5GfhWYGGa2gbVaB6tOYDl+ACxSicr83nmdf0JTlgihujme87RGxkmiN72TEsiuogtWKkqnMLWzDnY0ptSJNa3oiOJqBgPAEjUKttHZr90jwr4z8/yb+qJbM1gMhagQUoLUQ/MVMM6yFU3E/J95QjNrnkd0FbLD9nxMZJ54jq1BumtUkRK/NUlGPxbcViE2qzDuWqAcgUbssUiMjphj64duY6rkW7r7yjsIGkU2LnHZTcSOHk3R+7TIkVtZj3ALbNX0VsHGIMrTynkgRRcvsgO+0SHsKprvJS7LH8Udr4LbWdh9YOo6MUgucMBYpDYPgzFZzmXhiXUmO2/ZkagN3sw7yM0wDGaGnYq60iiYnx4hggG6XKchSMpPRN/2foqXFuprGfbNFA9r/faCqSEig63U3Y4o8LHhcSv5JovfuPdF9XxR6rpzIb3egfbMm4hhsmBWYTLEG461IiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(86362001)(31686004)(36756003)(66946007)(66556008)(4326008)(8676002)(66476007)(44832011)(41300700001)(2906002)(15650500001)(83380400001)(38100700002)(2616005)(6486002)(36916002)(110136005)(316002)(31696002)(6506007)(5660300002)(478600001)(8936002)(6666004)(186003)(6512007)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFlTcDBxdWtaOVVVYUo3K2d6SHN5akYrM3BBSlFVcDE2TVl4bG5IcU5IWWx3?=
 =?utf-8?B?TXFIdktWWTBmaldVTzUvTTF3WHVQUEoyUkxVS1pJWENuSGt5RjRGME0rbXht?=
 =?utf-8?B?N1lCb1dhaHBQT2ozdCt2eCtVeGtWSEpScVFEaktpRTBIMlRHRCsvb3JxUWVK?=
 =?utf-8?B?U3R4dGxqU3p1b2h3NWU3Mmx0b3RwVncxM1B4RDJqYVgyZkczUlYwOGhUUDAy?=
 =?utf-8?B?SEgzdjBzSDlrNXJGMzVwYzNYdGtETWQ1bVV4SlBnanBLYUZHTXNvejZHVHBQ?=
 =?utf-8?B?RGhWWG5EWWV6NHV0eFlNY1d6VFA4djlRc2tWV3lxQ0VWeTV3dk1MeWRKTFRK?=
 =?utf-8?B?RWI0Z00xS2ZiWTQyaDY1ancrTm1vOGd6cnNRc1NjaTNtb0JkMGx5MHI1c2c5?=
 =?utf-8?B?RWYwZUtTbGxQTHhjbVRWSk5TUndsUmpkNmFiUWpkRkZmT2xCMFFwWnlBNjlQ?=
 =?utf-8?B?WFpTaEpjSWxaYWs1S3VYZ0VGcEVWeXRjYjh2Y3N4V0xhM1gySzlHeERPa1Q4?=
 =?utf-8?B?NEdPeFpLM2tNMHlJOXViYUN4c3BqRWNxSitrWURmaCt2SUtsV0JsN2pRK3RZ?=
 =?utf-8?B?Vyt5YnRsTlRHbGV0dzZQNDR2QW5KaE9CU1RmaHBpRFI2SG0rVlJEOHF1VTcz?=
 =?utf-8?B?UWhKbEFrWGowYy9YUWo1TmV2cTNvQVJ2dzdYbjlyMC9ZZmhOOWxHeGlmYzBh?=
 =?utf-8?B?UG50Ri94TzNtRTgvT0txVXBhK1lScHRGdEp1aGpyYkVJWWlwZ0xKWWcxTVhW?=
 =?utf-8?B?L2xhc0Y5aFNLVjRwZFhaTnNhVjZRdUppdU1uR2x4ZE4vN0xqZnM5MENDbksy?=
 =?utf-8?B?dXFUbHpuSEpUOTJ3Q25aMWFOclNhUnV3MmJ6a28wUkdvL2U1aTJLN0taaXph?=
 =?utf-8?B?NDFUNjN2ZUtGWFpNMk1YUVF2cUk2Wmhkd2pzV0VFTUpqdkt4RTZaNFViME1J?=
 =?utf-8?B?cW1lanNHL282ZmwwTGpaOVRqVGJvNlcrSVRSTXJmUzA2SHdYSkVlWnpieW1i?=
 =?utf-8?B?cTQxUG4ybitSMTdNSXlsazdMenUrcEN3SWs4OWp6SngvTGtpY1BzUDcrRm1t?=
 =?utf-8?B?R0h5YjN4M3pYQ0dTM05VdDY2Nmt3aGpiZWUvd2M0amxRaXdkSWljTC95RXZM?=
 =?utf-8?B?b0lRcWppSEhodGxna3dvMUhxWGFNWUxJS0dURmxCS2FFK3pGSzNyd3dRV1h5?=
 =?utf-8?B?ZjN2UVRqYUUzOTRqdThRYTEyZ2cxalQ0TDMzdGhqRDA1TXRQWEw3WExuL1B0?=
 =?utf-8?B?V2dkUWxEd0wzbnRNNVk1NkEyTHk1K1drUENQWkxxUERhaWt1ay9DMTF2d0lH?=
 =?utf-8?B?MEo0UlNuaENCL1haRVBnRjhXbWpYNXREZytqbURjR2JIbUFFcUEyRUJuSlNW?=
 =?utf-8?B?MU5sVVhVM0U0YjM1V3VpK0ZJaVRBM2pIQ09UOHVDeGtTdThxNkNrbEEyaHZC?=
 =?utf-8?B?UzRyTlNwVFVaSFJoZSt6d0pKVjFTZ3pJN1ZYYXN0T3B5WjJwR1kySmpmZ2JT?=
 =?utf-8?B?b3ZwUzUvaUdWMUk2TCtCUjMxK3VOTytYaWszYW5xc3QrTHE2a0trV3VPcWZJ?=
 =?utf-8?B?TDUvb1l2bUwrUUVlU3V3cWtOU3owZHdNdnNKbkNjY1d1WXhyZGJ1WWRLdFFI?=
 =?utf-8?B?ajVaNGFHQlRqa1BUNE1nbGl2STdGNTl0WnZZVVMxdm5mRGoza3Z5Z0dVVkFU?=
 =?utf-8?B?ODJ2N3A3SUwrV1FEeTRvY2tES1NMblJaNmVTdGpuc3R1V1kveTNWSjdzclgx?=
 =?utf-8?B?WEo4S0RtVFdoa2JveDJubm5HUzVrRjZQenpGYVdzcHc3Q0lxM0IrNmppYW5V?=
 =?utf-8?B?T0dNekxTUWhEVmhZMmJESlRWOWhYc0dOWlpiNWdLRnB5dGYzK0s5TTRna0F5?=
 =?utf-8?B?WVQ5azRzbG1PMmFpcUg3QlJ5d3RET0YvTGF4WnQzajNRdEpIWnJiZXZBMlYw?=
 =?utf-8?B?SDUzbnM0Y1BtajdNaGMyUXhIVzVEWStvN3hWay9rb0RLcUNpS1UrTWVaWWpK?=
 =?utf-8?B?NkRENHdVZndOZDh3aG5jVU9YaU9EejVuaDRDVHZZYmhLbVNodHVJOElBYlZQ?=
 =?utf-8?B?T1VJNzkrZ1JQeVpQY0R1Yk1vdllVS3pIRnhod3QyZ2NBbmxuOXBaTHhCOGZV?=
 =?utf-8?B?Qjk3d3dYNzJIWE5kVTM2eXhjZ3c4dEJ3YVMrTWVQMmpkTGhIVklWVXlETFhw?=
 =?utf-8?B?Vmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f6b8d0-6fb6-4e10-7c7d-08dad94fc5cf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 19:09:47.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWsH5HxLozniU08ZgMtaQFWvaiGgx1MsYzYqQ31Nz6Mk2OGPtyDc3kDK8Rp6TYobZ8gla7vYRY6v/AvKy3XLcfZRjgzoHhgu8Zcw4Un5mes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080161
X-Proofpoint-ORIG-GUID: SmTwIj-0QDsrHWDYVfR1DgPp_g9YBX4S
X-Proofpoint-GUID: SmTwIj-0QDsrHWDYVfR1DgPp_g9YBX4S
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2022 10:19 AM, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 04:52:32PM -0700, Alex Williamson wrote:
>> On Tue,  6 Dec 2022 13:55:46 -0800
>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index d7d8e09..5c5cc7e 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>> ...
>>> @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
>>>   *
>>>   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
>>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>>> - *
>>> - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>>> - * cannot be combined with the get-dirty-bitmap flag.
>>>   */
>>>  struct vfio_iommu_type1_dma_unmap {
>>>  	__u32	argsz;
>>>  	__u32	flags;
>>>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>>  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
>>> -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
>>
>> This flag should probably be marked reserved.
>>
>> Should we consider this separately for v6.2?
> 
> I think we should merge this immediately, given the security problem.
> 
>> For the remainder, the long term plan is to move to iommufd, so any new
>> feature of type1 would need equivalent support in iommufd.  Thanks,
> 
> At a bare minimum nothing should be merged to type1 that doesn't come
> along with an iommufd implementation too.
> 
> IMHO at this point we should not be changing type1 any more - just do
> it iommufd only please. No reason to write and review everything
> twice.

Alex, your opinion?  Implement in iommufd only, or also in type1?  The latter
makes it more feasible to port to stable kernels and allow qemu with live update
to run on them.  I imagine porting iommufd to a stable kernel would be heavy lift,
and be considered too risky.

- Steve
