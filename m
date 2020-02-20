Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C2C165CAB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 12:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBTLXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 06:23:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32334 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726837AbgBTLXH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 06:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582197786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1D/6Qr3qzvdKaXRL9O6aJSFtYLJpaNfAiBHV63Od7ZM=;
        b=TC1GiijpFJwEoI73YTMpp8UwsGNBGxnFkk7LPltTzgy/eVOV2t6V8WSHXoUbhQCNIzpmEW
        aQiVTQyCINMMwCggwWmnHzNTZO3X4XgB+1MQj1VUHAOVelLK44A9EEwJZsNyxSDjwMGOx1
        y4Y8f7yYfU0PImGAAw8tE4pSF8TpVIs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-ccu6_SEwM7OpFEjp6Je7NA-1; Thu, 20 Feb 2020 06:23:04 -0500
X-MC-Unique: ccu6_SEwM7OpFEjp6Je7NA-1
Received: by mail-wm1-f72.google.com with SMTP id d4so491132wmd.7
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 03:23:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1D/6Qr3qzvdKaXRL9O6aJSFtYLJpaNfAiBHV63Od7ZM=;
        b=i2WmWXvmp+XQGnKMb3JP1HVUf7RURGuboqjhK9xx+6c2dokC7y0JmaBbLpQph37rlQ
         3tSScu+8rxhfSWMqCwwgfS/+zg1FHRoDf2OpA434/41ywywk0bHWT5x6BTrCly6KmJ/0
         MV8g8LNrcLjDDtwyCPPTHHX5vQRnYHviqqY2razuyR66MK6NT4Ygr2cMHo8oHQLqxYpe
         Z2eGbSj3Mt9jYM1e7pAXp6yLFChM5EahZJ5NS4kyh6ffvnlwCWPeray29hVgiWCwu6NC
         JKxy4pq7RounWM4ZGvotTcC2iJmBpWx4lEKBW0XsNYJ8mtzu3/jQuEtcA8ANsTg2Xqi4
         KYnw==
X-Gm-Message-State: APjAAAVTCWcno37MHLx/cd2mAyKyVfKMjEN9kamW8XD35I7BnyO4nDtH
        KCllw6hK2jUZTXJmTZSYWXzgTmoD8Vz021xgM8m2OG9YVOzZxFTbEgko77NmvI9FbL1ZxLdMg96
        FxI2ukbDOVUUL
X-Received: by 2002:adf:8b54:: with SMTP id v20mr43504674wra.390.1582197782817;
        Thu, 20 Feb 2020 03:23:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxY0CwAOAAf0Ljm6MAlBP7nPhwZYcP3yjr1rUPr2Ecl8f3lhHh16aZ+2ZHTWWvCdrnhYZARfA==
X-Received: by 2002:adf:8b54:: with SMTP id v20mr43504653wra.390.1582197782601;
        Thu, 20 Feb 2020 03:23:02 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id e22sm4135437wme.45.2020.02.20.03.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 03:23:01 -0800 (PST)
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org
References: <20200218184756.242904-1-oupton@google.com>
 <20200218190729.GD28156@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com>
Date:   Thu, 20 Feb 2020 12:22:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218190729.GD28156@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 20:07, Sean Christopherson wrote:
> On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
>> Particularly draconian compilers warn of a possible uninitialized use of
>> the nr_pages_avail variable. Silence this warning by initializing it to
>> zero.
> Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
> Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
> (hoping?) the suppression is no longer necessary.

What if __gfn_to_hva_many and gfn_to_hva_many are marked __always_inline?

Thanks,

Paolo

