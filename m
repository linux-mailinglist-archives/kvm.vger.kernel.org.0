Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABA416295
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbhIWQCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbhIWQCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 12:02:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E93C061574;
        Thu, 23 Sep 2021 09:01:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n18so6756386pgm.12;
        Thu, 23 Sep 2021 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BuDobJ3AWzl5ylAONqdPHFWh3sYqdQh+QEZjN3iZoYo=;
        b=Jn0EWN1cnKTmalUnGyaSabNAfg09UM7LGJlb9FMlmH2wC2ofN3uhW56smzjlK3UcO0
         E8PWTuQxY/T5n3CEXhkX29IWE9iP2/ATbaWgnOIwpS0ClnYMUCSfFbi7xZ1v5SzopW2I
         ikT6vQd6aEn6ghx6Yc0fhvcMfGtgd7pvTzHPwVzMJmFMv84TiAGSKxOFQnKXcwOzztRQ
         ft1Xce3oxJdSY5hqxuTdT+xJO7P+R/SZ8vhSPpPvuN/xusYQwRani0+kYdM08WgnAMWN
         Zo5dKXPafK9ww9lVNbrmImutp49COvua7RGz+cKMJPx0111B9mn2fIijtMjX8ooF14EG
         Uo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BuDobJ3AWzl5ylAONqdPHFWh3sYqdQh+QEZjN3iZoYo=;
        b=0ianK5DzhBbQyhF6pHVhFluyHvRIXUHmtOqbtwClAHhx2S7JMtf+GrD8vIpOEHPx1J
         jCV9s4FWdzcsszQ886tCC1zWxhwlZa+YwLp3I4zKvUsy40U9oztX641oGJTS4ifcZTwR
         xemuSS6KJPRdDTDQCN4mxUCN851xcD9xxKi8N+2rCCBvmTIkoz+ySET3atFRKcMiJIwW
         h0ao6cPSjhypBSD//OKWAr8KCtbI3kOhkc1APz0ns4hkazCdKPz0Mg7HzXkn495EOiag
         aKtxfcm9SUiUT7mg77PoeJ1R/yOGGjZIGRqwhe9LIjiMnfDT4OyqLFbF12nv3swx90ON
         JZ1Q==
X-Gm-Message-State: AOAM533TdEuGaE7obGhD9Qhrq1pPpRHUqWYYT3fRlZkHQZrzwpit3aKe
        nN0Q2fyRmGU9PHSLqbxlL1g=
X-Google-Smtp-Source: ABdhPJx88DiMKMKSNwuwobDW/TnAsm12KPnswH/dniTHtPoSgXe4d27DJb2nrLfRyvrtrTs0a80nZQ==
X-Received: by 2002:a63:774e:: with SMTP id s75mr4868424pgc.73.1632412871533;
        Thu, 23 Sep 2021 09:01:11 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id x19sm6138771pfn.105.2021.09.23.09.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 09:01:10 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 23 Sep 2021 06:01:09 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Xingyou Chen <rockrush@rockwork.org>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        jacob.jun.pan@intel.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com,
        brian.welty@intel.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] cgroup: New misc cgroup controller
Message-ID: <YUykxX/oWh2kvOvQ@slm.duckdns.org>
References: <20210330044206.2864329-1-vipinsh@google.com>
 <f1955267-c009-4dea-970e-9145c7cd6dbc@rockwork.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1955267-c009-4dea-970e-9145c7cd6dbc@rockwork.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 11:38:49PM +0800, Xingyou Chen wrote:
> > Misc controller is a generic controller which can be used by these
> > kinds of resources.
> 
> Will we make this dynamic? Let resources be registered via something
> like misc_cg_res_{register,unregister}, at compile time or runtime,
> instead of hard coded into misc_res_name/misc_res_capacity etc.
> 
> There are needs as noted in drmcg session earlier this year. We may
> make misc cgroup stable, and let device drivers to register their
> own resources.

Not too likely given that the need for one-off resources for a specific
driver seems to indicate lack of proper abstraction and control mechanism
more than anything else. Even for cases where there are genuine needs for
per-hardware knobs, I think it's prudent to enforce a review cycle which
involves people who aren't directly working on the specific driver.

Thanks.

-- 
tejun
