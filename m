Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A52F87CD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 22:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbhAOVmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 16:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAOVmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 16:42:45 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B038C061794
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 13:42:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v19so6822119pgj.12
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 13:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bgjnqtpec69vUmjqa2UifvxbYQW35/sgPsKU/7Bo9aI=;
        b=OggvUw0Hm9klzCb2gWzL1xpvM4h0B34ZYVQsxN3wC/zdRTLky1sIVS+aP+RMem0Lx+
         dhCHyUumtATf+63/HrQ39p6Plwn+OkdZ92Gyx3QGmotDVqQ0vYf+OMXeU1OQmZYDLp23
         G67G8V+nMMaSDcNKFXoJsHO5cGVnEx6jZqJiA8UQp+Rg3CH83hN9RC4c94IlDyEIP/st
         zg0JlRpy3X+IW2jLP5T+VNP8gpjIkw7faoZac0GCm/4Jn2YSbPTsHrfhyi9oLgSFjKtZ
         f/L89Eha2I7pIfgNg69nuV+z1VE8VInqryQK7DnoxnSVe+pgyAvVhEv/BLD+I5uOc5dA
         14Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bgjnqtpec69vUmjqa2UifvxbYQW35/sgPsKU/7Bo9aI=;
        b=la3PKTGnnjVHHSYaiNLpBLUq3TOjP49V0hGxiy6T6QM57cpzCNI94o+WBeu1nrFK65
         mfdqE9/6iLw67r8IbNVoo0jyXpn+ztt3I08yz+JijbnHcWQSZBshowWzcUsc0C8/WHOU
         +2+q5799Jveqroz30HxJGdSvxwqyd7R0CEag3T+4HUlV/tWNt79h7wuEaFvsqXm6H1z5
         wzY8JGVTvISnSbtFOZlLXZEbYTzpT/k6j/xw7duGz/so8hov2JHw1AwiYu3kXTUPRWkS
         lxeKbcXLnweaAxgfnr0A925Jof+IYWZa/NeBwth7AF88KFUk/18g9MzMH2ixKauDwp3C
         6tCA==
X-Gm-Message-State: AOAM530sISJufPl5hKZTEtQDdEXfCyD5+Eq8eJMAUSvBsX9gGmlGOyNk
        iay5IteyQp343+FqBzv3BPHqDg==
X-Google-Smtp-Source: ABdhPJxDU0ySQcc7fvev8M9M1d13VC+GIj7HBHfRSvtrxjqTvfzYTvW0G31AsN1nGGS2Xfbxazi8WQ==
X-Received: by 2002:a63:d305:: with SMTP id b5mr14631064pgg.452.1610746924450;
        Fri, 15 Jan 2021 13:42:04 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id a5sm8911135pgl.41.2021.01.15.13.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 13:42:03 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:41:59 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Tejun Heo <tj@kernel.org>
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
Message-ID: <YAIMJ9E8NneoAp8H@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-3-vipinsh@google.com>
 <YAICaoSyk2O2nU+P@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAICaoSyk2O2nU+P@mtj.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 04:00:26PM -0500, Tejun Heo wrote:
> On Thu, Jan 07, 2021 at 05:28:46PM -0800, Vipin Sharma wrote:
> > Documentation for both cgroup versions, v1 and v2, of Encryption IDs
> > controller. This new controller is used to track and limit usage of
> > hardware memory encryption capabilities on the CPUs.
> > 
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Reviewed-by: David Rientjes <rientjes@google.com>
> > Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 ++++++++++++++++++
> >  Documentation/admin-guide/cgroup-v2.rst       |  78 ++++++++++++-
> 
> Given how trivial it is, I'm not gonna object to adding new v1 interface but
> maybe just point to v2 doc from v1?
> 

Sure, I will just add the path to v2 doc in v1.

> Thanks.
> 
> -- 
> tejun
