Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F2C54D298
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbiFOUbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiFOUbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:31:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD1E544FC;
        Wed, 15 Jun 2022 13:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWlra7hkmxj/rWvcjJPuzijRSh0ik1uWLFBLLEFKqmzG/FPdyhs5lMV7uLfPKCk1d1TcF4AezaUQMedlOq9yLhteslOqQhWwVwztxMWcB+sujw9XzxbDTfaOFm1nsoavvRGa8oSn1KZG2BsP6seWuNYczDxI/ZlQ6oSGWWGfdt1fKWv4TuDIUAFDcrRjkMIlKHGH8VG63tjPveyP9ySxrSF8OVgfM8VEI2UG+z4ptkNaZVC2uhmLtdZdhywkgwR0NJgjJF9CnSTYXB71dNbYfm8K6aJAABtqgh7pFkZRwE2jQY21HjzlxcZL4XYIKuebMldBJes/4wGsdYkTPzz8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhatQNvfxf7iLHPCCGVJDAzu9iGLS7PiZi6bq/lxBXg=;
 b=AeE8AjzswhxHI2ptT5NJBm1KOOfMddzZQ/wjEjCZ4ck6OQuE4LtjGq4FZtUygjU0BrxQ+/af1z3NpkWq1GQcO9PElSjTUO6w+/Shcz+elRw4aKJBJIxt1sOO8uddf7sgM7q5ieye92yd7EjYfayTtvl/5rbPabctjArZ4918RFan+/8zfVV0m8UurnyWJvMPsRlpaEecg+ZsVhEIwEZ9dAcvZRPB+i+LvyvlL+qbH/mD1iVbXZa13QjBHK2+1b6Dk/Z58aujp6+BbUHa/5v0GEIpeT4D4p818eIBHyDea7T/c6UitDmjXVH5BOgciedfKrS/gKkjiEGpEGArPgYHQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhatQNvfxf7iLHPCCGVJDAzu9iGLS7PiZi6bq/lxBXg=;
 b=QFQdp+YIUaBZaC2pUtm0MfuO9qAE/RppP4o6fZbAgzuBBY7Hy650n6T6yl+DrbtVIhb0xNJe6oADRDd6Ts9zC1ss/bBzqIzKFWHDTiQ3po4HuFYoqh8tBu6Evnjx3wAciRqCMw5DJssyqt5uaRDfj45qHUbjb5e+J9UUuOEXOdWBRRMcmmGQjRgbTtlljqJBmcNAkB48078DCEu78YjXsEoZwQz97XHuD0HqYXttIXxg4r3eRFflGSphbsxhR6Boi1gB4N3hzfK/Ytj9E11EeG+NX78CSXasM0rNCV5BOOREw+nvwTY3L//XZsytgiDG5sfqpdqFD+HIBgTuFLS18w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 15 Jun
 2022 20:31:39 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:31:39 +0000
