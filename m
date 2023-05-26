Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16E711D3E
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 03:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjEZB7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 21:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjEZB7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 21:59:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB5118D
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 18:59:12 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso349076b3a.1
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 18:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685066351; x=1687658351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHXSI++vej3nO9JdS3WPE1L2j+X5Z0vQui5q9gEk36o=;
        b=u7yPykjjbmCytXH6pFeAr3KKb+n0Dr/7iRiYbmd/2mW7OQXDxbdmhCf6WTf2zF/OQA
         xgvnwKpsoHs4kD48+/NfDkt4HR9uPDjpqKei+Ka0yT6ZhcdLK0WEzirOb1pdjfT6Kl/l
         y6fqshg9NP1bWU2EoPB5oKxxwgbLMKz4RY56SNq0KLh4CyYFVyxMAhQ+DwYJrgwVHozn
         ykFkaZy8lZ3/pfwXq3RhNVJy8Z3tiOBvh2IeTdxOFY+GxHTOeQ3Bo9obBuv5UG6Awwnw
         iKpzYkpMjs2MOvS3KHQ6adGU+HflbDF/dnFeXzOZjqesxCry1a0qQjNBSsy4ajckxZwl
         R13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685066351; x=1687658351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SHXSI++vej3nO9JdS3WPE1L2j+X5Z0vQui5q9gEk36o=;
        b=HzjuI4k4TAVKWUXGkF4DHBJMsTuhcukqSFIsKwSxvIl9tUeDTz/sxG+/wVQGcJ69AJ
         oTBL0fs97kE0J/LZ+n4MOrFLC5OXCfSxwmniNlw4E6vzTLF9ZvosVquJuIzbfWscJH67
         mmAikPcqVNcpQJ4rl/ysydL7hzn5dkg58nK1k/lATifO1FS4ns7aFVLe5QX7fLtUQMXU
         44zkgVXau31fp8JwpZu8D2OrHl1DhSS32m9tvsG88caIfe/Lu70OaS6VpIyk109fo8G7
         SqTP1fvUzTS88Bt5jsRNQQUQZ/QWAiKMQs9p1DuUvq84EI0Ev/PXSRNIWPjzLS6J6O12
         oQFw==
X-Gm-Message-State: AC+VfDwlEFn9t8Fft/V8mWE3y3irzJ722+D0JjHdwcB3/u5rKdsFRXRE
        Xio93MObKwdOEy8SNyqzRu17Bg==
X-Google-Smtp-Source: ACHHUZ62FFB/huSWayTmzsRIupHGq1n53axHnLv9NDLNL/oh5ccqB5HNl6tnnxMTd0vHw7gzQMDQng==
X-Received: by 2002:a05:6a00:2491:b0:647:d698:56d2 with SMTP id c17-20020a056a00249100b00647d69856d2mr1017231pfv.27.1685066351315;
        Thu, 25 May 2023 18:59:11 -0700 (PDT)
Received: from [100.64.100.6] ([194.5.48.111])
        by smtp.gmail.com with ESMTPSA id fe22-20020a056a002f1600b0064ceb16a1a8sm1751764pfb.33.2023.05.25.18.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 18:59:10 -0700 (PDT)
Message-ID: <7650f32d-6d4d-012e-b14b-538529de0577@linaro.org>
Date:   Fri, 26 May 2023 09:58:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     jgg@nvidia.com, robin.murphy@arm.com, will@kernel.org,
        eric.auger@redhat.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, joro@8bytes.org,
        shameerali.kolothum.thodi@huawei.com, jean-philippe@linaro.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, yi.l.liu@intel.com
References: <cover.1683688960.git.nicolinc@nvidia.com>
 <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
 <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
 <CABQgh9FMGPnUpz6tc6c27i6nT0Lcs9YQMoO=V40Fi2inJiCh-A@mail.gmail.com>
 <ZG/ygPy1XbSSNzR4@Asurada-Nvidia>
From:   zhangfei gao <zhangfei.gao@linaro.org>
In-Reply-To: <ZG/ygPy1XbSSNzR4@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/5/26 07:42, Nicolin Chen 写道:
> On Tue, May 16, 2023 at 11:12:44AM +0800, Zhangfei Gao wrote:
>
>>>> However when debugging hotplug PCI device, it still does not work,
>>>> Segmentation fault same as 6.2.
>>>>
>>>> guest kernel
>>>> CONFIG_HOTPLUG_PCI_PCIE=y
>>>>
>>>> boot guest (this info does not appear in 6.2)
>>>> qemu-system-aarch64: -device
>>>> vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
>>>> Failed to set data -1
>>>> qemu-system-aarch64: -device
>>>> vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
>>>> failed to set device data
>>> Hmm.. I wonder what fails the set_dev_data ioctl...
>> Simply debug, it is because dev_data.sid=0, causing
>> arm_smmu_set_dev_user_data fail
> I found that too. The input pci bus number is 1, yet the in
> the context of set_dev_data, the pci bus number is 0, which
> resulted in a 0-valued sid. I will take another look to get
> why.
>
>>>> $ sudo nc -U /tmp/qmpm_1.socket
>>>> (qemu) info pci
>>>> (qemu) device_del acc1
>>>>
>>>> guest:
>>>> qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
>>>> qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae1fc0380,
>>>> 0x8000000000, 0x10000) = -2 (No such file or directory)
>>  From ex-email reply
>> (Eric) In qemu arm virt machine 0x8000000000 matches the PCI MMIO region.
>> (Yi) Currently, iommufd kernel part doesn't support mapping device BAR MMIO.
>> This is a known gap.
> OK.
>
>>>> qemu-system-aarch64: Failed to unset data -1
>>>> Segmentation fault (core dumped).  // also happened in 6.2
>>> Hmm, would it be possible for you to run the test again by
>>> adding the following tracers to your QEMU command?
>>>      --trace "iommufd*" \
>>>      --trace "smmu*" \
>>>      --trace "vfio_*" \
>>>      --trace "pci_*"
>>>
>> Have sent you the log directly, since it is too big.
> I have found two missing pieces in the device detach routine.
> Applying the following should fix the crash at hotplug path.
>
> ----------------------------------------------------------------------------
> diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
> index 89a256efa999..2344307523cb 100644
> --- a/hw/vfio/container-base.c
> +++ b/hw/vfio/container-base.c
> @@ -151,8 +151,10 @@ void vfio_container_destroy(VFIOContainer *container)
>       }
>
>       QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
> -        memory_region_unregister_iommu_notifier(
> -                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> +        if (giommu->n.notifier_flags) {
> +            memory_region_unregister_iommu_notifier(
> +                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> +        }
>           QLIST_REMOVE(giommu, giommu_next);
>           g_free(giommu);
>       }
> diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
> index 844c60892db2..35d31480390d 100644
> --- a/hw/vfio/iommufd.c
> +++ b/hw/vfio/iommufd.c
> @@ -652,6 +652,9 @@ found:
>        */
>       if (QLIST_EMPTY(&container->hwpt_list)) {
>           vfio_as_del_container(space, bcontainer);
> +        if (bcontainer->nested) {
> +            memory_listener_unregister(& bcontainer->prereg_listener);
> +        }
>       }
>       __vfio_device_detach_container(vbasedev, container, &err);
>       if (err) {
> ----------------------------------------------------------------------------
>
> Would you please try your case with it?


Yes, this solve the hotplug segmentation fault

Still report

qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae622e300, 
0x8000000000, 0x10000) = -2 (No such file or directory)
qemu-system-aarch64: Failed to unset data -1 (only the first time of 
device_del)

Test with device_del and device_add

Thanks.



