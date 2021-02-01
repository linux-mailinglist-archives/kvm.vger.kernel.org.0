Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE66030A80A
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhBAMxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:53:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBAMxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 07:53:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CZgER022130;
        Mon, 1 Feb 2021 12:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iHP5W9IU2nvRssfhL52u4LvhrQo2Qsjj11ArI1YBwcQ=;
 b=KAsElMWedmI38cDmEUNUlwyVC7CfdJi+cKSfnssAptG1j1qdT95g9kUnVEMJPQw0aaUF
 eebGF7Db/Qw8FOhVuQodwns5FCfqUshItJjJ6vXTqARrp5hpvMzwEtJ81z9X6NYPVevo
 vz+kze6ToAuMmSDLH0vkj1rGUC2sidFcSlG9yRE6o3zCOlcS+OAcCtIcwQ7jSu6CthMj
 oRh83PsxXqMcv7NNJasURcH/IRHgdZD3CPxL4JFvIT6kIU8Ps3toe9bZ5ceJl/30pvgD
 jHG9Bbg/BVUTbF7lvZ2ne71hMODjZS5QEWja8Daiy+WqrYpQAW7hyHXbh0esKmYB2ggu Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyan8e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:52:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CVdk4190857;
        Mon, 1 Feb 2021 12:52:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 36dh1mb2ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xm89K/tKl64owgrR/p/od4ggjhOLwMyue2LbrX3HJH80zSSXxP7OF6rP4hTwGw/c2iu/zBvH1AePYL2BU4BRgKDkQ0iMUZMGLGtw7pzkmXDrzW7Sd5wcZp4Ao/rkf3eAJkNNoQYFET4bL7k1bS9cD+BkHYYLQkZ6VxUNKbkwH7SE7ZzDvxiroGaSTfnYGsfgbgPZVy45FJuF5HzjCretgSRNjVMlspsNAgRkZYaRA1riitZ+7oABul/BcjRYW0Jec0Uz2n9Vjr9vC4eNma6KW+3AZK1ecEhDEuifT32u1hTp7nw+NA1Vq8gW0YTccK5IcYe1VmMdEK6d54OwmYIiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHP5W9IU2nvRssfhL52u4LvhrQo2Qsjj11ArI1YBwcQ=;
 b=lu4VD3NNko+t187tFWuUGDespFMJ6GtNuvkAvrDoui2aY/8n5DAbrBEVXHajL5W0xOXeLvPWFT23LUv/57r1dtz1izucXPo0082LPmpwPte5ByElgelgXOSiH30UwBFzT7+gdGyav8L+vojGnzaGTWk5Y86rOV8JVqobXNZ0VzM2+XSGa3syUAeSMcOdHwlVsOIkNH4MhqxX267Et/bz3ThIQq6GlXmADKUf2bwtzuClDxizNh4OdtF4UGqNXSy1tOrFh4zBYOumHHZXFvYlbnULIbW766RlaMV1QCSzSke8sdGCGVoaPgAB+6VGeIjU8WY1eKImW2vQkS0rnQ48wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHP5W9IU2nvRssfhL52u4LvhrQo2Qsjj11ArI1YBwcQ=;
 b=qsq8S3pi6Zh2qC7jyByWC7JQU6DJ7SLzAOuKOCuZGEssLuzZxEFCYkea+5DIjwPL8sfPMCNDKhgkE4kO5xlMnof1cnWErTcgwSOdcxSUoDUdhgIUbo7/PkrqfyC9HgVIlN1fT7W9ghEu4ifg7iP5i+dj7WEWI0eYKeJYrHaiqYM=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Mon, 1 Feb
 2021 12:52:19 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.024; Mon, 1 Feb 2021
 12:52:19 +0000
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
 <20210129145719.1b6cbe9c@omen.home.shazbot.org>
 <b3260683-7c45-4648-3b4b-3c81fb5ff5f7@oracle.com>
 <20210201133440.001850f4.cohuck@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <b7c5896d-d3f3-9dd2-15fa-a8137d56964c@oracle.com>
