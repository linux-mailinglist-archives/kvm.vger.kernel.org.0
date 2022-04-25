Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB750E9A1
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 21:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbiDYTn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 15:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbiDYTnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 15:43:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB25D632A
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650915609;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59OsmWVuRNUrfdHh8Mtn4PpwkZAEMGMF05GKzQKOW8M=;
        b=TAjApmMMxoK3fAnYBGG5QMjWOhGnT+g0wPgIAXpIrJS6A0U3G2szzEnZoT8tF9bN3IMqbY
        XqfW+hdP8wys+YAuqFAkk8JEcMOeoynl8O+cPHIByqy8GRZMc72EewZoJDLJMNNrO168gA
        RWxJQeLIFR+Eb2Iixtdb3cKwcM2IPvo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-_78CB8wdOuWaspaQCj0HBA-1; Mon, 25 Apr 2022 15:40:06 -0400
X-MC-Unique: _78CB8wdOuWaspaQCj0HBA-1
Received: by mail-wm1-f71.google.com with SMTP id d6-20020a05600c34c600b0039296a2ac7cso127355wmq.1
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=59OsmWVuRNUrfdHh8Mtn4PpwkZAEMGMF05GKzQKOW8M=;
        b=tYcF/9Uu4Ni60GohNFUElzuWyic6cauFC0B3a1d+XPRP4hopYiavch9M092TEfJ6Eq
         YpmXk0lGe0TorFUEXbrI9RIIMrDA5FaoaNopbWdLn7SwTGAWFYnbFAgKpVWklyfLlMai
         gj9dQhrmKVD8O5eEg5618Mid2rbN8DMoEFwh7Nc7MtYRViLRa1bFZTtd2Rar5AIePnLU
         R4Wb9RHImwt2H3O8+VkE467xALt18Pw/o7A2pvlu20nam9cmg2ZlAxatpMBNIOfpqlgm
         n6w5HcxJGI56b56I5oJlk5xQURcBrf0LqLCQI6nD/gc0weB4mS1POehAQrIdq4ChjHRF
         S7KQ==
X-Gm-Message-State: AOAM5312ZD4nACNFxxRRGm0Xm8/WZ/ugy+zB/QRoCXNGO/jMIz2HxzvM
        a4RjeM+MY+iieo+g4okgfgMd3auUUN4Fibhv8y63Pa391JC90SDGb2/7JIfLaeFdxT4cToq6h53
        tsE8kTpAySplW
X-Received: by 2002:a05:600c:1ca5:b0:393:e846:4ea1 with SMTP id k37-20020a05600c1ca500b00393e8464ea1mr8986757wms.32.1650915605257;
        Mon, 25 Apr 2022 12:40:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxklePhnj02IPsy8/Irc8mp3FLrjMXCVlgPJkcGwG6Xi81YV8G9XFRpOl9CalYqeU5TAb0+9w==
X-Received: by 2002:a05:600c:1ca5:b0:393:e846:4ea1 with SMTP id k37-20020a05600c1ca500b00393e8464ea1mr8986728wms.32.1650915605016;
        Mon, 25 Apr 2022 12:40:05 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id o21-20020adfa115000000b0020adea2767csm2615032wro.83.2022.04.25.12.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 12:40:04 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <Ylku1VVsbYiAEALZ@Asurada-Nvidia>
 <16ea3601-a3dd-ba9b-a5bc-420f4ac20611@redhat.com>
 <Yl4r3Ok61wxCc2zd@Asurada-Nvidia>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <9ba412e7-85c1-8dd7-9a55-3a0078642bf8@redhat.com>
Date:   Mon, 25 Apr 2022 21:40:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yl4r3Ok61wxCc2zd@Asurada-Nvidia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nicolin,

On 4/19/22 5:26 AM, Nicolin Chen wrote:
> On Sun, Apr 17, 2022 at 12:30:40PM +0200, Eric Auger wrote:
>
>>>> - More tests
>>> I did a quick test on my ARM64 platform, using "iommu=smmuv3"
>>> string. The behaviors are different between using default and
>>> using legacy "iommufd=off".
>>>
>>> The legacy pathway exits the VM with:
>>>     vfio 0002:01:00.0:
>>>     failed to setup container for group 1:
>>>     memory listener initialization failed:
>>>     Region smmuv3-iommu-memory-region-16-0:
>>>     device 00.02.0 requires iommu MAP notifier which is not currently supported
>>>
>>> while the iommufd pathway started the VM but reported errors
>>> from host kernel about address translation failures, probably
>>> because of accessing unmapped addresses.
>>>
>>> I found iommufd pathway also calls error_propagate_prepend()
>>> to add to errp for not supporting IOMMU_NOTIFIER_MAP, but it
>>> doesn't get a chance to print errp out. Perhaps there should
>>> be a final error check somewhere to exit?
>> thank you for giving it a try.
>>
>> vsmmuv3 + vfio is not supported as we miss the HW nested stage support
>> and SMMU does not support cache mode. If you want to test viommu on ARM
>> you shall test virtio-iommu+vfio. This should work but this is not yet
>> tested.
> I tried "-device virtio-iommu" and "-device virtio-iommu-pci"
> separately with vfio-pci, but neither seems to work. The host
> SMMU driver reports Translation Faults.
>
> Do you know what commands I should use to run QEMU for that
> combination?
you shall use :

 -device virtio-iommu-pci -device vfio-pci,host=<BDF>

Please make sure the "-device virtio-iommu-pci" is set *before* the
"-device vfio-pci,"

Otherwise the IOMMU MR notifiers are not set properly and this may be
the cause of your physical SMMU translations faults.

Eric
>
>> I pushed a fix for the error notification issue:
>> qemu-for-5.17-rc6-vm-rfcv2-rc0 on my git https://github.com/eauger/qemu.git
> Yes. This fixes the problem. Thanks!
>

