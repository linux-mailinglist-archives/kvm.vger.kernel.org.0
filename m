Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A03FDB20
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKOKTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:19:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725829AbfKOKTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=xIma6LGd2FNlo2mXwYtHoBseXP1/PYmrCLV26HJFQW4=;
        b=HkuSM5SxHOuf5uk0af69NPVOxNAloYeAgVIMwIPJDfewSVW0tUXLRJZ6Nkty31TC75WoIU
        to71IxbngzEm4nwtg8BKMU2nRGm8ZnNbEbVecop5NS3ULC22vInk6kM2yW5jbB+5sBuF2e
        6OPE9cL1niMgQhiHFpYF7bX3NprZ2Y4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273--UEwBf5yNWyxPe2FgF_RFw-1; Fri, 15 Nov 2019 05:19:20 -0500
Received: by mail-wm1-f70.google.com with SMTP id f21so5759976wmh.5
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:19:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ex691wxP+WudC1AeVAYuZvWpMt4elP21+Johc5/FhrM=;
        b=GL57MLb9+qrASfvg0NGys/9vr44zlO3UDBerBYj9hoSjQk56hWuntobpr8bt0IdahI
         PQrWoqkMvsrfF4BF1HM3CQ3u2OM2FZF3lrslHkJBh17+HyyYYOVuov5obkB2QRegI6RY
         /dno4JUDc56mCBYk7OL6OZT4GsTo/+qDnD6Jcghz1zR2UR9w5fAIJ31iQWCI3oOppRqj
         OCM/wtUfHTifOhICJvkCN2AsUWl//+UZoaqubz+eMLzjwjjg/+jiu2eMIY2JWSyTWajA
         0yPDoq2HYcmp1w+g68sd7srPjsoalKIk8BgKqOQGVy8CipBKzAJI1Zdy3X4bzOzfSm1J
         wV4g==
X-Gm-Message-State: APjAAAXQz/HSw3wpihKW+t3pQKulwhVaMxd5SJNr/x7Dy1HXFYAiW1P9
        UDPgIlfORXQ87kfdwgw4ZHBAeEHKp3GZB5i4q5kFHmDK4SzdM13UjwmiHxBY+e2BEL+QYGh2Ed2
        hSvT2CWeTS7PV
X-Received: by 2002:adf:f20f:: with SMTP id p15mr10274369wro.370.1573813159564;
        Fri, 15 Nov 2019 02:19:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTkuvxJhIBI0e2w2s+2Ww8sse+GeEdXk9Qz1xvwO6PARwz+GsNulE2kBO1u1UMw/nhWxZgCA==
X-Received: by 2002:adf:f20f:: with SMTP id p15mr10274336wro.370.1573813159231;
        Fri, 15 Nov 2019 02:19:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id t14sm10641509wrw.87.2019.11.15.02.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:19:18 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: use "-Werror" in cc-option
To:     Thomas Huth <thuth@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Bill Wendling <morbo@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20191107010844.101059-1-morbo@google.com>
 <20191107010844.101059-2-morbo@google.com>
 <60caf083-5778-0ccd-a11f-613d28514a25@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f0f8a02d-43fa-107d-3eca-f589d1c5b0e1@redhat.com>
Date:   Fri, 15 Nov 2019 11:19:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <60caf083-5778-0ccd-a11f-613d28514a25@redhat.com>
Content-Language: en-US
X-MC-Unique: -UEwBf5yNWyxPe2FgF_RFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 18:47, Thomas Huth wrote:
> On 07/11/2019 02.08, Bill Wendling wrote:
>> The "cc-option" macro should use "-Werror" to determine if a flag is
>> supported. Otherwise the test may not return a nonzero result. Also
>> conditionalize some of the warning flags which aren't supported by
>> clang.
>>
>> Signed-off-by: Bill Wendling <morbo@google.com>
>> ---
>>  Makefile | 20 ++++++++++++++------
>>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20

Queued, thanks.

(As for C++, the right thing to do would be to rewrite the tests for
tools/testing/selftests/kvm/ and get rid of it...).

Paolo

