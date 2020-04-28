Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD71BC465
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgD1QCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:02:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgD1QCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:02:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SFwq7i060307;
        Tue, 28 Apr 2020 16:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AdOVNmlqnmMa1m4s3N28MY0KnHTxH/u5cdtHE32+HHY=;
 b=uL/VQv1nXXX+xoOJU5+v0PpDaP9WS4RnGHgqBxJZE6to8laQoFDPDESPK2Yf9Fg13U/h
 cGCtUSZyc5cioQSIdwUAebDdDVFnoDMt02zzMSwmgWMMjWudpeKPb8BFd1A5+qxYnm4A
 wsYvEFA3BKglXo9MAGJkr48/HUP09tta+wgQchz3nHToyY+R6bOod8el2VkkOIQ8oZXv
 M/6No6ftWgIdyPX2x5u6awO7yeUoHK7nnFxqcrqRb1J0CAjMT5GyFiZNv0TroA18fcwm
 HpNk4G2mGXtZMDaC2MBUSvlVMgCKku3dxRxI8PH0E9ekALOvaULFKydxxJ4YHqrvf2MP Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg0w54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 16:01:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SFuerq071350;
        Tue, 28 Apr 2020 16:01:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30mxpgbmum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 16:01:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SG1owe014748;
        Tue, 28 Apr 2020 16:01:51 GMT
