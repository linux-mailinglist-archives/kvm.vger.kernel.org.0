Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2DFAF265
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 22:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfIJUvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 16:51:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfIJUvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 16:51:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AKnFnd089279;
        Tue, 10 Sep 2019 20:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xjVL8fHx3nMCaJgcuikMpVFmfHLSAhyH7NWA/fc6Y+g=;
 b=AmhHcqx6J4NHdl55d3CyzdfrO6kVmtu8R2bqb361AxLMYCnO8i6X8RehS21PPAoWRNmy
 H+l8VsIukCdYhaua8OZJHLHJ8MxeuSbm2OA2Hfj6IA/noPd5i3CBTS/gkRAKKUe3mec2
 jhwa5uSEUumr1xzi9hirNcGq+MtIiqJiNH9JRUbG9B6MQX83u99C92zPV+ccKoQFxSK+
 TJY8v1DbKSYQQOGIk0kJFwozGtNvkRnZL2m9jGMO3SD8ayi/CorUpNTjQgLB/1XzjqPS
 nstLnXfSYkSYBQyHwsvjzCB7/tr5uwAQaoFksb3Jjd0kqZ3FtiybyTWWe06ggnievG5G qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uw1jy61cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 20:51:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AKmaan121688;
        Tue, 10 Sep 2019 20:51:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uxj8820q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 20:51:29 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8AKpSpl019688;
        Tue, 10 Sep 2019 20:51:28 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 13:51:27 -0700
Subject: Re: [kvm-unit-tests PATCH v4 8/9] x86: VMX: Make
 guest_state_test_main() check state from nested VM
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-9-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6e9e4f21-da9c-5da1-6507-bc0cfaf94d73@oracle.com>
Date:   Tue, 10 Sep 2019 13:51:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190906210313.128316-9-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909100198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909100199
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/06/2019 02:03 PM, Oliver Upton wrote:
> The current tests for guest state do not yet check the validity of
> loaded state from within the nested VM. Introduce the
> load_state_test_data struct to share data with the nested VM.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   x86/vmx_tests.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 6f46c7759c85..84e1a7935aa1 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
>   	test_vmx_valid_controls(false);
>   }
>   
> +static struct vmx_state_area_test_data {
> +	u32 msr;
> +	u64 exp;
> +	bool enabled;
> +} vmx_state_area_test_data;
> +
>   static void guest_state_test_main(void)
>   {
> +	u64 obs;
> +	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
> +
>   	while (1) {
> -		if (vmx_get_test_stage() != 2)
> -			vmcall();
> -		else
> +		if (vmx_get_test_stage() == 2)
>   			break;
> +
> +		if (data->enabled) {
> +			obs = rdmsr(data->msr);
> +			report("Guest state is 0x%lx (expected 0x%lx)",
> +			       data->exp == obs, obs, data->exp);
> +		}
> +
> +		vmcall();
>   	}
>   
>   	asm volatile("fnop");
> @@ -6854,7 +6869,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
>   	u64 i, val;
>   	u32 j;
>   	int error;
> +	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
>   
> +	data->enabled = false;
>   	vmcs_clear_bits(ctrl_field, ctrl_bit);
>   	if (field == GUEST_PAT) {
>   		vmx_set_test_stage(1);

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
