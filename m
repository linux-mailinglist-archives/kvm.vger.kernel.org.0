Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973A75332AD
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbiEXU4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 16:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241765AbiEXU4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 16:56:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A2719C6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 13:55:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id bo5so17477809pfb.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 13:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MjBnehvEwPZLzs4+i+dSICYOgzejGL+XMwwqgLCtq0s=;
        b=SnIB/h6p4zajI9jK5p01v04JiMknxosV5tXu1PwEktHSgnIWXEpfHyR2S3Be+3UG28
         yFauwPfd3tTs/f4FbQIlgs5Jc9knP3OFyCbTFABsuQZS9m7EYwJxdjWpxt934TFKM2s+
         bZ3aF3I/mWXhcVIStndN+jv7z6i33Y6690bwZoyixkHIHZncsG6ii3+2uyDk6dY5N3Lz
         BvQ1dgVKgqBVM0SatIkNhVrtyAljHCdpDGp27xJ5S+qUlIw8PPxUEz6TmV9UTVo6XycR
         xvt7S/XVXLWY+ETb8VsgspdHFvOf/5ZRPJIvUIbRrnQPf8pDaLDlvG35MiAwUZ3vT2v4
         78gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MjBnehvEwPZLzs4+i+dSICYOgzejGL+XMwwqgLCtq0s=;
        b=zS5QBOOjWquXk6FnNJ91wflNmH2yRpRPltEhk3ZF+D3+6pk1DAyDJYvXVKk8uYLtb/
         RpBWsPYHI11kbUrpH9IsWrorf+uOhTC7Xl0aXw18ju58ewH7l5gbUtNaXxxYlYUilgUf
         M5mb6mxZec2Zz4BwgX2fma8NLPCHComeC50wQuVjdTK+RGB83lIWsku24QOvPrH47Ptw
         Q/EFKbBiF+/tqreXqdPkeVEPKKQdb8zwKSUWJ/isOe6ZNlJA3p2F5kYK9QaltYFuoNP+
         4mNgLQ1m9e37gOyTzyu3LtKvhZohN1LK6KhUvcNuugpXZAQ8qhzVMqwxVaHhwQOiTFby
         OXtw==
X-Gm-Message-State: AOAM532LERFfdkvGHxJBoS968ybB4IoOb4TXciO6A3WbfU/kX+M+q2fa
        MxxCaliNQ27cg8CvavGkycCU3g==
X-Google-Smtp-Source: ABdhPJyItd5TkRoDL/PBRi8x67lR4NgEpz+M4QMVvCsc5IPE1+rTorq3tadhk7sNyXDFG+M53CQ1ig==
X-Received: by 2002:a05:6a00:2391:b0:50a:3ea9:e84d with SMTP id f17-20020a056a00239100b0050a3ea9e84dmr29943750pfc.21.1653425758967;
        Tue, 24 May 2022 13:55:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z6-20020a170902708600b0015e8d4eb285sm561336plk.207.2022.05.24.13.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:55:58 -0700 (PDT)
Date:   Tue, 24 May 2022 20:55:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/8] KVM: VMX: Introduce PKS VMCS fields
Message-ID: <Yo1GW/7OuRooi3nT@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-2-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424101557.134102-2-lei4.wang@intel.com>
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

On Sun, Apr 24, 2022, Lei Wang wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> PKS(Protection Keys for Supervisor Pages) is a feature that extends the
> Protection Key architecture to support thread-specific permission
> restrictions on supervisor pages.
> 
> A new PKS MSR(PKRS) is defined in kernel to support PKS, which holds a
> set of permissions associated with each protection domain.
> 
> Two VMCS fields {HOST,GUEST}_IA32_PKRS are introduced in
> {host,guest}-state area to store the respective values of PKRS.
> 
> Every VM exit saves PKRS into guest-state area.

Uber nit, PKRS isn't saved if VMX doesn't support the entry control.

  Every VM exit saves PKRS into guest-state area if VM_ENTRY_LOAD_IA32_PKRS
  is supported by the CPU.

With that tweak,

Reviewed-by: Sean Christopherson <seanjc@google.com>
