Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AC84294B4
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 18:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhJKQq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 12:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhJKQqZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 12:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633970664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5eQ2fdMZRopXBrJf5sFBVPsk6Ix/lYtLMtjFnBm+68=;
        b=KZUYjgjYEPFEq2CLQxRc5Q7lPEbPCfDEh/N4tcEr7Y7IVHgHozWwAWEERgClDkXo1FFG1o
        zNeZM1u1XBb9I25+2AOsMH9X7543gf+oZgLt84dNAzzld3+KTSC8ArqgKgfVY2qMdO30lI
        QtsgSPXNYVZgfAjPsI9TmJVoyFM5Pgw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-1bu2nOTlPc6ggicf7Hiwfw-1; Mon, 11 Oct 2021 12:44:23 -0400
X-MC-Unique: 1bu2nOTlPc6ggicf7Hiwfw-1
Received: by mail-wr1-f69.google.com with SMTP id l6-20020adfa386000000b00160c4c1866eso13743052wrb.4
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 09:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v5eQ2fdMZRopXBrJf5sFBVPsk6Ix/lYtLMtjFnBm+68=;
        b=3zgylXLeBFruIdSedyUyawoB6vcQi8wg3EMCDGPQEcrbW4MUV4qLu7tsISSEx17/ic
         +w6y5oqDRbvzG6JAVutFgWc3JUMhW/M+FJaGXPz9ELXyUnRmtBmvNWCjt9lfDU2Tnmk4
         jVcbO+La51OPQskptd7tRurvjuQzDv84zzZJn5ehYAJPL+g8vnfelwJHAugnsQ5gV1lN
         uD3iyj/9h+ZTnTOqDvgYS9y4ybD5bILQEMKsPswVm5lmso0BIIehSYU4poXAOfSEzV3X
         Ukv/GoATCxAkYu5Fw9rljLTJ9ZBjsG9CvNnV723yp4iHCo0C1enuIqP+/Ib4RTF16HHL
         Swtg==
X-Gm-Message-State: AOAM5321r0fzE2V0l+IH+MSCD+r7GGwE+SYyIgFdYr9Hf/dV5JbCLfRk
        TjTRA43oOullZ6POdAuVSMjYX0aCWD+TTGV+8vRx9QuwTB21vXlzfjDLu/RjIEJIPwW38Zl0WaN
        e/ujeZzp/TdS4
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr5575wmg.129.1633970661893;
        Mon, 11 Oct 2021 09:44:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkNV6u5+zpDaiAm71jlzVLgMlxlreNuF/u2+P+xbwTXuHkkQCV+OrxvNWndTmUCXbtqs4IEw==
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr5550wmg.129.1633970661692;
        Mon, 11 Oct 2021 09:44:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w8sm5647263wrr.47.2021.10.11.09.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 09:44:20 -0700 (PDT)
Message-ID: <a2142175-c0f3-c511-4a55-ad22fb732af0@redhat.com>
Date:   Mon, 11 Oct 2021 18:44:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 3/4] KVM: nVMX: Track whether changes in L0 require MSR
 bitmap for L2 to be rebuilt
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20211004161029.641155-1-vkuznets@redhat.com>
 <20211004161029.641155-4-vkuznets@redhat.com> <YWDaOf/10znebx5S@google.com>
 <87zgrfzj9k.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87zgrfzj9k.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 17:13, Vitaly Kuznetsov wrote:
>>
>> The changelog kind of covers that, but those details will be completely lost to
>> readers of the code.
> Would it help if we rename 'msr_bitmap_changed' to something?

Yeah, what about 'msr_bitmap_force_recalc'?

Paolo

