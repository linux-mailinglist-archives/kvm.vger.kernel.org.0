Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079E83649A4
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbhDSSLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhDSSLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 14:11:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D035AC061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:10:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso13847453pjg.2
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=eEKtsAAow5Dnwj5Ukh0H9erKggNyhtm8xWDkEDWhElY=;
        b=SdOkjGAwQmWRjRZoqn33rspfHFqBAlsFUlx7jXY9qj+P859E3WXad4U/JMoOr82OC+
         mqJJ2QKinkJnOfHSXafhEEzmiHU3RncqAfGZesTY6Lu8H2FOhTzLo5YkPPqXFpOK/dZ0
         /qvpIiBHskG1Ba1iL4oNh0N7htrhblTJfLxj7xB2n/lS2qG0hIywrUTePoxCvHyeVAF4
         4XfmApwJJIdIgqC8+MnGivBrzBPk2iPzrD51LZHgO/nvKbBRq71ICw11PassQjKUwr4h
         Q5x3H2oAqfopZWRtrF0ENtXyQA+SZzZB8lvTcTQJu0b4FG2TP5I/eAox+yUeBD7gzdNQ
         MR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=eEKtsAAow5Dnwj5Ukh0H9erKggNyhtm8xWDkEDWhElY=;
        b=CLKUvigf4q7T1WrJJTjE9HcGKxljTAe9ZB1yT1TxqIQP4AnxVAdhRxtCNdJ7ObM57M
         Up1GYtI8foFhce9a/kJFNYjvxv+0kB3OWdboFPZN2Z6g38Gs5wfVgErguk+EOme+ICOL
         wqqCsQtKaB/xptmcOLGpvd2MGmjwoEAJjla3yZngE6tYFTEl6rR4wwLtu1UJDda5XGna
         lIXHPDBs/jHEUNmW/DQcln1UcYnawlyws4D3ITpPFRcSrTg768cwJriH8NGLOJ+MICUP
         sldAQylBj0pjkS749pn8HiJkAbhoVjJDMYLUR38HrvroQLv8386I1mL/V/fwHY5OI5sD
         mTfQ==
X-Gm-Message-State: AOAM531mGyycv4N8eq60xBVe6pFrILhp3aMjFxSO0am8IZlusinlW9RX
        YTJU3pJwt9xbGr7GdJG5WfIXDg==
X-Google-Smtp-Source: ABdhPJyuuLTOxSEyrf0O3oIfrBzyzcPIoO5zpHckWL/YdOK4Mxpjub3FNem2Opzxm/+mtxyS5BTCuQ==
X-Received: by 2002:a17:902:6907:b029:ea:d1e8:b80b with SMTP id j7-20020a1709026907b02900ead1e8b80bmr24524259plk.41.1618855847387;
        Mon, 19 Apr 2021 11:10:47 -0700 (PDT)
Received: from ?IPv6:2600:1010:b018:f7a3:b93c:afa3:79ad:4736? ([2600:1010:b018:f7a3:b93c:afa3:79ad:4736])
        by smtp.gmail.com with ESMTPSA id x12sm13302587pfu.193.2021.04.19.11.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 11:10:46 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding the page in RMP table
Date:   Mon, 19 Apr 2021 11:10:45 -0700
Message-Id: <B17112AE-8848-48B0-997D-E1A3D79BD395@amacapital.net>
References: <61596c4c-3849-99d5-b0aa-6ad6b415dff9@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <61596c4c-3849-99d5-b0aa-6ad6b415dff9@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: iPhone Mail (18D70)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 19, 2021, at 10:58 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> =EF=BB=BFOn 4/19/21 10:46 AM, Brijesh Singh wrote:
>> - guest wants to make gpa 0x1000 as a shared page. To support this, we
>> need to psmash the large RMP entry into 512 4K entries. The psmash
>> instruction breaks the large RMP entry into 512 4K entries without
>> affecting the previous validation. Now the we need to force the host to
>> use the 4K page level instead of the 2MB.
>>=20
>> To my understanding, Linux kernel fault handler does not build the page
>> tables on demand for the kernel addresses. All kernel addresses are
>> pre-mapped on the boot. Currently, I am proactively spitting the physmap
>> to avoid running into situation where x86 page level is greater than the
>> RMP page level.
>=20
> In other words, if the host maps guest memory with 2M mappings, the
> guest can induce page faults in the host.  The only way the host can
> avoid this is to map everything with 4k mappings.
>=20
> If the host does not avoid this, it could end up in the situation where
> it gets page faults on access to kernel data structures.  Imagine if a
> kernel stack page ended up in the same 2M mapping as a guest page.  I
> *think* the next write to the kernel stack would end up double-faulting.

I=E2=80=99m confused by this scenario. This should only affect physical page=
s that are in the 2M area that contains guest memory. But, if we have a 2M d=
irect map PMD entry that contains kernel data and guest private memory, we=E2=
=80=99re already in a situation in which the kernel touching that memory wou=
ld machine check, right?

ISTM we should fully unmap any guest private page from the kernel and all ho=
st user pagetables before actually making it be a guest private page.=
