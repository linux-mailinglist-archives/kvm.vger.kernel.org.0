Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7493CC0875
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfI0PVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:21:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfI0PVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Sep 2019 11:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569597704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=y1QOcujYXJSx6Zp27l1JXUc8QrisUQvzFNnC89dhwt4=;
        b=JVcniSfLBA/Q80GVrQAfMlFCBjQ2tCXafhJRBuA3E3aRfUFvUKa9VCXjPzmitYmv8ZgQxn
        /5eSD6L5hcEZb2I1WLcw8lvnfPHgzFl0uwGMNQHesjxkG8JTY2qbjlFK9PpN2eTyUXG9Fu
        3kfGyDe4US9lJQ841/fsR/gKVcuM/FQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-TwIIt0GeMGudN033DfbnVA-1; Fri, 27 Sep 2019 11:21:40 -0400
Received: by mail-wr1-f69.google.com with SMTP id z17so1213888wru.13
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EDks5KWssk2FKDVq4nArg/L0AVSqAJR9jNhv+jkYA2E=;
        b=sBCPaDEzc1HMS/8Gtb0dkeepo7ZwiQoz5PkYkpr5mWZzYopt17xogkh1gzGqKDxbla
         eWc0opRyCkaP+UGS8xsBGO6jgnrLmbRR+R6NI/l+wAG+ys7OPvMBuFGS0tGuby2yUIOR
         aJQK0Q69clp61vhoNmIhnp/4eg8rONQxNlIYHB4GzfsTQf7N6R0H3NIEvOGcJ64pLcfB
         K6njNohQ3luPtUA7t+FybUt8oYDT1FS8As1ObQnDHXNaK6gWK/zNCN9BRzvpPWYAaLXB
         bkKq6ucd5Q6UZStmkK+Dub4sBRUDL6S4N5xIIMHxMExBIgEu633IQllTNDFlG3SD0KUD
         a9/Q==
X-Gm-Message-State: APjAAAWirRLtXDq/mvnj6hmEukRcY4N07754Nsg+4SDnUy2yx6zQkwbm
        tsG5yhdwAWa9vIv5YGhUwwXAx02SP6LIecxgXD3qoLEnsKikclLA7tiVTpe1wHD3Y9AM20ewAvs
        Jtjoim6S9f4Ej
X-Received: by 2002:a1c:1b0b:: with SMTP id b11mr7491460wmb.82.1569597699164;
        Fri, 27 Sep 2019 08:21:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwnLLgLP3PKSnG/Onx9U0FR2PqhorKC4wP0ms6656LzUk+M60AaUJoY+aQhce2aGHgado7YAw==
X-Received: by 2002:a1c:1b0b:: with SMTP id b11mr7491440wmb.82.1569597698902;
        Fri, 27 Sep 2019 08:21:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id v6sm11126915wma.24.2019.09.27.08.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 08:21:38 -0700 (PDT)
Subject: Re: Suggest changing commit "KVM: vmx: Introduce
 handle_unexpected_vmexit and handle WAITPKG vmexit"
To:     Liran Alon <liran.alon@oracle.com>, Tao Xu <tao3.xu@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
 <8edd1d4c-03df-56e5-a5b1-aece3c85962a@intel.com>
 <9E41E337-A76D-4AE7-90A6-1CDD27AFC358@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fb780187-4507-600d-9467-4742e5fe9be9@redhat.com>
Date:   Fri, 27 Sep 2019 17:21:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9E41E337-A76D-4AE7-90A6-1CDD27AFC358@oracle.com>
Content-Language: en-US
X-MC-Unique: TwIIt0GeMGudN033DfbnVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 16:55, Liran Alon wrote:
> Why is it confusing? Any exit-reason not specified in
> kvm_vmx_exit_handlers[] is an exit-reason KVM doesn=E2=80=99t expect to b=
e
> raised from hardware. Whether it=E2=80=99s because VMCS is configured to =
not
> raise that exit-reason or because it=E2=80=99s a new exit-reason only
> supported on newer CPUs. (Which is kinda the same. Because a new
> exit-reason should be raised only if hypervisor opt-in some VMCS
> feature).

I agree that it's a bug compared to how other unhandled vmexits are
treated.  I didn't want to rewrite kvm/next or have a revert, so I have
sent a pull request but this should be fixed.  I'll wait for Liran's
patch or come up with one.

Paolo

