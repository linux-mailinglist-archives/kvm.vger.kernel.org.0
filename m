Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E165543537A
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhJTTMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:12:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231503AbhJTTMX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 15:12:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634757008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2fYJih/CjPQFZXgwcNdDHbQM/nEhdW/92S3MPMWu2g=;
        b=Y0mXkRdN+ntbJdC+ersZg7q6WNRA5Mz8w9on+oICIRjE/YFqLaNK1v2e2fDTx1YKb0z4eh
        q386yMMdXPveAQBonmzUtbSPxnunGLfDLjhMnSxckVm2Rlysn82pa5We72eeF1EI4JU9BM
        20Ok93NdaC5M5TVrjMKT9V3wrrHDv5o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-7OI83h-ePvesvmMFejr8Bg-1; Wed, 20 Oct 2021 15:10:07 -0400
X-MC-Unique: 7OI83h-ePvesvmMFejr8Bg-1
Received: by mail-ed1-f71.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so21865977edy.22
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s2fYJih/CjPQFZXgwcNdDHbQM/nEhdW/92S3MPMWu2g=;
        b=asMn0D8IGiI3eVAzk8Qk474qskz+mgKqpJAFRRvjWlKxa6fNb2UVPjdImSsO75WCkn
         4XqrFri7HOvAhbo4VZRSlrzpooGM8J1T39CMG+wex7YhZi6SqY+2gYb7mJSr8XpI5QN0
         BcXH9BfG035qRESoa7k9iYNEN7aVHciUYsR5vYp6eBPcV1XI1tjMwRUjJJC7FQWVcjvA
         3k5xJ2bNPtjKUVweNQoXt2YBFidhYm0HU92LQSNezvbGXDJnmUQ6CmKqT1K8MvXTtmhD
         Ia3tlWl7vvqPuxXv0LC6wlVidzdz6CyKtvkAGYZ6KpyooMuhytW1fVAsvDAPl5zNjAon
         DXKA==
X-Gm-Message-State: AOAM532F0NHL0a2aFAhby0rfhlEdgbWWYwsMNIkiOxajKYDX5iGRIKzP
        wm3WZiTeon7P6Md70bcBhzuZf6K/ZRI6xTrwTg7vfpU3ZNqeC+4ws/u5s3GACT4//FFvVe7I3hw
        BEX6GHbl4wVaT
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr990175edh.143.1634757006336;
        Wed, 20 Oct 2021 12:10:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbNwwKaQjWB9PuJKQegHteG94LwYyrTJB23Og8QQRP2nLFTm7Zcw323Tlxaphpr4E/Us/5yA==
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr990150edh.143.1634757006074;
        Wed, 20 Oct 2021 12:10:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l10sm1666272edk.30.2021.10.20.12.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 12:10:05 -0700 (PDT)
Message-ID: <9e61972b-3eb9-9693-3eab-274676a78be8@redhat.com>
Date:   Wed, 20 Oct 2021 21:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH kvm-unit-tests 1/2] unify structs for GDT descriptors
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        jroedel@suse.de, varad.gautam@suse.com,
        Jim Mattson <jmattson@google.com>
References: <20211020165333.953978-1-pbonzini@redhat.com>
 <20211020165333.953978-2-pbonzini@redhat.com> <YXBYzvnclL+HfIMr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXBYzvnclL+HfIMr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 19:58, Sean Christopherson wrote:
> Changelog says "unify struct", yet gdt_entry_t and gdt_desc_entry_t have fully
> redundant information.  Apparently anonymous structs aren't a thing (or I'm just
> doing it wrong), but even so, fully unifying this is not hugely problematic for
> the sole consumer.

Right, the unification is more between 32- and 64 bits.

"Unifying" the reply to both patches, the best thing to do is:

- always use gdt_entry_t as the argument

- use your definition of gdt_desc_entry_t and call it 
gdt_system_desc_entry_t.

- read the type and, if needed, cast to gdt_system_desc_entry_t to "OR" 
in the base4 field.

Paolo

