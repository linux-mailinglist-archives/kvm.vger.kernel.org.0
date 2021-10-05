Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF623421DC9
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 07:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhJEFE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 01:04:28 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:50366
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhJEFE1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 01:04:27 -0400
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C7FFD3F32F
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 05:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633410152;
        bh=4sv1HPCgRHpn4yyOFITBxjMLxNIHOvFNMiBGKmMcH4k=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=vvalc3mvXOQ3g1yrOrBn8g0EqBaCQlMxOr85d8lNUBE3JwoVtDMhaINKTSXW6tUwG
         1yeQWAHACG4Xn/6kGiEMdnEk+r6zE6QOw7jIAk/+zhUgjwwzYSDjLFXreygVjIDa5O
         vExidkOjIqaE7lddhb5tGqSUYJVrctx0RMwBqi2BXwVTyKkPSUm3wxjT1chfbqGnSS
         aAUmGANzz4vDlX2CDuVkVhK0MoOJx0em05z6H8r0dnotrsyi8lUpYYDJl8khOkrLtM
         xMDCIqS0CDdKXghrrEJ7hLk9WpT45kXawhQWxw8kmno8L0qLjT3IIMVh5EulC8S8Nc
         llUqsXnxj/Otg==
Received: by mail-pl1-f198.google.com with SMTP id p2-20020a170902bd0200b0013da15f4ab0so1186116pls.7
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 22:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4sv1HPCgRHpn4yyOFITBxjMLxNIHOvFNMiBGKmMcH4k=;
        b=qxPki6WKA2MWpJDqcq1xJAH056FbeNKf/9C40VyOuviUPLvpwmFrhJ29r2DETW3xY6
         HFx+GsGes6d50FkvhPVlWqezkKJI/L6d4vIHJadpG7mOmydwa2RVJlS68r/t1iFD1Njl
         IqfJ68Y8pD9V+i6dlyGN6afWIFkIvM5CZUUVScx7GNDhuR4MRi48GPpitDLfQfR0A+GA
         nlLjQogLb/TgE3whbhhebMPIERTCZ91ThT1+ykWihewQYS6TtMBEOYWLXkGZgzvY+nQ7
         MhcU166bZS63bNF1idACFlorim2+q19MGDeeK1VAgBwpurh6UFqiSsLScMLGSskgz++/
         +Zww==
X-Gm-Message-State: AOAM532fWYSLdSc8eqzrwsVDZ2/yfIBL1rC2FHEbPHn47TjqIND6W7y4
        VmYSZmClyxWpsKEabvB/oSeNcqjePQr1EagrOa9+3wuTGNs+z5s2pID2q6B16jmasrcLZBWs1aI
        RpkgJcbSS9yITq416o8AqwatZVAFcAQ==
X-Received: by 2002:a63:f80a:: with SMTP id n10mr13873454pgh.303.1633410151084;
        Mon, 04 Oct 2021 22:02:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhJ2fHJ+dmvfkCeHi0hcYcdtJHYxmYJcUqsJ34pBYhVK4O+ZYTX3mcaGYC7tek2r//0a/SZA==
X-Received: by 2002:a63:f80a:: with SMTP id n10mr13873440pgh.303.1633410150715;
        Mon, 04 Oct 2021 22:02:30 -0700 (PDT)
Received: from [192.168.1.107] (125-237-197-94-fibre.sparkbb.co.nz. [125.237.197.94])
        by smtp.gmail.com with ESMTPSA id b23sm16272954pfi.135.2021.10.04.22.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 22:02:30 -0700 (PDT)
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
 <20210914104301.48270518.alex.williamson@redhat.com>
 <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
 <20210915103235.097202d2.alex.williamson@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Message-ID: <2fadf33d-8487-94c2-4460-2a20fdb2ea12@canonical.com>
Date:   Tue, 5 Oct 2021 18:02:24 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210915103235.097202d2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Have you had an opportunity to have a look at this a bit deeper?

On 16/09/21 4:32 am, Alex Williamson wrote:
> 
> Adding debugging to the vfio-pci interrupt handler, it's correctly
> deferring the interrupt as the GPU device is not identifying itself as
> the source of the interrupt via the status register.  In fact, setting
> the disable INTx bit in the GPU command register while the interrupt
> storm occurs does not stop the interrupts.
> 
> The interrupt storm does seem to be related to the bus resets, but I
> can't figure out yet how multiple devices per switch factors into the
> issue.  Serializing all bus resets via a mutex doesn't seem to change
> the behavior.
> 
> I'm still investigating, but if anyone knows how to get access to the
> Broadcom datasheet or errata for this switch, please let me know.

We have managed to obtain a recent errata for this switch, and it 
doesn't
 mention any interrupt storms with nested switches. What would 
I be looking for
 in the errata? I cannot share our copy, sorry.



Is there anything that we can do to help?



Thanks,

Matthew
