Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51085F747B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKKNEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:04:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54789 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbfKKNEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:04:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573477487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ZN3aWSuYK/gGZE2cTnmbeXZL2qjoEVesuUlNyNHv5yE=;
        b=Z1TnWaR9CQCH1dFRTMawKYD5XdHe5zHdAyUcKYZfliDWHGg9QmLRh7zgPPBApHkbuKHPG+
        d8YL0KonTTzzlwvCJeuOuOImj+sQOuy1sJIhBsm+rP7egGLi9ivA7fk6dQ3eXmmCEKi+K0
        8ktelOxSojXp3Y38gzOquxeX20QDhkc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-eUJ97PGgOt6p1MJFQX0_zQ-1; Mon, 11 Nov 2019 08:04:44 -0500
Received: by mail-wm1-f72.google.com with SMTP id 199so8335694wmb.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:04:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZN3aWSuYK/gGZE2cTnmbeXZL2qjoEVesuUlNyNHv5yE=;
        b=iOsyPnC5poVPLbSU2dmSZY5R97zx4KhlNfkvo3HOXLJvELvZQe4W/fJJT57V9AeR0c
         aXurwmwv+RBQSgGmP476VqBSj3qIAUecSSCM9WzrnDdbEumJjab3ZmpqcB3Du8aCktiR
         fcBSD1wdTxJTaE/9oP8y5HCn+3z02cTAIlmUFYk1hlJ5WcyO4Wsc+YQwF69iNYEWKX4a
         PwF7iL22XW3IO/t0dr1E5nZo/u/Na/cW/arI7ahoXEqzlTSuliuadnpkoB0grQQfQqIP
         ZcZW/1Nu47Tg00Dwvwr3zIzIazJ2ZZh00GlwkDaeCztcz2Nl+ONjztmJpxKkpt6wQqyX
         6YGA==
X-Gm-Message-State: APjAAAVG7lbkJk0ZTiio9yCEJan+ddSByj5Qxye9O71cEkD9GDKRzpsM
        7EYgdLJs7LI/3bKNi3DxMc4JGNb1PESkSJvpJ/0xOMNSDx8aKN59oYcClaxgPWYTdXmhueEkRTl
        z+vSWQyqqZU9P
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr19169198wmf.85.1573477482724;
        Mon, 11 Nov 2019 05:04:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZR1lFwj8chLuUd2uvaV/Ko3M076flht1VZdA0Pn41UWH76EkVhjjNaZMxmxNvYQHQI2bUWA==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr19169166wmf.85.1573477482456;
        Mon, 11 Nov 2019 05:04:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id 19sm33906210wrc.47.2019.11.11.05.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:04:41 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
To:     Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        thuth@redhat.com
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
 <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
 <4c26975a-84af-e21b-fe40-33197b51fffd@linux.ibm.com>
 <20191111123109.mnibzicgsbcvvtth@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1f0fb08c-ca4d-93dc-2b43-72356c75d033@redhat.com>
Date:   Mon, 11 Nov 2019 14:04:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111123109.mnibzicgsbcvvtth@kamzik.brq.redhat.com>
Content-Language: en-US
X-MC-Unique: eUJ97PGgOt6p1MJFQX0_zQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:31, Andrew Jones wrote:
>> I had some more time to think about and test this and I think returning
>> NULL here is more useful. My usecase is a limit test where I allocate
>> until I get a NULL and then free everything afterwards.
> I think I prefer the assert here, since most users of this will not be
> expecting to run out of memory, and therefore not checking for it.

Yeah, the main issue with returning NULL is that (void*) 0 is a valid
address for kvm-unit-tests.

Paolo

