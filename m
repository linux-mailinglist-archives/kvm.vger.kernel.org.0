Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12EB20A8F8
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgFYXaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 19:30:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgFYXaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 19:30:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS36k151842;
        Thu, 25 Jun 2020 23:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CbeDyVYB5S3oRr4NWtBuj8dX4L5T2zsa98Esoc/k5Z4=;
 b=yBm5DkIhgvhKovZ94p1DlYmsJTp6Ydj5zaYkQWZ2pdFD1Q0xbGHtdGtXSfOylQh3mgQZ
 zcWrfv9sfHrEhuLu56ePLqmW5hx3okyDaI8BrwuM8Y6UxQSI6pYD/5YLUamdgwf9h65e
 RZRpiedUPzIuWkX/c1rUIrex6emM0ZHAIbNkJK2GGHi5QsenasWwu1FtMAPrATn5TEzL
 JDkhAg38jDozDVh2vjag5r0Uc/otWmOY3Ur8sjSe8XgV6HyDj4vsWUh6viWdTN+V9o7k
 GqhqvPQRyun2Woi4hwjQXaIRU7mgZt9H0NH95WvszmN5wY9vAskheffDGkxaF3rdmUoc yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu3aa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 23:29:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSHWm110879;
        Thu, 25 Jun 2020 23:29:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur9r3pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 23:29:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT5AL007704;
        Thu, 25 Jun 2020 23:29:05 GMT
Received: from localhost.localdomain (/10.159.236.36)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:05 +0000
Subject: Re: [PATCH 0/4] KVM: SVM: Code move follow-up
To:     Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20200625080325.28439-1-joro@8bytes.org>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a34c61ad-f28f-4560-2918-a826c03cee6b@oracle.com>
Date:   Thu, 25 Jun 2020 16:29:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/20 1:03 AM, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
>
> Hi,
>
> here is small series to follow-up on the review comments for moving
> the kvm-amd module code to its own sub-directory. The comments were
> only about renaming structs and symbols, so there are no functional
> changes in these patches.
>
> The comments addressed here are all from [1].
>
> Regards,
>
> 	Joerg
>
> [1] https://lore.kernel.org/lkml/87d0917ezq.fsf@vitty.brq.redhat.com/
>
> Joerg Roedel (4):
>    KVM: SVM: Rename struct nested_state to svm_nested_state
>    KVM: SVM: Add vmcb_ prefix to mark_*() functions
>    KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
>    KVM: SVM: Rename svm_nested_virtualize_tpr() to
>      nested_svm_virtualize_tpr()
>
>   arch/x86/kvm/svm/avic.c   |   2 +-
>   arch/x86/kvm/svm/nested.c |   8 +--
>   arch/x86/kvm/svm/sev.c    |   2 +-
>   arch/x86/kvm/svm/svm.c    | 138 +++++++++++++++++++-------------------
>   arch/x86/kvm/svm/svm.h    |  20 +++---
>   5 files changed, 85 insertions(+), 85 deletions(-)
>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
