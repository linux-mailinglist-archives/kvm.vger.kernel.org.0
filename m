Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA748A909
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 09:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348758AbiAKIAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 03:00:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348786AbiAKIA2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 03:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641888027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mUwFgZRxEbBys4hhtVi3XC+OOhBQXkgUrXq0SWKqfV4=;
        b=A7EDEux1wAt4xrnZxTI3qw8aeuk52RFcSi7QlBbesBVUpmSS3YRY7HuGFMEmJ1tS/8/jd0
        5xltgLp8NrHWdzrAnJKfiYbAacYHNGI7djhw7g+9osQTqcvFmDGfrsMXRnX92SGc3jCzd3
        uTjE+VjpIbTfuQOQG+nNCDzAn/To6cM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-Ma2NvKZuPqqM6PDgQ90Urg-1; Tue, 11 Jan 2022 03:00:26 -0500
X-MC-Unique: Ma2NvKZuPqqM6PDgQ90Urg-1
Received: by mail-ed1-f71.google.com with SMTP id i9-20020a05640242c900b003fe97faab62so2712484edc.9
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 00:00:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mUwFgZRxEbBys4hhtVi3XC+OOhBQXkgUrXq0SWKqfV4=;
        b=To3H8FU+bwszx4wxIGeCgddSPVNKFf0rBNnuEWywMOl7RSGfUZ8YgUGm2HWNKTHd6l
         AZ+OSh7/ZqWnAmIZvqBCIATaI9PSzCR3EMJUVzlYVQfLmKtyYz60o2dNbsvCKnpYx5TA
         CDR3ktRdJ71KNW4au2pLlkQRRc1yYaAHM4hZPfsd5ZvS94ZpXbAYct97FTcXJmD5Wkrp
         /PaDwEC7s81Dtwn+2F+Zzw9zPzwlHBkN2DpZa38XfC3nP4A1rdUoivpjN2UuwZkD7Lc0
         pYVRxOLqBsV0BwZniOHyIvhSfYtI+g49wdF6Oqt9/6/ulp3V/JdziHzL/a9G58y5cHLm
         N9aw==
X-Gm-Message-State: AOAM531aYclf69YjpQ8ERflPaZXykdqRqAMb5irWiaT7p9bj9dzwS0GJ
        2wHxTpx/MSic+H8ILS+N+3pNLW8xRE7tnAFWnIj/WVHJwhZW7gBm64C13A7aWGEistrVbJ+Wb4N
        FvglJxVkYam3W
X-Received: by 2002:a05:6402:27cf:: with SMTP id c15mr3238872ede.390.1641888024726;
        Tue, 11 Jan 2022 00:00:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqKWre77joDOe06fjv7Z8fAS1cCPD1ZbZaT/jVCVMGeddVETAE80TP8U4qVc80gmByfCibvA==
X-Received: by 2002:a05:6402:27cf:: with SMTP id c15mr3238860ede.390.1641888024586;
        Tue, 11 Jan 2022 00:00:24 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g17sm3304399eja.165.2022.01.11.00.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 00:00:23 -0800 (PST)
Date:   Tue, 11 Jan 2022 09:00:22 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20220111090022.1125ffb5@redhat.com>
In-Reply-To: <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
        <20211227183253.45a03ca2@redhat.com>
        <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
        <87mtkdqm7m.fsf@redhat.com>
        <20220103104057.4dcf7948@redhat.com>
        <875yr1q8oa.fsf@redhat.com>
        <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
        <87o84qpk7d.fsf@redhat.com>
        <877dbbq5om.fsf@redhat.com>
        <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jan 2022 19:15:43 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 1/7/22 10:02, Vitaly Kuznetsov wrote:
> > 
> > I'm again leaning towards an allowlist and currently I see only two
> > candidates:
> > 
> > CPUID.01H.EBX bits 31:24 (initial LAPIC id)
> > CPUID.0BH.EDX (x2APIC id)
> > 
> > Anything else I'm missing?  
> 
> I would also ignore completely CPUID leaves 03H, 04H, 0BH, 80000005h, 
> 80000006h, 8000001Dh, 8000001Eh (cache and processor topology), just to 
> err on the safe side.

on top of that,

1Fh

> We could change kvm_find_cpuid_entry to WARN if any of those leaves are 
> passed.
> 
> Paolo
> 

