Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6085E2E27
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393213AbfJXKId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 06:08:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28217 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733071AbfJXKId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 06:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571911711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=esfJDYJMPsiYJ7u3DFXauyQeLcWZdIkwkXmgSu/9TW8=;
        b=WWHSqdZ9eOGWI7w1V4Cyv1cOMy1QLQUKD+wfZTJZ5KCCP8ZmcqMcstdbnHs2BUlN2L/iC5
        Qnvif2OTKHTpNPIQBWGpKHx+6g1str83uq3//FBUh3/n8U0Pa7fpZncch2MX5PqVBSLhyP
        fG2fmia/wVWQMMRqmp0uu/ejE8MtwZI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-OrDZpQlHNlSXHvRd63u8Fg-1; Thu, 24 Oct 2019 06:08:29 -0400
Received: by mail-wr1-f70.google.com with SMTP id a15so12660196wrr.0
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 03:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=esfJDYJMPsiYJ7u3DFXauyQeLcWZdIkwkXmgSu/9TW8=;
        b=AsDIoe0OR9Aren21a2LVklLPPygSaKfG4Zp2kKAxomru0RV2x8V8JP8doQAj2KXZ68
         T1Jbc+zu2/76NEA3h3a/16t8Qy5hOxD5fpB5IwCQm5f2i9p4IRXYl4zvcSrtQ0QcuQlm
         mlGMbOvF2lBT8pijFI95T3PJnwp6vmENsvjA/It9AK7e/N7XSdLOWg8LA4JW6Bh/+Y6Q
         cNNv/Rfzkee0/k9INpiBJzmlwa2KhHS4+vTh8H4xkb+Wr8ttiBtTz+izxepNg1QNS/Ye
         gDtjmnZ3ME3lIuIbWkA0Sy6krurblB1PMxE6/geFfVSMJ52VbzSHD0ibTlTGCH3PIHnE
         FkBQ==
X-Gm-Message-State: APjAAAWD1rg90lmgTENE5QMM8K3RIhczd9A80lvWBTiERVhBeFGufmrH
        L6smqbeHtPKM/FnPzEfPz0GwbnPRfICXKd5mcAybPXfva1Ql5alL398mpf/mMTMGmUmQYkOb+s0
        LnTM5OmuSr6gE
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr4259500wmg.109.1571911708726;
        Thu, 24 Oct 2019 03:08:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwoT31QViboEUM71fzfc96nrE841J4xIaOvKoEhYnhXjxkLBWS/1xAfeou95adRq9sBgr5PbA==
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr4259479wmg.109.1571911708456;
        Thu, 24 Oct 2019 03:08:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6887:47f9:72a7:24e6? ([2001:b07:6468:f312:6887:47f9:72a7:24e6])
        by smtp.gmail.com with ESMTPSA id f8sm2054415wmb.37.2019.10.24.03.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 03:08:27 -0700 (PDT)
Subject: Re: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, John Sperbeck <jsperbeck@google.com>
References: <20191023171435.46287-1-jmattson@google.com>
 <20191023182106.GB26295@linux.intel.com>
 <7e1fe902-65e3-5381-1ac8-b280f39a677d@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4d81887e-12d7-baaf-586b-b85020bd5eaf@redhat.com>
Date:   Thu, 24 Oct 2019 12:08:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7e1fe902-65e3-5381-1ac8-b280f39a677d@google.com>
Content-Language: en-US
X-MC-Unique: OrDZpQlHNlSXHvRd63u8Fg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/19 04:59, Junaid Shahid wrote:
> AFAICT the kvm->users_count is already 0 before kvm_arch_destroy_vm()
> is called from kvm_destroy_vm() in the normal case.

Yes:

        if (refcount_dec_and_test(&kvm->users_count))
                kvm_destroy_vm(kvm);

where

| int atomic_inc_and_test(atomic_t *v);
| int atomic_dec_and_test(atomic_t *v);
|
| These two routines increment and decrement by 1, respectively, the
| given atomic counter.  They return a boolean indicating whether the
| resulting counter value was zero or not.

> So there really
> shouldn't be any arch that does a kvm_put_kvm() inside
> kvm_arch_destroy_vm(). I think it might be better to keep the
> kvm_arch_destroy_vm() call after the refcount_set() to be consistent
> with the normal path.

I agree, so I am applying Jim's patch.  If anything, we may want to WARN
if the refcount is not 1 before the refcount_set.

Paolo

