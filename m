Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692ED56B204
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 07:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiGHFAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 01:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiGHFAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 01:00:14 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA7A7968B
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 22:00:11 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z14so21491597pgh.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 22:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E9y0hdTSdgBELFghe30vfpqPkTbPmaytc9c+XLrJQw4=;
        b=SKraerElO1agLTwn0xA76BB0FiZSNryEZtaDXnA+JHNjYRMvUsLOCv1X5sEjSK0f0R
         htOWIzmvZhv0L0jwMtiW2nPnyZ3CI+f/0FJ/nUE4hnhk0dqHkg4a7ZiioG5UZ/9+eNCB
         QUCzYlREinDwtZZCGa4H/smeRlQaXMUwA0kevGh37ZOi+4uINBL+3f1aMPFpsIpdgdD/
         VnBIeU9LSLwqET2FzDXE/6ocklyUjWni+SH0w6nYA7I/Xw/N8bhDRP8BXm9Ki7ayy7Z0
         h/Ko2F4jw/zHA5E9Z+LVIoWYKHgXi6GIDedyFMYBgFPEGnnufsxuhVfoVEOtHIAoFJtR
         iPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E9y0hdTSdgBELFghe30vfpqPkTbPmaytc9c+XLrJQw4=;
        b=GDSdcIE1RLb0ZVhE3RGgGd7fixL8oG8ynQhI/jY0Y3ryHPUOAzxY/iV953hEnxoTu8
         LwaYH6/k9OPPvcEn8SBo5HEiqNpCOjmBn5uYCloCxgeQjtSWo65V+dvF0MQMHgFIJpEy
         qOu/vwBDPhhSbckQdbzZII3KyDvqQdS04yTfNelzhE83vXkfgkg1PwDTvDjBznXMwh6+
         jlEBcjz0EeSMBCymgcw5XEGNkDDedcCToEc4mJpotfmF6uL05qsS1SZ0FpbjLMz0qzQq
         DtkV0fxcqDbnV9ffZrm9PLCLQXO7bLJjN1wVLsGzpR44QhP4a5Cn67rBOJhKgv3FjnSq
         s3pg==
X-Gm-Message-State: AJIora8IXntxdZ8NKCg8icLT9ZIEL4CKBJfX+jjvjiLEnkyJIXlofy9j
        xNHSIyyLQGFJHKtk0MUVgFkccw==
X-Google-Smtp-Source: AGRyM1suq0RH9R4lP/80jDRDo9BqqJDQyfp833M305CP8y1vPTX3Kte0z547HpiYUPqHWGkQtgp09w==
X-Received: by 2002:a63:4722:0:b0:40d:289e:8637 with SMTP id u34-20020a634722000000b0040d289e8637mr1609961pga.362.1657256410428;
        Thu, 07 Jul 2022 22:00:10 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id l14-20020a170903244e00b0016c18f479d5sm1923916pls.19.2022.07.07.22.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 22:00:09 -0700 (PDT)
