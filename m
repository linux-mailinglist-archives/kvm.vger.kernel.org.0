Return-Path: <kvm+bounces-305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA2D7DE0B9
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 13:23:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A86F51C20D88
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180CF125AD;
	Wed,  1 Nov 2023 12:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6E3D74
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 12:23:34 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39CBDC
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 05:23:28 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SL5dz2H0ZzMlyC;
	Wed,  1 Nov 2023 20:19:03 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 1 Nov 2023 20:23:22 +0800
Subject: Re: Question: In a certain scenario, enabling GICv4/v4.1 may cause
 Guest hang when restarting the Guest
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Eric
 Auger <eric.auger@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>
CC: <kvm@vger.kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	"wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
	<chenxiang66@hisilicon.com>
References: <2bcd2a8a-673a-237f-8491-30db260fcf37@huawei.com>
 <0d9fdf42-76b1-afc6-85a9-159c5490bbd4@huawei.com>
 <8b881d50-cd26-9b7d-5057-93d48e20e4d1@huawei.com>
Message-ID: <a627066b-8a01-09bf-5bc6-72c9aa45d451@huawei.com>
Date: Wed, 1 Nov 2023 20:14:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8b881d50-cd26-9b7d-5057-93d48e20e4d1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Hi Mark,

Kindly ping.

The current implementation of GICv4/4.1 direct injection of vLPI
does not support "one shared vector for all queues" mode of
virtio-pci. Do you have any good idea?


Looking forward to your views on this qeustion.

Thanks,
Kunkun Jiang

On 2023/10/7 16:02, Kunkun Jiang wrote:
> Hi Mark,
>
> Kindly ping...
>
> I tried to fix it by decouple "host_irq" from vgic_irq when dealing
> with vlpi. Because I think the semantics of vic_irq->host_irq is
> vgic_irq bind 1:1 to the host-side LPI hwintid. But when I modified
> the code, I found that "host_irq" was used multiple times in
> vlpi related code and necessary...
>
> Looking forward to your views on this qeustion.
>
> Thanks,
> Kunkun Jiang
>
> On 2023/9/26 10:21, Kunkun Jiang wrote:
>> Hi everyone,
>>
>> Sorry, yesterday's email was garbled. Please see this version.
>>
>> Here is a very valuable question about the direct injection of vLPI.
>> Environment configuration:
>> 1)A virtio_SCSI device is pass through to a small-scale VM,1U
>> 2)Guest Kernel 4.19,Host Kernel 5.10
>> 3)Enable GICv4/v4.1
>> The Guest will hang in the BIOS phase when it is restarted, and
>> report"Synchronous Exception at 0x280004654FF40".
>>
>> Here's the analysis:
>> The virtio_SCSI device has six queues. The virtio driver may apply for
>> a vector for each queue of the device. It may also apply for one vector
>> for all queues. These queues share the vector.
>> In the problem scenario:
>> 1.The host driver(vDPA or VFIO) applies for six vectors(LPI) for the 
>> device.
>> 2.The virtio driver applies for only one vector(vLPI) in the guest.
>> 3.Only one vgic_irq is allocated by the vigic driver.In the current 
>> vgic driver
>>  implemention, when MAPTI/MAPI is executed in the Guest, it will be 
>> trapped
>>  to KVM. Therefore, the vgic driver allocates the same number of 
>> vgic_irq
>>  to record these vectors which applied by device drivers in VM.
>> 4.The kvm_vgic_v4_set_forwarding and its_map_vlpi is executed six times.
>>  vgic_irq->host_irq equals the last linux interrupt ID(virq). The 
>> result is
>>  that six LPIs are mapped to one vLPI. The six LPIs of the device can
>>  send interrupts. These interrupts will be injected into the guest
>>  through the same vLPI.
>> 5.When the Guest is restarted.The kvm_vgic_v4_unset_forwarding will 
>> also be
>>  executed six times. However, multiple call traces are generated. Since
>>  there is only one vgic_irq, its_unmap_vlpi is executed only once.
>>
>>> WARN_ON(!(irq->hw && irq->host_irq == virq));
>>> if (irq->hw) {
>>> atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count); 
>>>
>>>          irq->hw = false;
>>>          ret = its_unmap_vlpi(virq);
>>> } 
>>
>> 6.In the BIOS phase after the Guest restarted, the other five vectors 
>> continue
>>  to send interrupts. BIOS cannot handle these interrupts, so the 
>> Guest hang.
>>
>> This problem does not occur when the guest kernel is version 5.10, 
>> because
>> this patch is incorporated.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c66d4bd110a1f 
>>
>>
>> I think there are other scenarios where the virtual machine will 
>> apply for an
>> vector, and the host will apply for multiple vectors. There is still 
>> value in
>> fixing this problem at the hypervisor layer. I think there are two 
>> modification
>> methods here, but not sure if it is possible:
>> 1)The vDPA or VFIO driver is aware of the behavior within the Guest 
>> and only
>> apply for the same number of vectors.
>> 2)Modify the vgic driver so that one vgic_irq can be bound to 
>> multiple LPIs.
>> But I understand that the semantics of vigc_irq->host_irq is that 
>> vgic_irq
>> is bound 1:1 to the host-side LPI hwintid.
>>
>> If you have other ideas, we can discuss them together.
>>
>> Looking forwarding to your reply.
>> Thanks,
>> Kunkun Jiang
>>
>> .
>
> .

