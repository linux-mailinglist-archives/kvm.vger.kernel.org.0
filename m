Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC83550E9C3
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbiDYTzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 15:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240027AbiDYTzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 15:55:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC57E28998
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650916315;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NejFGku8tmTysZQlCWRMUNXSNstiBWgW9gErbkZB1bY=;
        b=fsRphBvd/6bBZWsF7COU86p3aHKaHoy0chPoEkJL0xrMS8mXUpvL2QBn2tcUHP3NpekmNq
        yIwyuECgemp/xEp7JWW3NvVFNFsGFUkxwteTViDCxAed5WpqsNPUxzXjxj7+6ZGjqLgWBL
        puFTeUtdwttnfMD9tyjHTes7asSmf00=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-sW8wNsFOMVeeh2FD2y9iQQ-1; Mon, 25 Apr 2022 15:51:54 -0400
X-MC-Unique: sW8wNsFOMVeeh2FD2y9iQQ-1
Received: by mail-wm1-f72.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so152711wmj.0
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=NejFGku8tmTysZQlCWRMUNXSNstiBWgW9gErbkZB1bY=;
        b=wdFrZbhtTETbcG1ppvtOVexuYsiTcil3iogRdhESfkpqrea3kMA6ZwxnK8CcRpyG+s
         qBeeMky433U8smxSmMaa7eBaAqRX9lf6SCXh+DvXvrMUXkdyyoGy8lZxPqQMzSOAQ1oC
         SqkGwC07E5IDWXqm8wOTrxm6+rvhueXxYfH20daZfSf2OYJK8lt5GyEqKsCCpQjtw/Tz
         XKq7fMnKz0VO229ddPYdjESYsPB2fjPj1vV+7AwYh4y2Gi6B/RZbu9AZ75ycn4/0ZgUV
         3sqmz83qDDnMDtZ7Ox3fYalyIcast+Qh1b7DZWmbSEfcm9n9WihhaZ6G4JptIBuMM+Uf
         GhRg==
X-Gm-Message-State: AOAM531Pf2lO4eaVh+TdewZfqexBKWWWV0yZcK0pnlVFSsZw0K0O/l4r
        H3CMLCksB2cvUyUp6vWbYMmGM+jeaX5bV4zFpQiVO/EaC0Og4c4Xo6N0Evp//jyTPASKbBUwk2Y
        gqR5K8O6dzsBt
X-Received: by 2002:adf:ec05:0:b0:20a:e496:dab5 with SMTP id x5-20020adfec05000000b0020ae496dab5mr247807wrn.221.1650916313311;
        Mon, 25 Apr 2022 12:51:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJlpHuAFBUuxbBtLFRTUv0JgUBTm+ipIen36mZe/um1QXc6ZikRWIDhhIYcUzWG97aCLpdVA==
X-Received: by 2002:adf:ec05:0:b0:20a:e496:dab5 with SMTP id x5-20020adfec05000000b0020ae496dab5mr247795wrn.221.1650916313060;
        Mon, 25 Apr 2022 12:51:53 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n38-20020a05600c502600b00393d946aef4sm8598703wmr.10.2022.04.25.12.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 12:51:52 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <BN9PR11MB5276085CDF750807005A775B8CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <abfebe33-149d-ce34-a178-f735afe2ca95@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <7015518e-dc19-d1f6-1eb8-a143be8d3721@redhat.com>
Date:   Mon, 25 Apr 2022 21:51:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <abfebe33-149d-ce34-a178-f735afe2ca95@intel.com>
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

Hi,

