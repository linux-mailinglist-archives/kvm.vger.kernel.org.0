Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAFE128DE3
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 13:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLVMSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 07:18:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52954 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbfLVMSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 07:18:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577017088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVcwDJ9q7mHGB0f2gxBplUO1RgXxxYA7NYBgVoLV4zs=;
        b=VvciwW9NJ1UxL/8Bp9iiVZ4vS/8rzsqPyk02CVfFK1gm8ZTJFASvabOXJr4BhRJGN8A013
        2/E6VR9/lGlrWnA2XUs1Pfy6tTZJckBkGIQJ1/jR0iuD8DScxt6cQS8S7NRWZuH8eTB34C
        oyMA2x3Ao9W9B9WzoTLhbVGmSnxuUVg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-auKEapRFNbqbd81SRCzGKw-1; Sun, 22 Dec 2019 07:18:04 -0500
X-MC-Unique: auKEapRFNbqbd81SRCzGKw-1
Received: by mail-wr1-f71.google.com with SMTP id f10so5608697wro.14
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2019 04:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVcwDJ9q7mHGB0f2gxBplUO1RgXxxYA7NYBgVoLV4zs=;
        b=YCXH/qCujlXu2WtgWTXngtxHapgzpdMWl+fIfN5yLWOwcqVfmiSsiZ++DMw6wjDCMz
         fDFOgvIvCDrSzxvUN1Q14/cTjJvNZMPZR/04Tx/pJh8Lmsdfn1epmo7Dxx6ZSrBppEkr
         fD21tPHgvZsboxdp8KmwjJbZ5z4mPlTibO/M44+NgvpMF8tkDXkjapHYuov5ld9VB8IB
         EBsiGivc3RyNVolXQX7OdcKFg2uNPai/WkJ6M5xiniUyRfUU+Qh0zpxaxaUygh1SiDdg
         8b2p+kFDs2W9KvpNwe5kPOql7jRzY5hRi3+A8+MIMETazyh41RMw+HqKW8GI+6XCylCt
         45KQ==
X-Gm-Message-State: APjAAAV8eoTbDyiv1Ve11c9afFEGcQGjB8DNnu2V/Vbh/lJ7dS1HOaRl
        +eu3cKk8icfQsEf1nE2ruYqCTPQ4eKnQKuH9Y3n0Wkpvh3JF0JP+mEZnpsj35nXUTuAzBC3sbw2
        k1itj5k+ZJyyV
X-Received: by 2002:adf:ea51:: with SMTP id j17mr25281571wrn.83.1577017083058;
        Sun, 22 Dec 2019 04:18:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqx9KSkR+4EMtJDrj1y3LsZ/vh9fax2RGIQnEf6Wg1AUH38J0MO5GcK4ZJoEwziC8drrgnmk5A==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr25281552wrn.83.1577017082869;
        Sun, 22 Dec 2019 04:18:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:7009:9cf0:6204:f570? ([2001:b07:6468:f312:7009:9cf0:6204:f570])
        by smtp.gmail.com with ESMTPSA id n187sm1522196wme.28.2019.12.22.04.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 04:18:02 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.5-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20191219001912.GA12288@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a82fc920-66b4-4c0a-89ea-500df2993fa3@redhat.com>
Date:   Sun, 22 Dec 2019 13:18:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191219001912.GA12288@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/12/19 01:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.5-1

Pulled, thanks.

Paolo

