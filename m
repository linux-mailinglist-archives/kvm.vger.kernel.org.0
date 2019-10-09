Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B95D1C38
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 00:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbfJIWuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 18:50:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732302AbfJIWuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Oct 2019 18:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570661414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=CbgpBG69W3Xxb5a6Ssxl5LP9mZoRKPa/mOy1gfjgbK4=;
        b=PrwtkWo7O09oC1LuVxvO8SfSq8w4Pgy927mo0MD45ttctTqUY3TzzcvDQSUqsJQGRQYKuk
        4M/0hcXIIjQKvx1XbvplMR7nq8p3HW0WQ5AnCexqo26ZDCntmaXTmlYeebpOJwGHWIPHGi
        Ci9R68IYw/HGbGST9VC7zT/ceIYConM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-EVYStdCHM2OjPwwHOiDMJw-1; Wed, 09 Oct 2019 18:50:13 -0400
Received: by mail-wr1-f70.google.com with SMTP id y18so1772787wrw.8
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 15:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xsA6d1N0yHId/YtP2xKnkBmHpHSNLVq87w9E1zgqoSY=;
        b=o28uhAnvu+gQFlKezEGEmcA6kniz3g34JOCIFAwLKYqPDjvwYpOzTRTV7dnsA2SqKZ
         7pj5vKhbCf5vV+640HmYtJCI/1qCyK728kbZuJPKaQUtOEIWAFKwY4h29evzlJkwoYQw
         KsV+I1UloTDHUOAGmXpBUSVT4O4s0whLGi56orKKHvMNMXIqKH7znTdk7/6WF6+6e6ph
         0W2cl7SoYmHOVnOF9YnNH6W+9M8hZe/a6QEEc/URYCvLLe0k4kG8U73yBsdX1NKVAv30
         n+AVssu/bOygVT6yTZBkvo0LpIxYGTxc+bNxCt1MiNUdEhiBqsSpTgNxA/Rd6fHUXi1C
         rI1A==
X-Gm-Message-State: APjAAAVoGwEbGeryt6kTiGSuofnLKyxbtwNncy39Y0ejeRR+KKnEeq2C
        BJo0f+GfT+kuWyXsVFwwBH/5m7GLqH+oPNUuDay0cpjpFLD/uF7JEFgqQ8LdACnoG6gLqz8YwPd
        MCpRNhktDtzwJ
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr4921133wrw.10.1570661411381;
        Wed, 09 Oct 2019 15:50:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy07hu4yFjDInGnWEM/eAkittSfEadjpJ+GUEnHkJRlZCXURorVeclhCVbEO1u3sqOAb5pfZw==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr4921118wrw.10.1570661411126;
        Wed, 09 Oct 2019 15:50:11 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o1sm5141619wrs.78.2019.10.09.15.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 15:50:10 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.3 28/68] KVM: x86: Expose XSAVEERPTR to the
 guest
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kvm@vger.kernel.org
References: <20191009170547.32204-1-sashal@kernel.org>
 <20191009170547.32204-28-sashal@kernel.org>
 <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
 <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7119916d-462e-8ba8-300c-c165d9df045a@redhat.com>
Date:   Thu, 10 Oct 2019 00:50:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
Content-Language: en-US
X-MC-Unique: EVYStdCHM2OjPwwHOiDMJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 23:40, Sebastian Andrzej Siewior wrote:
>>>  =09const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
>>> +=09=09F(XSAVEERPTR) |
>>>  =09=09F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_S=
SBD) |
>>>  =09=09F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
>>> =20
>>>
>> Yet another example of a patch that shouldn't be stable material (in
>> this case it's fine, but there can certainly be cases where just adding
>> a single flag depends on core kernel changes).
>=20
> Also, taking advantage of this feature requires changes which just
> landed in qemu's master branch.

That's not a big deal, every QEMU supports every kernel and vice versa.

Paolo

