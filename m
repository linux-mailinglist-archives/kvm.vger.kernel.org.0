Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F1219B4E
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 10:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGIIlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 04:41:16 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:50663 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgGIIlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 04:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594284071; x=1625820071;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6Hkhde5IxnELtuse18A/DwgKSpkcR/Hv6UUPWVTjkdM=;
  b=HSxk8h9thOWVRW7BK4XdE/orm/V3KZX8mNlaBQ12EwaQ5mpBUnLpdlwF
   0z+ptESrwHQ9kE3x1cJm9SfhSQER3/Y2q6oCp1RoUptSbOrsF/gPz77dG
   MCS5LDB6fgrFlS1MsYoJiO1pu+43izpnVM1NLz38V3/rzwmXQ494mR7R9
   o=;
IronPort-SDR: 453VhCMhBzUIFqJb6zNPay0YrAlrN1Zc73WsiYAu6vrksw0hQrWJ8AAVWjvSrsPgTYU4jJrKUT
 YE/UjYF0EXkA==
X-IronPort-AV: E=Sophos;i="5.75,331,1589241600"; 
   d="scan'208";a="40904264"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 09 Jul 2020 08:41:05 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 935BAA1D40;
        Thu,  9 Jul 2020 08:41:04 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 08:41:03 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.100) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 08:40:59 +0000
Subject: Re: [PATCH v4 11/18] nitro_enclaves: Add logic for enclave memory
 region set
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-12-andraprs@amazon.com>
 <798dbb9f-0fe4-9fd9-2e64-f6f2bc740abf@amazon.de>
 <b7b7691c-595f-531e-9db3-c8e3fc21f983@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <d4577406-8c9c-7130-3322-8265a2795d9a@amazon.de>
Date:   Thu, 9 Jul 2020 10:40:57 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b7b7691c-595f-531e-9db3-c8e3fc21f983@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09.07.20 09:36, Paraschiv, Andra-Irina wrote:
> =

> =

