Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79A5118511
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 11:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfLJK2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 05:28:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47310 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726574AbfLJK2k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 05:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575973719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=qQLjE6x+Qqsvkr5Q/eTHtuJougeuX+xHRNz4ZzjEMxU=;
        b=Mnb3r03YHYAeFNO4XfEci8fzEyYawL9w2k6p/ja5eTDiHlgag/m4sI7xhryqfgZz9+lXMj
        tQTeIS3eNVgkUByU9+7imJX3/pQE4/2EtaqHFir53djYjxoCnWy5392MbJV6dcPZ1Y8uDe
        bsd8JqgJfaXpPmJTNLyvIZVYI+O30qk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-Tqi9PExFNc-hjF8XHbhBOw-1; Tue, 10 Dec 2019 05:28:38 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05782DBF5;
        Tue, 10 Dec 2019 10:28:37 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-158.ams2.redhat.com [10.36.116.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96C5C6FDDF;
        Tue, 10 Dec 2019 10:28:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 5/9] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-6-git-send-email-pmorel@linux.ibm.com>
 <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
 <c37b0a10-358d-08be-7a59-20048b7af620@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <23770c1c-8aba-85ef-09a1-346393bb90d6@redhat.com>
Date:   Tue, 10 Dec 2019 11:28:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c37b0a10-358d-08be-7a59-20048b7af620@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Tqi9PExFNc-hjF8XHbhBOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2019 11.07, Pierre Morel wrote:
>=20
>=20
> On 2019-12-09 12:49, Thomas Huth wrote:
>> On 06/12/2019 17.26, Pierre Morel wrote:
>>> These are the include and library utilities for the css tests patch
>>> series.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>> =C2=A0 lib/s390x/css.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 259 ++++++++++++=
+++++++++++++++++++++++++++++++
>>> =C2=A0 lib/s390x/css_dump.c | 156 ++++++++++++++++++++++++++
>>> =C2=A0 2 files changed, 415 insertions(+)
>>> =C2=A0 create mode 100644 lib/s390x/css.h
>>> =C2=A0 create mode 100644 lib/s390x/css_dump.c
>>>
>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>> new file mode 100644
>>> index 0000000..6f19bb5
>>> --- /dev/null
>>> +++ b/lib/s390x/css.h
>> [...]
>>> +/* Debug functions */
>>> +char *dump_pmcw_flags(uint16_t f);
>>> +char *dump_scsw_flags(uint32_t f);
>>> +#undef DEBUG
>>> +#ifdef DEBUG
>>> +void dump_scsw(struct scsw *);
>>> +void dump_irb(struct irb *irbp);
>>> +void dump_schib(struct schib *sch);
>>> +struct ccw *dump_ccw(struct ccw *cp);
>>> +#else
>>> +static inline void dump_scsw(struct scsw *scsw) {}
>>> +static inline void dump_irb(struct irb *irbp) {}
>>> +static inline void dump_pmcw(struct pmcw *p) {}
>>> +static inline void dump_schib(struct schib *sch) {}
>>> +static inline void dump_orb(struct orb *op) {}
>>> +static inline struct ccw *dump_ccw(struct ccw *cp)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return NULL;
>>> +}
>>> +#endif
>>
>> I'd prefer to not have a "#undef DEBUG" (or "#define DEBUG") statement
>=20
> Anyway hawfull!
>=20
>> in the header here - it could trigger unexpected behavior with other
>> files that also use a DEBUG macro.
>>
>> Could you please declare the prototypes here and move the "#else" part
>> to the .c file instead? Thanks!
>=20
> What if I use a CSS_DEBUG here instead of a simple DEBUG definition?
>=20
> It can be enabled or not by defining CSS_ENABLED ahead of the include...?

Why does it have to be in the header and not in the .c file?

 Thomas

