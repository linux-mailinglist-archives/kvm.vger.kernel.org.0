Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7062203536
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 13:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgFVLAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 07:00:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727079AbgFVK77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592823598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8E9QgTr5DUSmPQUcgFY/pyHg2J7mDIdAy0q0CM6YVs=;
        b=DBN7rO9eXfk2a1SeJw9pJ7r/xUYkmgQQMVVdFuPyXNkZdpVq1+GpHJnZFjqT7tRApPOjKs
        McWKHZlQAS8zCs7RrZDVp7ylU01YOrcgQ/OI5Kc9/Lbj0jjLGsJUgXxcu2r1oLTQbco4gI
        FgLM1vvIA0sXmPfRUYFwh99EHjLrnwk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-o1W3qd8GNN2zhqw14Vwi7A-1; Mon, 22 Jun 2020 06:59:56 -0400
X-MC-Unique: o1W3qd8GNN2zhqw14Vwi7A-1
Received: by mail-wr1-f71.google.com with SMTP id m14so10659577wrj.12
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 03:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=h8E9QgTr5DUSmPQUcgFY/pyHg2J7mDIdAy0q0CM6YVs=;
        b=lgvuV4KsjI5aLI9RboD00pY+TFB3y1CMlIqHS2wrqQf6n/j23YGTqmcZpin1ZhfYc7
         UJxvwEoX7KcdjUlAAhlYIsABdaKhV/6ashRfvX5Pjyr5b3+llMVavj3EARNI+esLeqJw
         Umalgmdmp46U77hFC3cgPorVyGb36nrU+vko8hBDTZ6jeSRqz8vBxa1U7UfXdkksL+QK
         U9PVZGXusmRKZTKe7qlviFR5XJP0bE+DPF8+pa0jBkAX+3O/RMqGT74/ZV4tClsJHqSU
         DGo+aH+ozhBOQGmGO9tajuKSF65y18s3Q7AK5BB7oZIQv0Ff8cKuVnF5y8fd/c0us6oS
         DgrQ==
X-Gm-Message-State: AOAM5338gi02lnjyt3OT4uJL1lPvqa/4so9Qv4AijpInLA+t7NV9yOs4
        HM/puFBgCCGZFhk5qyLFRQsaJQQruizjpv6qQjnperifc1nopUyyFY36N4ZJOswsvhUa3fLPU7O
        WrCy410sz14vG
X-Received: by 2002:a1c:9ec4:: with SMTP id h187mr17658398wme.27.1592823595773;
        Mon, 22 Jun 2020 03:59:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU0bX7wm+ozkWz+5aBqs2YpW0BK97Ao8m+ZhEht7Htjof/4aAVnlwSlLaDsim2jqnkq0PV2A==
X-Received: by 2002:a1c:9ec4:: with SMTP id h187mr17658362wme.27.1592823595363;
        Mon, 22 Jun 2020 03:59:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u13sm15951613wmm.6.2020.06.22.03.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:59:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, xudong.hao@intel.com,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: selftests: kvm: Test results on x86_64
In-Reply-To: <CA+G9fYvVfSEBsZCaiMCpCKfJNdbFzrKGdXR0KeRYG+nhDiEpuA@mail.gmail.com>
References: <CA+G9fYvVfSEBsZCaiMCpCKfJNdbFzrKGdXR0KeRYG+nhDiEpuA@mail.gmail.com>
Date:   Mon, 22 Jun 2020 12:59:53 +0200
Message-ID: <87r1u7fjrq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> FYI,
> Linaro test farm selftests kvm test cases results.
>   * kvm_mmio_warning_test — SKIP
>   * kvm_svm_vmcall_test — SKIP
>   * kvm_clear_dirty_log_test — PASS
>   * kvm_cr4_cpuid_sync_test — PASS
>   * kvm_debug_regs — PASS
>   * kvm_demand_paging_test — PASS
>   * kvm_dirty_log_test — PASS
>   * kvm_evmcs_test — PASS
>   * kvm_hyperv_cpuid — PASS
>   * kvm_ * kvm_create_max_vcpus — PASS
>   * kvm_platform_info_test — PASS
>   * kvm_set_memory_region_test — PASS
>   * kvm_set_sregs_test — PASS
>   * kvm_smm_test — PASS
>   * kvm_state_test — PASS
>   * kvm_steal_time — PASS
>   * kvm_sync_regs_test — PASS
>   * kvm_vmx_close_while_nested_test — PASS
>   * kvm_vmx_dirty_log_test — PASS
>   * kvm_vmx_preemption_timer_test — PASS
>   * kvm_vmx_set_nested_state_test — PASS
>   * kvm_vmx_tsc_adjust_test — PASS
>   * kvm_xss_msr_test — PASS

[...]

Thanks you! It would be great to see which particular commit was tested
here and how often you run these tests in general, which git/branch you
follow. Also, you can improve your subject line by adding [PASS] or
[FAIL] so we can see if there's a problem to deal with.

-- 
Vitaly

