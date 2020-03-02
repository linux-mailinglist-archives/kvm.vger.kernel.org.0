Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6908F175F5D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBQTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:19:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726621AbgCBQTU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 11:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583165959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcgIDsqSV25Wxct1z7cORqnU51/MVkfs3svtsO72JHU=;
        b=KO5n6VJKqr5aGMRLcNX0RcAvggvTvo5EmDI7zu9ZIFFbOiNR6110F05f8iDYEe7isU/dK8
        eFW/S0way1ChNlkc6MhE321D6bOBblYr367ZWvTYdo3EihjsqNOCKnqd+tlA6a4XfmJhr3
        Y58TmGaHriWcq3q/ix9AuZpmZ9fwQtM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-SMsFLaT7NYy8OnpjXCWqIw-1; Mon, 02 Mar 2020 11:19:18 -0500
X-MC-Unique: SMsFLaT7NYy8OnpjXCWqIw-1
Received: by mail-wm1-f70.google.com with SMTP id d129so16272wmd.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:19:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xcgIDsqSV25Wxct1z7cORqnU51/MVkfs3svtsO72JHU=;
        b=US0AuJMXEERSL40evnBAyqeUorqEqI9pDcuep9hLE/+/aOO9NQU7HbUpHe6tLhYq9y
         2nRwLXB3LSd7rC+O6aPuERNZPLBydl/kkGor9iMaxF9lEAKm1F176QuOmL1KC2f1aUyc
         ccUpUmqONSH0lTCLnvyUvloN4Ng2natVVh6r6Xt/bcZsyV11u+wCZ9gNHgFobowy9Fq1
         Ogc/mm4yfea6tya1Tjb6FkRRjOcgJIN33s3+r1K+UT6zCBD1hUPj+iGbwbFSYyq5zidd
         QMQ3hAE1+M/oheKG5dAbEG87J4KvdRi6SYLm60ESqisFux7oOaPBvA2MgUe8OxsP0ri7
         TdKw==
X-Gm-Message-State: ANhLgQ2FcfuUm/KR3IPRY/SMEL0UP6W7potQ68MfigUXiR4OWjvC5FIP
        /28Z0lXLNWFKH7SzZlSt7DfgCD1Gmcyc5SJiYgNoO1tveXk1vw698tgfimC6PeZnLeOXSd4gSYw
        MvIPMqr/1OmMS
X-Received: by 2002:a1c:7203:: with SMTP id n3mr159983wmc.119.1583165957071;
        Mon, 02 Mar 2020 08:19:17 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtpz/QD7rNsVUym/z0mc5G8wkwZRKUg9bf4O5odofDRqTjOdUR0Iie50J99YEDSh9Yz+Be91g==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr159962wmc.119.1583165956757;
        Mon, 02 Mar 2020 08:19:16 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id l17sm8139900wmi.10.2020.03.02.08.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:19:15 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Wei Huang <whuang2@amd.com>, Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200228085905.22495-1-oupton@google.com>
 <20200228085905.22495-2-oupton@google.com>
 <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
 <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af610180-d7fc-5a62-029f-0e27980c4037@redhat.com>
Date:   Mon, 2 Mar 2020 17:19:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 23:47, Wei Huang wrote:
>> How extensively has this been tested? Why hasn't someone from AMD
>> suggested this change?
>
> I personally don't suggest enable AVIC by default. There are cases of
> slow AVIC doorbell delivery, due to delivery path and contention under a
> large number of guest cores.

To clarify, this is a hardware issue, right?

Note that in practice this patch series wouldn't change much, because
x2apic is enabled by default by userspace (it has better performance
than memory-mapped APIC) and patch 1 in turn inhibits APICv if the guest
has the X2APIC CPUID bit set.

Paolo

