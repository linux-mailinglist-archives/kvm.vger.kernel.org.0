Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC35DB5603
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 21:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfIQTO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 15:14:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIQTO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 15:14:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HJEFt4183679;
        Tue, 17 Sep 2019 19:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QMx50CQcBGdEDrZ4txMSMGEDsuF+A3iWP5uwy7rYvNw=;
 b=e1K4rHyPQNg/i38t3qhg1dJAtk9CvCOoVIIux2YawmsyG7HUUkKImyH8DlejGOy1BW21
 h2TNvIMFp6GW/EXLUtiFICcVNPsXALcqGGZSjEJ1m6Y+G0H8sm0zkGQJjxSKzcRWgNkY
 5qs2uaRX+28IItHoFyvKWlCJd4HBAICv80BgvLeotZia0l+6GGK7uXCcnhrjP31QQgEM
 l39sqoco4FlF3CSLnkvCJANxvLVE9ayLAub7P8PEAe1zhcqgnRy0Ji+r8pa6ZWHMdAq9
 KPPAJHgzX9XV7iCRHdd08FITTZezQp0/JMR2m481J4KRiwQxM4MBAsPfVO8O+dFWpT6b Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v2bx30stn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 19:14:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HJCbDF152086;
        Tue, 17 Sep 2019 19:14:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v2jjtqc56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 19:14:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8HJErqn021224;
        Tue, 17 Sep 2019 19:14:53 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 12:14:53 -0700
Subject: Re: [kvm-unit-tests PATCH v3 1/2] x86: nvmx: fix bug in
 __enter_guest()
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
References: <20190917185753.256039-1-marcorr@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1393a5ea-3103-7f5c-7ea7-c6d9244efdff@oracle.com>
Date:   Tue, 17 Sep 2019 12:14:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190917185753.256039-1-marcorr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/17/2019 11:57 AM, Marc Orr wrote:
> __enter_guest() should only set the launched flag when a launch has
> succeeded. Thus, don't set the launched flag when the VMX_ENTRY_FAILURE,
> bit 31, is set in the VMCS exit reason.
>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>   x86/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6079420db33a..7313c78f15c2 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1820,7 +1820,7 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>   		abort();
>   	}
>   
> -	if (!failure->early) {
> +	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
>   		launched = 1;
>   		check_for_guest_termination();
>   	}
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
