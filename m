Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376614D1BDA
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347882AbiCHPhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347858AbiCHPht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:37:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B34EA20;
        Tue,  8 Mar 2022 07:36:51 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228F8gpR023210;
        Tue, 8 Mar 2022 15:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hXnQ0rBa96gOa+hoSE0wvZ2c0b1RX3LP9Z6UDpoFjrg=;
 b=fSMGaya7gS4GucDkKA0fuge5/Pzj/1q2la1TR+jyaXIg+R1XwESHTyIB93zbVrRHf3he
 iNbbPQDAP1LZi+XY7YRtq0zA9vmPzIWh1tfr/UQGxVA0Lswmxw29ZarvTf0IPwT6to/3
 2rsZUDkTz0ss56IJz8pLMMMlKlyLM257zeDTDCSPVl2D+d/xTdgkqtzhCea/SsC0jUT1
 vD40QC/Srf7OZZT0vMDVj5dbVqdQGNktIT3HdEh/EwQYFcFqzrdoq7mj28nzKRnjF5uk
 jek64VxIm13jG+DdyvDX3S+NkCXlVuf73zzqyODGC7f2BJiLxU8REwcIRLMHjjotXmep mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny18dv7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:47 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 228EqN9C009729;
        Tue, 8 Mar 2022 15:36:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny18dv4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228F8l3J017955;
        Tue, 8 Mar 2022 15:36:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ekyg8eqgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228FPMrn47776060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 15:25:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A736AE053;
        Tue,  8 Mar 2022 15:36:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3CB1AE051;
        Tue,  8 Mar 2022 15:36:31 +0000 (GMT)
Received: from [9.171.93.186] (unknown [9.171.93.186])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Mar 2022 15:36:31 +0000 (GMT)
Message-ID: <b64c2540-be37-0b03-a216-39b4eb5ef85c@de.ibm.com>
Date:   Tue, 8 Mar 2022 16:36:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 30/30] KVM: selftests: Add test to populate a VM with
 the max possible guest mem
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-31-pbonzini@redhat.com>
 <63f4a488-87f1-097f-95d5-f85e46786740@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <63f4a488-87f1-097f-95d5-f85e46786740@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ofe5f7xGEwS3pzcaC3a_MoVoQ_zD_0O
X-Proofpoint-ORIG-GUID: --hHz0VjfFPlHGuHq7c1ZoUCT-vZqihS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 08.03.22 um 15:47 schrieb Paolo Bonzini:
> On 3/3/22 20:38, Paolo Bonzini wrote:
>> From: Sean Christopherson<seanjc@google.com>
>>
>> Add a selftest that enables populating a VM with the maximum amount of
>> guest memory allowed by the underlying architecture.  Abuse KVM's
>> memslots by mapping a single host memory region into multiple memslots so
>> that the selftest doesn't require a system with terabytes of RAM.
>>
>> Default to 512gb of guest memory, which isn't all that interesting, but
>> should work on all MMUs and doesn't take an exorbitant amount of memory
>> or time.  E.g. testing with ~64tb of guest memory takes the better part
>> of an hour, and requires 200gb of memory for KVM's page tables when using
>> 4kb pages.
> 
> I couldn't quite run this on a laptop, so I'll tune it down to 128gb and 3/4 of the available CPUs.
> 
>> To inflicit maximum abuse on KVM' MMU, default to 4kb pages (or whatever
>> the not-hugepage size is) in the backing store (memfd).  Use memfd for
>> the host backing store to ensure that hugepages are guaranteed when
>> requested, and to give the user explicit control of the size of hugepage
>> being tested.
>>
>> By default, spin up as many vCPUs as there are available to the selftest,
>> and distribute the work of dirtying each 4kb chunk of memory across all
>> vCPUs.  Dirtying guest memory forces KVM to populate its page tables, and
>> also forces KVM to write back accessed/dirty information to struct page
>> when the guest memory is freed.
>>
>> On x86, perform two passes with a MMU context reset between each pass to
>> coerce KVM into dropping all references to the MMU root, e.g. to emulate
>> a vCPU dropping the last reference.  Perform both passes and all
>> rendezvous on all architectures in the hope that arm64 and s390x can gain
>> similar shenanigans in the future.
> 
> Did you actually test aarch64 (not even asking about s390 :))?  For now let's only add it for x86.

I do get spurious
# selftests: kvm: max_guest_memory_test
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:883: !ret
#   pid=575178 tid=575178 errno=22 - Invalid argument
#      1	0x000000000100385f: vm_set_user_memory_region at kvm_util.c:883
#      2	0x0000000001001ee1: main at max_guest_memory_test.c:242
#      3	0x000003ffa1033731: ?? ??:0
#      4	0x000003ffa103380d: ?? ??:0
#      5	0x0000000001002389: _start at ??:?
#   KVM_SET_USER_MEMORY_REGION failed, errno = 22 (Invalid argument)
not ok 9 selftests: kvm: max_guest_memory_test # exit=254

as the userspace address must be 1MB-aligned but the mmap is not (due to aslr).

There are probably more issues, so it certainly is ok to skip s390 for now.
> 
>> +            TEST_ASSERT(nr_vcpus, "#DE");
> 
> srsly? :)
> 
> Paolo
> 
