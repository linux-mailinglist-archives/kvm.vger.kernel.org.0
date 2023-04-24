Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CC46ED8F7
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDXXsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjDXXsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:48:37 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B492D5FD3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:48:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b7b54642cso3812162b3a.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682380089; x=1684972089;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXgQDsM6W2q3bXF99TK+m6aQnV2HNJnRqfZQdtfImNw=;
        b=NuWrcZqthwuXE3gdrtpndxJ+MePiW25yJTyWnP5jDKvceq+4NSVjCU5LzW+X7qhNPL
         FzDGuDVoovoXbYUDJZ+EwaqUMktciOaRmcADW1WqKaRAaf3DboUoJpdPhFSiMTlfDH2g
         tVmWIMd53XxysVPmsSjppjHpWA/p5EBd7SW/CkQgBG5E/hRj1QQD2EIDooXOJabXWc63
         yT4p8EELvqsGitPhysYCtqEFbfaByHrDdEbS2ZbUOBb2iLySmBZx+hlzgbPlT0LLtB5G
         5Zb6OUIp2P0C31d+Ker6yi8nIUyszQDMVdaWPp7jzRU60XyR+7HNVPnBI70p6yuZq/iP
         N/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380089; x=1684972089;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXgQDsM6W2q3bXF99TK+m6aQnV2HNJnRqfZQdtfImNw=;
        b=FdHfUekWFCOx6G9JU7BZlq8hwZqS5TICbiWhwR1zqSsFR6JsuDVp7e7PXbfQs73AUQ
         gzi7qqyvOhpUhywkxkc1GdgZkGauhSOjkZxfiizbOBZxWMpKRwC8T/vmzh7yX901oAjn
         fsxYKsEFoOFSbKi5kY+G5GcoO+oId9dubJ8d2yuduinieHh01kUljf+fRaeA8RRB+jcy
         rZC3NjddGi3zi8SgVx50m+j9/ByWgclg2gbDWcT/FIF+qdlRZBu5Ndv12KaYjKw9yyfM
         cSIx62VdxjPHjhWXjXSh4f+V4Wg/HF468jRntY4HJE7+1dJlJ/IOL4QokZ8RLPKWtE6q
         41VA==
X-Gm-Message-State: AAQBX9cBi/HN7SnNsPN7TWpzcE/WCD8I3Asa2m46HUpxYHqrQwkedc5A
        VRAEUT7hTaB4rgihdNdDAe8=
X-Google-Smtp-Source: AKy350aLFglhLcr1XPFUnLjs3RjZgFHFuEI0VDZf7pIqPFO5Z4N0lXIRC5JFEuyucak3iEgCzGUAlw==
X-Received: by 2002:a05:6a00:230b:b0:63b:8778:99e4 with SMTP id h11-20020a056a00230b00b0063b877899e4mr22658731pfh.2.1682380088874;
        Mon, 24 Apr 2023 16:48:08 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id a197-20020a621ace000000b0062e10435843sm7853235pfa.217.2023.04.24.16.48.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Apr 2023 16:48:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZEboGH28IVKPZ2vo@google.com>
Date:   Mon, 24 Apr 2023 16:47:56 -0700
Cc:     Anish Moorthy <amoorthy@google.com>, Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <B6EEF84A-CCEA-44D7-B5AA-EA40073C81D4@gmail.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <ZEboGH28IVKPZ2vo@google.com>
To:     Sean Christopherson <seanjc@google.com>
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

Feel free to tell me to shut up, as it is none of my business, and I =
might be
missing a lot of context. Yet, it never stopped me before. :)

> On Apr 24, 2023, at 1:35 PM, Sean Christopherson <seanjc@google.com> =
wrote:
>=20
> On Mon, Apr 24, 2023, Nadav Amit wrote:
>>=20
>>> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> =
wrote:
>>> Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in =
general,
>>> so I'm guessing (some version of) that will (eventually :) be merged
>>> in any case.
>>=20
>> It certainly not my call. But if you ask me, introducing a solution =
for
>> a concrete use-case that requires API changes/enhancements is not
>> guaranteed to be the best solution. It may be better first to fully
>> understand the existing overheads and agree that there is no =
alternative
>> cleaner and more general solution with similar performance.
>=20
> KVM already returns -EFAULT for these situations, the change I really =
want to land
> is to have KVM report detailed information about why the -EFAULT =
occurred.  I'll be
> happy to carry the code in KVM even if userspace never does anything =
beyond dumping
> the extra information on failures.

I thought that the change is to inform on page-faults through a new =
interface
instead of the existing uffd-file-based one. There is already another =
interface
(signals) and I thought (but did not upstream) io-uring. You now suggest =
yet
another one.

I am not sure it is very clean. IIUC, it means that you would still need =
in
userspace to monitor uffd, as qemu (or =
whatever-kvm-userspace-counterpart-you-
use) might also trigger a page-fault. So userspace becomes more =
complicated,
and the ordering of different events/page-faults reporting becomes even =
more
broken.

At the same time, you also break various assumptions of userfaultfd. I =
don=E2=80=99t
immediately find some functionality that would break, but I am not very
confident about it either.

>=20
>> Considering the mess that KVM async-PF introduced, I would be very =
careful
>> before introducing such API changes. I did not look too much on the =
details,
>> but some things anyhow look slightly strange (which might be since I =
am
>> out-of-touch with KVM). For instance, returning -EFAULT on from =
KVM_RUN? I
>> would have assumed -EAGAIN would be more appropriate since the =
invocation did
>> succeed.
>=20
> Yeah, returning -EFAULT is somewhat odd, but as above, that's =
pre-existing
> behavior that's been around for many years.

Again, it is none of my business, but don=E2=80=99t you want to =
gradually try to fix
the interface so maybe on day you would be able to deprecate it?

IOW, if you already introduce a new interface which is enabled with a =
new
flag, which would require userspace change, then you can return the more
appropriate error-code.

