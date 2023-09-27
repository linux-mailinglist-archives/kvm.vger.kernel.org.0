Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807FE7B0BA1
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 20:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjI0SJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 14:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI0SJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 14:09:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9119DA1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 11:09:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvzqR+h1Bfw3VIE43QzYN9QS5NOFl7AswotihTo4nCIIkEVkX0qcWDsoJn36emHSXGl/TAz9EzSHLF3ybG1plhh488CDwO9rSwW+os6zta4vrlbqDpPJWUweXSDM8UyL4xrne5fw0CKRdD3j2rbGWmAYZnGh/lKkJ3ItqhAmp+aXwcoEJAMM5i15wGVui+eiMqpqgwt/KIXQiA+rOylTaAv3yz9qALaOQ2EfsE+DzHOqzMpEf06a2HNHUpry1dyLJIyvcfiPdm2PrMR8qpUV63mUVHm3S77atqAuV6pLNuC8kodT1Op0CRgJjCbKqfzosn8299n0iTIVjInWuD+THg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmwQJnUA5aIbXUzPxgqkGYwI1jbBrV+P5ivCFZLhddo=;
 b=dg5hD4RbmKyEEBgv1xGmxoKuyvk3P7MiAvO0NGDd7t3cFfkvX4byzm36UIgay5sCG3ZVQNSH0tRPmR9WNjQD3MQSr7ti2WX2D3VuvbIzGgMn343Bisn+na9Npzj/U32PerpYuoZ3SRGZnZskOo5+jT8D3LwTg7GXWIu7FSKkq+/P3VAeYM1OJ8XbYHHlLrLF/mLHrwiUvogNNYN6lTDDlyIjM9YXYVbrc04313Zp9BYtKbpXjZZW6O8kNux1YWg1LwpdaWZ8IzFtg3NQD+zfn3tzL69aHiS3KKUmkC6XOizQTIhWkT1zObi2vOLf0VlYp3OM79UhwQO0Ghhr2Q05SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmwQJnUA5aIbXUzPxgqkGYwI1jbBrV+P5ivCFZLhddo=;
 b=YMozpr1J2bDya2cuN6pOGoDM7b6w3zXbdjlSh7y0FJxr/kUSEd2Mler65zXU9bBiFPm+0PR6NalN3puFksD/QKGeR8JJtCNFaeqAsI+H+NychiWirsFYJU5b2i9S4VH0HcKu8S578MDUQa0sEEjI4QjQusKs/glC+GYP9MhtmY1IIhV0CKU9b7doZnQeUGgSP+v8VNj2/JZGeg7DeIj3lQSBrQ4lR1G4NQqahef7TenFI79RdOF+bPAkgu5eQ+FnXr2iXm3hW6SmlwMMd7oiNbKUHSaCsOOhGrTJrTTwVNWvQvJ96y0WkjtwpvYBHs/LnoWFOl6tj7Zgt6OUy5yE8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by PH7PR12MB8828.namprd12.prod.outlook.com (2603:10b6:510:26b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 18:09:49 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082%4]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 18:09:49 +0000
