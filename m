Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0F3ED955
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhHPO6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:58:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhHPO6j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 10:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629125887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ioeiNnp8tClwq5SGhpQi9ejqmj1i1k7xbprFS2Msh8=;
        b=AIYksPRzKbEp5oeB6U8nPSbCrkKqHUfmhLkOVnzP7jGYKHjZAc13qsAkPSvwr9Ogeu5gTf
        P4FJou1OlX0K+UIVc3cGvo/GXQ1IB+5yMvMw4YH4gAK4F++gfwFSDEl0Vf8NhjPzxieqtn
        ZcdxKhFwE+y47rcPxdUkXq5fIln9UsY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-eE1w2ueMMvCGs0cUp96e5w-1; Mon, 16 Aug 2021 10:58:06 -0400
X-MC-Unique: eE1w2ueMMvCGs0cUp96e5w-1
Received: by mail-wm1-f71.google.com with SMTP id o3-20020a05600c510300b002e6dd64e896so38227wms.1
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ioeiNnp8tClwq5SGhpQi9ejqmj1i1k7xbprFS2Msh8=;
        b=i/UpSa3MX916Q7wyKAUzMgTcS8hw4i235d1+ex2SEliOenG4dkrod74JXjZilB0ASo
         8UBfpZ3shnVb/RNFR5VaVD9LVkgnSWkn+BRoxnhA6aFX596om0BwOYH6YDimf9PX/jOt
         Hsfp66eeqdRhjqudmeumb6I9jpCO0Tla0dUljn9FAHNHCusM+s2VsSi1SwBKHWCHfRpn
         dbbNQ/wNNeN+lcJzvfUcirj5Xtb7esaleo+4JRbX/qJULYAel0+JiH9t8CuAMIyuXUaY
         sdtMQRriInw2mzqXl7plnS4oiRZpYljxM3gKzARkvAQqev+AO56Gvkxre5PUBSGmFQgz
         oaBw==
X-Gm-Message-State: AOAM530cj1L5VvOkFbc27fXeZ9yyByvpcfURt3IsVT2p++uzthbTBgP8
        w0H/oMMxhtGk76I8fNqUfxhYtMVOCKjZTPEx+wLoBzTql1HY5vc4Rjdr1xkaNULgdxDfnBwm39N
        DTQgqMXgJ2QqQ2zkQp0LFt+8flrKMpfi9P1xystboyd9ZJeZPnLDRxWivAyfgqYPm
X-Received: by 2002:a5d:42c9:: with SMTP id t9mr19031960wrr.356.1629125884868;
        Mon, 16 Aug 2021 07:58:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmZmFLMNwCgWpunBMWfLzO2EV47hCpJpp+zBxS6t3ApfzdeOZSeEc/IYgsFGdxI5iuYNWfnw==
X-Received: by 2002:a5d:42c9:: with SMTP id t9mr19031927wrr.356.1629125884570;
        Mon, 16 Aug 2021 07:58:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id z1sm11798056wrv.22.2021.08.16.07.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 07:58:04 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
Date:   Mon, 16 Aug 2021 16:58:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816144413.GA29881@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 16:44, Ashish Kalra wrote:
> I think that once the mirror VM starts booting and running the UEFI
> code, it might be only during the PEI or DXE phase where it will
> start actually running the MH code, so mirror VM probably still need
> to handles KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> accesses and Debug Agent initialization stuff in SEC startup code.

That may be a design of the migration helper code that you were working
with, but it's not necessary.

The migration helper can be just some code that the guest "donates" to
the host.  The entry point need not be the usual 0xfffffff0; it can be
booted directly in 64-bit mode with a CR3 and EIP that the guest
provides to the guest---for example with a UEFI GUIDed structure.

In fact, the migration helper can run even before the guest has booted
and while the guest is paused, so I don't think that it is possible to
make use of any device emulation code in it.

Paolo

