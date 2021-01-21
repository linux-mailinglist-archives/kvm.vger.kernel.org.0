Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446FC2FF0EC
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbhAUQtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732333AbhAUP6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 10:58:34 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0B1C06121F;
        Thu, 21 Jan 2021 07:56:02 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id e17so1855233qto.3;
        Thu, 21 Jan 2021 07:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RgFdesqiZMPXxw2+lHkC+nOIxN2Hdy7A8pPSFD9aimI=;
        b=vNyp82p47jqoLdij4TrB0pGsaHQMJ9ZtfFxJ3k/gjlPax2v0NfLp+MONyCPUjLEDR/
         o8W7yrQU1d2o+rmTbByYaJrI/Gy8Et+KryvlEKvcjQIXeyZkBaufFhQW5LmnQhssI7aJ
         /17MlJnHVYhq9JZUG8p83rGj4gC0Lx3T9zF0l7vm73Az1z8Rw9kbsB7O5nehtIZ8ywCr
         l1EDbfGpQMaVGAlbZb39lFnaj3JKXxQf8zvITV7EFxPFOo1D0gbTbF1EER+qpHjLGh1n
         5knJr4nJ6JQA1pDUbogmPleaktdT4HIREjqfogvE5YqYMUwLyxi0MO8ffxMxzJt92OG7
         p0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RgFdesqiZMPXxw2+lHkC+nOIxN2Hdy7A8pPSFD9aimI=;
        b=V6pLCoAQGJOf4thevys7gebQZS0XogtpTGZBerdzTLo4Mq5ZuncvgY4gJCT9EAI1CS
         edmxSEgAdqnlHz1Jr2VKE/D4N1/tCKnVKRs277EYnSHOQHnL+UjMV/ip7yQbhYFGA1BE
         zgm9pIJgpq1a3e1vuy6FoPq/XN8YwQ3xMQ3Zvt3D1vnRAJf7ogo3hRsTxV8uCQl0KJIw
         C2vR666oq7W+GMF2lebcLd8dd/4YspVpOR2hEPUXeZlQu6t4w39tmRFdVr7NV7Py1NTC
         mkgQCbVw2HdXzLQopmXlrON3h5yYWTb7TtbvaTZzGljPyqAyeRqgeiCNcTNQVI8KSEr/
         LI4Q==
X-Gm-Message-State: AOAM532j6B6wI8+wUx70AlkhqzLXnsYa42EugJqzJaXh1uRR3rL163vD
        Soax7x9fa6QUVgeToGmygMY=
X-Google-Smtp-Source: ABdhPJz3bv4Sx6a3QAdc23npXr+czyCvAz3QTroWX0XotZEPOoMQoRfUqriMdvA8T2IxXy/3vTvn5A==
X-Received: by 2002:aed:3306:: with SMTP id u6mr234827qtd.386.1611244561576;
        Thu, 21 Jan 2021 07:56:01 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:1f82])
        by smtp.gmail.com with ESMTPSA id o56sm3856440qtb.0.2021.01.21.07.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:56:00 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 21 Jan 2021 10:55:13 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vipin Sharma <vipinsh@google.com>, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Jan 21, 2021 at 08:55:07AM -0600, Tom Lendacky wrote:
> The hardware will allow any SEV capable ASID to be run as SEV-ES, however,
> the SEV firmware will not allow the activation of an SEV-ES VM to be
> assigned to an ASID greater than or equal to the SEV minimum ASID value. The
> reason for the latter is to prevent an !SEV-ES ASID starting out as an
> SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN.
> This would result in the downgrading of the security of the VM without the
> VM realizing it.
> 
> As a result, you have a range of ASIDs that can only run SEV-ES VMs and a
> range of ASIDs that can only run SEV VMs.

I see. That makes sense. What's the downside of SEV-ES compared to SEV w/o
ES? Are there noticeable performance / feature penalties or is the split
mostly for backward compatibility?

Thanks.

-- 
tejun