Message-ID: <39d8a0a5-4365-4ced-cac1-bef2bc8d6367@nvidia.com>
Date:   Wed, 27 Sep 2023 14:09:43 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH vfio 01/11] virtio-pci: Use virtio pci device layer vq
 info instead of generic one
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     kvm@vger.kernel.org, maorg@nvidia.com,
        virtualization@lists.linux-foundation.org, jgg@nvidia.com,
        jiri@nvidia.com, leonro@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-2-yishaih@nvidia.com>
 <20230921093540-mutt-send-email-mst@kernel.org>
 <6eb92b47-cefe-8b00-d3d2-f15ce4aa9959@nvidia.com>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <6eb92b47-cefe-8b00-d3d2-f15ce4aa9959@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:5:120::28) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|PH7PR12MB8828:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d98893-87d5-4c5d-898c-08dbbf84ef2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ux9BbCxaej9TCtdLOL9cPWpbtSMfRJbh2B06OJ7d49ePGlRRqLb+2DH4yIC5uXg0yb4qIogpgFNhgbj9IZdsZQyJHN2ftZjRYzP5hj06F8I+W2VF80/zLyljwteoSqgFvPRc43+c1QdD2wg22f0aQYahhDM8i5MTKnK8ip8NVXJUVoecIqeRlpoZWWaImagzi+h0MTZR6GiLFu/BWLMv4Vg6VxOQG6+MeVu5np5NfPnw4XXQJr0cxY6cHEneHeo/FQGgvBBkTf3znTymUHERXM4TJWmz8v7W5tjWYqMsJaGiWIur5fzyWLCou2W+EVdqBb/DPEUkIEYfQqNFzoJr3U2L5dAJYo4pgvcjV55E9Ci2igT8Tfr4QtmaI2PFvByc+FLocH32rQ7n4mwgqroMA7sSf/WfIyp4lV0Znc/B8Xu9aBP1hiOBkagM229sLTAGs/moNLqLZwhSuW0RYS/joVFm44iMv/qNEAoBcIbH0eG9GM7xmY/vYJ2xAysKs85VDeQio7zRBmWVBj7TqoTjc948YqtcMTwYZcf1CQfhc2CNNjlCqS7A8XF7uld6uppmpMkV68uaZGGy6Fgdw02gnas+2mkn2RWYp03/jxvmw+ygmiiNmTc0xp20DV72lTkL3z9zvNceVQgQnQiAjODMYfS6HGTnt2AhtbUNgTFBeCWr64d7hfr0CCxE7RQ1GnZu5QFQ3KydllHeXCVUB7tmGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(39860400002)(396003)(230922051799003)(1800799009)(451199024)(186009)(316002)(5660300002)(8936002)(4326008)(8676002)(41300700001)(6636002)(110136005)(66476007)(66556008)(31686004)(66946007)(2906002)(6506007)(2616005)(6512007)(36756003)(478600001)(966005)(6486002)(26005)(107886003)(86362001)(83380400001)(31696002)(38100700002)(6666004)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmlNM2djSTBpWmpqMWRYVGsrMmRkbnh6Q3BKa0xhYm1hTzdZMFZCYlpuYjh2?=
 =?utf-8?B?a2FDMElVMXgwZWY1clE3UzY1UUY5OGd0TnRDckRBQlB4OUt2djZQazJJL3N4?=
 =?utf-8?B?cElJdWlHQzNRQlFyMG15QTJKSjVMWmVsWkpBcWhKVTV3QXV2ZllVMHMwbUVM?=
 =?utf-8?B?L3gzN3FVSWFuS3ZTTjNIbVM0ZTZaK2FEMHJ3aWhVeG4vaTYwaStnSENGT0lO?=
 =?utf-8?B?azd5ck0wTzdBRTNtN2tLQ3lNRTVqbncyYTFTVlBYb3Roa1RTbE9kQkpiUVdN?=
 =?utf-8?B?R2hmOVVkRWQvL2RRSzhVdjB5dTNrV1A4VzBLOVFsZ1lTVCtTWmFsdlRXZlg5?=
 =?utf-8?B?UXAwejB1TS80MEpMY3NMQzNjWVNRaS9yaUpoM0RzdUpsZTBLMUJqTlFOajhR?=
 =?utf-8?B?Nkk1dTVNcEFpTGFTdzdJWHlLK014QUJrU0tDZnFmaUxMcUNsWVYrRE5qdFk0?=
 =?utf-8?B?ampzQ0t2R2YrZVlhSU1neDlJRGVQNEhRb3dYQ1Z0S1A2NUpYaGQzNVIwSG5T?=
 =?utf-8?B?clFIb1NKN0haaUJGWTE5TkJuRWN6c0xBbWFNRysxUUhMSFdGUGYwdzVHenQw?=
 =?utf-8?B?M1ZqcnhuRy84ZE1ScTZxelVKTVg1dlhjbXFBd1IzaWs0WHpmTWlRYWNJR2x1?=
 =?utf-8?B?cHZyTit5TkJNT2VnZmlESm51am9Wc1FyeWtCdXJTZTlFOWZ1cGhjOE5FOTN2?=
 =?utf-8?B?YkZxWWdEWTF2SEl1TUx0UlRwT3JBTVU2enY5MjF4NkZvWE9kT3R0NU1oc2Nk?=
 =?utf-8?B?WEE5dHVnQWI4Vjl1aWxhMWgzdUJHT1h5OXdKS0tEQVBqLzNERGxMSkxGU3dC?=
 =?utf-8?B?YlYrN0k2QVo4NWE3ZjJ3N2lUSUpiTHIyTWtXcS9zQm44eTlyUnBkNUIwNlYw?=
 =?utf-8?B?MXAxQ1lHRnRWbDdkelF4dFZudHN0NGNWbVYxd2NFQXpUUUZoem9oSmRFOEtO?=
 =?utf-8?B?MGZhc2FoYXdGd3dneUplTnhUZVduRmloMm9tQjZNelNUVFlEb0hBR3lpTVI3?=
 =?utf-8?B?WDJhc0hCTGMycURrOTVST21LUnorUG1tckFPb0U3YVVubU5pUG5EVXZka3Zr?=
 =?utf-8?B?R0tIVlJYUWsvaXJhRHdlZFV3TFJvTEQrdUgxdkN1aHl5VUYwQlNRamlXd24r?=
 =?utf-8?B?TVVSbFkzNTcyOUxiRTBEWDhxQXJacGRESkdBT2hocWJ3QlJHRk56OHpEQnhW?=
 =?utf-8?B?N05NVlEwZmh4OUZzYVk0QTl6MFBNc3NWZFBPTk85WGJCTDRMaC9KZ2xza3g1?=
 =?utf-8?B?NnMwODFlbWg0OW1KUDVveTNNZ2pTcEo5bmNib2NDV3h2Yk5Rc1QyU3Q5SzBt?=
 =?utf-8?B?c0Nkc21nZUJ2WFh4Y0ZjV1VMeEljcVZRTjJ3MDVsSDNEc3hPdVJRb3RlZXQr?=
 =?utf-8?B?SWVEWEJOeTFkMm8wcXlSbEpEMlp2dUxOeWZPNU8ydkxIQjQyWlZDclJrSlph?=
 =?utf-8?B?T1VZcUUzYk9zQWprNnNSOHVNQ1RxZDBXTTczd29TVmpTQUx3YmFEYlFqK3hF?=
 =?utf-8?B?anBrcjRsMFZlOWl4NTBTcGJ0cldScExiOGRsVGhRUGd2TFZ1MlpoYy84U3FV?=
 =?utf-8?B?Yjh1QjQwQmZiZUVDclJkNVNaa0NyVG1TeU5paituQSs1RHNpZS82d3luTHhj?=
 =?utf-8?B?TUNqTGlyOENiMDd5TFhhUEdyRkZ1d0FpQ3Q5dmNiekFJeGEzMjYyamgrdlRm?=
 =?utf-8?B?MVY3T0lYWStqaURmUVViUHhpUWxiNTFFNkt3cEc2UWdnZDBEYXkwb1RwUlNp?=
 =?utf-8?B?dVlFYUpjTGpENjdXRXVBWDVicEJxeFpsOHJ6QmZiVjFIc1AweS8vNUhtb2ZV?=
 =?utf-8?B?NnRUWkpUWmFkSW1kYUE1bmRPaHBTMmIvOWJsRW1HN1h3d0NsWE1Qem91S0Z6?=
 =?utf-8?B?K3RCNHpkaWVBZjRjL2ZEZjZ0Nnl0dndKRTFEbUJ4TkpLVnFlamRRTDJYVCtX?=
 =?utf-8?B?aVBWeTQ4UUxEQitPVDFiTHVpWDJuZDFwKy9EcE9nTU02TGxIVWlVOEhmR2gw?=
 =?utf-8?B?cDZZejRVQjJPMU1uT3ZoRnFWbUgyK0VKY05zK0hleUJjR1VpUWR6S2ptaDla?=
 =?utf-8?B?ZWJ0a2JiSDNibjk5aVhyNHAvL0grOXhPTlhJMGZzU2ltSW5pSzUvZUt6SGpV?=
 =?utf-8?Q?btIYPKQSKXaXH5TXDlNb/IKDM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d98893-87d5-4c5d-898c-08dbbf84ef2d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 18:09:49.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oM2k3VBoKPQUe8EM2B9zuu0bqNsV2Zm8s63tsCR04NBeTSmLrhTVkQV6zX5hcjY0xH0TqOqEC60R0BiBSsq67g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8828
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-09-26 p.m.3:13, Feng Liu via Virtualization wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2023-09-21 a.m.9:46, Michael S. Tsirkin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Thu, Sep 21, 2023 at 03:40:30PM +0300, Yishai Hadas wrote:
>>> From: Feng Liu <feliu@nvidia.com>
>>>

