Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF10312893D
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 14:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLUNnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:43:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726339AbfLUNnV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 08:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576935799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JD0mbg52OUGlDcpVMiwsNyHTTSD8PNUusphZebUvI2Y=;
        b=Qh17yj5lns9p0Blzgd/WLpJl6rK59EKhbAZNnhRfBOXd9O7hcL5z0eFagSWigv+nXAZZMf
        dM6MdiS76ySrgadwKq8/vIxQj2QDZF30/TuIeXycxaWzA4RLBIgRSgqoXs5xj84Iqw/k73
        zVrV7V6+z2RpoNR2Od1BQmokwNdt+/Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-lPngD01fM_-CLGLtaak1dA-1; Sat, 21 Dec 2019 08:43:17 -0500
X-MC-Unique: lPngD01fM_-CLGLtaak1dA-1
Received: by mail-wr1-f70.google.com with SMTP id k18so4164403wrw.9
        for <kvm@vger.kernel.org>; Sat, 21 Dec 2019 05:43:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JD0mbg52OUGlDcpVMiwsNyHTTSD8PNUusphZebUvI2Y=;
        b=M2CzS4JGUhVTY3tZBIPLS7bIMtPnGufB0EOsipNlKmWS8hlgxcKqfk6tI+43IMMZFl
         PdJhf/f+F+omKTXxu/iPJauRmQn5a3dWuWrP5swTmRICJPy88L0M8fpq86dL8J0/TbDL
         eqJ0L8qhz79XXT5djP09Vu8zuynp01MdaB7uYT/h9SsZVUPxagpLLVahjMzJ8aCtMD6r
         BZOC9MIDn8xLhINTCk0zUaE+pty64G2C2LA+jrTeJRxEianztGv46zuJbp9LrrnWI1r8
         o+AcBmeZA1oBr01CB8OuqBubBMhI5Sfb1ay2+yzzyeppAQ/jkXYQU3f2m6OPeMZGgH7o
         ylfA==
X-Gm-Message-State: APjAAAUSwM+1rMhu/ZRpJ1cjH0geLJcTgsIaLlg9TwKPrO6Aj6vjCJ5+
        omwIkvEF9450XvovgjGrscLxvyXMsnmRKU4U3OYh2tUeBkuo7bSL3ifpOiuwKIdrTluz7lUG2Qz
        UC12hjBukmnc0
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr22079614wmm.70.1576935796676;
        Sat, 21 Dec 2019 05:43:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSjGMHAPy9zRCs6BzDjnNA6/Ba5Z8beOBTYqmQPU9ThAmehVSsZTEp5aknQsKzHvyEntwKmA==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr22079598wmm.70.1576935796435;
        Sat, 21 Dec 2019 05:43:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id c4sm13219286wml.7.2019.12.21.05.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:43:15 -0800 (PST)
Subject: Re: Can we retire Python 2 now?
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, qemu-ppc@nongnu.org
References: <8736dfdkph.fsf@dusky.pond.sub.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c8bc635-96cc-ab3d-01d3-db97013cda3e@redhat.com>
Date:   Sat, 21 Dec 2019 14:43:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8736dfdkph.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/19 17:29, Markus Armbruster wrote:
> Python 2 EOL is only a few days away[*].  We made configure bitch about
> it in commit e5abf59eae "Deprecate Python 2 support", 2019-07-01.  Any
> objections to retiring it now, i.e. in 5.0?
> 
> Cc'ing everyone who appears to be maintaining something that looks like
> a Python script.
> 
> [*] https://pythonclock.org/

Fortunately Betteridge's law of headlines is not always true.  :)

Paolo

