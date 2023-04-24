Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2201A6ED3F7
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjDXRz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjDXRz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:55:28 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DC6A59
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:55:27 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-76355514e03so430265639f.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682358927; x=1684950927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qK0g7OjjecNV9tTu3zO64lSO1YjuimVznnZZbsBmbRA=;
        b=m2GQZIOpmOMM7ESyTmKbtoevb5UEW7eDeXUpNfNok9EqUc75StZqoqM2rHHuDY8L+i
         rhNAW52UC807nIj0M4O8M2Xsrm8eiR75V4SYcRNTjm/HQcKpj80+OBQqmlHozhOarAgM
         s//kPObbRGybaw0gRSL1ot566d/ip/8ae+5HW1DEEZ4odrUPHZ/UzyqSaolbtcy55slb
         geRWognQa3HCKtKJ6Y4jw/un0Z7hV3nB54awmhbcJndbud49MfPaxUCgYxY51g4u4A35
         Gq4YDOHn3BsvlSGrmSF9nHapcbkQHH/7eFvdxxbCcoISiWSeEiahxtTdNzDsKwRE4Lfz
         AXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682358927; x=1684950927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qK0g7OjjecNV9tTu3zO64lSO1YjuimVznnZZbsBmbRA=;
        b=QSpm3mpnTw4joe1YwdymHN/miPYijKFbLyAzsJu3Xukr4ZU4j24ZIXw6T5LgA7TtTU
         dRSbWTd/VeJbyrqVSxMBkz2n7J2tFTgunnRMNAKKk3nZp/YtAED40PMXL1CHBJwpQszg
         aWy+iJWcX4ROjCwopkYtHV5s52wspYqp/+HbgiHpPQVWOij10XklVvpjKzIqt9UDRm/3
         nJRKwn0RhRKCG5hYf+utv77/RDj85vyblO4w7OtTTorjm0ww8DCGPI3Zeb4TBroRwPO2
         uC2P8Uwm5q09RrstcacZiADXR5nfr5DaJAjLljAYNXhkYfObyikWS7YI9cjO07VIwMgE
         ZALA==
X-Gm-Message-State: AAQBX9c+3o6mpMMBt0569QLeexDBoXwtcfRybrw9+qP/niSCTP7IPgz8
        tgizrcsLEPfkjf5JIHPT/Y3lvdfy0LzZltm41QViWw==
X-Google-Smtp-Source: AKy350Ye7jrvbmBowRwPJtvtJhUL3SLCQKNIIPngIs6AtoBBdiCVXC0qfiNo/W6uFPuCcup6AZKJyi/VNVKXKhbl/A8=
X-Received: by 2002:a6b:490b:0:b0:760:3b22:9d0 with SMTP id
 u11-20020a6b490b000000b007603b2209d0mr5636708iob.19.1682358927190; Mon, 24
 Apr 2023 10:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
In-Reply-To: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 24 Apr 2023 10:54:51 -0700
Message-ID: <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>
> If I understand the problem correctly, it sounds as if the proper solutio=
n
> should be some kind of a range-locks. If it is too heavy or the interface=
 can
> be changed/extended to wake a single address (instead of a range),
> simpler hashed-locks can be used.

Some sort of range-based locking system does seem relevant, although I
don't see how that would necessarily speed up the delivery of faults
to UFFD readers: I'll have to think about it more.

On the KVM side though, I think there's value in merging
KVM_CAP_ABSENT_MAPPING_FAULT and allowing performance improvements to
UFFD itself proceed separately. It's likely that returning faults
directly via the vCPU threads will be faster than even an improved
UFFD, since the former approach basically removes one level of
indirection. That seems important, given the criticality of the
EPT-violation path during postcopy. Furthermore, if future performance
improvements to UFFD involve changes/restrictions to its API, then
KVM_CAP_ABSENT_MAPPING_FAULT could well be useful anyways.

Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
so I'm guessing (some version of) that will (eventually :) be merged
in any case.
