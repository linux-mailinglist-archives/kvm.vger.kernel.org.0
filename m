Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BC82DD97A
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgLQTlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 14:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgLQTlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 14:41:49 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9898C0617B0
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 11:41:08 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2so24519pfq.5
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 11:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oGlSDWZ94ObciHMURxpfYsKRlLh9/i8WxGRFy/xIrb0=;
        b=oB46SiCaFqCblph5KLvrwi7hpFg40Vbut4PbBEne8/8q2UNMZ5MW7RZwz2tcNQYv/6
         e1JFBr66qroaAwyidhyMLtGEUzth9BIoyCI4RfOtgEb7Vv4cXJLgwK7fw4U3JGaBIP7k
         AN34rY+fpgxZif7vyJfefzZIPSmURVMCXOXcSR8MM00WWtF0n1bLbuF82ccHNIgp3Mo7
         0e1AB5EazNiCyMjYHFskvmbxDisL/NgFLYWMoX9FW6GxVFsaaY2aGdBLzgeqfrBiPShS
         fUuUKsNLNdztwNPsqF0+xLl+vH5g3oL2Bh3yRtMPGUKO85pDnLdRhB8L+AuZy5JpDScr
         fsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oGlSDWZ94ObciHMURxpfYsKRlLh9/i8WxGRFy/xIrb0=;
        b=C44DJXPXy+OgZeFfLM2lww3GoCW0aW+g5TWt145+RDVvTwrYWWAzd817s8bjDCSpbI
         THskF7REuoi7ntFb4598tLxbd7BxhEIeTI5ZJfd2O+FsqDXi5UOaDXeMV/L/g+K1yu9b
         X+3PmraqT4VrViD7ER9sYrgHC9ZVygNlxnq18/O6MrEEtGp3EE+3iM7xW9JAg3RuzUaC
         X3z7MGilC6MH7/Ry7Zzp4KrMzn9EphurVqlW0QwXZvPs7yupTbFmdAB8eq34Z45TxpWL
         iu0BQpCYZ/rPA02BSNs0jsrVGxvipPKFPxzXGkjctFEjHFs4aVfxX4jdBsK6wrGGIvP1
         HQPQ==
X-Gm-Message-State: AOAM5336l30OsdcgV1QDArrYKf3ZLRMR4dTz4L2y4Fsxwx4KgwTd4cgk
        IlMXcoOqSoIuISEUF/rOWyk=
X-Google-Smtp-Source: ABdhPJxCp/CVB6WaO/xFBgvaSDDcvNtoe3mt1JB/7FUkKAnrnPGvFiEPiJuB/D62u78YefM59QlliQ==
X-Received: by 2002:a65:4544:: with SMTP id x4mr789999pgr.183.1608234068280;
        Thu, 17 Dec 2020 11:41:08 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:18dc:435f:36d7:18c9? ([2601:647:4700:9b2:18dc:435f:36d7:18c9])
        by smtp.gmail.com with ESMTPSA id b22sm6569963pfo.163.2020.12.17.11.41.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Dec 2020 11:41:07 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page
 allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
Date:   Thu, 17 Dec 2020 11:41:05 -0800
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A03C81A-BE59-4C1F-8056-94364C79933B@gmail.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 16, 2020, at 12:11 PM, Claudio Imbrenda =
<imbrenda@linux.ibm.com> wrote:
>=20
> My previous patchseries was rushed and not polished enough. =
Furthermore it
> introduced some regressions.
>=20
> This patchseries fixes hopefully all the issues reported, and =
introduces
> some new features.
>=20
> It also simplifies the code and hopefully makes it more readable.
>=20
> Fixed:
> * allocated memory is now zeroed by default

Thanks for doing that. Before I test it, did you also fix the issue of =
x86=E2=80=99s
setup_vm() [1]?

[1] https://www.spinics.net/lists/kvm/msg230470.html