On 4/18/22 2:09 PM, Yi Liu wrote:
> Hi Kevin,
>
> On 2022/4/18 16:49, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Thursday, April 14, 2022 6:47 PM
>>>
>>> With the introduction of iommufd[1], the linux kernel provides a
>>> generic
>>> interface for userspace drivers to propagate their DMA mappings to
>>> kernel
>>> for assigned devices. This series does the porting of the VFIO devices
>>> onto the /dev/iommu uapi and let it coexist with the legacy
>>> implementation.
>>> Other devices like vpda, vfio mdev and etc. are not considered yet.
>>
>> vfio mdev has no special support in Qemu. Just that it's not supported
>> by iommufd yet thus can only be operated in legacy container
>> interface at
>> this point. Later once it's supported by the kernel suppose no
>> additional
>> enabling work is required for mdev in Qemu.
>
> yes. will make it more precise in next version.
>
>>>
>>> For vfio devices, the new interface is tied with device fd and iommufd
>>> as the iommufd solution is device-centric. This is different from
>>> legacy
>>> vfio which is group-centric. To support both interfaces in QEMU, this
>>> series introduces the iommu backend concept in the form of different
>>> container classes. The existing vfio container is named legacy
>>> container
>>> (equivalent with legacy iommu backend in this series), while the new
>>> iommufd based container is named as iommufd container (may also be
>>> mentioned
>>> as iommufd backend in this series). The two backend types have their
>>> own
>>> way to setup secure context and dma management interface. Below diagram
>>> shows how it looks like with both BEs.
>>>
>>>                      VFIO                           AddressSpace/Memory
>>>      +-------+  +----------+  +-----+  +-----+
>>>      |  pci  |  | platform |  |  ap |  | ccw |
>>>      +---+---+  +----+-----+  +--+--+  +--+--+    
>>> +----------------------+
>>>          |           |           |        |        |  
>>> AddressSpace       |
>>>          |           |           |        |       
>>> +------------+---------+
>>>      +---V-----------V-----------V--------V----+               /
>>>      |           VFIOAddressSpace              | <------------+
>>>      |                  |                      |  MemoryListener
>>>      |          VFIOContainer list             |
>>>      +-------+----------------------------+----+
>>>              |                            |
>>>              |                            |
>>>      +-------V------+            +--------V----------+
>>>      |   iommufd    |            |    vfio legacy    |
>>>      |  container   |            |     container     |
>>>      +-------+------+            +--------+----------+
>>>              |                            |
>>>              | /dev/iommu                 | /dev/vfio/vfio
>>>              | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
>>>   Userspace  |                            |
>>>
>>> ===========+============================+=======================
>>> =========
>>>   Kernel     |  device fd                 |
>>>              +---------------+            | group/container fd
>>>              | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
>>>              |  ATTACH_IOAS) |            | device fd
>>>              |               |            |
>>>              |       +-------V------------V-----------------+
>>>      iommufd |       |                vfio                  |
>>> (map/unmap  |       +---------+--------------------+-------+
>>>   ioas_copy) |                 |                    | map/unmap
>>>              |                 |                    |
>>>       +------V------+    +-----V------+      +------V--------+
>>>       | iommfd core |    |  device    |      |  vfio iommu   |
>>>       +-------------+    +------------+      +---------------+
>>
>> last row: s/iommfd/iommufd/
>
> thanks. a typo.
>
>> overall this sounds a reasonable abstraction. Later when vdpa starts
>> supporting iommufd probably the iommufd BE will become even
>> smaller with more logic shareable between vfio and vdpa.
>
> let's see if Jason Wang will give some idea. :-)
>
>>>
>>> [Secure Context setup]
>>> - iommufd BE: uses device fd and iommufd to setup secure context
>>>                (bind_iommufd, attach_ioas)
>>> - vfio legacy BE: uses group fd and container fd to setup secure
>>> context
>>>                    (set_container, set_iommu)
>>> [Device access]
>>> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
>>> - vfio legacy BE: device fd is retrieved from group fd ioctl
>>> [DMA Mapping flow]
>>> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
>>> - VFIO populates DMA map/unmap via the container BEs
>>>    *) iommufd BE: uses iommufd
>>>    *) vfio legacy BE: uses container fd
>>>
>>> This series qomifies the VFIOContainer object which acts as a base
>>> class
>>
>> what does 'qomify' mean? I didn't find this word from dictionary...
>>
>>> for a container. This base class is derived into the legacy VFIO
>>> container
>>> and the new iommufd based container. The base class implements generic
>>> code
>>> such as code related to memory_listener and address space management
>>> whereas
>>> the derived class implements callbacks that depend on the kernel
>>> user space
>>
>> 'the kernel user space'?
>
> aha, just want to express different BE callbacks will use different
> user interface exposed by kernel. will refine the wording.
>
>>
>>> being used.
>>>
>>> The selection of the backend is made on a device basis using the new
>>> iommufd option (on/off/auto). By default the iommufd backend is
>>> selected
>>> if supported by the host and by QEMU (iommufd KConfig). This option is
>>> currently available only for the vfio-pci device. For other types of
>>> devices, it does not yet exist and the legacy BE is chosen by default.
>>>
>>> Test done:
>>> - PCI and Platform device were tested
>>
>> In this case PCI uses iommufd while platform device uses legacy?
>
> For PCI, both legacy and iommufd were tested. The exploration kernel
> branch doesn't have the new device uapi for platform device, so I
> didn't test it.
> But I remember Eric should have tested it with iommufd. Eric?
No I just ran non regression tests for vfio-platform, in legacy mode. I
did not integrate with the new device uapi for platform device.
>
>>> - ccw and ap were only compile-tested
>>> - limited device hotplug test
>>> - vIOMMU test run for both legacy and iommufd backends (limited tests)
>>>
>>> This series was co-developed by Eric Auger and me based on the
>>> exploration
>>> iommufd kernel[2], complete code of this series is available in[3]. As
>>> iommufd kernel is in the early step (only iommufd generic interface
>>> is in
>>> mailing list), so this series hasn't made the iommufd backend fully
>>> on par
>>> with legacy backend w.r.t. features like p2p mappings, coherency
>>> tracking,
>>
>> what does 'coherency tracking' mean here? if related to iommu enforce
>> snoop it is fully handled by the kernel so far. I didn't find any use of
>> VFIO_DMA_CC_IOMMU in current Qemu.
>
> It's the kvm_group add/del stuffs.perhaps say kvm_group add/del
> equivalence
> would be better?
>
>>> live migration, etc. This series hasn't supported PCI devices
>>> without FLR
>>> neither as the kernel doesn't support VFIO_DEVICE_PCI_HOT_RESET when
>>> userspace
>>> is using iommufd. The kernel needs to be updated to accept device fd
>>> list for
>>> reset when userspace is using iommufd. Related work is in progress by
>>> Jason[4].
>>>
>>> TODOs:
>>> - Add DMA alias check for iommufd BE (group level)
>>> - Make pci.c to be BE agnostic. Needs kernel change as well to fix the
>>>    VFIO_DEVICE_PCI_HOT_RESET gap
>>> - Cleanup the VFIODevice fields as it's used in both BEs
>>> - Add locks
>>> - Replace list with g_tree
>>> - More tests
>>>
>>> Patch Overview:
>>>
>>> - Preparation:
>>>    0001-scripts-update-linux-headers-Add-iommufd.h.patch
>>>    0002-linux-headers-Import-latest-vfio.h-and-iommufd.h.patch
>>>    0003-hw-vfio-pci-fix-vfio_pci_hot_reset_result-trace-poin.patch
>>>    0004-vfio-pci-Use-vbasedev-local-variable-in-vfio_realize.patch
>>>    0005-vfio-common-Rename-VFIOGuestIOMMU-iommu-into-
>>> iommu_m.patch
>>
>> 3-5 are pure cleanups which could be sent out separately
>
> yes. may send later after checking with Eric. :-)
yes makes sense to send them separately.

