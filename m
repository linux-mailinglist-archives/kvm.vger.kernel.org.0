Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAD4C9D1E
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfJCLWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:22:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfJCLWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:22:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BKtlW077138;
        Thu, 3 Oct 2019 11:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Djdgiv+tAn1DIDSeZL7stKvfsy/kly/tC4eydmMJNLc=;
 b=H2CF2yCGybuG1eycM0ssSuGhfjeyhmwxaJKdZRYZQIKHx9u+WvC/djQYxflnIFLe/twm
 aXc3Qts7JLOWFMOdG51ROT2dI7RJANufU7DDTVgu3tuNRYhfIx7sj/5PZTrk4RhSArXY
 L+F/OOhp1Jv1PkBpM+AU8IpdgITA4a4Lm1Jb7rbgw52Hz+O+1qMp+1l4Lq0+jzJ0yDSc
 9G55+IMVjE3SvlmubBqZ4Ye+obX18P7uL2Sqfuor1QqBI+XIXoGBjaxW8VLJl/EdLVJ7
 BHGvqPvVVnuFdkrZkNfiHm61UtK4d38isL2qb6s3QWuizEM5c4c5XaTog98FfYoJo+2b FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfqk6tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:22:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BKKIu174569;
        Thu, 3 Oct 2019 11:22:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vcg63eap9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:22:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x93BMMZS032544;
        Thu, 3 Oct 2019 11:22:22 GMT
Received: from [10.191.0.240] (/10.191.0.240)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 04:22:22 -0700
Subject: Re: [PATCH v3 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
 and map it to "nopvspin"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-5-git-send-email-zhenzhong.duan@oracle.com>
 <20191002171952.GE9615@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <f52083d6-9964-c995-1acf-a11ed1dbf935@oracle.com>
Date:   Thu, 3 Oct 2019 19:22:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002171952.GE9615@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/3 1:19, Sean Christopherson wrote:
> On Mon, Sep 30, 2019 at 08:44:39PM +0800, Zhenzhong Duan wrote:
>> Includes asm/hypervisor.h in order to reference x86_hyper_type.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>> Cc: Stephen Hemminger <sthemmin@microsoft.com>
>> Cc: Sasha Levin <sashal@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> ---
...snip
>> @@ -64,7 +63,7 @@ __visible bool hv_vcpu_is_preempted(int vcpu)
>>   
>>   void __init hv_init_spinlocks(void)
>>   {
>> -	if (!hv_pvspin || !apic ||
>> +	if (!pvspin || !apic ||
>>   	    !(ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) ||
>>   	    !(ms_hyperv.features & HV_X64_MSR_GUEST_IDLE_AVAILABLE)) {
>>   		pr_info("PV spinlocks disabled\n");
>> @@ -82,7 +81,9 @@ void __init hv_init_spinlocks(void)
>>   
>>   static __init int hv_parse_nopvspin(char *arg)
>>   {
>> -	hv_pvspin = false;
>> +	pr_notice("\"hv_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
>> +	if (x86_hyper_type == X86_HYPER_MS_HYPERV)
>> +		pvspin = false;
> Personal preference would be to keep the hv_pvspin variable and add the
> extra check in hv_init_spinlocks().

OK, will do that way. Thanks

Zhenzhong

