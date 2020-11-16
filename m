Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4148E2B5109
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 20:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgKPTZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 14:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729366AbgKPTZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 14:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605554745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NvVBGmxqrQQuwWx3xbqybvwAEYkcdIjrRUPaqDC7Ogg=;
        b=U1wjNto1NlBOjUeKiVry3WMCGPfKBU9prr4PL7YhnfmFeXS/P+mbSVizMMy+ejsfACK1fE
        gs4pwyXvha/ZebgeR2560I05zdYJfELoww1LzMU59W15Xy+5XrXLQEI9qEUSd6u+RSJJQU
        L2+YNUZMJMOmow3zVaiEnHxPBgEUQqE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-LeYnDdQ6MRCYma1Yf5rzWg-1; Mon, 16 Nov 2020 14:25:42 -0500
X-MC-Unique: LeYnDdQ6MRCYma1Yf5rzWg-1
Received: by mail-wr1-f72.google.com with SMTP id w6so11526256wrk.1
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 11:25:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NvVBGmxqrQQuwWx3xbqybvwAEYkcdIjrRUPaqDC7Ogg=;
        b=ORXZEQuV/D4CGGKx4fBljb1gIm2Nd0uiJ5NurhgiStwVteajkGz7me5hTbAs8F3Yen
         0BiVyI9kHleQtZqGM9fSGdWpj+GgnqsW89eUiZ2kjw6e8XAAp7/+JRToG1kNANOeare8
         u7OV1UGppUM5FavoVTAWpsjqIJzpvNrAOt34cN2NdhD9xfh0bNAkKA4OfNMqalX2c3fP
         Qf2Wf2MR45CGKkVGPCGdVobGDAWOMSHBQz6oiDlbg1dBj38y46SBxp/4w+M4EQ6VcrZv
         rNGgpRJ3TXGC9ROhQPzZLWgcIhy96RJafnmdFEEIatiHPAemFWI3CsPSgDASshTrycGd
         msKA==
X-Gm-Message-State: AOAM532VY6YawoGhbAZeHDg3Cd05dIuFPAeLSwI6DXlby/etfSc0ieK+
        Z880ji1FRGBZKarRJgH1/9MLXu7bqKrKswzgh25MRVH4Z1oJ30O4bZpEZz6Vy0df96PZvAdpcjX
        JLt7cBuXYpnkA
X-Received: by 2002:adf:e3cf:: with SMTP id k15mr20912832wrm.259.1605554741093;
        Mon, 16 Nov 2020 11:25:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/b4YoIKX8CQypRFi1xFvHZ9h3JEEhGLLN9/A6g7hCGC22w9inVABpcuR0toTOwvtdqCUX/Q==
X-Received: by 2002:adf:e3cf:: with SMTP id k15mr20912819wrm.259.1605554740953;
        Mon, 16 Nov 2020 11:25:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r8sm23858459wrq.14.2020.11.16.11.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 11:25:40 -0800 (PST)
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Add existing trace points to TDP MMU
To:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20201027175944.1183301-1-bgardon@google.com>
 <CANgfPd8FkNL-05P7us6sPq8pXPJ1jedXGMPkR2OrvTtg8+WSLg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0751cea5-9f4a-1bb9-b023-f9e5eece1d01@redhat.com>
Date:   Mon, 16 Nov 2020 20:25:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd8FkNL-05P7us6sPq8pXPJ1jedXGMPkR2OrvTtg8+WSLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 20:15, Ben Gardon wrote:
> If anyone has time to review this short series, I'd appreciate it. I
> don't want these to get lost in the shuffle.
> Thanks!

Yup, it's on the list. :)

Paolo

