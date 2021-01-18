Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500F92FA816
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436804AbhARR4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436793AbhARRz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 12:55:56 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38EC061573;
        Mon, 18 Jan 2021 09:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=VSy7n9nGa+8yIgiz5/4Q9YZDqz+WHE9uZBEMuw4LP60=; b=ElCtRKXWs00XlQ5Ju8PBSEsSCb
        3CKHkgdNQu7e41t3Gwu6khGQbo7R7XI6ZZ6nOHwmCrH5tafVsX0+G1e+2II5ILaV4zQDNl6LvNSAf
        k1xhJvevWgHmbH5bii13SgJRDA2Gv/2FfexFvnnyb1mgpy9MJDYKQZFoh0RUivM9eMxCsraYa2p9R
        Jg4Mb4zn0txphL73yMA/ZsAguhFstS8Lu17S7jB6DxUL9EfvLUYpzyudmN0fpZ6wPIZ77YM7lJlEY
        saWcR1bPA7nTD90KFEz5YAShJB9kepxCRmYpBXT91+34kLPPifqcqDTGm265vQ+0HuVZfjmuPe6u9
        W2ZEIc9A==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l1YkN-0004ON-QQ; Mon, 18 Jan 2021 17:55:24 +0000
Subject: Re: [Patch v5 2/2] cgroup: svm: Encryption IDs cgroup documentation.
To:     Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, seanjc@google.com, tj@kernel.org,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net
Cc:     joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210116023204.670834-1-vipinsh@google.com>
 <20210116023204.670834-3-vipinsh@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2a009bd9-fde5-4911-3525-e28379fe3be2@infradead.org>
Date:   Mon, 18 Jan 2021 09:55:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210116023204.670834-3-vipinsh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 6:32 PM, Vipin Sharma wrote:
> Documentation of Encryption IDs controller. This new controller is used
> to track and limit usage of hardware memory encryption capabilities on
> the CPUs.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  .../admin-guide/cgroup-v1/encryption_ids.rst  |  1 +
>  Documentation/admin-guide/cgroup-v2.rst       | 78 ++++++++++++++++++-
>  2 files changed, 77 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/encryption_ids.rst b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> new file mode 100644
> index 000000000000..8e9e9311daeb
> --- /dev/null
> +++ b/Documentation/admin-guide/cgroup-v1/encryption_ids.rst
> @@ -0,0 +1 @@
> +/Documentation/admin-guide/cgroup-v2.rst
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 63521cd36ce5..72993571de2e 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
>         5-7-1. RDMA Interface Files
>       5-8. HugeTLB
>         5.8-1. HugeTLB Interface Files
> -     5-8. Misc
> -       5-8-1. perf_event
> +     5-9. Encryption IDs
> +       5.9-1 Encryption IDs Interface Files
> +       5.9-2 Migration and Ownership
> +     5-10. Misc
> +       5-10-1. perf_event
>       5-N. Non-normative information
>         5-N-1. CPU controller root cgroup process behaviour
>         5-N-2. IO controller root cgroup process behaviour
> @@ -2160,6 +2163,77 @@ HugeTLB Interface Files
>  	are local to the cgroup i.e. not hierarchical. The file modified event
>  	generated on this file reflects only the local events.
>  
> +Encryption IDs
> +--------------
> +
> +There are multiple hardware memory encryption capabilities provided by the
> +hardware vendors, like Secure Encrypted Virtualization (SEV) and SEV Encrypted
> +State (SEV-ES) from AMD.
> +
> +These features are being used in encrypting virtual machines (VMs) and user
> +space programs. However, only a small number of keys/IDs can be used
> +simultaneously.
> +
> +This limited availability of these IDs requires system admin to optimize

                                                          admins

> +allocation, control, and track the usage of the resources in the cloud
> +infrastructure. This resource also needs to be protected from getting exhausted
> +by some malicious program and causing starvation for other programs.
> +
> +Encryption IDs controller provides capability to register the resource for

   The Encryption IDs controller provides the capability to register the resource for

> +controlling and tracking through the cgroups.

                            through cgroups.

> +
> +Encryption IDs Interface Files
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Each encryption ID type have their own interface files,

                           has its own

> +encids.[ID TYPE].{max, current, stat}, where "ID TYPE" can be sev and

                                                                     or

> +sev-es.
> +
> +  encids.[ID TYPE].stat
> +        A read-only flat-keyed single value file. This file exists only in the
> +        root cgroup.
> +
> +        It shows the total number of encryption IDs available and currently in
> +        use on the platform::
> +          # cat encids.sev.stat
> +          total 509
> +          used 0

This is described above as a single-value file...

Is the max value a hardware limit or a software (flexible) limit?


> +
> +  encids.[ID TYPE].max
> +        A read-write file which exists on the non-root cgroups. File is used to
> +        set maximum count of "[ID TYPE]" which can be used in the cgroup.
> +
> +        Limit can be set to max by::
> +          # echo max > encids.sev.max
> +
> +        Limit can be set by::
> +          # echo 100 > encids.sev.max
> +
> +        This file shows the max limit of the encryption ID in the cgroup::
> +          # cat encids.sev.max
> +          max
> +
> +        OR::
> +          # cat encids.sev.max
> +          100
> +
> +        Limits can be set more than the "total" capacity value in the
> +        encids.[ID TYPE].stat file, however, the controller ensures
> +        that the usage never exceeds the "total" and the max limit.
> +
> +  encids.[ID TYPE].current
> +        A read-only single value file which exists on non-root cgroups.
> +
> +        Shows the total number of encrypted IDs being used in the cgroup.
> +
> +Migration and Ownership
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +An encryption ID is charged to the cgroup in which it is used first, and
> +stays charged to that cgroup until that ID is freed. Migrating a process
> +to a different cgroup do not move the charge to the destination cgroup

                         does

> +where the process has moved.
> +
>  Misc
>  ----
>  
> 


-- 
~Randy
You can't do anything without having to do something else first.
-- Belefant's Law