Received: from [192.168.14.112] (/79.176.191.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 09:01:50 -0700
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Alexander Graf <graf@amazon.de>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <5c514de6-52a8-8532-23d9-e6b0cc9ac7eb@oracle.com>
 <eb92ba4e-113e-d7ec-4633-f6b5ac54796b@amazon.com>
 <26111e31-8ff5-8358-1e05-6d7df0441ab1@oracle.com>
 <50f58a36-76ee-5e97-f5e6-1f08bee0c596@amazon.de>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <6789d559-cb57-24b5-2c4a-57c6d18133a2@oracle.com>
Date:   Tue, 28 Apr 2020 19:01:45 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <50f58a36-76ee-5e97-f5e6-1f08bee0c596@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 28/04/2020 18:25, Alexander Graf wrote:
>
>
> On 27.04.20 13:44, Liran Alon wrote:
>>
>> On 27/04/2020 10:56, Paraschiv, Andra-Irina wrote:
>>>
>>> On 25/04/2020 18:25, Liran Alon wrote:
>>>>
>>>> On 23/04/2020 16:19, Paraschiv, Andra-Irina wrote:
>>>>>
>>>>> The memory and CPUs are carved out of the primary VM, they are
>>>>> dedicated for the enclave. The Nitro hypervisor running on the host
>>>>> ensures memory and CPU isolation between the primary VM and the
>>>>> enclave VM.
>>>> I hope you properly take into consideration Hyper-Threading
>>>> speculative side-channel vulnerabilities here.
>>>> i.e. Usually cloud providers designate each CPU core to be assigned
>>>> to run only vCPUs of specific guest. To avoid sharing a single CPU
>>>> core between multiple guests.
>>>> To handle this properly, you need to use some kind of core-scheduling
>>>> mechanism (Such that each CPU core either runs only vCPUs of enclave
>>>> or only vCPUs of primary VM at any given point in time).
>>>>
>>>> In addition, can you elaborate more on how the enclave memory is
>>>> carved out of the primary VM?
>>>> Does this involve performing a memory hot-unplug operation from
>>>> primary VM or just unmap enclave-assigned guest physical pages from
>>>> primary VM's SLAT (EPT/NPT) and map them now only in enclave's SLAT?
>>>
>>> Correct, we take into consideration the HT setup. The enclave gets
>>> dedicated physical cores. The primary VM and the enclave VM don't run
>>> on CPU siblings of a physical core.
>> The way I would imagine this to work is that Primary-VM just specifies
>> how many vCPUs will the Enclave-VM have and those vCPUs will be set with
>> affinity to run on same physical CPU cores as Primary-VM.
>> But with the exception that scheduler is modified to not run vCPUs of
>> Primary-VM and Enclave-VM as sibling on the same physical CPU core
>> (core-scheduling). i.e. This is different than primary-VM losing
>> physical CPU cores permanently as long as the Enclave-VM is running.
>> Or maybe this should even be controlled by a knob in virtual PCI device
>> interface to allow flexibility to customer to decide if Enclave-VM needs
>> dedicated CPU cores or is it ok to share them with Primary-VM
>> as long as core-scheduling is used to guarantee proper isolation.
>
> Running both parent and enclave on the same core can *potentially* 
> lead to L2 cache leakage, so we decided not to go with it :).
Haven't thought about the L2 cache. Makes sense. Ack.
>
>>>
>>> Regarding the memory carve out, the logic includes page table entries
>>> handling.
>> As I thought. Thanks for conformation.
>>>
>>> IIRC, memory hot-unplug can be used for the memory blocks that were
>>> previously hot-plugged.
>>>
>>> https://urldefense.com/v3/__https://www.kernel.org/doc/html/latest/admin-guide/mm/memory-hotplug.html__;!!GqivPVa7Brio!MubgaBjJabDtNzNpdOxxbSKtLbqXHbsEpTtZ1mj-rnfLvMIbLW1nZ8cK10GhYJQ$ 
>>>
>>>
>>>>
>>>> I don't quite understand why Enclave VM needs to be
>>>> provisioned/teardown during primary VM's runtime.
>>>>
>>>> For example, an alternative could have been to just provision both
>>>> primary VM and Enclave VM on primary VM startup.
>>>> Then, wait for primary VM to setup a communication channel with
>>>> Enclave VM (E.g. via virtio-vsock).
>>>> Then, primary VM is free to request Enclave VM to perform various
>>>> tasks when required on the isolated environment.
>>>>
>>>> Such setup will mimic a common Enclave setup. Such as Microsoft
>>>> Windows VBS EPT-based Enclaves (That all runs on VTL1). It is also
>>>> similar to TEEs running on ARM TrustZone.
>>>> i.e. In my alternative proposed solution, the Enclave VM is similar
>>>> to VTL1/TrustZone.
>>>> It will also avoid requiring introducing a new PCI device and driver.
>>>
>>> True, this can be another option, to provision the primary VM and the
>>> enclave VM at launch time.
>>>
>>> In the proposed setup, the primary VM starts with the initial
>>> allocated resources (memory, CPUs). The launch path of the enclave VM,
>>> as it's spawned on the same host, is done via the ioctl interface -
>>> PCI device - host hypervisor path. Short-running or long-running
>>> enclave can be bootstrapped during primary VM lifetime. Depending on
>>> the use case, a custom set of resources (memory and CPUs) is set for
>>> an enclave and then given back when the enclave is terminated; these
>>> resources can be used for another enclave spawned later on or the
>>> primary VM tasks.
>>>
>> Yes, I already understood this is how the mechanism work. I'm
>> questioning whether this is indeed a good approach that should also be
>> taken by upstream.
>
> I thought the point of Linux was to support devices that exist, rather 
> than change the way the world works around it? ;)
I agree. Just poking around to see if upstream wants to implement a 
different approach for Enclaves, regardless of accepting the Nitro 
Enclave virtual PCI driver for AWS use-case of course.
>
>> The use-case of using Nitro Enclaves is for a Confidential-Computing
>> service. i.e. The ability to provision a compute instance that can be
>> trusted to perform a bunch of computation on sensitive
>> information with high confidence that it cannot be compromised as it's
>> highly isolated. Some technologies such as Intel SGX and AMD SEV
>> attempted to achieve this even with guarantees that
>> the computation is isolated from the hardware and hypervisor itself.
>
> Yeah, that worked really well, didn't it? ;)
You haven't seen me saying SGX worked well. :)
AMD SEV though still have it's shot (Once SEV-SNP will be GA).
>
>> I would have expected that for the vast majority of real customer
>> use-cases, the customer will provision a compute instance that runs some
>> confidential-computing task in an enclave which it
>> keeps running for the entire life-time of the compute instance. As the
>> sole purpose of the compute instance is to just expose a service that
>> performs some confidential-computing task.
>> For those cases, it should have been sufficient to just pre-provision a
>> single Enclave-VM that performs this task, together with the compute
>> instance and connect them via virtio-vsock.
>> Without introducing any new virtual PCI device, guest PCI driver and
>> unique semantics of stealing resources (CPUs and Memory) from primary-VM
>> at runtime.
>
> You would also need to preprovision the image that runs in the 
> enclave, which is usually only determined at runtime. For that you 
> need the PCI driver anyway, so why not make the creation dynamic too?
The image doesn't have to be determined at runtime. It could be supplied 
to control-plane. As mentioned below.
>
>> In this Nitro Enclave architecture, we de-facto put Compute
>> control-plane abilities in the hands of the guest VM. Instead of
>> introducing new control-plane primitives that allows building
>> the data-plane architecture desired by the customer in a flexible 
>> manner.
>> * What if the customer prefers to have it's Enclave VM polling S3 bucket
>> for new tasks and produce results to S3 as-well? Without having any
>> "Primary-VM" or virtio-vsock connection of any kind?
>> * What if for some use-cases customer wants Enclave-VM to have dedicated
>> compute power (i.e. Not share physical CPU cores with primary-VM. Not
>> even with core-scheduling) but for other
>> use-cases, customer prefers to share physical CPU cores with Primary-VM
>> (Together with core-scheduling guarantees)? (Although this could be
>> addressed by extending the virtual PCI device
>> interface with a knob to control this)
>>
>> An alternative would have been to have the following new control-plane
>> primitives:
>> * Ability to provision a VM without boot-volume, but instead from an
>> Image that is used to boot from memory. Allowing to provision 
>> disk-less VMs.
>>    (E.g. Can be useful for other use-cases such as VMs not requiring EBS
>> at all which could allow cheaper compute instance)
>> * Ability to provision a group of VMs together as a group such that they
>> are guaranteed to launch as sibling VMs on the same host.
>> * Ability to create a fast-path connection between sibling VMs on the
>> same host with virtio-vsock. Or even also other shared-memory mechanism.
>> * Extend AWS Fargate with ability to run multiple microVMs as a group
>> (Similar to above) connected with virtio-vsock. To allow on-demand scale
>> of confidential-computing task.
>
> Yes, there are a *lot* of different ways to implement enclaves in a 
> cloud environment. This is the one that we focused on, but I'm sure 
> others in the space will have more ideas. It's definitely an 
> interesting space and I'm eager to see more innovation happening :).
>
>> Having said that, I do see a similar architecture to Nitro Enclaves
>> virtual PCI device used for a different purpose: For hypervisor-based
>> security isolation (Such as Windows VBS).
>> E.g. Linux boot-loader can detect the presence of this virtual PCI
>> device and use it to provision multiple VM security domains. Such that
>> when a security domain is created,
>> it is specified what is the hardware resources it have access to (Guest
>> memory pages, IOPorts, MSRs and etc.) and the blob it should run to
>> bootstrap. Similar, but superior than,
>> Hyper-V VSM. In addition, some security domains will be given special
>> abilities to control other security domains (For example, to control the
>> +XS,+XU EPT bits of other security
>> domains to enforce code-integrity. Similar to Windows VBS HVCI). Just an
>> idea... :)
>
> Yes, absolutely! So much fun to be had :D

:)

-Liran

>
>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
