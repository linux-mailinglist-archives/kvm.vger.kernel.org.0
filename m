Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30FF9A723
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 07:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392162AbfHWFaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 01:30:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387557AbfHWFaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 01:30:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N5TLTI023002;
        Fri, 23 Aug 2019 05:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gFWohBOfdKshcZEk5K8mbuk+VusK92nev4qWo3nHYS4=;
 b=b47nGOmNPKzbECreNwdHU+XZXRgXg6cv5Rrg7fj+gT4jdYTEbT+zcAVv/iRKMLcV5PSY
 UZuihucIpKi2nyo88YvJUnO2CwBdPJXD+4wg3hylEwNPiQihhtoL7ZNkUfFjvI50VMG5
 nSK+NtAtYiLm722ZYj60AWis9P+We3D/B7np38RjIpm43t0KritNp6X35HR5lRY6sGsc
 4Bq3IaqtaX3hUczKj56Y2x+4FHEM+Lm5i/dwCV6xMYuoE9vTtJDuSaKDYICFQEcLo/sU
 XTzi2+iAZPtY9ba3sN/jdh1Gw2748p5jRYJVHkEhUpd7Cm0NC0t+PMGQO8G11Rw+e8b/ 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90u2dk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 05:29:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N5TIu2071173;
        Fri, 23 Aug 2019 05:29:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uh83qx02w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 05:29:38 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7N5Tbrm004595;
        Fri, 23 Aug 2019 05:29:37 GMT
Received: from [10.159.224.62] (/10.159.224.62)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 22:29:37 -0700
Subject: Re: [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry
 of nested guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-7-krish.sadhukhan@oracle.com>
 <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a2889868-eb62-5843-f3d2-fe066055e80c@oracle.com>
Date:   Thu, 22 Aug 2019 22:29:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/15/19 3:44 PM, Jim Mattson wrote:
> On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Loading Guest State" in Intel SDM vol 3C, the
>> IA32_PERF_GLOBAL_CTRL MSR is loaded on vmentry of nested guests:
>>
>>      "If the “load IA32_PERF_GLOBAL_CTRL” VM-entry control is 1, the
>>       IA32_PERF_GLOBAL_CTRL MSR is loaded from the IA32_PERF_GLOBAL_CTRL
>>       field."
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index a7bf19eaa70b..8177374886a9 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2300,6 +2300,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>          vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
>>          vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
>>
>> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>> +               vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
>> +                            vmcs12->guest_ia32_perf_global_ctrl);
>> +
>>          if (vmx->nested.nested_run_pending &&
>>              (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
>>                  vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
>> --
>> 2.17.2
>>
> This isn't quite right. The GUEST_IA32_PERF_GLOBAL_CTRL value is just
> going to get overwritten later by atomic_switch_perf_msrs().
>
> Instead of writing the vmcs12 value directly into the vmcs02, you
> should call kvm_set_msr(), exactly as it would have been called if
> MSR_CORE_PERF_GLOBAL_CTRL had been in the vmcs12
> VM-entry MSR-load list. Then, atomic_switch_perf_msrs() will
> automatically do the right thing.


I notice that the existing code for VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL 
in load_vmcs12_host_state() doesn't use kvm_set_msr():

             if (vmcs12->vm_exit_controls & 
VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
                 vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
                         vmcs12->host_ia32_perf_global_ctrl);

This should also be changed to use kvm_set_msr() then ?

