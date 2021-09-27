Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469984194A6
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhI0Mzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 08:55:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234398AbhI0Mzv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 08:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632747253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqmCLZUE/RvdZRryhurm8ZYGJCB6f4ZHjcfNNE4aW4s=;
        b=PODrkc9JYKOdWTwOBmSdo36BCDjrhdMqFxZ5pNXzZUOLF77M0BMSVk+mWHEV/sJu5eUVuK
        2R5+BbQ0e6jq15fdYM31pyztzC7yy91B+2PWwr+BgMLerjWEYhnKZIJCYgg7gRrkN8crmz
        5fKJ4kR73rEMxbG9Bfa02P8XX4DdUgk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-HDqzCk6DPxaYsFsVzTa2hw-1; Mon, 27 Sep 2021 08:54:12 -0400
X-MC-Unique: HDqzCk6DPxaYsFsVzTa2hw-1
Received: by mail-ed1-f69.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so17802384edb.3
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 05:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vqmCLZUE/RvdZRryhurm8ZYGJCB6f4ZHjcfNNE4aW4s=;
        b=pB16SmwXvnZvaFPuqrK43pMZx4+YQSyoTVuRsWUQH7OUnMe58lYB2f77GyCAbERheX
         6AmulfdcHzFllMHYV+SRmaA+p5q+1pQG6FIykj29LmCFzu+5E4NhigQ4uWw2KPLtmC8T
         pkSOV+HstAwax9EpNUxBkw5hlso6tQ3POkwASkGhERLePIbcANL7RRRpX1Dac5+2tVAR
         +iNs3wgsM3aVWe8ShugeWX+n7tEd+XNNBtjpd/jfwWnA//HSSTecsheyKYAVH7Z015nE
         hazg/S/hJgosRPaARkys8gJSh+zE93oXiTYWT2JJiF4Ledhg4v1qCcgrLyPZzKdgJuJp
         6w6Q==
X-Gm-Message-State: AOAM532KBA+JYsZ+0Q/tmHsC7xlM3iUdymoJUhC4nyLQHXnde1UVZn33
        dErLcjQCwt+RrnaUX71cP6Wh6eH7nU5A/JCntF6GZgAy5IR2kTIeyX6UwhBSC5V/yIdXteqg1c4
        lndu9uKjAZbso
X-Received: by 2002:a05:6402:336:: with SMTP id q22mr23230097edw.53.1632747251021;
        Mon, 27 Sep 2021 05:54:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh2KYg0dnn8JVSWbgyFbmkyYWSZ1VqCAk6GrPkabmD/MjIijY41QSlBI2wv4H6jHN8FyRGNw==
X-Received: by 2002:a05:6402:336:: with SMTP id q22mr23230070edw.53.1632747250829;
        Mon, 27 Sep 2021 05:54:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j6sm8611436ejk.114.2021.09.27.05.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 05:54:10 -0700 (PDT)
Message-ID: <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
Date:   Mon, 27 Sep 2021 14:54:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic> <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
 <YVGz0HXe+WNAXfdF@zn.tnic> <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
 <YVG46L++WPBAHxQv@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVG46L++WPBAHxQv@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/21 14:28, Borislav Petkov wrote:
> On Mon, Sep 27, 2021 at 02:14:52PM +0200, Paolo Bonzini wrote:
>> Right, not which MSR to write but which value to write.  It doesn't know
>> that the PSF disable bit is valid unless the corresponding CPUID bit is set.
> 
> There's no need for the separate PSF CPUID bit yet. We have decided for
> now to not control PSF separately but disable it through SSB. Please
> follow this thread:

There are other guests than Linux.  This patch is just telling userspace 
that KVM knows what the PSFD bit is.  It is also possible to expose the 
bit in KVM without having any #define in cpufeatures.h or without the 
kernel using it.  For example KVM had been exposing FSGSBASE long before 
Linux supported it.

That said, the patch is incomplete because it should also add the new 
CPUID bit to guest_has_spec_ctrl_msr (what KVM *really* cares about is 
not the individual bits, only whether SPEC_CTRL exists at all).

Paolo

