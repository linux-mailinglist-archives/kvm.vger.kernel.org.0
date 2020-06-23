Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8720586D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgFWRU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWRU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:20:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA5C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:20:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i4so1846175pjd.0
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QFN3NBLN9NlKmsJoOd/K5asHRG67kb3ucUtGgZA54rQ=;
        b=NqL3QjknBNlgt8ZZBtyyr2ohVY/nsuZ0zR9KhC+tGbi8c8Xaxqq+uQR8qytlw9eC07
         6Stjn53kmqtHeZZO3J8zoSj5QIRgaIPbry8HYSdddtzqu2ciACfHzRNKNLzdy5sizgBi
         cR7G6gadpnX9LRMGqMg3GoODN9qyz/fbDVwSRufi1OVySAyZ/Lh9UvLURnWVdmZ3kzCf
         3VE5VUDESFw222kYRb8VdwXHZ3qTZEt9IAZd9G6DEl+VVb6C3AX7su3pQ164rPylw/Ht
         VIOVMNkCNa7doA+/L+Y/NvTEmwbvOp2OoeJCCsBmE9RznQ9baJUoldF178E+KR/eYqXQ
         thwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QFN3NBLN9NlKmsJoOd/K5asHRG67kb3ucUtGgZA54rQ=;
        b=BzB8vKfcsZGDgbOXmJI1MWLFyU7bJxYTAHkPdJ6FR9+FcMZZdaWfUoAhPeEoPGyhTO
         kdCx524v/8VjdDnLZjQRElrJEp5WYL2J1+XPCJZu/NYYQsbnPu3FzVaQEeDEU4Y/92gj
         r5r5P4yTbk4oyps3g8uriZQG9eFtd6p0v/cBM7TXH3ParsF6+YVrcBovOAklMULaBHM5
         wlCYWabMiBGJCsbf3h+OHdrzYO3LGkNxjO9qO3qeKOA5rJdwcvz+AT/T/f68CLmihQeX
         CA+pcu3hAK8J5QLrF0L+DkR17OwNdd3u21Fx3mbrxLrsFtAv/+Yc+9xMeR37r7npde6J
         FGbQ==
X-Gm-Message-State: AOAM532LuV2oOrg1SPIub2faRjRPwWwNlu3l10W9iYeLzb24w6UBgOAV
        SdIwTSb1F0JniK+yExXcCG9rL7lz4kA=
X-Google-Smtp-Source: ABdhPJwfxh6Aoq7bSr9WgBjQF92rbQcMreeaMGe9Q2Eip/FbneWsCv1Tkzm+ImMrrhqIL94YDtXvqw==
X-Received: by 2002:a17:902:122:: with SMTP id 31mr24892190plb.182.1592932855680;
        Tue, 23 Jun 2020 10:20:55 -0700 (PDT)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id s22sm9344825pgv.43.2020.06.23.10.20.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 10:20:54 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] vmx: remove unnecessary #ifdef __x86_64__
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <0e052425-0eb6-0bca-1948-8485d5c76ac1@redhat.com>
Date:   Tue, 23 Jun 2020 10:20:53 -0700
Cc:     kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD04529C-192A-4D2C-BA3D-3E41E9234B1B@gmail.com>
References: <20200623092045.271835-1-pbonzini@redhat.com>
 <AB6977D0-7844-49AE-A631-FF98A74E60FB@gmail.com>
 <0e052425-0eb6-0bca-1948-8485d5c76ac1@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 23, 2020, at 10:12 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 23/06/20 19:02, Nadav Amit wrote:
>>> On Jun 23, 2020, at 2:20 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> The VMX tests are 64-bit only, so checking the architecture is
>>> unnecessary.  Also, if the tests supported 32-bits environments
>>> the #ifdef would probably go in test_canonical.
>>=20
>> Why do you say that the VMX tests are 64-bit only? I ran it the other =
day on
>> 32-bit and it was working.
>=20
> Because it is not listed in either x86/Makefile.i386 or
> x86/Makefile.common. :)

Oops, stupid me. So I guess I was not running it after all...=
