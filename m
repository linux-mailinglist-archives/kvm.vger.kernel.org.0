Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AFB79FFC4
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbjINJLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbjINJL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:11:29 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113842103;
        Thu, 14 Sep 2023 02:11:20 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-6556d05a55fso4139396d6.3;
        Thu, 14 Sep 2023 02:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694682679; x=1695287479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBSojwSH3itXBXHNd5wo3wIw6OI5nU9SUCVGGwVOLnw=;
        b=QGeJ9vHWyxRM2Mcea2aFIuuK6D0VthSHBKK3CfjIV0puSg9w3Lj6U+E14CdFhDM9FN
         ocsIKFHLk5joTpSceXx6j5o7kUqPbKoZ6XW0eqEEMiNNWDeMtlAjdKRGdRGiJ1BDkFFC
         evQwy1zP+vMyAfomXRcyrUxEdGM3CisYg8H9hpKG2Gcag7qREKi+0T1ecOWRVAGYltEq
         ZmvW4l9pCYVZg3FTEobtFFgwS1vevfxvW0l3z5inH8sdgVvfZG3zKN6tjdcWlOQOFVvv
         rmwJXrftQ15fQUp3TSPQKRIxLba6WwBc9esn0emTU5VPXGa0qU9dYXLWXnOH2uwypizt
         nboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694682679; x=1695287479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBSojwSH3itXBXHNd5wo3wIw6OI5nU9SUCVGGwVOLnw=;
        b=tMp2OyDnZYYNaQIHiI/er6zPUOdQ/NHpcN4R9Ls2wnzcuDNV/8n6oH3Ijl4UvG9Wew
         lsGMeerm7jjlgjyLLSUvkXomzxGyDeY4NOsDuTmVZ8U6rHy9lyB0ctO6IWz0Cpp8LtlU
         iAsPz7Ugv6SqA5KVNUhx+sl0RB9/F1oZwLmktlARzj/qgJM1mtFSswqlBwG/th1D8HOZ
         6QACP6/b8u2NT72vy8XjzBct2Xf1sQ6ViSucNKiUL4cpQ1Mr5dI3UtWDp0uGgT/5fY0T
         UhX7uYXkaDT2q6T4V85kRD4ragvDVs++DCHJNj1Buw2M63W5GNccj2KQlJQT+GUXmbUN
         e8Zw==
X-Gm-Message-State: AOJu0Yznxzgpg/XrquVMr2kA+ZyxUNLHYG0Ck0/+72/HoN4Kq9wYfTjz
        effNWGU0U3abnZj4Xl2vPtg=
X-Google-Smtp-Source: AGHT+IHlzfxw10a1MS6HdIAfaD0rRywZY36C5FfD/1Zvct/AUDGOupL4vA5SXGAn1f2srGZDMcTqAQ==
X-Received: by 2002:a0c:f789:0:b0:64f:420d:18ab with SMTP id s9-20020a0cf789000000b0064f420d18abmr5270695qvn.28.1694682678999;
        Thu, 14 Sep 2023 02:11:18 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id c15-20020a0cca0f000000b0063cdbe739f0sm338421qvk.71.2023.09.14.02.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:11:18 -0700 (PDT)
Date:   Thu, 14 Sep 2023 05:11:50 -0400
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dgilbert@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQKzKkDEsY1n9dB1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 04:15:54AM -0300, Leonardo Bras wrote:
> So, IIUC, the xfeatures from the source guest will be different than the 
> xfeatures of the target (destination) guest. Is that correct?

Correct.
 
> It does not seem right to me. I mean, from the guest viewpoint, some 
> features will simply vanish during execution, and this could lead to major 
> issues in the guest.

My assumption is that the guest CPU model should confine access to registers
that make sense for that (guest) CPU.

e.g., take a host CPU capable of AVX-512 running a guest CPU model that only
has AVX-256. If the guest suddenly loses the top 256 bits of %zmm*, it should
not really be perceivable as %ymm architecturally remains unchanged.

Though maybe I'm being too rash here? Is there a case where this assumption
breaks down?

> The idea here is that if the target (destination) host can't provide those 
> features for the guest, then migration should fail.
> 
> I mean, qemu should fail the migration, and that's correct behavior.
> Is it what is happening?

Unfortunately, no, it is not... and that is biggest concern right now.

I do see some discussion between Peter and you on this topic and see that
there was an RFC to implement such behavior stemming from it, here:
https://lore.kernel.org/qemu-devel/20220607230645.53950-1-peterx@redhat.com/

... though I do not believe that work ever landed in the tree. Looking at
qemu's master branch now, the error from kvm_arch_put_registers is just
discarded in do_kvm_cpu_synchronize_post_init...

```
static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
{
    kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
    cpu->vcpu_dirty = false;
}
```

Best,
Tyler
