Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120E05F3678
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJCTjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJCTjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:39:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B791C48E90
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:39:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so10819190pjk.2
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Fv0au4SRa/nCh2VkMnBPtiJ2PuLgaWQajBtBq7ab4Eo=;
        b=EgK/+EkbR4PIDpnn/sLiY9L/MhrTMPX+WC418JDHmCbffMGNR27L8VI33U1d69yB0R
         RgPwObQKp/YorfNN7hNcWZ1kLd9vPYhoWABlm0OITASCl8ycA0Q7byK24u3bp9Sm1u8M
         y8B3zI8CJsBFW2Vrr5Liiv8KhNXac0Mq2pLA5biFpV5+3Sq+jIt6a1EPJEUyU4SAhAH7
         pRpj7QRVqUUWvLLXrJ5bNdPXJsCCHxpoIbU9Ukp/PkqVSH53/6uqJ+ZWGYU9LH4R0a1L
         Y8vNaP+9fgesjHnS5CnuKwh5JKdjeh2ysJG5no+YPNCYPfZmpyjppblSm9KsDqfGA1SY
         KohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Fv0au4SRa/nCh2VkMnBPtiJ2PuLgaWQajBtBq7ab4Eo=;
        b=U3JcqIIT8UgWzAKLManUI8yfzCQWaV8YPZLZxQ3KgSATgaBN0qrSz8Wyd5MBaDCLyI
         DzlvToyZHCrzBWAEmY3rotqozQHRDxSVfFQh7uTIS1eNT/gX/H5R4HChVedvyBoq62tu
         m7RsNCqKWVA2yGVTC2Baq7ARoto7Z0MeWZYOeQUtj+ACjiRVfOsDbpjiIgG2bfmkS/AM
         9T1ys8TxKXa3Ri51HXZPPLxhvlvfoOiUp8saCGXI6faNDfI7wQrAMa0MR57yRRF3M93m
         KImFz3gxMoOuapnxb5L6nKbwivOopsAhezRfciLM5Rj6f8XDzPcLZnj7GIuT8hyPpizI
         WZcQ==
X-Gm-Message-State: ACrzQf3rkPrlPhFUul65eF3Ne4+2jNByqhO3JHKL2KZl49mSx0JiaI4/
        IvKAu7/5z8YbiMQUdGNFUviy+w==
X-Google-Smtp-Source: AMsMyM6wgYrDTvbt1RuBc3Z21KtUHbV72tlR/MkX9QczEYOwuo+2ablmxGJm9ML78WEj4RM4EKjzzw==
X-Received: by 2002:a17:902:9b91:b0:17e:5aba:5fb9 with SMTP id y17-20020a1709029b9100b0017e5aba5fb9mr10508972plp.27.1664825953190;
        Mon, 03 Oct 2022 12:39:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902f64e00b00178b6ccc8a0sm7567665plg.51.2022.10.03.12.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:39:12 -0700 (PDT)
Date:   Mon, 3 Oct 2022 19:39:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/3] KVM + perf: Rename *_intel_pt_intr() for generic
 usage
Message-ID: <Yzs6XTxOp7wxgmJO@google.com>
References: <20220926142938.89608-1-likexu@tencent.com>
 <20220926142938.89608-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926142938.89608-2-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The perf_guest_info_callbacks is common to KVM, while intel_pt is not,
> not even common to x86. In the VMX context, it makes sense to hook
> up the intel_pt specific hook, and given the uniqueness of this usage,
> calling the  generic callback in the explicit location of the perf context
> is not functionally broken.

But it's extremely misleading.  If I were a developer writing the perf hooks for
a different architecture, I would expect perf_handle_guest_intr() to be called on
_every_ perf interrupt that occurred in the guest.

Genericizing the hook also complicates wiring up the hook and consuming the interrupt
type.  E.g. patch 3 is buggy; it wires up the VMX handler if and only if PT is in
PT_MODE_HOST_GUEST, and then takes a dependency on that buggy behavior by not
checking if Intel PT is supported in the now-generic vmx_handle_guest_intr().

This also doesn't really clean up the API from a non-x86 perspective, it just doesn't
make it any worse, i.e. other architectures are still exposed to an x86-specific hook.

Unless we anticipate ARM or RISC-V (which IIRC is gaining PMU support "soon") needing
to hook into "special" perf interrupts, it might be better to figure out a way to make
the hooks themselves more extensible for per-arch behavior.  E.g similar to
kvm_vcpu and kvm_vcpu_arch, add an embedded arch (or vice versa) struct in
perf_guest_info_callbacks plus a perf-internal arch hook to update static calls,
and use that to wire up handle_intel_pt_int for x86.  It'll require more work up
front, but in theory it will require less maintenance in the long run.

> Rename a bunch of intel_pt_intr() functions to the generic guest_intr().
> No functional change intended.

This changelog never says _why_.  Looking forward, the reason for the rename is
to piggyback the hook for BTS.

