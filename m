Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EDF3F4CC2
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhHWO7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:59:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11302 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhHWO7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 10:59:19 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEeVRq008489;
        Mon, 23 Aug 2021 14:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=v8F/RhanCJlWO+hOwe2t28EnIAMOLgMx/3ynHoqmXb0=;
 b=UdJCNf1uVC7lhpiZEndo3VJHLRXb+KynglITFco8HWurRIPAnWewpdrWzwXbmiQUPsuF
 HcEYmVJaqSYdedzfjTfxgUfPRIeMbQmWxthb++oxio58QVXp7F46AwxN5p985H9gI9ve
 9aVxnMu8uFYWG83KAv0/t+vX8cXg56P03eqVcz4MXHuKFVYCjRMmkLIJXNfb4dwbRoJC
 KODGSX5zCwfKo6n3o0xZ88TzU65gjGfkrBOdrMuEcjzKzlRQzX1ke2m/9gXjYogpHcPf
 +ZHcmY8SWV2+hDW/LjbA+zSxr/3uCHYmutgI+owH173fZUykUsFqhdZ+rsNZGGgc8nB9 jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=v8F/RhanCJlWO+hOwe2t28EnIAMOLgMx/3ynHoqmXb0=;
 b=uAKztccq4KR87z24h/kvuRELv9nvPUQmu8FFkD4w5wggcb8R18Z5D0QrAadj4W38EB4w
 UQw6wSaAA86Jx1nUGhWbdT3Y6skNpU60DrNBC8pqYJfEk99g5UE18/xjf4ICY7H1HW7m
 920TP8NOTOMWmkLTbGQ16rwogYNmeR5fXyGrtKf8R/ijnpYKW0gSEjlladd4Z1xWyv4b
 EgeHg4iYK9ym2aPUIvfo8vuG87r8BTrL5ThOtblz9NL0mz1kOD7HvUMQmWFhc6o1Wevw
 uIK5Fc6jEfOWeR8ULUqe6kDvl013xdhxzfP+tAA/MMdWNWspoCjzPz16mhDiHfEzdlEg Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwcf9qvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 14:58:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NEtHCl029457;
        Mon, 23 Aug 2021 14:58:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3ajqhct2w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 14:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJyYxZH48EUBEZRyW8XPxtv9uV73KPqs1DFNz56UopZuCamN4fDes/x86rxRgacavUnhWnoFgKHRhjZHlRf+0SNPpkcx0L6uaMOUX30gVNSwzI2jzGDYTLjFREoQuOO4OW1duvHqVb9UPoonDgddum99GU/WbggHxDWapYa0NZldYIEzARfHsIg3KbX2UrwDBWvMnYXX7K0sNvateUfY2jp3glKix21wFtzxLT/Dv+ZPEDsb6XVTjoMqv7U6B3t3u3quxtnLmPh339j3t6JaaSA3Me/OOxhc9V6beYPzUfuCDoCiIzXqM7p9RZb8g8cFiSNdCYkiiUrEit9njhpzkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8F/RhanCJlWO+hOwe2t28EnIAMOLgMx/3ynHoqmXb0=;
 b=ha5TJWz7dsCyxj0D3jxae0feUciymXLqlGhyk0MeSNrun/KavLtkAtoX57nHzkpqmefSJnzfDl0SGKo7CTyCbh4hmHkFsYUAtFpWLw2uWjxnTC+6whCdXXOyaO8Q1QzxNxNMVX0cmiYwiY9khhq/j4Cev0bLwi1SvYvtLLkNuw0u5Va4fXJeTld264frwSemrelRSTSYDS8aY+ENNtjVgijIfmdR9kYyuoTS2ozbaHg3IDqaOHkR+8o4y/eWLIXIuFXIdIRKJIICehaQQv0hUL06kOiW7hq1LNRY0JzMSt9EdOhTdZsSngZBo9iPdG88c9bKTKPyfoKX62S9sgTNXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8F/RhanCJlWO+hOwe2t28EnIAMOLgMx/3ynHoqmXb0=;
 b=qAmoAgfrBmNkm52DDsG3qncjF7bR4C8fq5/Xf1Wggxw5cKwZ1kwly9qAJoBh5r/a7fSuIMIHyTzo3IuNmzx/qRXFK6+AcrnGSioiu0FUnIiAboup+bLwz9bi5Gyq21BVPLsAL5wyqan80F4JNboUqyV5uJT9PuJ2ij5O7ld6J9Y=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB2838.namprd10.prod.outlook.com (2603:10b6:a03:8f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Mon, 23 Aug
 2021 14:58:31 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::5cdb:a037:dbd1:dcac]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::5cdb:a037:dbd1:dcac%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:58:31 +0000
