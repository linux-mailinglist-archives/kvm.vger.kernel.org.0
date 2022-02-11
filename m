Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9D4B1E23
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 07:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbiBKGHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 01:07:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiBKGHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 01:07:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF302264F
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 22:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644559655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sOs06svCRskfevOs7wvSSDMydwtyNRGcYolT1X1xpFc=;
        b=I/o9iMEOPZwQYD+v5XpbjHH1k4jZaI9uxLJpFaZSHjTVi0PjEUDN5FDhfxTRrjkbQ3Tl0/
        dPYrUzle9J/b2RxJDPhw6coBWuqqwp/GIcijEx0coDIMAYVxEouGNW0kLoxgJjD2qLykFd
        U1lDDnal0e8BgkFkiTNLbprLamejmd4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-bD7SEfF_Oc-Kj6txYqOBfQ-1; Fri, 11 Feb 2022 01:07:34 -0500
X-MC-Unique: bD7SEfF_Oc-Kj6txYqOBfQ-1
Received: by mail-lf1-f69.google.com with SMTP id v24-20020a056512349800b0043f1c29459bso1871816lfr.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 22:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOs06svCRskfevOs7wvSSDMydwtyNRGcYolT1X1xpFc=;
        b=PwJDy/uKA0euEPmSdVKx/zTMeA5Ftbcq7oI/zrWKnIJWsSeiCf1PoG9JSTd6EX35Ai
         kCzWt9pTid24ZPX+3kZjSiMAJOi7SU5IeeYzmLhAovPUQepy7jPS7uWgkr8Yw5uxBXJL
         733R+KG1xCsr9WJWm0Rg1nDBlRWgm25mXQ3hHmcyw8MgpXf1U3DWGt980eS/ieICmTHl
         L+0ZgXXdq6kTbzB5sYrsiBySlzrlqYmd87rbywZ7faXD7W0/yjqxvTgO+pVS1mC2r/7J
         a1CJGELl+iLjaAwrMNKRODTgVaMPEeG1f8/aF/aB7sV0ju3suRMd2bqmGg7qWSTwZpuq
         hfhw==
X-Gm-Message-State: AOAM530g7ma8VLY+JP85Hm6IecMJIg+Ohkt4kQuOrUhex3efELHBJku0
        zHLPhLUL4CwT2FSnV9dIbN3xThyO5mItlyhOZFfRvOQUlrHE3UNSbyHRXPUEVUIVBEEmOz6J7rE
        xsocvqH3A7k8PU2w4o3kp4kqKLcVG
X-Received: by 2002:a05:6512:2606:: with SMTP id bt6mr147631lfb.187.1644559653310;
        Thu, 10 Feb 2022 22:07:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoWLii9XxRSj/jXk7N/fLFlqzjSP5PWx4yrCtcPB/EmY7s+7To2p8aZkqI47cuUUV+IBXyzuvMn1WIvmoFkZ8=
X-Received: by 2002:a05:6512:2606:: with SMTP id bt6mr147608lfb.187.1644559653059;
 Thu, 10 Feb 2022 22:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20220208022809.575769-1-leobras@redhat.com>
In-Reply-To: <20220208022809.575769-1-leobras@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Fri, 11 Feb 2022 03:07:21 -0300
Message-ID: <CAJ6HWG6mEssijXC63kTA+ARNG-xupcFsrU_JBibO2d33CTt8vA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just noticed I forgot to include the EXPORT_SYMBOL() so kvm can have
access to fpu_user_cfg.
Sorry about that.

I will send a v3 shortly.

Best regards,
Leo