> On 06/07/2020 13:46, Alexander Graf wrote:
>>
>>
>> On 22.06.20 22:03, Andra Paraschiv wrote:
>>> Another resource that is being set for an enclave is memory. User space
>>> memory regions, that need to be backed by contiguous memory regions,
>>> are associated with the enclave.
>>>
>>> One solution for allocating / reserving contiguous memory regions, that
>>> is used for integration, is hugetlbfs. The user space process that is
>>> associated with the enclave passes to the driver these memory regions.
>>>
>>> The enclave memory regions need to be from the same NUMA node as the
>>> enclave CPUs.
>>>
>>> Add ioctl command logic for setting user space memory region for an
>>> enclave.
>>>
>>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>> ---
>>> Changelog
>>>
>>> v3 -> v4
>>>
>>> * Check enclave memory regions are from the same NUMA node as the
>>> =A0=A0 enclave CPUs.
>>> * Use dev_err instead of custom NE log pattern.
>>> * Update the NE ioctl call to match the decoupling from the KVM API.
>>>
>>> v2 -> v3
>>>
>>> * Remove the WARN_ON calls.
>>> * Update static calls sanity checks.
>>> * Update kzfree() calls to kfree().
>>>
>>> v1 -> v2
>>>
>>> * Add log pattern for NE.
>>> * Update goto labels to match their purpose.
>>> * Remove the BUG_ON calls.
>>> * Check if enclave max memory regions is reached when setting an enclave
>>> =A0=A0 memory region.
>>> * Check if enclave state is init when setting an enclave memory region.
>>> ---
>>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 257 +++++++++++++++++++=
+++
>>> =A0 1 file changed, 257 insertions(+)
>>>
>>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>> index cfdefa52ed2a..17ccb6cdbd75 100644
>>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>> @@ -476,6 +476,233 @@ static int ne_create_vcpu_ioctl(struct =

>>> ne_enclave *ne_enclave, u32 vcpu_id)
>>> =A0=A0=A0=A0=A0 return rc;
>>> =A0 }
>>> =A0 +/**
>>> + * ne_sanity_check_user_mem_region - Sanity check the userspace memory
>>> + * region received during the set user memory region ioctl call.
>>> + *
>>> + * This function gets called with the ne_enclave mutex held.
>>> + *
>>> + * @ne_enclave: private data associated with the current enclave.
>>> + * @mem_region: user space memory region to be sanity checked.
>>> + *
>>> + * @returns: 0 on success, negative return value on failure.
>>> + */
>>> +static int ne_sanity_check_user_mem_region(struct ne_enclave =

>>> *ne_enclave,
>>> +=A0=A0=A0 struct ne_user_memory_region *mem_region)
>>> +{
>>> +=A0=A0=A0 if (ne_enclave->mm !=3D current->mm)
>>> +=A0=A0=A0=A0=A0=A0=A0 return -EIO;
>>> +
>>> +=A0=A0=A0 if ((mem_region->memory_size % NE_MIN_MEM_REGION_SIZE) !=3D =
0) {
>>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Mem size no=
t multiple of 2 MiB\n");
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>>
>> Can we make this an error that gets propagated to user space =

>> explicitly? I'd rather have a clear error return value of this =

>> function than a random message in dmesg.
> =

> We can make this, will add memory checks specific NE error codes, as for =

> the other call paths in the series e.g. enclave CPU(s) setup.
> =

>>
>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 if ((mem_region->userspace_addr & (NE_MIN_MEM_REGION_SIZE - =
1)) ||
>>
>> This logic already relies on the fact that NE_MIN_MEM_REGION_SIZE is a =

>> power of two. Can you do the same above on the memory_size check?
> =

> Done.
> =

>>
>>> +=A0=A0=A0=A0=A0=A0=A0 !access_ok((void __user *)(unsigned =

>>> long)mem_region->userspace_addr,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem_region->memory_size)) {
>>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Invalid use=
r space addr range\n");
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>>
>> Same comment again. Return different errors for different conditions, =

>> so that user space has a chance to print proper errors to its users.
>>
>> Also, don't we have to check alignment of userspace_addr as well?
>>
> =

> Would need an alignment check for 2 MiB at least, yes.
> =

>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 return 0;
>>> +}
>>> +
>>> +/**
>>> + * ne_set_user_memory_region_ioctl - Add user space memory region to =

>>> the slot
>>> + * associated with the current enclave.
>>> + *
>>> + * This function gets called with the ne_enclave mutex held.
>>> + *
>>> + * @ne_enclave: private data associated with the current enclave.
>>> + * @mem_region: user space memory region to be associated with the =

>>> given slot.
>>> + *
>>> + * @returns: 0 on success, negative return value on failure.
>>> + */
>>> +static int ne_set_user_memory_region_ioctl(struct ne_enclave =

>>> *ne_enclave,
>>> +=A0=A0=A0 struct ne_user_memory_region *mem_region)
>>> +{
>>> +=A0=A0=A0 struct ne_pci_dev_cmd_reply cmd_reply =3D {};
>>> +=A0=A0=A0 long gup_rc =3D 0;
>>> +=A0=A0=A0 unsigned long i =3D 0;
>>> +=A0=A0=A0 struct ne_mem_region *ne_mem_region =3D NULL;
>>> +=A0=A0=A0 unsigned long nr_phys_contig_mem_regions =3D 0;
>>> +=A0=A0=A0 unsigned long nr_pinned_pages =3D 0;
>>> +=A0=A0=A0 struct page **phys_contig_mem_regions =3D NULL;
>>> +=A0=A0=A0 int rc =3D -EINVAL;
>>> +=A0=A0=A0 struct slot_add_mem_req slot_add_mem_req =3D {};
>>> +
>>> +=A0=A0=A0 rc =3D ne_sanity_check_user_mem_region(ne_enclave, mem_regio=
n);
>>> +=A0=A0=A0 if (rc < 0)
>>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>>> +
>>> +=A0=A0=A0 ne_mem_region =3D kzalloc(sizeof(*ne_mem_region), GFP_KERNEL=
);
>>> +=A0=A0=A0 if (!ne_mem_region)
>>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>>> +
>>> +=A0=A0=A0 /*
>>> +=A0=A0=A0=A0 * TODO: Update nr_pages value to handle contiguous virtua=
l address
>>> +=A0=A0=A0=A0 * ranges mapped to non-contiguous physical regions. Huget=
lbfs =

>>> can give
>>> +=A0=A0=A0=A0 * 2 MiB / 1 GiB contiguous physical regions.
>>> +=A0=A0=A0=A0 */
>>> +=A0=A0=A0 ne_mem_region->nr_pages =3D mem_region->memory_size /
>>> +=A0=A0=A0=A0=A0=A0=A0 NE_MIN_MEM_REGION_SIZE;
>>> +
>>> +=A0=A0=A0 ne_mem_region->pages =3D kcalloc(ne_mem_region->nr_pages,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 siz=
eof(*ne_mem_region->pages),
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GFP=
_KERNEL);
>>> +=A0=A0=A0 if (!ne_mem_region->pages) {
>>> +=A0=A0=A0=A0=A0=A0=A0 kfree(ne_mem_region);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>>
>> kfree(NULL) is a nop, so you can just set rc and goto free_mem_region =

>> here and below.
> =

> Updated both return paths.
> =

>>
>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 phys_contig_mem_regions =3D kcalloc(ne_mem_region->nr_pages,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof=
(*phys_contig_mem_regions),
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GFP_KE=
RNEL);
>>> +=A0=A0=A0 if (!phys_contig_mem_regions) {
>>> +=A0=A0=A0=A0=A0=A0=A0 kfree(ne_mem_region->pages);
>>> +=A0=A0=A0=A0=A0=A0=A0 kfree(ne_mem_region);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 /*
>>> +=A0=A0=A0=A0 * TODO: Handle non-contiguous memory regions received fro=
m user =

>>> space.
>>> +=A0=A0=A0=A0 * Hugetlbfs can give 2 MiB / 1 GiB contiguous physical re=
gions. =

>>> The
>>> +=A0=A0=A0=A0 * virtual address space can be seen as contiguous, althou=
gh it is
>>> +=A0=A0=A0=A0 * mapped underneath to 2 MiB / 1 GiB physical regions e.g=
. 8 MiB
>>> +=A0=A0=A0=A0 * virtual address space mapped to 4 physically contiguous =

>>> regions of 2
>>> +=A0=A0=A0=A0 * MiB.
>>> +=A0=A0=A0=A0 */
>>> +=A0=A0=A0 do {
>>> +=A0=A0=A0=A0=A0=A0=A0 unsigned long tmp_nr_pages =3D ne_mem_region->nr=
_pages -
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nr_pinned_pages;
>>> +=A0=A0=A0=A0=A0=A0=A0 struct page **tmp_pages =3D ne_mem_region->pages=
 +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nr_pinned_pages;
>>> +=A0=A0=A0=A0=A0=A0=A0 u64 tmp_userspace_addr =3D mem_region->userspace=
_addr +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nr_pinned_pages * NE_MIN_MEM_REGION_=
SIZE;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 gup_rc =3D get_user_pages(tmp_userspace_addr, tm=
p_nr_pages,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FOLL_GET, tm=
p_pages, NULL);
>>> +=A0=A0=A0=A0=A0=A0=A0 if (gup_rc < 0) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D gup_rc;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this=
_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
"Error in gup [rc=3D%d]\n", rc);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unpin_user_pages(ne_mem_region->page=
s, nr_pinned_pages);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_mem_region;
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 nr_pinned_pages +=3D gup_rc;
>>> +
>>> +=A0=A0=A0 } while (nr_pinned_pages < ne_mem_region->nr_pages);
>>
>> Can this deadlock the kernel? Shouldn't we rather return an error when =

>> we can't pin all pages?
> =

> It shouldn't cause a deadlock, based on the return values:
> =

>  > Returns either number of pages pinned (which may be less than the
>  > number requested), or an error. Details about the return value:
>  >
>  > -- If nr_pages is 0, returns 0.
>  > -- If nr_pages is >0, but no pages were pinned, returns -errno.
>  > -- If nr_pages is >0, and some pages were pinned, returns the number of
>  > pages pinned. Again, this may be less than nr_pages.
> =

> =

> But I can update the logic to have all or nothing.
> =

>>
>>> +
>>> +=A0=A0=A0 /*
>>> +=A0=A0=A0=A0 * TODO: Update checks once physically contiguous regions =
are =

>>> collected
>>> +=A0=A0=A0=A0 * based on the user space address and get_user_pages() re=
sults.
>>> +=A0=A0=A0=A0 */
>>> +=A0=A0=A0 for (i =3D 0; i < ne_mem_region->nr_pages; i++) {
>>> +=A0=A0=A0=A0=A0=A0=A0 if (!PageHuge(ne_mem_region->pages[i])) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this=
_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
"Not a hugetlbfs page\n");
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unpin_pages;
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 if (huge_page_size(page_hstate(ne_mem_region->pa=
ges[i])) !=3D
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NE_MIN_MEM_REGION_SIZE) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this=
_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
"Page size isn't 2 MiB\n");
>>
>> Why is a huge page size of >2MB a problem? Can't we just make =

>> huge_page_size() the ne mem slot size?
> =

> It's not a problem, actually this is part of the TODO(s) from the =

> current function, to support contiguous regions larger than 2 MiB. It's =

> just that we started with 2 MiB. :)
> =

>>
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unpin_pages;
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->numa_node !=3D
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 page_to_nid(ne_mem_region->pages[i])=
) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this=
_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
"Page isn't from NUMA node %d\n",
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
ne_enclave->numa_node);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unpin_pages;
>>
>> Is there a way to give user space hints on *why* things are going wrong?
> =

