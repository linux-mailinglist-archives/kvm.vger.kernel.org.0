Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EDE1583C3
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 20:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBJTdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 14:33:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20156 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727604AbgBJTdM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 14:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581363190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMGTDJZkPMbNI+3IMfPL5+AglR9F0y1G1+wx9lx+BsI=;
        b=TcPQpmue+JLSX8FYKYt9F8+9+ilvj9HwZGbs5qLxrXEOkODtkXwierfmqq4q80RrCRKf7y
        Ke7ytNffFrFPTaWc44oF6dm2aKDNQ1R0CrVXV4WHMUFvmFCcx/Om1kQLqMMgbC6L61UsNz
        EHMfaZxtljDmaCydJLjPCuGGWSqJNxk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-i2rUGfZGNU2OfFOEN89h9Q-1; Mon, 10 Feb 2020 14:33:08 -0500
X-MC-Unique: i2rUGfZGNU2OfFOEN89h9Q-1
Received: by mail-wr1-f70.google.com with SMTP id s13so5520750wru.7
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 11:33:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=KMGTDJZkPMbNI+3IMfPL5+AglR9F0y1G1+wx9lx+BsI=;
        b=EYErjQSqsDPxyMoQxhxfzlnZt0JFIo+ME/5oYxeSLoisDNth/mQkdJh9epcAPXHaI5
         fLvYZb40nrlIvCxag4prZ8IA3EQvfSF2V+o4NtBaVB4bI5hItBqt1/f8RMjJlK5dQ35Q
         KsVl7W0XnZePQXso9SJaWfSwG92EBvTlAyqu6dLIDxuzP9gqlXyHmH1POQ61XQpCSEt3
         Pi+zk4YNNIDYSY3D/+j9jyKa0m1Gxsm0WJv72QMoMql9bBZ194+QExDUD7HIhBDmDEi1
         +Yn13KF0V3fagJoxxYy58HAkJGtz3Oc2eyMmILqKzKoBmC015BgV20PITvlA3wjQHMvB
         1SjQ==
X-Gm-Message-State: APjAAAUch4r1baTJD1+WgVvf2hIhrXJDpRp91CvTKslpAgclwa0Qjxs6
        hJQl4lhneIxQiUbO34MTOvz9R2+yoz8uWzhKMp/Jc1tVrw+tOlDaIv25Ti0ENI++2y45RSs/IgX
        Plt0mH/BlWiGk
X-Received: by 2002:a7b:c651:: with SMTP id q17mr547563wmk.5.1581363187537;
        Mon, 10 Feb 2020 11:33:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOFQo4U+msfHUzbyhRVj8cg0iNrOibhxMs/UaxDfGLpnaLdW3bHIUiRE0Ps7lwZNvo2fOj/g==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr547530wmk.5.1581363187308;
        Mon, 10 Feb 2020 11:33:07 -0800 (PST)
Received: from [192.168.3.122] (p5B0C6A1F.dip0.t-ipconnect.de. [91.12.106.31])
        by smtp.gmail.com with ESMTPSA id a16sm1803138wrx.87.2020.02.10.11.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 11:33:06 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 02/35] KVM: s390/interrupt: do not pin adapter interrupt pages
Date:   Mon, 10 Feb 2020 20:33:06 +0100
Message-Id: <567B980B-BDA5-4EF3-A96E-1542D11F2BD4@redhat.com>
References: <083a3fd0-7b56-e92b-bf15-3383b7f5488b@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <083a3fd0-7b56-e92b-bf15-3383b7f5488b@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 10.02.2020 um 19:41 schrieb Christian Borntraeger <borntraeger@de.ibm.c=
om>:
>=20
> =EF=BB=BF
>=20
>> On 10.02.20 13:26, David Hildenbrand wrote:
>>> On 07.02.20 12:39, Christian Borntraeger wrote:
>>> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>>>=20
>>> The adapter interrupt page containing the indicator bits is currently
>>> pinned. That means that a guest with many devices can pin a lot of
>>> memory pages in the host. This also complicates the reference tracking
>>> which is needed for memory management handling of protected virtual
>>> machines.
>>> We can reuse the pte notifiers to "cache" the page without pinning it.
>>>=20
>>> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>>> Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
>>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>=20
>> So, instead of pinning explicitly, look up the page address, cache it,
>> and glue its lifetime to the gmap table entry. When that entry is
>> changed, invalidate the cached page. On re-access, look up the page
>> again and register the gmap notifier for the table entry again.
>=20
> I think I might want to split this into two parts.
> part 1: a naive approach that always does get_user_pages_remote/put_page
> part 2: do the complex caching
>=20
> Ulrich mentioned that this actually could make the map/unmap a no-op as we=

> have the address and bit already in the irq route. In the end this might b=
e
> as fast as todays pinning as we replace a list walk with a page table walk=
.=20
> Plus it would simplify the code. Will have a look if that is the case.

If we could simplify that heavily, that would be awesome!=

