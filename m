Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6F7A979F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 02:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfIEA0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 20:26:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfIEA0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 20:26:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x850Nxh7097571;
        Thu, 5 Sep 2019 00:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XoOxQgv9dHeTA6suQ7C74cyVUbDjVwa3hBIpu49UkPY=;
 b=CoLTWhqt+C7QITjEz9xdRwYDftGolnq7MfkxtdbNmoLHOKe66m/UM7cgzWQlh1M2eywG
 4IIts+TZrzl1+BmivVEa6I8KcGU9SGe0VLb7hz8nwbCJSH3SxbmCVVuTScPo66kBYjbX
 s/9qvSZRK64EdzgspKSeqG5eABpwYJCURA23mc7WsbgTG1oU/VHZH0CXYVDVbkJsCnW5
 IiDWvDUQsMzaNVAaPDAlEWStVI8ZRAkCJ/X2YQu36kEfDBxwx2JbNkklWQ+4k/wgrbDP
 +HC0bgqs8LT8SVq8Nd+Xk4BKVokd0rqKB5Ta6DyYho2kk1E/Oedci3ehqgfNAqpTfXEH IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2utqfgg24t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 00:25:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x850NwvU133399;
        Thu, 5 Sep 2019 00:25:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ut1hpay3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 00:25:48 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x850PlKW020131;
        Thu, 5 Sep 2019 00:25:48 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 17:25:47 -0700
Subject: Re: [kvm-unit-tests PATCH v3 7/8] x86: VMX: Make
 guest_state_test_main() check state from nested VM
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190903215801.183193-1-oupton@google.com>
 <20190903215801.183193-8-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1fb19467-a743-1886-de52-a63bd19b0b00@oracle.com>
Date:   Wed, 4 Sep 2019 17:25:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190903215801.183193-8-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/03/2019 02:58 PM, Oliver Upton wrote:
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
> index f035f24a771a..b72a27583793 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
>   	test_vmx_valid_controls(false);
>   }
>   
> +static struct load_state_test_data {
> +	u32 msr;
> +	u64 exp;
> +	bool enabled;
> +} load_state_test_data;

A better name is probably 'loaded_state_test_data'  as you are checking 
the validity of the loaded MSR in the guest.

> +
>   static void guest_state_test_main(void)
>   {
> +	u64 obs;
> +	struct load_state_test_data *data = &load_state_test_data;
> +
>   	while (1) {
> -		if (vmx_get_test_stage() != 2)
> -			vmcall();
> -		else
> +		if (vmx_get_test_stage() == 2)
>   			break;
> +
> +		if (data->enabled) {
> +			obs = rdmsr(obs);

Although you fixed it in the next patch, why not use  'data->msr' in 
place of 'obs' as the parameter to rdmsr() in this patch only ?

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
> +	struct load_state_test_data *data = &load_state_test_data;
>   
> +	data->enabled = false;
>   	vmcs_clear_bits(ctrl_field, ctrl_bit);
>   	if (field == GUEST_PAT) {
>   		vmx_set_test_stage(1);

