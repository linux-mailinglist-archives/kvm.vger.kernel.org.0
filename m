Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314EF4ADC2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbfFRWRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:17:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:17:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMEJUo084014;
        Tue, 18 Jun 2019 22:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ErVOMnHLEU3iYCpPY/9GqzKz/EQai2BPkiy8hqBf6U8=;
 b=5cRtJ50Zhns5cW4pmfht9ESqVvbgEZ++sHDMudmcHfV6NkRSpEm6BdzcWUhFXa6Oj5Q0
 cOse2QQRlrRYdo7SpsibVhQjOQJ15pJqMuDw3UB8WU5Ts1gmCrlYfZGYSqVYa4DnfdJG
 1Jz4Y59M+BU0847EWQl7tVY9+85E16U2gE1wZFqBnd7llsNF2H1Oh1Br6mNBuBeaBgyv
 T7Ie1QKPywdNI9cY83uy1BOFddmcgJ7YLJhvUOvpD6ShoLD+aoSkJqFcenC46gU+HdYO
 FmnYRKLIclaV2NftiJt5N304OEVs8LBuV3Rk2pDD8iUBIaoWR3SkoR46RqVkFWjmgP7K zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t780983sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:17:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMFAb1069654;
        Tue, 18 Jun 2019 22:17:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ymremn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:17:02 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IMH1kJ032165;
        Tue, 18 Jun 2019 22:17:01 GMT
Received: from [10.141.197.71] (/10.141.197.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:17:01 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v3 9/9] KVM: i386: Remove VMX migration
 blocker
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-10-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <907faf19-aaff-1d1a-422e-739ee5aa7d12@oracle.com>
Date:   Tue, 18 Jun 2019 15:17:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617175658.135869-10-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/2019 10:56 AM, Liran Alon wrote:
> This effectively reverts d98f26073beb ("target/i386: kvm: add VMX migration blocker").
> This can now be done because previous commits added support for Intel VMX migration.
>
> AMD SVM migration is still blocked. This is because kernel
> KVM_CAP_{GET,SET}_NESTED_STATE in case of AMD SVM is not
> implemented yet. Therefore, required vCPU nested state is still
> missing in order to perform valid migration for vCPU exposed with SVM.
>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/kvm.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 797f8ac46435..772c8619efc4 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -948,7 +948,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>   }
>   
>   static Error *invtsc_mig_blocker;
> -static Error *nested_virt_mig_blocker;
> +static Error *svm_mig_blocker;
>   
>   #define KVM_MAX_CPUID_ENTRIES  100
>   
> @@ -1313,13 +1313,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                                     !!(c->ecx & CPUID_EXT_SMX);
>       }
>   
> -    if (cpu_has_nested_virt(env) && !nested_virt_mig_blocker) {
> -        error_setg(&nested_virt_mig_blocker,
> -                   "Nested virtualization does not support live migration yet");
> -        r = migrate_add_blocker(nested_virt_mig_blocker, &local_err);
> +    if (cpu_has_svm(env) && !svm_mig_blocker) {
> +        error_setg(&svm_mig_blocker,
> +                   "AMD SVM does not support live migration yet");
> +        r = migrate_add_blocker(svm_mig_blocker, &local_err);
>           if (local_err) {
>               error_report_err(local_err);
> -            error_free(nested_virt_mig_blocker);
> +            error_free(svm_mig_blocker);
>               return r;
>           }
>       }

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran
