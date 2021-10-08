Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D995426A13
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbhJHLtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 07:49:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243302AbhJHLsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 07:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633693580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lh+diEwAf8U3ReLTasZgr3/j+zvIsi8Y6VYOcH4j0ls=;
        b=fh1w60f55yvNQiFBxh4nMGMyAB0OZB9cCT1g6P3flUpMnTY7LXG2YA2CnQx2qrmi1/NqFN
        VBSrQCqwHophcRpkyfjgxR2BNV5ijJ+6eP4g9aYHbuQNRlBHiHbY6gNuI8GQwtupMBmYV1
        PTNRNM1x6Z72t6YPlDd1E0NxxIVznls=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-v6AOyJMxOuGv9qhTsBQ9WQ-1; Fri, 08 Oct 2021 07:46:19 -0400
X-MC-Unique: v6AOyJMxOuGv9qhTsBQ9WQ-1
Received: by mail-wr1-f72.google.com with SMTP id 75-20020adf82d1000000b00160cbb0f800so6348960wrc.22
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 04:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lh+diEwAf8U3ReLTasZgr3/j+zvIsi8Y6VYOcH4j0ls=;
        b=A0LaoDawaGR0n2ELtdT5RAh4FjFV+yM2ryRiHXLrQ6fL6KuE3nIErgykV9Vl6zdYwC
         BS3X70365ZTywX/vEQ4UPuGzfxCK0r3nqVEEMH7FTsEuBdJQ6EhQbFRJT8imCMUfnX2H
         sj9vIGTBSW0tDF/nFlfvD5s/jC9DNyT25ibV78DW4O7FdWHXmZbuoFb6PpHW+uNRhdoe
         t/FsdevFWjj26lc+dVgjUg8aRxmYG6rQzt4OaZ140dEO4pmZBGqa/YZKuhOZ3zYzyREB
         Chp5LD0jSP8tgFc0u0uH9gcckYdWanGhgxw960TshCDUVX8jv/TNuo6HJdWIYfKM30NW
         Mu4g==
X-Gm-Message-State: AOAM533ZrIxa1TKZ8o0vJOgeR6QwwU31fAZVQgBYFzAv7HMZbSGmYk71
        K0SW+eStZJZtUeZIVPFOmoZ0wpn03u8/3YUwgxf3Nk49L9SxL0dzrpWiudbY3tlL+u/EmO3rmHn
        nEA3v/4CgC8Qm
X-Received: by 2002:a5d:4eca:: with SMTP id s10mr3354525wrv.290.1633693578103;
        Fri, 08 Oct 2021 04:46:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxen0P/zZgCn2jHENZdGynWMKtpMJlE0YDux4vIqlCdyBrGUI/ELpDzW2sAkC1c700Lwvbrzw==
X-Received: by 2002:a5d:4eca:: with SMTP id s10mr3354491wrv.290.1633693577894;
        Fri, 08 Oct 2021 04:46:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o8sm12665914wme.38.2021.10.08.04.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 04:46:17 -0700 (PDT)
Message-ID: <8c3b3841-1daa-64aa-b2be-8f0e54a96df3@redhat.com>
Date:   Fri, 8 Oct 2021 13:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 16/23] target/i386/sev: Remove stubs by using code
 elision
Content-Language: en-US
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eric Blake <eblake@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-17-philmd@redhat.com> <YV8pS2D8e14qmFBq@work-vm>
 <6080fa16-66aa-570e-93c8-09be2ced9431@redhat.com> <YV8s2r+lNyP/sX7u@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YV8s2r+lNyP/sX7u@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/21 19:22, Dr. David Alan Gilbert wrote:
> So that I'm fine with, the bit I'm more worried about is the bit where
> inside the if () we call functions (like sev_get_cbit_position )  which
> we know the compiler will elide; I'm sure any sane compiler will,
> but.....
> 
> Looking at your example, in cpu.c there's still places that ifdef around
> areas with tcg_enabled.

I think that's just because nobody tried changing it; it should work 
there as well.

Paolo

