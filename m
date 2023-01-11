Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECA6665ED
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbjAKWDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjAKWDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:03:10 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0544462D8
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:03:10 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id s192so5595196vka.3
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VmuBCsBxf7mGeczzGNyI3TdKv9UghiIBbcHCLEfGXdM=;
        b=KaFTBvuzzUGYrZ+Ybzzensoen8m4E/m1o7K4b71m0FAGmqXFaMaSDRpu++B6Ok8oEN
         f3AcgLUCTslQoRgcV0s1D9QvNshpfhIR+qlWY6vwFY1TfMF9YQnfQPliZMfGmRAiprbI
         pUAcF6HuklZsxetyIsR2eHH/vqwElPE6YbIc1EbrZXi6ioYulQFGj8ttyHhyDZg2vBtq
         cMclNpu7P4tPWSwrhP9Zjh5lS02JfSBEqc2YWOlY2KpDaZ90HK1u0Jua1HGRTY7+k51P
         nUwy47oXH5x3JUGxumq4hpvIuGGPUvThPNATphMrf4MTz3ejPeTtio0IY+n1vSzMz3hh
         oSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmuBCsBxf7mGeczzGNyI3TdKv9UghiIBbcHCLEfGXdM=;
        b=PZ2+qbEzsCbusPMJDNPt6yhDSLQhFdCP82OYF2fgR9Ow1tWNOSbkyw4WsWUpj2qS/i
         0yMrWMJFlbU6ahbekhsTqYIYnRReEMsqpWFl4SGjHEqtx3RHIlOs7J3APbaX5phZr9Ut
         tKWEjuLsV8XBCdA6VLpViI0Ppdmb5ZYGP2YkOSST+n57g7uZN29ZlUelevD07Zxmqdl1
         dolnjxY7SPYFnL+T7z2az8E08osotn6KCBdzEE06youWSJwEkion/d8XM8/MJdUEtyal
         QOi0I2pR5D7aNLdDyGyEU4a99etvwA/9PP1gC5fYeTnM1ZeHVh+Fynman6uZxZ4cftv5
         b+cg==
X-Gm-Message-State: AFqh2kplTM9f3ucDCpheAgxfkFfq/PTSN9vA5vLcrinSbEDVthLl71JD
        yOHZbdamGmLzXqgZeyyVN0foF2ZfpgYa8Oqq4zeM4A==
X-Google-Smtp-Source: AMrXdXtcFHbwzLgHpc/Ot7k4Klal50U1YIc7w99emrc4gOqh/WvQIQDDdPtwam+4svMTdbiQSZu9m1B21/H1BRUa4e0=
X-Received: by 2002:a1f:aa15:0:b0:3d5:dcb7:5f88 with SMTP id
 t21-20020a1faa15000000b003d5dcb75f88mr5238304vke.37.1673474588933; Wed, 11
 Jan 2023 14:03:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1667110240.git.isaku.yamahata@intel.com> <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Wed, 11 Jan 2023 14:02:58 -0800
Message-ID: <CAAYXXYwQ_qBbug85QgMMN376FSZqoZypbTm9Gzc9wgY88AxX+w@mail.gmail.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Sat, Oct 29, 2022 at 11:24 PM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>

> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +       int r;
> +
> +       if (!enable_ept) {
> +               pr_warn("Cannot enable TDX with EPT disabled\n");
> +               return -EINVAL;
> +       }
> +
> +       /* MOVDIR64B instruction is needed. */
> +       if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
> +               pr_warn("Cannot enable TDX with MOVDIR64B supported ");
> +               return -ENODEV;
> +       }
> +
> +       /* TDX requires VMX. */
> +       r = vmxon_all();
> +       if (!r)
> +               r = tdx_module_setup();
> +       vmxoff_all();

if few CPUs have VMX enabled, this will disable VMX in all of them.
Depending on what enabled VMX on those CPUs, would this not cause
kernel crashes/problems?
