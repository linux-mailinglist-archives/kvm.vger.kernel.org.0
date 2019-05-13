Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49201BF5E
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 00:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfEMWJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 18:09:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfEMWJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 18:09:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DM3bt1193849;
        Mon, 13 May 2019 22:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+bKar+AVIXt3UhsHuOh61v4Ml02y2pBXRpujk/BHMDc=;
 b=CcY2DAb/yJgK+gVnJbtxYUEwv/XuPgr6dHQgV6J0CenlO1UpnbeMtus64VP3FakhUfIJ
 AOLXl1KHEErf3zEr1sMsENg+N+dTSZlpr9xjbgo0WytoSBunv9oQFisH89VCISAexsnW
 K2WbuZuhugWvZ9FeHZBd7/aClke7VmpPrgvG6IrPP3TVeMpZ4DbhDVatKKuQUdHMngoI
 gbihSgJdkyD44pODMZCqXCEGgcJmluMUZO9uZ1cgzxvvna0isaFGGBQEVFIxvI0Ubywy
 aIuzzKrC6mN5HFYh9Ur8/xCs4tPcsaws6Ft4uxLSMhDjNTjApUZqWXeEAy37zfAM24SH pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1q9xd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 22:08:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DM7mbf145188;
        Mon, 13 May 2019 22:08:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sdnqj7bku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 22:08:51 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DM8nk8031473;
        Mon, 13 May 2019 22:08:50 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 15:08:49 -0700
Subject: Re: [PATCH 1/8][KVMnVMX]: Enable "load IA32_PERF_GLOBAL_CTRL" VM-exit
 control for nested guests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-2-krish.sadhukhan@oracle.com>
 <20190513184930.GF28561@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <29d30b7d-5cd0-65f3-283e-05b78df2bf3e@oracle.com>
Date:   Mon, 13 May 2019 15:08:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190513184930.GF28561@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130147
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/13/2019 11:49 AM, Sean Christopherson wrote:
> On Wed, Apr 24, 2019 at 07:17:17PM -0400, Krish Sadhukhan wrote:
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 3170e291215d..42a4deb662c6 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5493,7 +5493,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>>   	msrs->exit_ctls_high |=
>>   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>>   		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>> -		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
>> +		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
>> +		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> This exposes the control to L1 but doesn't implement the backing
> functionality.  The backing functionality, consistency checks and exposure
> to L1 should be a single patch.  The consistency checks could be added
> earlier, but I don't see much value in doing so given that the checks are
> (currently) a few lines.

I will combine the exposure of the control and its backing functionality 
into a single patch. But I would prefer to keep the consistency checks 
in separate patches just to make it a gradual progression i.e., first 
enabling the controls in a  patch and then checking their consistency in 
the successive patch.

>
>>   
>>   	/* We support free control of debug control saving. */
>>   	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
>> -- 
>> 2.17.2
>>

