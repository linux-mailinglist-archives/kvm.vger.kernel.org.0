Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4713A28BF83
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbgJLSR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404104AbgJLSR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:17:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58F3C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:17:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t18so9057591plo.1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6FpjzUpaNtbaJHbOyV8Kb0FBAweSByDV0MzTXlP9tQk=;
        b=hDJnvAPeMAkV9PkOBI+lmrQW3MECWx3Ns3rz71fxLgoHqu4AiBYEHxKmhDGTCE7ZD5
         KqRbO/uO2mG3dS6hcu4yYqqfE3PV0mKYOENJg/GeYWBapVlc5tftYtB6AcH7+AG2N3eo
         5VnOI6K4JnQZwH3zOI6atTxDPxAqTdLVmqUuuM/1e0NsV71AV8RBZobSnXtf60yrWz9Q
         3zVIHWHLhcntdiOX9cwQhP1WXYpB2W4gX8ngXPVBilmNGxdzaRuADRDNuIxkipF1Gtmy
         lelIWtc8LsjzY13LIOMYwj5MGR0n4RrLLqoUpr/tp9y7fYJWe6hMVhUfq9db6z15tmVR
         m6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6FpjzUpaNtbaJHbOyV8Kb0FBAweSByDV0MzTXlP9tQk=;
        b=AT/GLgLM7C3ocCrG9r7mUwZsXRQgFtRLcjFiYKr0rnBQSQfjDdanKKEzh0EkXCbZss
         AXrYAzhvViT7xn361npPo9NGw7CiEK5iWB0lw6l6v5JreuCfo0eh7Aca+NlneaFjCOXc
         guGD9h8Crsunz0mDVg+ye42XYkn/2ODy5JKUH91mOb6mLixrDdzE+7+XA1OxF5+AxrHP
         p51gJVKqFs8fpAN2WOprAGDGKlVeJkw5BywPZOo+0tZQTU3HBl5D8WY9KwCWsbw+bOid
         ATHsuKiQYZgpP4QSkANWut89Y6rbtLw70twyUoEeG4Jwsj4JdzqT8hQ6QFFlm7dwaLwz
         18yQ==
X-Gm-Message-State: AOAM530r+QUT0fgbZKQi24pZO/aqSunUrT3F1VqGI8Bap6zggMBiA7iR
        wADbMp32aG9VlD2P5S9NxDI=
X-Google-Smtp-Source: ABdhPJxWIk88xjanMK32HrmueRIioHWybIVdYv1B4MRpkmNG+GT94Kt+9pRlvnVmmG02+LAC/lYZWg==
X-Received: by 2002:a17:902:bd0c:b029:d4:ba5c:f37 with SMTP id p12-20020a170902bd0cb02900d4ba5c0f37mr18449303pls.56.1602526646002;
        Mon, 12 Oct 2020 11:17:26 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:8cd7:a47f:78d6:7975? ([2601:647:4700:9b2:8cd7:a47f:78d6:7975])
        by smtp.gmail.com with ESMTPSA id ck21sm24589900pjb.56.2020.10.12.11.17.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 11:17:25 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
Date:   Mon, 12 Oct 2020 11:17:22 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com>
 <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 12, 2020, at 10:55 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> I don't know of any relevant hardware errata. The test verifies that
> the implementation adheres to the architectural specification.
>=20
> KVM clearly doesn't adhere to the architectural specification. I don't
> know what is wrong with your Broadwell machine.

Are you saying that the test is expected to fail on KVM? And that =
Sean=E2=80=99s
failures are expected?

