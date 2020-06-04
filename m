Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7F1EEDEA
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 00:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFDWrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 18:47:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726565AbgFDWrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 18:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591310870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XASiRYDVjPrE/pa/1MmZ5LDpkQAntZhxxgkJZkVE2R4=;
        b=h4a07fbegu2SMCfG1yJFXaMH4NaCWOnh8K2iq+cKDC6D+4c6YJO5/sR9N7Pj3/C82loxb5
        VPoEDy3SlFZouitd1e6mmLgubj9XNpkPab4ABNf8uR+b+JP4aGPLioCGOIVutDWDlia+lf
        4LIuUYpgwPfXpNp74AvSQcM2hNxDkCo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-nK4V7xh6M7aGn9JpJnEKdg-1; Thu, 04 Jun 2020 18:47:26 -0400
X-MC-Unique: nK4V7xh6M7aGn9JpJnEKdg-1
Received: by mail-wm1-f71.google.com with SMTP id 11so2201160wmj.6
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 15:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XASiRYDVjPrE/pa/1MmZ5LDpkQAntZhxxgkJZkVE2R4=;
        b=JBd95+GGZq1wD3ZzbFVzd2686oeIFmsBI+G3aHIosbE0Jr1EBxjVgHpa/40UT0R/9L
         0FSbAQqYRlpzJSKSrzVNV4KAPkgpWj3o2Jqg2Hwb1bdQgmuqzKxTnGDfYD2/E+JxD7qP
         xJXv8whaND0KgQrBEUvNqXFrWLuqIdskAkkd0DAZpaIpDRkRCmDrcgeRoYVsQO907XnC
         NN3t2h/6KqWqOKuM3lwTMjc4A7CVn8k1KOqw7teUi2O0H1He8+XPS4FOyarUbHsFg9PG
         2eUM9/cD9GM6/Fw9zfIMo33XWPP8k3A9viqV0LNsIRWF7tp7BTygTaZpkx2XI6lMo0b+
         92WA==
X-Gm-Message-State: AOAM531WBw7qLldZ1/5ypugdqaB7T7EnoP+JctXsVXSXbr9Q7bsYkZES
        MrwSn3UrLxZ3KTNbQntDFZHrW5rwvjeZZgRNhEJ3b5Yv0M8xH5Ns7KduxiYrISS840BDLS6SBE4
        TF8y6qX+DRNGe
X-Received: by 2002:a5d:4404:: with SMTP id z4mr6683878wrq.189.1591310845457;
        Thu, 04 Jun 2020 15:47:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlkk5SvPBnPSUvXvWnaamBXc4TawEXxNTXO6msjT+msfHOTDq37cmuivNkSAgN0hreVjyO+Q==
X-Received: by 2002:a5d:4404:: with SMTP id z4mr6683847wrq.189.1591310845161;
        Thu, 04 Jun 2020 15:47:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id z16sm9711667wrm.70.2020.06.04.15.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 15:47:24 -0700 (PDT)
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-ppc@nongnu.org, qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <87tuzr5ts5.fsf@morokweng.localdomain>
 <20200604062124.GG228651@umbus.fritz.box>
 <87r1uu1opr.fsf@morokweng.localdomain>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com>
Date:   Fri, 5 Jun 2020 00:47:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87r1uu1opr.fsf@morokweng.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 23:54, Thiago Jung Bauermann wrote:
> QEMU could always create a PEF object, and if the command line defines
> one, it will correspond to it. And if the command line doesn't define one,
> then it would also work because the PEF object is already there.

How would you start a non-protected VM?  Currently it's the "-machine"
property that decides that, and the argument requires an id
corresponding to "-object".

Paolo

> That way, compatibility with AMD SEV is preserved but we also get
> command line simplicity where it is not needed.

