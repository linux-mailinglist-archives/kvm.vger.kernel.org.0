Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4126981
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 20:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfEVSEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 14:04:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39200 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfEVSEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 14:04:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MI42H6057108;
        Wed, 22 May 2019 18:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vNGE+0uZ7+d6OMvSR28E+rQ2Uw8q+Rmo8/vlHSZ5AlI=;
 b=PLx9+LuiCl0T8AKx6m0zIp+9YZSXsyR1Yaa2JmvmwurFCbb0y9W5Fd1SMIJWIA6Mvu2p
 zdT9SCsJo1hyc3OGiGLQ9JCTxMR/vKXNiAnjRgwEBSI1E1UoTk2zE5o8w54/qi4635T1
 vgOytFZm/g3ihAPuP/5O6ypN9I1Y83Yzn/Lcro9C+R9ddZvCA0WkJg77BU5n1wy51qKa
 M4DExMajQd4fhy0FTUvazLl9lXgLGzesWLe+CZaFKI0ck5dnoRHZcXcpcigmhYBD2gux
 4TB/p5gMbUfQbDbakriRdGoXBPyvDOmYiBIcmMVJL4tXPgqCjhnvSUT6tqKuwmOyECF2 Gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2smsk5dp28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 18:04:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MI45Tw191793;
        Wed, 22 May 2019 18:04:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2smsh1rue8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 18:04:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4MI4AXX001566;
        Wed, 22 May 2019 18:04:11 GMT
Received: from [10.159.159.229] (/10.159.159.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 18:04:10 +0000
Subject: Re: [PATCH kvm-unit-tests] vmx_tests: use enter_guest if guest state
 is valid
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1558521229-8770-1-git-send-email-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <06c91c5e-9a50-a038-f836-f6bab51f6a94@oracle.com>
Date:   Wed, 22 May 2019 11:04:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1558521229-8770-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/22/19 3:33 AM, Paolo Bonzini wrote:
> Change one remaining call site where the guest state is valid as far as
> PAT is concerned; we should abort on both an early vmentry failure
> as well as an invalid guest state.
>
> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/vmx_tests.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index a0b3639..b9bb169 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6735,7 +6735,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
>   				report_prefix_pop();
>   
>   			} else {	// GUEST_PAT
> -				enter_guest_with_invalid_guest_state();
> +				enter_guest();
>   				report_guest_pat_test("ENT_LOAD_PAT enabled",
>   						       VMX_VMCALL, val);
>   			}


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

