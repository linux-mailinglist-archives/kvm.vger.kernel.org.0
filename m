Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6144A4C6D
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 17:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380606AbiAaQsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 11:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349514AbiAaQsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 11:48:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB43AC061714
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 08:48:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 192so13353180pfz.3
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 08:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FEXr3o9AVVAks3RYUsTP9ea9gUTvinZzKepGOgcXzQM=;
        b=CW7N8M304J+53WVf/BpkUCwdN1l2ThMJkFVGdx/RKeMHvjg2uK6Xjpx8dXRPP8rS/c
         p4ubkcKXYA35I4zzDM9YCoMf6NADbiKz6/dDavZc6uWO9XesixO+I8FkD2MtAJp3wKnC
         zAgONa5UCwXbeXugTRaPjstTepe5i36fjsF27t+L0vEpmx4EJkPSW6YwcoDE/ePoQqTY
         9Qd9gl6MEHoe27rot4jLcrnELB7OSiVUYA07UwS0zLsssrFn6SCgyxsrVn1FtFg8Xn6z
         CVhKEfEEaYyjegdOYG+cNF5a1BWunM6fb0Vk4SwAWEV2b5Sn8zcldFw1vwOYUtSV7YZF
         Jf6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FEXr3o9AVVAks3RYUsTP9ea9gUTvinZzKepGOgcXzQM=;
        b=8Nt95mvhWu4wkaxAiH8Pv9hXt50A+FDa30X5gBjIHcCERawXruHwHbUdZOoJJnaTmq
         wD6hCUzVrMj35Qnx6E8B2CdMKomruWXXYRX6b606cDry7ELwC8RBfg6c9uDLW2k5zP+N
         K7w5lV7FaGsu+fUOYVscrGluq7TUFFPy8uKGVh9IncynZi5lzuOvA1EHOMqqiMhWiKaw
         sKkZXgJf3Rrw3y6w51hRtLF8pvgkHAFDGs5G8PuSF2PO7X4SzCeDWKyzq8ky4MjXkiAh
         1sJ0eOZP6Emz6q34OiX2t5M8PgPh13BQSkkPyfNuYxYLs6v9vbhc526QLikctgY1NJ00
         d+Eg==
X-Gm-Message-State: AOAM532a/YxnENlXHufntzlujcY0Nr9ogjvHIJMh/VWmR+XeL2YJ0mxu
        Gs7LzjflHPrvY2PlwHDvjantMA==
X-Google-Smtp-Source: ABdhPJygTSsEQFeDUTdJLfXm3w9hO9zbkOUUbSfeLfaH891QI0/yWPvqUvyRT1YeP+wiW0q4JquI9g==
X-Received: by 2002:a63:1c10:: with SMTP id c16mr17282685pgc.275.1643647729876;
        Mon, 31 Jan 2022 08:48:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k16sm20792277pgh.45.2022.01.31.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 08:48:49 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:48:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
Message-ID: <YfgS7VIp8fpGJvyD@google.com>
References: <20220128005208.4008533-1-seanjc@google.com>
 <20220128005208.4008533-2-seanjc@google.com>
 <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
 <YfQO+ADS1wnefoSr@google.com>
 <6979e482-1f07-4148-b9d7-d91cfa98c081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6979e482-1f07-4148-b9d7-d91cfa98c081@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 31, 2022, Paolo Bonzini wrote:
> On 1/28/22 16:42, Sean Christopherson wrote:
> All in all I totally agree with patches 2-11 and will apply them (patch 2 to
> 5.17 even, as a prerequisite to fix the AVIC race).  Several of patches
> 13-21 are also mostly useful as it clarifies the code, and the others I
> guess are okay in the context of a coherent series though probably they
> would have been rejected as one-offs.

Yeah, the SEV changes in particular are a bit forced.  The only one I care deeply
about is mem_enc_op() => mem_enc_ioctl().  If the macro shenanigans are rejected,
I'd say drop patches 20 and 21, drop most of 19, and maybe give 18 (svm=>avic) the
boot as well.  I'd prefer to keep patch 17 (TLB tweak) to clarify the scope of
SVM's TLB flush.  Many of the changelogs would need to be tweaked as well, i.e. a
v2 is in order.

> However, patches 12 and 22 are unnecessary uses of the C preprocessor in my
> opinion.  

And 14 :-)

I don't have a super strong opinion.  I mostly worked on this because the idea
had been discussed multiple times in the past.  And because I wanted an excuse to
rename vmx_free_vcpu => vmx_vcpu_free, which for some reason I can never find :-)

I was/am concerned that the macro approach will make it more difficult to find a
vendor's implementation, though forcing a conforming name will mitigate that to
some degree.

The pros, in order of importance (IMO)

  1. Mostly forces vendor implementation name to match hook name
  2. Forces new hooks to get an entry in kvm-x86-ops.h
  3. Provides a bit of documentation for specialized hooks (APICv, etc...)
  4. Forces vendors to explicitly define something for non-conforming hooks
