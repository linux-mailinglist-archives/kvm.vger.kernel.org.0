Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8B94D0F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfHSSdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 14:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfHSSdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 14:33:20 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C75B57E425
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 18:33:19 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id q9so5647234wrc.12
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 11:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jHC20YAO7i3dX79rngQOnV9bwJPBl1SY2fxabeqEHk=;
        b=pv/M/LXK71QAlgDQrUtN90ELbhNHCvWGHx4z+nnltwFTh9EjMZyQIhNlGxjJLJyUBv
         nvH5XKX2+CJzvboynAl8xkNZACb4C2sPBYG/PzT5OEfKB1UNZsaJgYJ6Fk03IJB12cJN
         JucMwsuLiXxLubYMOrNF0HIw6t9H5Bhgo0gctk5mG4oI7QA9rrC0HAYYo+Ijsiv0EpM5
         Z4LmXgGfR8lfoq35M7P1USOF/fnWP1ABFEjfuuF5RlueGD1zJJQwo4hJt0YXezpYnW9X
         05U/TcfNa/dGJB7k0F4Vpbke89+oAov40WCMQOqLD0Uwi4tw+b/YUEhjXIBc6XZn9Tsz
         HTQw==
X-Gm-Message-State: APjAAAXZFtcksdO8/qZcBr3gIRjlAvDW/20TCdkLD1Mf2v3vE3fMnL9/
        YFmPQSnm3nPOIeGu/GrO4ipBMu6ILHnRJ8oAEj74OKutHi+UR2QBRmXdr/YU4km5muSwSI/6Ui2
        Ip7UmZ2TwIQnV
X-Received: by 2002:adf:fc87:: with SMTP id g7mr28697375wrr.319.1566239598419;
        Mon, 19 Aug 2019 11:33:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwRzgvRxefwBW4gtKRSSnETPE93k3WsITQv4FasqWWtMUx0D0FuzwoHIAa9Z4TfsJ8CTnhFbQ==
X-Received: by 2002:adf:fc87:: with SMTP id g7mr28697362wrr.319.1566239598177;
        Mon, 19 Aug 2019 11:33:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399c:411e:1ccb:f240? ([2001:b07:6468:f312:399c:411e:1ccb:f240])
        by smtp.gmail.com with ESMTPSA id d19sm21489395wrb.7.2019.08.19.11.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 11:33:17 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: x86: fix reporting of AMD speculation bug CPUID
 leaf
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
 <1565854883-27019-2-git-send-email-pbonzini@redhat.com>
 <CALMp9eQcRbMjQ_=jQ=qaYmh1Lavc3PYvm4Qcf3zY+N8j3zZe-w@mail.gmail.com>
 <0e29f624-10f5-7ab5-1823-280f32732b68@redhat.com>
 <CALMp9eT2uo+_tbV=Z3-pyzjU76kaEU-BNvVriEHU6yGMsiy5Dw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9097ee53-e681-60ef-b389-6603bcb52041@redhat.com>
Date:   Mon, 19 Aug 2019 20:33:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT2uo+_tbV=Z3-pyzjU76kaEU-BNvVriEHU6yGMsiy5Dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/19 20:30, Jim Mattson wrote:
>>> Perhaps there is another patch coming for reporting Intel bits on AMD?
>> I wasn't going to work on it but yes, they should be.  This patch just
>> fixed what was half-implemented.
> I'm not sure that the original intent was to enumerate the AMD
> features on Intel hosts, but it seems reasonable to do so.
> 
> Should we also populate the AMD cache topology leaf (0x8000001d) on
> Intel hosts? And so on? :-)
>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Thanks.  Note that I plan to send v2 tomorrow, and I've also done the
part that reports Intel bits unconditionally.

Paolo
