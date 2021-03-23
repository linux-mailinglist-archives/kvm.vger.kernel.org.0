Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5838E345C17
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 11:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCWKm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 06:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhCWKmM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 06:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616496131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gNbDvqmHSmOS17Uw36LiU1hQfbOR+Uaf4HP1sWsQm8M=;
        b=i9Zd7lab+U0DtmNZcdh7BbZRS4wnp3EG57Az0yLY+sEUYC+qwkbT9uMpkidFo3L57Hn5CH
        v22yxx+vnTmaWG/OfGPipB5XMa37Dm+nFk/m8sRMzY+KolRhJMc9vdtXSteU2xMfL2v4Ze
        UsxuP7OaMlAsCJd5XbT2XC4lMQ/2e0w=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-FTvmujGdPeCjDawEhpa7zQ-1; Tue, 23 Mar 2021 06:42:09 -0400
X-MC-Unique: FTvmujGdPeCjDawEhpa7zQ-1
Received: by mail-ej1-f72.google.com with SMTP id jo6so861130ejb.13
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 03:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gNbDvqmHSmOS17Uw36LiU1hQfbOR+Uaf4HP1sWsQm8M=;
        b=eAwUZb3ddjMv+z9ie1KZYadpNsi4GxNULrAroprPkqCEfzuspi4gxanJFcxgcQ4i5S
         E+wkF4H/BlQF3BLIl0W1bassXhvzLo7XRCJW0mt59byOvAe/tMzv0Nj27WmHeYjfg55G
         kpG21x3uR4yLPVnFwcnjP9cPLaq9Yx8oWBxeeL5NCGyIlreFo9s1kCNqszD6KIXslDyM
         MxBoAu5xaxCD8mj3BE2BtMBcZqNacLiPSDN3Rm/tObYd/DiMSXlua/XmPW7yO8XEDTOW
         uXfCQW2DHp8e5yqtJUQPMee3x6xrqv0ijBuY7G9XQ9tgMAycXlzoom1DVIttgYUDgigY
         VCOQ==
X-Gm-Message-State: AOAM532xnwumFnxtrqHD9wyTnR4xZjmIQsczQfQ68GrkykWHjRo6l3Sd
        dJm1G9tVhfZkqNgzI2AfFUeOZvvecie4QUZ1eLkp/wxysSAb15LiSejhWTUWUO1GyZs1hmdw9dT
        78Ko8lWXB1LlQ
X-Received: by 2002:a17:906:c058:: with SMTP id bm24mr4259394ejb.335.1616496128660;
        Tue, 23 Mar 2021 03:42:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHfV1x3tHtVhnWgVqKlxX+gGynmicskM/QyDg69WoGaur0WMcJJEOYrnEMKEzPFcvqr3TD/g==
X-Received: by 2002:a17:906:c058:: with SMTP id bm24mr4259380ejb.335.1616496128521;
        Tue, 23 Mar 2021 03:42:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g21sm10903399ejd.6.2021.03.23.03.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:42:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: make hardware_disable_test less verbose
In-Reply-To: <20210323100311.zq3yzru4heg4zomu@kamzik.brq.redhat.com>
References: <20210323085303.1347449-1-vkuznets@redhat.com>
 <20210323100311.zq3yzru4heg4zomu@kamzik.brq.redhat.com>
Date:   Tue, 23 Mar 2021 11:42:07 +0100
Message-ID: <875z1iyww0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <drjones@redhat.com> writes:

> On Tue, Mar 23, 2021 at 09:53:03AM +0100, Vitaly Kuznetsov wrote:
>> hardware_disable_test produces 512 snippets like
>> ...
>>  main: [511] waiting semaphore
>>  run_test: [511] start vcpus
>>  run_test: [511] all threads launched
>>  main: [511] waiting 368us
>>  main: [511] killing child
>> 
>> and this doesn't have much value, let's just drop these fprintf().
>> Restoring them for debugging purposes shouldn't be too hard.
>
> Changing them to pr_debug() allows you to keep them and restore
> with -DDEBUG

Ah, missed that we have this for selftests! v2 is coming.

-- 
Vitaly

