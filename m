Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F961434F00
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 17:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJTP2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 11:28:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhJTP2u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 11:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634743596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eV6bAWxCLxc2CW54T10deAeKBJdgDr/k1C9fu5coVs=;
        b=JEiR+DMuR+qWIUrrGTw66HeSwqROSVbXqBZ4qGVcwISZs7/2mWOmsf3IaT3hiqR6mbRt4J
        4InDVaqCqgEOO9jPl/oqFLVIXHAtoO2wHewrpf3BiTsDCX/nf6lo0SLTKCrutrCGiob9Wv
        2o3k4I3+eP9BUj7nQQjaQMqVAZ0XiS4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-OaxLq3KxPmGkdrLZS2w1Rg-1; Wed, 20 Oct 2021 11:26:34 -0400
X-MC-Unique: OaxLq3KxPmGkdrLZS2w1Rg-1
Received: by mail-ed1-f71.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so21368160edb.8
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9eV6bAWxCLxc2CW54T10deAeKBJdgDr/k1C9fu5coVs=;
        b=e2j/vE5fY678YUxADS//BXKE67Ifx8E9eva+KJXb4Y1P5R4x2FaoFRlgLNmeGnC91v
         LnblfJLR3jd60osHxuPkHVmsS6Q5ommxrY9wVP6vCcid3ETMc3KYFStAUyDQ8BSY+Ex+
         EpcDlXQ+kqnj92BqS40OBJ3iGeCxwtaxAoy26eaNj7j9S0QqKdszZV70eQSktxG4Js/l
         qqRKjt1iyIBewrCGj0TMveRC/9SnScyLrj4GSKT5tPUclS0iRzhhoYUppwcMIgM4d9qW
         kAj8dVhCHBSJUnr10ltppNJ7yz1SZVYWJCE8XMwpD6S/sGF3jkHUfo+PLBT05NRayjZ6
         1xkg==
X-Gm-Message-State: AOAM530mHk+DLcfNPn59w8fjkEJ2HS6Jisq7h0shx8hvnp+m/zy+mNOF
        JsvvrWbMWpC1/d1EsIMyYXJRqx0WhFInjy2ETKcOOzGl8ifGGCsItYbbCAjkdyjPI7SB/TeS0Vx
        MnRC11WMwQSQ7
X-Received: by 2002:a17:906:3c09:: with SMTP id h9mr205661ejg.565.1634743593535;
        Wed, 20 Oct 2021 08:26:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFO5pYJnkMnW4v73cGdCSvog/8XPoS1QNKlg3H2UZkFwM0yhwHQLOjBYFGftiaKDHLdyiW1g==
X-Received: by 2002:a17:906:3c09:: with SMTP id h9mr205627ejg.565.1634743593305;
        Wed, 20 Oct 2021 08:26:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y21sm1199757ejk.30.2021.10.20.08.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:26:32 -0700 (PDT)
Message-ID: <e1e6c07a-132d-ba11-cca2-282315b23eb3@redhat.com>
Date:   Wed, 20 Oct 2021 17:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86: Move IDT, GDT and TSS to
 desc.c
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-2-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004204931.1537823-2-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 22:49, Zixuan Wang wrote:
> +/* In gdt64, there are 16 entries before TSS entries */
> +#define GDT64_PRE_TSS_ENTRIES (16)
> +#define GDT64_TSS_OFFSET (GDT64_PRE_TSS_ENTRIES)

No need to have both; in fact the definition can also be changed to 
TSS_MAIN/8.

tss_descr is completely broken in the current code, I'll send a patch to 
fix it so you don't have to deal with it.

Paolo

> +extern gdt_entry_t gdt64[];

