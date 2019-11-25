Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4B109355
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfKYSOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 13:14:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43681 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727832AbfKYSOW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Nov 2019 13:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574705660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=GvnYXdwX6vY/1C5cbb9gQtXUzSKWNqW2KaSUFzES6WM=;
        b=eKO8bBT2Dt90Sqltt70iE6cjB0pr7ayOLPiWR7/t/9p54NY0nlHitOOdA1Gwx9jyla04RM
        eOqpZ6etr10txKJ12UHgIRCAaZ5Twi1kWLjFdb0l+3xixvWZplMoUanLIz5DbU5nS2Btbg
        IEOyKIY+gnw7AvNHWLtBCzLd6hnPDQQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-SomBPxY4M7CjIlYtgVnwqw-1; Mon, 25 Nov 2019 13:14:18 -0500
Received: by mail-wm1-f71.google.com with SMTP id p19so86931wma.8
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 10:14:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GvnYXdwX6vY/1C5cbb9gQtXUzSKWNqW2KaSUFzES6WM=;
        b=iZ6/E4Uu4Dty30rxCzZJFtC0LS9x+jY0bzJilAou6KS/yTYIBhCCxl79L7TVuin9PL
         EJ30iUotiNfyh0IHAViFiDdzQcPwZfNyc6GRGm3dExSlqZRv/EgCHYBsKCZGp9eZ0S4R
         UBKQkRQ0if4mlxf6vm6XFEfjNq2er0gHl+MMgWyN1pR/rT4/zzYjvD6h517/O1qgfu32
         wTeR1wJdjLi+/NQE7yvP5Evf+0yrKPM3Ax9R9X9OOfMtLdKF6uyzAX3y6zLGFb/26Epw
         +ctV47AJDZBH3WZiYp6pVDDw7RLBMbh/pREj/edobXatuIFA5p5SKrNLucD0+fp7M3u4
         DlLg==
X-Gm-Message-State: APjAAAUiWm2hMVizGh7AVlNVPzrEhmX6+7woEiN8cAcctVx3USC7G9lE
        Mv25vcMTj+L3DKlUprtqGb6XOYbnegt4QP1+MZvffDVXxp09p0gcSIQ/1Ic69vURkYOJ//H9JG3
        OO+oQBpsUDooX
X-Received: by 2002:adf:f20f:: with SMTP id p15mr30884829wro.370.1574705657722;
        Mon, 25 Nov 2019 10:14:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXM1/tnTX1yVUaesSB7fee7PwX2ZsULIQK3ruLywhJBpQerXNpkN8hhBakZQglggg7r/52Hg==
X-Received: by 2002:adf:f20f:: with SMTP id p15mr30884776wro.370.1574705656712;
        Mon, 25 Nov 2019 10:14:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id y67sm96926wmy.31.2019.11.25.10.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 10:14:16 -0800 (PST)
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
To:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
References: <20191122234355.174998-1-jmattson@google.com>
 <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
 <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
 <E5F51322-35EF-4EC1-AF3E-2233C6C37645@oracle.com>
 <CALMp9eQ12F4OuJmvvUKLTXoKhF5UtdYBV22sTqrTffTUfj1WzQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a0c3620f-ae7a-1473-2018-7c32d51b5120@redhat.com>
Date:   Mon, 25 Nov 2019 19:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ12F4OuJmvvUKLTXoKhF5UtdYBV22sTqrTffTUfj1WzQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: SomBPxY4M7CjIlYtgVnwqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/19 18:45, Jim Mattson wrote:
> I would call that an opt-out cap, rather than an opt-in cap. That is,
> we'd like to opt-out from the ABI change. I was going to go ahead and
> do it, but it looks like Paolo has accepted the change as it is.

Yes, your experience has proved that guests are not annoyed by the
discrepancy between VMX_INSIDE_SMX and the actual lack of SMX, so it's
pointless to complicate the code.

Paolo

