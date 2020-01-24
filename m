Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00711491A5
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 00:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgAXXNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 18:13:51 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44196 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgAXXNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 18:13:51 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so1872180pgl.11
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 15:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Dfg0/boBAQFvkeehLpElmfimf033PvO4iSo4QXoxHg4=;
        b=My4/aFYnUzlc6gwer7RI4Pxtk3U35mG5XYzaugWJ9DfTBQLxDA1N/sRhflPuTALvLy
         8V6E+Al3NBolZOU6uwIvj8XytwFiXOec1mODNQenmgfFJ6teL/d+gXTqXu5qSHxqZgO9
         fQtYPVnzDvX66bjMz2Eoo3hKml0s7it6PARXdFjiMDTgu6h8zK5xKdkBPZoWdH9ZcyWJ
         FXf0bewTClMpbeokFF8H68NYsgWOmB1EWzbrmN9hU917kbPeSg/WbFXskytHvpfJADH0
         yUiadn+jlAJjQJ8wKlV3a2ugwjckU+qhstBQLXupoxTcJImwASd8dqAgI5LKr+KevheI
         nDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Dfg0/boBAQFvkeehLpElmfimf033PvO4iSo4QXoxHg4=;
        b=qFBt3Nam8U7H3242+oUk/i9vLomYMoXMRk72+QCDRy6ChNOQKM/FxWmmhzofFaL7iJ
         jvGwcRgjuqk4nLjI1LHI+2UGkM1oLyxnXNx3H6mNW4xJ21hHlazGeuZMj60sxCZSASmx
         HmMR02f41GuVWwpCowgZrCDKNHHKUv8xlr7GD+ELK5v4vHJUiNvHtzlfV/MWuMOM9UtL
         GKxRzwkV9znChLGEbFscI20FTLMmD5Lrpo4L32wZ/ScsRNLbk+BLvsdkueo4vuOBQxV1
         Sx3RIwUChNk28NDtZOXavqQRBoNrXU5b+qZVck0Q6jQobH+qv0TsrEMCR74wDEqkVGyF
         wkVw==
X-Gm-Message-State: APjAAAWlrLxayzdyE17oF6MnqyuD71jRmOTlCHIE6SXn/wWgdMGLUcM4
        nQGMJcsf8HWKTOa7EaL6fow=
X-Google-Smtp-Source: APXvYqxOlF9LnKdCORsOMzAoo1TRTvEEBmiCyxjiem9LMyprqpC26FyXv0VYj+lQGTfNUTmjVOMSRA==
X-Received: by 2002:aa7:96b0:: with SMTP id g16mr5217198pfk.99.1579907630109;
        Fri, 24 Jan 2020 15:13:50 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id z30sm7795858pfq.154.2020.01.24.15.13.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jan 2020 15:13:49 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20191202204356.250357-1-aaronlewis@google.com>
Date:   Fri, 24 Jan 2020 15:13:44 -0800
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> =
wrote:
>=20
> Verify that the difference between a guest RDTSC instruction and the
> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> MSR-store list is less than 750 cycles, 99.9% of the time.
>=20
> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observable =
L2 TSC=E2=80=9D)
>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Running this test on bare-metal I get:

  Test suite: rdtsc_vmexit_diff_test
  FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations

Any idea why? Should I just play with the 750 cycles magic number?

