Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC59579138
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 05:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiGSDSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 23:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiGSDSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 23:18:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F4B1C9
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 20:18:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q13-20020a17090a304d00b001f1af9a18a2so5949652pjl.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 20:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9BVbVFop1MpExz8nPR0yoVMaqYjV+LHpDDLDzkkCU8g=;
        b=UAhbqadBM/QJIMG5sz78JBdA/BL/wUjyPyE5E85/ipptFRRwSKwtKhN4WIZ5aA2Ywr
         Fsdc4BIQ8tnRUxaj6wL/poEe7FJc2kAu03DxFcoRvukp3SawnfYxAoTYLdPZzY5/q/6q
         MsZYckLMnZeLYQ4aZcBgJ7GWZkun52q5tNbmvddUIT2fV33ZnzGTI9DKEGPGJCm1Lo0t
         0OCbxdIQddJS6n9AkpSb1JhvlmYsndSqj6LTnxwDzrWFE6cl66FjvhJUrW+fpi2vQMgH
         dFQEkumZhilzMHLGf487TnvS9oBD0TuTqZCip/HXcACrjG0UEAS7ex/8qh5NXiQRWwhV
         spdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9BVbVFop1MpExz8nPR0yoVMaqYjV+LHpDDLDzkkCU8g=;
        b=Epg1P9DFtLZl7CSd0xT16gK8quzPnoT1UljUJ0I0bYuX06LufJn9vCfG52fJBIyfDi
         WaTSjiZ8lzpm1S+UFWDe0czCKtplJLOwA0Jg9zXSjjupRfMe0CsrJppa3Tzk2ofxKnFD
         G/IIYsynIUHcWXruHuI4hvPr+BNmWGkA86TjtioxLhMd8Mz37XijFnFphFQH7NCIy6EN
         fpRyJ+x1TCBb2iP0f43Muj2D0Q1/ua93U1P/EPtCiALAUTEnhlYRmCmheGLFo2EW10ls
         R51JOZlH3DrvfTKFtUkmPpOUoN4vbHhJMfdp1mJz6PYA3sfPa/ILeJlTK2HYHsU3Doah
         eP0w==
X-Gm-Message-State: AJIora+9uVs1Q7UGnP33ICZ8j6x9YVizy6Mi4ucS2Th0xxEQ4AjwvX/h
        xFmUrgrUlo5CmDxod0nDtcaKfw==
X-Google-Smtp-Source: AGRyM1uY9pOIvUU5sZk2tegLaQel9y2LSRoNU/6A4GrRu42DlhuPCUNFDsTN/WPyANdrSXxxWLHOYg==
X-Received: by 2002:a17:902:cf12:b0:16c:a263:62b8 with SMTP id i18-20020a170902cf1200b0016ca26362b8mr20734673plg.31.1658200721009;
        Mon, 18 Jul 2022 20:18:41 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id h16-20020a170902f55000b0016c740e53bbsm10281804plf.79.2022.07.18.20.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 20:18:40 -0700 (PDT)
Message-ID: <00c41fa4-4e64-0a90-b06e-accdc662fa4d@ozlabs.ru>
Date:   Tue, 19 Jul 2022 13:18:32 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101
 Thunderbird/103.0
Subject: Re: [PATCH kernel 3/3] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Deming Wang <wangdeming@inspur.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20220714081822.3717693-1-aik@ozlabs.ru>
 <20220714081822.3717693-4-aik@ozlabs.ru> <20220718180924.GE4609@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220718180924.GE4609@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19/07/2022 04:09, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2022 at 06:18:22PM +1000, Alexey Kardashevskiy wrote:
