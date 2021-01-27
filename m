Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A112E3067DF
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhA0X1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:27:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60894 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhA0XYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 18:24:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNFJjw120167;
        Wed, 27 Jan 2021 23:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Jx7FVPV7X1s+a2lol6kpB6u/LKlXGV9PVwTLTrGFAzo=;
 b=N5khHt0vSEy2lz0d38VWVZSjNMiPJcLqdoq9vhWff0ksH8T/vJHNwtCqoLdQc+7TZeNv
 MH0DGNh6XmIwHaprWp37Vd9OQI1ZKb/GV96ZUsgxl/zDEWFQZYUQWV4x2qWJEMZTbH1S
 0d/JsZK6i+bYd9Fq9s2DN0l/ftGlu4ZKRtMMrYofE/DX4AYY3eGjFu91oAmumZcRCE2W
 0THbg2ZP9PVlLnVHaqMWeXzbCi1p0g/pYmBfEx5oklqGOXlgtJ1sermS1bCBHKn1kvdU
 bepAZ6aEWgeGzacflsirQzoINSqmKfD4lX8QJhMMBD/m87Dvo/lBqaHoBbfKZwx1YFIO /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aasukc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:24:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RNFlLM175528;
        Wed, 27 Jan 2021 23:24:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 368wjt6tbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 23:24:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UULewp7Wauha4cM0wMjnEBUPIJX6xJf7tFVSWpVJGwUFLZGwYk8zl4JIAl2zFMUsW4Vp8RmHkcRkbLAjobfbYJChHheEe6+SgSezupF0LckXpNm5ryMxM1A1mCLFUgugl5TK+j9QHwlQ8X1i7qCU3Y7V54HTdxoo3RyycrjZKmUGeLBfH146bjU7Ia1XeA+42xaxmqOyxXpn7fJItWI7OvFc7mKqccFq0vxc4Xr/uN4Y7h/GJvvY8bh1DZMbxRDCDsE9LrBqxY/9Tq4uU98rhuRjYQDGO99Oe3PJvjVPJA63zoF4WlOnw2fA2uyoSMpiVNmkKCWeD6eOXnELtIE0kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jx7FVPV7X1s+a2lol6kpB6u/LKlXGV9PVwTLTrGFAzo=;
 b=Dboeb+6UCrqGwi0Is2SlnEeX7Xw7rlyG5plhn5MtlCfASXNUIzNRz3i9Znol9VAscn49UNwsSrUXQAxnG8iMdvTlq/d7AkidTEPrwo7Fb7LO2oEo4JpWcJaWyRpADIxZfMZugv+UMbV1B5vMwVN0ZFbHE1KIozDcnYmFN41fAVlASMSFyVwIreUkpsn7y2nLUN7ALB3Tlbpv9u83KlaMmFJwzUpjEx5M0V4kR1FqVyQuiidXLkXN5WCf0To1yl/FrCXhPLc10Gn9KZC+oAJxkf7ok5ZgfFO3wi3Iry9nWJs6weJ8DmBbJMmnZ1U5LRh5rrxMWCDlfEGMRdK+JwO/QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jx7FVPV7X1s+a2lol6kpB6u/LKlXGV9PVwTLTrGFAzo=;
 b=whF/lpm+E7s1GG4jLs8cyrjPhxhV2fDdnSUw1rGGPzqMTsSS8sMyXpXKqStAjVuw53tGaYbIcVuDUqw0LbEvg4sBUn0rBd/xzpdA6p8AIR28y5n+AwH4AYZ0ntCrcqjnz0Mo0g2lGoWGD/2NrgIMt8PrsaznYJjucSIqNtrRgQs=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3655.namprd10.prod.outlook.com (2603:10b6:a03:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 23:24:05 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 23:24:05 +0000
Subject: Re: [PATCH V2 8/9] vfio/type1: implement notify callback
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
 <1611078509-181959-9-git-send-email-steven.sistare@oracle.com>
 <20210122160012.30349b62@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <3e07f283-534f-13ee-2c4c-39cefa8c4cd8@oracle.com>
Date:   Wed, 27 Jan 2021 18:24:02 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210122160012.30349b62@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: BYAPR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::45) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by BYAPR05CA0104.namprd05.prod.outlook.com (2603:10b6:a03:e0::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Wed, 27 Jan 2021 23:24:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7366a0c8-6aa4-40c0-c7f2-08d8c31aa35f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36556C34A5798A37802A88A7F9BB9@BYAPR10MB3655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYDi58CJV3vhmkChh/Mbfwld8HSc9jpbh/XA7bIXltoGv3lWpLIuck7mEfWRnTLoBOgDTz0f2VbF3CjP7+pFv5VCONi7T0AxVAq/R2siJVxjQpWAui1GUHOVaeMw7IlvPq7oQnGGYKnc94xJDMQ6G73cyiF9djSMpOdMoCq2fx12GScyPlQXs9VLzy9KVBm4aM6MpOYFScAtDztvWecG62hRR5hym+6adbCQqFH5F6WqwVBWeY3MReplE75rgJ6Xoz/z8yAdPqsyQooiSsDI+PJEvEKoFE46bv9dL7kM7OGgaupgrXDdBKO7Mo+/Ip2D/FWPIaOCUkbXRGR3ZL/3hk1t24Iw2WufET2coWH/HzdN4r3tHQxu5uAV4qP9Odh1ZlrEb3S5wvFkahmRWQvPLTyXFMKKLs1EP/4fB/2ABE76nNQv+7d64jXzx5sVVnCjGm55Uf60wlT4Vr6FoH540fbsPweaRUvRTATTHCx1irBq0SqoCysX9sOV5n/INzFLfBZmZ02lLAPeixtFPYdOTdJWrzRnqBU3CeB2NW1T0QQ3fDgD9XFOC1TR0hiJemxOrijiPa6DPI2SjB3O5/OG5Ko3elc7czh1ffetgZ/y2Gs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(186003)(36916002)(54906003)(478600001)(16526019)(31696002)(26005)(44832011)(4326008)(31686004)(8676002)(956004)(6486002)(86362001)(83380400001)(66476007)(66556008)(316002)(6916009)(53546011)(66946007)(16576012)(2906002)(8936002)(2616005)(5660300002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mnh5M2JYOEozOW84aGNoeFB5aXRKazA5WDhTY1lRSzVkQzIvSEFXUTdLTVY5?=
 =?utf-8?B?Nzl5SW1BakRldzFhb2tqRCtPYWtRcUcrbUNsNmdRYkVyTXEwTkxTb1FXNWxa?=
 =?utf-8?B?SDdLTVgzZy9XTzRNUHh5a0xoL295NkF2QXJUZWl2WUI1bTNDSGhnL01Zb2tZ?=
 =?utf-8?B?b0FGQmFhN2hXWWxjYndtQmpDTlVsa3g3SnRDaFI3VEV6dVJuS2tqS1RZOXhJ?=
 =?utf-8?B?UFAyaWJnR25MTWJ2OHlFQUhjaGliTy9KNEorVWtJMjBhclVwUlhseW01Zk80?=
 =?utf-8?B?dWw1VUtZaDZiT1Z2bllwUW1nblNPNGVtaTJqeDh1bFdaR0FIa2JxZWJLSVEx?=
 =?utf-8?B?QU90eWpDN3kzVldOb2VNTXJqVlYzclJvbitBSm1rZkdFRkQ2ZjdBVzcrVDZD?=
 =?utf-8?B?cVc5RVBCeFBzWUNQSmVLcVhUdENqZHJTZzMzM01PeHpRK1ltTlZic0ZTQ2Mv?=
 =?utf-8?B?K21SYzJXb1pSWTQxa1JXSDRSd2dlZUtxbmFLbm5PVVFzY1VSdnkxVGsrZnNz?=
 =?utf-8?B?Rmk5ZHQ5MHVod0VDYVRNbFJRdjVqNC9LbTRTNVlMdktRTHFLSiszMHR1TmYr?=
 =?utf-8?B?ZTVucDU4Mkp2YTRvMEpPRDJTNC9CbmRFdldVUHlKSUdXblgwYzZuVFJ6RnFI?=
 =?utf-8?B?R1ozNjVXbFhXOWxSU1VvbjJyWlY3TmJRbCswanEzRzI1OGUrMllhL3VjTmJn?=
 =?utf-8?B?ZXc0RkxPS1dOVG1aZkxrL1hhNE9ScWpXOWQ4N3N1MGs3U2srSEx2Ump4T1pX?=
 =?utf-8?B?WnZxbi9QTDJKTXRCZ2MwWnBPbGs2cWFrTDg0MldEUWhyRzZKNzRKeGh2Z0RG?=
 =?utf-8?B?V3NVUEptZ2JPZG1jTVVna1hwNE9Sc2FscFFmUm1yb0dkV3hJN2VCRW9sdm1t?=
 =?utf-8?B?ZWhhWUM4SHJWelNPQ2pUWElmWVY0eEpDYytoZTFSZjQvZm5YUVo3ZEZqTHhx?=
 =?utf-8?B?ZGlvcjBDdlMrKzJPVWhDMTlHUmMxOURRWWtCdGZtek1BZnRhbVR5YjgvOVdo?=
 =?utf-8?B?VTRnVmp6U1lSeVhDRWZ4V2Q0ZlMwQVZvZVlLMUZLNFBkMHpib2htTmV2WkNI?=
 =?utf-8?B?dWNTTlVvdWdnTWd2cVMycEtCL0U1WEN1c0xSVUgwTkF4SVZlb2UrVlNYTEdw?=
 =?utf-8?B?WGFwaVhJZXJXemFQb2l6ZDJWNG50N3FsdWd4U0lqTzJkRmNOMjByeFRiV3FP?=
 =?utf-8?B?WWlNeEtPaFMxVCtwaW9GR1BlZ3h5UEhiZFpwZDlpSFBhb3BjWk9nZ2thWnRl?=
 =?utf-8?B?T2g3cHhQcU1vSHo1TEJvQ3FmUSt6aUtuS2s4dlVmejczekhBeVluYTMyRDNv?=
 =?utf-8?B?Yys3bFlYNzEvQU1JZFNjWG1aanJrdmNRSkNJVEg2ajdWS3Y1UEptVS9WUXYw?=
 =?utf-8?B?YkpoVFJ5UFVKRVZ6VGxUUHR1cVRQeXQ0dEJQV2pVQ1BNSjJqM0QwUm1kVzh3?=
 =?utf-8?Q?sKaYHWBH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7366a0c8-6aa4-40c0-c7f2-08d8c31aa35f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 23:24:05.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N22iPF5jMNDG45jyksBGkvJlX+ON1VAcYQatImRddftcvQK9eLoDglG+lV9jSGzDOfPcJQ6cIix5718FATgNI6s3FDK+LlZDSVjmW5q01kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/2021 6:00 PM, Alex Williamson wrote:
> On Tue, 19 Jan 2021 09:48:28 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Implement a notify callback that remembers if the container's file
>> descriptor has been closed.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index c307f62..0167996 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -74,6 +74,7 @@ struct vfio_iommu {
>>  	bool			nesting;
>>  	bool			dirty_page_tracking;
>>  	bool			pinned_page_dirty_scope;
>> +	bool			controlled;
> 
> s/controlled/container_open/?  Thanks,

I like controlled because it documents the issue nicely: it is no longer possible for
the user to change the state via IOConTroL.  If you like more context, then container_controlled.
But container_open is fine.

- Steve
 
>>  };
>>  
>>  struct vfio_domain {
>> @@ -2518,6 +2519,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>  	INIT_LIST_HEAD(&iommu->iova_list);
>>  	iommu->dma_list = RB_ROOT;
>>  	iommu->dma_avail = dma_entry_limit;
>> +	iommu->controlled = true;
>>  	mutex_init(&iommu->lock);
>>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>>  
>> @@ -3043,6 +3045,18 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
>>  	return ret;
>>  }
>>  
>> +static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
>> +				    void *data)
>> +{
>> +	struct vfio_iommu *iommu = iommu_data;
>> +
>> +	if (event != VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE)
>> +		return;
>> +	mutex_lock(&iommu->lock);
>> +	iommu->controlled = false;
>> +	mutex_unlock(&iommu->lock);
>> +}
>> +
>>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>>  	.name			= "vfio-iommu-type1",
>>  	.owner			= THIS_MODULE,
>> @@ -3056,6 +3070,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
>>  	.register_notifier	= vfio_iommu_type1_register_notifier,
>>  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
>>  	.dma_rw			= vfio_iommu_type1_dma_rw,
>> +	.notify			= vfio_iommu_type1_notify,
>>  };
>>  
>>  static int __init vfio_iommu_type1_init(void)
> 
