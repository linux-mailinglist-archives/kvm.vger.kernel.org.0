Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B0DAF263
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfIJUuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 16:50:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfIJUuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 16:50:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AKn3Xw126017;
        Tue, 10 Sep 2019 20:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gEX/ay168l1eZw5b8fNdKPmzLU3fmo8tw73dbyQEsOM=;
 b=m6EqDnFzAhp39aK7NgV+tx0jfC6smfu2P1dl0cW51bH1FB3x4rp9gaqhQx3clWlhVx/f
 3RzKcNq5wUP4vm+MldavmLiZOfIxFE+5hMY6ziKkiNaxP/aDqW2WWVCWk8xAxnWOx7Vj
 NIXRQiY0s3Cd7AfX7Tn9MBqX4ojhg/IGj1b8avNVeq4GOFh/0FWK2x1caF4Z2KSSfs0o
 OlTZRh90Kf1A0ptmiWCKyU0EHmWCnw16th2vDvXPmaokThkwWKE+uLhacnag5XYOW8UN
 g4ljIpz5lAeEvZT8ajFbsMX3mHPj5eSt5NX+Ri6c2s1VmkaFPAsRM20Lw90AwMgYt6V8 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uw1jke19k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 20:49:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AKmNSu003742;
        Tue, 10 Sep 2019 20:49:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uxd6d2gab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 20:49:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8AKneIH019151;
        Tue, 10 Sep 2019 20:49:41 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 13:49:40 -0700
Subject: Re: [kvm-unit-test PATCH v4 7/9] vmx: Allow vmx_tests to reset the
 test_guest_func
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-8-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <f587e8a2-f022-2b48-9bd5-9ce835f3d521@oracle.com>
Date:   Tue, 10 Sep 2019 13:49:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190906210313.128316-8-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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
> The guest state tests are to be grouped together under a single
> vmx_test, vmx_guest_state_area_test(). However, each sub-test is an
> independent test that sets up its guest. test_set_guest() only allows a
> guest function to be set once in the lifetime of a vmx_test.
>
> Add a new helper, vmx_reset_guest(), which the guest state tests may use
> to set the guest function more than once. Also, this function will reset
> the VMCS as if running another independent test.

The commit header should have "nVMX" instead of "vmx".

>
> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   x86/vmx.c       | 13 +++++++++++++
>   x86/vmx.h       |  1 +
>   x86/vmx_tests.c |  2 +-
>   3 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6079420db33a..37e31c284399 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1772,6 +1772,19 @@ void test_set_guest(test_guest_func func)
>   	v2_guest_main = func;
>   }
>   
> +/*
> + * Reset the target for the enter_guest call, re-initialize VMCS. For tests
> + * that wish to run multiple sub-tests under the same vmx_test parent function
> + */
> +void test_reset_guest(test_guest_func func)
> +{
> +	assert(current->v2);
> +	init_vmcs(&(current->vmcs));
> +	v2_guest_main = func;
> +	launched = 0;
> +	guest_finished = 0;
> +}
> +
>   static void check_for_guest_termination(void)
>   {
>   	if (is_hypercall()) {
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 75abf9a489dd..217114c3bf3a 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -824,6 +824,7 @@ void enter_guest_with_invalid_guest_state(void);
>   typedef void (*test_guest_func)(void);
>   typedef void (*test_teardown_func)(void *data);
>   void test_set_guest(test_guest_func func);
> +void test_reset_guest(test_guest_func func);
>   void test_add_teardown(test_teardown_func func, void *data);
>   void test_skip(const char *msg);
>   
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24a771a..6f46c7759c85 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6858,7 +6858,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
>   	vmcs_clear_bits(ctrl_field, ctrl_bit);
>   	if (field == GUEST_PAT) {
>   		vmx_set_test_stage(1);
> -		test_set_guest(guest_state_test_main);
> +		test_reset_guest(guest_state_test_main);
>   	}
>   
>   	for (i = 0; i < 256; i = (i < PAT_VAL_LIMIT) ? i + 1 : i * 2) {

Except the commit header issue,

   Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
