Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5037A9AD
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhEKOkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:40:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231781AbhEKOkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620743957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BldeCvM9QHm9N8qu+17EJDBJ78BgeNyJtTowBlKxfAg=;
        b=hC0bNDslCP/ljB7Mosf6nU/DxHJWTj4WD24kY+pAN0twoDbA8vCSprFkaL2pqcAemPdH8e
        lqtLa3vSfT9tTMttYeWBaRcy+QWgJfGSpDZuPIRa3NtL+QZjahSWbqXeAWR3+A0k1Zo9HG
        tGfN4vmRjyYgjJUAQshUb38VaoNmOZo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-jbuQocCgM7uPNKtAb9uyoQ-1; Tue, 11 May 2021 10:39:13 -0400
X-MC-Unique: jbuQocCgM7uPNKtAb9uyoQ-1
Received: by mail-qv1-f72.google.com with SMTP id l61-20020a0c84430000b02901a9a7e363edso15618946qva.16
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 07:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BldeCvM9QHm9N8qu+17EJDBJ78BgeNyJtTowBlKxfAg=;
        b=KrmV/1dPOmadPLfACAdHGCWvURwxvfM6KfxND7CJdkFKh1Bl4AmbSccnG8Gl+3VacC
         YAUMGlaiZ3Rp7x9SZ6lqPV4DiW4V1ZgKuJ7fnpL1AlEgXxIP6Xmc4wt69fMQDt5NR7Jl
         TuDbgZXy7JymgOzlkQW4qdsTEuS0UOg8lye/nCQk2ARWpKNo9wm2vQOFi+zp0NWDEoN7
         crYMVS8pMl8CKzBnw8ms6ZQ1Fz4bFH9bSDklBGJsCTPnHEOiRmYfV2guxQTlEg21/XOE
         Z4Fc1jEbBenYKlrXKoe8ONP8n6yeqoOaRHJ7af+4ffHzUlYNwHkEECN7Uv8Wne3pCPRk
         zrIQ==
X-Gm-Message-State: AOAM533yuxpKkx/oe8SEkUSdvNxycww6yH8HYFkwwpH65rS0MQvYjBRC
        zVonOxercgOXLcORqGesldH/Y5DodjmbuxTAhA4BMtnCVfI0aGJySoxz8A5Me0gkj+O4+R1S9II
        TehAP3LziQWJr
X-Received: by 2002:a37:658a:: with SMTP id z132mr17467815qkb.86.1620743952949;
        Tue, 11 May 2021 07:39:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwma92fggIfHJJaV1/FXJQoHnBmTmrmte7vpnL4skInn3tziNs7PO/jme78HyhgRRutTZNwQ==
X-Received: by 2002:a37:658a:: with SMTP id z132mr17467791qkb.86.1620743952741;
        Tue, 11 May 2021 07:39:12 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id m124sm14170793qkc.70.2021.05.11.07.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 07:39:12 -0700 (PDT)
Date:   Tue, 11 May 2021 10:39:11 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJqXD5gQCfzO4rT5@t490s>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210507220831.GA449495@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > somehow, so that even without customized ->vcpu_check_block we should be able
> > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> 
> static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> {
>         int ret = -EINTR;
>         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> 
>         if (kvm_arch_vcpu_runnable(vcpu)) {
>                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
>                 goto out;
>         }
> 
> Don't want to unhalt the vcpu.

Could you elaborate?  It's not obvious to me why we can't do that if
pi_test_on() returns true..  we have pending post interrupts anyways, so
shouldn't we stop halting?  Thanks!

-- 
Peter Xu

