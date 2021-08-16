Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB573ED95C
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhHPPBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:01:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhHPPA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629126027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6c/B2w01DIces0Gwf7GdMJgUY5TLllh+DG4mItOjhBc=;
        b=RCeDT+MAuXV7UrC3GPIakHZPuikgP1KLxlw6tQuQKCp4T9HVtxF/yTwwOPnMWmcg4wyNFq
        wb0DPh2JaLJAAa2HzP+ZhPN5SoZHSE4lNJwr0Dq+mw1w3jtxthfJU89vgZMSXzmHy/zGzn
        iBdplhsX5EvBhy2cuO2PaoJ2XTcJk+k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-0h3hefsOMPiKsedSpgHYBg-1; Mon, 16 Aug 2021 11:00:25 -0400
X-MC-Unique: 0h3hefsOMPiKsedSpgHYBg-1
Received: by mail-ej1-f72.google.com with SMTP id ja25-20020a1709079899b02905b2a2bf1a62so4787003ejc.4
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 08:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6c/B2w01DIces0Gwf7GdMJgUY5TLllh+DG4mItOjhBc=;
        b=jhD4v9arMX4JaWFXGXLy8/mZaXM2pSFXCj/QvndzKPwmQzrbbiWRhrFZoIalTZELXv
         6rJffPnAThARXvsRidb+ySPzhhOUjUsapmvXZRCcDhlAxnha/IVbJ4YwT4OycN4Mnjex
         GeGC34AMveJuYuZWfG1D7nRnAruMNVtacdMalYsJz+hu0LZwBMueflBY0AFWbLswU38P
         7luG8snMzxSAKRSIjzb8xY/jgREgtjHa3oLTN+W6IdALigwoDIlMEROCIda+zortyj+l
         V+DoryXkn7egKKYIRMizcf4ADvONwelM+O3ufQlxZaoHr4/8TN3Ghm0sD6QysK9mk7Tx
         NMJQ==
X-Gm-Message-State: AOAM5322rKQyJmZRvUOQnQLdAPI1CQxp6uEJtLnpvkb73KkMjEfRPk3y
        x885cSiW/VEcVGA0gjr5lmLlvSBFeiWJ45Y9qgkR/0dscjEoYEaxCB95txblGeSQDR9imcGcbbx
        HHOFlwLxOnXrT
X-Received: by 2002:a17:906:379a:: with SMTP id n26mr13897748ejc.501.1629126024558;
        Mon, 16 Aug 2021 08:00:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg05Adq9gspWdSbc/Y9Sdi3R19vQwkaCjgwvGhtfdPLEYQAovOnaHfkwwSg4AGDaeULaKNUw==
X-Received: by 2002:a17:906:379a:: with SMTP id n26mr13897731ejc.501.1629126024408;
        Mon, 16 Aug 2021 08:00:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m6sm874535edc.82.2021.08.16.08.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:00:23 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     thomas.lendacky@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, richard.henderson@linaro.org, jejb@linux.ibm.com,
        tobin@ibm.com, qemu-devel@nongnu.org, dgilbert@redhat.com,
        frankeh@us.ibm.com, dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <YRp09sXRaNPefs2g@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b77dfd8f-94e7-084f-b633-105dc5fdb645@redhat.com>
Date:   Mon, 16 Aug 2021 17:00:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRp09sXRaNPefs2g@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 16:23, Daniel P. Berrangé wrote:
> snip
> 
>> With this implementation, the number of mirror vCPUs does not even have to
>> be indicated on the command line.  The VM and its vCPUs can simply be
>> created when migration starts.  In the SEV-ES case, the guest can even
>> provide the VMSA that starts the migration helper.
>
> I don't think management apps will accept that approach when pinning
> guests. They will want control over how many extra vCPU threads are
> created, what host pCPUs they are pinned to, and what schedular
> policies might be applied to them.

That doesn't require creating the migration threads at startup, or 
making them vCPU threads, does it?

The migration helper is guest code that is run within the context of the 
migration helper in order to decrypt/re-encrypt the code (using a 
different tweak that is based on e.g. the ram_addr_t rather than the 
HPA).  How does libvirt pin migration thread(s) currently?

Paolo

