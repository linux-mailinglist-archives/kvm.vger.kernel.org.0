Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15B8F9C59
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKLVdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:33:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLVdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573594394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=apvF/+PBT99p/+GngvqMt0gongEPRLUHJbqLkax5zKk=;
        b=JBdviS96ce5BmY3OnWVVTOJi3/0OmgKj14tLFXXXVMBXcPkIRN/g5uZMGnpPoBrV8u6a1x
        cBSEY2Ugu/DUeaqglG/1W1+J/5e7+pYM33sAxkpb0E71WiL88w4NJLyMb6ZdVdNStlkx2j
        5iWHKxaXvEztAH10JHZecXB5l2N+eEo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-TXk8wWyFNueWZkfQx9t-Tw-1; Tue, 12 Nov 2019 16:33:13 -0500
Received: by mail-wr1-f71.google.com with SMTP id f8so54226wrq.6
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 13:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=apvF/+PBT99p/+GngvqMt0gongEPRLUHJbqLkax5zKk=;
        b=jjvDBu3kSPp4NlLDJlZx6FFcNjHRhFUJ7hdUcgGLPDeBuljT1SRu82wwn8dsjmkfvq
         LFzv8mKaAAk04tnNHVWWsVeOkUPbiTJceVFa0ffFrRrCxrcxGf7dXwzwKGZ6OBC94fUS
         dMh/lbtaeVPcb22grRL1zKiNs092sLTiWihNtn4OT8CIHAxYWuGHNnH5MjgtnvTSMyFV
         cVSYZzZb9DdcBbsv5TuYNoD0v/KdcCfctrlIA+j2nQwTQUtF/YqmOuaac5ag/FPPrHHD
         3WutmPm/aIyzBlQJxSEy3L4f+860dMM1An3UWu7oj2K999Bq5guIonN+G8xzOE19Cazk
         10mw==
X-Gm-Message-State: APjAAAWffbCfYbajEMG0s/Hn0yyUpM1FmIkKmUes+vCoj9W6AtppqwfW
        lStE8mX+ZWwAeSWrv966Beg2xKVUklqDifBoAxL/IhFpLU5qGEk+1a42J49qA8OIat29RhqR/19
        RaUMMgTmVl2D6
X-Received: by 2002:a1c:9601:: with SMTP id y1mr5674886wmd.157.1573594391837;
        Tue, 12 Nov 2019 13:33:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1I8PJlwVaiQe0THPl1xlemvb30kE4eh6T1y8r6NmBDFnNIb5EVpHyc6RGbobIWt7/n+/AKg==
X-Received: by 2002:a1c:9601:: with SMTP id y1mr5674868wmd.157.1573594391554;
        Tue, 12 Nov 2019 13:33:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id o187sm4558524wmo.20.2019.11.12.13.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:33:11 -0800 (PST)
Subject: Re: [GIT PULL] KVM patches for Linux 5.4-rc8
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>
References: <1573593036-23271-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wibywR7ySaBD=H9Q0cc1d86+Z1Sg3OWUsDjUvj21dZAKQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b21e7ce6-6151-87dd-9d20-e39b788d523e@redhat.com>
Date:   Tue, 12 Nov 2019 22:33:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wibywR7ySaBD=H9Q0cc1d86+Z1Sg3OWUsDjUvj21dZAKQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: TXk8wWyFNueWZkfQx9t-Tw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 22:26, Linus Torvalds wrote:
>> It's not a particularly hard conflict, but I'm including anyway a
>> resolution at the end of this email.
> Hmm. My resolution has a slightly different conflict diff, that shows
> another earlier part (that git ended up sorting out itself - maybe you
> edited it out for that reason).

Yes, I edited it out to point out the one that matters.  Sorry for the
confusion.

Paolo

> I think I did the right conflict resolution, but the difference in
> diffs makes me just slightly nervous. Mind checking it?

