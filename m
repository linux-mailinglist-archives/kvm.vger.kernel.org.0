Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDB312353C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfLQSqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 13:46:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31286 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726623AbfLQSqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 13:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576608410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZjRKmHuvnoVKMirbirXU2qUqtR+sRTFhW7hH7QT1ZU=;
        b=BeAjs3MnG3mwhtN2yDaJ2VOk5wUb7K2bgWbr4obeafn2MDEF0V0Dh07vnM2B75q6zHoOt4
        EZxNvwZxEXIzMTTogHEbLCL1bdMXYsZZ07O+MpPke6uMbgsPTmPU21g25Y0m5eK4JW3tpn
        G8mQTmSwN0N3KMNXghL3t/Cpl4nXmEY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-lacmH-AtNjuQbPvaodHrMg-1; Tue, 17 Dec 2019 13:46:49 -0500
X-MC-Unique: lacmH-AtNjuQbPvaodHrMg-1
Received: by mail-wm1-f69.google.com with SMTP id f25so17223wmb.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 10:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=IZjRKmHuvnoVKMirbirXU2qUqtR+sRTFhW7hH7QT1ZU=;
        b=Z6q47ZDtCZEqtrsoQJ65F9AchgNT8Kg71jCwUCL+Yy0eCO56d9Nxtd9EckWItdLop/
         oOSkrbmcbOZ1I+jfGbhB1y0z4pmKcj4dVtUjCzWPAQlm5nz98BYfZqNCrvJKrxa/wpr3
         6msYJt2BfIwPE98llTMZPBup1U5t1vDSCMql9emBFS/qxsMLmrxyFi87i5hGVks9GNqw
         2HtGzTzVCFpRWrj7/I6y0Mc4ioQY07Qc+IE1A98F0k5nbsVIsAgyxZPByO7SH3Y4p/uz
         MawALEylP2Ix9BF4iL5x/PsenT4Je2Bqo6/ZmPABikRMyEOleN8S4VTcObKrI31PfE0M
         e1fQ==
X-Gm-Message-State: APjAAAVqRdk3g2s/re7iEdThOJIO6w0D/SNJaankHuNhTwgfAMWNh3IH
        kdkJAH0Uy5WCwaAb1UABmMPbYyFS6RTHPLrsA1q7kgnxnTl/Crzoo6+oIkMApShuRwlP11TPXLi
        0F+OSW2yIGR2d
X-Received: by 2002:a5d:6708:: with SMTP id o8mr39021295wru.296.1576608408740;
        Tue, 17 Dec 2019 10:46:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPvlk+TwbhCe+kHYv7eZKZShKxj66b/JxKprHybJXtulfbUtBwnBztokfND3OEGYr34Cq8KA==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr39021257wru.296.1576608408527;
        Tue, 17 Dec 2019 10:46:48 -0800 (PST)
Received: from [192.168.3.122] (p5B0C64F3.dip0.t-ipconnect.de. [91.12.100.243])
        by smtp.gmail.com with ESMTPSA id g25sm3943341wmh.3.2019.12.17.10.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:46:47 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v15 3/7] mm: Add function __putback_isolated_page
Date:   Tue, 17 Dec 2019 19:46:47 +0100
Message-Id: <08EFF184-E727-4A79-ABEF-52F2463860C3@redhat.com>
References: <1a6e4646f570bf193924e099557841eb6e77a80d.camel@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
In-Reply-To: <1a6e4646f570bf193924e099557841eb6e77a80d.camel@linux.intel.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
X-Mailer: iPhone Mail (17A878)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 17.12.2019 um 19:25 schrieb Alexander Duyck <alexander.h.duyck@linux.in=
tel.com>:
>=20
> =EF=BB=BFOn Tue, 2019-12-17 at 18:24 +0100, David Hildenbrand wrote:
>>>>> Also there are some scenarios where __page_to_pfn is not that simple a=

>>>>> call with us having to get the node ID so we can find the pgdat struct=
ure
>>>>> to perform the calculation. I'm not sure the compiler would be ble to
>>>>> figure out that the result is the same for both calls, so it is better=
 to
>>>>> make it explicit.
>>>>=20
>>>> Only in case of CONFIG_SPARSEMEM we have to go via the section - but I
>>>> doubt this is really worth optimizing here.
>>>>=20
>>>> But yeah, I'm fine with this change, only "IMHO
>>>> get_pageblock_migratetype() would be nicer" :)
>>>=20
>>> Aren't most distros running with CONFIG_SPARSEMEM enabled? If that is th=
e
>>> case why not optimize for it?
>>=20
>> Because I tend to dislike micro-optimizations without performance
>> numbers for code that is not on a hot path. But I mean in this case, as
>> you said, you need the pfn either way, so it's completely fine with.
>>=20
>> I do wonder, however, if you should just pass in the migratetype from
>> the caller. That would be even faster ;)
>=20
> The problem is page isolation. We can end up with a page being moved to an=

> isolate pageblock while we aren't holding the zone lock, and as such we
> likely need to test it again anyway. So there isn't value in storing and
> reusing the value for cases like page reporting.
>=20
> In addition, the act of isolating the page can cause the migratetype to
> change as __isolate_free_page will attempt to change the migratetype to
> movable if it is one of the standard percpu types and we are pulling at
> least half a pageblock out. So storing the value before we isolate it
> would be problematic as well.
>=20
> Undoing page isolation is the exception to the issues pointed out above,
> but in that case we are overwriting the pageblock migratetype anyway so
> the cache lines involved should all be warm from having just set the
> value.

Nothing would speak against querying the migratetype in the caller and passi=
ng it on. After all you=E2=80=98re holding the zone lock, so it can=E2=80=98=
t change.
>=20

