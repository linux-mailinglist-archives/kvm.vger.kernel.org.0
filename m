Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34957E7B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfF0ItR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 04:49:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43228 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0ItR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:49:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so1524478wru.10
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 01:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aweQbVBefN+UFMcwTZu0tWlyLGn7KoCwWsCPZKw0Gj4=;
        b=ky+Cy1hTPtJTB14SgdK1Nt7DiHHd/QImuviGYn1Ew4XAoow/VtiBqzTElcLFFYVqS9
         ogPUfFAoa5lt+FW0EdaCMrRlU+LNjHkhAK4Bz/adTPGW8YfFoaEdKTTewLksIC8gwMXo
         afpG0eqOgoPp5cfMycIAV29qmLcpf+yszvUuw3U5w1cyDnQdh1eyx7gZadJYbHyjDfra
         nnugYi0Y+fFH9Su63cH8jztSqQNieXj7rjnjKxC5nnLtacS2EPyqmHI94rl/XXCihe3B
         DIqexIP9LfcVvdLdXv/Jl2ikJklj3Kfx0MC4Hnys5uiemwwE758MqcXsCny/r2oHFhbn
         pDBw==
X-Gm-Message-State: APjAAAUmv4G/L+9Rx810RNXS41FM5pHcD4OV0GT+Oj3/Ha7hz+TlFtEs
        bKc5dWy0Y0xq4rVbT5T5kOjOtA==
X-Google-Smtp-Source: APXvYqwI3WkrkC4bFyrFtLsBLqBOYVkMeSComD2UhbzClVCfvtfgNjQdVY32oANQOAKYi/OcHBQdvw==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr2110270wrr.252.1561625355456;
        Thu, 27 Jun 2019 01:49:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:41bc:c7e6:75c9:c69f? ([2001:b07:6468:f312:41bc:c7e6:75c9:c69f])
        by smtp.gmail.com with ESMTPSA id p4sm1778473wrx.97.2019.06.27.01.49.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 01:49:14 -0700 (PDT)
Subject: Re: Pre-required Kconfigs for kvm unit tests
To:     Andrew Jones <drjones@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com, andre.przywara@arm.com, cdall@kernel.org
References: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
 <20190627081650.frxivyrykze5mqdv@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e10ac8cc-9bf6-b07d-00d9-83d9cc0f4b98@redhat.com>
Date:   Thu, 27 Jun 2019 10:49:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627081650.frxivyrykze5mqdv@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 10:16, Andrew Jones wrote:
> On Thu, Jun 27, 2019 at 12:45:18PM +0530, Naresh Kamboju wrote:
>> Hi,
>>
>> We (kernel validation team) at Linaro running KVM unit tests [1] on arm64
>> and x86_64 architectures. Please share the Kernel configs fragments required
>> for better testing coverage.
>> Thank you.
>>
>> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>>
> For arm64 if you're testing on a host with a latest kernel installed,
> which of course has KVM enabled, and all the kvm-unit-tests test are
> passing (except for the GIC tests that are not appropriate for your
> host, which will be skipped), then you're getting all the coverage
> those tests provide.
> 
> I'm not sure about x86_64, but I imagine a similar statement to what
> I said for arm64 applies. If you don't get all passes, then you can
> check your host's config to see if there are KVM* symbols disabled
> that look relevant.

For x86 there's just CONFIG_KVM_INTEL and CONFIG_KVM_AMD.

Paolo
