Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56030A809
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBAMxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:53:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhBAMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 07:53:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CZ4VB109869;
        Mon, 1 Feb 2021 12:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tLtgRcQzJCpbaZ/IwkGPeTQF1749eOoIJ4UWiGrDywA=;
 b=fCew/wScsDClztozDjMN28QngzavPTc9lTwt6sgQQGc0YDv/ATvyYECME0k7oKsfh+AK
 QOykWHulhM4FJHeLF5xcrVKGb0ZaPw0N8myBtw/wR04T3rm3IMt9GzdN2OQYZFM4hp1z
 B+CQMIVT94AsBeRZpJCg1vQttQbI2ZTxoUJ3W6mdT9wI/qCGciPJGUcFJb6txIJ1kLek
 So8Lqf/BD+MWVP/rXomOMlp61Cp/xpmhTGGsXUk9T6sPbuL1y1Ewfoi3OvhooRIVI6IX
 5frsGkcVmgTgeyIfjL77iNB7FGS3hWhasO5FTsXohr7lkOw9CIH5xtz9Hqd6OGpN+PLU 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cydkn1dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:52:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CV9k9170131;
        Mon, 1 Feb 2021 12:52:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 36dhbwjpm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:52:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEM+VddOT/A0/LS4IK4M6rVbR+tD04HMeUEZG5r/mTVhVyAR9vzSW7mkJ/yXEgVQxScQUva/fR94TRBq71SEvlf6MryNipLAIp0Q1ucdnLUZbiVBK6HO1YX3FhCnG43KBKEUaKNqNB2CzVRJnjvdeVOTp7HOobz63H7YWexXbkO85AhfCSIx9PKOJt3aO7bVtu11D5k8/w5s6D0rI/I/OSgFdhxIBB2irUQrLOu/MzwQai8/rH+xLr8J+jmMx1zetrbfmr0LQ5hI2vIU9Z9u8uE7JqRmr6fXTI65B5R3W3MCacZsk1A3hCwbCYOlC8fFouYsAYdFxFLwVXbgkpINoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLtgRcQzJCpbaZ/IwkGPeTQF1749eOoIJ4UWiGrDywA=;
 b=WpMDucVnPxRbmIn6KQIs0LbN5VWVdI/w7Byh8GcX/c7QXxZJzkVjQvpKK0XMDQSQSswmpeBAfM1cOLh6PTXEPpwueH9gRoxB0m9JSBDDn5fWtFvVYUKQoRSUm7PaRva6bUwH1IUvecUlN+1dUShBw744dwUW8K0a0E+IOBQ1rhklZDKEtobPYheFdXAYHo6h4VcNvLrKzVRqiraYWKkVLpS7VlLsF92/Iy6JJ74xtdKvzj7qOLzMgfs3dXbgabYzA7FRTsACQ0w5ddk6OB9ZA12L0g8bqEc5XgQsUQ79p4XygXACjVf+lAdQ7tXVThT2AWbn2RJu7bzDflqQY8GioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLtgRcQzJCpbaZ/IwkGPeTQF1749eOoIJ4UWiGrDywA=;
 b=T7UnUHBUFLzbVBvB7MvGRITqmk2XUtpRp0L0R5+f+UZ9w1YS+a+ES75rOE9Y+6LSsVMZlS6aPXjMK39IbqhxCfDwTLaL6jEgXxrz98VUwvAbLABbQcfEx3vuANPfBFJKglrdeG+E+WArg2kmersJZDehg91TeKP7u6sqGy7hlaI=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Mon, 1 Feb
 2021 12:52:08 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.024; Mon, 1 Feb 2021
 12:52:07 +0000
Subject: Re: [PATCH V3 1/9] vfio: option to unmap all
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <1611939252-7240-2-git-send-email-steven.sistare@oracle.com>
 <20210201124206.49d3c71b.cohuck@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <1c152346-88ad-80da-f093-a7ebc516a239@oracle.com>