Message-ID: <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
Date:   Fri, 8 Jul 2022 15:00:03 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linuxppc-dev@lists.ozlabs.org, Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joerg Roedel <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220707151002.GB1705032@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/8/22 01:10, Jason Gunthorpe wrote:
> On Thu, Jul 07, 2022 at 11:55:52PM +1000, Alexey Kardashevskiy wrote:
>> Historically PPC64 managed to avoid using iommu_ops. The VFIO driver
>> uses a SPAPR TCE sub-driver and all iommu_ops uses were kept in
>> the Type1 VFIO driver. Recent development though has added a coherency
>> capability check to the generic part of VFIO and essentially disabled
>> VFIO on PPC64; the similar story about iommu_group_dma_owner_claimed().
>>
>> This adds an iommu_ops stub which reports support for cache
>> coherency. Because bus_set_iommu() triggers IOMMU probing of PCI devices,
>> this provides minimum code for the probing to not crash.
>>
>> Because now we have to set iommu_ops to the system (bus_set_iommu() or
>> iommu_device_register()), this requires the POWERNV PCI setup to happen
>> after bus_register(&pci_bus_type) which is postcore_initcall
>> TODO: check if it still works, read sha1, for more details:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5537fcb319d016ce387
>>
>> Because setting the ops triggers probing, this does not work well with
>> iommu_group_add_device(), hence the move to iommu_probe_device().
>>
>> Because iommu_probe_device() does not take the group (which is why
>> we had the helper in the first place), this adds
>> pci_controller_ops::device_group.
>>
>> So, basically there is one iommu_device per PHB and devices are added to
>> groups indirectly via series of calls inside the IOMMU code.
>>
>> pSeries is out of scope here (a minor fix needed for barely supported
>> platform in regard to VFIO).
>>
>> The previous discussion is here:
>> https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/
> 
> I think this is basically OK, for what it is. It looks like there is
> more some-day opportunity to make use of the core infrastructure though.
> 
>> does it make sense to have this many callbacks, or
>> the generic IOMMU code can safely operate without some
>> (given I add some more checks for !NULL)? thanks,
> 
> I wouldn't worry about it..
> 
>> @@ -1156,7 +1158,10 @@ int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
>>   	pr_debug("%s: Adding %s to iommu group %d\n",
>>   		 __func__, dev_name(dev),  iommu_group_id(table_group->group));
>>   
>> -	return iommu_group_add_device(table_group->group, dev);
>> +	ret = iommu_probe_device(dev);
>> +	dev_info(dev, "probed with %d\n", ret);
> 
> For another day, but it seems a bit strange to call iommu_probe_device() like this?
> Shouldn't one of the existing call sites cover this? The one in
> of_iommu.c perhaps?


It looks to me that of_iommu.c expects the iommu setup to happen before 
linux starts as linux looks for #iommu-cells or iommu-map properties in 
the device tree. The powernv firmware (aka skiboot) does not do this and 
it is linux which manages iommu groups.


>> +static bool spapr_tce_iommu_is_attach_deferred(struct device *dev)
>> +{
>> +       return false;
>> +}
> 
> I think you can NULL this op:
> 
> static bool iommu_is_attach_deferred(struct device *dev)
> {
> 	const struct iommu_ops *ops = dev_iommu_ops(dev);
> 
> 	if (ops->is_attach_deferred)
> 		return ops->is_attach_deferred(dev);
> 
> 	return false;
> }
> 
>> +static struct iommu_group *spapr_tce_iommu_device_group(struct device *dev)
>> +{
>> +	struct pci_controller *hose;
>> +	struct pci_dev *pdev;
>> +
>> +	/* Weirdly iommu_device_register() assigns the same ops to all buses */
>> +	if (!dev_is_pci(dev))
>> +		return ERR_PTR(-EPERM);
>> +
>> +	pdev = to_pci_dev(dev);
>> +	hose = pdev->bus->sysdata;
>> +
>> +	if (!hose->controller_ops.device_group)
>> +		return ERR_PTR(-ENOENT);
>> +
>> +	return hose->controller_ops.device_group(hose, pdev);
>> +}
> 
> Is this missing a refcount get on the group?
> 
>> +
>> +static int spapr_tce_iommu_attach_dev(struct iommu_domain *dom,
>> +				      struct device *dev)
>> +{
>> +	return 0;
>> +}
> 
> It is important when this returns that the iommu translation is all
> emptied. There should be no left over translations from the DMA API at
> this point. I have no idea how power works in this regard, but it
> should be explained why this is safe in a comment at a minimum.
>
 > It will turn into a security problem to allow kernel mappings to leak
 > past this point.
 >

I've added for v2 checking for no valid mappings for a device (or, more 
precisely, in the associated iommu_group), this domain does not need 
checking, right?

In general, is "domain" something from hardware or it is a software 
concept? Thanks,


> Jason

-- 
Alexey
