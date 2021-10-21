Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8745B43643A
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhJUO3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:29:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231623AbhJUO3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634826444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7x2spmNSm74cr0wAgUB2pdUqCV5GYdCRbjeqGjf9Ms=;
        b=BkQtBe50BVrnv62Cb63m1xjCI5pqVEv/sXvJlsr3jLubPZt9jvO/vq6hxrgPcLF0NgmaX9
        T8CZa+fuHR21MM7im2zYppGC6aJfQ4V6ytE7qU1SblffNrA0OQfOc9T7TUH+N0KQ0wAnT5
        wvZC5vDC2Yf2tAdXJO1GQY7gj1FkhBw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-G0pSRvAPPMWHUhbHAibZ0Q-1; Thu, 21 Oct 2021 10:27:23 -0400
X-MC-Unique: G0pSRvAPPMWHUhbHAibZ0Q-1
Received: by mail-ed1-f72.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so534046edb.8
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B7x2spmNSm74cr0wAgUB2pdUqCV5GYdCRbjeqGjf9Ms=;
        b=5yA0pJ12A6C3H7DDE4q9RuB6nihKL6CyxmE01+hvoio5bUt3vLBdtGsnUYyNTAWFoT
         DPCkKRA5Iz7ZaFtkt9S89ecgg+WF8IhnVEGFcIipDK7MV6o04/GBOyVVgWtRvpnLGqiM
         yfuEjLoP8d1o+x6wfpfup5EmHOkXGX0e27X8B8HsBZwF0TJzkZa0ZoacrZvhLZfjv5Tx
         LACV5VLzYLOUPWSKnuUDmaQinNHQD48ZWyv0Cd/E8DSA1Zl3k1KcJVTEpI3Log+ZPXJu
         RrWc/9KLNGDagLkrNoYJnrnY2pbi51/JVWsZydAqmdy59Sq/iqotxrABP9m7Efri2bz6
         nKnQ==
X-Gm-Message-State: AOAM533Mzqp3yNmpadh5mZ4YoiZHkvQtGZFZ4qIJd+O43Y0BEOds7uVF
        KUqBJi14IZzlRmMroQ1IT3MXjedwddSS5t5xOAtqJMmn5JnPLw+cRyq8/znqrWerC7qggDPYpZA
        tsqRlIFqhUMvn
X-Received: by 2002:a17:907:2d14:: with SMTP id gs20mr7517802ejc.415.1634826442188;
        Thu, 21 Oct 2021 07:27:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBEDp+BTX2sdI3MFfnAek86kDPk4PYMovq2RqshGtA7ZCYyHKfNftXWE5Yf8mdUElhcjOeIw==
X-Received: by 2002:a17:907:2d14:: with SMTP id gs20mr7517767ejc.415.1634826441967;
        Thu, 21 Oct 2021 07:27:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id kw5sm2613320ejc.110.2021.10.21.07.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:27:19 -0700 (PDT)
Message-ID: <525709a4-be1f-8360-8546-ba22346d681f@redhat.com>
Date:   Thu, 21 Oct 2021 16:27:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 00/17] x86_64 UEFI and AMD SEV/SEV-ES
 support
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
 <CAA03e5E9BSLsuv5XQiMZGAL+MOqcbyWok0p6Z7U3m14W0p9bsA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5E9BSLsuv5XQiMZGAL+MOqcbyWok0p6Z7U3m14W0p9bsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 16:22, Marc Orr wrote:
> Should we go ahead and post it to the list (and perhaps update the 
> branch in the gitlab so everyone can work off of that)? Or would it
> be easier to wait for the GDT cleanup work to finalize, and then post
> it afterward?

I would say, just post it on top of the 'uefi' branch.  I'm not sure how 
and when it will be merged in 'master', but for the next few weeks I 
suppose it's okay if I get incremental patches, and either squash them 
or commit them on top.

Paolo

