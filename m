Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A00420837
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhJDJ2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:28:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231869AbhJDJ2D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633339573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UpqA3RAtB68rUMSfW6XEZltEn9tatTT1LRY0PkKsI3I=;
        b=YV+Bg/tVManfQo8vB1Al1sCz+wFfhncmYOlbWNBfWDG0qHUdJPTAEFZU68uHzECNYRKz0x
        plvQAsHGozyOJFpCoafP/4YVbFgheGqhUqKDKdTje+jUxJd0Gkm91I7PZcYDGrPTRyTA5w
        kPhIiwU6l6CFKi9IceQvz2Q9bG54D4I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-bQQSu4snM_2AdhssoifUpQ-1; Mon, 04 Oct 2021 05:26:12 -0400
X-MC-Unique: bQQSu4snM_2AdhssoifUpQ-1
Received: by mail-ed1-f69.google.com with SMTP id 1-20020a508741000000b003da559ba1eeso16656050edv.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 02:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UpqA3RAtB68rUMSfW6XEZltEn9tatTT1LRY0PkKsI3I=;
        b=CnS0WA1xxLY4sKP7TcWVfKS3SDKXgAGPlYYXNNR9eIrZi/gAtkKprLOb1Uzs8XOUiq
         AAdOkNCda4ghHwGB3CenVvKDj4C73/7E6+p9JeOxgEewaLDmyYVnr7yNsnVViHxMxK/u
         gXzGWlt0CIbFSvUmqfm9hkWxz30JTzNSFDRGqyMvU5gnZskOrZXXfAi8/aqXwg9HlI/r
         poXuyf2S+CUefRSBrgyLmGKheFKcYVsQefn05PzKBwGCe2WEZl57O4b9rHLyXmm+Akc/
         /kGd/xWS29zjwFQYOKQH6Pgtej09oPVbdQqv+JsOmbPPhVUpHH2qTCl6AV2lBBjkpEue
         xe1w==
X-Gm-Message-State: AOAM531QmBOt43TiCTYnuPe4B/lHU1jLiPTFOMo22MteCPzoInNgaCGi
        sEr0CUlnJ/a8aj8apon9JigFuXi4VHWuBnF5rYBpg4mTpvIryO42fLkLHIw0Mz3RMuJaRxvPfc4
        b3v70Og23ZGzR
X-Received: by 2002:a05:6402:203:: with SMTP id t3mr17170044edv.69.1633339571638;
        Mon, 04 Oct 2021 02:26:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw47lRVXBkGbFFJrfvZQZTC8jubY5rVVRVe3osrFc1yxjdC7v8pzjWaCW/Gzd5a+bZ9PbBGDA==
X-Received: by 2002:a05:6402:203:: with SMTP id t3mr17170024edv.69.1633339571429;
        Mon, 04 Oct 2021 02:26:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id jl12sm6092783ejc.120.2021.10.04.02.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 02:26:10 -0700 (PDT)
Message-ID: <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
Date:   Mon, 4 Oct 2021 11:26:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
Content-Language: en-US
To:     torvic9@mailbox.org, "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
References: <1446878298.170497.1633338512925@office.mailbox.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1446878298.170497.1633338512925@office.mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 11:08, torvic9@mailbox.org wrote:
> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> 
> In file included from arch/x86/kvm/mmu/mmu.c:27:
> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>          return __is_bad_mt_xwr(rsvd_check, spte) |
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                   ||
> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning

The warning is wrong, as mentioned in the line right above:

         /*
          * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
          * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
          * (this is extremely unlikely to be short-circuited as true).
          */

Paolo

