Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A62A10CEF8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 20:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfK1TsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 14:48:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44782 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbfK1TsJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 14:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574970488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvPlK3FY9i9H+9TL/UAhr/vwa8L3atPNKvm4SjuaV3w=;
        b=fOyjFuQzkJ0+87KxgS2HWf9olXL2kLvrKYhs06y74pEZR45yaGqztL3IgIZO5IIV2qEn3w
        nRKwaHC40JOWL72Z5B8DQoEonVRICO8VCZjinBzj9ZM97dHbMboeQjEbiZaiRMjWc2JB6Y
        EEGrM9zJdYyA7PP9GWiVWr7+zhP7gq4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-CpIUvA30NzC3wSsr8NAmmQ-1; Thu, 28 Nov 2019 14:48:05 -0500
Received: by mail-wr1-f72.google.com with SMTP id d8so10375200wrq.12
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 11:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=YvPlK3FY9i9H+9TL/UAhr/vwa8L3atPNKvm4SjuaV3w=;
        b=gARjqsXMI9GFqp0L+Gpir3CeqDKWylTl5qsGmgOd4LYqTcsymJK1j7pzxSR5SE2AO5
         jUjgZp1Wl/u6WP2YY1tc0bPJRvyNSKshalq/KDG1uah3OGcqiSIiGM+7PUYsj289igSS
         BQ1LJdiWKkWWHLokxVgPAmMEjryDDhddr71y4Q4EnTUPgzfcr5twqNGQ4lIXqZ2rQcs3
         1SX2WNxgeBvWucfJjpeBt0eISoGb/TJqXwsdUTiNHubKH3iA6SALe2j4kyP3YX93+nf0
         93li16ZKLTJg6InBCFCckVWtPuyxML3BKfm9kdB21HStON+mLrZDbztZqQIeKHMKpQ2E
         cbFA==
X-Gm-Message-State: APjAAAXzbiLHM4Jf48YHyvsM0T60J7VUYsvx+1gvFC67QzDcT5jvXizz
        YkFmhbtneiQ5X95XSxdmx0C3J3RzFlEI6Bbx3ezxzA3ZrNWwJlvZpLA/e4L3pivjGDwyrP+GbkB
        NXRAgfPXpmKJr
X-Received: by 2002:a5d:6048:: with SMTP id j8mr13791683wrt.41.1574970483646;
        Thu, 28 Nov 2019 11:48:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqyy8wMkFJhMkD+2MNkZuc7gOpe6rl3TIYCocJrmP0KBpHq6nlsnOURLQwVa6Ah+CifS9sUkNA==
X-Received: by 2002:a5d:6048:: with SMTP id j8mr13791671wrt.41.1574970483494;
        Thu, 28 Nov 2019 11:48:03 -0800 (PST)
Received: from [192.168.3.122] (p5B0C6369.dip0.t-ipconnect.de. [91.12.99.105])
        by smtp.gmail.com with ESMTPSA id h140sm11725884wme.22.2019.11.28.11.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 11:48:02 -0800 (PST)
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: Define the PSW bits
Date:   Thu, 28 Nov 2019 20:48:00 +0100
Message-Id: <30DD27E7-BE6E-4986-AD69-7718E6B9A730@redhat.com>
References: <7abb4725-b814-8b43-8a4f-e0e2cf7a44f8@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
In-Reply-To: <7abb4725-b814-8b43-8a4f-e0e2cf7a44f8@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
X-Mailer: iPhone Mail (17A878)
X-MC-Unique: CpIUvA30NzC3wSsr8NAmmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 28.11.2019 um 20:16 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>=20
> =EF=BB=BF
>> On 2019-11-28 15:36, David Hildenbrand wrote:
>>> On 28.11.19 13:46, Pierre Morel wrote:
>>> Let's define the PSW bits  explicitly, it will clarify their
>>> usage.
>>>=20
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm/arch_bits.h | 20 ++++++++++++++++++++
>>>  lib/s390x/asm/arch_def.h  |  6 ++----
>> I'm sorry, but I don't really see a reason to move these 4/5 defines to
>> a separate header. Can you just keep them in arch_def.h and extend?
>=20
> no because arch_def.h contains C structures and inline.

(resend because the iOS Mail app does crazy html thingies)

You=E2=80=98re looking for

#ifndef __ASSEMBLER__
...

See lib/s390x/asm/sigp.h

