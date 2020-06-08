Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E676A1F1B32
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgFHOno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:43:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37211 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729989AbgFHOnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 10:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591627422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCu4klvK8WqDG/7fqy7QMZOQkd/Lpx79HGToUSh8N5c=;
        b=Ae+/Goiqgjb0H83tFY9+X/1ufpVxUgje99A9y5GWdeTLlAHxh17r79qoVmBxEqIBc2Sf7G
        PLOddJKQyiyZ9JGzLocDM+GRRGFyCJjgLaLbDm87SEgqFPr/bLZMrLWG9wf0f5aBI6zFeJ
        /2+SXB18TKO+kTyA/SBhmHx79n/Oc9Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-I28IqFn2NYOBR2ZDltulLg-1; Mon, 08 Jun 2020 10:43:35 -0400
X-MC-Unique: I28IqFn2NYOBR2ZDltulLg-1
Received: by mail-wr1-f69.google.com with SMTP id a4so7246465wrp.5
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 07:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dCu4klvK8WqDG/7fqy7QMZOQkd/Lpx79HGToUSh8N5c=;
        b=px6J4MgKlqesi72S9v5Xg2ZP7WOq+lefJ7x/8etSojPMhjyP5cMckKpEEx7Z3V8Da8
         DKbpwCZvGiUE3ZeLnJNuvs6qBaezLqtnMaS8Djq5LxGKAHfmrCn04WRSR4wzF7YhX17R
         hCSu/wH9lSQHAJ4joBzMBVI+58zRxKOL8asKVsYn062DvhezB7R8J8f4DSu7aFvz2KHh
         y/ENo3sZYB68tR3EmykLcr7Xk8gs4sG09kW75R78V/B0oIbQy1RBiXDXHKL2sXQA94ta
         dq26er2JOptrs2e7MLSCf2maEkZBKH2X/0DMOaWQ17DSK9VsZyEY8y627TdKrMgpMhF4
         xfVA==
X-Gm-Message-State: AOAM5329mMKR0WO1VulB9VT01vufmMwR0FqfpS2veZztDUSc5mEAos/3
        CuWwRK5tnZ402nDLf8mEdkpFtZuPxCvAe0mGQaB6X+UPcg4pULywfd0EjnhJIWOQfHUvslKZY7R
        eaeonOj7ACQVB
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr17379006wme.41.1591627414623;
        Mon, 08 Jun 2020 07:43:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdXdnqTWlVa3j79SWNzN7JbE0jP7z5+vx+TBdN9i5XhxydAeK9f7Bns2HfpNfKKDsLlJwjEw==
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr17378990wme.41.1591627414384;
        Mon, 08 Jun 2020 07:43:34 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id k21sm24574254wrd.24.2020.06.08.07.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 07:43:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: selftests: fix vmx_preemption_timer_test build
 with GCC10
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org
References: <20200608112346.593513-1-vkuznets@redhat.com>
 <20200608112346.593513-2-vkuznets@redhat.com>
 <39c73030-49ff-f25c-74de-9a52579eefbe@redhat.com>
 <20200608143859.GA8223@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b2a36b7-69ad-7cce-fec4-2df70f867fe2@redhat.com>
Date:   Mon, 8 Jun 2020 16:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200608143859.GA8223@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/20 16:38, Sean Christopherson wrote:
>> Queued both, thanks.
> 
> Hmm, someone go awry with your queue a while back?
> 
> https://lkml.kernel.org/r/ce6a5284-e09b-2f51-8cb6-baa29b3ac5c3@redhat.com

Both that one and "x86/kvm: Remove defunct KVM_DEBUG_FS Kconfig" were
queued for 5.7, but Linus released one week earlier so they got lost.

Paolo

