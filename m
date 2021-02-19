Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECC31F94B
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBSMRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:17:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhBSMQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 07:16:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613736930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7UkzvW7YzAkDU1Z3fCAUqBMPy3CC83kWNUoEw+T4Xs=;
        b=A7pJfdAkDNk8Tfnqcf9iBYPkRbGFsOTnAmaPJp205sE/qju8eyzFw5aak7/XHHvgjOr06D
        yYbc8QOuVqfvwkRcfXhGw7vU92RgdQjUxVf828KFloVwOKKKZddSGPp3/ji8v7uSn/dnkh
        415fWJ9sMoF/I16/vkW2m8roJhnqu68=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-6PwhzhUbMHSsNYp-5GsOFA-1; Fri, 19 Feb 2021 07:15:29 -0500
X-MC-Unique: 6PwhzhUbMHSsNYp-5GsOFA-1
Received: by mail-wr1-f69.google.com with SMTP id x14so1771137wrr.13
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 04:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k7UkzvW7YzAkDU1Z3fCAUqBMPy3CC83kWNUoEw+T4Xs=;
        b=AR1Bqb3wVZOEKPKCPOKPjbZIGWRY4FGuYPPO8SNhqekp/OiitMntUuVhz4ERZMb3J0
         gSOiv1eZPNQ2a0HXKvAjZl3TYvDggcLj1mW1gTdqOcJeqSP8uHup8BZDqttnoVBKjzjh
         gjTbLsjL4UZiQexm3H3klDp6Q4hqacwl6wj1/XcQMuzmDp0IZYZPhJs/NEj0IG+fUibX
         5e+gZhF0pDGR08iTpPC9QG75tj3+jv81bmAzF/lgKV2Tf40bJhrB1j3ZJ7JaPh++SzsQ
         zAl5AtaLpfRMBF6CF29b1gvSFzCK3///71rwVoAGz7j4CmkyzJIO2mbWxGxzL+paiuwu
         xoBw==
X-Gm-Message-State: AOAM531tF3eyjoAG8NZYZSo9H6NE9/b8sGNi/YCA1Lz9AvNMNzMZGb0v
        y6hY/4LZ91lk6f4wZamaeIYt5HEilOpzBAkjvmJG42biCMOG7Kh3niBEnrfwj0MtVJaXyAm2wx1
        hIQ8dM9IgMqT5
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr8682300wrq.136.1613736928111;
        Fri, 19 Feb 2021 04:15:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmQclYO9ZhqzgZzBU9ISHEPtCdoxK2Zha9Xp+WzEh2+CWGZrXpFAc+rT0z/qrpMS6UCHdkEA==
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr8682284wrq.136.1613736927988;
        Fri, 19 Feb 2021 04:15:27 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id d15sm13126267wru.80.2021.02.19.04.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 04:15:27 -0800 (PST)
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <YC+oZWDs3PnWHPQo@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <9540912b-1a81-1fd2-4710-2b81d5e69c5f@redhat.com>
Date:   Fri, 19 Feb 2021 13:15:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC+oZWDs3PnWHPQo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/21 1:00 PM, Daniel P. Berrangé wrote:
> On Fri, Feb 19, 2021 at 12:44:21PM +0100, Philippe Mathieu-Daudé wrote:
>> Hi,
>>
>> This series aims to improve user experience by providing
>> a better error message when the user tries to enable KVM
>> on machines not supporting it.
> 
> Improved error message is good, but it is better if the mgmt apps knows
> not to try this in the first place.

I am not sure this is the same problem. This series addresses
users from the command line (without mgmt app).

> IOW, I think we want "query-machines" to filter out machines
> which are not available with the currently configured accelerator.
> 
> libvirt will probe separately with both TCG and KVM enabled, so if
> query-machines can give the right answer in these cases, libvirt
> will probably "just work" and not offer to even start such a VM.

Yes, agreed. There are other discussions about 'query-machines'
and an eventual 'query-accels'. This series doesn't aim to fix
the mgmt app problems.

