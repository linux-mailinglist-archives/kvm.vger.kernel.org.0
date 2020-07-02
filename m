Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3D212F90
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgGBWf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:35:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGBWf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:35:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062MSGAl159707;
        Thu, 2 Jul 2020 22:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pI/I0GQlo/5hwo35H7R36a5/4TxdHYFWAt9rB96vzsc=;
 b=M9ph//CFG5evsdUH46ARcuiavfY3mQg8+/6kgRsSZo9ztZ4w+0wtlJgY1k7a2omF/1xa
 cKb8MIp1Glj2deGYxP/hjstqtmABsM7ycZyRWrhQCVsz8hrcoKC2FvqZCSWcuuKP1UOD
 MrRDp8/rC9Is6aPrBFKlHugv4YK+icpQKjHyxsf0yv0UuAp9xxdVSNL2xAejSz1Hb/SF
 y8dP46Oz2u7Zh2DazfAPNxYa0GBjqQ/YKjXeCelLjkUidm+ywbzP4kOwoenIw3Ac8vEs
 wCWRxP+Y9cP9dXVJhWiAaoZgmM2Gt7jpDd1/WQQm9WPejPxa+rAtf0AL/6BjQnLr0Bn+ Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrnjwtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 22:35:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062MWg53006061;
        Thu, 2 Jul 2020 22:33:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvwadvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 22:33:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 062MXt15007271;
        Thu, 2 Jul 2020 22:33:55 GMT
Received: from localhost.localdomain (/10.159.136.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 22:33:55 +0000
Subject: Re: [PATCH 0/4] KVM: nSVM: Check reserved bits in DR6, DR7 and EFER
 on vmrun of nested guests
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
Message-ID: <2fa88813-684c-f7ac-495b-68fe6cdbd5b2@oracle.com>
Date:   Thu, 2 Jul 2020 15:33:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=973 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=990
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

On 5/22/20 3:19 PM, Krish Sadhukhan wrote:
> Patch# 1: Moves the check for upper 32 reserved bits of DR6 to a new function.
> Patch# 2: Adds the KVM checks for DR6[63:32] and DR7[64:32] reserved bits
> Patch# 3: Adds kvm-unit-tests for DR6[63:32] and DR7[64:32] reserved bits and
> 	  reserved bits in EFER
> Patch# 4: Removes the duplicate definition of 'vmcb' that sneaked via one of
> 	  my previous patches.
>
>
> [PATCH 1/4] KVM: x86: Move the check for upper 32 reserved bits of
> [PATCH 2/4] KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not
> [PATCH 3/4] kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32]
> [PATCH 4/4] kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
>
>   arch/x86/kvm/svm/nested.c | 3 +++
>   arch/x86/kvm/x86.c        | 2 +-
>   arch/x86/kvm/x86.h        | 5 +++++
>   3 files changed, 9 insertions(+), 1 deletion(-)
>
> Krish Sadhukhan (2):
>        KVM: x86: Move the check for upper 32 reserved bits of DR6 to separate fun
>        KVM: nVMX: Check that DR6[63:32] and DR7[64:32] are not set on vmrun of ne
>   x86/svm.c       |  1 -
>   x86/svm.h       |  3 +++
>   x86/svm_tests.c | 59 ++++++++++++++++++++++++++++++++++++++-------------------
>   3 files changed, 42 insertions(+), 21 deletions(-)
>
> Krish Sadhukhan (2):
>        kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32] and EFER reserved b
>        kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
>
