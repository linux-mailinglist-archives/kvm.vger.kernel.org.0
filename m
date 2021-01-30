Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4403096E5
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhA3Qwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:52:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3Qwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 11:52:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGkSEb037576;
        Sat, 30 Jan 2021 16:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oq7EBJ2dGEQC5csXHr8t0H4DOWzjvaGnZUTP+v/huEg=;
 b=oOixk/6Da0wXHwJ2aZKL3ntDru+QNvt/mH+7eJ3H6+9pfpR+bMJcKYbQv/hMhvEnaHZM
 KGxiot2f4mkgVp5tGGL8u+ym9S/rLcESGAITdrKMlprbQUpklIcU8bbDzoXIjBg6mdWC
 k23WFWNsX/fKJI6jKhzTV3riSAr9B0O2qmMM6p20TOFewQ3SF3iIjYOMe/p3XEYLLjhP
 CmE7+wj/W1qT7Z5YFJD7gd3Auj8k4l1ei9k6zAJqNJsHTZukzZZmn2Bq7YzEa5YYv8IU
 fXX8fVpN8ssZQxwGq/GclpNx6FtPhGi9VI7zhp6ohR5ds6BPxS41Q1WOoabWrXE2uZ0x RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyah4u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGikm6151556;
        Sat, 30 Jan 2021 16:51:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36cy8yyk71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:51:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSeqqHmM4RlytAUZ/U4z4KE+3WABCfePCbcSd6GAHg6AIPw4aaEIy+0q3rMqihn5PQVgNcDMgyKBFHF9afbvwZD7OxNx/wrtCtEj+Zuf5VWVwx0f8Gkx5/WtxbfLv4oS1jAeujwQbvxMjOKFsGEL+XIvXGKJzirR6y3pokFEFDtUe44jCioyfCquCqy04KQdC0izs7XOW2g+SsQnXfQLOvLrkz6tIvhP5KB1JwgY3FHbVrAOgGBut/U+98LYrnihtnjIDJtwv0WuDgP37Bi9UC1ThxTnl8Pshr6FIMRjGJVpJEyB7yJr7tSM2YtJ/LHcI5Hn3eh1hrGHWzkE0df7xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq7EBJ2dGEQC5csXHr8t0H4DOWzjvaGnZUTP+v/huEg=;
 b=jTLWcLK9GcHGn5mCoRqZnbkgCRotdsK8mbtocRXRbZEpnFciJL8H8z/6DwYBgE0iddJc5rwHmIFWbtrVO1nHy8tmav3fFvoW+L/26iI1r2A7oyhGs3GZzYeDjUHznya7ocLKhUYffbp7miw52Tq3dzh0BrB7XXkVv+dBGwulX7VSCnC6YPBvdFjOfh6dwPTJmZ63v2YY8xqKjLnBFUeD0tamqAIddrKV0eAM7pD3dcfI0EKk0VIxIlQCh6UKlYrt/rKxY3M5224+Z35ngFvXQqFuV1MzFWbjHfXb0EEfo6f+0knoy+AM6+bDam820+GstUiNb6RN19hfG2ck4i+tNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq7EBJ2dGEQC5csXHr8t0H4DOWzjvaGnZUTP+v/huEg=;
 b=wmlIjQV+Emp3K52CCXFqMjRTW8uE6X4Wr6E8JZQyfOaqubMGtqmvMYQG7wytmUqtYzBR0SLXRenEYzb7kHhW3zkpvAdVcRYsr4ThwBvUZgR56aDFvsawNYt6ppn7cbp+oDbj3XKOYWbJTjAqLS5zOWVRYIkVonNaSQaJHNOrve8=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Sat, 30 Jan
 2021 16:51:44 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 16:51:44 +0000
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
 <20210129145719.1b6cbe9c@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <b3260683-7c45-4648-3b4b-3c81fb5ff5f7@oracle.com>
