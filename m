Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D580D47C6BC
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 19:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbhLUSlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 13:41:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237012AbhLUSlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 13:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640112069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuXvMVBgPkcC4bssaqxCL8o/Urd9sxPp4kAV+3sZ2Pw=;
        b=HnNXaq7qwIjhpoS66lPb4CgwTOYNQTuGIdJmkGYrX5vtzpt0kw5Z4u7RwDmn/uEueaWMvK
        74X/XcQ+Cpu1nupQxMuklXuczK9oC3sf28d+t79osDqeleFdbt3SngpKzRsB+Oktq7Xb1o
        xK8vsWgMhzzC8iMYyZ+S1XQ/ah/6FzE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-JZar39ASOc64G8NgrRFB9w-1; Tue, 21 Dec 2021 13:41:08 -0500
X-MC-Unique: JZar39ASOc64G8NgrRFB9w-1
Received: by mail-wm1-f71.google.com with SMTP id v190-20020a1cacc7000000b003456d598510so1642923wme.6
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 10:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OuXvMVBgPkcC4bssaqxCL8o/Urd9sxPp4kAV+3sZ2Pw=;
        b=FaoCW3+aPCgF1hZGRGZUTUl8TORrjN6zDSbLgJK+ATWAoVwNTK5/mMGCQBGzxQzFPl
         wLiBR9um0pKk/ZCGJpXJwqsKk1dw7ImJl2IJibNqjUbXD5ptQEclFkDfDKqzbj0ZQK13
         bbrt3V3hxqUKXEVQFThC3mnhA11dwypZSeyOKS0LXERzVPHs+mnbWZXsfou622wUlJo4
         EI5Mo3jyudbhQ49NlRiCZND67IHE186HXCgAfWGwVPF7rIuMZmbo2oh0OQ+Am+oKMGXt
         BHsahndwcDStROKz/UZxindoBRs7fwoN/njx4m4njIoi7ALGMjvpw3PLLtq7CeQwbfFm
         c5gw==
X-Gm-Message-State: AOAM533Mcdio3x5xRCHofa6LEkcPvMEtz64KqYSkydUIHA7bcvdh1I5P
        sKM4qAolBWDu4GEEXv0R1KK7ex20IZ46d0xZyTtG8QP9j8M2pCSOOOwS3jg6lBK3/g+PnNEAUOU
        0ECU8PhMo9tb4
X-Received: by 2002:a1c:cc0f:: with SMTP id h15mr3843002wmb.38.1640112067177;
        Tue, 21 Dec 2021 10:41:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhXc12lA864aBzj2Wv1/GXJ/rJfU4ohEmYhTErGNpZGU1SI/y93362YUwUd3TySNWCEvujVQ==
X-Received: by 2002:a1c:cc0f:: with SMTP id h15mr3842987wmb.38.1640112066960;
        Tue, 21 Dec 2021 10:41:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p18sm5514695wmq.0.2021.12.21.10.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 10:41:06 -0800 (PST)
Message-ID: <be53a3f3-071a-f309-a1be-00d893dee470@redhat.com>
Date:   Tue, 21 Dec 2021 19:41:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL 0/6] KVM: s390: Fix and cleanup for 5.17
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20211220181104.595009-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211220181104.595009-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 19:10, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.17-1

Pulled, thanks.

Paolo

