Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B447221451
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 20:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGOSey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 14:34:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgGOSey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 14:34:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIXUfb138835;
        Wed, 15 Jul 2020 18:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6I12/FdoxOF4xdt6/G3zFI4SqIdDm8HDV/2dXSrs7ps=;
 b=OYbm8LrdLFebrx8Uq0QXvPdz6Ub/18yYBiFiwBX9Iv/64vSdjtGN+4Z1apKK9lDHHdrL
 dSDT2JTBodyDbAzm5Og3ZCCssbLE5DHfrUNUhN3qGD/o7+M6ExXlYonMHzNefS8kwCpY
 xV2yGvRcnYbZvfb2eNwkTsIU2uVoiKtkYj5KQhR7QEU3Y23hPU3YijHZuUhujdZt9IJG
 bbjJKl4YL/6SomG31+nfjSxJSrpX7IWbjrfvXBdn2SpuovScWfGALGgJ1fumDnAD4fiq
 WWNC1/+p6b+beuFx7z9Qm8Q8j4ZMwS8E3P6yERV7OdPSOyJubD11einTTIIf5o6yDNWP +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cmd36a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 18:34:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIXeuh085868;
        Wed, 15 Jul 2020 18:34:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0rrr41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 18:34:48 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FIYl37027485;
        Wed, 15 Jul 2020 18:34:47 GMT
Received: from localhost.localdomain (/10.159.239.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 11:34:47 -0700
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Restore active host RIP/CR4
 after test_host_addr_size()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Karl Heubaum <karl.heubaum@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
 <20200714002355.538-2-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <378edd35-38eb-1d62-8471-f111c17afee7@oracle.com>
Date:   Wed, 15 Jul 2020 11:34:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200714002355.538-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/13/20 5:23 PM, Sean Christopherson wrote:
> Perform one last VMX transition to actually load the host's RIP and CR4
> at the end of test_host_addr_size().  Simply writing the VMCS doesn't
> restore the values in hardware, e.g. as is, CR4.PCIDE can be left set,
> which causes spectacularly confusing explosions when other misguided
> tests assume setting bit 63 in CR3 will cause a non-canonical #GP.
>
> Fixes: 0786c0316ac05 ("kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested guests")
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Cc: Karl Heubaum <karl.heubaum@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   x86/vmx_tests.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 29f3d0e..cb42a2d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7673,6 +7673,11 @@ static void test_host_addr_size(void)
>   		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
>   		vmcs_write(HOST_RIP, rip_saved);
>   		vmcs_write(HOST_CR4, cr4_saved);
> +
> +		/* Restore host's active RIP and CR4 values. */
> +		report_prefix_pushf("restore host state");
> +		test_vmx_vmlaunch(0);
> +		report_prefix_pop();
>   	}
>   }
>   
Just for my understanding.  When you say, "other misguided tests", which 
tests are you referring to ?  In the current sequence of tests in 
vmx_host_state_area_test(), test_load_host_perf_global_ctrl() is the  
one that follows and it runs fine.
