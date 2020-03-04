Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0021799D4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbgCDUae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:30:34 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42521 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgCDUad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:30:33 -0500
Received: by mail-pg1-f194.google.com with SMTP id h8so1526340pgs.9;
        Wed, 04 Mar 2020 12:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NY5izrCaTjPPMM0nMljJM70P0c5WnZWBbXOSJziAbQI=;
        b=dYC62F7ks46pS4Q68zNNsItNhXrU184Sts4g63KBpd9Q3R6NQV123wl1oxCHiQ7Jti
         p1o0QgBv9g21NRNuC3VGkKEQL7hvbwZKVZFH2Pe/ri5oqI4silP8nX8UDgMlY2JNrC0R
         HQ/6FhGqfyxlI/4LtgDBsW9sh3X2g5XQa6LXm6NrgjQS3WsbHcnM2iQY6gKOl73FQRxK
         5yZ7/LfRh4L3OhrCZ4w4ysIvEjk74C9jUW1Ug0O+z/T7LXpzp958PMS/j2nbUlZxABq8
         pCw+CHC7lS4pcj7DyL9uC23oeiS7Pr3rP2daBsOHxEXlZrFE46uTuZzhfTa1LC9wdQQ6
         k9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NY5izrCaTjPPMM0nMljJM70P0c5WnZWBbXOSJziAbQI=;
        b=IdIQ3mYlUOgkiRBac8bD7UwWrpIeNtgrpWhnPelWRElUHQpdHRkrUAi0iYMUrwSFrR
         5jFsxGoF39j9h/qakt0C10fYpSCYdz+rBw7zfBpSmDRnMOHmsVFLM/NL7Uc3kR+HIy7d
         RhB0QMS5QlZZAJDv4yN+BAuxFqlsecvo1S7esgyZjwEE3HRPGAicXzPY4XOC3ACXAWOo
         fsUh7AO5Ayg+ZvvO0rK/NDtxsBdu0wVtUPHV452yPlmrEZWyLVic20jXbEq4bWdEomMJ
         Q/HJI7TClliDlvXldj0ZQ/NvxX5l/j2VrFUzfWEcOz524dScICi+w7RC+fbqm5IdoT/x
         74Kg==
X-Gm-Message-State: ANhLgQ2dhc2XKwxVYzSdCQcxVk5NchzHgnZ3iGY6XtQqEBDosCiNjIZx
        T6K0b5JMSu7tFuwd9O0kR2w=
X-Google-Smtp-Source: ADFU+vtDiLzB5A+RDGdcwREuzbLcYTrDkbng/6a82Zf9JBW6Two8xHW5WgrddP17z/IaL8xRqbhuWw==
X-Received: by 2002:a62:a518:: with SMTP id v24mr4543065pfm.77.1583353832440;
        Wed, 04 Mar 2020 12:30:32 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id e189sm24524247pfa.139.2020.03.04.12.30.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 12:30:31 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ad023c34-9a08-7d61-22de-911c4e8760ba@redhat.com>
Date:   Wed, 4 Mar 2020 12:30:30 -0800
Cc:     Peter Xu <peterx@redhat.com>, linmiaohe <linmiaohe@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <13E8DCB7-D977-49AD-B63F-8BF4B06B096E@gmail.com>
References: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
 <20200304153253.GB7146@xz-x1>
 <ad023c34-9a08-7d61-22de-911c4e8760ba@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 4, 2020, at 10:19 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 04/03/20 16:32, Peter Xu wrote:
>>> Looks good, thanks. But it seems we should also take care of the =
comment in __do_insn_fetch_bytes(), as we do not
>>> load instruction at the beginning of x86_decode_insn() now, which =
may be misleading:
>>> 		/*
>>>         * One instruction can only straddle two pages,
>>>         * and one has been loaded at the beginning of
>>>         * x86_decode_insn.  So, if not enough bytes
>>>         * still, we must have hit the 15-byte boundary.
>>>         */
>>>        if (unlikely(size < op_size))
>>>                return emulate_gp(ctxt, 0);
>> Right, thanks for spotting that (even if the patch to be dropped :).
>>=20
>> I guess not only the comment, but the check might even fail if we
>> apply the patch. Because when the fetch is the 1st attempt and
>> unluckily that acrosses one page boundary (because we'll only fetch
>> until either 15 bytes or the page boundary), so that single fetch
>> could be smaller than op_size provided.
>=20
> Right, priming the decode cache with one byte from the current page
> cannot fail, and then we know that the next call must be at the
> beginning of the next page.

IIRC I encountered (and fixed) a similar KVM bug in the past. It is a =
shame
I never wrote a unit test (and I don=E2=80=99t have time now), but it =
would be nice
to have one.

