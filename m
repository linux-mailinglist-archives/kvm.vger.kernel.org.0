Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413CC3EDA4B
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhHPP5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236237AbhHPP5L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629129399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZpQLZMB7RJdGulqivRZelq1MarObE9Ch/tXNewyPHo=;
        b=Jcs7G+tp7Va5M7RXYiP26mVq6XkQH2+t0qBPdVdSR0MS1hCWR4L/xoPTdIFAhZ2R4jFF+r
        icAebz9lZsOoHKPD8qNbcYCIhzaplNHrKkpohR3W/lMHRhr+hjuFLG8FRebnpaRjMKOrnq
        nHpezwHa4Arlgu8ULFa1UTBExLZeG6I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-l-v_FCXVO1GHMNf6Ra5TJA-1; Mon, 16 Aug 2021 11:56:38 -0400
X-MC-Unique: l-v_FCXVO1GHMNf6Ra5TJA-1
Received: by mail-ej1-f71.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so4821679ejc.21
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 08:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZpQLZMB7RJdGulqivRZelq1MarObE9Ch/tXNewyPHo=;
        b=Iw/FJC9mVsi/eNTNdGvOLQa+jFFsoRAhfYiI4TOu5a7/k64jMHxFi28COjUDpnfZmw
         NLqKNBnRIc9gsQQzgSgKoXn2c9VjEmjzddjnHS4mxMwavrs2CBnRHKW8LME5lIpG/ZRV
         Ya58QJ8fYW0VytP0lHrpQ+Yz/3+JztcbJKFFEP7vHUgHEsX6DYV3pw0YNjOY3AANctZL
         lDrvUQkCw7VCwcJ2qjT8T4YbjAJCLcU2iiOAQkrz3BwyYqR2pLX6yUqYNZboP5G99pDr
         XYkiabeOaqwQcyma2nONpzUsaubBFKWZBdVgZAgEYhLZ8oHSPwxSCv7ab77CXAZC9p2x
         ErPg==
X-Gm-Message-State: AOAM533GQwkbg5WDNmgZ47GNyQp0Qd7y/ru7wB+d/iadk1eaSCD+NSb+
        7+bF2gZOsO/iVcuAN01+NvkvW5xCha2jjRdJB5U4nJ70QXlm1CcexIcnkB5NIE5jxZiE5p9tCb6
        +quorDoRakNMi
X-Received: by 2002:aa7:c894:: with SMTP id p20mr21016344eds.42.1629129397237;
        Mon, 16 Aug 2021 08:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0zVXLSgao02pT8Fnch/EOLmPpvxZgNu0lTTzYEYe6LDXa/xwx5yX+prRxBm3ZPVFWwFWf4g==
X-Received: by 2002:aa7:c894:: with SMTP id p20mr21016321eds.42.1629129397047;
        Mon, 16 Aug 2021 08:56:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i11sm5047064edu.97.2021.08.16.08.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:56:36 -0700 (PDT)
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from
 L2 in int_ctl (CVE-2021-3653)
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210816140240.11399-6-pbonzini@redhat.com>
 <YRp1bUv85GWsFsuO@kroah.com>
 <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
 <YRqAM3gTAscfmr60@kroah.com>
 <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad855723-fe97-6916-8d96-013021e19fc7@redhat.com>
Date:   Mon, 16 Aug 2021 17:56:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 17:37, Maxim Levitsky wrote:
> 5.13 will more likely to work with the upstream version.
> I'll check it soon.

There are a couple context differences so I've already tested it and 
sent it out.

Paolo