> Yes, one option for the user space to have more insights is to have the =

> specific NE error codes you mentioned, so that we can improve the =

> experience even further.
> =

>>
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 /*
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 * TODO: Update once handled non-contiguous me=
mory regions
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 * received from user space.
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 */
>>> +=A0=A0=A0=A0=A0=A0=A0 phys_contig_mem_regions[i] =3D ne_mem_region->pa=
ges[i];
>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 /*
>>> +=A0=A0=A0=A0 * TODO: Update once handled non-contiguous memory regions=
 received
>>> +=A0=A0=A0=A0 * from user space.
>>> +=A0=A0=A0=A0 */
>>> +=A0=A0=A0 nr_phys_contig_mem_regions =3D ne_mem_region->nr_pages;
>>> +
>>> +=A0=A0=A0 if ((ne_enclave->nr_mem_regions + nr_phys_contig_mem_regions=
) >
>>> +=A0=A0=A0=A0=A0=A0=A0 ne_enclave->max_mem_regions) {
>>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Reached max=
 memory regions %lld\n",
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_enclave->=
max_mem_regions);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 goto unpin_pages;
>>> +=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0 for (i =3D 0; i < nr_phys_contig_mem_regions; i++) {
>>> +=A0=A0=A0=A0=A0=A0=A0 u64 phys_addr =3D page_to_phys(phys_contig_mem_r=
egions[i]);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 slot_add_mem_req.slot_uid =3D ne_enclave->slot_u=
id;
>>> +=A0=A0=A0=A0=A0=A0=A0 slot_add_mem_req.paddr =3D phys_addr;
>>> +=A0=A0=A0=A0=A0=A0=A0 /*
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 * TODO: Update memory size of physical contig=
uous memory
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 * region, in case of non-contiguous memory re=
gions received
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 * from user space.
>>> +=A0=A0=A0=A0=A0=A0=A0=A0 */
>>> +=A0=A0=A0=A0=A0=A0=A0 slot_add_mem_req.size =3D NE_MIN_MEM_REGION_SIZE;
>>
>> Yeah, for now, just make it huge_page_size()! :)
> =

