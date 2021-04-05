Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1061C353A3E
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 02:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhDEAaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhDEAaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Apr 2021 20:30:23 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80093C061756
        for <kvm@vger.kernel.org>; Sun,  4 Apr 2021 17:30:17 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u9so11094604ljd.11
        for <kvm@vger.kernel.org>; Sun, 04 Apr 2021 17:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4djxblumYsM0MYjaTI3gAeclQoo4tMzFZGJUydviNoY=;
        b=k9XPOH16pkp6wIhN6fUXTfgtf00C1nX1vfWzkAoJCwZhTPryGhPETEbWtKNuql8dcT
         J66HvvN+nGIGX/hWkB2rtYjC7ogWFD4Rd4IZkQ0bS/rYf5HmIGTyE/ZylI39cDqXlZLQ
         DrwfgJgtrdAYa4RnReHlFBjkf09I61p5QCpFtdcJBiTqN5do0FBlf/GNBAM4Sa4K9fTt
         O0Sc6EJP96oqfCYeJaor+ktU4xDDekqEt6oEKns8rGYAeQWl4AQoPK1E7sIISi8w1r2q
         CU1BS4YW9udqw0T/oEayc0e8nZsTv0pujP4QcRjuay7oCDxyx5293bIck4CW+rAYTTaJ
         a32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4djxblumYsM0MYjaTI3gAeclQoo4tMzFZGJUydviNoY=;
        b=SZSxn02Oh8kHlWxpC0ZheZqrqhviGh8hitlDEnx7kBYOeE+zlIVCy/S1PmO0NVm5Vh
         dmIuEygng8c1Pm+yrqmcb0lYJ8w7/TjHOcBp5nVL4RKCWCjj9NSVs8NxpKvUBlpJ3FiD
         6tbLBwpSv+h2XAtwKjhpBKEp4dmCjno9zLiXZ4TILkTFpdC+aerMTaMPYI4DTIY8Bwhq
         uyOQ7frUPwK2WlUBTrey9rS91Xm45dHFJYwStbbHkoM1f1D2xcL39Xzo3WhO/qtf5iB+
         z/XPfKIz6fWERH+RmvKMpKwhhmFnyvWVgMa72niPg75WmfO09zLU0tGpiFQ0T1ETtSnz
         j1Eg==
X-Gm-Message-State: AOAM532fxc8cOu145tefiiuKIZjSEJrWlEJvVCzGOIT/iq0T0LmV/c+P
        PNZnEdSbJjA/ObUn4OXIL6aJtFhAF5acdSW7A642ag==
X-Google-Smtp-Source: ABdhPJya1pQ3m+PBzENKSEcDzB6ja6iy+5Hr6CE5/UQqlDXSenL4ol3iYtZBtv3DVLGum6BVeQ8oNUuY6m+mGf4u65w=
X-Received: by 2002:a2e:87d8:: with SMTP id v24mr14196684ljj.387.1617582615756;
 Sun, 04 Apr 2021 17:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210330044206.2864329-1-vipinsh@google.com> <YGn42SKCPg2HWtQc@mtj.duckdns.org>
In-Reply-To: <YGn42SKCPg2HWtQc@mtj.duckdns.org>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Sun, 4 Apr 2021 17:29:59 -0700
Message-ID: <CAHVum0fhWSOFRS-t7cF=zCRf_SUoMN5UOYBChWSpmhJVcuMbsg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] cgroup: New misc cgroup controller
To:     Tejun Heo <tj@kernel.org>
Cc:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>,
        Eric <eric.vantassell@amd.com>, pbonzini@redhat.com,
        hannes@cmpxchg.org, Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, corbet@lwn.net,
        Sean Christopherson <seanjc@google.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, Jim Mattson <jmattson@google.com>,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Matt Gingell <gingell@google.com>,
        David Rientjes <rientjes@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 4, 2021 at 10:35 AM Tejun Heo <tj@kernel.org> wrote:
>
> Applied to cgroup/for-5.13. If there are further issues, let's address them
> incrementally.
>
> Thanks.
>
> --
> tejun

Thanks Tejun for accepting and guiding through each version of this
patch series.