>>> pci_irq_vector(vp_dev->pci_dev, v);
>>> @@ -294,6 +298,7 @@ static int vp_find_vqs_msix(struct virtio_device 
>>> *vdev, unsigned int nvqs,
>>>        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>>>        if (!vp_dev->vqs)
>>>                return -ENOMEM;
>>> +     vp_dev->nvqs = nvqs;
>>>
>>>        if (per_vq_vectors) {
>>>                /* Best option: one for change interrupt, one per vq. */
>>> @@ -365,6 +370,7 @@ static int vp_find_vqs_intx(struct virtio_device 
>>> *vdev, unsigned int nvqs,
>>>        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>>>        if (!vp_dev->vqs)
>>>                return -ENOMEM;
>>> +     vp_dev->nvqs = nvqs;
>>>
>>>        err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, 
>>> IRQF_SHARED,
>>>                        dev_name(&vdev->dev), vp_dev);
>>> diff --git a/drivers/virtio/virtio_pci_common.h 
>>> b/drivers/virtio/virtio_pci_common.h
>>> index 4b773bd7c58c..602021967aaa 100644
>>> --- a/drivers/virtio/virtio_pci_common.h
>>> +++ b/drivers/virtio/virtio_pci_common.h
>>> @@ -60,6 +60,7 @@ struct virtio_pci_device {
>>>
>>>        /* array of all queues for house-keeping */
>>>        struct virtio_pci_vq_info **vqs;
>>> +     u32 nvqs;
>>
>> I don't much like it that we are adding more duplicated info here.
>> In fact, we tried removing the vqs array in
>> 5c34d002dcc7a6dd665a19d098b4f4cd5501ba1a - there was some bug in that
>> patch and the author didn't have the time to debug
>> so I reverted but I don't really think we need to add to that.
>>
> 
> Hi Michael
> 
> As explained in commit message, this patch is mainly to prepare for the
> subsequent admin vq patches.
> 
> The admin vq is also established using the common mechanism of vring,
> and is added to vdev->vqs in __vring_new_virtqueue(). So vdev->vqs
> contains all virtqueues, including rxq, txq, ctrlvq and admin vq.
> 
> admin vq should be managed by the virito_pci layer and should not be
> created or deleted by upper driver (net, blk);
> When the upper driver was unloaded, it will call del_vqs() interface,
> which wll call vp_del_vqs(), and vp_del_vqs() should not delete the
> admin vq, but only delete the virtqueues created by the upper driver
> such as rxq, txq, and ctrlq.
> 
> 
> vp_dev->vqs[] array only contains virtqueues created by upper driver
> such as rxq, txq, ctrlq. Traversing vp_dev->vqs array can only delete
> the upper virtqueues, without the admin vq. Use the vdev->vqs linked
> list cannot meet the needs.
> 
> 
> Can such an explanation be explained clearly? Or do you have any other
> alternative methods?
> 

Hi, Michael
	Is the above explanations OK to you?

Thanks
Feng

>>>
>>>        /* MSI-X support */
>>>        int msix_enabled;
>>> -- 
>>> 2.27.0
>>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