Message-ID: <adab68ab-1f61-f975-8dee-f9f95012ecb5@nvidia.com>
Date:   Thu, 16 Jun 2022 02:01:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 10/13] vfio/mdev: consolidate all the name sysfs into the
 core code
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-11-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::30) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b37ede4-6a04-4e9a-68e5-08da4f0e0b37
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB264016E29FA79FE79FEE143ADCAD9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g88yLSd11NU9f/EXlW3ZZCyPn9yncy82Fy4ZqdYTLtkXKX5kaX8vaRjVyUQBqm5JpRxhgsGK7DVcwCsVdKJ5EXUxLarLfQTSN3bQCgfNhoSC3NVnxx4vUEhiF9Qe3ItvFNEmIR/6gFMrhv/IzqOJeVohu3hcdkeGFfMC/AvPyPyuYRXawNgf+7WHbdCVmNMksBvNX969z4XBkoPP20lxfAZPRqfz0bhmW65BnmiyI8uKMFIuDt56HnawlQE4to01yslrf+Jw/cJHmg4CuVjeu+LU9C/8gJY7CNas59iJoJhGMeA/agNMnfDzJEqCx7V7AF9QG2ZcKwDNkvzLqNWbwdjZwsoDppUCVR3QbrLjWPK3KS9vhgbM1vxyQnpyzhx8frxzLBjOZMsFMz0oZF/g0d7VJuUyRUClGiqRdGDR1h9mahgSxdmNN9J7sYs2uxSMXqHVOn6tQnMd7uTg7VXrc1T15gE/ZCnJu5voeo9s3VWLOjn5KKpG11thYEmzuVjcS4kmHJ9axn+JRD9qDJ63HEXwC1OzscgZAavHueZILA02CY2/VRq37cs9iEj3GsSbVfjhNJlJamQG0vvXc9LJhFLcX05R7KxplhsGGiFEOrglSeiL79viWXvjg8O2OUsglzLAmHJg0ksDJsYek8G8Xgxqmgcu0rbDdElj6KK1+VOH/vVCiyqTx7suzHWNdkQtqQu+l0td18uwCy+443gZoS72Wah/BBs/s+BsCbj+XoM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(30864003)(26005)(86362001)(2616005)(7416002)(66556008)(83380400001)(107886003)(31686004)(186003)(6486002)(6512007)(8676002)(2906002)(6666004)(6506007)(110136005)(54906003)(316002)(66476007)(53546011)(31696002)(4326008)(508600001)(38100700002)(36756003)(55236004)(8936002)(5660300002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlBSUmtUcWxmcHlKNTVwZ000K3NhbnlheTV5ZUhIZk93aTgydkx2NVA5L3BH?=
 =?utf-8?B?K2dQbGZnY1h0aEdETUMzYWNhVTJhUUJoeTlkR1lCUXVTSjB4QktSYk91RjZi?=
 =?utf-8?B?V3hlVngvZlVhZlVSSUxHelZyU3NkbTlReUtKS3RxTkhkNEYzakExaVlYUE1w?=
 =?utf-8?B?WXZZNDZhSnlCMDcyQ2N6T2kzSlZaYlNEUnpZZ09rSUV1eEFHNXZLcXh0Vmhy?=
 =?utf-8?B?eFd2bXRpaWUyYWR0REIrZHdoVjB6YU1xSWVsdzVEbWE2TGZmaisyRHFGY3cv?=
 =?utf-8?B?VGg4Uml2MmJuVGo1cjRuYUVydUp5dTdYeCthYzhBdi81Tmx3VVhQRWV0czFk?=
 =?utf-8?B?Q0srL2EwYllDNk0rMVdrKzhpSGpqd3FZa1VYT0F2V2JmMVRrL3gzT1N4YVg3?=
 =?utf-8?B?VGlQUnhPREJqNXJ6UzRNVUVWYjdER3IrUll1dW9UVWFVbUUwc1JTcjNIVlB2?=
 =?utf-8?B?cHFZNm5jZ3dFdGZCSm9GTXBPYnJOZXQwUE93Sk96N243RytuU0ZLM1E0SUdh?=
 =?utf-8?B?d24xNXRNYStTck9ETTVSNnJrbEt1V2s4WTRZSlU1a3ZWVG9PbWx6c2pWVzhn?=
 =?utf-8?B?YVFkQUZLTnRSSWREQ1plcjhLYk5RZzRuVEM0VFI3T1JXS1hSMFdYdlFQenNH?=
 =?utf-8?B?bXNLdytEaFN5VCt1aGRYQnFBN2RUb3BzNFkzNjc1dGt0amM3ejhPRmJkbUZ4?=
 =?utf-8?B?eHI1Zm5TUTEyWk9BSWtBd1BBRVFKbENmbWZ3RE1WSk5OcFFQL2tPdEE4bGZN?=
 =?utf-8?B?UW1OYURoR3J3clVTVXNaUWZUbTF5WExWVFBwYXBmRlBKVW9Wc2VOWURMN1pN?=
 =?utf-8?B?blBmcVl2bTl6UGMwZEtWbjZzRmJNeG11ejlPY1JwdnlQVVlYWkp1UEM2MUFX?=
 =?utf-8?B?N1RlRjV6cW1hTTlDWFQ4UWU3WFhuaFhHeWVEN1VnRTM0dXNLSlNLL0RVOVZl?=
 =?utf-8?B?UHZQWkdyTVZkNm1UNlBLMkpvOXJDcWFYSGdlOVdvek5odVNZdzFlbDNid1Vj?=
 =?utf-8?B?NHpmVnFrdnllT2ZaU1FpLzg4NUxZUm5XZ05PV1dQZmdkcHEwN2kwSHdHOVpH?=
 =?utf-8?B?M0lWeVdlcm1MdFlHTTk0cy9uZm1HcFpUT01UUXo5SGZ5SDJrR0svakZTRjA4?=
 =?utf-8?B?SmlUNWVZRlJTb2h3b1hOWkN0SmVXbElDT2YzYkh6eXoxWlVtUXd0Y2JqaW5G?=
 =?utf-8?B?T3pFS2NqNDdyelU2MWxlQUJ3WUxMNGRESm9McDV1ZkFiOHU4dVdBLzJWV2RX?=
 =?utf-8?B?Vzk1ZmhiR2RRMkxFcXVKVGEyWkRsWFJqVEtkYTlvN01ObzNMck9sQTlUQVZh?=
 =?utf-8?B?eEY3T1J5THNKUmpTMnlLL0VlTkJsUUxPZ3RuNHZ1UzFEVU1URVF3UG9UM1JV?=
 =?utf-8?B?ZGMxbGkzWVFDY3YxdFhoMXFUa2dNSnY2UDJkRFVUdEczRlRiT1NNTVRwazFJ?=
 =?utf-8?B?bDNGYUZzdVJyTDhaV1gxbWxVZ3p1ZTkxVXgwYkdpTUQvSlVpSUtFeFFrcGFX?=
 =?utf-8?B?QnlWZDV6RGVjQmdSVkN4cFl3NEJ2eEpiRzlXVm9VaVVjVXN2UnREZXBGdWti?=
 =?utf-8?B?WWVTQmZDL1Vvb0w1c2JsMERGVzkvUUxVYWRWbG1FZk5SUjZmK2JPdjd2T1pv?=
 =?utf-8?B?SFBMenpjWFBhWnN5cHBkOTlDNjh0cm1GM1RtZFN6VW8wV1dmeGF2eDBLbUtS?=
 =?utf-8?B?UzlmRyt5WHJnSXc2WkZ0TldVZnl0NElWQVB6S3M1RnhHSHRNSkJ1aW5pNXRF?=
 =?utf-8?B?MnZUTk1GRHUvOHFGSWIwalR1UU1LTWtLUTYybW91OW0rcGNOVkJrSStEN2NW?=
 =?utf-8?B?UjFtOGNkMVRGR2p0amdOb3E2ZkNoeDNOTFJPV2p3M2hWY2dqUVA2ZEZreDdO?=
 =?utf-8?B?SW41L0lBWm9QT3NCOXgwdGhXS1NLbnltd21QSFRDanBrelJrOW5ZY0liV2Fm?=
 =?utf-8?B?UjFGSCt0UGdkZWcvRTl4UUpoaksxVCsycE5XblNsSVJNTnVWUFc1cUxGOGdP?=
 =?utf-8?B?R05qQkxiYmxkS0U2Ynk3bmlHWS83blJCY0hXaUxmcWFLL2ZPRnZVVkFnV0xa?=
 =?utf-8?B?WGNPOExvVHBDd1RVN1NhL2hHLytNV1JiS1Y0a2pET1FIU0lrdFozTERReGta?=
 =?utf-8?B?SjZTSGtPUkRpWHZUcVZmZFlielhmSmFVZERGQ0JyMWUrR1pKSGZxYVphZVJN?=
 =?utf-8?B?REo3WGthRnhZZkF6VEZ0R00vMm1KUFVVb3c2a3lyOXEvVGtTaERoRTdqdVhp?=
 =?utf-8?B?U2lwY2RjVmF4dlAvS25zZ3k2SzJlSTlDM0doRytOdTYyemZTRHBnK1dSeDRx?=
 =?utf-8?B?WWpBTlVXWmtneU1IempRbEJ0K0pBa1lwbTQzZzNVWndIOTMyMDBiS2IrNEQy?=
 =?utf-8?Q?g39mEBjgyFjcAYiU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b37ede4-6a04-4e9a-68e5-08da4f0e0b37
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:31:39.2360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiaTIBaprWkAEJWKEm82WydtUn3joos/GmINIXk5u+UB2cqD3EOh+tjEES2MbQ4eWlXC6dAY764XIuTBuuzHaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
> Every driver just emits a static string, simply add a field to the
> mdev_type for the driver to fill out or fall back to the sysfs name and
> provide a standard sysfs show function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

> ---
>   .../driver-api/vfio-mediated-device.rst       |  2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  8 -------
>   drivers/s390/cio/vfio_ccw_ops.c               |  9 +-------
>   drivers/s390/crypto/vfio_ap_ops.c             |  9 --------
>   drivers/vfio/mdev/mdev_sysfs.c                | 11 ++++++++++
>   include/linux/mdev.h                          |  1 +
>   samples/vfio-mdev/mbochs.c                    | 20 ++++--------------
>   samples/vfio-mdev/mdpy.c                      | 21 +++++--------------
>   samples/vfio-mdev/mtty.c                      | 18 ++++------------
>   9 files changed, 27 insertions(+), 72 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index e9913bfb4393b..87d207744db79 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -219,7 +219,7 @@ Directories and files under the sysfs for Each Physical Device
>   
>   * name
>   
> -  This attribute should show human readable name. This is optional attribute.
> +  This attribute shows a human readable name.
>   
>   * description
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 44a418d897377..191e64ef70acf 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -138,20 +138,12 @@ static ssize_t description_show(struct mdev_type *mtype,
>   		       type->weight);
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", mtype->sysfs_name);
> -}
> -
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   static MDEV_TYPE_ATTR_RO(description);
> -static MDEV_TYPE_ATTR_RO(name);
>   
>   static const struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_name.attr,
>   	NULL,
>   };
>   
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 730d87a96a305..35389f4b67dc5 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -70,13 +70,6 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "I/O subchannel (Non-QDIO)\n");
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -88,7 +81,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -642,6 +634,7 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
>   	strcat(sch->mdev_type.sysfs_name, "io");
> +	strcat(sch->mdev_type.pretty_name, "I/O subchannel (Non-QDIO)");
>   	sch->mdev_types[0] = &sch->mdev_type;
>   	return mdev_register_parent(&sch->parent, &sch->dev,
>   				    &vfio_ccw_mdev_driver, sch->mdev_types,
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index da21fd60877fb..d6b2e819a615e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -511,14 +511,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	atomic_inc(&matrix_dev->available_instances);
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_AP_MDEV_NAME_HWVIRT);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -530,7 +522,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *vfio_ap_mdev_type_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 20763f1aa9f5a..8384e2992c706 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -81,9 +81,20 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> +static ssize_t name_show(struct mdev_type *mtype,
> +			 struct mdev_type_attribute *attr, char *buf)
> +{
> +	if (!mtype->pretty_name[0])
> +		return sprintf(buf, "%s\n", mtype->sysfs_name);
> +	return sprintf(buf, "%s\n", mtype->pretty_name);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(name);
> +
>   static struct attribute *mdev_types_core_attrs[] = {
>   	&mdev_type_attr_create.attr,
>   	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_name.attr,
>   	NULL,
>   };
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 81e11e18b3e41..64ca2ba806ed3 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -26,6 +26,7 @@ struct mdev_device {
>   struct mdev_type {
>   	/* set by the driver before calling mdev_register parent: */
>   	char sysfs_name[32];
> +	char pretty_name[32]; /* optional */
>   
>   	/* set by the core, can be used drivers */
>   	struct mdev_parent *parent;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 199846f01de92..c8271168a96ad 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -101,26 +101,25 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
>   
>   static struct mbochs_type {
>   	struct mdev_type type;
> -	const char *name;
>   	u32 mbytes;
>   	u32 max_x;
>   	u32 max_y;
>   } mbochs_types[] = {
>   	{
>   		.type.sysfs_name	= MBOCHS_TYPE_1,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
>   		.mbytes = 4,
>   		.max_x  = 800,
>   		.max_y  = 600,
>   	}, {
>   		.type.sysfs_name	= MBOCHS_TYPE_2,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
>   		.mbytes = 16,
>   		.max_x  = 1920,
>   		.max_y  = 1440,
>   	}, {
>   		.type.sysfs_name	= MBOCHS_TYPE_3,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
>   		.mbytes = 64,
>   		.max_x  = 0,
>   		.max_y  = 0,
> @@ -547,7 +546,7 @@ static int mbochs_probe(struct mdev_device *mdev)
>   		goto err_mem;
>   
>   	dev_info(dev, "%s: %s, %d MB, %ld pages\n", __func__,
> -		 type->name, type->mbytes, mdev_state->pagecount);
> +		 type->type.pretty_name, type->mbytes, mdev_state->pagecount);
>   
>   	mutex_init(&mdev_state->ops_lock);
>   	mdev_state->mdev = mdev;
> @@ -1334,16 +1333,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mbochs_type *type =
> -		container_of(mtype, struct mbochs_type, type);
> -
> -	return sprintf(buf, "%s\n", type->name);
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -1368,7 +1357,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 401a9a622673c..1b2117772192f 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -53,7 +53,6 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
>   
>   static struct mdpy_type {
>   	struct mdev_type type;
> -	const char *name;
>   	u32 format;
>   	u32 bytepp;
>   	u32 width;
> @@ -61,21 +60,21 @@ static struct mdpy_type {
>   } mdpy_types[] = {
>   	{
>   		.type.sysfs_name 	= MDPY_TYPE_1,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 640,
>   		.height = 480,
>   	}, {
>   		.type.sysfs_name 	= MDPY_TYPE_2,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1024,
>   		.height = 768,
>   	}, {
>   		.type.sysfs_name 	= MDPY_TYPE_3,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1920,
> @@ -256,8 +255,8 @@ static int mdpy_probe(struct mdev_device *mdev)
>   		ret = -ENOMEM;
>   		goto err_vconfig;
>   	}
> -	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
> -		 type->height);
> +	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->type.pretty_name,
> +		 type->width, type->height);
>   
>   	mutex_init(&mdev_state->ops_lock);
>   	mdev_state->mdev = mdev;
> @@ -651,15 +650,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
> -
> -	return sprintf(buf, "%s\n", type->name);
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -679,7 +669,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 2a470424628af..b95a4491265c5 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -146,10 +146,11 @@ struct mdev_state {
>   static struct mtty_type {
>   	struct mdev_type type;
>   	int nr_ports;
> -	const char *name;
>   } mtty_types[2] = {
> -	{ .nr_ports = 1, .type.sysfs_name = "1", .name = "Single port serial" },
> -	{ .nr_ports = 2, .type.sysfs_name = "2", .name = "Dual port serial" },
> +	{ .nr_ports = 1, .type.sysfs_name = "1",
> +	  .type.pretty_name = "Single port serial" },
> +	{ .nr_ports = 2, .type.sysfs_name = "2",
> +	  .type.pretty_name = "Dual port serial" },
>   };
>   
>   static struct mdev_type *mtty_mdev_types[] = {
> @@ -1246,16 +1247,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
> -
> -	return sysfs_emit(buf, "%s\n", type->name);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -1269,7 +1260,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
