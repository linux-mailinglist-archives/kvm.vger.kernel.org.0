Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B56E23ED61
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgHGMgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:36:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20388 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgHGMga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596803788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSQdzT7H+4LpZsteVQiSFjDrjWc1ok8uzbhUSttUkq4=;
        b=PP1kQCRvwXnvTtITVBJ1zUFl/JyAg/KbOfAmoVYxIlhH31+41iRyHbei9/qEOEbms9YI9C
        1ley/Y1hfr77VKqjl8jVdsowRBw+zoEPK1dR/bmmr30ImmyG+ZVzRmqgtpQc8jj8hEzksm
        YoZ08H7OjVXeJqqmnMQOmDWLICAh8m0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-mqTgS58xNDSYphp_9qe7xQ-1; Fri, 07 Aug 2020 08:36:22 -0400
X-MC-Unique: mqTgS58xNDSYphp_9qe7xQ-1
Received: by mail-wr1-f72.google.com with SMTP id d6so700645wrv.23
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 05:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSQdzT7H+4LpZsteVQiSFjDrjWc1ok8uzbhUSttUkq4=;
        b=U2vvs8ZbGWZi4yEduT3qBsxtwOXMoRSesnk40iE5O4viOsdDto8PohKz65ksGQue8n
         gaJRlUvLakFI1zl8cczL9jzLstyYWzWXHUeCRS7QvmgaV8E1OVmKW370faTVOwNPvZWj
         Ss7xkesNHktkCb09TQz9PPZMf+Y2L9mdLkmpABmY2MrPjWWorsxBDOBW6lSsrDiMcuQp
         nukE5Rgog6v8jTNhnzGxTfGLleLNzX4zqAJF9e9KOtgr99cSgOFsaJ6jCzeuV4FXEYNZ
         aPHxd9aGKe9pvReYcxbPtfhuwdc4m0TLGLRQsmAKqpFkY1VxdEndjH6RCBTsfA+k5FvF
         J+Gg==
X-Gm-Message-State: AOAM5303rAQxWIYOFNYkZQmx0/Tr89njRPIN38+3uB2/1adFdy4NeHY7
        jKLmdaWptLj+r92pSynPMscvRNeyjPct/Axa6WhpPxr7eSN5bH8wvF9xynw54oHK6CHhNHXLMOm
        5U9BkAb8/wZxu
X-Received: by 2002:a7b:c941:: with SMTP id i1mr12440139wml.73.1596803781569;
        Fri, 07 Aug 2020 05:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy++d/iNBNlxpS408ApnJ6hJ1kj6cCNrPLWp6KR03nlEWj2RVoifDtPxcqbzhatTdCupXP2iQ==
X-Received: by 2002:a7b:c941:: with SMTP id i1mr12440125wml.73.1596803781373;
        Fri, 07 Aug 2020 05:36:21 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.136.3])
        by smtp.gmail.com with ESMTPSA id j4sm10066356wmi.48.2020.08.07.05.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 05:36:20 -0700 (PDT)
Subject: Re: Guest OS migration and lost IPIs
To:     paulmck@kernel.org
Cc:     kvm@vger.kernel.org
References: <20200805000720.GA7516@paulmck-ThinkPad-P72>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <191fd6d6-a66e-06b1-aa6e-9a0f12efcfc8@redhat.com>
Date:   Fri, 7 Aug 2020 14:36:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805000720.GA7516@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 02:07, Paul E. McKenney wrote:
> 
> We are seeing occasional odd hangs, but only in cases where guest OSes
> are being migrated.  Migrating more often makes the hangs happen more
> frequently.
> 
> Added debug showed that the hung CPU is stuck trying to send an IPI (e.g.,
> smp_call_function_single()).  The hung CPU thinks that it has sent the
> IPI, but the destination CPU has interrupts enabled (-not- disabled,
> enabled, as in ready, willing, and able to take interrupts).  In fact,
> the destination CPU usually is going about its business as if nothing
> was wrong, which makes me suspect that the IPI got lost somewhere along
> the way.
> 
> I bumbled a bit through the qemu and KVM source, and didn't find anything
> synchronizing IPIs and migrations, though given that I know pretty much
> nothing about either qemu or KVM, this doesn't count for much.

The code migrating the interrupt controller is in
kvm_x86_ops.sync_pir_to_irr (which calls vmx_sync_pir_to_irr) and
kvm_apic_get_state.  kvm_apic_get_state is called after CPUs are stopped.

It's possible that we're missing a kvm_x86_ops.sync_pir_to_irr call
somewhere.  It would be surprising but it would explain the symptoms
very well.

Paolo

