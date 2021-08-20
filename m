Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3893F340C
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhHTSos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 14:44:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50832 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhHTSos (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 14:44:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KIecoc014805;
        Fri, 20 Aug 2021 18:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BeoPEY8TTMF3jAsVt4bTMM5DmQKPg8glm+fIZR0Lszo=;
 b=KDW38DJe7VsV8fQT1e1hLTSUj8mDJzGja8b9Xi1asc1ntn5YK3Mv+sxUlfBEUeR/o2FO
 elyORTRMi325TPd19sr1iV9X3gXIwnyl2xP9wwZ4FWqxWL5qk6jiRlafQ+MkLYn+zGrt
 QgSGfTZ+a1gHkXYEXtb3EZ/f58/IPqMRvtCwkKyy/PjeYZ2hIFmtvVWF9R1HAwZBWqk/
 GOoWEOQnBXbiQ1e6E3BL36wo7lFpLTCjrqlDv/8bmTofZxagBW52w9FqkEv/b01Fz5y6
 ejLAlf0GeCFcnhzEY05h6XiV9P0Vc0km/Sa4I0o+ReFJ7qn2Ybt9Xy5mbowLsk3cWaOT ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BeoPEY8TTMF3jAsVt4bTMM5DmQKPg8glm+fIZR0Lszo=;
 b=bS0l7Kn5robbWiarhy1a1akeuPwwWE78PsroDTAo0Qz17yuLp7WixMSw0yTafcoY7BKS
 DzsBI0GHQl2pZmdAkj6QQ59DD5ccRJX2B7XLUfKzxJlAKa0ykUujcfOKy6yzd06hvqbj
 JYwvD17uzpjQh/XM979XH5OnuPEALPGYDAtUnsT/dK9OduPKLY6//L3+TIi7H8QPenyJ
 SXJUQNfT1YRAL+K/i8PgfEiSfSvPdR12/us7XOjUj1fnOm3LqswCP30XrVp4MOxEa4kp
 6BMIrbF5jtzVVICTB6pisK8/AHQj6c0ZCTJ6X+Pwyl0sc4bhOzB0BiPiswfdBO7MytIL 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aje2j0ksw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 18:44:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KIf2xu178844;
        Fri, 20 Aug 2021 18:44:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3ae5ne3k3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 18:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJppl8hi8YOCYuA3xdTKIvSgwtov0l+k+aOX/Ut936Ezl0LAl7t1huTP4+ePy+xxt91J0mftrthzvguTg+sPqbS9130r1U5esGff5PVKYBZQQLggOd+fTQ3CJbheAP/rdhG9sKInxRT1fbWmY+Q2YmOFU/rYWmHlaGpah8V+73BXrgPM3qe+PvjC5yrft3hks4eNAkRDflmTwxjo2u0ujo4pWD+DZTodjgI5DpQjWJvRPAH7UNcfySixxhD025mWI2QfmyQAczia9vXqrQY0YqLWUam3s+ZVLs6mCCwoHLQkgIb/LJ/WLatQEeW5LpEs3SPfJSslifRDtaA/1imssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeoPEY8TTMF3jAsVt4bTMM5DmQKPg8glm+fIZR0Lszo=;
 b=Mq5zkIX4WjuzZ962ghQjw0VL0KvqIUnLz9oZR6JO7UN9IZnMDyF4vcA+DummM234tYACefh9pCQ4N5eFNgAJKellj6SHQC/EmFyqwKQ8qaz/w8nY4CYY+rnJn4E+A3VJjb6Sr2QosAL6rCA4//X7Q2ZTFRUR4w31dvYqutSh32iLL4yz7PdDh1dy4stYhuqdpsRVcsWh1t/yYzfmQYmzDH/5jkCdN8o+/nYt9AC7unZYnXWwg7nK525jqxXGvzXq4uztWHcDuTkbF9a3ZiUNX0AA8t7cXcL7OIEt7tFE9UfdY9kztcxKmLS71karbrbBO5SLT/CPUHJjnoE/csOhiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeoPEY8TTMF3jAsVt4bTMM5DmQKPg8glm+fIZR0Lszo=;
 b=RxOeICdqQzFCSPgdK8armDoy2cQKDiMma55onQO/8XbV0qFylRayOOQ1fLEJaqemvlzpcUEi7kT1UzcXcHEWZD+fur5CxxVg3bZXImibVolDg1E0p+EsUB9pS9oFV5Meecnz54W7iIPgXKEPqbuo0l8x4t+QM85BeU3goNW/22Q=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
 by BLAPR10MB5380.namprd10.prod.outlook.com (2603:10b6:208:333::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 18:44:04 +0000
Received: from MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547]) by MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547%7]) with mapi id 15.20.4436.021; Fri, 20 Aug 2021
 18:44:03 +0000
