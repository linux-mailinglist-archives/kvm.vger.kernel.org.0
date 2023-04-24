Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CAB6ED577
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 21:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjDXTo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 15:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXTo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 15:44:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340365B8C
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:44:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b4bf2d74aso3997272b3a.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682365464; x=1684957464;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gttumJmRjcuzz0nO+L7dcVXMjmV9xRO1wfvCT89kRx4=;
        b=QhGHaaQM7azk+tjDDGNq++SGPWl7Kj3oUwHiSYejHGylznulHSRxwbj78wuowCQTbd
         lXQRgyAx5jsaDrsldardH4Y3uKDEAIj4dFgor4j4cLrR9UxmhMRhZGg9+kpcvH0G/gV2
         x6Efy7EVL8kChy1OyD/h3L7WI3tJtCquUgp3VvfFU65cVIrymiThNTGC+0a7Edp9k70c
         5dvUcFoLWeibOqe2B/W17Skkpf6QCwxmnBRjb6fy33L/6Y76qU6UNtSgEqEJHtJhT56c
         1KW3jVAd12uXjegicLHD3yWFVkzHe/W10uUYHA5gsFq6x6eL8SJI4EW+ecviKy+Q48Eb
         TePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682365464; x=1684957464;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gttumJmRjcuzz0nO+L7dcVXMjmV9xRO1wfvCT89kRx4=;
        b=E6jTUZNMkSrk6gPusFE21pcMls2wJiZ9hU4Aus4bC33jo+YYh9wdJx/aksXrCw4NgT
         0EWMSBlyK2yz80CLGKrVXkz4J0kuTZTY0kqPfYk7S8FplABg97QC5Z0Xsf+dGCKSF38p
         wbh+rmH89pDYohOJLfX8w3FIvd612EjAOl0JEFYYgX1IO78z8IfwacfhHyvDUJ1Mx7nm
         27SAAU6PbvqaOgc1wfjUpuzBsWLfGBdC4Ydiz3Qx9gOeoSAkAqPGgRypOnj35MtPpBmU
         ey2sPnbO+H9vG1Lap+cj+SCxhxicQ99uZE9HArx9gHmLAHOS85//c8DZo9HC00TOcA7V
         nN9Q==
X-Gm-Message-State: AAQBX9dsyRwvOjoZ86bpplDfyzl9j7kDMXBEn2+Vxxfr9NlezmTSom5l
        JRR5YfBW00Jcn2p5BnIwcxo=
X-Google-Smtp-Source: AKy350anKgALpmjX1X2m2rSez1PeuzTbvdvdwU9liVevuWPVen/bdTLfTlgAazii7v0HqNVMqA9Ufg==
X-Received: by 2002:a05:6a00:c85:b0:625:efa4:4c01 with SMTP id a5-20020a056a000c8500b00625efa44c01mr22230394pfv.3.1682365464396;
        Mon, 24 Apr 2023 12:44:24 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000a0a00b0062d8e79ea22sm7694477pfh.40.2023.04.24.12.44.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Apr 2023 12:44:23 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
Date:   Mon, 24 Apr 2023 12:44:11 -0700
Cc:     Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
To:     Anish Moorthy <amoorthy@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> =
wrote:
>=20
> On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit =
<nadav.amit@gmail.com> wrote:
>>=20
>> If I understand the problem correctly, it sounds as if the proper =
solution
>> should be some kind of a range-locks. If it is too heavy or the =
interface can
>> be changed/extended to wake a single address (instead of a range),
>> simpler hashed-locks can be used.
>=20
> Some sort of range-based locking system does seem relevant, although I
> don't see how that would necessarily speed up the delivery of faults
> to UFFD readers: I'll have to think about it more.

Perhaps I misread your issue. Based on the scalability issues you =
raised,
I assumed that the problem you encountered is related to lock =
contention.
I do not know whether your profiled it, but some information would be
useful.

Anyhow, if the issue you encounter is mostly about the general overhead
of delivering userfaultfd, I encountered this one too. The solution I =
tried
(and you can find some old patches) is in delivering and resolving =
userfaultfd
using IO-uring. The main advantage is that this solution is generic and
performance is pretty good. The disadvantage is that you do need to =
allocate
a polling thread/core to handle the userfaultfd.

If you want, I can send you privately the last iteration of my patches =
for
you to give it a spin.

>=20
> On the KVM side though, I think there's value in merging
> KVM_CAP_ABSENT_MAPPING_FAULT and allowing performance improvements to
> UFFD itself proceed separately. It's likely that returning faults
> directly via the vCPU threads will be faster than even an improved
> UFFD, since the former approach basically removes one level of
> indirection. That seems important, given the criticality of the
> EPT-violation path during postcopy. Furthermore, if future performance
> improvements to UFFD involve changes/restrictions to its API, then
> KVM_CAP_ABSENT_MAPPING_FAULT could well be useful anyways.
>=20
> Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
> so I'm guessing (some version of) that will (eventually :) be merged
> in any case.

It certainly not my call. But if you ask me, introducing a solution for
a concrete use-case that requires API changes/enhancements is not
guaranteed to be the best solution. It may be better first to fully
understand the existing overheads and agree that there is no alternative
cleaner and more general solution with similar performance.

Considering the mess that KVM async-PF introduced, I
would be very careful before introducing such API changes. I did not =
look
too much on the details, but some things anyhow look slightly strange
(which might be since I am out-of-touch with KVM). For instance, =
returning
-EFAULT on from KVM_RUN? I would have assumed -EAGAIN would be more
appropriate since the invocation did succeed.

