Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BC434F56
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDRw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:52:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDRw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:52:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54HiKPo062556;
        Tue, 4 Jun 2019 17:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=IDdrf3mxQkHUxoFJBGVqp07pFy+F66WWcRn/7XzQbR4=;
 b=cqLEhsg9tdm2bK44K7Hk8btXxS8Ytk0W5WFAHi6m2XNGt5jyUY3LI4UC0jN+dvfvVUyX
 Eyrv1UZ52TcqBSj1Qsy34iusQgKvaimc86wOTe0aqznw4Jx0KVbyiTnBHVOy1xGY196z
 jjbxR5KLqLSvwWPSHRP5MCHXq62sJn6+DDrL2QtY8bJR3sRjM3/O53RPssQsFve179Fx
 z+L55Jp/NsfWnFqsC5aw5NJ6DvHqLaueBleTkPljJHtJJ5xBiz4MzGoZ+VLYFvy1zLqq
 KP0lcbehhygNM75Y4LSDEGgTtR4ct5lpYetOR496pU6q0k5H2Bjua8uM+iY+WTb411lo PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0qegqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:52:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Hqh3U178944;
        Tue, 4 Jun 2019 17:52:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2swngkg2sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:52:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54HqnW8001159;
        Tue, 4 Jun 2019 17:52:49 GMT
Received: from [10.159.240.249] (/10.159.240.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 10:52:49 -0700
Subject: Re: [PATCH 1/2] kvm: nVMX: Enforce must-be-zero bits in the
 IA32_VMX_VMCS_ENUM MSR
To:     Aaron Lewis <aaronlewis@google.com>, jmattson@google.com,
        pshier@google.com, marcorr@google.com, kvm@vger.kernel.org
References: <20190531184159.260151-1-aaronlewis@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4b50c550-308e-2b88-053e-c6933f9ed320@oracle.com>
Date:   Tue, 4 Jun 2019 10:52:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190531184159.260151-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/31/19 11:41 AM, Aaron Lewis wrote:
> According to the SDM, bit 0 and bits 63:10 of the IA32_VMX_VMCS_ENUM
> MSR are reserved and are read as 0.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6401eb7ef19c..3438279e76bb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1219,6 +1219,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
>   	case MSR_IA32_VMX_EPT_VPID_CAP:
>   		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
>   	case MSR_IA32_VMX_VMCS_ENUM:
> +		if (data & (GENMASK_ULL(63, 10) | BIT_ULL(0)))
> +			return -EINVAL;
>   		vmx->nested.msrs.vmcs_enum = data;
>   		return 0;
>   	default:


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