Subject: Re: [PATCH v2] vfio/type1: Fix vfio_find_dma_valid return
To:     Anthony Yznaga <anthony.yznaga@oracle.com>, kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com
References: <1629491974-27042-1-git-send-email-anthony.yznaga@oracle.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <244084b3-83f3-533b-4211-5c7fa9404074@oracle.com>
Date:   Mon, 23 Aug 2021 10:58:27 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <1629491974-27042-1-git-send-email-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0050.namprd12.prod.outlook.com
 (2603:10b6:802:20::21) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.217.55] (138.3.201.55) by SN1PR12CA0050.namprd12.prod.outlook.com (2603:10b6:802:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 14:58:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17e246d9-9bf4-4d25-cf90-08d9664678b7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2838900774647CBC10933642F9C49@BYAPR10MB2838.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2OHGny0jk2Hp8WCvLSMsRapx/dso//Tb1g1DBy0NF/WxqFPp1Fe0ZFL5K9jfZUwlqZHI+/Wg/leTVvze9DxbsqfvPEd16Od6qaXymHtkX5WTt7hoJeS/ar3CoX0Qb5KH4XFBSSr9aAxyV/o7kneIgJ++ut9jVC5RQjmt9ngrywDhe1Qc8Tvp9WRbCLbmloPYTfm7fybfc46Ej5AcJBhMgth3mlOB2TJA9FaW+Qdptpq0RfjV/hR6Y+IJn8YLkBjeVP3UxfzY6/9tch4pLbnUKBIbrbAM5a+qDe9rYFT7H7FlqVmLDNx8E/8BgaJwoy9SRPQRUDeA9zKgtpBYDtZRvCncYPr4i3653Oxf2ihDC4aW+8iCYTHTUBNmOoVTiy3NIxqWCOzvvy3Vg8JlRfyVQUW4I8ItqJN0tdU35UIWbYiTpkGomfuoIM628qaeBI9mX6b4fZxBh/ESEQVW8S4onGqPSsi7na7SdxwGWPgWNzaNyjqYmZy3IShhSxHm009vQuGPFJpAFr0dJF8oa5ezi/cRZMeP1Jsgx1PJNW1fER5fn47Ft9fvlGZPctxlAB2VXGTNod0Cswp1HZyrEAVu1gUOi3rUKnzAqNkXBEXAJEBTi1AWSZYHPOExH7yNgJfmUGT6zsaR84BkcdaSMiBNnXim+K3pyf4A5N7ftt20I0FOP1DLKSO/WyrfBqZ5fWRGNyvVD9hwoDM5PlD12aYlyExcO1EYbVnOhE1VlFzX70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(66556008)(31696002)(16576012)(4326008)(508600001)(6666004)(6486002)(316002)(8936002)(2906002)(956004)(86362001)(8676002)(53546011)(31686004)(36756003)(26005)(44832011)(5660300002)(66946007)(186003)(38100700002)(36916002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjh1RDhKYm5RbEhCc29ZcDBUUlI0a2lYaHJjWlNHMnVFWXg2dzFHemlFSzhk?=
 =?utf-8?B?cnBWc0NRclBZdU4vblB4cXhUc2RlSGhKc09CWnZDY2hJMXpsQkppckxDcml4?=
 =?utf-8?B?UFgyT1ZBaGRXZU1lRjBQSFg3bDNwNUhEenBpMHVrKzN5Y0hxU3oxRWVkMUk2?=
 =?utf-8?B?MkRiZkdJUXE5QUNTMm5nZkxjNFlNNnVSc1FCZUhrUnFHam1xZjF4VXRPMHZV?=
 =?utf-8?B?OU1DSjRlQ2Q1T2w4OFlXeU5VMCtuQjQ2cmJaMEd5aDhsVmduMlpVK1E0NGlU?=
 =?utf-8?B?S0k5WTErQ1ZxMVMvQ0FmSnRMT1JJVDRNb0I1RmRrR1dmOWkxSDhyTXJ6UjNh?=
 =?utf-8?B?MHJRQVA0RGtISkozRVhGS2dpd3VyUGVJY3FhenlaWWZIMUhnTnhMVWdXK2dn?=
 =?utf-8?B?MldZaWZqeUxrclZVNFk4Sm1GNjlTZVRnV2E0SlpSV3ZXMFRDaUdGeWwxSUtK?=
 =?utf-8?B?RHV0M0hsOUo4TDVMMFJmY25rMU0yM0R0cnJvKzFzVnE2MU9aM2VZZm9kWFZU?=
 =?utf-8?B?V2JPREtpbGVnNkdaRUpFMWVsODNYQ0dOMy9Yais4S24yU0dDOUUrMTJMbnkw?=
 =?utf-8?B?NDVXUDhkSnlsS05qQjJrNWxvUWxyUEN5d0RZTzFmT0g0UWl1cThOejNQSXJC?=
 =?utf-8?B?eS9DeDR0T3hJZm1zeDl5L0NPOUk1YWxxNlJjUmV6WVpINGRmeDNHelhzOGc2?=
 =?utf-8?B?N2xaQ0grZkxwWlVEZ3ZvSThiMGZyOW9FYUF6VHR6dzdtTVgyK0k5RkpVMHB5?=
 =?utf-8?B?ZTdrRUxRbHROQ2JxK0lpUEJ0NnRKcjM3Qlg2QVhuNzYwdm8wenZIREdHRHhm?=
 =?utf-8?B?UGxEVThERlBuWUpTZWp6SjE4TVNqSXpJSUFwR3EwMVc3VHZHblhrRW4zcWxW?=
 =?utf-8?B?WFZWMFBMNjU3Mk00YlMra0tScDVBbTRZb2p2Vks0WFplNFlxV0JTUGJjL2xu?=
 =?utf-8?B?dWdGcjg3ZFhTTkpEeWtaWWFXbm1TbDUvOTNFRFRWc1VPUVV2dklNdDEwaVpQ?=
 =?utf-8?B?WENqckJMRHpoZHBMVnZpT1ZCWlB6NFA1ZGNKL25kb1ZNd0JuNnBvaTdSSzdM?=
 =?utf-8?B?UVp3QU1TRzRCTmUxY2tERkFEZWNDbzRnMWVPM1MrVnRYeXJBRXJScUxSbUtN?=
 =?utf-8?B?WFVsamZkMVBYWFgvYzNrL1FhckdBWWR6NEJ0VjZWL1Q4RnMrT05vSnZxZyt1?=
 =?utf-8?B?c2JEWEpXclVWb21mUVlXZGQvZU1zSm03eXp6bGlQT1pGaUwxRkd6RktpVmxQ?=
 =?utf-8?B?RHhaS3Y3YTV4bnUrUDhkdXVGODNpamFjRC9rL1hkeEN4WmV6Ni9zVHpNbUsz?=
 =?utf-8?B?SjVSbDJYSUpydXN4eTVNNGRrRS93MWl3TU1RelUrd2N5eitUZEtvVExJTEJ2?=
 =?utf-8?B?Vk5PVFNURVhUam56QVdqNXlFVndHUmlOcUY0T0s5QStuY2JyK3ZUcDZSenZN?=
 =?utf-8?B?cGxBWmsxZEF0QVZMREN0amR4U0VBOVpNUTNsV2VFa2xlSWE1aUJvWUEyeFBC?=
 =?utf-8?B?R1FudUpZSUxmRmVLQXVUczZ3OG5WY2Nza2JvWW51MFhLNjk3OW5pd004RVRG?=
 =?utf-8?B?Y1doL3dqaXRWNTUwenFSZEVMakFwTGtlNmNxa2lId1FXRFNDMEh3by9KdmRE?=
 =?utf-8?B?UW9WUG4xSXlVT0ZXN1NLcDJObmNJd2FEcm1PeDM0MDMzNWdFQ25UdDh3L0Rh?=
 =?utf-8?B?V25VN0dzZVdOV0c3aEx0eEdKUC9YZE1YWmtITU96SC9YTjJWODVuM24xaVZN?=
 =?utf-8?Q?tMLJjxXl7ScWWZ/4m+8awVwaO3skRSA4EcnIwa2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e246d9-9bf4-4d25-cf90-08d9664678b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 14:58:31.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MO/eclRrVBFtqOx1SM1pTM7ZlLSJpQeQ2V2PrA/4aXep+yc4oRK4UPlFPAaoxF5NZucnYsNxgb244mntYmmctdzJAdEaxGmjEBPPyj8hMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2838
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230103
X-Proofpoint-GUID: 5A7w3O4vcmf4giNguKD74txziW17M7y9
X-Proofpoint-ORIG-GUID: 5A7w3O4vcmf4giNguKD74txziW17M7y9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/20/2021 4:39 PM, Anthony Yznaga wrote:
> Fix vfio_find_dma_valid to return WAITED on success if it was necessary
> to wait which mean iommu lock was dropped and reacquired.  This allows
> vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
> avoid the checking the validity of every vaddr in its list.
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
> v2:
>   use Alex Williamson's simplified fix

Hi Anthony, thanks for finding and fixing this.  I suggest you modify the commit 
message to describe the bug.  Something like:

  vfio_find_dma_valid is defined to return WAITED on success if it was
  necessary to wait.  However, the loop forgets the WAITED value returned
  by vfio_wait() and returns 0 in a later iteration.  Fix it.

With that, 
Reviewed-by: Steve Sistare <steven.sistare@oracle.com>

- Steve

>  drivers/vfio/vfio_iommu_type1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
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
