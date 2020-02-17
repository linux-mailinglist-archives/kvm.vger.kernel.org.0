Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBCF161882
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgBQRHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:07:46 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35250 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726879AbgBQRHp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 12:07:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w8ekHRxyGjG79FMqVIJ5GpDBPE0vuy0FBs+DN7hAGZE=;
        b=D46xs11uVizDy9gDhmJaJpyt/6cpE+ro1XL8pLXYmaQFjg/N+5kiGTIOC36u+pkgkkFfBo
        y3obiWGoFUPBqubDNIC5dCk4qGfqoGjskzFIUTFpilviKYuqt4jUHc9nIHyxYjAyY4qDaC
        bQtqh2au+r4KqrZsVJpzjd9irs/MXRE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-psHpUWe_O9yABigXtaa_DA-1; Mon, 17 Feb 2020 12:07:42 -0500
X-MC-Unique: psHpUWe_O9yABigXtaa_DA-1
Received: by mail-wm1-f71.google.com with SMTP id f66so8346wmf.9
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:07:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w8ekHRxyGjG79FMqVIJ5GpDBPE0vuy0FBs+DN7hAGZE=;
        b=ESF1TkjEI4HCu7x+iVOEqECRCQUx5UesJlDug+O2rjjVgOdut0I80F7yZdTt3kfCGs
         aYbVBT1/zEp5xAVQMsF8/Q5t13Y/AUAz8gf9SEbe14hp2UV1F3oy58Ac3Z1PlGrZsWtY
         zX0Xqg6eXN1K7tPgulBCIum++9OXZJvucbM4h3BSBymGCpFe3abshbyuicBaMAt5LYrh
         sHmNmg5G2FsuwpLgI1kwLSV1jB6rUfo7pxZygfwCpdXWPezVeLUEdB/8UZEFxU0ngqci
         mD1XV6h8uyJX5Id3k8PxZ0HK/S/ux1GqaAWQYE44ocigYNwl+yPowjGBh2OdqhB9voLL
         ifyA==
X-Gm-Message-State: APjAAAV23k0lVjxL9tU5x1naQCidpZOEHG/WAIEW6Yk40ejiAz3wOZld
        nElRSOGi7Iy5xdVSwg9aQdLkrjm3fDDgLu6tWHdNdCcWVplYkYIUcrD5KrqjAJzp0fFjQT5ZlB1
        AKut0ov4Q5qWD
X-Received: by 2002:adf:ed8e:: with SMTP id c14mr23169035wro.80.1581959261298;
        Mon, 17 Feb 2020 09:07:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBi1h1ePrfcvbLrgaw7FsnBlFRQyIF6cIDnTGDykcOro85MvUUUz1i0rgLeTQdc3sx7DjSBg==
X-Received: by 2002:adf:ed8e:: with SMTP id c14mr23169004wro.80.1581959261031;
        Mon, 17 Feb 2020 09:07:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id d4sm1694350wra.14.2020.02.17.09.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:07:39 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix print format and coding style
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <1581734662-970-1-git-send-email-linmiaohe@huawei.com>
 <87o8txbngb.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbae67b2-a9b6-d2fc-a49e-ef07d1358860@redhat.com>
Date:   Mon, 17 Feb 2020 18:07:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87o8txbngb.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 09:57, Vitaly Kuznetsov wrote:
> I would've suggested we split such unrelated changes by source files in
> the future to simplify (possible) stable backporting. Changes themselves
> look good,

In this case I think it's trivial enough that we shouldn't have any
problem backporting to stable, but in general I agree.

Queued, thanks.

Paolo

