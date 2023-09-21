Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EFB7AA58F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 01:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjIUXWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 19:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIUXWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 19:22:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A802B110
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:22:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81a47e12b5so2161388276.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695338560; x=1695943360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7bkyRILGQE7yWTmbQXiGKEo0p9CYB75A1OQz7APl7U=;
        b=0hloQHuZm4kw+GLf+XzEbwSz7VgbGzWdjly9NkDAk617soopbzpgGP7Nb5A77X1HKb
         Efbw8bJsGZfOP/SlWMAi6uzNfzXSPPvUL5i/5eRf8yPFn+4Geli1z8X2LKrYUM+cruF4
         NjSItMMkZ3LAN6/kAy2RC0uh3RAFhVCR30VAe/0r968XtLqX/XNNNPgjIcjNLxYTr9F/
         Wu9rOtQSPiJ8G3/r3Xm17BVoBZPIVz+2qcZEBAK9lbnt7bMG1QGVNl5c2FOiX/U0NsdX
         K5aVsd2Acvc7O0mYeks10zktzq5Jxi3OXF37xd5gjoJNokS3HS4Sy+ljUOwlPBAfSett
         v8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695338560; x=1695943360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7bkyRILGQE7yWTmbQXiGKEo0p9CYB75A1OQz7APl7U=;
        b=bpAAEBfSwIX4RMgJoZOAlrTtInQWPmnDgS14y2B6co8yiILfW3WhLdkGmE+DrvilJA
         dg/P1XICJdnAyUTJ+UXp5XTTklevAVgz5sfCc2FUjrFDPlhxRDGFnd6z1LWTL6TN4K2k
         sSey2sVWGrsPaZYjPwike/EKWTBe2JAELxbo+Cl/xVewF3PaNJP0xqtPTfopfLBl2LLe
         3oQxEUg1LenSfw+cVwdsBTOTImJwuUwvGZtdwoAd5qAxMJoNRs+EVpmj1Ws3CI9IbOQA
         SfvzEn6L/fcUQbRRkR8LF8nQor6HXKJhSVeMyyJiCQl4cSykV1kb1MJCG5GRWUaonoFW
         zlEg==
X-Gm-Message-State: AOJu0YxdbMJUM1Sxx6S64PiIAa40/Q/6Fj0ZKWPxAdvfwXexBAK6d7WU
        Qx+UhFo3aOd8Sj4h8QpVChjKdaT+igQ=
X-Google-Smtp-Source: AGHT+IHSb1Z0r7ilnJEoZiCefYypp5r5pBlXksHvx1oJ1cYKDwbYaGWbl1D6tS70HePwIJJQap8jFXMgfrE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:746:0:b0:d05:98ef:c16b with SMTP id
 67-20020a250746000000b00d0598efc16bmr943ybh.5.1695338559807; Thu, 21 Sep 2023
 16:22:39 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:22:38 -0700
In-Reply-To: <7fddbf10494490251f2156fd600306991826165f.1695327124.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com> <7fddbf10494490251f2156fd600306991826165f.1695327124.git.isaku.yamahata@intel.com>
Message-ID: <ZQzQPlcRdxu3z2Y/@google.com>
Subject: Re: [RFC PATCH v2 6/6] KVM: guest_memfd: selftest: Add test case for
 error_remove_page method
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This test case implements fault injection into guest memory by
> madvise(MADV_HWPOISON) for shared(conventional) memory region and
> KVM_GUEST_MEMORY_FAILURE for private gmem region.  Once page is poisoned,
> free the poisoned page and try to run vcpu again to see a new zero page is
> assigned.

Thanks much for the test!  I think for the initial merge it makes sense to leave
this out, mainly because I don't think we want a KVM specific ioctl().  But I'll
definitely keep this around to do manual point testing.

> +#define BASE_DATA_SLOT		10
> +#define BASE_DATA_GPA		((uint64_t)(1ull << 32))
> +#define PER_CPU_DATA_SIZE	((uint64_t)(SZ_2M))
> +
> +enum ucall_syncs {
> +	HWPOISON_SHARED,
> +	HWPOISON_PRIVATE,
> +};
> +
> +static void guest_sync_shared(uint64_t gpa)

Probably guest_poison_{shared,private}(), or maybe just open code the GUEST_SYNC2()
calls.  I added helpers in the other tests because the ucalls were a bit more
involved then passing the GPA.

However, I don't see any reason to do hypercalls and on-demand mapping/fallocate.
Just have two separate sub-tests, one for private and one for shared, each with
its own host.  I'm pretty sure the guest code can be the same, e.g. I believe it
would just boil down to:

static void guest_code(uint64_t gpa)
{
	uint64_t *addr = (void *)gpa;

	WRITE_ONCE(*addr, <some pattern>);

	/* Ask the host to poison the page. */
	GUEST_SYNC(EWPOISON);

	/*
	 * Access the poisoned page.  The host should see a SIGBUS or EHWPOISON
	 * and then truncate the page.  After truncation, the page should be
	 * faulted back and read zeros, all before the read completes.
	 */
	GUEST_ASSERT_EQ(*(uint64_t *)gpa, 0);
	GUEST_DONE();
}

> +			if (uc.args[0] == HWPOISON_PRIVATE) {
> +				int ret;
> +
> +				inject_memory_failure(gmem_fd, gpa);
> +				ret = _vcpu_run(vcpu);
> +				TEST_ASSERT(ret == -1 && errno == EHWPOISON &&

Honestly, I'm kinda surprised the KVM code actually works :-)

> +					    run->exit_reason == KVM_EXIT_MEMORY_FAULT,
> +					    "exit_reason 0x%x",
> +					    run->exit_reason);
> +				/* Discard the poisoned page and assign new page. */
> +				vm_guest_mem_fallocate(vm, gpa, PAGE_SIZE, true);
> +			} else {
> +				uint8_t *hva = addr_gpa2hva(vm, gpa);
> +				int r;
> +
> +				r = madvise(hva, 8, MADV_HWPOISON);

Huh.  TIL there's an MADV_HWPOISON.  We've already talked about adding fbind(),
adding an fadvise() seems like the obvious solution.  Or maybe overload
fallocate() with a new flag?  Regardless, I think we should add or extend a generic
fd-based syscall(), not throw in something KVM specific.
