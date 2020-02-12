Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC911159FA4
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 04:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBLDsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 22:48:17 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35958 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgBLDsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 22:48:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id d9so482372pgu.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 19:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=6n20LY7Gbk1vIJ9y2Ek0mCSqczMDBuYCkKoruXym20c=;
        b=qOIuXMr7r5BjTTN+iUHHZHwXO2d7fltI4qfqf6tbvQdh49e6cPRYEmcbGwuGAudwb8
         w30L9oHSj79cz2PbPcfqcB0XK5ilmwynVKV5aJeHITXsOfGQ2xUe9v8aFSP2LLudhaqZ
         5EuvCyJJGJ3MGeULZocj6JU8fEJyVtrln/UygU9d8PPqtZxL46O0XGUSRS+39CSaFCaR
         PhuepTAcAYHA+JKjnq+oXEayOFQCah3uurRAwCjTvqdoLYAUh8wSQQCctFOTihvo8swD
         tQpwBaUvnbY54Av/9UrQQY8UAW1JwMUpiJdvP7Al5IAKyacPUWPBhZ8RkUJSh68erc9A
         ehOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=6n20LY7Gbk1vIJ9y2Ek0mCSqczMDBuYCkKoruXym20c=;
        b=pEweNcIuV31Nec3pIbIXLGSN/kebFd8Wlhjm6I8dTXB3xP0vUMB0utROQbRdvR8Q4Q
         l1zRZGSD7MGwEPuXcI8S5HI/2jiPJIK7m3OsA1vOB85rrrOImYKVcrLG+Omor1c6QuS/
         GlAFTnPtQ6q4ap8divVDjQ0epbe7QpUrPvM+EeqN/SZwNahpTwoEJG1Ex2ylAv34c0hP
         TKGnOV85Cc23ylozIqvEGEge0f7TOGBZM9kvHnWrEuQOrEmcSPBAi/0MnPx8jdxSKad7
         zXA+ZInQYzmDghY8JUSkpDgpWAWmzl4tteyj7giNB8vnGjKJKMz8Bs6hzQpFVz/7zdXf
         1Jmw==
X-Gm-Message-State: APjAAAUggifx9qV1S/WiCyjMTrXX+sLD/UzDiMKlHKa4XwGl+ijtY2b0
        kHRXCOVGyxRaYo5vaCNwMiPlDQ==
X-Google-Smtp-Source: APXvYqwHXdDGCoJF29xdQdH8f5hJD2lx/3SlqjjMPooqFIPhLc6mldJbeBq8PCoMMtLk5e0pp0EI6A==
X-Received: by 2002:a63:f20a:: with SMTP id v10mr10098705pgh.420.1581479295020;
        Tue, 11 Feb 2020 19:48:15 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:d1cf:7a62:c997:6a4b? ([2601:646:c200:1ef2:d1cf:7a62:c997:6a4b])
        by smtp.gmail.com with ESMTPSA id 72sm6294836pfw.7.2020.02.11.19.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 19:48:14 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Date:   Tue, 11 Feb 2020 19:48:12 -0800
Message-Id: <BD48E405-8E3F-4EEE-A72A-8A7EDCB6A376@amacapital.net>
References: <20200211135256.24617-1-joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 11, 2020, at 5:53 AM, Joerg Roedel <joro@8bytes.org> wrote:

>=20
>=20
>    * Putting some NMI-load on the guest will make it crash usually
>      within a minute

Suppose you do CPUID or some MMIO and get #VC. You fill in the GHCB to ask f=
or help. Some time between when you start filling it out and when you do VMG=
EXIT, you get NMI. If the NMI does
its own GHCB access [0], it will clobber the outer #VC=E2=80=99a state, resu=
lting in a failure when VMGEXIT happens. There=E2=80=99s a related failure m=
ode if the NMI is after the VMGEXIT but before the result is read.

I suspect you can fix this by saving the GHCB at the beginning of do_nmi and=
 restoring it at the end. This has the major caveat that it will not work if=
 do_nmi comes from user mode and schedules, but I don=E2=80=99t believe this=
 can happen.

[0] Due to the NMI_COMPLETE catastrophe, there is a 100% chance that this ha=
ppens.=
