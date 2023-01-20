Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA5675A99
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 17:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjATQ6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 11:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjATQ6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 11:58:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A724716ADD
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674233858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rfg4NeB0AI/m45F2FDkswyB0mN6BPfq//7//u6EQy60=;
        b=He+L+0uC4jZpCb81xqVvwfUAbtj8itEAJbt+OEBaLMQ8/8/z1ApPMz0Yi1ifT+ZwGRpsHw
        Dfmnf290kCgQP8P73BlMYkGPVNpihJM46d9HGXmRs/TphFFhblkbCjzKThWWToZADSTiOE
        zVYtv9VMoi4/vB556D7iOTUok9mYaYQ=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-9ClJpA4iMX-N-Mz1a-pZ8g-1; Fri, 20 Jan 2023 11:57:37 -0500
X-MC-Unique: 9ClJpA4iMX-N-Mz1a-pZ8g-1
Received: by mail-ua1-f72.google.com with SMTP id z9-20020ab05bc9000000b00617f27a4999so1797444uae.17
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:57:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rfg4NeB0AI/m45F2FDkswyB0mN6BPfq//7//u6EQy60=;
        b=cfFtYBedQeQusWe8hL9FQxfrZdPwNyf1upQE+AbBNoFarQuqm7HC6KW76ywuddNgrC
         NDPj5/UjWqQ5isePk3tZ0nYK2XaZLk5I8dFt8velHKSdWG8QCom2ISgppz61nCBQR0mc
         QOO0vxFoTPTwmUql3WWVSa7lvBpaIbA7sWb2MhWtX+ZJt5UI1RiOgQhGuvzg49AtWigU
         2hLEWtRs+Dm6rnNVTgxmo7AlVxf7xPjohsc1/eGmX7yAnIrYh8I0WtVMI74v2tDXq49G
         HukClsrAB9EE6O+CgCIzfQ+xgCxyzszULcs/o9d3G2d45S1kSwkSj/lgOpoyUK4iaEVl
         zHGQ==
X-Gm-Message-State: AFqh2koZ+R9NQ/rcUiuXw5Ta+5FyEwO9oC2rNOF4ZejTxte+J0zW2vLT
        AQ8D08sSk7qQtKY5ztz9q0aEdf4Y8umQBe8p4rHtagf4xVR1x1s9oEhvUjwoDLgNuOvUJMNw3qn
        lbSbr/McC14IIL4dcrrtjZMRjeTMO
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id i20-20020a0561023d1400b003b52762568bmr2121095vsv.62.1674233856751;
        Fri, 20 Jan 2023 08:57:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtVNKbtO+RxKzXoGATvq8dhonkXupwEH9Qvc7lVp2lEJMrVE9QYU2NHCPVjDwK0gUdo43vp27UkVAlKuuHRtlk=
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id
 i20-20020a0561023d1400b003b52762568bmr2121089vsv.62.1674233856467; Fri, 20
 Jan 2023 08:57:36 -0800 (PST)
MIME-Version: 1.0
References: <20230118142123.461247-1-aharivel@redhat.com> <CABgObfZdvd-=cqQ1aLVsJNuBd830=GJW+PMj1iaq7yMa2Za_7w@mail.gmail.com>
 <CPX65W5M0LSW.17ZS900QMBZLL@fedora>
In-Reply-To: <CPX65W5M0LSW.17ZS900QMBZLL@fedora>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 20 Jan 2023 17:57:23 +0100
Message-ID: <CABgObfb4uYa817tG9Q8vS-O0XVqom1CRia+g=hSuAYWOB2+xHQ@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
To:     Anthony Harivel <aharivel@redhat.com>
Cc:     kvm@vger.kernel.org, rjarry@redhat.com,
        Christophe Fontaine <cfontain@redhat.com>, xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 5:48 PM Anthony Harivel <aharivel@redhat.com> wrote:
> So I'm wondering if the contexts switching (KVM->userpace->KVM) to
> update all MSRs will cause performance issues?

How often do you anticipate them to be read by the guest?

> What I'm pretty sure is that updating the values should be done
> separately from the callback that consume the value. This would ensure
> the consistency of the values.
>
> In the hypothesis those MSRs are handled within KVM, we can read MSRs
> with rdmsrl_safe() but how can we get the percentage of CPU used by Qemu
> to get a proportional value of the counter?

If you are okay with only counting the time spent in the guest, i.e.
not in QEMU, you can snapshot the energy value when the vCPU starts
(kvm_arch_vcpu_load, kvm_sched_in) and update it when the vCPU stops
(kvm_sched_out, kvm_get_msr and post_kvm_run_save).

Paolo

