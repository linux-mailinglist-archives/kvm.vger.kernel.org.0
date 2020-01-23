Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC0146AC8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgAWOFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:05:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729400AbgAWOFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579788346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MefNIlVtOS6BxvJxq3/0ue5/uwqSdXi/qGTJoiOKPDc=;
        b=N+OJaWUttqjQGjhTwOEnMR1DANXhv/gpPkO+yHY4xnLWRI8lBQ3nKvfOKnVX/eO0Yg1GRv
        UVN0qBpoypoIxstSVC/YwwowU95r6GQP4hn/gF7D315zLpw08bC6VqmvNM3t8G72uFdMz1
        vGeFMbYyfU1R9BqmHmB5FbwBgH93q7I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-93EdJzgzMZ-ou5P73QVBiw-1; Thu, 23 Jan 2020 09:05:44 -0500
X-MC-Unique: 93EdJzgzMZ-ou5P73QVBiw-1
Received: by mail-wm1-f70.google.com with SMTP id p5so640722wmc.4
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 06:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MefNIlVtOS6BxvJxq3/0ue5/uwqSdXi/qGTJoiOKPDc=;
        b=C15V9da8JDvY8n6JN8jG/ihcE5AKWDAIauJjJZSGhVFZZKgw/uJhYRgoUurn6nvMof
         dCDifr26b2KGT56HB4TquNspwLTU1kzdEiSjAKQRyn6Cx+SnSXL1R826pF6Lz1d0mIUU
         n8ry+gZhVoo0MWUnsLfQuR5AcPXxm1ostfBzh2X07yO3ge1WWwWpGgNYkzep2A3auHXJ
         IjpF7rESqJvYaCHeE0b0u8ro5G1Csqa3PBzD2NM7KD0lExs3yMAypKtL59sCMNW4Kw79
         yV5YKnKOWXxEM/1bT6ZSv/4HlHiBrZXIIv6SBaJFnznpM/roq6Y4gGp/2V6Jdafc5sAy
         afeA==
X-Gm-Message-State: APjAAAXLVdiD1qQ+i3EJaNm2aI99vuj2HVNzQ7pQ8UuiMDKHKfkdR09P
        ddIT8H9I+tTHUY7wzgybaAttV0hTWv3pKlhKkCw4q2FEL9jEamha2WGvGbIibxnD6hA+j8HnbB9
        oDn7YkdBobks/
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr4406356wmj.88.1579788342033;
        Thu, 23 Jan 2020 06:05:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGQMJPjjxhe4yGypPjiAHNss/zMF3/c+GKE++PjuEKCP6CcWxijnQtOt2pgJC1LdxtEvljrQ==
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr4405997wmj.88.1579788337303;
        Thu, 23 Jan 2020 06:05:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id p18sm2823051wmb.8.2020.01.23.06.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 06:05:36 -0800 (PST)
Subject: Re: kvm-unit-testing: Test results parsing vs tap13
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org, david@redhat.com,
        Andrew Jones <drjones@redhat.com>, alexandru.elisei@arm.com,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        Dan Rue <dan.rue@linaro.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
References: <CA+G9fYu31wTfE+=4pNSGdT08VBeVL=mvEn+YV6YB4PSh4VdDJA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a0fb4967-eebd-bb4d-0c70-15147bc3bdb3@redhat.com>
Date:   Thu, 23 Jan 2020 15:05:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYu31wTfE+=4pNSGdT08VBeVL=mvEn+YV6YB4PSh4VdDJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 14:23, Naresh Kamboju wrote:
> 
> We (Linaro) are validating LTS branches and mainline and linux-next by
> using kvm-unit-test repo and reporting test results for stable rc
> reviews. kvm-unit-tests are running on x86_64 and arm64 architectures.
> 
> I need your opinion on running test with available options.
> 
> The current test definitions run_tests.sh running with option -v.
> 
>  ./run_tests.sh -v
> 
> If I run with option -t (---tap13)  47355 results showed on the console.
> With TAP13 it is a huge number of results compared with option -v -a
> the 57 test case results.

The TAP option is simply more detailed than the default, which
aggregates all the tests from a single executable in a single line.  You
can see that in the non-TAP options output, which is

PASS apic-split (53 tests)
PASS ioapic-split (19 tests)

etc.

If you sum the results (53+19+...) the number you get should be very
close to 47355.

Thanks,

Paolo

