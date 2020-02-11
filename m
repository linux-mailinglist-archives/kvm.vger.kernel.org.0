Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D2C1595E9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgBKREh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:04:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727436AbgBKREg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:04:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581440673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pVasLlAXrbuX/G7lTFwAzDA95FldSPgS2d9mYCqPyE=;
        b=KuG3UTL1zdh2oGpINOpXAhf4EM6NR7NDUrIeRg42jaXfO1d4A6A+QmkIU/L0t5wcWsxONJ
        2R6hQWEaSF4OxwPwlr2nqsXcFRJZvKemjz8pv35e0L5M4nzpyS1upvmUrQrZDkt8kBUTwS
        kcYwayf2PK6T8q0q9wdi8AA+2M7+dbA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-mVm7npRIPUGTgaeTxVTs_Q-1; Tue, 11 Feb 2020 12:04:31 -0500
X-MC-Unique: mVm7npRIPUGTgaeTxVTs_Q-1
Received: by mail-wm1-f69.google.com with SMTP id s25so1724975wmj.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 09:04:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=+pVasLlAXrbuX/G7lTFwAzDA95FldSPgS2d9mYCqPyE=;
        b=jRXBBsO8+WUbrGr+LmYMZtPHqxZrUU8UJwrIFJe+xc5MEG7dShA6B0YqEBRN1jxSRZ
         3knzmeLunjp6SznPDdLl0hNdyqk8JabYSIwxtfUgDwOUY19nwSpdaFEmsSwHCuobRTnM
         64F69PXbYaNHToBWlxplvpTpdefXNm6jSVlL3M1RgWfNdOPesmQIpW82MXHhRPL+JM4w
         bWuvGNhLgUut/wUF65gtHbyVSQVwwg8mDhAr6MfQQ50gOSRwBI55JjcJ2tAnPDhlauwl
         5OCz98WR6EDVKJMUcyrpFiAYVQB1iEg2npjiN8Av39Itb2bFGxN+stzE8QUYRW3HoKV5
         O1Fw==
X-Gm-Message-State: APjAAAUl2W8S6I1IP0fQejdwQM9IwvHc5o9dtIQKf/I/3kKtDHLS7TeC
        kJd6a6IBfC0OH/ytHG3EjvI9T7rryeBaoFxOPBxlEqv+mYVpDrAdeOndIVouiEYn2WK9E88HntV
        EpuODRgnMhMXF
X-Received: by 2002:a7b:c93a:: with SMTP id h26mr6919381wml.83.1581440670339;
        Tue, 11 Feb 2020 09:04:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzMCDV526/z9R5lcDc3NhDo6UURiXu+j3B53PoBthyG7X0n2lAluIm3ooAEuX99NhH29t7P0w==
X-Received: by 2002:a7b:c93a:: with SMTP id h26mr6919325wml.83.1581440669937;
        Tue, 11 Feb 2020 09:04:29 -0800 (PST)
Received: from [192.168.3.122] (p5B0C67DC.dip0.t-ipconnect.de. [91.12.103.220])
        by smtp.gmail.com with ESMTPSA id j5sm6025280wrb.33.2020.02.11.09.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 09:04:29 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v16.1 6/9] virtio-balloon: Add support for providing free page reports to host
Date:   Tue, 11 Feb 2020 18:04:28 +0100
Message-Id: <B3E5574A-B696-4239-8F1D-ED51496DD59C@redhat.com>
References: <3a8d9e1a3a5528c3a0889448f2ffd02c186399b7.camel@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
In-Reply-To: <3a8d9e1a3a5528c3a0889448f2ffd02c186399b7.camel@linux.intel.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 11.02.2020 um 17:33 schrieb Alexander Duyck <alexander.h.duyck@linux.in=
tel.com>:
>=20
> =EF=BB=BFOn Tue, 2020-02-11 at 16:13 +0100, David Hildenbrand wrote:
>>>> AFAIKs, the guest could inflate/deflate (esp. temporarily) and
>>>> communicate via "actual" the actual balloon size as he sees it.
>>>=20
>>> OK so you want hinted but unused pages counted, and reported
>>> in "actual"? That's a vmexit before each page use ...
>>=20
>> No, not at all. I rather meant, that it is unclear how
>> inflation/deflation requests and "actual" *could* interact. Especially
>> if we would consider free page reporting as some way of inflation
>> (+immediate deflation) triggered by the guest. IMHO, we would not touch
>> "actual" in that case.
>>=20
>> But as I said, I am totally fine with keeping it as is in this patch.
>> IOW not glue free page reporting to inflation/deflation but let it act
>> like something different with its own semantics (and document these
>> properly).
>>=20
>=20
> Okay, so before I post v17 am I leaving the virtio-balloon changes as they=

> were then?

I=E2=80=98d say yes :)=