Date:   Mon, 1 Feb 2021 07:52:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210201124206.49d3c71b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CH0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:76::26) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CH0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:610:76::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 12:52:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35fd85a6-c764-4976-61c0-08d8c6b02eef
X-MS-TrafficTypeDiagnostic: BYAPR10MB3573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB357373B56BEBD5A7976FB835F9B69@BYAPR10MB3573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1yk1ewdhPIVTbsDyay8yYvpBr8la40KnRn42SqFmmu/pvTMYck2Wjkgr831CKBA2ITKDhj8nOjCR2Q4vI8qVzPdRkL73DLC111uf+cBf4lvCY7FxV0keFV2e8FOSD6yUWKM2A6mgJqIiETMBz3eJY1tdSCx8Hs8KkfjJHsyKTl59s31LaR0kGe8HkzQbGxVOY2rxsZXeGI/Jl5htcKHzfaKHc077qgrxxLGFE5Z+BYbaBx7Ve6lNlIyt8uppYnag5rIQMMwOdopmVD9arCo3ejx1klXKO4aWtVOxu89Qx78cspC9xbMaQXe/0S6xl/H35qX3jrdy3am3lCkKlRmj5Kzyw6HDFcJPWoIBBlUojw2qkvZcSaWZhySIFmKFkjRY+f/uVNdbssbHuvVn4iESyCIrLP7hFtF30mq0YBrvZj25OCzqHSCapZhocBdWp5zjgiq+w+m7EhOV42GNypn4Y7WSbBJ8nNArKpRtoEwg11I05I0BfGF2cTi6nKEAcYUG1xH2yiih5Kakrgm262dW9hzwRM+6JCbiofjrxbz5p8yUZF9xAkW9BsOIoWXpfpdbycU2vaARfoeVzOpNhR6cts8/UT/mni3Ox30TjLpERJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(6486002)(26005)(2616005)(66476007)(66556008)(956004)(6916009)(5660300002)(83380400001)(186003)(16526019)(36916002)(4326008)(53546011)(316002)(16576012)(8936002)(31686004)(54906003)(36756003)(31696002)(86362001)(66946007)(8676002)(478600001)(44832011)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RndBT1RUTFhSQitvZCs5NEhuY0V3ditPc05GK0pSYzhJSXdMajg5UXhodjFP?=
 =?utf-8?B?V3loK1JjL3RJWkM2TWRONnpiR3BjRXQ5cTJtSWdaQjFkK3JkY2JSUUczWnVD?=
 =?utf-8?B?T1lvM0VVa3Vwa053d0tiQWdtVmFzNUZSeFpyVUtLZFNKS0JieFVpa2hoamFG?=
 =?utf-8?B?aTNCcXdEVHZ3TXNiOEVUeUhSbm5CTTBUaWNKQkt5am5NSjVDQmV1MnpZVkJn?=
 =?utf-8?B?QldqUG9oL0h1WjdHT3ZaSDNCY203WnEySjJaaS9BNGp4UjZZbGVmRTNhNjJS?=
 =?utf-8?B?VURmc2dIYzJkYkxvZHlYTDdmaGpmWHhqOWFGQjh6V2RoQ2dwWWpmeTFFeDJ3?=
 =?utf-8?B?SzJPN2xRUXNjaFNTdUNRclhiUHFYRWVNT2dVUllRZ2s5QVhWOXl3NEVYQVYv?=
 =?utf-8?B?NVI4WndUQ3hEK1daYVBFVWlZQkpnbHI0d2tSZVozWERoRWxGd0lrVjllQWRq?=
 =?utf-8?B?SnNYRmhUU3dwWjV5S0l1NTJWUGUrWHRMVnBhcTZjZXV5bWk3b0pGb1VXNnZN?=
 =?utf-8?B?WTZVUkFYZnZtMWdxRXJvaHNTTlMxa0dvdW9wVlY4S1pKdEk0ekJveG1KbGtn?=
 =?utf-8?B?RjNaR1Z1QVBaV0d3dkJCWXlPTWFzMXZ3MS9ISVJnTTUycUsyTE5qbVY2ckpz?=
 =?utf-8?B?UE5oSWRuSUtlNHRxbk5LMmhsdmNjN1BxWUt3UTFYYi93NXFBRDYwb3lIdVha?=
 =?utf-8?B?VHpZUFpRbXRwaXpETmRZN3Bkbkp4cGJTSHJxeVkrbGNmdnB5WDZaVVA4L0w3?=
 =?utf-8?B?QU9yWC95eVRkSEVkdFhaNklIRHVEalYzSEprZjY4N0Z5Vm5neDNqdnJCZTc5?=
 =?utf-8?B?MkpSSi8xcVY5QkxUUFZWUEYxQlVZSDR6QTROUmVFS21JZUJabHVIUWZncUdG?=
 =?utf-8?B?NjM1Uk5JVmVJZC95TVVKTU5jcTI1SExJWlc5RjlmM0pYRHVINFVWOXpEVWlh?=
 =?utf-8?B?T1ltQzQvR2hha3ZvOE8yNUhET2MvdlVaT1VwejIzalJDTXNnMmMzOHp0MkVI?=
 =?utf-8?B?V1RTVmtGemFXNXNuUitPaEJWWmRNUEI0OEphREdZNzczK2NxOHpZYWVHTmhN?=
 =?utf-8?B?eEM0cFg3YUFETGpoak5TRnlNZkxZZFF1M1FqRWQvbFhrVzVEOWZucm85dFlO?=
 =?utf-8?B?cU9GWDFjVVdnWkNCQ2VOZ3I3dFhhNzRpa0dNUUMwZGVtU0FocW9GV2tkajJs?=
 =?utf-8?B?cjFGRG8xUTlVTy9YTTEyUi9VSURMYnhlTmUwekYyL2VjS0tiZ3JrWGxHaW9B?=
 =?utf-8?B?cmRVS3lTbXF0OU1jM2NpZnpremdRaTJUdkRhUUtMcFp0eDVlZXIvaXZjRHVh?=
 =?utf-8?B?OFlxUkMrNGRsVkwwclVGVDVaWnIxWkpNSEpzT25KTk9FSjZEb0IwZEpTWDlE?=
 =?utf-8?B?b3pNb2pKTGo3UGpKNWY0R0x0eFdKUzNWZ005YkkxRHZzQ0wyVWtRZk0zTEhP?=
 =?utf-8?Q?gzt4LT6u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fd85a6-c764-4976-61c0-08d8c6b02eef
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 12:52:07.9067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHctb9N9T2QkuhEVV+h6rIal6kd96Svu2x/QxKcg6FnRJiP1WyBFIiOdDVcj9t3YitVFYEbqhM3q63iCzigSfj8vDkdaEzTpz4OK1GHN+po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010065
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2021 6:42 AM, Cornelia Huck wrote:
> On Fri, 29 Jan 2021 08:54:04 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> For the UNMAP_DMA ioctl, delete all mappings if VFIO_DMA_UNMAP_FLAG_ALL
>> is set.  Define the corresponding VFIO_UNMAP_ALL extension.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  include/uapi/linux/vfio.h | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9204705..55578b6 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -46,6 +46,9 @@
>>   */
>>  #define VFIO_NOIOMMU_IOMMU		8
>>  
>> +/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>> +#define VFIO_UNMAP_ALL			9
>> +
>>  /*
>>   * The IOCTL interface is designed for extensibility by embedding the
>>   * structure length (argsz) and flags into structures passed between
>> @@ -1074,6 +1077,7 @@ struct vfio_bitmap {
>>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>>   * or size different from those used in the original mapping call will
>>   * succeed.
>> + *
>>   * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
>>   * before unmapping IO virtual addresses. When this flag is set, the user must
>>   * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
>> @@ -1083,11 +1087,15 @@ struct vfio_bitmap {
>>   * indicates that the page at that offset from iova is dirty. A Bitmap of the
>>   * pages in the range of unmapped size is returned in the user-provided
>>   * vfio_bitmap.data.
>> + *
>> + * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
>> + * must be 0.  This may not be combined with the get-dirty-bitmap flag.
> 
> wording nit: s/may not/cannot/

OK. So, the same edit should be applied to this from patch 4:

+ * iova's vaddr will block.  DMA to already-mapped pages continues.  This may
+ * not be combined with the get-dirty-bitmap flag.

Alex, can you make these edits please?

- Steve

> Or maybe
> 
> "VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP and VFIO_DMA_UNMAP_FLAG_ALL are
> mutually exclusive."
> 
> ?
> 
>>   */
>>  struct vfio_iommu_type1_dma_unmap {
>>  	__u32	argsz;
>>  	__u32	flags;
>>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>> +#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
>>  	__u64	iova;				/* IO virtual address */
>>  	__u64	size;				/* Size of mapping (bytes) */
>>  	__u8    data[];
> 
