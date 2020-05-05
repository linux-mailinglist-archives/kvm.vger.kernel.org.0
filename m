Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C45F1C6136
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 21:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgEETp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 15:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728609AbgEETp2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 15:45:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78481C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 12:45:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s18so1475857pgl.12
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 12:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=a3QkM3UUL+vBdQNPCcBKA3SfHuRvCGtFzWmVOQVs51k=;
        b=DFfygW8pZzvNCsGPTZCmYcwyXznVwfUmKcnJDyikkD+o4Hg66kVsScSTzi+DkE6mtl
         jBAQw5lPxfUwW8aCMvviqCplYlGAxYgVH1sLJED1FwO6HttXikU2+7TaW22my8FkQLDS
         A3QykF8aR/PVpApz6L19ST3xg1Y45UX4ysd7e7TAI7/6vnmVa1wr1nILft4DxV66umfV
         /eE6Y8b0FBYj1kwLtOwcaMZWuggRmYaBuljzyWP6yY8gleTIIlQ/h9N8des+VhAy2ZR1
         poxbQ7bC+lXL+KANNwtg533+y5AP2pUm1FFRnxxGSgscbIY5jM5WBh6ypoX1bD9UKovq
         hw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=a3QkM3UUL+vBdQNPCcBKA3SfHuRvCGtFzWmVOQVs51k=;
        b=ZJrlVzVAO1rplAyAzVUqMrX7ayce28S3sEUb3kvTVQco2O+MDLv5Oj08kJshtR7bCU
         XzWfZCzNUbka/mjwOMy7VgdIVp9XeSNwEbiSoMMZbeyCi6kv+s/P6HMaIcIYZvk5rFIv
         cg0TCGoVrfpSzoYwsskvjZP1PjExCGgJhu7cgNbZZJ5Y33BDkjkJFN7Uu2kTEHUAJHTg
         V7ZzZHNMM/uxkuoQvRUNJ9DH9zNYEm3mslWUU3h2TJuScrI7CSpfnjwU/Q5GG9Xzr3OB
         9fCC+eRBqG4usiOw5/5T/wGvYulM9rJHVnd//bscpVuptJ4u1Cz3Khps1r4oMyfv5qzt
         HWSQ==
X-Gm-Message-State: AGi0PuYqYxY0LdUhndQsQn3clIaN1LSn7WyIerbjvPcQL0E5g5XqKY0k
        PEMt6VuF5H7AE6vFDocWMdQ=
X-Google-Smtp-Source: APiQypLSmruLVlnkenOsE8uvRwRL2Pb3OP/teTG+4GvvBNQxsaILXyDFBNUeYbf/1im4a16xOath2g==
X-Received: by 2002:a63:5907:: with SMTP id n7mr4065529pgb.439.1588707927797;
        Tue, 05 May 2020 12:45:27 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:1cf4:7516:9122:5276? ([2601:647:4700:9b2:1cf4:7516:9122:5276])
        by smtp.gmail.com with ESMTPSA id b8sm2653058pft.11.2020.05.05.12.45.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 12:45:26 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery during
 HLT
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <4d62be2d-ce60-e9f6-abcf-3c69b3e59d21@redhat.com>
Date:   Tue, 5 May 2020 12:45:25 -0700
Cc:     kvm <kvm@vger.kernel.org>, Cathy Avery <cavery@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <80E7D011-D86A-4125-B495-6878B829F4BC@gmail.com>
References: <20200505160512.22845-1-pbonzini@redhat.com>
 <EE739374-65DD-4DA0-85F4-DC060E8C22E4@gmail.com>
 <4d62be2d-ce60-e9f6-abcf-3c69b3e59d21@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 5, 2020, at 9:48 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 05/05/20 18:16, Nadav Amit wrote:
>>> On May 5, 2020, at 9:05 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> From: Cathy Avery <cavery@redhat.com>
>>=20
>> Paolo,
>>=20
>> Not related directly to this patch: can you please push from time to =
time
>> the kvm-unit-tests? You tend to forget=E2=80=A6
>=20
> Done - it's usually not forgetting, rather not having enough =
confidence
> in the tests I've done to the changes, or in the corresponding KVM
> changes.  But sometimes I do just forget. :)

Thank you. I did not mean to offend in any way. I just wanted to check =
no
new bare-metal bugs were introduced. Apparently, everything is ok on =
that
front. :)

