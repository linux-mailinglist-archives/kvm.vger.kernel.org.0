Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95FFBFFC
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 07:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNGCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 01:02:05 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39779 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNGCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 01:02:05 -0500
Received: by mail-pf1-f196.google.com with SMTP id x28so3405947pfo.6;
        Wed, 13 Nov 2019 22:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RIdrNWg9ykQyjlS1vDZmkPrZGZPQZaDltIMLFksT0cA=;
        b=AtP7Hv8DOaYFSPjKcQeWqtbxRD4IBq72aM8EpwK+jHtHGul+r/m+05z1IEUzdOsVB/
         z35KlNE+rj/kldikDbhZDEuz5j4fDs1UbivPpOChKVUU+gIzZvJ0Wlrdm7oWvFT6s4rA
         OcQBB5rrGFQDAD6Zmx+qKMDIK3V4u3zaj2Za2QUzMxgNaNDSmADXaaD7/c8jBvmsKhTZ
         LcQgCn18mQSYUXH/OemjRKUdQKySYEu1izAgYBIZFLPzz/az36AxieBwlQt7O6QsQddK
         uHg8UusJHQRCO5I2OcP3PF6yTs+nx6hLWV+pzmwYe1U9UnCfIQRnkW0fLiGMiib5LAVZ
         UAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RIdrNWg9ykQyjlS1vDZmkPrZGZPQZaDltIMLFksT0cA=;
        b=bcxSi1JMmhb7T1Y1Ud0iWG1wopBq8GywPlwOP+XqPiSsdLFVa7iQD84EKdwcRTpzBZ
         t9u+nyrGUNB57VLDq3AgRxh+SscQFNS40ggmaDxPn6gKaoonLLmLkvXydn6CGSz7eokG
         SCd1mRQWcGDHH1/KamHRPKJgDncjBW889+ZDD7lDnR/lsiwlMchPQqiJYr6rMTB1mphx
         x7q37+o3U6yv9YjSfcxedgGhGPDISXqoD1jtPcw1+Nmkw4t78+EGY1kel1y3MpqhzG+D
         G/S7DUEQeVumRgT2f59M96zjo3dJDIFw2UOO3lYL/RkDtYSKEAn1nkL7LcmMghLLzdoW
         wiEA==
X-Gm-Message-State: APjAAAUeaSf73QYeqBTHhtj4gmizJKjAalTp2ewB7KHv4LnVZH6FNhgT
        pimK9bAFmjsApE34PItgCJ4=
X-Google-Smtp-Source: APXvYqy7ji5ojUWoRYZ9cM85wsdIM243TNvjX1vgt45wOK02S0nRfGnXp6i9l90ozNRKyJOLPlePpQ==
X-Received: by 2002:a62:170b:: with SMTP id 11mr8942505pfx.85.1573711323877;
        Wed, 13 Nov 2019 22:02:03 -0800 (PST)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y36sm4261302pgk.66.2019.11.13.22.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 22:02:02 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <6a317558-44c0-5a21-0310-4ae49048134f@intel.com>
Date:   Wed, 13 Nov 2019 22:02:00 -0800
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <130E72B7-E7C0-4E96-A580-8F96FAF59996@gmail.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
 <6C0513A5-6C73-4F17-B73B-6F19E7D9EAF0@gmail.com>
 <6a317558-44c0-5a21-0310-4ae49048134f@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Nov 13, 2019, at 9:26 PM, Dave Hansen <dave.hansen@intel.com> =
wrote:
>=20
> On 11/13/19 5:17 PM, Nadav Amit wrote:
>> But is it always the case? Looking at __split_large_page(), it seems =
that the
>> TLB invalidation is only done after the PMD is changed. Can't this =
leave a
>> small time window in which a malicious actor triggers a machine-check =
on=20
>> another core than the one that runs __split_large_page()?
>=20
> It's not just a split.  It has to be a change that results in
> inconsistencies between two entries in the TLB.  A normal split =
doesn't
> change the resulting final translations and is never inconsistent
> between the two translations.
>=20
> To have an inconsistency, you need to change the backing physical
> address (or cache attributes?).  I'd need to go double-check the =
erratum
> to be sure about the cache attributes.
>=20
> In any case, that's why we decided that normal kernel mapping
> split/merges don't need to be mitigated.  But, we should probably
> document this somewhere if it's not clear.
>=20
> Pawan, did we document the results of the audit you did anywhere?

Thank you for explaining. I now see that it is clearly written:

"Software modifies the paging structures so that the same linear address
is translated using a large page (2 MB, 4 MB, or 1 GB) with a different
physical address or memory type.=E2=80=9D [1]

My bad.


[1] =
https://software.intel.com/security-software-guidance/insights/deep-dive-m=
achine-check-error-avoidance-page-size-change-0=