Subject: Re: [PATCH] vfio/type1: Fix vfio_find_dma_valid return
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, steven.sistare@oracle.com
References: <1629417237-8924-1-git-send-email-anthony.yznaga@oracle.com>
 <20210820102440.4630b853.alex.williamson@redhat.com>
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
Message-ID: <d61744e0-e30d-e5d0-a4e7-e1a80f2ede46@oracle.com>
Date:   Fri, 20 Aug 2021 11:44:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210820102440.4630b853.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN1PR12CA0043.namprd12.prod.outlook.com
 (2603:10b6:802:20::14) To MN2PR10MB3533.namprd10.prod.outlook.com
 (2603:10b6:208:118::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.159.154.253] (148.87.23.10) by SN1PR12CA0043.namprd12.prod.outlook.com (2603:10b6:802:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 18:44:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0570acc9-f97c-48d6-47d1-08d9640a7ba1
X-MS-TrafficTypeDiagnostic: BLAPR10MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5380A3FF0027A98C13646C43ECC19@BLAPR10MB5380.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QUMbGsvb6Y6bS71Vu7ILcyw3IF0XYQPETCISuuvLxF4Rd5AHEFGYNibMBDM51hVizlq8knr4MuPcEsyf6Yq+UZqjwohmPMbKTST7Efjc48vedi/ZrClbHfZj4aXkD6bX/CZbA3meImyFkyOryFUJzEzncseCRUTUgBTRHTrOWvkkgXHqzY+0TctQJqCTHrEmrtZy44K3hKaRP88nEyzfJRuivQWAVz9lvmfR0T8BTPK0R2ggUAO02RW37swg23k7+7HGUv+oq1UHSHDwmSSLsiAkFaO0KpkGgyNtJHx3m2Myr4Knjhn55s1T4Cy2k6PQCFmV6b1cNOrjZLBVA6MRpsPOKauR8TfUV/jaVHJhvM+TqedOHEQrnEcydI4drgBmNFje/G0eEJO1bXKdqF97pD9o65k+Y0tNZXhL1FR0v3M/1/xYSO8V46oaFeH7BUwacjBKqpfwveW42abQNdoL7kRxN2Zmr2wAN9uoaz3YkhjyP1N6h5rFzGThrA/EMCFJuWpQte7x5QQUyP8O1MFsYAMTZFCWNUgASnfeqRUwEZYDG8Ma5rwixTPCqQP7nTECNRcrIIwFm6EU6gN2nFCB8RimtJuf+AhM8Ayko043jFaLcWupPz/qCyaOPtM+jCeRDrh4f+T0FOjXbnCuDjHLeVdSuDkcXOq7cAy0GBmLm3RP8Zf4xxaIIxICPrfIVtxNtM1FuWoVcZ1OECl+phxq9x+M+gH7OyejSKgMTOtvYQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3533.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(346002)(396003)(31686004)(31696002)(316002)(6916009)(107886003)(6486002)(36756003)(44832011)(4326008)(2616005)(16576012)(8936002)(86362001)(26005)(8676002)(66556008)(478600001)(2906002)(66946007)(66476007)(5660300002)(83380400001)(38100700002)(186003)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXFmT2JEd1lick5Jdk1QY1NVaFBONDZMMkpLWkphQ1VxYXFJd3VvL1poLzE3?=
 =?utf-8?B?MTdsd0p6QTJpS1g3UlZ2TXdBak1FRlZ2ZVZicGhTdXovb0F1aFRnZTExMURk?=
 =?utf-8?B?a2xFaWpjZFV3ZFBJUnpQd0J2czlnY1oyR3NyT05mYkNkbFZyQlBtZ3R0N2I2?=
 =?utf-8?B?L0pDeWhwMmVwdVVtbkVDMHJRd2poTWhHQ1pieENHZzNkcXdvS2QxSEtEY1kr?=
 =?utf-8?B?aHYxZzhJYXF6SWhydlo5NkxORWlBVjhpNUhJV3Nsc3dveUpxOHQ3VnNja0RX?=
 =?utf-8?B?NmMzVFpjd2ZOb2NpVDNXbmNkSk9FY2tUbkFHZmRiaVVvUmNVVm8wSE43Yi80?=
 =?utf-8?B?NjdPVkFuQ2JBSXpzcDdUTkZMSWxlNFAvbmRibXZhemR2Q1o3blFnM2k2QndM?=
 =?utf-8?B?OW1JcktoNFRYTTZIV1U0UjMzNkw1YUlvSjV5Y1hjcXk2b0txUEN2VWlXbFYw?=
 =?utf-8?B?a0hsbzVhVDJydzgyTTdmRTd3c0NLb204WDdUN2x6amp5cDk4Yi9vaWxOZjFo?=
 =?utf-8?B?SVludjhKZFRFVmhTb3VmZis2VmtNdlYzZVYvK0d1V21kVEROamNRNmxsNjFW?=
 =?utf-8?B?R3VJdXRyZ0NxWldHV0tnZXl1cUVqdGxadzQ3Yit3MzF4cnAvNEdTN2laaUsw?=
 =?utf-8?B?dXhWL25OS3RBdys2eGlReEt1K3crYUFtMldRMk9sc3JIT3hCaUxaUkxSRXRy?=
 =?utf-8?B?RTFHcExzaXJtZjVYa3RqYnpQN3JtYjdYc1BTejRGK3Y1QytnM2dJUldvTkU2?=
 =?utf-8?B?NHp3MEJRcXlVOHBzbGp6bDNJbThFeVV1aTE2a0dvM0lkYlk4bldUR3R0L1lt?=
 =?utf-8?B?amlZME9KRmRHT05kQzdJNFFPeHI2TUIyTkdDS2VxNTJBdVl3MDZlK2lnWnVE?=
 =?utf-8?B?RGZCUS9QOE0raC9Hc2YwR3IyVWRtdnFOTkdvTVN3eERxcTdlaGRlMHZEUmpu?=
 =?utf-8?B?T0FycEVUd3pMUGY4N2xCQXdERU1kUHlsczgrckFPVFBnT1gzRmRVYVJoS3hh?=
 =?utf-8?B?TVpBbm5LRGRnNy9GTUk5alRnb29OOU5zZ205ekNRUG9zcjQ2U0ZCOHFVd1E4?=
 =?utf-8?B?S1JSMURhcmpVWlhQMnpEZ3FucE10VklaT05FZlZWSThFRVRCUFZPNFhGVEQ5?=
 =?utf-8?B?S3hpUHJpWms4RUcrMWc0UXp0Q0s5bzg5WUtUdVhQUERDdlZSSXVxNTJETDhM?=
 =?utf-8?B?QTFSQkJKMXo4bkVzYXQ3R1NjcDFxNk1zUHN4MURtdDArdnZFMmdaM1ZhZmJE?=
 =?utf-8?B?V1NQS0M1cFRvb0JZSy95QkxKT1NhYXV1VDVoTGc2VDZXZEZqZ0dUcElsVW0y?=
 =?utf-8?B?RGE1YWt0OE9PeTZFSlYzaG1iaGU2L3ZIcS80MzFNcEphS3p5Tm96MjlyY1Jr?=
 =?utf-8?B?TkVrQ3d3bTY3bFhpYkVRVGoyR2hIVFpNVTRRSzM3bDJUMHRISHBQdlJqWXI4?=
 =?utf-8?B?OVhHakhKRkMxZGlXVDdiRWZPR2MyT3FXclZpTGplT3FSUUNKeERWbUxaeWpE?=
 =?utf-8?B?ei9BMStkc3FsenNyR0MzaVZVWHBsOEc1Ukw0dlJUdTNrNG9ycTY4VmNJeXow?=
 =?utf-8?B?eG10UElJSDZCc2tkVktYcEpMQW82enFobmZWUE9VTUdzY1VYZnNFZFE0eDJ4?=
 =?utf-8?B?WFJYcjBTWXBPN1YxNEd2YzJYc0MrUkEzTm5mcHF6N2dWejN1YXVyczVjckpl?=
 =?utf-8?B?OFJoSm9oV3h1MzIxOTgzRzJ6V005Z21BTWRqbUhxdFBGS205UmxLWXBWZGtE?=
 =?utf-8?Q?53wIa+utApYuryqno8FKM8YFCnmDmP8dqhAEtiq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0570acc9-f97c-48d6-47d1-08d9640a7ba1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3533.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 18:44:03.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjwKrGQCGU61mQVrMgafAE1d+Xxhyl6fusirNIGomxHeMnSAXzS9zObSPAB6iN0VT43mUvDxWY/jbAlBIzOGQGgell4WLBeiC0ltvh5pVQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200104
X-Proofpoint-GUID: izFjVQaCEA1LcmhSCoJhDzrCYTFUpJNe
X-Proofpoint-ORIG-GUID: izFjVQaCEA1LcmhSCoJhDzrCYTFUpJNe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/20/21 9:24 AM, Alex Williamson wrote:
> On Thu, 19 Aug 2021 16:53:57 -0700
> Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
>
>> Fix vfio_find_dma_valid to return WAITED on success if it was necessary
>> to wait which mean iommu lock was dropped and reacquired.  This allows
>> vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
>> avoid the checking the validity of every vaddr in its list.
>>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index a3e925a41b0d..7ca8c4e95da4 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -612,6 +612,7 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>>  			       size_t size, struct vfio_dma **dma_p)
>>  {
>>  	int ret;
>> +	int waited = 0;
>>  
>>  	do {
>>  		*dma_p = vfio_find_dma(iommu, start, size);
>> @@ -620,10 +621,10 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>>  		else if (!(*dma_p)->vaddr_invalid)
>>  			ret = 0;
>>  		else
>> -			ret = vfio_wait(iommu);
>> +			ret = waited = vfio_wait(iommu);
>>  	} while (ret > 0);
>>  
>> -	return ret;
>> +	return ret ? ret : waited;
>>  }
>>  
>>  /*
> How about...
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4f7c174c7a..0e9217687f5c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
>  static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>  			       size_t size, struct vfio_dma **dma_p)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	do {
>  		*dma_p = vfio_find_dma(iommu, start, size);
>  		if (!*dma_p)
> -			ret = -EINVAL;
> +			return -EINVAL;
>  		else if (!(*dma_p)->vaddr_invalid)
> -			ret = 0;
> +			return ret;
>  		else
>  			ret = vfio_wait(iommu);
> -	} while (ret > 0);
> +	} while (ret == WAITED);
>  
>  	return ret;
>  }
>

Even better.  Should I send a new patch?

Thanks,
Anthony

