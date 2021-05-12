Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A827237BB40
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhELKtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230129AbhELKtM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 06:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620816484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HawenKJcX93/Kf64cToc0lOfSdPyP11wwRNo7KhYrQ=;
        b=aOpWHZwqcw7JaF+/VYUg+sOesV4pvLrScKzjvcjnQyTYEHOxsxmrorbaVKKkJ+FULHBAAS
        qFlLvijELhNVfqdJ4VAjWtamwO8fcuifskxKhsRbUc26u3wlNC/zQazvmFh1nfg+S5Y7DO
        Aax1hnWSB8a+lLMemlDQbxHiMrrnZN8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-DqgmDU3UNEWBC_N6yHHrGA-1; Wed, 12 May 2021 06:48:02 -0400
X-MC-Unique: DqgmDU3UNEWBC_N6yHHrGA-1
Received: by mail-ed1-f69.google.com with SMTP id h18-20020a05640250d2b029038cc3938914so917703edb.17
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/HawenKJcX93/Kf64cToc0lOfSdPyP11wwRNo7KhYrQ=;
        b=Lm9AeqGbdup7dnERoEwZ2TxGxQlY6sM6+dzQR1gkaj0dnQBPd9c2X2s6tmk6F6iW8p
         cF6TfOz1Ok14XouyXfExYLd0jgQaM2dgLF6QdwOIxgu4CcFwgObqvRlRU44XOlsfKNfx
         jbOF9m8zIlpJ/+1iI3o8U4yCz4JpGdEyi5FFSuR3YEPNmDThkBiIBQMwjQsNqWYaHC5O
         s+2L/K6G9nbmFY2hymkoVKpipDWMIaUsVLef9tBQxcAK1pBtKyb9/v9Qn8bpTGDojl9v
         HR28Ip43D1GbL0PIJP1fx+SAL4oqvdZon0f/c1OfePfimxBa+9u5weGP6HjJOdgtWDUC
         CK1w==
X-Gm-Message-State: AOAM532VWNc2+rUX8RacPWraskFK+gElrzuaJN7Jnq0mf93YQoifWCHA
        ObDvRSAnjlc1uoLAStlynu3KNpUL+wEmSeVZhBLc1W1RZcv810YxdQgtNyiIkk5C+p3SwfVOWW4
        kc0GDJv08/Z3XTNe3tPzwAJKXJhNKi2U5NeMkBHCJnaA45EbyT94WHouM0YPOcAEM
X-Received: by 2002:a17:906:3bc6:: with SMTP id v6mr37588365ejf.165.1620816481148;
        Wed, 12 May 2021 03:48:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2zBNiswoVfm3HtObttQYz8ODuLWKT2lh+0kVm2RbahjhxjB8/sCVU71ON375Nj2dBcjYQ1A==
X-Received: by 2002:a17:906:3bc6:: with SMTP id v6mr37588352ejf.165.1620816480861;
        Wed, 12 May 2021 03:48:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o13sm14091324ejx.86.2021.05.12.03.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 03:48:00 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/2] libcflat: clean up and complete long
 division routines
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
References: <20210511174106.703235-1-pbonzini@redhat.com>
 <20210511174106.703235-2-pbonzini@redhat.com>
 <3255ae16-ee2d-861d-d7e8-9360e7eaa09c@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3216c48-3e96-8d8d-290e-25d7754874be@redhat.com>
Date:   Wed, 12 May 2021 12:47:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3255ae16-ee2d-861d-d7e8-9360e7eaa09c@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/21 12:39, Alexandru Elisei wrote:
>> +
>> +	/* Copy sign of num^den into quotient, sign of num into remainder.  */
>> +	quot = (__divmoddi4(num, den, p_rem) + qmask) ^ qmask;
> I see no early return statement in the function, it looks to me like the function
> will recurse forever. Maybe you wanted to call here __*u*divmoddi4() (emphasis
> added) instead?

Of course...

Paolo

