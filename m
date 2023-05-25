Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879F271020E
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 02:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbjEYAi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 20:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjEYAi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 20:38:57 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C35D3;
        Wed, 24 May 2023 17:38:55 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34P0TOdZ014158;
        Thu, 25 May 2023 00:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=/e6B8PzwIMOA1NUnKfCKwK2WyRgcsLlUL/WWtMhoXOo=;
 b=p3qB04b9XJKftly38O5+vr0J26dCdM35VoVjloUmf9fYS0RaN82z0Hr3YOWh4ZJQsIjf
 BZiPx+ihcB08jdCDDKbmzPherYn1S2m1s//fnj9cxWlR23hvxTUQUVj+hShpm/tBZn5v
 jDiBZ5ioeyyjMpK+LEvalgHQPiEK8wKmXBNCpReedGyLTdn2zyAqM3iDTmQKde8ORkWM
 T86J62r2qVscXNPcq/nHDEto456qzSc9BtrhHoCSk2cNbiTANPUKFw9/ulvZYESobBSt
 WF7jcasL0f/+Lab6joyPDPm4sna1+eyFr3WPINyTsoOpta5EBv9ueff6H1jxJGX7j1Tt ww== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qscautcq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 May 2023 00:37:18 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34P0bGcV018047
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 May 2023 00:37:16 GMT
Received: from [10.110.74.38] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 24 May
 2023 17:37:15 -0700
Message-ID: <cf1d6831-dac9-f738-44b4-a9dbc575b7e9@quicinc.com>
Date:   Wed, 24 May 2023 17:37:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "mic@digikod.net" <mic@digikod.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        "Graf, Alexander" <graf@amazon.com>,
        "Andersen, John S" <john.s.andersen@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
        "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <20230505152046.6575-1-mic@digikod.net>
 <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
From:   Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: IbOKlK9jsOZG2ChFhg5i0OOOj4Du3a1t
X-Proofpoint-GUID: IbOKlK9jsOZG2ChFhg5i0OOOj4Du3a1t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_17,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305250003
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2023 3:20 PM, Edgecombe, Rick P wrote:
> On Fri, 2023-05-05 at 17:20 +0200, Mickaël Salaün wrote:
>> # How does it work?
>>
>> This implementation mainly leverages KVM capabilities to control the
>> Second
>> Layer Address Translation (or the Two Dimensional Paging e.g.,
>> Intel's EPT or
>> AMD's RVI/NPT) and Mode Based Execution Control (Intel's MBEC)
>> introduced with
>> the Kaby Lake (7th generation) architecture. This allows to set
>> permissions on
>> memory pages in a complementary way to the guest kernel's managed
>> memory
>> permissions. Once these permissions are set, they are locked and
>> there is no
>> way back.
>>
>> A first KVM_HC_LOCK_MEM_PAGE_RANGES hypercall enables the guest
>> kernel to lock
>> a set of its memory page ranges with either the HEKI_ATTR_MEM_NOWRITE
>> or the
>> HEKI_ATTR_MEM_EXEC attribute. The first one denies write access to a
>> specific
>> set of pages (allow-list approach), and the second only allows kernel
>> execution
>> for a set of pages (deny-list approach).
>>
>> The current implementation sets the whole kernel's .rodata (i.e., any
>> const or
>> __ro_after_init variables, which includes critical security data such
>> as LSM
>> parameters) and .text sections as non-writable, and the .text section
>> is the
>> only one where kernel execution is allowed. This is possible thanks
>> to the new
>> MBEC support also brough by this series (otherwise the vDSO would
>> have to be
>> executable). Thanks to this hardware support (VT-x, EPT and MBEC),
>> the
>> performance impact of such guest protection is negligible.
>>
>> The second KVM_HC_LOCK_CR_UPDATE hypercall enables guests to pin some
>> of its
>> CPU control register flags (e.g., X86_CR0_WP, X86_CR4_SMEP,
>> X86_CR4_SMAP),
>> which is another complementary hardening mechanism.
>>
>> Heki can be enabled with the heki=1 boot command argument.
>>
>>
> 
> Can the guest kernel ask the host VMM's emulated devices to DMA into
> the protected data? It should go through the host userspace mappings I
> think, which don't care about EPT permissions. Or did I miss where you
> are protecting that another way? There are a lot of easy ways to ask
> the host to write to guest memory that don't involve the EPT. You
> probably need to protect the host userspace mappings, and also the
> places in KVM that kmap a GPA provided by the guest.
> 
> [ snip ]
> 
>>
>> # Current limitations
>>
>> The main limitation of this patch series is the statically enforced
>> permissions. This is not an issue for kernels without module but this
>> needs to
>> be addressed.  Mechanisms that dynamically impact kernel executable
>> memory are
>> not handled for now (e.g., kernel modules, tracepoints, eBPF JIT),
>> and such
>> code will need to be authenticated.  Because the hypervisor is highly
>> privileged and critical to the security of all the VMs, we don't want
>> to
>> implement a code authentication mechanism in the hypervisor itself
>> but delegate
>> this verification to something much less privileged. We are thinking
>> of two
>> ways to solve this: implement this verification in the VMM or spawn a
>> dedicated
>> special VM (similar to Windows's VBS). There are pros on cons to each
>> approach:
>> complexity, verification code ownership (guest's or VMM's), access to
>> guest
>> memory (i.e., confidential computing).
> 
> The kernel often creates writable aliases in order to write to
> protected data (kernel text, etc). Some of this is done right as text
> is being first written out (alternatives for example), and some happens
> way later (jump labels, etc). So for verification, I wonder what stage
> you would be verifying? If you want to verify the end state, you would
> have to maintain knowledge in the verifier of all the touch-ups the
> kernel does. I think it would get very tricky.

Right and for the ARM (from what I know) is that Erratas can be applied
using the alternatives fwk when you hotplug in the CPU post boot.

---Trilok Soni
