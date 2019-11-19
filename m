Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6124F102554
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 14:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKSNZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 08:25:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30605 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSNZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 08:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574169945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zuIFrepTI5XGjnmu7SZRBXm2ypngTSYro2lLoyi+D9U=;
        b=JLQtEiSI+NwnDBeKKHxGV7Dn6VNrdnoyJjvOcG08/jhiAad552Dw2oWGSfk9jyK1rZ09MD
        in5WpOznWffBqUBfz+Q6RFJClDxegOI4sIIcoDZRSUh/Sf+jIFJvUleQZkMjTHTJXqnyNK
        EL24j8nv+9mM1AY4CYwA00kiMTnj+Lg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-FzSI37vnP_6E5yp397RuFQ-1; Tue, 19 Nov 2019 08:25:43 -0500
Received: by mail-wm1-f71.google.com with SMTP id g13so1431399wme.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 05:25:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UWribs4bV+tz4KZQ/7HRXELXyhGEq0/rpuN5CPg+cLU=;
        b=n293lOW01t0G3gYoB4FPsH3xGaHD7e9HyqXjosZKPA6gyJY/Gz3thEI8ArqfAV+leN
         1wQU7ySa66S3y73yIDDR3GyM5USAj6VsG7r7PDsphK8ACLlKBFuogEDjMXFPWAN9us7F
         ZoPESL97DWdwIfDCafOBEuD1lnqO0VHTWKRZqFZ7EFFRBInZvjz43oyVOl7SrlG89NaM
         bNmcBg7vsHfzk8wJIzlK8GOQAcqWxHOXS7LDDWeUT5A9VtMY0uM6u2+QcbmX/3c2eZIS
         EQjj+d/DW3smH3+W4xC8IfTdMywCDWjGx+EPSTM9Or+Ke3kGbzC1AFU6UL20kbgYx+jI
         g1cw==
X-Gm-Message-State: APjAAAU2T2Crb58rvsztd5XTMFe9OzxSqFJ/d7S9CLMHZRkQEO8lc271
        /qrvGMsc3H1lKtAeLn/XiHd9YzA5OOKqGidTnm9msJA0s44NTf8nY9KiOOHQ9uQhjBQwL54mOSb
        Ttli0fV8b40NL
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr26061340wrx.310.1574169942737;
        Tue, 19 Nov 2019 05:25:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyt0XLcdpHWEe/n4GPIDIIm1F1+q8ZirrEBw+e15nvX+SUzCfY2GLvuKgW2pCfMt5pAjJsTA==
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr26061309wrx.310.1574169942433;
        Tue, 19 Nov 2019 05:25:42 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u13sm2968880wmm.45.2019.11.19.05.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:25:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
In-Reply-To: <20191119123956.GC5604@kadam>
References: <20191119030640.25097-1-maowenan@huawei.com> <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam> <87imnggidr.fsf@vitty.brq.redhat.com> <20191119123956.GC5604@kadam>
Date:   Tue, 19 Nov 2019 14:25:40 +0100
Message-ID: <87a78sgfqj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: FzSI37vnP_6E5yp397RuFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Tue, Nov 19, 2019 at 01:28:32PM +0100, Vitaly Kuznetsov wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>=20
>> > On Tue, Nov 19, 2019 at 12:58:54PM +0100, Vitaly Kuznetsov wrote:
>> >> Mao Wenan <maowenan@huawei.com> writes:
>> >>=20
>> >> > Fixes gcc '-Wunused-but-set-variable' warning:
>> >> >
>> >> > arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
>> >> > arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
>> >> > used [-Wunused-but-set-variable]
>> >> >
>> >> > It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
>> >> > IOAPIC scan request to target vCPUs")
>> >>=20
>> >> Better expressed as=20
>> >>=20
>> >> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to ta=
rget vCPUs")
>> >>=20
>> >
>> > There is sort of a debate about this whether the Fixes tag should be
>> > used if it's only a cleanup.
>> >
>>=20
>> I have to admit I'm involved in doing backporting sometimes and I really
>> appreciate Fixes: tags. Just so you know on which side of the debate I
>> am :-)
>
> But we're not going to backport this hopefully?
>

In case we're speaking about stable@ kernels, 7ee30bc132c6 doesn't look
like a good candidate (to me) but who knows, it may get pulled in
because of some code dependency or some other 'autosel magic'. And
that's when 'Fixes:' tags become handy.

--=20
Vitaly

