Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F86366005
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhDTTJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233509AbhDTTJE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 15:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618945712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzIxCQz9dJkrU2k2A9+BTpoRFh3xXkAwoj6J7/2c9z0=;
        b=XSJ5tq9mS+uN7Nis1PVC5/J+xvlBbcclre5aSEpQxp5PzERPqfYyijW/uefUuoc/GSkbe+
        T3KQ1h/CtkImVMcXmSX1lAcF23xw1uAhTKSsq6ZqZLaImvc4CTx9Mf/eTk0rQIZVyhhoBl
        ULDw1m0vpaK4PpH8UY2MOZ2xF9yAilo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-eEQRNO4LNkiD5v3oqvjSzw-1; Tue, 20 Apr 2021 15:08:30 -0400
X-MC-Unique: eEQRNO4LNkiD5v3oqvjSzw-1
Received: by mail-ed1-f71.google.com with SMTP id t11-20020aa7d4cb0000b0290382e868be07so13624441edr.20
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 12:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xzIxCQz9dJkrU2k2A9+BTpoRFh3xXkAwoj6J7/2c9z0=;
        b=NBCWdnrG804/GGus0Q1qwswbj30zwsZEmag6vQRs9WR3xty2q1CHV9E4ZCD5ZofN8l
         usXPtA2HCtuecHhBGIPU9oZeq7ys0CBYAHPryv/s6g+097DI6zw74iJvfu2DB1CtUAOm
         KWB6lMBAWp0vYVWFCh1L+A9NA3eIzIu5OmaG9uzkXZb574v6PUGFjxM29/WUJ4liM3gm
         bQy8SiW9+xQpQjL0qzTLgXOlvpYkTnqI5jO5/ub4tLZebGZmGPe5gscbLn9V6X/RXiLK
         HI+lPU0jXSsn4JUT2DHTwmcSqUdwl2mEtCfsylEeHAmIEbvD2dhXn1TBBFQs5aqP35PH
         A4tw==
X-Gm-Message-State: AOAM53150/1Wzi/Yl4Zqi8N1jNETwRcxj7aE/wmHabf7skFF/PNx6xBl
        ednxw5+EqDGk0IlK/+BXiHnkihFCLFMLbO1v9z6qgUMFGLrNiDZ8k0quxunW3B1lL0ybP/7LPeR
        GYQvuVIkvHL4U
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr16664467ejk.443.1618945709508;
        Tue, 20 Apr 2021 12:08:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGqxHNHbZCDe6mb7p2nY9TIgzHG0FAEjVhnv9ou4NsLim5ASSKjnjjCS5e+6dzUm7Xi6wHGw==
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr16664445ejk.443.1618945709367;
        Tue, 20 Apr 2021 12:08:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g26sm13413869ejz.70.2021.04.20.12.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 12:08:28 -0700 (PDT)
Subject: Re: [PATCH v13 00/12] Add AMD SEV guest live migration support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <65ebdd0c-3224-742b-d0dd-5003309d1d62@redhat.com>
 <20210420185139.GI5029@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4deae424-85c1-57a7-3952-23d1d65e30ab@redhat.com>
Date:   Tue, 20 Apr 2021 21:08:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210420185139.GI5029@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 20:51, Borislav Petkov wrote:
> Hey Paolo,
> 
> On Tue, Apr 20, 2021 at 01:11:31PM +0200, Paolo Bonzini wrote:
>> I have queued patches 1-6.
>>
>> For patches 8 and 10 I will post my own version based on my review and
>> feedback.
> 
> can you pls push that tree up to here to a branch somewhere so that ...

Yup, for now it's all at kvm/queue and it will land in kvm/next tomorrow 
(hopefully).  The guest interface patches in KVM are very near the top.

Paolo

>> For guest patches, please repost separately so that x86 maintainers will
>> notice them and ack them.
> 
> ... I can take a look at the guest bits in the full context of the
> changes?

