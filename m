Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA35421917E
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 22:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgGHU26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 16:28:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgGHU25 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 16:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594240136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tKlR3ZjSGkU94hKtcspH+LSF41vCI5eSTGDezrwB8ao=;
        b=MNK+SaOC30eAULtpDFpBdLFgVQQHkfFwzwUwaMifWg5GTvFF7BlIr6nXi4HXGnPR1EejzI
        IMP/zAoMa4La/7C5MCbEy7lLEKsRrukMpU4mUKPDD7jZVXm4bCvTDohnflNaAcpTxkSkSa
        9mxI949fNhGZAObRuOyAihkzDlz49D8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-Iqw3zoWAPEO4VhhsahJVWQ-1; Wed, 08 Jul 2020 16:28:54 -0400
X-MC-Unique: Iqw3zoWAPEO4VhhsahJVWQ-1
Received: by mail-wr1-f70.google.com with SMTP id v3so23389071wrq.10
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 13:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tKlR3ZjSGkU94hKtcspH+LSF41vCI5eSTGDezrwB8ao=;
        b=L8DX71sGz7s7V6d1kTGmg6xHjSLTIr1g8uSsx/5E9JdmsepchJBKA/w03iC2yHLjXg
         hVlz4MlKfwmKQ6uOHEjsnM0ds6JQjzePw/C4a/iHZSSXtMNf8LSdT9rtJXfpPyfMQxVU
         +l57LzUEmizTCV36J2MUkElU5AvfeQrZhMkzlHlUmTuQV4bPuOE/hsBddYplzOgic6Oi
         7XcCYX4nxv2TGPoM0Ek1u6Va/1Dd/kA+PN5lSaTosKRlii8Yakr8Yke1hGBp42qURZQ6
         0zyBlYzmRNu5Kq7OkUyyXfpZ8UXa6v7hyHp90eHD+aAT88NqhHVgD48/GmdhxRH+xcyD
         FxaQ==
X-Gm-Message-State: AOAM5327AVy/fvgphY27TV0MF204MB0lu81fzf2zoBAl8WsU0ZiKNpnX
        w1vlAXwRq28VgPAaCc0Dg9d1ykWEZX30i/o3GnIiu2/vfxlK+pXFspZOCqzXSVVeWXP4XAt82BZ
        BBeQvSvlAyjvr
X-Received: by 2002:a05:6000:1206:: with SMTP id e6mr29803848wrx.346.1594240133652;
        Wed, 08 Jul 2020 13:28:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymxGVgiM5r72XA6vzEjzcO7z2KzQpDxACkB5nl5lRy9YvNMCQdsG72gOmEThXjiJuxHh5pBw==
X-Received: by 2002:a05:6000:1206:: with SMTP id e6mr29803834wrx.346.1594240133412;
        Wed, 08 Jul 2020 13:28:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id v3sm1664758wrq.57.2020.07.08.13.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 13:28:52 -0700 (PDT)
Subject: Re: [patch V2 0/7] x86/kvm: RCU/context tracking and instrumentation
 protections
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
References: <20200708195153.746357686@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b17c3ed-e53c-2e20-2880-882fdc84f622@redhat.com>
Date:   Wed, 8 Jul 2020 22:28:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708195153.746357686@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 21:51, Thomas Gleixner wrote:
> Folks,
> 
> this is a rebased and adopted version of the original series which is
> available here:
> 
>      https://lore.kernel.org/r/20200519203128.773151484@linutronix.de
>  
> It deals with the RCU and context tracking state and the protection against
> instrumentation in sensitive places:
> 
>   - Placing the guest_enter/exit() calls at the correct place
> 
>   - Moving the sensitive VMENTER/EXIT code into the non-instrumentable code
>     section.
> 
>   - Fixup the tracing code to comply with the non-instrumentation rules
> 
>   - Use native functions to access CR2 and the GS base MSR in the critical
>     code pathes to prevent them from being instrumented.
> 
> Thanks,
> 
> 	tglx
> 

Queued, thanks.

Paolo

