Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7133CA30
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhCOXyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhCOXyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:54:39 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E526C06174A;
        Mon, 15 Mar 2021 16:54:39 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id l4so33579197qkl.0;
        Mon, 15 Mar 2021 16:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=US0hVPQ8vE/ff4q4EMV/WahbUbFBxAIlNGyDC8TZKKo=;
        b=anlpAKgv1icjbUA4PcLTmi9IUjIbI/zzazbcKLMIKSnLma+f+zvtMa/z+TNJ1Fb4/U
         w4LKNq8Sxa+Jd4ADL3B6JaCsM2rY4qXj3HeZD4506hVAgMner9pcoO2Vd9OZCjXqeQ2Q
         C/KJ3q0LAJ2t2P4R0lPsrUK1AC8Cgrxvl02ibVFSP88VrAhtb7nDKS5uiJI/tNu+Uv/M
         HvEa87XZIybFq27EArSte01J4H7GrL53gn48U5jGfSOP/O0z/vgpwwPp2ftthhXWAsVY
         //QJ71p/BWJs/LrqaW7yb0VkIlGKZxprXpB0uMM1gym5oJ/Pjk4XP/jxxyLzDqwn2AFp
         k4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=US0hVPQ8vE/ff4q4EMV/WahbUbFBxAIlNGyDC8TZKKo=;
        b=KEGWOT8MVzbPBjCMDkpk8xVkk+J5TARSWq11CGzFI1rA5KWn13A/ZNNKke1pCLGutH
         bKD1UoKogYl3cA4WbBiooJQ5MntH74omUIhKKJgIxvrEGFoNmLoJ6tprs9s4egS1Y6XV
         7kqTJCTL4b3CJZb9Aq/BXbfYUWaB138R9CrVhVYX+7XGgh0gmfhYy2viTffPuaSjRo6a
         s2gCy7sYUo7W0m+zayo6ipxwH8j40yQ9i4EKX9aQc8l6M7QyUMRjK7qvUS3ygXVTDaYM
         Z9fumSBBnH4X58ek0b1ezXg69/CdoNgx5NDWybWF0R8EhFD9ZZoLOrEdFORPaeESq+bC
         IKpw==
X-Gm-Message-State: AOAM530U6jQg+tIETAhYN2/IuUmqty0q9sCXmJWICpIhHsCveo6u2+yw
        dyXICQSwH8jsZqva9QyHlDk=
X-Google-Smtp-Source: ABdhPJwa2U9JAW0IdxHOI/3q/+uL14oiW0exgSHcfpOxWOPVytqe+AmVKLw8B8hEQOQOpxUo2j2moA==
X-Received: by 2002:a37:9b82:: with SMTP id d124mr27326575qke.489.1615852478161;
        Mon, 15 Mar 2021 16:54:38 -0700 (PDT)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id g186sm14138805qke.0.2021.03.15.16.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 16:54:37 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 15 Mar 2021 19:54:36 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Jacob Pan <jacob.jun.pan@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <YE/zvLkL1vM8/Cdm@slm.duckdns.org>
References: <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
 <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
 <20210315151155.383a7e6e@jacob-builder>
 <YE/ddx5+ToNsgUF0@slm.duckdns.org>
 <20210315164012.4adeabe8@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315164012.4adeabe8@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Mon, Mar 15, 2021 at 04:40:12PM -0700, Jacob Pan wrote:
> 2. then we want to move/migrate Process1 to cg_B. so we need uncharge 10 of
> cg_A, charge 10 of cg_B

So, what I don't get is why this migration is necessary. This isn't
supported as a usage pattern and no one, at least in terms of wide-spread
usage, does this. Why is this a requirement for your use case?

Thanks.

-- 
tejun
