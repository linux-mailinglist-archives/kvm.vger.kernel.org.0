Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3011A766E
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437057AbgDNIuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:50:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50915 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437051AbgDNIuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 04:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586854250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrqnSK2z2Mx9WULK9xxD9Z7/6kzhbQXBsftTQjmd+zc=;
        b=N0IidgBR9gTMm2YEjy0t7cpQhakOGNI+ZzzniqXxgzNc+oX8HLXKTLkNHzaNHB43Agg5EU
        YaskvrYiWKgZWosY3yyr67jaFIIfuRG3GHMUidS1dtqK7cvO4zWQtGucFugjmPSHqWsfUn
        FwdvI8k3k9OO1zREaZG8oxOsGE6HdfI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-dd70Rp5rPyijN55WpAYDBg-1; Tue, 14 Apr 2020 04:50:49 -0400
X-MC-Unique: dd70Rp5rPyijN55WpAYDBg-1
Received: by mail-wm1-f70.google.com with SMTP id h6so3458200wmi.7
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vrqnSK2z2Mx9WULK9xxD9Z7/6kzhbQXBsftTQjmd+zc=;
        b=XndIUnDI6ubi7YC/7F+LjOQPU3dXHmqDB39W8o8oYwrCmzOsdATW55fDxPr9cmjuZd
         V5aarzTbhznOPnG10e3fdLPbBnPxs3lTKdrQnMvYuOKHxIBd4S7+eA6JMDgzA6QjaYLd
         MEbMULE3RI1TOHyJjsokDnJwxO3suOgVGzPaq/+Jl9KSBtlDvjDGMwVNgs8atEbyzu5E
         Z7/MKtCilKSX4ldi+axQGRNWCd8bpiKw7flkqZ3R3Kvr0JtUqmORvtmNoAVm2inTkdQ7
         Tzdvqmj33h12K2b9dEhrhhVARJGPAQPuqR5xcqVJ2FuLhiqG7k/50esO0w4eQusrhRyc
         PruQ==
X-Gm-Message-State: AGi0PuYDFjqpWLLk1sh+BiMZ6BHO5NCfdUTAoyykvZvPykzpWLQ/YR5v
        8K3ltGqThUfsrhn3bLD7ZeNtLr2fptAqY5RD733R2+oDb3cNHs3T4DBzW933yOkOgLoM41u31sp
        1sCkH7rcahA9r
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr24058919wmj.156.1586854247933;
        Tue, 14 Apr 2020 01:50:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypKDkwl9jMwHEP6EvtHIRdrpN+MHMbdxTbJaVcT6czlc4Y4KI/h1zD4uhe7xAmkIs58BFidPcg==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr24058904wmj.156.1586854247667;
        Tue, 14 Apr 2020 01:50:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c37:bdc0:470a:460c? ([2001:b07:6468:f312:6c37:bdc0:470a:460c])
        by smtp.gmail.com with ESMTPSA id q8sm17446443wmg.22.2020.04.14.01.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 01:50:47 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: SVM: Use do_machine_check to pass MCE to the
 host
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200411153627.3474710-1-ubizjak@gmail.com>
 <265cb525-6fa7-d1a0-b666-5b17fc590e42@redhat.com>
 <CAFULd4Z25D9J2PUJBMx07ubAHnRDuML5bwg6COGmw_uW=L-DKg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0daba26-db83-cfc6-a498-d87ee491e9d9@redhat.com>
Date:   Tue, 14 Apr 2020 10:50:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4Z25D9J2PUJBMx07ubAHnRDuML5bwg6COGmw_uW=L-DKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 10:38, Uros Bizjak wrote:
> Will do, after the confirmation that the patch works for AMD hosts.

Ok, I will test it (I found an AMD machine with EINJ support).  In the
meanwhile I queued the VMX part.

> OTOH, the function is just a simple wrapper around do_machine_check,
> so I was thinking to move it to a kvm_host.h header as a static
> inline. This way, we could save a call to a wrapper function.

Yes, that works too.

Paolo

