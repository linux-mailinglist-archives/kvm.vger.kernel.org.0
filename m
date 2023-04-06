Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FAC6D8D60
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbjDFCUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDFCUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:20:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58036EAF;
        Wed,  5 Apr 2023 19:20:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z11so24912329pfh.4;
        Wed, 05 Apr 2023 19:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680747611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPttce9mwmXnSVxB26FbEZfZew9OpavH8s0yj1jWAxQ=;
        b=FFnWjHp1JyVAdpXSYKsLs04rmCn/J2U/vI6DrqybZIScrcKTCtwyhmRW+kbIEPN7ha
         2tUSl4YGQ/Vjx/kpH03mIbQ62YEkKX7j8RLdbRqvqTXpS8ThznMXKs65Tgvs8u08pTc6
         mri3CqlPB393s4ENfHkYnZhV0+BmTY3pEIG0qJO/2pr+BPAeSrIKoqUxLb2zhVLrBFgy
         Cu/JWGzMOCcE9HrzJbDXJiWBJJVYcKztmEyVOR5e/+wh9ARFfFrNSwGlpcUM9Xkf65xR
         h2RPMjjVmVXjzzRzBq27I0h+V7nNnOJUDEGxfhRnlJhEtZLz0rt12SiFOmiYyVbovT8U
         uPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680747611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPttce9mwmXnSVxB26FbEZfZew9OpavH8s0yj1jWAxQ=;
        b=ClgcBO3COgXZrB5JkAHrXbL3Bjchya4xnJ+aBYqjLQ3u/1nqoCspT45CbTF8lXDl/R
         7VPHdFN9dF6h/jFmyQbofHqvjE4bV9eU5xsLd1sVjTEQdQSFwgDenCTduqmOiXd3nT6X
         VtKMpzT96MLcNFmMH5BI5QROZKEPRcvnFIue8ZrV66Izn8es188h89WAO7kzR65BICfq
         CVrEt7p6ODxGK8jSFoPJSbFlL7CyMGDYDA9LPerpv3N/yD9GVcFrWUf6lMxFPNQGTLFa
         pnMvnatmvtYXsZ8HwCBQVyRg8Xg/+1BaK+MmOKSb0R8toj4i5CklRW5v2S1sBENFXDjk
         kgtw==
X-Gm-Message-State: AAQBX9cMN92jg/L4ahs/UF/ejUQX0yQKrUNpzFng3QbRu3Qc5d8S85+q
        bfU6JbWeqQk6z16+9o3QCvpKgOoT2DT2W03kX+c=
X-Google-Smtp-Source: AKy350ah/yAbNH61dTfsbN07VXnYGkfpcj6Q1ghmXf8mxiMvh8fyNX8pjOrxn77qIo7g1qOrHpABjcAD/0nRU8I3M3g=
X-Received: by 2002:a05:6a00:174f:b0:62a:424b:2af0 with SMTP id
 j15-20020a056a00174f00b0062a424b2af0mr4713798pfc.0.1680747611176; Wed, 05 Apr
 2023 19:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230403095200.1391782-1-korantwork@gmail.com> <168063175075.174995.217166777153935864.b4-ty@google.com>
In-Reply-To: <168063175075.174995.217166777153935864.b4-ty@google.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Thu, 6 Apr 2023 10:21:20 +0800
Message-ID: <CAEm4hYV-M1sbboOon_O=eRsk6LEgwog+oUKBpdnAkchs=KMWEw@mail.gmail.com>
Subject: Re: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm@vger.kernel.org, Xinghui Li <korantli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 5, 2023 at 7:44=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, 03 Apr 2023 17:52:00 +0800, korantwork@gmail.com wrote:
> > VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
> > which is meaningless. Delete the duplicate one.
>
> Applied to kvm-x86 svm, thanks!
>
> In the future, please don't use "PATCH REBASED".  If you're sending a new
> version of a patch that's been rebased, then the revision number needs to=
 be
> bumped.  The fact that the only change is that the patch was rebased isn'=
t
> relevant as far as versioning is concerned, it's still a new version.  Th=
e
> cover letter and/or ignored part of the patch is where the delta between
> versions should be captured.
>
> And in this case, there really was no need to send a new version, the ori=
ginal
> patch still applies cleanly.  I suspect that the REBASED version was sent=
 as a
> form of a ping, which again is not the right way to ping a patch/series. =
 If you
> want to ping, please reply to the original patch.  Unnecessarily sending =
new
> versions means more patches to sort through, i.e. makes maintainers lives=
 harder,
> not easier.
>
Firstly, I'm so so SORRY to burden you in this way.
I found the last patch can't be am directly, so I send a new patch
with the last rebased code.
I used to believe that this would alleviate your burden, but
unfortunately, it had the opposite effect.
Again, sorry for my wrong operation.

Thanks~
