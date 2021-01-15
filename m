Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B563A2F8710
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 22:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388485AbhAOVCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 16:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388376AbhAOVB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 16:01:56 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CBBC061796;
        Fri, 15 Jan 2021 13:01:15 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id v5so7050790qtv.7;
        Fri, 15 Jan 2021 13:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b4f3UhQcs3db0KRbKmi1fEJZcKX6X448F2Q0YUA3YCg=;
        b=mN2tL4d7EaI6xnuajdBvL5TsthjPSdFeFTAb8rFdHhUk9Uj/rgahmZB7MmEMctUuGZ
         Fg8a1b+24UXmaUpf4tBkbpJuOuI1bdlTm/fiGQ85bvihYW96JAT44+jsgpr5FBSLdyb3
         MX6S+KYcqkTqgTFXwdlADrWf/o41kcwBDUYN8qpTTmvQEJfBVpL+7ZjOgSo3czN0ktUS
         nNX9YVumcl5V2w3Wap4mtr0AsIR29/fDDHSRC+nMR/zMiewki7afBE9xg+pfDF6Cuvjy
         JGdYuBQekOeccVgdqtf1/QoItAgqShbR+EnnkPRzmEeYnr1+32kqMnrOxkLAAb95Qabi
         3G6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b4f3UhQcs3db0KRbKmi1fEJZcKX6X448F2Q0YUA3YCg=;
        b=EQUXTTNe4aeSqDbYXf6Y4gZwXtqnXKrUAYQtSVQvDVp0TDw6AhW25goiVucA51zmtx
         nRdnETxfdoB6x+swOgINV7vD95CMd7z6leXluiUGZqFsHRUuvBStNdaJ6adQqw2srGVa
         BSmvEXHuSXVCoas1mlgYxmFHSN8R3DcJW3QkHEi6u72/eSPZzdEa4e3uYA3UqZPhNnPZ
         2W+E4C9iygEkWLhuP/jzD6/g2M9uYT4fKDyGuESsHNC56bLtp6ouCvpQlaDV0/mezj7V
         zak8r3elcMXC3nRjX+dhLf85UeFQREG7+1Y9NxEEXZ825R3ZUVD8HBVXHBmW7ca6juG6
         u5tw==
X-Gm-Message-State: AOAM533WVsywL7iVjfV5njj5LAWIae92Mc4BHeGYMLFv1QNqQjcTy0Vx
        VV7U93lDVLHQk6/ntKP4XmY=
X-Google-Smtp-Source: ABdhPJxCyeLO5Rttyu1nlPqULd/wARnfFYEFkxXElMkQCD2Ka1eVA33f6/5Bfv81NzMIBuMhSkGHlA==
X-Received: by 2002:aed:2f67:: with SMTP id l94mr14087477qtd.201.1610744474123;
        Fri, 15 Jan 2021 13:01:14 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:97cc])
        by smtp.gmail.com with ESMTPSA id s8sm5436604qtq.32.2021.01.15.13.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 13:01:13 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 15 Jan 2021 16:00:26 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 2/2] cgroup: svm: Encryption IDs cgroup documentation.
Message-ID: <YAICaoSyk2O2nU+P@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108012846.4134815-3-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 05:28:46PM -0800, Vipin Sharma wrote:
> Documentation for both cgroup versions, v1 and v2, of Encryption IDs
> controller. This new controller is used to track and limit usage of
> hardware memory encryption capabilities on the CPUs.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 ++++++++++++++++++
>  Documentation/admin-guide/cgroup-v2.rst       |  78 ++++++++++++-

Given how trivial it is, I'm not gonna object to adding new v1 interface but
maybe just point to v2 doc from v1?

Thanks.

-- 
tejun
