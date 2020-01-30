Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AD814DFAE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 18:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgA3RMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 12:12:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbgA3RMl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 12:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580404360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+9ocZHh0AU1ZkwHneI6oxUTKDtS8LS2JUiIPF/tsAc=;
        b=VTkfW9cxTYyHmtxqhyejdfkmbt6q97cGpxS44b4uItx4JA9kZ0SJrSbYJsMUjAQjE8+UBl
        wPgtQJegnHq1yPRXa6ayrJdLcKDPREzBCCwaKEeSX3oC2Z4v7VUu/5Y8fmolL8/peOqtMM
        1G8yfIs7aB/L4i8S6XDkCAOwIKgkDv4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-pXYOUJMnNh-JoSrrWooiDA-1; Thu, 30 Jan 2020 12:12:29 -0500
X-MC-Unique: pXYOUJMnNh-JoSrrWooiDA-1
Received: by mail-wr1-f72.google.com with SMTP id d8so2007156wrq.12
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 09:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e+9ocZHh0AU1ZkwHneI6oxUTKDtS8LS2JUiIPF/tsAc=;
        b=iG04fXEYiX/PmCWBgVgzY4a3W1/kjDchBi67IMFlH4Qgr1TJDuo7X/72vWgoZjUFAL
         QyqHcZsvUUGyS8ovpb9CvG2P1CddfY34x1U9KpTsJX1l6r1ij5ZVpQGRXeKf6TEDqDOb
         phPwanxOxMvKpMWMm6aOdZ9l+BD+ENvvm1zuM5GXDP60NYTOspLJG4QPqBMBC5XeFm0N
         TYcAWwORjnW50Rt+Kfezx3eeOrQ15p7XcYICBBfkCWFHU9lO2PcFm8QSQFt7eN0cI5bt
         pNeCAcy5kec8akPAibC+lAFQ1MAV0/+WdbvZ5FdTucpPwPMGQtQUtu6Y436d0b17fGPv
         SFsA==
X-Gm-Message-State: APjAAAXglMQ6+ovWz929JxS80emdqWVhcHLkYKaYo+thBB0VDxWtCZOe
        WZFBRxLuMZhOku+JBtPTyIoDwLrie7EdEmyDWAlH+8uNr7NmLNiY3cBu24OIGacrGTFYokysbKq
        MlsDgpQOGrqVR
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr6599247wmg.86.1580404348098;
        Thu, 30 Jan 2020 09:12:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdpmJ+7y/TrrsdhvhuHv0pmAg/ySv9TMNb79VFtSHAgrgJYM6IOs5aeMMIoE4fHr9YCW0p7g==
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr6599215wmg.86.1580404347786;
        Thu, 30 Jan 2020 09:12:27 -0800 (PST)
Received: from [10.200.153.153] ([213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b137sm7570916wme.26.2020.01.30.09.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 09:12:27 -0800 (PST)
Subject: Re: [kvm-unit-tests PULL 0/6] s390x updates
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200130131116.12386-1-david@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff92febb-742c-c34c-5f6b-8bace33918be@redhat.com>
Date:   Thu, 30 Jan 2020 18:12:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200130131116.12386-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/20 14:11, David Hildenbrand wrote:
> Hi Paolo,
> 
> The following changes since commit f2606a873e805f9aff4c4879ec75e65d7e30af73:
> 
>   Makefile: Compile the kvm-unit-tests with -fno-strict-aliasing (2020-01-22 16:29:43 +0100)
> 
> are available in the Git repository at:
> 
>   https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2020-01-30
> 
> for you to fetch changes up to 1cbda07c1cc63589686048866ee24459c38c42f5:
> 
>   s390x: SCLP unit test (2020-01-24 09:47:00 +0100)
> 
> ----------------------------------------------------------------
> Add new SCLP unit test
> 
> ----------------------------------------------------------------
> Claudio Imbrenda (6):
>       s390x: export sclp_setup_int
>       s390x: sclp: add service call instruction wrapper
>       s390x: lib: fix stfl wrapper asm
>       s390x: lib: add SPX and STPX instruction wrapper
>       s390x: lib: fix program interrupt handler if sclp_busy was set
>       s390x: SCLP unit test
> 
>  lib/s390x/asm/arch_def.h |  26 +++
>  lib/s390x/asm/facility.h |   2 +-
>  lib/s390x/interrupt.c    |   5 +-
>  lib/s390x/sclp.c         |   9 +-
>  lib/s390x/sclp.h         |   1 +
>  s390x/Makefile           |   1 +
>  s390x/intercept.c        |  24 +--
>  s390x/sclp.c             | 479 +++++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg      |   8 +
>  9 files changed, 531 insertions(+), 24 deletions(-)
>  create mode 100644 s390x/sclp.c
> 

Pulled, thanks.

Paolo

