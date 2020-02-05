Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBCC153384
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBEO6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:58:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28209 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726740AbgBEO6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABQJ6sOXpdgofUoJMW9UAd62y35uOEs746O1CxC8kas=;
        b=TWzGwInTecSDcZAYL9Grg/tEEI0Ze4Y+A4HIUkNCJRJtOlE0mrP49fwfNBBOAi7yX3VAmV
        PYrBlu5b4a1ru7kEjDGL+h4NW4pwVOLvfVm/b4Uc5m3gMuUgr+ImK4JjEq/laWJHRTkwnX
        /0QE1xlpJmidbF8ldSLoD5AfndaEPvg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-KlMTel_hMJCDqzzYLI6M9Q-1; Wed, 05 Feb 2020 09:58:18 -0500
X-MC-Unique: KlMTel_hMJCDqzzYLI6M9Q-1
Received: by mail-wr1-f72.google.com with SMTP id s13so1303261wru.7
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABQJ6sOXpdgofUoJMW9UAd62y35uOEs746O1CxC8kas=;
        b=a8p7QbwHJBHOdV5MtsciW0XDz/36NhEmVSkRzm3WVALAyGeIq0XDMFuSjfxVyNHNHi
         vRuo5lx6tJf9rK9VZsLgeCZR0/rxcVWC+liduW/r+wjt66f5pgaYCAk3BeCy3fcdyy2Q
         Klc6xwzyZ2EnBn+UY8nAt+6Ev/EfJO5ooiv77dQykL0HJJs+nCKAsG83kfA+xt9kCkxM
         Ib2w8khhLWpZK11meRrNRfvbXlGyWDXRCEu/qVUqiN5xiOpIax7cZ+9SQ0j4RQ+b3hXc
         veLz0kSKP/SL0ouweLNZan2KeXwO68DpqJXlRzn9ybskQheqHVx9e3FCfut6AhbKRHph
         LekQ==
X-Gm-Message-State: APjAAAXkQMnVQ+iOddI8snelJWMUGrWFtU7M/MDZAYzRcjrD4VW88uns
        WzoFxm/OzGJpaLrgDCpojnze9xbyuIlI+DhCcQUO+qR2lrdhq3ipFftR+t4a0MVQ0ZP41q3seki
        7jxzSILkKL8xZ
X-Received: by 2002:adf:ed09:: with SMTP id a9mr12584937wro.350.1580914696175;
        Wed, 05 Feb 2020 06:58:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgCuFN5ZWKoDFKJkHefwIr1SGohq6KO0CKaDHnlZhbhzUnHD2MrXoNjfgPWoAiF6rAviCZPw==
X-Received: by 2002:adf:ed09:: with SMTP id a9mr12584924wro.350.1580914695993;
        Wed, 05 Feb 2020 06:58:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id q10sm8121850wme.16.2020.02.05.06.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:58:15 -0800 (PST)
Subject: Re: [kvm-unit-tests PULL 0/9] s390x and CI patches
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com
References: <20200204071335.18180-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2711414-0bc5-e952-8131-a662b5a5e6e4@redhat.com>
Date:   Wed, 5 Feb 2020 15:58:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/20 08:13, Thomas Huth wrote:
>   https://gitlab.com/huth/kvm-unit-tests.git tags/s390x-2020-02-04

Pulled, thanks.

Paolo