> Yup, I'll handle this in order to have the option for other sizes, in =

> addition to 2 MiB e.g. 1 GiB for hugetlbfs.
> =

>>
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_do_request(ne_enclave->pdev, SLOT_ADD_=
MEM,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &slot_add_mem_r=
eq, sizeof(slot_add_mem_req),
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &cmd_reply, siz=
eof(cmd_reply));
>>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this=
_device,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
"Error in slot add mem [rc=3D%d]\n",
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
rc);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: Only unpin memory regions n=
ot added. */
>>
>> Are we sure we're not creating an unusable system here?
> =

> The way the requests to the PCI device are structured is that we cannot =

> get back a memory region / CPU, once added, till the enclave is =

> terminated. Let's say there is an error in the remaining logic from the =

> ioctl, after the region is successfully added, then the memory region =

> can be given back to the primary / parent VM once the enclave =

> termination (including slot free) is done.
> =

> We can either have the logic handle one contiguous region per ioctl call =

> (user space gives a memory region that is backed by a single contiguous =

> physical memory region) or have a for loop to go through all contiguous =

> regions (user space gives a memory region that is backed by a set of =

> (smaller) contiguous physical memory regions). In the second case, if a =

> request to the NE PCI device fails, already added memory regions can be =

> given back only on slot free, triggered by the enclave termination, when =

> closing the enclave fd.

I'm in full agreement with you, but the logic here aborts mid-way, =

explicitly unpins all pages (does that mean use count is now -1 for =

some?) and does not keep track of the fact that some pages may be =

donated already. Does that mean that those pages may be reserved for the =

enclave, but passed to user space again?

I think in the error case, we should not unpin for now, because we can't =

guarantee that the "enclave device" isn't using those pages.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



