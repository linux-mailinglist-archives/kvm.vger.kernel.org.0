Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A3B10EFE1
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 20:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfLBTNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 14:13:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728083AbfLBTNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 14:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575314026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Koo47jDt4Xn6t4/WFfWrAz0JUqLFx+2S884BamowWg=;
        b=K2gNIKPARxFOJnYywHTcSElI+pofWhBhqPnEpxROjV4WY3PKkoRucMLatufTD7Ba9zhlTi
        VRKEwqUkRRpx+wT3HQVlS/xnFSSNjsvBQM+PBJCnfl3nWosBcoP0kIe3mWxpFdCGgB3zL9
        0FiCiE8+nlzkOe7bdAk1vniQ4S/aoVQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-Kfk7ScPNN7muNRUvYtBO0w-1; Mon, 02 Dec 2019 14:13:43 -0500
Received: by mail-qk1-f197.google.com with SMTP id q125so383869qka.1
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 11:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BioxUrJcAILXuwKr65jwIWwsCyr6BnKmW1bpxxUtOyM=;
        b=R3FjvNJm/004wJcuf+DtoDMzl4pL8acNGi8bKwQmAs8bmaAqdmdnCBABS6C26/wiQT
         h5Hu9vKR6vKAVDZr48E70pqmBBPJE36BaZA2dopq0ZGCjdXGasP98XsN5KQrk7ibp+HE
         rFm0kwuHL6uIwwH2hSqMdG6Ox9N1I8MOeX7IAyjRrBmH59h1FXK9DL7WGRoW3Y9vMCO8
         HyLMdmPyZ5bmcCTvILvpGmge1t9P4Hj0PydiLAKrDDxRx1plv9arYLFF6q4ub93Gjoo+
         lXx38sm6PmaGSi//taps/CdyAG4x7yxQ1SeWCbBTHQh5ZWknDHK6SZEZdaP2Ii1Iq0e9
         LM3Q==
X-Gm-Message-State: APjAAAVX86ydWzNVXosu6sQ9TGawwz/AKpViLluskAbndzaq3AKqgAnd
        GQnRjG/5Wu287Yt5GF8+3YaPmbC4YBk+1db3fwqGgr4f72VNZTEcUn09Yb6c1aU4ykKHfG6/kEb
        mPyFC/C1ntpeY
X-Received: by 2002:ac8:4712:: with SMTP id f18mr157197qtp.68.1575314023537;
        Mon, 02 Dec 2019 11:13:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnuJWazul2T04ohiAVs6sW/FPS0cM2fqg2o7jLwMh5Eg9j29fvLxb5xtdrZSNZquvLP8lCMA==
X-Received: by 2002:ac8:4712:: with SMTP id f18mr157161qtp.68.1575314023236;
        Mon, 02 Dec 2019 11:13:43 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q73sm268156qka.56.2019.12.02.11.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:13:42 -0800 (PST)
Date:   Mon, 2 Dec 2019 14:13:41 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Some cleanups in ioapic.h/lapic.h
Message-ID: <20191202191340.GC10882@xz-x1>
References: <20191129163234.18902-1-peterx@redhat.com>
 <20191129163234.18902-2-peterx@redhat.com>
 <87k17fcc14.fsf@vitty.brq.redhat.com>
 <20191202174741.GC4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202174741.GC4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: Kfk7ScPNN7muNRUvYtBO0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 09:47:41AM -0800, Sean Christopherson wrote:
> > kvm_apic_match_dest()'s implementation lives in lapic.c so moving the
> > declaration to lapic.h makes perfect sense. kvm_irq_delivery_to_apic()'=
s
> > body is, however, in irq_comm.c and declarations for it are usually
> > found in asm/kvm_host.h. I'm not sure but maybe it would make sense to
> > move kvm_irq_delivery_to_apic()'s body to lapic.c too.
>=20
> asm/kvm_host.h is generally used only for exported functions, internal-on=
ly
> functions for irq_comm.c are declared in arch/x86/kvm/irq.h.

I think I'm fine with either lapic.h or irq.h.  Let me do with irq.h.

I'll try to avoid moving the body of kvm_irq_delivery_to_apic() if you
don't disagree, I think it's ok to be in irq.c, while I'll normally
avoid doing those churns because I wanted to keep the git history
clean so it's easier to read the history per-line of that function. :)

Thanks,

--=20
Peter Xu

