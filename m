Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2AA4115A8
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhITN2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239673AbhITN0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632144328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbgRxY1Kwyd5e8Ybt8IMEeqXmoKho8XjkJuR4TeH6UA=;
        b=egEtzuDPleOs5h24EfTK3Zlxs0G2/5X2XL+aY9qgppYyPzTIaGwv/z8zBbh/CjpVYs9wpq
        DkDdeyeYSjQIM/wqD28JFu0gIR4dPUb62YQ7we7HY58JZ3Y80iGgkpzuZbnivR6gs1nkx1
        cnYOMUjcISpF0IB15RLzx4paHxRUCGs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-LODDWeW0NKu7JW1O4TqVIg-1; Mon, 20 Sep 2021 09:25:26 -0400
X-MC-Unique: LODDWeW0NKu7JW1O4TqVIg-1
Received: by mail-ed1-f71.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso15606796edi.1
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 06:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbgRxY1Kwyd5e8Ybt8IMEeqXmoKho8XjkJuR4TeH6UA=;
        b=w/26ZhMOpHiFpVVDJNIXkSw/ekWnP6vZ+GuwWFMJ0KbZzXa5sDWM+MrqnrHk20tO8V
         48yHhe4aq2T/uPRdy42VdJWs6KL9AVdyWCdmKbG7DBuCaBUO6nNTTbazZhaArQElP+9E
         GnQ9sgqSum6+hPhyMNOhB95Mh+x8MwL1BRnnUo9eq1PNeswzGsfEbSuJnYuQ8wjn3MKI
         z48qVSuSQwV0d4XcU0cM88ggHlkkkcKFwkgPfXNcPjaZcZw8LkxmTTetlf4GjWEKf1wA
         nJeqAUF7KUW0T4cI2OzPcuSB57hSkQxRXjiP+AV7YGsQor5VyUwGRj3vrn5lwX2XAkRk
         00Gw==
X-Gm-Message-State: AOAM533KMGdxeXDqii49hHsEAbQ5sOrks3biZH0hLNuTZA2fKlgZuYMs
        Cpjb3IxNvI+NF1FTFNJ6SBQINl+qigGrTnK9T7Tg1NRQq5A+BIb82jkFax25O8xHP5LXGHrjjtZ
        3Ure/YzjSQnoS
X-Received: by 2002:aa7:d6c7:: with SMTP id x7mr29573529edr.180.1632144325556;
        Mon, 20 Sep 2021 06:25:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLYE9jEem7SAWRV34u22CAUUh9OWwyzW8vzAsRSoIpdWAdoor6vNz9n92Gjou/xYgF8O4zsA==
X-Received: by 2002:aa7:d6c7:: with SMTP id x7mr29573517edr.180.1632144325398;
        Mon, 20 Sep 2021 06:25:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dn28sm7045838edb.76.2021.09.20.06.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 06:25:24 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/1] svm: Fix MBZ reserved bits of AMD CR4
 register
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, drjones@redhat.com, babu.moger@amd.com,
        krish.sadhukhan@oracle.com
References: <20210916184551.119561-1-wei.huang2@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b4829dd-1e7c-da10-e4a1-35971e8b6492@redhat.com>
Date:   Mon, 20 Sep 2021 15:25:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210916184551.119561-1-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:45, Wei Huang wrote:
> According to AMD APM, Volume 2: System Programming (Rev. 3.37, March 2021),
> CR4 register is defined to have the following MBZ reserved bits:
>    * Bit 12 - 15
>    * Bit 19
>    * Bit 24 - 63
> Additionally Bit 12 will be used by LA57 in future CPUs. Fix the CR4
> reserved bit definition to match with APM and prevent potential test_cr4()
> failures.

So the difference is LA57 and CET.  Queued, thanks!

Paolo

> -#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
> +#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U

