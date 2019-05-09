Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B11949F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfEIV3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:29:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45930 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIV3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:29:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so4945413wra.12
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5k8DogH/Stja7i9wE9GeOzqotd+NJ1H/9hEjrvbxVLA=;
        b=kgBLZHvzP1+XsW1w2D8sNXmhsdgsV43RmpT5FbDT5jVgHRZSzFIn5B1ZApi+BAByfZ
         e72B9bLTQyfoEfxOLW9ZvXxpVtj7+gZ0IXgNsCMy16JTdNdt5eYcvzi5wJjddRTTjLjH
         X31TtMdl9k/BNBAMuGEfMzCJueeOEIwryE8ywUna5rMHPxywmbcmn1HGU/AaESOVba3e
         ZZYUEaol6fxTFLVfJ6YSdIS5a32L2+KltumTfSDdikxyxnCcX8H9dy0U4yAUtvhIyQnC
         IN8w3uFJo+gcAPj405NrI8fdazdiQMbidKAjbfdd7VDQjN/nSt0+y9L0HszDP5b4Lc66
         hTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5k8DogH/Stja7i9wE9GeOzqotd+NJ1H/9hEjrvbxVLA=;
        b=XHazUhKdD/NwUlYW/fV59wJuQVKu+8n4Q9fQfdFjzFM7Z0AWOKNl6e5TPRxtAJo/H2
         ljjMOwWYILPMdX8DahcPeP6ITepz7+fHsHMCvZsuEy4v3j5xbrOlBqLBuSnS9nqI27z4
         lQuJTQuHKh/IUO1Ts7hY8l5/AiqsJ0Fvf2pUvqFGrW6gCoU9Lrjv/iz5A6tyHvvaR+z9
         KhqFxh5GemQkQc39qjW/UuSSQA3yx41RPPiepl80rUeGtVrfV9wrnBmfoAKtJnwIJ1Ec
         Snorhea1vBZNKFHhg8Kc+D1kFAeoGCatEjPDbR3paqTf2qJLkfbfnwzYIc79Ydn9yDfD
         IU5Q==
X-Gm-Message-State: APjAAAVGRE5ifrJu6Xmjb+NCrel9GRNzB8jlviaNvM5flg+94b7DuAwl
        HvETmEWY6bdUyqMBy6IgdHk=
X-Google-Smtp-Source: APXvYqxOEnPFQaPn/ZySo8roHceTTTODdXI9kbDm85jgtxUL7Wqrb882amtxAinQ14PkdGJ6Qfqj1g==
X-Received: by 2002:adf:da4a:: with SMTP id r10mr4735013wrl.216.1557437393381;
        Thu, 09 May 2019 14:29:53 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id d3sm6245906wmf.46.2019.05.09.14.29.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 14:29:52 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after
 NMI/INTR-window tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190509203241.GB12810@linux.intel.com>
Date:   Thu, 9 May 2019 14:29:45 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <16444EC3-7BB8-4FD4-8F1C-30ADFEB5E9CC@gmail.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-3-namit@vmware.com>
 <20190509203241.GB12810@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 9, 2019, at 1:32 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, May 08, 2019 at 03:27:15AM -0700, Nadav Amit wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
>> events wake the logical processor if it just entered the HLT state
>> because of a VM entry." A similar statement is told about NMI-window
>> exiting.
>>=20
>> However, running tests which are similar to verify_nmi_window_exit() =
and
>> verify_intr_window_exit() on bare-metal suggests that real CPUs do =
not
>> wake up. Until someone figures what the correct behavior is, just =
reset
>> the activity state to "active" after each test to prevent the whole
>> test-suite from getting stuck.
>>=20
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> x86/vmx_tests.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index f921286..2d6b12d 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7063,6 +7063,7 @@ static void verify_nmi_window_exit(u64 rip)
>> 	report("Activity state (%ld) is 'ACTIVE'",
>> 	       vmcs_read(GUEST_ACTV_STATE) =3D=3D ACTV_ACTIVE,
>> 	       vmcs_read(GUEST_ACTV_STATE));
>> +	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>=20
> Don't you need to remove (or modify) the above report() as well to =
avoid
> failing the current test?

Thanks for checking it (in your second email).

So should I remove this test completely for v2? Or do you have any =
different
test you want to run?

