Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0FD48DA77
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 16:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiAMPJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 10:09:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235988AbiAMPJZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 10:09:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DDq9u4010321;
        Thu, 13 Jan 2022 15:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7LX5KeAirnDHIYJQqXMWNufA/g4qmD+wx5smisw5wbM=;
 b=s9vailyQj2majgh9Yq5+b1P/kGn7M72S3/zBzWeqy08cYOz9UHhOXltISWwM2SgF/S2E
 WadkGwgSC7Epd4vZhEN+o8iJIoiYZVxTkR/fPnKX/RIIQ+SZr0wisYrEP+u2qmc0GZDK
 rrWTlxr89tlHeksHGAJvNZBULESeVGAqNYo2uhh6pTho8DfxP4TdVxqkKffc13wfWH79
 FZ8is1cEq3vI7ChzFai9MUEvJqAk8bZFa6YgGpCupbqERZD7Ld45Ia/76MsiS/U4qlqV
 d2w+Byv6Ih3k9nyUHRawGTxoUS0ul0put6w3j2z9fHyJ027WOxAC0ma2MdDMdoLm0iv2 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djnbe1nmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:09:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DF5VZv009362;
        Thu, 13 Jan 2022 15:09:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djnbe1nk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:09:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DF7ORa025162;
        Thu, 13 Jan 2022 15:09:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3df289upsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:09:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DF9FC442729918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 15:09:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E186BA407C;
        Thu, 13 Jan 2022 15:09:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B6F9A405F;
        Thu, 13 Jan 2022 15:09:14 +0000 (GMT)
Received: from [9.171.57.64] (unknown [9.171.57.64])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 15:09:14 +0000 (GMT)
Message-ID: <4a54cba5-6fce-7810-2966-b990d0dbb7c3@linux.ibm.com>
Date:   Thu, 13 Jan 2022 16:09:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
 <20220113120609.736701-1-borntraeger@linux.ibm.com>
 <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
 <b6d9785d769f98da0b057fac643b0f088e346a94.camel@infradead.org>
 <c685a543-a524-9c95-4b85-f53a0ff744a9@linux.ibm.com>
 <bfc53985a178f43a3a21796f33449570cf9e4649.camel@infradead.org>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <bfc53985a178f43a3a21796f33449570cf9e4649.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zhB1xhAe4LBWJhH9SRJkn9MP5dxb3LLA
X-Proofpoint-GUID: morpnHT-q60JuDUQdTVAIhkTneeom_hM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_07,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13.01.22 um 14:22 schrieb David Woodhouse:
> On Thu, 2022-01-13 at 13:51 +0100, Christian Borntraeger wrote:
>>> Btw, that get_map_page() in arch/s390/kvm/interrupt.c looks like it has
>>> the same use-after-free problem that kvm_map_gfn() used to have. It
>>> probably wants converting to the new gfn_to_pfn_cache.
>>>
>>> Take a look at how I resolve the same issue for delivering Xen event
>>> channel interrupts.
>>
>> Do you have a commit ID for your Xen event channel fix?
> 
> 14243b387137 ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event
> channel delivery") and the commits reworking the gfn_to_pfn_cache which
> lead up to it.
> 
> Questions: In your kvm_set_routing_entry() where it calls
> gmap_translate() to turn the summary_addr and ind_addr from guest
> addresses to userspace virtual addresses, what protects those
> translations? If the gmap changes before kvm_set_routing_entry() even
> returns, what ensures that the IRQ gets retranslated?

In the end the gmap translated between guest physical and host virtual, just
like the kvm memslots. This is done in kvm_arch_commit_memory_region. The gmap
is a method where we share the last level page table between the guest mapping
and the user mapping. That is why our memslots have to be on 1 MB boundary (our
page tables have 256 4k entries). So instead of gmap we could have used the
memslots as well for translation.

I have trouble seeing a kernel integrity issue: worst case is that we point to
a different address in the userspace mapping if qemu would change the memslots
maybe even to an invalid one. But then the access should fail (for invalid) or
you get a self-inflicted bit flips on your own address space if you play such
games.

Well, one thing:  if QEMU changes memslots, it might need to redo the irqfd
registration as well as we do not follow these changes. Maybe this is something
that we could improve as future QEMUs could do more changes regarding memslots.

> 
> And later in adapter_indicators_set() where you take that userspace
> virtual address and pass it to your get_map_page() function, the same
> question: what if userspace does a concurrent mmap() and changes the
> physical page that the userspace address points to?
> 
> In the latter case, at least it does look like you don't support
> external memory accessed only by a PFN without having a corresponding
> struct page. So at least you don't end up accessing a page that can now
> belong to *another* guest, because the original underlying page is
> locked. You're probably OK in that case, so it's just the gmap changing
> that we need to focus on?
