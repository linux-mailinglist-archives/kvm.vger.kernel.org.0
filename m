Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6B0171118
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 07:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgB0Gl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 01:41:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726602AbgB0Gl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 01:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582785714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3WtQm8cciAT/fjByiLCd+SwYSU+Wsh17sH8Rz+Ha9TQ=;
        b=dU7AHXyuYYKpvTIZvdq4Gv6uPyukw0O3nXhpyWq/5+jNpOUHcybiMhRezGsvVQLVMT+7GN
        JE0v//XU6QEjTpt+qjnPm/XEiRUU/8Ya5b2zzrNIb1AsVnyDTuzZNkK7PmhBlGyE+USY7j
        CR33O+BnwEcV5JCuOJkZs4BG57PNE+Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-28J9UUYfPXCE9ibhziC52w-1; Thu, 27 Feb 2020 01:41:53 -0500
X-MC-Unique: 28J9UUYfPXCE9ibhziC52w-1
Received: by mail-wm1-f72.google.com with SMTP id 7so324446wmf.9
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 22:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3WtQm8cciAT/fjByiLCd+SwYSU+Wsh17sH8Rz+Ha9TQ=;
        b=KoYXUVYFoiVD+/C6fW97expLzBFx+pP2uQlMyBFuSQHLD87arttTUhSFScuFK2JV17
         6TdaE0bB5hRhsQJLHqxj9cbbfZCVeHciHvej2qYnk3sU5KmH/TXhpCc11fbz6roB06z+
         aFpOXplnPeLGVK1M9i5hOeb55gjhDHIJV+kZUNiU6FphSjOsmIfzJc+T7UZSzaBQ5wEJ
         srCHrsmJCz+U6LNiTtm85ZMioETc+KAouIYYXh39xipQwzztkeQgKiR47BZjuh5/L3ru
         xlcuwyV2sQhoXc+Bq5hP9M4I2d78031/HRj7qwJ7sbQje5xbozsfHDoWYrAwPOVkOxEI
         8/bw==
X-Gm-Message-State: APjAAAUBAFjmnO5yJ4srjORUbPaXjXBJbtbbZcEyd2S+YYF5QvOoXqdO
        AKLUSpj9dIfSEz/HOPN6oyQiHPovOYNCY4J9NmFt7jQMYAtCWr2OBAUXiATM+4jENq2YHeB+e53
        tN1aW30OFWCAk
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr2822677wrp.378.1582785712302;
        Wed, 26 Feb 2020 22:41:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqyArG/FMFCYBNGHUeD0cJCcpopv6q6Q0n5+XKSdmGhLCIy+1iyQ2uDjJJoigYpVcciUwPCVQg==
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr2822649wrp.378.1582785711971;
        Wed, 26 Feb 2020 22:41:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id g206sm5552090wme.46.2020.02.26.22.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 22:41:51 -0800 (PST)
Subject: Re: [PATCH] Revert "KVM: x86: enable -Werror"
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Christoph Hellwig <hch@lst.de>, torvalds@linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200226153929.786743-1-hch@lst.de>
 <87v9ns1z79.fsf@mpe.ellerman.id.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f31e38e-2f78-7919-7c60-a1761b9abb2e@redhat.com>
Date:   Thu, 27 Feb 2020 07:41:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87v9ns1z79.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 04:33, Michael Ellerman wrote:
> We've had -Werror enabled by default on powerpc for over 10 years, and
> haven't had many complaints. Possibly that's just because no one builds
> powerpc kernels ...

I looked for other cases of -Werror being always on in Linux before
writing this patch.  There are both unconditional cases and others like
PPC where it's governed by Kconfig.

I will add a Kconfig for now.  It probably should be made global instead
of having a dozen different Kconfig symbols.

kvm_timer_init should be fixed, though.

Paolo

> The key thing is that it's configurable, so if it does break the build
> for someone they can just turn it off. It's also off by default for
> allyes/allmod builds because the user-selectable option disables
> -Werror, eg:

