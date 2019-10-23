Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1EE2225
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfJWRzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 13:55:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34005 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbfJWRzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 13:55:19 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so26076052ion.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 10:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pO/myx3J7kHrLEpa25DVGDw09CZzis8oLjoyxuQ8iXY=;
        b=rH/zv2bBzv28ImycCzKpsHuu8Ps9K+MRaSqhv0eBaQ/3iLs+cMzAR2Q7J8IIdjzbS1
         xjEGpt52mQB+IbeLuyfJXacyyEaoZstWgGpMs/+Xvu2AN8D7AabjnsUbQlzJkATlMW72
         6soo95F/DsR834TJQNiOLnP5A7F4D4FRtxhPvArLgUJ2hDyUUZSN9tTbPTDVFyjRHsx+
         bUvmWlRJ/N691cAYkhE1QT2k8JPuipH4eXsJSWe6YBK58bpKBN1K2PuR+cDyjk1KLga7
         sRfO8dzKDnYpEPd9X6q7qI/3SnZew/6K0OEa17iP+DntLfijtTTQ6JWyZoMmmhAWptht
         CsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pO/myx3J7kHrLEpa25DVGDw09CZzis8oLjoyxuQ8iXY=;
        b=rBIB1V/WZNaxih0hiJWeEKx7ZK0SekkV+QBrGTGZJpaTRkaHRbPmehgOyUsh10+eNE
         jwvh4MrvxkfMpdp+I+MUE/3hy4W+OtY00/ryipPebu3NGL3/wl/MQ44szh3RTkPeLdy8
         9ekTqQPGoktlTM3Kzq5LnEbZuESQywBYvmDWiOBuNRz5IuJzPC2RC5diPRECCLLAZy+N
         cSsqxNI7KBDWXb5hCZ/0Bd99NmLZw8G1Lel3ow8Exe5XaDMXRBQVC+/5s7S6Cee4uyo6
         8ERhaFNDkHMOdmBY+m9gdy1gJuQ7/EfL6IS+Z+Zo6ZDLEngpPEwxwwYg5LqrHfPRiofE
         qOAA==
X-Gm-Message-State: APjAAAX7nRJ6KHuS4pNIHAy4/A2hXq3cWvcezVa2NqK6pj/muFMjIOKV
        6c4Ctmj6UozExNKKRl4akwBSYoNdRjWy0ssbuz++H/2FGPk=
X-Google-Smtp-Source: APXvYqxsl67QSPoS4uT6rbqaV0JLYE88xU9s8zWf37x/DLlTqLfH704EHVMUPvK17HziO1K2RFkFUCoxfPD70rfTzlE=
X-Received: by 2002:a5d:8146:: with SMTP id f6mr4908064ioo.108.1571853317840;
 Wed, 23 Oct 2019 10:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191021160651.49508-1-like.xu@linux.intel.com> <20191021160651.49508-4-like.xu@linux.intel.com>
In-Reply-To: <20191021160651.49508-4-like.xu@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Oct 2019 10:55:06 -0700
Message-ID: <CALMp9eRyyKy=U_90mxZw=QaEPujLw+KKbXyozH2FUb-GdP7-Qg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] KVM: x86/vPMU: Rename pmu_ops callbacks from
 msr_idx to rdpmc_idx
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, like.xu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Kan Liang <kan.liang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 1:12 AM Like Xu <like.xu@linux.intel.com> wrote:
>
> The leagcy pmu_ops->msr_idx_to_pmc is only called in kvm_pmu_rdpmc, so
> this name is restrictedly limited to rdpmc_idx which could be indexed
> exactly to a kvm_pmc. Let's restrict its semantic by renaming the
> existing msr_idx_to_pmc to rdpmc_idx_to_pmc, and is_valid_msr_idx to
> is_valid_rdpmc_idx (likewise for kvm_pmu_is_valid_msr_idx).
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
Nit: The ECX argument to RDPMC is more than just an index (in fact,
intel_is_valid_msr_idx() extracts the index from the provided ECX
value), so I'd suggest s/rdpmc_idx/rdpmc_ecx/g.

Reviewed-by: Jim Mattson <jmattson@google.com>