> 
>> +/*
>> + * A simple iommu_ops to allow less cruft in generic VFIO code.
>> + */
>> +static bool spapr_tce_iommu_capable(enum iommu_cap cap)
>> +{
>> +	switch (cap) {
>> +	case IOMMU_CAP_CACHE_COHERENCY:
> 
> I would add a remark here that it is because vfio is going to use
> SPAPR mode but still checks that the iommu driver support coherency -
> with out that detail it looks very strange to have caps without
> implementing unmanaged domains
> 
>> +static struct iommu_domain *spapr_tce_iommu_domain_alloc(unsigned int type)
>> +{
>> +	struct iommu_domain *dom;
>> +
>> +	if (type != IOMMU_DOMAIN_BLOCKED)
>> +		return NULL;
>> +
>> +	dom = kzalloc(sizeof(*dom), GFP_KERNEL);
>> +	if (!dom)
>> +		return NULL;
>> +
>> +	dom->geometry.aperture_start = 0;
>> +	dom->geometry.aperture_end = ~0ULL;
>> +	dom->geometry.force_aperture = true;
> 
> A blocked domain doesn't really have an aperture, all DMA is rejected,
> so I think these can just be deleted and left at zero.
> 
> Generally I'm suggesting drivers just use a static singleton instance
> for the blocked domain instead of the allocation like this, but that
> is a very minor nit.
> 
>> +static struct iommu_device *spapr_tce_iommu_probe_device(struct device *dev)
>> +{
>> +	struct pci_dev *pdev;
>> +	struct pci_controller *hose;
>> +
>> +	/* Weirdly iommu_device_register() assigns the same ops to all buses */
>> +	if (!dev_is_pci(dev))
>> +		return ERR_PTR(-EPERM);
> 
> Less "weirdly", more by design. The iommu driver should check if the
> given struct device is supported or not, it isn't really a bus
> specific operation.
> 
>> +static struct iommu_group *spapr_tce_iommu_device_group(struct device *dev)
>> +{
>> +	struct pci_controller *hose;
>> +	struct pci_dev *pdev;
>> +
>> +	/* Weirdly iommu_device_register() assigns the same ops to all buses */
>> +	if (!dev_is_pci(dev))
>> +		return ERR_PTR(-EPERM);
> 
> This doesn't need repeating, if probe_device() fails then this will
> never be called.
> 
>> +static int spapr_tce_iommu_attach_dev(struct iommu_domain *dom,
>> +				      struct device *dev)
>> +{
>> +	struct iommu_group *grp = iommu_group_get(dev);
>> +	struct iommu_table_group *table_group;
>> +	int ret = -EINVAL;
>> +
>> +	if (!grp)
>> +		return -ENODEV;
>> +
>> +	table_group = iommu_group_get_iommudata(grp);
>> +
>> +	if (dom->type == IOMMU_DOMAIN_BLOCKED)
>> +		ret = table_group->ops->take_ownership(table_group);
> 
> Ideally there shouldn't be dom->type checks like this.
> 
> 
> The blocking domain should have its own iommu_domain_ops that only
> process the blocking operation. Ie call this like
> spapr_tce_iommu_blocking_attach_dev()
> 
> Instead of having a "default_domain_ops" leave it NULL and create a
> spapr_tce_blocking_domain_ops with these two functions and assign it
> to domain->ops when creating. Then it is really clear these functions
> are only called for the DOMAIN_BLOCKED type and you don't need to
> check it.
> 
>> +static void spapr_tce_iommu_detach_dev(struct iommu_domain *dom,
>> +				       struct device *dev)
>> +{
>> +	struct iommu_group *grp = iommu_group_get(dev);
>> +	struct iommu_table_group *table_group;
>> +
>> +	table_group = iommu_group_get_iommudata(grp);
>> +	WARN_ON(dom->type != IOMMU_DOMAIN_BLOCKED);
>> +	table_group->ops->release_ownership(table_group);
>> +}
> 
> Ditto
> 
>> +struct iommu_group *pSeries_pci_device_group(struct pci_controller *hose,
>> +					     struct pci_dev *pdev)
>> +{
>> +	struct device_node *pdn, *dn = pdev->dev.of_node;
>> +	struct iommu_group *grp;
>> +	struct pci_dn *pci;
>> +
>> +	pdn = pci_dma_find(dn, NULL);
>> +	if (!pdn || !PCI_DN(pdn))
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	pci = PCI_DN(pdn);
>> +	if (!pci->table_group)
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	grp = pci->table_group->group;
>> +	if (!grp)
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	return iommu_group_ref_get(grp);
> 
> Not for this series, but this is kind of backwards, the driver
> specific data (ie the table_group) should be in
> iommu_group_get_iommudata()...


It is there but here we are getting from a device to a group - a device 
is not added to a group yet when iommu_probe_device() works and tries 
adding a device via iommu_group_get_for_dev().




>> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
>> index 8a65ea61744c..3b53b466e49b 100644
>> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
>> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
>> @@ -1152,8 +1152,6 @@ static void tce_iommu_release_ownership(struct tce_container *container,
>>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
>>   		if (container->tables[i])
>>   			table_group->ops->unset_window(table_group, i);
>> -
>> -	table_group->ops->release_ownership(table_group);
>>   }
>>   
>>   static long tce_iommu_take_ownership(struct tce_container *container,
>> @@ -1161,10 +1159,6 @@ static long tce_iommu_take_ownership(struct tce_container *container,
>>   {
>>   	long i, ret = 0;
>>   
>> -	ret = table_group->ops->take_ownership(table_group);
>> -	if (ret)
>> -		return ret;
>> -
>>   	/* Set all windows to the new group */
>>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
>>   		struct iommu_table *tbl = container->tables[i];
>> @@ -1183,8 +1177,6 @@ static long tce_iommu_take_ownership(struct tce_container *container,
>>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
>>   		table_group->ops->unset_window(table_group, i);
>>   
>> -	table_group->ops->release_ownership(table_group);
>> -
> 
> This is great, makes alot of sense.
> 
> Anyhow, it all looks fine to me as is even:
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks. I'll try now to find an interested party to test this :)


> 
> Jason

-- 
Alexey
