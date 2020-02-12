Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4615AD3A
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgBLQWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:22:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46409 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLQWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:22:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id k29so1459865pfp.13
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=UtBs909g2Ug5B/GmWLl9syqH2ckGGAYGctQB3xVEPLk=;
        b=V0nJ4J4nOpEq7kQ1dqdvmNnRxG670BfZwH5PqrHNkdmszKt+Nuf5IkDfEPLa6hHtjy
         oQ/5HvIyGCUiyO+DKLpmEhjIaRtaMGsX4Ho4j+g5PEHbDGEU4EJj2lBNBfX3LEUu9h39
         U7haCGvFvvtAEpjYU7/qWar6H5YvcL/BQUp2/+6JPuTRlsj3hgsVKRDQdiJerCImp4VP
         9O/2vHiw/xH7JQHP6NWurerQCjwskocQQpbyiomB2Q4aqgBGsB4wCYS4fgUtTV5EJVqO
         a9lsRy8l7mxCuMF2IuG8tVVKQVL4K7Y4LzMZWYykNg9SJMfePai7QvvlNM7P3AxhiqI8
         2brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=UtBs909g2Ug5B/GmWLl9syqH2ckGGAYGctQB3xVEPLk=;
        b=C/057sM1OguoYifTlQRPicMSTEfoQmri63WOeHkpd4TuMD3yF8YOY4YkorESyThZWF
         ovWuk093Ko421pjtClTs6ux9KXIruyRIlVqJ0HDvu/LG8OT1sr2lDEOqB/sbM7OHuzau
         b9Jj0ZmjyTGHM+ia+SPnqwBrN7a7uu42NxTS2l1PDrt+SCXcvMAL4eRbSgKTUv/sJm2W
         1XT4QpNnuqZAB27y/Cz4VkmK4yznHlUeeW7qGE2vtnilCl1el1LOr6mZfcIR4/3Jezqo
         YX2M5FWkS8iu2D4FI88QDu3j1Va0DcD+jyKwPUqGTvaK1wwMu3gIG1VDWL/5S8tVQLJM
         v/pA==
X-Gm-Message-State: APjAAAWvTNYYPYhNLOpWVPKeUa5V0rHq+i0ZgzX57PMu7zD0yc+JvCHm
        j7QEpbTlxsiujW/D6R3ikrzHfw==
X-Google-Smtp-Source: APXvYqyksnxVfiGQnmL2dJDTJhvH3Jj2OjnrG6wn2hFFnBKljhf5Nl9AB7BmudDVKXJXj5Ka8PadqA==
X-Received: by 2002:aa7:86c2:: with SMTP id h2mr9202566pfo.45.1581524537390;
        Wed, 12 Feb 2020 08:22:17 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:6918:d286:95c1:bba2? ([2601:646:c200:1ef2:6918:d286:95c1:bba2])
        by smtp.gmail.com with ESMTPSA id z19sm1429801pfn.49.2020.02.12.08.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 08:22:16 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 14/62] x86/boot/compressed/64: Add stage1 #VC handler
Date:   Wed, 12 Feb 2020 08:22:14 -0800
Message-Id: <A67CC291-C07A-496C-BD67-2A795813E93F@amacapital.net>
References: <20200212113840.GB20066@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
In-Reply-To: <20200212113840.GB20066@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 12, 2020, at 3:38 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> =EF=BB=BFOn Tue, Feb 11, 2020 at 02:23:22PM -0800, Andy Lutomirski wrote:
>>> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>>> +void __init no_ghcb_vc_handler(struct pt_regs *regs)
>>=20
>> Isn't there a second parameter: unsigned long error_code?
>=20
> No, the function gets the error-code from regs->orig_ax. This particular
> function only needs to check for error_code =3D=3D SVM_EXIT_CPUID, as that=

> is the only one supported when there is no GHCB.
>=20

Hmm. It might be nice to use the same signature for early handlers as for no=
rmal ones.

> Regards,
>=20
>    Joerg
