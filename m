Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E565416B9F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 08:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244213AbhIXGe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 02:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244198AbhIXGex (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 02:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632465200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P05/Oq4ySEY6PLih3XN6eaMzxFSGFF7LNUzRL1MRuoQ=;
        b=f4iC8ud87ICq48mVuIiejmPm90+y0zSNv4nLhzKLid3z4XcJCEbf6xbVh4yvePD4LOIzaI
        SObSnhvFZnIn8ScACmOnibjp6rf+caiwGGmiXamY9d2gmRRf08jCRNiRJLnTu1X+C8azEf
        DeMn+0LME855rEfFDFeBkDKas2v3eMw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-k45dTEtSNv-dBBpobN3q4Q-1; Fri, 24 Sep 2021 02:33:17 -0400
X-MC-Unique: k45dTEtSNv-dBBpobN3q4Q-1
Received: by mail-ed1-f70.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso9243411edp.13
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 23:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P05/Oq4ySEY6PLih3XN6eaMzxFSGFF7LNUzRL1MRuoQ=;
        b=ck7QkSBh3Yk0h5TIfzBR6KvMsf7RUnP0mXOAABuJNkKkafiGzt+we21PHnpr6h1V/4
         X31RE7zjZtQI80KBicPoXej5yi2c0ZDffgZ6MvqwoLX2pTzd83djzkh5j+ItE27KWFzi
         7dmCCCqU5lMLUSPt4cAfvxLBfRJyJ05d/P01Uq/8orCaXhaLoV9kBHYGUxTYa0+63Yvc
         Hphl9cOcDerwxN3eCZt3d38mB4uKFaeN9PuvPAXji0ua0GaR1kn0hDajZaoIKDAKLSaE
         UkWJ2FJUt56ZoirYr/aDCaIOyXS8UxoIWNPoLB4GyRd4wsbjDC/ICzK9GrBkS4kBm/It
         ndbA==
X-Gm-Message-State: AOAM530iJKKD5HApneQ401G/0+9w8YBPIvRhkzClBQLpiIUQJZtW7xJP
        Qk0p2CGX9UxKHLLJTojUw0MLmNo0UYcfGjVv7RGeMRLcqLzOobbI88bJhJAxfO/0pDj+ivBdBOS
        ucl10TJVV6sqO
X-Received: by 2002:a17:906:f24f:: with SMTP id gy15mr9224853ejb.226.1632465196072;
        Thu, 23 Sep 2021 23:33:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXgobudpoDKOnIq3JWwoEm3aUCb6qIbPZcX+UZAQMZ3+Oz06EeQPINrQYM2ebvFFCNKXc+nw==
X-Received: by 2002:a17:906:f24f:: with SMTP id gy15mr9224842ejb.226.1632465195921;
        Thu, 23 Sep 2021 23:33:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id 5sm940766ejy.53.2021.09.23.23.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 23:33:15 -0700 (PDT)
Message-ID: <720d5e5d-bb11-b415-cf1e-d83d324906d7@redhat.com>
Date:   Fri, 24 Sep 2021 08:33:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Explicitly use movq to read xmm registers
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210924005147.1122357-1-oupton@google.com>
 <YU1amie6LL/5JY8w@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YU1amie6LL/5JY8w@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 06:56, Ricardo Koller wrote:
> Reviewed-by: Ricardo Koller<ricarkol@google.com>

Queued, thanks for the patch and the review!

Paolo

