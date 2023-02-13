Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAD694DAB
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjBMRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjBMRFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:05:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B372F1E5F5
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:05:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o13so12558494pjg.2
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YA3nXeavi2IgC2QVEKNh3Y5rIck8xWQVEfND0oydho=;
        b=nkZVzJbW+0bAOf26p5HsohKx+B3sQMov+Uu3S1eeRd1i6SPBBuU8E80VWtaV9x5Fuv
         apJjdn41Pn5CsXsDS1amjSOZNn0Mm7GDqwrfOcuUmCDXpl5jHorRFr61rZLPw5EjFe+3
         phU4Ys0/xnT+xVZ0Oo2VlG0PFGOP4aSKq91PbjPbK1UsLxhWFytCwUwCeISVYhzvFiVS
         ThHQ66pYGUzCsXWFCFd8qkw1XlMlhqd3l51mb4/QRyMBe2R0osZMaRkO6CEjhZks0hQl
         IK4JRKaPfNXnS+wjQCDalqbSQF12pMk3SzgthO1wpw1ZhBchUa4pc6ogThsp8L7ldgDu
         4ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YA3nXeavi2IgC2QVEKNh3Y5rIck8xWQVEfND0oydho=;
        b=HxVwMR7B0HTFJEl5Zds0VGIdvveNfqucPlMooT4ywAyZBSHh7NsTpiaeqalNnH9sOx
         /41+Mop7AV2eiOhRZERYhCQNvWtSNmn/IuT/f7jIJ5YzPNu1Y/J/iAzjWj2hI0D+WU3S
         lalM3CqG/BAAFrYD8QdJ4BVplcAW4MOpG4GKmW/FtPgti617PvE/RfihjysQ5bj2saBv
         j3xJqnh4cHus8CihxVo2Ge7KsMUDPA0IRr/RQ5S3ZtiUrizM6URybasLELxwEeQNIBtF
         RmaPZnwXH/zf/xiW9g6YqGuyh1yXOthdB6oKPv0NYukwu+8YStzzZGbhmuGyT9xURn5i
         he3Q==
X-Gm-Message-State: AO0yUKXM5E/H6IOVQrrOKHQOv+ZFPSEG+dHldNOv9pxrw/y8eBxBlmJ4
        1kgPhac2Qa+PHFfp/JLKA3uK2w==
X-Google-Smtp-Source: AK7set9EH5feIANijfgT1ULe2nAmv+dr9K+OHOXj94Qu4ry1lc9l+1uto405Lq0mYsu9jjzTnSvx0Q==
X-Received: by 2002:a17:902:e003:b0:199:3909:eaee with SMTP id o3-20020a170902e00300b001993909eaeemr505647plo.6.1676307945009;
        Mon, 13 Feb 2023 09:05:45 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t1-20020a63b701000000b004fb5704f19bsm6174181pgf.31.2023.02.13.09.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 09:05:44 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:05:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/5] KVM: Put struct kvm_vcpu on a diet
Message-ID: <Y+pt5MGR+EjLH4qQ@google.com>
References: <20230213163351.30704-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213163351.30704-1-minipli@grsecurity.net>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023, Mathias Krause wrote:
> Relayout members of struct kvm_vcpu and embedded structs to reduce its
> memory footprint. Not that it makes sense from a memory usage point of
> view (given how few of such objects get allocated), but this series
> achieves to make it consume two cachelines less, which should provide a
> micro-architectural net win. However, I wasn't able to see a noticeable
> difference running benchmarks within a guest VM -- the VMEXIT costs are
> likely still high enough to mask any gains.

...

> Below is the high level pahole(1) diff. Most significant is the overall
> size change from 6688 to 6560 bytes, i.e. -128 bytes.

While part of me wishes KVM were more careful about struct layouts, IMO fiddling
with per vCPU or per VM structures isn't worth the ongoing maintenance cost.

Unless the size of the vCPU allocation (vcpu_vmx or vcpu_svm in x86 land) crosses
a meaningful boundary, e.g. drops the size from an order-3 to order-2 allocation,
the memory savings are negligible in the grand scheme.  Assuming the kernel is
even capable of perfectly packing vCPU allocations, saving even a few hundred bytes
per vCPU is uninteresting unless the vCPU count gets reaaally high, and at that
point the host likely has hundreds of GiB of memory, i.e. saving a few KiB is again
uninteresting.

And as you observed, imperfect struct layouts are highly unlikely to have a
measurable impact on performance.  The types of operations that are involved in
a world switch are just too costly for the layout to matter much.  I do like to
shave cycles in the VM-Enter/VM-Exit paths, but only when a change is inarguably
more performant, doesn't require ongoing mainteance, and/or also improves the code
quality.

I am in favor in cleaning up kvm_mmu_memory_cache as there's no reason to carry
a sub-optimal layouy and the change is arguably warranted even without the change
in size.  Ditto for kvm_pmu, logically I think it makes sense to have the version
at the very top.

But I dislike using bitfields instead of bools in kvm_queued_exception, and shuffling
fields in kvm_vcpu, kvm_vcpu_arch, vcpu_vmx, vcpu_svm, etc. unless there's a truly
egregious field(s) just isn't worth the cost in the long term.
