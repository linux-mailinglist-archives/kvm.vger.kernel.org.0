Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACF54C26C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 22:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfFSUbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 16:31:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFSUbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 16:31:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JKTNx5035178;
        Wed, 19 Jun 2019 20:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=bssTrlS3vr8JSQjQlxvvfsp1R2goSd+Cm00n04UTBwo=;
 b=RRyGEAOcQQgrLrkX+Fk2M8SRzb0QFf3Pbhw7MEYLfMs+/U9MRTwovYKUUYqlfLZ8IxoZ
 XPOH6MQS609JblhWM/yyD/6HU27h/VxD5hrLb8zAAY+36fkTIovPpNt5UpZJU4j49Int
 SzHq0wSTJei+FlKodK+kpTqNP4Y9Iq2Q7R0UE0PpGot3ce2JV69t1VUX8V3laqu6nuZU
 ceNjZXtQBaZxJFk+5wop/IZQKZN/Ez3Vf3AgwT25CLfP8OOK4jxfhJ8t7+2btI2y0ZBV
 4ni9ML2i09UkbNz3wtNzCk06/Zn3ZqmJD+UdPMrBC7oj3p0k8dTdtg7hCGfa6LDoKqxB 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t7809dgs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 20:30:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JKTE0d053490;
        Wed, 19 Jun 2019 20:30:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t7rdwuf7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 20:30:17 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5JKUG9Z008409;
        Wed, 19 Jun 2019 20:30:16 GMT
Received: from [10.141.197.71] (/10.141.197.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 13:30:16 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v4 01/10] target/i386: kvm: Delete VMX
 migration blocker on vCPU init failure
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190619162140.133674-1-liran.alon@oracle.com>
 <20190619162140.133674-2-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <d7cf4dd5-13ca-9ba1-2424-25d0d2de8c58@oracle.com>
Date:   Wed, 19 Jun 2019 13:30:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619162140.133674-2-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/2019 9:21 AM, Liran Alon wrote:
> Commit d98f26073beb ("target/i386: kvm: add VMX migration blocker")
> added migration blocker for vCPU exposed with Intel VMX because QEMU
> doesn't yet contain code to support migration of nested virtualization
> workloads.
>
> However, that commit missed adding deletion of the migration blocker in
> case init of vCPU failed. Similar to invtsc_mig_blocker. This commit fix
> that issue.
>
> Fixes: d98f26073beb ("target/i386: kvm: add VMX migration blocker")
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/kvm.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3b29ce5c0d08..7aa7914a498c 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -940,7 +940,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>       r = kvm_arch_set_tsc_khz(cs);
>       if (r < 0) {
> -        goto fail;
> +        return r;
>       }
>   
>       /* vcpu's TSC frequency is either specified by user, or following
> @@ -1295,7 +1295,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>               if (local_err) {
>                   error_report_err(local_err);
>                   error_free(invtsc_mig_blocker);
> -                return r;
> +                goto fail2;
>               }
>           }
>       }
> @@ -1346,6 +1346,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>    fail:
>       migrate_del_blocker(invtsc_mig_blocker);
> + fail2:
> +    migrate_del_blocker(vmx_mig_blocker);
> +

At the risk of being a bit pedantic...

Your changes don't introduce this problem, but they do make it worse -- 
Since [vmx|invtsc]_mig_blocker are both global in scope, isn't it 
possible you end up deleting one or both valid blockers that were 
created by a previous invocation of kvm_arch_init_vcpu() ?  Seems to me 
that you would need something like an additional pair of local boolean 
variables named created_[vmx|invtsc]_mig_blocker and condition the calls 
to migrate_del_blocker() accordingly. On the positive side, that would 
simplify some of the logic around when and if it's ok to jump to "fail" 
(and you wouldn't need the "fail2").

Thanks,
-Maran

>       return r;
>   }
>   
