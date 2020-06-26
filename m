Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3420AFF6
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgFZKnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 06:43:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728060AbgFZKnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 06:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593168216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBNi3jdL0zQvZSJqmxN3mS/J04iKYWSdEMxdlM+rPp4=;
        b=HcbuiNoOZ/yjDP9tQlVicVFTJrD0Fmu+L7SB1tbjhHb+PzdTBwtvFYZMvO3kd1UETRvAZD
        IqH+tzMQiDMb34X0PfX8aqJKLPy16rk/XvqfBayuGQ9NvCq56vKfLVACBT3cmBenUFFz0H
        FXgIjpIhNPLGqsb5klxpC0BAcNR2WLg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-TGx5uyXiOCevqhEX3PFaHQ-1; Fri, 26 Jun 2020 06:43:34 -0400
X-MC-Unique: TGx5uyXiOCevqhEX3PFaHQ-1
Received: by mail-wr1-f72.google.com with SMTP id c18so2773274wrp.15
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 03:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBNi3jdL0zQvZSJqmxN3mS/J04iKYWSdEMxdlM+rPp4=;
        b=aROx1tzcfJp6RpNEZY+XBqiPd2Z9LYfldAXpWjxrFbxs6ugNB/QW9DEaXEYcFiFTmq
         zBpvRMbd4l8Yx9Gy2XPaHTm1tNp6pW4gaKEhwaL35JWzVtuOCWRWmoMlY7WlH2MgaS0U
         8x0vvym4Ut1djYjP/6bNGFWo4+R9sjHqRe0NKmYc5DXNlBMqojoJB4qWo8G3y74gLiR4
         oqV8jAjCPj0qf8BS1hE+TbOmbhqQaoO7Nr6Kf3yxAEKSpFaPvngLPaP1sH0ZJMVmOBAw
         7HKVSf3VVhGu4kQL1Pt7LqSO2KZN/WVfil+sOyvz8R9RhRvu4fkn6x375C1O2ZVBUiAn
         QgNA==
X-Gm-Message-State: AOAM533KF38pMkBFvaiWHBP/W+6bhUU5+7YPtsTll2Ab1LVAUW+zVI/3
        qaJItBT9c0Gmwv+Jc9zRGcm1bsHS0ZNTdBKue9JfUcyorDBl87//gK43uVvdWGjzSLicnq+/hz2
        KeTFV54wjSYfT
X-Received: by 2002:adf:d084:: with SMTP id y4mr2984723wrh.161.1593168213597;
        Fri, 26 Jun 2020 03:43:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdWE7r+TMpE/MvLwAtwwnPcK4pPBtsm2Qo4mJKWb1qHJpG6r6cGHObsZ347i0di+5j/BGAuQ==
X-Received: by 2002:adf:d084:: with SMTP id y4mr2984712wrh.161.1593168213433;
        Fri, 26 Jun 2020 03:43:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id a12sm26290603wrv.41.2020.06.26.03.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:43:32 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/3] x86: realmode: fixes
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200626092333.2830-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4eff4ad1-948e-94d4-4645-7dc8edf5fc8e@redhat.com>
Date:   Fri, 26 Jun 2020 12:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200626092333.2830-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/20 11:23, Nadav Amit wrote:
> Some fixes for realmode tests.
> 
> Nadav Amit (3):
>   x86: realmode: initialize idtr
>   x86: realmode: hlt loop as fallback on exit
>   x86: realmode: fix lss test
> 
>  x86/realmode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

Queued, thanks.

Paolo

