Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A056F89F7
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 22:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjEEUFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 16:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjEEUFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 16:05:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD2D3
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 13:05:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-643aad3bc41so906288b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683317116; x=1685909116;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=te4sAuRzX8wSQKX6THFhQ+UogT5JHUxdicm0nlSOK7Q=;
        b=hTJkx1aBQ3X/ggwMdGwfrocXkNybdm6YFEepVzFvEYp/joksyFqSeT9n3c4irIW6wn
         lfA3hEGHF2+hDGGh7vlC03BiqVO5xNHOSzAJjvJ841sp0JmwikTvShH3zpyQYLbWjQIv
         rAUo05ZVovtWF5lmOOEe6JGJ+cfgS+6OqZQNk0EJGf9/8aE3KH+fXdGVL/IZzmD/3RkU
         WCDBWHaLUa8C7mrSSwDr/hEui2G5B7MteIpTLgAqV9wvTN5fymw0v1PjHgVaL3mlYEwY
         HWrR/kQ3fA0LPS+TKDohl7M6xOpwg9yKvykzgcSbwExNguOmb5UVyG8ewd8jiiuesC70
         7MXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683317116; x=1685909116;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=te4sAuRzX8wSQKX6THFhQ+UogT5JHUxdicm0nlSOK7Q=;
        b=FKg1XJPu3Su9+v3tO8CSoX0kEG27CEsVeV6/zY8Svlflm7JqvUDf8GMbtxeXayw2NK
         6dSVsRowuy0RfhqVvbf0g7uJOcCp3TnXH+t+WLG4rM8r4ejALZXoq62lINnPZrBcQ7uA
         bsHBckmrF4aD+xi7VSO65nxxaY5ImDtPeOigdj3gU7dRBNfxo/0GOmFMDE17H1rVHtrH
         elHBrRB0hN7LzjO4dMUNm85D5I+ZFPQ0q8W5Bk7NNuv9LjbE4FYUa5WmR21DVIw4yBsl
         R4RUesbJbWkJlHJYejEty7JijNrd4PcxrXDOtRlJFOtdd88ZNETFW4XBGmt6FGOrGfuw
         VAsg==
X-Gm-Message-State: AC+VfDwIQANXxE9EDmWQJ2Jr0c/bp/Op8GdKMkUN5uyb2KDolyqI4KBm
        PjgQey+UansI6wpxF/wdMxg=
X-Google-Smtp-Source: ACHHUZ75P0u2CxseiLnXqvon8NR428DDVfkd9GBfbjK16rQnl2L1ovsA78wH6CgK7aGsUzIghW9K/Q==
X-Received: by 2002:a05:6a20:d39b:b0:f6:c920:7870 with SMTP id iq27-20020a056a20d39b00b000f6c9207870mr2724178pzb.59.1683317115161;
        Fri, 05 May 2023 13:05:15 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78510000000b005a8de0f4c64sm1988708pfn.82.2023.05.05.13.05.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 13:05:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZFLyGDoXHQrN1CCD@x1n>
Date:   Fri, 5 May 2023 13:05:02 -0700
Cc:     Sean Christopherson <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
References: <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
To:     Peter Xu <peterx@redhat.com>
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



> On May 3, 2023, at 4:45 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
>> On Wed, May 03, 2023, Peter Xu wrote:
>>> Oops, bounced back from the list..
>>>=20
>>> Forward with no attachment this time - I assume the information is =
still
>>> enough in the paragraphs even without the flamegraphs.
>>=20
>> The flamegraphs are definitely useful beyond what is captured here.  =
Not sure
>> how to get them accepted on the list though.
>=20
> Trying again with google drive:
>=20
> single uffd:
> https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view
>=20
> 32 uffds:
> https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view
>=20
>>=20
>>>> =46rom what I got there, vmx_vcpu_load() gets more highlights than =
the
>>>> spinlocks. I think that's the tlb flush broadcast.
>>=20
>> No, it's KVM dealing with the vCPU being migrated to a different =
pCPU.  The
>> smp_call_function_single() that shows up is from loaded_vmcs_clear() =
and is
>> triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU =
(yay for the
>> VMCS caches not being coherent).
>>=20
>> Task migration can also trigger IBPB (if mitigations are enabled), =
and also does
>> an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
>>=20
>> Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ =
eliminate the
>> vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely =
represenative of a real
>> world configuration.
>=20
> Yes it does went away:
>=20
> https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view
>=20
> With pinning vcpu threads only (again, over 40 hard cores/threads):
>=20
> ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c =
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28=
,29,30,31,32
>=20
> It seems to me for some reason the scheduler ate more than I =
expected..
> Maybe tomorrow I can try two more things:
>=20
>  - Do cpu isolations, and
>  - pin reader threads too (or just leave the readers on housekeeping =
cores)

For the record (and I hope I do not repeat myself): these scheduler =
overheads
is something that I have encountered before.

The two main solutions I tried were:

1. Optional polling on the faulting thread to avoid context switch on =
the
   faulting thread.

(something like =
https://lore.kernel.org/linux-mm/20201129004548.1619714-6-namit@vmware.com=
/ )

and=20

2. IO-uring to avoid context switch on the handler thread.

In addition, as I mentioned before, the queue locks is something that =
can be
simplified.

