Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C01A8443
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbgDNQL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:11:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388691AbgDNQLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586880707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUBd2pCgRj9SiApZb/+jh75HU78vESbbc+295T6gaM0=;
        b=gRtBEc6heb3eEdoLnGih6WHhGjKAdL5VIjyzqXatUaq8MvcfUuzzyZTmp+s1G+GpwQvd5b
        eIWhRaJpPz+wGOlyQLtzecoQR8B6RfnZj9cMLwLyuJPjpAXbfzysyODU9y8faFXPceJ5z9
        gC+vMZib6QctzFYoVtyblcLSQPeuQY0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-MaoD9W_pNBeMrxizV-SbsQ-1; Tue, 14 Apr 2020 12:11:43 -0400
X-MC-Unique: MaoD9W_pNBeMrxizV-SbsQ-1
Received: by mail-wm1-f72.google.com with SMTP id f8so4476063wmh.4
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fUBd2pCgRj9SiApZb/+jh75HU78vESbbc+295T6gaM0=;
        b=AwQcMwlwwfWpHGZzBG5vDFGOTVi1mwa+Qvx3alzOdXr2cJ0cmYRLRtdKnFC1cGM7f+
         nHDqjdCekysX5H4RN6FF4vVsLkRxLoMd891cSlChFeyLyss+Y7sNwdelds3Ag/cGVYkU
         nP/Ds535srfSZWa/PuN03xU6aoFdNFoDg6+6DX+LuxXK7nfOG7PfFdz18KcQhZmrMQWN
         PNBqCR0tTY93H+LxCRzXCqMjtkvXvwz4rObJ1RJnengOmoLyW8LjSwkt2gL+MsAilFNA
         Qb/3GDeBd/0txRnXw1RvutAdwC8p58uwSqV8Ykp6Ysq1O3Sc8+1boM2HmJOanu6B2JOb
         xrlA==
X-Gm-Message-State: AGi0Puac3l6BPcJrz7Xa6UvqGCh9Ig+UgYfawCD1bYKEJZUmjy+HcQKE
        VjTvszP3ViQDuBvVix10eftnkWM15F9jNrr9B+3sxM6//z1j0mtcYmvOUhzBKQgNIVMkIFxitUv
        UuVSfn/jIASUx
X-Received: by 2002:adf:f54c:: with SMTP id j12mr23218447wrp.183.1586880702427;
        Tue, 14 Apr 2020 09:11:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLtfS/+Hnrcq5KAZCGCrP6cU036LFagfhlNdo+F/A3zWmXw/b5z/SoA1fq+BaaSGzxibn2I2w==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr23218432wrp.183.1586880702199;
        Tue, 14 Apr 2020 09:11:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j10sm16437268wmi.18.2020.04.14.09.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 09:11:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
In-Reply-To: <3c9c379c-c027-2793-6148-3b677054740e@redhat.com>
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com> <20200310140323.GA7132@fuller.cnet> <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com> <878siyyxng.fsf@vitty.brq.redhat.com> <b0482ffb-a1e0-7d00-8883-53936487b955@redhat.com> <87wo6ixeyq.fsf@vitty.brq.redhat.com> <3c9c379c-c027-2793-6148-3b677054740e@redhat.com>
Date:   Tue, 14 Apr 2020 18:11:40 +0200
Message-ID: <87r1wqxd1f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> On 4/14/20 11:30 AM, Vitaly Kuznetsov wrote:
>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>
>>> On 4/14/20 10:01 AM, Vitaly Kuznetsov wrote:
>>>> Also, this patch could've been split.
>>> I can divide it 2 parts:
>>> 1. support for logical destination mode.
>>> 2. support for physical destination mode. I can also fix  the above issue in
>>> this patch itself.
>>> Does that make sense?
>> Too late, it's already commited :-) I just meant to say that
>> e.g. spinlock part could've been split into its own patch, unittests.cfg
>> - another one,...
>
> Ah, I see. I will be more careful.
> For now,  I will just move the physical destination mode test back under
> the check. Will that be acceptable as a standalone patch?

This is already in Paolo's patch:
https://lore.kernel.org/kvm/87zhbexh3v.fsf@vitty.brq.redhat.com/T/#m9791cd50a9d82fabdaddcb9259d14df3b89ed250

> In between I have a question is it normal for test_ioapic_self_reconfigure()
> to fail when executed with irqchip split?
> If so do we expect that it will leave the VM in some sort of dirty state
> that causes the following test to fail?

Not sure I got your question but IMO when someone does
./run_tests.sh
all tests are supposed to pass -- unless there is a bug in KVM (e.g. the
person is running an old kernel). In case we're seeing failures (or,
even worse, hangs) with the latest upstream kernel -- something is
broken, either KVM or kvm-unit-tests.

-- 
Vitaly

