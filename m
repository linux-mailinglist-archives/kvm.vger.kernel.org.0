Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9EA305C86
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313758AbhAZWpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391588AbhAZSKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 13:10:49 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FADCC061573
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:10:09 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 30so11951353pgr.6
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=9qXjNZouu+T2bptO4V2q/fEYj1NRhCbZOJSzY37VnAM=;
        b=kxAv0xKVGG7BwnWPjOQDwlrxfGCTuOtEvgV365hIsKf5iiADFSVyEhvSGIvKkoMLm5
         GDybLvjtHpDbuPduKHzEf+JyVancUCfRvTXgfF9QES6GhG6l+VXi75cfwnWQB4zZUqoL
         jwMAuAqRnbhLXuH1CzwE+uFP0hl9ikaC5h10PPCWzziLnmQ2i71NlILSUb+3v1EYoE29
         fVwnfLMS8launbZjAvVagJoeHiYpatzCKOsb7ahueSeiWX0VtdZdQ7/3A3cuiF6Xx/F5
         yRLgUCL7LOlOkdIj0cMBKDyl0wdkNsrlS5C3zzZ6v+MNZxBw6Q1LnPImv67phZGG3nWS
         lPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=9qXjNZouu+T2bptO4V2q/fEYj1NRhCbZOJSzY37VnAM=;
        b=dnFSVzFZUaSq9sxj+Vbl/ROMYDqB4n6kSg/+qsSSJpn6DQee6Y8AkDeZOyF+hIw543
         IDDkcGH5g1JhclvqeAN+BldAk1cRkJWom4rsdZfjyAq/VTLSnCe3pDQ11WXHWYeci11h
         Mxdrivt2osxPJM3T3HthRFUloYwzdLEQ+6iEiPpTHgUmmBbCnxOBIhqcwpuIycWZ4D6j
         RdmZuL/TLb8TsdQBWsmWApvNQ3HjlyVcWmsuCzkoAtq0yYjGsSNbMDTbnw86nmTQCIQc
         NDxFAp1IlxkMSw+SrHSVjRF1eqJD7ng+9qCgoDX/ICgbYJu5lx1Nt+DvL/++7jgWQZCM
         K3Ng==
X-Gm-Message-State: AOAM532rsGzVTAn89CdSofWWb56BoMMwHBR4dIHjGQHaMcnZ626KemjJ
        f/3zMRwtPPkjioa13ORGAK/Bew==
X-Google-Smtp-Source: ABdhPJw+Pyn/Lj1faj/rBJ50SuyQjLi9aPa/q0qBCO5rOApwmQkuP5S9N1Di3OSJZYoyx3kR9F+YDA==
X-Received: by 2002:a63:d42:: with SMTP id 2mr7048995pgn.236.1611684608859;
        Tue, 26 Jan 2021 10:10:08 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:4034:b7d6:a311:ffcc? ([2601:646:c200:1ef2:4034:b7d6:a311:ffcc])
        by smtp.gmail.com with ESMTPSA id p64sm19433188pfb.201.2021.01.26.10.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:10:07 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Tue, 26 Jan 2021 10:10:06 -0800
Message-Id: <7379D257-B504-4142-9FA3-F83DE5ABAEB4@amacapital.net>
References: <24778167-cbd4-1dc5-5b81-e8a49266d1f8@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
In-Reply-To: <24778167-cbd4-1dc5-5b81-e8a49266d1f8@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 26, 2021, at 9:03 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> =EF=BB=BFOn 1/26/21 1:31 AM, Kai Huang wrote:
>> Modify sgx_init() to always try to initialize the virtual EPC driver,
>> even if the bare-metal SGX driver is disabled.  The bare-metal driver
>> might be disabled if SGX Launch Control is in locked mode, or not
>> supported in the hardware at all.  This allows (non-Linux) guests that
>> support non-LC configurations to use SGX.
>=20
> One thing worth calling out *somewhere* (which is entirely my fault):
> "bare-metal" in the context of this patch set refers to true bare-metal,
> but *ALSO* covers the plain SGX driver running inside a guest.
>=20
> So, perhaps "bare-metal" isn't the best term to use.  Again, my bad.
> Better nomenclature suggestions are welcome.


How about just SGX?  We can have an SGX driver and a virtual EPC driver.=
