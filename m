Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3932B5DE8
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 12:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgKQLEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 06:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKQLEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 06:04:45 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C969C0613CF;
        Tue, 17 Nov 2020 03:04:44 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 1so1321019wme.3;
        Tue, 17 Nov 2020 03:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rOaJF6sxlfFSahGzMed0tR7LlFvBke/MI1WU7Gd8cdk=;
        b=NFPX05QKHgHmo7GME58le2xewfdkwEflb3rY9BaSq+L3qzh6T+2i+sQ4TADpUb2+Ze
         Y5yZfE7ZRKtwwYCIXVDI3aLjCF2nQaJ+6FwyPP7R1WcXeBe1CYtMk3mZ39RXCcwsulIu
         g82v65KKB+JlXL4/WhEtaBFMArHzDDtiY32aYtQwnuThw8l1kDKlILpCrv/pzBWi0Fed
         R5TUyVEmJ8wIwMRSGq06hhtJ44IXctkzSY3GoA+V/nhyk0tut6r2KGajEuRbr/ENfD3i
         RCWiwUeFVYpOf2RojV3ZMr6o8csQohwsKqP8+wQUGY2OyfIaRsEwcV612jognuV0INcr
         VKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rOaJF6sxlfFSahGzMed0tR7LlFvBke/MI1WU7Gd8cdk=;
        b=sffI2Tt5EXqXzpKAksakU2bNPL7a0ZQTPjbfdyNiEyT9Klqwf/8+gH77XYJahC8YTB
         oj0faQKxJfLuo+AMyZdZpKMPtxwBYaf/2j9lIi1DhdeSFq68TxXGAUCu6cbFuxF9bOtq
         ChjBjgxHZL1YhHV/xgZ7ATB6Q9CUkF2UuCWRBvnu4R+a+MHIFAjc1qE7rdZP3wfr9k3u
         GstrjqWrn/pjrYT4M1hxwRxdJEcb2ViNBQce/E01TIanOPPYw4QqyWyUnQ2f21OhVjFv
         hUgAthyOWoQvtu1ZoNvsAGytItLGw4soxPw0+XLv4pNJURC1Nx/QpcE2ZqTMLQhg5epY
         wedg==
X-Gm-Message-State: AOAM53193fMkUahkfzNJfFCNDcdTQfRI/wn1j8/ic/JivZ7PUo/RPJub
        QugcAgzGnKuwJqtObdGWFas=
X-Google-Smtp-Source: ABdhPJwOAgFYO4Mpln0IO7uONcF1bnKVn80AtWHkGz/Yiu3U4Nwe3vYitCywHhvciVa0p0YiuxQNcQ==
X-Received: by 2002:a1c:3907:: with SMTP id g7mr3683736wma.176.1605611083335;
        Tue, 17 Nov 2020 03:04:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t7sm1886255wrp.26.2020.11.17.03.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 03:04:42 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Add existing trace points to TDP MMU
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20201027175944.1183301-1-bgardon@google.com>
 <CANgfPd8FkNL-05P7us6sPq8pXPJ1jedXGMPkR2OrvTtg8+WSLg@mail.gmail.com>
 <0751cea5-9f4a-1bb9-b023-f9e5eece1d01@redhat.com>
Message-ID: <4f18ac24-6c81-f8c2-8f88-bc33cb7c3cba@redhat.com>
Date:   Tue, 17 Nov 2020 12:04:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0751cea5-9f4a-1bb9-b023-f9e5eece1d01@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 20:25, Paolo Bonzini wrote:
> On 16/11/20 20:15, Ben Gardon wrote:
>> If anyone has time to review this short series, I'd appreciate it. I
>> don't want these to get lost in the shuffle.
>> Thanks!
> 
> Yup, it's on the list. :)

Queued, thanks.

Paolo
