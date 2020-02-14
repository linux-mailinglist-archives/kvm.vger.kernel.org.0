Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717F715F6EA
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 20:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgBNTd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 14:33:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729075AbgBNTd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 14:33:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581708836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UPIixaZTo637w7gbAg5h94awMsbkxhmjz3SnYWa8Jks=;
        b=bjSTP/HCFuhaecWzhahd+F/5gqhCxIeE8GEg7+e7gp2l2OFCM1ch2bhvwLSNNkLtbdGxtl
        2N5LCI+3P4agYa+i6wgLNl+tZdjgtXGZ7ikTTC+mhGrFaKh6Fw3XHOZiySqYKR96cCuA3A
        9gIVovTezzb10hhVFLzUEQnUd9riIQw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-gd4WVI5rP5qFYSVL24rxOw-1; Fri, 14 Feb 2020 14:33:53 -0500
X-MC-Unique: gd4WVI5rP5qFYSVL24rxOw-1
Received: by mail-wr1-f71.google.com with SMTP id u8so4584069wrp.10
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 11:33:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UPIixaZTo637w7gbAg5h94awMsbkxhmjz3SnYWa8Jks=;
        b=R7zZyD6ofUAPEtL/gi+NMhQCBLhzwe3Ioa9xFhM1cT2GUj9kPUnJE6HsUzXhZgE5wD
         dhl6f/HtTHJNr67/uTSu42+5bGh77CJlVgZiAlN6xplOU7CxnLHtj9wTuMlgDrTVFikd
         +VcqXrz0efOKoKEqTyZ0ggdpLY/mV5tp3jS5t5sf2MUuPkN5yD4QPvvqW/tuw/MWhAJr
         l60P9/cJYAIKUOAdwdIZ9yx/1v7zpQBHvd2cKz1H1yDjeOa3Dn0u7YMWhzVrWLNkIQlY
         fzfzDNN/qUjKVS2tvVbP5e0hzxxfWFXDTTWn9whO3k/Eaeo67LTO9wcHSWV61CEdPLYE
         VtLw==
X-Gm-Message-State: APjAAAU2Y2p2bUZGLm8sdrzMUcD5D2Y4z5VEEqXvPhq7D9YbpOML5Jtr
        DjipKm1ymLmA2QDkdmuvcQP7ELw9/ON2G6SSAouHBUH5wCUJUNpSGI2bGa24uX5lcb9OVTUesrj
        Ew08+QnSLanlh
X-Received: by 2002:a7b:c851:: with SMTP id c17mr6052187wml.71.1581708832401;
        Fri, 14 Feb 2020 11:33:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqxsT15BbBlGYbrQrK/pBOJv6OOjWJfid3u8re60HHU3WUA4qE5D4E03zTsBQdyB9S0kA4ZJKw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr6052168wml.71.1581708832179;
        Fri, 14 Feb 2020 11:33:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id t81sm8513936wmg.6.2020.02.14.11.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 11:33:51 -0800 (PST)
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
To:     Qian Cai <cai@lca.pw>, Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
 <20200214165923.GA20690@linux.intel.com> <1581700124.7365.70.camel@lca.pw>
 <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
 <1581707646.7365.72.camel@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <28680b99-d043-ee02-dab3-b5ce8c2e625b@redhat.com>
Date:   Fri, 14 Feb 2020 20:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581707646.7365.72.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 20:14, Qian Cai wrote:
>> It seems misguided to define a local variable just to get an implicit
>> cast from (void *) to (fastop_t). Sean's first suggestion gives you
>> the same implicit cast without the local variable. The second
>> suggestion makes both casts explicit.
> 
> OK, I'll do a v2 using the first suggestion which looks simpler once it passed
> compilations.
> 

Another interesting possibility is to use an unnamed union of a
(*execute) function pointer and a (*fastop) function pointer.

Paolo

