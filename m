Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBA3DFE6F
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhHDJzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236483AbhHDJzI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 05:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628070896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IVyRjDmeX+wbvqFuUsJ5xLBNN+y9TnRnqtbgDhoq1nM=;
        b=GX9CB2qYjrMAqdyo5lgqZTTquYuf6xvep7NeL72DOvQ82qjJOfb/epdRHkU13yk89+MTfZ
        N7tAQQWzuNpRuULKyEpvht3u/YlVpOBgsElw+Go9dIxFU4hnP1Le4k+Z802plGl8z8K85d
        FMzxPR3YBBG6Wo7Syzx2jJm3Hp7cfsU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-wUqhYAr7PZK6FP7TUhV76w-1; Wed, 04 Aug 2021 05:54:54 -0400
X-MC-Unique: wUqhYAr7PZK6FP7TUhV76w-1
Received: by mail-wm1-f71.google.com with SMTP id y186-20020a1c32c30000b02902b5ac887cfcso286521wmy.2
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 02:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IVyRjDmeX+wbvqFuUsJ5xLBNN+y9TnRnqtbgDhoq1nM=;
        b=J4p6m/yLL8UW0kOpvUwfeiLhmXtv9e1wY3TcqsxDeVVcrm+yVG4vJqk5pJWkNb2LXM
         n7TTG8o35jm/c5OeNAK+Xl5MsvrOpP4TLvKk+9guQdTnz4tbs3kgquMhKdZePAYNh8GL
         jQPF6dnJIOD2BZx2jXH2GwnZIHrqtR6OU8cuIYAJtUdpXKjhyvKFWKyJuosP5mp3hAJD
         p5P14Omkiyv04XJtBONGJVnhiXQzRu10Y7Yi87ILkvcWNiQTlEL0Ji1+XtMJY013SmZx
         vZzA4VoDP8p06nDVgTGkgxww3OLWt4hT4SaRIEPqxnojTPt8AwLydCmrmIWxZWSWmjtO
         2n3w==
X-Gm-Message-State: AOAM533WOVQB3eDq7xI3yUqUnJbKZ2mc7ZFtlyDmJOFrVdCjB0vnWrA4
        9RBrEL2agqjY/KVH8SkloHLnfxwT959kosQ0GWXNQ4+en9Xg1G2V7Fjl9+hM0JymfWJWSNKnEGH
        NPfNqqg4nEhGw
X-Received: by 2002:adf:e652:: with SMTP id b18mr28298499wrn.349.1628070893681;
        Wed, 04 Aug 2021 02:54:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEzjSkw2SNBjsVvvj0XG8DdnV1HOS2cohTznkyoER8S0vQ+eZzwQZxWq98BnI25UUDHEHBBA==
X-Received: by 2002:adf:e652:: with SMTP id b18mr28298474wrn.349.1628070893524;
        Wed, 04 Aug 2021 02:54:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id o17sm1815503wrw.17.2021.08.04.02.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 02:54:53 -0700 (PDT)
Subject: Re: What does KVM_HINTS_REALTIME do?
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, Jenifer Abrams <jhopper@redhat.com>,
        atheurer@redhat.com, jmario@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
 <CAM9Jb+jAx8uy0PerK6gN2GOykQpPXQbd9uoPkeyxZSbya==o5w@mail.gmail.com>
 <CAM9Jb+jNUrympkjUMnX3D0AMTfZOuHYbF+-VDb10AiXybW-e_A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bef63d3a-d8e5-03c9-521e-7b287247c626@redhat.com>
Date:   Wed, 4 Aug 2021 11:54:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAM9Jb+jNUrympkjUMnX3D0AMTfZOuHYbF+-VDb10AiXybW-e_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/08/21 11:06, Pankaj Gupta wrote:
>> Do we need to mention "halt_poll_ns" at host side also will also be disabled?
> with KVM_FEATURE_POLL_CONTROL
> 
> Sorry, pressed enter quickly in previous email.

That is done by the cpuidle-haltpoll driver, not just by the presence of 
the feature.

Paolo