Date:   Sat, 30 Jan 2021 11:51:41 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129145719.1b6cbe9c@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CH0PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:610:b2::9) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CH0PR13CA0034.namprd13.prod.outlook.com (2603:10b6:610:b2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.10 via Frontend Transport; Sat, 30 Jan 2021 16:51:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4538163d-6935-4078-a148-08d8c53f5361
X-MS-TrafficTypeDiagnostic: BY5PR10MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4340540D2A50649D2D6539CDF9B89@BY5PR10MB4340.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5ZgFhfiAnj+wrXFzPb74Phj2LoLea2opiSWs8HUAH+JA7mAJUsboMJEqSzEdayNqSCw7+dHysxqPAVDXTucAvEGLmQgzt7+vDpZRM70b/6VWOwW4e2n5FK1UTzZAKidKkYDZ+YGp9lTRpYL0YnctA/Gkn3Tncb0EFGHeMbLEkl1Vjvnj47Q2eSYcupPPk2qC+iFIqTusbSCR51A4wPU8UBaPD5ehxiftb6effHNe6aMqNNLTU780ev7s9CJkbczESZvvGTanKkFXA7p/E/H6MdnTWjjHG5S6DLAPBGI6+D5c4CysfdOzGkbCGQuCMrICKYZkap/HKjXF4Dto2/oBLp8hItvnQri7cu3IXykzX7OkGjnVP7SijystJQzIeBgXwkRUERZ4kyDaIkdyxe3iOYuAYuunviY7W8lK77EjmZjO8uwKtSE0WkAtXkOFegs1yF5DbY0Y4ecDnupQB7oJUfQ8OwmdXLHjD5TNoynkGWm+oTj/QaeGlqtue/pmuYJQhdRSMgT+oznD/UKj3zADa5S6JOmXrzr4Z+ExMygFAZU2uCXbOYaFc51MGFNtiVxtqcJ41rmYHa36XhsxGpeolsIag1MxDNfgVIiqMnCdCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(54906003)(8676002)(2616005)(31696002)(44832011)(8936002)(16576012)(316002)(2906002)(956004)(86362001)(4326008)(6916009)(83380400001)(36756003)(6486002)(36916002)(31686004)(66946007)(186003)(26005)(5660300002)(66556008)(66476007)(53546011)(16526019)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djNoWVBCWXdRSHVKSHlPdUI5ak9UN2hxWXQzM3VZcjBHRFJTQTFlRHJCWHla?=
 =?utf-8?B?QXM1emtwQmc5RStPdy9FUHFrRzg4U3h2RGpDZjNQVTFaL3RtRGM1SGF5bVFn?=
 =?utf-8?B?WE44OXNuODV6NHpOVklBQWRDWnNqOWN0MGt2NFlZTVhXZXRtbjQ0RUpablJP?=
 =?utf-8?B?RzVPRDRPajdrY1pDeDZMZW5EOS9GSXZGL3kraHpNdk5ybHNQc2VpRE1WWEw5?=
 =?utf-8?B?OG5abjdKUFRsVW5rWkJMQnhsbW9tcmdYY0xnK0RiOWE4Qk1KUWYvRzd6dVhK?=
 =?utf-8?B?T1czZzhQUWwrRGlReGlPVDh1WlUyd2JscEkxSXJpTEdubXJBc2ZxQjRZUUFV?=
 =?utf-8?B?Ly9ncFY3dzQvMXpwbm9XWS8xUEllUnQydUkwcnd4dkt4MEwwYTZyS2l3SktH?=
 =?utf-8?B?bFYzOUZVaW5rSEpja3JSaERMUnR6VGVWaHAyRWYrdXJIV0xWZ3l6TkVxQmtL?=
 =?utf-8?B?eDFLLytOSWJJeUtnVnd0QThDRHlsU1ViUzVheTNoRWdIeGNwVVlkclFCbE1S?=
 =?utf-8?B?R2dudzBRWXhlUEs1UHozaUZHQ3ZqMDBzRzBVN1EzeGFoK3RwTjdLNWp2VkR2?=
 =?utf-8?B?UmVMaW85S0hHNVdPUlAxaHhGU3hnRml4VGltalFUdThSaXRTMGZ0WnNqbDhV?=
 =?utf-8?B?a01CQVJ2UjVHeHhteFdRZ216TklHMldkMmNwbnVkR0s2ZUY3aUx2akIvb1pn?=
 =?utf-8?B?S0VjcTc3dWh6d0pZWklvSmQ4OVZKRWh1cjhkTFNiSzF2dGdPeDl5VjQ2RGx4?=
 =?utf-8?B?Nm50UUlER3BZSm1DWlJiL0hVUnFjQkFNYXhlWWpYY1hOeUF6Z3JJSWlyQ3c2?=
 =?utf-8?B?SEFadE1zLy9RK1lXeXZ5YWVwSjNibTc0bWltRFNFaldOQXdkLzBBK1J2TVRL?=
 =?utf-8?B?Sk1BNENIeWRqN2hSWnN4SW1ZcEZTcERvT2dlaVJQMTNkZjVSYWFiM24xN21B?=
 =?utf-8?B?OEdWTFJhdkhySXRlZnVTOXdjKzhBNEdCYk9WYTlOZHk3QUYxV2lQQjVNczZx?=
 =?utf-8?B?WkxZSEE1c3ZucC80Nm84R1NtT05iRzEwb29WK3ZQS1hnbFJFQ1FwRDhmdngz?=
 =?utf-8?B?Ym1TTTJhbXVxK2R3TVVVelgvUXpyU1V1a1J5RlF3NWNFdDUyTmVKRGxsY2xt?=
 =?utf-8?B?dkp5dTV4ZkZRTlVWTk1US0V3dWFybm1FYk5CVnJ2U0laRUZ1UHhNT2x2WjJz?=
 =?utf-8?B?aHg5bVhXTUNNOXJKRGxSME1ZdFBiYy8rdGRRVGJ5RGNMSnhkSmEvckcyVmNO?=
 =?utf-8?B?MnBIUExpQy9pek84dFpVWFlZVFdNRGV0aHZUNGIzTUcyWVFld092QllYNU5H?=
 =?utf-8?B?dFJuSDVFRHBjM09IZCtscHFyVlFkR2tXMnl6RnFPT0JPVnBhZCtGblZYbXQx?=
 =?utf-8?B?RDVuODRHRXNZTWk2dnA5ODQ1SlQ5SURVU1FXTENYR3hFam9nNDhvVjNkUzZC?=
 =?utf-8?Q?TwStVA8C?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4538163d-6935-4078-a148-08d8c53f5361
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 16:51:44.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvday9wI70YdlAV4OanUaGzUQYNBYZMaIOyY0l/NKNJI4QpVY3d1ZUdZZXzk/RsLRuwVPATjr3ug0aJfO/D3f8FyTlTGIJbzQrrwTw9cR/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/2021 4:57 PM, Alex Williamson wrote:
> On Fri, 29 Jan 2021 08:54:10 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Define a vfio_iommu_driver_ops notify callback, for sending events to
>> the driver.  Drivers are not required to provide the callback, and
>> may ignore any events.  The handling of events is driver specific.
>>
>> Define the CONTAINER_CLOSE event, called when the container's file
>> descriptor is closed.  This event signifies that no further state changes
>> will occur via container ioctl's.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio.c  | 5 +++++
>>  include/linux/vfio.h | 5 +++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 262ab0e..99458fc 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1220,6 +1220,11 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
>>  static int vfio_fops_release(struct inode *inode, struct file *filep)
>>  {
>>  	struct vfio_container *container = filep->private_data;
>> +	struct vfio_iommu_driver *driver = container->iommu_driver;
>> +
>> +	if (driver && driver->ops->notify)
>> +		driver->ops->notify(container->iommu_data,
>> +				    VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE, NULL);
>>  
>>  	filep->private_data = NULL;
>>  
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index 38d3c6a..9642579 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
>>  extern void vfio_device_put(struct vfio_device *device);
>>  extern void *vfio_device_data(struct vfio_device *device);
>>  
>> +/* events for the backend driver notify callback */
>> +#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1
> 
> We should use an enum for type checking.

Agreed.
I see you changed the value to 0.  Do you want to reserve 0 for invalid-event?
(I know, this is internal and can be changed).  Your call.

>> +
>>  /**
>>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>>   */
>> @@ -90,6 +93,8 @@ struct vfio_iommu_driver_ops {
>>  					       struct notifier_block *nb);
>>  	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
>>  				  void *data, size_t count, bool write);
>> +	void		(*notify)(void *iommu_data, unsigned int event,
>> +				  void *data);
> 
> I'm not sure why we're pre-enabling this 3rd arg, do you have some
> short term usage in mind that we can't easily add on demand later?
> This is an internal API, not one we need to keep stable.  Thanks,

No short term need, just seems sensible for an event callback.  I was mimic'ing the 
signature of the callback for vfio_register_notifier. Your call.

- Steve

> 
> Alex
> 
>>  };
>>  
>>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> 
