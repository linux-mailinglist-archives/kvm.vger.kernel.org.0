Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C355B7DA1
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 01:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIMXm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 19:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiIMXm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 19:42:26 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB043E5E
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 16:42:24 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1280590722dso36554407fac.1
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 16:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ymOBTT9gt+5RfA+7OEYVUzIarEXqqhDX2Od7iC8wXFo=;
        b=fDWCbKx75MTAMO9j3QRsvKgBo3jSzijY6zAqVK0AS2P8/ediVvkOEfRSYw7pixHsH4
         KC2FqdOz6xyZSS2wybPYXn0L7mG4FCztnKaTXk0rTUf7wRU5fg81yAZVn78AGS8GJX6j
         LlbQHXBgYMAxw6980OxKnXlXSpVPWvtBFNbKY9BrrhZyW30QJ0NiB7vQEk21dprRXQ6d
         qHoanaNXknZDg4F1PMSfuxvLNkOHOlcbxwmOxJKyPkqvkf9R1nDMi4uIjaR4n+JhCePM
         1Q+X4GROYfQeYmauiBzDqUMcpPBZKzuuxhtqnzFAiWmFfHzHmBZsIM0M8A64rxlaQx/b
         9NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ymOBTT9gt+5RfA+7OEYVUzIarEXqqhDX2Od7iC8wXFo=;
        b=mFSTf6HG6Xw7OcOuqcITwHIVBZvPYR7rt28Vk0vVieoBJGZev5oOvxu2fjkxrhoPQx
         CuYPoNhsS4CMXsT/IBX/SqyA+ynOERj66au5qrow+q34tSnSnAcch746oDs9oOX5w6cs
         iRRCOLTE8k6ct5Eru/RGghWhYuR1giRew0i6UAREfWA+3VC9GaWRd47MfITlNP7atyCi
         uB3MTjN17d3Ngt8OFZFE0kgmouSfutPAhJJoxUyp+7nXTGFSg5xOi5CUgW+2K4rUbdj+
         /5zKwq2r/5tNWDuiBtPqWdV/rdSiHlH+i14aZY33Ht58Md17Mtfqu4k281+eqa0VFhDh
         8mXw==
X-Gm-Message-State: ACgBeo3Flis5MJg8MzSMqgSV1yihKoSsE2dQZT0LidZX221AH0UqKXCd
        823rrx6jdWPFKVht8YO8UuTSOW4aKoJkjhHWIjZNGA==
X-Google-Smtp-Source: AA6agR7Hq1uTc9jDRtKqlEHZ2RHt5dQ5mO20NUpTJWAN2EXMUT3sVSSiDkiMAO2NrzQpBeNj1rJ3MxCf8wVNy33a7cw=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr895413oao.112.1663112544112; Tue, 13
 Sep 2022 16:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210201051039.255478-1-like.xu@linux.intel.com>
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 13 Sep 2022 16:42:13 -0700
Message-ID: <CALMp9eRC2APJgB3Y7S4MWsTs9wom3iQycd60kM2eJg39N_L4Ag@mail.gmail.com>
Subject: Re: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording Enabling
To:     Like Xu <likexu@tencent.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 31, 2021 at 9:17 PM Like Xu <like.xu@linux.intel.com> wrote:
>
> Hi geniuses,
>
> Please help review this new version which enables the guest LBR.
>
> We already upstreamed the guest LBR support in the host perf, please
> check more details in each commit and feel free to test and comment.
>
> QEMU part: https://lore.kernel.org/qemu-devel/20210201045453.240258-1-like.xu@linux.intel.com
> kvm-unit-tests: https://lore.kernel.org/kvm/20210201045751.243231-1-like.xu@linux.intel.com
>
> v13-v14 Changelog:
> - Rewrite crud about vcpu->arch.perf_capabilities;
> - Add PERF_CAPABILITIES testcases to tools/testing/selftests/kvm;
> - Add basic LBR testcases to the kvm-unit-tests (w/ QEMU patches);
> - Apply rewritten commit log from Paolo;
> - Queued the first patch "KVM: x86: Move common set/get handler ...";
> - Rename 'already_passthrough' to 'msr_passthrough';
> - Check the values of MSR_IA32_PERF_CAPABILITIES early;
> - Call kvm_x86_ops.pmu_ops->cleanup() always and drop extra_cleanup;
> - Use INTEL_PMC_IDX_FIXED_VLBR directly;
> - Fix a bug in the vmx_get_perf_capabilities();
>
> Previous:
> https://lore.kernel.org/kvm/20210108013704.134985-1-like.xu@linux.intel.com/
>
> ---
>
> The last branch recording (LBR) is a performance monitor unit (PMU)
> feature on Intel processors that records a running trace of the most
> recent branches taken by the processor in the LBR stack. This patch
> series is going to enable this feature for plenty of KVM guests.
>
> with this patch set, the following error will be gone forever and cloud
> developers can better understand their programs with less profiling overhead:
>
>   $ perf record -b lbr ${WORKLOAD}
>   or $ perf record --call-graph lbr ${WORKLOAD}
>   Error:
>   cycles: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'
>
> The user space could configure whether it's enabled or not for each
> guest via MSR_IA32_PERF_CAPABILITIES msr. As a first step, a guest
> could only enable LBR feature if its cpu model is the same as the
> host since the LBR feature is still one of model specific features.
>
> If it's enabled on the guest, the guest LBR driver would accesses the
> LBR MSR (including IA32_DEBUGCTLMSR and records MSRs) as host does.
> The first guest access on the LBR related MSRs is always interceptible.
> The KVM trap would create a special LBR event (called guest LBR event)
> which enables the callstack mode and none of hardware counter is assigned.
> The host perf would enable and schedule this event as usual.
>
> Guest's first access to a LBR registers gets trapped to KVM, which
> creates a guest LBR perf event. It's a regular LBR perf event which gets
> the LBR facility assigned from the perf subsystem. Once that succeeds,
> the LBR stack msrs are passed through to the guest for efficient accesses.
> However, if another host LBR event comes in and takes over the LBR
> facility, the LBR msrs will be made interceptible, and guest following
> accesses to the LBR msrs will be trapped and meaningless.
>
> Because saving/restoring tens of LBR MSRs (e.g. 32 LBR stack entries) in
> VMX transition brings too excessive overhead to frequent vmx transition
> itself, the guest LBR event would help save/restore the LBR stack msrs
> during the context switching with the help of native LBR event callstack
> mechanism, including LBR_SELECT msr.
>
> If the guest no longer accesses the LBR-related MSRs within a scheduling
> time slice and the LBR enable bit is unset, vPMU would release its guest
> LBR event as a normal event of a unused vPMC and the pass-through
> state of the LBR stack msrs would be canceled.

How does live migration work? I don't see any mechanism for recording
the current LBR MSRs on suspend or restoring them on resume.
