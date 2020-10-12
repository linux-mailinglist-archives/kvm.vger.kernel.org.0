Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405F828BFC1
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbgJLSbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387669AbgJLSbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:31:25 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF74C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:31:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so9070377pll.11
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZcMTMynEPIOH3c2ch38zU1fqI4EnSpaHA3AjU3AE5LE=;
        b=uTz7zIG+m/7QnmfbI+/bmDL7bU1e2gTbDSNkmu5a9RuAfh6OX+6wDv0DUhsUD4xoM/
         JjkU+jbvRtksQzU6THxbqlSYt55KvjsoVjKmbytTRFJaVgwEe2A2Ex6Tmzdr0So1XPbk
         a/PQf85bXr43WIqv0tO6ZATS4erXfYjgNZz/BbM72JOLbnVU8wRhN96RUwrdkDyE9kUE
         FlhQdGOShPX7YVvyIfKlNnV/usHsoVLNfLdorEyCa5vMocb51mCDAOsluhh7iKeywuuH
         GAXKHya+1iaMPi2IUiWB3ZcDlmvABKThoxOCTDHH5qSqBOnzaAoQOIkGFyb28HeaOkTv
         hkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZcMTMynEPIOH3c2ch38zU1fqI4EnSpaHA3AjU3AE5LE=;
        b=krL6OcEwd0nxGLYh2rB/FwZ5yJ8GQRE2VAJFrQb4rvxZmJJE4LqEb9rstXMXTYPvWp
         KFwZeYUSrlAB/6AZ1hJhdViZaQOHNfSZnFzWJGgaslM/9utVbQ+jIId+5lPLJng/9Y9S
         hkks3OmPzpY/bJQ6oJogColw73UcQGPruNM4uXS3BRIrcjqeipRQ4Qp/ZY/rpq8VLICy
         7zp7UnLFohBBfTZe3aeR8kO1ketQmHk0VnKEiZg99fJOb5ydDx5FJFADpL4zHFKovm3N
         fVAfhFUaACQ43orHMpqn7Shb1GM8Dq1/BeQlE8FmsZEs+/J+7i3a8OkHzrgNbZn0QUvb
         w8Qg==
X-Gm-Message-State: AOAM533N2Za6rgErgyzvqUbetqT9Fi2Q+DEkR0ZD2bKzTRp+ZPic5hFv
        WOYGVO+0apBNPSiuIMSZWcY=
X-Google-Smtp-Source: ABdhPJzDu13oE+P1K9sd9BLnAwr/3JbfLBIGLGU1gAUJQpjS+vrSH3DPgxeo5UCfoZQLz8BVybdzdA==
X-Received: by 2002:a17:902:9008:b029:d3:b4d2:9a2 with SMTP id a8-20020a1709029008b02900d3b4d209a2mr24401153plp.15.1602527484526;
        Mon, 12 Oct 2020 11:31:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:8cd7:a47f:78d6:7975? ([2601:647:4700:9b2:8cd7:a47f:78d6:7975])
        by smtp.gmail.com with ESMTPSA id x12sm21657191pfr.156.2020.10.12.11.31.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 11:31:23 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
Date:   Mon, 12 Oct 2020 11:31:22 -0700
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <354EB465-6F61-4AED-89B1-AB49A984A8A1@gmail.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com>
 <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
 <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com>
 <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 12, 2020, at 11:29 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 12/10/20 20:17, Nadav Amit wrote:
>>> KVM clearly doesn't adhere to the architectural specification. I =
don't
>>> know what is wrong with your Broadwell machine.
>> Are you saying that the test is expected to fail on KVM? And that =
Sean=E2=80=99s
>> failures are expected?
>=20
> It's not expected to fail, but it's apparently broken.

Hm=E2=80=A6 Based on my results on bare-metal, it might be an =
architectural issue or
a test issue, and not a KVM issue.