Thanks

Eric
>
>>>    0006-vfio-common-Split-common.c-into-common.c-container.c.patch
>>>
>>> - Introduce container object and covert existing vfio to use it:
>>>    0007-vfio-Add-base-object-for-VFIOContainer.patch
>>>    0008-vfio-container-Introduce-vfio_attach-detach_device.patch
>>>    0009-vfio-platform-Use-vfio_-attach-detach-_device.patch
>>>    0010-vfio-ap-Use-vfio_-attach-detach-_device.patch
>>>    0011-vfio-ccw-Use-vfio_-attach-detach-_device.patch
>>>    0012-vfio-container-obj-Introduce-attach-detach-_device-c.patch
>>>    0013-vfio-container-obj-Introduce-VFIOContainer-reset-cal.patch
>>>
>>> - Introduce iommufd based container:
>>>    0014-hw-iommufd-Creation.patch
>>>    0015-vfio-iommufd-Implement-iommufd-backend.patch
>>>    0016-vfio-iommufd-Add-IOAS_COPY_DMA-support.patch
>>>
>>> - Add backend selection for vfio-pci:
>>>    0017-vfio-as-Allow-the-selection-of-a-given-iommu-backend.patch
>>>    0018-vfio-pci-Add-an-iommufd-option.patch
>>>
>>> [1] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-
>>> iommufd_jgg@nvidia.com/
>>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>>> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
>>> [4] https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-
>>> vfio_mdev_no_group_jgg@nvidia.com/
>>
>> Following is probably more relevant to [4]:
>>
>> https://lore.kernel.org/all/10-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com/
>>
>
> absolutely.:-) thanks.
>
>> Thanks
>> Kevin
>

