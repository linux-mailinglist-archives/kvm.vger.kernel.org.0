Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72ECD125CFF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 09:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLSIwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 03:52:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55750 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLSIwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 03:52:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so4565978wmj.5
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 00:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fE0beaW51bVROqMNkTXFKxWcz+Tb87M69L5AJyAkTjc=;
        b=RENnMshqJ/F1XA23nUq7xrUf2jjBSgsdXM6OvJbL+kOqqMTdg3+PpiFAsPBxkQlAM1
         vJgKPMWSq4URZ43jXPlTYBgaoAvIDsYYX0SCwD9tN81ybirXqcOxCs5xzvlJaCMXiWPy
         HBIBFu3Yoxh6w5FbGHtwiUF2g+dY5y4CqZzdmzvlN1tFzfylYMNb+ueRSIjwV9jvpz46
         147CAKntzf/+vABgnB5dLCfzkz0HgyM3ucbcCi7ag0bNWsfktxY/QmM6VZELI8GolqtD
         aKqCrDQuRC2NtjbLOi3vtXRBAWqqBjX6sEAOG3o4vb2g2qspmS5upQG82sXhzYkgmiKz
         tcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fE0beaW51bVROqMNkTXFKxWcz+Tb87M69L5AJyAkTjc=;
        b=MhPt0wlkyhteMZ/KBeIuao/sfomqy5wwRQrDbrZoK/HjEBqBxIj5UDo4Kff/RD3+Du
         eOekgXnaWz/LthMGR7F3eVkt8a8A3F51DYLnBICpKkztvRjHe2mw33vk+Vf1wxHQTy7n
         gduclW/fDoe3GyLnk8XT+Yq2uIwWgHlokMk4hNMV6OEJSgrkQ3dPCoIGdk+i5HYYuSnD
         PgszRrPUE0N7zF+FP+mwwT/hyjodgxk1J4X49+JbL7TiHNeVyvlV12X9SLE6EV2W7JS0
         WdamsOzi9ucmx94H5y+8pxh03Kcvi0pgpLRRRiUAI7oWUG5JB8qZu07h4qB2emOXdTFN
         jOLw==
X-Gm-Message-State: APjAAAX5pswpbrj4awJD50xpY5p2BTGbjDrl0qeya3pfncBOH0NI7eGK
        WteeDnTRFUAI11xo/Da+/OA=
X-Google-Smtp-Source: APXvYqwBPKC4vZaQv4h1Ic/C76bPDMeY1bUz3J5Viu2MNrOuWOtjTuK34arVD9rfxroIxQzSM1c0Fw==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr8662698wml.114.1576745555584;
        Thu, 19 Dec 2019 00:52:35 -0800 (PST)
Received: from ?IPv6:2a00:a040:196:18a:c097:da9:b879:56d6? ([2a00:a040:196:18a:c097:da9:b879:56d6])
        by smtp.gmail.com with ESMTPSA id d12sm5647498wrp.62.2019.12.19.00.52.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 00:52:34 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index
 check
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20191218002410.GN11771@linux.intel.com>
Date:   Thu, 19 Dec 2019 10:52:33 +0200
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0F6C621D-5953-4818-A278-BBFEC21E80DF@gmail.com>
References: <20190518163743.5396-1-nadav.amit@gmail.com>
 <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
 <51BBC492-AD4F-4AA4-B9AD-8E0AAFFC276F@gmail.com>
 <CALMp9eT+K7qwLeBb231OjNwqTaS4XE6Ci+-j_b+a=0JU__HEqg@mail.gmail.com>
 <20191218002410.GN11771@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 18, 2019, at 2:24 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Dec 13, 2019 at 09:30:45AM -0800, Jim Mattson wrote:
>> On Fri, Dec 13, 2019 at 1:13 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>> On Dec 13, 2019, at 12:59 AM, Jim Mattson <jmattson@google.com> =
wrote:
>>>>=20
>>>> On Sat, May 18, 2019 at 4:58 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> The test that checks the maximum VMCS field encoding does not =
probe all
>>>>> possible VMCS fields. As a result it might fail since the actual
>>>>> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected =
value.
>>>>>=20
>>>>> Change the test to check that the maximum of the supported probed
>>>>> VMCS fields is lower/equal than the actual reported
>>>>> IA32_VMX_VMCS_ENUM.MAX_INDEX.
>>>>=20
>>>> Wouldn't it be better to probe all possible VMCS fields and keep =
the
>>>> test for equality?
>>>=20
>>> It might take a while though=E2=80=A6
>>>=20
>>> How about probing VMREAD/VMWRITE to MAX_INDEX in addition to all the =
known
>>> VMCS fields and then checking for equation?
>> It can't take that long. VMCS field encodings are only 15 bits, and
>> you can ignore the "high" part of 64-bit fields, so that leaves only
>> 14 bits.
>=20
> Unless kvm-unit-tests is being run in L1, in which case things like =
this
> are painful.  That being said, I do agree that probing "all" VMCS =
fields
> is the way to go.  Walking from highest->lowest probably won't even =
take
> all that many VMREADS.  If it is slow, the test can be binned to its =
own
> config.

Ok. I=E2=80=99ll send a patch for that.