Date:   Mon, 1 Feb 2021 07:52:16 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210201133440.001850f4.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CH0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:610:76::15) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CH0PR04CA0010.namprd04.prod.outlook.com (2603:10b6:610:76::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 12:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72dbea13-e692-413a-efa6-08d8c6b035f2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB357362B330E669E26E188FDBF9B69@BYAPR10MB3573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFUUP30tZW9KdIl5ThMa1cxOqNc2gEAM42uZMD3ayYHBRt2ItSR8d00WBbZR2cYmLC97qO1E3aukPlKte6kQ41Ww+xWt0d30SLYP9nRbwwjsiGQMGVsIFUq55jgE3S4a7ROoIpeOFX+g9VNWm5ZJiIl3df2Cj/gOMc6DtTIl7UaQLuari0r2nzNx/j1/hWeA32Lex07AaRNAxT78dvVrxcXyG/HI/tU/rWkg4tARVhGdm3LSCvFBNNs9G+G5eV6pLl4VJQpyTeevny1TKCvx9/zYLG+tdyffh6AWe+EJ6PQP7ft5pjcgEB9bmQIAutyf6gF+mlj7R9VQp+WLRv50tOvpZQA5pSVUwAiHBU7pUVEvTSbhMTnUdv7sHDpf/muZpl1879ZGoEG/OMdFdUZ4+ZmZMz03dqtA/dILdEczuEnTD/OH7FSF/YopNrp1KwCpHbOaBhkZRItEBl1pXtot64YQfzodi4oBnpACQorWOmeR32dye5JcFVvJ/8LO1gMMsVLnpr0vGGzj3cieUh5Puixb6C6TZdS/N2M5HI65PIDSxZXzvng2Fpl2sXuFR+4BR/6BzKCThqFGQWW80iCmd7dMmBp+l3avbJASakM9378=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(6486002)(26005)(2616005)(66476007)(66556008)(956004)(6916009)(5660300002)(83380400001)(186003)(16526019)(36916002)(4326008)(53546011)(316002)(16576012)(8936002)(31686004)(54906003)(36756003)(31696002)(86362001)(66946007)(8676002)(478600001)(44832011)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVdKS0JCaDFYRjBXZzhQMHVVbkFudHVCc3ArRW5EeUVKOHZQMHhtTzViVlM1?=
 =?utf-8?B?azh1VVRtTkNmejRTaGQ0VzROSE03QUl6b2Qvdkd5UGlVUkRNcGJ2bGoycTNF?=
 =?utf-8?B?RXMrYzZlRmVQdUsvQWY3RGpEeVNlT3VEOWNuTkxFVmsxc09raHhxLzNDNEFo?=
 =?utf-8?B?QWIveU52MlU4SVRyV3g3MGNZRkx4blVLQVZoYWNJemhtdFh6RWZRSU8rZisr?=
 =?utf-8?B?UHRwSENWdVp2TGFBYitIRlhabVVTSXBvN0dPd3gwbVdDL1BmZUdBemEyTG9y?=
 =?utf-8?B?czIrVmdic0s0dWJhOE85TWVJVktweUc1QjJtSUk3N0wzNUFqZXJDN3dya0J0?=
 =?utf-8?B?T0NObkV3MkdTMDdROUh3NkJWb1NlWTRmYzVhUFlodHZnaW1HT1JSdHNseVFv?=
 =?utf-8?B?TG92eUlnTzhldzdzU1k0UjA3U3FnZVlIaG9vTlVqY1ZwWEhiN1NQZ2c4eVVB?=
 =?utf-8?B?RHQyZ292QjJEd1hpQWlZa1lCYklPY3cyRFYyMVp1UkxWN1hsVkVTZDBYRVQ2?=
 =?utf-8?B?bzlMWE1TU1ZoRm1LWHdHRGVNQ21UdFRyZHdwamxUQWVtS3hkNlBlRGs2Mjl1?=
 =?utf-8?B?ZkRGc2ZEeWdvaXoxSE1UNml2clJNbjdCRUU0ZXFxZEtKQ01sZ1lHdjZPbjZY?=
 =?utf-8?B?ZFcwaFVpcTJsT0RWaGZydGtFa3M0SHBTbVZxaFVpRzNDeGdLWTd6WGNuZnlH?=
 =?utf-8?B?WjVGZXJNbXZPSGFTUVpINkM4djJuMEI0ZzBzUlArd1hYaGtwU0xYd0MvbTk1?=
 =?utf-8?B?R2NOQklwd1NFaDJkb1ErYXVTT3B6Z0pjY0xQbkc5dTcrUHZIbzJpZ1N1Q0FI?=
 =?utf-8?B?S3pFc2kwT1p0N2dSNmhrVHlSV2ROZWtveHBha3h3djAwTXJaYyt6aDUzVWZQ?=
 =?utf-8?B?Q3VZb09xU1FEOEhLMGxEU0lydEJqbko0Z204YkZoRjVuL2RxSVJhTzlFVGVI?=
 =?utf-8?B?b1p2dVJNTXUwQ0FmK2pGWFEyQU1iRkJoMElaS3d1OE9XblZZT3Irc01mZFB6?=
 =?utf-8?B?MkYwc2RyYmd2Z09OMFZVY2RQNEZGLzk0dENqZlF5TExjM0RYQWZzdmQ1aG5z?=
 =?utf-8?B?STFBUVh0cW9ONnkxOFFVR00vTFd5SCswczliWTRaRytxK2E3cFR5cmxmYWh0?=
 =?utf-8?B?YUJZTlYranVNcmw0Y3duRWY5Vkp5Y3MvUEVKL2RUcTVSWHArOEpDYkxDTHZS?=
 =?utf-8?B?aGZpSVp2RER1cDg5V0J0Si8rVlFFdmlhdnE2R1Y5bjhpa0xYM2ZKREc4WUF5?=
 =?utf-8?B?eVBSR1gyVmdQYi81ejJJb1hwWDRuYmlEQk9TTmFhbC84UDNjd2tJYzViTTMz?=
 =?utf-8?B?OGVsQThWaHVzSVYzUHJIcnE3OW1vd0hzaU16Tkp2VjJ6Y0dST1VXbkphVGto?=
 =?utf-8?B?Vm0xR1FQdThiLzkyajMxcXFoY2p2VEc2YnhUWUs4dGdnTUt6RXE2ZDBpRmIx?=
 =?utf-8?Q?vlu4jVPp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72dbea13-e692-413a-efa6-08d8c6b035f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 12:52:19.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9mQXWVH4Os+1ZavXjWcxpo5yqPVVsj2vvdpbekydiGXlOY5DAai6vRAs0dee2Y9DVvZ7sSIx3sASTb0XDZpip/FiNeKAzM+y9eDSpowNUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010065
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2021 7:34 AM, Cornelia Huck wrote:
> On Sat, 30 Jan 2021 11:51:41 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 1/29/2021 4:57 PM, Alex Williamson wrote:
>>> On Fri, 29 Jan 2021 08:54:10 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> Define a vfio_iommu_driver_ops notify callback, for sending events to
>>>> the driver.  Drivers are not required to provide the callback, and
>>>> may ignore any events.  The handling of events is driver specific.
>>>>
>>>> Define the CONTAINER_CLOSE event, called when the container's file
>>>> descriptor is closed.  This event signifies that no further state changes
>>>> will occur via container ioctl's.
>>>>
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio.c  | 5 +++++
>>>>  include/linux/vfio.h | 5 +++++
>>>>  2 files changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>>> index 262ab0e..99458fc 100644
>>>> --- a/drivers/vfio/vfio.c
>>>> +++ b/drivers/vfio/vfio.c
>>>> @@ -1220,6 +1220,11 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
>>>>  static int vfio_fops_release(struct inode *inode, struct file *filep)
>>>>  {
>>>>  	struct vfio_container *container = filep->private_data;
>>>> +	struct vfio_iommu_driver *driver = container->iommu_driver;
>>>> +
>>>> +	if (driver && driver->ops->notify)
>>>> +		driver->ops->notify(container->iommu_data,
>>>> +				    VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE, NULL);
>>>>  
>>>>  	filep->private_data = NULL;
>>>>  
>>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>>>> index 38d3c6a..9642579 100644
>>>> --- a/include/linux/vfio.h
>>>> +++ b/include/linux/vfio.h
>>>> @@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
>>>>  extern void vfio_device_put(struct vfio_device *device);
>>>>  extern void *vfio_device_data(struct vfio_device *device);
>>>>  
>>>> +/* events for the backend driver notify callback */
>>>> +#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1  
>>>
>>> We should use an enum for type checking.  
>>
>> Agreed.
>> I see you changed the value to 0.  Do you want to reserve 0 for invalid-event?
>> (I know, this is internal and can be changed).  Your call.
> 
> I'm not sure what we would use an invalid-event event for... the type
> checking provided by the enum should be enough?

I should have described it as no-event or null-event.  It can be useful when
initializing a struct member that stores an event, eg, last-event-received.

- Steve

>>>> +
>>>>  /**
>>>>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>>>>   */
>>>> @@ -90,6 +93,8 @@ struct vfio_iommu_driver_ops {
>>>>  					       struct notifier_block *nb);
>>>>  	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
>>>>  				  void *data, size_t count, bool write);
>>>> +	void		(*notify)(void *iommu_data, unsigned int event,
>>>> +				  void *data);  
>>>
>>> I'm not sure why we're pre-enabling this 3rd arg, do you have some
>>> short term usage in mind that we can't easily add on demand later?
>>> This is an internal API, not one we need to keep stable.  Thanks,  
>>
>> No short term need, just seems sensible for an event callback.  I was mimic'ing the 
>> signature of the callback for vfio_register_notifier. Your call.
> 
> I'd drop *data for now, if we don't have a concrete use case.
> 
>>
>> - Steve
>>
>>>
>>> Alex
>>>   
>>>>  };
>>>>  
>>>>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);  
>>>   
>>
> 
