Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4463411AA8F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 13:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfLKMQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 07:16:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32600 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727365AbfLKMQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 07:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576066562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qhLvO9cL+UDJahGIPe42tFkxybZ/1jdKLiaU29uZrPo=;
        b=ftD3mLFVe1mHQEMTQsyvl7ecZOXg2byvzmCXl4JhJ9nbFNkPereQGhzJmoKqbzEeYjU/uq
        I5dxDlbiTF90NKWY3cHO0qh9Xghc3hq4O3aknwW5CfUC0DmUfAZbQ3N8ze2TpbJwO+Fhps
        i7aJTVmsdNQYUVQT930nXOdSRM1u/2g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-_Nrtu_PEMheXkyfINxMqWw-1; Wed, 11 Dec 2019 07:16:01 -0500
Received: by mail-wm1-f72.google.com with SMTP id z2so1661012wmf.5
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 04:16:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=D8e4mTzdBGTwYrfLOn2tAfgoLGMbKdwCqYeYEhuffzg=;
        b=DnkcbOeQwRJeUi/0NZQ6XWuceuc93YpRGEI9MXsES0orh5rGGNRHo4SFb7q/8nbAMB
         jQVjbK4l8JQtkiwdkpvC99dv75h9BggbLsUKtU79LaJn3J2MA/F9CE+Or5BI/doS/paw
         WLVgW1Q/8M6hdp8rTBFCe4BJv76WpoQUDXxL07oVYtv+x846gHbsP3nYepCn0wOGdaWC
         FT7DCL0VdYRUqC4D1nYB46SipSGpoyA3xVKLyA14q7cHpFbmmcwYzyKqwWxOoki3VLbo
         CDSK0nInzKrbypLOefOu2tiaQ0zmEm9AFMn0qmgIRhUGPSb/muzygHHGWXNuQaqSUxyp
         yOvw==
X-Gm-Message-State: APjAAAVF/+1g4v8CX9esFpNu4EZcUvXcXJt0Zcf1fabNvcqyTPbOfoZ4
        zN3h7YuxxBKGJWejqD2gW3g7cB6dYNhgYDqDCj+/EO/y2Ayu13HtEVBxSC7DuW16nNvglU64qeU
        AE/MTa5K4ATw1
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr3667239wru.112.1576066559915;
        Wed, 11 Dec 2019 04:15:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwITh/QBWQs0if0PQQDdy7GL/k9szr4VjFabTb3OB8IvV3Gkxo29URndvAVFZ0PSckijIJSTQ==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr3667194wru.112.1576066559449;
        Wed, 11 Dec 2019 04:15:59 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s25sm2004831wmh.4.2019.12.11.04.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:15:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
In-Reply-To: <9159a786-6a5f-e8be-33b8-19a765cedd68@redhat.com>
References: <20191210044829.180122-1-gshan@redhat.com> <871rtcd0wo.fsf@vitty.brq.redhat.com> <9159a786-6a5f-e8be-33b8-19a765cedd68@redhat.com>
Date:   Wed, 11 Dec 2019 13:15:58 +0100
Message-ID: <87y2vjawht.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: _Nrtu_PEMheXkyfINxMqWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> On 12/10/19 7:45 PM, Vitaly Kuznetsov wrote:
>> Gavin Shan <gshan@redhat.com> writes:
>>=20
>>> The filter name is fixed to "exit_reason" for some kvm_exit events, no
>>> matter what architect we have. Actually, the filter name ("exit_reason"=
)
>>> is only applicable to x86, meaning it's broken on other architects
>>> including aarch64.
>>>
>>> This fixes the issue by providing various kvm_exit filter names, depend=
ing
>>> on architect we're on. Afterwards, the variable filter name is picked a=
nd
>>> applied through ioctl(fd, SET_FILTER).
>>=20
>> Would it actually make sense to standardize (to certain extent) kvm_exit
>> tracepoints instead?
>>=20
>
> Yes, It makes sense, but it's something for future if you agree. Besides,
> It seems that other kvm tracepoints need standardization either.

If we change kvm_stat the way you suggest we'll have reverse issues
after changing tracepoints fields: updated kvm_stat won't work with the
fixed kernel. I understand that kvm_stat doesn't have to work with
anything but the corresponding kernel tree and so we can change it back
in the same series, but wouldn't it be an unnecessary churn?

I'd suggest we standardize 'exit_reason' field name now just to fix the
immediate issue, it shouldn't be a big change, probably the same size as
this patch. Changing other tracepoints to match can be left for future
generations :-) What do you say?

--=20
Vitaly

