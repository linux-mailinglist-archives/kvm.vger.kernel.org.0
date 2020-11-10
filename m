Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1DA2ADF08
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 20:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKJTEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 14:04:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJTEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 14:04:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAIjFnZ114122;
        Tue, 10 Nov 2020 19:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7m1c5pTIV0kI3e9zBRZ6UNdUmG/Rs2VB0KWAI4LOjKo=;
 b=Cz7GY7ESK4QYh6eDfZnRuBNXqm0WYS/ZWcOVFV7L2teJT+HPS5sy2azSPV3Ej8Tk/sRh
 OPA/MUUqg5ozP2k6qaGc4Ns7dpj6nYl3kczdZxhsW/aq2/pdFvFMn5A89rn0YzQaeFUx
 GC2jzt2neQ6L5wZxlIK+GoiM08sq95e5509jtQ5+LuFtSs6Epcod/LvArF6c+fODWj7k
 U6ooerCVG5EReNDD8PFs/acTx619NJoufRAYCF3KzdEWdmz+WJ+WQaqT5ZqPpd3ltWJp
 mGm1I46Qou4HwC/qjYBdPPHoJDZJhAQ43bSd5BD8ZfIY9rg6ZMNYNT+Tk4EEyPE0LEwL IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72ekhwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 19:04:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAIk9AU158125;
        Tue, 10 Nov 2020 19:02:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34p5gxckn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 19:02:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAJ2M5B025306;
        Tue, 10 Nov 2020 19:02:23 GMT
Received: from localhost.localdomain (/10.159.238.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 11:02:22 -0800
Subject: Re: [PATCH 4/5 v4] KVM: VMX: Fill in conforming vmx_x86_ops via macro
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org,
        sean.j.christopherson@intel.com, jmattson@google.com
References: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
 <20201110012312.20820-5-krish.sadhukhan@oracle.com>
 <0ef40499-77b8-587a-138d-9b612ae9ae8c@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e9819b87-c4e0-d15b-80b8-637ecb74f1c3@oracle.com>
Date:   Tue, 10 Nov 2020 11:02:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <0ef40499-77b8-587a-138d-9b612ae9ae8c@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=2 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/9/20 5:49 PM, Like Xu wrote:
> Hi Krish,
>
> On 2020/11/10 9:23, Krish Sadhukhan wrote:
>> @@ -1192,7 +1192,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state 
>> *host, u16 fs_sel, u16 gs_sel,
>>       }
>>   }
>>   -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu)
>
> What do you think of renaming it to
>
>     void vmx_prepare_switch_for_guest(struct kvm_vcpu *vcpu)；


In my opinion, it sounds a bit odd as we usually say, "switch to 
something". :-)

 From that perspective, {svm|vmx}_prepare_switch_to_guest is probably 
the best name to keep.


>
> ?
>
> Thanks,
> Like Xu
>
>>   {
>>       struct vcpu_vmx *vmx = to_vmx(vcpu);
>>       struct vmcs_host_state *host_state;
>>
>> @@ -311,7 +311,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, 
>> int cpu,
>>   int allocate_vpid(void);
>>   void free_vpid(int vpid);
>>   void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
>> -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu);
>>   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, 
>> u16 gs_sel,
>>               unsigned long fs_base, unsigned long gs_base);
>>   int vmx_get_cpl(struct kvm_vcpu *vcpu);
>
