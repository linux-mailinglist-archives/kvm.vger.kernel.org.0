Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A8212F8F
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgGBWfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:35:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGBWfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:35:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062MSKgq159748;
        Thu, 2 Jul 2020 22:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xlbrTGZfCtli3Wu7vMNvj+DYwyAg+qHp5XBf6/obxfY=;
 b=v3MIq9XXN3wyUL7ViIeAtzupxsvPPPGhxqF7yQk681s1UXCD6U/ob+4jtPEpSW2MY265
 prRv8Voob1U1SpMZ0jOEbCrF5vFib0yWkgj+SLJnZYwxKr2F4CcNJq/Qay9dKYS67/yP
 QmFDJf40emhIo/NNC6e2j6CD+dPrFisR/ycGpFMVTqX36WdslFZAbpJ+ZgTqAY35AaKT
 B2S9bcHQd+nKQ2wSILu79vc5/jzSazvc7taP442D0NdwQ03IhzQRam+K4O8sfIBQ2a8/
 SqxWKW7frpJd7dtz93Dp/jpKIoqn1sDjrMNWB65V2Y7xiz0SRMGWSh9tLp3gTf6SVeG6 Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrnjwsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 22:35:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062MWggQ006112;
        Thu, 2 Jul 2020 22:33:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31xfvwadk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 22:33:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 062MXSD7023329;
        Thu, 2 Jul 2020 22:33:28 GMT
Received: from localhost.localdomain (/10.159.136.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 22:33:27 +0000
Subject: Re: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun
 of nested guests
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
Message-ID: <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
Date:   Thu, 2 Jul 2020 15:33:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On 5/14/20 10:36 PM, Krish Sadhukhan wrote:
> v2 -> v3:
> 	In patch# 1, the mask for guest CR4 reserved bits is now cached in
> 	'struct kvm_vcpu_arch', instead of in a global variable.
>
>
> [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in
> [PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on
> [PATCH 3/3 v3] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun
>
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/cpuid.c            |  2 ++
>   arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
>   arch/x86/kvm/svm/svm.h          |  5 ++++-
>   arch/x86/kvm/x86.c              | 27 ++++-----------------------
>   arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
>   6 files changed, 53 insertions(+), 26 deletions(-)
>
> Krish Sadhukhan (2):
>        KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
>        nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested gu
>
>   x86/svm.h       |   6 ++++
>   x86/svm_tests.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 99 insertions(+), 12 deletions(-)
>
> Krish Sadhukhan (1):
>        nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested g
>
