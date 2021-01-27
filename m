Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911CE3067AB
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhA0XSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:18:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhA0XKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 18:10:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RN5Gt0099424;
        Wed, 27 Jan 2021 23:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4MlvLKhk+cC0BAQpqkWse/QC9H0fjh7VCE/hPL63lKw=;
 b=lsmFSxoeQ1xCdkZ+v/ikcl5K1nc55i5amjooF7/KeCHqQ1RNotB+7U0UYX1dEgjoJc+9
 0UwiRwfbktqiqLHQfem7gW51ILXJEAjhMPHyuz2/Aip6x8j3csCds/qj4hoJvZUqavoh
 1pc13Dzd5XIHRw0q4k4uxTWfCeYysiDpJwP2jrbAvTEHatwPAhFmooZOVZf3eu17o170
 WaHjTwYJCc2Wln77koTqHdLCS9crf2nULm+MQTJFbTG73jq5GAHvx/72f4BclcgQOcFc
 SQ0jSu9Qta2529BaMxtwxJwwo9kzQPWuKFEJ28KR3RtUrsTQJ6Y6s9eaEqGZ/aeboMFC Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aast75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:10:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RN6b2A149060;
        Wed, 27 Jan 2021 23:08:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 368wq0uq77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:08:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdNV5h/YR8jeBD/1NGqOtwJH8OlfhOt8cgLLUthy0WB42ZI4J3mW6kw/fpL7hC/LFoehCX6RMuzJZbfmwkttmJRPu6vlWM24F1ezzshUTBlnyWB+DAY/23G4+Xaigd40MKSQ2TX/Ah4uRKEOVJyFfiG4BtQrzm/mwC6X/Sq1+tKxLWqcVRc34BmbcFumvvaSNMa9MrhL1wl4TTVa8Mf3cnZOpZAwntO++tiG5nE+d8tw0izsoZexDHShs8JJbhtNJ9hzsafEjXT5zaKHT7T0LbJSLkpRAMGTHjRJde/AzHxqOh8xj+oH5gOXEBLwAr/ergOVYbsRpXgqgurf8fmDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MlvLKhk+cC0BAQpqkWse/QC9H0fjh7VCE/hPL63lKw=;
 b=gFjWHai5A1J97eoxJi2L9BcXGEQdgSsW3O6JHhC3RlhDg2QO1CyhdajZ0Xyzyzy9PWQ5QVT/xeyXU4iaCiSJgC0JHbImemoWpgJ4A1vrRQRoC/gXQT3DW9EIP7QMfU4GE3Ln4uRFr4N/mLWxaavZHD8ph71uBKYvivtiTj81yFi9nwft8FJSsYfCm7fwjb9alEKpb9yFT6NIcy8oscK42E/1+vR/h6teDMg8NQRIwPHiLh2GBYK7LiKXhAIDMkRUSZ7XOVhwYiu/hTPohqTGJPMsaeM7UNbTBAob1q8mlEU/vEO7huIiKhDRtaq4Mx8xiO/TYq/HsIEqem108fQmrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MlvLKhk+cC0BAQpqkWse/QC9H0fjh7VCE/hPL63lKw=;
 b=Oq0dUlHJEA1grtBLM6r1wRqO3cVsqXHiLxONMHwcs1x4z8bkCc56zRZSF1SBHC4nZg5EDA9UCWyW16araDHHoue4y88E4Sjj+2TEOZ+fZunreI3j3zJyeAzK7wyoNusOSGgMGOPCWTHHiP5W5f6thzccdTlyBKlru1pw22zDM3Y=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by SJ0PR10MB4542.namprd10.prod.outlook.com (2603:10b6:a03:2da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 23:08:00 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 23:08:00 +0000
Subject: Re: [PATCH V2 4/9] vfio/type1: implement unmap all
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
 <1611078509-181959-5-git-send-email-steven.sistare@oracle.com>
 <20210122142247.0046a862@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <646af8fe-dc41-a8c7-0e09-e8247343d526@oracle.com>
Date:   Wed, 27 Jan 2021 18:07:56 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210122142247.0046a862@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: MW4PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:303:85::33) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by MW4PR04CA0178.namprd04.prod.outlook.com (2603:10b6:303:85::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 23:07:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60a18ce8-396f-4108-39e2-08d8c3186428
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4542E8B8065EF9847DA20409F9BB9@SJ0PR10MB4542.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTvxb1hydQWyACq69z/bpnsBU0U1X4Ar9wFotctb5dc7O2ZKI6tPk8QxJUCIr3nua/m75EliYfxQdLMJ+RIAF2zGlRELg4rMz5NAD+CixYWr/pkQ84lEbAKLZpI2mBFJbKtanv2OMHY5iGqzN3sGB/Q0tGxyzWFDxGe6S75EmAEanzSnEBpVgArkiE+DuvBeWLEa6jsNO1N2WvGdmtNPmUsEMwGmVnx58Ndaa9hIE0GONrctZbhaeB0QmAJgThBnIPVQ7r7zr4x2ef5JpHeMUlLAlHMJUGl82UH5la+bDwm66aom5lo39xZlRL5j4N9FMd92lAqfj3trpp7Ws36Y1LkaIjZAIQdNbb0ewmA+UhgfQn2B2epHMgv33gtBD4MxpdURX+xyRgegBMazZWjkAu6/A1RUj2vrtn6rVE4v2K04XTTfRCImoCO4zlCJfJ3+0PMx2+Jy1+TTTjROmXAY54jtNXQYg57gP+tZjl0kP+qkDcRPB0ppYzWmqVosJdLHIy1gVDCLzhomuByaj8un7yuNIIVVXTsP9MT19u8eXVS9yz7l+q68ZUVsgVbgORc8kMbRXdBsjhZFMhenPPwwLzkxa9LTo69Pfb26XVHpZU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(478600001)(16576012)(2616005)(956004)(6666004)(316002)(36756003)(31686004)(83380400001)(16526019)(6916009)(6486002)(8676002)(8936002)(186003)(26005)(36916002)(31696002)(5660300002)(86362001)(54906003)(66946007)(53546011)(66476007)(44832011)(66556008)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTZvQXlCU2prdXo3MlZHMy9iQ0NHYnYvenVKa1NSSnRqcjVrNnhTMTZVSUJB?=
 =?utf-8?B?VFdsbkRCNTFBVjBuSXN5K0k0d1hoNnU0ZXBMZ1ZNMDZ2bXVTR0pyS1VpdS9X?=
 =?utf-8?B?OWJWTHpQMnVMZCtmQjRySFAxSm4wUE80bWlOT2ZBYkYvSUVLZ0VCU3lPbmxh?=
 =?utf-8?B?YmNLWThabVIwZ3FyWmI2Z1k4VlQrWU0rK1pPa3Y4Y2xzTTZ3TWNRQVJaWnFH?=
 =?utf-8?B?d3NWMk8vbW82dUl0M2cyY05qR1dQNWdvK3NQMHZ5WGY2RFlSNUxucEJNUHc2?=
 =?utf-8?B?S0FISE54bUdnREJRRXJFTHEyRkdGdjVLR1d0QkdKWU5EWDhBZHRISnAyK2xy?=
 =?utf-8?B?SFh1WTgwbC9JblhrZXdkUEpGWW1FZXh4dC9lUjFyNTU2dldwbDFsOE5MOU8z?=
 =?utf-8?B?cGJ5R1dvZnZWcXZlL1k0aUNSOUh4ekVDaldiLzcwQVVlTlAvWUN0elBYWmJt?=
 =?utf-8?B?OERQd3BEczcyUC9wNE5zd0J3ZDdQTm93SU9mQmcweVhubEVCQURmYzRrcXZv?=
 =?utf-8?B?dHpiNFV2OEFVOHdWL3lvMno0NkFnTnc1Wm9KaGdNOEgwZHo5SURXdjlOdDJX?=
 =?utf-8?B?MEZQR2x6bnh6WFQraUdSTEoxUlVQaFpVRXF2M2dEUUpEbVEwS3BTT3o0Tm1U?=
 =?utf-8?B?Mlh4MUh5elJYL3JvM2tabG84NmNMYzBHNHZ5WUMzOXk3SDdoTWROU0FJSmsz?=
 =?utf-8?B?WUdpcEV2dkp2NTRBR1lGWEZsSEVVUUNxRHV6V1lLY0l1eUNMVExwRVlqeXJK?=
 =?utf-8?B?N0NPMndoTytEQktpa0oxY29DTVdRejhqcm8weCtmeGwxVVFjYmh0SDdrNm9J?=
 =?utf-8?B?Nm43dlBiQlFPeElNSnlzREFvNUVvQVBjai9ObG9DM2dzeDlEZnM3RDZnWVRl?=
 =?utf-8?B?TWRTV1hYSkEvUURySFp0L0UzclovV2tnKzREZmJsTDc0Q3VFOFQyYXNJdWJE?=
 =?utf-8?B?Q0FsZ3l0eEsvZmFpenBITFd3YlJxVDlsRGc3dStsUnF3R1FGSUZzcERnVHc1?=
 =?utf-8?B?YlVPVDJjKzN6RVplU0RjcHNZdFpPZlhuQWs5Zk0vU2pHS1lKSitVU3RRUUx1?=
 =?utf-8?B?KzZaVWVrUXl4SlpYZWZaZGp5T2FzM3FtR2VVdStNeHhuZ0laOFJtWmFkamdj?=
 =?utf-8?B?MVdnMEFHSVpPVzU0bHFwRHVSY3cyYWl5RHp5YS9tZlQ0ZWtiRjNlZXhRVnNB?=
 =?utf-8?B?c2V5c29jZnhBemFqcysyQnAwOWpiT2prRFBXdUNMNEhLY1ZyNTY0ZFMzNnAw?=
 =?utf-8?B?TS8yME5Wekpmd1N1bjJmelRYUW9YMWI2VG56UlBXd2szVlM4Zzc4ajNuKzRn?=
 =?utf-8?B?V3NUZmJZR0dCRWFEZEJ5UDJkbXcrV01ucXFGM2tsdHh2am1JL25LWVdWcThB?=
 =?utf-8?B?S3pHZHpDQ1NUU2ZkQVE0ZFd2Y1o1ZG1UUVVtcmprZzJVMmhYbVVCVVZSbUh1?=
 =?utf-8?Q?xnQdNrvO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a18ce8-396f-4108-39e2-08d8c3186428
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 23:08:00.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qu/jAhanMc6YrQ8hgcHavkMhokWl8YTnjjmF9XdvJ3h0V3yHDSBTgbgpx5s8SNdRIsYcUxfsjHhMKvfDtJTYUFrK7gdjVcxW1GNdLi/s594=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4542
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270115
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/2021 4:22 PM, Alex Williamson wrote:
> On Tue, 19 Jan 2021 09:48:24 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Implement VFIO_DMA_UNMAP_FLAG_ALL.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index c687174..ef83018 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1100,6 +1100,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	unsigned long pgshift;
>>  	dma_addr_t iova = unmap->iova;
>>  	unsigned long size = unmap->size;
>> +	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -1109,8 +1110,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	if (iova & (pgsize - 1))
>>  		goto unlock;
>>  
>> -	if (!size || size & (pgsize - 1))
>> +	if (unmap_all) {
>> +		if (iova || size)
>> +			goto unlock;
>> +		size = SIZE_MAX;
>> +	} else if (!size || size & (pgsize - 1)) {
>>  		goto unlock;
>> +	}
>>  
>>  	if (iova + size - 1 < iova || size > SIZE_MAX)
>>  		goto unlock;
>> @@ -1154,7 +1160,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	 * will only return success and a size of zero if there were no
>>  	 * mappings within the range.
>>  	 */
>> -	if (iommu->v2) {
>> +	if (iommu->v2 && !unmap_all) {
>>  		dma = vfio_find_dma(iommu, iova, 1);
>>  		if (dma && dma->iova != iova)
>>  			goto unlock;
>> @@ -1165,7 +1171,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	}
>>  
>>  	ret = 0;
>> -	while ((dma = vfio_find_dma(iommu, iova, size))) {
>> +	while ((dma = vfio_find_dma_first(iommu, iova, size))) {
> 
> 
> Why is this necessary?  Isn't vfio_find_dma_first() O(logN) for this
> operation while vfio_find_dma() is O(1)?

True, vfio_find_dma is O(1) for unmap-all, and find-first is not needed until a later patch.  
I'll continue discussing this issue in my response to your next email.
 
>>  		if (!iommu->v2 && iova > dma->iova)
>>  			break;
>>  		/*
>> @@ -2538,6 +2544,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1_IOMMU:
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>> +	case VFIO_UNMAP_ALL:
>>  		return 1;
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>> @@ -2710,6 +2717,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  {
>>  	struct vfio_iommu_type1_dma_unmap unmap;
>>  	struct vfio_bitmap bitmap = { 0 };
>> +	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
>> +			VFIO_DMA_UNMAP_FLAG_ALL;
>>  	unsigned long minsz;
>>  	int ret;
>>  
>> @@ -2718,8 +2727,11 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  	if (copy_from_user(&unmap, (void __user *)arg, minsz))
>>  		return -EFAULT;
>>  
>> -	if (unmap.argsz < minsz ||
>> -	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
>> +	if (unmap.argsz < minsz || unmap.flags & ~mask)
>> +		return -EINVAL;
>> +
>> +	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>> +	    (unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP))
> 
> Somehow we're jumping from unmap-all and dirty-bitmap being mutually
> exclusive to dirty-bitmap is absolutely exclusive, which seems like a
> future bug or maintenance issue.  Let's just test specifically what
> we're deciding is unsupported.  Thanks,

OK, I will make it future proof.

- Steve

 		return -EINVAL;
>>  
>>  	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> 
