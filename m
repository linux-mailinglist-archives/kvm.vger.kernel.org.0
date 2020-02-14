Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77C015D801
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 14:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgBNNKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 08:10:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29317 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgBNNKx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 08:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581685852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tk355w+VT5A6GLvgx0YR1ga+vZy9gBA9fV703K1m64A=;
        b=aK0ikhrXNqWynXKsmH0FYo7yIs4wM+lXFXiECYqUSe1creOIdRMto3B/2QQ4RcxktnKx/T
        kHwMScnkZfhEp9dVBP+UQsDQQDabxxscB6Kb4ULShxFLAxn3w85TzOT9m+AJX4yqjRQ7pY
        Lfvjt3CiqVpL47xuXGg+lwCUKPjYW5g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-HhvAwjKpNfeYpnjI1N5Dnw-1; Fri, 14 Feb 2020 08:10:50 -0500
X-MC-Unique: HhvAwjKpNfeYpnjI1N5Dnw-1
Received: by mail-wm1-f70.google.com with SMTP id n17so3448773wmk.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 05:10:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tk355w+VT5A6GLvgx0YR1ga+vZy9gBA9fV703K1m64A=;
        b=BCKxGa+vsKaFOW6wzL5X3kTeXdgLw/04pz/FDDmBKubHcOWI5TTcq8/9ugkHrA3GmT
         bxuscxN5X/yUfbJLErEvW3z+V3eTNU2YbzIo0R0xSz7EhTAQofKod+AHwnYpIBUvgBxj
         G7gz0FvhE2JTaH6snC6c+dr8tP4Vi11TY69pF7EZodDUUwLRvCRwurbk5AtJk+MTs4WZ
         YeNYEfMFLrSvgpU+NLjO1rcV4kIkKz74/Idqzcc2etcKAZisTgOk10QzYNr5KsU5V1Wa
         DVzrYj8nc8UY+zoXMV5bXBa9f7OiAwL8eWc2v0n4bRahJHRjBriXck2wTfNTjlRBq/Bi
         EifQ==
X-Gm-Message-State: APjAAAWnrDLkyzUHq9F0PWXjPnvEvw/YmvJkI21qp/OqHutMabmoqpu6
        qR5g0pO5z7GbbepF6eqrBuckPbLeguInJNKMsUSQ9jT2ceJoFjBo9N9B/D3nNAtp4eF4EXbzdQH
        /356laJdVAHlm
X-Received: by 2002:a1c:238e:: with SMTP id j136mr4725285wmj.33.1581685849427;
        Fri, 14 Feb 2020 05:10:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZu8H9sGITBqvzZ063eTp25KN3M0jTWTgrktE5YNL0hK7lDN3kARzRAslaNIxkx2mBXJxg4Q==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr4725256wmj.33.1581685849152;
        Fri, 14 Feb 2020 05:10:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id l6sm7096155wrn.26.2020.02.14.05.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 05:10:48 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
 <20200214103853.ycxs4clif4gisk6i@kamzik.brq.redhat.com>
 <d04b6913-e71e-8983-e704-d956be12dac9@redhat.com>
 <20200214115051.o4t6ro55y42oztxf@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <730a5700-ab25-2a27-809e-a14d8e6bf492@redhat.com>
Date:   Fri, 14 Feb 2020 14:10:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214115051.o4t6ro55y42oztxf@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 12:50, Andrew Jones wrote:
> After
> -----
> 
> $ ./run_tests.sh -j 2 -v pmu psci
> PASS psci (4 tests)
> 
> $ ./run_tests.sh pmu psci -j 2 -v
> $
> 
> (no output)

Bugs. :)

> $ ./run_tests.sh -j 2 -v -- pmu psci
> $
> 
> (no output)

This is intended, it shouldn't be a big deal because we don't have tests
starting with a dash.

Paolo

