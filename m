Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB927114B5
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbjEYSjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241815AbjEYSik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:38:40 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AB2E45;
        Thu, 25 May 2023 11:36:51 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34PFGFcD001882;
        Thu, 25 May 2023 18:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=YlvFsbEPrwbVAdxwxMbKnxn1gExf5XgZ9Xo7rbW6dUQ=;
 b=Lzyf9aLPcAqinix9YfLlsRAGGN+gR2pGIMlP8b/TpYgMTdhl/3rPyJ97zvP/hy/rFL48
 cqe4Pi8D360VWoL8sYMXdrz3fQmuqTWxk7EjcGsPO8A4qjig2fE0oOs8zCtvb5BhmMB9
 sAdHk7SIWExI5l2C0Z5IPdzh1SSC8+UsT4WL8RiZ4aJdj3SoEqluyXexy6vivclVNQRp
 xfywfC0GZvFljCxVu48w6+0GrjH6HI80FeJdCtLJPgWUaVFWinxGnDMoTThNWZaZkTrb
 fqWNgaubCjXAnculU0WyTmLSQbSFozQhX9Eign2tg15P5DGaZoNtC7o225DL42lxfvDi MA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qt27n1j61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 May 2023 18:34:31 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34PIYDC6001496
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 May 2023 18:34:13 GMT
Received: from [10.110.51.179] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 25 May
 2023 11:34:12 -0700
Message-ID: <e17da8f4-4d5d-adb7-02c9-631ffdfc9037@quicinc.com>
Date:   Thu, 25 May 2023 11:34:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Content-Language: en-US
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
CC:     Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?Q?=c8=98tefan_=c8=98icleru?= <ssicleru@bitdefender.com>,
        <dev@lists.cloudhypervisor.org>, <kvm@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <virtualization@lists.linux-foundation.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
References: <20230505152046.6575-1-mic@digikod.net>
 <1e10da25-5704-18ee-b0ce-6de704e6f0e1@quicinc.com>
 <0b069bc3-0362-d8ec-fc2a-05dd65218c39@digikod.net>
From:   Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <0b069bc3-0362-d8ec-fc2a-05dd65218c39@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: uBbHTCakZngacL0OpkU9CBmNWESa7i53
X-Proofpoint-GUID: uBbHTCakZngacL0OpkU9CBmNWESa7i53
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_10,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305250156
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2023 6:25 AM, Mickaël Salaün wrote:
> 
> On 24/05/2023 23:04, Trilok Soni wrote:
>> On 5/5/2023 8:20 AM, Mickaël Salaün wrote:
>>> Hi,
>>>
>>> This patch series is a proof-of-concept that implements new KVM features
>>> (extended page tracking, MBEC support, CR pinning) and defines a new 
>>> API to
>>> protect guest VMs. No VMM (e.g., Qemu) modification is required.
>>>
>>> The main idea being that kernel self-protection mechanisms should be 
>>> delegated
>>> to a more privileged part of the system, hence the hypervisor. It is 
>>> still the
>>> role of the guest kernel to request such restrictions according to its
>>
>> Only for the guest kernel images here? Why not for the host OS kernel?
> 
> As explained in the Future work section, protecting the host would be 
> useful, but that doesn't really fit with the KVM model. The Protected 
> KVM project is a first step to help in this direction [11].
> 
> In a nutshell, KVM is close to a type-2 hypervisor, and the host kernel 
> is also part of the hypervisor.
> 
> 
>> Embedded devices w/ Android you have mentioned below supports the host
>> OS as well it seems, right?
> 
> What do you mean?

I think you have answered this above w/ pKVM and I was referring the 
host protection as well w/ Heki. The link/references below refers to the 
Android OS it seems and not guest VM.

> 
> 
>>
>> Do we suggest that all the functionalities should be implemented in the
>> Hypervisor (NS-EL2 for ARM) or even at Secure EL like Secure-EL1 (ARM).
> 
> KVM runs in EL2. TrustZone is mainly used to enforce DRM, which means 
> that we may not control the related code.
> 
> This patch series is dedicated to hypervisor-enforced kernel integrity, 
> then KVM.
> 
>>
>> I am hoping that whatever we suggest the interface here from the Guest
>> to the Hypervisor becomes the ABI right?
> 
> Yes, hypercalls are part of the KVM ABI.

Sure. I just hope that they are extensible enough to support for other 
Hypervisors too. I am not sure if they are on this list like ACRN / Xen 
and see if it fits their need too.

Is there any other Hypervisor you plan to test this feature as well?

> 
>>
>>
>>>
>>> # Current limitations
>>>
>>> The main limitation of this patch series is the statically enforced
>>> permissions. This is not an issue for kernels without module but this 
>>> needs to
>>> be addressed.  Mechanisms that dynamically impact kernel executable 
>>> memory are
>>> not handled for now (e.g., kernel modules, tracepoints, eBPF JIT), 
>>> and such
>>> code will need to be authenticated.  Because the hypervisor is highly
>>> privileged and critical to the security of all the VMs, we don't want to
>>> implement a code authentication mechanism in the hypervisor itself 
>>> but delegate
>>> this verification to something much less privileged. We are thinking 
>>> of two
>>> ways to solve this: implement this verification in the VMM or spawn a 
>>> dedicated
>>> special VM (similar to Windows's VBS). There are pros on cons to each 
>>> approach:
>>> complexity, verification code ownership (guest's or VMM's), access to 
>>> guest
>>> memory (i.e., confidential computing).
>>
>> Do you foresee the performance regressions due to lot of tracking here?
> 
> The performance impact of execution prevention should be negligible 
> because once configured the hypervisor do nothing except catch 
> illegitimate access attempts.

Yes, if you are using the static kernel only and not considering the 
other dynamic patching features like explained. They need to be thought 
upon differently to reduce the likely impact.

> 
> 
>> Production kernels do have lot of tracepoints and we use it as feature
>> in the GKI kernel for the vendor hooks implementation and in those cases
>> every vendor driver is a module.
> 
> As explained in this section, dynamic kernel modifications such as 
> tracepoints or modules are not currently supported by this patch series. 
> Handling tracepoints is possible but requires more work to define and 
> check legitimate changes. This proposal is still useful for static 
> kernels though.
> 
> 
>> Separate VM further fragments this
>> design and delegates more of it to proprietary solutions?
> 
> What do you mean? KVM is not a proprietary solution.

Ah, I was referring the VBS Windows VM mentioned in the above text. Is 
it open-source? The reference of VM (or dedicated VM) didn't mention 
that VM itself will be open-source running Linux kernel.

> 
> For dynamic checks, this would require code not run by KVM itself, but 
> either the VMM or a dedicated VM. In this case, the dynamic 
> authentication code could come from the guest VM or from the VMM itself. 
> In the former case, it is more challenging from a security point of view 
> but doesn't rely on external (proprietary) solution. In the latter case, 
> open-source VMMs should implement the specification to provide the 
> required service (e.g. check kernel module signature).
> 
> The goal of the common API layer provided by this RFC is to share code 
> as much as possible between different hypervisor backends.
> 
> 
>>
>> Do you have any performance numbers w/ current RFC?
> 
> No, but the only hypervisor performance impact is at boot time and 
> should be negligible. I'll try to get some numbers for the 
> hardware-enforcement impact, but it should be negligible too.

Thanks. Please share the data once you have it ready.

---Trilok Soni

