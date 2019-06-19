Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA254C439
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfFSXx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 19:53:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfFSXx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 19:53:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JNnZXI076903;
        Wed, 19 Jun 2019 23:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=juZE9Qg2p6QoV0FADmXwZn45FspqngSNBEE+z0aiHAE=;
 b=n6+72eiI8B1UIGb08xvUPZz2XxuTbdrLFsVEu7FHkUN/7gz6NlvcDkqo8gKT8Ja5iZQR
 v4vxA8R2a0LmBkgn2H2+59zQ42SMhThbEmKzT45l4XXh7Xl+d2amHUF4TSe8dwCHjdHP
 oqAHvAYFeP3QwKiUAMIGs1JccBwH93PtCIL4k6+1FEuZ4Gt6K0i5e8CZMVK2tH2oiGVj
 SHHhF4ZmIfn3l0+n9umXuclcKMZaeIhgZIVP20Y3y5Jmu8PJfgh0orwz2ai6hZbN5Pwh
 C+1Xvr8N+1SY46SvJa4EGvAQgJFs8AJkKssrWg0FJ+P2PF3vltz49/PXbrFvzCnsL90X Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t7809e4bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 23:53:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JNpdDg106385;
        Wed, 19 Jun 2019 23:53:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77ync13w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 23:53:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JNr1KK008938;
        Wed, 19 Jun 2019 23:53:01 GMT
Received: from [10.159.140.81] (/10.159.140.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 16:53:01 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v4 10/10] target/i386: kvm: Add nested
 migration blocker only when kernel lacks required capabilities
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190619162140.133674-1-liran.alon@oracle.com>
 <20190619162140.133674-11-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <5ae979fd-39e0-50e2-df53-c6f70f939dd2@oracle.com>
Date:   Wed, 19 Jun 2019 16:52:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619162140.133674-11-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190193
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/2019 9:21 AM, Liran Alon wrote:
> Previous commits have added support for migration of nested virtualization
> workloads. This was done by utilising two new KVM capabilities:
> KVM_CAP_NESTED_STATE and KVM_CAP_EXCEPTION_PAYLOAD. Both which are
> required in order to correctly migrate such workloads.
>
> Therefore, change code to add a migration blocker for vCPUs exposed with
> Intel VMX or AMD SVM in case one of these kernel capabilities is
> missing.
>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/kvm.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 99480a52ad33..a3d0fbed3b35 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1313,9 +1313,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                                     !!(c->ecx & CPUID_EXT_SMX);
>       }
>   
> -    if (cpu_has_nested_virt(env) && !nested_virt_mig_blocker) {
> +    if (cpu_has_nested_virt(env) && !nested_virt_mig_blocker &&
> +        ((kvm_max_nested_state_length() <= 0) || !has_exception_payload)) {
>           error_setg(&nested_virt_mig_blocker,
> -                   "Nested virtualization does not support live migration yet");
> +                   "Kernel do not provide required capabilities for "

s/do/does/

And with that change:

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran


> +                   "nested virtualization migration. "
> +                   "(CAP_NESTED_STATE=%d, CAP_EXCEPTION_PAYLOAD=%d)",
> +                   kvm_max_nested_state_length() > 0,
> +                   has_exception_payload);
>           r = migrate_add_blocker(nested_virt_mig_blocker, &local_err);
>           if (local_err) {
>               error_report_err(local_err);

