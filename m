Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC0016BAAC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgBYHbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:31:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729375AbgBYHbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582615899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7bMDIxOengvGEcE4RV6AlXH7TZ8wwcgKOnjFRpqQA4=;
        b=iUqGHu3QWMBmA3HQyPi3LlxD5tw3Wpj/2ibrrbYbYVFzZGxteUTMmQr7fcShrDshViLTAA
        vO5a8ddgcJZpn4+LZLXnrFJO3SM3sISpSGKHPjQfprPO8WpZe0tI7wLG1/ExMxYdfBtbHa
        fdYIABPD/DmlKByEncSGYB/hK2DsJBA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-oo0WokUkPjOuXei4RkwRbQ-1; Tue, 25 Feb 2020 02:31:38 -0500
X-MC-Unique: oo0WokUkPjOuXei4RkwRbQ-1
Received: by mail-wm1-f72.google.com with SMTP id 7so691044wmf.9
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 23:31:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7bMDIxOengvGEcE4RV6AlXH7TZ8wwcgKOnjFRpqQA4=;
        b=a/MAOjRzngMrycqaoZ11FpDxZjKRhWStwJ55lo/gy9aa0gbdnTCoS6KI48qDdz3eDA
         3VoqHkQMqVhhgPaXqwrqsHJ9gPHQ4UUEziMKxrAe3cu48om1GQPkeuh4KRTqnntKHub1
         qN4SsOzIZuPVf592OQpviIHhXr7RWrITE8LoA0NpNntIUJOA49RVjsyl/TfBUaBA97z0
         MMZjtZYqr7Fwy/u6Q+bQCSUTCfULO2Z4Vym44CBOv2aKbJ1n14Qc4K6alJrPoqjMEMnb
         ojaSF+w6keeZtfbKqu9nj9HBs3l3aD3l0vXHRZkQT7pYY3TG60BkWjEeY4Zl6BCOAFxf
         mFXw==
X-Gm-Message-State: APjAAAX02eDWDBgl1GSEB/C4LdyeYHahEhc/66taR5JRE1vE9KRs7FEm
        fwPlrM415E35LLkXy6LgNDZKdnNi+a5DbhiEUvmkht1enT7HXT/Z22LgdyuSTjYlarNnLTJDqK7
        FODTNV6U1zSXf
X-Received: by 2002:a1c:4908:: with SMTP id w8mr3495906wma.57.1582615896962;
        Mon, 24 Feb 2020 23:31:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6q71B1EqSg86r/aGLG8R2szCZk1D/y1rfUiB/yQuGdIwswSLR4GY8ySZEejg9dSHCTwYBQw==
X-Received: by 2002:a1c:4908:: with SMTP id w8mr3495877wma.57.1582615896651;
        Mon, 24 Feb 2020 23:31:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:60c6:7e02:8eeb:a041? ([2001:b07:6468:f312:60c6:7e02:8eeb:a041])
        by smtp.gmail.com with ESMTPSA id j14sm22647589wrn.32.2020.02.24.23.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:31:36 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Dan Rue <dan.rue@linaro.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        kvm list <kvm@vger.kernel.org>, yzt356@gmail.com,
        lkft-triage@lists.linaro.org, namit@vmware.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        jmattson@google.com
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
 <CA+G9fYu3RgTJ8BM3Js3_gUbhxFJrY6QTJR-ApNQtwFh+Ci0q8Q@mail.gmail.com>
 <20200224173033.GE29865@linux.intel.com>
 <20200224212234.m4gqvgxoqj3elni2@xps.therub.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea030d10-04a3-6fee-8a63-8fc0d767c230@redhat.com>
Date:   Tue, 25 Feb 2020 08:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224212234.m4gqvgxoqj3elni2@xps.therub.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 22:22, Dan Rue wrote:
> We would also like to be able to verify the additional test coverage
> that may be added to kvm-unit-tests against older kernels (I assume it's
> not all just new features that tests are added for?)

Depending on what you mean by "features".  Most changes to
kvm-unit-tests are for aspects of the processor that are emulated more
correctly.  These are rarely if ever backported to stable kernels, and
they show up as test failures.

Paolo

